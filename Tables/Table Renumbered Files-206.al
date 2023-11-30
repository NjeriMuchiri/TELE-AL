OBJECT table 17326 ATM Log Entries
{
  OBJECT-PROPERTIES
  {
    Date=12/19/19;
    Time=[ 2:14:59 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;BigInteger    ;AutoIncrement=Yes;
                                                   Editable=No }
    { 2   ;   ;Date Time           ;DateTime       }
    { 3   ;   ;Account No          ;Code20         }
    { 4   ;   ;Amount              ;Decimal        }
    { 5   ;   ;ATM No              ;Code20         }
    { 6   ;   ;ATM Location        ;Text250        }
    { 7   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE;
                                                   OptionString=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE }
    { 8   ;   ;Return Code         ;Option        ;OptionString=Transaction Succeded,Insufficient Funds,Invalid Card,Card Blocked,Unspecified Error }
    { 9   ;   ;Trace ID            ;Code30         }
    { 13  ;   ;Account No.         ;Code20         }
    { 14  ;   ;Card No.            ;Code20         }
    { 15  ;   ;ATM Amount          ;Decimal        }
    { 16  ;   ;Withdrawal Location ;Text250        }
    { 50000;  ;Reference No        ;Text250        }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
    {    ;Date Time                                }
    {    ;Account No                               }
    {    ;Amount                                   }
    {    ;Transaction Type                         }
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

