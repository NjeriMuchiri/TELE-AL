OBJECT table 50079 Salary Step/Notch Transactions
{
  OBJECT-PROPERTIES
  {
    Date=02/01/19;
    Time=11:37:20 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55534;
    DrillDownPageID=Page55534;
  }
  FIELDS
  {
    { 1   ;   ;Salary Grade        ;Code20        ;TableRelation="prPayroll Periods"."Period Month" }
    { 2   ;   ;Salary Step/Notch   ;Code20        ;TableRelation="HR Salary Notch"."Salary Notch" WHERE (Salary Grade=FIELD(Salary Grade)) }
    { 3   ;   ;Transaction Code    ;Code20        ;OnValidate=BEGIN
                                                                {IF Trans.GET("Transaction Code") THEN BEGIN
                                                                "Transaction Name":=Trans."Transaction Name";
                                                                "Transaction Type":=Trans."Transaction Type";
                                                                Formula:=Trans.Formula;
                                                                END;}
                                                              END;
                                                               }
    { 4   ;   ;Transaction Name    ;Text100        }
    { 5   ;   ;Transaction Type    ;Option        ;OptionString=Income,Deduction }
    { 6   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                "Annual Amount":=Amount*12;
                                                              END;
                                                               }
    { 7   ;   ;% of Basic Pay      ;Decimal        }
    { 8   ;   ;Formula             ;Code100        }
    { 9   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 10  ;   ;Annual Amount       ;Decimal       ;OnValidate=BEGIN
                                                                IF "Annual Amount">0 THEN
                                                                Amount:="Annual Amount"/12;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Salary Grade,Salary Step/Notch,Entry No ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

