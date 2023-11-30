OBJECT table 17302 Transaction Types
{
  OBJECT-PROPERTIES
  {
    Date=08/10/23;
    Time=[ 2:50:45 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516333;
    DrillDownPageID=Page51516333;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Type                ;Option        ;OptionCaptionML=ENU=Cash Deposit,Withdrawal,Cheque Deposit,ATM Cash Deposit,ATM Cheque Deposit,ATM Withdrawal,BOSA Receipt,BOSA Withdrawal,Bankers Cheque,Encashment,M-pesa;
                                                   OptionString=Cash Deposit,Withdrawal,Cheque Deposit,ATM Cash Deposit,ATM Cheque Deposit,ATM Withdrawal,BOSA Receipt,BOSA Withdrawal,Bankers Cheque,Encashment,M-pesa }
    { 5   ;   ;Account Type        ;Code20        ;TableRelation="Account Types-Saving Products" }
    { 6   ;   ;Has Schedule        ;Boolean        }
    { 7   ;   ;Transaction Category;Option        ;OptionString=General,Account Opening,Normal Cheques,Bankers Cheque }
    { 8   ;   ;Transaction Span    ;Option        ;OptionString=FOSA,BOSA }
    { 9   ;   ;Lower Limit         ;Decimal        }
    { 10  ;   ;Upper Limit         ;Decimal        }
    { 11  ;   ;Default Mode        ;Option        ;OptionCaptionML=ENU=Cash,Cheque;
                                                   OptionString=Cash,Cheque }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
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

