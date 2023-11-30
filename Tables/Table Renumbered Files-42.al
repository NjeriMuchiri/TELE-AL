OBJECT table 50061 HR Job Responsiblities
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=11:40:17 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55564;
    DrillDownPageID=Page55564;
  }
  FIELDS
  {
    { 2   ;   ;Job ID              ;Code50        ;TableRelation="HR Jobs"."Job ID" }
    { 3   ;   ;Responsibility Description;Text250  }
    { 4   ;   ;Remarks             ;Text150        }
    { 5   ;   ;Responsibility Code ;Code20        ;OnValidate=BEGIN
                                                                HRAppEvalArea.RESET;
                                                                HRAppEvalArea.SETRANGE(HRAppEvalArea."Assign To","Responsibility Code");
                                                                IF HRAppEvalArea.FIND('-') THEN
                                                                BEGIN
                                                                    "Responsibility Description":=HRAppEvalArea.Code;
                                                                END;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Job ID,Responsibility Code              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HRAppEvalArea@1102755000 : Record 51516107;

    BEGIN
    END.
  }
}

