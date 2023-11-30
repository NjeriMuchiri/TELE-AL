OBJECT CodeUnit 20393 HR Leave Jnl.-Post
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 3:57:50 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    TableNo=51516410;
    OnRun=BEGIN
            HRJournalLine.COPY(Rec);
            Code;
            Rec.COPY(HRJournalLine);
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=Do you want to post the journal lines?';
      Text001@1001 : TextConst 'ENU=There is nothing to post.';
      Text002@1002 : TextConst 'ENU=The journal lines were successfully posted.';
      Text003@1003 : TextConst 'ENU=The journal lines were successfully posted. You are now in the %1 journal.';
      HRLeaveJournalTemplate@1004 : Record 51516195;
      HRJournalLine@1005 : Record 51516410;
      HRLeaveJnlPostBatch@1006 : CodeUnit 20394;
      TempJnlBatchName@1007 : Code[10];

    LOCAL PROCEDURE Code@1();
    BEGIN
      WITH HRJournalLine DO BEGIN
        HRLeaveJournalTemplate.GET("Journal Template Name");
        HRLeaveJournalTemplate.TESTFIELD("Force Posting Report",FALSE);

        IF NOT CONFIRM(Text000,FALSE) THEN
          EXIT;

        TempJnlBatchName := "Journal Batch Name";

        HRLeaveJnlPostBatch.RUN(HRJournalLine);

        IF "Line No." = 0 THEN
          MESSAGE(Text001)
        ELSE
          IF TempJnlBatchName = "Journal Batch Name" THEN
            MESSAGE(Text002)
          ELSE
            MESSAGE(
              Text003,
              "Line No.");

        IF NOT FIND('=><') OR (TempJnlBatchName <> "Journal Batch Name") THEN BEGIN
          RESET;
          FILTERGROUP := 2;
          SETRANGE("Journal Template Name","Journal Template Name");
          SETRANGE("Journal Batch Name","Journal Batch Name");
          FILTERGROUP := 0;
          "Line No." := 1;
        END;
      END;
    END;

    BEGIN
    END.
  }
}

