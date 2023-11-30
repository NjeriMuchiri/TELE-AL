OBJECT table 20484 Temp Loans Balances
{
  OBJECT-PROPERTIES
  {
    Date=07/07/17;
    Time=[ 5:15:13 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Member No           ;Code20         }
    { 2   ;   ;Loan No             ;Code30         }
    { 3   ;   ;Outstanding Balance ;Decimal        }
    { 4   ;   ;Extra To Loans      ;Boolean        }
    { 5   ;   ;Loan Product        ;Code20         }
  }
  KEYS
  {
    {    ;Member No,Loan No                       ;Clustered=Yes }
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

