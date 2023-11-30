OBJECT table 17211 HR Training Needs
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=11:13:33 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55635;
    DrillDownPageID=Page55635;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text200        }
    { 3   ;   ;Start Date          ;Date           }
    { 4   ;   ;End Date            ;Date           }
    { 5   ;   ;Duration Units      ;Option        ;OptionString=Hours,Days,Weeks,Months,Years }
    { 6   ;   ;Duration            ;Decimal       ;OnValidate=BEGIN
                                                                {BEGIN
                                                                IF (Duration <> 0) AND ("Start Date" <> 0D) THEN

                                                                "End Date" :=HRLeaveApp.DetermineLeaveReturnDate("Start Date",Duration);

                                                                //---------------------------------------------------------
                                                                "End Date":=CALCDATE('-1D',"End Date");
                                                                mDay:=0;
                                                                mDay:=DATE2DWY("End Date",1);
                                                                IF mDay=6 THEN "End Date":=CALCDATE('+2D',"End Date");
                                                                IF mDay=7 THEN "End Date":=CALCDATE('+1D',"End Date");
                                                                //---------------------------------------------------------
                                                                MODIFY;
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 7   ;   ;Cost Of Training    ;Decimal       ;OnValidate=BEGIN
                                                                {IF Posted THEN BEGIN
                                                                IF Duration <> xRec.Duration THEN BEGIN
                                                                MESSAGE('%1','You cannot change the costs after posting');
                                                                Duration := xRec.Duration;
                                                                END
                                                                END
                                                                }
                                                              END;
                                                               }
    { 8   ;   ;Location            ;Text100        }
    { 10  ;   ;Re-Assessment Date  ;Date           }
    { 12  ;   ;Need Source         ;Option        ;OptionCaptionML=ENU=Appraisal,Succesion,Training,Employee,Employee Skill Plan;
                                                   OptionString=Appraisal,Succesion,Training,Employee,Employee Skill Plan }
    { 13  ;   ;Provider            ;Code20        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN
                                                                         Vend.RESET;
                                                                         Vend.SETRANGE(Vend."No.",Provider);
                                                                         IF Vend.FIND('-') THEN BEGIN
                                                                            "Provider Name":=Vend.Name;
                                                                         END;
                                                              END;
                                                               }
    { 15  ;   ;Posted              ;Boolean       ;Editable=No }
    { 16  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionClass='1,1,1' }
    { 17  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionClass='1,1,2' }
    { 18  ;   ;Closed              ;Boolean       ;Editable=No }
    { 19  ;   ;Qualification Code  ;Code20        ;TableRelation="HR Job Qualifications".Code WHERE (Qualification Type=FIELD(Qualification Type));
                                                   OnValidate=BEGIN
                                                                                    HRQualifications.SETRANGE(HRQualifications.Code,"Qualification Code");
                                                                                    IF HRQualifications.FIND('-') THEN
                                                                                    "Qualification Description":=HRQualifications.Description;
                                                              END;
                                                               }
    { 20  ;   ;Qualification Type  ;Code30        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Qualification Type));
                                                   NotBlank=Yes }
    { 21  ;   ;Qualification Description;Text80    }
    { 22  ;   ;Training Applicants ;Integer        }
    { 23  ;   ;Training Applicants (Passed);Integer }
    { 24  ;   ;Training Applicants (Failed);Integer }
    { 25  ;   ;Provider Name       ;Text50         }
    { 26  ;   ;Job id              ;Code50        ;TableRelation="HR Jobs"."Job ID" }
    { 27  ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center".Code WHERE (Global Dimension 2 Code=FIELD(Global Dimension 2 Code)) }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HRLeaveApp@1102755000 : Record 51516191;
      HRQualifications@1102755001 : Record 51516162;
      Vend@1102755002 : Record 23;
      mDay@1000 : Integer;

    BEGIN
    END.
  }
}

