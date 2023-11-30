OBJECT CodeUnit 20405 MembEntry-Apply Posted Entrie
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=[ 2:52:50 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    TableNo=51516224;
    Permissions=TableData 21=rimd;
    OnRun=VAR
            EntriesToApply@1000 : Record 21;
            ApplicationDate@1001 : Date;
            UpdateAnalysisView@1002 : Codeunit 410;
          BEGIN
            WITH Rec DO BEGIN
              //IF NOT PaymentToleracenMgt.PmtTolMember(Rec) THEN
                //EXIT;
              GET("Entry No.");

              ApplicationDate := 0D;
              EntriesToApply.SETCURRENTKEY("Customer No.","Applies-to ID");
              EntriesToApply.SETRANGE("Customer No.","Customer No.");
              EntriesToApply.SETRANGE("Applies-to ID","Applies-to ID");
              EntriesToApply.FIND('-');
              REPEAT
                IF EntriesToApply."Posting Date" > ApplicationDate THEN
                  ApplicationDate := EntriesToApply."Posting Date";
              UNTIL EntriesToApply.NEXT = 0;
              ///PostApplication.SetValues("Document No.",ApplicationDate);
              ///PostApplication.LOOKUPMODE(TRUE);
              {
              IF ACTION::LookupOK = PostApplication.RUNMODAL THEN BEGIN
                GenJnlLine.INIT;
                PostApplication.GetValues(GenJnlLine."Document No.",GenJnlLine."Posting Date");
                IF GenJnlLine."Posting Date" < ApplicationDate THEN
                  ERROR(
                    Text003,
                    GenJnlLine.FIELDCAPTION("Posting Date"),FIELDCAPTION("Posting Date"),TABLECAPTION);
              END ELSE
                EXIT;
                 }
              Window.OPEN(Text001);

              SourceCodeSetup.GET;

              GenJnlLine."Document Date" := GenJnlLine."Posting Date";
              GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
              GenJnlLine."Account No." := "Customer No.";
              CALCFIELDS("Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)");
              GenJnlLine.Correction :=
                ("Debit Amount" < 0) OR ("Credit Amount" < 0) OR
                ("Debit Amount (LCY)" < 0) OR ("Credit Amount (LCY)" < 0);
              GenJnlLine."Document Type" := "Document Type";
              GenJnlLine.Description := Description;
              GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
              GenJnlLine."Posting Group" := "Customer Posting Group";
              GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
              GenJnlLine."Source No." := "Customer No.";
              GenJnlLine."Source Code" := SourceCodeSetup."Sales Entry Application";
              GenJnlLine."System-Created Entry" := TRUE;

              EntryNoBeforeApplication := FindLastApplDtldCustLedgEntry;

              GenJnlPostLine.MemberPostApplyCustLedgEntry(GenJnlLine,Rec);

              EntryNoAfterApplication := FindLastApplDtldCustLedgEntry;
              IF EntryNoAfterApplication = EntryNoBeforeApplication THEN
                ERROR(Text004);

              COMMIT;
              Window.CLOSE;
              UpdateAnalysisView.UpdateAll(0,TRUE);
              MESSAGE(Text002);
            END;
          END;

  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'ENU=Posting application...';
      Text002@1001 : TextConst 'ENU=The application was successfully posted.';
      Text003@1002 : TextConst 'ENU=The %1 entered must not be before the %2 on the %3.';
      Text004@1003 : TextConst 'ENU=The application was successfully posted though no entries have been applied.';
      SourceCodeSetup@1004 : Record 242;
      GenJnlLine@1005 : Record 81;
      GenJnlCheckLine@1022 : Codeunit 11;
      GenJnlPostLine@1007 : Codeunit 12;
      PaymentToleracenMgt@1011 : Codeunit 426;
      Window@1008 : Dialog;
      EntryNoBeforeApplication@1009 : Integer;
      EntryNoAfterApplication@1010 : Integer;
      Text005@1018 : TextConst 'ENU=Before you can unapply this entry, you must first unapply all application entries that were posted after this entry.';
      Text006@1017 : TextConst 'ENU=%1 No. %2 does not have an application entry.';
      Text007@1016 : TextConst 'ENU=Do you want to unapply the entries?';
      Text008@1015 : TextConst 'ENU=Unapplying and posting...';
      Text009@1014 : TextConst 'ENU=The entries were successfully unapplied.';
      Text010@1013 : TextConst 'ENU="There is nothing to unapply. "';
      Text011@1012 : TextConst 'ENU=To unapply these entries, the program will post correcting entries.\';
      Text012@1019 : TextConst 'ENU=Before you can unapply this entry, you must first unapply all application entries in %1 No. %2 that were posted after this entry.';
      Text013@1020 : TextConst 'ENU=%1 is not within your range of allowed posting dates in %2 No. %3.';
      Text014@1021 : TextConst 'ENU=%1 is not within your range of allowed posting dates.';
      Text015@1024 : TextConst 'ENU=The latest %3 must be an application in %1 No. %2.';
      Text016@1023 : TextConst 'ENU="You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed. "';
      MaxPostingDate@1025 : Date;
      Text017@1026 : TextConst 'ENU=You cannot unapply %1 No. %2 because the entry has been involved in a reversal.';
      Text018@1102601000 : TextConst 'ENU=One or more of the entries that you selected is closed. You cannot apply closed entries.';

    LOCAL PROCEDURE FindLastApplDtldCustLedgEntry@1() : Integer;
    VAR
      DtldCustLedgEntry@1000 : Record 379;
    BEGIN
      DtldCustLedgEntry.LOCKTABLE;
      IF DtldCustLedgEntry.FIND('+') THEN
        EXIT(DtldCustLedgEntry."Entry No.")
      ELSE
        EXIT(0);
    END;

    LOCAL PROCEDURE FindLastApplEntry@2(CustLedgEntryNo@1002 : Integer) : Integer;
    VAR
      DtldCustLedgEntry@1001 : Record 379;
      ApplicationEntryNo@1000 : Integer;
    BEGIN
      DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntryNo);
      DtldCustLedgEntry.SETRANGE("Entry Type",DtldCustLedgEntry."Entry Type"::Application);
      ApplicationEntryNo := 0;
      IF DtldCustLedgEntry.FIND('-') THEN
        REPEAT
          IF (DtldCustLedgEntry."Entry No." > ApplicationEntryNo) AND NOT DtldCustLedgEntry.Unapplied THEN
            ApplicationEntryNo := DtldCustLedgEntry."Entry No.";
        UNTIL DtldCustLedgEntry.NEXT = 0;
      EXIT(ApplicationEntryNo);
    END;

    LOCAL PROCEDURE FindLastTransactionNo@6(CustLedgEntryNo@1002 : Integer) : Integer;
    VAR
      DtldCustLedgEntry@1001 : Record 379;
      LastTransactionNo@1000 : Integer;
    BEGIN
      DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntryNo);
      LastTransactionNo := 0;
      IF DtldCustLedgEntry.FIND('-') THEN
        REPEAT
          IF (DtldCustLedgEntry."Transaction No." > LastTransactionNo) AND NOT DtldCustLedgEntry.Unapplied THEN
            LastTransactionNo := DtldCustLedgEntry."Transaction No.";
        UNTIL DtldCustLedgEntry.NEXT = 0;
      EXIT(LastTransactionNo);
    END;

    PROCEDURE UnApplyDtldCustLedgEntry@3(DtldCustLedgEntry@1000 : Record 379);
    VAR
      ApplicationEntryNo@1001 : Integer;
    BEGIN
      DtldCustLedgEntry.TESTFIELD("Entry Type",DtldCustLedgEntry."Entry Type"::Application);
      DtldCustLedgEntry.TESTFIELD(Unapplied,FALSE);
      ApplicationEntryNo := FindLastApplEntry(DtldCustLedgEntry."Cust. Ledger Entry No.");

      IF DtldCustLedgEntry."Entry No." <> ApplicationEntryNo THEN
        ERROR(Text005);
      CheckReversal(DtldCustLedgEntry."Cust. Ledger Entry No.");
      UnApplyCustomer(DtldCustLedgEntry);
    END;

    PROCEDURE UnApplyCustLedgEntry@7(CustLedgEntryNo@1000 : Integer);
    VAR
      CustLedgentry@1003 : Record 21;
      DtldCustLedgEntry@1002 : Record 379;
      ApplicationEntryNo@1001 : Integer;
    BEGIN
      CheckReversal(CustLedgEntryNo);
      ApplicationEntryNo := FindLastApplEntry(CustLedgEntryNo);
      IF ApplicationEntryNo = 0 THEN
        ERROR(Text006,CustLedgentry.TABLECAPTION,CustLedgEntryNo);
      DtldCustLedgEntry.GET(ApplicationEntryNo);
      UnApplyCustomer(DtldCustLedgEntry);
    END;

    LOCAL PROCEDURE UnApplyCustomer@19(DtldCustLedgEntry@1000000000 : Record 379);
    VAR
      UnapplyCustEntries@1102755000 : Page 623;
    BEGIN
      WITH DtldCustLedgEntry DO BEGIN
        TESTFIELD("Entry Type","Entry Type"::Application);
        TESTFIELD(Unapplied,FALSE);
        UnapplyCustEntries.SetDtldCustLedgEntry("Entry No.");
        UnapplyCustEntries.LOOKUPMODE(TRUE);
        UnapplyCustEntries.RUNMODAL;
      END;
    END;

    PROCEDURE PostUnApplyCustomer@4(VAR DtldCustLedgEntryBuf@1008 : Record 379;DtldCustLedgEntry2@1007 : Record 379;VAR DocNo@1000 : Code[20];VAR PostingDate@1001 : Date);
    VAR
      GLEntry@1019 : Record 17;
      CustLedgEntry@1018 : Record 21;
      SourceCodeSetup@1017 : Record 242;
      GenJnlLine@1016 : Record 81;
      DtldCustLedgEntry@1014 : Record 379;
      GenJnlPostLine@1002 : Codeunit 12;
      DateComprReg@1005 : Record 87;
      Window@1012 : Dialog;
      ApplicationEntryNo@1010 : Integer;
      LastTransactionNo@1003 : Integer;
      AddCurrChecked@1004 : Boolean;
    BEGIN
      IF NOT DtldCustLedgEntryBuf.FIND('-') THEN
        ERROR(Text010);
      IF NOT CONFIRM(Text011 + Text007,FALSE) THEN
        EXIT;
      MaxPostingDate := 0D;
      GLEntry.LOCKTABLE;
      DtldCustLedgEntry.LOCKTABLE;
      CustLedgEntry.LOCKTABLE;
      CustLedgEntry.GET(DtldCustLedgEntry2."Cust. Ledger Entry No.");
      CheckPostingDate(PostingDate,'',0);
      IF PostingDate < DtldCustLedgEntry2."Posting Date" THEN
        ERROR(Text003,
          DtldCustLedgEntry2.FIELDCAPTION("Posting Date"),
          DtldCustLedgEntry2.FIELDCAPTION("Posting Date"),
          DtldCustLedgEntry2.TABLECAPTION);
      DtldCustLedgEntry.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Transaction No.",DtldCustLedgEntry2."Transaction No.");
      DtldCustLedgEntry.SETRANGE("Customer No.",DtldCustLedgEntry2."Customer No.");
      IF DtldCustLedgEntry.FIND('-') THEN
        REPEAT
          IF (DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."Entry Type"::"Initial Entry") AND
             NOT DtldCustLedgEntry.Unapplied
          THEN BEGIN
            IF NOT AddCurrChecked THEN BEGIN
              CheckAdditionalCurrency(PostingDate,DtldCustLedgEntry."Posting Date");
              AddCurrChecked := TRUE;
            END;
            CheckReversal(DtldCustLedgEntry."Cust. Ledger Entry No.");
            IF DtldCustLedgEntry."Entry Type" = DtldCustLedgEntry."Entry Type"::Application THEN BEGIN
              LastTransactionNo :=
                FindLastApplTransactionEntry(DtldCustLedgEntry."Cust. Ledger Entry No.");
              IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") THEN
                ERROR(Text012,CustLedgEntry.TABLECAPTION,DtldCustLedgEntry."Cust. Ledger Entry No.");
            END;
            LastTransactionNo := FindLastTransactionNo(DtldCustLedgEntry."Cust. Ledger Entry No.");
            IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") THEN
              ERROR(
                Text015,
                CustLedgEntry.TABLECAPTION,
                DtldCustLedgEntry."Cust. Ledger Entry No.",
                CustLedgEntry.FIELDCAPTION("Transaction No."));
          END;
        UNTIL DtldCustLedgEntry.NEXT = 0;

      DateComprReg.CheckMaxDateCompressed(MaxPostingDate,0);

      WITH DtldCustLedgEntry2 DO BEGIN
        SourceCodeSetup.GET;
        CustLedgEntry.GET("Cust. Ledger Entry No.");
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := "Customer No.";
        GenJnlLine.Correction := TRUE;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine.Description := CustLedgEntry.Description;
        GenJnlLine."Shortcut Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
        GenJnlLine."Posting Group" := CustLedgEntry."Customer Posting Group";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := "Customer No.";
        GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Sales Entry Appln.";
        GenJnlLine."Source Currency Code" := DtldCustLedgEntry2."Currency Code";
        GenJnlLine."System-Created Entry" := TRUE;
        Window.OPEN(Text008);
        GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine,DtldCustLedgEntry2);
        DtldCustLedgEntryBuf.DELETEALL;
        DocNo := '';
        PostingDate := 0D;
        COMMIT;
        Window.CLOSE;
        MESSAGE(Text009);
      END;
    END;

    LOCAL PROCEDURE CheckPostingDate@5(PostingDate@1001 : Date;Caption@1002 : Text[50];EntryNo@1003 : Integer);
    VAR
      CustLedgEntry@1004 : Record 21;
    BEGIN
      IF GenJnlCheckLine.DateNotAllowed(PostingDate) THEN BEGIN
        IF Caption <> '' THEN
          ERROR(Text013,CustLedgEntry.FIELDCAPTION("Posting Date"),Caption,EntryNo)
        ELSE
          ERROR(Text014,CustLedgEntry.FIELDCAPTION("Posting Date"));
      END;
      IF PostingDate > MaxPostingDate THEN
        MaxPostingDate := PostingDate;
    END;

    LOCAL PROCEDURE CheckAdditionalCurrency@8(OldPostingDate@1000 : Date;NewPostingDate@1001 : Date);
    VAR
      GLSetup@1002 : Record 98;
      CurrExchRate@1003 : Record 330;
    BEGIN
      IF OldPostingDate = NewPostingDate THEN
        EXIT;
      GLSetup.GET;
      IF GLSetup."Additional Reporting Currency" <> '' THEN
        IF CurrExchRate.ExchangeRate(OldPostingDate,GLSetup."Additional Reporting Currency") <>
           CurrExchRate.ExchangeRate(NewPostingDate,GLSetup."Additional Reporting Currency")
        THEN
          ERROR(Text016,NewPostingDate);
    END;

    PROCEDURE CheckReversal@9(CustLedgEntryNo@1000 : Integer);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      CustLedgEntry.GET(CustLedgEntryNo);
      IF CustLedgEntry.Reversed THEN
        ERROR(Text017,CustLedgEntry.TABLECAPTION,CustLedgEntryNo);
    END;

    PROCEDURE ApplyCustEntryformEntry@10(VAR ApplyingCustLedgEntry@1000 : Record 51516224);
    VAR
      ApplyCustEntries@1102755000 : Page 51516234;
      CustledgEntry@1002 : Record 51516224;
      CustEntryApplID@1004 : Code[20];
      OK@1003 : Boolean;
    BEGIN
      IF NOT ApplyingCustLedgEntry.Open THEN
        ERROR(Text018)
      ELSE BEGIN
        CustEntryApplID := USERID;
        IF CustEntryApplID = '' THEN
          CustEntryApplID := '***';

        ApplyingCustLedgEntry."Applying Entry" := TRUE;
        ApplyingCustLedgEntry."Applies-to ID" := CustEntryApplID;
        ApplyingCustLedgEntry."Amount to Apply" := ApplyingCustLedgEntry."Remaining Amount";
        //CODEUNIT.RUN(CODEUNIT::Codeunit,ApplyingCustLedgEntry);
        COMMIT;
      {
        CustledgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
        CustledgEntry.SETRANGE("Customer No.",ApplyingCustLedgEntry."Customer No.");
        CustledgEntry.SETRANGE(Open,TRUE);
        IF CustledgEntry.FINDSET THEN BEGIN
          ApplyCustEntries.SetCustLedgEntry(ApplyingCustLedgEntry);
          ApplyCustEntries.SETRECORD(CustledgEntry);
          ApplyCustEntries.SETTABLEVIEW(CustledgEntry);
          OK := ApplyCustEntries.RUNMODAL = ACTION::LookupOK;
          CLEAR(ApplyCustEntries);
          IF NOT OK THEN
            EXIT;
        END;
      }
      END;
    END;

    PROCEDURE FindLastApplTransactionEntry@11(CustLedgEntryNo@1000 : Integer) : Integer;
    VAR
      DtldCustLedgEntry@1001 : Record 379;
      LastTransactionNo@1002 : Integer;
    BEGIN
      DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntryNo);
      DtldCustLedgEntry.SETRANGE("Entry Type",DtldCustLedgEntry."Entry Type"::Application);
      LastTransactionNo :=0;
      IF DtldCustLedgEntry.FIND('-') THEN
        REPEAT
          IF (DtldCustLedgEntry."Transaction No." > LastTransactionNo) AND NOT DtldCustLedgEntry.Unapplied THEN
            LastTransactionNo := DtldCustLedgEntry."Transaction No.";
        UNTIL DtldCustLedgEntry.NEXT = 0;
      EXIT(LastTransactionNo);
    END;

    BEGIN
    END.
  }
}

