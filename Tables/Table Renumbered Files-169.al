OBJECT table 17287 Tracker applications History
{
  OBJECT-PROPERTIES
  {
    Date=09/01/15;
    Time=[ 9:38:04 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

                 IF No = '' THEN BEGIN
                 NoSetup.GET;
                 NoSetup.TESTFIELD(NoSetup."MPESA Application Nos");
                 NoSeriesMgt.InitSeries(NoSetup."MPESA Application Nos",xRec."No. Series",0D,No,"No. Series");
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

    LookupPageID=Page39004041;
    DrillDownPageID=Page39004041;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code30        ;TableRelation="Tracker applications".No }
    { 2   ;   ;Date Entered        ;Date           }
    { 3   ;   ;Time Entered        ;Time           }
    { 4   ;   ;Entered By          ;Code30         }
    { 5   ;   ;Document Serial No  ;Text50         }
    { 6   ;   ;Document Date       ;Date           }
    { 7   ;   ;Customer ID No      ;Code50         }
    { 8   ;   ;Customer Name       ;Text200        }
    { 9   ;   ;MPESA Mobile No     ;Text50        ;OnValidate=BEGIN
                                                                {StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"M-SACCO Approval");
                                                                IF StatusPermissions.FIND('-') THEN
                                                                ERROR('Approvers are not allowed to capture/modify application details.');
                                                                 }
                                                              END;
                                                               }
    { 10  ;   ;MPESA Corporate No  ;Code30         }
    { 11  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 12  ;   ;Comments            ;Text200        }
    { 13  ;   ;Rejection Reason    ;Text30         }
    { 14  ;   ;Date Approved       ;Date           }
    { 15  ;   ;Time Approved       ;Time           }
    { 16  ;   ;Approved By         ;Code30         }
    { 17  ;   ;Date Rejected       ;Date           }
    { 18  ;   ;Time Rejected       ;Time           }
    { 19  ;   ;Rejected By         ;Code30         }
    { 20  ;   ;Sent To Server      ;Option        ;OptionString=No,Yes }
    { 21  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 22  ;   ;1st Approval By     ;Code30         }
    { 23  ;   ;Date 1st Approval   ;Date           }
    { 24  ;   ;Time First Approval ;Time           }
    { 25  ;   ;Withdrawal Limit Code;Code20       ;TableRelation="MPESA Withdrawal Limits".Code;
                                                   OnValidate=BEGIN
                                                                WithdrawLimit.RESET;
                                                                WithdrawLimit.SETRANGE(WithdrawLimit.Code,"Withdrawal Limit Code");
                                                                IF WithdrawLimit.FIND('-') THEN BEGIN
                                                                WithdrawLimit.TESTFIELD(WithdrawLimit."Limit Amount");
                                                                "Withdrawal Limit Amount":=WithdrawLimit."Limit Amount";
                                                                END;
                                                              END;
                                                               }
    { 26  ;   ;Withdrawal Limit Amount;Decimal     }
    { 27  ;   ;Application Type    ;Option        ;OnValidate=BEGIN
                                                                IF "Application Type"="Application Type"::Initial THEN BEGIN
                                                                IF "Application No"<>'' THEN BEGIN
                                                                ERROR('Please ensure the application number field is blank if the application is not a change application.');
                                                                END;
                                                                END;
                                                              END;

                                                   OptionString=Initial,Change }
    { 28  ;   ;Application No      ;Code10        ;TableRelation="MPESA Applications".No WHERE (Status=CONST(Approved));
                                                   OnValidate=BEGIN
                                                                IF "Application Type"<>"Application Type"::Change THEN BEGIN
                                                                ERROR('The application must be a change application before selecting this option.');
                                                                END;

                                                                MPESAApp.RESET;
                                                                MPESAApp.SETRANGE(MPESAApp.No,"Application No");
                                                                IF MPESAApp.FIND('-') THEN BEGIN
                                                                "Old Telephone No":=MPESAApp."MPESA Mobile No";
                                                                "Document Serial No":=MPESAApp."Document Serial No";
                                                                "Customer ID No":=MPESAApp."Customer ID No";
                                                                "Customer Name":=MPESAApp."Customer Name";
                                                                END
                                                                ELSE BEGIN
                                                                "Old Telephone No":='';
                                                                END;

                                                                MPESAAppDetails.RESET;
                                                                MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                                                IF MPESAAppDetails.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                MPESAAppDetails.DELETE;
                                                                UNTIL MPESAAppDetails.NEXT=0
                                                                END;


                                                                MPESAAppDetails.RESET;
                                                                MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No","Application No");
                                                                IF MPESAAppDetails.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                MPESAAppDet2.RESET;
                                                                MPESAAppDet2.INIT;
                                                                MPESAAppDet2."Application No":=No;
                                                                MPESAAppDet2."Account Type":=MPESAAppDetails."Account Type";
                                                                MPESAAppDet2."Account No.":=MPESAAppDetails."Account No.";
                                                                MPESAAppDet2.Description:=MPESAAppDetails.Description;
                                                                MPESAAppDet2.INSERT;
                                                                UNTIL MPESAAppDetails.NEXT=0
                                                                END;
                                                              END;
                                                               }
    { 29  ;   ;Changed             ;Option        ;OptionString=No,Yes }
    { 30  ;   ;Date Changed        ;Date           }
    { 31  ;   ;Time Changed        ;Time           }
    { 32  ;   ;Changed By          ;Code30         }
    { 33  ;   ;Old Telephone No    ;Code30         }
    { 34  ;   ;I agree information is true;Boolean }
    { 35  ;   ;App Status          ;Option        ;OptionString=Pending,1st Approval,Approved,Rejected }
    { 36  ;   ;Responsibility Center;Code20       ;TableRelation="Responsibility Center BR" }
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
      WithdrawLimit@1102756002 : Record 39004042;
      StatusPermissions@1102755000 : Record 39004288;
      MPESAApp@1102755001 : Record 39004045;
      MPESAAppDetails@1102755002 : Record 39004044;
      MPESAAppDet2@1102755003 : Record 39004044;

    BEGIN
    END.
  }
}

