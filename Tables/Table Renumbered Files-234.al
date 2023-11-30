OBJECT table 20375 Checkoff Adv Deposts Buffer
{
  OBJECT-PROPERTIES
  {
    Date=08/01/19;
    Time=11:03:51 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Member No           ;Code10         }
    { 3   ;   ;Month               ;Integer        }
    { 4   ;   ;ED Code             ;Code20         }
    { 5   ;   ;Transaction Date    ;Date           }
    { 6   ;   ;Amount              ;Decimal        }
    { 7   ;   ;Batch No            ;Code20         }
    { 8   ;   ;Employer Code       ;Code20         }
  }
  KEYS
  {
    {    ;Entry No,Member No,ED Code              ;Clustered=Yes }
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

