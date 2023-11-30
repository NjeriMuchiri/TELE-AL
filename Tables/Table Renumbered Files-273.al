OBJECT table 20416 Investor Amounts Ledger
{
  OBJECT-PROPERTIES
  {
    Date=11/03/15;
    Time=12:18:28 PM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Line No             ;Integer       ;AutoIncrement=Yes }
    { 11  ;   ;Investor No         ;Code20         }
    { 12  ;   ;Principle Amount    ;Decimal        }
    { 13  ;   ;Principle Amount(LCY);Decimal       }
    { 14  ;   ;Date                ;Date           }
    { 15  ;   ;Day                 ;Integer        }
    { 16  ;   ;Month               ;Integer        }
    { 17  ;   ;Year                ;Integer        }
    { 18  ;   ;Receipt No          ;Code30         }
    { 19  ;   ;Interest Rate       ;Code30         }
  }
  KEYS
  {
    {    ;Line No,Investor No                     ;Clustered=Yes }
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

