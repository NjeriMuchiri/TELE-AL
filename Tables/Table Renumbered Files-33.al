OBJECT table 50052 SMSAutomation
{
  OBJECT-PROPERTIES
  {
    Date=09/09/20;
    Time=[ 4:48:12 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry               ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;SERVICE NAME        ;Code20         }
    { 3   ;   ;StartTime           ;DateTime       }
    { 4   ;   ;RunTime             ;DateTime       }
    { 5   ;   ;No of Runs          ;Integer        }
  }
  KEYS
  {
    {    ;Entry                                   ;Clustered=Yes }
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

