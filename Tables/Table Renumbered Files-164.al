OBJECT table 17282 Loan Charge Band
{
  OBJECT-PROPERTIES
  {
    Date=07/24/15;
    Time=11:22:55 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan Type           ;Code20         }
    { 2   ;   ;Charge Type         ;Code20         }
    { 3   ;   ;Lower Limit         ;Decimal        }
    { 4   ;   ;Upper Limit         ;Decimal        }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Use (%)             ;Boolean        }
    { 7   ;   ;Rate                ;Decimal        }
  }
  KEYS
  {
    {    ;Loan Type,Charge Type,Lower Limit       ;Clustered=Yes }
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

