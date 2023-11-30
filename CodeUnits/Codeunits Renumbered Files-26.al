OBJECT CodeUnit 20390 CloudPESA Live maga
{
  OBJECT-PROPERTIES
  {
    Date=09/19/19;
    Time=[ 6:50:34 PM];
    Modified=Yes;
    Version List=CloudPESA;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            //MESSAGE(AccountBalance('5-02-30006085-00','9148826'));
            //MESSAGE(InsertTransaction('1745500H1','DEV','07859','KOECH TEST','0723214181',600,2000));
            //MESSAGE(PaybillSwitch());
             //MESSAGE(LoanGuarantors('BLN00002')) ; working
              //ERROR('tEST ONE AccountBalanceDec('5-02-30006085-00',10)));
            //MESSAGE(AccountBalanceNew('5-02-40000106-00','145477000011'));
            //MESSAGE(AccountBalanceNew('5-02-30006085-00','983788l5088'));
            //MESSAGE(MiniStatement('  0726455429','2618529634568'));

            //MESSAGE(LoanBalances('254722701543')); // working
            //MESSAGE(PostMPESATrans('MLB9GO7TOJ.','5-06-90000064-00',1000,111218D));
            //MESSAGE(LoansGuaranteed('726455429'));
            //MESSAGE(LoanGuarantors('BLN2623'));
            //MESSAGE(OutstandingLoansUSSD('711110323'));
            //MESSAGE(LoanRepayment('5-02-30006085-00','BLN0039','LNRU781111986',1000));
            //MESSAGE(OutstandingLoans('726455429'));
            //fnStatemenTmember('5-02-40000063-00','5-02-40000063-00.pdf','5');
            //MESSAGE(PostAdvance('0004320000093','5-02-20000066-00',4000,1,'M-JIENJOY'));
            //  END
            //MESSAGE(FORMAT(AdvanceEligibilityDividend('5-02-40000106-00','M-DIV')))
            //MESSAGE(FORMAT(AdvanceEligibility('5-02-40000106-00','M-JIENJOY',1)));
            //MESSAGE(ClientCodes('A12132'));
            //MESSAGE(FundsTransferFOSA('5-02-30006085-00','5-02-30006094-00','00220002222',200)); ok
            //MESSAGE(FundsTransferBOSA('5-02-30006090-00','Deposit Contribution','1152211008521',1000));
            //MESSAGE(SharesUSSD('726455429','25699')); //no amounts
            //MESSAGE(MemberAccountNumbers('0722472345'));
          END;

  }
  CODE
  {
    VAR
      Vendor@1000000000 : Record 23;
      AccountTypes@1000000002 : Record 51516436;
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
      CloudPESAApplications@1000000001 : Record 51516521;
      GenJournalLine@1000000019 : Record 81;
      GenBatches@1000000018 : Record 232;
      LineNo@1000000020 : Integer;
      GLPosting@1000000021 : Codeunit 12;
      CloudPESATrans@1000000022 : Record 51516522;
      GenLedgerSetup@1000000023 : Record 98;
      Charges@1000000024 : Record 51516439;
      MobileCharges@1000000025 : Decimal;
      MobileChargesACC@1000000026 : Text[20];
      CloudPESACommACC@1000000027 : Code[20];
      CloudPESACharge@1000000028 : Decimal;
      ExcDuty@1000000029 : Decimal;
      TempBalance@1000000030 : Decimal;
      SMSMessages@1000000032 : Record 51516329;
      iEntryNo@1000000033 : Integer;
      msg@1000000034 : Text[1024];
      accountName1@1000000035 : Text[40];
      accountName2@1000000036 : Text[40];
      fosaAcc@1000000037 : Text[30];
      LoanGuaranteeDetails@1000000038 : Record 51516231;
      bosaNo@1000000039 : Text[20];
      MPESARecon@1000000042 : Text[20];
      TariffDetails@1000000041 : Record 51516273;
      MPESACharge@1000000040 : Decimal;
      TotalCharges@1000000043 : Decimal;
      ExxcDuty@1000000044 : TextConst 'ENU=22018';
      PaybillTrans@1000000045 : Record 51516098;
      PaybillRecon@1000000046 : Code[30];
      fosaConst@1000000047 : TextConst 'ENU=101';
      ChargeAmount@1000000017 : Decimal;
      glamount@1000000031 : Decimal;
      FreeShares@1000000048 : Decimal;
      LoanGuard@1000000049 : Record 51516231;
      GenSetup@1000000050 : Record 51516257;
      GLEntries@1000000051 : Record 17;
      loanamount@1000000052 : Decimal;
      Nrsbuffer@1000000053 : Record 51516240;
      DailyInterestAccrued@1000000054 : Decimal;
      LoanType@1000000055 : Record 51516240;
      membershares@1000000056 : Text[50];
      SurePESATrans@1000 : Record 51516522;
      SURESTEPFACTORY@1007 : CodeUnit 20376;
      SMTP@1006 : Codeunit 400;
      UserSetup@1005 : Record 91;
      TextBody@1004 : Text;
      TextMessage@1003 : Text;
      SMTPSetup@1002 : Record 409;
      EmailSend@1001 : Boolean;
      TCount@1013 : Integer;
      Sal1@1012 : Decimal;
      Sal2@1011 : Decimal;
      Salarybal@1010 : Decimal;
      interestRate@1008 : Decimal;
      Sal3@1009 : Decimal;
      SalaryAverage@1014 : Decimal;
      LoanArrears@1015 : Decimal;
      MonthlyLoanRepayments@1016 : Decimal;
      DivBuffer@1017 : Record 51516240;
      MbankingBuffer@1018 : Record 51516066;
      CrbAdvance@1019 : Record 5405;

    PROCEDURE AccountBalance@1000000001(Acc@1000000000 : Code[30];DocNumber@1000000001 : Code[20]) Bal : Text[500];
    BEGIN
      {BEGIN
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        Bal:='REFEXISTS';
      END
      ELSE BEGIN
        GenSetup.GET();
        Bal:='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;

          ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",Acc);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
            AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Vendor."Account Type")  ;
              IF AccountTypes.FIND('-') THEN
              BEGIN
                miniBalance:=AccountTypes."Minimum Balance";
              END;
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance);

                IF Vendor."Account Type"='502' THEN
                BEGIN
                IF (TempBalance>MobileCharges+CloudPESACharge) THEN BEGIN
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

              //Dr Mobile Transfer Charges
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
                      GenJournalLine.Amount:=(MobileCharges+CloudPESACharge);
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
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
                      GenJournalLine."Posting Date":=TODAY;
                       GenJournalLine."Source No.":=Vendor."No.";
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Balance Enquiry';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=Vendor."No.";
                      CloudPESATrans."Account No2" :='';
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans."Account Name":=Vendor.Name;
                      CloudPESATrans.Posted:=TRUE;
                      CloudPESATrans."Posting Date":=TODAY;
                      CloudPESATrans.Status:=CloudPESATrans.Status::Completed;
                      CloudPESATrans.Comments:='Success';
                      CloudPESATrans.Client:=Vendor."BOSA Account No";
                      CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::Balance;
                      CloudPESATrans."Transaction Time":=TIME;
                      CloudPESATrans.INSERT;
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
                      Bal:=FORMAT(accBalance);
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
      }
    END;

    PROCEDURE MiniStatement@1000000010(Phone@1000000000 : Text[20];DocNumber@1000000001 : Text[20]) MiniStmt : Text[250];
    BEGIN
      {BEGIN
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        MiniStmt:='REFEXISTS';
      END
      ELSE BEGIN
        MiniStmt :='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");
        GenSetup.GET();
        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileChargesACC:=Charges."GL Account";
          MobileCharges:=Charges."Charge Amount";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;

       CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,Phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
        IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
           fosaAcc:=Vendor."No.";

                IF (TempBalance>CloudPESACharge) THEN BEGIN
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
                      GenJournalLine.Amount:=CloudPESACharge + MobileCharges ;
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mini Statement Charges';
                      GenJournalLine.Amount:=-(CloudPESACharge + MobileCharges);
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                      //Charge Excise Duty
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
                      GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine.Description:='Excise Duty - Ministatement';
                      GenJournalLine.Amount:=(CloudPESACharge + MobileCharges) * GenSetup."Excise Duty(%)"/100 ;
                      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                      GenJournalLine."Bal. Account No.":=GenSetup."Excise Duty Account";
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Mini Statement';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=Vendor."No.";
                      CloudPESATrans."Account No2" :='';
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans."Account Name":=Vendor.Name;
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
                        MiniStmt:='';
                        REPEAT
                          VendorLedgEntry.CALCFIELDS(VendorLedgEntry.Amount);
                          amount:=VendorLedgEntry.Amount;
                          IF amount<1 THEN
                              amount:= amount*-1;
                              MiniStmt :=MiniStmt + FORMAT(VendorLedgEntry."Posting Date") +':::'+ COPYSTR(VendorLedgEntry.Description,1,25) +':::' +
                              FORMAT(amount)+'::::';
                              minimunCount:= minimunCount +1;
                              IF minimunCount>5 THEN
                              EXIT
                          UNTIL VendorLedgEntry.NEXT =0;
                     END;
                     END
                     ELSE BEGIN
                       MiniStmt:='INSUFFICIENT';
                     END;
              END
              ELSE BEGIN
                MiniStmt:='ACCNOTFOUND';
              END;
            END;
        END;
        END;
      }
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
      {Vendor.RESET;
      Vendor.SETRANGE(Vendor."Phone No.",Phone);
      IF Vendor.FIND('-') THEN BEGIN
        Members.RESET;
        Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
        IF Members.FIND('-') THEN BEGIN
          bosaAcc:=Members."FOSA Account No.";
        END;
      END;
      }
    END;

    PROCEDURE MemberAccountNumbers@1000000006(phone@1000000000 : Text[20]) accounts : Text[250];
    BEGIN
      BEGIN
       CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."ID No.",CloudPESAApplications."ID No");
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
    END;

    PROCEDURE RegisteredMemberDetails@1000000003(Phone@1000000000 : Text[20]) reginfo : Text[250];
    BEGIN
      {  BEGIN
        CloudPESAApplications.RESET;
        CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,Phone);
        CloudPESAApplications.SETRANGE(Status,CloudPESAApplications.Status::Approved);
        IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.", CloudPESAApplications."Account No");
       // Vendor.SETRANGE(Vendor.
        IF Vendor.FIND('-') THEN
         BEGIN
           //REPEAT
            Members.RESET;
            Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
            IF Members.FIND('-') THEN
            BEGIN
            reginfo:=Members."No."+':::'+Members.Name+':::'+FORMAT(Members."ID No.")+':::'+Members."Personal No"+':::'+ Members."E-Mail";
            END;
           // UNTIL Members.NEXT=0;
        END
        ELSE
        BEGIN
        reginfo:='';
        END
        END;
        END;
      }
    END;

    PROCEDURE DetailedStatement@1000000019(Phone@1000000000 : Text[20];lastEntry@1000000001 : Integer) detailedstatement : Text[1023];
    BEGIN
      {BEGIN
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
                  //DetailedVendorLedgerEntry.SETFILTER(DetailedVendorLedgerEntry."Entry No.",'>%1',lastEntry);
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
      }
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
      {BEGIN
      amount:=0;
        CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
        IF Vendor.FIND('-') THEN BEGIN
              Members.RESET;
              Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
              IF  Members.FIND('-') THEN BEGIN
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Share Capital");
            IF MemberLedgerEntry.FIND('-') THEN
              REPEAT
                  amount:=amount+MemberLedgerEntry.Amount;
                  shares:= FORMAT(amount,STRLEN(FORMAT(amount)),'<Integer Thousand><Decimals>');
                  UNTIL MemberLedgerEntry.NEXT =0;
              END;
              IF shares='' THEN BEGIN
              shares:='0';
              END;
              END;

          END;
          END;
      }
    END;

    PROCEDURE LoanBalances@1000000017(phone@1000000000 : Text[20]) loanbalances : Text[250];
    BEGIN
      BEGIN
      CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
        IF Vendor.FIND('-') THEN BEGIN
              Members.RESET;
              Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
              IF  Members.FIND('-') THEN BEGIN
               //MESSAGE('And %1',Vendor."BOSA Account No");
                LoansRegister.RESET;
                LoansRegister.SETRANGE(LoansRegister."Client Code",Members."No.");
                IF LoansRegister.FIND('-') THEN BEGIN
                REPEAT
                  LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest",LoansRegister."Interest to be paid",LoansRegister."Interest Paid");
                  IF (LoansRegister."Outstanding Balance">0)OR(LoansRegister."Oustanding Interest">0) THEN
                   loanbalances:= loanbalances + '::::' +LoansRegister."Loan  No." + ':::'+ LoansRegister."Loan Product Type Name" + ':::'+
                   FORMAT(LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest") ;
                UNTIL LoansRegister.NEXT = 0;
                END;
                END;

            END;
       END;
       END;
    END;

    PROCEDURE MemberAccounts@1000000000(phone@1000000000 : Text[20]) accounts : Text[700];
    BEGIN
      BEGIN
       // bosaNo:=BOSAAccount(phone);
       CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
       Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
        IF Vendor.FIND('-') THEN
          BEGIN
             accounts:='';
             REPEAT
               accounts:=accounts+'::::'+Vendor."No."+':::'+AccountDescription(Vendor."Account Type");
             UNTIL Vendor.NEXT =0;
          END
        ELSE
        BEGIN
           accounts:='';
        END
        END;
        END;
    END;

    PROCEDURE SurePESARegistration@1000000002() memberdetails : Text[1000];
    BEGIN
      BEGIN
        CloudPESAApplications.RESET;
        CloudPESAApplications.SETRANGE(CloudPESAApplications.SentToServer, FALSE);
        IF CloudPESAApplications.FINDFIRST() THEN
          BEGIN
               memberdetails:=CloudPESAApplications."Account No"+':::'+CloudPESAApplications.Telephone+':::'+CloudPESAApplications."ID No";
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
        CloudPESAApplications.RESET;
        CloudPESAApplications.SETRANGE(CloudPESAApplications.SentToServer, FALSE);
        CloudPESAApplications.SETRANGE(CloudPESAApplications."Account No", accountNo);
        IF CloudPESAApplications.FIND('-') THEN
          BEGIN
               CloudPESAApplications.SentToServer:=TRUE;
               CloudPESAApplications.MODIFY;
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
      CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
        IF Vendor.FIND('-') THEN BEGIN
              Members.RESET;
              Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
              IF  Members.FIND('-') THEN BEGIN
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");
            IF MemberLedgerEntry.FIND('-') THEN
              REPEAT
                  amount:=amount+MemberLedgerEntry.Amount;
                  shares:= FORMAT(amount,STRLEN(FORMAT(amount)),'<Integer Thousand><Decimals>');
                  UNTIL MemberLedgerEntry.NEXT =0;
              END;
              END;
          END;
          END;
    END;

    PROCEDURE BenevolentFund@1000000111(phone@1000000000 : Text[20]) shares : Text[50];
    BEGIN
      BEGIN
      CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
        IF Vendor.FIND('-') THEN BEGIN
              Members.RESET;
              Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
              IF  Members.FIND('-') THEN BEGIN
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Benevolent Fund");
            IF MemberLedgerEntry.FIND('-') THEN
              REPEAT
                  amount:=amount+MemberLedgerEntry.Amount;
                  shares:= FORMAT(amount,STRLEN(FORMAT(amount)),'<Integer Thousand><Decimals>');
                  UNTIL MemberLedgerEntry.NEXT =0;
              END;
              END;
          END;
          END;
    END;

    PROCEDURE FundsTransferFOSA@1000000007(accFrom@1000000000 : Text[20];accTo@1000000001 : Text[20];DocNumber@1000000002 : Text[30];amount@1000000003 : Decimal) result : Text[30];
    BEGIN
      {CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");
        GenSetup.GET();
        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;

          ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges+CloudPESACharge);

         //Members.RESET;
         //Members.SETRANGE(Members."No.",accFrom);


          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",accFrom);
          IF Vendor.FIND('-') THEN BEGIN
             accountName1:=Vendor.Name;
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
           Vendor.RESET;
           Vendor.SETRANGE(Vendor."No.",accTo);
          IF Vendor.FIND('-') THEN BEGIN

                IF (TempBalance>amount+MobileCharges+CloudPESACharge) THEN BEGIN
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
                      GenJournalLine.Description:='Online Money Transfer -'+ FORMAT(accTo);
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
                      GenJournalLine.Amount:=MobileCharges + CloudPESACharge ;
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
                       GenJournalLine."Source No.":=Vendor."No.";
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
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Mobile Transfer';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=accFrom;
                      CloudPESATrans."Account No2" :=accTo;
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans."Account Name":=accountName1;
                      CloudPESATrans.Posted:=TRUE;
                      CloudPESATrans."Posting Date":=TODAY;
                      CloudPESATrans.Comments:='Success';
                      CloudPESATrans.Client:=Vendor."BOSA Account No";
                      CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::"Transfer to Fosa";
                      CloudPESATrans."Transaction Time":=TIME;
                      CloudPESATrans.Status:=CloudPESATrans.Status::Completed;
                      CloudPESATrans.INSERT;
                      result:='TRUE';

                      Vendor.RESET();
                      Vendor.SETRANGE(Vendor."No.",accTo);
                      IF Vendor.FIND('-') THEN BEGIN
                        accountName2:=Vendor.Name;
                        msg:='Dear ' +accountName2 + ' you have received KES '+FORMAT(amount)+' from Account '+accountName1 +
                          ' .Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accTo,Vendor."Phone No.",msg);
                      END;
                      Vendor.RESET();
                      Vendor.SETRANGE(Vendor."No.",accFrom);
                      IF Vendor.FIND('-') THEN BEGIN
                       // accountName2:=Vendor.Name
                      END;
                         msg:='You have transfered KES '+FORMAT(amount)+' from Account '+accountName1+' to '+accountName2+
                          ' .Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                     Vendor.RESET();
                      Vendor.SETRANGE(Vendor."No.",accFrom);
                      IF Vendor.FIND('-') THEN BEGIN
                       // accountName2:=Vendor.Name
                      END;
                           msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' .Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END;
              END
              ELSE BEGIN
                result:='ACC2INEXISTENT';
                           msg:='Your request has failed because the recipent account does not exist.'+
                          ' .Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
              END;
          END
          ELSE BEGIN
            result:='ACCINEXISTENT';
                       // result:='INSUFFICIENT';
                     Vendor.RESET();
                      Vendor.SETRANGE(Vendor."No.",accFrom);
                      IF Vendor.FIND('-') THEN BEGIN
                       // accountName2:=Vendor.Name
                      END;
                        msg:='Your request has failed because the recipent account does not exist.'+
                        ' .Thank you for using M-Cash.';
                        SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
          END;
        END;
      }
    END;

    PROCEDURE FundsTransferBOSA@1000000018(accFrom@1000000000 : Text[20];accTo@1000000001 : Text[20];DocNumber@1000000002 : Text[30];amount@1000000003 : Decimal) result : Text[30];
    BEGIN
      {
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
        GenSetup.GET();
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;

          ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges+CloudPESACharge);

      //IF amount>=100  THEN BEGIN
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",accFrom);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

          IF (accTo='Shares Capital') OR(accTo='Deposit Contribution') OR(accTo='Benevolent Fund')
            THEN BEGIN
                IF (TempBalance>amount+MobileCharges+CloudPESACharge) THEN BEGIN
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
                      GenJournalLine.Amount:=MobileCharges + CloudPESACharge ;
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
                       GenJournalLine."Source No.":=Vendor."No.";
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
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
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
                      GenJournalLine."Account No.":=Vendor."BOSA Account No";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":='SUREPESA';
                      GenJournalLine."Posting Date":=TODAY;

                      IF accTo='Deposit Contribution' THEN BEGIN
                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
                        GenJournalLine.Description:='Mobile Transfer from '+accFrom;
                      END;
                      IF accTo='Shares Capital' THEN BEGIN
                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Share Capital";
                        GenJournalLine.Description:='Mobile Transfer from '+accFrom;
                      END;
                      IF accTo='Benovelent Fund' THEN BEGIN
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Mobile Transfer';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=accFrom;
                      CloudPESATrans."Account No2" :=accTo;
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans."Account Name":=Vendor.Name;
                      CloudPESATrans.Posted:=TRUE;
                      CloudPESATrans."Posting Date":=TODAY;
                      CloudPESATrans.Comments:='Success';
                      CloudPESATrans.Status:= CloudPESATrans.Status::Completed;
                      CloudPESATrans.Client:=Vendor."BOSA Account No";
                      CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::"Transfer to Bosa";
                      CloudPESATrans."Transaction Time":=TIME;
                      CloudPESATrans.INSERT;
                      result:='TRUE';

                         msg:='You have transfered KES '+FORMAT(amount)+' from Account '+Vendor.Name+' to '+accTo+
                          ' .Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                           msg:='You have insufficient funds in your savings Account to use this service.'+
                          '. Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END;
              END
              ELSE BEGIN
                result:='ACC2INEXISTENT';
                           msg:='Your request has failed because the recipent account does not exist.'+
                          '. Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
              END;

       END;

        END;
        }
    END;

    PROCEDURE WSSAccount@1000000014(phone@1000000000 : Text[20]) accounts : Text[250];
    BEGIN
      BEGIN
      //MESSAGE(COPYSTR(phone,4,12));

       CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
       // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
           Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
        IF Vendor.FIND('-') THEN BEGIN


               accounts:=Vendor."No."+':::'+AccountDescription(Vendor."Account Type");


          END
        ELSE
        BEGIN
           accounts:='';
        END
        END;
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
    BEGIN
      {
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN

        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",accFrom);
        IF Vendor.FIND('-') THEN BEGIN
            GenSetup.GET();
            GenLedgerSetup.RESET;
            GenLedgerSetup.GET;
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

            Charges.RESET;
            Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
            IF Charges.FIND('-') THEN BEGIN
              Charges.TESTFIELD(Charges."GL Account");
              MobileCharges:=Charges."Charge Amount";
              MobileChargesACC:=Charges."GL Account";
            END;

              CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
              CloudPESACharge:=0;

              ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges+CloudPESACharge);
              loanamount:=amount;

              Vendor.RESET;
              Vendor.SETRANGE(Vendor."No.",accFrom);
              IF Vendor.FIND('-') THEN BEGIN
                   Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                   TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

                        LoansRegister.RESET;
                        LoansRegister.SETRANGE(LoansRegister."Loan  No.",loanNo);
                        LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."BOSA Account No");

                     IF LoansRegister.FIND('+') THEN BEGIN
                      // DailyInterestAccrued:=NrsbufferAmount(LoansRegister."Loan  No.",Vendor."BOSA Account No");
                        LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
                        IF (TempBalance>amount+MobileCharges+CloudPESACharge) THEN BEGIN
                         IF LoansRegister."Outstanding Balance" > 0 THEN BEGIN
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
                                  GenJournalLine.Description:='Mobile Transfer Charges';
                                  GenJournalLine.Amount:=MobileCharges + CloudPESACharge ;
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
                                  GenJournalLine.Description:='Excise duty-Mobile Transfer Charges';
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
                                  GenJournalLine.Description:='Excise duty-Mobile Transfer Charges';
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
                                   GenJournalLine."Source No.":=Vendor."No.";
                                  GenJournalLine."External Document No.":=MobileChargesACC;
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
                                  GenJournalLine."Account No.":=CloudPESACommACC;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                   GenJournalLine."Source No.":=Vendor."No.";
                                  GenJournalLine."External Document No.":=MobileChargesACC;
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Mobile Transfer Charges';
                                  GenJournalLine.Amount:=-CloudPESACharge;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                                  //outstanding balance
                                 // IF LoansRegister."Oustanding Interest">0 THEN BEGIN
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

                             //accrued interest
                                 // IF  (DailyInterestAccrued<>0) THEN BEGIN
                                  LineNo:=LineNo+10000;

                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                  GenJournalLine."Account No.":=LoansRegister."Client Code";
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=DocNumber;
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Daily interest Accrued';
                                  IF amount > (DailyInterestAccrued) THEN
                                  GenJournalLine.Amount:=-(DailyInterestAccrued)
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


                                    LineNo:=LineNo+10000;
                                    GenJournalLine.INIT;
                                    GenJournalLine."Journal Template Name":='GENERAL';
                                    GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                    GenJournalLine."Line No.":=LineNo;
                                    GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                    GenJournalLine."Account No.":=LoansRegister."Client Code";
                                    GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                    GenJournalLine."Document No.":=DocNumber;
                                    GenJournalLine."Posting Date":=TODAY;
                                    GenJournalLine.Description:='Interest Due';
                                    GenJournalLine.Amount:=DailyInterestAccrued;
                                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                    GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                    IF LoanType.GET(LoansRegister."Loan Product Type") THEN
                                    GenJournalLine."Bal. Account No.":=LoanType."Loan Interest Account";
                                    GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                    GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                                    GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                    GenJournalLine."Loan Product Type":=LoansRegister."Loan Product Type";
                                    IF GenJournalLine.Amount<>0 THEN
                                    GenJournalLine.INSERT;

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
                                  GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Loan Repayment";
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
                                  GenJournalLine.RESET;
                                  GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                  GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                                  GenJournalLine.DELETEALL;


                                  CloudPESATrans.INIT;
                                  CloudPESATrans."Document No":=DocNumber;
                                  CloudPESATrans.Description:='Mobile Transfer';
                                  CloudPESATrans."Document Date":=TODAY;
                                  CloudPESATrans."Account No" :=accFrom;
                                  CloudPESATrans."Account No2" :=loanNo;
                                  CloudPESATrans.Amount:=amount;
                                  CloudPESATrans.Posted:=TRUE;
                                  CloudPESATrans."Posting Date":=TODAY;
                                  CloudPESATrans."Account Name":=Vendor.Name;
                                  CloudPESATrans.Comments:='Success';
                                   CloudPESATrans.Status:= CloudPESATrans.Status::Completed;
                                  CloudPESATrans.Client:=Vendor."BOSA Account No";
                                  CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::"Loan Status";
                                  CloudPESATrans."Transaction Time":=TIME;
                                  CloudPESATrans.INSERT;
                                  result:='TRUE';

                                     msg:='You have transfered KES '+FORMAT(loanamount)+' from Account '+Vendor.Name+' to '+loanNo+
                                      '. Thank you for using M-Cash.';
                                      SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                                END;
                               END
                               ELSE BEGIN
                               result:='INSUFFICIENT';
                                       msg:='You have insufficient funds in your savings Account to use this service.'+
                                      '. Thank you for using M-Cash.';
                                      SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                               END;
                      END
                      ELSE BEGIN
                        result:='ACC2INEXISTENT';
                                   msg:='Your request has failed because you do not have any outstanding balance.'+
                                  '. Thank you for using M-Cash.';
                                  SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                      END;
                END
                ELSE BEGIN
                  result:='ACCINEXISTENT';
                              msg:='Your request has failed.Please make sure you are registered for mobile banking.'+
                              '. Thank you for using M-Cash.';
                              SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                END;
            END
            ELSE BEGIN
                result:='MEMBERINEXISTENT';
                          msg:='Your request has failed because the recipent account does not exist.'+
                          '. Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
            END;
        END
        }
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
                LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Interest Due",LoansRegister."Interest to be paid",LoansRegister."Interest Paid",LoansRegister."Oustanding Interest");
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
          REPEAT
            IF LoanGuaranteeDetails."Amont Guaranteed">0 THEN
              guarantors:=guarantors + '::::'+ LoanGuaranteeDetails.Name+':::'+FORMAT(LoanGuaranteeDetails."Amont Guaranteed");
          UNTIL LoanGuaranteeDetails.NEXT =0;
        END;
      END;
    END;

    PROCEDURE LoansGuaranteed@1000000046(phone@1000000000 : Text[20]) guarantors : Text[1000];
    BEGIN
      BEGIN
      CloudPESAApplications.RESET;
       CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
       IF CloudPESAApplications.FIND('-') THEN BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
         bosaNo:=Vendor."BOSA Account No";
          END;
          LoanGuaranteeDetails.RESET;
          LoanGuaranteeDetails.SETRANGE(LoanGuaranteeDetails."Member No",bosaNo);
          IF LoanGuaranteeDetails.FIND('-') THEN BEGIN
            REPEAT
                guarantors:=guarantors + '::::' + LoanGuaranteeDetails."Loan No"+':::'+FORMAT(LoanGuaranteeDetails."Guarantor Outstanding");
            UNTIL LoanGuaranteeDetails.NEXT =0;
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
      {BEGIN
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
        result :='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileChargesACC:=Charges."GL Account";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",Phone);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
           fosaAcc:=Vendor."No.";

                IF (TempBalance>CloudPESACharge) THEN BEGIN
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

              //Dr Mobile Transfer Charges
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
                      GenJournalLine.Amount:=CloudPESACharge ;
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Loan Guarantors Info Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Loan Guarantors Info';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=Vendor."No.";
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
        }
    END;

    PROCEDURE AccountBalanceNew@1000000009(Acc@1000000000 : Code[30];DocNumber@1000000001 : Code[20]) Bal : Text[50];
    BEGIN
      {BEGIN
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        Bal:='REFEXISTS';
      END
      ELSE BEGIN
        GenSetup.GET();
        Bal:='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;

          ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges+CloudPESACharge);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",Acc);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

                IF (Vendor."Account Type"='502') OR (Vendor."Account Type"='507')OR (Vendor."Account Type"='504') OR (Vendor."Account Type"='506')THEN
                BEGIN
                IF (TempBalance>MobileCharges+CloudPESACharge) THEN BEGIN
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

              //Dr Mobile Transfer Charges
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
                      GenJournalLine.Amount:=MobileCharges + CloudPESACharge ;
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Balance Enquiry';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=Vendor."No.";
                      CloudPESATrans."Account No2" :='';
                      CloudPESATrans."Account Name":=Vendor.Name;
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans.Posted:=TRUE;
                      CloudPESATrans."Posting Date":=TODAY;
                      CloudPESATrans.Status:=CloudPESATrans.Status::Completed;
                      CloudPESATrans.Comments:='Success';
                      CloudPESATrans.Client:=Vendor."BOSA Account No";
                      CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::Balance;
                      CloudPESATrans."Transaction Time":=TIME;
                      CloudPESATrans.INSERT;
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
                           msg:='Account Name: '+Vendor.Name+', '+'BALANCE: '+FORMAT(accBalance)+'. '
                          +'Thank you for using M-Cash';
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
      }
    END;

    PROCEDURE AccountBalanceDec@1000000033(Acc@1000000000 : Code[30];amt@1000000001 : Decimal) Bal : Decimal;
    BEGIN
      {  BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.", Acc);
        IF Vendor.FIND('-') THEN
         BEGIN
              GenSetup.GET();
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
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
              //GenLedgerSetup.TESTFIELD(GenLedgerSetup."MPESA Reconciliation acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

              Charges.RESET;
              Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
              IF Charges.FIND('-') THEN BEGIN
                Charges.TESTFIELD(Charges."GL Account");

                MPESACharge:=GetCharge(amt,'MPESA');
                CloudPESACharge:=GetCharge(amt,'VENDWD');
                MobileCharges:=GetCharge(amt,'SACCOWD');

                ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges+CloudPESACharge);
                TotalCharges:=CloudPESACharge+MobileCharges+ExcDuty+MPESACharge;
                END;
                Bal:=Bal-TotalCharges;
         END
        END;
        }
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

    PROCEDURE PostMPESATrans@1000000027(docNo@1000000000 : Text[20];telephoneNo@1000000001 : Text[20];amount@1000000003 : Decimal;TransactionDate@1000 : Date) result : Text[30];
    BEGIN
      {
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", docNo);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."MPESA Settl Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");

          MPESACharge:=GetCharge(amount,'MPESA');
          CloudPESACharge:=GetCharge(amount,'VENDWD');
          MobileCharges:=GetCharge(amount,'SACCOWD');

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          MPESARecon:=GenLedgerSetup."MPESA Settl Acc";
          MobileChargesACC:=Charges."GL Account";
          GenSetup.GET();
          ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges+CloudPESACharge);
          TotalCharges:=CloudPESACharge+MobileCharges+ExcDuty;
        END;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", telephoneNo);
         // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

               IF (TempBalance>amount+TotalCharges+MPESACharge) THEN BEGIN
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MPESAWITHD');
                      GenJournalLine.DELETEALL;
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
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MPESAWITHD';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");

                      GenJournalLine."Bal. Account Type":=GenJournalLine."Account Type"::"Bank Account";
                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type");
                      GenJournalLine."Bal. Account No.":=MPESARecon;
                      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");

                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TransactionDate;
                      GenJournalLine.Description:='MPESA Withdrawal ' + COPYSTR(Vendor.Name,1,20);
                      GenJournalLine.Amount:=amount+MPESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //Dr Withdrawal Charges
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MPESAWITHD';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TransactionDate;
                      GenJournalLine.Description:='Mobile Withdrawal Charges';
                      GenJournalLine.Amount:=TotalCharges;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Mobile Transactions Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MPESAWITHD';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=MobileChargesACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TransactionDate;
                      GenJournalLine.Description:='Mobile Withdrawal Charges';
                      GenJournalLine.Amount:=MobileCharges*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Surestep Acc
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MPESAWITHD';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=docNo;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TransactionDate;
                      GenJournalLine.Description:='Mobile Withdrawal Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

                     //CR Excise Duty
                            LineNo:=LineNo+10000;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name":='GENERAL';
                            GenJournalLine."Journal Batch Name":='MPESAWITHD';
                            GenJournalLine."Line No.":=LineNo;
                            GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                            GenJournalLine."Account No.":=FORMAT(ExxcDuty);
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Document No.":=docNo;
                            GenJournalLine."External Document No.":=docNo;
                            GenJournalLine."Posting Date":=TransactionDate;
                            GenJournalLine.Description:='Excise duty';
                            GenJournalLine.Amount:=ExcDuty*-1;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            IF GenJournalLine.Amount<>0 THEN
                            GenJournalLine.INSERT;

                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MPESAWITHD');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MPESAWITHD');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=docNo;
                      CloudPESATrans.Description:='MPESA Withdrawal';
                      CloudPESATrans."Document Date":=TransactionDate;
                      CloudPESATrans."Account No" :=Vendor."No.";
                      CloudPESATrans."Account No2" :=MPESARecon;
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans.Status:=CloudPESATrans.Status::Completed;
                      CloudPESATrans.Posted:=TRUE;
                      CloudPESATrans."Posting Date":=TODAY;
                      CloudPESATrans."Account Name":=Vendor.Name;
                      CloudPESATrans.Comments:='Success';
                      CloudPESATrans.Client:=Vendor."BOSA Account No";
                      CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::Withdrawal;
                      CloudPESATrans."Transaction Time":=TIME;
                      CloudPESATrans.INSERT;
                      result:='TRUE';
                      msg:='You have withdrawn KES '+FORMAT(amount)+' from Account '+Vendor.Name+
                      ' .Thank you for using M-Cash.';
                      SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                          { msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' .Thank you for using Magadi Sacco Mobile.';
                          SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);}
                            CloudPESATrans.INIT;
                            CloudPESATrans."Document No":=docNo;
                            CloudPESATrans.Description:='MPESA Withdrawal';
                            CloudPESATrans."Document Date":=TransactionDate;
                            CloudPESATrans."Account No" :=Vendor."No.";
                            CloudPESATrans."Account No2" :=MPESARecon;
                            CloudPESATrans.Amount:=amount;
                            CloudPESATrans.Status:=CloudPESATrans.Status::Failed;
                            CloudPESATrans.Posted:=FALSE;
                            CloudPESATrans."Posting Date":=TODAY;
                            CloudPESATrans.Comments:='Failed,Insufficient Funds';
                            CloudPESATrans.Client:=Vendor."BOSA Account No";
                            CloudPESATrans."Account Name":=Vendor.Name;
                            CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::Withdrawal;
                            CloudPESATrans."Transaction Time":=TIME;
                            CloudPESATrans.INSERT;
                   END;
             END
              ELSE BEGIN
                result:='ACCINEXISTENT';
                           { msg:='Your request has failed because account does not exist.'+
                            ' .Thank you for using Magadi Sacco Mobile.';
                            SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);}
                            CloudPESATrans.INIT;
                            CloudPESATrans."Document No":=docNo;
                            CloudPESATrans.Description:='MPESA Withdrawal';
                            CloudPESATrans."Document Date":=TODAY;
                            CloudPESATrans."Account No" :='';
                            CloudPESATrans."Account No2" :=MPESARecon;
                            CloudPESATrans.Amount:=amount;
                            CloudPESATrans.Posted:=FALSE;
                            CloudPESATrans."Posting Date":=TODAY;
                            CloudPESATrans.Comments:='Failed,Invalid Account';
                            CloudPESATrans.Client:='';
                            CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::Withdrawal;
                            CloudPESATrans."Transaction Time":=TIME;
                            CloudPESATrans.INSERT;
              END;
        END;
        }
    END;

    PROCEDURE AccountDescription@1000000021(code@1000000000 : Text[20]) description : Text[100];
    BEGIN
      {BEGIN
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
        }
    END;

    PROCEDURE InsertTransaction@1000000011("Document No"@1000000000 : Code[30];Keyword@1000000001 : Code[30];"Account No"@1000000002 : Code[30];"Account Name"@1000000003 : Text[100];Telephone@1000000004 : Code[20];Amount@1000000005 : Decimal;"Sacco Bal"@1000000006 : Decimal;TransactionDate@1000 : Date) Result : Code[20];
    BEGIN
      BEGIN
            BEGIN
                  BEGIN
                    PaybillTrans.INIT;
                    PaybillTrans."Document No":="Document No";
                    PaybillTrans."Key Word":=Keyword;
                    PaybillTrans."Account No":="Account No";
                    PaybillTrans."Account Name":="Account Name";
                    PaybillTrans."Transaction Date":=TransactionDate;
                    PaybillTrans."Transaction Time":=TODAY;
                    PaybillTrans.Description:='PayBill Deposit';
                    PaybillTrans.Telephone:=Telephone;
                    PaybillTrans.Amount:=Amount;
                    PaybillTrans."Paybill Acc Balance":="Sacco Bal";
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
    END;

    PROCEDURE PaybillSwitch@1000000022() Result : Code[20];
    BEGIN

      BEGIN

             PaybillTrans.RESET;
             PaybillTrans.SETRANGE(PaybillTrans.Posted,FALSE);
             PaybillTrans.SETRANGE(PaybillTrans."Needs Manual Posting",FALSE);

            IF PaybillTrans.FIND('-') THEN BEGIN

                  IF PaybillTrans."Account No"='DEPOSIT CONTRIBUTION' THEN BEGIN
                    CloudPESAApplications.RESET;
                    CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,(COPYSTR(PaybillTrans.Telephone,4,12)));
                    IF CloudPESAApplications.FIND('-') THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
                    IF Vendor.FIND('-') THEN BEGIN
                    Result:=PayBillToBOSA('PAYBILL',PaybillTrans."Document No",Vendor."BOSA Account No",Vendor."BOSA Account No",PaybillTrans.Amount,PaybillTrans."Key Word",PaybillTrans."Account No",PaybillTrans."Transaction Date");

                      END;
                      END;
                  END ELSE IF PaybillTrans."Account No"='BENOVELENT FUND' THEN BEGIN
                    CloudPESAApplications.RESET;
                    CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,(COPYSTR(PaybillTrans.Telephone,4,12)));
                    IF CloudPESAApplications.FIND('-') THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE(Vendor."No.",CloudPESAApplications."Account No");
                    IF Vendor.FIND('-') THEN BEGIN
                    Result:=PayBillToBOSA('PAYBILL',PaybillTrans."Document No",Vendor."BOSA Account No",Vendor."BOSA Account No",PaybillTrans.Amount,PaybillTrans."Key Word",PaybillTrans."Account No",PaybillTrans."Transaction Date");
                    END;
                    END;
                   END ELSE  BEGIN
                   Vendor.RESET;
                   Vendor.SETRANGE(Vendor."No.",PaybillTrans."Account No");
                   IF Vendor.FIND('-') THEN BEGIN
                      Result:=PayBillToAcc('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'ORDINARY',PaybillTrans."Transaction Date");

                   END ELSE BEGIN
                           LoansRegister.RESET;
                     LoansRegister.SETRANGE(LoansRegister."Loan  No.",PaybillTrans."Account No");
                     IF LoansRegister.FIND('-') THEN BEGIN
                        Result:=PayBillToLoan('PAYBILL',PaybillTrans."Document No",PaybillTrans."Account No",PaybillTrans."Account No",PaybillTrans.Amount,'152',PaybillTrans."Transaction Date");

                       END;
                     END;
                     END;


             IF Result='' THEN BEGIN
                     PaybillTrans."Date Posted":=TODAY;
                        PaybillTrans."Needs Manual Posting":=TRUE;
                        PaybillTrans.Description:='Failed';
                        PaybillTrans.MODIFY;
               // msg:='Dear ' +PaybillTrans."Account Name"+' Deposit of Ksh.'+ FORMAT(PaybillTrans.Amount) +'has been received but not credited to your account. ';
               // SMSMessage('PAYBILLTRANS',PaybillTrans."Account No",PaybillTrans.Telephone,msg);

               END;END;
          END;
          //END;
    END;

    LOCAL PROCEDURE PayBillToAcc@1000000062(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];Amount@1000000004 : Decimal;accountType@1000000005 : Code[30];Pdate@1000 : Date) res : Code[10];
    BEGIN
      { BEGIN
            GenLedgerSetup.RESET;
              GenLedgerSetup.GET;
              //Gensetup.RESET;
              //Gensetup.GET;
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."PayBill Settl Acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");
             // Gensetup.TESTFIELD(Gensetup);
             CloudPESACharge:=GetCharge(Amount,'PAYBILL');
              PaybillRecon:=GenLedgerSetup."PayBill Settl Acc";
              CloudPESACommACC:=GenLedgerSetup."CloudPESA Comm Acc";


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
                Vendor.SETRANGE(Vendor."No.",accNo );
               // Vendor.SETRANGE(Vendor."Account Type", accountType);
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
                    GenJournalLine."Source No.":=Vendor."No.";
                    GenJournalLine."Document No.":=docNo;
                    GenJournalLine."External Document No.":=docNo;
                    GenJournalLine."Posting Date":=Pdate;
                    GenJournalLine.Description:='Paybill from ' + PaybillTrans.Telephone+ ' - ' + COPYSTR(PaybillTrans."Account Name",1,20);
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
                    GenJournalLine."Posting Date":=Pdate;
                    GenJournalLine.Description:='Paybill from ' + PaybillTrans.Telephone+ '-' + COPYSTR(PaybillTrans."Account Name",1,20);
                    GenJournalLine.Amount:=-1*Amount;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;

              //Dr Customer Charge amount
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
                    GenJournalLine."Posting Date":=Pdate;
                    GenJournalLine.Description:='Paybill transaction charges';
                    GenJournalLine.Amount:=(CloudPESACharge);
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                     IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;

            //CR Cloudpesa a/c
             LineNo:=LineNo+10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name":='GENERAL';
                    GenJournalLine."Journal Batch Name":=batch;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine."Account No.":=CloudPESACommACC;
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No.":=docNo;
                       GenJournalLine."Source No.":=Vendor."No.";
                    GenJournalLine."External Document No.":=docNo;
                    GenJournalLine."Posting Date":=Pdate;
                    GenJournalLine.Description:=' Charges';
                    GenJournalLine.Amount:=-CloudPESACharge;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;
          {  //cr excise duty
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
                    GenJournalLine.Description:='Excise duty';
                    GenJournalLine.Amount:=2;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;

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
                    GenJournalLine.Description:='Excise duty';
                    GenJournalLine.Amount:=2*-1;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;
              }
                     END;//Vendor
                  //  END;//Member

                    //Post
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                    GenJournalLine.SETRANGE("Journal Batch Name",batch);
                    IF GenJournalLine.FIND('-') THEN BEGIN
                    REPEAT
                      GLPosting.RUN(GenJournalLine);
                    UNTIL GenJournalLine.NEXT = 0;
                    PaybillTrans.Posted:=TRUE;
                            PaybillTrans."Date Posted":=TODAY;
                            PaybillTrans.Description:='Posted';
                            PaybillTrans.MODIFY;
                            res:='TRUE';

                  msg:='Dear ' +Vendor.Name+' you have deposited KSH. '+ FORMAT(Amount) +' to '+AccountDescription(Vendor."Account Type")+' Thank you for Patronizing Magadi Sacco.';
                  SMSMessage('PAYBILLTRANS',Vendor."No.",Vendor."Phone No.",msg);
                    END
                    ELSE BEGIN
                      PaybillTrans."Date Posted":=TODAY;
                            PaybillTrans."Needs Manual Posting":=TRUE;
                            PaybillTrans.Description:='Failed';
                            PaybillTrans.MODIFY;
                            res:='FALSE';
                  msg:='Dear ' +Vendor.Name+' your deposit of Ksh. '+ FORMAT(Amount) +' has been received but not credited to your account';
                  SMSMessage('PAYBILLTRANS',Vendor."No.",Vendor."Phone No.",msg);

                    END;
          END;
          }
    END;

    LOCAL PROCEDURE PayBillToBOSA@1000000080(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];amount@1000000004 : Decimal;type@1000000005 : Code[30];descr@1000000006 : Text[100];Pdate@1000 : Date) res : Code[10];
    BEGIN
      {
       BEGIN

            GenLedgerSetup.RESET;
              GenLedgerSetup.GET;
              //Gensetup.RESET;
              //Gensetup.GET;
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."PayBill Settl Acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");
             // Gensetup.TESTFIELD(Gensetup);
              CloudPESACharge:=GetCharge(amount,'PAYBILL');
              PaybillRecon:=GenLedgerSetup."PayBill Settl Acc";
              CloudPESACommACC:=GenLedgerSetup."CloudPESA Comm Acc";


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
                Members.SETRANGE(Members."No.", accNo);
                IF Members.FIND('-') THEN BEGIN
               // Vendor.RESET;
               // Vendor.SETRANGE(Vendor."BOSA Account No", accNo);
               // Vendor.SETRANGE(Vendor."Account Type", fosaConst);
               //   IF Vendor.FINDFIRST THEN BEGIN

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
                    //GenJournalLine."Bal. Account No.":='BK006';
                    GenJournalLine."Source No.":=Members."No.";
                    GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
                    GenJournalLine.Description:='Paybill from ' + PaybillTrans.Telephone+ '-' + COPYSTR(PaybillTrans."Account Name",1,20);;
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
                    GenJournalLine."Account No.":=accNo;
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No.":=docNo;
                    GenJournalLine."External Document No.":=docNo;
                    GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
                    CASE descr OF'DEPOSIT CONTRIBUTION':
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
                       // memberaccount:= "Normal Shares";
                    END;
                     CASE descr OF 'Benovelent Fund':
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";
                       END;
                       // me
                    GenJournalLine."Shortcut Dimension 1 Code":='BOSA';

                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Paybill from ' + PaybillTrans.Telephone+ '-' + COPYSTR(PaybillTrans."Account Name",1,20);;
                    GenJournalLine.Amount:=(amount)*-1;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;
                    //CR Cloudpesa a/c
             LineNo:=LineNo+10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name":='GENERAL';
                    GenJournalLine."Journal Batch Name":=batch;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine."Account No.":=CloudPESACommACC;
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No.":=docNo;
                    GenJournalLine."External Document No.":=docNo;
                    GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
                    GenJournalLine.Description:=' Charges';
                    GenJournalLine.Amount:=-CloudPESACharge;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;
                     //Dr Customer Charge amount
                    LineNo:=LineNo+10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name":='GENERAL';
                    GenJournalLine."Journal Batch Name":=batch;
                    GenJournalLine."Line No.":=LineNo;
                    GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                    GenJournalLine."Account No.":=accNo;
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No.":=docNo;
                    GenJournalLine."External Document No.":=docNo;
                    GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
                    CASE descr OF'Deposit Contribution':
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Deposit Contribution";
                       // memberaccount:= "Normal Shares";
                    END;
                     CASE descr OF 'Benovelent Fund':
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Benevolent Fund";
                       // memberaccount:= "Normal Shares";
                    END;
                   { CASE PaybillTrans."Key Word" OF 'FO':
                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"FOSA Shares";
                      //bosaNo:="FosaShares";
                    END;
                    CASE PaybillTrans."Key Word" OF 'LN':
                      GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Unallocated Funds";
                     // bosaNo:='Unllocated Funds';
                    END;}
                    GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Description:='Paybill from ' + PaybillTrans.Telephone+ '-' + COPYSTR(PaybillTrans."Account Name",1,20);
                    GenJournalLine.Amount:=(0);
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine."Account No.":=CloudPESACommACC;
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    IF GenJournalLine.Amount<>0 THEN
                    GenJournalLine.INSERT;


                  //DR
                   //  END;//Vendor
                    END;//Member

                    //Post
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                    GenJournalLine.SETRANGE("Journal Batch Name",batch);
                    IF GenJournalLine.FIND('-') THEN BEGIN
                    REPEAT
                      GLPosting.RUN(GenJournalLine);
                    UNTIL GenJournalLine.NEXT = 0;
                      PaybillTrans.Posted:=TRUE;
                      PaybillTrans."Date Posted":=TODAY;
                      PaybillTrans.Description:='Posted';
                      PaybillTrans.MODIFY;
                      res:='TRUE';


      IF Members."Phone No." <> '' THEN BEGIN
                  msg:='Dear ' +Members.Name+' your have deposited  KSH. '+ FORMAT(amount) +' to '+descr+' Thank you for using M-Cash';
                  SMSMessage('PAYBILLTRANS',Members."No.",Members."Phone No.",msg);
                  END;

                    END
                    ELSE BEGIN
                       msg:='Dear ' +Members.Name+'we have received Ksh. '+ FORMAT(amount) +' but has not been credited to your account, Thank you for using M-Cash';
                       SMSMessage('PAYBILLTRANS',Members."No.",Members."Phone No.",msg);

                      PaybillTrans."Date Posted":=TODAY;
                      PaybillTrans."Needs Manual Posting":=TRUE;
                      PaybillTrans.Description:='Failed';
                      PaybillTrans.MODIFY;
                      res:='FALSE';


                    END;
          END;
      }
    END;

    LOCAL PROCEDURE PayBillToLoan@1000000081(batch@1000000000 : Code[20];docNo@1000000001 : Code[20];accNo@1000000002 : Code[20];memberNo@1000000003 : Code[20];amount@1000000004 : Decimal;type@1000000005 : Code[30];Pdate@1000 : Date) res : Code[10];
    BEGIN
       { GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."PayBill Settl Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
        CloudPESACharge:=0;//GenLedgerSetup."CloudPESA Charge";
        PaybillRecon:=GenLedgerSetup."PayBill Settl Acc";

        ExcDuty:=0;//(10/100)*CloudPESACharge;

      loanamount:=amount;



              LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Loan  No.",accNo);
             // LoansRegister.SETRANGE(LoansRegister."Client Code",memberNo);


              IF LoansRegister.FIND('+') THEN BEGIN
                // DailyInterestAccrued:=NrsbufferAmount(LoansRegister."Loan  No.",accNo);
               // MESSAGE(FORMAT(DailyInterestAccrued));
              LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
             IF (LoansRegister."Outstanding Balance" > 0) OR(LoansRegister."Oustanding Interest"> 0)   THEN BEGIN


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
              GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
              GenJournalLine.Description:='Paybill Loan Repayment';
              GenJournalLine.Amount:=amount;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;



          //outstanding interest
          //

             IF (LoansRegister."Oustanding Interest">0 )   THEN BEGIN
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
              GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
              GenJournalLine.Description:='Loan Interest Payment';
              END;
              IF amount > LoansRegister."Oustanding Interest" THEN
              GenJournalLine.Amount:=-(LoansRegister."Oustanding Interest")
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
              //END;




      //principal
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
               GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
               GenJournalLine.Description:='Loan outstanding balance repayment';
               GenJournalLine.Amount:=-amount;
               GenJournalLine.VALIDATE(GenJournalLine.Amount);
               GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Loan Repayment";
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
              GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
              GenJournalLine.Description:='Paybill Loan Repayment Charges';
              GenJournalLine.Amount:=CloudPESACharge+ExcDuty;
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
              GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
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
              GenJournalLine."Account No.":=CloudPESACommACC;
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine."Document No.":=docNo;
              GenJournalLine."External Document No.":=docNo;
              GenJournalLine."Posting Date":=PaybillTrans."Transaction Date";
              GenJournalLine.Description:='Paybill Loan Repayment'+' Charges';
              GenJournalLine.Amount:=-CloudPESACharge;
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;
                  END;//Outstanding Balance
                 END;//Loan Register
             //  END;//Vendor
            //  END;//Member

              //Post
              GenJournalLine.RESET;
              GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
              GenJournalLine.SETRANGE("Journal Batch Name",batch);
              IF GenJournalLine.FIND('-') THEN BEGIN
              REPEAT
               GLPosting.RUN(GenJournalLine);
              UNTIL GenJournalLine.NEXT = 0;


              msg:='Dear ' +Members.Name+' You have repayed loan: '+LoansRegister."Loan Product Type Name"+' amount  KSH '+ FORMAT(loanamount) +' Thank you for Patronizing Magadi Sacco.';
                 SMSMessage('PAYBILLTRANS',Vendor."No.",Vendor."Phone No.",msg);

                PaybillTrans.Posted:=TRUE;
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans.Description:='Posted';
                PaybillTrans.MODIFY;
                res:='TRUE';
              END
              ELSE BEGIN
                PaybillTrans."Date Posted":=TODAY;
                PaybillTrans."Needs Manual Posting":=TRUE;
                PaybillTrans.Description:='Failed';
                PaybillTrans.MODIFY;
                res:='FALSE';
              END;
              }
    END;

    PROCEDURE LoanRepaymentSchedule@1000000016(Productname@1000000000 : Text[50]) Schedule : Text[1024];
    VAR
      loanschedule@1000000001 : Text[250];
    BEGIN
    END;

    PROCEDURE Guaranteefreeshares@1000000020(phone@1000000000 : Text[500]) shares : Text[500];
    BEGIN
      BEGIN
      GenSetup.GET();
      FreeShares:=0;
      glamount:=0;
        Members.RESET;
        Members.SETRANGE(Members."Mobile Phone No",phone);
        IF Members.FIND('-') THEN BEGIN
          Members.CALCFIELDS("Current Shares");
          LoanGuard.RESET;
          LoanGuard.SETRANGE(LoanGuard."Member No",Members."No.");
         // LoanGuard.SETRANGE(LoanGuard.Substituted,FALSE);
            IF LoanGuard.FIND('-') THEN BEGIN
              REPEAT
                  glamount:=glamount+LoanGuard."Amont Guaranteed";
                 MESSAGE('Member No %1 Account no %2',Members."No.",glamount);
                  UNTIL LoanGuard.NEXT =0;
            END;
            FreeShares:=(Members."Current Shares"*GenSetup."Guarantors Multiplier")-glamount;
            shares:= FORMAT(FreeShares,0,'<Precision,2:2><Integer><Decimals>');
        END;
        END;
    END;

    PROCEDURE Loancalculator@1000000030() calcdetails : Code[1024];
    BEGIN
      {BEGIN

      LoanProducttype.RESET;
          //LoanProducttype.GET();
      LoanProducttype.SETRANGE(LoanProducttype.Source,1);
      LoanProducttype.SETRANGE("Show On Portal",TRUE);
           IF LoanProducttype.FIND('-') THEN BEGIN
              //  LoanProducttype.CALCFIELDS(LoanProducttype."Interest rate",LoanProducttype."Max. Loan Amount",LoanProducttype."Min. Loan Amount");

                REPEAT

         varLoan := varLoan + '::::'+FORMAT( LoanProducttype."Product Description") +':::' +FORMAT(LoanProducttype."Interest rate") +':::' + FORMAT(LoanProducttype."No of Installment")+':::' + FORMAT(LoanProducttype."Max. Loan Amount");

                UNTIL LoanProducttype.NEXT = 0;
                //MESSAGE('Loan Balance %1',loanbalances);
                calcdetails:=varLoan;

            END;
       END;
       }
    END;

    PROCEDURE OutstandingLoansUSSD@1000000026(phone@1000000000 : Code[20]) loanbalances : Text[1024];
    BEGIN
      {BEGIN
            Vendor.SETRANGE(Vendor."Phone No.",phone)   ;
            IF Vendor.FIND('-') THEN BEGIN
                Members.RESET;
              Members.SETRANGE(Members."FOSA Account No.",Vendor."No.");
              IF  Members.FIND('-') THEN BEGIN
                LoansRegister.RESET;
                LoansRegister.SETRANGE(LoansRegister."Client Code",Members."No.");
                IF LoansRegister.FIND('-') THEN BEGIN
                REPEAT
                  LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest",LoansRegister."Interest to be paid",LoansRegister."Interest Paid");
                  IF (LoansRegister."Outstanding Balance">0)OR(LoansRegister."Oustanding Interest">0) THEN
                  loanbalances:= loanbalances + '::::' +LoansRegister."Loan  No." + ':::'+ LoansRegister."Loan Product Type" + ':::'+
                   FORMAT(LoansRegister."Outstanding Balance")+':::'+ FORMAT(LoansRegister."Oustanding Interest") ;
                UNTIL LoansRegister.NEXT = 0;
                END;
                END;
                 //LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."No.");

            END;
       END;
       }
    END;

    PROCEDURE getMembernames@1000000035(memberno@1000000000 : Code[30]) name : Text[1024];
    BEGIN
      {Members.RESET;
      Members.SETRANGE(Members."No.",memberno);
      IF Members.FIND('-') THEN BEGIN

        name:=Members.Name+':::'+Members."FOSA Account No.";
        END;
      }
    END;

    PROCEDURE AccountbalalanceREF@1000000039(Acc@1000000000 : Code[30]) Bal : Text[1024];
    BEGIN
      {Vendor.RESET;
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
      }
    END;

    PROCEDURE CommisionEarned@1000000043() AccBal : Text[1024];
    BEGIN
      GLEntries.RESET;
      GLEntries.SETRANGE("G/L Account No.",'20106');
      amount:=0;
      IF GLEntries.FIND('-') THEN BEGIN
      REPEAT
      amount:=amount+GLEntries."Credit Amount";
      UNTIL GLEntries.NEXT=0;
      AccBal:='::::'+FORMAT(amount)+':::';
      END;
    END;

    PROCEDURE FundsTransferOTHER@1000000023(accFrom@1000000000 : Text[20];accTo@1000000001 : Text[20];DocNumber@1000000002 : Text[30];amount@1000000003 : Decimal) result : Text[30];
    BEGIN
      {CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;
          GenSetup.GET();
          ExcDuty:=(GenSetup."Excise Duty(%)"/100)*(MobileCharges+CloudPESACharge);

        IF amount>=100 THEN BEGIN

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",accFrom);
          IF Vendor.FIND('-') THEN BEGIN
                 Vendor.CALCFIELDS(Vendor."Balance (LCY)");
               TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
                accountName1:=Vendor.Name;
               Vendor.RESET;
               Vendor.SETRANGE(Vendor."BOSA Account No",accTo);

          IF Vendor.FIND('-') THEN BEGIN

                IF (TempBalance>amount+MobileCharges+CloudPESACharge) THEN BEGIN
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
                      GenJournalLine.Description:='Mobile Transfer - '+ FORMAT(accTo);
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
                      GenJournalLine.Amount:=MobileCharges + CloudPESACharge ;
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
                       GenJournalLine."Source No.":=accFrom;
                      GenJournalLine."External Document No.":=accFrom;
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
                       GenJournalLine."Source No.":=accFrom;
                      GenJournalLine."External Document No.":=accFrom;
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=accFrom;
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
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
                      GenJournalLine."Account No.":=Vendor."No.";
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=Vendor."No.";
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer from - '+FORMAT(accFrom);
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Mobile Transfer';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=accFrom;
                      CloudPESATrans."Account No2" :=accTo;
                      CloudPESATrans.Amount:=amount;
                      CloudPESATrans."Account Name":=accountName1;
                      CloudPESATrans.Posted:=TRUE;
                       CloudPESATrans.Status:= CloudPESATrans.Status::Completed;
                      CloudPESATrans."Posting Date":=TODAY;
                      CloudPESATrans.Comments:='Success';
                      CloudPESATrans.Client:=Vendor."BOSA Account No";
                      CloudPESATrans."Transaction Type":=CloudPESATrans."Transaction Type"::"Transfer to Fosa";
                      CloudPESATrans."Transaction Time":=TIME;
                      CloudPESATrans.INSERT;
                      result:='TRUE';
                      accountName2:=Vendor.Name;


                         msg:='You have transfered KES '+FORMAT(amount)+' from Account '+accountName1+' to '+accountName2+
                          ' .Thank you for Patronizing Magadi Sacco.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                           msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' .Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END;
              END
              ELSE BEGIN
                result:='ACC2INEXISTENT';
                           msg:='Your request has failed because the recipent account does not exist.'+
                          ' .Thank you for using M-Cash.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
              END;
          END
          ELSE BEGIN
            result:='ACCINEXISTENT';
                        result:='INSUFFICIENT';
                        msg:='Your request has failed because the recipent account does not exist.'+
                        ' .Thank you for using M-Cash.';
                        SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
          END;
          END
        ELSE BEGIN
          result:='LIMIT';

                        msg:='Your request has failed because the amount is below the limit required which is above 100'+
                        ' .Thank you for using M-Cash.';
                        SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
        END;
          END;
      }
    END;

    PROCEDURE SharesUSSD@1000000024(phone@1000000000 : Text[20];DocNo@1000000001 : Text[50]) shares : Text[1000];
    VAR
      sharecapital@1000000002 : Text[50];
      normalshares@1000000003 : Text[50];
      fosashares@1000000004 : Text[50];
    BEGIN
      {BEGIN

        CloudPESAApplications.RESET;
        CloudPESAApplications.SETRANGE(CloudPESAApplications.Telephone,phone);
        IF CloudPESAApplications.FIND('-') THEN BEGIN
              Vendor.RESET;
              Vendor.SETRANGE(Vendor."Phone No.",phone);
              IF Vendor.FIND('-') THEN BEGIN
                Members.RESET;
                Members.SETRANGE(Members."No.",Vendor."BOSA Account No");
                IF Members.FIND('-') THEN BEGIN
                  MemberLedgerEntry.RESET;
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Share Capital");
                  IF MemberLedgerEntry.FIND('-') THEN BEGIN
                    REPEAT
                        amount:=amount+MemberLedgerEntry.Amount;
                        sharecapital:= FORMAT(amount,STRLEN(FORMAT(amount)),'<Integer Thousand><Decimals>')
                        UNTIL MemberLedgerEntry.NEXT =0;
                    END;

                  MemberLedgerEntry.RESET;
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");

                  IF MemberLedgerEntry.FIND('-') THEN BEGIN
                    amount:=0;
                    REPEAT
                        amount:=amount+MemberLedgerEntry.Amount;
                        normalshares:= FORMAT(amount,STRLEN(FORMAT(amount)),'<Integer Thousand><Decimals>')
                        UNTIL MemberLedgerEntry.NEXT =0;
                  END;
                  //fosa shares
                   MemberLedgerEntry.RESET;
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
                  MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"FOSA Shares");

                  IF MemberLedgerEntry.FIND('-') THEN BEGIN
                    amount:=0;
                    REPEAT
                        amount:=amount+MemberLedgerEntry.Amount;
                        fosashares:= FORMAT(amount,STRLEN(FORMAT(amount)),'<Integer Thousand><Decimals>')
                        UNTIL MemberLedgerEntry.NEXT =0;
                  END;
                  IF sharecapital='' THEN BEGIN
                    sharecapital:='0';
                    END;
                     IF normalshares='' THEN BEGIN
                       normalshares:='0';
                    END;
                     END;

                  shares:='Share Capital - KSH '+sharecapital+' , Deposit contibution -KSH '+normalshares;
                  //MESSAGE(shares);
                  SMSMessage('MOBILETRAN',Vendor."No.",Vendor."Phone No.",shares);
                  END;
                 //GenericCharges(phone,DocNo,'Shares Balance Request');

          END;
          END;
      }
    END;

    PROCEDURE Unallocatedfunds@1000000028(phone@1000000000 : Text[20]) shares : Text[1000];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        IF Vendor.FIND('-') THEN BEGIN
            MemberLedgerEntry.RESET;
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Vendor."BOSA Account No");
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Benevolent Fund");
            IF MemberLedgerEntry.FIND('-') THEN
              REPEAT
                  amount:=amount+MemberLedgerEntry.Amount;
                  shares:= FORMAT(amount,STRLEN(FORMAT(amount)),'<Integer Thousand><Decimals>');
                  UNTIL MemberLedgerEntry.NEXT =0;
              END;
              IF shares='' THEN BEGIN
                shares:='0';
                END;
          END;
    END;

    PROCEDURE AccountBalanceAirtime@1(Acc@1000000000 : Code[30];amt@1000000001 : Decimal) Bal : Decimal;
    BEGIN
       { BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.", Acc);
        IF Vendor.FIND('-') THEN
         BEGIN
            IF (Vendor."Staff Account"=TRUE) THEN BEGIN
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
              Bal:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance-Vendor."Cheque Discounted");

              GenLedgerSetup.RESET;
              GenLedgerSetup.GET;
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

              Charges.RESET;
              Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
              IF Charges.FIND('-') THEN BEGIN
                Charges.TESTFIELD(Charges."GL Account");

                MPESACharge:=GetCharge(amt,'MPESA');
                CloudPESACharge:=GetCharge(amt,'VENDWD');
                MobileCharges:=GetCharge(amt,'SACCOWD');

                ExcDuty:=(10/100)*(MobileCharges+CloudPESACharge);
                TotalCharges:=CloudPESACharge+MobileCharges+ExcDuty+MPESACharge;
                END;
                Bal:=Bal;


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
              Bal:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+miniBalance-Vendor."Cheque Discounted");

              GenLedgerSetup.RESET;
              GenLedgerSetup.GET;
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
              GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

              Charges.RESET;
              Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
              IF Charges.FIND('-') THEN BEGIN
                Charges.TESTFIELD(Charges."GL Account");

                MPESACharge:=GetCharge(amt,'MPESA');
                CloudPESACharge:=GetCharge(amt,'VENDWD');
                MobileCharges:=GetCharge(amt,'SACCOWD');

                ExcDuty:=(10/100)*(MobileCharges+CloudPESACharge);
                TotalCharges:=CloudPESACharge+MobileCharges+ExcDuty+MPESACharge;
                END;
                Bal:=Bal;//-TotalCharges;
                END;
         END;
        END;
        }
    END;

    PROCEDURE postAirtime@1000000025("Doc No"@1000000000 : Code[100];Phone@1000000001 : Code[100];amount@1000000002 : Decimal) result : Code[400];
    VAR
      airtimeAcc@1000 : Code[50];
    BEGIN
      {SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", "Doc No");
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup.AirTimeSettlAcc);
        airtimeAcc:=  GenLedgerSetup.AirTimeSettlAcc;
        END;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.", Phone);
        //  Vendor.SETRANGE(Vendor."Account Type", 'CURRENT');
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           Vendor.CALCFIELDS(Vendor."ATM Transactions");
           Vendor.CALCFIELDS(Vendor."Uncleared Cheques");
           Vendor.CALCFIELDS(Vendor."EFT Transactions");
           Vendor.CALCFIELDS(Vendor."Mobile Transactions");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions"+Vendor."Mobile Transactions"-Vendor."Cheque Discounted");

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
                      GenJournalLine."Bal. Account Type":=GenJournalLine."Account Type"::"Bank Account";
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
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'AIRTIME');
                      GenJournalLine.DELETEALL;

                      SurePESATrans.INIT;
                      SurePESATrans."Document No":="Doc No";
                      SurePESATrans.Description:='AIRTIME Purchase';
                      SurePESATrans."Document Date":=TODAY;
                      SurePESATrans."Account No" :=Vendor."No.";
                      SurePESATrans."Account No2" :=Phone;
                      SurePESATrans."Account Name":=Vendor.Name;
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
                    msg:='You have purchased airtime worth KES '+FORMAT(amount)+' from Account '+Vendor.Name+ ' thank you for using M-Cash.';
                      SMSMessage("Doc No",Vendor."No.",Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                          { msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' .Thank you for using Magadi Sacco Mobile.';
                          SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);}
                            SurePESATrans.INIT;
                            SurePESATrans."Document No":="Doc No";
                            SurePESATrans.Description:='AIRTIME Purchase';
                            SurePESATrans."Document Date":=TODAY;
                            SurePESATrans."Account No" :=Vendor."No.";
                            SurePESATrans."Account No2" :=Phone;
                            SurePESATrans.Amount:=amount;
                             SurePESATrans."Account Name":=Vendor.Name;
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
                            SurePESATrans.Amount:=amount;
                             SurePESATrans."Account Name":=Vendor.Name;
                            SurePESATrans.Posted:=FALSE;
                            SurePESATrans."Posting Date":=TODAY;
                            SurePESATrans.Comments:='Failed,Invalid Account';
                            SurePESATrans.Client:='';
                            SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::Airtime;
                            SurePESATrans."Transaction Time":=TIME;
                            SurePESATrans.INSERT;
              END;
      }
    END;

    PROCEDURE fnStatemenTmember@45("Account No"@1000000000 : Code[50];path@1000000001 : Text[100];DateFilter@1000 : Code[10]) result : Code[50];
    BEGIN
      {
       SMTPSetup.RESET;
       SMTPSetup.GET;
       Filename := SMTPSetup."Path to Save Report"+path;

      IF EXISTS(Filename) THEN
        ERASE(Filename);

           DatepreviousMonth:=CALCDATE('<CM-'+DateFilter+'M>',(TODAY));

           LastSixMonths:=CALCDATE('<-CM>',(DatepreviousMonth));

        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No.","Account No");
        Vendor.SETFILTER( Vendor."Date Filter",FORMAT(LastSixMonths)+'..'+FORMAT(TODAY));
        IF Vendor.FIND('-') THEN BEGIN
          REPORT.SAVEASPDF(51516476,Filename,Vendor);

           TextMessage:=' Detailed Statement - '+FORMAT(TODAY,0,'<Day,2> <Month Text,3> <Year4>');
           TextBody:=' Please find attached your Detailed Statement as at '+FORMAT(TODAY,0,'<Day,2> <Month Text,3> <Year4>')+'. You can save, view or print the statement at your convenience.';

            EmailSend:=SURESTEPFACTORY.FnSendStatementViaMail(Vendor.Name,TextMessage,TextBody,Vendor."E-Mail",path,'');
            IF EmailSend=TRUE THEN
              result:='TRUE'    //MESSAGE('Email sent Successful')
            ELSE
             result:='TRUE';

        result:='TRUE'
           // ERROR('Error occured during sending of Email');

      END;
      }
    END;

    PROCEDURE MiniStatementAPP@30(Phone@1000000000 : Text[20];DocNumber@1000000001 : Text[20];VAR VarMinistatement@1000 : BigText) MiniStmt : Text[250];
    BEGIN
      {BEGIN
      CloudPESATrans.RESET;
      CloudPESATrans.SETRANGE(CloudPESATrans."Document No", DocNumber);
      IF CloudPESATrans.FIND('-') THEN BEGIN
        MiniStmt:='REFEXISTS';
      END
      ELSE BEGIN
        MiniStmt :='';
        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Mobile Charge");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");
        GenSetup.GET();
        Charges.RESET;
        Charges.SETRANGE(Charges.Code,GenLedgerSetup."Mobile Charge");
        IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          MobileChargesACC:=Charges."GL Account";
          MobileCharges:=Charges."Charge Amount";
        END;

          CloudPESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          CloudPESACharge:=0;
          CloudPESACharge+=MobileCharges;
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",Phone);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
           fosaAcc:=Vendor."No.";

                IF (TempBalance>CloudPESACharge) THEN BEGIN
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
                      GenJournalLine.Amount:=CloudPESACharge ;
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
                      GenJournalLine."Account No.":=CloudPESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                       GenJournalLine."Source No.":=Vendor."No.";
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mini Statement Charges';
                      GenJournalLine.Amount:=-CloudPESACharge;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

          //Charge Excise Duty
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
                      GenJournalLine.Description:='Excise Duty - Ministatement';
                      GenJournalLine.Amount:=CloudPESACharge * GenSetup."Excise Duty(%)"/100 ;
                      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                      GenJournalLine."Bal. Account No.":=GenSetup."Excise Duty Account";
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

          //End Excise Duty
                      //Post
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      IF GenJournalLine.FIND('-') THEN BEGIN
                      REPEAT
                      GLPosting.RUN(GenJournalLine);
                      UNTIL GenJournalLine.NEXT = 0;
                      END;
                      GenJournalLine.RESET;
                      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                      GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                      GenJournalLine.DELETEALL;

                      CloudPESATrans.INIT;
                      CloudPESATrans."Document No":=DocNumber;
                      CloudPESATrans.Description:='Mini Statement';
                      CloudPESATrans."Document Date":=TODAY;
                      CloudPESATrans."Account No" :=Vendor."No.";
                      CloudPESATrans."Account No2" :='';
                      CloudPESATrans."Account Name":=Vendor.Name;
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

                      VendorLedgEntry.SETRANGE(VendorLedgEntry."Vendor No.",Vendor."No.");

                        VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>%1','*Excise*');
                        VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>%1','*Charges*');
                        VendorLedgEntry.SETFILTER(VendorLedgEntry.Description,'<>*Excise duty*');
                      VendorLedgEntry.SETRANGE(VendorLedgEntry.Reversed,VendorLedgEntry.Reversed::"0");
                    IF VendorLedgEntry.FINDSET THEN BEGIN
                        MiniStmt:='';
                        REPEAT
                          VendorLedgEntry.CALCFIELDS(VendorLedgEntry.Amount);
                          amount:=VendorLedgEntry.Amount;
                          IF amount<1 THEN
                              amount:= amount*-1;
                              VarMinistatement.ADDTEXT( FORMAT(VendorLedgEntry."Posting Date") +':::'+ COPYSTR(VendorLedgEntry.Description,1,25) +':::' +
                              FORMAT(amount)+'::::');
                              minimunCount:= minimunCount +1;
                              IF minimunCount>20 THEN
                              EXIT
                          UNTIL VendorLedgEntry.NEXT =0;
                     END;
                     END
                     ELSE BEGIN
                       MiniStmt:='INSUFFICIENT';
                     END;
              END
              ELSE BEGIN
                MiniStmt:='ACCNOTFOUND';
              END;
            END;
        END;
        }
    END;

    PROCEDURE fngetpicture@10(itemno@1000 : Code[50];VAR VarItem@1010 : BigText);
    BEGIN
      {Item.RESET;
      Item.SETRANGE(Item."Phone No.",itemno);
      IF Item.FIND('-') THEN BEGIN
      //MESSAGE(Item."No.");
      TenantMedia.GET(Item.Picture.ITEM(1));
      TenantMedia.CALCFIELDS(Content);
      IF TenantMedia.Content.HASVALUE THEN BEGIN
        CLEAR(PictureTex);
        CLEAR(PictureInstream);
        TenantMedia.Content.CREATEINSTREAM(PictureInstream);

        TempBlob.RESET;
          IF TempBlob.FIND('+') THEN BEGIN
          iEntryNo:=TempBlob."Primary Key";
          iEntryNo:=iEntryNo+1;
          END
          ELSE BEGIN
          iEntryNo:=1;
          END;
        TempBlob.INIT;
        TempBlob."Primary Key":=iEntryNo;
        TempBlob.Blob.CREATEOUTSTREAM(PictureOutStream);
        COPYSTREAM(PictureOutStream,PictureInstream);
        TempBlob.INSERT;
        TempBlob.CALCFIELDS(Blob);
        PictureTex:=TempBlob.ToBase64String;
        VarItem.ADDTEXT(PictureTex);
      //  Filename:='E:\IPRS\'+Item."No."+'.txt';
      // IF EXISTS(Filename) THEN
      //  ERASE(Filename);
      //
      // MyFile.CREATE(Filename);
      // MyFile.CREATEOUTSTREAM(MyOutStream);
      // MyOutStream.WRITETEXT(PictureTex);

        //EXIT(VarOUT);

        END;
        END;
        }
    END;

    PROCEDURE AdvanceEligibility@3(account@1000000000 : Text[50];loantype@1003 : Code[50];period@1004 : Decimal) amount : Decimal;
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
      Vledger@1000 : Record 25;
      RCount@1001 : Integer;
      amountArrears@1002 : Decimal;
      LoanRepaymentS@1012 : Record 51516234;
      RepayedLoanAmt@1011 : Decimal;
      Fulldate@1010 : Date;
      LastRepayDate@1009 : Date;
      PrincipalAmount@1008 : Decimal;
      TotalAmount@1007 : Decimal;
      TransactionLoanAmt@1006 : Decimal;
      TransactionLoanDiff@1005 : Decimal;
    BEGIN
       {   Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",account);
          Vendor.SETRANGE(Status,Vendor.Status::Active);
          IF Vendor.FIND('-') THEN BEGIN

          //*****Check  if Salary is processed through Sacco*******//
          IF (Vendor."Salary Processing"=FALSE) OR (Vendor."Not Eligible for M-Loans" = TRUE) THEN BEGIN
          amount:=1;
             FnpostDetails(45,FORMAT(amount),Vendor."ID No.",Vendor.Name);
          END
          ELSE BEGIN
            //*****Get Member Default Status-BOSA*****//
          MonthlyLoanRepayments:=0;
          LoanArrears:=0;
          amountArrears:=0;
          LoansRegister.RESET;
          LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."No.");
          LoansRegister.SETFILTER("Loan Product Type",'<>DIV DISC');
          LoansRegister.SETRANGE(LoansRegister.Posted,TRUE);
          IF LoansRegister.FIND('-') THEN BEGIN
          REPEAT
            LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance");
          IF (LoansRegister."Outstanding Balance">0) THEN BEGIN
          //check monthly loan repayment for existing loans
          IF LoansRegister."Loan Product Type" <> 'M-JIENJOY' THEN
          MonthlyLoanRepayments+=(LoansRegister."Approved Amount"/LoansRegister.Installments) + LoansRegister."Outstanding Balance" * LoansRegister.Interest/100;
          //check loan arrears for all of member's loans in FOSA
            LoanArrears+=SURESTEPFACTORY.FnGetLoanAmountinArrears(LoansRegister."Loan  No.");
          //Check if member has an outstanding Loan Advance and whether it exceeds loan limit of 5000/=
          IF (LoansRegister."Loan Product Type" = 'M-JIENJOY') THEN
            amountArrears:= amountArrears+(LoansRegister."Outstanding Balance");

         //MESSAGE(FORMAT(amountArrears));
              END;
          UNTIL LoansRegister.NEXT=0;
          amountArrears:=amountArrears + LoanArrears;
          IF amountArrears >= 5000 THEN BEGIN
            amount:=2;
             FnpostDetails(45,FORMAT(amount),Vendor."ID No.",Vendor.Name);
            END

          END;
          IF amount<>2 THEN BEGIN
            IF amount<>3 THEN BEGIN

            //******Get Standing Order Amounts
          StoDedAmount:=0;

          STO.RESET;
          STO.SETRANGE(STO."Source Account No.",Vendor."No.");
          STO.SETRANGE(STO."Standing Order Type",STO."Standing Order Type"::Salary);
          STO.SETRANGE(Status,STO.Status::Approved);
          IF STO.FIND('-') THEN BEGIN
          REPEAT
          StoDedAmount:=StoDedAmount+STO.Amount;
          UNTIL STO.NEXT=0;
          END;
         // ============================================Get arreas

              LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."No.");
              IF LoansRegister.FIND('-') THEN BEGIN

             REPEAT
                LoansRegister.CALCFIELDS(LoansRegister."Oustanding Interest",LoansRegister."Outstanding Balance");
             IF (LoansRegister."Oustanding Interest" >0)  OR (LoansRegister."Outstanding Balance">0)  THEN BEGIN
              LoanRepaymentS.RESET;
              LoanRepaymentS.SETRANGE(LoanRepaymentS."Loan No.",LoansRegister."Loan  No.");
              IF LoanRepaymentS.FIND('-') THEN BEGIN
                REPEAT

                     Fulldate:= DMY2DATE(DATE2DMY(280511D,1),DATE2DMY(TODAY,2),DATE2DMY(TODAY,3));
                     LastRepayDate:= DMY2DATE(DATE2DMY(280511D,1),DATE2DMY(LoanRepaymentS."Repayment Date",2),DATE2DMY(LoanRepaymentS."Repayment Date",3));


                   IF Fulldate>=LastRepayDate THEN BEGIN

                     PrincipalAmount:= PrincipalAmount+LoanRepaymentS."Principal Repayment";
                     END;
                   //  EXIT
                 UNTIL LoanRepaymentS.NEXT=0;
              END;

               MemberLedgerEntry.RESET;
              MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Loan No",LoansRegister."Loan  No.");
              MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Loan Repayment");
              MemberLedgerEntry.CALCSUMS(MemberLedgerEntry."Credit Amount (LCY)");
              TransactionLoanAmt:=MemberLedgerEntry."Credit Amount (LCY)";
              TransactionLoanDiff:=PrincipalAmount-TransactionLoanAmt;

              IF TransactionLoanDiff>0 THEN BEGIN
                RepayedLoanAmt:=TransactionLoanDiff;
                 amount:=3;
                END ELSE BEGIN
                  PrincipalAmount:=0;
                 RepayedLoanAmt:=RepayedLoanAmt+0;
              END;
              END;//BAL
           UNTIL LoansRegister.NEXT=0;
          END;


        //******Get Average Salary Amount
              Vledger.RESET;
              Vledger.SETRANGE(Vledger."Vendor No.",Vendor."No.");
              Vledger.SETFILTER(Vledger.Reversed,'<>%1',TRUE);
              Vledger.SETFILTER(Vledger."Posting Date",FORMAT(CALCDATE('-3M',TODAY))+ '..' + FORMAT(TODAY));
              Vledger.SETRANGE(Vledger.Description,'Salary Processing');


               IF (Vledger.FIND('-')) THEN BEGIN
                  RCount:=Vledger.COUNT;
                  TCount:=0;
                  Sal1:=0;
                  Sal2:=0;
                  Sal3:=0;
                  IF RCount> 1 THEN BEGIN
                      REPEAT
                          Vledger.CALCFIELDS(Vledger."Amount (LCY)");

                          TCount+=1;
                          IF TCount= RCount-2 THEN
                            Sal3:= Vledger."Amount (LCY)"*-1
                          ELSE IF TCount = RCount-1 THEN
                              Sal1:=Vledger."Amount (LCY)" *-1
                          ELSE IF TCount = RCount THEN
                              Sal2:=Vledger."Amount (LCY)" *-1;

                     // MESSAGE(FORMAT(TCount)+'-' +FORMAT(RCount)+'\'+FORMAT(Vledger."Amount (LCY)")+'\Sal 1: %1\Sal 2: %2',Sal1,Sal2);
                      UNTIL Vledger.NEXT=0;

                      SalaryAverage:=(Sal1+Sal2+Sal3)/3;
                    {
                      IF(Sal1 < Sal2) AND (Sal1 < Sal3) THEN
                          Salarybal:=Sal1
                      ELSE IF (Sal2 < Sal1) AND (Sal2 < Sal3) THEN
                        Salarybal:=Sal2
                      ELSE
                        Salarybal:=Sal3;
                      }

                      //ERROR(Vledger."Vendor No."+'\Sal 1: %1\Sal 2: %2',Sal1,Sal2);
                  END
                  ELSE IF RCount=1 THEN BEGIN
                      Vledger.CALCFIELDS(Vledger."Amount (LCY)");
                      SalaryAverage:=Vledger."Amount (LCY)"*-1;

                      //Salarybal:=Vledger."Amount (LCY)"*-1;
                      //ERROR(Vledger."Vendor No."+'\Salarybal %1',Salarybal);
                  END
                  ELSE BEGIN
                      SalaryAverage:=0;
                  END;

               END;


            LoanProductsSetup.RESET;
            LoanProductsSetup.SETRANGE(LoanProductsSetup.Code,'M-JIENJOY');
            IF LoanProductsSetup.FINDFIRST() THEN BEGIN
              interestRate:=LoanProductsSetup."Interest rate";
              //InterestAcc:=LoanProductsSetup."Loan Interest Account";
            END;

          AdvQualificationAmount:=SalaryAverage-(StoDedAmount) - MonthlyLoanRepayments;
          interestAMT:=(interestRate/100)*amount;
          amount:=AdvQualificationAmount-interestAMT;
            IF amount<=0 THEN BEGIN
              amount:=4;
            END ELSE

              IF amount-amountArrears>5000 THEN BEGIN
              amount:=5000;
            END
            ELSE BEGIN
            amount:= ROUND((amount-amountArrears),1,'<');
            END;
            FnpostDetails(45,FORMAT(amount),Vendor."ID No.",Vendor.Name);
         // END;
          END;//End of Loan Default Check
          END;//End of Existing Adavance Loan Check
          END;//End of Salary Processing Check
        END;//End Vendor
      //MESSAGE('Salary is %1 and Repaid Loan amount %2 and sto deductions %3 and Monthly Loan repayment is %4',SalaryAverage,RepayedLoanAmt,StoDedAmount,MonthlyLoanRepayments);
      }
    END;

    PROCEDURE PostAdvance@1000000036(docNo@1000000000 : Code[20];telephoneNo@1000000001 : Code[20];amount@1000000002 : Decimal;period@1000 : Decimal;loantype@1001 : Code[100]) result : Code[30];
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
      SurePESATrans@1000000017 : Record 51516522;
      LoanProdCharges@1000000018 : Record 51516240;
      SurePESACharge@1000000019 : Decimal;
      SurePESACommACC@1000000020 : Code[100];
      SaccoNoSeries@1000000021 : Record 51516258;
      NoSeriesMgt@1000000022 : Codeunit 396;
      LoanRepSchedule@1000000023 : Record 51516234;
      loanadvancetype@1002 : Code[10];
      loanAdvanceCharge@1003 : Decimal;
    BEGIN
      {SurePESATrans.RESET;
      SurePESATrans.SETRANGE(SurePESATrans."Document No", docNo);
      IF SurePESATrans.FIND('-') THEN BEGIN
        result:='REFEXISTS';
      END
      ELSE BEGIN

        GenLedgerSetup.RESET;
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Comm Acc");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."CloudPESA Charge");

        LoanProductsSetup.RESET;
        LoanProductsSetup.SETRANGE(LoanProductsSetup.Code,loantype);
        IF LoanProductsSetup.FINDFIRST() THEN BEGIN
          LoanAcc:=LoanProductsSetup."Loan Account";
          InterestAcc:=LoanProductsSetup."Loan Interest Account";
        END;

        GenSetup.GET();
      //..................Loan Charges.......
        LoanProdCharges.RESET;
        LoanProdCharges.SETRANGE(LoanProdCharges."Product Code",loantype);
        LoanProdCharges.SETRANGE(LoanProdCharges.Code,'LAPPLICATION');
        IF LoanProdCharges.FINDFIRST() THEN BEGIN
          advApp:=LoanProdCharges.Amount;
          advAppAcc:=LoanProdCharges."G/L Account";
          advAppDesc:=LoanProdCharges.Description;
        END;

      //...................SMS Charges.............
        LoanProdCharges.RESET;
        LoanProdCharges.SETRANGE(LoanProdCharges."Product Code",loantype);
        LoanProdCharges.SETRANGE(LoanProdCharges.Code,'LOAN DISB SMS');
        IF LoanProdCharges.FINDFIRST() THEN BEGIN
          advSMS:=LoanProdCharges.Amount;
          advSMSAcc:=LoanProdCharges."G/L Account";
          advSMSDesc:=LoanProdCharges.Description;
        END;

      //.................loan processing fee....
        LoanProdCharges.RESET;
        LoanProdCharges.SETRANGE(LoanProdCharges."Product Code",loantype);
        LoanProdCharges.SETRANGE(LoanProdCharges.Code,'LAPPRAISAL');
        IF LoanProdCharges.FINDFIRST() THEN BEGIN
          advFee:=LoanProdCharges.Amount;
          advFEEAcc:=LoanProdCharges."G/L Account";
          advFeeDesc:=LoanProdCharges.Description;
        END;

          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";
          SurePESACommACC:= GenLedgerSetup."CloudPESA Comm Acc";

          IF period =1 THEN BEGIN
          InterestAmount:=(10/100)*amount;
            END
            ELSE BEGIN
            InterestAmount:=(15/100)*amount;
          END;
          loanAdvanceCharge:=50;
          AmountToCredit:=amount-(InterestAmount);

          //ExcDuty:=(10/100)*(MobileCharges+SurePESACharge);

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No." ,telephoneNo);
         // Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
          //Vendor.SETRANGE("Allowed Mobile Loans",TRUE);
          IF Vendor.FIND('-') THEN BEGIN

            //*******Create Loan *********//
                SaccoNoSeries.GET;
                SaccoNoSeries.TESTFIELD(SaccoNoSeries."FOSA Loans Nos");
                loanNo:=NoSeriesMgt.GetNextNo(SaccoNoSeries."FOSA Loans Nos",0D,TRUE);

                  //END;

                LoansRegister.INIT;
                LoansRegister."Approved Amount":=amount;
                LoansRegister.Interest:=LoanProductsSetup."Interest rate";
                LoansRegister."Instalment Period":=LoanProductsSetup."Instalment Period";
                LoansRegister.Repayment:=amount+InterestAmount;
                IF period=1 THEN BEGIN
                LoansRegister."Expected Date of Completion":=CALCDATE('1M',TODAY);
                  LoansRegister.Installments:=1;
                  END
                  ELSE BEGIN
                    LoansRegister."Expected Date of Completion":=CALCDATE('2M',TODAY);
                    LoansRegister.Installments:=2;
                    END;
                 LoansRegister.Posted:=TRUE;
               // Members.CALCFIELDS(Members."Current Shares",Members."Outstanding Balance",//Members."Current Loan");
                //LoansRegister."Shares Balance":=Members."Current Shares";
                LoansRegister."Net Payment to FOSA":=AmountToCredit;
                //LoansRegister.Savings:=Members."Current Shares";
                LoansRegister."Interest Paid":=InterestAmount;
                LoansRegister."Issued Date":=TODAY;
                LoansRegister."Repayment Start Date":=CALCDATE('1M',TODAY);
                LoansRegister.Source:=LoansRegister.Source::FOSA;
                LoansRegister."Loan Disbursed Amount":=AmountToCredit;
                LoansRegister."Current Interest Paid":=InterestAmount;
                LoansRegister."Loan Disbursement Date":=TODAY;
                LoansRegister."Client Code":=Vendor."No.";
                LoansRegister."Client Name":=Vendor.Name;
                LoansRegister."Outstanding Balance to Date":=amount;
                //LoansRegister."Existing Loan":=Members."Outstanding Balance";
                //LoansRegister."Staff No":=Members."Payroll/Staff No";
                //LoansRegister.Gender:=Membersdv  ms..Gender;
                LoansRegister."BOSA No":=Vendor."BOSA Account No";
                LoansRegister."Branch Code":=Vendor."Global Dimension 2 Code";
                LoansRegister."Requested Amount":=amount;
                LoansRegister."ID NO":=Vendor."ID No.";
                IF LoansRegister."Branch Code" = '' THEN
                LoansRegister."Branch Code":=Vendor."Global Dimension 2 Code";
                LoansRegister."Loan  No.":=loanNo;
                LoansRegister."No. Series":=SaccoNoSeries."FOSA Loans Nos";
                LoansRegister."Doc No Used":=docNo;
                LoansRegister."BOSA No":=Vendor."BOSA Account No";
                LoansRegister."Loan Interest Repayment":=InterestAmount;
                LoansRegister."Loan Principle Repayment":=amount;
                LoansRegister."Loan Repayment":=amount;
                LoansRegister."ID NO":=Vendor."ID No.";
                LoansRegister."Employer Code":=Vendor."Employer P/F";
                //LoansRegister."Appraised By":=USERID;
                //LoansRegister."Posted By":=USERID;
                //LoansRegister."Discount Amount":=0;
                LoansRegister."Interest Upfront Amount":=InterestAmount;
                LoansRegister."Approval Status":=LoansRegister."Approval Status"::Approved;
                LoansRegister."Account No":=Vendor."No.";
                LoansRegister."Application Date":=TODAY;
                LoansRegister."Loan Product Type":=LoanProductsSetup.Code;
                LoansRegister."Loan Product Type Name":=LoanProductsSetup."Product Description";
                LoansRegister."Loan Amount":=amount;
                LoansRegister."Membership No.":=Vendor."BOSA Account No";
                LoansRegister.Posted:=TRUE;
                LoansRegister."Issued Date":=TODAY;
                LoansRegister."Outstanding Balance":=0;//Update
                LoansRegister."Repayment Frequency":=LoansRegister."Repayment Frequency"::Monthly;
                LoansRegister."Recovery Mode":=LoansRegister."Recovery Mode"::Salary;
                LoansRegister."Mode of Disbursement":= LoansRegister."Mode of Disbursement"::"Bank Transfer";
                LoansRegister.INSERT(TRUE);



           //**********Process Loan*******************//
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                GenJournalLine.SETRANGE("Journal Batch Name",'MOBILELOAN');
                GenJournalLine.DELETEALL;
                //end of deletion


                GenBatches.RESET;
                GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                GenBatches.SETRANGE(GenBatches.Name,'MOBILELOAN');

                IF GenBatches.FIND('-') = FALSE THEN BEGIN
                GenBatches.INIT;
                GenBatches."Journal Template Name":='GENERAL';
                GenBatches.Name:='MOBILELOAN';
                GenBatches.Description:=LoanProductsSetup.Code+' Advance';
                GenBatches.VALIDATE(GenBatches."Journal Template Name");
                GenBatches.VALIDATE(GenBatches.Name);
                GenBatches.INSERT;
                END;

                //Post Loan
                LoansRegister.RESET;
                LoansRegister.SETRANGE(LoansRegister."Doc No Used",docNo);
                IF LoansRegister.FIND('-') THEN BEGIN

        //Dr Loan Acc
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=LoansRegister."Client Code";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:=LoansRegister."Loan Product Type Name";
                GenJournalLine.Amount:=amount;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

        //Cr Fosa Acc
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=Vendor."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:=GenBatches.Description;
                GenJournalLine.Amount:=-amount;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

       //Dr Fosa Acc with charges
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=Vendor."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='Mobile Loan Charge';
                GenJournalLine.Amount:=loanAdvanceCharge;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;


       //Excise Duty Deduction

                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=Vendor."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='Excise Duty - Loan Charge';
                GenJournalLine.Amount:=loanAdvanceCharge*GenSetup."Excise Duty(%)"/100;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

      //Credit Excise duty

                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=GenSetup."Excise Duty Account";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='Excise Duty - Loan Charge';
                GenJournalLine.Amount:=-loanAdvanceCharge*GenSetup."Excise Duty(%)"/100;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

       //Dr  Acc with INTERESTST CHARGES
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=Vendor."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='Interest Paid';
                GenJournalLine.Amount:=InterestAmount;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

           //Dr Fosa Acc with charges
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine."Account No.":=SurePESACommACC;
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine.Description:='Mobile Loan Charge';
                GenJournalLine.Amount:=-loanAdvanceCharge;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

      // DR Interest charge
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                GenJournalLine."Account No.":=LoansRegister."Client Code";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";;
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
                GenJournalLine."Bal. Account No.":=InterestAcc;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

           // CR Interest charge
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='GENERAL';
                GenJournalLine."Journal Batch Name":='MOBILELOAN';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                GenJournalLine."Account No.":=LoansRegister."Client Code";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No.":=LoansRegister."Loan  No.";;
                GenJournalLine."External Document No.":='';
                GenJournalLine."Posting Date":=TODAY;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                GenJournalLine.Description:='Loan ' +FORMAT(GenJournalLine."Transaction Type"::"Interest Paid");
                GenJournalLine.Amount:=-InterestAmount;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                GenJournalLine."Shortcut Dimension 1 Code":=Members."Global Dimension 1 Code";
                GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                END;
                GenJournalLine."Loan No":=LoansRegister."Loan  No.";
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;




                //Post
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                GenJournalLine.SETRANGE("Journal Batch Name",'MOBILELOAN');
                IF GenJournalLine.FIND('-') THEN BEGIN
                REPEAT
                GLPosting.RUN(GenJournalLine);
                UNTIL GenJournalLine.NEXT = 0;
                END;


                 msg:='Dear '+Vendor.Name+' your loan of KES '+FORMAT(amount)+' has been processed. KES '+FORMAT(amount)+' has been credited to your FOSA account '+Vendor."No."+
               '. Your monthly repayment of KES '+FORMAT(amount)+' is due on '+FORMAT(CALCDATE('+'+FORMAT(period)+'M',TODAY));

                //***************Update Loan Status************//
                LoansRegister."Loan Status":=LoansRegister."Loan Status"::Issued;
                LoansRegister."Amount Disbursed":=amount;
                LoansRegister.Posted:=TRUE;
               // LoansRegister."Discount Amount":=amount;
                LoansRegister."Outstanding Balance":=amount;
                LoansRegister.MODIFY;

          //Insert to Schedule***********//
          //LoanRepSchedule
                LoanRepSchedule.INIT;
                LoanRepSchedule."Loan No.":=loanNo;
                LoanRepSchedule."Member No.":=Vendor."No.";
                LoanRepSchedule."Loan Category":=loantype;
                LoanRepSchedule."Loan Amount":=AmountToCredit;
                LoanRepSchedule."Monthly Repayment":=AmountToCredit;
                LoanRepSchedule."Monthly Interest":=0;
                LoanRepSchedule."Repayment Date":=CALCDATE('1M',TODAY);
                LoanRepSchedule."Principal Repayment":=amount;
                LoanRepSchedule."Instalment No":=1;
                LoanRepSchedule."Loan Balance":=AmountToCredit;
                LoanRepSchedule.INSERT();

                SurePESATrans.INIT;
                SurePESATrans."Document No":=docNo;
                SurePESATrans.Description:= loantype+' Advance';
                SurePESATrans."Document Date":=TODAY;
                SurePESATrans."Account No" :=Vendor."No.";
                SurePESATrans."SMS Message":=msg;
         SurePESATrans.Charge:=TotalCharges;
                       SurePESATrans."Account Name":=Vendor.Name;
                        SurePESATrans."Telephone Number":=Vendor."Phone No.";

                SurePESATrans."Account No2" :='';
                SurePESATrans.Amount:=amount;
                SurePESATrans.Status:=SurePESATrans.Status::Completed;
                SurePESATrans.Posted:=TRUE;
                SurePESATrans."Posting Date":=TODAY;
                SurePESATrans.Comments:='Success';
                SurePESATrans.Client:=Vendor."BOSA Account No";
                SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Loan Application";
                SurePESATrans."Transaction Time":=TIME;
                SurePESATrans.INSERT;
                result:='TRUE';

                SMSMessage(docNo,Vendor."No.",Vendor."Phone No.",msg);

                //update dividend advance qualification amount
                //Modify remaining amount
                IF loantype = 'M-DIV' THEN
                  BEGIN
                    DivBuffer.RESET;
                    DivBuffer.SETRANGE(DivBuffer."Member No.",Vendor."BOSA Account No");
                    IF DivBuffer.FIND('-') THEN
                      BEGIN
                        DivBuffer."Qualifying Dividend":=DivBuffer."Qualifying Dividend"-amount;
                        DivBuffer.MODIFY;
                      END;
                  END;
                //end update dividend advance qualification

                END;//Loans Register
              END
        ELSE BEGIN
          result:='ACCINEXISTENT';
                SurePESATrans.INIT;
                SurePESATrans."Document No":=docNo;
                SurePESATrans.Description:=loantype+' Advance';
                SurePESATrans."Document Date":=TODAY;
                SurePESATrans."Account No" :=Vendor."No.";
                SurePESATrans."Account No2" :='';
                SurePESATrans.Amount:=amount;
                SurePESATrans.Status:=SurePESATrans.Status::Completed;
                SurePESATrans.Posted:=TRUE;
                SurePESATrans."Posting Date":=TODAY;
                SurePESATrans.Comments:='Failed.Invalid Account';
                SurePESATrans.Client:=Vendor."BOSA Account No";
                SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Loan Application";
                SurePESATrans."Transaction Time":=TIME;
                SurePESATrans.INSERT;
        END;
        END;
        }
    END;

    PROCEDURE AdvanceEligibilityDividend@6(account@1000000000 : Text[50];loantype@1003 : Code[50]) amount : Decimal;
    VAR
      dividendavailableAmount@1000000001 : Decimal;
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
      Vledger@1000 : Record 25;
      RCount@1001 : Integer;
      amountArrears@1002 : Decimal;
      LoanRepaymentS@1005 : Record 51516234;
      RepayedLoanAmt@1009 : Decimal;
      Fulldate@1008 : Date;
      LastRepayDate@1007 : Date;
      PrincipalAmount@1006 : Decimal;
      TotalAmount@1012 : Decimal;
      TransactionLoanAmt@1011 : Decimal;
      TransactionLoanDiff@1010 : Decimal;
      expiryDate@1004 : Date;
      dateToday@1013 : Date;
    BEGIN
          {loantype:='M-DIV';
          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",account);
          IF Vendor.FIND('-') THEN BEGIN

            //......check Loan Product Epiry Date.......//
            LoanProductsSetup.RESET;
            LoanProductsSetup.SETRANGE(LoanProductsSetup.Code,loantype);
            IF LoanProductsSetup.FINDFIRST() THEN BEGIN
              expiryDate:=LoanProductsSetup."Loan Product Expiry Date";
              END;
              IF expiryDate <>0D THEN BEGIN
                IF TODAY> expiryDate THEN BEGIN
                  amount:=6;
                  END ELSE BEGIN
                    amount:=6;
                    END;

            //*****Get Member Default Status-BOSA*****//

          LoansRegister.RESET;
          LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."No.");
          LoansRegister.SETRANGE(LoansRegister.Posted,TRUE);
          IF LoansRegister.FIND('-') THEN BEGIN
          REPEAT
            LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance");
          IF (LoansRegister."Outstanding Balance">0) THEN BEGIN

          //Check if member has an outstanding Dividend Advance

          IF LoansRegister."Loan Product Type" = 'M-DIV' THEN
            amountArrears:= amountArrears+(LoansRegister."Outstanding Balance");
            amount:=7;
              END;
          UNTIL LoansRegister.NEXT=0;

          END;

          // ============================================Get arreas

              LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."Client Code",Vendor."No.");
               LoansRegister.SETFILTER(LoansRegister."Loan Product Type",'<>%1','M-JIENJOY');
              IF LoansRegister.FIND('-') THEN BEGIN

             REPEAT
                LoansRegister.CALCFIELDS(LoansRegister."Oustanding Interest",LoansRegister."Outstanding Balance");
             IF (LoansRegister."Oustanding Interest" >0)  OR (LoansRegister."Outstanding Balance">0)  THEN BEGIN
              LoanRepaymentS.RESET;
              LoanRepaymentS.SETRANGE(LoanRepaymentS."Loan No.",LoansRegister."Loan  No.");
              IF LoanRepaymentS.FIND('-') THEN BEGIN
                REPEAT

                     Fulldate:= DMY2DATE(DATE2DMY(280511D,1),DATE2DMY(TODAY,2),DATE2DMY(TODAY,3));
                     LastRepayDate:= DMY2DATE(DATE2DMY(280511D,1),DATE2DMY(LoanRepaymentS."Repayment Date",2),DATE2DMY(LoanRepaymentS."Repayment Date",3));


                   IF Fulldate>=LastRepayDate THEN BEGIN

                     PrincipalAmount:= PrincipalAmount+LoanRepaymentS."Principal Repayment";
                     END;
                   //  EXIT
                 UNTIL LoanRepaymentS.NEXT=0;
              END;


              MemberLedgerEntry.RESET;
              MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Loan No",LoansRegister."Loan  No.");
              MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Loan Repayment");
              MemberLedgerEntry.CALCSUMS(MemberLedgerEntry."Credit Amount (LCY)");
              TransactionLoanAmt:=MemberLedgerEntry."Credit Amount (LCY)";
              TransactionLoanDiff:=PrincipalAmount-TransactionLoanAmt;

              IF TransactionLoanDiff>0 THEN BEGIN
                RepayedLoanAmt:=TransactionLoanDiff;
                 amount:=3;
                END ELSE BEGIN
                  PrincipalAmount:=0;
                 RepayedLoanAmt:=RepayedLoanAmt+0;
              END;
              END;//BAL
           UNTIL LoansRegister.NEXT=0;
          END;

          IF amount<>2 THEN BEGIN
            IF amount<>3 THEN BEGIN
              // ==============================Get available dividend balance
          dividendavailableAmount:=0;
          Members.RESET;
          Members.SETRANGE("No.", Vendor."BOSA Account No");

          IF Members.FIND('-') THEN BEGIN
            Members.CALCFIELDS(Members."Dividend Advance Qualification");
            dividendavailableAmount:=ROUND(Members."Dividend Advance Qualification",0.05,'=');
           // amount:=0.75*dividendavailableAmount;
           amount:=dividendavailableAmount;
         END;


            IF amount<0 THEN BEGIN
              amount:=8;
            END;
              //IF amount<1000 THEN BEGIN
             // amount:=0;
            //END;

              IF amount>5000 THEN BEGIN
              amount:=5000;
            END;

          END;//End of Loan Default Check
          END;//End of Existing Adavance Loan Check
          END; //End of Loan Product Expiry
        END;//End Vendor
        }
    END;

    PROCEDURE FnMbankingRegistration@2(dateOfBirth@1006 : Date;firstName@1005 : Code[250];otherName@1004 : Code[250];surname@1003 : Code[250];idNumber@1001 : Code[250];phone@1000 : Code[100];email@1002 : Text[100];address@1007 : Text[100];Residence@1008 : Text[100];Postalcode@1009 : Text[100]) result : Text[1000];
    BEGIN
      {
      Members.RESET;
      Members.SETRANGE(Members."ID No.",idNumber);
      IF Members.FIND('-') THEN BEGIN
        EXIT('0:::Member already registered');
      END;

      MbankingBuffer.RESET;
      MbankingBuffer.SETRANGE(MbankingBuffer."Id no",idNumber);
      IF MbankingBuffer.FIND('-') THEN BEGIN
        EXIT('0:::Member already registered');
      END;
      MbankingBuffer.RESET;
      MbankingBuffer.INIT;
      MbankingBuffer."Date of Birth":=dateOfBirth;
      MbankingBuffer."First Name":=firstName;
      MbankingBuffer."Other Names":=otherName;
      MbankingBuffer."Last Name":=surname;
      MbankingBuffer."Id no":=idNumber;
      MbankingBuffer."Phone number":=phone;
      MbankingBuffer.email:=email;
      MbankingBuffer.Address:=address;
      MbankingBuffer.Residence:=Residence;
      MbankingBuffer."postal code":=Postalcode;
      MbankingBuffer."Captured by":=USERID;
      IF MbankingBuffer.INSERT=TRUE THEN BEGIN
        EXIT('1:::Your information has been received and is being Processed, You will receive sms notification');
       END;
       }
    END;

    PROCEDURE FnpostDetails@4(RequestNo@1000 : Integer;code@1001 : Code[10];idnumber@1002 : Code[50];Names@1003 : Text[250];Grade@1120054000 : Code[100];MobileLoanScore@1120054001 : Code[100]);
    BEGIN
      {CrbAdvance.RESET;
      CrbAdvance.SETRANGE(CrbAdvance."Request No",RequestNo);
      IF CrbAdvance.FIND('-')=FALSE THEN BEGIN
        CrbAdvance.INIT;
        CrbAdvance."Request No":=RequestNo;
        CrbAdvance."Response code":=code;
        CrbAdvance."ID Number":=idnumber;
        CrbAdvance.Names:=Names;
        CrbAdvance.CrbRequested:=FALSE;
        CrbAdvance.INSERT;

      END;
      }
    END;

    PROCEDURE FnCheckCrbStatus@1120054000() res : Boolean;
    BEGIN
    END;

    PROCEDURE FnCheckIfTransRequest@1120054001(IDnumber@1120054000 : Code[100]) Result : Code[50];
    BEGIN
      Result:='';
    END;

    BEGIN
    {
      //
    }
    END.
  }
}

