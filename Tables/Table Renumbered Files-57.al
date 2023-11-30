OBJECT table 50076 HR Staff Movement
{
  OBJECT-PROPERTIES
  {
    Date=11/10/20;
    Time=12:23:10 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF No = '' THEN BEGIN
                 Setup.GET;
                 Setup.TESTFIELD(Setup."Staff Movement Nos");
                 NoSeriesMgt.InitSeries(Setup."Staff Movement Nos",xRec."No. Series",0D,No,"No. Series");
               END;

               "Captured By":=USERID;
               "Datime Captured":=CURRENTDATETIME;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code10        ;Editable=No }
    { 2   ;   ;Staff No            ;Code20        ;TableRelation="HR Employees";
                                                   OnValidate=VAR
                                                                HREmployee@1120054000 : Record 51516160;
                                                              BEGIN
                                                                HREmployee.GET("Staff No");
                                                                HREmployee.TESTFIELD(HREmployee."User ID");
                                                                TESTFIELD("Captured By",HREmployee."User ID");
                                                              END;
                                                               }
    { 3   ;   ;Staff Name          ;Text100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Employees"."First Name" WHERE (No.=FIELD(Staff No))) }
    { 4   ;   ;Category            ;Option        ;OptionString=Personal,Official }
    { 5   ;   ;Purpose             ;Text150        }
    { 6   ;   ;Location            ;Text100        }
    { 7   ;   ;Start Date          ;Date           }
    { 8   ;   ;End date            ;Date           }
    { 9   ;   ;Start Time          ;Time           }
    { 10  ;   ;End Time            ;Time           }
    { 11  ;   ;Back in Office On   ;DateTime      ;OnValidate=VAR
                                                                cnfm@1120054000 : TextConst 'ENU=This action will mark the card as completed and not edtable any more, do you want to proceed?';
                                                              BEGIN
                                                                TESTFIELD("Staff No");
                                                                TESTFIELD(Purpose);
                                                                TESTFIELD(Location);
                                                                TESTFIELD("Start Date");
                                                                TESTFIELD("End date");
                                                                TESTFIELD("Start Time");
                                                                TESTFIELD("End Time");
                                                                IF NOT CONFIRM(cnfm,FALSE) THEN
                                                                  ERROR('operation stopped by user');
                                                                Finalized := TRUE;
                                                                "DateTime Finalized":=CURRENTDATETIME;
                                                                "Finalized By":=USERID;
                                                              END;
                                                               }
    { 12  ;   ;Captured By         ;Code50        ;Editable=No }
    { 13  ;   ;No. Series          ;Code10        ;Editable=No }
    { 14  ;   ;Datime Captured     ;DateTime      ;Editable=No }
    { 15  ;   ;Last DateTime Updated;DateTime     ;Editable=No }
    { 16  ;   ;Finalized           ;Boolean       ;Editable=No }
    { 17  ;   ;DateTime Finalized  ;DateTime      ;Editable=No }
    { 18  ;   ;Finalized By        ;Code50        ;Editable=No }
    { 19  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Approved,Rejected;
                                                   OptionString=Open,Approved,Rejected }
    { 20  ;   ;Date Confirmed      ;DateTime      ;Editable=No }
    { 21  ;   ;Confirmed By        ;Code50        ;Editable=No }
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
      Setup@1120054001 : Record 51516192;
      NoSeriesMgt@1120054000 : Codeunit 396;

    PROCEDURE ConfirmRec@1120054000();
    VAR
      UserSetup@1120054000 : Record 91;
    BEGIN
      IF NOT CONFIRM('Approve this movement?',FALSE) THEN EXIT;

      TESTFIELD("Staff No");
      TESTFIELD(Purpose);
      TESTFIELD(Location);
      TESTFIELD("Start Date");
      TESTFIELD("End date");
      TESTFIELD(Finalized,TRUE);

      UserSetup.GET(USERID);
      UserSetup.TESTFIELD(UserSetup."HR Department");
      Status:=Rec.Status::Approved;
      Rec."DateTime Finalized":=CURRENTDATETIME;
      Rec."Finalized By":=USERID;
      MODIFY;

      MESSAGE('Record marked as finalized');
    END;

    BEGIN
    END.
  }
}

