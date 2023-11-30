OBJECT CodeUnit 20395 HR Leave Jnl.-Check Line
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 2:42:05 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    TableNo=51516410;
    OnRun=VAR
            TempJnlLineDim@1000 : TEMPORARY Record 51516203;
          BEGIN
            GLSetup.GET;

            IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
              TempJnlLineDim."Table ID" := DATABASE::"HR Journal Line";
              TempJnlLineDim."Journal Template Name" := "Journal Template Name";
              TempJnlLineDim."Journal Batch Name" := "Journal Batch Name";
              TempJnlLineDim."Journal Line No." := "Line No.";
              TempJnlLineDim."Dimension Code" := GLSetup."Global Dimension 1 Code";
              TempJnlLineDim."Dimension Value Code" := "Shortcut Dimension 1 Code";
              TempJnlLineDim.INSERT;
            END;
            IF "Shortcut Dimension 2 Code" <> '' THEN BEGIN
              TempJnlLineDim."Table ID" := DATABASE::"HR Employee Qualifications";
              TempJnlLineDim."Journal Template Name" := "Journal Template Name";
              TempJnlLineDim."Journal Batch Name" := "Journal Batch Name";
              TempJnlLineDim."Journal Line No." := "Line No.";
              TempJnlLineDim."Dimension Code" := GLSetup."Global Dimension 2 Code";
              TempJnlLineDim."Dimension Value Code" := "Shortcut Dimension 2 Code";
              TempJnlLineDim.INSERT;
            END;

            RunCheck(Rec,TempJnlLineDim);
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
      Text001@1001 : TextConst 'ENU=A dimension used in %1 %2, %3, %4 has caused an error. %5';
      GLSetup@1002 : Record 98;
      FASetup@1003 : Record 51516192;
      DimMgt@1004 : Codeunit 408;
      CallNo@1005 : Integer;
      Text002@1102755000 : TextConst 'ENU=The Posting Date Must be within the open leave periods';
      Text003@1102755001 : TextConst 'ENU=The Posting Date Must be within the allowed Setup date';
      LeaveEntries@1102755002 : Record 51516201;
      Text004@1102755003 : TextConst 'ENU=The Allocation of Leave days has been done for the period';

    PROCEDURE ValidatePostingDate@1102755000(VAR InsuranceJnlLine@1102755000 : Record 51516410);
    BEGIN
      WITH InsuranceJnlLine DO BEGIN
         IF "Leave Entry Type"="Leave Entry Type"::Negative THEN BEGIN
        TESTFIELD("Leave Period");
       END;
        TESTFIELD("Document No.");
        TESTFIELD("Posting Date");
        TESTFIELD("Staff No.");
        IF ("Posting Date"<"Leave Period Start Date") OR
           ("Posting Date">"Leave Period End Date")  THEN
          // ERROR(FORMAT(Text002));

      FASetup.GET();
      IF (FASetup."Leave Posting Period[FROM]"<>0D) AND (FASetup."Leave Posting Period[TO]"<>0D) THEN BEGIN
        IF ("Posting Date"<FASetup."Leave Posting Period[FROM]") OR
           ("Posting Date">FASetup."Leave Posting Period[TO]")  THEN
           ERROR(FORMAT(Text003));
      END;
      {
           LeaveEntries.RESET;
           LeaveEntries.SETRANGE(LeaveEntries."Leave Type","Leave Type Code");
          IF LeaveEntries.FIND('-') THEN BEGIN
       IF LeaveEntries."Leave Transaction Type"=LeaveEntries."Leave Transaction Type"::"Leave Allocation" THEN BEGIN
       IF (LeaveEntries."Posting Date"<"Leave Period Start Date") OR
           (LeaveEntries."Posting Date">"Leave Period End Date")  THEN
           ERROR(FORMAT(Text004));
                   END;
         END;
      }
      END;
    END;

    PROCEDURE RunCheck@2(VAR InsuranceJnlLine@1000 : Record 51516410;VAR JnlLineDim@1001 : Record 51516203);
    VAR
      TableID@1002 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      WITH InsuranceJnlLine DO BEGIN
         IF "Leave Entry Type"="Leave Entry Type"::Negative THEN BEGIN
      //  TESTFIELD("Leave Application No.");
       END;
        TESTFIELD("Document No.");
        TESTFIELD("Posting Date");
        TESTFIELD("Staff No.");
        CallNo := 1;

       { IF NOT DimMgt.CheckJnlLineDimComb(JnlLineDim) THEN
          ERROR(
            Text000,
            TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
            DimMgt.GetDimCombErr);
        }
      //  TableID[1] := DATABASE::Table56175;
        TableID[1] := DATABASE::"HR Journal Line";
        No[1] := "Leave Application No.";
       { IF NOT DimMgt.CheckJnlLineDimValuePosting(JnlLineDim,TableID,No) THEN
          IF "Line No." <> 0 THEN
            ERROR(
              Text001,
              TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
              DimMgt.GetDimValuePostingErr)
          ELSE
            ERROR(DimMgt.GetDimValuePostingErr); }
      END;
      ValidatePostingDate(InsuranceJnlLine);
    END;

    LOCAL PROCEDURE JTCalculateCommonFilters@1();
    BEGIN
    END;

    BEGIN
    END.
  }
}

