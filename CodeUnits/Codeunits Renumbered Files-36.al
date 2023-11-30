OBJECT CodeUnit 20400 HR Make Leave Ledg. Entry
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 3:48:57 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    PROCEDURE CopyFromJnlLine@1(VAR InsCoverageLedgEntry@1000 : Record 51516201;VAR InsuranceJnlLine@1001 : Record 51516410);
    BEGIN
      WITH InsCoverageLedgEntry DO BEGIN
        "User ID" := USERID;
        "Leave Period" := InsuranceJnlLine."Leave Period";
        "Staff No." := InsuranceJnlLine."Staff No.";
        "Staff Name" := InsuranceJnlLine."Staff Name";
        "Posting Date" := InsuranceJnlLine."Posting Date";
        "Leave Recalled No.":=InsuranceJnlLine."Leave Recalled No.";
        "Leave Entry Type" := InsuranceJnlLine."Leave Entry Type";
        "Leave Type":=InsuranceJnlLine."Leave Type";
        "Leave Approval Date" := InsuranceJnlLine."Leave Approval Date";
        "Leave Type":=InsuranceJnlLine."Leave Type";
        IF "Leave Approval Date" = 0D THEN
        "Leave Approval Date" := "Posting Date";
        "Document No." :=  InsuranceJnlLine."Document No.";
        "External Document No." := InsuranceJnlLine."External Document No.";
        "No. of days" := InsuranceJnlLine."No. of Days";
        "Leave Posting Description" := InsuranceJnlLine.Description;
        "Global Dimension 1 Code" := InsuranceJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := InsuranceJnlLine."Shortcut Dimension 2 Code";
        "Source Code" := InsuranceJnlLine."Source Code";
        "Journal Batch Name" := InsuranceJnlLine."Journal Batch Name";
        "Reason Code" := InsuranceJnlLine."Reason Code";
        Closed := SetDisposedFA(InsCoverageLedgEntry."Staff No.");
        "No. Series" := InsuranceJnlLine."Posting No. Series";
      END;
    END;

    PROCEDURE CopyFromInsuranceCard@2(VAR InsCoverageLedgEntry@1000 : Record 51516201;VAR Insurance@1001 : Record 51516197);
    BEGIN
      {WITH InsCoverageLedgEntry DO BEGIN
        "FA Class Code" := Insurance."FA Class Code";
        "FA Subclass Code" := Insurance."FA Subclass Code";
        "FA Location Code" := Insurance."FA Location Code";
        "Location Code" := Insurance."Location Code";
      END;}
    END;

    PROCEDURE SetDisposedFA@3(FANo@1000 : Code[20]) : Boolean;
    VAR
      FASetup@1001 : Record 51516192;
    BEGIN
      {FASetup.GET;
      FASetup.TESTFIELD("Insurance Depr. Book");
      IF FADeprBook.GET(FANo,FASetup."Insurance Depr. Book") THEN
        EXIT(FADeprBook."Disposal Date" > 0D)
      ELSE
        EXIT(FALSE);
       }
    END;

    PROCEDURE UpdateLeaveApp@1102755000(LeaveCode@1102755001 : Code[20];Status@1102755002 : Option);
    VAR
      LeaveApplication@1102755000 : Record 51516191;
    BEGIN
    END;

    BEGIN
    END.
  }
}

