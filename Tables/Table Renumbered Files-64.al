OBJECT table 50083 Share Capital Recoveries
{
  OBJECT-PROPERTIES
  {
    Date=12/14/20;
    Time=[ 2:39:21 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 2   ;   ;Member No           ;Code20        ;Editable=No }
    { 3   ;   ;Date Recovered      ;DateTime      ;Editable=No }
    { 4   ;   ;Amount Recoverred   ;Decimal       ;Editable=No }
    { 5   ;   ;Recovered By        ;Code50        ;Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
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

