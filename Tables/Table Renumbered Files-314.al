OBJECT table 20458 Sky Transactions
{
  OBJECT-PROPERTIES
  {
    Date=09/19/23;
    Time=[ 4:18:38 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Transaction ID      ;Code20         }
    { 3   ;   ;Transaction Date    ;Date          ;FieldClass=Normal }
    { 4   ;   ;Transaction Time    ;Time           }
    { 8   ;   ;Member Account      ;Code20         }
    { 11  ;   ;Vendor Commission   ;Decimal        }
    { 13  ;   ;Sacco Fee           ;Decimal        }
    { 15  ;   ;Description         ;Text50         }
    { 17  ;   ;Amount              ;Decimal        }
    { 18  ;   ;Posted              ;Boolean        }
    { 19  ;   ;Date Posted         ;Date           }
    { 20  ;   ;Time Posted         ;Time           }
    { 21  ;   ;Posted By           ;Code50         }
    { 22  ;   ;Reversed            ;Boolean        }
    { 23  ;   ;Date Reversed       ;Date           }
    { 24  ;   ;Time Reversed       ;Time           }
    { 25  ;   ;Reversed By         ;Code50         }
    { 26  ;   ;Reversal ID         ;Code20         }
    { 27  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=" ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime,T-Kash Loan Repayment,T-Kash Paybill,CoopDeposit";
                                                   OptionString=[ ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime,T-Kash Loan Repayment,T-Kash Paybill,CoopDeposit] }
    { 28  ;   ;Transaction Name    ;Text50         }
    { 32  ;   ;Session ID          ;Code20         }
    { 33  ;   ;Loan No.            ;Code20         }
    { 34  ;   ;Keyword             ;Code20         }
    { 35  ;   ;Mobile No.          ;Code20         }
    { 36  ;   ;Statement Max Rows  ;Integer        }
    { 37  ;   ;Statement Start Date;Date           }
    { 38  ;   ;Statement End Date  ;Date           }
    { 39  ;   ;Account to Check    ;Code20         }
    { 40  ;   ;Entry No.           ;GUID           }
    { 41  ;   ;Client Name         ;Text200        }
    { 42  ;   ;Paybill Member ID   ;Code20         }
    { 43  ;   ;Needs Change        ;Boolean        }
    { 44  ;   ;Changed By          ;Code50         }
    { 45  ;   ;Date Changed        ;Date           }
    { 46  ;   ;Interest Paid       ;Decimal        }
    { 47  ;   ;Principal Paid      ;Decimal        }
    { 50050;  ;MobileApp           ;Boolean        }
    { 50051;  ;Manually Inserted   ;Boolean        }
    { 50052;  ;Inserted By         ;Code50         }
    { 50053;  ;Date Inserted       ;Date           }
    { 50054;  ;Old Transaction Date;Date           }
    { 50055;  ;Savings Product     ;Code20         }
    { 50056;  ;Loan Product        ;Code20         }
    { 50057;  ;Date Captured       ;DateTime       }
    { 50058;  ;Paybill Account Entered;Code20      }
    { 50059;  ;Line Amount         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("MBanking Receipt Line".Amount WHERE (Receipt No.=FIELD(Transaction ID))) }
    { 50060;  ;Bosa Entry          ;Boolean        }
    { 50061;  ;Fosa Account        ;Code20         }
    { 50062;  ;Bosa Account        ;Code20         }
    { 50063;  ;Reconcilled         ;Boolean        }
    { 50064;  ;Found               ;Boolean        }
    { 50065;  ;Network Service Provider;Option    ;OptionString=Safaricom,Telkom }
    { 50066;  ;Posting Attempts    ;Integer        }
    { 50067;  ;Beneficiary Mobile Number;Text30    }
    { 50068;  ;Beneficiary Name    ;Text50         }
    { 50069;  ;Other Number        ;Boolean        }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Date Captured                            }
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

