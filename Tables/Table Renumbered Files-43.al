OBJECT table 50062 HR Employee Requisitions
{
  OBJECT-PROPERTIES
  {
    Date=04/08/22;
    Time=11:36:48 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               //GENERATE DOCUMENT NUMBER
               IF "Requisition No." = '' THEN BEGIN
                 HRSetup.GET;
                 HRSetup.TESTFIELD(HRSetup."Employee Requisition Nos.");
                 NoSeriesMgt.InitSeries(HRSetup."Employee Requisition Nos.",xRec."No. Series",0D,"Requisition No.","No. Series");
               END;

               userSetup.RESET;
               userSetup.SETRANGE(userSetup."User ID",USERID);
               //IF userSetup.FIND('-') THEN BEGIN
                //mDivision:=userSetup."Global Dimension 2 Code";
                //mResponsibility:=userSetup."Responsibility Center";
               //END;

               //POPULATE FIELDS
               Requestor:=USERID;
               "Requisition Date":=TODAY;
               "Responsibility Center":=mResponsibility;
               "Global Dimension 2 Code":=mDivision;
             END;

    OnModify=BEGIN
               userSetup.RESET;
               userSetup.SETRANGE(userSetup."User ID",USERID);
               //IF userSetup.FIND('-') THEN BEGIN
                //mDivision:=userSetup."Global Dimension 1 Code";
                //mResponsibility:=userSetup."Responsibility Center";
               //END;
             END;

    OnDelete=BEGIN

               IF Status<>Status::New THEN
               ERROR('You cannot delete this record if its status is'+' '+FORMAT(Status));
             END;

    LookupPageID=Page51516885;
    DrillDownPageID=Page51516885;
  }
  FIELDS
  {
    { 2   ;   ;Job ID              ;Code20        ;TableRelation="HR Jobs"."Job ID";
                                                   OnValidate=BEGIN
                                                                HRJobs.RESET;
                                                                IF HRJobs.GET("Job ID") THEN BEGIN
                                                                  "Job Description":=HRJobs."Job Description";
                                                                  "Vacant Positions":=HRJobs."Vacant Positions";
                                                                  "Job Grade":=HRJobs.Grade;
                                                                  "Global Dimension 2 Code":=HRJobs."Global Dimension 2 Code";
                                                                  "Job Supervisor/Manager":=HRJobs."Supervisor/Manager";
                                                                  HRJobs."Responsibility Center":="Responsibility Center";
                                                                END;

                                                                HRJobs.RESET;
                                                                HRJobs.SETRANGE(HRJobs."Job ID","Job ID");
                                                                HRJobs.SETFILTER(HRJobs.Status,'<>%1',HRJobs.Status::Approved);
                                                                IF HRJobs.FIND('-') THEN BEGIN
                                                                  "Job ID":='';
                                                                  ERROR('The job position is not approved');
                                                                END;
                                                                  {
                                                                mDivision:='';
                                                                mResponsibility:='';

                                                                userSetup.RESET;
                                                                userSetup.SETRANGE(userSetup."User ID",USERID);
                                                                IF userSetup.FIND('-') THEN BEGIN
                                                                 mDivision:=userSetup."Global Dimension 2 Code";
                                                                 mResponsibility:=userSetup."Responsibility Center";
                                                                END;

                                                                HRJobs.RESET;
                                                                HRJobs.SETRANGE(HRJobs."Job ID","Job ID");
                                                                HRJobs.SETFILTER(HRJobs."Global Dimension 2 Code",'=%1',mDivision);
                                                                HRJobs.SETFILTER(HRJobs."Responsibility Center",'=%1',mResponsibility);
                                                                IF HRJobs.FIND('-') THEN
                                                                 BEGIN
                                                                //  message('success');
                                                                 END
                                                                ELSE BEGIN
                                                                  "Job ID":='';
                                                                  ERROR('The job position chosen is not in your division');
                                                                END;
                                                                      }
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Requisition Date    ;Date          ;OnValidate=BEGIN
                                                                IF (Rec."Requisition Date" - TODAY) < 0 THEN
                                                                 MESSAGE('Days in the past are not allowed');
                                                              END;
                                                               }
    { 4   ;   ;Priority            ;Option        ;OptionCaptionML=ENU=High,Medium,Low;
                                                   OptionString=High,Medium,Low }
    { 5   ;   ;Positions           ;Integer        }
    { 6   ;   ;Approved            ;Boolean       ;OnValidate=BEGIN
                                                                "Date Approved":=TODAY;
                                                              END;
                                                               }
    { 7   ;   ;Date Approved       ;Date           }
    { 8   ;   ;Job Description     ;Text200       ;Editable=No }
    { 9   ;   ;Stage               ;Code20        ;FieldClass=FlowFilter }
    { 10  ;   ;Score               ;Decimal       ;FieldClass=Normal }
    { 11  ;   ;Stage Code          ;Code20         }
    { 12  ;   ;Qualified           ;Boolean       ;FieldClass=Normal }
    { 13  ;   ;Job Supervisor/Manager;Code20       }
    { 14  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionClass='1,1,2' }
    { 17  ;   ;Turn Around Time    ;Integer       ;Editable=No }
    { 21  ;   ;Grace Period        ;Integer        }
    { 25  ;   ;Closed              ;Boolean       ;Editable=No }
    { 26  ;   ;Requisition Type    ;Option        ;OptionCaptionML=ENU=" ,Internal,External,Both";
                                                   OptionString=[ ,Internal,External,Both] }
    { 27  ;   ;Closing Date        ;Date           }
    { 28  ;   ;Status              ;Option        ;OptionCaptionML=ENU=New,Pending Approval,Approved,Canceled;
                                                   OptionString=New,Pending Approval,Approved,Canceled;
                                                   Editable=No }
    { 38  ;   ;Required Positions  ;Decimal       ;OnValidate=BEGIN
                                                                IF "Required Positions" > "Vacant Positions" THEN
                                                                BEGIN
                                                                    ERROR('Required positions exceed the total  no of Vacant Positions');
                                                                END;

                                                                IF "Required Positions" <= 0 THEN
                                                                BEGIN
                                                                    ERROR('Required positions cannot be Less Than or Equal to Zero');
                                                                END;
                                                              END;
                                                               }
    { 39  ;   ;Vacant Positions    ;Decimal       ;Editable=No }
    { 3949;   ;Reason for Request(Other);Text100   }
    { 3950;   ;Any Additional Information;Text100  }
    { 3958;   ;Job Grade           ;Text100       ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Grade));
                                                   Editable=No }
    { 3964;   ;Type of Contract Required;Code20   ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Contract Type)) }
    { 3965;   ;Reason For Request  ;Option        ;OptionString=New Vacancy,Replacement,Retirement,Retrenchment,Demise,Other }
    { 3966;   ;Requestor           ;Code50        ;Editable=No }
    { 3967;   ;No. Series          ;Code10         }
    { 3968;   ;Requisition No.     ;Code20         }
    { 3969;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center".Code }
    { 3970;   ;Shortlisting Comittee;Code20        }
    { 3971;   ;HR                  ;Boolean        }
    { 3972;   ;Company E-Mail      ;Text30         }
  }
  KEYS
  {
    {    ;Requisition No.                         ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Job ID,Job Description                   }
  }
  CODE
  {
    VAR
      HRSetup@1102755000 : Record 51516192;
      NoSeriesMgt@1102755001 : Codeunit 396;
      HRJobs@1102755002 : Record 51516100;
      HREmployeeReq@1102755003 : Record 51516184;
      userSetup@1000 : Record 91;
      mDivision@1001 : Code[50];
      mResponsibility@1002 : Code[50];

    BEGIN
    END.
  }
}

