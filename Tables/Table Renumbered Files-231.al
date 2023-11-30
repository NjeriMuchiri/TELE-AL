OBJECT table 20372 POS Commissions
{
  OBJECT-PROPERTIES
  {
    Date=11/11/19;
    Time=[ 3:47:47 PM];
    Modified=Yes;
    Version List=;
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
    { 5   ;   ;Sacco charge        ;Decimal        }
    { 6   ;   ;Bank charge         ;Decimal        }
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

