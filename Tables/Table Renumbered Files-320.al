OBJECT table 20464 Credit Rating
{
  OBJECT-PROPERTIES
  {
    Date=03/14/22;
    Time=11:39:25 AM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               //ERROR('You cannot delete M-KAHAWA transactions.');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20         }
    { 2   ;   ;Document Date       ;Date           }
    { 3   ;   ;Loan Amount         ;Decimal        }
    { 5   ;   ;Date Entered        ;Date           }
    { 6   ;   ;Time Entered        ;Time           }
    { 7   ;   ;Entered By          ;Code100        }
    { 11  ;   ;Account No          ;Code20         }
    { 12  ;   ;Member No           ;Code20         }
    { 13  ;   ;Telephone No        ;Code20         }
    { 16  ;   ;Customer Name       ;Text150        }
    { 19  ;   ;Comments            ;Text250        }
    { 21  ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 25  ;   ;Next Loan Application Date;Date     }
    { 29  ;   ;Penalized           ;Boolean        }
    { 30  ;   ;Penalty Date        ;Date           }
    { 31  ;   ;Last Notification   ;Option        ;OptionString=[ ,1,2,3,4,5,6,7,8,9,10] }
    { 32  ;   ;Next Notification   ;Option        ;OptionString=[ ,1,2,3,4,5,6,7,8,9,10] }
    { 33  ;   ;Loan Product Type   ;Code20         }
    { 34  ;   ;New Rate            ;Boolean        }
    { 35  ;   ;Loan Limit          ;Decimal        }
    { 36  ;   ;Amount Recovered From BOSA;Decimal  }
    { 37  ;   ;Amount  Recovered From FOSA;Decimal }
    { 38  ;   ;Test Amount         ;Decimal        }
    { 39  ;   ;Deposits Recovered  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Defaulter Deposit Recovery"."Deposits Recovered" WHERE (Loan No.=FIELD(Loan No.))) }
    { 40  ;   ;Deposit Balance Cleared;Boolean     }
    { 59  ;   ;FOSA Balance        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(Account No)));
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;Deposits Refunded   ;Boolean        }
    { 61  ;   ;Dep. Refund. Updated By;Code50      }
    { 62  ;   ;Staff No.           ;Code20         }
    { 63  ;   ;Reversed            ;Boolean        }
    { 64  ;   ;Installments        ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loans Register".Installments WHERE (Loan  No.=FIELD(Loan No.))) }
    { 65  ;   ;End Date            ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loans Register"."Expected Date of Completion" WHERE (Loan  No.=FIELD(Loan No.))) }
    { 67  ;   ;AmountRecoveredFromShares;Decimal   }
  }
  KEYS
  {
    {    ;Loan No.                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ObjCustomers@1000000000 : Record 18;

    BEGIN
    END.
  }
}

