OBJECT table 50088 Payroll Monthly Transactions
{
  OBJECT-PROPERTIES
  {
    Date=08/24/23;
    Time=10:38:29 AM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code20         }
    { 11  ;   ;Transaction Code    ;Code20         }
    { 12  ;   ;Transaction Name    ;Text50         }
    { 13  ;   ;Global Dimension 1  ;Code20         }
    { 14  ;   ;Global Dimension 2  ;Code20         }
    { 15  ;   ;Shortcut Dimension 3;Code20         }
    { 16  ;   ;Shortcut Dimension 4;Code20         }
    { 17  ;   ;Shortcut Dimension 5;Code20         }
    { 18  ;   ;Shortcut Dimension 6;Code20         }
    { 19  ;   ;Shortcut Dimension 7;Code20         }
    { 20  ;   ;Shortcut Dimension 8;Code20         }
    { 21  ;   ;Group Text          ;Text50         }
    { 22  ;   ;Amount              ;Decimal        }
    { 23  ;   ;Amount(LCY)         ;Decimal        }
    { 24  ;   ;Balance             ;Decimal        }
    { 25  ;   ;Balance(LCY)        ;Decimal        }
    { 26  ;   ;Grouping            ;Integer        }
    { 27  ;   ;SubGrouping         ;Integer        }
    { 28  ;   ;Period Month        ;Integer        }
    { 29  ;   ;Period Year         ;Integer        }
    { 30  ;   ;Payroll Period      ;Date           }
    { 31  ;   ;Period Filter       ;Date           }
    { 32  ;   ;Reference No        ;Code20         }
    { 33  ;   ;Membership          ;Code20         }
    { 34  ;   ;LumpSumItems        ;Boolean        }
    { 35  ;   ;TravelAllowance     ;Code20         }
    { 36  ;   ;Posting Type        ;Option        ;OptionCaptionML=ENU=" ,Debit,Credit";
                                                   OptionString=[ ,Debit,Credit] }
    { 37  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=" ,G/L Account,Customer,Vendor";
                                                   OptionString=[ ,G/L Account,Customer,Vendor] }
    { 38  ;   ;Account No          ;Code50         }
    { 39  ;   ;Loan Number         ;Code20         }
    { 40  ;   ;Co-Op parameters    ;Option        ;OptionCaptionML=ENU=none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension,NSSF,Overtime,WSS,DevShare,NHIF,Housing Levy;
                                                   OptionString=none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension,NSSF,Overtime,WSS,DevShare,NHIF,Housing Levy }
    { 41  ;   ;Company Deduction   ;Boolean        }
    { 42  ;   ;Employer Amount     ;Decimal        }
    { 43  ;   ;Employer Amount(LCY);Decimal        }
    { 44  ;   ;Employer Balance    ;Decimal        }
    { 45  ;   ;Employer Balance(LCY);Decimal       }
    { 46  ;   ;Payment Mode        ;Option        ;OptionCaptionML=ENU=" ,Bank Transfer,Cheque,Cash,SACCO";
                                                   OptionString=[ ,Bank Transfer,Cheque,Cash,SACCO] }
    { 47  ;   ;Payroll Code        ;Code50         }
    { 48  ;   ;No. of Units        ;Decimal        }
    { 49  ;   ;Original Amount     ;Decimal        }
    { 50  ;   ;Allowance           ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Payroll Transaction Code".Allowance WHERE (Transaction Code=FIELD(Transaction Code))) }
  }
  KEYS
  {
    {    ;No.,Transaction Code,Period Month,Period Year;
                                                   Clustered=Yes }
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

