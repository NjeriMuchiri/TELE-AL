OBJECT page 50057 Posted Transactions - List
{
  OBJECT-PROPERTIES
  {
    Date=07/02/18;
    Time=12:48:08 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516299;
    SourceTableView=WHERE(Posted=CONST(Yes));
    PageType=List;
    CardPageID=Posted Transactions Card;
    OnOpenPage=BEGIN
                 //SETRANGE("Transaction Date",TODAY);
                 //SETRANGE(Cashier,USERID);
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr=No }

    { 1102760003;2;Field  ;
                SourceExpr="Account No" }

    { 1102760005;2;Field  ;
                SourceExpr="Account Name" }

    { 1102760007;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1102760009;2;Field  ;
                SourceExpr=Amount }

    { 1102760020;2;Field  ;
                SourceExpr="Expected Maturity Date" }

    { 1102760011;2;Field  ;
                SourceExpr=Cashier }

    { 1102760013;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1102760019;2;Field  ;
                SourceExpr="Amount Discounted";
                Editable=FALSE }

    { 1102760015;2;Field  ;
                SourceExpr=Posted;
                Editable=TRUE }

  }
  CODE
  {
    VAR
      GenJournalLine@1102760007 : Record 81;
      GLPosting@1102760006 : Codeunit 12;
      Account@1102760005 : Record 23;
      AccountType@1102760004 : Record 51516295;
      LineNo@1102760003 : Integer;
      ChequeType@1102760002 : Record 51516304;
      DimensionV@1102760001 : Record 349;
      ChargeAmount@1102760000 : Decimal;
      DiscountingAmount@1102760008 : Decimal;
      Loans@1102760009 : Record 51516230;
      DActivity@1102760012 : Code[20];
      DBranch@1102760011 : Code[20];
      UsersID@1102760010 : Record 2000000120;
      Vend@1102760013 : Record 23;
      LoanType@1102760014 : Record 51516240;
      BOSABank@1102760015 : Code[20];
      ReceiptAllocations@1102760016 : Record 51516246;
      StatusPermissions@1102760017 : Record 51516310;

    PROCEDURE PostBOSAEntries@1102760002();
    VAR
      ReceiptAllocation@1102760000 : Record 51516246;
    BEGIN
      //BOSA Cash Book Entry
      IF "Account No" = '502-00-000300-00' THEN
      BOSABank:='13865'
      ELSE IF "Account No" = '502-00-000303-00' THEN
      BOSABank:='070006';


      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=BOSABank;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      ReceiptAllocations.RESET;
      ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No",No);
      IF ReceiptAllocations.FIND('-') THEN BEGIN
      REPEAT

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Posting Date":="Transaction Date";
      IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment THEN BEGIN
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      IF "Account No" = '502-00-000303-00' THEN
      GenJournalLine."Account No.":='080023'
      ELSE
      GenJournalLine."Account No.":='045003';
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:=Payee;
      END ELSE BEGIN
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Customer;
      GenJournalLine."Account No.":=ReceiptAllocations."Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:=FORMAT(ReceiptAllocations."Transaction Type");
      END;
      GenJournalLine.Amount:=ReceiptAllocations.Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Interest Due" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Benevolent Fund"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Loan THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Benevolent Fund" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Unallocated Funds"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Registration Fee" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Withdrawal THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Registration Fee";
      GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      IF (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Registration Fee") AND
         (ReceiptAllocations."Interest Amount" > 0) THEN BEGIN
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Customer;
      GenJournalLine."Account No.":=ReceiptAllocations."Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Interest Paid';
      GenJournalLine.Amount:=ReceiptAllocations."Interest Amount";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
      GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      END;

      UNTIL ReceiptAllocations.NEXT = 0;
      END;
    END;

    BEGIN
    END.
  }
}

