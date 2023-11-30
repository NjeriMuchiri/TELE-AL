OBJECT table 50095 Payroll Employer Deductions
{
  OBJECT-PROPERTIES
  {
    Date=10/20/15;
    Time=[ 3:52:40 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Employee Code       ;Code20         }
    { 11  ;   ;Transaction Code    ;Code20         }
    { 12  ;   ;Amount              ;Decimal        }
    { 13  ;   ;Period Month        ;Integer        }
    { 14  ;   ;Period Year         ;Integer        }
    { 15  ;   ;Payroll Period      ;Date          ;TableRelation="Payroll Calender"."Date Opened" }
    { 16  ;   ;Payroll Code        ;Code20         }
    { 17  ;   ;Amount(LCY)         ;Decimal        }
    { 18  ;   ;Group               ;Integer        }
    { 19  ;   ;SubGroup            ;Integer        }
    { 20  ;   ;Transaction Type    ;Code20         }
    { 21  ;   ;Description         ;Text50         }
    { 22  ;   ;Balance             ;Decimal        }
    { 23  ;   ;Balance(LCY)        ;Decimal        }
    { 24  ;   ;Membership No       ;Code20         }
    { 25  ;   ;Reference No        ;Code20         }
  }
  KEYS
  {
    {    ;Employee Code,Transaction Code,Period Month,Period Year;
                                                   Clustered=Yes }
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

