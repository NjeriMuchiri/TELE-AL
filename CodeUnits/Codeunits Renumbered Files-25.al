OBJECT CodeUnit 20389 SURESTEP Factory
{
  OBJECT-PROPERTIES
  {
    Date=05/03/23;
    Time=[ 5:27:00 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=VAR
            DoubleLoan@1120054000 : Record 51516230;
            Transactions@1120054002 : Record 51516299;
            Ctr@1120054001 : Record 51516299;
            MembershipApplications@1120054003 : Record 51516220;
          BEGIN
            // //MESSAGE(FORMAT(FnGetFosaAccountBalance('0804-019444-00')));
            // //MESSAGE(FORMAT(FnGetCashierTransactionBudding('CASHWD-S',1000)));
            // //MESSAGE(FORMAT(FnGetMinimumAllowedBalance('CURRENT')));
            // //FnSendSMS('Cashwi','my message','Fosaaccount');
            // //MESSAGE(FnGetMpesaAccount());
            // //FnUpdateMonthlyContributions();
            //  //FnReturnRetirementDate('006987');
            //  ObjLoans.RESET;
            //  ObjLoans.SETRANGE("Loan  No.",'BLN_00044');
            //  ObjLoans.SETFILTER("Date filter",'..'+FORMAT(111118D));
            //  IF ObjLoans.FIND('-') THEN BEGIN
            //    ObjLoans.CALCFIELDS("Scheduled Principal to Date");
            //  MESSAGE('%1 %2',FnGetPrincipalDueFiltered(ObjLoans,'..'+FORMAT(TODAY)), ObjLoans."Scheduled Principal to Date");
            //  END
            //
            //  {
            //  MESSAGE('xxxxxx %1',FnCalculatePaye(50020.85));
            //  MESSAGE('40,000 %1',FnCalculatePaye(40000));
            //  MESSAGE('100,000 %1',FnCalculatePaye(100000));
            //  MESSAGE('150,000 %1',FnCalculatePaye(150000));
            //  MESSAGE('500,000 %1',FnCalculatePaye(500000));
            //  }

            {DoubleLoan.RESET;
            DoubleLoan.SETRANGE("Loan Status",DoubleLoan."Loan Status"::Application);
            //DoubleLoan.SETFILTER("Client Code",'%1','');
            //DoubleLoan.SETFILTER(DoubleLoan."Application Date",'<=%1',310820D);
            DoubleLoan.SETRANGE(DoubleLoan.Posted,FALSE);
            IF DoubleLoan.FINDSET THEN
              REPEAT
                  IF (DoubleLoan."Application Date"=0D) OR (DoubleLoan."Application Date"<=310820D) THEN BEGIN
                   //IF DoubleLoan."Client Code"='' THEN BEGIN
                     DoubleLoan."Loan Status":=DoubleLoan."Loan Status"::Rejected;
                     DoubleLoan.MODIFY;
                   END;
                UNTIL DoubleLoan.NEXT =0;
            }
            //MESSAGE(FORMAT(FnGetAccountAvailableBalance('0502-001-00018')));

            {MembershipApplications.GET('MAPPP1024');
            MembershipApplications.Status:=MembershipApplications.Status::Open;
            MembershipApplications.MODIFY;}

            {DoubleLoan.GET('FL003245');
            MESSAGE(FORMAT(DoubleLoan.InterestBalanceAsAt(TODAY)));
            }
          END;

  }
  CODE
  {
    VAR
      ObjTransCharges@1000000000 : Record 51516442;
      UserSetup@1000000001 : Record 2000000120;
      ObjVendor@1000000002 : Record 23;
      ObjProducts@1000000003 : Record 51516436;
      ObjMemberLedgerEntry@1000000004 : Record 51516224;
      ObjLoans@1000000005 : Record 51516230;
      ObjBanks@1000000006 : Record 270;
      ObjLoanProductSetup@1000000007 : Record 51516240;
      ObjProductCharges@1000000008 : Record 51516242;
      ObjMembers@1000000009 : Record 51516223;
      ObjMembers2@1000000010 : Record 51516223;
      ObjGenSetUp@1000000011 : Record 51516257;
      ObjCompInfo@1000000012 : Record 79;
      BAND1@1000000017 : Decimal;
      BAND2@1000000016 : Decimal;
      BAND3@1000000015 : Decimal;
      BAND4@1000000014 : Decimal;
      BAND5@1000000013 : Decimal;
      Lstart@1120054000 : Date;
      ProgressWindow@1120054001 : Dialog;

    PROCEDURE FnGetPreviousMonthLastDate@1000000028(LoanNum@1000000000 : Code[10];RunDate@1000000002 : Date) LastMonthDate : Date;
    VAR
      ObjLoansReg@1000000001 : Record 51516230;
    BEGIN
      IF ObjLoansReg.GET(LoanNum) THEN
        BEGIN
          IF (ObjLoansReg."Repayment Frequency"=ObjLoansReg."Repayment Frequency"::Monthly) THEN
            BEGIN
              IF (RunDate=CALCDATE('CM',RunDate)) THEN
                BEGIN
                  LastMonthDate:=RunDate;
                  END ELSE
                  BEGIN
                    LastMonthDate:=CALCDATE('-1M',RunDate);
                    END;
                    LastMonthDate:=CALCDATE('CM',LastMonthDate);
              END;
          END;

      EXIT(LastMonthDate);
    END;

    PROCEDURE FnGetScheduledExpectedBalance@1000000029(LoanNum@1000000000 : Code[10];RunDate@1000000001 : Date) ScheduleBal : Decimal;
    VAR
      ObjRepaySch@1000000002 : Record 51516234;
    BEGIN
      ScheduleBal:=0;

      ObjRepaySch.RESET;
      ObjRepaySch.SETRANGE(ObjRepaySch."Loan No.",LoanNum);
      ObjRepaySch.SETRANGE(ObjRepaySch."Repayment Date",RunDate);
      IF ObjRepaySch.FIND('-') THEN
        BEGIN
          ScheduleBal:=ObjRepaySch."Loan Balance";
          //ERROR('%1',ScheduleBal);
          END ELSE
            ScheduleBal:=0;

      EXIT(ScheduleBal);
    END;

    PROCEDURE FnGetLoanBalance@1000000030(LoanNum@1000000000 : Code[10];RunDate@1000000001 : Date) LoanBal : Decimal;
    VAR
      ObjLoanReg@1000000002 : Record 51516230;
    BEGIN
      LoanBal:=0;

      ObjLoanReg.RESET;
      ObjLoanReg.SETRANGE(ObjLoanReg."Loan  No.",LoanNum);
      ObjLoanReg.SETFILTER(ObjLoanReg."Date filter",'..'+FORMAT(RunDate));
      IF ObjLoanReg.FIND('-') THEN
        BEGIN
          ObjLoanReg.CALCFIELDS(ObjLoanReg."Outstanding Balance");
          LoanBal:=ObjLoanReg."Outstanding Balance";
          END;

      EXIT(LoanBal);
    END;

    PROCEDURE FnCalculateLoanArrears@1000000031(LoanBalance@1000000001 : Decimal;RunDate@1000000002 : Date;ExpCompDate@1000000003 : Date;ScheduleBalance@1000000006 : Decimal;ProductType@1000000005 : Code[10]) Arrears : Decimal;
    VAR
      ObjSchedule@1000000000 : Record 51516234;
      ObjLoansReg@1000000004 : Record 51516230;
    BEGIN
      Arrears:=0;

      IF ProductType='L15' THEN
        Arrears:=LoanBalance;

      IF ExpCompDate<RunDate THEN
        BEGIN
          Arrears:=LoanBalance;
          END ELSE
          BEGIN
            IF ScheduleBalance>0 THEN BEGIN
              Arrears:=LoanBalance-ScheduleBalance;
            END ELSE
              Arrears:=0;
            IF Arrears<0 THEN
              Arrears:=0
            ELSE
              Arrears:=Arrears;
            END;
            IF Arrears<0 THEN
              Arrears:=0;
      EXIT(Arrears);
    END;

    PROCEDURE FnCalculatePeriodInArrears@1000000032(Arrears@1000000000 : Decimal;PRepay@1000000001 : Decimal;RunDate@1000000002 : Date;ExpCompletionDate@1000000003 : Date;ProductType@1000000004 : Code[10];IssueDate@1000000006 : Date) PeriodArrears : Decimal;
    BEGIN
      PeriodArrears:=0;

      IF (Arrears>0) AND (PRepay>0)THEN
        BEGIN
          IF ExpCompletionDate<RunDate THEN
            BEGIN
              PeriodArrears:=ROUND((RunDate-ExpCompletionDate)/30,1,'=');
              END ELSE
              PeriodArrears:=ROUND(Arrears/PRepay,1,'=');
          END;
        IF PeriodArrears>0 THEN

      IF ProductType='L15' THEN
        BEGIN
          PeriodArrears:=ROUND((RunDate-IssueDate)/30,1,'=');
        END;
      EXIT(PeriodArrears);
    END;

    PROCEDURE FnClassifyLoans@1000000033(LoanNum@1000000002 : Code[10];PeriodArrears@1000000000 : Decimal;AmountArrears@1000000001 : Decimal) Class : Integer;
    VAR
      ObjLoansReg@1000000003 : Record 51516230;
    BEGIN
      IF ObjLoansReg.GET(LoanNum) THEN
        BEGIN
          IF (AmountArrears=0) OR (PeriodArrears<2) THEN
            BEGIN
              ObjLoansReg."Loans Category":=ObjLoansReg."Loans Category"::Perfoming;
              ObjLoansReg."Loans Category-SASRA":=ObjLoansReg."Loans Category-SASRA"::Perfoming;
              ObjLoansReg.Arears:=AmountArrears;
              ObjLoansReg."Period In Arears":=PeriodArrears;
              Class:=1;
              ObjLoansReg.MODIFY;
             END ELSE
            IF (PeriodArrears >=2) AND (PeriodArrears <3) THEN
            BEGIN
              ObjLoansReg."Loans Category":=ObjLoansReg."Loans Category"::Watch;
              ObjLoansReg."Loans Category-SASRA":=ObjLoansReg."Loans Category-SASRA"::Watch;
              ObjLoansReg.Arears:=AmountArrears;
              ObjLoansReg."Period In Arears":=PeriodArrears;
              Class:=2;
              ObjLoansReg.MODIFY;
            END ELSE
            IF (PeriodArrears >=3) AND (PeriodArrears <=6) THEN
              BEGIN
                ObjLoansReg."Loans Category":=ObjLoansReg."Loans Category"::Substandard;
                ObjLoansReg."Loans Category-SASRA":=ObjLoansReg."Loans Category-SASRA"::Substandard;
                ObjLoansReg.Arears:=AmountArrears;
                ObjLoansReg."Period In Arears":=PeriodArrears;
                Class:=3;
                ObjLoansReg.MODIFY;
            END ELSE
            IF (PeriodArrears >6) AND (PeriodArrears <=12) THEN
              BEGIN
                ObjLoansReg."Loans Category":=ObjLoansReg."Loans Category"::Doubtful;
                ObjLoansReg."Loans Category-SASRA":=ObjLoansReg."Loans Category-SASRA"::Doubtful;
                ObjLoansReg.Arears:=AmountArrears;
                ObjLoansReg."Period In Arears":=PeriodArrears;
                Class:=4;
                ObjLoansReg.MODIFY;
            END ELSE
            IF (PeriodArrears >12) THEN
              BEGIN
                ObjLoansReg."Loans Category":=ObjLoansReg."Loans Category"::Loss;
                ObjLoansReg."Loans Category-SASRA":=ObjLoansReg."Loans Category-SASRA"::Loss;
                ObjLoansReg.Arears:=AmountArrears;
                ObjLoansReg."Period In Arears":=PeriodArrears;
                Class:=5;
                ObjLoansReg.MODIFY;
                END;

            ObjLoansReg.MODIFY;
          END;

      EXIT(Class);
    END;

    PROCEDURE FnLoanProvisioningSummary@1000000034(MemberNo@1000000000 : Code[10];Type@1000000001 : Code[15];Image@1000000003 : Byte);
    BEGIN
    END;

    PROCEDURE FnGetSecurity@1000000036("Loan No"@1000000000 : Code[10]) Name : Text;
    VAR
      ObjLoanCollateral@1000000001 : Record 51516233;
    BEGIN
      ObjLoanCollateral.RESET;
      ObjLoanCollateral.SETRANGE(ObjLoanCollateral."Loan No","Loan No");
      IF ObjLoanCollateral.FIND('-') THEN
        BEGIN
          Name:=ObjLoanCollateral."Security Details";
        END;
      EXIT(Name);
    END;

    PROCEDURE FnGetGuarantee@1000000038("Loan No"@1000000001 : Code[10]) Shares : Boolean;
    VAR
      ObjLoanguarantor@1000000000 : Record 51516231;
    BEGIN
      ObjLoanguarantor.RESET;
      ObjLoanguarantor.SETRANGE(ObjLoanguarantor."Loan No","Loan No");
      IF ObjLoanguarantor.FIND('-') THEN
        BEGIN
          Shares:=TRUE;
        END ELSE
          Shares:=FALSE;
      EXIT(Shares);
    END;

    PROCEDURE FnSendMessage@1000000000(LoanNo@1000000000 : Code[10];PhoneNo@1000000002 : Text[50];ClientName@1000000003 : Text[50];LoanProduct@1000000004 : Text[50];AmountInareas@1000000009 : Decimal;PeriodInAreas@1000000010 : Decimal);
    VAR
      SMSMessage@1000000001 : Record 51516329;
      objGuaranteeDetails@1000000005 : Record 51516231;
      FisrtNotice@1000000008 : Text[250];
      SecondNotice@1000000007 : Text;
      ThirdNotice@1000000006 : Text;
      iEntryNo@1000000011 : Integer;
      ObjMembersRegister@1000000012 : Record 51516223;
    BEGIN
      FisrtNotice:='Please Note that you have not paid your '+LoanProduct+' loan for One month. Telepost Sacco';
      SecondNotice:='please note that the '+LoanProduct+' that you guaranteed '+ClientName+' has not been paid for two months. Telepost Sacco';
      ThirdNotice:='Please note that the defaulted '+LoanProduct+' in areas of Kshs '+FORMAT(AmountInareas)+' will be deducted from your Account. Telepost Sacco';

      IF PeriodInAreas=1 THEN
        BEGIN
              SMSMessage.RESET;
              IF SMSMessage.FIND('+') THEN BEGIN
              iEntryNo:=SMSMessage."Entry No";
              iEntryNo:=iEntryNo+1;
               END ELSE BEGIN
              iEntryNo:=1;
              END;
              SMSMessage.RESET;
              SMSMessage.INIT;
              SMSMessage."Entry No":=iEntryNo;
              SMSMessage."Account No":=ObjLoans."BOSA No";
              SMSMessage."Date Entered":=TODAY;
              SMSMessage."Time Entered":=TIME;
              SMSMessage.Source:='LOAN GUARANTORS';
              SMSMessage."Entered By":=USERID;
              SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
              SMSMessage."SMS Message":=FisrtNotice;
              SMSMessage."Telephone No":=PhoneNo;
            IF SMSMessage."Telephone No"<>'' THEN
            SMSMessage.INSERT;
        END;

      IF PeriodInAreas=2 THEN
        BEGIN
          objGuaranteeDetails.RESET;
          objGuaranteeDetails.SETRANGE(objGuaranteeDetails."Loan No",LoanNo);
          IF objGuaranteeDetails.FINDSET THEN
            BEGIN
              ObjMembersRegister.RESET;
              ObjMembersRegister.SETRANGE(ObjMembersRegister."No.",objGuaranteeDetails."Member No");
              IF ObjMembersRegister.FIND('-') THEN
                BEGIN
                    SMSMessage.RESET;
                    IF SMSMessage.FIND('+') THEN BEGIN
                    iEntryNo:=SMSMessage."Entry No";
                    iEntryNo:=iEntryNo+1;
                     END ELSE BEGIN
                    iEntryNo:=1;
                    END;
                    SMSMessage.RESET;
                    SMSMessage.INIT;
                    SMSMessage."Entry No":=iEntryNo;
                    SMSMessage."Account No":=ObjLoans."BOSA No";
                    SMSMessage."Date Entered":=TODAY;
                    SMSMessage."Time Entered":=TIME;
                    SMSMessage.Source:='LOAN GUARANTORS';
                    SMSMessage."Entered By":=USERID;
                    SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                    SMSMessage."SMS Message":=SecondNotice;
                    SMSMessage."Telephone No":=ObjMembersRegister."Phone No.";
                  IF SMSMessage."Telephone No"<>'' THEN
                  SMSMessage.INSERT;
                 END;
            END;
        END;

      IF PeriodInAreas>=3 THEN
        BEGIN
          objGuaranteeDetails.RESET;
          objGuaranteeDetails.SETRANGE(objGuaranteeDetails."Loan No",LoanNo);
          IF objGuaranteeDetails.FINDSET THEN
            BEGIN
              ObjMembersRegister.RESET;
              ObjMembersRegister.SETRANGE(ObjMembersRegister."No.",objGuaranteeDetails."Member No");
              IF ObjMembersRegister.FIND('-') THEN
                BEGIN
                    SMSMessage.RESET;
                    IF SMSMessage.FIND('+') THEN BEGIN
                    iEntryNo:=SMSMessage."Entry No";
                    iEntryNo:=iEntryNo+1;
                     END ELSE BEGIN
                    iEntryNo:=1;
                    END;
                    SMSMessage.RESET;
                    SMSMessage.INIT;
                    SMSMessage."Entry No":=iEntryNo;
                    SMSMessage."Account No":=ObjLoans."BOSA No";
                    SMSMessage."Date Entered":=TODAY;
                    SMSMessage."Time Entered":=TIME;
                    SMSMessage.Source:='LOAN GUARANTORS';
                    SMSMessage."Entered By":=USERID;
                    SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                    SMSMessage."SMS Message":=ThirdNotice;
                    SMSMessage."Telephone No":=ObjMembersRegister."Phone No.";
                  IF SMSMessage."Telephone No"<>'' THEN
                  SMSMessage.INSERT;
                 END;
            END;
        END;
    END;

    PROCEDURE FnCreateGnlJournalLine@1000000001(TemplateName@1000000000 : Text;BatchName@1000000001 : Text;DocumentNo@1000000002 : Code[30];LineNo@1000000003 : Integer;TransactionType@1000000009 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';AccountType@1000000004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';AccountNo@1000000006 : Code[50];TransactionDate@1000000007 : Date;TransactionAmount@1000000010 : Decimal;DimensionActivity@1000000012 : Code[40];TransactionDescription@1000000008 : Text;LoanNumber@1000000013 : Code[50]);
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
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DimensionActivity;
      GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN BEGIN
      GenJournalLine.INSERT;

      END;
    END;

    PROCEDURE FnRunGetAccountBookBalance@1120054000(VarAccountNo@1120054000 : Code[30];VarDateFilter@1120054001 : Text) AvailableBal : Decimal;
    VAR
      ObjVendors@1120054002 : Record 23;
      ObjAccTypes@1120054003 : Record 51516295;
    BEGIN
      ObjVendors.RESET;
      ObjVendors.SETRANGE(ObjVendors."No.",VarAccountNo);
      ObjVendors.SETFILTER(ObjVendors."Date Filter",VarDateFilter);
      IF ObjVendors.FINDSET THEN BEGIN
      ObjVendors.CALCFIELDS(ObjVendors.Balance,ObjVendors."Uncleared Cheques",ObjVendors."EFT Transactions",ObjVendors."ATM Transactions");
      AvailableBal:=(ObjVendors.Balance-ObjVendors."ATM Transactions"
      -ObjVendors."EFT Transactions");

      END;
      EXIT(AvailableBal);
    END;

    PROCEDURE FnCreateGnlJournalLineCloud@1120054001(TemplateName@1000000000 : Text;BatchName@1000000001 : Text;DocumentNo@1000000002 : Code[30];LineNo@1000000003 : Integer;TransactionType@1000000009 : ' ,Registration Fee,Share Capital,Interest Paid,Loan Repayment,Deposit Contribution,Insurance Contribution,Benevolent Fund,Loan,Unallocated Funds,Dividend,FOSA Account';AccountType@1000000004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';AccountNo@1000000006 : Code[50];TransactionDate@1000000007 : Date;TransactionAmount@1000000010 : Decimal;DimensionActivity@1000000012 : Code[40];ExternalDocumentNo@1000000011 : Code[50];TransactionDescription@1000000008 : Text;LoanNumber@1000000013 : Code[50]);
    VAR
      GenJournalLine@1000000005 : Record 81;
    BEGIN
      GenJournalLine.RESET;
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
      GenJournalLine.Amount:=TransactionAmount;
      GenJournalLine."External Document No.":=ExternalDocumentNo;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DimensionActivity;
      GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      COMMIT;

      //MESSAGE('%1..',LineNo)
    END;

    PROCEDURE FnGenerateLoanSchedule@1120054002(LoanNumber@1120054011 : Code[60]);
    VAR
      RSchedule@1120054001 : Record 51516234;
      LInterest@1120054009 : Decimal;
      LPrincipal@1120054008 : Decimal;
      RepayCode@1120054007 : Code[40];
      GrPrinciple@1120054006 : Integer;
      GrInterest@1120054005 : Integer;
      QPrinciple@1120054004 : Decimal;
      QCounter@1120054003 : Integer;
      InPeriod@1120054002 : DateFormula;
      LoansR@1120054010 : Record 51516230;
      Loans@1120054000 : Record 51516230;
      InitialInstal@1120054013 : Integer;
      InitialGraceInt@1120054012 : Integer;
      LoanAmount@1120054016 : Decimal;
      InterestRate@1120054015 : Decimal;
      RepayPeriod@1120054014 : Integer;
      LBalance@1120054026 : Decimal;
      RunDate@1120054025 : Date;
      InstalNo@1120054024 : Decimal;
      RepayInterval@1120054023 : DateFormula;
      TotalMRepay@1120054022 : Decimal;
      LNBalance@1120054017 : Decimal;
      WhichDay@1120054018 : Integer;
      BalanceX@1120054019 : Decimal;
    BEGIN
      Loans.RESET;
      Loans.SETRANGE(Loans."Loan  No.",LoanNumber);
      IF Loans.FINDFIRST THEN BEGIN
      IF Loans."Repayment Frequency"=Loans."Repayment Frequency"::Daily THEN
      EVALUATE(InPeriod,'1D')
      ELSE IF Loans."Repayment Frequency"=Loans."Repayment Frequency"::Weekly THEN
      EVALUATE(InPeriod,'1W')
      ELSE IF Loans."Repayment Frequency"=Loans."Repayment Frequency"::Monthly THEN
      EVALUATE(InPeriod,'1M')
      ELSE IF Loans."Repayment Frequency"=Loans."Repayment Frequency"::Quaterly THEN
      EVALUATE(InPeriod,'1Q');


      QCounter:=0;
      QCounter:=3;
      //EVALUATE(InPeriod,'1D');
      GrPrinciple:=Loans."Grace Period - Principle (M)";
      GrInterest:=Loans."Grace Period - Interest (M)";
      InitialGraceInt:=Loans."Grace Period - Interest (M)";
      END;

      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Loan  No.",LoanNumber);
      IF LoansR.FIND('-') THEN BEGIN

      IF LoansR."Loan Disbursement Date"<>0D THEN

      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",LoanNumber);
      RSchedule.DELETEALL;

      LoanAmount:=LoansR."Approved Amount";
      IF LoansR.Interest<>0 THEN BEGIN
      InterestRate:=LoansR.Interest;
      END ELSE BEGIN
      IF ObjLoanProductSetup.GET(LoansR."Loan Product Type") THEN
      InterestRate:=ObjLoanProductSetup."Interest rate";
      END;
      RepayPeriod:=LoansR.Installments;
      InitialInstal:=LoansR.Installments+LoansR."Grace Period - Principle (M)";
      LBalance:=LoansR."Approved Amount";
      LNBalance:=LoansR."Outstanding Balance";
      IF LoansR."Repayment Start Date"=0D THEN BEGIN
      //MESSAGE('Loan%1',LoansR."Loan  No.");
      FnGetStartDate(LoansR."Issued Date");
      RunDate:=Lstart;
      END ELSE BEGIN;
      RunDate:=LoansR."Repayment Start Date";
      END;

      InstalNo:=0;
      EVALUATE(RepayInterval,'1W');

      //Repayment Frequency
      IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('-1D',RunDate)
      ELSE IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('-1W',RunDate)
      ELSE IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('-1M',RunDate)
      ELSE IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('-1Q',RunDate);
      //Repayment Frequency


      REPEAT
      InstalNo:=InstalNo+1;


      //*************Repayment Frequency***********************//
      IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('1D',RunDate)
      ELSE IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('1W',RunDate)
      ELSE IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('1M',RunDate)
      ELSE IF LoansR."Repayment Frequency"=LoansR."Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('1Q',RunDate);






      //*******************If Amortised****************************//
      IF LoansR."Repayment Method"=LoansR."Repayment Method"::Amortised THEN BEGIN
      //MESSAGE('LoanNo%1rate%2Repayperiod%3LoanAmount%4',LoansR."Loan  No.",InterestRate,RepayPeriod,LoanAmount);
      TotalMRepay:=(InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount;
      LInterest:=ROUND(LBalance / 100 / 12 * InterestRate);

      LPrincipal:=TotalMRepay-LInterest;
      END;



      IF LoansR."Repayment Method"=LoansR."Repayment Method"::"Straight Line" THEN BEGIN
      LPrincipal:=ROUND(LoanAmount/RepayPeriod,1,'>');
      IF (LoansR."Loan Product Type" = 'INST') OR (LoansR."Loan Product Type" = 'MAZAO') THEN BEGIN
      LInterest:=0;
      END ELSE BEGIN
      LInterest:=ROUND((InterestRate/100)*LoanAmount,1,'>');
      END;

      LoansR.Repayment:=LPrincipal+LInterest;
      LoansR."Loan Principle Repayment":=LPrincipal;
      LoansR."Loan Interest Repayment":=LInterest;
      END;


      IF LoansR."Repayment Method"=LoansR."Repayment Method"::"Reducing Balance" THEN BEGIN
      LPrincipal:=ROUND(LoanAmount/RepayPeriod,1,'>');
      LInterest:=ROUND((InterestRate/12/100)*LBalance,1,'>');
      END;

      IF LoansR."Repayment Method"=LoansR."Repayment Method"::Constants THEN BEGIN
      IF LBalance < LoansR.Repayment THEN
      LPrincipal:=LBalance
      ELSE
      LPrincipal:=LoansR.Repayment;
      LInterest:=LoansR.Interest;
      END;


      //Grace Period
      IF GrPrinciple > 0 THEN BEGIN
      LPrincipal:=0
      END ELSE BEGIN
      IF LoansR."Instalment Period" <> InPeriod THEN
      LBalance:=LBalance-LPrincipal;

      END;

      IF GrInterest > 0 THEN
      LInterest:=0;

      GrPrinciple:=GrPrinciple-1;
      GrInterest:=GrInterest-1;
      LBalance:=LBalance-LPrincipal;
      // MESSAGE('Repaymentnew%1Loan%2',RunDate,LoanNumber);
      //  EXIT;
      //Grace Period
      RSchedule.INIT;
      RSchedule."Repayment Code":=RepayCode;
      RSchedule."Loan No.":=LoanNumber;
      RSchedule."Loan Amount":=LoanAmount;
      RSchedule."Instalment No":=InstalNo;
      RSchedule."Loan Balance":=LBalance;
      RSchedule."Repayment Date":=RunDate;
      RSchedule."Member No.":=LoansR."Client Code";
      RSchedule."Loan Category":=LoansR."Loan Product Type";
      RSchedule."Monthly Repayment":=LInterest + LPrincipal;
      RSchedule."Monthly Interest":=LInterest;
      RSchedule."Principal Repayment":=LPrincipal;
      RSchedule.INSERT;
      WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
      UNTIL LBalance < 1;
      END;

      COMMIT;
    END;

    LOCAL PROCEDURE FnGetStartDate@1120054003(DisbursementDate@1120054006 : Date);
    VAR
      LoansT@1120054005 : Record 51516230;
      currYear@1120054004 : Integer;
      StartDate@1120054003 : Date;
      EndDate@1120054002 : Date;
      Month@1120054001 : Integer;
      DAY@1120054000 : Integer;
    BEGIN
      currYear := DATE2DMY(DisbursementDate,3);
      StartDate := 0D;
      EndDate := 0D;
      Month:=DATE2DMY(DisbursementDate,2);
      DAY:=DATE2DMY(DisbursementDate,1);
      StartDate := DMY2DATE(1, Month, currYear); // StartDate will be the date of the first day of the month
      IF Month=12 THEN BEGIN
      Month:=0;
      currYear:=currYear+1;
      END;
      EndDate := DMY2DATE(1, Month+1, currYear)-1; // EndDate will be the last day of the month

      IF DAY <=15 THEN BEGIN
      Lstart:=EndDate;

      END ELSE BEGIN
      Lstart:=CALCDATE('1M',EndDate);

      END;
    END;

    PROCEDURE FnGetAccountAvailableBalance@1102760000(AccNo@1120054000 : Code[30]) AvailableBalance : Decimal;
    VAR
      FosaAcc@1120054001 : Record 23;
      AccountTypes@1120054002 : Record 51516295;
      MinAccBal@1120054003 : Decimal;
    BEGIN
      AvailableBalance:=0;MinAccBal:=0;
      IF NOT FosaAcc.GET(AccNo) THEN EXIT;

      WITH FosaAcc DO BEGIN
           CALCFIELDS("Balance (LCY)","Uncleared Cheques","ATM Transactions","Authorised Over Draft","EFT Transactions","Mpesa Withdrawals","Coop Transaction");
           AccountTypes.RESET;
           AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
           IF AccountTypes.FIND('-') THEN
              MinAccBal:=AccountTypes."Minimum Balance";
           AvailableBalance:=("Balance (LCY)" + "Authorised Over Draft") - (MinAccBal+"Uncleared Cheques"+"ATM Transactions"+"EFT Transactions");
        END;
    END;

    PROCEDURE FnSplitThisSpringAndReturnValueAtPosition@1120054022(InputStr@1120054000 : Text;ReturnValue@1120054001 : Integer) : Text;
    VAR
      ValuesArray@1120054003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
      StringToSplit@1120054005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      Separator@1120054002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
    BEGIN
      StringToSplit := InputStr;
      Separator := ' ';
      ValuesArray := StringToSplit.Split(Separator.ToCharArray());
      IF ValuesArray.Length < (ReturnValue+1) THEN
         EXIT('');

      EXIT(ValuesArray.GetValue(ReturnValue));
    END;

    PROCEDURE FnSendMessageCD@1120054004(ClientCode@1120054003 : Code[40];Body@1120054001 : Text[250]);
    VAR
      SMSMessage@1000000001 : Record 51516329;
      objGuaranteeDetails@1000000005 : Record 51516231;
      FisrtNotice@1000000008 : Text[250];
      SecondNotice@1000000007 : Text;
      ThirdNotice@1000000006 : Text;
      iEntryNo@1000000011 : Integer;
      ObjMembersRegister@1000000012 : Record 51516223;
      Members@1120054002 : Record 51516223;
    BEGIN

      Members.RESET;Members.SETRANGE(Members."No.",ClientCode);
      IF Members.FINDFIRST THEN BEGIN
              SMSMessage.RESET;
              IF SMSMessage.FIND('+') THEN BEGIN
              iEntryNo:=SMSMessage."Entry No";
              iEntryNo:=iEntryNo+1;
               END ELSE BEGIN
              iEntryNo:=1;
              END;
              SMSMessage.RESET;
              SMSMessage.INIT;
              SMSMessage."Entry No":=iEntryNo;
              SMSMessage."Account No":=Members."No.";
              SMSMessage."Date Entered":=TODAY;
              SMSMessage."Time Entered":=TIME;
              SMSMessage.Source:='';
              SMSMessage."Entered By":=USERID;
              SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
              SMSMessage."SMS Message":=Body;
              SMSMessage."Telephone No":=Members."Mobile Phone No";
            IF SMSMessage."Telephone No"<>'' THEN
            SMSMessage.INSERT;
        END;
    END;

    PROCEDURE FnSendMemberBirthdayMessage@1120054005();
    VAR
      Members@1120054000 : Record 51516223;
      BirthMonth@1120054001 : Integer;
      BirthDate@1120054002 : Integer;
      CurrMonth@1120054003 : Integer;
      CurrDate@1120054004 : Integer;
      SMSMessage@1120054007 : Record 51516329;
      iEntryNo@1120054006 : Integer;
      EntryNo@1120054005 : Integer;
    BEGIN
      Members.RESET;
      Members.SETFILTER(Members.Status,'%1',Members.Status::Active);
      IF Members.FINDFIRST THEN BEGIN
      ProgressWindow.OPEN('Send birthday messages #1#######');
      REPEAT
      SLEEP(100);
      IF Members."Date of Birth"<>0D THEN BEGIN
      BirthMonth:=DATE2DMY(Members."Date of Birth",2);
      BirthDate:=DATE2DMY(Members."Date of Birth",1);
      CurrDate:=DATE2DMY(TODAY,1);
      CurrMonth:=DATE2DMY(TODAY,2);
      IF ((CurrDate=BirthDate) AND (CurrMonth=BirthMonth)) THEN BEGIN
      SMSMessage.RESET;
      IF SMSMessage.FIND('+') THEN BEGIN
      iEntryNo:=SMSMessage."Entry No";
      iEntryNo:=iEntryNo+1;
      END
      ELSE BEGIN
      iEntryNo:=1;
      END;


      SMSMessage.INIT;
      SMSMessage."Entry No":=iEntryNo;
      SMSMessage."Batch No":='';
      SMSMessage."Document No":='';
      SMSMessage."Account No":=Members."Phone No.";
      SMSMessage."Date Entered":=TODAY;
      SMSMessage."Time Entered":=TIME;
      SMSMessage.Source:='HAPPYBIRTHDAY';
      SMSMessage."Entered By":=USERID;
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      SMSMessage."SMS Message":='Happy Birthday '+Members.Name+'!We are glad to journey along with you as you grow.May you soar higher and higher.Telepost Sacco';
      SMSMessage."Telephone No":=Members."Phone No.";
      IF Members."Phone No."<>'' THEN
      SMSMessage.INSERT;
      END;

      END;
      ProgressWindow.UPDATE(1,Members."No."+':'+Members.Name);
      UNTIL Members.NEXT=0;
      ProgressWindow.CLOSE;
      END;
    END;

    BEGIN
    END.
  }
}

