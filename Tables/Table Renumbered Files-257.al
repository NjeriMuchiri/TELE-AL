OBJECT table 20400 HR Salary Grades
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 3:20:43 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55526;
    DrillDownPageID=Page55526;
  }
  FIELDS
  {
    { 1   ;   ;Salary Grade        ;Code20         }
    { 2   ;   ;Salary Amount       ;Decimal        }
    { 3   ;   ;Description         ;Text100        }
    { 4   ;   ;Pays NHF            ;Boolean        }
    { 5   ;   ;Pays NSITF          ;Boolean        }
  }
  KEYS
  {
    {    ;Salary Grade                            ;Clustered=Yes }
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

