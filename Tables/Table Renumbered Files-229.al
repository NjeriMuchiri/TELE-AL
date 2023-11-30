OBJECT table 20370 ATM Transactions 2
{
  OBJECT-PROPERTIES
  {
    Date=10/27/16;
    Time=[ 1:31:24 PM];
    Modified=Yes;
    Version List=ATM;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 2   ;   ;Account No          ;Code16        ;NotBlank=Yes;
                                                   Editable=No }
    { 3   ;   ;Processing Code     ;Text6         ;NotBlank=Yes;
                                                   Editable=No }
    { 4   ;   ;Transaction Amount  ;Text12        ;Editable=No }
    { 5   ;   ;Cardholder Billing  ;Text12        ;Editable=No }
    { 6   ;   ;Transmission Date Time;Text10      ;Editable=No }
    { 7   ;   ;Conversion Rate     ;Text8         ;Editable=No }
    { 8   ;   ;System Trace Audit No;Text6        ;Editable=No }
    { 9   ;   ;Date Time - Local   ;Text12        ;Editable=No }
    { 10  ;   ;Expiry Date         ;Text4         ;Editable=No }
    { 11  ;   ;POS Entry Mode      ;Text12        ;Editable=No }
    { 12  ;   ;Function Code       ;Text3         ;Editable=No }
    { 13  ;   ;POS Capture Code    ;Text4         ;Editable=No }
    { 14  ;   ;Transaction Fee     ;Text6         ;Editable=No }
    { 15  ;   ;Settlement Fee      ;Text3         ;Editable=No }
    { 16  ;   ;Settlement Processing Fee;Text250  ;Editable=No }
    { 17  ;   ;Acquiring Institution ID Code;Text250;
                                                   Editable=No }
    { 18  ;   ;Forwarding Institution ID Code;Text250;
                                                   Editable=No }
    { 19  ;   ;Transaction 2 Data  ;Text250       ;Editable=No }
    { 20  ;   ;Retrieval Reference No;Text12      ;Editable=No }
    { 21  ;   ;Authorisation ID Response;Text6    ;Editable=No }
    { 22  ;   ;Response Code       ;Text3         ;Editable=No }
    { 23  ;   ;Card Acceptor Terminal ID;Text8    ;Editable=No }
    { 24  ;   ;Card Acceptor ID Code;Text15       ;Editable=No }
    { 25  ;   ;Card Acceptor Name/Location;Text250;Editable=No }
    { 26  ;   ;Additional Data - Private;Text250  ;Editable=No }
    { 27  ;   ;Transaction Currency Code;Text3    ;Editable=No }
    { 28  ;   ;Settlement Currency Code;Text3     ;Editable=No }
    { 29  ;   ;Cardholder Billing Cur Code;Text3  ;Editable=No }
    { 30  ;   ;Response Indicator  ;Text250       ;Editable=No }
    { 31  ;   ;Service Indicator   ;Text250       ;Editable=No }
    { 32  ;   ;Replacement Amounts ;Text250       ;Editable=No }
    { 33  ;   ;Receiving Institution ID Code;Text250;
                                                   Editable=No }
    { 34  ;   ;Account Identification 2;Text250   ;Editable=No }
    { 35  ;   ;Status              ;Option        ;OptionString=Sent,Failed;
                                                   Editable=No }
    { 36  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,MINIMUM BALANCE;
                                                   OptionString=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,MINIMUM BALANCE;
                                                   Editable=No }
    { 37  ;   ;Bitmap - Hexadecimal;Text32        ;Editable=No }
    { 38  ;   ;Bitmap - Binary     ;Text128       ;Editable=No }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
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

