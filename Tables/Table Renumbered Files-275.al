OBJECT table 20418 Investor Posting Group
{
  OBJECT-PROPERTIES
  {
    Date=10/08/15;
    Time=[ 4:57:36 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Posting Code        ;Code20         }
    { 11  ;   ;Posting Group Description;Text100   }
    { 12  ;   ;Investor Deposit A/C;Code20        ;TableRelation="G/L Account" }
    { 13  ;   ;Interest Payables A/C;Code20       ;TableRelation="G/L Account" }
    { 14  ;   ;Interest Expense A/C;Code20        ;TableRelation="G/L Account" }
  }
  KEYS
  {
    {    ;Posting Code                            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE CheckGLAcc@2(AccNo@1000 : Code[20];CheckProdPostingGroup@1001 : Boolean;CheckDirectPosting@1002 : Boolean);
    VAR
      GLAcc@1003 : Record 15;
    BEGIN
      IF AccNo <> '' THEN BEGIN
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        IF CheckProdPostingGroup THEN
          GLAcc.TESTFIELD("Gen. Prod. Posting Group");
        IF CheckDirectPosting THEN
          GLAcc.TESTFIELD("Direct Posting",TRUE);
      END;
    END;

    PROCEDURE GetReceivablesAccount@6() : Code[20];
    BEGIN
      TESTFIELD("Investor Deposit A/C");
      EXIT("Investor Deposit A/C");
    END;

    PROCEDURE GetPmtDiscountAccount@1(Debit@1000 : Boolean) : Code[20];
    BEGIN
      {
      //Surestep Comment
      IF Debit THEN BEGIN
        TESTFIELD("Payment Disc. Debit Acc.");
        EXIT("Payment Disc. Debit Acc.");
      END;
      TESTFIELD("Payment Disc. Credit Acc.");
      EXIT("Payment Disc. Credit Acc.");
      }
    END;

    PROCEDURE GetPmtToleranceAccount@3(Debit@1000 : Boolean) : Code[20];
    BEGIN
      {
      //Surestep Comment
      IF Debit THEN BEGIN
        TESTFIELD("Payment Tolerance Debit Acc.");
        EXIT("Payment Tolerance Debit Acc.");
      END;
      TESTFIELD("Payment Tolerance Credit Acc.");
      EXIT("Payment Tolerance Credit Acc.");
      }
    END;

    PROCEDURE GetRoundingAccount@4(Debit@1000 : Boolean) : Code[20];
    BEGIN
      {
      //Surestep Comment
      IF Debit THEN BEGIN
        TESTFIELD("Debit Rounding Account");
        EXIT("Debit Rounding Account");
      END;
      TESTFIELD("Credit Rounding Account");
      EXIT("Credit Rounding Account");
      }
    END;

    PROCEDURE GetApplRoundingAccount@5(Debit@1000 : Boolean) : Code[20];
    BEGIN
      {
      //Surestep Comment
      IF Debit THEN BEGIN
        TESTFIELD("Debit Curr. Appln. Rndg. Acc.");
        EXIT("Debit Curr. Appln. Rndg. Acc.");
      END;
      TESTFIELD("Credit Curr. Appln. Rndg. Acc.");
      EXIT("Credit Curr. Appln. Rndg. Acc.");
      }
    END;

    PROCEDURE GetInterestPayableAccount@10() : Code[20];
    BEGIN
      TESTFIELD("Interest Payables A/C");
      EXIT("Interest Payables A/C");
    END;

    PROCEDURE GetInterestExpenseAccount@9() : Code[20];
    BEGIN
      TESTFIELD("Interest Expense A/C");
      EXIT("Interest Expense A/C");
    END;

    BEGIN
    END.
  }
}

