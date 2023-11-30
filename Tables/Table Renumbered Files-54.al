OBJECT table 50073 Absence Preferences
{
  OBJECT-PROPERTIES
  {
    Date=11/25/19;
    Time=[ 3:17:25 PM];
    Modified=Yes;
    Version List=HR ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Include Weekends    ;Boolean        }
    { 2   ;   ;Include Holidays    ;Boolean        }
    { 3   ;   ;Year-Start Date     ;Date           }
  }
  KEYS
  {
    {    ;Include Weekends,Include Holidays       ;Clustered=Yes }
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

