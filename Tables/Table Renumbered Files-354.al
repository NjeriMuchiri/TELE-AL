OBJECT table 20499 Partial Disbursement Amount
{
  OBJECT-PROPERTIES
  {
    Date=02/17/22;
    Time=[ 4:23:36 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer        }
    { 2   ;   ;Client Number       ;Code10         }
    { 3   ;   ;Amount Disbursed    ;Decimal        }
    { 4   ;   ;Date Disbursed      ;Date           }
    { 5   ;   ;Document No         ;Code10         }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
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

