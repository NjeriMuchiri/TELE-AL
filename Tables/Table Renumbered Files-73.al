OBJECT table 50092 Payroll Posting Groups
{
  OBJECT-PROPERTIES
  {
    Date=08/24/23;
    Time=10:40:33 AM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Posting Code        ;Code10         }
    { 11  ;   ;Description         ;Text50         }
    { 12  ;   ;Salary Account      ;Code100       ;TableRelation="G/L Account" }
    { 13  ;   ;Income Tax Account  ;Code50        ;TableRelation="G/L Account" }
    { 14  ;   ;SSF Employer Account;Code50        ;TableRelation="G/L Account" }
    { 15  ;   ;SSF Employee Account;Code50        ;TableRelation="G/L Account" }
    { 16  ;   ;Net Salary Payable  ;Code50        ;TableRelation="G/L Account" }
    { 17  ;   ;Operating Overtime  ;Code50        ;TableRelation="G/L Account" }
    { 18  ;   ;Tax Relief          ;Code50        ;TableRelation="G/L Account" }
    { 19  ;   ;Employee Provident Fund Acc.;Code50;TableRelation="G/L Account" }
    { 20  ;   ;Pay Period Filter   ;Date          ;FieldClass=FlowFilter }
    { 21  ;   ;Pension Employer Acc;Code50        ;TableRelation="G/L Account" }
    { 22  ;   ;Pension Employee Acc;Code50        ;TableRelation="G/L Account" }
    { 23  ;   ;Earnings and deductions;Code50      }
    { 24  ;   ;Staff Benevolent    ;Code50        ;TableRelation="G/L Account" }
    { 25  ;   ;SalaryExpenseAC     ;Code100       ;TableRelation="G/L Account" }
    { 26  ;   ;Directors Fee GL    ;Code50        ;TableRelation="G/L Account" }
    { 27  ;   ;Staff Gratuity      ;Code50        ;TableRelation="G/L Account" }
    { 28  ;   ;NHIF Employee Account;Code50       ;TableRelation="G/L Account" }
    { 29  ;   ;Payroll Code        ;Code20         }
    { 30  ;   ;Upload to Payroll   ;Boolean        }
    { 31  ;   ;PAYE Benefit A/C    ;Code20        ;TableRelation="G/L Account" }
    { 32  ;   ;Provident Employer Acc;Code50      ;TableRelation="G/L Account" }
    { 33  ;   ;Provident Employee Acc;Code50      ;TableRelation="G/L Account" }
    { 34  ;   ;Housing Levy Employer Acc;Code50   ;TableRelation="G/L Account" }
    { 35  ;   ;Housing Levy Employee Acc;Code50   ;TableRelation="G/L Account" }
  }
  KEYS
  {
    {    ;Posting Code                            ;Clustered=Yes }
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

