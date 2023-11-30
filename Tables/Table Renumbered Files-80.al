OBJECT table 50099 HR Calendar
{
  OBJECT-PROPERTIES
  {
    Date=09/06/17;
    Time=[ 3:28:54 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 2   ;   ;Year                ;Code10         }
    { 3   ;   ;Starts              ;Date           }
    { 4   ;   ;Ends                ;Date           }
    { 5   ;   ;Current             ;Boolean       ;Editable=No }
  }
  KEYS
  {
    {    ;Year                                    ;Clustered=Yes }
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

