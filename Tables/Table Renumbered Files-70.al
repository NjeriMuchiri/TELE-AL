OBJECT table 50089 Payroll Employee P9
{
  OBJECT-PROPERTIES
  {
    Date=05/20/22;
    Time=[ 2:46:30 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Employee Code       ;Code20        ;TableRelation="Payroll Employee" }
    { 11  ;   ;Basic Pay           ;Decimal        }
    { 12  ;   ;Allowances          ;Decimal        }
    { 13  ;   ;Benefits            ;Decimal        }
    { 14  ;   ;Value Of Quarters   ;Decimal        }
    { 15  ;   ;Defined Contribution;Decimal        }
    { 16  ;   ;Owner Occupier Interest;Decimal     }
    { 17  ;   ;Gross Pay           ;Decimal        }
    { 18  ;   ;Taxable Pay         ;Decimal        }
    { 19  ;   ;Tax Charged         ;Decimal        }
    { 20  ;   ;Insurance Relief    ;Decimal        }
    { 21  ;   ;Tax Relief          ;Decimal        }
    { 22  ;   ;PAYE                ;Decimal        }
    { 23  ;   ;NSSF                ;Decimal        }
    { 24  ;   ;NHIF                ;Decimal        }
    { 25  ;   ;Deductions          ;Decimal        }
    { 26  ;   ;Net Pay             ;Decimal        }
    { 27  ;   ;Period Month        ;Integer        }
    { 28  ;   ;Period Year         ;Integer        }
    { 29  ;   ;Payroll Period      ;Date          ;TableRelation="Payroll Calender"."Date Opened" }
    { 30  ;   ;Period Filter       ;Date          ;FieldClass=FlowFilter;
                                                   TableRelation="Payroll Calender"."Date Opened" }
    { 31  ;   ;Pension             ;Decimal        }
    { 32  ;   ;HELB                ;Decimal        }
    { 33  ;   ;Payroll Code        ;Code20         }
    { 34  ;   ;Pension Contribution;Decimal        }
  }
  KEYS
  {
    {    ;Employee Code,Payroll Period            ;Clustered=Yes }
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

