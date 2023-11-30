OBJECT table 20392 HR Leave Family Groups
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=11:49:28 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55661;
    DrillDownPageID=Page55661;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text100        }
    { 3   ;   ;Remarks             ;Text200        }
    { 4   ;   ;Max Employees On Leave;Integer     ;Description=Maximum nmber of employees allowed to be on leave at once }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
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

