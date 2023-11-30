OBJECT table 50100 HR Leave Journal Template
{
  OBJECT-PROPERTIES
  {
    Date=09/06/17;
    Time=[ 3:27:52 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               VALIDATE("Form ID");
             END;

    OnDelete=BEGIN
               InsuranceJnlLine.SETRANGE("Employee No.",Name);
               InsuranceJnlLine.DELETEALL(TRUE);
               InsuranceJnlBatch.SETRANGE("Journal Template Name",Name);
               InsuranceJnlBatch.DELETEALL;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Name                ;Code20        ;CaptionML=ENU=Name;
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text80        ;CaptionML=ENU=Description }
    { 5   ;   ;Test Report ID      ;Integer       ;TableRelation=Object.ID WHERE (Type=CONST(Report));
                                                   CaptionML=ENU=Test Report ID }
    { 6   ;   ;Form ID             ;Integer       ;TableRelation=Object.ID WHERE (Type=CONST(Page));
                                                   CaptionML=ENU=Form ID }
    { 7   ;   ;Posting Report ID   ;Integer       ;TableRelation=Object.ID WHERE (Type=CONST(Report));
                                                   CaptionML=ENU=Posting Report ID }
    { 8   ;   ;Force Posting Report;Boolean       ;CaptionML=ENU=Force Posting Report }
    { 10  ;   ;Source Code         ;Code20        ;TableRelation="Source Code";
                                                   OnValidate=BEGIN
                                                                InsuranceJnlLine.SETRANGE("Employee No.",Name);
                                                                InsuranceJnlLine.MODIFYALL("Source Code","Source Code");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=ENU=Source Code }
    { 11  ;   ;Reason Code         ;Code20        ;TableRelation="Reason Code";
                                                   CaptionML=ENU=Reason Code }
    { 13  ;   ;Test Report Name    ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                                                                Object ID=FIELD(Test Report ID)));
                                                   CaptionML=ENU=Test Report Name;
                                                   Editable=No }
    { 14  ;   ;Form Name           ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Page),
                                                                                                                Object ID=FIELD(Form ID)));
                                                   CaptionML=ENU=Form Name;
                                                   Editable=No }
    { 15  ;   ;Posting Report Name ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                                                                Object ID=FIELD(Posting Report ID)));
                                                   CaptionML=ENU=Posting Report Name;
                                                   Editable=No }
    { 16  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF ("No. Series" <> '') AND ("No. Series" = "Posting No. Series") THEN
                                                                  "Posting No. Series" := '';
                                                              END;

                                                   CaptionML=ENU=No. Series }
    { 17  ;   ;Posting No. Series  ;Code10        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                                                                  FIELDERROR("Posting No. Series",STRSUBSTNO(Text000,"Posting No. Series"));
                                                              END;

                                                   CaptionML=ENU=Posting No. Series }
  }
  KEYS
  {
    {    ;Name                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=must not be %1';
      InsuranceJnlLine@1001 : Record 51516197;
      InsuranceJnlBatch@1002 : Record 51516196;
      SourceCodeSetup@1003 : Record 242;

    BEGIN
    END.
  }
}

