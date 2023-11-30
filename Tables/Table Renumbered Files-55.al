OBJECT table 50074 HR Job Qualifications
{
  OBJECT-PROPERTIES
  {
    Date=04/22/20;
    Time=11:25:10 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DataCaptionFields=Code,Description;
    CaptionML=ENU=HR Qualifications;
    LookupPageID=Page51516622;
    DrillDownPageID=Page51516622;
  }
  FIELDS
  {
    { 1   ;   ;Qualification Type  ;Code50        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Contract Type)) }
    { 2   ;   ;Code                ;Code10        ;CaptionML=ENU=Code }
    { 6   ;   ;Description         ;Text100       ;CaptionML=ENU=Description;
                                                   NotBlank=Yes }
    { 7   ;   ;Pays NHF            ;Boolean        }
  }
  KEYS
  {
    {    ;Qualification Type,Code                 ;Clustered=Yes }
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

