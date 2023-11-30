OBJECT table 50042 Budgeting Setup
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 4:39:04 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 2   ;   ;Job Nos.            ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Job Nos. }
    { 10  ;   ;Primary Key         ;Code10         }
    { 11  ;   ;Current Budget Code ;Code20        ;TableRelation="G/L Budget Name".Name }
    { 12  ;   ;Current Budget Start Date;Date      }
    { 13  ;   ;Current Budget End Date;Date        }
    { 14  ;   ;Budget Dimension 1 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                IF "Budget Dimension 1 Code" <> xRec."Budget Dimension 1 Code" THEN BEGIN
                                                                  IF Dim.CheckIfDimUsed("Budget Dimension 1 Code",9,Name,'',0) THEN
                                                                    ERROR(Text000,Dim.GetCheckDimErr);
                                                                  MODIFY;
                                                                  UpdateBudgetDim("Budget Dimension 1 Code",0);
                                                                END;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Budget Dimension 1 Code }
    { 15  ;   ;Budget Dimension 2 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                IF "Budget Dimension 2 Code" <> xRec."Budget Dimension 2 Code" THEN BEGIN
                                                                  IF Dim.CheckIfDimUsed("Budget Dimension 2 Code",10,Name,'',0) THEN
                                                                    ERROR(Text000,Dim.GetCheckDimErr);
                                                                  MODIFY;
                                                                  UpdateBudgetDim("Budget Dimension 2 Code",1);
                                                                END;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Budget Dimension 2 Code }
    { 16  ;   ;Budget Dimension 3 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                IF "Budget Dimension 3 Code" <> xRec."Budget Dimension 3 Code" THEN BEGIN
                                                                  IF Dim.CheckIfDimUsed("Budget Dimension 3 Code",11,Name,'',0) THEN
                                                                    ERROR(Text000,Dim.GetCheckDimErr);
                                                                  MODIFY;
                                                                  UpdateBudgetDim("Budget Dimension 3 Code",2);
                                                                END;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Budget Dimension 3 Code }
    { 17  ;   ;Budget Dimension 4 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                IF "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" THEN BEGIN
                                                                  IF Dim.CheckIfDimUsed("Budget Dimension 4 Code",12,Name,'',0) THEN
                                                                    ERROR(Text000,Dim.GetCheckDimErr);
                                                                  MODIFY;
                                                                  UpdateBudgetDim("Budget Dimension 4 Code",3);
                                                                END;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Budget Dimension 4 Code }
    { 18  ;   ;Budget Dimension 5 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                IF "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" THEN BEGIN
                                                                  IF Dim.CheckIfDimUsed("Budget Dimension 4 Code",12,Name,'',0) THEN
                                                                    ERROR(Text000,Dim.GetCheckDimErr);
                                                                  MODIFY;
                                                                  UpdateBudgetDim("Budget Dimension 4 Code",3);
                                                                END;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Budget Dimension 5 Code }
    { 19  ;   ;Budget Dimension 6 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                IF "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" THEN BEGIN
                                                                  IF Dim.CheckIfDimUsed("Budget Dimension 4 Code",12,Name,'',0) THEN
                                                                    ERROR(Text000,Dim.GetCheckDimErr);
                                                                  MODIFY;
                                                                  UpdateBudgetDim("Budget Dimension 4 Code",3);
                                                                END;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Budget Dimension 6 Code }
    { 20  ;   ;Analysis View Code  ;Code20        ;TableRelation="Analysis View".Code }
    { 21  ;   ;Dimension 1 Code    ;Code20        ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                TESTFIELD(Blocked,FALSE);
                                                                IF Dim.CheckIfDimUsed("Dimension 1 Code",13,'',Code,0) THEN
                                                                  ERROR(Text000,Dim.GetCheckDimErr);
                                                                ModifyDim(FIELDCAPTION("Dimension 1 Code"),"Dimension 1 Code",xRec."Dimension 1 Code");
                                                                MODIFY;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Dimension 1 Code }
    { 22  ;   ;Dimension 2 Code    ;Code20        ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                TESTFIELD(Blocked,FALSE);
                                                                IF Dim.CheckIfDimUsed("Dimension 2 Code",14,'',Code,0) THEN
                                                                  ERROR(Text000,Dim.GetCheckDimErr);
                                                                ModifyDim(FIELDCAPTION("Dimension 2 Code"),"Dimension 2 Code",xRec."Dimension 2 Code");
                                                                MODIFY;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Dimension 2 Code }
    { 23  ;   ;Dimension 3 Code    ;Code20        ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                TESTFIELD(Blocked,FALSE);
                                                                IF Dim.CheckIfDimUsed("Dimension 3 Code",15,'',Code,0) THEN
                                                                  ERROR(Text000,Dim.GetCheckDimErr);
                                                                ModifyDim(FIELDCAPTION("Dimension 3 Code"),"Dimension 3 Code",xRec."Dimension 3 Code");
                                                                MODIFY;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Dimension 3 Code }
    { 24  ;   ;Dimension 4 Code    ;Code20        ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                {
                                                                TESTFIELD(Blocked,FALSE);
                                                                IF Dim.CheckIfDimUsed("Dimension 4 Code",16,'',Code,0) THEN
                                                                  ERROR(Text000,Dim.GetCheckDimErr);
                                                                ModifyDim(FIELDCAPTION("Dimension 4 Code"),"Dimension 4 Code",xRec."Dimension 4 Code");
                                                                MODIFY;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Dimension 4 Code }
    { 25  ;   ;Mandatory           ;Boolean        }
    { 26  ;   ;Allow OverExpenditure;Boolean       }
    { 27  ;   ;Current Item Budget ;Code10        ;TableRelation="Item Budget Name".Name }
    { 28  ;   ;Budget Check Criteria;Option       ;OptionCaptionML=ENU=Current Month,Whole Year;
                                                   OptionString=Current Month,Whole Year }
    { 29  ;   ;Actual Source       ;Option        ;OnValidate=BEGIN
                                                                    IF "Actual Source"="Actual Source"::"G/L Entry" THEN BEGIN
                                                                        IF NOT CONFIRM('Changing to Actual Source type G/L Entry will result in deletion of all Actuals Continue?',TRUE,FALSE) THEN
                                                                          ERROR('Change to G/L Entry source cancelled');
                                                                        "Analysis View Code":='';
                                                                        "Dimension 1 Code":='';
                                                                        "Dimension 2 Code":='';
                                                                        "Dimension 3 Code":='';
                                                                        "Dimension 4 Code":='';
                                                                         MODIFY;
                                                                     END;
                                                              END;

                                                   OptionCaptionML=ENU=G/L Entry,Analysis View Entry;
                                                   OptionString=G/L Entry,Analysis View Entry }
    { 30  ;   ;Partial Budgetary Check;Boolean     }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

