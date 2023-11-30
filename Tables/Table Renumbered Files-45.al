OBJECT table 50064 HR Applicant Qualifications
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=12:32:44 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DataCaptionFields=Employee No.;
    CaptionML=ENU=HR Applicant Qualifications;
    LookupPageID=Page53960;
    DrillDownPageID=Page53960;
  }
  FIELDS
  {
    { 1   ;   ;Application No      ;Code10        ;TableRelation="HR Job Applications"."Application No";
                                                   CaptionML=ENU=Application No }
    { 2   ;   ;Employee No.        ;Code20        ;CaptionML=ENU=Employee No.;
                                                   NotBlank=Yes }
    { 3   ;   ;Qualification Description;Code80   ;OnValidate=BEGIN
                                                                {
                                                                Qualifications.RESET;
                                                                Qualifications.SETRANGE(Qualifications.Code,"Qualification Description");
                                                                IF Qualifications.FIND('-') THEN
                                                                "Qualification Code":=Qualifications.Description;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Qualification Description;
                                                   NotBlank=Yes }
    { 4   ;   ;From Date           ;Date          ;CaptionML=ENU=From Date }
    { 5   ;   ;To Date             ;Date          ;CaptionML=ENU=To Date }
    { 6   ;   ;Type                ;Option        ;CaptionML=ENU=Type;
                                                   OptionCaptionML=ENU=" ,Internal,External,Previous Position";
                                                   OptionString=[ ,Internal,External,Previous Position] }
    { 7   ;   ;Description         ;Text30        ;CaptionML=ENU=Description }
    { 8   ;   ;Institution/Company ;Text30        ;CaptionML=ENU=Institution/Company }
    { 9   ;   ;Cost                ;Decimal       ;CaptionML=ENU=Cost;
                                                   AutoFormatType=1 }
    { 10  ;   ;Course Grade        ;Text30        ;CaptionML=ENU=Course Grade }
    { 11  ;   ;Employee Status     ;Option        ;CaptionML=ENU=Employee Status;
                                                   OptionCaptionML=ENU=Active,Inactive,Terminated;
                                                   OptionString=Active,Inactive,Terminated;
                                                   Editable=No }
    { 13  ;   ;Expiration Date     ;Date          ;CaptionML=ENU=Expiration Date }
    { 14  ;   ;Qualification Type  ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Contract Type));
                                                   NotBlank=No }
    { 15  ;   ;Qualification Code  ;Text200       ;TableRelation="HR Job Qualifications".Code WHERE (Qualification Type=FIELD(Qualification Type));
                                                   OnValidate=BEGIN
                                                                IF HRQualifications.GET("Qualification Type","Qualification Code") THEN
                                                                "Qualification Description":=HRQualifications.Description;
                                                              END;

                                                   NotBlank=Yes }
    { 16  ;   ;Score ID            ;Decimal        }
  }
  KEYS
  {
    {    ;Application No,Qualification Type,Qualification Code;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HRQualifications@1000000000 : Record 51516162;
      Applicant@1000000001 : Record 51516162;
      Position@1000000002 : Code[20];
      JobReq@1000000003 : Record 51516101;

    BEGIN
    END.
  }
}

