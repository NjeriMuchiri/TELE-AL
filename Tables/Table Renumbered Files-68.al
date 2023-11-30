OBJECT table 50087 Payroll Employee Transactions
{
  OBJECT-PROPERTIES
  {
    Date=08/19/21;
    Time=[ 4:37:29 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
                PayrollCalender.RESET;
                PayrollCalender.SETRANGE(PayrollCalender.Closed,FALSE);
                IF PayrollCalender.FINDFIRST THEN BEGIN
                 "Period Month":=PayrollCalender."Period Month";
                 "Period Year":=PayrollCalender."Period Year";
                 "Payroll Period":=PayrollCalender."Date Opened";
                END;
             END;

  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code20         }
    { 11  ;   ;Transaction Code    ;Code20        ;OnValidate=BEGIN
                                                                 PayrollTrans.RESET;
                                                                 PayrollTrans.SETRANGE(PayrollTrans."Transaction Code","Transaction Code");
                                                                 IF PayrollTrans.FINDFIRST THEN BEGIN
                                                                  "Transaction Name":=PayrollTrans."Transaction Name";
                                                                  "Transaction Type":=PayrollTrans."Transaction Type";
                                                                 END;
                                                              END;
                                                               }
    { 12  ;   ;Transaction Name    ;Text100       ;Editable=No }
    { 13  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Income,Deduction;
                                                   OptionString=Income,Deduction;
                                                   Editable=Yes }
    { 14  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                Employee.RESET;
                                                                Employee.SETRANGE(Employee."No.","No.");
                                                                IF Employee.FINDFIRST THEN BEGIN
                                                                  IF Employee."Currency Code" = '' THEN
                                                                    "Amount(LCY)" := Amount
                                                                  ELSE
                                                                    "Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(TODAY,Employee."Currency Code",Amount,Employee."Currency Factor"));
                                                                END;
                                                              END;
                                                               }
    { 15  ;   ;Amount(LCY)         ;Decimal       ;Editable=No }
    { 16  ;   ;Balance             ;Decimal       ;Editable=Yes }
    { 17  ;   ;Balance(LCY)        ;Decimal       ;Editable=Yes }
    { 18  ;   ;Period Month        ;Integer       ;Editable=No }
    { 19  ;   ;Period Year         ;Integer       ;Editable=No }
    { 20  ;   ;Payroll Period      ;Date          ;TableRelation="Payroll Calender"."Date Opened";
                                                   Editable=No }
    { 21  ;   ;No of Repayments    ;Decimal        }
    { 22  ;   ;Membership          ;Code20         }
    { 23  ;   ;Reference No        ;Text30         }
    { 24  ;   ;Employer Amount     ;Decimal       ;OnValidate=BEGIN
                                                                Employee.RESET;
                                                                Employee.SETRANGE(Employee."No.","No.");
                                                                IF Employee.FINDFIRST THEN BEGIN
                                                                  IF Employee."Currency Code" = '' THEN
                                                                    "Employer Amount(LCY)" := "Employer Amount"
                                                                  ELSE
                                                                    "Employer Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(TODAY,Employee."Currency Code","Employer Amount",Employee."Currency Factor"));
                                                                END;
                                                              END;
                                                               }
    { 25  ;   ;Employer Amount(LCY);Decimal       ;Editable=No }
    { 26  ;   ;Employer Balance    ;Decimal       ;Editable=No }
    { 27  ;   ;Employer Balance(LCY);Decimal      ;Editable=No }
    { 28  ;   ;Stop for Next Period;Boolean        }
    { 29  ;   ;Amtzd Loan Repay Amt;Decimal       ;OnValidate=BEGIN
                                                                {Employee.RESET;
                                                                Employee.SETRANGE(Employee."Job No","No.");
                                                                IF Employee.FINDFIRST THEN BEGIN
                                                                  IF Employee."Currency Code" = '' THEN
                                                                    "Amtzd Loan Repay Amt(LCY)" :="Amtzd Loan Repay Amt"
                                                                  ELSE
                                                                    "Amtzd Loan Repay Amt(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(TODAY,Employee."Currency Code","Amtzd Loan Repay Amt",Employee."Currency Factor"));
                                                                END;}
                                                              END;
                                                               }
    { 30  ;   ;Amtzd Loan Repay Amt(LCY);Decimal   }
    { 31  ;   ;Start Date          ;Date           }
    { 32  ;   ;End Date            ;Date           }
    { 33  ;   ;Loan Number         ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Staff No=FIELD(No.));
                                                   OnValidate=BEGIN

                                                                Loan.RESET;
                                                                Loan.SETRANGE(Loan."Loan  No.","Loan Number");
                                                                IF Loan.FIND('-') THEN BEGIN
                                                                 Loan.CALCFIELDS(Loan."Outstanding Balance");
                                                                 Balance:=Loan."Outstanding Balance";

                                                                END;
                                                              END;
                                                               }
    { 34  ;   ;Payroll Code        ;Code20         }
    { 35  ;   ;No of Units         ;Decimal        }
    { 36  ;   ;Suspended           ;Boolean        }
    { 37  ;   ;Entry No            ;Integer        }
    { 38  ;   ;IsCoop/LnRep        ;Boolean        }
    { 39  ;   ;Grants              ;Code20         }
    { 40  ;   ;Posting Group       ;Code20         }
    { 41  ;   ;Original Amount     ;Decimal        }
    { 42  ;   ;Employee Code       ;Code20         }
    { 43  ;   ;Inclusive of Sunday ;Boolean        }
    { 44  ;   ;Inclusive of Saturday;Boolean       }
  }
  KEYS
  {
    {    ;No.,Transaction Code,Payroll Period     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Employee@1000 : Record 51516180;
      CurrExchRate@1001 : Record 330;
      PayrollCalender@1002 : Record 51516185;
      PayrollTrans@1003 : Record 51516181;
      Loan@1000000000 : Record 51516230;

    BEGIN
    END.
  }
}

