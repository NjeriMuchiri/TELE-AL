OBJECT table 17204 HR Calendar List
{
  OBJECT-PROPERTIES
  {
    Date=09/06/17;
    Time=[ 3:43:40 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55640;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10         }
    { 2   ;   ;Day                 ;Text40        ;Editable=No }
    { 3   ;   ;Date                ;Date          ;Editable=No }
    { 4   ;   ;Non Working         ;Boolean       ;Editable=No }
    { 5   ;   ;Reason              ;Text40         }
  }
  KEYS
  {
    {    ;Code,Date,Day                           ;Clustered=Yes }
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

