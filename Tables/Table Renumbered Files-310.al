OBJECT table 20454 Sky Safcom Corporate Charges
{
  OBJECT-PROPERTIES
  {
    Date=07/24/23;
    Time=[ 1:22:42 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 2   ;   ;Minimum             ;Decimal        }
    { 3   ;   ;Maximum             ;Decimal        }
    { 4   ;   ;Charge              ;Decimal        }
    { 5   ;   ;Code                ;Code20         }
  }
  KEYS
  {
    {    ;Minimum,Code                            ;Clustered=Yes }
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

