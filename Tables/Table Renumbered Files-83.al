OBJECT table 17201 HR Employee Qualifications
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=[ 2:32:14 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DataCaptionFields=Employee No.;
    OnInsert=BEGIN
               Employee.GET("Employee No.");
               "Employee Status" := Employee.Status;
             END;

    OnDelete=BEGIN
               IF Comment THEN
                 ERROR(Text000);
             END;

    CaptionML=ENU=Employee Qualification;
    LookupPageID=Page5206;
    DrillDownPageID=Page5207;
  }
  FIELDS
  {
    { 1   ;   ;Employee No.        ;Code20        ;TableRelation="HR Employees".No.;
                                                   CaptionML=ENU=Employee No.;
                                                   NotBlank=Yes }
    { 2   ;   ;Line No.            ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=ENU=Line No. }
    { 4   ;   ;From Date           ;Date          ;CaptionML=ENU=From Date }
    { 5   ;   ;To Date             ;Date          ;CaptionML=ENU=To Date }
    { 6   ;   ;Type                ;Option        ;CaptionML=ENU=Type;
                                                   OptionCaptionML=ENU=" ,Internal,External,Previous Position";
                                                   OptionString=[ ,Internal,External,Previous Position] }
    { 7   ;   ;Description         ;Text100       ;CaptionML=ENU=Description }
    { 8   ;   ;Institution/Company ;Text30        ;CaptionML=ENU=Institution/Company }
    { 9   ;   ;Cost                ;Decimal       ;CaptionML=ENU=Cost;
                                                   AutoFormatType=1 }
    { 10  ;   ;Course Grade        ;Text30        ;CaptionML=ENU=Course Grade }
    { 11  ;   ;Employee Status     ;Option        ;CaptionML=ENU=Employee Status;
                                                   OptionCaptionML=ENU=Active,Inactive,Terminated;
                                                   OptionString=Active,Inactive,Terminated;
                                                   Editable=No }
    { 12  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Human Resource Comment Line" WHERE (Table Name=CONST(Employee Qualification),
                                                                                                          No.=FIELD(Employee No.),
                                                                                                          Table Line No.=FIELD(Line No.)));
                                                   CaptionML=ENU=Comment;
                                                   Editable=No }
    { 13  ;   ;Expiration Date     ;Date          ;CaptionML=ENU=Expiration Date }
    { 14  ;   ;Qualification Type  ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Qualification Type));
                                                   NotBlank=No }
    { 15  ;   ;Qualification Code  ;Code30        ;TableRelation="HR Job Qualifications".Code WHERE (Qualification Type=FIELD(Qualification Type));
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
    { 16  ;   ;Qualification Description;Text100   }
    { 50000;  ;Course of Study     ;Text70         }
  }
  KEYS
  {
    {    ;Employee No.,Line No.                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You cannot delete employee qualification information if there are comments associated with it.';
      HRLookupValues@1001 : Record 51516163;
      Employee@1002 : Record 51516160;
      HRQualifications@1102755000 : Record 51516197;

    BEGIN
    END.
  }
}

