OBJECT table 17261 Sacco General Set-Up
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=[ 4:14:42 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Share Interest (%)  ;Decimal        }
    { 2   ;   ;Max. Non Contribution Periods;Code10 }
    { 3   ;   ;Min. Contribution   ;Decimal        }
    { 4   ;   ;Min. Dividend Proc. Period;Code10   }
    { 5   ;   ;Loan to Share Ratio ;Decimal        }
    { 6   ;   ;Min. Loan Application Period;Code10 }
    { 7   ;   ;Min. Guarantors     ;Integer        }
    { 8   ;   ;Max. Guarantors     ;Integer        }
    { 9   ;   ;Member Can Guarantee Own Loan;Boolean }
    { 10  ;   ;Insurance Premium (%);Decimal       }
    { 11  ;   ;Rec                 ;Integer       ;NotBlank=No }
    { 12  ;   ;Commision (%)       ;Decimal        }
    { 13  ;   ;Contactual Shares (%);Decimal       }
    { 14  ;   ;Registration Fee    ;Decimal        }
    { 15  ;   ;Welfare Contribution;Decimal        }
    { 16  ;   ;Administration Fee  ;Decimal        }
    { 17  ;   ;Dividend (%)        ;Decimal        }
    { 18  ;   ;Statement Message #1;Text250        }
    { 19  ;   ;Statement Message #2;Text250        }
    { 20  ;   ;Statement Message #3;Text250        }
    { 21  ;   ;Statement Message #4;Text250        }
    { 22  ;   ;Statement Message #5;Text250        }
    { 23  ;   ;Statement Message #6;Text250        }
    { 24  ;   ;Defaut Batch        ;Code20        ;TableRelation="Appraissal Lines WP"."Appraisal No." }
    { 25  ;   ;Min. Member Age     ;DateFormula    }
    { 26  ;   ;Approved Loans Letter;Code10       ;TableRelation="Interaction Template".Code }
    { 27  ;   ;Rejected Loans Letter;Code10       ;TableRelation="Interaction Template".Code }
    { 28  ;   ;Max. Contactual Shares;Decimal      }
    { 29  ;   ;Shares Contribution ;Decimal        }
    { 30  ;   ;Boosting Shares %   ;Decimal        }
    { 31  ;   ;Boosting Shares Maturity (M);DateFormula }
    { 32  ;   ;Min Loan Reaplication Period;DateFormula }
    { 33  ;   ;Welfare Breakdown #1 (%);Decimal    }
    { 34  ;   ;Loan to Share Ratio (4M);Decimal    }
    { 35  ;   ;FOSA Loans Transfer Acct;Code20    ;TableRelation="G/L Account" }
    { 36  ;   ;FOSA Bank Account   ;Code20        ;TableRelation="Bank Account".No. }
    { 37  ;   ;Guarantor Loan No Series;Code20     }
    { 38  ;   ;Interest Due Document No.;Code20    }
    { 39  ;   ;Interest Due Posting Date;Date      }
    { 40  ;   ;Withholding Tax (%) ;Decimal        }
    { 41  ;   ;Withdrawal Fee      ;Decimal        }
    { 42  ;   ;Retained Shares     ;Decimal        }
    { 43  ;   ;Multiple Disb. Acc. ;Code20        ;TableRelation="G/L Account" }
    { 44  ;   ;Receipt Document No.;Code20         }
    { 45  ;   ;Minimum Balance     ;Decimal        }
    { 46  ;   ;Use Bands           ;Boolean        }
    { 47  ;   ;Retirement Age      ;DateFormula    }
    { 48  ;   ;Insurance Retension Account;Code20 ;TableRelation="G/L Account" }
    { 49  ;   ;Shares Retension Account;Code20    ;TableRelation="G/L Account" }
    { 50  ;   ;Batch File Path     ;Text250        }
    { 51  ;   ;Incoming Mail Server;Text30         }
    { 52  ;   ;Outgoing Mail Server;Text30         }
    { 53  ;   ;Email Text          ;Text100        }
    { 54  ;   ;Sender User ID      ;Text30         }
    { 55  ;   ;Sender Address      ;Text100        }
    { 56  ;   ;Email Subject       ;Text100        }
    { 57  ;   ;Template Location   ;Text100        }
    { 58  ;   ;Copy To             ;Text100        }
    { 59  ;   ;Delay Time          ;Integer        }
    { 60  ;   ;Alert time          ;Time           }
    { 61  ;   ;Shares              ;Decimal        }
    { 62  ;   ;Qualifing Shares    ;Decimal        }
    { 63  ;   ;Gross Dividends     ;Decimal        }
    { 64  ;   ;Withholding Tax     ;Decimal        }
    { 65  ;   ;Net Dividends       ;Decimal        }
    { 66  ;   ;Actual Net Surplus  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("G/L Entry".Amount WHERE (G/L Account No.=FILTER(1-11-00000..2-99-29999),
                                                                                             Posting Date=FIELD(Date Filter))) }
    { 67  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 68  ;   ;Loan Transfer Fees Account;Code20  ;TableRelation="G/L Account" }
    { 69  ;   ;Rejoining Fees Account;Code20      ;TableRelation="G/L Account" }
    { 70  ;   ;Boosting Fees Account;Code20       ;TableRelation="G/L Account" }
    { 71  ;   ;Bridging Commision Account;Code20  ;TableRelation="G/L Account" }
    { 72  ;   ;Funeral Expenses Amount;Decimal     }
    { 73  ;   ;Funeral Expenses Account;Code20    ;TableRelation="G/L Account" }
    { 74  ;   ;Interest on Deposits (%);Decimal    }
    { 75  ;   ;Days for Checkoff   ;DateFormula    }
    { 76  ;   ;Guarantors Multiplier;Decimal       }
    { 77  ;   ;Excise Duty(%)      ;Decimal        }
    { 78  ;   ;Excise Duty Account ;Code20        ;TableRelation="G/L Account" }
    { 79  ;   ;ATM Expiry Duration ;DateFormula    }
    { 80  ;   ;Defaulter LN        ;Integer        }
    { 81  ;   ;Loan Trasfer Fee-EFT;Decimal        }
    { 82  ;   ;Loan Trasfer Fee-Cheque;Decimal     }
    { 83  ;   ;Loan Trasfer Fee-FOSA;Decimal       }
    { 84  ;   ;Loan Trasfer Fee A/C-FOSA;Code30   ;FieldClass=Normal;
                                                   TableRelation="G/L Account".No. }
    { 85  ;   ;Loan Trasfer Fee A/C-EFT;Code30    ;TableRelation="G/L Account".No. }
    { 86  ;   ;Loan Trasfer Fee A/C-Cheque;Code30 ;TableRelation="G/L Account".No. }
    { 87  ;   ;Monthly Share Contributions;Decimal }
    { 88  ;   ;Maximum No of Guarantees;Integer    }
    { 89  ;   ;Loan Trasfer Fee-RTGS;Decimal       }
    { 90  ;   ;Loan Trasfer Fee A/C-RTGS;Code20   ;TableRelation="G/L Account" }
    { 91  ;   ;Top up Commission   ;Decimal        }
    { 92  ;   ;ATM Card Fee-New Coop;Decimal       }
    { 93  ;   ;ATM Card Fee-Replacement;Decimal    }
    { 94  ;   ;ATM Card Fee-Renewal;Decimal        }
    { 95  ;   ;ATM Card Fee-Account;Code20        ;TableRelation="G/L Account" }
    { 96  ;   ;ATM Card Fee Co-op Bank;Code20     ;TableRelation="Bank Account" }
    { 97  ;   ;ATM Card Fee-New Sacco;Decimal      }
    { 98  ;   ;ATM Card Co-op Bank Amount;Decimal  }
    { 99  ;   ;Deposits Multiplier ;Decimal        }
    { 100 ;   ;FOSA MPESA COmm A/C ;Code30        ;TableRelation="G/L Account" }
    { 101 ;   ;Funeral Expense Amount;Decimal      }
    { 102 ;   ;Rejoining Fee       ;Decimal        }
    { 103 ;   ;Maximum No of Loans Guaranteed;Integer }
    { 104 ;   ;Withdrawal Fee Account;Code20      ;TableRelation="G/L Account" }
    { 105 ;   ;Overdraft App Nos.  ;Code20        ;TableRelation="No. Series" }
    { 106 ;   ;Send SMS Notifications;Boolean      }
    { 107 ;   ;ATM Applications    ;Code10         }
    { 108 ;   ;Auto Open FOSA Savings Acc.;Boolean }
    { 109 ;   ;Max Loans To Guarantee;Integer      }
    { 110 ;   ;Min Deposits To Apply Loan;Decimal  }
    { 111 ;   ;Speed Charge (%)    ;Decimal        }
    { 112 ;   ;Charge Premature Interest;Boolean   }
    { 113 ;   ;Retirement Age - Management;DateFormula }
    { 114 ;   ;Customer Care No    ;Text30         }
    { 115 ;   ;Send Email Notifications;Boolean    }
    { 116 ;   ;HQ Branch           ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 117 ;   ;FOSA Account Type   ;Code20        ;TableRelation="Account Types-Saving Products".Code }
    { 118 ;   ;Auto Fill Msacco Application;Boolean }
    { 119 ;   ;Auto Fill ATM Application;Boolean   }
    { 121 ;   ;Allow Multiple Receipts;Boolean     }
    { 122 ;   ;Withdrawal fee G/L Account;Code20  ;TableRelation="G/L Account" }
    { 123 ;   ;Boosting Commission Account;Code20 ;TableRelation="G/L Account" }
    { 124 ;   ;Tracker no          ;Code20        ;TableRelation="No. Series" }
    { 125 ;   ;Withdrawal Commision;Decimal        }
    { 126 ;   ;Max. No. of Signatories;Integer     }
    { 127 ;   ;Max Loan Guarantors BLoans;Integer  }
    { 128 ;   ;Business Loans A/c Format;Code10   ;Editable=Yes }
    { 129 ;   ;Commission on FOSA Overdraft;Code20;TableRelation="G/L Account" }
    { 130 ;   ;Statement Fee       ;Decimal        }
    { 131 ;   ;Statement Fee Account;Code10       ;TableRelation="G/L Account" }
    { 132 ;   ;ATM Withdrawal Limit Amount;Decimal }
    { 133 ;   ;Overdrafft%         ;Decimal        }
    { 134 ;   ;Checkoff Cutoff Days;DateFormula    }
    { 135 ;   ;Salary Cutoff Days  ;DateFormula    }
    { 136 ;   ;Price Per Share     ;Decimal        }
    { 137 ;   ;Co-op Shares Charge G/L;Code20     ;TableRelation="G/L Account" }
    { 138 ;   ;Co-op Share Transfer Charge;Decimal }
    { 139 ;   ;Co-op Shares Control Acc;Code20    ;TableRelation="G/L Account" }
    { 140 ;   ;Minimum Purchasable Shares;Integer  }
    { 141 ;   ;Maximum Purchasable Shares;Integer  }
    { 142 ;   ;Co-op Shares Dividend %;Decimal     }
    { 143 ;   ;Co-op Shares Dividend Payable;Code20;
                                                   TableRelation="G/L Account" }
    { 144 ;   ;WithHolding Tax G/L ;Code10        ;TableRelation="G/L Account" }
    { 145 ;   ;Members Cutoff Period;DateFormula   }
    { 146 ;   ;Minimum Share Capital;Decimal       }
    { 147 ;   ;Express Loan Charge ;Decimal        }
    { 148 ;   ;ESS Interest%       ;Decimal        }
    { 149 ;   ;Deposits Interest%  ;Decimal        }
    { 150 ;   ;Dividends Bal Account;Code15       ;TableRelation="G/L Account" }
    { 151 ;   ;Dividends Processing Fee;Decimal    }
    { 152 ;   ;Deposits Int  Bal Account;Code15   ;TableRelation="G/L Account" }
    { 153 ;   ;Deposits int Processing Fee;Decimal }
    { 154 ;   ;ESS Int  Bal Account;Code15        ;TableRelation="G/L Account" }
    { 155 ;   ;ESS int Processing Fee;Decimal      }
    { 156 ;   ;Dormancy Period     ;DateFormula    }
    { 157 ;   ;Coop-Shares Processing Fee;Decimal  }
    { 158 ;   ;Guarantorship Multiplier;Decimal    }
    { 159 ;   ;UFAA Duration       ;DateFormula    }
    { 160 ;   ;Savings Interest%   ;Decimal        }
    { 161 ;   ;Savings Bal Account ;Code15        ;TableRelation="G/L Account" }
    { 162 ;   ;Max SMS Charge Dividend Amount;Decimal }
    { 163 ;   ;BusinessGNos        ;Code10        ;TableRelation="No. Series" }
    { 164 ;   ;ReatNos             ;Code10        ;TableRelation="No. Series" }
    { 165 ;   ;Interest Capitalizing %;Decimal     }
    { 166 ;   ;Int Capitalizing Min Amount;Decimal }
    { 167 ;   ;Int Deduction Max Amount;Decimal    }
  }
  KEYS
  {
    {    ;Rec                                     ;Clustered=Yes }
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

