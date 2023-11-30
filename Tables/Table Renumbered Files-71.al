OBJECT table 50090 Payroll Calender
{
  OBJECT-PROPERTIES
  {
    Date=10/15/15;
    Time=[ 6:17:57 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Date Opened         ;Date           }
    { 11  ;   ;Date Closed         ;Date           }
    { 12  ;   ;Period Name         ;Text50         }
    { 13  ;   ;Period Month        ;Integer        }
    { 14  ;   ;Period Year         ;Integer        }
    { 15  ;   ;Payroll Code        ;Code50         }
    { 16  ;   ;Tax Paid            ;Decimal        }
    { 17  ;   ;Tax Paid(LCY)       ;Decimal        }
    { 18  ;   ;Basic Pay Paid      ;Decimal        }
    { 19  ;   ;Basic Pay Paid(LCY) ;Decimal        }
    { 20  ;   ;Closed              ;Boolean        }
  }
  KEYS
  {
    {    ;Date Opened                             ;Clustered=Yes }
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

