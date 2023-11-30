OBJECT table 20435 SMS Charges
{
  OBJECT-PROPERTIES
  {
    Date=03/17/24;
    Time=11:40:10 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    LookupPageID=Page51516871;
  }
  FIELDS
  {
    { 1   ;   ;Charge Code         ;Code20         }
    { 2   ;   ;Source              ;Text50        ;FieldClass=Normal }
    { 3   ;   ;Amount              ;Decimal        }
    { 4   ;   ;Charge Account      ;Code30        ;TableRelation="G/L Account".No. }
  }
  KEYS
  {
    {    ;Charge Code                             ;Clustered=Yes }
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

