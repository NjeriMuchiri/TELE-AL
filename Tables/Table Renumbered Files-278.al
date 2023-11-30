OBJECT table 20421 POSTAL CORP
{
  OBJECT-PROPERTIES
  {
    Date=08/01/23;
    Time=[ 1:40:33 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Employer Code       ;Code20         }
    { 2   ;   ;Employer Name       ;Text100        }
    { 3   ;   ;County              ;Code50         }
    { 4   ;   ;Payroll No          ;Code30         }
    { 5   ;   ;Account No          ;Code40         }
    { 6   ;   ;Grade               ;Code50         }
    { 7   ;   ;Salary Amount       ;Decimal        }
  }
  KEYS
  {
    {    ;Employer Code,Payroll No,Account No     ;Clustered=Yes }
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

