OBJECT table 50070 prPayroll Periods
{
  OBJECT-PROPERTIES
  {
    Date=04/28/20;
    Time=[ 2:46:29 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page51516337;
    DrillDownPageID=Page51516337;
  }
  FIELDS
  {
    { 1   ;   ;Period Month        ;Integer        }
    { 2   ;   ;Period Year         ;Integer        }
    { 3   ;   ;Period Name         ;Text30        ;Description=e.g November 2009 }
    { 4   ;   ;Date Opened         ;Date          ;NotBlank=Yes }
    { 5   ;   ;Date Closed         ;Date           }
    { 6   ;   ;Closed              ;Boolean       ;Description=A period is either closed or open }
    { 7   ;   ;Payroll Code        ;Code20         }
    { 8   ;   ;Tax Paid            ;Decimal       ;FieldClass=FlowField }
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

