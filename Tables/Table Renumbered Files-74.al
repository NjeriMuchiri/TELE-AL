OBJECT table 50093 Payroll Salary Arrears
{
  OBJECT-PROPERTIES
  {
    Date=10/13/15;
    Time=11:43:22 AM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Employee Code       ;Code20        ;TableRelation="Payroll Employee" }
    { 11  ;   ;Transaction Code    ;Code20         }
    { 12  ;   ;Start Date          ;Date          ;Description=From when }
    { 13  ;   ;End Date            ;Date          ;Description=Upto when }
    { 14  ;   ;Salary Arrears      ;Decimal        }
    { 15  ;   ;Salary Arrears(LCY) ;Decimal        }
    { 16  ;   ;PAYE Arrears        ;Decimal        }
    { 17  ;   ;PAYE Arrears(LCY)   ;Decimal        }
    { 18  ;   ;Period Month        ;Integer        }
    { 19  ;   ;Period Year         ;Integer        }
    { 20  ;   ;Current Basic       ;Decimal        }
    { 21  ;   ;Current Basic(LCY)  ;Decimal        }
    { 22  ;   ;Payroll Period      ;Date          ;TableRelation="Payroll Calender"."Date Opened" }
    { 23  ;   ;Number              ;Integer       ;AutoIncrement=Yes;
                                                   NotBlank=Yes }
  }
  KEYS
  {
    {    ;Employee Code                           ;Clustered=Yes }
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

