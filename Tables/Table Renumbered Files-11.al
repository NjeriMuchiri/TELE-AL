OBJECT table 50030 Mobile Loan Installments
{
  OBJECT-PROPERTIES
  {
    Date=10/19/22;
    Time=12:28:46 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Product             ;Code20         }
    { 2   ;   ;Installments        ;Integer        }
    { 3   ;   ;Caption             ;Text30         }
  }
  KEYS
  {
    {    ;Product,Installments                    ;Clustered=Yes }
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

