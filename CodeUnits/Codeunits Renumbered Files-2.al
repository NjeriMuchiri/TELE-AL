OBJECT CodeUnit 20366 SKy Transactions
{
  OBJECT-PROPERTIES
  {
    Date=02/03/22;
    Time=[ 3:20:22 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            //ClearCheques;

            //ClearOverDraft;
            //ClearLien;
            //ClearCreditCheques;
            //SavingsAccounts.GET('5050001710000');
            //CalculateFDInterest(SavingsAccounts,093019D);
          END;

  }
  CODE
  {
    VAR
      Jtemplate@1005 : Code[10];
      JBatch@1004 : Code[10];
      LineNo@1000 : Integer;
      EntrNo@1010 : Integer;
      BalAccountType@1001 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      GenJLine@1002 : Record 81;
      Post@1006 : Boolean;
      GenSetup@1008 : Record 51516700;
      SourceType@1012 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,WITHDRAWAL';
      SavingsACC@1013 : Record 23;
      MobileNo@1014 : Code[20];
      AccTypes@1015 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      AccNo@1016 : Code[20];
      ErrPosted@1017 : TextConst 'ENU=This document has not been approved';
      MsgOnConfirmDialog@1018 : TextConst 'ENU=Are you want to Post this Application?';
      AccountTypes@1019 : Record 51516295;
      SMTPMail@1020 : Codeunit 400;
      SMTPSetup@1021 : Record 409;
      Loans@1022 : Record 51516230;
      Memb@1023 : Record 51516220;
      Genrating@1026 : TextConst 'ENU=Posting Salaries';
      PrdFac@1027 : Record 51516717;
      GenJnlPost@1028 : Codeunit 231;
      Window@1029 : Dialog;
      RCount@1030 : Integer;
      "CheckOffAmountOn/Off"@1031 : Decimal;
      LoanProducts@1032 : Record 51516240;
      GeneralSetUp@1033 : Record 51516700;

    LOCAL PROCEDURE "***************SKY*************"@65();
    BEGIN
    END;

    PROCEDURE JournalInsert@66(Jtemplate@1000 : Code[20];JBatch@1001 : Code[20];DocNo@1003 : Code[20];PDate@1016 : Date;AcctType@1004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';AcctNo@1005 : Code[20];Desc@1006 : Text[150];BalAcctType@1008 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';BalAcctNo@1007 : Code[20];Amt@1009 : Decimal;ExtDocNo@1010 : Code[20];Loan@1014 : Code[20];TransType@1015 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';Dim1@1011 : Code[20];Dim2@1012 : Code[20];SystemCreated@1017 : Boolean;ClientName@1018 : Text);
    VAR
      LineNo@1002 : Integer;
      GenJournalLine@1013 : Record 81;
    BEGIN

      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",Jtemplate);
      GenJournalLine.SETRANGE("Journal Batch Name",JBatch);
      LineNo:=GenJournalLine.COUNT;

      LineNo+=1;


      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":=Jtemplate;
      GenJournalLine."Journal Batch Name":=JBatch;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=DocNo;
      GenJournalLine."Posting Date":=PDate;
      GenJournalLine."Account Type":=AcctType;
      GenJournalLine."Account No.":=AcctNo;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:=COPYSTR(Desc,1,50);
      GenJournalLine."Bal. Account Type":=BalAcctType;
      GenJournalLine."Bal. Account No.":=BalAcctNo;
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine.Amount:=Amt;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."External Document No.":=ExtDocNo;
      GenJournalLine."Loan No":=Loan;
      GenJournalLine."Transaction Type":=TransType;
      GenJournalLine."Shortcut Dimension 1 Code":=Dim1;
      GenJournalLine."Shortcut Dimension 2 Code":=Dim2;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      GenJournalLine."System-Created Entry":=TRUE;

      //MESSAGE('%1',GenJournalLine);
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
    END;

    PROCEDURE PostJournal@68(JTemplate@1001 : Code[10];JBatch@1002 : Code[10]);
    VAR
      GenJournalLine@1000 : Record 81;
    BEGIN

      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",JTemplate);
      GenJournalLine.SETRANGE("Journal Batch Name",JBatch);
      IF GenJournalLine.FIND('-') THEN BEGIN
       // ERROR('T');
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
      END;
      //Post New
    END;

    PROCEDURE InitJournal@70(JTemplate@1001 : Code[10];JBatch@1002 : Code[10]);
    VAR
      GenJournalLine@1000 : Record 81;
    BEGIN

      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",JTemplate);
      GenJournalLine.SETRANGE("Journal Batch Name",JBatch);
      IF GenJournalLine.FIND('-') THEN BEGIN
        GenJournalLine.DELETEALL;
      END;
    END;

    PROCEDURE JournalCount@78(JTemplate@1001 : Code[10];JBatch@1002 : Code[10]) : Integer;
    VAR
      GenJournalLine@1000 : Record 81;
    BEGIN

      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",JTemplate);
      GenJournalLine.SETRANGE("Journal Batch Name",JBatch);
      IF GenJournalLine.FIND('-') THEN BEGIN
        EXIT(GenJournalLine.COUNT);
      END;

      EXIT(0);
    END;

    PROCEDURE ActiveMobileMember@1(MemberNo@1000 : Code[20]) MemberActive : Boolean;
    VAR
      Cust@1001 : Record 51516223;
      LoanType@1002 : Record 51516240;
      LoanBalance@1003 : Decimal;
      LastPayDate@1004 : Date;
    BEGIN

      MemberActive := FALSE;

      Cust.GET(MemberNo);
      IF Cust.Status = Cust.Status::Active THEN BEGIN
          //Cust.CALCFIELDS("Last Transaction Date");

          IF Cust."Last Transaction Date" = 0D THEN
               Cust."Last Transaction Date" := Cust."Registration Date";

          IF Cust."Last Transaction Date" <> 0D THEN
              IF CALCDATE('45D', Cust."Last Transaction Date") >= TODAY THEN
                  MemberActive := TRUE;
      END;


      IF MemberActive THEN BEGIN
          LoanType.RESET;
          LoanType.SETRANGE(Code,'<>%1','');
          IF LoanType.FINDFIRST THEN BEGIN
              REPEAT
                  LoanBalance := 0;
                  LastPayDate := 0D;
                  GetLoanNoFromProduct(Cust."No.",LoanType.Code,LoanBalance,LastPayDate);
                  IF LoanBalance > 100 THEN BEGIN
                      IF LastPayDate = 0D THEN
                          MemberActive := FALSE
                      ELSE BEGIN

                          IF CALCDATE('45D', LastPayDate) < TODAY THEN
                              MemberActive := FALSE;
                      END;
                  END;
              UNTIL (LoanType.NEXT = 0) OR (NOT MemberActive);
          END;
      END;

       MemberActive := TRUE;
    END;

    PROCEDURE GetLoanNoFromProduct@160(MemberNo@1000 : Code[20];LoanProduct@1001 : Code[20];VAR LoanBalance@1004 : Decimal;VAR LastPayDate@1005 : Date) LoanNo : Code[20];
    VAR
      LoanType@1002 : Record 51516240;
      Loans@1003 : Record 51516230;
      CLedger@1006 : Record 51516224;
    BEGIN
      LoanBalance := 0;
      LoanNo := '';
      LastPayDate := 0D;

      LoanType.GET(LoanProduct);
      {
      Loans.RESET;
      Loans.SETRANGE("Client Code",MemberNo);
      Loans.SETRANGE("Loan Product Type",LoanProduct);
      Loans.SETFILTER("Outstanding Loan Principal",'<>0');
      IF Loans.FINDFIRST THEN BEGIN
          REPEAT
              Loans.CALCFIELDS("Outstanding Loan Principal");
              LoanBalance += Loans."Outstanding Loan Principal";
              LoanNo := Loans."Loan  No.";
          UNTIL Loans.NEXT = 0;
      END;

      IF LoanBalance <= 0 THEN BEGIN
          LoanBalance := 0;
          LoanNo := '';

      END
      ELSE BEGIN
          CLedger.RESET;
          CLedger.SETRANGE("Customer No.",MemberNo);
          CLedger.SETRANGE("Loan Type Code",LoanProduct);
          CLedger.SETRANGE("Transaction Type",CLedger."Transaction Type"::Repayment);
          IF CLedger.FINDLAST THEN
              LastPayDate := CLedger."Posting Date";
      END;
      }
    END;

    PROCEDURE ActiveMember@2(MemberNo@1000 : Code[20]) MemberActive : Boolean;
    VAR
      Cust@1001 : Record 51516223;
      LoanType@1002 : Record 51516240;
      LoanBalance@1003 : Decimal;
      LastPayDate@1004 : Date;
    BEGIN

      MemberActive := FALSE;

      Cust.GET(MemberNo);
      IF (Cust.Status = Cust.Status::Active) OR (Cust.Status = Cust.Status::Dormant) THEN BEGIN
          Cust.CALCFIELDS("Last Transaction Date");

          IF Cust."Last Transaction Date" = 0D THEN
               Cust."Last Transaction Date" := Cust."Registration Date";

          IF Cust."Last Transaction Date" <> 0D THEN
              IF CALCDATE('3M', Cust."Last Transaction Date") >= TODAY THEN
                  MemberActive := TRUE;



          IF MemberActive THEN BEGIN
              LoanType.RESET;
              LoanType.SETRANGE(Code,'<>%1','');
              IF LoanType.FINDFIRST THEN BEGIN
                  REPEAT
                      LoanBalance := 0;
                      LastPayDate := 0D;
                      GetLoanNoFromProduct(Cust."No.",LoanType.Code,LoanBalance,LastPayDate);
                      IF LoanBalance > 100 THEN BEGIN
                          IF LastPayDate = 0D THEN
                              MemberActive := FALSE
                          ELSE BEGIN

                              IF CALCDATE('3M', LastPayDate) < TODAY THEN
                                  MemberActive := FALSE;
                          END;
                      END;
                  UNTIL (LoanType.NEXT = 0) OR (NOT MemberActive);
              END;
          END;
      END;
    END;

    BEGIN
    END.
  }
}

