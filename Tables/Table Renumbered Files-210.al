OBJECT table 17331 ATM Charges
{
  OBJECT-PROPERTIES
  {
    Date=05/07/16;
    Time=12:51:12 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE;
                                                   OptionString=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE }
    { 2   ;   ;Total Amount        ;Decimal        }
    { 3   ;   ;Sacco Amount        ;Decimal        }
    { 4   ;   ;Source              ;Option        ;OptionString=ATM,POS }
    { 5   ;   ;Atm Bank Settlement A/C;Code30     ;TableRelation="Bank Account" }
    { 6   ;   ;Atm Income A/c      ;Code30        ;TableRelation="G/L Account" }
  }
  KEYS
  {
    {    ;Transaction Type                        ;Clustered=Yes }
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

