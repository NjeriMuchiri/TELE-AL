OBJECT table 17267 Simplified Accounts
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 5:50:59 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No             ;Code10         }
    { 2   ;   ;Code                ;Code10         }
    { 3   ;   ;Description         ;Text30         }
    { 4   ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=Current Asset,Current Liablity,Fixed Asset,Equity,Sales,Credit Sales;
                                                   OptionString=Current Asset,Current Liablity,Fixed Asset,Equity,Sales,Credit Sales }
    { 5   ;   ;Amount              ;Decimal        }
  }
  KEYS
  {
    {    ;Loan No,Code,Description                ;Clustered=Yes }
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

