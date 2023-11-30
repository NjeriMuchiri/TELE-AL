OBJECT table 50041 Budget Committment
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 5:21:24 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Line No             ;Integer        }
    { 11  ;   ;Date                ;Date           }
    { 12  ;   ;Posting Date        ;Date           }
    { 13  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Grant Surrender,Cash Purchase;
                                                   OptionString=LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Grant Surrender,Cash Purchase }
    { 14  ;   ;Document No.        ;Code20         }
    { 15  ;   ;Amount              ;Decimal        }
    { 16  ;   ;Month Budget        ;Decimal        }
    { 17  ;   ;Month Actual        ;Decimal        }
    { 18  ;   ;Committed           ;Boolean        }
    { 19  ;   ;Committed By        ;Code50         }
    { 20  ;   ;Committed Date      ;Date           }
    { 21  ;   ;Committed Time      ;Time           }
    { 22  ;   ;Committed Machine   ;Text100        }
    { 23  ;   ;Cancelled           ;Boolean        }
    { 24  ;   ;Cancelled By        ;Code20         }
    { 25  ;   ;Cancelled Date      ;Date           }
    { 26  ;   ;Cancelled Time      ;Time           }
    { 27  ;   ;Cancelled Machine   ;Text100        }
    { 28  ;   ;Shortcut Dimension 1 Code;Code20    }
    { 29  ;   ;Shortcut Dimension 2 Code;Code20    }
    { 30  ;   ;Shortcut Dimension 3 Code;Code20    }
    { 31  ;   ;Shortcut Dimension 4 Code;Code20    }
    { 32  ;   ;G/L Account No.     ;Code20         }
    { 33  ;   ;Budget              ;Code20         }
    { 34  ;   ;Vendor/Cust No.     ;Code20         }
    { 35  ;   ;Type                ;Option        ;OptionString=[ ,Vendor,Customer] }
  }
  KEYS
  {
    {    ;Line No                                 ;Clustered=Yes }
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

