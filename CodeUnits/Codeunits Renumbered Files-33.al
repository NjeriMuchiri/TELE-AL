OBJECT CodeUnit 20397 LeaveJnlManagement
{
  OBJECT-PROPERTIES
  {
    Date=11/20/17;
    Time=12:46:04 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    Permissions=TableData 5633=imd,
                TableData 5634=imd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=Leave';
      Text001@1001 : TextConst 'ENU=Leave Journal';
      Text002@1002 : TextConst 'ENU=DEFAULT';
      Text003@1003 : TextConst 'ENU=Default Journal';
      OldInsuranceNo@1004 : Code[20];
      OldFANo@1005 : Code[20];
      OpenFromBatch@1006 : Boolean;

    PROCEDURE TemplateSelection@1(FormID@1003 : Integer;VAR InsuranceJnlLine@1002 : Record 51516197;VAR JnlSelected@1001 : Boolean);
    VAR
      InsuranceJnlTempl@1000 : Record 51516195;
    BEGIN
      JnlSelected := TRUE;

      InsuranceJnlTempl.RESET;
      InsuranceJnlTempl.SETRANGE("Form ID",FormID);

      CASE InsuranceJnlTempl.COUNT OF

         0:

        BEGIN
            InsuranceJnlTempl.RESET;
            InsuranceJnlTempl.SETRANGE(InsuranceJnlTempl.Name,Text000);
            IF InsuranceJnlTempl.FIND('-') THEN
             InsuranceJnlTempl.DELETEALL;

            InsuranceJnlTempl.INIT;
            InsuranceJnlTempl.Name := Text000;
            InsuranceJnlTempl.Description := Text001;
            InsuranceJnlTempl.VALIDATE("Form ID");
            InsuranceJnlTempl.INSERT;
            COMMIT;
          END;

        1:
          InsuranceJnlTempl.FIND('-');
        ELSE
          JnlSelected := PAGE.RUNMODAL(0,InsuranceJnlTempl) = ACTION::LookupOK;
      END;
      IF JnlSelected THEN BEGIN
        InsuranceJnlLine.FILTERGROUP := 2;
        InsuranceJnlLine.SETRANGE("Employee No.",InsuranceJnlTempl.Name);
        InsuranceJnlLine.FILTERGROUP := 0;
        IF OpenFromBatch THEN BEGIN
          InsuranceJnlLine."Employee No." := '';
          PAGE.RUN(InsuranceJnlTempl."Form ID",InsuranceJnlLine);
        END;
      END;
    END;

    PROCEDURE TemplateSelectionFromBatch@10(VAR InsuranceJnlBatch@1000 : Record 51516196);
    VAR
      InsuranceJnlLine@1002 : Record 51516197;
      InsuranceJnlTempl@1003 : Record 51516195;
      JnlSelected@1001 : Boolean;
    BEGIN
      OpenFromBatch := TRUE;
      InsuranceJnlTempl.GET(InsuranceJnlBatch."Journal Template Name");
      InsuranceJnlTempl.TESTFIELD("Form ID");
      InsuranceJnlBatch.TESTFIELD(Name);

      InsuranceJnlLine.FILTERGROUP := 2;
      InsuranceJnlLine.SETRANGE("Employee No.",InsuranceJnlTempl.Name);
      InsuranceJnlLine.FILTERGROUP := 0;

      InsuranceJnlLine."Employee No." := '';
      InsuranceJnlLine."Line No." := InsuranceJnlBatch.Name;
      PAGE.RUN(InsuranceJnlTempl."Form ID",InsuranceJnlLine);
    END;

    PROCEDURE OpenJournal@2(VAR CurrentJnlBatchName@1000 : Code[10];VAR InsuranceJnlLine@1001 : Record 51516197);
    BEGIN
      CheckTemplateName(InsuranceJnlLine.GETRANGEMAX("Employee No."),CurrentJnlBatchName);
      InsuranceJnlLine.FILTERGROUP := 2;
      InsuranceJnlLine.SETRANGE("Line No.",CurrentJnlBatchName);
      InsuranceJnlLine.FILTERGROUP := 0;
    END;

    PROCEDURE OpenJnlBatch@12(VAR InsuranceJnlBatch@1000 : Record 51516196);
    VAR
      InsuranceJnlTemplate@1002 : Record 51516195;
      InsuranceJnlLine@1004 : Record 51516197;
      JnlSelected@1003 : Boolean;
    BEGIN
      IF InsuranceJnlBatch.GETFILTER("Journal Template Name") <> '' THEN
        EXIT;
      InsuranceJnlBatch.FILTERGROUP(2);
      IF InsuranceJnlBatch.GETFILTER("Journal Template Name") <> '' THEN BEGIN
        InsuranceJnlBatch.FILTERGROUP(0);
        EXIT;
      END;
      InsuranceJnlBatch.FILTERGROUP(0);

      IF NOT InsuranceJnlBatch.FIND('-') THEN BEGIN
        IF NOT InsuranceJnlTemplate.FIND('-') THEN
          TemplateSelection(0,InsuranceJnlLine,JnlSelected);
        IF InsuranceJnlTemplate.FIND('-') THEN
          CheckTemplateName(InsuranceJnlTemplate.Name,InsuranceJnlBatch.Name);
      END;
      InsuranceJnlBatch.FIND('-');
      JnlSelected := TRUE;
      IF InsuranceJnlBatch.GETFILTER("Journal Template Name") <> '' THEN
         InsuranceJnlTemplate.SETRANGE(Name,InsuranceJnlBatch.GETFILTER("Journal Template Name"));
      CASE InsuranceJnlTemplate.COUNT OF
        1:
          InsuranceJnlTemplate.FIND('-');
        ELSE
          JnlSelected := PAGE.RUNMODAL(0,InsuranceJnlTemplate) = ACTION::LookupOK;
      END;
      IF NOT JnlSelected THEN
        ERROR('');

      InsuranceJnlBatch.FILTERGROUP(2);
      InsuranceJnlBatch.SETRANGE("Journal Template Name",InsuranceJnlTemplate.Name);
      InsuranceJnlBatch.FILTERGROUP(0);
    END;

    PROCEDURE CheckName@4(CurrentJnlBatchName@1000 : Code[10];VAR InsuranceJnlLine@1001 : Record 51516197);
    VAR
      InsuranceJnlBatch@1002 : Record 51516196;
    BEGIN
      InsuranceJnlBatch.GET(InsuranceJnlLine.GETRANGEMAX("Employee No."),CurrentJnlBatchName);
    END;

    PROCEDURE SetName@5(CurrentJnlBatchName@1000 : Code[10];VAR InsuranceJnlLine@1001 : Record 51516197);
    BEGIN
      InsuranceJnlLine.FILTERGROUP := 2;
      InsuranceJnlLine.SETRANGE("Line No.",CurrentJnlBatchName);
      InsuranceJnlLine.FILTERGROUP := 0;
      IF InsuranceJnlLine.FIND('-') THEN;
    END;

    PROCEDURE LookupName@6(VAR CurrentJnlBatchName@1000 : Code[10];VAR InsuranceJnlLine@1001 : Record 51516197) : Boolean;
    VAR
      InsuranceJnlBatch@1002 : Record 51516196;
    BEGIN
      COMMIT;

      InsuranceJnlBatch."Journal Template Name" := InsuranceJnlLine.GETRANGEMAX("Employee No.");
      InsuranceJnlBatch.Name := InsuranceJnlLine.GETRANGEMAX("Line No.");
      InsuranceJnlBatch.FILTERGROUP(2);
      InsuranceJnlBatch.SETRANGE("Journal Template Name",InsuranceJnlBatch."Journal Template Name");
      InsuranceJnlBatch.FILTERGROUP(0);
      IF PAGE.RUNMODAL(0,InsuranceJnlBatch) = ACTION::LookupOK THEN BEGIN
        CurrentJnlBatchName := InsuranceJnlBatch.Name;
        SetName(CurrentJnlBatchName,InsuranceJnlLine);
      END;
    END;

    PROCEDURE CheckTemplateName@3(CurrentJnlTemplateName@1000 : Code[10];VAR CurrentJnlBatchName@1001 : Code[10]);
    VAR
      InsuranceJnlBatch@1002 : Record 51516196;
    BEGIN
      IF NOT InsuranceJnlBatch.GET(CurrentJnlTemplateName,CurrentJnlBatchName) THEN BEGIN
        InsuranceJnlBatch.SETRANGE("Journal Template Name",CurrentJnlTemplateName);
        IF NOT InsuranceJnlBatch.FIND('-') THEN BEGIN
          InsuranceJnlBatch.INIT;
          InsuranceJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
          InsuranceJnlBatch.SetupNewBatch;
          InsuranceJnlBatch.Name := Text002;
          InsuranceJnlBatch.Description := Text003;
          InsuranceJnlBatch.INSERT(TRUE);
          COMMIT;
        END;
        CurrentJnlBatchName := InsuranceJnlBatch.Name;
      END;
    END;

    PROCEDURE GetDescriptions@7(InsuranceJnlLine@1000 : Record 51516197;VAR InsuranceDescription@1001 : Text[30];VAR FADescription@1002 : Text[30]);
    VAR
      Insurance@1003 : Record 51516191;
      FA@1004 : Record 51516160;
    BEGIN
      IF InsuranceJnlLine."Employee Status" <> OldInsuranceNo THEN BEGIN
        InsuranceDescription := '';
        IF InsuranceJnlLine."Employee Status" <> '' THEN
          IF Insurance.GET(InsuranceJnlLine."Employee Status") THEN
            InsuranceDescription := Insurance.Description;
        OldInsuranceNo := InsuranceJnlLine."Employee Status";
      END;
      IF InsuranceJnlLine.Type <> OldFANo THEN BEGIN
        FADescription := '';
        IF InsuranceJnlLine.Type <> '' THEN
          IF FA.GET(InsuranceJnlLine.Type) THEN
            FADescription := FA.County;
        OldFANo := FA.City;
      END;
    END;

    BEGIN
    END.
  }
}

