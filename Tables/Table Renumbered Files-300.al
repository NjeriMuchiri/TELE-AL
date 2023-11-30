OBJECT table 20444 KBA Bank Names
{
  OBJECT-PROPERTIES
  {
    Date=03/09/22;
    Time=[ 3:25:26 PM];
    Modified=Yes;
    Version List=PAYROLL;
  }
  PROPERTIES
  {
    LookupPageID=Page51516917;
    DrillDownPageID=Page51516917;
  }
  FIELDS
  {
    { 1   ;   ;Bank Code           ;Code100       ;OnValidate=BEGIN
                                                                  //IF STRLEN("Bank Code")<2 THEN
                                                                  //"Bank Code":='0'+''+"Bank Code";
                                                              END;
                                                               }
    { 2   ;   ;Bank Name           ;Text130        }
    { 3   ;   ;Location            ;Text30         }
  }
  KEYS
  {
    {    ;Bank Code,Bank Name                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
    ;

    BEGIN
    END.
  }
}

