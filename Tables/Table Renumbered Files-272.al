OBJECT table 20415 Investor Interest Amounts
{
  OBJECT-PROPERTIES
  {
    Date=10/09/15;
    Time=10:22:08 AM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Investor No         ;Code20         }
    { 11  ;   ;Interest Code       ;Code20         }
    { 12  ;   ;Month               ;Integer        }
    { 13  ;   ;Year                ;Integer        }
    { 14  ;   ;Day                 ;Integer        }
    { 15  ;   ;Principle Amount    ;Decimal        }
    { 16  ;   ;Interest Amount     ;Decimal        }
    { 17  ;   ;Paid                ;Boolean        }
    { 18  ;   ;Paying Document No  ;Code20         }
    { 19  ;   ;Paying Date         ;Date           }
    { 20  ;   ;Date Name           ;Code20         }
  }
  KEYS
  {
    {    ;Investor No,Interest Code,Month,Year    ;Clustered=Yes }
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

