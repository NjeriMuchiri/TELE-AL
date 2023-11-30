OBJECT table 17340 Change MPESA PIN No
{
  OBJECT-PROPERTIES
  {
    Date=04/05/16;
    Time=[ 2:07:16 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
                 IF No = '' THEN BEGIN
                 NoSetup.GET();
                 NoSetup.TESTFIELD(NoSetup."Change MPESA PIN Nos");
                 NoSeriesMgt.InitSeries(NoSetup."Change MPESA PIN Nos",xRec."No. Series",0D,No,"No. Series");
                 END;


               "Entered By":=USERID;
               "Date Entered":=TODAY;
               "Time Entered":=TIME;
             END;

    OnDelete=BEGIN
               IF Status<>Status::Open THEN BEGIN
               ERROR('You cannot delete the MPESA transaction because it has already been sent for first approval.');
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code30         }
    { 2   ;   ;Date Entered        ;Date           }
    { 3   ;   ;Time Entered        ;Time           }
    { 4   ;   ;Entered By          ;Code30         }
    { 5   ;   ;MPESA Application No;Code30        ;TableRelation="MPESA Applications".No WHERE (Status=CONST(Approved),
                                                                                                Sent To Server=CONST(Yes));
                                                   OnValidate=BEGIN
                                                                MPESAApp.RESET;
                                                                MPESAApp.SETRANGE(MPESAApp.No,"MPESA Application No");
                                                                IF MPESAApp.FIND('-') THEN BEGIN
                                                                "Customer ID No":=MPESAApp."Customer ID No";
                                                                "Customer Name":=MPESAApp."Customer Name";
                                                                "MPESA Mobile No":=MPESAApp."MPESA Mobile No";
                                                                "Document Date":=MPESAApp."Document Date";
                                                                "MPESA Corporate No":=MPESAApp."MPESA Corporate No";
                                                                END;
                                                              END;
                                                               }
    { 6   ;   ;Document Date       ;Date           }
    { 7   ;   ;Customer ID No      ;Code50         }
    { 8   ;   ;Customer Name       ;Text200        }
    { 9   ;   ;MPESA Mobile No     ;Text50         }
    { 10  ;   ;MPESA Corporate No  ;Code30         }
    { 11  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 12  ;   ;Comments            ;Text200        }
    { 13  ;   ;Rejection Reason    ;Text30         }
    { 14  ;   ;Date Sent           ;Date           }
    { 15  ;   ;Time Sent           ;Time           }
    { 16  ;   ;Sent By             ;Code30         }
    { 17  ;   ;Date Rejected       ;Date           }
    { 18  ;   ;Time Rejected       ;Time           }
    { 19  ;   ;Rejected By         ;Code30         }
    { 20  ;   ;Sent To Server      ;Option        ;OptionString=No,Yes }
    { 21  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 22  ;   ;MPESA Change Nos    ;Code10        ;TableRelation="No. Series" }
    { 23  ;   ;MPESA Application Nos;Code10       ;TableRelation="No. Series" }
    { 24  ;   ;Change MPESA PIN Nos;Code10        ;TableRelation="No. Series" }
    { 25  ;   ;App Status          ;Option        ;OptionCaptionML=ENU=Pending,New PIN Sent,Rejected;
                                                   OptionString=Pending,New PIN Sent,Rejected }
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
      NoSetup@1102756001 : Record 98;
      NoSeriesMgt@1102756000 : Codeunit 396;
      MPESAApp@1102756002 : Record 51516330;

    BEGIN
    END.
  }
}

