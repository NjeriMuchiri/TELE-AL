OBJECT table 20393 HR Leave Family Employees
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=11:49:41 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55662;
    DrillDownPageID=Page55662;
  }
  FIELDS
  {
    { 1   ;   ;Family              ;Code20        ;TableRelation="HR Leave Family Groups".Code;
                                                   NotBlank=Yes }
    { 2   ;   ;Employee No         ;Code20        ;TableRelation="HR Employees".No.;
                                                   NotBlank=Yes }
    { 3   ;   ;Remarks             ;Text100        }
  }
  KEYS
  {
    {    ;Family,Employee No                      ;Clustered=Yes }
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

