OBJECT table 20438 Loan SMS Notice
{
  OBJECT-PROPERTIES
  {
    Date=08/26/20;
    Time=[ 3:15:19 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Loan No             ;Code50         }
    { 3   ;   ;SMS 7 Day           ;Date           }
    { 4   ;   ;SMS Due Date today  ;Date           }
    { 5   ;   ;Notice SMS 1        ;Date           }
    { 6   ;   ;Notice SMS 2        ;Date           }
    { 7   ;   ;Notice SMS 3        ;Date           }
    { 8   ;   ;Guarantor SMS       ;Date           }
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

