OBJECT table 20414 Investor Amounts
{
  OBJECT-PROPERTIES
  {
    Date=11/03/15;
    Time=12:26:43 PM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Investor No         ;Code20        ;Editable=No }
    { 11  ;   ;Interest Code       ;Code20        ;TableRelation="Interest Rates".Code }
    { 12  ;   ;Investment Date     ;Date           }
    { 13  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                 "Amount(LCY)":=Amount;
                                                              END;
                                                               }
    { 14  ;   ;Amount(LCY)         ;Decimal       ;Editable=No }
    { 15  ;   ;Closure Date        ;Date          ;Editable=No }
    { 16  ;   ;Description         ;Text100       ;Editable=No }
    { 17  ;   ;Interest Due        ;Decimal        }
    { 18  ;   ;Interest Paid       ;Decimal       ;Editable=No }
    { 19  ;   ;Last Update Date    ;Date          ;Editable=No }
    { 20  ;   ;Last Update Time    ;Time          ;Editable=No }
    { 21  ;   ;Last Update User    ;Code50        ;Editable=No }
  }
  KEYS
  {
    {    ;Investor No,Interest Code,Investment Date;
                                                   Clustered=Yes }
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

