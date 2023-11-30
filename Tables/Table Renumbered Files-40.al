OBJECT table 50059 HR Jobs
{
  OBJECT-PROPERTIES
  {
    Date=04/08/22;
    Time=10:03:32 AM;
    Modified=Yes;
    Version List=HR ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Job ID" = '' THEN
               BEGIN
                 HRSetup.GET;
                 HRSetup.TESTFIELD(HRSetup."Job Nos");
                 NoSeriesMgt.InitSeries(HRSetup."Job Nos",xRec."No series",0D,"Job ID","No series");
               END;

                "Date Created":=TODAY;
             END;

    OnModify=BEGIN
                "Vacant Positions" := "No of Posts" - "Occupied Positions";
             END;

    LookupPageID=Page51516882;
    DrillDownPageID=Page51516882;
  }
  FIELDS
  {
    { 1   ;   ;Job ID              ;Code60        ;NotBlank=Yes }
    { 2   ;   ;Job Description     ;Text250       ;Editable=Yes }
    { 3   ;   ;No of Posts         ;Integer       ;OnValidate=BEGIN
                                                                IF "No of Posts" <> xRec."No of Posts" THEN
                                                                "Vacant Positions" := "No of Posts" - "Occupied Positions";
                                                              END;
                                                               }
    { 4   ;   ;Position Reporting to;Code20       ;TableRelation="HR Jobs"."Job ID" WHERE (Status=CONST(Approved)) }
    { 5   ;   ;Occupied Positions  ;Integer       ;Editable=No }
    { 6   ;   ;Vacant Positions    ;Decimal       ;OnValidate=BEGIN
                                                                                 "Vacant Positions" := "No of Posts" - "Occupied Positions";
                                                              END;

                                                   Editable=No }
    { 7   ;   ;Score code          ;Code20         }
    { 8   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionClass='1,1,1' }
    { 9   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionClass='1,1,2' }
    { 17  ;   ;Total Score         ;Decimal       ;Editable=No }
    { 19  ;   ;Main Objective      ;Text250        }
    { 21  ;   ;Key Position        ;Boolean        }
    { 22  ;   ;Category            ;Code20         }
    { 23  ;   ;Grade               ;Code20         }
    { 24  ;   ;Employee Requisitions;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("HR Employee Requisitions") }
    { 27  ;   ;UserID              ;Code50         }
    { 28  ;   ;Supervisor/Manager  ;Code50        ;TableRelation="HR Employees".City WHERE (stat=CONST(" "));
                                                   OnValidate=BEGIN
                                                                                 HREmp.GET("Supervisor/Manager");
                                                                                 "Supervisor Name":=HREmp.County+''+HREmp."Home Phone Number"+''+HREmp."Post Code";
                                                              END;
                                                               }
    { 29  ;   ;Supervisor Name     ;Text60        ;Editable=No }
    { 30  ;   ;Status              ;Option        ;OptionString=New,Pending Approval,Approved,Rejected;
                                                   Editable=Yes }
    { 31  ;   ;Responsibility Center;Code10        }
    { 32  ;   ;Date Created        ;Date           }
    { 33  ;   ;No. of Requirements ;Integer       ;FieldClass=FlowField }
    { 34  ;   ;No. of Responsibilities;Integer    ;FieldClass=FlowField }
    { 44  ;   ;Is Supervisor       ;Boolean        }
    { 45  ;   ;G/L Account         ;Code50        ;TableRelation="G/L Account".No. }
    { 46  ;   ;No series           ;Code20         }
  }
  KEYS
  {
    {    ;Job ID                                  ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoOfPosts@1102755001 : Decimal;
      HREmp@1102755000 : Record 51516160;
      HRSetup@1000 : Record 51516192;
      NoSeriesMgt@1001 : Codeunit 396;

    BEGIN
    END.
  }
}

