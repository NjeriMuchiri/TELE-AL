OBJECT table 17307 Denominations
{
  OBJECT-PROPERTIES
  {
    Date=05/11/16;
    Time=[ 5:27:49 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516486;
    DrillDownPageID=Page51516486;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code30        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text100        }
    { 3   ;   ;Value               ;Decimal        }
    { 4   ;   ;Type                ;Option        ;OptionString=Note,Coin }
    { 5   ;   ;Priority            ;Integer        }
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

