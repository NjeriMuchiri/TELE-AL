OBJECT table 50027 Coop ATM Transaction
{
  OBJECT-PROPERTIES
  {
    Date=03/23/23;
    Time=10:23:44 PM;
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    LookupPageID=Page170041;
    DrillDownPageID=Page170041;
  }
  FIELDS
  {
    { 1   ;   ;Transaction ID      ;Code50         }
    { 2   ;   ;Service Name        ;Text50         }
    { 3   ;   ;Transaction Date    ;Date           }
    { 4   ;   ;Transaction Time    ;Time           }
    { 5   ;   ;Terminal ID         ;Text50         }
    { 6   ;   ;Channel             ;Text30         }
    { 7   ;   ;Sacco Account       ;Code50         }
    { 8   ;   ;Member Account      ;Code20         }
    { 9   ;   ;Institution Code    ;Code50         }
    { 10  ;   ;Institution Name    ;Text100        }
    { 11  ;   ;Commission          ;Decimal        }
    { 12  ;   ;Commission Currency ;Code20         }
    { 13  ;   ;Fee Charged         ;Decimal        }
    { 14  ;   ;Fee Currency        ;Code20         }
    { 15  ;   ;Description 1       ;Text50         }
    { 16  ;   ;Activity            ;Option        ;OptionCaptionML=ENU=" ,Balance Enquiry,Funds Transfer,MiniStatement,Reversal";
                                                   OptionString=[ ,Balance Enquiry,Funds Transfer,MiniStatement,Reversal] }
    { 17  ;   ;Amount              ;Decimal        }
    { 18  ;   ;Posted              ;Boolean        }
    { 19  ;   ;Date Posted         ;Date           }
    { 20  ;   ;Time Posted         ;Time           }
    { 21  ;   ;Posted By           ;Code50         }
    { 22  ;   ;Reversed            ;Boolean        }
    { 23  ;   ;Date Reversed       ;Date           }
    { 24  ;   ;Time Reversed       ;Time           }
    { 25  ;   ;Reversed By         ;Code50         }
    { 26  ;   ;Reversal ID         ;Code50         }
    { 27  ;   ;Transaction Type    ;Code20         }
    { 28  ;   ;Transaction Name    ;Text50         }
    { 29  ;   ;Description 2       ;Text50         }
    { 30  ;   ;Original Transaction ID;Code50      }
    { 31  ;   ;Amount Currency     ;Code10         }
    { 32  ;   ;ATM No.             ;Text30         }
    { 33  ;   ;Document No.        ;Code20         }
    { 34  ;   ;Channel Code        ;Code10         }
    { 35  ;   ;Terminal Code       ;Code10         }
    { 36  ;   ;Total Account Debit ;Decimal        }
    { 37  ;   ;Total Charges       ;Decimal        }
    { 38  ;   ;Coop Fee            ;Decimal        }
    { 39  ;   ;Sacco Fee           ;Decimal        }
    { 40  ;   ;Sacco Excise Duty   ;Decimal        }
    { 41  ;   ;Skipped             ;Boolean        }
    { 42  ;   ;Remarks             ;Text250        }
    { 43  ;   ;Name                ;Text200       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor.Name WHERE (No.=FIELD(Member Account))) }
    { 44  ;   ;PF No.              ;Code30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor."Staff No" WHERE (No.=FIELD(Member Account))) }
    { 45  ;   ;Device Type         ;Text100        }
    { 46  ;   ;Location            ;Text100        }
    { 47  ;   ;Conversion Rate     ;Decimal        }
    { 48  ;   ;Foreign Amount      ;Decimal        }
    { 49  ;   ;Posting Attempts    ;Integer        }
    { 50  ;   ;Session ID          ;Code20         }
    { 51  ;   ;Reconcillation Header;Code20        }
    { 52  ;   ;Reconcilled         ;Boolean        }
  }
  KEYS
  {
    {    ;Transaction ID,Transaction Type         ;Clustered=Yes }
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

