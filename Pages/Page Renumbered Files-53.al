OBJECT page 20417 Funds Transfer Card
{
  OBJECT-PROPERTIES
  {
    Date=08/19/16;
    Time=[ 9:31:11 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516004;
    PageType=Card;
    OnNewRecord=BEGIN
                  "Created By":=USERID;
                END;

    ActionList=ACTIONS
    {
      { 26      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 25      ;1   ;ActionGroup }
      { 35      ;2   ;Action    ;
                      Name=Post;
                      Promoted=Yes;
                      Visible=false;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 TempBatch.RESET;
                                 TempBatch.SETRANGE(TempBatch.UserID,USERID);
                                 IF TempBatch.FIND('-') THEN  BEGIN

                                     "Inter Bank Template Name":=TempBatch."FundsTransfer Batch Name";
                                     MESSAGE("Inter Bank Template Name");
                                     "Inter Bank Journal Batch":=TempBatch."FundsTransfer Template Name";
                                 END;

                                 //TESTFIELD(Status,Status::Approved);
                                 TESTFIELD("Posting Date");
                                 //TESTFIELD("Sending Responsibility Center");
                                 TESTFIELD("Paying Bank Account");

                                 //Check whether the two LCY amounts are same
                                 //IF "Request Amt LCY" <>"Pay Amt LCY" THEN
                                   // ERROR('The [Requested Amount in LCY: %1] should be same as the [Paid Amount in LCY: %2]',"Request Amt LCY" ,"Pay Amt LCY");

                                 //get the source account balance from the database table
                                 BankAcc.RESET;
                                 BankAcc.SETRANGE(BankAcc."No.","Paying Bank Account");
                                 BankAcc.SETRANGE(BankAcc."Bank Type",BankAcc."Bank Type"::Cash);
                                 IF BankAcc.FINDFIRST THEN
                                   BEGIN
                                       BankAcc.CALCFIELDS(BankAcc.Balance );
                                     "Bank Balance":=BankAcc.Balance ;
                                     IF ("Bank Balance"-"Amount to Transfer")<0 THEN
                                       BEGIN
                                         ERROR('The transaction will result in a negative balance in a CASH ACCOUNT.');
                                       END;
                                   END;
                                 IF "Amount to Transfer"=0 THEN
                                   BEGIN
                                     ERROR('Please ensure Amount to Transfer is entered');
                                   END;
                                 {Check if the user's batch has any records within it}

                                 FundsLine.RESET;
                                 FundsLine.SETRANGE(FundsLine."Document No","No.");
                                 IF FundsLine.FIND ('-') THEN BEGIN
                                 REPEAT
                                 GenJnlLine.RESET;
                                 GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Inter Bank Template Name");
                                 GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Inter Bank Journal Batch");
                                 GenJnlLine.DELETEALL;

                                 LineNo:=1000;
                                 {Insert the new lines to be updated}
                                 GenJnlLine.INIT;
                                   {Insert the lines}
                                     GenJnlLine."Line No.":=LineNo;
                                     GenJnlLine."Source Code":='PAYMENTJNL';
                                     GenJnlLine."Journal Template Name":="Inter Bank Template Name";
                                     GenJnlLine."Journal Batch Name":="Inter Bank Journal Batch";
                                     GenJnlLine."Posting Date":="Posting Date";
                                     GenJnlLine."Document No.":="No.";
                                    { IF "Receiving Transfer Type"="Receiving Transfer Type"::"Intra-Company" THEN
                                       BEGIN
                                         GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
                                       END
                                     ELSE IF "Receiving Transfer Type"="Receiving Transfer Type"::"Inter-Company" THEN
                                       BEGIN
                                         GenJnlLine."Account Type":=GenJnlLine."Account Type"::"IC Partner";
                                       END;}
                                     GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
                                     GenJnlLine."Account No.":=FundsLine."Receiving Bank Account";
                                     GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                                     GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + FORMAT("No.");
                                     //GenJnlLine."Shortcut Dimension 1 Code":="Receiving Depot Code";
                                     //GenJnlLine."Shortcut Dimension 2 Code":="Receiving Department Code";
                                     GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                     GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                     //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code1");
                                     //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code1");
                                     //GenJnlLine."External Document No.":=fundline.e;
                                     GenJnlLine.Description:=Description;
                                     IF Description='' THEN BEGIN GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + FORMAT("No."); END;
                                     //GenJnlLine."Currency Code":="Currency Code Destination";
                                     GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                                     {IF "Currency Code Destination"<>'' THEN
                                       BEGIN
                                         GenJnlLine."Currency Factor":="Exch. Rate Destination";//"Reciprical 2";
                                         GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
                                       END}
                                     GenJnlLine.Amount:="Amount to Transfer";
                                     GenJnlLine.VALIDATE(GenJnlLine.Amount);
                                 GenJnlLine.INSERT;


                                 GenJnlLine.INIT;
                                   {Insert the lines}
                                     GenJnlLine."Line No.":=LineNo + 1;
                                     GenJnlLine."Source Code":='PAYMENTJNL';
                                     GenJnlLine."Journal Template Name":="Inter Bank Template Name";
                                     GenJnlLine."Journal Batch Name":="Inter Bank Journal Batch";
                                     GenJnlLine."Posting Date":="Posting Date";
                                     GenJnlLine."Document No.":="No.";
                                     {IF "Source Transfer Type"="Source Transfer Type"::"Intra-Company" THEN
                                       BEGIN
                                         GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
                                       END
                                     ELSE IF "Source Transfer Type"="Source Transfer Type"::"Inter-Company" THEN
                                       BEGIN
                                         GenJnlLine."Account Type":=GenJnlLine."Account Type"::"IC Partner";
                                       END;
                                       }
                                     GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
                                     GenJnlLine."Account No.":="Paying Bank Account";
                                     GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                                     //GenJnlLine."Shortcut Dimension 1 Code":="Source Depot Code";
                                     //GenJnlLine."Shortcut Dimension 2 Code":="Source Department Code";
                                     GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                     GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                    // GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                                     //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                     GenJnlLine."External Document No.":=FundsLine."External Doc No.";
                                     GenJnlLine.Description:=Description;
                                     IF Description='' THEN BEGIN GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + FORMAT("No."); END;
                                     //GenJnlLine."Currency Code":="Currency Code Source";
                                     //GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                                    { IF "Currency Code Source"<>'' THEN
                                       BEGIN
                                         GenJnlLine."Currency Factor":="Exch. Rate Source";//"Reciprical 1";
                                         GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
                                       END;}
                                     GenJnlLine.Amount:=-"Amount to Transfer";
                                     GenJnlLine.VALIDATE(GenJnlLine.Amount);
                                 GenJnlLine.INSERT;

                                 UNTIL FundsLine.NEXT=0;
                                 END;
                                 Post:=FALSE;
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
                                 Post:=JournalPostedSuccessfully.PostedSuccessfully();

                                 {
                                 IF Post = FALSE THEN BEGIN
                                     Posted:=TRUE;
                                     "Date Posted":=TODAY;
                                     "Time Posted":=TIME;
                                     "Posted By":=USERID;
                                     MODIFY;
                                     MESSAGE('The Journal Has Been Posted Successfully');
                                 END;
                                 }

                                 Posted:=TRUE;
                                 "Date Posted":=TODAY;
                                 "Time Posted":=TIME;
                                 "Posted By":=USERID;
                                 MODIFY;
                               END;
                                }
      { 34      ;2   ;Separator  }
      { 33      ;2   ;Action    ;
                      Name=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1000000000 : Page 658;
                               BEGIN
                                 Doc_Type:=Doc_Type::Interbank;
                                 //ApprovalEntries.Setfilters(DATABASE::"Funds Transfer Header",Doc_Type,No);
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 32      ;2   ;Action    ;
                      Name=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1000000000 : Codeunit 439;
                                 Text001@1000000001 : TextConst 'ENU=This batch is already pending approval';
                                 NoSeriesMgt@1102755000 : Codeunit 396;
                               BEGIN
                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);

                                 //End allocate batch number
                                 Doc_Type:=Doc_Type::Interbank;
                                 Table_id:=DATABASE::"Funds Transfer Header";
                                 IF ApprovalMgt.SendApproval(Table_id,"No.",Doc_Type,Status)THEN;
                               END;
                                }
      { 31      ;2   ;Action    ;
                      Name=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1000000000 : Codeunit 439;
                               BEGIN
                                 //IF ApprovalMgt.CancelInterbankApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 30      ;2   ;Separator  }
      { 29      ;2   ;Action    ;
                      Name=Print;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {RESET;
                                 SETRANGE(No,No);
                                 REPORT.RUN(51516400,TRUE,TRUE,Rec);
                                 RESET;
                                         }
                               END;
                                }
      { 28      ;2   ;Separator  }
      { 27      ;2   ;Action    ;
                      Name=Cancel Document;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 {TESTFIELD(Status,Status::Approved);
                                 IF CONFIRM(Text000,TRUE) THEN  BEGIN
                                 Status:=Status::Cancelled;
                                 "Cancelled By":=USERID;
                                 "Date Cancelled":=TODAY;
                                 "Time Cancelled":=TIME;
                                 MODIFY;
                                 END ELSE
                                   ERROR(Text001);}
                               END;
                                }
      { 1000000000;1 ;Action    ;
                      Name=PostA;
                      CaptionML=ENU=Post Transfer;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Post;
                      OnAction=BEGIN

                                 //Check Required Fields
                                 CheckRequiredFields;

                                 TESTFIELD("Posting Date");
                                 TESTFIELD(Status,Status::Approved);

                                 //Get Setups of the current UserID from Cash Office User Template
                                 CashOfficeUserTemplate.RESET;
                                 CashOfficeUserTemplate.SETRANGE(CashOfficeUserTemplate.UserID,USERID);
                                 IF CashOfficeUserTemplate.FIND('-') THEN  BEGIN
                                     "Inter Bank Template Name":=CashOfficeUserTemplate."FundsTransfer Template Name";
                                     "Inter Bank Journal Batch":=CashOfficeUserTemplate."FundsTransfer Batch Name";
                                 END;

                                 //Check whether the "Line Amounts" to be Transfered is the same as "Amount to Transfer" in the header
                                 CALCFIELDS("Total Line Amount");
                                 IF  "Total Line Amount" <> "Amount to Transfer" THEN
                                 BEGIN
                                    ERROR(Text001,"Amount to Transfer","Total Line Amount");
                                 END;

                                 //Check if the transaction will lead to a Negative Account Balance in the Paying Account Bank
                                 BankAcc.RESET;
                                 BankAcc.SETRANGE(BankAcc."No.","Paying Bank Account");
                                 IF BankAcc.FINDFIRST THEN
                                 BEGIN
                                     BankAcc.CALCFIELDS(BankAcc.Balance);

                                     currBankBalance:=BankAcc.Balance - "Amount to Transfer";
                                         {
                                     //For normal banks with no Credit Agreement
                                     IF (currBankBalance <= 0) AND NOT BankAcc."Credit Agreement?" THEN
                                     BEGIN
                                         ERROR(Text002,currBankBalance,"Paying Bank Account","Paying Account Name");
                                     END;
                                         }
                                     //For banks with credit agreeement
                                     IF (currBankBalance <= 0) AND (BankAcc."Credit Agreement?") THEN
                                     BEGIN
                                         NewBankBalanceAfterPost:=BankAcc.Balance - "Amount to Transfer";
                                         IF  NewBankBalanceAfterPost < BankAcc."Maximum Credit Limit" THEN
                                         BEGIN
                                             ERROR(Text006,"Paying Bank Account","Paying Bank Name");
                                         END ELSE
                                         BEGIN
                                             //Do Nothing
                                         END;

                                     END;

                                 END;


                                 //Clear Users Batch
                                 GenJnlLine.RESET;
                                 GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Inter Bank Template Name");
                                 GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Inter Bank Journal Batch");
                                 GenJnlLine.DELETEALL;

                                 //Inserting Amounts of Accounts to be Debited into the Journal (+)
                                 IBTLines.RESET;
                                 IBTLines.SETRANGE(IBTLines."Document No","No.");
                                 IF IBTLines.FIND('-') THEN
                                 BEGIN
                                     REPEAT
                                         Insert_IBTLines_to_Journal;
                                     UNTIL IBTLines.NEXT =0;
                                 END;

                                 //Insert Amounts of Accounts to "Credit" (-) into the Journal
                                 Insert_IBTHead_to_Journal;

                                 Post:=FALSE;
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
                                 //Post:=JournalPostedSuccessfully.PostedSuccessfully();

                                 //IF Post THEN BEGIN
                                     Posted:=TRUE;
                                     Status:=Status::Posted;
                                     "Date Posted":=TODAY;
                                     "Time Posted":=TIME;
                                     "Posted By":=USERID;
                                     //"Posted On Computer Name":='';
                                     MODIFY;

                                     MESSAGE('The Journal Has Been Posted Successfully');

                                 //END;

                                 //MESSAGE('Lines transfered to Payments Journal and Batch Name %1 for posting',"Inter Bank Journal Batch");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="No." }

    { 5   ;2   ;Field     ;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 7   ;2   ;Field     ;
                SourceExpr="Paying Bank Account" }

    { 8   ;2   ;Field     ;
                SourceExpr="Paying Bank Name";
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                SourceExpr="Bank Balance";
                Editable=false }

    { 14  ;2   ;Field     ;
                SourceExpr="Amount to Transfer" }

    { 16  ;2   ;Field     ;
                SourceExpr="Total Line Amount" }

    { 18  ;2   ;Field     ;
                SourceExpr="Cheque/Doc. No" }

    { 19  ;2   ;Field     ;
                SourceExpr=Description }

    { 20  ;2   ;Field     ;
                SourceExpr="Created By";
                Editable=false }

    { 21  ;2   ;Field     ;
                SourceExpr="Date Created" }

    { 22  ;2   ;Field     ;
                SourceExpr="Time Created" }

    { 23  ;2   ;Field     ;
                OptionCaptionML=ENU=Open,Pending Approval,Approved,Cancelled,Posted;
                SourceExpr=Status }

    { 1000000001;2;Field  ;
                SourceExpr=Posted }

    { 1000000002;2;Field  ;
                SourceExpr="Posted By" }

    { 24  ;1   ;Part      ;
                SubPageLink=Document No=FIELD(No.);
                PagePartID=Page51516032;
                PartType=Page }

  }
  CODE
  {
    VAR
      interbank@1000 : Record 51516004;
      Table_id@1003 : Integer;
      Doc_No@1002 : Code[20];
      Doc_Type@1001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening';
      TempBatch@1000000000 : Record 51516031;
      "Inter Bank Template Name"@1000000001 : Code[30];
      "Inter Bank Journal Batch"@1000000002 : Code[30];
      BankAcc@1000000003 : Record 270;
      LineNo@1000000005 : Integer;
      FundsLine@1000000006 : Record 51516005;
      GenJnlLine@1000000018 : Record 81;
      CashOfficeUserTemplate@1000000017 : Record 51516031;
      JTemplate@1000000016 : Code[20];
      IBTLines@1000000014 : Record 51516005;
      Post@1000000013 : Boolean;
      JournalPostedSuccessfully@1000000012 : Codeunit 51516156;
      currBankBalance@1000000011 : Decimal;
      NewBankBalanceAfterPost@1000000010 : Decimal;
      FHeader@1000000009 : Record 51516265;
      Text001@1000000019 : TextConst 'ENU=The [Requested Amount to Transfer in LCY: %1] should be same as the [Total Line Amount in LCY: %2]';
      Text002@1000000015 : TextConst 'ENU=The Transaction will result in a negative Balance of [%1] in Bank Account [%2 - %3]';
      Text003@1000000008 : TextConst 'ENU=Sorry you are not authorised to Cancel Petty Cash Documents. Please liase with the Approver (%1)';
      Text004@1000000007 : TextConst 'ENU=Document % 1 is already POSTED and cannot be reverted to Pending';
      Text006@1000000004 : TextConst 'ENU=The Transaction will result in a negative Maximum Credit Limit Balance of in Bank Account [%1 - %2]';

    PROCEDURE CheckRequiredFields@1000000000();
    BEGIN
       TESTFIELD("Amount to Transfer");
      //Check Lines if Cheque No has been specified
      IBTLines.RESET;
      IBTLines.SETRANGE(IBTLines."Document No","No.");
      IF IBTLines.FIND('-') THEN
      BEGIN
          REPEAT
              IBTLines.TESTFIELD(IBTLines."Pay Mode");
              IF IBTLines."Pay Mode" = IBTLines."Pay Mode"::Cheque THEN
              BEGIN
                  IBTLines.TESTFIELD(IBTLines."External Doc No.");
              END;
          UNTIL IBTLines.NEXT = 0;
      END;

      //Check whether the "Line Amounts" to be Transfered is the same as "Amount to Transfer" in the header
      CALCFIELDS("Total Line Amount");
      IF  "Total Line Amount" <> "Amount to Transfer" THEN
      BEGIN
         ERROR(Text001,"Amount to Transfer","Total Line Amount");
      END;
    END;

    PROCEDURE Insert_IBTLines_to_Journal@1000000007();
    BEGIN
      //Get Last Line No in Journal
      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Inter Bank Template Name");
      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Inter Bank Journal Batch");
      IF GenJnlLine.FIND('+') THEN
      BEGIN
          LineNo:=GenJnlLine."Line No."+1;
      END ELSE
      BEGIN
          LineNo:=1000;
      END;

      //Insert Into Journal
      GenJnlLine.INIT;
      GenJnlLine."Line No.":=LineNo;
      GenJnlLine."Source Code":='PAYMENTJNL';
      GenJnlLine."Journal Template Name":="Inter Bank Template Name";
      GenJnlLine."Journal Batch Name":="Inter Bank Journal Batch";
      GenJnlLine."Posting Date":="Posting Date";
      GenJnlLine."Document No.":="No.";
      GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
      GenJnlLine."Account No.":=IBTLines."Receiving Bank Account";
      GenJnlLine.VALIDATE(GenJnlLine."Account No.");
      GenJnlLine.Description:='Inter-Bank Transfer Ref No: ' + FORMAT("No.");
      //GenJnlLine."Shortcut Dimension 1 Code":="Receiving Depot Code";
      //GenJnlLine."Shortcut Dimension 2 Code":="Receiving Department Code";
      //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
      //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
      //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code1");
      //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code1");
      GenJnlLine."External Document No.":=IBTLines."External Doc No.";
      IF Description='' THEN
      BEGIN
          GenJnlLine.Description:='Inter-Bank Transfer Ref No: ' + FORMAT("No.");
      END ELSE
      BEGIN
          GenJnlLine.Description:=Description;
      END;
      GenJnlLine."Currency Code":=IBTLines."Currency Code";
      GenJnlLine.VALIDATE(GenJnlLine."Currency Code");

      IF IBTLines."Currency Code" <> '' THEN
      BEGIN
          GenJnlLine."Currency Factor":=IBTLines."Currency Factor";
          GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
      END;

      GenJnlLine.Amount:=IBTLines."Amount to Receive";
      GenJnlLine.VALIDATE(GenJnlLine.Amount);
      GenJnlLine.INSERT;
    END;

    PROCEDURE Insert_IBTHead_to_Journal@1000000004();
    BEGIN
      //Get Last Line No in Journal
      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Inter Bank Template Name");
      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Inter Bank Journal Batch");
      IF GenJnlLine.FIND('+') THEN
      BEGIN
          LineNo:=GenJnlLine."Line No."+1;
      END ELSE
      BEGIN
          LineNo:=1000;
      END;

      GenJnlLine.INIT;
      GenJnlLine."Line No.":=LineNo;
      GenJnlLine."Source Code":='PAYMENTJNL';
      GenJnlLine."Journal Template Name":="Inter Bank Template Name";
      GenJnlLine."Journal Batch Name":="Inter Bank Journal Batch";
      GenJnlLine."Posting Date":="Posting Date";
      GenJnlLine."Document No.":="No.";
      GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
      GenJnlLine."Account No.":="Paying Bank Account";
      GenJnlLine.VALIDATE(GenJnlLine."Account No.");
      //GenJnlLine."Shortcut Dimension 1 Code":="Source Depot Code";
      //GenJnlLine."Shortcut Dimension 2 Code":="Source Department Code";
      //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
      //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
      //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
      //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
      GenJnlLine."External Document No.":="Cheque/Doc. No";
      IF Description='' THEN
      BEGIN
          GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + FORMAT("No.");
      END ELSE
      BEGIN
          GenJnlLine.Description:=Description;
      END;
      //GenJnlLine."Currency Code":=;
      //GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
      //IF "Paying Account Currency Code" <> '' THEN
       // BEGIN
          GenJnlLine."Currency Factor":=IBTLines."Currency Factor";  //Exchange Rate of Paying Account
          GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
        //END;
      GenJnlLine.Amount:=-"Amount to Transfer";
      GenJnlLine.VALIDATE(GenJnlLine.Amount);
      GenJnlLine.INSERT;
    END;

    PROCEDURE UpdateControl@1102756000();
    BEGIN
      {
      IF Status=Status::Open THEN BEGIN
          Currpage."Paying Bank Account".EDITABLE:=TRUE;
          Currpage.Description.EDITABLE:=TRUE;
          Currpage."Amount to Transfer".EDITABLE:=TRUE;
          Currpage.IBTLines.EDITABLE:=TRUE;
          //Currpage."Posting Date".EDITABLE:=FALSE;
          Currpage.UPDATECONTROLS;
      END;
      }
      IF Status=Status::"Pending Approval" THEN
      BEGIN
           CurrPage.EDITABLE:=FALSE;
           //Currpage.UPDATECONTROLS
      END;
      {
      IF Status=Status::Approved THEN
      BEGIN
          //message('');
          Currpage."Paying Bank Account".EDITABLE:=FALSE;
          Currpage.Description.EDITABLE:=FALSE;
          //Currpage."Amount to Transfer".EDITABLE:=FALSE;
          Currpage.IBTLines.EDITABLE:=FALSE;
          Currpage.UPDATECONTROLS;
      END;
      //Currpage.UPDATE(FALSE);
       }
    END;

    BEGIN
    END.
  }
}

