OBJECT CodeUnit 20386 CloudPESALivexx
{
  OBJECT-PROPERTIES
  {
    Date=02/22/17;
    Time=[ 4:20:26 PM];
    Modified=Yes;
    Version List=CloudPESA;
  }
  PROPERTIES
  {
    OnRun=BEGIN
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
      LoansTable@1000000017 : Record 51516230;
      SurePESAApplications@1000000001 : Record 51516521;
      GenJournalLine@1000000019 : Record 81;
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
      BOSATransSchedule@1000000031 : Record 51516265;
      SMSMessages@1000000032 : Record 51516329;
      iEntryNo@1000000033 : Integer;
      msg@1000000034 : Text[250];
      accountName1@1000000035 : Text[40];
      accountName2@1000000036 : Text[40];
      fosaAcc@1000000037 : Text[30];
      LoanGuaranteeDetails@1000000038 : Record 51516231;
      bosaNo@1000000039 : Text[20];
      SaccoName@1000000040 : TextConst 'ENU=Telepost Sacco';

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
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          ExcDuty:=(10/100)*MobileCharges;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",Acc);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

                IF Vendor."Account Type"='WSS' THEN
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
                      GenJournalLine.Amount:=(MobileCharges-ExcDuty) + SurePESACharge ;
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
                      GenJournalLine."Account No.":=FORMAT('200-000-168');
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
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
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
                      GenJournalLine."External Document No.":=MobileChargesACC;
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Balance Enquiry Charges';
                      GenJournalLine.Amount:=(MobileCharges-ExcDuty)*-1;
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
    END;

    PROCEDURE MiniStatement@1000000010(Phone@1000000000 : Text[20];DocNumber@1000000001 : Text[20]) MiniStmt : Text[250];
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
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."Phone No.",Phone);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
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
                      GenJournalLine."Account No.":=fosaAcc;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
                      GenJournalLine."External Document No.":=fosaAcc;
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
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=SurePESACommACC;
                      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                      GenJournalLine."Document No.":=DocNumber;
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

    PROCEDURE LoanProducts@1000000040() LoanTypes : Text[150];
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
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",Phone);
        IF Vendor.FIND('-') THEN BEGIN
          bosaAcc:=Vendor."BOSA Account No";
          END;
      END
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
            reginfo:=Members."No."+':::'+Members.Name+':::'+FORMAT(Members."ID No.")+':::'+Members."Payroll/Staff No"+':::'+ Members."E-Mail";
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
               accounts:=accounts+'::::'+Vendor.Name;
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

    PROCEDURE LoanBalances@1000000017(phone@1000000000 : Text[20]) loanbalances : Text[250];
    BEGIN
      BEGIN
            Vendor.SETRANGE(Vendor."Phone No.",phone)   ;
            IF Vendor.FIND('-') THEN BEGIN
                LoansTable.RESET;
                LoansTable.SETRANGE(LoansTable."Account No",Vendor."No.");
                IF LoansTable.FIND('-') THEN BEGIN
                REPEAT
                  LoansTable.CALCFIELDS(LoansTable."Outstanding Balance",LoansTable."Interest Due",LoansTable."Interest to be paid",LoansTable."Interest Paid");
                  IF (LoansTable."Outstanding Balance">0)OR(LoansTable."Interest Due">0) THEN
                  loanbalances:= loanbalances + '::::' + LoansTable."Loan Product Type Name" + ':::'+
                   FORMAT(LoansTable."Outstanding Balance"+LoansTable."Interest Due") ;
                UNTIL LoansTable.NEXT = 0;
                END;
            END;
       END;
    END;

    PROCEDURE MemberAccounts@1000000000(phone@1000000000 : Text[20]) accounts : Text[250];
    BEGIN
      BEGIN
        Vendor.RESET;
        Vendor.SETRANGE(Vendor."Phone No.",phone);
        Vendor.SETRANGE(Vendor.Status, Vendor.Status::Active);
        Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
        IF Vendor.FIND('-') THEN
          BEGIN
             accounts:='';
             REPEAT
               accounts:=accounts+'::::'+Vendor."No."+':::'+Vendor.Name;
             UNTIL Vendor.NEXT =0;
          END
        ELSE
        BEGIN
           accounts:='';
        END
        END;
    END;

    PROCEDURE SurePESARegistration@1000000002() memberdetails : Text[1000];
    BEGIN
      BEGIN
        SurePESAApplications.RESET;
        SurePESAApplications.SETRANGE(SurePESAApplications.SentToServer, FALSE);
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
            MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Benevolent Fund");
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
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          ExcDuty:=(10/100)*MobileCharges;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",accFrom);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

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
                      GenJournalLine.Amount:=(MobileCharges-ExcDuty) + SurePESACharge ;
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
                      GenJournalLine."Account No.":=FORMAT('200-000-3016');
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
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=(MobileCharges-ExcDuty)*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=SurePESACommACC;
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
                      accountName1:=Vendor.Name;
                      Vendor.RESET();
                      Vendor.SETRANGE(Vendor."No.",accTo);
                      IF Vendor.FIND('-') THEN BEGIN
                        accountName2:=Vendor.Name;
                      END;


                         msg:='You have transfered KES '+FORMAT(amount)+' from Account '+accountName1+' to '+accountName2+
                          ' .Thank you for using '+SaccoName+' Mobile.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                           msg:='You have insufficient funds in your savings Account to use this service.'+
                          ' .Thank you for using '+SaccoName+' Mobile.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END;
              END
              ELSE BEGIN
                result:='ACC2INEXISTENT';
                           msg:='Your request has failed because the recipent account does not exist.'+
                          ' .Thank you for using '+SaccoName+' Mobile.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
              END;
          END
          ELSE BEGIN
            result:='ACCINEXISTENT';
                        result:='INSUFFICIENT';
                        msg:='Your request has failed because the recipent account does not exist.'+
                        ' .Thank you for using '+SaccoName+' Mobile.';
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
          MobileCharges:=Charges."Charge Amount";
          MobileChargesACC:=Charges."GL Account";
        END;

          SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
          SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

          ExcDuty:=(10/100)*MobileCharges;

          Vendor.RESET;
          Vendor.SETRANGE(Vendor."No.",accFrom);
          IF Vendor.FIND('-') THEN BEGIN
           Vendor.CALCFIELDS(Vendor."Balance (LCY)");
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

          BOSATransSchedule.RESET;
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
                      GenJournalLine.Amount:=(MobileCharges-ExcDuty) + SurePESACharge ;
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
                      GenJournalLine."Account No.":=FORMAT('200-000-3016');
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
                      GenJournalLine."Posting Date":=TODAY;
                      GenJournalLine.Description:='Mobile Transfer Charges';
                      GenJournalLine.Amount:=(MobileCharges-ExcDuty)*-1;
                      GenJournalLine.VALIDATE(GenJournalLine.Amount);
                      IF GenJournalLine.Amount<>0 THEN
                      GenJournalLine.INSERT;

              //CR Commission
                      LineNo:=LineNo+10000;
                      GenJournalLine.INIT;
                      GenJournalLine."Journal Template Name":='GENERAL';
                      GenJournalLine."Journal Batch Name":='MOBILETRAN';
                      GenJournalLine."Line No.":=LineNo;
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                      GenJournalLine."Account No.":=SurePESACommACC;
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
                          ' .Thank you for using '+SaccoName+' Mobile.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END
                   ELSE BEGIN
                   result:='INSUFFICIENT';
                           msg:='You have insufficient funds in your savings Account to use this service.'+
                          '. Thank you for using '+SaccoName+' Mobile.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                   END;
              END
              ELSE BEGIN
                result:='ACC2INEXISTENT';
                           msg:='Your request has failed because the recipent account does not exist.'+
                          '. Thank you for using '+SaccoName+' Mobile.';
                          SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
              END;
          END
          ELSE BEGIN
            result:='ACCINEXISTENT';
                        result:='INSUFFICIENT';
                        msg:='Your request has failed because the recipent account does not exist.'+
                        '. Thank you for using '+SaccoName+' Mobile.';
                        SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
          END;
        END
        ELSE BEGIN
            result:='MEMBERINEXISTENT';
                      msg:='Your request has failed because the recipent account does not exist.'+
                      '. Thank you for using '+SaccoName+' Mobile.';
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
        Vendor.SETRANGE(Vendor."Account Type", 'ORDINARY');
        Vendor.SETRANGE(Vendor.Blocked, Vendor.Blocked::" ");
        IF Vendor.FIND('-') THEN
          BEGIN
               accounts:=Vendor."No."+':::'+Vendor.Name;
          END
        ELSE
        BEGIN
           accounts:='';
        END
        END;
    END;

    LOCAL PROCEDURE SMSMessage@1000000051(documentNo@1000000000 : Text[30];accfrom@1000000001 : Text[30];phone@1000000002 : Text[20];message@1000000003 : Text[250]);
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
          SMSMessages."Telephone No":='+254702262990';//phone;
          IF SMSMessages."Telephone No"<>'' THEN
          SMSMessages.INSERT;
    END;

    PROCEDURE LoanRepayment@1000000015(accFrom@1000000000 : Text[20];loanNo@1000000001 : Text[20];DocNumber@1000000002 : Text[30];amount@1000000003 : Decimal) result : Text[30];
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
              MobileCharges:=Charges."Charge Amount";
              MobileChargesACC:=Charges."GL Account";
            END;

              SurePESACommACC:=  GenLedgerSetup."CloudPESA Comm Acc";
              SurePESACharge:=GenLedgerSetup."CloudPESA Charge";

              ExcDuty:=(10/100)*MobileCharges;

              Vendor.RESET;
              Vendor.SETRANGE(Vendor."No.",accFrom);
              IF Vendor.FIND('-') THEN BEGIN
                   Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                   TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");

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
                                  GenJournalLine.Amount:=(MobileCharges-ExcDuty) + SurePESACharge ;
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
                                  GenJournalLine."Account No.":=FORMAT('200-000-3016');
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
                                  GenJournalLine."Posting Date":=TODAY;
                                  GenJournalLine.Description:='Mobile Charges';
                                  GenJournalLine.Amount:=(MobileCharges-ExcDuty)*-1;
                                  GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  IF GenJournalLine.Amount<>0 THEN
                                  GenJournalLine.INSERT;

                          //CR Commission
                                  LineNo:=LineNo+10000;
                                  GenJournalLine.INIT;
                                  GenJournalLine."Journal Template Name":='GENERAL';
                                  GenJournalLine."Journal Batch Name":='MOBILETRAN';
                                  GenJournalLine."Line No.":=LineNo;
                                  GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                  GenJournalLine."Account No.":=SurePESACommACC;
                                  GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                  GenJournalLine."Document No.":=DocNumber;
                                  GenJournalLine."External Document No.":=MobileChargesACC;
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
                                  GenJournalLine.RESET;
                                  GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                  GenJournalLine.SETRANGE("Journal Batch Name",'MOBILETRAN');
                                  GenJournalLine.DELETEALL;

                                  SurePESATrans.INIT;
                                  SurePESATrans."Document No":=DocNumber;
                                  SurePESATrans.Description:='Mobile Transfer';
                                  SurePESATrans."Document Date":=TODAY;
                                  SurePESATrans."Account No" :=accFrom;
                                  SurePESATrans."Account No2" :=loanNo;
                                  SurePESATrans.Amount:=amount;
                                  SurePESATrans.Posted:=TRUE;
                                  SurePESATrans."Posting Date":=TODAY;
                                  SurePESATrans.Comments:='Success';
                                  SurePESATrans.Client:=Vendor."BOSA Account No";
                                  SurePESATrans."Transaction Type":=SurePESATrans."Transaction Type"::"Transfer to Fosa";
                                  SurePESATrans."Transaction Time":=TIME;
                                  SurePESATrans.INSERT;
                                  result:='TRUE';

                                     msg:='You have transfered KES '+FORMAT(amount)+' from Account '+Vendor.Name+' to '+loanNo+
                                      '. Thank you for using '+SaccoName+' Mobile.';
                                      SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                                END;
                               END
                               ELSE BEGIN
                               result:='INSUFFICIENT';
                                       msg:='You have insufficient funds in your savings Account to use this service.'+
                                      '. Thank you for using '+SaccoName+' Mobile.';
                                      SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                               END;
                      END
                      ELSE BEGIN
                        result:='ACC2INEXISTENT';
                                   msg:='Your request has failed because you do not have any outstanding balance.'+
                                  '. Thank you for using '+SaccoName+' Mobile.';
                                  SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                      END;
                END
                ELSE BEGIN
                  result:='ACCINEXISTENT';
                              msg:='Your request has failed.Please make sure you are registered for mobile banking.'+
                              '. Thank you for using '+SaccoName+' Mobile.';
                              SMSMessage(DocNumber,accFrom,Vendor."Phone No.",msg);
                END;
            END
            ELSE BEGIN
                result:='MEMBERINEXISTENT';
                          msg:='Your request has failed because the recipent account does not exist.'+
                          '. Thank you for using '+SaccoName+' Mobile.';
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
              LoansTable.RESET;
              LoansTable.SETRANGE(LoansTable."Account No",Vendor."No.");
              IF LoansTable.FIND('-') THEN BEGIN
              REPEAT
                LoansTable.CALCFIELDS(LoansTable."Outstanding Balance",LoansTable."Interest Due",LoansTable."Interest to be paid",LoansTable."Interest Paid");
                IF (LoansTable."Outstanding Balance">0)OR(LoansTable."Interest Due">0) THEN
                loannos:= loannos + ':::' + LoansTable."Loan  No.";
              UNTIL LoansTable.NEXT = 0;
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
              guarantors:=guarantors + '::::' + LoanGuaranteeDetails.Name+':::'+FORMAT(LoanGuaranteeDetails."Amont Guaranteed");
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
          bosaNo:=Vendor."BOSA Account No";
          END;
          LoanGuaranteeDetails.RESET;
          LoanGuaranteeDetails.SETRANGE(LoanGuaranteeDetails."Member No",bosaNo);
          IF LoanGuaranteeDetails.FIND('-') THEN BEGIN
            REPEAT
                guarantors:=guarantors + ':::' + LoanGuaranteeDetails."Loan No"+':'+FORMAT(LoanGuaranteeDetails."Amont Guaranteed");
            UNTIL LoanGuaranteeDetails.NEXT =0;
          END;
      END;
    END;

    PROCEDURE ClientCodes@1000000052(loanNo@1000000000 : Text[20]) codes : Text[20];
    BEGIN
      BEGIN
        LoansTable.RESET;
        LoansTable.SETRANGE(LoansTable."Loan  No.",loanNo);
        IF LoansTable.FIND('-') THEN BEGIN
          codes:=LoansTable."Client Code";
          END;
      END
    END;

    PROCEDURE ClientNames@1000000053(ccode@1000000000 : Text[20]) names : Text[100];
    BEGIN
      BEGIN
        LoansTable.RESET;
        LoansTable.SETRANGE(LoansTable."Client Code",ccode);
        IF LoansTable.FIND('-') THEN BEGIN
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
           TempBalance:=Vendor."Balance (LCY)"-(Vendor."ATM Transactions"+Vendor."Uncleared Cheques"+Vendor."EFT Transactions");
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
                      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
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

    BEGIN
    END.
  }
}

