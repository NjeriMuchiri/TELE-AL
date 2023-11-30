OBJECT table 20472 Defaulter Deposit Recovery
{
  OBJECT-PROPERTIES
  {
    Date=01/28/21;
    Time=[ 1:54:21 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer        }
    { 2   ;   ;Loan No.            ;Code20         }
    { 3   ;   ;Member No.          ;Text30         }
    { 4   ;   ;Name                ;Text30         }
    { 5   ;   ;Deposits Recovered  ;Decimal        }
    { 6   ;   ;Date Recovered      ;Date           }
    { 7   ;   ;Recovered By        ;Code50         }
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

