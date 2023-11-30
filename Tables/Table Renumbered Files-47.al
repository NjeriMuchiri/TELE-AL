OBJECT table 50066 HR Appraisal Eval Areas
{
  OBJECT-PROPERTIES
  {
    Date=04/13/18;
    Time=[ 9:54:45 AM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Assign To           ;Code20        ;TableRelation="HR Jobs" }
    { 2   ;   ;Code                ;Code20        ;OnValidate=VAR
                                                                HRAppEvalAreas@1000000000 : Record 51516107;
                                                              BEGIN
                                                                HRAppEvalAreas.RESET;
                                                                HRAppEvalAreas.SETRANGE(HRAppEvalAreas.Code,Code);
                                                                IF HRAppEvalAreas.FIND('-') THEN
                                                                BEGIN
                                                                    ERROR('Code [%1] already exist, Please use another code',Code);
                                                                END;
                                                              END;

                                                   NotBlank=No }
    { 3   ;   ;Line No.            ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 4   ;   ;Categorize As       ;Option        ;OptionCaptionML=ENU=" ,Employee's Subordinates,Employee's Peers,External Sources,Job Specific,Self Evaluation";
                                                   OptionString=[ ,Employee's Subordinates,Employee's Peers,External Sources,Job Specific,Self Evaluation] }
    { 5   ;   ;Sub Category        ;Code100       ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Appraisal Subcategory));
                                                   OnValidate=BEGIN
                                                                HRLookup.RESET;
                                                                HRLookup.SETRANGE(HRLookup.Type,HRLookup.Type::"Appraisal Subcategory");
                                                                HRLookup.SETRANGE(HRLookup.Code,"Sub Category");
                                                                IF HRLookup.FIND('-') THEN BEGIN
                                                                  Description:=HRLookup.Description;

                                                                END;
                                                              END;
                                                               }
    { 6   ;   ;Description         ;Text250       ;NotBlank=No }
    { 7   ;   ;Include in Evaluation Form;Boolean  }
    { 8   ;   ;External Source Type;Option        ;OptionCaptionML=ENU=" ,Vendor,Customer";
                                                   OptionString=[ ,Vendor,Customer] }
    { 9   ;   ;External Source Code;Code10        ;TableRelation=IF (External Source Type=CONST(Customer)) Customer.No.
                                                                 ELSE IF (External Source Type=CONST(Vendor)) Vendor.No. }
    { 10  ;   ;External Source Name;Text100       ;FieldClass=Normal }
    { 11  ;   ;Assigned To         ;Text100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Jobs"."Job Description" WHERE (Job ID=FIELD(Assign To)));
                                                   Editable=No }
    { 12  ;   ;Blocked             ;Boolean        }
    { 13  ;   ;Appraisal Period    ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Appraisal Type),
                                                                                                Closed=CONST(No)) }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HRLookup@1000000000 : Record 51516163;

    BEGIN
    END.
  }
}

