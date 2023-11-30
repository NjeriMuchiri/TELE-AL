OBJECT table 20431 Loan Partial Disburesments
{
  OBJECT-PROPERTIES
  {
    Date=11/11/19;
    Time=[ 3:48:23 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20        ;TableRelation=Table51516371.Field1 }
    { 2   ;   ;Member No           ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Table51516371.Field4 WHERE (Field1=FIELD(Loan No.))) }
    { 3   ;   ;Member Name         ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Table51516371.Field26 WHERE (Field1=FIELD(Loan No.))) }
    { 4   ;   ;Loan Product        ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Table51516371.Field3 WHERE (Field1=FIELD(Loan No.))) }
    { 5   ;   ;Amount to Be Disbursed;Decimal     ;OnValidate=BEGIN
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan No.");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                "Amount Due":=Loans."Approved Amount"-"Amount to Be Disbursed";
                                                                END;
                                                              END;
                                                               }
    { 6   ;   ;Amount Due          ;Decimal        }
  }
  KEYS
  {
    {    ;Loan No.                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Loans@1000000000 : Record 51516230;

    BEGIN
    END.
  }
}

