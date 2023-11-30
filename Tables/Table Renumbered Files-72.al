OBJECT table 50091 Employee Unused Relief
{
  OBJECT-PROPERTIES
  {
    Date=04/29/20;
    Time=[ 3:17:43 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Employee No.        ;Code20         }
    { 11  ;   ;Unused Relief       ;Decimal        }
    { 12  ;   ;Unused Relief(LCY)  ;Decimal        }
    { 13  ;   ;Period Month        ;Integer        }
    { 14  ;   ;Period Year         ;Integer        }
    { 15  ;   ;Payroll Period      ;Date           }
  }
  KEYS
  {
    {    ;Employee No.,Period Month,Period Year   ;Clustered=Yes }
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

