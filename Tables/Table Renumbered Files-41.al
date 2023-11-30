OBJECT table 50060 HR Job Requirements
{
  OBJECT-PROPERTIES
  {
    Date=03/03/17;
    Time=11:50:47 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Job Id              ;Code50        ;TableRelation="HR Jobs"."Job ID";
                                                   NotBlank=Yes }
    { 2   ;   ;Qualification Type  ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Contract Type));
                                                   NotBlank=No }
    { 3   ;   ;Qualification Code  ;Code30        ;TableRelation="HR Job Qualifications".Code WHERE (Qualification Type=FIELD(Qualification Type));
                                                   OnValidate=BEGIN
                                                                {.SETFILTER(Requirments."Qualification Type","Qualification Type");
                                                                Requirments.SETFILTER(Requirments.Code,"Qualification Code");
                                                                IF Requirments.FIND('-') THEN
                                                                 Qualification := Requirments.Description; }


                                                                IF HRQualifications.GET("Qualification Type","Qualification Code") THEN
                                                                "Qualification Description":=HRQualifications.Description;
                                                              END;

                                                   NotBlank=Yes;
                                                   Editable=Yes }
    { 6   ;   ;Priority            ;Option        ;OptionString=[ ,High,Medium,Low] }
    { 8   ;   ;Score ID            ;Decimal        }
    { 9   ;   ;Need code           ;Code10        ;TableRelation=Table0 }
    { 10  ;   ;Stage Code          ;Code10        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Stages)) }
    { 11  ;   ;Mandatory           ;Boolean        }
    { 12  ;   ;Desired Score       ;Decimal        }
    { 13  ;   ;Total (Stage)Desired Score;Decimal  }
    { 14  ;   ;Qualification Description;Text100   }
  }
  KEYS
  {
    {    ;Job Id,Qualification Type,Qualification Code;
                                                   SumIndexFields=Score ID;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HRQualifications@1102755000 : Record 51516619;

    BEGIN
    END.
  }
}

