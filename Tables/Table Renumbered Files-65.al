OBJECT table 50084 HR General Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/27/20;
    Time=12:05:54 PM;
    Modified=Yes;
    Version List=HR ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Primary Key         ;Code10         }
    { 11  ;   ;Employee Nos        ;Code20        ;TableRelation="No. Series".Code }
    { 12  ;   ;Payroll Nos         ;Code20        ;TableRelation="No. Series".Code }
    { 13  ;   ;Staff Movement Nos  ;Code10        ;TableRelation="No. Series".Code }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
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

