OBJECT table 17299 Account Types-Saving Products
{
  OBJECT-PROPERTIES
  {
    Date=08/24/23;
    Time=[ 1:37:23 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Last Date Modified":=TODAY;
               "Modified By":=USERID;
             END;

    OnModify=BEGIN
               "Last Date Modified":=TODAY;
               "Modified By":=USERID;
             END;

    OnRename=BEGIN
               "Last Date Modified":=TODAY;
               "Modified By":=USERID;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 4   ;   ;Minimum Balance     ;Decimal        }
    { 5   ;   ;Closure Fee         ;Decimal        }
    { 6   ;   ;Fee Below Minimum Balance;Decimal   }
    { 7   ;   ;Dormancy Period (M) ;DateFormula    }
    { 8   ;   ;Interest Calc Min Balance;Decimal   }
    { 9   ;   ;Interest Calculation Method;Code30  }
    { 13  ;   ;Earns Interest      ;Boolean        }
    { 14  ;   ;Interest Rate       ;Decimal        }
    { 15  ;   ;Withdrawal Interval ;DateFormula    }
    { 17  ;   ;Service Charge      ;Decimal        }
    { 18  ;   ;Maintenence Fee     ;Decimal        }
    { 19  ;   ;Minimum Interest Period (M);DateFormula }
    { 20  ;   ;Requires Closure Notice;Boolean     }
    { 21  ;   ;Transfer Fee        ;Decimal        }
    { 22  ;   ;Pass Book Fee       ;Decimal        }
    { 23  ;   ;Withdrawal Penalty  ;Decimal       ;Description=Charged on withdrawing more than the interval period }
    { 24  ;   ;Salary Processing Fee;Decimal       }
    { 25  ;   ;Loan Application Fee;Decimal        }
    { 26  ;   ;Maximum Withdrawal Amount;Decimal   }
    { 31  ;   ;Max Period For Acc Topup (M);DateFormula }
    { 32  ;   ;Non Staff Loan Security(%);Decimal  }
    { 33  ;   ;Staff Loan Security(%);Decimal      }
    { 34  ;   ;Maximum Allowable Deposit;Decimal   }
    { 35  ;   ;Entered By          ;Code30         }
    { 36  ;   ;Date Entered        ;Date           }
    { 37  ;   ;Time Entered        ;Time           }
    { 39  ;   ;Fixed Deposit Type  ;Code30        ;TableRelation=Table53026 }
    { 40  ;   ;Last Date Modified  ;Date           }
    { 41  ;   ;Modified By         ;Text30         }
    { 43  ;   ;Reject App. Pending Period;DateFormula }
    { 44  ;   ;Maintenence Duration;DateFormula    }
    { 45  ;   ;Fixed Deposit       ;Boolean        }
    { 46  ;   ;Overdraft Charge    ;Code20        ;TableRelation=Charges }
    { 47  ;   ;Charge Closure Before Maturity;Decimal }
    { 48  ;   ;Posting Group       ;Code10        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=ENU=Vendor Posting Group }
    { 49  ;   ;Account No Prefix   ;Code10         }
    { 50  ;   ;Interest Expense Account;Code20    ;TableRelation="G/L Account" }
    { 51  ;   ;Interest Payable Account;Code20    ;TableRelation="G/L Account" }
    { 52  ;   ;Requires Opening Deposit;Boolean    }
    { 53  ;   ;Interest Forfeited Account;Code20  ;TableRelation="G/L Account" }
    { 54  ;   ;Allow Loan Applications;Boolean     }
    { 55  ;   ;Closing Charge      ;Code20        ;TableRelation=Charges }
    { 56  ;   ;Min Bal. Calc Frequency;DateFormula }
    { 57  ;   ;SMS Description     ;Text150        }
    { 58  ;   ;Authorised Ovedraft Charge;Code20  ;TableRelation=Charges }
    { 59  ;   ;Fee bellow Min. Bal. Account;Code20;TableRelation="G/L Account" }
    { 60  ;   ;Withdrawal Interval Account;Code20 ;TableRelation="G/L Account" }
    { 61  ;   ;No. Series          ;Code10         }
    { 62  ;   ;Ending Series       ;Code10         }
    { 63  ;   ;Account Openning Fee;Decimal        }
    { 64  ;   ;Account Openning Fee Account;Code20;TableRelation="G/L Account" }
    { 65  ;   ;Re-activation Fee   ;Decimal        }
    { 66  ;   ;Re-activation Fee Account;Code20   ;TableRelation="G/L Account" }
    { 67  ;   ;Standing Orders Suspense;Code20    ;TableRelation="G/L Account" }
    { 68  ;   ;Closing Prior Notice Charge;Code20 ;TableRelation=Charges }
    { 69  ;   ;Closure Notice Period;DateFormula   }
    { 70  ;   ;Bankers Cheque Account;Code20      ;TableRelation="Bank Account".No. }
    { 71  ;   ;Tax On Interest     ;Decimal        }
    { 72  ;   ;Interest Tax Account;Code20        ;TableRelation="G/L Account" }
    { 73  ;   ;External EFT Charges;Decimal        }
    { 74  ;   ;Internal EFT Charges;Decimal        }
    { 75  ;   ;EFT Charges Account ;Code20        ;TableRelation="G/L Account".No. }
    { 76  ;   ;EFT Bank Account    ;Code20        ;TableRelation="Bank Account".No. }
    { 77  ;   ;Branch              ;Code20         }
    { 78  ;   ;Statement Charge    ;Code20        ;TableRelation=Charges }
    { 79  ;   ;Savings Duration    ;DateFormula    }
    { 80  ;   ;Savings Withdrawal penalty;Decimal  }
    { 81  ;   ;Savings Penalty Account;Code20     ;TableRelation="G/L Account" }
    { 82  ;   ;Recovery Priority   ;Integer        }
    { 83  ;   ;Check Off Recovery  ;Boolean        }
    { 84  ;   ;RTGS Charges        ;Decimal        }
    { 85  ;   ;RTGS Charges Account;Code20        ;TableRelation="G/L Account".No. }
    { 86  ;   ;Use Savings Account Number;Boolean  }
    { 87  ;   ;Search Fee          ;Code10         }
    { 88  ;   ;Activity Code       ;Option        ;OptionCaptionML=ENU=FOSA,MICRO;
                                                   OptionString=FOSA,MICRO }
    { 89  ;   ;FOSA Shares         ;Code20        ;TableRelation=Charges }
    { 90  ;   ;Pass Book           ;Code20        ;TableRelation=Charges }
    { 91  ;   ;Registration Fee    ;Code20        ;TableRelation=Charges }
    { 92  ;   ;Allow Over Draft    ;Boolean        }
    { 93  ;   ;Over Draft Interest %;Decimal       }
    { 94  ;   ;Over Draft Interest Account;Code20 ;TableRelation="G/L Account" }
    { 95  ;   ;Over Draft Issue Charge %;Decimal   }
    { 96  ;   ;Over Draft Issue Charge A/C;Code20 ;TableRelation="G/L Account" }
    { 97  ;   ;Allow Multiple Over Draft;Boolean   }
    { 98  ;   ;ATM Placing Charge  ;Decimal        }
    { 99  ;   ;ATM Replacement Charge;Decimal      }
    { 100 ;   ;Commission on Placing;Decimal       }
    { 101 ;   ;Commission on Replacement;Decimal   }
    { 102 ;   ;Comission on ATM Cards A/C;Code50  ;TableRelation="G/L Account" }
    { 103 ;   ;ATM Bank/GL Account ;Code20        ;TableRelation=IF (ATM Post to Stock=CONST(No)) "Bank Account"
                                                                 ELSE IF (ATM Post to Stock=CONST(Yes)) "G/L Account" }
    { 104 ;   ;ATM Post to Stock   ;Boolean        }
    { 105 ;   ;Allow Multiple Accounts;Boolean     }
    { 50050;  ;Mobile Transaction  ;Option        ;OptionString=[ ,Deposits Only,Withdrawals Only,Deposits & Withdrawals] }
    { 50051;  ;USSD Product Name   ;Text30         }
    { 50052;  ;Max. Overdraft Amount;Decimal       }
    { 50053;  ;Savings Account     ;Boolean        }
    { 50054;  ;Child Account       ;Boolean        }
  }
  KEYS
  {
    {    ;Code                                    ;SumIndexFields=Minimum Balance;
                                                   Clustered=Yes }
    {    ;Recovery Priority                        }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Code,Description                         }
  }
  CODE
  {
    VAR
      GenBusPostingGrp@1000000000 : Record 250;

    BEGIN
    END.
  }
}

