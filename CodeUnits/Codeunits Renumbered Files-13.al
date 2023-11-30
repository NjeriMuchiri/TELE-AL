OBJECT CodeUnit 20377 Gen. Jnl.-Post Sacco
{
  OBJECT-PROPERTIES
  {
    Date=05/07/16;
    Time=12:46:27 PM;
    Modified=Yes;
    Version List=NAVW13.00;
  }
  PROPERTIES
  {
    TableNo=81;
    OnRun=BEGIN
            GenJnlLine.COPY(Rec);
            Code;
            Rec.COPY(GenJnlLine);
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=cannot be filtered when posting recurring journals';
      Text001@1001 : TextConst 'ENU=Do you want to post the journal lines?';
      Text002@1002 : TextConst 'ENU=There is nothing to post.';
      Text003@1003 : TextConst 'ENU=The journal lines were successfully posted.';
      Text004@1004 : TextConst 'ENU=The journal lines were successfully posted. You are now in the %1 journal.';
      GenJnlTemplate@1005 : Record 80;
      GenJnlLine@1006 : Record 81;
      GenJnlPostBatch@1007 : Codeunit 13;
      TempJnlBatchName@1008 : Code[10];

    LOCAL PROCEDURE Code@1();
    BEGIN
      WITH GenJnlLine DO BEGIN
        GenJnlTemplate.GET("Journal Template Name");
        GenJnlTemplate.TESTFIELD("Force Posting Report",FALSE);
        IF GenJnlTemplate.Recurring AND (GETFILTER("Posting Date") <> '') THEN
          FIELDERROR("Posting Date",Text000);

        //IF NOT CONFIRM(Text001,FALSE) THEN
          //EXIT;

        TempJnlBatchName := "Journal Batch Name";

        GenJnlPostBatch.RUN(GenJnlLine);

        IF "Line No." = 0 THEN
          MESSAGE(Text002)
        ELSE
        {
          IF TempJnlBatchName = "Journal Batch Name" THEN
            MESSAGE(Text003)
          ELSE
            MESSAGE(
              Text004,
              "Journal Batch Name");
        }
        IF NOT FIND('=><') OR (TempJnlBatchName <> "Journal Batch Name") THEN BEGIN
          RESET;
          FILTERGROUP(2);
          SETRANGE("Journal Template Name","Journal Template Name");
          SETRANGE("Journal Batch Name","Journal Batch Name");
          FILTERGROUP(0);
          "Line No." := 1;
        END;
      END;
    END;

    BEGIN
    END.
  }
}

