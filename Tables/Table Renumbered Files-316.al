OBJECT table 20460 Mobile Withdrawals Buffer
{
  OBJECT-PROPERTIES
  {
    Date=06/15/23;
    Time=10:17:22 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               //ERROR('You are not allowed to manually insert anything into this table');
             END;

    OnModify=BEGIN
               //ERROR('You are not allowed to modify anything in this table');
             END;

    OnDelete=BEGIN
               ERROR('You are not allowed to delete anything from this table');
             END;

    OnRename=BEGIN
               ERROR('You are not allowed to edit anything from this table');
             END;

    LookupPageID=Page51516707;
    DrillDownPageID=Page51516707;
  }
  FIELDS
  {
    { 1   ;   ;Trace ID            ;GUID           }
    { 2   ;   ;Posting Date        ;Date           }
    { 3   ;   ;Account No          ;Code20         }
    { 4   ;   ;Description         ;Text200        }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Posting S           ;Text50         }
    { 7   ;   ;Posted              ;Boolean        }
    { 8   ;   ;Unit ID             ;Code10         }
    { 9   ;   ;Transaction Type    ;Text30         }
    { 10  ;   ;Trans Time          ;Text50         }
    { 11  ;   ;Transaction Time    ;Time           }
    { 12  ;   ;Transaction Date    ;Date           }
    { 13  ;   ;Source              ;Option        ;OptionString=ATM,M-PESA }
    { 14  ;   ;Reversed            ;Boolean        }
    { 16  ;   ;Reversed Posted     ;Boolean       ;Editable=Yes }
    { 17  ;   ;Reversal Trace ID   ;Code20         }
    { 18  ;   ;Transaction Description;Text100     }
    { 19  ;   ;Withdrawal Location ;Text150        }
    { 20  ;   ;Entry No            ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 22  ;   ;Transaction Type Charges;Option    ;OptionCaptionML=ENU=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,Pos Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,Pos-cash Withdrawal,Pos-balance Enquiry,Pos-mini Statement,MINIMUM BALANCE,POS - Cash Withdrawal;
                                                   OptionString=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,Pos Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,Pos-cash Withdrawal,Pos-balance Enquiry,Pos-mini Statement,MINIMUM BALANCE,POS - Cash Withdrawal }
    { 23  ;   ;Card Acceptor Terminal ID;Code20    }
    { 24  ;   ;ATM Card No         ;Code20         }
    { 25  ;   ;Customer Names      ;Text100        }
    { 26  ;   ;Process Code        ;Code20         }
    { 27  ;   ;Is Coop Bank        ;Boolean        }
    { 28  ;   ;POS Vendor          ;Option        ;OptionCaptionML=ENU=ATM Lobby,Coop,Sacco;
                                                   OptionString=ATM Lobby,Coop,Sacco }
    { 29  ;   ;Session ID          ;Text100        }
    { 30  ;   ;Comments            ;Text100        }
    { 31  ;   ;Date Reversed       ;Date           }
    { 32  ;   ;Reversed By         ;Code50         }
    { 33  ;   ;Withdrawal Type     ;Text30         }
    { 34  ;   ;Beneficiary Mobile Number;Text30    }
    { 35  ;   ;Beneficiary Name    ;Text50         }
    { 36  ;   ;Other Number        ;Boolean        }
  }
  KEYS
  {
    {    ;Trace ID                                 }
    {    ;Entry No,Unit ID,Transaction Type,Posting S;
                                                   Clustered=Yes }
    { No ;Account No,Posted                       ;SumIndexFields=Amount }
    {    ;Transaction Date,Transaction Time        }
    {    ;Entry No                                 }
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

