OBJECT table 50028 Coop Transaction Codes
{
  OBJECT-PROPERTIES
  {
    Date=04/17/21;
    Time=[ 4:33:54 PM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20         }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Terminal            ;Code10         }
    { 4   ;   ;Channel             ;Code10         }
    { 5   ;   ;Daily Limit         ;Decimal        }
  }
  KEYS
  {
    {    ;Code,Terminal,Channel                   ;Clustered=Yes }
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

