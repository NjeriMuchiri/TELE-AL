OBJECT table 20389 prEmployee Posting Group
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=10:44:44 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DataCaptionFields=Code,Description;
    LookupPageID=Page51516139;
    DrillDownPageID=Page51516139;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code50        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Salary Account      ;Code100       ;TableRelation="G/L Account" }
    { 4   ;   ;Income Tax Account  ;Code50        ;TableRelation="G/L Account" }
    { 5   ;   ;NSSF Employer Account;Code50       ;TableRelation="G/L Account" }
    { 6   ;   ;NSSF Employee Account;Code50       ;TableRelation="G/L Account" }
    { 7   ;   ;Net Salary Payable  ;Code50        ;TableRelation="G/L Account" }
    { 8   ;   ;Operating Overtime  ;Code50        ;TableRelation="G/L Account" }
    { 9   ;   ;Tax Relief          ;Code50        ;TableRelation="G/L Account" }
    { 10  ;   ;Employee Provident Fund Acc.;Code50;TableRelation="G/L Account" }
    { 11  ;   ;Pay Period Filter   ;Date          ;FieldClass=FlowFilter;
                                                   TableRelation="G/L Account" }
    { 12  ;   ;Pension Employer Acc;Code50        ;TableRelation="G/L Account" }
    { 13  ;   ;Pension Employee Acc;Code50        ;TableRelation="G/L Account" }
    { 14  ;   ;Earnings and deductions;Code50      }
    { 15  ;   ;Staff Benevolent    ;Code50        ;TableRelation="G/L Account" }
    { 16  ;   ;SalaryExpenseAC     ;Code100       ;TableRelation="G/L Account" }
    { 17  ;   ;DirectorsFeeGL      ;Code50        ;TableRelation="G/L Account" }
    { 18  ;   ;StaffGratuity       ;Code50        ;TableRelation="G/L Account" }
    { 19  ;   ;NHIF Employee Account;Code50       ;TableRelation="G/L Account" }
    { 20  ;   ;Payroll Code        ;Code20        ;TableRelation="prPayroll Type" }
    { 21  ;   ;Pension Payable Acc ;Code50        ;TableRelation="G/L Account" }
    { 22  ;   ;NSSF Payable Acc    ;Code50        ;TableRelation="G/L Account" }
    { 23  ;   ;NHIF Payable Acc    ;Code50        ;TableRelation="G/L Account" }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Earnings and deductions                  }
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

