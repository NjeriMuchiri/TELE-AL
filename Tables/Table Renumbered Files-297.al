OBJECT table 20441 Account Viewing Frequency
{
  OBJECT-PROPERTIES
  {
    Date=07/21/20;
    Time=12:11:35 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer        }
    { 2   ;   ;Account No          ;Code40         }
    { 3   ;   ;Account Name        ;Text60         }
    { 4   ;   ;Source              ;Option        ;OptionCaptionML=ENU=BOSA,FOSA,G/L ACCOUNT;
                                                   OptionString=BOSA,FOSA,G/L ACCOUNT }
    { 5   ;   ;Frequency           ;Integer        }
    { 6   ;   ;Date                ;Date           }
    { 7   ;   ;Time                ;Time           }
    { 8   ;   ;USERID              ;Code60         }
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

