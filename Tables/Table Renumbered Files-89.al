OBJECT table 17207 Journal Line Dimension
{
  OBJECT-PROPERTIES
  {
    Date=11/20/17;
    Time=12:48:05 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF ("Dimension Value Code" = '') AND ("New Dimension Value Code" = '') THEN
                 ERROR(Text001,TABLECAPTION);

               GLSetup.GET;
               IF "Dimension Code" = GLSetup."Global Dimension 1 Code" THEN
                 UpdateGlobalDimCode(
                   1,"Table ID","Journal Template Name","Journal Batch Name",
                   "Journal Line No.","Allocation Line No.","Dimension Value Code"
                   ,"New Dimension Value Code");
               IF "Dimension Code" = GLSetup."Global Dimension 2 Code" THEN
                 UpdateGlobalDimCode(
                   2,"Table ID","Journal Template Name","Journal Batch Name",
                   "Journal Line No.","Allocation Line No.","Dimension Value Code"
                   ,"New Dimension Value Code");
             END;

    OnModify=BEGIN
               IF ("Dimension Value Code" = '') AND ("New Dimension Value Code" = '') THEN
                 ERROR(Text001,TABLECAPTION);

               GLSetup.GET;
               IF "Dimension Code" = GLSetup."Global Dimension 1 Code" THEN
                 UpdateGlobalDimCode(
                   1,"Table ID","Journal Template Name","Journal Batch Name",
                   "Journal Line No.","Allocation Line No.","Dimension Value Code",
                   "New Dimension Value Code");
               IF "Dimension Code" = GLSetup."Global Dimension 2 Code" THEN
                 UpdateGlobalDimCode(
                   2,"Table ID","Journal Template Name","Journal Batch Name",
                   "Journal Line No.","Allocation Line No.","Dimension Value Code"
                   ,"New Dimension Value Code");
             END;

    OnDelete=BEGIN
               GLSetup.GET;
               IF "Dimension Code" = GLSetup."Global Dimension 1 Code" THEN
                 UpdateGlobalDimCode(
                   1,"Table ID","Journal Template Name","Journal Batch Name",
                   "Journal Line No.","Allocation Line No.",'','');
               IF "Dimension Code" = GLSetup."Global Dimension 2 Code" THEN
                 UpdateGlobalDimCode(
                   2,"Table ID","Journal Template Name","Journal Batch Name",
                   "Journal Line No.","Allocation Line No.",'','');
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=ENU=Journal Line Dimension;
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;TableRelation=AllObj."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=ENU=Table ID;
                                                   NotBlank=Yes }
    { 2   ;   ;Journal Template Name;Code10       ;TableRelation=IF (Table ID=FILTER(81|221)) "Gen. Journal Template".Name
                                                                 ELSE IF (Table ID=CONST(83)) "Item Journal Template".Name
                                                                 ELSE IF (Table ID=CONST(89)) Table88.Field1
                                                                 ELSE IF (Table ID=CONST(207)) "Res. Journal Template".Name
                                                                 ELSE IF (Table ID=CONST(54334)) "Job-Journal Line"."Journal Template Name"
                                                                 ELSE IF (Table ID=CONST(246)) "Req. Wksh. Template".Name
                                                                 ELSE IF (Table ID=CONST(5621)) "FA Journal Template".Name
                                                                 ELSE IF (Table ID=CONST(5635)) "Insurance Journal Template".Name;
                                                   CaptionML=ENU=Journal Template Name }
    { 3   ;   ;Journal Batch Name  ;Code10        ;CaptionML=ENU=Journal Batch Name }
    { 4   ;   ;Journal Line No.    ;Integer       ;CaptionML=ENU=Journal Line No. }
    { 5   ;   ;Allocation Line No. ;Integer       ;CaptionML=ENU=Allocation Line No. }
    { 6   ;   ;Dimension Code      ;Code20        ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                IF NOT DimMgt.CheckDim("Dimension Code") THEN
                                                                  ERROR(DimMgt.GetDimErr);
                                                                "Dimension Value Code" := '';
                                                              END;

                                                   CaptionML=ENU=Dimension Code;
                                                   NotBlank=Yes }
    { 7   ;   ;Dimension Value Code;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension Code));
                                                   OnValidate=BEGIN
                                                                IF NOT DimMgt.CheckDimValue("Dimension Code","Dimension Value Code") THEN
                                                                  ERROR(DimMgt.GetDimErr);
                                                              END;

                                                   CaptionML=ENU=Dimension Value Code }
    { 8   ;   ;New Dimension Value Code;Code20    ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension Code));
                                                   OnValidate=BEGIN
                                                                IF NOT DimMgt.CheckDimValue("Dimension Code","New Dimension Value Code") THEN
                                                                  ERROR(DimMgt.GetDimErr);
                                                              END;

                                                   CaptionML=ENU=New Dimension Value Code }
  }
  KEYS
  {
    {    ;Table ID,Journal Template Name,Journal Batch Name,Journal Line No.,Allocation Line No.,Dimension Code;
                                                   Clustered=Yes }
    {    ;Dimension Code,Dimension Value Code     ;KeyGroups=Dim(Setup) }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You can''t rename a %1.';
      GLSetup@1001 : Record 98;
      DimMgt@1002 : Codeunit 408;
      Text001@1003 : TextConst 'ENU="At least one dimension value code must have a value. Enter a value or delete the %1. "';

    PROCEDURE UpdateGlobalDimCode@25(GlobalDimCodeNo@1000 : Integer;"Table ID"@1001 : Integer;"Journal Template Name"@1002 : Code[10];"Journal Batch Name"@1003 : Code[10];"Journal Line No."@1004 : Integer;"Allocation Line No."@1005 : Integer;NewDimValue@1006 : Code[20];NewNewDimValue@1007 : Code[20]);
    VAR
      GenJnlLine@1008 : Record 81;
      ItemJnlLine@1009 : Record 83;
      ResJnlLine@1014 : Record 207;
      JobJnlLine@1015 : Record 51516204;
      GenJnlAlloc@1016 : Record 221;
      ReqLine@1017 : Record 246;
      FAJnlLine@1018 : Record 5621;
      InsuranceJnlLine@1019 : Record 5635;
      PlanningComponent@1011 : Record 99000829;
      StdGenJnlLine@1012 : Record 751;
      StdItemJnlLine@1013 : Record 753;
    BEGIN
      CASE "Table ID" OF
        DATABASE::"Gen. Journal Line":
          BEGIN
            IF GenJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  GenJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  GenJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              GenJnlLine.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Item Journal Line":
          BEGIN
            IF ItemJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  BEGIN
                    ItemJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                    ItemJnlLine."New Shortcut Dimension 1 Code" := NewNewDimValue;
                  END;
                2:
                  BEGIN
                    ItemJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
                    ItemJnlLine."New Shortcut Dimension 2 Code" := NewNewDimValue;
                  END;
              END;
              ItemJnlLine.MODIFY(TRUE);
            END;
          END;
       {----------------denno DATABASE::"BOM Journal Line":
          BEGIN
            IF BOMJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  BOMJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  BOMJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              BOMJnlLine.MODIFY(TRUE);
            END;
          END;
          ----------------}
        DATABASE::"Res. Journal Line":
          BEGIN
            IF ResJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  ResJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  ResJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              ResJnlLine.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Job Journal Line":
          BEGIN
            IF JobJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  JobJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  JobJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              JobJnlLine.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Gen. Jnl. Allocation":
          BEGIN
            IF GenJnlAlloc.GET(
                 "Journal Template Name","Journal Batch Name","Journal Line No.","Allocation Line No.")
            THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  GenJnlAlloc."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  GenJnlAlloc."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              GenJnlAlloc.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Requisition Line":
          BEGIN
            IF ReqLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  ReqLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  ReqLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              ReqLine.MODIFY(TRUE);
            END;
          END;
        DATABASE::"FA Journal Line":
          BEGIN
            IF FAJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  FAJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  FAJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              FAJnlLine.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Insurance Journal Line":
          BEGIN
            IF InsuranceJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  InsuranceJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  InsuranceJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              InsuranceJnlLine.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Planning Component":
          BEGIN
            IF PlanningComponent.GET("Journal Template Name","Journal Batch Name","Journal Line No.","Allocation Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  PlanningComponent."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  PlanningComponent."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              PlanningComponent.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Standard General Journal Line":
          BEGIN
            IF StdGenJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  StdGenJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  StdGenJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              StdGenJnlLine.MODIFY(TRUE);
            END;
          END;
        DATABASE::"Standard Item Journal Line":
          BEGIN
            IF StdItemJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.") THEN BEGIN
              CASE GlobalDimCodeNo OF
                1:
                  StdItemJnlLine."Shortcut Dimension 1 Code" := NewDimValue;
                2:
                  StdItemJnlLine."Shortcut Dimension 2 Code" := NewDimValue;
              END;
              StdItemJnlLine.MODIFY(TRUE);
            END;
          END;
      END;
    END;

    BEGIN
    END.
  }
}

