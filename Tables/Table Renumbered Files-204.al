OBJECT table 17324 Stations
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 4:57:00 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page50238;
    DrillDownPageID=Page50238;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Employer Code       ;Code20        ;TableRelation="HR Leave Application"."Application Code" }
  }
  KEYS
  {
    {    ;Employer Code,Code                      ;Clustered=Yes }
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

