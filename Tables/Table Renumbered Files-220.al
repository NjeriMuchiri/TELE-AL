OBJECT table 17341 Bulk SMS Header
{
  OBJECT-PROPERTIES
  {
    Date=10/31/16;
    Time=12:55:52 PM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN


                 IF No = '' THEN BEGIN
                 NoSetup.GET;
                 NoSetup.TESTFIELD(NoSetup."SMS Request Series");
                 NoSeriesMgt.InitSeries(NoSetup."SMS Request Series",xRec."No. Series",0D,No,"No. Series");
                 END;

               "Date Entered":=TODAY;
               "Time Entered":=TIME;
               "Entered By":=USERID;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;NotBlank=No }
    { 2   ;   ;Date Entered        ;Date           }
    { 3   ;   ;Time Entered        ;Time           }
    { 4   ;   ;Entered By          ;Code150        }
    { 5   ;   ;SMS Type            ;Option        ;OptionString=Dimension,Telephone,Everyone }
    { 6   ;   ;SMS Status          ;Option        ;OptionString=Pending,Sent,Cancelled }
    { 7   ;   ;Status Date         ;Date           }
    { 8   ;   ;Status Time         ;Time           }
    { 9   ;   ;Status By           ;Code150        }
    { 10  ;   ;Message             ;Text250        }
    { 11  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 12  ;   ;Use Line Message    ;Boolean        }
    { 13  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 14  ;   ;SentToServer        ;Boolean        }
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
      NoSetup@1102755000 : Record 51516258;
      NoSeriesMgt@1102755001 : Codeunit 396;

    BEGIN
    END.
  }
}

