OBJECT CodeUnit 20387 CloudPESALive
{
  OBJECT-PROPERTIES
  {
    Date=11/26/20;
    Time=[ 5:36:49 PM];
    Modified=Yes;
    Version List=CloudPESA;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            //MESSAGE(AccountBalance('0502-001-08721','852188'));
            //MESSAGE(WSSAccount('+254727636706'));
            //ChargeSMS();
            //MESSAGE(SurePESARegistration());
            //MESSAGE(MemberAccounts('+254721642818'));
            //MESSAGE(LoansGuaranteed('+254721642818'));
            //MESSAGE(LoanBalances('+254725024804'));
            //MESSAGE(MemberAccountNumbers('+254721642818'))
            MESSAGE(LoanRepayment('0502-001-08721','LN008091','00007608176079', 10)); //Removed
            //MESSAGE(LoanBalances('+254729006052'))
            //// IF LoanGuarantors('BLN_00001') <> '' THEN BEGIN
              //ERROR('tEST ONE LEV %1',OutstandingLoans('0710886650'));
            //  FnSendSMSNotification
            //MESSAGE(LoanGuarantors('FL000024'));
            //MESSAGE(ClientNames('011979'));
            //MESSAGE(FundsTransferFOSA('0502-001-08685','0502-001-08685','12233',200));
            //MESSAGE(FundsTransferBOSA('0502-001-08685','Shares Capital','12221',340));
            //MESSAGE(InsertTransaction('A1821o','BVF','0502-001-01667','Ngosa','0725698745',10000,7000));
            //MESSAGE(PayBillToAcc('PAYBILL','ADDKDK40','BES000615','BES000615',20,'POD'po));
            //MESSAGE(FORMAT(AdvanceEligibility('0502-001-08640',1)));
            //MESSAGE(SharesUSSD('+254721642818','245699'));
            //MESSAGE(Loancalculator());
          END;

  }
  CODE
  {
    VAR
      Vendor@1000000000 : Record 23;
      AccountTypes@1000000002 : Record 51516295;
      miniBalance@1000000003 : Decimal;
      accBalance@1000000004 : Decimal;
      minimunCount@1000000005 : Integer;
      VendorLedgEntry@1000000006 : Record 25;
      amount@1000000007 : Decimal;
      Loans@1000000008 : Integer;
      LoansRegister@1000000009 : Record 51516230;
      LoanProductsSetup@1000000010 : Record 51516240;
      Members@1000000011 : Record 51516223;
      dateExpression@1000000012 : Text[20];
      DetailedVendorLedgerEntry@1000000013 : Record 380;
      dashboardDataFilter@1000000014 : Date;
      VendorLedgerEntry@1000000015 : Record 25;
      MemberLedgerEntry@1000000016 : Record 51516224;
      SurePESAApplications@1000000001 : Record 51516521;
      GenJournalLine@1000000019 : TEMPORARY Record 81;
      GenJournalLineTrans@1120054017 : TEMPORARY Record 51516099;
      GenBatches@1000000018 : Record 232;
      LineNo@1000000020 : Integer;
      GLPosting@1000000021 : Codeunit 12;
      SurePESATrans@1000000022 : Record 51516522;
      GenLedgerSetup@1000000023 : Record 98;
      Charges@1000000024 : Record 51516297;
      MobileCharges@1000000025 : Decimal;
      MobileChargesACC@1000000026 : Text[20];
      SurePESACommACC@1000000027 : Code[20];
      SurePESACharge@1000000028 : Decimal;
      ExcDuty@1000000029 : Decimal;
      TempBalance@1000000030 : Decimal;
      SMSMessages@1000000032 : Record 51516329;
      iEntryNo@1000000033 : Integer;
      msg@1000000034 : Text[250];
      accountName1@1000000035 : Text[40];
      accountName2@1000000036 : Text[40];
      fosaAcc@1000000037 : Text[30];
      LoanGuaranteeDetails@1000000038 : Record 51516231;
      bosaNo@1000000039 : Text[20];
      MPESARecon@1000000042 : Text[20];
      TariffDetails@1000000041 : Record 51516273;
      MPESACharge@1000000040 : Decimal;
      TotalCharges@1000000043 : Decimal;
      ExxcDuty@1000000044 : TextConst 'ENU=200-000-168';
      PaybillTrans@1000000045 : Record 51516098;
      PaybillRecon@1000000046 : Code[30];
      fosaConst@1000000047 : TextConst 'ENU=101';
      accountsFOSA@1000000017 : Text[1023];
      interestRate@1000000031 : Integer;
      LoanAmt@1000000048 : Decimal;
      LoanuaranteeFosa@1000000049 : Record 51516319;
      MpesaDisbus@1120054000 : Record 51516094;
      MpesaAccount@1120054001 : Code[50];
      airtimeAcc@1120054002 : Code[50];
      CloudPESATrans@1120054003 : Record 51516522;
      RSchedule@1120054004 : Record 51516234;
      I@1120054005 : Integer;
      MCount@1120054006 : Integer;
      VarAdvance@1120054007 : Record 51516523;
      CloudPESASMS@1120054008 : CodeUnit 20388;
      SurestepFactory@1120054009 : CodeUnit 20389;
      AuditTrail@1120054012 : CodeUnit 20399;
      Trail@1120054011 : Record 51516655;
      EntryNo@1120054010 : Integer;
      sFactory@1120054013 : CodeUnit 20389;
      ObjAutomation@1120054014 : Record 51516068;
      TrCodeunit@1120054015 : Codeunit 50052;
      GenJournalLinePaybill@1120054016 : Record 81;
      Surefactory@1120054018 : CodeUnit 20389;

    PROCEDURE AccountBalance@1000000001(Acc@1000000000 : Code[30];DocNumber@1000000001 : Code[20]) Bal : Text[500];
    BEGIN

        BEGIN
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        Bal:='REFEXISTS';
      END
      ELSE BEGIN
        Bal:='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          //MobileCharges:=Charges."Charge Amount";
          MobileCharges:=GetmobileCharges('ACCBAL');
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";
          TotalCharges:=SurePESACharge+MobileCharges;
          ExcDuty:=(10/100)*(TotalCharges);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",Acc);
          IF Vendor.FIND('-') THEN BEGIN
             AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
          // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
          TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");

            IF (Vendor."Account Type"='ORDINARY') OR (Vendor."Account Type"='SCHOLAR') OR (Vendor."Account Type"='CHURCH')OR (Vendor."Account Type"='BUSINESS')OR (Vendor."Account Type"='COFFEE' ) OR (Vendor."Account Type"='SAVINGS')
                   THEN
                BEGIN
                IF (TempBalance>MobileCharges+SurePESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;
                      //end of deletion

                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MOBILETRAN';
                      GenBatches.Description:='Balance Enquiry';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //Dr Mobile Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Acc;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Acc;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry';
                      GenJournalLine.Amount:=(MobileCharges) + SurePESACharge ;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //DR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Acc;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Acc;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Balance Enquiry';
                      GenJournalLine.Amount:=ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=ExxcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Balance Enquiry';
                      GenJournalLine.Amount:=ExcDuty*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Mobile Transactions Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=MobileChargesACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry Charges';
                      GenJournalLine.Amount:=(MobileCharges)*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                      //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');

                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":=DocNumber;
                      SurePESATrans.Description:='Balance Enquiry';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=Vendor."No.";
                      SurePESATrans."Account No2" :='';
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Status:=SurePESATrans.Status::Completed;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Balance;
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                      AccountTypes.RESET;
                      AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
                      IF AccountTypes.FIND('-') THEN
                      BEGIN
                        miniBalance:=AccountTypes."Minimum Balance";
                      END;
                      Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                      Vendor.CALCFIELDS(Vendor."ATM Transactions");
                      Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
                      Vendor.CALCFIELDS(Vendor."EFT Transactions");
                      accBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
                      Bal:=FORMAT(accBalance);
                      END
                     ELSE BEGIN
                      // Bal:='INSUFFICIENT';
                       Bal:='0';
                     END;
                     END
                     ELSE BEGIN
                        AccountTypes.RESET;
                        AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
                        IF AccountTypes.FIND('-') THEN
                        BEGIN
                          miniBalance:=AccountTypes."Minimum Balance";
                        END;
                        Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                        Vendor.CALCFIELDS(Vendor."ATM Transactions");
                        Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
                        Vendor.CALCFIELDS(Vendor."EFT Transactions");
                        accBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
                        Bal:=FORMAT(accBalance);
                     END;
              END
              ELSE BEGIN
                Bal:='ACCNOTFOUND';
              END;
            END;
        END;
    END;

    PROCEDURE MiniStatement@1000000010(Phone@1000000000 : Text[20];DocNumber@1000000001 : Text[20]) MiniStmt : Text;
    BEGIN
      BEGIN
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        MiniStmt:='REFEXISTS';
      END
      ELSE BEGIN
        MiniStmt :='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileChargesACC:=Charges."GL Account";
          //MobileCharges:=Charges."Charge Amount";
          MobileCharges:=GetmobileCharges('MINIST');
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";
         ExcDuty:=(10/100)*(MobileCharges+SurePESACharge);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",Phone);
          IF Vendor.FIND('-') THEN BEGIN
            AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
          // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
             TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");
           fosaAcc:=Vendor."No.";

                IF (TempBalance>SurePESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;
                      //end of deletion

                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MOBILETRAN';
                      GenBatches.Description:='Mini Statement';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;


              //Dr Mobile Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Vendor."No.";;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mini statement Charges';
                      GenJournalLine.Amount:=(MobileCharges) + SurePESACharge ;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //DR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Mini statement';
                      GenJournalLine.Amount:=ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=ExxcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Mini statement';
                      GenJournalLine.Amount:=ExcDuty*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mini statement Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Mobile Transactions Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=MobileChargesACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mini statement Charges';
                      GenJournalLine.Amount:=(MobileCharges)*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                     //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":=DocNumber;
                      SurePESATrans.Description:='Mini Statement';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=Vendor."No.";
                      SurePESATrans."Account No2" :='';
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Status:=SurePESATrans.Status::Completed;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Ministatement;
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;

                      minimunCount:=1;
                      Vendor.CALCFIELDS(Vendor.Balance);
                      VendorLedgEntry.RESET;
                      VendorLedgEntry.SETCURRENTKEY(VendorLedgEntry."Entry No.");
                      VendorLedgEntry.ASCENDING(FALSE);
                      VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>%1','*Charges*');
                      VendorLedgEntry.SETRANGE(VendorLedgEntry."Vendor No.",Vendor."No.");
                      //VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>*Excise duty*');
                      VendorLedgEntry.SETRANGE(VendorLedgEntry.Reversed,VendorLedgEntry.Reversed::"0");
                    IF VendorLedgEntry.FINDSET THEN BEGIN
                        MiniStmt:='';
                        REPEAT
                          VendorLedgEntry.CALCFIELDS(VendorLedgEntry.Amount);
                          amount:=VendorLedgEntry.Amount;
                          IF amount<1 THEN
                              amount:= amount*-1;
                              MiniStmt :=MiniStmt + FORMAT(VendorLedgEntry."Posting Date") +':::'+ COPYSTR(VendorLedgEntry.Description,1,25) +':::' +
                              FORMAT(amount)+'::::';
                              minimunCount:= minimunCount +1;
                              IF minimunCount>10 THEN
                              EXIT
                          UNTIL VendorLedgEntry.NEXT =0;
                     END;
                     END
                     ELSE BEGIN
                       //MiniStmt:='INSUFFICIENT';
                        Vendor.CALCFIELDS(Vendor.Balance);
                      VendorLedgEntry.RESET;
                      VendorLedgEntry.SETCURRENTKEY(VendorLedgEntry."Entry No.");
                      VendorLedgEntry.ASCENDING(FALSE);
                      VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>%1','*Charges*');
                      VendorLedgEntry.SETRANGE(VendorLedgEntry."Vendor No.",Vendor."No.");
                      //VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>*Excise duty*');
                      VendorLedgEntry.SETRANGE(VendorLedgEntry.Reversed,VendorLedgEntry.Reversed::"0");
                    IF VendorLedgEntry.FINDSET THEN BEGIN
                        MiniStmt:='';
                        REPEAT
                          VendorLedgEntry.CALCFIELDS(VendorLedgEntry.Amount);
                          amount:=VendorLedgEntry.Amount;
                          IF amount<1 THEN
                              amount:= amount*-1;
                              MiniStmt :=MiniStmt + FORMAT(VendorLedgEntry."Posting Date") +':::'+ COPYSTR(VendorLedgEntry.Description,1,25) +':::' +
                              FORMAT(amount)+'::::';
                              minimunCount:= minimunCount +1;
                              IF minimunCount>10 THEN
                              EXIT
                          UNTIL VendorLedgEntry.NEXT =0;
                     END;
                     END;
              END
              ELSE BEGIN
                MiniStmt:='ACCNOTFOUND';
              END;
            END;
        END;
    END;

    PROCEDURE LoanProducts@1000000040() LoanTypes : Text[1000];
    BEGIN
      BEGIN
      LoanProductsSetup.RESET;
      LoanProductsSetup.SETRANGE(LoanProductsSetup.Source, LoanProductsSetup.Source::FOSA);
        IF LoanProductsSetup.FIND('-') THEN BEGIN
          REPEAT
            LoanTypes:=LoanTypes +':::'+LoanProductsSetup."Product Description";
          UNTIL LoanProductsSetup.NEXT =0;
        END
      END
    END;

    PROCEDURE BOSAAccount@1000000005(Phone@1000000000 : Text[20]) bosaAcc : Text[20];
    BEGIN
      Vendor.RESET;
      Vendor.SETRANGE(Vendor."Phone No.",Phone);
      IF Vendor.FIND('-') THEN BEGIN
        Members.RESET;
        Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
        IF Members.FIND('-') THEN BEGIN
          bosaAcc:=Members."No.";
        END;
      END;
    END;

    PROCEDURE MemberAccountNumbers@1000000006(phone@1000000000 : Text[20]) accounts : Text[250];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        IF Vendor.FIND('-') THEN
          BEGIN
             accounts:='';
             REPEAT
               accounts:=accounts+'::::'+Vendor."No.";
             UNTIL Vendor.NEXT =0;
          END
        ELSE
        BEGIN
           accounts:='';
        END
        END;
    END;

    PROCEDURE RegisteredMemberDetails@1000000003(Phone@1000000000 : Text[20]) reginfo : Text[250];
    BEGIN
        BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.", Phone);
        IF Vendor.FIND('-') THEN
         BEGIN
            Members.RESET;
            Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
            IF Members.FIND('-') THEN
            BEGIN
            reginfo:=Members."No."+':::'+Members.Name+':::'+FORMAT(Members."ID No.")+':::'+ Members."E-Mail";
            END;
        END
        ELSE
        BEGIN
        reginfo:='';
        END
        END;
    END;

    PROCEDURE DetailedStatement@1000000019(Phone@1000000000 : Text[20];lastEntry@1000000001 : Integer) detailedstatement : Text[1023];
    BEGIN
      BEGIN
          dateExpression:= '<CD-1M>'; // Current date less 3 months
          dashboardDataFilter := CALCDATE(dateExpression, TODAY);

            Vendor.RESET;
            Vendor.SETRANGE(Vendor."Phone No.",Phone);
              detailedstatement:='';
            IF Vendor.FINDSET THEN REPEAT
              minimunCount:=1;
                AccountTypes.RESET;
                AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type");

            IF AccountTypes.FINDSET THEN REPEAT

                  DetailedVendorLedgerEntry.RESET;
                  DetailedVendorLedgerEntry.SETRANGE(DetailedVendorLedgerEntry."Vendor No.",Vendor."No.");
                  DetailedVendorLedgerEntry.SETFILTER(DetailedVendorLedgerEntry."Entry No.",'>%1',lastEntry);
                  DetailedVendorLedgerEntry.SETFILTER(DetailedVendorLedgerEntry."Posting Date",'>%1',dashboardDataFilter);

            IF DetailedVendorLedgerEntry.FINDSET THEN REPEAT

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Entry No.",DetailedVendorLedgerEntry."Vendor Ledger Entry No.");

              IF VendorLedgerEntry.FINDSET THEN BEGIN
              IF detailedstatement=''
              THEN BEGIN
              detailedstatement:=FORMAT(DetailedVendorLedgerEntry."Entry No.") +':::'+
              FORMAT(AccountTypes.Description)+':::'+
              FORMAT(DetailedVendorLedgerEntry."Posting Date")+':::'+
              FORMAT((DetailedVendorLedgerEntry."Posting Date"),0,'<Month Text>')+':::'+
              FORMAT(DATE2DMY((DetailedVendorLedgerEntry."Posting Date"),3))+':::'+
              FORMAT((DetailedVendorLedgerEntry."Credit Amount"),0,'<Precision,2:2><Integer><Decimals>')+':::'+
              FORMAT((DetailedVendorLedgerEntry."Debit Amount"),0,'<Precision,2:2><Integer><Decimals>')+':::'+
              FORMAT((DetailedVendorLedgerEntry.Amount),0,'<Precision,2:2><Integer><Decimals>')+':::'+
              FORMAT(DetailedVendorLedgerEntry."Journal Batch Name")+':::'+
              FORMAT(DetailedVendorLedgerEntry."Initial Entry Global Dim. 1")+':::'+
              FORMAT(VendorLedgerEntry.Description);
              END
              ELSE
              REPEAT
              detailedstatement:=detailedstatement+'::::'+
              FORMAT(DetailedVendorLedgerEntry."Entry No.") +':::'+
              FORMAT(AccountTypes.Description)+':::'+
              FORMAT(DetailedVendorLedgerEntry."Posting Date")+':::'+
              FORMAT((DetailedVendorLedgerEntry."Posting Date"),0,'<Month Text>')+':::'+
              FORMAT(DATE2DMY((DetailedVendorLedgerEntry."Posting Date"),3))+':::'+
              FORMAT((DetailedVendorLedgerEntry."Credit Amount"),0,'<Precision,2:2><Integer><Decimals>')+':::'+
              FORMAT((DetailedVendorLedgerEntry."Debit Amount"),0,'<Precision,2:2><Integer><Decimals>')+':::'+
              FORMAT((DetailedVendorLedgerEntry.Amount),0,'<Precision,2:2><Integer><Decimals>')+':::'+
              FORMAT(DetailedVendorLedgerEntry."Journal Batch Name")+':::'+
              FORMAT(DetailedVendorLedgerEntry."Initial Entry Global Dim. 1")+':::'+
              FORMAT(VendorLedgerEntry.Description);

              IF minimunCount>20 THEN
              EXIT
              UNTIL VendorLedgerEntry.NEXT =0;
              END;
              UNTIL DetailedVendorLedgerEntry.NEXT =0;
              UNTIL AccountTypes.NEXT =0;
            UNTIL Vendor.NEXT =0;
      END;
    END;

    PROCEDURE MemberAccountNames@1000000042(phone@1000000000 : Text[20]) accounts : Text[250];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        IF Vendor.FIND('-') THEN
          BEGIN
             accounts:='';
             REPEAT
               accounts:=accounts+'::::'+AccountDescription(Vendor."Account Type");
             UNTIL Vendor.NEXT =0;
          END
        ELSE
        BEGIN
           accounts:='';
        END
        END;
    END;

    PROCEDURE SharesRetained@1000000012(phone@1000000000 : Text[20]) shares : Text[1000];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        IF Vendor.FIND('-') THEN BEGIN
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Vendor."BOSA Account No");
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Shares Capital");
            IF MemberLedgerEntry.FIND('-') THEN
              REPEAT
                  amount:=amount+MemberLedgerEntry.Amount;
                  shares:= FORMAT(amount,0,'<Precision,2:2><Integer><Decimals>');
                  UNTIL MemberLedgerEntry.NEXT =0;
              END;
          END;
    END;

    PROCEDURE LoanBalances@1000000017(phone@1000000000 : Text[20]) loanbalances : Text[500];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        //Vendor.SETRANGE(Vendor."Account Type", 'SALIMIA','STAFF');


      // IF (Vendor."Account Type"='SALIMIA') OR (Vendor."Account Type"='STAFF') OR (Vendor."Account Type"='SAVINGS')OR (Vendor."Account Type"='CHURCH')OR (Vendor."Account Type"='BUSINESS')OR (Vendor."Account Type"='COFFEE') THEN
        Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
        IF Vendor.FIND('-') THEN
          BEGIN
             accountsFOSA:='';
             REPEAT
               accountsFOSA:=':::'+Vendor."No.";
              LoansRegister.RESET;
                LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."BOSA Account No");

                IF LoansRegister.FIND('-') THEN BEGIN

                REPEAT

                  LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Interest Due",LoansRegister."Interest to be paid",LoansRegister."Interest Paid",LoansRegister."Oustanding Interest");
                  IF (LoansRegister."Outstanding Balance">0) THEN
                  loanbalances:= loanbalances + '::::' +LoansRegister."Loan  No." +':::'+ LoansRegister."Loan Product Type Name" + ':::'+
                   FORMAT(ROUND((LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"),1,'>'));
                   //  MESSAGE(FORMAT(inter));
                             UNTIL LoansRegister.NEXT = 0;
                END;
             UNTIL Vendor.NEXT =0;
          END
        ELSE
        BEGIN
           accountsFOSA:='';

                  END

        END;{
      BEGIN
            Vendor.SETRANGE(Vendor."Phone No.",phone)   ;
            IF Vendor.FIND('-') THEN BEGIN
                LoansRegister.RESET;
                LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."No.");
                IF LoansRegister.FIND('-') THEN BEGIN
                REPEAT
                  LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Interest Due",LoansRegister."Interest to be paid",LoansRegister."Interest Paid");
                  IF (LoansRegister."Outstanding Balance">0) THEN
                  loanbalances:= loanbalances + '::::' +LoansRegister."Loan  No." +':::'+ LoansRegister."Loan Product Type" + ':::'+
                   FORMAT(LoansRegister."Outstanding Balance") ;
                UNTIL LoansRegister.NEXT = 0;
                END;
            END;
       END;
       }
    END;

    PROCEDURE MemberAccounts@1000000000(phone@1000000000 : Text[20]) accounts : Text[700];
    BEGIN
       // bosaNo:=BOSAAccount(phone);
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
       // Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
        IF Vendor.FIND('-') THEN
          BEGIN
            bosaNo:=Vendor."BOSA Account No";
          END;

        Vendor.RESET;
        Vendor.SETRANGE(Vendor."BOSA Account No",bosaNo);
         Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
      IF Vendor.FIND('-') THEN BEGIN
             accounts:='';
             REPEAT
               accounts:=accounts+'::::'+Vendor."No."+':::'+AccountDescription(Vendor."Account Type");
             UNTIL Vendor.NEXT =0;
          END ELSE BEGIN
           accounts:='';
      END;

        //END;
    END;

    PROCEDURE SurePESARegistration@1000000002() memberdetails : Text[1000];
    BEGIN
      BEGIN
        SurePESAApplications.RESET;
        SurePESAApplications.SETASCENDING(SurePESAApplications."No.",TRUE);
        SurePESAApplications.SETRANGE(SurePESAApplications.SentToServer, FALSE);
      //SurePESAApplications.SETRANGE(SurePESAApplications.Status, SurePESAApplications.Status::Active);
        IF SurePESAApplications.FINDFIRST() THEN
          BEGIN
               memberdetails:=SurePESAApplications."Account No"+':::'+SurePESAApplications.Telephone+':::'+SurePESAApplications."ID No";

          END
        ELSE
        BEGIN
           memberdetails:='';
        END
        END;
    END;

    PROCEDURE UpdateSurePESARegistration@1000000029(accountNo@1000000000 : Text[30]) result : Text[10];
    BEGIN
      BEGIN
        SurePESAApplications.RESET;
        SurePESAApplications.SETRANGE(SurePESAApplications.SentToServer, FALSE);
        SurePESAApplications.SETRANGE(SurePESAApplications."Account No", accountNo);
        IF SurePESAApplications.FIND('-') THEN
          BEGIN
               SurePESAApplications.SentToServer:=TRUE;
               SurePESAApplications.MODIFY;
               result:='Modified';
          END
        ELSE
        BEGIN
           result:='Failed';
        END
        END;
    END;

    PROCEDURE CurrentShares@1000000110(phone@1000000000 : Text[20]) shares : Text[1000];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        IF Vendor.FIND('-') THEN BEGIN
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Vendor."BOSA Account No");
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");
            IF MemberLedgerEntry.FIND('-') THEN
              REPEAT
                  amount:=amount+MemberLedgerEntry.Amount;
                  shares:= FORMAT(amount,0,'<Precision,2:2><Integer><Decimals>');
                  UNTIL MemberLedgerEntry.NEXT =0;
              END;
          END;
    END;

    PROCEDURE BenevolentFund@1000000111(phone@1000000000 : Text[20]) shares : Text[50];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        IF Vendor.FIND('-') THEN BEGIN
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Vendor."BOSA Account No");
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"SchFee Shares");
            IF MemberLedgerEntry.FIND('-') THEN
              REPEAT
                  amount:=amount+MemberLedgerEntry.Amount;
                  shares:= FORMAT(amount,0,'<Precision,2:2><Integer><Decimals>');
                  UNTIL MemberLedgerEntry.NEXT =0;
              END;
          END;
    END;

    PROCEDURE FundsTransferFOSA@1000000007(accFrom@1000000000 : Text[20];accTo@1000000001 : Text[20];DocNumber@1000000002 : Text[30];amount@1000000003 : Decimal) result : Text[30];
    BEGIN
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          //MobileCharges:=Charges."Charge Amount";
          MobileCharges:=GetmobileCharges('TRANS');
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          ExcDuty:=(10/100)*(MobileCharges+SurePESACharge);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",accFrom);
          IF Vendor.FIND('-') THEN BEGIN
             AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
         //  TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
            TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");
            accountName1:=Vendor.Name;
          IF Vendor.GET(accTo) THEN BEGIN

                IF (TempBalance>amount+MobileCharges+SurePESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;
                      //end of deletion

                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MOBILETRAN';
                      GenBatches.Description:='SUREPESA Tranfers';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //DR ACC 1
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=accFrom;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=accFrom;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer';
                      GenJournalLine.Amount:=amount;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //Dr Transfer Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=accFrom;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=accFrom;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=MobileCharges + SurePESACharge ;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;


              //DR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=accFrom;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=accFrom;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Mobile Transfer';
                      GenJournalLine.Amount:=ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=ExxcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Mobile Transfer';
                      GenJournalLine.Amount:=ExcDuty*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Mobile Transactions Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=MobileChargesACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=MobileCharges*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR ACC2
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=accTo;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=accTo;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer from '+accFrom;
                      GenJournalLine.Amount:=-amount;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                      //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":=DocNumber;
                      SurePESATrans.Description:='Mobile Transfer';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=accFrom;
                      SurePESATrans."Account No2" :=accTo;
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Transfer to Fosa";
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                      result:='TRUE';

                      Vendor.RESET();
                      Vendor.SETRANGE(Vendor."No.",accTo);
                      IF Vendor.FIND('-') THEN BEGIN
                        accountName2:=Vendor.Name;
                      END;
                         msg:='You have transfered KES '+FORMAT(amount)+' from Account '+accountName1+' to '+accountName2+
                          ' .Thank you for your patronage.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                           msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' . Thank you for your patronage.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END;
              END
              ELSE BEGIN
                result:='ACC2INEXISTENT';
                           msg:='Your request has failed because the recipent account does not exist.'+
                          ' . Thank you for your patronage.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
              END;
          END
          ELSE BEGIN
            result:='ACCINEXISTENT';
                        result:='INSUFFICIENT';
                        msg:='Your request has failed because the recipent account does not exist.'+
                        ' . Thank you for using TELEPOST Sacco Mobile.';
                        SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
          END;
        END;
    END;

    PROCEDURE FundsTransferBOSA@1000000018(accFrom@1000000000 : Text[20];accTo@1000000001 : Text[20];DocNumber@1000000002 : Text[30];amount@1000000003 : Decimal) result : Text[30];
    BEGIN

      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN

      Members.RESET;
      Members.SETRANGE(Members."FOSA Account",accFrom);
      IF Members.FIND('-') THEN BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
         // MobileCharges:=Charges."Charge Amount";
         MobileCharges:=GetmobileCharges('TRANS');
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          ExcDuty:=(10/100)*(MobileCharges+SurePESACharge);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",accFrom);
          IF Vendor.FIND('-') THEN BEGIN
             AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           //TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
              TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");

          IF (accTo='Shares Capital') OR(accTo='Deposit Contribution') OR(accTo='Benevolent Fund')
            THEN BEGIN
                IF (TempBalance>amount+MobileCharges+SurePESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;
                      //end of deletion

                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MOBILETRAN';
                      GenBatches.Description:='SUREPESA Tranfers';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //DR ACC 1
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=accFrom;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=accFrom;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer';
                      GenJournalLine.Amount:=amount;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //Dr Transfer Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=accFrom;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=accFrom;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=MobileCharges + SurePESACharge ;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;


              //DR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=accFrom;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=accFrom;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Mobile Transfer';
                      GenJournalLine.Amount:=ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=ExxcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Mobile Transfer';
                      GenJournalLine.Amount:=ExcDuty*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Mobile Transactions Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=MobileChargesACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=MobileCharges*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR ACC2
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                      GenJournalLine."Account No.":=Members."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":='SUREPESA';
                      GenJournalLine."Posting Date":=TODAY;

                      IF accTo='Deposit Contribution' THEN BEGIN
                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
                      END;
                      IF accTo='Shares Capital' THEN BEGIN
                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Shares Capital";
                      END;
                      IF accTo='Benevolent Fund' THEN BEGIN
                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";

                      GenJournalLine.Description:='Mobile Transfer from '+accFrom;
                      END;
                      GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      GenJournalLine.Amount:=-amount;
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                      //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":=DocNumber;
                      SurePESATrans.Description:='Mobile Transfer';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=accFrom;
                      SurePESATrans."Account No2" :=accTo;
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Transfer to Fosa";
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                      result:='TRUE';

                         msg:='You have transfered KES '+FORMAT(amount)+' from Account '+Vendor.Name+' to '+accTo+
                          ' . Thank you for your patronage.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                           msg:='You have insufficient funds in your savings Account to use this service.'+
                          '. Thank you for your patronage.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END;
              END
              ELSE BEGIN
                result:='ACC2INEXISTENT';
                           msg:='Your request has failed because the recipent account does not exist.'+
                          '. Thank you for your patronage.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
              END;
          END
          ELSE BEGIN
            result:='ACCINEXISTENT';
                        result:='INSUFFICIENT';
                        msg:='Your request has failed because the recipent account does not exist.'+
                        '. Thank you for your patronage.';
                        SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
          END;
        END
        ELSE BEGIN
            result:='MEMBERINEXISTENT';
                      msg:='Your request has failed because the recipent account does not exist.'+
                      '. Thank you for your patronage.';
                      SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
        END;
        END;
    END;

    PROCEDURE WSSAccount@1000000014(phone@1000000000 : Text[20]) accounts : Text[250];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
      Vendor.SETRANGE(Vendor."Account Type",'ORDINARY');
        IF Vendor.FIND('-') THEN
          BEGIN
               accounts:=Vendor."No."+':::'+AccountDescription(Vendor."Account Type");
          END
        ELSE
        BEGIN
           accounts:='';
        END

        END;
    END;

    PROCEDURE SMSMessage@1000000051(documentNo@1000000000 : Text[30];accfrom@1000000001 : Text[30];phone@1000000002 : Text[20];message@1000000003 : Text[250]);
    BEGIN

          SMSMessages.RESET;
          IF SMSMessages.FIND('+') THEN BEGIN
          iEntryNo:=SMSMessages."Entry No";
          iEntryNo:=iEntryNo+1;
          END
          ELSE BEGIN
          iEntryNo:=1;
          END;
          SMSMessages.INIT;
          SMSMessages."Entry No":=iEntryNo;
          SMSMessages."Batch No":=documentNo;
          SMSMessages."Document No":=documentNo;
          SMSMessages."Account No":=accfrom;
          SMSMessages."Date Entered":=TODAY;
          SMSMessages."Time Entered":=TIME;
          SMSMessages.Source:='MOBILETRAN';
          SMSMessages."Entered By":=USERID;
          SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
          SMSMessages."SMS Message":=message;
          SMSMessages."Telephone No":=phone;
          IF SMSMessages."Telephone No"<>'' THEN
          SMSMessages.INSERT;
    END;

    PROCEDURE LoanRepayment@1000000015(accFrom@1000000000 : Text[20];loanNo@1000000001 : Text[20];DocNumber@1000000002 : Text[30];amount@1000000003 : Decimal) result : Text[30];
    VAR
      newloanAmt@1120054000 : Decimal;
    BEGIN

      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
        LoanAmt:=amount;

             Vendor.RESET;
              Vendor.SETRANGE(Vendor."No.",accFrom);
              IF Vendor.FIND('-') THEN BEGIN


            GenLedgerSetup.RESET;
            GenLedgerSetup.GET;
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

            Charges.RESET;
            Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
            IF Charges.FIND('-') THEN BEGIN
              Charges.TESTFIELD(Charges."GL Account");
             // MobileCharges:=Charges."Charge Amount";
             MobileCharges:=GetmobileCharges('LOANREP');
              MobileChargesACC:=Charges."GL Account";
            END;

              SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
              SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

              ExcDuty:=(20/100)*(MobileCharges+SurePESACharge);

              Members.RESET;
              Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
              IF Members.FIND('-') THEN BEGIN
                 AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
                   Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                  // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
                     TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");

                        LoansRegister.RESET;
                        LoansRegister.SETRANGE(LoansRegister."Loan  No.",loanNo);
                        LoansRegister.SETRANGE(LoansRegister."Client Code",Members."No.");

                     IF LoansRegister.FIND('+') THEN BEGIN
                        LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
                        IF (TempBalance>amount+MobileCharges+SurePESACharge) THEN BEGIN
                         IF LoansRegister."Outstanding Balance" > 50 THEN BEGIN
                                  GenJournalLine.RESET;
                                  GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                  GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                                  GenJournalLine.DELETEALL;
                                  //end of deletion

                                  GenBatches.RESET;
                                  GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                                  GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                                  IF GenBatches.FIND('-') = FALSE THEN BEGIN
                                  GenBatches.INIT;
                                  GenBatches."Journal Template Name":='GENERAL';
                                  GenBatches.Name:='MOBILETRAN';
                                  GenBatches.Description:='Mobile Loan Repayment';
                                  GenBatches.VALIDATE(GenBatches."Journal Template Name");
                                  GenBatches.VALIDATE(GenBatches.Name);
                                  GenBatches.INSERT;
                                  END;

                          //DR ACC 1
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                  GenJournalLine."Account No.":=accFrom;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=accFrom;
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Mobile Loan Repayment';
                                  GenJournalLine.Amount:=amount;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                          //Dr Transfer Charges
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                  GenJournalLine."Account No.":=accFrom;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=accFrom;
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Mobile Charges';
                                  GenJournalLine.Amount:=MobileCharges + SurePESACharge ;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;


                          //DR Excise Duty
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                  GenJournalLine."Account No.":=accFrom;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=accFrom;
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Excise duty-Mobile Charges';
                                  GenJournalLine.Amount:=ExcDuty;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                  GenJournalLine."Account No.":=ExxcDuty;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=MobileChargesACC;
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Excise duty-Mobile Charges';
                                  GenJournalLine.Amount:=ExcDuty*-1;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                          //CR Mobile Transactions Acc
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                  GenJournalLine."Account No.":=MobileChargesACC;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=MobileChargesACC;
                                   GenJournalLine."Source No.":=Vendor."No.";
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Mobile Charges';
                                  GenJournalLine.Amount:=MobileCharges*-1;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                          //CR Commission
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                  GenJournalLine."Account No.":=SurePESACommACC;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=MobileChargesACC;
                                   GenJournalLine."Source No.":=Vendor."No.";
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Mobile Charges';
                                  GenJournalLine.Amount:=-SurePESACharge;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                                  IF LoansRegister."Oustanding Interest">0 THEN BEGIN
                                  LineNo:=LineNo+10000;

                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                  GenJournalLine."Account No.":=LoansRegister."Client Code";
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":='';
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Loan Interest Payment';


                                  IF amount > LoansRegister."Oustanding Interest" THEN
                                  GenJournalLine.Amount:=-LoansRegister."Oustanding Interest"
                                  ELSE
                                  GenJournalLine.Amount:=-amount;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";

                                  IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                                  GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                  END;
                                  GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                                  amount:=amount+GenJournalLine.Amount;
                                  END;
                                  IF amount>0 THEN BEGIN
                                  LineNo:=LineNo+10000;

                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                  GenJournalLine."Account No.":=LoansRegister."Client Code";
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":='';
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Loan repayment';
                                  GenJournalLine.Amount:=-amount;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                  IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                                  GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                  END;
                                  GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;
                                  END;


                                  //Post
                                  GenJournalLine.RESET;
                                  GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                  GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                                  IF GenJournalLine.FIND('-') THEN BEGIN
                                  REPEAT
                                  GLPosting.RUN(GenJournalLine);
                                  UNTIL GenJournalLine.NEXT = 0;
                                  END;

                                  //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');
                                  GenJournalLine.RESET;
                                  GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                  GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                                  GenJournalLine.DELETEALL;

                                  SurePESATrans.INIT;
                                  SurePESATrans."Document No":=DocNumber;
                                  SurePESATrans.Description:='Mobile repayment';
                                  SurePESATrans."Document Date":=TODAY;
                                  SurePESATrans."Account No" :=accFrom;
                                  SurePESATrans."Account No2" :=loanNo;
                                  SurePESATrans.Amount:=amount;
                                  SurePESATrans.Posted:=TRUE;
                                  SurePESATrans."Posting Date":=TODAY;
                                  SurePESATrans.Status:=SurePESATrans.Status::Completed;
                                  SurePESATrans.Comments:='Success';
                                  SurePESATrans.Client:=Vendor."BOSA Account No";
                                  SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Transfer to Fosa";
                                  SurePESATrans."Transaction Time":=TIME;
                                  SurePESATrans.INSERT;
                                  result:='TRUE';


                                    LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
                                      newloanAmt:=ROUND((LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"),1,'>');

                                msg:='You have transfered KES '+FORMAT(LoanAmt)+' from Account '+Vendor.Name+' to '+LoansRegister."Loan Product Type Name"+
                                      ' Your new loan balance is Ksh .'+FORMAT(newloanAmt)+'. Thank you for your patronage.';
                                      SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                                END;
                               END
                               ELSE BEGIN
                               result:='INSUFFICIENT';
                                       msg:='You have insufficient funds in your savings Account to use this service.'+
                                      '. Thank you for your patronage.';
                                      SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                               END;
                      END
                      ELSE BEGIN
                        result:='ACC2INEXISTENT';
                                   msg:='Your request has failed because you do not have any outstanding balance.'+
                                  '. Thank you for your patronage.';
                                  SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                      END;
                END
                ELSE BEGIN
                  result:='ACCINEXISTENT';
                              msg:='Your request has failed.Please make sure you are registered for mobile banking.'+
                              '. Thank you for your patronage.';
                              SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                END;
            END
            ELSE BEGIN
                result:='MEMBERINEXISTENT';
                          msg:='Your request has failed because the recipent account does not exist.'+
                          '. Thank you for your patronage.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
            END;
        END
    END;

    PROCEDURE OutstandingLoans@1000000004(phone@1000000000 : Text[20]) loannos : Text[200];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
            IF Vendor.FIND('-') THEN BEGIN
              LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."BOSA Account No");
              IF LoansRegister.FIND('-') THEN BEGIN
              REPEAT
                LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest",LoansRegister."Interest to be paid",LoansRegister."Interest Paid");
                IF (LoansRegister."Outstanding Balance">0)OR(LoansRegister."Oustanding Interest">0) THEN
                loannos:= loannos + ':::' + LoansRegister."Loan  No.";
              UNTIL LoansRegister.NEXT = 0;
              END;
        END
      END;
    END;

    PROCEDURE LoanGuarantors@1000000013(loanNo@1000000000 : Text[20]) guarantors : Text[1000];
    BEGIN
      BEGIN
        LoanGuaranteeDetails.RESET;
        LoanGuaranteeDetails.SETRANGE(LoanGuaranteeDetails."Loan No",loanNo);
        IF LoanGuaranteeDetails.FIND('-') THEN BEGIN
          //LoanGuaranteeDetails.CALCFIELDS(LoanGuaranteeDetails."Loans Outstanding");
          REPEAT
             LoanGuaranteeDetails.CALCFIELDS(LoanGuaranteeDetails."Loans Outstanding");
              guarantors:=guarantors + '::::' + LoanGuaranteeDetails.Name+':::'+FORMAT(LoanGuaranteeDetails."Loans Outstanding");
          UNTIL LoanGuaranteeDetails.NEXT =0;
        END;
      END;
    END;

    PROCEDURE LoansGuaranteed@1000000046(phone@1000000000 : Text[20]) guarantors : Text[1000];
    BEGIN
      BEGIN
      Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        IF Vendor.FIND('-') THEN BEGIN
          bosaNo:=Vendor."No.";

          LoanGuaranteeDetails.RESET;
          LoanGuaranteeDetails.SETRANGE(LoanGuaranteeDetails."Staff/Payroll No.",Vendor."Staff No");
          IF LoanGuaranteeDetails.FIND('-') THEN BEGIN
            //LoanGuaranteeDetails.CALCFIELDS(LoanGuaranteeDetails."Amont Guaranteed");
            IF (LoanGuaranteeDetails."Amont Guaranteed">0) THEN BEGIN
            REPEAT
                guarantors:=guarantors + LoanGuaranteeDetails."Loan No"+':::'+FORMAT(LoanGuaranteeDetails."Amont Guaranteed")+'::::';
            UNTIL LoanGuaranteeDetails.NEXT =0;
            END;
          END;

      END;
      END;
    END;

    PROCEDURE ClientCodes@1000000052(loanNo@1000000000 : Text[20]) codes : Text[20];
    BEGIN
      BEGIN
        LoansRegister.RESET;
        LoansRegister.SETRANGE(LoansRegister."Loan  No.",loanNo);
        IF LoansRegister.FIND('-') THEN BEGIN
          codes:=LoansRegister."Client Code";
          END;
      END
    END;

    PROCEDURE ClientNames@1000000053(ccode@1000000000 : Text[20]) names : Text[100];
    BEGIN
      BEGIN
        LoansRegister.RESET;
        LoansRegister.SETRANGE(LoansRegister."Client Code",ccode);
        IF LoansRegister.FIND('-') THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE(Vendor."BOSA Account No",ccode);
            IF Vendor.FIND('-') THEN BEGIN
              names:=Vendor.Name;
            END;
          END;
      END
    END;

    PROCEDURE ChargesGuarantorInfo@1000000061(Phone@1000000000 : Text[20];DocNumber@1000000001 : Text[20]) result : Text[250];
    BEGIN
      BEGIN
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
        result :='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
      GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",Phone);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
          // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
             TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");
           fosaAcc:=Vendor."No.";

                IF (TempBalance>SurePESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;
                      //end of deletion

                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MOBILETRAN';
                      GenBatches.Description:='Loan Guarantors Info';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //Dr Mobile Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=fosaAcc;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=fosaAcc;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Loan Guarantors Info Charges';
                      GenJournalLine.Amount:=SurePESACharge ;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Loan Guarantors Info Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Post
                     GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                      //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":=DocNumber;
                      SurePESATrans.Description:='Loan Guarantors Info';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=Vendor."No.";
                      SurePESATrans."Account No2" :='';
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Status:=SurePESATrans.Status::Completed;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Ministatement;
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                      result:='TRUE';
                     END
                     ELSE BEGIN
                       result:='INSUFFICIENT';
                     END;
              END
              ELSE BEGIN
                result:='ACCNOTFOUND';
              END;
            END;
        END;
    END;

    PROCEDURE AccountBalanceNew@1000000009(Acc@1000000000 : Code[30];DocNumber@1000000001 : Code[20]) Bal : Text[50];
    BEGIN
      BEGIN
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        Bal:='REFEXISTS';
      END
      ELSE BEGIN
        Bal:='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          //MobileCharges:=Charges."Charge Amount";
          MobileCharges:=GetmobileCharges('ACCBAL');
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          ExcDuty:=(10/100)*(MobileCharges+SurePESACharge);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",Acc);
          IF Vendor.FIND('-') THEN BEGIN
             AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
        //   TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
           TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");

                IF (Vendor."Account Type"='ORDINARY') OR (Vendor."Account Type"='SCHOLAR')OR (Vendor."Account Type"='BUSINESS') OR (Vendor."Account Type"='STAFF')
                  OR (Vendor."Account Type"='COFFEE')OR (Vendor."Account Type"='SAVINGS')THEN
                BEGIN
                IF (TempBalance>MobileCharges+SurePESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;
                      //end of deletion

                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MOBILETRAN';
                      GenBatches.Description:='Balance Enquiry';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //Dr Mobile Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Acc;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Acc;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry';
                      GenJournalLine.Amount:=MobileCharges + SurePESACharge ;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //DR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Acc;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Acc;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Balance Enquiry';
                      GenJournalLine.Amount:=ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=ExxcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Balance Enquiry';
                      GenJournalLine.Amount:=ExcDuty*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Mobile Transactions Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=MobileChargesACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry Charges';
                      GenJournalLine.Amount:=MobileCharges*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                      //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":=DocNumber;
                      SurePESATrans.Description:='Balance Enquiry';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=Vendor."No.";
                      SurePESATrans."Account No2" :='';
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Status:=SurePESATrans.Status::Completed;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Balance;
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                      AccountTypes.RESET;
                      AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
                      IF AccountTypes.FIND('-') THEN
                      BEGIN
                        miniBalance:=AccountTypes."Minimum Balance";
                      END;
                      Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                      Vendor.CALCFIELDS(Vendor."ATM Transactions");
                      Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
                      Vendor.CALCFIELDS(Vendor."EFT Transactions");
                      accBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
                           msg:='Account Name: '+Vendor.Name+', '+'BALANCE: '+FORMAT(accBalance)+'. '
                          +'Thank you for your patronage';
                          SMSMessage(DocNumber,Vendor."No.",Vendor."Phone No.",msg);
                        Bal:='TRUE';
                      END
                     ELSE BEGIN
                       Bal:='INSUFFICIENT';
                     END;
                     END
                     ELSE BEGIN
                        AccountTypes.RESET;
                        AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
                        IF AccountTypes.FIND('-') THEN
                        BEGIN
                          miniBalance:=AccountTypes."Minimum Balance";
                        END;
                     END;
              END
              ELSE BEGIN
                Bal:='ACCNOTFOUND';
              END;
            END;
        END;
    END;

    PROCEDURE AccountBalanceDec@1000000033(Acc@1000000000 : Code[30];amt@1000000001 : Decimal) Bal : Decimal;
    BEGIN
        BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.", Acc);
        IF Vendor.FIND('-') THEN
         BEGIN

              Vendor.CALCFIELDS(Vendor."Balance (LCY)");
              Vendor.CALCFIELDS(Vendor."ATM Transactions");
              Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
              Vendor.CALCFIELDS(Vendor."EFT Transactions");
             // Bal:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);
                Bal:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");

              GenLedgerSetup.RESET;
              GenLedgerSetup.GET;
             GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

              Charges.RESET;
              Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
              IF Charges.FIND('-') THEN BEGIN
                Charges.TESTFIELD(Charges."GL Account");

                MPESACharge:=GetCharge(amt,'MPESA');
                SurePESACharge:=GetCharge(amt,'VENDWD');
                MobileCharges:=GetCharge(amt,'SACCOWD');

                ExcDuty:=(20/100)*(MobileCharges+SurePESACharge);
                TotalCharges:=SurePESACharge+MobileCharges+ExcDuty+MPESACharge;
                END;
                Bal:=Bal-TotalCharges;
         END
        END;
    END;

    LOCAL PROCEDURE GetCharge@1000000008(amount@1000000000 : Decimal;code@1000000001 : Text[20]) charge : Decimal;
    BEGIN
      TariffDetails.RESET;
      TariffDetails.SETRANGE(TariffDetails.Code,code);
      TariffDetails.SETFILTER(TariffDetails."Lower Limit",'<=%1',amount);
      TariffDetails.SETFILTER(TariffDetails."Upper Limit",'>=%1',amount);
      IF TariffDetails.FIND('-') THEN BEGIN
        charge:=TariffDetails."Charge Amount";
      END
    END;

    PROCEDURE PostMPESATrans@1000000027(docNo@1000000000 : Text[20];telephoneNo@1000000001 : Text[50];amount@1000000003 : Decimal;TransactionDate@1120054000 : Date) result : Text[30];
    BEGIN

      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", docNo);
      IF SurePESATrans.FIND('-') THEN BEGIN
        IF SurePESATrans.Posted =TRUE THEN
        result:='TRUE';
        IF SurePESATrans.Posted =FALSE THEN
        result:='REFEXISTS';
        EXIT;
      END
      ELSE BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."MPESA Recon Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");

          MPESACharge:=GetCharge(amount,'MPESA');
          SurePESACharge:=GetCharge(amount,'VENDWD');
          MobileCharges:=GetCharge(amount,'SACCOWD');

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          MPESARecon:='BNK00013';//GenLedgerSetup."MPESA Recon Acc";
          MobileChargesACC:=Charges."GL Account";

          ExcDuty:=(20/100)*(MobileCharges);
          TotalCharges:=SurePESACharge+MobileCharges;
        END;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.", telephoneNo);
       // IF  (Vendor."Account Type"='SALIMIA') OR (Vendor."Account Type"='STAFF') OR (Vendor."Account Type"='SAVINGS')OR (Vendor."Account Type"='CHURCH')OR (Vendor."Account Type"='BUSINESS')OR (Vendor."Account Type"='COFFEE') THEN BEGIN
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
          // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
             TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");

               IF (TempBalance<>0) THEN BEGIN
                      GenJournalLineTrans.RESET;
                      GenJournalLineTrans.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLineTrans.SETRANGE("Journal Batch Name",'MPESAWITHD');
                      GenJournalLineTrans.DELETEALL;
                      //end of deletion


                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MPESAWITHD');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MPESAWITHD';
                      GenBatches.Description:='MPESA Withdrawal';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //DR Customer Acc
                      LineNo:=LineNo+10000;
                      GenJournalLineTrans.INIT;
                      GenJournalLineTrans."Journal Template Name":='GENERAL';
                      GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                      GenJournalLineTrans."Line No.":=LineNo;
                      GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::Vendor;
                      GenJournalLineTrans."Account No.":=Vendor."No.";
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                      GenJournalLineTrans."Document No.":=docNo;
                      GenJournalLineTrans."External Document No.":=Vendor."No.";
                      GenJournalLineTrans."Posting Date":=TransactionDate;
                      GenJournalLineTrans.Description:='MPESA Withdrawal';
                      GenJournalLineTrans.Amount:=amount;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;

              //Dr Withdrawal Charges
                      LineNo:=LineNo+10000;
                      GenJournalLineTrans.INIT;
                      GenJournalLineTrans."Journal Template Name":='GENERAL';
                      GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                      GenJournalLineTrans."Line No.":=LineNo;
                      GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::Vendor;
                      GenJournalLineTrans."Account No.":=Vendor."No.";
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                      GenJournalLineTrans."Document No.":=docNo;
                      GenJournalLineTrans."External Document No.":=Vendor."No.";
                      GenJournalLineTrans."Posting Date":=TransactionDate;
                      GenJournalLineTrans.Description:='Mobile Withdrawal Charges';
                      GenJournalLineTrans.Amount:=TotalCharges;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;

              //Dr MPESA Charges
                      LineNo:=LineNo+10000;
                      GenJournalLineTrans.INIT;
                      GenJournalLineTrans."Journal Template Name":='GENERAL';
                      GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                      GenJournalLineTrans."Line No.":=LineNo;
                      GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::Vendor;
                      GenJournalLineTrans."Account No.":=Vendor."No.";
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                      GenJournalLineTrans."Document No.":=docNo;
                      GenJournalLineTrans."External Document No.":=Vendor."No.";
                      GenJournalLineTrans."Posting Date":=TransactionDate;
                      GenJournalLineTrans.Description:='MPESA Withdrawal Charges';
                      GenJournalLineTrans.Amount:=MPESACharge;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;

              //Cr MPESA ACC
                      LineNo:=LineNo+10000;
                      GenJournalLineTrans.INIT;
                      GenJournalLineTrans."Journal Template Name":='GENERAL';
                      GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                      GenJournalLineTrans."Line No.":=LineNo;
                      GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::"Bank Account";
                      GenJournalLineTrans."Account No.":=MPESARecon;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                      GenJournalLineTrans."Document No.":=docNo;
                      GenJournalLineTrans."External Document No.":=Vendor."No.";
                      GenJournalLineTrans."Source No.":=Vendor."No.";
                      GenJournalLineTrans."Posting Date":=TransactionDate;
                      GenJournalLineTrans.Description:='Withdrawal to MPESA';
                      GenJournalLineTrans.Amount:=(amount)*-1;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;
                 //Cr MPESA ACC
                      LineNo:=LineNo+10000;
                      GenJournalLineTrans.INIT;
                      GenJournalLineTrans."Journal Template Name":='GENERAL';
                      GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                      GenJournalLineTrans."Line No.":=LineNo;
                      GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::"Bank Account";
                      GenJournalLineTrans."Account No.":=MPESARecon;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                      GenJournalLineTrans."Document No.":=docNo;
                      GenJournalLineTrans."External Document No.":=Vendor."No.";
                      GenJournalLineTrans."Source No.":=Vendor."No.";
                      GenJournalLineTrans."Posting Date":=TransactionDate;
                      GenJournalLineTrans.Description:='MPESA Withdrawal Charges';
                      GenJournalLineTrans.Amount:=(MPESACharge)*-1;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;
                //DR Excise Duty
                      LineNo:=LineNo+10000;
                     GenJournalLineTrans.INIT;
                     GenJournalLineTrans."Journal Template Name":='GENERAL';
                     GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                     GenJournalLineTrans."Line No.":=LineNo;
                     GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::Vendor;
                     GenJournalLineTrans."Account No.":=Vendor."No.";
                     GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                     GenJournalLineTrans."Document No.":=docNo;
                     GenJournalLineTrans."External Document No.":=Vendor."No.";
                     GenJournalLineTrans."Posting Date":=TransactionDate;
                     GenJournalLineTrans.Description:='Excise duty-Mobile Withdrawal';
                     GenJournalLineTrans.Amount:=ExcDuty;
                     GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;

              //CR Excise Duty
                      LineNo:=LineNo+10000;
                     GenJournalLineTrans.INIT;
                     GenJournalLineTrans."Journal Template Name":='GENERAL';
                     GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                     GenJournalLineTrans."Line No.":=LineNo;
                     GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::"G/L Account";
                     GenJournalLineTrans."Account No.":=FORMAT(ExxcDuty);
                     GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                     GenJournalLineTrans."Document No.":=docNo;
                     GenJournalLineTrans."External Document No.":=MobileChargesACC;
                     GenJournalLineTrans."Source No.":=Vendor."No.";
                     GenJournalLineTrans."Posting Date":=TransactionDate;
                     GenJournalLineTrans.Description:='Excise duty-Mobile Withdrawal';
                     GenJournalLineTrans.Amount:=ExcDuty*-1;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;

              //CR Mobile Transactions Acc
                      LineNo:=LineNo+10000;
                      GenJournalLineTrans.INIT;
                      GenJournalLineTrans."Journal Template Name":='GENERAL';
                      GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                      GenJournalLineTrans."Line No.":=LineNo;
                      GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::"G/L Account";
                      GenJournalLineTrans."Account No.":=MobileChargesACC;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                      GenJournalLineTrans."Document No.":=docNo;
                      GenJournalLineTrans."External Document No.":=MobileChargesACC;
                      GenJournalLineTrans."Source No.":=Vendor."No.";
                      GenJournalLineTrans."Posting Date":=TransactionDate;
                      GenJournalLineTrans.Description:='Mobile Withdrawal Charges';
                      GenJournalLineTrans.Amount:=MobileCharges*-1;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;

              //CR Surestep Acc
                      LineNo:=LineNo+10000;
                      GenJournalLineTrans.INIT;
                      GenJournalLineTrans."Journal Template Name":='GENERAL';
                      GenJournalLineTrans."Journal Batch Name":='MPESAWITHD';
                      GenJournalLineTrans."Line No.":=LineNo;
                      GenJournalLineTrans."Account Type":=GenJournalLineTrans."Account Type"::"G/L Account";
                      GenJournalLineTrans."Account No.":=SurePESACommACC;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans."Account No.");
                      GenJournalLineTrans."Document No.":=docNo;
                      GenJournalLineTrans."External Document No.":=MobileChargesACC;
                      GenJournalLineTrans."Source No.":=Vendor."No.";
                      GenJournalLineTrans."Posting Date":=TransactionDate;
                      GenJournalLineTrans.Description:='Mobile Withdrawal Charges';
                      GenJournalLineTrans.Amount:=-SurePESACharge;
                      GenJournalLineTrans.VALIDATE(GenJournalLineTrans.Amount);
                      IF GenJournalLineTrans.Amount<>0 THEN
                      GenJournalLineTrans.INSERT;

                      //Post
                      GenJournalLineTrans.RESET;
                      GenJournalLineTrans.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLineTrans.SETRANGE("Journal Batch Name",'MPESAWITHD');
                      IF GenJournalLineTrans.FIND('-') THEN BEGIN
                     // REPEAT
                     // GLPosting.RUN(GenJournalLine);
                     // UNTIL GenJournalLine.NEXT = 0;

                      TrCodeunit.RunPostingGenJnl(GenJournalLineTrans,'GENERAL','MPESAWITHD');

                      GenJournalLineTrans.RESET;
                      GenJournalLineTrans.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLineTrans.SETRANGE("Journal Batch Name",'MPESAWITHD');
                      GenJournalLineTrans.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":=docNo;
                      SurePESATrans.Description:='MPESA Withdrawal';
                      SurePESATrans."Document Date":=TransactionDate;
                      SurePESATrans."Account No" :=Vendor."No.";
                      SurePESATrans."Account No2" :=MPESARecon;
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Status:=SurePESATrans.Status::Completed;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TransactionDate;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Withdrawal;
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                      result:='TRUE';
                     msg:='You have withdrawn KES '+FORMAT(amount)+' from Account '+Vendor.Name+ ' MPESA REF:'+docNo+' . Thank you for your patronage.';
                      SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);
                      EXIT;
                      END;
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                          { msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' .Thank you for using TELEPOST Sacco Mobile.';
                          SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);}
                            SurePESATrans.INIT;
                            SurePESATrans."Document No":=docNo;
                            SurePESATrans.Description:='MPESA Withdrawal';
                            SurePESATrans."Document Date":=TransactionDate;
                            SurePESATrans."Account No" :=Vendor."No.";
                            SurePESATrans."Account No2" :=MPESARecon;
                            SurePESATrans.Amount:=amount;
                            SurePESATrans.Status:=SurePESATrans.Status::Failed;
                            SurePESATrans.Posted:=FALSE;
                            SurePESATrans."Posting Date":=TransactionDate;
                            SurePESATrans.Comments:='Failed,Insufficient Funds';
                            SurePESATrans.Client:=Vendor."BOSA Account No";
                            SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Withdrawal;
                            SurePESATrans."Transaction Time":=TIME;
                            SurePESATrans.INSERT;
                   END;
             END
              ELSE BEGIN
                result:='ACCINEXISTENT';
                           { msg:='Your request has failed because account does not exist.'+
                            ' .Thank you for using TELEPOST Sacco Mobile.';
                            SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);}
                            SurePESATrans.INIT;
                            SurePESATrans."Document No":=docNo;
                            SurePESATrans.Description:='MPESA Withdrawal';
                            SurePESATrans."Document Date":=TransactionDate;
                            SurePESATrans."Account No" :='';
                            SurePESATrans."Account No2" :=MPESARecon;
                            SurePESATrans.Amount:=amount;
                            SurePESATrans.Posted:=FALSE;
                            SurePESATrans."Posting Date":=TransactionDate;
                            SurePESATrans.Comments:='Failed,Invalid Account';
                            SurePESATrans.Client:='';
                            SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Withdrawal;
                            SurePESATrans."Transaction Time":=TIME;
                            SurePESATrans.INSERT;
              END;
        END;

    END;

    PROCEDURE AccountDescription@1000000021(code@1000000000 : Text[20]) description : Text[100];
    BEGIN
      BEGIN
        AccountTypes.RESET;
        AccountTypes.SETRANGE(AccountTypes.Code,code);
        IF AccountTypes.FIND('-') THEN
          BEGIN
               description:=AccountTypes.Description;
          END
        ELSE
        BEGIN
           description:='';
        END
        END;
    END;

    PROCEDURE InsertTransaction@1000000011("Document No"@1000000000 : Code[30];Keyword@1000000001 : Code[30];"Account No"@1000000002 : Code[30];"Account Name"@1000000003 : Text[100];Telephone@1000000004 : Code[20];Amount@1000000005 : Decimal;"Sacco Bal"@1000000006 : Decimal;TransactionDate@1120054000 : Date) Result : Code[20];
    BEGIN
      BEGIN
            BEGIN
              PaybillTrans.INIT;
              PaybillTrans."Document No":="Document No";
              PaybillTrans."Key Word":=Keyword;
              PaybillTrans."Account No":=Keyword+"Account No";
              PaybillTrans."Account Name":="Account Name";
              PaybillTrans."Transaction Date":=TODAY;
              PaybillTrans."Paybill Acc Balance":="Sacco Bal";
              PaybillTrans."Transaction Time":=TODAY;
              PaybillTrans.Description:='PayBill Deposit';
              PaybillTrans.Telephone:=Telephone;
              PaybillTrans.Amount:=Amount;
              PaybillTrans.Posted:=FALSE;
              PaybillTrans.INSERT;
              END;
                PaybillTrans.RESET;
                PaybillTrans.SETRANGE(PaybillTrans."Document No","Document No");
              IF PaybillTrans.FIND('-') THEN BEGIN
                Result:='TRUE';
              END
              ELSE BEGIN
                Result:='FALSE';
              END;
          END;
    END;

    PROCEDURE PaybillSwitch@1000000022() Result : Code[20];
    BEGIN

      //CloudPESASMS.ChargeSMS;
       PaybillTrans.RESET;
       PaybillTrans.SETRANGE(PaybillTrans.Posted,FALSE);
       PaybillTrans.SETRANGE(PaybillTrans."Needs Manual Posting",FALSE);

      IF PaybillTrans.FIND('-') THEN BEGIN
      //Result:=PayBillToAcc('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'WSS');
       Vendor.RESET;
       Vendor.SETRANGE(Vendor."No.",PaybillTrans."Account No");
       IF Vendor.FIND('-') THEN BEGIN
            Result:=PayBillToAccAPI('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'ORDINARY');
         END ELSE BEGIN
          LoansRegister.RESET;
           LoansRegister.SETRANGE(LoansRegister."Loan  No.", PaybillTrans."Account No");
           IF LoansRegister.FIND('-') THEN BEGIN
          Result:=PayBillToLoanAPI('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'L01');
      END ELSE BEGIN
        IF (PaybillTrans."Account No"='SHARE CAPITAL') OR (PaybillTrans."Account No"='DEPOSIT CONTRIBUTION') OR (PaybillTrans."Account No"='INSURANCE') THEN BEGIN
                Result:=PayBillToBOSAAPI('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,PaybillTrans."Key Word",'PayBill to Deposit');


        END ELSE BEGIN

       CASE PaybillTrans."Key Word" OF
         'CD':
            Result:=PayBillToAcc('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'ORDINARY');
        'SH':
            Result:=PayBillToBOSA('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,PaybillTrans."Key Word",'PayBill to School deposit');
         'NS':
            Result:=PayBillToBOSA('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,PaybillTrans."Key Word",'PayBill to Deposit');
         'BVF':
            Result:=PayBillToBOSA('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,PaybillTrans."Key Word",'PayBill to Benevolent Fund');
         'NL':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'L01');
          'EM':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'L02');
      'ES':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'L04');
      'IS':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'A02');
      'OK':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'A07');
      'SL':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'A01');
      'RP':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'A10');
      'FD':
          Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'A04');



       END;
       IF Result='' THEN BEGIN
               PaybillTrans."Date Posted":=TODAY;
                  PaybillTrans."Needs Manual Posting":=TRUE;
                  PaybillTrans.Description:='Failed';
                  PaybillTrans.MODIFY;
         END;
         END;
         END;
         END;
         END;
    END;

    LOCAL PROCEDURE PayBillToAcc@1000000062(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];Amount@1000000004 : Decimal;accountType@1000000005 : Code[30]) res : Code[10];
    BEGIN
      GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Paybill acc");
         PaybillRecon:=GenLedgerSetup."Paybill acc";
        SurePESACharge:=GetCharge(Amount,'PAYBILL');
         SurePESACommACC:=GenLedgerSetup."CloudPESA Comm Acc";
          ExcDuty:=(10/100)*(SurePESACharge);

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
        GenJournalLine.SETRANGE("Journal Batch Name",batch);
        GenJournalLine.DELETEALL;
        //end of deletion

        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
        GenBatches.SETRANGE(GenBatches.Name,batch);

        IF GenBatches.FIND('-') = FALSE THEN BEGIN
          GenBatches.INIT;
          GenBatches."Journal Template Name":='GENERAL';
          GenBatches.Name:=batch;
          GenBatches.Description:='Paybill Deposit';
          GenBatches.VALIDATE(GenBatches."Journal Template Name");
          GenBatches.VALIDATE(GenBatches.Name);
          GenBatches.INSERT;
        END;//General Jnr Batches

          Members.RESET;
          Members.SETRANGE(Members."ID No.", accNo);
         IF Members.FIND('-') THEN BEGIN
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", Members."FOSA Account");
          //Vendor.SETRANGE(Vendor."Account Type", accountType);
          Vendor.SETFILTER(Vendor.Blocked ,'=%1',Vendor.Blocked::" ");
            IF Vendor.FIND('-') THEN BEGIN

            //Dr MPESA PAybill ACC
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
              GenJournalLine."Account No.":=PaybillRecon;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Source No.":=Vendor."No.";
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Deposit';
              GenJournalLine.Amount:=Amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

            //Cr Customer
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
              GenJournalLine."Account No.":=Vendor."No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Deposit';
              GenJournalLine.Amount:=-1*Amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

                  //Dr Customer charges
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
              GenJournalLine."Account No.":=Vendor."No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Deposit Charges';
              GenJournalLine.Amount:=SurePESACharge;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;
             //DR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":=batch;
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=docNo;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Paybill Deposit';
                      GenJournalLine.Amount:=ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;


              //CR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":=batch;
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=FORMAT(ExxcDuty);
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Paybill deposit';
                      GenJournalLine.Amount:=ExcDuty*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;
       //CR Surestep Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":=batch;
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Deposit Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;
               END;
               //Vendor
              END;//Member

              //Post
              GenJournalLine.RESET;
              GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
              GenJournalLine.SETRANGE("Journal Batch Name",batch);
              IF GenJournalLine.FIND('-') THEN BEGIN
              REPEAT
                GLPosting.RUN(GenJournalLine);
              UNTIL GenJournalLine.NEXT = 0;

              //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
              PaybillTrans.Posted:=TRUE;
                      PaybillTrans."Date Posted":=TODAY;
                      PaybillTrans.Description:='Posted';
                      PaybillTrans.MODIFY;
                      res:='TRUE';
                       msg:='Dear ' +Members.Name+' your have deposited  Ksh. '+ FORMAT(Amount) +' to '+PaybillTrans."Account No"+' MPESA Receipt No. '+docNo +' Thank you for your patronage';
                  SMSMessage('PAYBILLTRANS',Members."No.",Members."Phone No.",msg);
              END
              ELSE BEGIN
                PaybillTrans."Date Posted":=TODAY;
                      PaybillTrans."Needs Manual Posting":=TRUE;
                      PaybillTrans.Description:='Failed';
                      PaybillTrans.MODIFY;
                      res:='FALSE';
              END;
    END;

    LOCAL PROCEDURE PayBillToBOSA@1000000080(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];amount@1000000004 : Decimal;type@1000000005 : Code[30];descr@1000000006 : Text[100]) res : Code[10];
    BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Paybill acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge:=0;//GenLedgerSetup."CloudPESA Charge";
        PaybillRecon:=GenLedgerSetup."Paybill acc";

        ExcDuty:=(10/100)*SurePESACharge;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
        GenJournalLine.SETRANGE("Journal Batch Name",batch);
        GenJournalLine.DELETEALL;
        //end of deletion

        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
        GenBatches.SETRANGE(GenBatches.Name,batch);

        IF GenBatches.FIND('-') = FALSE THEN BEGIN
          GenBatches.INIT;
          GenBatches."Journal Template Name":='GENERAL';
          GenBatches.Name:=batch;
          GenBatches.Description:=descr;
          GenBatches.VALIDATE(GenBatches."Journal Template Name");
          GenBatches.VALIDATE(GenBatches.Name);
          GenBatches.INSERT;
        END;//General Jnr Batches

          Members.RESET;
          Members.SETRANGE(Members."ID No.",accNo);
          IF Members.FIND('-') THEN BEGIN
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", Members."FOSA Account");
          //Vendor.SETRANGE(Vendor."Account Type", fosaConst);
            IF Vendor.FINDFIRST THEN BEGIN

            //Dr MPESA PAybill ACC
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
              GenJournalLine."Account No.":=PaybillRecon;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:=descr;
              GenJournalLine.Amount:=amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

            //Cr Customer
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
              GenJournalLine."Account No.":=Members."No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              CASE PaybillTrans."Key Word" OF 'NS':
                  GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
              END;
              CASE PaybillTrans."Key Word" OF 'SH':
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"SchFee Shares"
              END;
              CASE PaybillTrans."Key Word" OF 'BVF':
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";
              END;
              GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
              GenJournalLine.Description:=descr;
              GenJournalLine.Amount:=(amount-SurePESACharge-ExcDuty)*-1;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              //CR Excise Duty
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
              GenJournalLine."Account No.":=FORMAT(ExxcDuty);
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Excise duty-'+descr;
              GenJournalLine.Amount:=ExcDuty*-1;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              //CR Surestep Acc
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
              GenJournalLine."Account No.":=SurePESACommACC;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:=descr+' Charges';
              GenJournalLine.Amount:=-SurePESACharge;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;
               END;//Vendor
              END;//Member

              //Post
              GenJournalLine.RESET;
              GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
              GenJournalLine.SETRANGE("Journal Batch Name",batch);
              IF GenJournalLine.FIND('-') THEN BEGIN
              REPEAT
                GLPosting.RUN(GenJournalLine);
              UNTIL GenJournalLine.NEXT = 0;

              //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
                PaybillTrans.Posted:=TRUE;
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans.Description:='Posted';
                PaybillTrans.MODIFY;
                res:='TRUE';
                 msg:='Dear ' +Members.Name+' your have deposited  Ksh. '+ FORMAT(amount) +' to '+PaybillTrans."Account No"+' MPESA Receipt No. '+docNo +' Thank you for Telepost sacco mobile';
                  SMSMessage('PAYBILLTRANS',Members."No.",Members."Phone No.",msg);

              END
              ELSE BEGIN
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans."Needs Manual Posting":=TRUE;
                PaybillTrans.Description:='Failed';
                PaybillTrans.MODIFY;
                res:='FALSE';
              END;
    END;

    LOCAL PROCEDURE PayBillToLoan@1000000081(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];amount@1000000004 : Decimal;type@1000000005 : Code[30]) res : Code[10];
    BEGIN
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Paybill acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge:=0;//GenLedgerSetup."CloudPESA Charge";
        PaybillRecon:=GenLedgerSetup."Paybill acc";

        ExcDuty:=(10/100)*SurePESACharge;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
        GenJournalLine.SETRANGE("Journal Batch Name",batch);
        GenJournalLine.DELETEALL;
        //end of deletion

        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
        GenBatches.SETRANGE(GenBatches.Name,batch);

        IF GenBatches.FIND('-') = FALSE THEN BEGIN
          GenBatches.INIT;
          GenBatches."Journal Template Name":='GENERAL';
          GenBatches.Name:=batch;
          GenBatches.Description:='Paybill Loan Repayment';
          GenBatches.VALIDATE(GenBatches."Journal Template Name");
          GenBatches.VALIDATE(GenBatches.Name);
          GenBatches.INSERT;
        END;//General Jnr Batches

          Members.RESET;
          Members.SETRANGE(Members."ID No.", accNo);
          IF Members.FIND('-') THEN BEGIN
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", Members."FOSA Account");
       //   Vendor.SETRANGE(Vendor."Account Type", fosaConst);
            IF Vendor.FINDFIRST THEN BEGIN

              LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Loan Product Type",type);
              LoansRegister.SETRANGE(LoansRegister."Client Code",Members."No.");

              IF LoansRegister.FIND('+') THEN BEGIN
              LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
             IF LoansRegister."Outstanding Balance" > 50 THEN BEGIN

            //Dr MPESA PAybill ACC
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
              GenJournalLine."Account No.":=PaybillRecon;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Loan Repayment';
              GenJournalLine.Amount:=amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              IF LoansRegister."Oustanding Interest">0 THEN BEGIN
              LineNo:=LineNo+10000;

              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
              GenJournalLine."Account No.":=LoansRegister."Client Code";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Loan Interest Payment';
              END;

              IF amount > LoansRegister."Oustanding Interest" THEN
              GenJournalLine.Amount:=-LoansRegister."Oustanding Interest"
              ELSE
              GenJournalLine.Amount:=-amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";

              IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
              GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
              END;
              GenJournalLine."Loan No":=LoansRegister."Loan  No.";
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              amount:=amount+GenJournalLine.Amount;

              IF amount>0 THEN BEGIN
              LineNo:=LineNo+10000;

              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
              GenJournalLine."Account No.":=LoansRegister."Client Code";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":='';
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Loan Repayment';
              GenJournalLine.Amount:=-amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
              IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
              GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
              END;
              GenJournalLine."Loan No":=LoansRegister."Loan  No.";
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;
              END;

              //DR Cust Acc
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
              GenJournalLine."Account No.":=Vendor."No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Loan Repayment Cha';
              GenJournalLine.Amount:=SurePESACharge+ExcDuty;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              //CR Excise Duty
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
              GenJournalLine."Account No.":=FORMAT(ExxcDuty);
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Excise duty-'+'Paybill Loan Repayment';
              GenJournalLine.Amount:=ExcDuty*-1;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              //CR Surestep Acc
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
              GenJournalLine."Account No.":=SurePESACommACC;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Loan Repayment'+' Charges';
              GenJournalLine.Amount:=-SurePESACharge;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;
                  END//Outstanding Balance
                 END//Loan Register
               END;//Vendor
              END;//Member

              //Post
              GenJournalLine.RESET;
              GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
              GenJournalLine.SETRANGE("Journal Batch Name",batch);
              IF GenJournalLine.FIND('-') THEN BEGIN
              REPEAT
                GLPosting.RUN(GenJournalLine);
              UNTIL GenJournalLine.NEXT = 0;

             // TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
                PaybillTrans.Posted:=TRUE;
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans.Description:='Posted';
                PaybillTrans.MODIFY;
                res:='TRUE';

       msg:='Dear ' +Members.Name+' your have deposited  Ksh. '+ FORMAT(amount) +' to '+LoansRegister."Loan Product Type Name"+' MPESA Receipt No. '+docNo +' Thank you for Telepost sacco mobile';
                  SMSMessage('PAYBILLTRANS',Members."No.",Members."Phone No.",msg);
              END
              ELSE BEGIN
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans."Needs Manual Posting":=TRUE;
                PaybillTrans.Description:='Failed';
                PaybillTrans.MODIFY;
                res:='FALSE';
              END;
    END;

    PROCEDURE Loancalculator@1000000016() calcdetails : Text;
    VAR
      varLoan@1000000000 : Text[1023];
      LoanProducttype@1000000001 : Record 51516240;
    BEGIN
      BEGIN

      LoanProducttype.RESET;
          //LoanProducttype.GET();
      LoanProducttype.SETRANGE(LoanProducttype.Source,LoanProducttype.Source::BOSA);
           IF LoanProducttype.FIND('-') THEN BEGIN
              //  LoanProducttype.CALCFIELDS(LoanProducttype."Interest rate",LoanProducttype."Max. Loan Amount",LoanProducttype."Min. Loan Amount");

                REPEAT
                  interestRate:=LoanProducttype."Interest rate" DIV 1;
         varLoan := varLoan + '::::'+FORMAT( LoanProducttype."Product Description") +':::' +FORMAT(interestRate) +':::' + FORMAT(LoanProducttype."No of Installment")+':::' + FORMAT(LoanProducttype."Max. Loan Amount");

                UNTIL LoanProducttype.NEXT = 0;
                //MESSAGE('Loan Balance %1',loanbalances);
                calcdetails:=varLoan;

            END;
       END;
    END;

    PROCEDURE SharesUSSD@1000000026(phone@1000000000 : Text[20];DocNo@1000000001 : Text[50]) shares : Text[1000];
    VAR
      normalshares@1000000002 : Text[50];
      sharecapital@1000000003 : Text[50];
    BEGIN
       BEGIN
              Vendor.RESET;
              Vendor.SETRANGE(Vendor."Phone No.",phone);
              IF Vendor.FIND('-') THEN BEGIN
                  MemberLedgerEntry.RESET;
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Vendor."BOSA Account No");
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Shares Capital");
                  IF MemberLedgerEntry.FIND('-') THEN BEGIN
                    REPEAT
                        amount:=amount+MemberLedgerEntry.Amount;
                        sharecapital:= FORMAT(amount,0,'<Precision,2:2><Integer><Decimals>');
                        UNTIL MemberLedgerEntry.NEXT =0;
                    END;

                  MemberLedgerEntry.RESET;
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Vendor."BOSA Account No");
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");

                  IF MemberLedgerEntry.FIND('-') THEN BEGIN
                    amount:=0;
                    REPEAT
                        amount:=amount+MemberLedgerEntry.Amount;
                        normalshares:= FORMAT(amount,0,'<Precision,2:2><Integer><Decimals>');
                        UNTIL MemberLedgerEntry.NEXT =0;
                  END;
                  shares:='Share Capital - KSH '+sharecapital+' , Normal Shares - KSH '+normalshares;
                  SMSMessage('MOBILETRAN',Vendor."No.",Vendor."Phone No.",shares);
                // GenericCharges(phone,DocNo,'Shares Balance Request');
                END;
          END;
    END;

    PROCEDURE GenericCharges@1000000036(Phone@1000000000 : Text[50];Description@1000000001 : Text[50];DocNumber@1000000002 : Text[50]) result : Text[250];
    BEGIN
    END;

    LOCAL PROCEDURE GetmobileCharges@1000000023(code@1000000000 : Code[30]) charge : Decimal;
    VAR
      MobileTariffs@1000000001 : Record 51516062;
    BEGIN
      MobileTariffs.RESET;
      MobileTariffs.SETRANGE(MobileTariffs.Code,code);
      //MobileTariffs.SETFILTER(MobileTariffs."Charge amount",'<=%1',amount);
      IF MobileTariffs.FIND('-') THEN BEGIN
        charge:=MobileTariffs."Charge amount";
      END
    END;

    PROCEDURE AdvanceEligibility@1120054012(account@1000000000 : Text[50];Period@1120054020 : Decimal) amount : Decimal;
    VAR
      StoDedAmount@1000000001 : Decimal;
      STO@1000000002 : Record 51516307;
      FOSALoanRepayAmount@1000000003 : Decimal;
      CumulativeNet@1000000004 : Decimal;
      LastSalaryDate@1000000006 : Date;
      FirstSalaryDate@1000000007 : Date;
      AvarageNetPay@1000000008 : Decimal;
      AdvQualificationAmount@1000000009 : Decimal;
      CumulativeNet2@1000000010 : Decimal;
      finalAmount@1000000011 : Decimal;
      interestAMT@1000000012 : Decimal;
      MaxLoanAmt@1120054000 : Decimal;
      LastPaydate@1120054008 : Date;
      MPayDate@1120054007 : Decimal;
      MToday@1120054006 : Decimal;
      DateRegistered@1120054005 : Date;
      MtodayYear@1120054004 : Decimal;
      RegYear@1120054003 : Decimal;
      MtodayDiff@1120054002 : Decimal;
      MRegdate@1120054001 : Decimal;
      ComittedShares@1120054009 : Decimal;
      LoanGuarantors@1120054010 : Record 51516231;
      FreeShares@1120054011 : Decimal;
      TotalAmount@1120054015 : Decimal;
      TransactionLoanAmt@1120054014 : Decimal;
      TransactionLoanDiff@1120054013 : Decimal;
      RepayedLoanAmt@1120054012 : Decimal;
      LoanRepaymentS@1120054016 : Record 51516234;
      Fulldate@1120054018 : Date;
      LastRepayDate@1120054017 : Date;
      PrincipalAmount@1120054019 : Decimal;
      Mrecomended@1120054021 : Decimal;
      Mpenalty@1120054022 : Decimal;
      MobileLoan@1120054023 : Record 51516094;
      NoOFcountsAmont@1120054024 : Decimal;
    BEGIN


      //=================================================must be member for 6 months
      Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",account);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
      Vendor.SETRANGE(Vendor."Account Type",'ORDINARY');
        IF Vendor.FIND('-')=TRUE THEN BEGIN


      Members.RESET;
      Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
      IF Members.FIND('-') THEN BEGIN
        DateRegistered:=Members."Registration Date";
      END;

      MemberLedgerEntry.RESET;
      MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
      MemberLedgerEntry.SETFILTER(MemberLedgerEntry."Posting Date",FORMAT(CALCDATE('CM',CALCDATE('-8M',TODAY)))+'..'+FORMAT(TODAY));
      MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");
      MemberLedgerEntry.SETFILTER(MemberLedgerEntry."Credit Amount",'>%1',0);
      MemberLedgerEntry.CALCSUMS(MemberLedgerEntry."Credit Amount (LCY)");
      MToday:=MemberLedgerEntry.COUNT;
      IF MToday<6 THEN BEGIN
        amount:=1;//not contributed for last six months
         fnInsertEligibity(Vendor."No.",Vendor.Name,1,amount,'Has not contributed for last six months');
        EXIT;
      END;

      //calculate number of trials in that month.
      MpesaDisbus.RESET;
       MpesaDisbus.SETRANGE(MpesaDisbus."Account No",Members."No.");
       MCount:=MpesaDisbus.COUNT;
       IF MpesaDisbus.FINDLAST() THEN BEGIN
         MobileLoan.RESET;
         MobileLoan.SETRANGE(MobileLoan."Date Entered",MpesaDisbus."Date Entered");
         MobileLoan.SETRANGE(MobileLoan."Account No",Members."No.");
         IF MobileLoan.FIND('-') THEN BEGIN
           NoOFcountsAmont:=MobileLoan.COUNT;
         END;
        END;
        MCount:=MCount-NoOFcountsAmont;

       MpesaDisbus.RESET;
       MpesaDisbus.SETRANGE(MpesaDisbus."Account No",Members."No.");
       IF MpesaDisbus.FIND('-') THEN BEGIN
            REPEAT

           IF MpesaDisbus."Penalty Date" <>0D THEN BEGIN

           IF TODAY <MpesaDisbus."Penalty Date"  THEN BEGIN
             amount:=5;
             fnInsertEligibity(Vendor."No.",Vendor.Name,1,amount,'Penalized for late Payment');
             EXIT;
             END;
           END;

         UNTIL MpesaDisbus.NEXT=0;

         END;






      IF amount<>1 THEN BEGIN
          LoansRegister.RESET;
          LoansRegister.SETRANGE(LoansRegister."Client Code",Members."No.");
          LoansRegister.SETRANGE(LoansRegister.Posted,TRUE);
          IF LoansRegister.FIND('-') THEN BEGIN
          REPEAT
            LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance");
          IF (LoansRegister."Outstanding Balance">0) THEN BEGIN

      // =================================== Check if member has an outstanding A03

          IF (LoansRegister."Loan Product Type" = 'A03') THEN BEGIN
            amount:=2;
             fnInsertEligibity(Vendor."No.",Vendor.Name,1,amount,'Has Outstanding Mobile Loan of amount Ksh. '+FORMAT(LoansRegister."Outstanding Balance"));
          EXIT;
          END;
          END;
          UNTIL LoansRegister.NEXT=0;
          END;

      // ============================================Get arreas
      IF amount<>2 THEN BEGIN
         {     LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Client Code",Members."No.");
              IF LoansRegister.FIND('-') THEN BEGIN

             REPEAT
                LoansRegister.CALCFIELDS(LoansRegister."Oustanding Interest",LoansRegister."Outstanding Balance");
             IF  (LoansRegister."Outstanding Balance">0)  THEN BEGIN
              LoanRepaymentS.RESET;
              LoanRepaymentS.SETRANGE(LoanRepaymentS."Loan No.",LoansRegister."Loan  No.");
              IF LoanRepaymentS.FIND('-') THEN BEGIN
                REPEAT

                     Fulldate:= DMY2DATE(DATE2DMY(280511D,1),DATE2DMY( CALCDATE('CM+1D-2M',TODAY),2),DATE2DMY(CALCDATE('CM+1D-2M',TODAY),3));
                     LastRepayDate:= DMY2DATE(DATE2DMY(280511D,1),DATE2DMY(LoanRepaymentS."Repayment Date",2),DATE2DMY(LoanRepaymentS."Repayment Date",3));


                   IF Fulldate>=LastRepayDate THEN BEGIN

                     PrincipalAmount:= PrincipalAmount+LoanRepaymentS."Principal Repayment";
                     END;
                   //  EXIT
                 UNTIL LoanRepaymentS.NEXT=0;
              END;


              MemberLedgerEntry.RESET;
              MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Loan No",LoansRegister."Loan  No.");
              MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::Repayment);
              MemberLedgerEntry.CALCSUMS(MemberLedgerEntry."Credit Amount (LCY)");
              TransactionLoanAmt:=MemberLedgerEntry."Credit Amount (LCY)";
              TransactionLoanDiff:=PrincipalAmount-TransactionLoanAmt;

              IF TransactionLoanDiff>0 THEN BEGIN
                RepayedLoanAmt:=TransactionLoanDiff;
                 amount:=6;
                END ELSE BEGIN
                  PrincipalAmount:=0;
                 RepayedLoanAmt:=RepayedLoanAmt+0;
              END;
              END;//BAL
           UNTIL LoansRegister.NEXT=0;
          END;

          }
            IF amount<>3 THEN BEGIN
      // =========================================================Get Free Shares
          ComittedShares:=0;
          LoanGuarantors.RESET;
          LoanGuarantors.SETRANGE(LoanGuarantors."Member No",Members."No.");
          LoanGuarantors.SETRANGE(LoanGuarantors.Substituted,FALSE);
          IF LoanGuarantors.FIND('-') THEN BEGIN
          REPEAT
          IF LoansRegister.GET(LoanGuarantors."Loan No") THEN BEGIN
          LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance");
          IF LoansRegister."Outstanding Balance" > 0 THEN BEGIN
          ComittedShares:=ComittedShares+LoanGuarantors."Amont Guaranteed";
          END;
          END;
          UNTIL LoanGuarantors.NEXT = 0;
          END;


           Members.CALCFIELDS(Members."Current Shares");
           FreeShares:=Members."Current Shares"-ComittedShares;
            amount:=FreeShares;

           // MESSAGE(FORMAT(ComittedShares));



      //==================================================Get maximum loan amount
           LoanProductsSetup.RESET;
           LoanProductsSetup.SETRANGE(LoanProductsSetup.Code,'A03');
           IF LoanProductsSetup.FIND('-') THEN BEGIN
             interestAMT:=LoanProductsSetup."Interest rate";
             MaxLoanAmt:=LoanProductsSetup."Max. Loan Amount";
            END;


       Mpenalty:=0;
       MpesaDisbus.RESET;
       MpesaDisbus.SETRANGE(MpesaDisbus."Account No",Members."No.");
      // MpesaDisbus.ASCENDING(FALSE);
       //MCount:=0;
       IF MpesaDisbus.FINDLAST THEN BEGIN
        //REPEAT
          //MCount:=MCount+1;
          IF MpesaDisbus.Penalized=TRUE THEN BEGIN
          Mpenalty:=1;
            END;
        // UNTIL (  (MpesaDisbus.NEXT=0));
         END;

      //EXIT;
      IF Mpenalty=1 THEN BEGIN
        Mrecomended:=2500;
      END ELSE BEGIN
       Mrecomended:=GetCharge(MCount+1,'LOANLIMIT');
       END;

      IF amount> Mrecomended THEN
        amount:=Mrecomended;

      //MESSAGE(FORMAT(MCount));

          IF amount>MaxLoanAmt THEN
            amount:=MaxLoanAmt;

           fnInsertEligibity(Vendor."No.",Vendor.Name,0,amount,'Success');
          END;
         END;
      END;
      END;
    END;

    PROCEDURE PostNormalLoan@1120054044(docNo@1000000000 : Code[20];AccountNo@1000000001 : Code[50];amount@1000000002 : Decimal;Period@1120054000 : Decimal) result : Code[30];
    VAR
      LoanAcc@1000000003 : Code[30];
      InterestAcc@1000000004 : Code[30];
      InterestAmount@1000000005 : Decimal;
      AmountToCredit@1000000006 : Decimal;
      loanNo@1000000007 : Text[20];
      advSMS@1000000008 : Decimal;
      advFee@1000000009 : Decimal;
      advApp@1000000010 : Decimal;
      advSMSAcc@1000000011 : Code[20];
      advFEEAcc@1000000012 : Code[20];
      advAppAcc@1000000013 : Code[20];
      advSMSDesc@1000000014 : Text[100];
      advFeeDesc@1000000015 : Text[100];
      advAppDesc@1000000016 : Text[100];
      LoanProdCharges@1000 : Record 51516242;
      SaccoNoSeries@1001 : Record 51516258;
      NoSeriesMgt@1002 : Codeunit 396;
      LoanRepSchedule@1003 : Record 51516234;
      loanType@1004 : Code[50];
      InsuranceAcc@1007 : Code[10];
      SaccoNo@1120054001 : Record 308;
      AmountDispursed@1120054002 : Decimal;
      loanAdvanceCharge@1120054003 : Decimal;
    BEGIN
      //loanType:='322';
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", docNo);
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
      //  GenSetUp.GET();
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;

        //............INSURANCE
        LoanProductsSetup.RESET;
        LoanProductsSetup.SETRANGE(LoanProductsSetup.Code,'A03');
        IF LoanProductsSetup.FINDFIRST() THEN BEGIN
          LoanAcc:=LoanProductsSetup."Loan Account";
          InterestAcc:=LoanProductsSetup."Loan Interest Account";
          InsuranceAcc:=LoanProductsSetup."Loan Insurance Accounts";
        END;
        //loan charges
        LoanProdCharges.RESET;
        LoanProdCharges.SETRANGE(LoanProdCharges."Product Code",'A03');
        LoanProdCharges.SETRANGE(LoanProdCharges.Code,loanType);
        IF LoanProdCharges.FINDFIRST() THEN BEGIN
          advApp:=LoanProdCharges.Amount;
          advAppAcc:=LoanProdCharges."G/L Account";
          advAppDesc:=LoanProdCharges.Description;
        END;
        //sms charge
        LoanProdCharges.RESET;
        LoanProdCharges.SETRANGE(LoanProdCharges."Product Code",'A03');
        LoanProdCharges.SETRANGE(LoanProdCharges.Code,'A03');
        IF LoanProdCharges.FINDFIRST() THEN BEGIN
          advSMS:=(LoanProdCharges.Amount);
          advSMSAcc:=LoanProdCharges."G/L Account";
          advSMSDesc:=LoanProdCharges.Description;
        END;

      //INSURANCE charge
        LoanProdCharges.RESET;
        LoanProdCharges.SETRANGE(LoanProdCharges."Product Code",'A03');
        LoanProdCharges.SETRANGE(LoanProdCharges.Code,'LPF');
        IF LoanProdCharges.FINDFIRST() THEN BEGIN
          advSMS:=LoanProdCharges.Amount;
          advSMSAcc:=LoanProdCharges."G/L Account";
          advSMSDesc:=LoanProdCharges.Description;
        END;
        //loan proccessing fee
        LoanProdCharges.RESET;
        LoanProdCharges.SETRANGE(LoanProdCharges."Product Code",'A03');
        LoanProdCharges.SETRANGE(LoanProdCharges.Code,'LPF');
        IF LoanProdCharges.FINDFIRST() THEN BEGIN
          advFee:=(LoanProdCharges.Amount/100)*amount;
          advFEEAcc:=LoanProdCharges."G/L Account";
          advFeeDesc:=LoanProdCharges.Description;
        END;


         MpesaAccount:='BNK00013';//GenLedgerSetup."MPESA Recon Acc";
           MPESACharge:=GetCharge(amount,'MPESA');

          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";
          SurePESACommACC:= GenLedgerSetup."CloudPESA Comm Acc";
          MobileCharges:=10;
          InterestAmount:=ROUND(((LoanProductsSetup."Interest rate"/1200)*amount),1,'>');
          AmountToCredit:=amount+MPESACharge;
          ExcDuty:=(20/100)*(MobileCharges);

           TotalCharges:= SurePESACharge+ExcDuty+MobileCharges+MPESACharge;
            AmountDispursed:=amount+TotalCharges;

       //loanAdvanceCharge:=;

       Vendor.RESET;
            Vendor.SETRANGE(Vendor."No.", AccountNo);
            IF Vendor.FIND('-') THEN BEGIN

            Members.RESET;
            Members.SETRANGE(Members."No.", Vendor."BOSA Account No");
            IF Members.FIND('-') THEN BEGIN

            //*******Create Loan *********//
                SaccoNoSeries.RESET;
                SaccoNoSeries.GET;
                SaccoNoSeries.TESTFIELD(SaccoNoSeries."BOSA Loans Nos");
                NoSeriesMgt.InitSeries(SaccoNoSeries."BOSA Loans Nos",LoansRegister."No. Series",0D,LoansRegister."Loan  No.",LoansRegister."No. Series");
                loanNo:=LoansRegister."Loan  No.";

                LoansRegister.INIT;
                LoansRegister."Approved Amount":=amount;
                LoansRegister.Interest:=LoanProductsSetup."Interest rate";
                LoansRegister."Instalment Period":=LoanProductsSetup."Instalment Period";
                LoansRegister.Repayment:=AmountDispursed;
                LoansRegister."Expected Date of Completion":=CALCDATE('1M',TODAY);
                LoansRegister.Posted:=TRUE;
                Members.CALCFIELDS(Members."Current Shares",Members."Outstanding Balance",Members."Current Loan");
                LoansRegister."Shares Balance":=Members."Current Shares";
                LoansRegister."Amount Disbursed":=AmountDispursed;
                LoansRegister.Savings:=Members."Current Shares";
                LoansRegister."Interest Paid":=0;
                LoansRegister."Issued Date":=TODAY;
                LoansRegister.Source:=LoanProductsSetup.Source;
                LoansRegister."Loan Disbursed Amount":=AmountDispursed;
                LoansRegister."Schedule Repayment":=AmountDispursed;
                LoansRegister."Current Interest Paid":=0;
                LoansRegister."Loan Disbursement Date":=TODAY;
                LoansRegister."Client Code":=Members."No.";
                LoansRegister."Client Name":=Members.Name;
                LoansRegister."Outstanding Balance to Date":=AmountDispursed;
                LoansRegister."Existing Loan":=Members."Outstanding Balance";
                //LoansRegister."Staff No":=Members."Payroll/Staff No";
                LoansRegister.Gender:=Members.Gender;
                LoansRegister."BOSA No":=Members."No.";
               // LoansRegister."Branch Code":=Vendor."Global Dimension 2 Code";
                LoansRegister."Requested Amount":=amount;
                LoansRegister."ID NO":=Members."ID No.";
                IF LoansRegister."Branch Code" = '' THEN
                LoansRegister."Branch Code":=Members."Global Dimension 2 Code";
                LoansRegister."Loan  No.":=loanNo;
                LoansRegister."No. Series":=SaccoNoSeries."BOSA Loans Nos";
                LoansRegister."Doc No Used":=docNo;
                LoansRegister."Loan Interest Repayment":=InterestAmount;
                LoansRegister."Loan Principle Repayment":=AmountDispursed;
                LoansRegister."Loan Repayment":=AmountDispursed;
                LoansRegister."Employer Code":=Members."Employer Code";
                LoansRegister."Approval Status":=LoansRegister."Approval Status"::Approved;
                LoansRegister."Account No":=Members."No.";
                LoansRegister."Application Date":=TODAY;
                LoansRegister."Loan Product Type":=LoanProductsSetup.Code;
                LoansRegister."Loan Product Type Name":=LoanProductsSetup."Product Description";
                LoansRegister."Loan Disbursement Date":=TODAY;
                LoansRegister."Repayment Start Date":=TODAY;
                LoansRegister."Recovery Mode":=LoansRegister."Recovery Mode"::Checkoff;
                LoansRegister."Mode of Disbursement":=LoansRegister."Mode of Disbursement"::"FOSA Loans";
                LoansRegister."Requested Amount":=amount;
                LoansRegister."Approved Amount":=AmountDispursed;
                LoansRegister.Installments:=1;
                LoansRegister."Loan Amount":=AmountDispursed;
                LoansRegister."Issued Date":=TODAY;
                LoansRegister."Outstanding Balance":=0;//Update
                LoansRegister."Repayment Frequency":=LoansRegister."Repayment Frequency"::Monthly;
                LoansRegister."Mode of Disbursement":= LoansRegister."Mode of Disbursement"::"Transfer to FOSA";
                LoansRegister.INSERT(TRUE);

           // InterestAmount:=0;

           //**********Process Loan*******************//

                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                GenJournalLine.SETRANGE("Journal Batch Name",'MOBILA03');
                GenJournalLine.DELETEALL;
                //end of deletion

                GenBatches.RESET;
                GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                GenBatches.SETRANGE(GenBatches.Name,'MOBILA03');

                IF GenBatches.FIND('-') = FALSE THEN BEGIN
                GenBatches.INIT;
                GenBatches."Journal Template Name":='GENERAL';
                GenBatches.Name:='MOBILA03';
                GenBatches.Description:='Normal Loan';
                GenBatches.VALIDATE(GenBatches."Journal Template Name");
                GenBatches.VALIDATE(GenBatches.Name);
                GenBatches.INSERT;
                END;



                //Post Loan
                LoansRegister.RESET;
                LoansRegister.SETRANGE(LoansRegister."Loan  No.",loanNo);
                IF LoansRegister.FIND('-') THEN BEGIN

        //Dr loan Acc
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILA03';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=Members."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=docNo;
                GenJournalLine."External Document No.":=Members."No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='MBanking Loan Disbursment';
                GenJournalLine.Amount:=AmountDispursed;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

      //Cr Acc with charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILA03';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Loan Charge';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

      //Cr Acc with charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILA03';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                      GenJournalLine."Account No.":='300-000-055';
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Sms Charge '+LoansRegister."Loan  No.";
                      GenJournalLine.Amount:=-MobileCharges;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

      //Cr Acc with charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILA03';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                      GenJournalLine."Account No.":=ExxcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Sms Charge Excise duty '+LoansRegister."Loan  No.";
                      GenJournalLine.Amount:=-ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

        // DR Interest charge
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILA03';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                      GenJournalLine."Account No.":=LoansRegister."Client Code";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":='';
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                      GenJournalLine.Description:='Loan ' +FORMAT(GenJournalLine."Transaction Type"::"Interest Due");
                      GenJournalLine.Amount:=InterestAmount;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                      IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                      GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                      END;
                       GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                      GenJournalLine."Bal. Account No.":=LoanProductsSetup."Loan Interest Account";
                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                      GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;


        //Cr bank Charges
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILA03';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                GenJournalLine."Account No.":=MpesaAccount;
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=docNo;
                GenJournalLine."External Document No.":=docNo;
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='MBanking Loan Disbursment - Charges';
                GenJournalLine.Amount:=MPESACharge*-1;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

      //Cr bank
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILA03';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                GenJournalLine."Account No.":=MpesaAccount;
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=docNo;
                GenJournalLine."External Document No.":=docNo;
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='MBanking Loan Disbursment';
                GenJournalLine.Amount:=(amount)*-1;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;



                //Post
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                GenJournalLine.SETRANGE("Journal Batch Name",'MOBILA03');
                IF GenJournalLine.FIND('-') THEN BEGIN
                REPEAT
                GLPosting.RUN(GenJournalLine);
                UNTIL GenJournalLine.NEXT = 0;

              //  TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILA03');
      //***************Update Loan Status************//
                LoansRegister."Loan Status":=LoansRegister."Loan Status"::Issued;
                LoansRegister."Amount Disbursed":=AmountToCredit;
                LoansRegister.Posted:=TRUE;
                LoansRegister."Interest Upfront Amount":=InterestAmount;
                LoansRegister."Outstanding Balance":=amount;
                LoansRegister.MODIFY;

       //======================Generate schedule
            I:=1;
            WHILE I<=Period DO BEGIN
             LoansRegister.CALCFIELDS(LoansRegister."Oustanding Interest",LoansRegister."Outstanding Balance");
                      RSchedule.INIT;
                      RSchedule."Repayment Code":=FORMAT(I);
                      RSchedule."Loan No.":=LoansRegister."Loan  No.";
                      RSchedule."Loan Amount":=LoansRegister."Loan Amount";
                      RSchedule."Instalment No":=I;
                      RSchedule."Repayment Date":=CALCDATE(FORMAT(I)+'M',LoansRegister."Issued Date");
                      RSchedule."Member No.":=LoansRegister."Client Code";
                      RSchedule."Loan Category":=LoansRegister."Loan Product Type";
                      RSchedule."Monthly Repayment":=(LoansRegister."Loan Principle Repayment"+LoansRegister."Loan Interest Repayment")/I;
                      RSchedule."Monthly Interest":=(LoansRegister."Oustanding Interest")/I;
                      RSchedule."Principal Repayment":=(LoansRegister."Loan Principle Repayment")/I;
                      RSchedule."Loan Balance":=LoansRegister."Oustanding Interest"+LoansRegister."Outstanding Balance";
                      RSchedule.INSERT;

            I:=I+1;
                      END;


      //=====================insert to Mpesa mobile disbursment
                MpesaDisbus.RESET;
                MpesaDisbus.SETRANGE(MpesaDisbus."Document No",docNo);
                IF MpesaDisbus.FIND('-')=FALSE THEN BEGIN
                MpesaDisbus.INIT;
                MpesaDisbus."Account No":=Members."No.";
                MpesaDisbus."Document Date":=TODAY;
                MpesaDisbus."Loan Amount":=(amount);
                MpesaDisbus."Document No":=docNo;
                MpesaDisbus."Batch No":='MOBILE';
                MpesaDisbus."Date Entered":=TODAY;
                MpesaDisbus."Time Entered":=TIME;
                MpesaDisbus."Entered By":=USERID;
                MpesaDisbus."Member No":=Members."No.";
                MpesaDisbus."Telephone No":=Vendor."Phone No.";
                MpesaDisbus."Corporate No":='591227';
                MpesaDisbus."Delivery Center":='MPESA';
                MpesaDisbus."MPESA Doc No.":=docNo;
                MpesaDisbus."Date Entered":=TODAY;
                MpesaDisbus."Time Entered":=TIME;
                MpesaDisbus."Date Sent To Server":=TODAY;
                MpesaDisbus."Time Sent To Server":=TIME;
                MpesaDisbus.Comments:='Successful';
                MpesaDisbus."Customer Name":=Members.Name;
                MpesaDisbus.Status:=MpesaDisbus.Status::Completed;
                MpesaDisbus.Purpose:='Emergency';
                MpesaDisbus.INSERT;

                END;


                 SurePESATrans.INIT;
                      SurePESATrans."Document No":=docNo;
                      SurePESATrans.Description:='Mobile Loan';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=AccountNo;
                      SurePESATrans."Account No2" :='';
                      SurePESATrans."Account Name":=Members.Name;
                      SurePESATrans."Telephone Number":=Members."Phone No.";
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Status:=SurePESATrans.Status::Completed;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Members."No.";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Loan Application";
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                result:='TRUE';
                msg:='Dear '+SplitString(Members.Name,' ')+', Your '+LoansRegister."Loan Product Type Name"+' of Ksh '+FORMAT((amount))+' has been approved and disbursed to your Mpesa No.'+
               Members."Mobile Phone No"+ ' Your loan of KShs '+FORMAT(AmountDispursed+InterestAmount)+ ' is due on '+FORMAT(CALCDATE('+1M',TODAY));

               SMSMessage(docNo,Members."No.",Members."Mobile Phone No",msg);
                 END;
                END;//Loans Register
              //END
              END
        ELSE BEGIN
          result:='ACCINEXISTENT';
                SurePESATrans.INIT;
                SurePESATrans."Document No":=docNo;
                SurePESATrans.Description:='Mobile Loan';
                SurePESATrans."Document Date":=TODAY;
                SurePESATrans."Account No" :=Vendor."No.";
                SurePESATrans."Account No2" :='';
                SurePESATrans.Amount:=amount;
                SurePESATrans.Status:=SurePESATrans.Status::Completed;
                SurePESATrans.Posted:=TRUE;
                SurePESATrans."Posting Date":=TODAY;
                SurePESATrans.Comments:='Failed.Invalid Account';
                SurePESATrans.Client:=Members."No.";
                SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Loan Application";
                SurePESATrans."Transaction Time":=TIME;
                SurePESATrans.INSERT;
        END;
        END;
        END;
    END;

    PROCEDURE GetMpesaDisbursment@1120054002() result : Text;
    BEGIN
      MpesaDisbus.RESET;
      MpesaDisbus.SETRANGE(MpesaDisbus."Sent To Server",MpesaDisbus."Sent To Server"::No);
      MpesaDisbus.SETRANGE(MpesaDisbus.Status,MpesaDisbus.Status::Pending);
      IF MpesaDisbus.FIND('-') THEN BEGIN
         result:=MpesaDisbus."Document No"+':::'+MpesaDisbus."Telephone No"+':::'+FORMAT(MpesaDisbus."Loan Amount")+':::'+MpesaDisbus."Account No"+':::'+MpesaDisbus."Customer Name";
      END;
    END;

    PROCEDURE UpdateMpesaDisbursment@1120054007(ImprestNo@1120054000 : Code[30];MpesaNo@1120054001 : Code[30];Phone@1120054002 : Code[30];ResultCode@1120054003 : Code[10];Comments@1120054004 : Text) result : Code[10];
    VAR
      BankLedger@1120054005 : Record 271;
    BEGIN
      MpesaDisbus.RESET;
      MpesaDisbus.SETRANGE(MpesaDisbus."Document No",ImprestNo);
      //Mkahawa.SETRANGE(Mkahawa."Telephone No",Phone);
      IF MpesaDisbus.FIND('-') THEN BEGIN
        IF ResultCode='0' THEN BEGIN
          MpesaDisbus."Sent To Server":=MpesaDisbus."Sent To Server"::Yes;
          MpesaDisbus.Status:=MpesaDisbus.Status::Completed;
           BankLedger.RESET;
           BankLedger.SETRANGE(BankLedger."External Document No.",ImprestNo);
          // BankLedger.SETRANGE(
           IF BankLedger.FIND('-') THEN
             BEGIN
               BankLedger."External Document No.":=MpesaNo;
               BankLedger.MODIFY;
              END;
        END ELSE BEGIN
         MpesaDisbus."Sent To Server":=MpesaDisbus."Sent To Server"::Yes;
         MpesaDisbus.Status:=MpesaDisbus.Status::Failed;
        END;
        MpesaDisbus.Comments:=Comments;
        MpesaDisbus."Date Sent To Server":=TODAY;
        MpesaDisbus."Time Sent To Server":=TIME;
        MpesaDisbus."MPESA Doc No.":=MpesaNo;
        MpesaDisbus.MODIFY;
        result:='TRUE';
        END;
    END;

    PROCEDURE UpdateMpesaPending@1120054001(Doc@1120054000 : Code[50]);
    BEGIN
      MpesaDisbus.RESET;
      MpesaDisbus.SETRANGE(MpesaDisbus."Document No",Doc);
      MpesaDisbus.SETRANGE(MpesaDisbus."Sent To Server",MpesaDisbus."Sent To Server"::No);
      MpesaDisbus.SETRANGE(MpesaDisbus.Status,MpesaDisbus.Status::Pending);
      IF MpesaDisbus.FIND('-') THEN BEGIN
        MpesaDisbus.Status:=MpesaDisbus.Status::Waiting;
        MpesaDisbus.MODIFY;
        END;
    END;

    PROCEDURE fnProcessNotification@1120054003();
    VAR
      VarIssuedDate@1120054000 : Date;
      VarExpectedCompletion@1120054001 : Date;
      batch@1120054002 : Code[50];
      SaccoNoSeries@1120054004 : Record 51516258;
      docNo@1120054003 : Code[50];
      loanamt@1120054005 : Decimal;
      FosaBal@1120054006 : Decimal;
      amtToRecover@1120054007 : Decimal;
      RemainAmt@1120054008 : Decimal;
      FosaRecovered@1120054009 : Decimal;
    BEGIN
      LoansRegister.RESET;
      LoansRegister.SETRANGE(LoansRegister."Loan Product Type",'A03');
      LoansRegister.SETRANGE(LoansRegister.Posted, TRUE);
      IF LoansRegister.FIND('-') THEN BEGIN
         //............

        LoanProductsSetup.RESET;
        LoanProductsSetup.SETRANGE(LoanProductsSetup.Code,'A03');
        IF LoanProductsSetup.FINDFIRST() THEN BEGIN

        END;
        REPEAT
          LoansRegister.CALCFIELDS("Outstanding Balance", "Oustanding Interest");

         IF LoansRegister."Outstanding Balance">0 THEN BEGIN

           VarIssuedDate:=LoansRegister."Issued Date";

           Members.RESET;
           Members.SETRANGE(Members."No.",LoansRegister."Client Code");
           IF Members.FIND('-') THEN BEGIN

               IF TODAY >= CALCDATE('15D',VarIssuedDate) THEN BEGIN //SEND SMS 2ND WEEK
                 MpesaDisbus.RESET;
                 MpesaDisbus.SETRANGE(MpesaDisbus."Document No",LoansRegister."Doc No Used");
                 MpesaDisbus.SETRANGE(MpesaDisbus."Ist Notification",FALSE);
                 IF MpesaDisbus.FIND('-') THEN BEGIN
                 msg:='Dear '+SplitString(Members.Name,' ')+', Your '+LoansRegister."Loan Product Type Name"+' of amount Ksh. '
                   +FORMAT(ROUND((LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"),1,'>'))+' is due on '
                 + FORMAT(LoansRegister."Expected Date of Completion")
                 + 'Dial *850# and choose option 4, then select the Mobile loan Advance' ;

                SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",MpesaDisbus."Telephone No",msg);
                MpesaDisbus."Ist Notification":=TRUE;
                MpesaDisbus.MODIFY;
                  END;
                 END;

               //MESSAGE('%1',TODAY);//CALCDATE('4W',10092018D));
               IF TODAY >= CALCDATE('21D',VarIssuedDate) THEN BEGIN //SEND SMS 4TH WEEK

                 MpesaDisbus.RESET;
                 MpesaDisbus.SETRANGE(MpesaDisbus."Document No",LoansRegister."Doc No Used");
                 MpesaDisbus.SETRANGE(MpesaDisbus."2nd Notification",FALSE);
                 IF MpesaDisbus.FIND('-') THEN BEGIN
                 msg:='Dear '+SplitString(Members.Name,' ')+', Your '+LoansRegister."Loan Product Type Name"+' of amount Ksh. '+FORMAT(ROUND((LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"),1,'>'))+' is due on '
                 + FORMAT(LoansRegister."Expected Date of Completion")+' Kindly settle the arrears to qualify for a higher amount .';
                SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",MpesaDisbus."Telephone No",msg);
                MpesaDisbus."2nd Notification":=TRUE;
                MpesaDisbus.MODIFY;
                  END;
               END;

                IF TODAY >= CALCDATE('27D',VarIssuedDate) THEN BEGIN //SEND SMS 4TH WEEK

                 MpesaDisbus.RESET;
                 MpesaDisbus.SETRANGE(MpesaDisbus."Document No",LoansRegister."Doc No Used");
                 MpesaDisbus.SETRANGE(MpesaDisbus."3rd Notification",FALSE);
                 IF MpesaDisbus.FIND('-') THEN BEGIN
                 msg:='Dear '+SplitString(Members.Name,' ')+', Your '+LoansRegister."Loan Product Type Name"+' of amount Ksh. '+FORMAT(ROUND((LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"),1,'>'))+' is due on '
                 + FORMAT(LoansRegister."Expected Date of Completion")+' Kindly settle the arrears to qualify for a higher amount .';
                SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",MpesaDisbus."Telephone No",msg);
                MpesaDisbus."3rd Notification":=TRUE;
                MpesaDisbus.MODIFY;
                  END;
               END;

               IF TODAY >= CALCDATE('28D',VarIssuedDate) THEN BEGIN //SEND SMS 4TH WEEK

                 MpesaDisbus.RESET;
                 MpesaDisbus.SETRANGE(MpesaDisbus."Document No",LoansRegister."Doc No Used");
                 MpesaDisbus.SETRANGE(MpesaDisbus."5th Notification",FALSE);
                 IF MpesaDisbus.FIND('-') THEN BEGIN
                 msg:='Dear '+SplitString(Members.Name,' ')+', Your '+LoansRegister."Loan Product Type Name"+' of amount Ksh. '+FORMAT(ROUND((LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"),1,'>'))+' is due on '
                 + FORMAT(LoansRegister."Expected Date of Completion")+' Kindly settle the arrears to qualify for a higher amount .';
                SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",MpesaDisbus."Telephone No",msg);
                MpesaDisbus."5th Notification":=TRUE;
                MpesaDisbus.MODIFY;
                  END;
               END;

               IF TODAY >= CALCDATE('1M',VarIssuedDate) THEN BEGIN //SEND SMS 4TH WEEK

                 MpesaDisbus.RESET;
                 MpesaDisbus.SETRANGE(MpesaDisbus."Document No",LoansRegister."Doc No Used");
                 MpesaDisbus.SETRANGE(MpesaDisbus."4th Notification",FALSE);
                 IF MpesaDisbus.FIND('-') THEN BEGIN
                 msg:='Dear '+SplitString(Members.Name,' ')+', Your '+LoansRegister."Loan Product Type Name"+' of amount Ksh. '+FORMAT(ROUND((LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"),1,'>'))+' is due Today '
                 + FORMAT(LoansRegister."Expected Date of Completion")+' Kindly pay to avoid recovery from your salary and being barred from future transactions.';
                SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",MpesaDisbus."Telephone No",msg);
                MpesaDisbus."4th Notification":=TRUE;
                MpesaDisbus.MODIFY;
                  END;
               END;


               IF TODAY >= CALCDATE('37D',VarIssuedDate) THEN BEGIN // recover from deposit

                 docNo:='RECOVER -'+LoansRegister."Loan  No.";
                loanamt:=LoansRegister."Oustanding Interest"+LoansRegister."Outstanding Balance";
                batch:='MOBILEREC';
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                GenJournalLine.SETRANGE("Journal Batch Name",batch);
                GenJournalLine.DELETEALL;
                //end of deletion

                GenBatches.RESET;
                GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                GenBatches.SETRANGE(GenBatches.Name,batch);

                IF GenBatches.FIND('-') = FALSE THEN BEGIN
                  GenBatches.INIT;
                  GenBatches."Journal Template Name":='GENERAL';
                  GenBatches.Name:=batch;
                  GenBatches.Description:='mobile recovery';
                  GenBatches.VALIDATE(GenBatches."Journal Template Name");
                  GenBatches.VALIDATE(GenBatches.Name);
                  GenBatches.INSERT;
                END;//General Jnr Batches
                FosaBal:= FnGetAccountBal(LoansRegister."Client Code");

                amtToRecover:=(LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"+(0.1* LoansRegister."Outstanding Balance"));
               RemainAmt:=0;
               IF FosaBal>0 THEN BEGIN
                IF FosaBal>=amtToRecover THEN
                  FosaRecovered:=amtToRecover;
                 IF FosaBal<=amtToRecover THEN
                  FosaRecovered:=FosaBal;

                 RemainAmt:=amtToRecover-FosaRecovered;
                IF RemainAmt<0 THEN
                  RemainAmt:=0;



                END ELSE BEGIN
                  RemainAmt:=amtToRecover;
                END;
                IF FosaBal>0 THEN BEGIN
                   //Dr Mobile Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":=batch;
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=docNo;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:=LoansRegister."Loan Product Type Name"+' Recovery';
                      GenJournalLine.Amount:=FosaRecovered;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;
                END;
                    LineNo:=LineNo+10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name":='GENERAL';
                    GenJournalLine."Journal Batch Name":=batch;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                    GenJournalLine."Account No.":=Members."No.";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No.":=docNo;
                    GenJournalLine."External Document No.":=docNo;
                    GenJournalLine."Posting Date":=TODAY;
                    GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
                    GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:=LoansRegister."Loan Product Type Name"+' Recovery';
                    GenJournalLine.Amount:=RemainAmt;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;

                  LineNo:=LineNo+10000;
                  GenJournalLine.INIT;
                  GenJournalLine."Journal Template Name":='GENERAL';
                  GenJournalLine."Journal Batch Name":=batch;
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                  GenJournalLine."Account No.":=LoansRegister."Client Code";
                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                  GenJournalLine."Document No.":=docNo;
                  GenJournalLine."External Document No.":=docNo;
                  GenJournalLine."Posting Date":=TODAY;
                  GenJournalLine.Description:='Loan Interest Payment';
                  GenJournalLine.Amount:=-LoansRegister."Oustanding Interest";
                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                  GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                  IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                  GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                  END;
                  GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                  IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;

      //Cr Interest A03 receivable

            {    LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILA03';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Account No.":=LoanProductsSetup."Loan Interest Account";
                GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=docNo;
                GenJournalLine."External Document No.":='';
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='Loan '+FORMAT(GenJournalLine."Transaction Type"::"Interest Paid");
                GenJournalLine.Amount:=-(LoansRegister."Oustanding Interest");
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                 IF  LoansRegister.Source= LoansRegister.Source::BOSA THEN BEGIN
                GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":= Members."Global Dimension 2 Code";
                END;
                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
               GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
               GenJournalLine."Bal. Account No.":=LoanProductsSetup."Receivable Interest Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;
                    }
                  LineNo:=LineNo+10000;
                  GenJournalLine.INIT;
                  GenJournalLine."Journal Template Name":='GENERAL';
                  GenJournalLine."Journal Batch Name":=batch;
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                  GenJournalLine."Account No.":=LoansRegister."Client Code";
                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                  GenJournalLine."Document No.":=docNo;
                  GenJournalLine."External Document No.":=docNo;
                  GenJournalLine."Posting Date":=TODAY;
                  GenJournalLine.Description:='Loan Repayment';
                  GenJournalLine.Amount:=-LoansRegister."Outstanding Balance";
                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                  GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                  IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                  GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                  END;
                  GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                  IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;

                  LineNo:=LineNo+10000;
                  GenJournalLine.INIT;
                  GenJournalLine."Journal Template Name":='GENERAL';
                  GenJournalLine."Journal Batch Name":=batch;
                  GenJournalLine."Line No.":=LineNo;
                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                  GenJournalLine."Account No.":=LoansRegister."Client Code";
                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                  GenJournalLine."Document No.":=docNo;
                  GenJournalLine."External Document No.":=docNo;
                  GenJournalLine."Posting Date":=TODAY;
                  GenJournalLine.Description:='Loan penalty';
                  GenJournalLine.Amount:=-(0.1* LoansRegister."Outstanding Balance");
                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                  GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Penalty Paid";
                  IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                  GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                  GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                  END;
                  GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                  IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;


                  GenJournalLine.RESET;
                  GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                  GenJournalLine.SETRANGE("Journal Batch Name",batch);
                  IF GenJournalLine.FIND('-') THEN BEGIN
                  REPEAT
                   GLPosting.RUN(GenJournalLine);
                  UNTIL GenJournalLine.NEXT = 0;

                  //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
                 MpesaDisbus.RESET;
                 MpesaDisbus.SETRANGE(MpesaDisbus."Document No",LoansRegister."Doc No Used");
                 MpesaDisbus.SETRANGE(MpesaDisbus.Penalized,FALSE);
                 IF MpesaDisbus.FIND('-') THEN BEGIN
                   MpesaDisbus."Penalty Date":=CALCDATE('2Y',TODAY);
                   MpesaDisbus.Penalized:=TRUE;
                   MpesaDisbus.MODIFY;

                   Members."Loan Defaulter":=TRUE;
                   Members."Loans Defaulter Status":=Members."Loans Defaulter Status"::Loss;
                   Members.MODIFY;

                   LoansRegister.Defaulter:=TRUE;
                   LoansRegister."Defaulted install":=loanamt;
                   LoansRegister.MODIFY;

                 msg:='Dear '+SplitString(Members.Name,' ')+', Your '+LoansRegister."Loan Product Type Name"+' of amount Ksh. '+FORMAT(loanamt)
                 +' has been recovered from your Deposits and your have been barred from using this service untill '+FORMAT(CALCDATE('2Y',TODAY));
                     SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",MpesaDisbus."Telephone No",msg);
                      END;
                    END;

                  END;



           END;

          END;

        UNTIL LoansRegister.NEXT=0;
      END;

      ObjAutomation.RESET;
      ObjAutomation.SETRANGE(ObjAutomation."SERVICE NAME", 'LOANAUTO');
      IF ObjAutomation.FIND('-') THEN BEGIN
      IF ObjAutomation.RunTime <=CURRENTDATETIME THEN BEGIN
          ObjAutomation.RunTime:=CREATEDATETIME(CALCDATE('1D',TODAY), 060000T);
          ObjAutomation."No of Runs":=ObjAutomation."No of Runs"+1;
          ObjAutomation.MODIFY;
       //   FnSendSMSNotification;
      END;
      END;
    END;

    LOCAL PROCEDURE SplitString@24(sText@1000 : Text;separator@1001 : Text) Token : Text;
    VAR
      Pos@1002 : Integer;
      Tokenq@1003 : Text;
    BEGIN
      Pos := STRPOS(sText,separator);
      IF Pos > 0 THEN BEGIN
        Token := COPYSTR(sText,1,Pos-1);
        IF Pos+1 <= STRLEN(sText) THEN
          sText := COPYSTR(sText,Pos+1)
        ELSE
          sText := '';
      END ELSE BEGIN
        Token := sText;
        sText := '';
      END;
    END;

    PROCEDURE postAirtime@1000000025("Doc No"@1000000000 : Code[100];Phone@1000000001 : Code[50];amount@1000000002 : Decimal) result : Code[50];
    BEGIN
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", "Doc No");
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        //GenLedgerSetup.TESTFIELD(GenLedgerSetup."suspense coop bank");
        //airtimeAcc:=  GenLedgerSetup."suspense coop bank";
        END;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", Phone);
          Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           Vendor.CALCFIELDS(Vendor."ATM Transactions");
           Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
           Vendor.CALCFIELDS(Vendor."EFT Transactions");

         //  TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
            TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");

               IF (TempBalance>amount) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'AIRTIME');
                      GenJournalLine.DELETEALL;
                      //end of deletion
                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'AIRTIME');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='AIRTIME';
                      GenBatches.Description:='AIRTIME Purchase';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //DR Customer Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='AIRTIME';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Bal. Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine."Bal. Account No.":=airtimeAcc;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                      GenJournalLine."Document No.":="Doc No";
                      GenJournalLine."External Document No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='AIRTIME Purchase';
                      GenJournalLine.Amount:=amount;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;



                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'AIRTIME');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                      //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','AIRTIME');
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'AIRTIME');
                      GenJournalLine.DELETEALL;
                       msg:='You have purchased airtime worth KES '+FORMAT(amount)+' from Account '+Vendor.Name+
                    '  Thank you for your patronage.';

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":="Doc No";
                      SurePESATrans.Description:='AIRTIME Purchase';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=Vendor."No.";
                      SurePESATrans."Account No2" :=Phone;
                       SurePESATrans.Charge:=TotalCharges;
                       SurePESATrans."Account Name":=Vendor.Name;

                        SurePESATrans."SMS Message":=msg;
                      SurePESATrans.Amount:=amount;
                      SurePESATrans.Status:=SurePESATrans.Status::Completed;
                      SurePESATrans.Posted:=TRUE;
                      SurePESATrans."Posting Date":=TODAY;
                      SurePESATrans.Comments:='Success';
                      SurePESATrans.Client:=Vendor."BOSA Account No";
                      SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Airtime;
                      SurePESATrans."Transaction Time":=TIME;
                      SurePESATrans.INSERT;
                      result:='TRUE';

                      SMSMessage("Doc No",Vendor."No.",Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                          { msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' .Thank you for using JITEGEMEE Sacco Mobile.';
                          SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);}
                            SurePESATrans.INIT;
                            SurePESATrans."Document No":="Doc No";
                            SurePESATrans.Description:='AIRTIME Purchase';
                            SurePESATrans."Document Date":=TODAY;
                            SurePESATrans."Account No" :=Vendor."No.";
                            SurePESATrans."Account No2" :=Phone;
                               SurePESATrans.Charge:=TotalCharges;
                       SurePESATrans."Account Name":=Vendor.Name;

                            SurePESATrans.Amount:=amount;
                            SurePESATrans.Status:=SurePESATrans.Status::Failed;
                            SurePESATrans.Posted:=FALSE;
                            SurePESATrans."Posting Date":=TODAY;
                            SurePESATrans.Comments:='Failed,Insufficient Funds';
                            SurePESATrans.Client:=Vendor."BOSA Account No";
                            SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Airtime;
                            SurePESATrans."Transaction Time":=TIME;
                            SurePESATrans.INSERT;
                   END;
             END
              ELSE BEGIN
                result:='ACCINEXISTENT';
                            SurePESATrans.INIT;
                            SurePESATrans."Document No":="Doc No";
                            SurePESATrans.Description:='AIRTIME Purchase';
                            SurePESATrans."Document Date":=TODAY;
                            SurePESATrans."Account No" :='';
                            SurePESATrans."Account No2" :=Phone;
                               SurePESATrans.Charge:=TotalCharges;
                       SurePESATrans."Account Name":=Vendor.Name;

                            SurePESATrans.Amount:=amount;
                            SurePESATrans.Posted:=FALSE;
                            SurePESATrans."Posting Date":=TODAY;
                            SurePESATrans.Comments:='Failed,Invalid Account';
                            SurePESATrans.Client:='';
                            SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Airtime;
                            SurePESATrans."Transaction Time":=TIME;
                            SurePESATrans.INSERT;
              END;
    END;

    PROCEDURE AccountBalanceAirtime@1000000028(Acc@1000000000 : Code[30];amt@1000000001 : Decimal) Bal : Decimal;
    BEGIN
        BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.", Acc);
        IF Vendor.FIND('-') THEN
         BEGIN
              AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
              Vendor.CALCFIELDS(Vendor."Balance (LCY)");
              Vendor.CALCFIELDS(Vendor."ATM Transactions");
              Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
              Vendor.CALCFIELDS(Vendor."EFT Transactions");
              Bal:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);

              GenLedgerSetup.RESET;
              GenLedgerSetup.GET;
             // GenLedgerSetup.TESTFIELD(GenLedgerSetup."family account bank");
              //GenLedgerSetup.TESTFIELD(GenLedgerSetup."MPESA Reconciliation acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
             // GenLedgerSetup.TESTFIELD(GenLedgerSetup."Agent Charges Account");

              Charges.RESET;
             // Charges.SETRANGE(Charges.Code,GenLedgerSetup."equity bank acc");
              IF Charges.FIND('-') THEN BEGIN
                Charges.TESTFIELD(Charges."GL Account");

                MPESACharge:=GetCharge(amt,'MPESA');
                //CloudPESACharge:=GetCharge(amt,'VENDWD');
                MobileCharges:=GetCharge(amt,'SACCOWD');

               // ExcDuty:=(10/100)*(MobileCharges+CloudPESACharge);
                TotalCharges:=0;//CloudPESACharge+MobileCharges+ExcDuty+MPESACharge;
                END;
                Bal:=Bal-TotalCharges;
         END
        END;
    END;

    PROCEDURE AccountbalalanceREF@1000000059(Acc@1000000000 : Code[30]) Bal : Text[250];
    BEGIN
       Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",Acc);
          IF Vendor.FIND('-') THEN BEGIN
       AccountTypes.RESET;
                        AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
                        IF AccountTypes.FIND('-') THEN
                        BEGIN
                          miniBalance:=AccountTypes."Minimum Balance";
                        END;
                        Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                        Vendor.CALCFIELDS(Vendor."ATM Transactions");
                        Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
                        Vendor.CALCFIELDS(Vendor."EFT Transactions");
                        accBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
                        Bal:=FORMAT(accBalance);
                        END;
    END;

    PROCEDURE CommisionEarned@1000000043() AccBal : Text[1024];
    BEGIN
      {GLEntries.RESET;
      GLEntries.SETRANGE("G/L Account No.",'20106');
      debitAmount:=0;
      amount:=0;
      IF GLEntries.FIND('-') THEN BEGIN
      REPEAT
      amount:=amount+GLEntries."Credit Amount";
        debitAmount:=debitAmount+GLEntries."Debit Amount";
      UNTIL GLEntries.NEXT=0;

      AccBal:='::::'+FORMAT(amount-debitAmount)+':::';
      END;
      }
    END;

    PROCEDURE getMembernames@1000000035(memberno@1000000000 : Code[30]) name : Text[1024];
    BEGIN
      Members.RESET;
      Members.SETRANGE(Members."No.",memberno);//use member number and not account number
      IF Members.FIND('-') THEN BEGIN

        name:=Members.Name+':::'+Members."FOSA Account";
        END;
    END;

    PROCEDURE MiniStatementAPP@1(Phone@1000000000 : Text[20];DocNumber@1000000001 : Text[20];VAR ministmtarr@1000 : BigText;ministmt@1001 : Text);
    BEGIN
      BEGIN
      CLEAR(ministmtarr);
      SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", DocNumber);
      IF SurePESATrans.FIND('-') THEN BEGIN
        ministmt:='REFEXISTS';
      END
      ELSE BEGIN
        ministmt :='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
       // GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Transfer Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Transfer Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",Phone);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
          // TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
             TempBalance:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");
           fosaAcc:=Vendor."No.";

                IF (TempBalance>SurePESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;
                      //end of deletion

                      GenBatches.RESET;
                      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                      GenBatches.SETRANGE(GenBatches.Name,'MOBILETRAN');

                      IF GenBatches.FIND('-') = FALSE THEN BEGIN
                      GenBatches.INIT;
                      GenBatches."Journal Template Name":='GENERAL';
                      GenBatches.Name:='MOBILETRAN';
                      GenBatches.Description:='Mini Statement';
                      GenBatches.VALIDATE(GenBatches."Journal Template Name");
                      GenBatches.VALIDATE(GenBatches.Name);
                      GenBatches.INSERT;
                      END;

              //Dr Mobile Transfer Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Ministatement Charges';
                      GenJournalLine.Amount:=SurePESACharge ;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mini Statement Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;

                      //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','MOBILETRAN');
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Mini Statement';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=Vendor."No.";
                      TotalCharges:=ExcDuty+MobileCharges+SurePESACharge;
                        CloudPESATrans.Charge:=TotalCharges;
                       CloudPESATrans."Account Name":=Vendor.Name;
                          CloudPESATrans."Telephone Number":=Vendor."Phone No.";
                      CloudPESATrans."Account No2" :='';
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans.Posted:=TRUE;
                      CloudPESATrans."Posting Date":=TODAY;
                      CloudPESATrans.Status:=CloudPESATrans.Status::Completed;
                      CloudPESATrans.Comments:='Success';
                      CloudPESATrans.Client:=Vendor."BOSA Account No";
                      CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::Ministatement;
                      CloudPESATrans."Transaction Time":=TIME;
                      CloudPESATrans.INSERT;

                      minimunCount:=1;
                      Vendor.CALCFIELDS(Vendor.Balance);
                      VendorLedgEntry.RESET;
                      VendorLedgEntry.SETCURRENTKEY(VendorLedgEntry."Entry No.");
                      VendorLedgEntry.ASCENDING(FALSE);
                      VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>%1','*Charges*');
                      VendorLedgEntry.SETRANGE(VendorLedgEntry."Vendor No.",Vendor."No.");
                      //VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>*Excise duty*');
                      VendorLedgEntry.SETRANGE(VendorLedgEntry.Reversed,VendorLedgEntry.Reversed::"0");
                    IF VendorLedgEntry.FINDSET THEN BEGIN
                        ministmt:='';
                        REPEAT
                          VendorLedgEntry.CALCFIELDS(VendorLedgEntry.Amount);
                          amount:=VendorLedgEntry.Amount;
                          IF amount<1 THEN
                              amount:= amount*-1;
                              ministmt :=ministmt + FORMAT(VendorLedgEntry."Posting Date") +':::'+ COPYSTR(VendorLedgEntry.Description,1,25) +':::' +
                              FORMAT(amount)+'::::';
                              ministmtarr.ADDTEXT(ministmt);
                              minimunCount:= minimunCount +1;
                              IF minimunCount>10 THEN
                              EXIT
                          UNTIL VendorLedgEntry.NEXT =0;

                     END;
                     END
                     ELSE BEGIN
                       ministmt:='INSUFFICIENT';
                        ministmtarr.ADDTEXT(ministmt);
                     END;
              END
              ELSE BEGIN
                ministmt:='ACCNOTFOUND';
              END;
            END;
            ministmtarr.ADDTEXT(ministmt);
        END;
    END;

    PROCEDURE OutstandingLoansUSSD@1120054000(phone@1000000000 : Code[20]) loanbalances : Text[1024];
    BEGIN
      BEGIN
      Vendor.RESET;
            Vendor.SETRANGE(Vendor."Phone No.",phone)   ;
            IF Vendor.FIND('-') THEN BEGIN

                 LoansRegister.RESET;
                 LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."BOSA Account No");
                IF LoansRegister.FIND('-') THEN BEGIN
                REPEAT
                  LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest",LoansRegister."Interest to be paid",LoansRegister."Interest Paid");
                  IF (LoansRegister."Outstanding Balance">0) THEN
                  loanbalances:= loanbalances + '::::' +LoansRegister."Loan  No." + ':::'+ LoansRegister."Loan Product Type Name" + ':::'+
                   FORMAT(LoansRegister."Outstanding Balance")+':::'+ FORMAT(LoansRegister."Oustanding Interest") ;
                UNTIL LoansRegister.NEXT = 0;
                END;
            END;
       END;
    END;

    LOCAL PROCEDURE PayBillToAccAPI@1120054006(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];Amount@1000000004 : Decimal;accountType@1000000005 : Code[30]) res : Code[10];
    BEGIN
      GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Paybill acc");
         PaybillRecon:=GenLedgerSetup."Paybill acc";
        SurePESACharge:=GetCharge(Amount,'PAYBILL');
         SurePESACommACC:=GenLedgerSetup."CloudPESA Comm Acc";
          ExcDuty:=(20/100)*(SurePESACharge);

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
        GenJournalLine.SETRANGE("Journal Batch Name",batch);
        GenJournalLine.DELETEALL;
        //end of deletion

        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
        GenBatches.SETRANGE(GenBatches.Name,batch);

        IF GenBatches.FIND('-') = FALSE THEN BEGIN
          GenBatches.INIT;
          GenBatches."Journal Template Name":='GENERAL';
          GenBatches.Name:=batch;
          GenBatches.Description:='Paybill Deposit';
          GenBatches.VALIDATE(GenBatches."Journal Template Name");
          GenBatches.VALIDATE(GenBatches.Name);
          GenBatches.INSERT;
        END;//General Jnr Batches


          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", accNo);
          Vendor.SETFILTER(Vendor.Blocked ,'=%1',Vendor.Blocked::" ");
          //Vendor.SETRANGE(Vendor."Account Type", accountType);
            IF Vendor.FIND('-') THEN BEGIN

         Members.RESET;
          Members.SETRANGE(Members."No.", Vendor."BOSA Account No");
         IF Members.FIND('-') THEN BEGIN

            //Dr MPESA PAybill ACC
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
              GenJournalLine."Account No.":=PaybillRecon;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Source No.":=Vendor."No.";
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Deposit';
              GenJournalLine.Amount:=Amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

            //Cr Customer
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
              GenJournalLine."Account No.":=Vendor."No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Deposit';
              GenJournalLine.Amount:=-1*Amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

                  //Dr Customer charges
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
              GenJournalLine."Account No.":=Vendor."No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Paybill Deposit Charges';
              GenJournalLine.Amount:=SurePESACharge;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;
             //DR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":=batch;
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=docNo;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Paybill Deposit';
                      GenJournalLine.Amount:=ExcDuty;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;


              //CR Excise Duty
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":=batch;
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=FORMAT(ExxcDuty);
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Excise duty-Paybill deposit';
                      GenJournalLine.Amount:=ExcDuty*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;
       //CR Surestep Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":=batch;
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Deposit Charges';
                      GenJournalLine.Amount:=-SurePESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;
               END;
               //Vendor
              END;//Member

              //Post
              GenJournalLine.RESET;
              GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
              GenJournalLine.SETRANGE("Journal Batch Name",batch);
              IF GenJournalLine.FIND('-') THEN BEGIN
              REPEAT
                GLPosting.RUN(GenJournalLine);
              UNTIL GenJournalLine.NEXT = 0;

              //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
              PaybillTrans.Posted:=TRUE;
                      PaybillTrans."Date Posted":=TODAY;
                      PaybillTrans.Description:='Posted';
                      PaybillTrans.MODIFY;
                      res:='TRUE';

                   msg:='Dear ' +Members.Name+' your have deposited  KSH. '+ FORMAT(Amount) +' to '+PaybillTrans."Account No"+' MPESA Receipt No. '+docNo +' Thank you for your patronage';
                  SMSMessage('PAYBILLTRANS',Vendor."No.",Vendor."Phone No.",msg);
              END
              ELSE BEGIN
                PaybillTrans."Date Posted":=TODAY;
                      PaybillTrans."Needs Manual Posting":=TRUE;
                      PaybillTrans.Description:='Failed';
                      PaybillTrans.MODIFY;
                      res:='FALSE';
              END;
    END;

    LOCAL PROCEDURE PayBillToBOSAAPI@1120054005(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];amount@1000000004 : Decimal;type@1000000005 : Code[30];descr@1000000006 : Text[100]) res : Code[10];
    BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Paybill acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge:=0;//GenLedgerSetup."CloudPESA Charge";
        PaybillRecon:=GenLedgerSetup."Paybill acc";

        ExcDuty:=(20/100)*SurePESACharge;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
        GenJournalLine.SETRANGE("Journal Batch Name",batch);
        GenJournalLine.DELETEALL;
        //end of deletion

        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
        GenBatches.SETRANGE(GenBatches.Name,batch);

        IF GenBatches.FIND('-') = FALSE THEN BEGIN
          GenBatches.INIT;
          GenBatches."Journal Template Name":='GENERAL';
          GenBatches.Name:=batch;
          GenBatches.Description:=descr;
          GenBatches.VALIDATE(GenBatches."Journal Template Name");
          GenBatches.VALIDATE(GenBatches.Name);
          GenBatches.INSERT;
        END;//General Jnr Batches

          Members.RESET;
          Members.SETRANGE(Members."Phone No.",'+'+PaybillTrans.Telephone);
          Members.SETFILTER(Members.Blocked,'=%1',Members.Blocked::" ");
          IF Members.FIND('-') THEN BEGIN
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", Members."FOSA Account");
          //Vendor.SETRANGE(Vendor."Account Type", fosaConst);
            IF Vendor.FINDFIRST THEN BEGIN

            //Dr MPESA PAybill ACC
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
              GenJournalLine."Account No.":=PaybillRecon;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:=descr;
              GenJournalLine.Amount:=amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

            //Cr Customer
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
              GenJournalLine."Account No.":=Members."No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              CASE PaybillTrans."Account No" OF 'DEPOSIT CONTRIBUTION':
                  GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
              END;
              CASE PaybillTrans."Key Word" OF 'SHARE CAPITAL':
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"SchFee Shares"
              END;
              CASE PaybillTrans."Key Word" OF 'BENEVOLENT FUND':
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";
              END;
              GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
              GenJournalLine.Description:=descr;
              GenJournalLine.Amount:=(amount-SurePESACharge-ExcDuty)*-1;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              //CR Excise Duty
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
              GenJournalLine."Account No.":=FORMAT(ExxcDuty);
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:='Excise duty-'+descr;
              GenJournalLine.Amount:=ExcDuty*-1;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;

              //CR Surestep Acc
              LineNo:=LineNo+10000;
              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='GENERAL';
              GenJournalLine."Journal Batch Name":=batch;
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
              GenJournalLine."Account No.":=SurePESACommACC;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine.Description:=descr+' Charges';
              GenJournalLine.Amount:=-SurePESACharge;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;
               END;//Vendor
              END;//Member

              //Post
              GenJournalLine.RESET;
              GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
              GenJournalLine.SETRANGE("Journal Batch Name",batch);
              IF GenJournalLine.FIND('-') THEN BEGIN
              REPEAT
                GLPosting.RUN(GenJournalLine);
              UNTIL GenJournalLine.NEXT = 0;

              //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
                PaybillTrans.Posted:=TRUE;
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans.Description:='Posted';
                PaybillTrans.MODIFY;
                res:='TRUE';
                msg:='Dear ' +Members.Name+' your have deposited  KSH. '+ FORMAT(amount) +' to '+PaybillTrans."Account No"+' MPESA Receipt No. '+docNo +' Thank you for Telepost sacco mobile';
                  SMSMessage('PAYBILLTRANS',Members."No.",PaybillTrans.Telephone,msg);

              END
              ELSE BEGIN
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans."Needs Manual Posting":=TRUE;
                PaybillTrans.Description:='Failed';
                PaybillTrans.MODIFY;
                res:='FALSE';
              END;
    END;

    LOCAL PROCEDURE PayBillToLoanAPI@1120054004(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];amount@1000000004 : Decimal;type@1000000005 : Code[30]) res : Code[10];
    VAR
      paidamt@1120054000 : Decimal;
      newloanAmt@1120054001 : Decimal;
    BEGIN
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Paybill acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
        SurePESACharge:=0;//GenLedgerSetup."CloudPESA Charge";
        PaybillRecon:=GenLedgerSetup."Paybill acc";

      paidamt:=amount;
        ExcDuty:=(20/100)*SurePESACharge;

       GenJournalLinePaybill.RESET;
       GenJournalLinePaybill.SETRANGE("Journal Template Name",'GENERAL');
       GenJournalLinePaybill.SETRANGE("Journal Batch Name",batch);
       GenJournalLinePaybill.DELETEALL;
        //end of deletion

        GenBatches.RESET;
        GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
        GenBatches.SETRANGE(GenBatches.Name,batch);

        IF GenBatches.FIND('-') = FALSE THEN BEGIN
          GenBatches.INIT;
          GenBatches."Journal Template Name":='GENERAL';
          GenBatches.Name:=batch;
          GenBatches.Description:='Paybill Loan Repayment';
          GenBatches.VALIDATE(GenBatches."Journal Template Name");
          GenBatches.VALIDATE(GenBatches.Name);
          GenBatches.INSERT;
        END;//General Jnr Batches


             LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Loan  No.",accNo);
              IF LoansRegister.FIND('+') THEN BEGIN
              Members.RESET;
              Members.SETRANGE(Members."No.", LoansRegister."Client Code");
              IF Members.FIND('-') THEN BEGIN
              Vendor.RESET;
              Vendor.SETRANGE(Vendor."No.", Members."FOSA Account");
           //   Vendor.SETRANGE(Vendor."Account Type", fosaConst);
                IF Vendor.FINDFIRST THEN BEGIN


              LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
             IF LoansRegister."Outstanding Balance" > 0 THEN BEGIN

            //Dr MPESA PAybill ACC
              LineNo:=LineNo+10000;
              GenJournalLinePaybill.INIT;
              GenJournalLinePaybill."Journal Template Name":='GENERAL';
              GenJournalLinePaybill."Journal Batch Name":=batch;
              GenJournalLinePaybill."Line No.":=LineNo;
              GenJournalLinePaybill."Account Type":=GenJournalLinePaybill."Account Type"::"Bank Account";
              GenJournalLinePaybill."Account No.":=PaybillRecon;
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill."Account No.");
              GenJournalLinePaybill."Document No.":=docNo;
              GenJournalLinePaybill."External Document No.":=docNo;
              GenJournalLinePaybill."Posting Date":=TODAY;
              GenJournalLinePaybill.Description:='Paybill Loan Repayment';
              GenJournalLinePaybill.Amount:=amount;
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill.Amount);
              IF GenJournalLinePaybill.Amount<>0 THEN
              GenJournalLinePaybill.INSERT;

              IF LoansRegister."Oustanding Interest">0 THEN BEGIN
              LineNo:=LineNo+10000;

              GenJournalLinePaybill.INIT;
              GenJournalLinePaybill."Journal Template Name":='GENERAL';
              GenJournalLinePaybill."Journal Batch Name":=batch;
              GenJournalLinePaybill."Line No.":=LineNo;
              GenJournalLinePaybill."Account Type":=GenJournalLinePaybill."Account Type"::Member;
              GenJournalLinePaybill."Account No.":=LoansRegister."Client Code";
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill."Account No.");
              GenJournalLinePaybill."Document No.":=docNo;
              GenJournalLinePaybill."External Document No.":=docNo;
              GenJournalLinePaybill."Posting Date":=TODAY;
              GenJournalLinePaybill.Description:='Loan Interest Payment';


              IF amount > LoansRegister."Oustanding Interest" THEN
              GenJournalLinePaybill.Amount:=-LoansRegister."Oustanding Interest"
              ELSE
              GenJournalLinePaybill.Amount:=-amount;
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill.Amount);
              GenJournalLinePaybill."Transaction Type":=GenJournalLinePaybill."Transaction Type"::"Interest Paid";

              IF GenJournalLinePaybill."Shortcut Dimension 1 Code" = '' THEN BEGIN
              GenJournalLinePaybill."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill."Shortcut Dimension 1 Code");
              END;
              GenJournalLinePaybill."Loan No":=LoansRegister."Loan  No.";
              IF GenJournalLinePaybill.Amount<>0 THEN
              GenJournalLinePaybill.INSERT;

              amount:=amount+GenJournalLinePaybill.Amount;
              END;
              IF amount>0 THEN BEGIN
              LineNo:=LineNo+10000;

              GenJournalLinePaybill.INIT;
              GenJournalLinePaybill."Journal Template Name":='GENERAL';
              GenJournalLinePaybill."Journal Batch Name":=batch;
              GenJournalLinePaybill."Line No.":=LineNo;
              GenJournalLinePaybill."Account Type":=GenJournalLinePaybill."Account Type"::Member;
              GenJournalLinePaybill."Account No.":=LoansRegister."Client Code";
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill."Account No.");
              GenJournalLinePaybill."Document No.":=docNo;
              GenJournalLinePaybill."External Document No.":='';
              GenJournalLinePaybill."Posting Date":=TODAY;
              GenJournalLinePaybill.Description:='Paybill Loan Repayment';
              GenJournalLinePaybill.Amount:=-amount;
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill.Amount);
              GenJournalLinePaybill."Transaction Type":=GenJournalLinePaybill."Transaction Type"::Repayment;
              IF GenJournalLinePaybill."Shortcut Dimension 1 Code" = '' THEN BEGIN
              GenJournalLinePaybill."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
              GenJournalLinePaybill.VALIDATE(GenJournalLinePaybill."Shortcut Dimension 1 Code");
              END;
              GenJournalLinePaybill."Loan No":=LoansRegister."Loan  No.";
              IF GenJournalLinePaybill.Amount<>0 THEN
              GenJournalLinePaybill.INSERT;
              END;


                  END//Outstanding Balance
                 END//Loan Register
               END;//Vendor
              END;//Member

              //Post
              GenJournalLinePaybill.RESET;
              GenJournalLinePaybill.SETRANGE("Journal Template Name",'GENERAL');
              GenJournalLinePaybill.SETRANGE("Journal Batch Name",batch);
              IF GenJournalLinePaybill.FIND('-') THEN BEGIN
              REPEAT
                GLPosting.RUN(GenJournalLinePaybill);
              UNTIL GenJournalLinePaybill.NEXT = 0;

             // TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
                PaybillTrans.Posted:=TRUE;
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans.Description:='Posted';
                PaybillTrans.MODIFY;
                res:='TRUE';

              LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Loan  No.",accNo);
              IF LoansRegister.FIND('+') THEN BEGIN
              LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
                newloanAmt:=LoansRegister."Oustanding Interest"+LoansRegister."Outstanding Balance";
              END;
                  msg:='Dear ' +Members.Name+', your have paid KSH. '+ FORMAT(paidamt) +' for '+LoansRegister."Loan Product Type Name"+'. Your new loan balance is Ksh. ' +FORMAT(newloanAmt)+
                  ' Thank you for your patronage';
                  SMSMessage('PAYBILLTRANS',Members."No.",PaybillTrans.Telephone,msg);

              END
              ELSE BEGIN
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans."Needs Manual Posting":=TRUE;
                PaybillTrans.Description:='Failed';
                PaybillTrans.MODIFY;
                res:='FALSE';
              END;
    END;

    LOCAL PROCEDURE fnInsertEligibity@1120054008(account@1120054000 : Code[50];name@1120054001 : Code[100];status@1120054002 : Decimal;Loanamt@1120054003 : Decimal;desc@1120054004 : Text);
    VAR
      ObjAdvace@1120054005 : Record 51516523;
    BEGIN

       ObjAdvace.RESET;
          IF ObjAdvace.FIND('+') THEN BEGIN
          iEntryNo:=ObjAdvace."Entry NO";
          iEntryNo:=iEntryNo+1;
          END
          ELSE BEGIN
          iEntryNo:=1;
          END;
      ObjAdvace.RESET;
      ObjAdvace.INIT;
      ObjAdvace."Entry NO":=iEntryNo;
      ObjAdvace.Account:=account;
      ObjAdvace.Name:=name;
      ObjAdvace.Status:=status;
      ObjAdvace."Loan type":=ObjAdvace."Loan type"::"Mobile Loan";
      ObjAdvace."Loan Amount":=Loanamt;
      ObjAdvace.Date:=TODAY;
      ObjAdvace.Description:=desc;
      ObjAdvace.Datetime:=CURRENTDATETIME;
      ObjAdvace.INSERT;
    END;

    PROCEDURE UpdateDeliveryStatus@1120054009();
    BEGIN
    END;

    LOCAL PROCEDURE Updatepenalytdate@1120054010();
    BEGIN
      MpesaDisbus.RESET;
      MpesaDisbus.SETRANGE(MpesaDisbus."Delivery Center",'MPESA');
      IF MpesaDisbus.FIND('-') THEN  BEGIN

        REPEAT
          IF MpesaDisbus."Penalty Date"<>0D THEN BEGIN
          MpesaDisbus."Penalty Date":=CALCDATE('2Y',MpesaDisbus."Document Date");
          MpesaDisbus.MODIFY;
          END;

          UNTIL MpesaDisbus.NEXT=0;

      END;
    END;

    PROCEDURE ChargeSMS@1120054011();
    VAR
      SMSCharges@1120054000 : Record 51516554;
      SMSCharge@1120054001 : Decimal;
      ExDuty@1120054002 : Decimal;
      Doc@1120054003 : Code[50];
      External_Doc@1120054004 : Code[100];
      SmsChargeAcc@1120054005 : Code[100];
      TransactionType@1120054006 : ' ,Registration Fee,Share Capital,Interest Paid,Loan Repayment,Deposit Contribution,Insurance Contribution,Benevolent Fund,Loan,Unallocated Funds,Dividend,FOSA Account';
      batch@1120054007 : Code[100];
    BEGIN

        SMSMessages.RESET;

        SMSMessages.SETCURRENTKEY(SMSMessages."Entry No");
        SMSMessages.SETASCENDING(SMSMessages."Entry No",FALSE);
        SMSMessages.SETRANGE(SMSMessages."Date Entered",TODAY);
        SMSMessages.SETRANGE(SMSMessages."Sent To Server", SMSMessages."Sent To Server"::Yes);
        SMSMessages.SETRANGE(SMSMessages."Entry No.",'SUCCESS');
        SMSMessages.SETFILTER(SMSMessages."Telephone No",'<>%1','');
        SMSMessages.SETRANGE(SMSMessages.Charged,FALSE);
        IF SMSMessages.FIND('-') THEN

              BEGIN


               SMSCharges.RESET;
               SMSCharges.SETRANGE(SMSCharges.Source,SMSMessages.Source);
              IF SMSCharges.FIND('-') THEN BEGIN
              //  SMSCharges.TESTFIELD(SMSCharges."Charge Account");
                SMSCharge:=SMSCharges.Amount;
                ExDuty:=(20/100)*SMSCharge;
               END;
               batch:='SMSCHARGES';
                Vendor.RESET;
                Vendor.SETRANGE(Vendor."No.",SMSMessages."Account No");
                IF Vendor.FIND('-') THEN BEGIN
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                    GenJournalLine.SETRANGE("Journal Batch Name",batch);
                    GenJournalLine.DELETEALL;
                    //end of deletion

                    GenBatches.RESET;
                    GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                    GenBatches.SETRANGE(GenBatches.Name,batch);

                    IF GenBatches.FIND('-') = FALSE THEN BEGIN
                    GenBatches.INIT;
                    GenBatches."Journal Template Name":='GENERAL';
                    GenBatches.Name:=batch;
                    GenBatches.Description:='SMS Charges';
                    GenBatches.VALIDATE(GenBatches."Journal Template Name");
                    GenBatches.VALIDATE(GenBatches.Name);
                    GenBatches.INSERT;
                    END;

                    Doc:=FORMAT(SMSMessages."Entry No");
                    External_Doc:=SMSMessages.Source;
                    SmsChargeAcc:=SMSCharges."Charge Account";

                    //DR Member Account

                            LineNo:=LineNo+10000;
                            SurestepFactory.FnCreateGnlJournalLineCloud('GENERAL',batch,Doc,LineNo,TransactionType::" ",
                            GenJournalLine."Account Type"::Vendor,Vendor."No.",TODAY,SMSCharge,'FOSA',
                            External_Doc,'SMS Charges','');
                            //Cr SMS Charges Acc

                            LineNo:=LineNo+10000;
                            SurestepFactory.FnCreateGnlJournalLineCloud('GENERAL',batch,Doc,LineNo,TransactionType::" ",
                            GenJournalLine."Account Type"::"G/L Account",SmsChargeAcc,TODAY,-SMSCharge,'FOSA',
                            External_Doc,'SMS Charges','');

                          //credit excc
                           LineNo:=LineNo+10000;
                            SurestepFactory.FnCreateGnlJournalLineCloud('GENERAL',batch,Doc,LineNo,TransactionType::" ",
                            GenJournalLine."Account Type"::Vendor,Vendor."No.",TODAY,ExDuty,'FOSA',
                            External_Doc,'Excise duty-SMS Notification','');

                            //Cr Ex Acc
                            LineNo:=LineNo+10000;
                               SurestepFactory.FnCreateGnlJournalLineCloud('GENERAL',batch,Doc,LineNo,TransactionType::" ",
                            GenJournalLine."Account Type"::"G/L Account",ExxcDuty,TODAY,-ExDuty,'FOSA',
                            External_Doc,'Excise duty-SMS Notification','');





                            //Post
                            GenJournalLine.RESET;
                            GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                            GenJournalLine.SETRANGE("Journal Batch Name",batch);
                            IF GenJournalLine.FIND('-') THEN BEGIN
                            REPEAT
                            GLPosting.RUN(GenJournalLine);
                           UNTIL GenJournalLine.NEXT = 0;
                            END;

                           //TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL',batch);
                           //END;


                          END;
                           SMSMessages.Charged:=TRUE;
                            SMSMessages.MODIFY;

                          END;


    END;

    LOCAL PROCEDURE FnGetAccountBal@1120054014(accountNo@1120054000 : Code[100]) Bal : Decimal;
    BEGIN
      Bal:=0;
      Vendor.RESET;
        Vendor.SETRANGE(Vendor."BOSA Account No",accountNo);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
        Vendor.SETRANGE(Vendor."Account Type",'ORDINARY');
        IF Vendor.FIND('-') THEN BEGIN
          AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
        Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           Bal:=SurestepFactory.FnGetAccountAvailableBalance(Vendor."No.");
        //   Bal:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+TempBalance+miniBalance);
      END;
    END;

    LOCAL PROCEDURE FnSendSMSNotification@1120054013();
    VAR
      PrincipalAmount@1120054000 : Decimal;
      TransactionLoanDiff@1120054001 : Decimal;
      LoanSMSNotice@1120054002 : Record 51516568;
      loanNotificationDate@1120054003 : Date;
      LoanRepay@1120054004 : Record 51516234;
      repayamt@1120054005 : Decimal;
      Loanbal@1120054006 : Decimal;
      amtsecondnotice@1120054007 : Decimal;
      ExpectedLoanDate@1120054008 : Date;
      amountPayed@1120054009 : Decimal;
    BEGIN
       //===============================================================loans
                    LoansRegister.RESET;
                    LoansRegister.SETRANGE(LoansRegister.Posted,TRUE);
                    //LoansRegister.SETRANGE(LoansRegister."Loan  No.",'LN010904');
                    LoansRegister.CALCFIELDS(LoansRegister."Oustanding Interest",LoansRegister."Outstanding Balance");
                     LoansRegister.SETFILTER(LoansRegister."Loan Product Type",'<>%1','A03');
                    LoansRegister.SETFILTER(LoansRegister."Outstanding Balance", '>%1',0);
                    IF LoansRegister.FIND('-') THEN BEGIN
                       REPEAT
                     // IF LoansRegister."Repayment Start Date"<> 0D THEN
                        //sFactory.FnGenerateLoanSchedule( LoansRegister."Loan  No.");
                     PrincipalAmount:=0;
                     TransactionLoanDiff:=0;
                     LoansRegister.CALCFIELDS(LoansRegister."Oustanding Interest",LoansRegister."Outstanding Balance");

                    LoanSMSNotice.RESET;
                    LoanSMSNotice.SETRANGE(LoanSMSNotice."Loan No",LoansRegister."Loan  No.");
                    IF LoanSMSNotice.FIND('-') =FALSE THEN BEGIN
                      LoanSMSNotice.RESET;
                     IF LoanSMSNotice.FIND('+') THEN BEGIN
                    iEntryNo:=LoanSMSNotice."Entry No";
                    iEntryNo:=iEntryNo+1;
                    END
                    ELSE BEGIN
                    iEntryNo:=1;
                    END;
                      LoanSMSNotice.INIT;
                      LoanSMSNotice."Entry No":=iEntryNo;
                      LoanSMSNotice."Loan No":=LoansRegister."Loan  No.";
                      LoanSMSNotice.INSERT;
                     END;

                    ExpectedLoanDate:=CALCDATE('CM',TODAY);

                    LoanSMSNotice.RESET;
                    LoanSMSNotice.SETRANGE(LoanSMSNotice."Loan No",LoansRegister."Loan  No.");
                     IF LoanSMSNotice.FIND('-')  THEN BEGIN
            // ============ifNot has arreas
                    loanNotificationDate:=TODAY;
                    TransactionLoanDiff:=LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest";
                    amountPayed:=FnGetOutstandingBal(LoansRegister."Loan  No.",LoansRegister.Repayment,TransactionLoanDiff);

                      Members.RESET;
                      Members.GET(LoansRegister."Client Code");
                    IF amountPayed>0 THEN BEGIN


            //========== send if due date is today
                      LoanRepay.RESET;
                      LoanRepay.SETRANGE(LoanRepay."Loan No.",LoansRegister."Loan  No.");
                      LoanRepay.SETRANGE(LoanRepay."Repayment Date",TODAY);
                      IF LoanRepay.FIND('-') THEN BEGIN

                           IF (LoanSMSNotice."SMS Due Date today"=0D)  THEN BEGIN
                              LoanSMSNotice."SMS Due Date today":=CALCDATE('1M',TODAY);
                              LoanSMSNotice.MODIFY;

                               msg:='Dear '+Members.Name+', Your monthly loan repayment for '+LoansRegister."Loan Product Type Name"+' of Ksh. '
                               +FORMAT(amountPayed,0,'<Precision,2><sign><Integer Thousand><Decimals,3>')
                               +' is due today. Contact 0205029200 for Enquiries';
                              SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg)

                     END;
                     IF (LoanSMSNotice."SMS Due Date today"<>0D)  THEN BEGIN

                       IF LoanSMSNotice."SMS Due Date today">=TODAY THEN BEGIN
                              LoanSMSNotice."SMS Due Date today":=CALCDATE('1M',TODAY);
                              LoanSMSNotice.MODIFY;

                               msg:='Dear '+Members.Name+', Your monthly loan repayment for '+LoansRegister."Loan Product Type Name"+' of Ksh. '
                               +FORMAT(amountPayed,0,'<Precision,2><sign><Integer Thousand><Decimals,3>')
                               +' is due today. Contact 0205029200 for Enquiries';
                              SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg)
                          END;
                     END;
                  END;

            //========== send if due date is  7 Day

                    LoanRepay.RESET;
                    LoanRepay.SETRANGE(LoanRepay."Loan No.",LoansRegister."Loan  No.");
                    LoanRepay.SETRANGE(LoanRepay."Repayment Date",CALCDATE('-7D',TODAY));
                    IF LoanRepay.FIND('-') THEN BEGIN
                     // ERROR('amount to pay..%1',amountPayed);
                         IF (LoanSMSNotice."SMS 7 Day"=0D) THEN BEGIN
                            LoanSMSNotice."SMS 7 Day":=CALCDATE('1M',CALCDATE('-7D',TODAY));
                            LoanSMSNotice.MODIFY;
                             msg:='Dear '+Members.Name+', Your monthly loan repayment for '+LoansRegister."Loan Product Type Name"+' of Ksh. '
                             +FORMAT(amountPayed,0,'<Precision,2><sign><Integer Thousand><Decimals,3>')
                             +' is due within next 7 days'
                            +' . contact 0205029200 for Enquiries';
                            SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);

                      END;
                      IF (LoanSMSNotice."SMS 7 Day"<>0D) THEN BEGIN
                          IF  LoanSMSNotice."SMS 7 Day">=TODAY THEN BEGIN
                            LoanSMSNotice."SMS 7 Day":=CALCDATE('1M',CALCDATE('-7D',TODAY));
                            LoanSMSNotice.MODIFY;
                             msg:='Dear '+Members.Name+', Your monthly loan repayment for '+LoansRegister."Loan Product Type Name"+' of Ksh. '
                             +FORMAT(amountPayed,0,'<Precision,2><sign><Integer Thousand><Decimals,3>')
                             +' is due within next 7 days'
                            +' . contact 0205029200 for Enquiries';
                            SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);
                            END;
                      END;
                    END;


       //========== send if due date is after due date 7days

                   LoanRepay.RESET;
                    LoanRepay.SETRANGE(LoanRepay."Loan No.",LoansRegister."Loan  No.");
                    LoanRepay.SETRANGE(LoanRepay."Repayment Date",CALCDATE('7D',TODAY));
                    IF LoanRepay.FIND('-') THEN BEGIN

                         IF (LoanSMSNotice."Notice SMS 1"=0D)   THEN BEGIN
                            LoanSMSNotice."Notice SMS 1":=CALCDATE('1M',CALCDATE('7D',TODAY));
                            LoanSMSNotice.MODIFY;
                             msg:='Dear '+SplitString(Members.Name,' ')+', Your monthly loan repayment for '+LoansRegister."Loan Product Type Name"+' of Ksh. '
                             +FORMAT(amountPayed,0,'<Precision,2><sign><Integer Thousand><Decimals,3>')
                             +' was due last 7 days'
                            +' . Contact 0205029200 for Enquiries ';
                            SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);

                   END;
                     IF (LoanSMSNotice."Notice SMS 1"<>0D)   THEN BEGIN
                       IF LoanSMSNotice."Notice SMS 1">=TODAY THEN BEGIN
                            LoanSMSNotice."Notice SMS 1":=CALCDATE('1M',CALCDATE('7D',TODAY));
                            LoanSMSNotice.MODIFY;
                             msg:='Dear '+SplitString(Members.Name,' ')+', Your monthly loan repayment for '+LoansRegister."Loan Product Type Name"+' of Ksh. '
                             +FORMAT(amountPayed,0,'<Precision,2><sign><Integer Thousand><Decimals,3>')
                             +' was due last 7 days'
                            +' . Contact 0205029200 for Enquiries ';
                            SMSMessage(LoansRegister."Doc No Used",LoansRegister."Client Code",Members."Phone No.",msg);
                            END;

                   END;

                    END;
                    END;//LOAN NOTICE TBL
                   END;



                    UNTIL LoansRegister.NEXT=0;
            END;
          //END;
    END;

    LOCAL PROCEDURE FnGetOutstandingBal@1120054019(loanNo@1120054000 : Code[100];LoanMonthly@1120054001 : Decimal;loanBal@1120054002 : Decimal) amout : Decimal;
    VAR
      AmountPaid@1120054003 : Decimal;
    BEGIN
      amout:=0;
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Loan No",loanNo);
            MemberLedgerEntry.SETFILTER(MemberLedgerEntry."Transaction Type", '=%1',MemberLedgerEntry."Transaction Type"::Repayment);
            MemberLedgerEntry.SETFILTER(MemberLedgerEntry."Posting Date", FORMAT(CALCDATE('CM + 1D - 1M',TODAY))+'..'+FORMAT(CALCDATE('CM',TODAY)));
            MemberLedgerEntry.CALCSUMS(MemberLedgerEntry."Credit Amount (LCY)");
            AmountPaid:=MemberLedgerEntry."Credit Amount (LCY)";
            IF (AmountPaid>=LoanMonthly) THEN BEGIN
              amout:=0;
              EXIT;
              END;

            IF LoanMonthly>=AmountPaid THEN BEGIN
              IF loanBal<LoanMonthly THEN BEGIN
              amout:=loanBal-AmountPaid;
              END;
                amout:=LoanMonthly-AmountPaid;
              END ELSE
                amout:=LoanMonthly;
    END;

    BEGIN
    END.
  }
}

