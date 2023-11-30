OBJECT CodeUnit 20394 HR Leave Jnl.-Post Batch
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 3:50:22 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    TableNo=51516410;
    Permissions=TableData 56104=imd;
    OnRun=BEGIN
            InsuranceJnlLine.COPY(Rec);
            Code;
            Rec := InsuranceJnlLine;
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=cannot exceed %1 characters';
      Text001@1001 : TextConst 'ENU=Journal Batch Name    #1##########\\';
      Text002@1002 : TextConst 'ENU=Checking lines        #2######\';
      Text003@1003 : TextConst 'ENU=Posting lines         #3###### @4@@@@@@@@@@@@@';
      Text004@1004 : TextConst 'ENU=A maximum of %1 posting number series can be used in each journal.';
      InsuranceJnlLine@1005 : Record 51516410;
      InsuranceJnlTempl@1006 : Record 51516195;
      InsuranceJnlBatch@1007 : Record 51516196;
      InsuranceReg@1008 : Record 51516205;
      InsCoverageLedgEntry@1010 : Record 51516201;
      InsuranceJnlLine2@1011 : Record 51516410;
      InsuranceJnlLine3@1012 : Record 51516410;
      NoSeries@1013 : TEMPORARY Record 308;
      FAJnlSetup@1014 : Record 51516192;
      InsuranceJnlPostLine@1015 : CodeUnit 20396;
      InsuranceJnlCheckLine@1016 : CodeUnit 20395;
      NoSeriesMgt@1017 : Codeunit 396;
      NoSeriesMgt2@1018 : ARRAY [10] OF Codeunit 396;
      DimMgt@1019 : Codeunit 408;
      Window@1020 : Dialog;
      LineCount@1021 : Integer;
      StartLineNo@1022 : Integer;
      NoOfRecords@1023 : Integer;
      InsuranceRegNo@1024 : Integer;
      LastDocNo@1025 : Code[20];
      LastDocNo2@1026 : Code[20];
      LastPostedDocNo@1027 : Code[20];
      NoOfPostingNoSeries@1028 : Integer;
      PostingNoSeriesNo@1029 : Integer;

    PROCEDURE Code@1();
    VAR
      UpdateAnalysisView@1002 : Codeunit 410;
      JnlLineDim@1003 : Record 51516203;
      TempJnlLineDim@1001 : TEMPORARY Record 51516203;
    BEGIN
      WITH InsuranceJnlLine DO BEGIN
        SETRANGE("Journal Template Name","Journal Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");
        IF RECORDLEVELLOCKING THEN
          LOCKTABLE;

        InsuranceJnlTempl.GET("Journal Template Name");
        InsuranceJnlBatch.GET("Journal Template Name","Journal Batch Name");
        IF STRLEN(INCSTR(InsuranceJnlBatch.Name)) > MAXSTRLEN(InsuranceJnlBatch.Name) THEN
          InsuranceJnlBatch.FIELDERROR(
            Name,
            STRSUBSTNO(
              Text000,
              MAXSTRLEN(InsuranceJnlBatch.Name)));

        IF NOT FIND('=><') THEN BEGIN
          COMMIT;
          "Line No." := 0;
          EXIT;
        END;

        Window.OPEN(
          Text001 +
          Text002 +
          Text003);
        Window.UPDATE(1,"Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := "Line No.";
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(2,LineCount);

          JnlLineDim.SETRANGE("Table ID",DATABASE::"HR Journal Line");
          JnlLineDim.SETRANGE("Journal Template Name","Journal Template Name");
          JnlLineDim.SETRANGE("Journal Batch Name","Journal Batch Name");
          JnlLineDim.SETRANGE("Journal Line No.","Line No.");
          JnlLineDim.SETRANGE("Allocation Line No.",0);
          TempJnlLineDim.DELETEALL;
          //DimMgt.CopyJnlLineDimToJnlLineDim(JnlLineDim,TempJnlLineDim);
          InsuranceJnlCheckLine.RunCheck(InsuranceJnlLine,TempJnlLineDim);

          IF NEXT = 0 THEN
            FIND('-');
        UNTIL "Line No." = StartLineNo;
        NoOfRecords := LineCount;

        //LedgEntryDim.LOCKTABLE;
        InsCoverageLedgEntry.LOCKTABLE;
        IF RECORDLEVELLOCKING THEN
          IF InsCoverageLedgEntry.FIND('+') THEN;
        InsuranceReg.LOCKTABLE;
        IF InsuranceReg.FIND('+') THEN
          InsuranceRegNo := InsuranceReg."No." + 1
        ELSE
          InsuranceRegNo := 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        FIND('-');
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(3,LineCount);
          Window.UPDATE(4,ROUND(LineCount / NoOfRecords * 10000,1));
          IF NOT ("Leave Period" = '') AND
             (InsuranceJnlBatch."No. Series" <> '') AND
             ("Document No." <> LastDocNo2)
          THEN
            //TESTFIELD("Document No.",NoSeriesMgt.GetNextNo(InsuranceJnlBatch."No. Series","Posting Date",FALSE));

      //    LastDocNo2 := "Document No.";
           LastDocNo2:=NoSeriesMgt.GetNextNo(InsuranceJnlBatch."No. Series","Posting Date",FALSE);
          IF "Posting No. Series" = '' THEN
            "Posting No. Series" := InsuranceJnlBatch."No. Series"
          ELSE
            IF NOT ("Leave Period" = '') THEN
              IF "Document No." = LastDocNo THEN
                "Document No." := LastPostedDocNo
              ELSE BEGIN
                IF NOT NoSeries.GET("Posting No. Series") THEN BEGIN
                  NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                  IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesMgt2) THEN
                    ERROR(
                      Text004,
                      ARRAYLEN(NoSeriesMgt2));
                  NoSeries.Code := "Posting No. Series";
                  NoSeries.Description := FORMAT(NoOfPostingNoSeries);
                  NoSeries.INSERT;
                END;
                LastDocNo := "Document No.";
                EVALUATE(PostingNoSeriesNo,NoSeries.Description);
                "Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series","Posting Date",FALSE);
                LastPostedDocNo := "Document No.";
              END;

          JnlLineDim.SETRANGE("Table ID",DATABASE::"HR Journal Line");
          JnlLineDim.SETRANGE("Journal Template Name","Journal Template Name");
          JnlLineDim.SETRANGE("Journal Batch Name","Journal Batch Name");
          JnlLineDim.SETRANGE("Journal Line No.","Line No.");
          JnlLineDim.SETRANGE("Allocation Line No.",0);
          TempJnlLineDim.DELETEALL;
          //DimMgt.CopyJnlLineDimToJnlLineDim(JnlLineDim,TempJnlLineDim);
          InsuranceJnlPostLine.RunWithOutCheck(InsuranceJnlLine,TempJnlLineDim);
         UNTIL NEXT = 0;

        IF InsuranceReg.FIND('+') THEN;
        IF InsuranceReg."No." <> InsuranceRegNo THEN
          InsuranceRegNo := 0;

        INIT;
        "Line No." := InsuranceRegNo;

        // Update/delete lines
        IF InsuranceRegNo <> 0 THEN BEGIN
          IF NOT RECORDLEVELLOCKING THEN BEGIN
            JnlLineDim.LOCKTABLE(TRUE,TRUE);
            LOCKTABLE(TRUE,TRUE);
          END;
          InsuranceJnlLine2.COPYFILTERS(InsuranceJnlLine);
          InsuranceJnlLine2.SETFILTER("Leave Period",'<>%1','');
          IF InsuranceJnlLine2.FIND('+') THEN; // Remember the last line

          JnlLineDim.SETRANGE("Table ID",DATABASE::"HR Journal Line");
          JnlLineDim.COPYFILTER("Journal Template Name","Journal Template Name");
          JnlLineDim.COPYFILTER("Journal Batch Name","Journal Batch Name");
          JnlLineDim.SETRANGE("Allocation Line No.",0);

          InsuranceJnlLine3.COPY(InsuranceJnlLine);
          IF InsuranceJnlLine3.FIND('-') THEN
            REPEAT
              //JnlLineDim.SETRANGE("Journal Line No.",InsuranceJnlLine3."Line No.");
              //JnlLineDim.DELETEALL;
              InsuranceJnlLine3.DELETE;
            UNTIL InsuranceJnlLine3.NEXT = 0;
          InsuranceJnlLine3.RESET;
          InsuranceJnlLine3.SETRANGE("Journal Template Name","Journal Template Name");
          InsuranceJnlLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
          IF NOT InsuranceJnlLine3.FIND('+') THEN
            IF INCSTR("Journal Batch Name") <> '' THEN BEGIN
              InsuranceJnlBatch.GET("Journal Template Name","Journal Batch Name");
              InsuranceJnlBatch.DELETE;
              //FAJnlSetup.IncInsuranceJnlBatchName(InsuranceJnlBatch);
              InsuranceJnlBatch.Name := INCSTR("Journal Batch Name");
              IF InsuranceJnlBatch.INSERT THEN;
              "Journal Batch Name" := InsuranceJnlBatch.Name;
            END;

          InsuranceJnlLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
          IF (InsuranceJnlBatch."No. Series" = '') AND NOT InsuranceJnlLine3.FIND('+') THEN BEGIN
            InsuranceJnlLine3.INIT;
            InsuranceJnlLine3."Journal Template Name" := "Journal Template Name";
            InsuranceJnlLine3."Journal Batch Name" := "Journal Batch Name";
            InsuranceJnlLine3."Line No." := 10000;
            InsuranceJnlLine3.INSERT;
            InsuranceJnlLine3.SetUpNewLine(InsuranceJnlLine2);
            InsuranceJnlLine3.MODIFY;
          END;
        END;
        IF InsuranceJnlBatch."No. Series" <> '' THEN
          NoSeriesMgt.SaveNoSeries;
        IF NoSeries.FIND('-') THEN
          REPEAT
            EVALUATE(PostingNoSeriesNo,NoSeries.Description);
            NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
          UNTIL NoSeries.NEXT = 0;

        COMMIT;
        CLEAR(InsuranceJnlCheckLine);
        CLEAR(InsuranceJnlPostLine);
      END;
      UpdateAnalysisView.UpdateAll(0,TRUE);
      COMMIT;
    END;

    BEGIN
    END.
  }
}

