OBJECT table 20397 prTransaction Codes
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 2:50:44 PM];
    Modified=Yes;
    Version List=Sacco ManagementV1.0(Surestep Systems)8;
  }
  PROPERTIES
  {
    DataCaptionFields=Transaction Name;
    OnDelete=BEGIN
               TestNoEntriesExist(FIELDCAPTION("Transaction Name"));
             END;

    OnRename=BEGIN
               TestNoEntriesExist(FIELDCAPTION("Transaction Name"));
             END;

    LookupPageID=Page51516874;
    DrillDownPageID=Page51516874;
  }
  FIELDS
  {
    { 1   ;   ;Transaction Code    ;Code50        ;Description=Unique Trans line code }
    { 3   ;   ;Transaction Name    ;Text100       ;OnValidate=BEGIN

                                                                TestNoEntriesExist(FIELDCAPTION("Transaction Name"));
                                                              END;

                                                   Description=Description }
    { 4   ;   ;Balance Type        ;Option        ;OptionString=None,Increasing,Reducing;
                                                   Description=None,Increasing,Reducing }
    { 5   ;   ;Transaction Type    ;Option        ;OptionString=Income,Deduction;
                                                   Description=Income,Deduction }
    { 6   ;   ;Frequency           ;Option        ;OptionString=Fixed,Varied;
                                                   Description=Fixed,Varied }
    { 7   ;   ;Is Cash             ;Boolean       ;Description=Does staff receive cash for this transaction }
    { 8   ;   ;Taxable             ;Boolean       ;Description=Is it taxable or not }
    { 9   ;   ;Is Formula          ;Boolean       ;Description=Is the transaction based on a formula }
    { 10  ;   ;Formula             ;Text200       ;Description=[[Formula]] If the above field is "Yes", give the formula] }
    { 16  ;   ;Amount Preference   ;Option        ;OptionString=[Posted Amount,Take Higher,Take Lower ];
                                                   Description=Either (Posted Amount), (Take Higher) or (Take Lower) }
    { 18  ;   ;Special Transactions;Option        ;OptionCaptionML=ENU=Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,StaffLoan,Value of Quarters,Morgage,staff loan;
                                                   OptionString=Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,StaffLoan,Value of Quarters,Morgage,staff loan;
                                                   Description=Represents all Special Transactions }
    { 21  ;   ;Deduct Premium      ;Boolean       ;Description=[[Insurance]] Should the Premium be treated as a payroll deduction?] }
    { 26  ;   ;Interest Rate       ;Decimal       ;Description=[[Loan]] If above is "Yes", give the interest rate] }
    { 28  ;   ;Repayment Method    ;Option        ;OptionCaptionML=ENU=Reducing,Straight line,Amortized;
                                                   OptionString=Reducing,Straight line,Amortized;
                                                   Description=[[Loan]] Reducing,Straight line,Amortized] }
    { 29  ;   ;Fringe Benefit      ;Boolean       ;Description=[[Loan]] should the loan be treated as a Fringe Benefit?] }
    { 30  ;   ;Employer Deduction  ;Boolean       ;Description=Caters for Employer Deductions }
    { 31  ;   ;isHouseAllowance    ;Boolean       ;Description=Flags if its house allowance - Dennis }
    { 32  ;   ;Include Employer Deduction;Boolean ;Description=Is the transaction to include the employer deduction? - Dennis }
    { 33  ;   ;Is Formula for employer;Text200    ;Description=[[Is Formula for employer]] If the above field is "Yes", give the Formula for employer Dennis] }
    { 34  ;   ;Transaction Code old;Code50        ;Description=Old Unique Trans line code - Dennis }
    { 35  ;   ;GL Account          ;Code50        ;TableRelation="G/L Account".No.;
                                                   Description=to post to GL account - Dennis }
    { 36  ;   ;GL Employee Account ;Code50        ;Description=to post to GLemployee  account - Dennis }
    { 37  ;   ;coop parameters     ;Option        ;CaptionML=ENU=Other Categorization;
                                                   OptionCaptionML=ENU=None,Shares,Loan,Loan Interest,Emergency Loan,Emergency Loan Interest,School Fees Loan,School Fees Loan Interest,Welfare,Pension,NSSF,Overtime,Security Fund,Risk Fund,NHIF;
                                                   OptionString=None,Shares,Loan,Loan Interest,Emergency Loan,Emergency Loan Interest,School Fees Loan,School Fees Loan Interest,Welfare,Pension,NSSF,Overtime,Security Fund,Risk Fund,NHIF;
                                                   Description=to be able to report the different coop contributions -Dennis }
    { 38  ;   ;IsCoop/LnRep        ;Boolean       ;Description=to be able to report the different coop contributions -Dennis }
    { 39  ;   ;Deduct Mortgage     ;Boolean        }
    { 40  ;   ;Subledger           ;Option        ;OptionString=[ ,Customer,Vendor,Member,G/L Account] }
    { 41  ;   ;Welfare             ;Boolean        }
    { 42  ;   ;CustomerPostingGroup;Code20        ;TableRelation="Customer Posting Group".Code }
  }
  KEYS
  {
    {    ;Transaction Code                        ;Clustered=Yes }
    {    ;Transaction Name                         }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Transaction Code,Transaction Name        }
  }
  CODE
  {
    VAR
      Text000@1102755000 : TextConst 'ENU=Its not possible to change the transaction name once used in previous Payroll periods. Please Contact the systems Administrator.';

    PROCEDURE TestNoEntriesExist@1006(CurrentFieldName@1000 : Text[100]);
    VAR
      PeriodTrans@1001 : Record 51516163;
    BEGIN
      {
        //To prevent change of field
       PeriodTrans.SETCURRENTKEY(PeriodTrans."Transaction Name");
       PeriodTrans.SETRANGE(PeriodTrans."Transaction Name","Transaction Name");

      IF PeriodTrans.FIND('-') THEN
        ERROR(
        Text000,
         CurrentFieldName);
         }
    END;

    BEGIN
    END.
  }
}

