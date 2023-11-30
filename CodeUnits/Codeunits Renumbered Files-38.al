OBJECT CodeUnit 20402 Member. Entry-Edit
{
  OBJECT-PROPERTIES
  {
    Date=10/01/15;
    Time=[ 7:47:58 AM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    TableNo=51516155;
    Permissions=TableData 21=imd,
                TableData 379=m;
    OnRun=BEGIN
            CustLedgEntry := Rec;
            CustLedgEntry.LOCKTABLE;
            CustLedgEntry.FIND;
            CustLedgEntry."On Hold" := "On Hold";
            IF CustLedgEntry.Open THEN BEGIN
              CustLedgEntry."Due Date" := "Due Date";
             // DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
             // DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
             // DtldCustLedgEntry.MODIFYALL("Initial Entry Due Date","Due Date");
              CustLedgEntry."Pmt. Discount Date" := "Pmt. Discount Date";
              CustLedgEntry."Applies-to ID" := "Applies-to ID";
              CustLedgEntry.VALIDATE("Remaining Pmt. Disc. Possible","Remaining Pmt. Disc. Possible");
              CustLedgEntry."Pmt. Disc. Tolerance Date" := "Pmt. Disc. Tolerance Date";
              CustLedgEntry.VALIDATE("Max. Payment Tolerance","Max. Payment Tolerance");
              CustLedgEntry.VALIDATE("Accepted Payment Tolerance","Accepted Payment Tolerance");
              CustLedgEntry.VALIDATE("Accepted Pmt. Disc. Tolerance","Accepted Pmt. Disc. Tolerance");
              CustLedgEntry.VALIDATE("Amount to Apply","Amount to Apply");
              CustLedgEntry.VALIDATE("Applying Entry","Applying Entry");
            END;
            CustLedgEntry.MODIFY;
            Rec := CustLedgEntry;
          END;

  }
  CODE
  {
    VAR
      CustLedgEntry@1000 : Record 51516155;
      DtldCustLedgEntry@1001 : Record 379;

    BEGIN
    END.
  }
}

