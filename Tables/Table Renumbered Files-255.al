OBJECT table 20398 prPeriod Transactions
{
  OBJECT-PROPERTIES
  {
    Date=05/27/16;
    Time=[ 2:09:07 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page51516339;
    DrillDownPageID=Page51516339;
  }
  FIELDS
  {
    { 1   ;   ;Employee Code       ;Code50        ;TableRelation="HR Employees".No. }
    { 2   ;   ;Transaction Code    ;Text30        ;TableRelation="prTransaction Codes"."Transaction Code" }
    { 3   ;   ;Group Text          ;Text30        ;Description=e.g Statutory, Deductions, Tax Calculation etc }
    { 4   ;   ;Transaction Name    ;Text200        }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Balance             ;Decimal        }
    { 7   ;   ;Original Amount     ;Decimal        }
    { 8   ;   ;Group Order         ;Integer        }
    { 9   ;   ;Sub Group Order     ;Integer        }
    { 10  ;   ;Period Month        ;Integer        }
    { 11  ;   ;Period Year         ;Integer        }
    { 12  ;   ;Period Filter       ;Date          ;FieldClass=FlowFilter }
    { 13  ;   ;Payroll Period      ;Date           }
    { 14  ;   ;Membership          ;Code50         }
    { 15  ;   ;Reference No        ;Text20         }
    { 16  ;   ;Department Code     ;Code20         }
    { 17  ;   ;Lumpsumitems        ;Boolean        }
    { 18  ;   ;TravelAllowance     ;Code20         }
    { 19  ;   ;GL Account          ;Code20        ;TableRelation="G/L Account" }
    { 20  ;   ;Company Deduction   ;Boolean       ;Description=Dennis- Added to filter out the company deductions esp: the Pensions }
    { 21  ;   ;Emp Amount          ;Decimal       ;Description=Dennis- Added to take care of the balances that need a combiantion btwn employee and employer }
    { 22  ;   ;Emp Balance         ;Decimal       ;Description=Dennis- Added to take care of the balances that need a combiantion btwn employee and employer }
    { 23  ;   ;Journal Account Code;Code20         }
    { 24  ;   ;Journal Account Type;Option        ;OptionString=[ ,G/L Account,Customer,Vendor] }
    { 25  ;   ;Post As             ;Option        ;OptionString=[ ,Debit,Credit] }
    { 26  ;   ;Loan Number         ;Code10         }
    { 27  ;   ;coop parameters     ;Option        ;OptionString=none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension,NSSF,Overtime;
                                                   Description=to be able to report the different coop contributions -Dennis }
    { 28  ;   ;Payroll Code        ;Code20        ;TableRelation="prPayroll Type" }
    { 29  ;   ;Payment Mode        ;Option        ;OptionString=[ ,Bank Transfer,Cheque,Cash,SACCO];
                                                   Description=Bank Transfer,Cheque,Cash,SACCO }
    { 30  ;   ;Location/Division   ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4)) }
    { 31  ;   ;Department          ;Code20        ;TableRelation=Table50082.Field1 }
    { 32  ;   ;Cost Centre         ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(COSTCENTRE)) }
    { 33  ;   ;Salary Grade        ;Code20        ;TableRelation="HR Salary Grades"."Salary Grade" }
    { 34  ;   ;Salary Notch        ;Code20        ;TableRelation="HR Salary Notch"."Salary Notch" WHERE (Salary Grade=FIELD(Salary Grade)) }
    { 35  ;   ;Payslip Order       ;Integer        }
    { 36  ;   ;No. Of Units        ;Decimal        }
    { 37  ;   ;Employee Classification;Code20      }
    { 38  ;   ;State               ;Code20        ;TableRelation="Post Code" }
    { 39  ;   ;New Departmental Code;Code20        }
    { 40  ;   ;grants              ;Code20        ;TableRelation=Jobs.No. }
    { 53900;  ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 53901;  ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 51516000;;Total Statutories  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prPeriod Transactions".Amount WHERE (Employee Code=FIELD(Employee Code),
                                                                                                         Group Text=CONST(STATUTORIES),
                                                                                                         Period Month=FIELD(Period Month),
                                                                                                         Period Year=FIELD(Period Year))) }
  }
  KEYS
  {
    {    ;Employee Code,Transaction Code,Period Month,Period Year,Membership,Reference No;
                                                   SumIndexFields=Amount,No. Of Units;
                                                   Clustered=Yes }
    {    ;Employee Code,Period Month,Period Year,Group Order,Sub Group Order,Payslip Order,Membership,Reference No;
                                                   SumIndexFields=Amount,No. Of Units }
    {    ;Group Order,Transaction Code,Period Month,Period Year,Membership,Reference No,Department Code;
                                                   SumIndexFields=Amount,No. Of Units }
    {    ;Membership                               }
    {    ;Transaction Code,Payroll Period,Membership,Reference No;
                                                   SumIndexFields=Amount,No. Of Units }
    {    ;Payroll Period,Group Order,Sub Group Order;
                                                   SumIndexFields=Amount,No. Of Units }
    {    ;Employee Code,Department Code           ;SumIndexFields=Amount,No. Of Units }
    {    ;Transaction Code,Employee Code,Payroll Period,Location/Division,Department;
                                                   SumIndexFields=Amount,No. Of Units }
    {    ;Payslip Order                            }
    {    ;Transaction Code,Employee Code,Payroll Period,Reference No }
    {    ;Department                              ;SumIndexFields=Amount }
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

