OBJECT table 17200 HR Leave Journal Batch
{
  OBJECT-PROPERTIES
  {
    Date=11/20/17;
    Time=10:06:49 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               LOCKTABLE;
               InsuranceJnlTempl.GET("Journal Template Name");
             END;

    OnDelete=BEGIN
               InsuranceJnlLine.SETRANGE("Employee No.","Journal Template Name");
               InsuranceJnlLine.SETRANGE("Line No.",Name);
               InsuranceJnlLine.DELETEALL(TRUE);
             END;

    OnRename=BEGIN
               InsuranceJnlLine.SETRANGE("Employee No.",xRec."Journal Template Name");
               InsuranceJnlLine.SETRANGE("Line No.",xRec.Name);
               WHILE InsuranceJnlLine.FIND('-') DO
                 InsuranceJnlLine.RENAME("Journal Template Name",Name,InsuranceJnlLine."Line No.");
             END;

    LookupPageID=Page51516875;
    DrillDownPageID=Page51516875;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code20       ;TableRelation="HR Leave Journal Template";
                                                   CaptionML=ENU=Journal Template Name;
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Code20        ;CaptionML=ENU=Name;
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=ENU=Description }
    { 4   ;   ;Reason Code         ;Code20        ;TableRelation="Reason Code";
                                                   OnValidate=BEGIN
                                                                IF "Reason Code" <> xRec."Reason Code" THEN BEGIN
                                                                  InsuranceJnlLine.SETRANGE("Employee No.","Journal Template Name");
                                                                  InsuranceJnlLine.SETRANGE("Line No.",Name);
                                                                  InsuranceJnlLine.MODIFYALL("Reason Code","Reason Code");
                                                                  MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Reason Code }
    { 5   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF ("No. Series" <> '') AND ("No. Series" = "Posting No. Series") THEN
                                                                  VALIDATE("Posting No. Series",'');
                                                              END;

                                                   CaptionML=ENU=No. Series }
    { 6   ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                                                                  FIELDERROR("Posting No. Series",STRSUBSTNO(Text000,"Posting No. Series"));
                                                                InsuranceJnlLine.SETRANGE("Employee No.","Journal Template Name");
                                                                InsuranceJnlLine.SETRANGE("Line No.",Name);
                                                                InsuranceJnlLine.MODIFYALL("Posting No. Series","Posting No. Series");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=ENU=Posting No. Series }
    { 18  ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                {
                                                                //"Test Report ID" := REPORT::"General Journal - Test";
                                                                //"Posting Report ID" := REPORT::"G/L Register";
                                                                SourceCodeSetup.GET;
                                                                CASE Type OF
                                                                  Type::Positive:
                                                                    BEGIN
                                                                      "Source Code" := SourceCodeSetup."Leave Journal";
                                                                      "Form ID" :=  PAGE::"HR Leave Journal Lines";
                                                                    END;
                                                                  Type::Negative:
                                                                    BEGIN
                                                                      "Source Code" := SourceCodeSetup."Leave Journal";
                                                                      "Form ID" := PAGE::"HR Leave Journal Lines";
                                                                    END;
                                                                END;
                                                                }
                                                              END;

                                                   OptionCaptionML=ENU=Positive,Negative;
                                                   OptionString=Positive,Negative }
    { 19  ;   ;Posting Description ;Text50         }
  }
  KEYS
  {
    {    ;Journal Template Name,Name              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=must not be %1';
      InsuranceJnlTempl@1001 : Record 51516195;
      InsuranceJnlLine@1002 : Record 51516197;

    PROCEDURE SetupNewBatch@3();
    BEGIN
      InsuranceJnlTempl.GET("Journal Template Name");
      "No. Series" := InsuranceJnlTempl."No. Series";
      "Posting No. Series" := InsuranceJnlTempl."Posting No. Series";
      "Reason Code" := InsuranceJnlTempl."Reason Code";
    END;

    BEGIN
    END.
  }
}

