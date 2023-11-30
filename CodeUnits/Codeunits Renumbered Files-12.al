OBJECT CodeUnit 20376 Release Membership app
{
  OBJECT-PROPERTIES
  {
    Date=10/18/21;
    Time=[ 4:59:07 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    TableNo=51516220;
    OnRun=BEGIN
            Status:=Status::Approved;
            MODIFY;
          END;

  }
  CODE
  {
    VAR
      UserSetup@1120054000 : Record 2000000120;
      ObjGenSetUp@1120054001 : Record 51516257;
      ObjCompInfo@1120054002 : Record 79;
      ObjLoans@1120054003 : Record 51516230;
      ObjMemberLedgerEntry@1120054004 : Record 51516224;
      ObjLoanProductSetup@1120054005 : Record 51516240;
      ObjProductCharges@1120054006 : Record 51516242;
      ObjBanks@1120054007 : Record 270;
      ObjMembers@1120054008 : Record 51516223;
      ObjMembers2@1120054009 : Record 51516223;
      VarRepaymentPeriod@1120054010 : Date;
      VarLoanNo@1120054013 : Code[20];
      VarLastMonth@1120054012 : Date;
      ObjLSchedule@1120054011 : Record 51516234;
      VarDateFilter@1120054019 : Text;
      VarLBal@1120054018 : Decimal;
      VarArrears@1120054017 : Decimal;
      VarDate@1120054016 : Integer;
      VarMonth@1120054015 : Integer;
      VarYear@1120054014 : Integer;
      VarLastMonthBeginDate@1120054022 : Date;
      VarScheduleDateFilter@1120054021 : Text;
      VarScheduleRepayDate@1120054020 : Date;
      VarScheduledLoanBal@1120054023 : Decimal;

    PROCEDURE PerformRelease@1000000000(VAR MembApp@1000000000 : Record 51516220);
    BEGIN
      WITH MembApp DO BEGIN
        CODEUNIT.RUN(CODEUNIT::"Release Membership app",MembApp);
        END;
    END;

    PROCEDURE FnCreateGnlJournalLine@1000000001(TemplateName@1000000000 : Text;BatchName@1000000001 : Text;DocumentNo@1000000002 : Code[30];LineNo@1000000003 : Integer;TransactionType@1000000009 : ' ,Registration Fee,Share Capital,Interest Paid,Loan Repayment,Deposit Contribution,Insurance Contribution,Benevolent Fund,Loan,Unallocated Funds,Dividend,FOSA Account,Loan Insurance Charged,Loan Insurance Paid,Recovery Account,FOSA Shares,Additional Shares,Interest Due,Capital Reserve';AccountType@1000000004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Member,Investor';AccountNo@1000000006 : Code[50];TransactionDate@1000000007 : Date;TransactionAmount@1000000010 : Decimal;DimensionActivity@1000000012 : Code[40];ExternalDocumentNo@1000000011 : Code[50];TransactionDescription@1000000008 : Text;LoanNumber@1000000013 : Code[50]);
    VAR
      GenJournalLine@1000000005 : Record 81;
    BEGIN
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":=TemplateName;
      GenJournalLine."Journal Batch Name":=BatchName;
      GenJournalLine."Document No.":=DocumentNo;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=AccountType;
      GenJournalLine."Account No.":=AccountNo;
      GenJournalLine."Transaction Type":=TransactionType;
      GenJournalLine."Loan No":=LoanNumber;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":=TransactionDate;
      GenJournalLine.Description:=TransactionDescription;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=TransactionAmount;
      GenJournalLine."External Document No.":=ExternalDocumentNo;
      //GenJournalLine."Source No.":=AccountNo;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DimensionActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=FnGetUserBranch();
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
    END;

    PROCEDURE FnGetUserBranch@1000000003() branchCode : Code[20];
    BEGIN
      UserSetup.RESET;
      UserSetup.SETRANGE(UserSetup."User Name",USERID);
      IF UserSetup.FIND('-') THEN BEGIN
        branchCode:=UserSetup.Branch;
        END;
        EXIT(branchCode);
    END;

    PROCEDURE FnSendSMS@1120054000(SMSSource@1000000001 : Text;SMSBody@1000000002 : Text;CurrentAccountNo@1000000003 : Text;MobileNumber@1000000005 : Text);
    VAR
      SMSMessage@1000000000 : Record 51516329;
      iEntryNo@1000000004 : Integer;
    BEGIN
      ObjGenSetUp.GET;
      ObjCompInfo.GET;

      SMSMessage.RESET;
      IF SMSMessage.FIND('+') THEN BEGIN
      iEntryNo:=SMSMessage."Entry No";
      iEntryNo:=iEntryNo+1;
      END
      ELSE BEGIN
      iEntryNo:=1;
      END;

      SMSMessage.LOCKTABLE;
      SMSMessage.INIT;

      SMSMessage."Entry No":=iEntryNo;
      SMSMessage."Batch No":=CurrentAccountNo;
      SMSMessage."Document No":='';
      SMSMessage."Account No":=CurrentAccountNo;
      SMSMessage."Date Entered":=TODAY;
      SMSMessage."Time Entered":=TIME;
      SMSMessage.Source:=SMSSource;
      SMSMessage."Entered By":=USERID;
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      SMSMessage."SMS Message":=SMSBody+'.' +ObjCompInfo.Name+' '+ObjGenSetUp."Customer Care No";
      SMSMessage."Telephone No":=MobileNumber;
      IF ((MobileNumber<>'') AND (SMSBody<>'')) THEN
      SMSMessage.INSERT;
    END;

    PROCEDURE FnGetInterestDueFiltered@1000000020(ObjLoans@1000000000 : Record 51516230;DateFilter@1000000002 : Text) : Decimal;
    VAR
      ObjLoanRegister@1000000001 : Record 51516230;
    BEGIN
      ObjLoans.SETFILTER("Date filter",DateFilter);
      ObjLoans.CALCFIELDS("Schedule Interest to Date","Outstanding Balance");
      EXIT(ObjLoans."Schedule Interest to Date");
    END;

    LOCAL PROCEDURE FnGetMemberLoanBalance@1000000005(LoanNo@1000000000 : Code[50];DateFilter@1000000001 : Date;TotalBalance@1000000002 : Decimal);
    BEGIN
      ObjLoans.RESET;
      ObjLoans.SETRANGE(ObjLoans."Loan  No.",LoanNo);
      ObjLoans.SETFILTER(ObjLoans."Date filter",'..%1',DateFilter);
       IF ObjMemberLedgerEntry.FINDSET THEN BEGIN
      TotalBalance:=TotalBalance+ObjMemberLedgerEntry."Amount (LCY)";
      END;
    END;

    PROCEDURE FnGenerateRepaymentScheduleChuna@22(LoanNumber@1000000000 : Code[50]);
    VAR
      LoansRec@1000000001 : Record 51516230;
      RSchedule@1000000002 : Record 51516234;
      LoanAmount@1000000003 : Decimal;
      InterestRate@1000000004 : Decimal;
      RepayPeriod@1000000005 : Integer;
      InitialInstal@1000000006 : Decimal;
      LBalance@1000000007 : Decimal;
      RunDate@1000000008 : Date;
      InstalNo@1000000009 : Decimal;
      TotalMRepay@1000000010 : Decimal;
      LInterest@1000000011 : Decimal;
      LPrincipal@1000000012 : Decimal;
      GrPrinciple@1000000013 : Integer;
      GrInterest@1000000014 : Integer;
      RepayCode@1000000015 : Code[10];
      WhichDay@1000000016 : Integer;
    BEGIN
      LoansRec.RESET;
            LoansRec.SETRANGE(LoansRec."Loan  No.",LoanNumber);
            LoansRec.SETFILTER(LoansRec."Approved Amount",'>%1',0);
            //LoansRec.SETFILTER(LoansRec.Posted,'=%1',TRUE);
            IF LoansRec.FIND('-') THEN BEGIN
              IF ((LoansRec."Issued Date"<>0D) AND (LoansRec."Repayment Start Date"<>0D)) THEN BEGIN
            LoansRec.TESTFIELD(LoansRec."Loan Disbursement Date");
            LoansRec.TESTFIELD(LoansRec."Repayment Start Date");

            RSchedule.RESET;
            RSchedule.SETRANGE(RSchedule."Loan No.",LoansRec."Loan  No.");
            RSchedule.DELETEALL;

            //LoanAmount:=LoansRec."Approved Amount";
            LoanAmount:=LoansRec."Approved Amount";
            InterestRate:=LoansRec.Interest;
            RepayPeriod:=LoansRec.Installments;
            InitialInstal:=LoansRec.Installments+LoansRec."Grace Period - Principle (M)";
            //LBalance:=LoansRec."Approved Amount";
            LBalance:=LoansRec."Approved Amount";
            RunDate:=LoansRec."Repayment Start Date";
            InstalNo:=0;

            //Repayment Frequency
            IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
            RunDate:=CALCDATE('-1D',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
            RunDate:=CALCDATE('-1W',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
            RunDate:=CALCDATE('-1M',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
            RunDate:=CALCDATE('-1Q',RunDate);
            //Repayment Frequency


            REPEAT
            InstalNo:=InstalNo+1;
            //Repayment Frequency
            IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
            RunDate:=CALCDATE('1D',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
            RunDate:=CALCDATE('1W',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
            RunDate:=CALCDATE('1M',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
            RunDate:=CALCDATE('1Q',RunDate);

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Amortised THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Installments);
            TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.0001,'>');
            LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.0001,'>');
            LPrincipal:=TotalMRepay-LInterest;
            END;

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Straight Line" THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Interest);
            LoansRec.TESTFIELD(LoansRec.Installments);
            LPrincipal:=LoanAmount/RepayPeriod;
            LInterest:=(InterestRate/12/100)*LoanAmount/RepayPeriod;
            END;

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Reducing Balance" THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Interest);
            LoansRec.TESTFIELD(LoansRec.Installments);
            LPrincipal:=LoanAmount/RepayPeriod;
            LInterest:=(InterestRate/12/100)*LBalance;
            END;

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Constants THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Repayment);
            IF LBalance < LoansRec.Repayment THEN
            LPrincipal:=LBalance
            ELSE
            LPrincipal:=LoansRec.Repayment;
            LInterest:=LoansRec.Interest;
            END;

            //Grace Period
            IF GrPrinciple > 0 THEN BEGIN
            LPrincipal:=0
            END ELSE BEGIN
            LBalance:=LBalance-LPrincipal;

            END;

            IF GrInterest > 0 THEN
            LInterest:=0;

            GrPrinciple:=GrPrinciple-1;
            GrInterest:=GrInterest-1;
            EVALUATE(RepayCode,FORMAT(InstalNo));


            RSchedule.INIT;
            RSchedule."Repayment Code":=RepayCode;
            RSchedule."Interest Rate":=InterestRate;
            RSchedule."Loan No.":=LoansRec."Loan  No.";
            RSchedule."Loan Amount":=LoanAmount;
            RSchedule."Instalment No":=InstalNo;
            RSchedule."Repayment Date":=CALCDATE('CM',RunDate);
            RSchedule."Member No.":=LoansRec."Client Code";
            RSchedule."Loan Category":=LoansRec."Loan Product Type";
            RSchedule."Monthly Repayment":=LInterest + LPrincipal;
            RSchedule."Monthly Interest":=LInterest;
            RSchedule."Principal Repayment":=LPrincipal;
            RSchedule."Loan Balance":=LBalance;
            RSchedule.INSERT;
            WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
            UNTIL LBalance < 1

            END;
            END;

            COMMIT;
    END;

    PROCEDURE FnGetChargeFee@1000000006(ProductCode@1000000000 : Code[50];InsuredAmount@1000000002 : Decimal;ChargeType@1000000003 : Code[100]) FCharged : Decimal;
    BEGIN
      IF ObjLoanProductSetup.GET(ProductCode) THEN BEGIN
          ObjProductCharges.RESET;
          ObjProductCharges.SETRANGE(ObjProductCharges."Product Code",ProductCode);
          ObjProductCharges.SETRANGE(ObjProductCharges.Code,ChargeType);
          IF ObjProductCharges.FIND('-') THEN BEGIN
              IF ObjProductCharges."Use Perc"=TRUE THEN BEGIN
                  FCharged:=InsuredAmount*(ObjProductCharges.Percentage/100);
                  //MESSAGE('Fcharged %1 | Insured Amount %2 | Charge %3',FCharged,InsuredAmount,ObjProductCharges.Percentage);

                  END
                ELSE
                FCharged:=ObjProductCharges.Amount;
            END;
      END;
      EXIT(FCharged);
    END;

    PROCEDURE FnGetChargeAccount@1000000013(ProductCode@1000000000 : Code[50];MemberCategory@1000000001 : 'Single,Joint,Corporate,Group,Parish,Church,Church Department,Staff';ChargeType@1000000003 : Code[100]) ChargeGLAccount : Code[50];
    BEGIN
      IF ObjLoanProductSetup.GET(ProductCode) THEN
        BEGIN
          ObjProductCharges.RESET;
          ObjProductCharges.SETRANGE(ObjProductCharges."Product Code",ProductCode);
          ObjProductCharges.SETRANGE(ObjProductCharges.Code,ChargeType);
          IF ObjProductCharges.FIND('-') THEN
            BEGIN
              ChargeGLAccount:=ObjProductCharges."G/L Account";
            END;
          END;
      EXIT(ChargeGLAccount);
    END;

    PROCEDURE FnGetTellerTillNo@1000000024() TellerTillNo : Code[40];
    BEGIN
      ObjBanks.RESET;
      ObjBanks.SETRANGE(ObjBanks."Account Type",ObjBanks."Account Type"::Cashier);
      ObjBanks.SETRANGE(ObjBanks.CashierID,USERID);
      IF ObjBanks.FIND('-') THEN BEGIN
      TellerTillNo:=ObjBanks."No.";
      END;
      EXIT(TellerTillNo);
    END;

    LOCAL PROCEDURE FnUpdateMonthlyContributions@1000000008();
    BEGIN
      ObjMembers.RESET;
      ObjMembers.SETCURRENTKEY(ObjMembers."No.");
      ObjMembers.SETRANGE(ObjMembers."Monthly Contribution",0.0);
      IF ObjMembers.FINDSET THEN BEGIN
        REPEAT
          ObjMembers2."Monthly Contribution":=500;
          ObjMembers2.MODIFY;
        UNTIL ObjMembers.NEXT=0;
        MESSAGE('Succesfully done');
      END;


    END;

    PROCEDURE FnGetTransferFee@1000000012(DisbursementMode@1000000000 : ' ,Cheque,Bank Transfer,EFT,RTGS,Cheque NonMember') : Decimal;
    VAR
      TransferFee@1000000001 : Decimal;
    BEGIN
      ObjGenSetUp.GET();
      CASE DisbursementMode OF
          DisbursementMode::"Bank Transfer":
          TransferFee:=ObjGenSetUp."Loan Trasfer Fee-FOSA";

          DisbursementMode::Cheque:
          TransferFee:=ObjGenSetUp."Loan Trasfer Fee-Cheque";

          DisbursementMode::"Cheque NonMember":
          TransferFee:=ObjGenSetUp."Loan Trasfer Fee-EFT";

          DisbursementMode::EFT:
          TransferFee:=ObjGenSetUp."Loan Trasfer Fee-RTGS";
       END;
       EXIT(TransferFee);
    END;

    PROCEDURE FnGetFosaAccount@1000000014(MemberNo@1000000000 : Code[50]) FosaAccount : Code[50];
    VAR
      ObjMembers@1000000001 : Record 51516223;
    BEGIN
      ObjMembers.RESET;
      ObjMembers.SETRANGE(ObjMembers."No.",MemberNo);
      IF ObjMembers.FIND('-') THEN BEGIN
         FosaAccount:=ObjMembers."FOSA Account";
        END;
        EXIT(FosaAccount);
    END;

    PROCEDURE FnClearGnlJournalLine@1000000029(TemplateName@1000000000 : Text;BatchName@1000000001 : Text);
    VAR
      GenJournalLine@1000000005 : Record 81;
    BEGIN
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",TemplateName);
      GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",BatchName);
      IF GenJournalLine.FINDSET THEN BEGIN
        GenJournalLine.DELETEALL;
        END;
    END;

    PROCEDURE FnPostGnlJournalLine@1000000030(TemplateName@1000000000 : Text;BatchName@1000000001 : Text);
    VAR
      GenJournalLine@1000000005 : Record 81;
    BEGIN
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",TemplateName);
      GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",BatchName);
      IF GenJournalLine.FINDSET THEN BEGIN
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
        END;
    END;

    PROCEDURE FnCreateGnlJournalLineBalanced@1000000015(TemplateName@1000000000 : Text;BatchName@1000000001 : Text;DocumentNo@1000000002 : Code[30];LineNo@1000000003 : Integer;TransactionType@1000000013 : ' ,Registration Fee,Share Capital,Interest Paid,Loan Repayment,Deposit Contribution,Insurance Contribution,Benevolent Fund,Loan,Unallocated Funds,Dividend,FOSA Account,Loan Insurance Charged,Loan Insurance Paid';AccountType@1000000004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Member,Investor';AccountNo@1000000006 : Code[50];TransactionDate@1000000007 : Date;TransactionDescription@1000000008 : Text;BalancingAccountType@1000000011 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';BalancingAccountNo@1000000009 : Code[50];TransactionAmount@1000000010 : Decimal;DimensionActivity@1000000012 : Code[40];LoanNo@1000000014 : Code[20]);
    VAR
      GenJournalLine@1000000005 : Record 81;
    BEGIN
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":=TemplateName;
      GenJournalLine."Journal Batch Name":=BatchName;
      GenJournalLine."Document No.":=DocumentNo;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Transaction Type":=TransactionType;
      GenJournalLine."Account Type":=AccountType;
      GenJournalLine."Account No.":=AccountNo;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":=TransactionDate;
      GenJournalLine.Description:=TransactionDescription;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=TransactionAmount;
      GenJournalLine."Loan No":=LoanNo;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=BalancingAccountType;
      GenJournalLine."Bal. Account No.":=BalancingAccountNo;
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DimensionActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=FnGetUserBranch();
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
    END;

    PROCEDURE FnChargeExcise@1000000016(ChargeCode@1000000000 : Code[100]) : Boolean;
    VAR
      ObjProductCharges@1000000001 : Record 51516241;
    BEGIN
      ObjProductCharges.RESET;
      ObjProductCharges.SETRANGE(Code,ChargeCode);
      IF ObjProductCharges.FIND('-') THEN
        EXIT(ObjProductCharges."Charge Excise");
    END;

    PROCEDURE FnGetInterestDueTodate@1000000017(ObjLoans@1000000000 : Record 51516230) : Decimal;
    VAR
      ObjLoanRegister@1000000001 : Record 51516230;
    BEGIN
      ObjLoans.SETFILTER("Date filter",'..'+FORMAT(TODAY));
      ObjLoans.CALCFIELDS("Schedule Interest to Date","Outstanding Balance");
      EXIT(ObjLoans."Schedule Interest to Date");
    END;

    PROCEDURE FnGetPhoneNumber@1000000018(ObjLoans@1000000000 : Record 51516230) : Code[50];
    BEGIN
      ObjMembers.RESET;
      ObjMembers.SETRANGE("No.",ObjLoans."Client Code");
      IF ObjMembers.FIND('-') THEN
        EXIT(ObjMembers."Mobile Phone No");
    END;

    PROCEDURE FnGenerateRepaymentSchedule@1000000035(LoanNumber@1000000000 : Code[50]);
    VAR
      LoansRec@1000000001 : Record 51516230;
      RSchedule@1000000002 : Record 51516234;
      LoanAmount@1000000003 : Decimal;
      InterestRate@1000000004 : Decimal;
      RepayPeriod@1000000005 : Integer;
      InitialInstal@1000000006 : Decimal;
      LBalance@1000000007 : Decimal;
      RunDate@1000000008 : Date;
      InstalNo@1000000009 : Decimal;
      TotalMRepay@1000000010 : Decimal;
      LInterest@1000000011 : Decimal;
      LPrincipal@1000000012 : Decimal;
      GrPrinciple@1000000013 : Integer;
      GrInterest@1000000014 : Integer;
      RepayCode@1000000015 : Code[10];
      WhichDay@1000000016 : Integer;
    BEGIN
      LoansRec.RESET;
            LoansRec.SETRANGE(LoansRec."Loan  No.",LoanNumber);
            LoansRec.SETFILTER(LoansRec."Approved Amount",'>%1',0);
            //LoansRec.SETFILTER(LoansRec.Posted,'=%1',TRUE);
            IF LoansRec.FIND('-') THEN BEGIN
              IF ((LoansRec."Issued Date"<>0D) AND (LoansRec."Repayment Start Date"<>0D)) THEN BEGIN
            LoansRec.TESTFIELD(LoansRec."Loan Disbursement Date");
            LoansRec.TESTFIELD(LoansRec."Repayment Start Date");

            RSchedule.RESET;
            RSchedule.SETRANGE(RSchedule."Loan No.",LoansRec."Loan  No.");
            RSchedule.DELETEALL;

            //LoanAmount:=LoansRec."Approved Amount";
            LoanAmount:=LoansRec."Approved Amount";
            InterestRate:=LoansRec.Interest;
            RepayPeriod:=LoansRec.Installments;
            InitialInstal:=LoansRec.Installments+LoansRec."Grace Period - Principle (M)";
            //LBalance:=LoansRec."Approved Amount";
            LBalance:=LoansRec."Approved Amount";
            RunDate:=LoansRec."Repayment Start Date";
            InstalNo:=0;

            //Repayment Frequency
            IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
            RunDate:=CALCDATE('-1D',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
            RunDate:=CALCDATE('-1W',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
            RunDate:=CALCDATE('-1M',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
            RunDate:=CALCDATE('-1Q',RunDate);
            //Repayment Frequency


            REPEAT
            InstalNo:=InstalNo+1;
            //Repayment Frequency
            IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
            RunDate:=CALCDATE('1D',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
            RunDate:=CALCDATE('1W',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
            RunDate:=CALCDATE('1M',RunDate)
            ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
            RunDate:=CALCDATE('1Q',RunDate);

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Amortised THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Installments);
            TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.0001,'>');
            LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.0001,'>');
            LPrincipal:=TotalMRepay-LInterest;
            END;

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Straight Line" THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Interest);
            LoansRec.TESTFIELD(LoansRec.Installments);
            LPrincipal:=LoanAmount/RepayPeriod;
            LInterest:=(InterestRate/12/100)*LoanAmount/RepayPeriod;
            END;

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Reducing Balance" THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Interest);
            LoansRec.TESTFIELD(LoansRec.Installments);
            LPrincipal:=LoanAmount/RepayPeriod;
            LInterest:=(InterestRate/12/100)*LBalance;
            END;

            IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Constants THEN BEGIN
            LoansRec.TESTFIELD(LoansRec.Repayment);
            IF LBalance < LoansRec.Repayment THEN
            LPrincipal:=LBalance
            ELSE
            LPrincipal:=LoansRec.Repayment;
            LInterest:=LoansRec.Interest;
            END;

            //Grace Period
            IF GrPrinciple > 0 THEN BEGIN
            LPrincipal:=0
            END ELSE BEGIN
            LBalance:=LBalance-LPrincipal;

            END;

            IF GrInterest > 0 THEN
            LInterest:=0;

            GrPrinciple:=GrPrinciple-1;
            GrInterest:=GrInterest-1;
            EVALUATE(RepayCode,FORMAT(InstalNo));


            RSchedule.INIT;
            RSchedule."Repayment Code":=RepayCode;
            RSchedule."Interest Rate":=InterestRate;
            RSchedule."Loan No.":=LoansRec."Loan  No.";
            RSchedule."Loan Amount":=LoanAmount;
            RSchedule."Instalment No":=InstalNo;
            RSchedule."Repayment Date":=CALCDATE('CM',RunDate);
            RSchedule."Member No.":=LoansRec."Client Code";
            RSchedule."Loan Category":=LoansRec."Loan Product Type";
            RSchedule."Monthly Repayment":=LInterest + LPrincipal;
            RSchedule."Monthly Interest":=LInterest;
            RSchedule."Principal Repayment":=LPrincipal;
            RSchedule."Loan Balance":=LBalance;
            RSchedule.INSERT;
            WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
            UNTIL LBalance < 1

            END;
            END;

            COMMIT;

      // LoansRec.RESET;
      // LoansRec.SETRANGE(LoansRec."Loan  No.",LoanNumber);
      // LoansRec.SETFILTER(LoansRec."Approved Amount",'>%1',0);
      // //LoansRec.SETFILTER(LoansRec.Posted,'=%1',TRUE);
      // IF LoansRec.FIND('-') THEN BEGIN
      //  IF ((LoansRec."Issued Date"<>0D) AND (LoansRec."Repayment Start Date"<>0D)) THEN BEGIN
      // LoansRec.TESTFIELD(LoansRec."Loan Disbursement Date");
      // LoansRec.TESTFIELD(LoansRec."Repayment Start Date");
      //
      // RSchedule.RESET;
      // RSchedule.SETRANGE(RSchedule."Loan No.",LoansRec."Loan  No.");
      // RSchedule.DELETEALL;
      // //mESSAGE('Repayment Start Date %1 Approved Amount %2',LoansRec."Repayment Start Date",LoansRec."Amount Disbursed");
      // //LoanAmount:=LoansRec."Approved Amount";
      // LoanAmount:=LoansRec."Amount Disbursed";
      // InterestRate:=LoansRec.Interest;
      // RepayPeriod:=LoansRec.Installments;
      // InitialInstal:=LoansRec.Installments+LoansRec."Grace Period - Principle (M)";
      // LBalance:=LoansRec."Approved Amount";
      // LBalance:=LoansRec."Amount Disbursed";
      // RunDate:=LoansRec."Repayment Start Date";
      // InstalNo:=0;
      //
      // //Repayment Frequency
      // IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
      // RunDate:=CALCDATE('-1D',RunDate)
      // ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
      // RunDate:=CALCDATE('-1W',RunDate)
      // ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
      // RunDate:=CALCDATE('-1M',RunDate)
      // ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
      // RunDate:=CALCDATE('-1Q',RunDate);
      // //Repayment Frequency
      //
      //
      // REPEAT
      // InstalNo:=InstalNo+1;
      // //Repayment Frequency
      // IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
      // RunDate:=CALCDATE('1D',RunDate)
      // ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
      // RunDate:=CALCDATE('1W',RunDate)
      // ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
      // RunDate:=CALCDATE('1M',RunDate)
      // ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
      // RunDate:=CALCDATE('1Q',RunDate);
      //
      // IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Amortised THEN BEGIN
      // LoansRec.TESTFIELD(LoansRec.Installments);
      // TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.0001,'>');
      // LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.0001,'>');
      // LPrincipal:=TotalMRepay-LInterest;
      // END;
      //
      // IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Straight Line" THEN BEGIN
      // LoansRec.TESTFIELD(LoansRec.Interest);
      // LoansRec.TESTFIELD(LoansRec.Installments);
      // LPrincipal:=LoanAmount/RepayPeriod;
      // LInterest:=(InterestRate/12/100)*LoanAmount/RepayPeriod;
      // END;
      //
      // IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Reducing Balance" THEN BEGIN
      // LoansRec.TESTFIELD(LoansRec.Interest);
      // LoansRec.TESTFIELD(LoansRec.Installments);
      // LPrincipal:=LoanAmount/RepayPeriod;
      // LInterest:=(InterestRate/12/100)*LBalance;
      // END;
      //
      // IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Constants THEN BEGIN
      // LoansRec.TESTFIELD(LoansRec.Repayment);
      // IF LBalance < LoansRec.Repayment THEN
      // LPrincipal:=LBalance
      // ELSE
      // LPrincipal:=LoansRec.Repayment;
      // LInterest:=LoansRec.Interest;
      // END;
      //
      // //Grace Period
      // IF GrPrinciple > 0 THEN BEGIN
      // LPrincipal:=0
      // END ELSE BEGIN
      // LBalance:=LBalance-LPrincipal;
      //
      // END;
      //
      // IF GrInterest > 0 THEN
      // LInterest:=0;
      //
      // GrPrinciple:=GrPrinciple-1;
      // GrInterest:=GrInterest-1;
      // EVALUATE(RepayCode,FORMAT(InstalNo));
      //
      //
      // RSchedule.INIT;
      // RSchedule."Repayment Code":=RepayCode;
      // RSchedule."Interest Rate":=InterestRate;
      // RSchedule."Loan No.":=LoansRec."Loan  No.";
      // RSchedule."Loan Amount":=LoanAmount;
      // RSchedule."Instalment No":=InstalNo;
      // RSchedule."Repayment Date":=CALCDATE('CM',RunDate);
      // RSchedule."Member No.":=LoansRec."Client Code";
      // RSchedule."Loan Category":=LoansRec."Loan Product Type";
      // RSchedule."Monthly Repayment":=LInterest + LPrincipal;
      // RSchedule."Monthly Interest":=LInterest;
      // RSchedule."Principal Repayment":=LPrincipal;
      // RSchedule."Loan Balance":=LBalance;
      // RSchedule.INSERT;
      // WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
      // UNTIL LBalance < 1
      //
      // END;
      // END;
      //
      // COMMIT;
    END;

    PROCEDURE FnGetPrincipalDueFiltered@1000000027(ObjLoans@1000000000 : Record 51516230;DateFilter@1000000002 : Text) : Decimal;
    VAR
      ObjLoanRegister@1000000001 : Record 51516230;
    BEGIN
      ObjLoans.SETFILTER("Date filter",DateFilter);
      ObjLoans.CALCFIELDS("Schedule Repayment","Outstanding Balance");
      EXIT(ObjLoans."Schedule Repayment");
    END;

    PROCEDURE FnGetLoanAmountinArrears@2(VarLoanNo@1000 : Code[20]) VarArrears : Decimal;
    BEGIN
      VarArrears:=0;
      VarRepaymentPeriod:=WORKDATE;

      ObjLoans.RESET;
      ObjLoans.SETRANGE(ObjLoans."Loan  No.",VarLoanNo);
      IF ObjLoans.FINDSET THEN BEGIN
        ObjLoans.CALCFIELDS(ObjLoans."Outstanding Balance",ObjLoans."Interest Due",ObjLoans."Oustanding Interest",ObjLoans."Penalty Charged");



        VarLoanNo:=ObjLoans."Loan  No.";

        //================Get Last Day of the previous month===================================
        IF ObjLoans."Repayment Frequency"=ObjLoans."Repayment Frequency"::Monthly THEN BEGIN
          IF VarRepaymentPeriod=CALCDATE('CM',VarRepaymentPeriod) THEN BEGIN
                VarLastMonth:=VarRepaymentPeriod;
              END ELSE BEGIN
                VarLastMonth:=CALCDATE('-1M',VarRepaymentPeriod);
              END;
            VarLastMonth:=CALCDATE('CM',VarLastMonth);
         END;
        VarDate:=1;
        VarMonth:=DATE2DMY(VarLastMonth,2);
        VarYear:=DATE2DMY(VarLastMonth,3);
        VarLastMonthBeginDate:=DMY2DATE(VarDate,VarMonth,VarYear);
        VarScheduleDateFilter:=FORMAT(VarLastMonthBeginDate)+'..'+FORMAT(VarLastMonth);
        //End ===========Get Last Day of the previous month==========================================


        //================Get Scheduled Balance=======================================================
          ObjLSchedule.RESET;
          ObjLSchedule.SETRANGE(ObjLSchedule."Loan No.",VarLoanNo);
          ObjLSchedule.SETRANGE(ObjLSchedule."Close Schedule",FALSE);
          ObjLSchedule.SETFILTER(ObjLSchedule."Repayment Date",VarScheduleDateFilter);
            IF ObjLSchedule.FINDFIRST THEN BEGIN
              VarScheduledLoanBal:=ObjLSchedule."Loan Balance";
              VarScheduleRepayDate:=ObjLSchedule."Repayment Date";
            END;

          ObjLSchedule.RESET;
          ObjLSchedule.SETCURRENTKEY(ObjLSchedule."Repayment Date");
          ObjLSchedule.SETRANGE(ObjLSchedule."Loan No.",VarLoanNo);
          ObjLSchedule.SETRANGE(ObjLSchedule."Close Schedule",FALSE);
              IF ObjLSchedule.FINDLAST THEN BEGIN
                IF ObjLSchedule."Repayment Date"<TODAY THEN BEGIN
                  VarScheduledLoanBal:=ObjLSchedule."Loan Balance";
                  VarScheduleRepayDate:=ObjLSchedule."Repayment Date";
              END;
              END;
        //================End Get Scheduled Balance====================================================

        //================Get Loan Bal as per the date filter===========================================
        IF VarScheduleRepayDate<>0D THEN BEGIN
          VarDateFilter:='..'+FORMAT(VarScheduleRepayDate);
          ObjLoans.SETFILTER(ObjLoans."Date filter",VarDateFilter);
              ObjLoans.CALCFIELDS(ObjLoans."Outstanding Balance");
              VarLBal:=ObjLoans."Outstanding Balance";
        //===============End Get Loan Bal as per the date filter=========================================

         VarLBal:=ObjLoans."Outstanding Balance";

          //============Amount in Arrears================================================================
          VarArrears:=VarScheduledLoanBal-VarLBal;
          IF (VarArrears>0) OR (VarArrears=0) THEN BEGIN
          VarArrears:=0
          END ELSE
          VarArrears:=VarArrears;
          END;
      END;
      EXIT(VarArrears*-1);
    END;

    PROCEDURE FnGetLoanBalance@7(LoanNum@1000000000 : Code[10];RunDate@1000000001 : Date) LoanBal : Decimal;
    VAR
      ObjLoanReg@1000000002 : Record 51516230;
    BEGIN
      LoanBal:=0;

      ObjLoanReg.RESET;
      ObjLoanReg.SETRANGE(ObjLoanReg."Loan  No.",LoanNum);
      ObjLoanReg.SETFILTER(ObjLoanReg."Date filter",'..'+FORMAT(RunDate));
      IF ObjLoanReg.FINDSET THEN
        BEGIN
          ObjLoanReg.CALCFIELDS(ObjLoanReg."Outstanding Balance");
          LoanBal:=ObjLoanReg."Outstanding Balance";
          END;

      EXIT(LoanBal);
    END;

    PROCEDURE FnCalculateLoanArrears@1000000031(ScheduleBalance@1000000000 : Decimal;LoanBalance@1000000001 : Decimal;RunDate@1000000002 : Date;ExpCompDate@1000000003 : Date) Arrears : Decimal;
    BEGIN
      Arrears:=0;

      IF ExpCompDate<RunDate THEN
        BEGIN
          Arrears:=LoanBalance;
          END ELSE
          BEGIN
            Arrears:=ScheduleBalance-LoanBalance;

            IF Arrears>0 THEN
              Arrears:=0
            ELSE
              Arrears:=Arrears;
            END;

      EXIT(Arrears);
    END;

    PROCEDURE FnCalculatePeriodInArrears@1000000032(Arrears@1000000000 : Decimal;PRepay@1000000001 : Decimal;RunDate@1000000002 : Date;ExpCompletionDate@1000000003 : Date) PeriodArrears : Decimal;
    BEGIN
      PeriodArrears:=0;

      IF Arrears<>0 THEN
        BEGIN
          IF ExpCompletionDate<RunDate THEN
            BEGIN
              PeriodArrears:=ROUND((RunDate-ExpCompletionDate)/30,1,'=');
              END ELSE
              PeriodArrears:=ROUND(Arrears/PRepay,1,'=')*-1;
          END;

      EXIT(PeriodArrears);
    END;

    PROCEDURE FnValidateSameLoanProduct@1120054001(Loan@1120054000 : Record 51516230);
    VAR
      LoanOffset@1120054001 : Record 51516235;
      OutstandingLoans@1120054002 : Record 51516230;
      ErrLoan@1120054003 : TextConst 'ENU=Member has an existing Loan %1, that has not been offset! Please offset the loan to proceed!';
    BEGIN
      {WITH Loan DO BEGIN

        OutstandingLoans.RESET;
        OutstandingLoans.SETRANGE("Client Code","Client Code");
        OutstandingLoans.SETRANGE("Loan Product Type","Loan Product Type");
        OutstandingLoans.SETFILTER("Outstanding Balance",'>0');
        IF OutstandingLoans.FINDFIRST THEN BEGIN

              LoanOffset.RESET;
              LoanOffset.SETRANGE(LoanOffset."Loan Top Up",OutstandingLoans."Loan  No.");
              IF NOT LoanOffset.FINDFIRST THEN BEGIN
                 ERROR(ErrLoan,OutstandingLoans."Loan Product Type"+' '+OutstandingLoans."Loan  No.");
              END;
          END;




      END;
      }
    END;

    BEGIN
    END.
  }
}

