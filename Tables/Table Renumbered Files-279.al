OBJECT table 20423 prPayroll Type
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=10:35:56 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page51516330;
    DrillDownPageID=Page51516330;
  }
  FIELDS
  {
    { 1   ;   ;Payroll Code        ;Code10         }
    { 2   ;   ;Payroll Name        ;Text50         }
    { 3   ;   ;Comment             ;Text200        }
    { 4   ;   ;Period Length       ;DateFormula    }
    { 5   ;   ;EntryNo             ;Integer       ;AutoIncrement=Yes }
  }
  KEYS
  {
    {    ;Payroll Code                            ;Clustered=Yes }
    {    ;EntryNo                                  }
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

