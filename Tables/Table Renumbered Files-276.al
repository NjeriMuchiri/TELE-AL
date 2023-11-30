OBJECT table 20419 CRBA Datas
{
  OBJECT-PROPERTIES
  {
    Date=04/03/20;
    Time=[ 1:44:33 PM];
    Modified=Yes;
    Version List=CRB;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer        }
    { 2   ;   ;Name                ;Text100        }
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
    { 28  ;   ;Date Account Opened ;Date           }
    { 29  ;   ;Installment Due Date;Text30         }
    { 30  ;   ;Original Amount     ;Text30         }
    { 31  ;   ;Currency of Facility;Code10         }
    { 32  ;   ;Amonut in Kenya shillings;Text30   ;AutoFormatType=0 }
    { 33  ;   ;Current Balance     ;Text30         }
    { 34  ;   ;Overdue Balance     ;Text30         }
    { 35  ;   ;No of Days in Arreas;Integer        }
    { 36  ;   ;No of Installment In;Integer        }
    { 37  ;   ;Performing / NPL Indicator;Text30   }
    { 38  ;   ;Account Status      ;Code10         }
    { 39  ;   ;Account Status Date ;Text30         }
    { 40  ;   ;Repayment Period    ;Integer        }
    { 41  ;   ;Payment Frequency   ;Text30         }
    { 42  ;   ;Disbursement Date   ;Text30         }
    { 43  ;   ;Insallment Amount   ;Text30         }
    { 44  ;   ;Date of Latest Payment;Text30       }
    { 45  ;   ;Last Payment Amount ;Text30         }
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
    { 64  ;   ;Deferred Payment    ;Text30         }
    { 65  ;   ;Type of Security    ;Text30         }
    { 66  ;   ;Other Identification Code;Code30    }
    { 67  ;   ;Employer Industry Type;Text30       }
    { 68  ;   ;Overdue Date        ;Text30         }
    { 69  ;   ;Name 2              ;Text30         }
    { 70  ;   ;Name 3              ;Text30         }
    { 71  ;No ;Date A/C Opened     ;Text30         }
    { 72  ;   ;Account Opened Date ;Text30         }
    { 73  ;   ;[ Balance Outstanding];Text30       }
    { 74  ;   ;Outstanding Balance ;Text30         }
    { 75  ;   ;Trading as          ;Text30         }
    { 76  ;   ;Old Account Number  ;Code10         }
    { 77  ;   ;Passport Country Code;Code10        }
    { 78  ;   ;Type of Residency   ;Text30         }
    { 79  ;   ;Occupational Industry Type;Code10   }
    { 80  ;   ;Prudential Risk Classification;Text30 }
    { 81  ;   ;Next paymentamount  ;Text30         }
    { 82  ;   ;Group ID            ;Code30         }
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

