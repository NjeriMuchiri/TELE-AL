OBJECT CodeUnit 20396 HR Leave Jnl.-Post Line
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 3:54:26 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    TableNo=51516410;
    Permissions=TableData 5629=rimd,
                TableData 5636=rimd;
    OnRun=BEGIN
            GLSetup.GET;
            TempJnlLineDim2.RESET;
            TempJnlLineDim2.DELETEALL;
            IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
              TempJnlLineDim2."Table ID" := DATABASE::"Insurance Journal Line";
              TempJnlLineDim2."Journal Template Name" := "Journal Template Name";
              TempJnlLineDim2."Journal Batch Name" := "Journal Batch Name";
              TempJnlLineDim2."Journal Line No." := "Line No.";
              TempJnlLineDim2."Dimension Code" := GLSetup."Global Dimension 1 Code";
              TempJnlLineDim2."Dimension Value Code" := "Shortcut Dimension 1 Code";
              TempJnlLineDim2.INSERT;
            END;
            IF "Shortcut Dimension 2 Code" <> '' THEN BEGIN
              TempJnlLineDim2."Table ID" := DATABASE::"HR Journal Line";
              TempJnlLineDim2."Journal Template Name" := "Journal Template Name";
              TempJnlLineDim2."Journal Batch Name" := "Journal Batch Name";
              TempJnlLineDim2."Journal Line No." := "Line No.";
              TempJnlLineDim2."Dimension Code" := GLSetup."Global Dimension 2 Code";
              TempJnlLineDim2."Dimension Value Code" := "Shortcut Dimension 1 Code";
              TempJnlLineDim2.INSERT;
            END;
            RunWithCheck(Rec,TempJnlLineDim2);
          END;

  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      FA@1001 : Record 51516160;
      Insurance@1002 : Record 51516191;
      InsuranceJnlLine@1003 : Record 51516410;
      InsCoverageLedgEntry@1004 : Record 51516201;
      InsCoverageLedgEntry2@1005 : Record 51516201;
      InsuranceReg@1006 : Record 51516205;
      InsuranceJnlCheckLine@1008 : CodeUnit 20395;
      MakeInsCoverageLedgEntry@1009 : CodeUnit 20400;
      DimMgt@1010 : Codeunit 408;
      NextEntryNo@1011 : Integer;
      TempJnlLineDim@1007 : Record 51516203;
      TempJnlLineDim2@1012 : Record 51516203;

    PROCEDURE RunWithCheck@3(VAR InsuranceJnlLine2@1000 : Record 51516410;TempJnlLineDim2@1001 : Record 51516203);
    BEGIN
      InsuranceJnlLine.COPY(InsuranceJnlLine2);
      TempJnlLineDim.RESET;
      TempJnlLineDim.DELETEALL;
      //DimMgt.CopyJnlLineDimToJnlLineDim(TempJnlLineDim2,TempJnlLineDim);
      Code(TRUE);
      InsuranceJnlLine2 := InsuranceJnlLine;
    END;

    PROCEDURE RunWithOutCheck@1(VAR InsuranceJnlLine2@1000 : Record 51516410;TempJnlLineDim@1001 : Record 51516203);
    BEGIN
      InsuranceJnlLine.COPY(InsuranceJnlLine2);

      TempJnlLineDim.RESET;
      TempJnlLineDim.DELETEALL;
      //DimMgt.CopyJnlLineDimToJnlLineDim(TempJnlLineDim2,TempJnlLineDim);

      Code(FALSE);
      InsuranceJnlLine2 := InsuranceJnlLine;
    END;

    LOCAL PROCEDURE Code@2(CheckLine@1000 : Boolean);
    BEGIN
      WITH InsuranceJnlLine DO BEGIN
        IF "Document No." = '' THEN
          EXIT;
        IF CheckLine THEN
      //    InsuranceJnlCheckLine.RunCheck(InsuranceJnlLine,TempJnlLineDim);
        Insurance.RESET;
        //Insurance.SETRANGE("Leave Application No.",
       // Insurance.GET("Document No.");
        FA.GET("Staff No.");
        MakeInsCoverageLedgEntry.CopyFromJnlLine(InsCoverageLedgEntry,InsuranceJnlLine);
        //MakeInsCoverageLedgEntry.CopyFromInsuranceCard(InsCoverageLedgEntry,Insurance);
      END;
      IF NextEntryNo = 0 THEN BEGIN
        InsCoverageLedgEntry.LOCKTABLE;
        IF InsCoverageLedgEntry2.FIND('+') THEN
          NextEntryNo := InsCoverageLedgEntry2."Entry No.";
        InsuranceReg.LOCKTABLE;
        IF InsuranceReg.FIND('+') THEN
          InsuranceReg."No." := InsuranceReg."No." + 1
        ELSE
          InsuranceReg."No." := 1;
        InsuranceReg.INIT;
        InsuranceReg."From Entry No." := NextEntryNo + 1;
        InsuranceReg."Creation Date" := TODAY;
        InsuranceReg."Source Code" := InsuranceJnlLine."Source Code";
        InsuranceReg."Journal Batch Name" := InsuranceJnlLine."Journal Batch Name";
        InsuranceReg."User ID" := USERID;
      END;
      NextEntryNo := NextEntryNo + 1;
      InsCoverageLedgEntry."Entry No." := NextEntryNo;
      InsCoverageLedgEntry.INSERT;
      {
      DimMgt.MoveJnlLineDimToLedgEntryDim(
        TempJnlLineDim,DATABASE::"Ins. Coverage Ledger Entry",
        InsCoverageLedgEntry."Entry No.");
      }
      IF InsuranceReg."To Entry No." = 0 THEN BEGIN
        InsuranceReg."To Entry No." := NextEntryNo;
        InsuranceReg.INSERT;
      END ELSE BEGIN
        InsuranceReg."To Entry No." := NextEntryNo;
        InsuranceReg.MODIFY;
      END;
    END;

    BEGIN
    END.
  }
}

