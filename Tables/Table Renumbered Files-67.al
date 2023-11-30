OBJECT table 50086 Payroll Transaction Code
{
  OBJECT-PROPERTIES
  {
    Date=08/23/23;
    Time=[ 5:27:50 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Transaction Code" = '' THEN BEGIN
                IF "Transaction Type"="Transaction Type"::Income THEN BEGIN
                 Setup.GET;
                 Setup.TESTFIELD(Setup."Earnings No");
                 NoSeriesMgt.InitSeries(Setup."Earnings No",xRec."No. Series",0D,"Transaction Code","No. Series");
                END;
                IF "Transaction Type"="Transaction Type"::Deduction THEN BEGIN
                 Setup.GET;
                 Setup.TESTFIELD(Setup."Deductions No");
                 NoSeriesMgt.InitSeries(Setup."Deductions No",xRec."No. Series",0D,"Transaction Code","No. Series");
                END;
               END;
             END;

    LookupPageID=Page51516193;
    DrillDownPageID=Page51516193;
  }
  FIELDS
  {
    { 10  ;   ;Transaction Code    ;Code10        ;Editable=Yes }
    { 11  ;   ;Transaction Name    ;Text100        }
    { 12  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Income,Deduction;
                                                   OptionString=Income,Deduction;
                                                   Editable=No }
    { 13  ;   ;Balance Type        ;Option        ;OptionCaptionML=ENU=None,Increasing,Reducing;
                                                   OptionString=None,Increasing,Reducing }
    { 14  ;   ;Frequency           ;Option        ;OptionCaptionML=ENU=Fixed,Varied;
                                                   OptionString=Fixed,Varied }
    { 15  ;   ;Taxable             ;Boolean        }
    { 16  ;   ;Is Cash             ;Boolean        }
    { 17  ;   ;Is Formulae         ;Boolean        }
    { 18  ;   ;Formulae            ;Code50         }
    { 19  ;   ;Special Transaction ;Option        ;OptionCaptionML=ENU=Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage;
                                                   OptionString=Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage }
    { 20  ;   ;Amount Preference   ;Option        ;OptionCaptionML=ENU="Posted Amount,Take Higher,Take Lower ";
                                                   OptionString=[Posted Amount,Take Higher,Take Lower ] }
    { 21  ;   ;Deduct Premium      ;Boolean        }
    { 22  ;   ;Interest Rate       ;Decimal        }
    { 23  ;   ;Repayment Method    ;Option        ;OptionCaptionML=ENU=Reducing,Straight line,Amortized;
                                                   OptionString=Reducing,Straight line,Amortized }
    { 24  ;   ;Fringe Benefit      ;Boolean        }
    { 25  ;   ;Employer Deduction  ;Boolean        }
    { 26  ;   ;IsHouseAllowance    ;Boolean        }
    { 27  ;   ;Include Employer Deduction;Boolean  }
    { 28  ;   ;Formulae for Employer;Code50        }
    { 29  ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account".No.;
                                                   OnValidate=BEGIN
                                                                  GLAcc.RESET;
                                                                  GLAcc.SETRANGE(GLAcc."No.","G/L Account");
                                                                  IF GLAcc.FINDFIRST THEN BEGIN
                                                                    "G/L Account Name":=GLAcc.Name;
                                                                  END;
                                                              END;
                                                               }
    { 30  ;   ;G/L Account Name    ;Text50        ;Editable=No }
    { 31  ;   ;Co-Op Parameters    ;Option        ;OptionCaptionML=ENU=none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension,NSSF,Overtime,WSS,DevShare,NHIF,Housing Levy;
                                                   OptionString=none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension,NSSF,Overtime,WSS,DevShare,NHIF,Housing Levy }
    { 32  ;   ;IsCo-Op/LnRep       ;Boolean        }
    { 33  ;   ;Deduct Mortgage     ;Boolean        }
    { 34  ;   ;SubLedger           ;Option        ;OptionCaptionML=ENU=" ,Customer,Vendor";
                                                   OptionString=[ ,Customer,Vendor] }
    { 35  ;   ;Welfare             ;Boolean        }
    { 36  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group".Code }
    { 37  ;   ;Previous Month Filter;Date          }
    { 38  ;   ;Current Month Filter;Date           }
    { 39  ;   ;Previous Amount     ;Decimal        }
    { 40  ;   ;Current Amount      ;Decimal        }
    { 41  ;   ;Previous Amount(LCY);Decimal        }
    { 42  ;   ;Current Amount(LCY) ;Decimal        }
    { 43  ;   ;Transaction Category;Option        ;OptionCaptionML=ENU=" ,Housing,Transport,Other Allowances,NHF,Pension,Company Loan,Housing Deduction,Personal Loan,Inconvinience,Bonus Special,Other Deductions,Overtime,Entertainment,Leave,Utility,Other Co-deductions,Car Loan,Call Duty,Co-op,Lunch,Compassionate Loan";
                                                   OptionString=[ ,Housing,Transport,Other Allowances,NHF,Pension,Company Loan,Housing Deduction,Personal Loan,Inconvinience,Bonus Special,Other Deductions,Overtime,Entertainment,Leave,Utility,Other Co-deductions,Car Loan,Call Duty,Co-op,Lunch,Compassionate Loan] }
    { 44  ;   ;Employee Code Filter;Code20         }
    { 45  ;   ;No. Series          ;Code10         }
    { 46  ;   ;Blocked             ;Boolean        }
    { 47  ;   ;Exclude in NSSF     ;Boolean        }
    { 48  ;   ;Exclude in NHIF     ;Boolean        }
    { 49  ;   ;Deployed Nos        ;Code20         }
    { 50  ;   ;Full Time Nos       ;Code20         }
    { 51  ;   ;Board Nos           ;Code20         }
    { 52  ;   ;Committee Nos       ;Code20         }
    { 53  ;   ;Employee Nos.       ;Code20         }
    { 54  ;   ;Employee Requisition Nos.;Code20    }
    { 55  ;   ;Allowance           ;Boolean        }
    { 56  ;   ;Is Housing Levy     ;Boolean        }
    { 57  ;   ;Housing Levy%       ;Decimal        }
  }
  KEYS
  {
    {    ;Transaction Code                        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Transaction Code,Transaction Name        }
  }
  CODE
  {
    VAR
      Setup@1000 : Record 51516219;
      NoSeriesMgt@1001 : Codeunit 396;
      GLAcc@1002 : Record 15;

    BEGIN
    END.
  }
}

