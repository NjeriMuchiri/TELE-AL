OBJECT table 20494 CRBA Datas-New
{
  OBJECT-PROPERTIES
  {
    Date=04/03/20;
    Time=11:01:57 AM;
    Modified=Yes;
    Version List=CRB Management;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer        }
    { 2   ;   ;Surname             ;Text100        }
    { 3   ;   ;Date of Birth       ;Text30         }
    { 4   ;   ;Client Code         ;Code20         }
    { 5   ;   ;Account Number      ;Code20         }
    { 6   ;   ;Gender              ;Option        ;OptionCaptionML=ENU=Male,Female;
                                                   OptionString=Male,Female }
    { 7   ;   ;Nationality         ;Text30         }
    { 8   ;   ;Marital Status      ;Option        ;OptionCaptionML=ENU=" ,Single,Married,Devorced,Widower";
                                                   OptionString=[ ,Single,Married,Devorced,Widower] }
    { 9   ;   ;Primary Identification 1;Text30     }
    { 10  ;   ;Primary Identification 2;Text30     }
    { 11  ;   ;Mobile No           ;Text30         }
    { 12  ;   ;Work Telephone      ;Code50         }
    { 13  ;   ;Postal Address 1    ;Code100        }
    { 14  ;   ;Postal Address 2    ;Code100        }
    { 15  ;   ;Postal Location Town;Text30         }
    { 16  ;   ;Postal Location Country;Text30      }
    { 17  ;   ;Post Code           ;Code50         }
    { 18  ;   ;Physical Address 1  ;Text50         }
    { 19  ;   ;Physical Address 2  ;Text50         }
    { 20  ;   ;Location Town       ;Text50         }
    { 21  ;   ;Location Country    ;Text50         }
    { 22  ;   ;Date of Physical Address;Date       }
    { 23  ;   ;Customer Work Email ;Text100        }
    { 24  ;   ;Employer Name       ;Text30         }
    { 25  ;   ;Employment Type     ;Option        ;OptionCaptionML=ENU=" ,Affiliates, Embassies, Spouse, NGOs";
                                                   OptionString=[ ,Affiliates, Embassies, Spouse, NGOs] }
    { 26  ;   ;Account Type        ;Text30         }
    { 27  ;   ;Account Product Type;Code10         }
    { 28  ;   ;Date Account Opened ;Text30         }
    { 29  ;   ;Installment Due Date;Date           }
    { 30  ;   ;Original Amount     ;Text30         }
    { 31  ;   ;Currency of Facility;Code10         }
    { 32  ;   ;Amonut in Kenya shillings;Text30   ;AutoFormatType=0 }
    { 33  ;   ;Current Balance     ;Text30         }
    { 34  ;   ;Overdue Balance     ;Decimal        }
    { 35  ;   ;No of Days in Arreas;Integer        }
    { 36  ;   ;No of Installment In;Integer        }
    { 37  ;   ;Performing / NPL Indicator;Text30   }
    { 38  ;   ;Account Status      ;Code10         }
    { 39  ;   ;Account Status Date ;Text30         }
    { 40  ;   ;Repayment Period    ;Integer        }
    { 41  ;   ;Payment Frequency   ;Text30         }
    { 42  ;   ;Disbursement Date   ;Date           }
    { 43  ;   ;Insallment Amount   ;Decimal        }
    { 44  ;   ;Date of Latest Payment;Text30       }
    { 45  ;   ;Last Payment Amount ;Decimal        }
    { 46  ;   ;Forename 1          ;Text30         }
    { 47  ;   ;Forename 2          ;Text30         }
    { 48  ;   ;Forename 3          ;Text30         }
    { 49  ;   ;Salutation          ;Text30         }
    { 50  ;   ;Primary Identification code;Code30  }
    { 51  ;   ;Secondary Identification code;Code30 }
    { 52  ;   ;Other Identification Type;Text30    }
    { 53  ;   ;Home Telephone      ;Text30         }
    { 54  ;   ;Plot Number         ;Text30         }
    { 55  ;   ;PIN Number          ;Text30         }
    { 56  ;   ;Employment Date     ;Text30         }
    { 57  ;   ;Salary Band         ;Text30         }
    { 58  ;   ;Lenders Registered Name;Text30      }
    { 59  ;   ;Lenders Trading Name;Text30         }
    { 60  ;   ;Lenders Branch Name ;Text30         }
    { 61  ;   ;Lenders Branch Code ;Code30         }
    { 62  ;   ;Account Closure Reason;Text30       }
    { 63  ;   ;Deferred Payment Date;Text30        }
    { 64  ;   ;Deferred Payment    ;Decimal        }
    { 65  ;   ;Type of Security    ;Text30         }
    { 66  ;   ;Other Identification Code;Code30    }
    { 67  ;   ;Employer Industry Type;Text30       }
    { 68  ;   ;Overdue Date        ;Text30         }
    { 69  ;   ;Name 2              ;Text30         }
    { 70  ;   ;Name 3              ;Text30         }
    { 71  ;   ;Type of Residency   ;Text30         }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
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

