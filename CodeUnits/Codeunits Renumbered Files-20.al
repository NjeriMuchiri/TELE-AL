OBJECT CodeUnit 20384 Budgetary Control
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 5:42:44 PM];
    Modified=Yes;
    Version List=FUNDS;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      BCSetup@1102755000 : Record 51516051;
      DimMgt@1102755001 : Codeunit 408;
      ShortcutDimCode@1102755002 : ARRAY [8] OF Code[20];
      BudgetGL@1102755003 : Code[20];
      Text0001@1102755005 : TextConst 'ENU="You Have exceeded the Budget by "';
      Text0002@1102755004 : TextConst 'ENU=" Do you want to Continue?"';
      Text0003@1102755006 : TextConst 'ENU=There is no Budget to Check against do you wish to continue?';
      GlBudgetControlled@1102755007 : Record 15;

    PROCEDURE CheckPurchase@1102755000(VAR PurchHeader@1102755000 : Record 38);
    VAR
      PurchLine@1102755013 : Record 39;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN
      //First Update Analysis View
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (PurchHeader."Document Date">BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");
          //Get Commitment Lines
               IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No";

          //get the lines related to the payment header
            PurchLine.RESET;
            PurchLine.SETRANGE(PurchLine."Document Type",PurchHeader."Document Type");
            PurchLine.SETRANGE(PurchLine."Document No.",PurchHeader."No.");
            IF PurchLine.FINDFIRST THEN
              BEGIN
                REPEAT
              {
               //Get the Dimension Here
                 IF PurchLine."Line No." <> 0 THEN
                      DimMgt.ShowDocDim(
                        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",
                        PurchLine."Line No.",ShortcutDimCode)
                    ELSE
                      DimMgt.ClearDimSetFilter(ShortcutDimCode);
                  }
                //Had to be put here for the sake of Calculating Individual Line Entries

                  //check the type of account in the payments line
                  //Item
                    IF PurchLine.Type=PurchLine.Type::Item THEN BEGIN
                        Item.RESET;
                        IF NOT Item.GET(PurchLine."No.") THEN
                           ERROR('Item Does not Exist');

                        Item.TESTFIELD("Item G/L Budget Account");
                        BudgetGL:=Item."Item G/L Budget Account";
                     END;

                     IF PurchLine.Type=PurchLine.Type::"Fixed Asset" THEN BEGIN
                             FixedAssetsDet.RESET;
                             FixedAssetsDet.SETRANGE(FixedAssetsDet."No.",PurchLine."No.");
                               IF FixedAssetsDet.FIND('-') THEN BEGIN
                                   FAPostingGRP.RESET;
                                   FAPostingGRP.SETRANGE(FAPostingGRP.Code,FixedAssetsDet."FA Posting Group");
                                   IF FAPostingGRP.FIND('-') THEN
                                     IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::Maintenance THEN
                                      BEGIN
                                         BudgetGL:=FAPostingGRP."Maintenance Expense Account";
                                           IF BudgetGL ='' THEN
                                             ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account',PurchLine."No.");
                                     END ELSE BEGIN
                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                         BudgetGL:=FAPostingGRP."Acquisition Cost Account";
                                            IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account',PurchLine."No.");
                                       END;
                                       //To Accomodate any Additional Item under Custom 1 and Custom 2
                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"3" THEN BEGIN
                                         BudgetGL:=FAPostingGRP."Custom 2 Account";
                                            IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
                                               FAPostingGRP."Custom 1 Account");
                                       END;

                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"4" THEN BEGIN
                                         BudgetGL:=FAPostingGRP."Custom 2 Account";
                                            IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
                                               FAPostingGRP."Custom 1 Account");
                                       END;
                                       //To Accomodate any Additional Item under Custom 1 and Custom 2

                                      END;
                               END;
                     END;

                     IF PurchLine.Type=PurchLine.Type::"G/L Account" THEN BEGIN
                        BudgetGL:=PurchLine."No.";
                        IF GLAcc.GET(PurchLine."No.") THEN
                           GLAcc.TESTFIELD("Budget Controlled",TRUE);
                     END;

                  //End Checking Account in Payment Line

                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(PurchHeader."Document Date",2),DATE2DMY(PurchHeader."Document Date",3));
                             CurrMonth:=DATE2DMY(PurchHeader."Document Date",2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(PurchHeader."Document Date",3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PurchHeader."Document Date",3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;
                              //MESSAGE('LastDay %1',LastDay);//maureen
                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             //Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             //Budget.SETRANGE(Budget."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                             //Budget.SETRANGE(Budget."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                            // Budget.SETRANGE(Budget."Dimension 3 Value Code",ShortcutDimCode[3]);
                            // Budget.SETRANGE(Budget."Dimension 4 Value Code",ShortcutDimCode[4]);
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;
                              //MESSAGE('LastDay %1, %2,%3',BudgetAmount,BudgetGL,BCSetup."Current Budget Code");//maureen

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                         // Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                         // Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;
                             // MESSAGE('LastDay %1',ActualsAmount);//maureen

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                         //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                         // Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;
                              //MESSAGE('LastDay %1',CommitmentAmount);//maureen

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount)
                         AND NOT (BCSetup."Allow OverExpenditure") THEN
                          BEGIN
                            ERROR('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                            PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                          END ELSE BEGIN
                              //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;
                              //END ADDING CONFIRMATION
                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=PurchHeader."Document Date";
                              IF PurchHeader.DocApprovalType=PurchHeader.DocApprovalType::Purchase THEN
                                  Commitments."Document Type":=Commitments."Document Type"::LPO
                              ELSE
                                  Commitments."Document Type":=Commitments."Document Type"::Requisition;

                              IF PurchHeader."Document Type"=PurchHeader."Document Type"::Invoice THEN
                                  Commitments."Document Type":=Commitments."Document Type"::PurchInvoice;

                              Commitments."Document No.":=PurchHeader."No.";
                              Commitments.Amount:=PurchLine."Outstanding Amount (LCY)";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=PurchHeader."Document Date";
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
                              //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                             // Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                             // Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                             // Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                              //Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=Commitments.Type::Vendor;
                              Commitments."Vendor/Cust No.":=PurchHeader."Buy-from Vendor No.";
                              Commitments.INSERT;
                              //Tag the Purchase Line as Committed
                                PurchLine.Committed:=TRUE;
                                PurchLine.MODIFY;
                              //End Tagging PurchLines as Committed
                          END;
                UNTIL PurchLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
    END;

    PROCEDURE CheckPayments@1102755001(VAR PaymentHeader@1102755000 : Record 51516000);
    VAR
      PayLine@1102755013 : Record 51516001;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN

      //First Update Analysis View
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (PaymentHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (PaymentHeader."Document Date">BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No,PaymentHeader."No.");
            PayLine.SETRANGE(PayLine."Document Type",PayLine."Document Type"::" ");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(PaymentHeader.Date,2),DATE2DMY(PaymentHeader.Date,3));
                             CurrMonth:=DATE2DMY(PaymentHeader.Date,2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(PaymentHeader.Date,3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PaymentHeader.Date,3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             BudgetGL:=PayLine."Currency Code";
                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                            // Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            // Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            // Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                         // Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                         // Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                         // Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                          //Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."NetAmount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine.No,PayLine."Interest Amount" ,PayLine.No,
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."NetAmount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=PaymentHeader.Date;
                              IF PaymentHeader."Payment Type"=PaymentHeader."Payment Type"::Normal THEN
                               Commitments."Document Type":=Commitments."Document Type"::"Payment Voucher"
                              ELSE
                                Commitments."Document Type":=Commitments."Document Type"::PettyCash;
                              Commitments."Document No.":=PaymentHeader."No.";
                              Commitments.Amount:=PayLine."NetAmount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=PaymentHeader.Date;
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
                             // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                             // Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                            //  Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                            //  Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                             // Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.INSERT;
                              //Tag the Payment Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Payment Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');
    END;

    PROCEDURE CheckImprest@1102755002(VAR ImprestHeader@1102755000 : Record 51516006);
    VAR
      PayLine@1102755013 : Record 51516001;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN
      // //First Update Analysis View
      // UpdateAnalysisView();
      //
      // //get the budget control setup first to determine if it mandatory or not
      // BCSetup.RESET;
      // BCSetup.GET();
      // IF BCSetup.Mandatory THEN//budgetary control is mandatory
      //   BEGIN
      //     //check if the dates are within the specified range in relation to the payment header table
      //     //IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
      //       BEGIN
      //        // ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
      //        // BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //      // END
      //     //ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
      //      // BEGIN
      //       //  ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
      //        // BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //
      //       END;
      //     //Is budget Available
      //     CheckIfBlocked(BCSetup."Current Budget Code");
      //
      //     //Get Commitment Lines
      //      IF Commitments.FIND('+') THEN
      //         EntryNo:=Commitments."Line No";
      //
      //     //get the lines related to the payment header
      //       PayLine.RESET;
      //       PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
      //       PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
      //       IF PayLine.FINDFIRST THEN
      //         BEGIN
      //           REPEAT
      //                        //check the votebook now
      //                        //FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
      //                        //CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
      //                        IF CurrMonth=12 THEN
      //                         BEGIN
      //                          // LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
      //                           //LastDay:=CALCDATE('-1D',LastDay);
      //                         END
      //                        ELSE
      //                         BEGIN
      //                           CurrMonth:=CurrMonth +1;
      //                          // LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
      //                           LastDay:=CALCDATE('-1D',LastDay);
      //                         END;
      //
      //                        //The GL Account
      //                         //BudgetGL:=PayLine."Account No:";
      //
      //                        //check the summation of the budget in the database
      //                        BudgetAmount:=0;
      //                        Budget.RESET;
      //                        Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
      //                        Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
      //                        Budget."Dimension 4 Value Code");
      //                        Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
      //                        Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                        Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
      //                       // Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                            Budget.CALCSUMS(Budget.Amount);
      //                            BudgetAmount:= Budget.Amount;
      //
      //                   //get the summation on the actuals
      //                     ActualsAmount:=0;
      //                     Actuals.RESET;
      //                     Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
      //                     Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
      //                     Actuals."Posting Date",Actuals."Account No.");
      //                     Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
      //                    // Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                     Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                     Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
      //                        Actuals.CALCSUMS(Actuals.Amount);
      //                        ActualsAmount:= Actuals.Amount;
      //
      //                   //get the committments
      //                     CommitmentAmount:=0;
      //                     Commitments.RESET;
      //                     Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
      //                     Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
      //                     Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
      //                     Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
      //                     Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
      //                     Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                    // Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
      //                   //  Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
      //                    // Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
      //                     //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
      //                        Commitments.CALCSUMS(Commitments.Amount);
      //                        CommitmentAmount:= Commitments.Amount;
      //
      //                    //check if there is any budget
      //                    IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
      //                       ERROR('No Budget To Check Against');
      //                    END ELSE BEGIN
      //                     IF (BudgetAmount<=0) THEN BEGIN
      //                      IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
      //                         ERROR('Budgetary Checking Process Aborted');
      //                      END;
      //                     END;
      //                    END;
      //
      //                    //check if the actuals plus the amount is greater then the budget amount
      //                   // IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
      //                    //AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
      //
      //                       //ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
      //                     //  PayLine.No,'Staff Imprest' ,PayLine.No,
      //                       //  FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
      //                     //END ELSE BEGIN
      //                     //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
      //                         //IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
      //                             //IF NOT CONFIRM(Text0001+
      //                             //FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
      //                             //s+Text0002,TRUE) THEN BEGIN
      //                                //ERROR('Budgetary Checking Process Aborted');
      //                             //END;
      //                         //END;
      //
      //                         Commitments.RESET;
      //                         Commitments.INIT;
      //                         EntryNo+=1;
      //                        // Commitments."Line No":=EntryNo;
      //                         Commitments.Date:=TODAY;
      //                         Commitments."Posting Date":=ImprestHeader.Date;
      //                         Commitments."Document Type":=Commitments."Document Type"::Imprest;
      //                         Commitments."Document No.":=ImprestHeader."No.";
      //                         Commitments.Amount:=PayLine."Amount LCY";
      //                         Commitments."Month Budget":=BudgetAmount;
      //                         Commitments."Month Actual":=ActualsAmount;
      //                         Commitments.Committed:=TRUE;
      //                         Commitments."Committed By":=USERID;
      //                         Commitments."Committed Date":=ImprestHeader.Date;
      //                         Commitments."G/L Account No.":=BudgetGL;
      //                         Commitments."Committed Time":=TIME;
      //                         //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
      //                         //Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
      //                         //Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
      //                         //Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
      //                        // Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
      //                         Commitments.Budget:=BCSetup."Current Budget Code";
      //                         Commitments.Type:=ImprestHeader."Account Type";
      //                         Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
      //                         Commitments.INSERT;
      //                         //Tag the Imprest Line as Committed
      //                           PayLine.Committed:=TRUE;
      //                           PayLine.MODIFY;
      //                         //End Tagging Imprest Lines as Committed
      //                     END;
      //
      //           UNTIL PayLine.NEXT=0;
      //         END;
      //   END
      // ELSE//budget control not mandatory
      //   BEGIN
      //
      //   END;
      // MESSAGE('Budgetary Checking Completed Successfully');
    END;

    PROCEDURE ReverseEntries@1102755003(DocumentType@1102755000 : 'LPO,Requisition,Imprest,Payment Voucher,PettyCash';DocNo@1102755001 : Code[20]);
    VAR
      Commitments@1102755002 : Record 51516050;
      EntryNo@1102755003 : Integer;
      CommittedLines@1102755004 : Record 51516050;
    BEGIN
      //Get Commitment Lines
      Commitments.RESET;
       IF Commitments.FIND('+') THEN
          EntryNo:=Commitments."Line No";

      CommittedLines.RESET;
      CommittedLines.SETRANGE(CommittedLines."Document Type",DocumentType);
      CommittedLines.SETRANGE(CommittedLines."Document No.",DocNo);
      CommittedLines.SETRANGE(CommittedLines.Committed,TRUE);
      IF CommittedLines.FIND('-') THEN BEGIN
         REPEAT
           Commitments.RESET;
           Commitments.INIT;
           EntryNo+=1;
           Commitments."Line No":=EntryNo;
           Commitments.Date:=TODAY;
           Commitments."Posting Date":=CommittedLines."Posting Date";
           Commitments."Document Type":=CommittedLines."Document Type";
           Commitments."Document No.":=CommittedLines."Document No.";
           Commitments.Amount:=-CommittedLines.Amount;
          //Before Posting the Amount Check the Amount being passed From LPO as Qty Received
           IF DocumentType=DocumentType::LPO THEN BEGIN
            IF BCSetup.GET THEN BEGIN
      //         IF CommittedLines."Posting Date">=BCSetup."Changes in LPO Committment" THEN BEGIN
      //          // Commitments.Amount:=-GetLineAmountToReverse(DocumentType,DocNo,CommittedLines."Document Line No.");
      //         END ELSE BEGIN
      //           Commitments.Amount:=-CommittedLines.Amount;
      //         END;
            END;
           END ELSE BEGIN
           Commitments.Amount:=-CommittedLines.Amount;
           END;
           //END CHECK AMOUNT BEING POSTED FOR LPO

           Commitments."Month Budget":=CommittedLines."Month Budget";
           Commitments."Month Actual":=CommittedLines."Month Actual";
           Commitments.Committed:=FALSE;
           Commitments."Committed By":=USERID;
           Commitments."Committed Date":=CommittedLines."Committed Date";
           Commitments."G/L Account No.":=CommittedLines."G/L Account No.";
           Commitments."Committed Time":=TIME;
           //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
          // Commitments."Shortcut Dimension 1 Code":= CommittedLines."Shortcut Dimension 1 Code";
           //Commitments."Shortcut Dimension 2 Code":=CommittedLines."Shortcut Dimension 2 Code";
           //Commitments."Shortcut Dimension 3 Code":=CommittedLines."Shortcut Dimension 3 Code";
           //Commitments."Shortcut Dimension 4 Code":=CommittedLines."Shortcut Dimension 4 Code";
           Commitments.Budget:=CommittedLines.Budget;
           Commitments.INSERT;

         UNTIL CommittedLines.NEXT=0;
      END;
    END;

    PROCEDURE CheckFundsAvailability@1102755004(Payments@1102755000 : Record 51516000);
    VAR
      BankAcc@1102755001 : Record 270;
      "Current Source A/C Bal."@1102755002 : Decimal;
    BEGIN
      // //get the source account balance from the database table
      // BankAcc.RESET;
      // BankAcc.SETRANGE(BankAcc."No.",Payments."Paying Bank Account");
      // BankAcc.SETRANGE(BankAcc."Bank Type",BankAcc."Bank Type"::Cash);
      // IF BankAcc.FINDFIRST THEN
      //   BEGIN
      //     BankAcc.CALCFIELDS(BankAcc.Balance);
      //     "Current Source A/C Bal.":=BankAcc.Balance;
      //     IF ("Current Source A/C Bal."-Payments."Total Net Amount")<0 THEN
      //       BEGIN
      //         ERROR('The transaction will result in a negative balance in the BANK ACCOUNT. %1:%2',BankAcc."No.",
      //         BankAcc.Name);
      //       END;
      //   END;
    END;

    PROCEDURE UpdateAnalysisView@1102755005();
    VAR
      UpdateAnalysisView@1102755002 : Codeunit 410;
      BudgetaryControl@1102755001 : Record 51516051;
      AnalysisView@1102755000 : Record 363;
    BEGIN
      //Update Budget Lines
      // IF BudgetaryControl.GET THEN BEGIN
      //   IF BudgetaryControl."Analysis View Code"<>'' THEN BEGIN
      //    AnalysisView.RESET;
      //    AnalysisView.SETRANGE(AnalysisView.Code,BudgetaryControl."Analysis View Code");
      //    IF AnalysisView.FIND('-') THEN
      //      UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
      //   END;
      // END;
    END;

    PROCEDURE UpdateDim@6(DimCode@1000 : Code[20];DimValueCode@1001 : Code[20]);
    BEGIN
      {IF DimCode = '' THEN
        EXIT;
      WITH GLBudgetDim DO BEGIN
        IF GET(Rec."Entry No.",DimCode) THEN
          DELETE;
        IF DimValueCode <> '' THEN BEGIN
          INIT;
          "Entry No." := Rec."Entry No.";
          "Dimension Code" := DimCode;
          "Dimension Value Code" := DimValueCode;
          INSERT;
        END;
      END; }
    END;

    PROCEDURE CheckIfBlocked@1(BudgetName@1102755001 : Code[20]);
    VAR
      GLBudgetName@1102755000 : Record 95;
    BEGIN
      GLBudgetName.GET(BudgetName);
      GLBudgetName.TESTFIELD(Blocked,FALSE);
    END;

    PROCEDURE CheckStaffAdvance@1102755007(VAR ImprestHeader@1102755000 : Record 51516006);
    VAR
      PayLine@1102755013 : Record 51516001;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN
      //First Update Analysis View
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      // BCSetup.RESET;
      // BCSetup.GET();
      // IF BCSetup.Mandatory THEN//budgetary control is mandatory
      //   BEGIN
      //     //check if the dates are within the specified range in relation to the payment header table
      //     IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
      //       BEGIN
      //         ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
      //         BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //       END
      //     ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
      //       BEGIN
      //         ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
      //         BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //
      //       END;
      //     //Is budget Available
      //     CheckIfBlocked(BCSetup."Current Budget Code");
      //
      //     //Get Commitment Lines
      //      IF Commitments.FIND('+') THEN
      //         EntryNo:=Commitments."Line No.";
      //
      //     //get the lines related to the payment header
      //       PayLine.RESET;
      //       PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
      //       PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
      //       IF PayLine.FINDFIRST THEN
      //         BEGIN
      //           REPEAT
      //                        //check the votebook now
      //                        FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
      //                        CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
      //                        IF CurrMonth=12 THEN
      //                         BEGIN
      //                           LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
      //                           LastDay:=CALCDATE('-1D',LastDay);
      //                         END
      //                        ELSE
      //                         BEGIN
      //                           CurrMonth:=CurrMonth +1;
      //                           LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
      //                           LastDay:=CALCDATE('-1D',LastDay);
      //                         END;
      //
      //                        //The GL Account
      //                         BudgetGL:=PayLine."Account No:";
      //
      //                        //check the summation of the budget in the database
      //                        BudgetAmount:=0;
      //                        Budget.RESET;
      //                        Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
      //                        Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
      //                        Budget."Dimension 4 Value Code");
      //                        Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
      //                        Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                        Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
      //                        //Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                            Budget.CALCSUMS(Budget.Amount);
      //                            BudgetAmount:= Budget.Amount;
      //
      //                   //get the summation on the actuals
      //                     ActualsAmount:=0;
      //                     Actuals.RESET;
      //                     Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
      //                     Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
      //                     Actuals."Posting Date",Actuals."Account No.");
      //                     Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
      //                    //Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                    //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                     Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                     Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
      //                        Actuals.CALCSUMS(Actuals.Amount);
      //                        ActualsAmount:= Actuals.Amount;
      //
      //                   //get the committments
      //                     CommitmentAmount:=0;
      //                     Commitments.RESET;
      //                     Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
      //                     Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
      //                     Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
      //                     Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
      //                     Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
      //                     Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                     //Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
      //                     //Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
      //                    //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
      //                    //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
      //                        Commitments.CALCSUMS(Commitments.Amount);
      //                        CommitmentAmount:= Commitments.Amount;
      //
      //                    //check if there is any budget
      //                    IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
      //                       ERROR('No Budget To Check Against');
      //                    END ELSE BEGIN
      //                     IF (BudgetAmount<=0) THEN BEGIN
      //                      IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
      //                         ERROR('Budgetary Checking Process Aborted');
      //                      END;
      //                     END;
      //                    END;

                         //check if the actuals plus the amount is greater then the budget amount
      //                    IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
      //                    AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
      //                       ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
      //                       PayLine.No,'Staff Imprest' ,PayLine.No,
      //                         FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
      //                     END ELSE BEGIN
      //                     //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
      //                         IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
      //                             IF NOT CONFIRM(Text0001+
      //                             FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
      //                             +Text0002,TRUE) THEN BEGIN
      //                                ERROR('Budgetary Checking Process Aborted');
      //                             END;
      //                         END;

      //                         Commitments.RESET;
      //                         Commitments.INIT;
      //                         EntryNo+=1;
      //                         Commitments."Line No":=EntryNo;
      //                         Commitments.Date:=TODAY;
      //                         Commitments."Posting Date":=ImprestHeader.Date;
      //                         Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
      //                         Commitments."Document No.":=ImprestHeader."No.";
      //                         Commitments.Amount:=PayLine."Amount LCY";
      //                         Commitments."Month Budget":=BudgetAmount;
      //                         Commitments."Month Actual":=ActualsAmount;
      //                         Commitments.Committed:=TRUE;
      //                         Commitments."Committed By":=USERID;
      //                         Commitments."Committed Date":=ImprestHeader.Date;
      //                         Commitments."G/L Account No.":=BudgetGL;
      //                         Commitments."Committed Time":=TIME;
      //                        // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
      //                         //Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
      //                         //Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
      //                         //Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
      //                         //Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
      //                         Commitments.Budget:=BCSetup."Current Budget Code";
      //                         Commitments.Type:=ImprestHeader."Account Type";
      //                         Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
      //                         Commitments.INSERT;
      //                         //Tag the Imprest Line as Committed
      //                           PayLine.Committed:=TRUE;
      //                           PayLine.MODIFY;
      //                         //End Tagging Imprest Lines as Committed
      //                     END;
      //
      //           UNTIL PayLine.NEXT=0;
      //         END;
      //   END
      // ELSE//budget control not mandatory
      //   BEGIN
      //
      //   END;
      // MESSAGE('Budgetary Checking Completed Successfully');
    END;

    PROCEDURE CheckStaffAdvSurr@1102755008(VAR ImprestHeader@1102755000 : Record 51516006);
    VAR
      PayLine@1102755013 : Record 51516001;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN
      //First Update Analysis View
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
         // IF (ImprestHeader."Surrender Date"< BCSetup."Current Budget Start Date") THEN
      //       BEGIN
      //         ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
      //         BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //       END
      //     ELSE IF (ImprestHeader."Surrender Date">BCSetup."Current Budget End Date") THEN
      //       BEGIN
      //         ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
      //         BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //
      //       END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No";

          //get the lines related to the payment header
      //       PayLine.RESET;
      //       PayLine.SETRANGE(PayLine."Surrender Doc No.",ImprestHeader.No);
      //       PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
      //       IF PayLine.FINDFIRST THEN
      //         BEGIN
      //           REPEAT
      //                        //check the votebook now
      //                        FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader."Surrender Date",2),DATE2DMY(ImprestHeader."Surrender Date",3));
      //                        CurrMonth:=DATE2DMY(ImprestHeader."Surrender Date",2);
      //                        IF CurrMonth=12 THEN
      //                         BEGIN
      //                           LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader."Surrender Date",3) +1);
      //                           LastDay:=CALCDATE('-1D',LastDay);
      //                         END
      //                        ELSE
      //                         BEGIN
      //                           CurrMonth:=CurrMonth +1;
      //                           LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader."Surrender Date",3));
      //                           LastDay:=CALCDATE('-1D',LastDay);
      //                         END;
      //
      //                        //The GL Account
      //                         BudgetGL:=PayLine."Account No:";
      //
      // //                        //check the summation of the budget in the database
      //                        BudgetAmount:=0;
      //                        Budget.RESET;
      //                        Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
      //                        Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
      //                        Budget."Dimension 4 Value Code");
      //                        Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
      //                        Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                        Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
      //                        //Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                       // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                        //Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                            Budget.CALCSUMS(Budget.Amount);
      //                            BudgetAmount:= Budget.Amount;
      //
      //                   //get the summation on the actuals
      //                     ActualsAmount:=0;
      //                     Actuals.RESET;
      //                     Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
      //                     Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
      //                     Actuals."Posting Date",Actuals."Account No.");
      //                     Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                     //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                     Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                     Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
      //                        Actuals.CALCSUMS(Actuals.Amount);
      //                        ActualsAmount:= Actuals.Amount;
      //
      //                   //get the committments
      //                     CommitmentAmount:=0;
      //                     Commitments.RESET;
      //                     Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
      //                     Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
      //                     Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
      //                     Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
      //                     Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
      //                     Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                     //Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Shortcut Dimension 1 Code");
      //                     //Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
      //                     //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
      //                     //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
      //                        Commitments.CALCSUMS(Commitments.Amount);
      //                        CommitmentAmount:= Commitments.Amount;
      //
      //                    //check if there is any budget
      //                    IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
      //                       ERROR('No Budget To Check Against');
      //                    END ELSE BEGIN
      //                     IF (BudgetAmount<=0) THEN BEGIN
      //                      IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
      //                         ERROR('Budgetary Checking Process Aborted');
      //                      END;
      //                     END;
      //                    END;

      //                    //check if the actuals plus the amount is greater then the budget amount
      //                    IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
      //                    AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
      //                       ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
      //                       PayLine."Surrender Doc No.",'Staff Imprest' ,PayLine."Surrender Doc No.",
      //                         FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
      //                     END ELSE BEGIN
      //                     //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
      //                         IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
      //                             IF NOT CONFIRM(Text0001+
      //                             FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
      //                             +Text0002,TRUE) THEN BEGIN
      //                                ERROR('Budgetary Checking Process Aborted');
      //                             END;
      //                         END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No":=EntryNo;
                              Commitments.Date:=TODAY;
      //                         Commitments."Posting Date":=ImprestHeader."Surrender Date";
      //                         Commitments."Document Type":=Commitments."Document Type"::StaffSurrender;
      //                         Commitments."Document No.":=ImprestHeader.No;
      //                         Commitments.Amount:=PayLine."Amount LCY";
      //                         Commitments."Month Budget":=BudgetAmount;
      //                         Commitments."Month Actual":=ActualsAmount;
      //                         Commitments.Committed:=TRUE;
      //                         Commitments."Committed By":=USERID;
      //                         Commitments."Committed Date":=ImprestHeader."Surrender Date";
      //                         Commitments."G/L Account No.":=BudgetGL;
      //                         Commitments."Committed Time":=TIME;
      //                         //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
      //                         //Commitments."Shortcut Dimension 1 Code":=PayLine."Shortcut Dimension 1 Code";
      //                         //Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
      //                         //Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
      //                         //Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
      //                         Commitments.Budget:=BCSetup."Current Budget Code";
      //                         Commitments.Type:=ImprestHeader."Account Type";
      //                         Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
      //                         Commitments.INSERT;
      //                         //Tag the Imprest Line as Committed
      //                           PayLine.Committed:=TRUE;
      //                           PayLine.MODIFY;
      //                         //End Tagging Imprest Lines as Committed
      //                     END;

      //
      END;
    END;

    PROCEDURE GetLineAmountToReverse@1102755006(DocumentType@1102755002 : 'LPO,Requisition,Imprest,Payment Voucher,PettyCash';DocNo@1102755001 : Code[20];DocLineNo@1102755000 : Integer);
    VAR
      LPO@1102755003 : Record 39;
    BEGIN
      {IF DocumentType=DocumentType::LPO THEN BEGIN
          LPO.RESET;
          LPO.SETRANGE(LPO."Document Type",LPO."Document Type"::Order);
          LPO.SETRANGE(LPO."Document No.",DocNo);
          LPO.SETRANGE(LPO."Line No.",DocLineNo);
          IF LPO.FIND('-') THEN BEGIN
                IF LPO."VAT %"=0 THEN
                TotalAmount:=LPO."Qty. to Invoice"*LPO."Direct Unit Cost"
                  ELSE
                     TotalAmount:=(LPO."Qty. to Invoice"*LPO."Direct Unit Cost")*((LPO."VAT %"+100)/100)

          END;
      END; }
    END;

    PROCEDURE CheckStaffClaim@1000000000(VAR ImprestHeader@1000000000 : Record 51516006);
    VAR
      PayLine@1000000017 : Record 51516001;
      Commitments@1000000016 : Record 51516050;
      Amount@1000000015 : Decimal;
      GLAcc@1000000014 : Record 15;
      Item@1000000013 : Record 27;
      FirstDay@1000000012 : Date;
      LastDay@1000000011 : Date;
      CurrMonth@1000000010 : Integer;
      Budget@1000000009 : Record 366;
      BudgetAmount@1000000008 : Decimal;
      Actuals@1000000007 : Record 365;
      ActualsAmount@1000000006 : Decimal;
      CommitmentAmount@1000000005 : Decimal;
      FixedAssetsDet@1000000004 : Record 5600;
      FAPostingGRP@1000000003 : Record 5606;
      EntryNo@1000000002 : Integer;
      GLAccount@1000000001 : Record 15;
    BEGIN
      // //First Update Analysis View
      // UpdateAnalysisView();
      //
      // //get the budget control setup first to determine if it mandatory or not
      // BCSetup.RESET;
      // BCSetup.GET();
      // IF BCSetup.Mandatory THEN//budgetary control is mandatory
      //   BEGIN
      //     //check if the dates are within the specified range in relation to the payment header table
      //     IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
      //       BEGIN
      //         ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
      //         BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //       END
      //     ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
      //       BEGIN
      //         ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
      //         BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
      //
      //       END;
      //     //Is budget Available
      //     CheckIfBlocked(BCSetup."Current Budget Code");
      //
      //     //Get Commitment Lines
      //      IF Commitments.FIND('+') THEN
      //         EntryNo:=Commitments."Line No.";
      //
      //     //get the lines related to the payment header
      //       PayLine.RESET;
      //       PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
      //       PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
      //       IF PayLine.FINDFIRST THEN
      //         BEGIN
      //           REPEAT
      //                        //check the votebook now
      //                        FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
      //                        CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
      //                        IF CurrMonth=12 THEN
      //                         BEGIN
      //                           LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
      //                           LastDay:=CALCDATE('-1D',LastDay);
      //                         END
      //                        ELSE
      //                         BEGIN
      //                           CurrMonth:=CurrMonth +1;
      //                           LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
      //                           LastDay:=CALCDATE('-1D',LastDay);
      //                         END;
      //                        //If Budget is annual then change the Last day
      //                        IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
      //                            LastDay:=BCSetup."Current Budget End Date";
      //
      //                        //The GL Account
      //                         BudgetGL:=PayLine."Account No:";
      //
      //                        //check the summation of the budget in the database
      //                        BudgetAmount:=0;
      //                        Budget.RESET;
      //                        Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
      //                        Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
      //                        Budget."Dimension 4 Value Code");
      //                        Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
      //                        Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                        Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
      //                        Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
      //                        Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                        Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                        Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                            Budget.CALCSUMS(Budget.Amount);
      //                            BudgetAmount:= Budget.Amount;
      //
      //                   //get the summation on the actuals
      //                   //Separate Analysis View and G/L Entry
      //                    IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
      //                     ActualsAmount:=0;
      //                     Actuals.RESET;
      //                     Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
      //                     Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
      //                     Actuals."Posting Date",Actuals."Account No.");
      //                     Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
      //                     Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
      //                     Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
      //                     Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
      //                     Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
      //                     Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                     Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
      //                        Actuals.CALCSUMS(Actuals.Amount);
      //                        ActualsAmount:= Actuals.Amount;
      //                     END ELSE BEGIN
      //                         GLAccount.RESET;
      //                         GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
      //                         GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
      //                         IF PayLine."Global Dimension 1 Code" <> '' THEN
      //                           GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
      //                         IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
      //                           GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
      //                         IF GLAccount.FIND('-') THEN BEGIN
      //                          GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
      //                          ActualsAmount:=GLAccount."Net Change";
      //                         END;
      //                     END;
      //                   //get the committments
      //                     CommitmentAmount:=0;
      //                     Commitments.RESET;
      //                     Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
      //                     Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
      //                     Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
      //                     Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
      //                     Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
      //                     Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
      //                     Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
      //                     Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
      //                     Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
      //                     Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
      //                        Commitments.CALCSUMS(Commitments.Amount);
      //                        CommitmentAmount:= Commitments.Amount;
      //
      //                    //check if there is any budget
      //                    IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
      //                       ERROR('No Budget To Check Against');
      //                    END ELSE BEGIN
      //                     IF (BudgetAmount<=0) THEN BEGIN
      //                      IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
      //                         ERROR('Budgetary Checking Process Aborted');
      //                      END;
      //                     END;
      //                    END;
      //
      //                    //check if the actuals plus the amount is greater then the budget amount
      //                    IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
      //                    AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
      //                       ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
      //                       PayLine.No,'Staff Imprest' ,PayLine.No,
      //                         FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
      //                     END ELSE BEGIN
      //                     //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
      //                         IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
      //                             IF NOT CONFIRM(Text0001+
      //                             FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
      //                             +Text0002,TRUE) THEN BEGIN
      //                                ERROR('Budgetary Checking Process Aborted');
      //                             END;
      //                         END;
      //
      //                         Commitments.RESET;
      //                         Commitments.INIT;
      //                         EntryNo+=1;
      //                         Commitments."Line No.":=EntryNo;
      //                         Commitments.Date:=TODAY;
      //                         Commitments."Posting Date":=ImprestHeader.Date;
      //                         Commitments."Document Type":=Commitments."Document Type"::StaffClaim;
      //                         Commitments."Document No.":=ImprestHeader."No.";
      //                         Commitments.Amount:=PayLine."Amount LCY";
      //                         Commitments."Month Budget":=BudgetAmount;
      //                         Commitments."Month Actual":=ActualsAmount;
      //                         Commitments.Committed:=TRUE;
      //                         Commitments."Committed By":=USERID;
      //                         Commitments."Committed Date":=ImprestHeader.Date;
      //                         Commitments."G/L Account No.":=BudgetGL;
      //                         Commitments."Committed Time":=TIME;
      //                        // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
      //                         Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
      //                         Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
      //                         Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
      //                         Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
      //                         Commitments.Budget:=BCSetup."Current Budget Code";
      //                         Commitments.Type:=ImprestHeader."Account Type";
      //                         Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
      //                         Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
      //                         Commitments."Actual Source":=BCSetup."Actual Source";
      //                         Commitments.INSERT;
      //                         //Tag the Imprest Line as Committed
      //                           PayLine.Committed:=TRUE;
      //                           PayLine.MODIFY;
      //                         //End Tagging Imprest Lines as Committed
      //                     END;
      //
      //           UNTIL PayLine.NEXT=0;
      //         END;
      //   END
      // ELSE//budget control not mandatory
      //   BEGIN
      //
      //   END;
      // MESSAGE('Budgetary Checking Completed Successfully');
    END;

    BEGIN
    END.
  }
}

