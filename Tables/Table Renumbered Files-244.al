OBJECT table 20386 File Locations Setup
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 9:23:33 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Location            ;Code20         }
    { 2   ;   ;Description         ;Text100        }
    { 3   ;   ;Custodian Code      ;Code20        ;TableRelation="HR Employees".No. }
    { 4   ;   ;Custodian Name      ;Text50         }
  }
  KEYS
  {
    {    ;Location                                ;Clustered=Yes }
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

