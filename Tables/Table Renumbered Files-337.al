OBJECT table 20482 Project General Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/29/15;
    Time=10:07:54 AM;
    Modified=Yes;
    Version List=Project ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Primary Key         ;Code10         }
    { 11  ;   ;Project Nos         ;Code20        ;TableRelation="No. Series".Code }
    { 12  ;   ;Auto Allocate Cost  ;Boolean        }
    { 13  ;   ;Depreciation Book   ;Code20        ;TableRelation="Depreciation Book".Code }
    { 14  ;   ;Projects Analysis Code;Code20      ;TableRelation=Dimension.Code WHERE (Field51516830=CONST(Yes)) }
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

