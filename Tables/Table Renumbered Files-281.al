OBJECT table 20425 Investment General Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/12/15;
    Time=11:58:32 AM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Primary Key         ;Code10         }
    { 11  ;   ;Investor Application Nos.;Code20   ;TableRelation="No. Series".Code }
    { 12  ;   ;Investor Account Nos.;Code20       ;TableRelation="No. Series".Code }
    { 13  ;   ;Investor Posting Group;Code20      ;TableRelation="Investor Posting Group"."Posting Code" }
    { 14  ;   ;Interest Posting Group;Code20      ;TableRelation="Investor Posting Group"."Posting Code" }
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

