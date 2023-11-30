OBJECT table 17221 Payroll Bank Branches
{
  OBJECT-PROPERTIES
  {
    Date=10/11/15;
    Time=[ 1:28:58 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Bank Code           ;Code20         }
    { 11  ;   ;Branch Code         ;Code20         }
    { 12  ;   ;Branch Name         ;Text100        }
    { 13  ;   ;Branch Physical Location;Text100    }
    { 14  ;   ;Branch Postal Code  ;Code20         }
    { 15  ;   ;Branch Address      ;Text50         }
    { 16  ;   ;Branch Phone No.    ;Code50         }
    { 17  ;   ;Branch Mobile No.   ;Code50         }
    { 18  ;   ;Branch Email Address;Text100        }
  }
  KEYS
  {
    {    ;Bank Code,Branch Code                   ;Clustered=Yes }
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

