OBJECT table 50022 Checkoff Messages
{
  OBJECT-PROPERTIES
  {
    Date=02/02/23;
    Time=[ 4:10:44 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer        }
    { 2   ;   ;Client Code         ;Code40         }
    { 3   ;   ;Account No          ;Code40         }
    { 4   ;   ;Account Name        ;Text150        }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Message             ;Text250        }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
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

