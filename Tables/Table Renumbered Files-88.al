OBJECT table 17206 HR E-Mail Parameters
{
  OBJECT-PROPERTIES
  {
    Date=09/06/17;
    Time=[ 3:47:08 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Associate With      ;Option        ;CaptionML=ENU=Associate With;
                                                   OptionCaptionML=ENU=,Vacancy Advertisements,Interview Invitations,General,HR Jobs,Regret Notification,Reliever Notifications,Leave Notifications,Activity Notifications,Send Payslip Email;
                                                   OptionString=,Vacancy Advertisements,Interview Invitations,General,HR Jobs,Regret Notification,Reliever Notifications,Leave Notifications,Activity Notifications,Send Payslip Email }
    { 2   ;   ;Sender Name         ;Text30         }
    { 3   ;   ;Sender Address      ;Text30         }
    { 4   ;   ;Recipients          ;Text30         }
    { 5   ;   ;Subject             ;Text100        }
    { 6   ;   ;Body                ;Text100        }
    { 7   ;   ;Body 2              ;Text250        }
    { 8   ;   ;HTMLFormatted       ;Boolean        }
    { 9   ;   ;Body 3              ;Text250        }
    { 10  ;   ;Body 4              ;Text250        }
    { 11  ;   ;Body 5              ;Text250        }
  }
  KEYS
  {
    {    ;Associate With                          ;Clustered=Yes }
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

