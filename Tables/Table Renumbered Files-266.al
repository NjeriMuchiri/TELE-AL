OBJECT table 20409 Appraisal Expenses-Micro
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=10:26:35 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;TableRelation="Profitability Set up-Micro";
                                                   OnValidate=BEGIN
                                                                IF ProfSetUp.GET(Code) THEN BEGIN
                                                                Description:=ProfSetUp.Description;
                                                                Type:=ProfSetUp.Type;
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Type                ;Option        ;OptionCaptionML=ENU=Profitability,Business Expenses,Family Expenses;
                                                   OptionString=Profitability,Business Expenses,Family Expenses }
    { 4   ;   ;Amount              ;Decimal        }
    { 5   ;   ;Loan                ;Code10        ;TableRelation="Loans Register" }
    { 6   ;   ;Client Code         ;Code50         }
  }
  KEYS
  {
    {    ;Loan,Client Code,Code                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ProfSetUp@1000000000 : Record 51516433;

    BEGIN
    END.
  }
}

