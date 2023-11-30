OBJECT table 20445 Approval Notification Setup
{
  OBJECT-PROPERTIES
  {
    Date=09/26/23;
    Time=12:19:22 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Approval ID         ;Code20         }
    { 2   ;   ;Sender ID           ;Code20         }
    { 3   ;   ;Employee Code       ;Code20         }
    { 4   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 5   ;   ;Email Sent          ;Boolean        }
    { 6   ;   ;Document No         ;Code50         }
    { 7   ;   ;Notification type   ;Option        ;OptionCaptionML=ENU=Send Approval,Approve Document,Reject Document;
                                                   OptionString=Send Approval,Approve Document,Reject Document }
    { 8   ;   ;Time Sent           ;Time           }
    { 9   ;   ;Date Sent           ;Date           }
  }
  KEYS
  {
    {    ;Approval ID                             ;Clustered=Yes }
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

