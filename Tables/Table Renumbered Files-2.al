OBJECT table 50021 UFAA Buffer
{
  OBJECT-PROPERTIES
  {
    Date=07/04/23;
    Time=[ 4:06:53 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer       ;Editable=No }
    { 2   ;   ;Member No           ;Code40        ;Editable=No }
    { 3   ;   ;FOSA Account        ;Code40        ;Editable=No }
    { 4   ;   ;Source              ;Option        ;OptionCaptionML=ENU=,BOSA,FOSA;
                                                   OptionString=,BOSA,FOSA;
                                                   Editable=No }
    { 5   ;   ;Deposits            ;Decimal       ;Editable=No }
    { 6   ;   ;Fosa Balance        ;Decimal       ;Editable=No }
    { 7   ;   ;Account Type        ;Code40        ;TableRelation="Account Types-Saving Products".Code;
                                                   Editable=No }
    { 8   ;   ;Members Name        ;Text250       ;Editable=No }
    { 9   ;   ;School Fees Deposits;Decimal       ;Editable=No }
    { 10  ;   ;Last Transaction Date;Date         ;Editable=No }
    { 11  ;   ;Member PF           ;Code20        ;Editable=No }
    { 12  ;   ;Mobile Number       ;Code40         }
    { 13  ;   ;ID Number           ;Code40         }
    { 14  ;   ;Withdrawal Notice Date;Date         }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
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

