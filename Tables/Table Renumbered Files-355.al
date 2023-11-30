OBJECT table 17350 Debt Collectors Details
{
  OBJECT-PROPERTIES
  {
    Date=02/02/23;
    Time=[ 1:35:49 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20         }
    { 2   ;   ;Collectors Name     ;Text200        }
    { 3   ;   ;Rate                ;Decimal        }
    { 4   ;   ;UserID              ;Code40        ;TableRelation="User Setup"."User ID" }
  }
  KEYS
  {
    {    ;Code,Collectors Name                    ;Clustered=Yes }
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

