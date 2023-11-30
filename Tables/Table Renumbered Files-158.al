OBJECT table 17276 Tarrif Header
{
  OBJECT-PROPERTIES
  {
    Date=08/19/13;
    Time=10:23:08 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20         }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Deposit,Withdrawal;
                                                   OptionString=Deposit,Withdrawal }
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

