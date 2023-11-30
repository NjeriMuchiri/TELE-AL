OBJECT page 17371 Member Ledger Entry FactBox
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=11:09:21 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    CaptionML=ENU=Member Ledger Entry Details;
    SourceTable=Table51516224;
    PageType=CardPart;
    OnOpenPage=BEGIN
                 DocumentHeading := GetDocumentHeading(Rec);
                 CalcNoOfRecords;
               END;

    OnFindRecord=BEGIN
                   NoOfReminderFinEntries := 0;
                   NoOfAppliedEntries := 0;
                   DocumentHeading := '';

                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       DocumentHeading := GetDocumentHeading(Rec);
                       CalcNoOfRecords;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 13  ;1   ;Field     ;
                DrillDown=Yes;
                CaptionML=ENU=Document;
                SourceExpr=DocumentHeading;
                OnDrillDown=VAR
                              SalesInvoiceHdr@1000 : Record 112;
                              SalesCrMemoHdr@1001 : Record 114;
                              GLEntry@1006 : Record 17;
                              PostedSalesInvoiceCard@1002 : Page 132;
                              PostedSalesCrMemoCard@1003 : Page 134;
                              GeneralLedgEntriesList@1007 : Page 20;
                              CheckGLEntry@1005 : Boolean;
                            BEGIN
                              CheckGLEntry := TRUE;

                              IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                                SalesInvoiceHdr.SETRANGE("No.","Document No.");
                                IF SalesInvoiceHdr.FINDFIRST THEN BEGIN
                                  PostedSalesInvoiceCard.SETTABLEVIEW(SalesInvoiceHdr);
                                  PostedSalesInvoiceCard.RUN;
                                  CheckGLEntry := FALSE;
                                END
                              END;

                              IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                                SalesCrMemoHdr.SETRANGE("No.","Document No.");
                                IF SalesCrMemoHdr.FINDFIRST THEN BEGIN
                                  PostedSalesCrMemoCard.SETTABLEVIEW(SalesCrMemoHdr);
                                  PostedSalesCrMemoCard.RUN;
                                  CheckGLEntry := FALSE;
                                END
                              END;

                              IF CheckGLEntry THEN BEGIN
                                GLEntry.SETCURRENTKEY("Document No.","Posting Date");
                                GLEntry.SETRANGE("Document No.","Document No.");
                                GLEntry.SETRANGE("Posting Date","Posting Date");
                                GeneralLedgEntriesList.SETTABLEVIEW(GLEntry);
                                GeneralLedgEntriesList.RUN
                              END;
                            END;
                             }

    { 1   ;1   ;Field     ;
                SourceExpr="Due Date" }

    { 3   ;1   ;Field     ;
                SourceExpr="Pmt. Discount Date" }

    { 5   ;1   ;Field     ;
                DrillDown=Yes;
                CaptionML=ENU=Reminder/Fin. Charge Entries;
                SourceExpr=NoOfReminderFinEntries;
                OnDrillDown=VAR
                              ReminderFinEntry@1001 : Record 300;
                              ReminderFinEntriesList@1000 : Page 444;
                            BEGIN
                              ReminderFinEntry.SETRANGE("Customer Entry No.","Entry No.");
                              ReminderFinEntriesList.SETTABLEVIEW(ReminderFinEntry);
                              ReminderFinEntriesList.RUN;
                            END;
                             }

    { 8   ;1   ;Field     ;
                DrillDown=Yes;
                CaptionML=ENU=Applied Entries;
                SourceExpr=NoOfAppliedEntries;
                OnDrillDown=VAR
                              AppliedCustomerEntriesList@1000 : Page 61;
                            BEGIN
                              AppliedCustomerEntriesList.SetTempCustLedgEntry("Entry No.");
                              AppliedCustomerEntriesList.RUN;
                            END;
                             }

    { 2   ;1   ;Field     ;
                DrillDown=Yes;
                CaptionML=ENU=Detailed Ledger Entries;
                SourceExpr=NoOfDetailedCustomerEntries;
                OnDrillDown=VAR
                              DetailedCustLedgEntry@1000 : Record 379;
                            BEGIN
                              DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.","Entry No.");
                              DetailedCustLedgEntry.SETRANGE("Customer No.","Customer No.");
                              PAGE.RUN(PAGE::"Detailed Cust. Ledg. Entries",DetailedCustLedgEntry);
                            END;
                             }

  }
  CODE
  {
    VAR
      NoOfReminderFinEntries@1002 : Integer;
      NoOfAppliedEntries@1000 : Integer;
      NoOfDetailedCustomerEntries@1004 : Integer;
      DocumentHeading@1001 : Text[250];
      Text000@1003 : TextConst 'ENU=Document';

    PROCEDURE CalcNoOfRecords@3();
    VAR
      ReminderFinChargeEntry@1005 : Record 300;
      DetailedCustLedgEntry@1000 : Record 379;
    BEGIN
      ReminderFinChargeEntry.RESET;
      ReminderFinChargeEntry.SETRANGE("Customer Entry No.","Entry No.");
      NoOfReminderFinEntries := ReminderFinChargeEntry.COUNT;

      NoOfAppliedEntries := 0;
      IF "Entry No." <> 0 THEN
        NoOfAppliedEntries := GetNoOfAppliedEntries(Rec);

      DetailedCustLedgEntry.RESET;
      DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.","Entry No.");
      DetailedCustLedgEntry.SETRANGE("Customer No.","Customer No.");
      NoOfDetailedCustomerEntries := DetailedCustLedgEntry.COUNT;
    END;

    PROCEDURE GetNoOfAppliedEntries@1(CustLedgerEntry@1000 : Record 51516224) : Integer;
    BEGIN
      GetAppliedEntries(CustLedgerEntry);
      EXIT(CustLedgerEntry.COUNT);
    END;

    PROCEDURE GetAppliedEntries@2(VAR CustLedgerEntry@1000 : Record 51516224);
    VAR
      DtldCustLedgEntry1@1005 : Record 379;
      DtldCustLedgEntry2@1004 : Record 379;
      CreateCustLedgEntry@1002 : Record 51516224;
    BEGIN
      CreateCustLedgEntry := CustLedgerEntry;

      DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
      DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.",CreateCustLedgEntry."Entry No.");
      DtldCustLedgEntry1.SETRANGE(Unapplied,FALSE);
      IF DtldCustLedgEntry1.FINDSET THEN
        REPEAT
          IF DtldCustLedgEntry1."Cust. Ledger Entry No." =
             DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
          THEN BEGIN
            DtldCustLedgEntry2.INIT;
            DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.","Entry Type");
            DtldCustLedgEntry2.SETRANGE(
              "Applied Cust. Ledger Entry No.",DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
            DtldCustLedgEntry2.SETRANGE("Entry Type",DtldCustLedgEntry2."Entry Type"::Application);
            DtldCustLedgEntry2.SETRANGE(Unapplied,FALSE);
            IF DtldCustLedgEntry2.FIND('-') THEN
              REPEAT
                IF DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                   DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                THEN BEGIN
                  CustLedgerEntry.SETCURRENTKEY("Entry No.");
                  CustLedgerEntry.SETRANGE("Entry No.",DtldCustLedgEntry2."Cust. Ledger Entry No.");
                  IF CustLedgerEntry.FINDFIRST THEN
                    CustLedgerEntry.MARK(TRUE);
                END;
              UNTIL DtldCustLedgEntry2.NEXT = 0;
          END ELSE BEGIN
            CustLedgerEntry.SETCURRENTKEY("Entry No.");
            CustLedgerEntry.SETRANGE("Entry No.",DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
            IF CustLedgerEntry.FINDFIRST THEN
              CustLedgerEntry.MARK(TRUE);
          END;
        UNTIL DtldCustLedgEntry1.NEXT = 0;

      CustLedgerEntry.SETCURRENTKEY("Entry No.");
      CustLedgerEntry.SETRANGE("Entry No.");

      IF CreateCustLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
        CustLedgerEntry."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
        CustLedgerEntry.MARK(TRUE);
      END;

      CustLedgerEntry.SETCURRENTKEY("Closed by Entry No.");
      CustLedgerEntry.SETRANGE("Closed by Entry No.",CreateCustLedgEntry."Entry No.");
      IF CustLedgerEntry.FINDSET THEN
        REPEAT
          CustLedgerEntry.MARK(TRUE);
        UNTIL CustLedgerEntry.NEXT = 0;

      CustLedgerEntry.SETCURRENTKEY("Entry No.");
      CustLedgerEntry.SETRANGE("Closed by Entry No.");

      CustLedgerEntry.MARKEDONLY(TRUE);
    END;

    PROCEDURE GetDocumentHeading@6(CustLedgerEntry@1000 : Record 51516224) : Text[50];
    VAR
      Heading@1001 : Text[50];
    BEGIN
      IF CustLedgerEntry."Document Type" = 0 THEN
        Heading := Text000
      ELSE
        Heading := FORMAT(CustLedgerEntry."Document Type");
      Heading := Heading + ' ' + CustLedgerEntry."Document No.";
      EXIT(Heading);
    END;

    BEGIN
    END.
  }
}

