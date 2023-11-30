OBJECT table 50071 HR Employee Timesheet
{
  OBJECT-PROPERTIES
  {
    Date=10/11/15;
    Time=[ 1:55:55 PM];
    Modified=Yes;
    Version List=HR ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Employee No         ;Code20         }
    { 11  ;   ;Day                 ;Date           }
    { 12  ;   ;Period Month        ;Integer        }
    { 13  ;   ;Period Year         ;Integer        }
    { 14  ;   ;Start Time          ;Time           }
    { 15  ;   ;End Time            ;Time           }
  }
  KEYS
  {
    {    ;Employee No                             ;Clustered=Yes }
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

