OBJECT table 50077 HR Meeting Rooms Bookings
{
  OBJECT-PROPERTIES
  {
    Date=02/17/23;
    Time=[ 6:10:19 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=VAR
               HRMeetingRoomsBookings@1120054000 : Record 51516165;
               Err_util@1120054001 : TextConst 'ENU=Please utilize document number %1, before proceeding';
             BEGIN
               HRMeetingRoomsBookings.RESET;
               HRMeetingRoomsBookings.SETRANGE(HRMeetingRoomsBookings."Entered By",USERID);
               HRMeetingRoomsBookings.SETRANGE(HRMeetingRoomsBookings.Status,HRMeetingRoomsBookings.Status::Open);
               IF HRMeetingRoomsBookings.FINDLAST THEN
                 ERROR(Err_util,HRMeetingRoomsBookings.No);

               IF No = '' THEN BEGIN
                 Setup.GET;
                 Setup.TESTFIELD(Setup."HR Meeting Nos");
                 NoSeriesMgt.InitSeries(Setup."HR Meeting Nos",xRec."No. Series",0D,No,"No. Series");
               END;

               "Entered By":=USERID;
               "DateTime Entered":=CURRENTDATETIME;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code10        ;Editable=No }
    { 2   ;   ;Room                ;Code10        ;TableRelation="HR Meeting Rooms";
                                                   OnValidate=VAR
                                                                MeetingRooms@1120054000 : Record 51516165;
                                                              BEGIN
                                                                TESTFIELD("Start Date");TESTFIELD("End Date");
                                                                TESTFIELD("Start Time");TESTFIELD("End Time");

                                                                MeetingRooms.RESET;
                                                                MeetingRooms.SETFILTER("Start Date",'>=%1',"Start Date");
                                                                MeetingRooms.SETFILTER("End Date",'<=%1',"End Date");
                                                                MeetingRooms.SETRANGE(Room,Room);
                                                                MeetingRooms.SETRANGE(Status,MeetingRooms.Status::Confirmed);
                                                                IF MeetingRooms.FINDFIRST THEN BEGIN
                                                                    IF (MeetingRooms."Start Time">="Start Time") AND (MeetingRooms."End Time"<="End Time") THEN
                                                                       ERROR('The room has been booked in the specified timeline!');
                                                                  END;
                                                              END;
                                                               }
    { 3   ;   ;Meeting Description ;Text150        }
    { 4   ;   ;Start Date          ;Date           }
    { 5   ;   ;End Date            ;Date           }
    { 6   ;   ;Start Time          ;Time           }
    { 7   ;   ;End Time            ;Time           }
    { 8   ;   ;Status              ;Option        ;OptionString=Open,Booked,Confirmed,Declined;
                                                   Editable=No }
    { 10  ;   ;DateTime Entered    ;DateTime      ;Editable=No }
    { 11  ;   ;Entered By          ;Code50        ;Editable=No }
    { 12  ;   ;Booked By           ;Code50        ;Editable=No }
    { 13  ;   ;Confirmed/Declined By;Code50       ;Editable=No }
    { 14  ;   ;Booked On           ;DateTime      ;Editable=No }
    { 15  ;   ;Confirmed/Declied On;DateTime      ;Editable=No }
    { 16  ;   ;No. Series          ;Code10        ;TableRelation="No. Series" }
    { 17  ;   ;Approval Status     ;Option        ;OptionCaptionML=ENU=Open,Pending Approval,Approved,Rejected,Canceled;
                                                   OptionString=Open,Pending Approval,Approved,Rejected,Canceled }
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
    VAR
      Setup@1120054000 : Record 51516192;
      NoSeriesMgt@1120054001 : Codeunit 396;
      Cnfm_room@1120054002 : TextConst 'ENU=Sure to %1 room %2 from %3 to %4?';
      UserSetup@1120054003 : Record 91;

    PROCEDURE BookRoom@1120054000();
    BEGIN
      IF NOT CONFIRM(Cnfm_room,FALSE,'book',Room,FORMAT("Start Date")+':'+FORMAT("Start Time"),
        FORMAT("End Date")+':'+FORMAT("End Time")) THEN EXIT;

      TESTFIELD(Room);
      TESTFIELD("Meeting Description");
      TESTFIELD("Start Date");
      TESTFIELD("End Date");
      TESTFIELD("Start Time");
      TESTFIELD("End Time");

      TESTFIELD(Status,Rec.Status::Open);
      Status:=Rec.Status::Booked;
      "Booked By":=USERID;
      "Booked On":=CURRENTDATETIME;
      MODIFY;

      MESSAGE('Room %1 booked successfully!',Room);
    END;

    PROCEDURE ConfirmRoom@1120054002();
    BEGIN
      IF NOT CONFIRM(Cnfm_room,FALSE,'confirm',Room,FORMAT("Start Date")+':'+FORMAT("Start Time"),
        FORMAT("End Date")+':'+FORMAT("End Time")) THEN EXIT;

      UserSetup.GET(USERID);
      UserSetup.TESTFIELD(UserSetup."HR Department");

      TESTFIELD(Status,Rec.Status::Booked);
      Status:=Rec.Status::Confirmed;
      "Confirmed/Declined By":=USERID;
      "Confirmed/Declied On":=CURRENTDATETIME;
      MODIFY;

      MESSAGE('Room %1 confirmed successfully!',Room);
    END;

    PROCEDURE DeclineRoom@1120054003();
    BEGIN
      IF NOT CONFIRM(Cnfm_room,FALSE,'decline',Room,FORMAT("Start Date")+':'+FORMAT("Start Time"),
        FORMAT("End Date")+':'+FORMAT("End Time")) THEN EXIT;

      UserSetup.GET(USERID);
      UserSetup.TESTFIELD(UserSetup."HR Department");

      TESTFIELD(Status,Rec.Status::Booked);
      Status:=Rec.Status::Declined;
      "Confirmed/Declined By":=USERID;
      "Confirmed/Declied On":=CURRENTDATETIME;
      MODIFY;

      MESSAGE('Room %1 declined!',Room);
    END;

    BEGIN
    END.
  }
}

