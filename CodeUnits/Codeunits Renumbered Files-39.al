OBJECT CodeUnit 20403 Member Entry-Set Appl.ID
{
  OBJECT-PROPERTIES
  {
    Date=10/01/15;
    Time=[ 7:47:37 AM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Permissions=TableData 21=imd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      CustEntryApplID@1000 : Code[20];

    PROCEDURE SetApplId@1(VAR CustLedgEntry@1000 : Record 51516155;ApplyingCustLedgEntry@1003 : Record 51516155;AppliedAmount@1004 : Decimal;PmtDiscAmount@1002 : Decimal;AppliesToID@1001 : Code[20]);
    BEGIN
      CustLedgEntry.LOCKTABLE;
      IF CustLedgEntry.FIND('-') THEN BEGIN
        // Make Applies-to ID
        IF CustLedgEntry."Applies-to ID" <> '' THEN
          CustEntryApplID := ''
        ELSE BEGIN
          CustEntryApplID := AppliesToID;
          IF CustEntryApplID = '' THEN BEGIN
            CustEntryApplID := USERID;
            IF CustEntryApplID = '' THEN
              CustEntryApplID := '***';
          END;
        END;

        // Set Applies-to ID
        REPEAT
          CustLedgEntry.TESTFIELD(Open,TRUE);
          CustLedgEntry."Applies-to ID" := CustEntryApplID;
          IF CustLedgEntry."Applies-to ID" = '' THEN BEGIN
            CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            CustLedgEntry."Accepted Payment Tolerance" := 0;
          END;
          // Set Amount to Apply
          IF ((CustLedgEntry."Amount to Apply" <> 0) AND (CustEntryApplID = '')) OR
            (CustEntryApplID = '')
          THEN
            CustLedgEntry."Amount to Apply" := 0
          ELSE
            IF CustLedgEntry."Amount to Apply" = 0 THEN BEGIN
              CustLedgEntry.CALCFIELDS("Remaining Amount");
              CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount"
            END;

          IF CustLedgEntry."Entry No." = ApplyingCustLedgEntry."Entry No." THEN
            CustLedgEntry."Applying Entry" := ApplyingCustLedgEntry."Applying Entry";
          CustLedgEntry.MODIFY;
        UNTIL CustLedgEntry.NEXT = 0;
      END;
    END;

    BEGIN
    END.
  }
}

