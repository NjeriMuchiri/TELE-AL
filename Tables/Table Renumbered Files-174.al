OBJECT table 17292 Procurement Methods
{
  OBJECT-PROPERTIES
  {
    Date=04/07/16;
    Time=[ 1:00:47 PM];
    Modified=Yes;
    Version List=W/P;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Invite/Advertise date;Date          }
    { 4   ;   ;Invite/Advertise period;DateFormula }
    { 5   ;   ;Open tender period  ;Integer        }
    { 6   ;   ;Evaluate tender period;Integer      }
    { 7   ;   ;Committee period    ;Integer        }
    { 8   ;   ;Notification period ;Integer        }
    { 9   ;   ;Contract period     ;Integer        }
    { 11  ;   ;Planned Date        ;Date           }
    { 12  ;   ;Planned Days        ;DateFormula    }
    { 13  ;   ;Actual Days         ;DateFormula    }
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

