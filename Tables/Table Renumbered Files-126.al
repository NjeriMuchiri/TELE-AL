OBJECT table 17244 Loan Products Setup
{
  OBJECT-PROPERTIES
  {
    Date=08/29/23;
    Time=[ 3:31:49 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnModify=BEGIN

                TestNoEntriesExist(FIELDCAPTION("Loan Account"),"Loan Account");
                TestNoEntriesExist(FIELDCAPTION("Loan Interest Account"),"Loan Interest Account");
                TestNoEntriesExist(FIELDCAPTION("Receivable Interest Account"),"Receivable Interest Account");
             END;

    OnDelete=BEGIN
                TestNoEntriesExist(FIELDCAPTION("Loan Account"),"Loan Account");
                TestNoEntriesExist(FIELDCAPTION("Loan Interest Account"),"Loan Interest Account");
                TestNoEntriesExist(FIELDCAPTION("Receivable Interest Account"),"Receivable Interest Account");
             END;

    OnRename=BEGIN
                TestNoEntriesExist(FIELDCAPTION("Loan Account"),"Loan Account");
                TestNoEntriesExist(FIELDCAPTION("Loan Interest Account"),"Loan Interest Account");
                TestNoEntriesExist(FIELDCAPTION("Receivable Interest Account"),"Receivable Interest Account");
             END;

    LookupPageID=Page51516270;
    DrillDownPageID=Page51516270;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20         }
    { 2   ;   ;Product Description ;Text30         }
    { 3   ;   ;Source of Financing ;Code10         }
    { 4   ;   ;Interest rate       ;Decimal        }
    { 9   ;   ;Interest Calculation Method;Option ;OptionString=,No Interest,Flat Rate,Reducing Balances }
    { 11  ;   ;Insurance %         ;Decimal        }
    { 17  ;   ;No. Series          ;Code10        ;TableRelation="No. Series" }
    { 24  ;   ;Grace Period        ;DateFormula    }
    { 26  ;   ;Name of Source of Funding;Text30   ;Editable=No }
    { 27  ;   ;Rounding            ;Option        ;OptionString=Nearest,Down,Up }
    { 28  ;   ;Rounding Precision  ;Decimal       ;InitValue=1;
                                                   MinValue=0.01;
                                                   MaxValue=1 }
    { 29  ;   ;Loan Appraisal %    ;Decimal        }
    { 30  ;   ;No of Installment   ;Integer        }
    { 31  ;   ;Loan No Series      ;Code10        ;TableRelation="No. Series" }
    { 32  ;   ;New Numbers         ;Code10         }
    { 33  ;   ;Instalment Period   ;DateFormula    }
    { 34  ;   ;Loan to Share Ratio ;Decimal        }
    { 35  ;   ;Penalty Calculation Days;DateFormula }
    { 36  ;   ;Penalty Percentage  ;Decimal        }
    { 37  ;   ;Penalty Calculation Method;Option  ;OptionString=No Penalty,Principal in Arrears,Principal in Arrears+Interest in Arrears,Principal in Arrears+Penalty inArrears,Principal in Arrears+Interest in Arrears+Penalty in Arrears }
    { 38  ;   ;Penalty Paid Account;Code20        ;TableRelation="G/L Account".No. }
    { 39  ;   ;Use Cycles          ;Boolean        }
    { 40  ;   ;Max. Loan Amount    ;Decimal        }
    { 41  ;   ;Penalty Posted Reporting Date;Date  }
    { 42  ;   ;Penalty Posted Last Calc. Date;Date }
    { 43  ;   ;Compulsary Savings  ;Decimal        }
    { 44  ;   ;Repayment Method    ;Option        ;OptionString=Amortised,Reducing Balance,Straight Line,Constants }
    { 45  ;   ;Grace Period - Principle (M);Integer }
    { 46  ;   ;Grace Period - Interest (M);Integer }
    { 47  ;   ;Min. Loan Amount    ;Decimal        }
    { 48  ;   ;Bank Account Details;Text250        }
    { 49  ;   ;BacK Code           ;Code20        ;FieldClass=Normal;
                                                   TableRelation="Bank Account".No. }
    { 50  ;   ;Loan Account        ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNoEntriesExist(FIELDCAPTION(Code),Code);
                                                                TestNoEntriesExist(FIELDCAPTION("Loan Account"),"Loan Account")
                                                              END;
                                                               }
    { 51  ;   ;Loan Interest Account;Code20       ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNoEntriesExist(FIELDCAPTION(Code),Code);
                                                                TestNoEntriesExist(FIELDCAPTION("Loan Interest Account"),"Loan Interest Account")
                                                              END;
                                                               }
    { 52  ;   ;Receivable Interest Account;Code20 ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNoEntriesExist(FIELDCAPTION(Code),Code);
                                                                TestNoEntriesExist(FIELDCAPTION("Receivable Interest Account"),"Receivable Interest Account")
                                                              END;
                                                               }
    { 53  ;   ;BOSA Account        ;Code20        ;TableRelation=Vendor.No. WHERE (Creditor Type=CONST(Account)) }
    { 54  ;   ;Action              ;Option        ;OptionCaptionML=ENU=" ,Off Set Commitments,Discounting";
                                                   OptionString=[ ,Off Set Commitments,Discounting] }
    { 55  ;   ;BOSA Personal Loan Account;Code20  ;TableRelation=Vendor.No. WHERE (Creditor Type=CONST(Account)) }
    { 56  ;   ;Top Up Commision Account;Code20    ;TableRelation="G/L Account" }
    { 57  ;   ;Top Up Commision    ;Decimal        }
    { 58  ;   ;Source              ;Option        ;OptionCaptionML=ENU=BOSA,FOSA,Investment,MICRO;
                                                   OptionString=BOSA,FOSA,Investment,MICRO }
    { 59  ;   ;Recovery Priority   ;Integer        }
    { 60  ;   ;Check Off Recovery  ;Boolean        }
    { 61  ;   ;SMS Description     ;Text50         }
    { 62  ;   ;Default Installements;Integer       }
    { 63  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 64  ;   ;Applications        ;Decimal        }
    { 65  ;   ;Issued Amount       ;Decimal        }
    { 66  ;   ;Min No. Of Guarantors;Integer       }
    { 67  ;   ;Min Re-application Period;DateFormula }
    { 68  ;   ;Check Off Loan No.  ;Integer        }
    { 69  ;   ;Bridged/Topped      ;Boolean        }
    { 70  ;   ;Affect Deposits Qualification;Boolean }
    { 71  ;   ;Shares Multiplier   ;Decimal        }
    { 72  ;   ;Mode of Qualification;Option       ;OptionCaptionML=ENU=Normal Sacco,Fosa,Security;
                                                   OptionString=Normal Sacco,Fosa,Security }
    { 73  ;   ;Product Currency Code;Code10       ;TableRelation=Currency.Code;
                                                   Editable=No }
    { 74  ;   ;Loan Product Expiry Date;Date       }
    { 75  ;   ;Appln. between Currencies;Option   ;CaptionML=ENU=Appln. between Currencies;
                                                   OptionCaptionML=ENU=None,EMU,All;
                                                   OptionString=None,EMU,All }
    { 76  ;   ;Repayment Frequency ;Option        ;OptionCaptionML=ENU=Daily,Weekly,Monthly,Quaterly;
                                                   OptionString=Daily,Weekly,Monthly,Quaterly }
    { 77  ;   ;Appraise Deposits   ;Boolean        }
    { 78  ;   ;Appraise Shares     ;Boolean        }
    { 79  ;   ;Appraise Salary     ;Boolean        }
    { 80  ;   ;Appraise Guarantors ;Boolean        }
    { 81  ;   ;Appraise Business   ;Boolean        }
    { 82  ;   ;Recovery Mode       ;Option        ;OptionCaptionML=ENU=Checkoff,Standing Order,Salary,Pension,Direct Debits,Mobile;
                                                   OptionString=Checkoff,Standing Order,Salary,Pension,Direct Debits,Mobile }
    { 83  ;   ;Deposits Multiplier ;Decimal        }
    { 84  ;   ;Appraise Collateral ;Decimal        }
    { 85  ;   ;Appraise Dividend   ;Boolean        }
    { 86  ;   ;Penalty Charged Account;Code20     ;TableRelation="G/L Account" }
    { 87  ;   ;Staff Sal Adv  Max %;Decimal        }
    { 88  ;   ;Jaza Loan Min Re-App  Period;DateFormula }
    { 89  ;   ;Jaza Min Boosting Amount;Decimal    }
    { 90  ;   ;Jaza Max Boosting Amount;Decimal    }
    { 91  ;   ;Jaza Levy           ;Decimal        }
    { 92  ;   ;Interest Rate-Outstanding >1.5;Decimal }
    { 93  ;   ;Instant loan Net Multiplier;Decimal }
    { 94  ;   ;Maximum No. Of Runing Loans;Decimal }
    { 95  ;   ;Mazao Qualification(%);Decimal      }
    { 96  ;   ;Self guaranteed Multiplier;Decimal  }
    { 97  ;   ;Dont Recover Repayment;Boolean      }
    { 98  ;   ;Loan Insurance Accounts;Code20     ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNoEntriesExist(FIELDCAPTION(Code),Code);
                                                                TestNoEntriesExist(FIELDCAPTION("Loan Interest Account"),"Loan Interest Account")
                                                              END;
                                                               }
    { 99  ;   ;Receivable Insurance Accounts;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNoEntriesExist(FIELDCAPTION(Code),Code);
                                                                TestNoEntriesExist(FIELDCAPTION("Receivable Interest Account"),"Receivable Interest Account")
                                                              END;
                                                               }
    { 100 ;   ;Loan Collateral Accounts;Code20    ;TableRelation="G/L Account" }
    { 101 ;   ;Post to Deposits    ;Boolean        }
    { 102 ;   ;Discount G/L Account;Code20        ;TableRelation="G/L Account" }
    { 103 ;   ;Requires LPO        ;Boolean        }
    { 104 ;   ;Post to G/L Account ;Boolean        }
    { 105 ;   ;G/L Account No      ;Code20        ;TableRelation="G/L Account" }
    { 106 ;   ;Post to Vendor      ;Boolean        }
    { 107 ;   ;Vendor Account No   ;Code20        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN
                                                                 TESTFIELD("Post to Vendor");
                                                              END;
                                                               }
    { 108 ;   ;Share Cap %         ;Decimal        }
    { 109 ;   ;Max Share Cap       ;Decimal        }
    { 110 ;   ;Bank Comm %         ;Decimal        }
    { 111 ;   ;Bank Comm A/c       ;Code20        ;TableRelation="G/L Account" }
    { 112 ;   ;Loan Tiers          ;Option        ;OptionCaptionML=ENU=" ,Tier One,Tier Two,Tier Three";
                                                   OptionString=[ ,Tier One,Tier Two,Tier Three] }
    { 113 ;   ;Loan Code           ;Code10         }
    { 114 ;   ;ProcessingFee       ;Decimal        }
    { 115 ;   ;ShowPortal          ;Boolean        }
    { 116 ;   ;No Qlf  Per Deposits;Boolean        }
    { 117 ;   ;interestpercentage  ;Decimal        }
    { 118 ;   ;ExemptInt           ;Boolean        }
    { 119 ;   ;Staff Loan          ;Boolean        }
    { 120 ;   ;Deposit Boost %     ;Decimal        }
    { 50050;  ;USSD Product Name   ;Text30         }
    { 50051;  ;AvailableOnMobile   ;Boolean        }
    { 50052;  ;Restrict to Insider Classif.;Option;OptionCaptionML=ENU=" ,Member,Delegate,Board Member,Staff";
                                                   OptionString=[  ,Member,Delegate,Board Member,Staff] }
    { 50053;  ;Interest Recovered Upfront;Boolean  }
    { 50054;  ;Min. Mobile Loan Guarantors;Integer }
    { 50055;  ;Appraise By School Fee Shares;Boolean }
    { 50056;  ;salary Earner       ;Boolean        }
    { 50057;  ;Salaried Max Loan Amount;Decimal    }
    { 50058;  ;Interest upfront    ;Decimal        }
    { 50059;  ;Pens dep %          ;Decimal        }
    { 50060;  ;Attached Accounts   ;Code20        ;TableRelation="Account Types-Saving Products".Code }
    { 50061;  ;Appraise By Jibambe Shares;Boolean  }
    { 50062;  ;Appraise By FOSA Savings;Boolean    }
    { 50063;  ;Days To Recover From FOSA;Integer   }
    { 50064;  ;Expected Threshhold Duration;DateFormula }
    { 50065;  ;KeyWord             ;Code30         }
    { 50066;  ;Mobile Loan Req. Guar.;Boolean      }
    { 50067;  ;Requires Purpose    ;Boolean        }
    { 50068;  ;Requires Branch     ;Boolean        }
    { 50069;  ;Mobile Installments Type;Option    ;OptionString=None,Input,Preset }
    { 50070;  ;Mobile Min. Guarantors;Integer      }
    { 50071;  ;Ordinary Default Intallments;Integer }
    { 50072;  ;Min. Mobile Installments;Integer    }
    { 50073;  ;Max. Mobile Installments;Integer    }
    { 50074;  ;Mobile Max. Guarantors;Integer      }
    { 50075;  ;Requires TnC        ;Boolean        }
    { 50076;  ;Shows Mobile Qualification;Boolean  }
    { 50077;  ;Requires Payslip PIN;Boolean        }
    { 50078;  ;Minimum Guarantor Deposits;Decimal  }
    { 50079;  ;Salary Loans        ;Boolean        }
    { 50080;  ;Min LoanGuatantor Amount;Decimal    }
    { 50081;  ;Max LoanGuatantor Amount;Decimal    }
    { 50082;  ;Minimum Monthly Contribution;Decimal }
    { 50083;  ;Interest Charged Upfront;Boolean    }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Recovery Priority                        }
    {    ;Product Description                      }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Code,Product Description                 }
  }
  CODE
  {
    VAR
      SalesSetup@1000000000 : Record 311;
      NoSeriesMgt@1000000001 : Codeunit 396;
      Text000@1102755000 : TextConst 'ENU=You cannot change %1 because there are one or more ledger entries associated with this account.';

    PROCEDURE TestNoEntriesExist@1006(CurrentFieldName@1000 : Text[100];GLNO@1102755000 : Code[20]);
    VAR
      GLLedgEntry@1000000000 : Record 17;
    BEGIN

        //To prevent change of field
       {GLLedgEntry.SETCURRENTKEY(GLLedgEntry."G/L Account No.");
       GLLedgEntry.SETRANGE("G/L Account No.",GLNO);
      IF GLLedgEntry.FIND('-') THEN
        ERROR(
        Text000,   CurrentFieldName)
        }
    END;

    BEGIN
    END.
  }
}

