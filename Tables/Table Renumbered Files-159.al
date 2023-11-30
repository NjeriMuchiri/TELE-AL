OBJECT table 17277 Tariff Details
{
  OBJECT-PROPERTIES
  {
    Date=08/19/13;
    Time=[ 3:38:58 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Lower Limit         ;Decimal        }
    { 3   ;   ;Upper Limit         ;Decimal        }
    { 4   ;   ;Charge Amount       ;Decimal        }
  }
  KEYS
  {
    {    ;Code,Lower Limit                        ;Clustered=Yes }
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

