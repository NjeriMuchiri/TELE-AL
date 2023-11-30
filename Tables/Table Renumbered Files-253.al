OBJECT table 20396 prEmployee Transactions
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 2:55:29 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Employee Code       ;Code30        ;TableRelation="HR Employees".No. }
    { 2   ;   ;Transaction Code    ;Code30        ;TableRelation="Payroll Transaction Code"."Transaction Code";
                                                   OnValidate=BEGIN


                                                                blnIsLoan:=FALSE;
                                                                IF objTransCodes.GET("Transaction Code") THEN
                                                                  "Transaction Name":=objTransCodes."Transaction Name";
                                                                  "Payroll Period":=SelectedPeriod;
                                                                  "Period Month":=PeriodMonth;
                                                                  "Period Year":=PeriodYear;
                                                                  IF objTransCodes."Special Transactions"=8 THEN blnIsLoan:=TRUE;
                                                              END;
                                                               }
    { 3   ;   ;Transaction Name    ;Text100        }
    { 4   ;   ;Amount              ;Decimal        }
    { 5   ;   ;Balance             ;Decimal        }
    { 6   ;   ;Original Amount     ;Decimal        }
    { 7   ;   ;Period Month        ;Integer        }
    { 8   ;   ;Period Year         ;Integer        }
    { 9   ;   ;Payroll Period      ;Date          ;TableRelation="prPayroll Periods"."Date Opened" }
    { 10  ;   ;#of Repayments      ;Integer        }
    { 11  ;   ;Membership          ;Code20         }
    { 12  ;   ;Reference No        ;Text100        }
    { 13  ;   ;integera            ;Integer        }
    { 14  ;   ;Employer Amount     ;Decimal        }
    { 15  ;   ;Employer Balance    ;Decimal        }
    { 16  ;   ;Stop for Next Period;Boolean        }
    { 17  ;   ;Amortized Loan Total Repay Amt;Decimal }
    { 18  ;   ;Start Date          ;Date           }
    { 19  ;   ;End Date            ;Date           }
    { 20  ;   ;Loan Number         ;Code16        ;TableRelation="Loans Register"."Loan  No." }
    { 21  ;   ;Payroll Code        ;Code20        ;TableRelation="prPayroll Type" }
    { 22  ;   ;No of Units         ;Decimal        }
    { 23  ;   ;Suspended           ;Boolean        }
    { 24  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Loan Penalty,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Share Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Welfare Contribution 2,Prepayment,Withdrawable Deposits,Domant Share Capital,Interest ADJ";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Loan Penalty,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Share Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Welfare Contribution 2,Prepayment,Withdrawable Deposits,Domant Share Capital,Interest ADJ] }
    { 25  ;   ;Loan Account No     ;Code30         }
    { 26  ;   ;Emp Count           ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("HR Employees" WHERE (No.=FIELD(Employee Code),
                                                                                           Status=FILTER(Active))) }
    { 27  ;   ;PV Filter           ;Code20        ;FieldClass=FlowFilter }
    { 28  ;   ;Emp Status          ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Employees".Status WHERE (No.=FIELD(Employee Code)));
                                                   OptionCaptionML=ENU=Normal,Resigned,Discharged,Retrenched,Pension,Disabled;
                                                   OptionString=Normal,Resigned,Discharged,Retrenched,Pension,Disabled }
  }
  KEYS
  {
    {    ;Employee Code,Transaction Code,Period Month,Period Year,Payroll Period,Reference No;
                                                   SumIndexFields=Amount;
                                                   Clustered=Yes }
    {    ;Employee Code,Transaction Code,Period Month,Period Year,Suspended }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Transcode@1000000014 : Record 51516413;
      objTransCodes@1000000013 : Record 51516413;
      SelectedPeriod@1000000012 : Date;
      objPeriod@1000000011 : Record 51516112;
      PeriodName@1000000010 : Text[30];
      PeriodTrans@1000000009 : Record 51516414;
      PeriodMonth@1000000008 : Integer;
      PeriodYear@1000000007 : Integer;
      blnIsLoan@1000000006 : Boolean;
      objEmpTrans@1000000005 : Record 51516412;
      transType@1000000004 : Text[30];
      strExtractedFrml@1000000002 : Text[30];
      curTransAmount@1000000001 : Decimal;
      empCode@1000000000 : Text[30];

    BEGIN
    END.
  }
}

