OBJECT table 20408 Profitability Set up-Micro
{
  OBJECT-PROPERTIES
  {
    Date=08/02/16;
    Time=12:17:43 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    LookupPageID=Page51516838;
    DrillDownPageID=Page51516838;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10         }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Amount              ;Decimal        }
    { 4   ;   ;Type                ;Option        ;OptionCaptionML=ENU=Profitability,Business Expenses,Family Expenses;
                                                   OptionString=Profitability,Business Expenses,Family Expenses }
    { 5   ;   ;Code Type           ;Option        ;OptionCaptionML=ENU=" ,Purchase,Sales";
                                                   OptionString=[ ,Purchase,Sales] }
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

