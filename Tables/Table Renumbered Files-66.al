OBJECT table 50085 Payroll Employee
{
  OBJECT-PROPERTIES
  {
    Date=05/26/22;
    Time=[ 2:03:29 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code20         }
    { 11  ;   ;Surname             ;Text30        ;OnValidate=BEGIN
                                                                  "Full Name":=Surname+' '+Firstname+' '+Lastname;
                                                              END;
                                                               }
    { 12  ;   ;Firstname           ;Text30        ;OnValidate=BEGIN
                                                                  "Full Name":=Surname+' '+Firstname+' '+Lastname;
                                                              END;
                                                               }
    { 13  ;   ;Lastname            ;Text30        ;OnValidate=BEGIN
                                                                   "Full Name":=Surname+' '+Firstname+' '+Lastname;
                                                              END;
                                                               }
    { 14  ;   ;Joining Date        ;Date           }
    { 15  ;   ;Currency Code       ;Code20        ;TableRelation=Currency.Code }
    { 16  ;   ;Currency Factor     ;Decimal        }
    { 17  ;   ;Global Dimension 1  ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   CaptionClass='1,1,1' }
    { 18  ;   ;Global Dimension 2  ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   CaptionClass='1,2,2' }
    { 19  ;   ;Shortcut Dimension 3;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3));
                                                   CaptionClass='1,2,3' }
    { 20  ;   ;Shortcut Dimension 4;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   CaptionClass='1,2,4' }
    { 21  ;   ;Shortcut Dimension 5;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5));
                                                   CaptionClass='1,2,5' }
    { 22  ;   ;Shortcut Dimension 6;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6));
                                                   CaptionClass='1,2,6' }
    { 23  ;   ;Shortcut Dimension 7;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7));
                                                   CaptionClass='1,2,7' }
    { 24  ;   ;Shortcut Dimension 8;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8));
                                                   CaptionClass='1,2,8' }
    { 25  ;   ;Basic Pay           ;Decimal       ;OnValidate=BEGIN
                                                                IF "Currency Code" = '' THEN
                                                                  "Basic Pay(LCY)" := "Basic Pay"
                                                                ELSE
                                                                  "Basic Pay(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(TODAY,"Currency Code","Basic Pay","Currency Factor"));
                                                              END;
                                                               }
    { 26  ;   ;Basic Pay(LCY)      ;Decimal        }
    { 27  ;   ;Cummulative Basic Pay;Decimal      ;Editable=No }
    { 28  ;   ;Cummulative Gross Pay;Decimal      ;Editable=No }
    { 29  ;   ;Cummulative Allowances;Decimal     ;Editable=No }
    { 30  ;   ;Cummulative Deductions;Decimal     ;Editable=No }
    { 31  ;   ;Cummulative Net Pay ;Decimal       ;Editable=No }
    { 32  ;   ;Cummulative PAYE    ;Decimal        }
    { 33  ;   ;Cummulative NSSF    ;Decimal        }
    { 34  ;   ;Cummulative Pension ;Decimal        }
    { 35  ;   ;Cummulative HELB    ;Decimal        }
    { 36  ;   ;Cummulative NHIF    ;Decimal        }
    { 37  ;   ;Cummulative Employer Pension;Decimal }
    { 38  ;   ;Cummulative TopUp   ;Decimal        }
    { 39  ;   ;Cummulative Basic Pay(LCY);Decimal ;Editable=No }
    { 40  ;   ;Cummulative Gross Pay(LCY);Decimal ;Editable=No }
    { 41  ;   ;Cummulative Allowances(LCY);Decimal;Editable=No }
    { 42  ;   ;Cummulative Deductions(LCY);Decimal;Editable=No }
    { 43  ;   ;Cummulative Net Pay(LCY);Decimal   ;Editable=No }
    { 44  ;   ;Cummulative PAYE(LCY);Decimal       }
    { 45  ;   ;Cummulative NSSF(LCY);Decimal       }
    { 46  ;   ;Cummulative Pension(LCY);Decimal    }
    { 47  ;   ;Cummulative HELB(LCY);Decimal       }
    { 48  ;   ;Cummulative NHIF(LCY);Decimal       }
    { 49  ;   ;Cumm Employer Pension(LCY);Decimal  }
    { 50  ;   ;Cummulative TopUp(LCY);Decimal      }
    { 51  ;   ;Non Taxable         ;Decimal       ;OnValidate=BEGIN
                                                                IF "Currency Code" = '' THEN
                                                                  "Non Taxable(LCY)" := "Non Taxable"
                                                                ELSE
                                                                  "Non Taxable(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(TODAY,"Currency Code","Non Taxable","Currency Factor"));
                                                              END;
                                                               }
    { 52  ;   ;Non Taxable(LCY)    ;Decimal        }
    { 53  ;   ;Posting Group       ;Code20        ;TableRelation="Payroll Posting Groups"."Posting Code" }
    { 54  ;   ;Payment Mode        ;Option        ;OptionCaptionML=ENU=Bank Transfer,Cheque,Cash,SACCO;
                                                   OptionString=Bank Transfer,Cheque,Cash,SACCO }
    { 55  ;   ;Pays PAYE           ;Boolean        }
    { 56  ;   ;Pays NSSF           ;Boolean        }
    { 57  ;   ;Pays NHIF           ;Boolean        }
    { 58  ;   ;Bank Code           ;Code20        ;TableRelation="Payroll Bank Codes"."Bank Code";
                                                   OnValidate=BEGIN
                                                                 BankCodes.RESET;
                                                                 BankCodes.SETRANGE(BankCodes."Bank Code","Bank Code");
                                                                 IF BankCodes.FINDFIRST THEN BEGIN
                                                                   BankCodes.TESTFIELD(BankCodes."Bank Name");
                                                                   "Bank Name":=BankCodes."Bank Name";
                                                                 END;
                                                              END;
                                                               }
    { 59  ;   ;Bank Name           ;Text100       ;Editable=No }
    { 60  ;   ;Branch Code         ;Code20        ;TableRelation="Payroll Bank Branches"."Branch Code" WHERE (Bank Code=FIELD(Bank Code));
                                                   OnValidate=BEGIN
                                                                  BankBranches.RESET;
                                                                  BankBranches.SETRANGE(BankBranches."Bank Code","Bank Code");
                                                                  BankBranches.SETRANGE(BankBranches."Branch Code","Branch Code");
                                                                  IF BankBranches.FINDFIRST THEN BEGIN
                                                                    BankBranches.TESTFIELD(BankBranches."Branch Name");
                                                                    "Branch Name":=BankBranches."Branch Name";
                                                                  END;
                                                              END;
                                                               }
    { 61  ;   ;Branch Name         ;Text100       ;Editable=No }
    { 62  ;   ;Bank Account No     ;Code50         }
    { 63  ;   ;Suspend Pay         ;Boolean        }
    { 64  ;   ;Suspend Date        ;Date           }
    { 65  ;   ;Suspend Reason      ;Text100        }
    { 66  ;   ;Hourly Rate         ;Decimal        }
    { 67  ;   ;Gratuity            ;Boolean        }
    { 68  ;   ;Gratuity Percentage ;Decimal        }
    { 69  ;   ;Gratuity Provision  ;Decimal       ;OnValidate=BEGIN
                                                                IF "Currency Code" = '' THEN
                                                                  "Gratuity Provision(LCY)" := "Gratuity Provision"
                                                                ELSE
                                                                  "Gratuity Provision(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(TODAY,"Currency Code","Gratuity Provision","Currency Factor"));
                                                              END;
                                                               }
    { 70  ;   ;Gratuity Provision(LCY);Decimal     }
    { 71  ;   ;Cummulative Gratuity;Decimal        }
    { 72  ;   ;Cummulative Gratuity(LCY);Decimal   }
    { 73  ;   ;Days Absent         ;Decimal        }
    { 74  ;   ;Payslip Message     ;Text100        }
    { 75  ;   ;Paid per Hour       ;Boolean        }
    { 76  ;   ;Full Name           ;Text90         }
    { 77  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Active,Inactive,Terminated;
                                                   OptionString=Active,Inactive,Terminated }
    { 78  ;   ;Date of Leaving     ;Date           }
    { 79  ;   ;GetsPayeRelief      ;Boolean        }
    { 80  ;   ;GetsPayeBenefit     ;Boolean        }
    { 81  ;   ;Secondary           ;Boolean        }
    { 82  ;   ;PayeBenefitPercent  ;Decimal        }
    { 83  ;   ;NSSF No             ;Code20         }
    { 84  ;   ;NHIF No             ;Code20         }
    { 85  ;   ;PIN No              ;Code20         }
    { 86  ;   ;Company             ;Option        ;OptionCaptionML=ENU=Telepost Sacco Society;
                                                   OptionString=Telepost Sacco Society }
    { 87  ;   ;Current Month Filter;Date          ;FieldClass=FlowFilter }
    { 88  ;   ;National ID No      ;Code20         }
    { 89  ;   ;Photo               ;BLOB          ;SubType=Bitmap }
    { 90  ;   ;Period Filter       ;Date          ;TableRelation="Payroll Calender"."Date Opened" }
    { 91  ;   ;Date Of Birth       ;Date           }
    { 92  ;   ;Employee Email      ;Text50         }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Full Name                            }
  }
  CODE
  {
    VAR
      CurrExchRate@1000 : Record 330;
      BankCodes@1001 : Record 51516216;
      BankBranches@1002 : Record 51516217;

    BEGIN
    END.
  }
}

