OBJECT table 50075 HR Lookup Values
{
  OBJECT-PROPERTIES
  {
    Date=02/02/23;
    Time=11:21:00 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF Type=Type::"Appraisal Type" THEN BEGIN
                 HrLookupValues.RESET;
                 HrLookupValues.SETRANGE(HrLookupValues.Type,HrLookupValues.Type::"Appraisal Type");
                 HrLookupValues.SETRANGE(HrLookupValues.Closed,FALSE);
                 IF HrLookupValues.FINDFIRST THEN
                   ERROR('Close the Appraisal Period %1',HrLookupValues.Code);
               END
             END;

    LookupPageID=Page51516888;
    DrillDownPageID=Page51516888;
  }
  FIELDS
  {
    { 1   ;   ;Type                ;Option        ;OptionCaptionML=ENU=Appraisal Subcategory,Religion,Language,Medical Scheme,Location,Contract Type,Qualification Type,Stages,Scores,Institution,Appraisal Type,Appraisal Period,Urgency,Succession,Security,Disciplinary Case Rating,Disciplinary Case,Disciplinary Action,Next of Kin,Country,Grade,Checklist Item,Appraisal Group Item,Transport Type,Grievance Cause,Grievance Outcome,Appraiser Recom,Department;
                                                   OptionString=Appraisal Subcategory,Religion,Language,Medical Scheme,Location,Contract Type,Qualification Type,Stages,Scores,Institution,Appraisal Type,Appraisal Period,Urgency,Succession,Security,Disciplinary Case Rating,Disciplinary Case,Disciplinary Action,Next of Kin,Country,Grade,Checklist Item,Appraisal Group Item,Transport Type,Grievance Cause,Grievance Outcome,Appraiser Recom,Department }
    { 2   ;   ;Code                ;Code70         }
    { 3   ;   ;Description         ;Text80         }
    { 4   ;   ;Remarks             ;Text250        }
    { 5   ;   ;Notice Period       ;Date           }
    { 6   ;   ;Closed              ;Boolean       ;OnValidate=BEGIN
                                                                "Last Date Modified":=TODAY;
                                                              END;
                                                               }
    { 7   ;   ;Contract Length     ;Integer        }
    { 8   ;   ;Current Appraisal Period;Boolean    }
    { 9   ;   ;Disciplinary Case Rating;Text30    ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Disciplinary Case Rating)) }
    { 10  ;   ;Disciplinary Action ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Disciplinary Action)) }
    { 14  ;   ;From                ;Date           }
    { 15  ;   ;To                  ;Date           }
    { 16  ;   ;Score               ;Decimal        }
    { 17  ;   ;Basic Salary        ;Decimal        }
    { 18  ;   ;To be cleared by    ;Code10        ;TableRelation="HR Lookup Values".Remarks }
    { 19  ;   ;Last Date Modified  ;Date           }
    { 20  ;   ;Supervisor Only     ;Boolean        }
    { 21  ;   ;Appraisal Stage     ;Option        ;OptionString=Target Setting,FirstQuarter,SecondQuarter,ThirdQuarter,EndYearEvaluation }
    { 22  ;   ;Previous Appraisal Code;Code70      }
    { 23  ;   ;Department          ;Code70         }
  }
  KEYS
  {
    {    ;Type,Code,Description                   ;Clustered=Yes }
    { No ;                                         }
    { No ;                                         }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HrLookupValues@1000000000 : Record 51516163;

    BEGIN
    END.
  }
}

