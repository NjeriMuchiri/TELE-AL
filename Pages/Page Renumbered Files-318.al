OBJECT page 50009 Member Statistics FactBox
{
  OBJECT-PROPERTIES
  {
    Date=06/23/23;
    Time=11:51:15 AM;
    Modified=Yes;
    Version List=NAVNA7.00;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[ENU=Member FactBox;
               ESM=Informaci¢n de cr‚dito;
               FRC=Informations sur le cr‚dit;
               ENC=Member FactBox];
    SaveValues=Yes;
    SourceTable=Table51516223;
    SourceTableView=WHERE(Employer Code=FILTER(<>STAFF));
    PageType=CardPart;
    OnOpenPage=BEGIN
                 // Default the Aging Period to 30D
                 EVALUATE(AgingPeriod,'<30D>');
                 // Initialize Record Variables
                 LatestCustLedgerEntry.RESET;
                 LatestCustLedgerEntry.SETCURRENTKEY("Document Type","Customer No.","Posting Date");
                 LatestCustLedgerEntry.SETRANGE("Document Type",LatestCustLedgerEntry."Document Type"::Payment);
                 FOR I := 1 TO ARRAYLEN(CustLedgerEntry) DO BEGIN
                   CustLedgerEntry[I].RESET;
                   CustLedgerEntry[I].SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
                   CustLedgerEntry[I].SETRANGE(Open,TRUE);
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       ChangeCustomer;
                       GetLatestPayment;
                       CalculateAging;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Field  ;
                CaptionML=ENU=Member No.;
                SourceExpr="No." }

    { 1000000001;1;Field  ;
                SourceExpr=Name }

    { 1000000005;1;Field  ;
                SourceExpr="Payroll/Staff No" }

    { 1000000003;1;Field  ;
                SourceExpr="ID No." }

    { 1000000004;1;Field  ;
                SourceExpr="Passport No." }

    { 1000000002;1;Field  ;
                SourceExpr="Mobile Phone No" }

    { 1000000019;1;Field  ;
                SourceExpr="Employer Code" }

    { 1120054003;1;Field  ;
                SourceExpr=Crblisting }

    { 39  ;1   ;Group     ;
                CaptionML=[ENU=Member Statistics FactBox;
                           ESM=Antigedad (d¡as de retraso);
                           FRC=Chronologie (affichage des jours en souffrance);
                           ENC=Aging (showing days overdue)];
                GroupType=Group }

    { 1120054006;2;Field  ;
                SourceExpr="Registration Fee Paid" }

    { 1000000007;2;Field  ;
                SourceExpr="Shares Retained" }

    { 1120054001;2;Field  ;
                SourceExpr="Current Savings" }

    { 1000000006;2;Field  ;
                SourceExpr="Current Shares" }

    { 1000000008;2;Field  ;
                SourceExpr="Un-allocated Funds" }

    { 1000000009;2;Field  ;
                SourceExpr="Benevolent Fund" }

    { 1000000010;2;Field  ;
                SourceExpr="Dividend Amount" }

    { 1120054002;2;Field  ;
                SourceExpr="Co-operative Shares" }

    { 1000000020;2;Field  ;
                SourceExpr="Outstanding Balance New" }

    { 1000000021;2;Field  ;
                Name=Outstanding Principle;
                SourceExpr="Principle Balance" }

    { 1120054000;2;Field  ;
                SourceExpr="Insurance Fund" }

    { 1000000012;2;Field  ;
                SourceExpr="Outstanding Interest" }

    { 1000000018;2;Field  ;
                SourceExpr="School Fees Shares" }

    { 1120054005;2;Field  ;
                SourceExpr="Deposits Interest Amount" }

    { 1120054004;2;Field  ;
                SourceExpr="ESS Interest Amount" }

    { 1000000017;2;Field  ;
                SourceExpr="FOSA  Account Bal" }

    { 1000000013;1;Group  ;
                CaptionML=ENU=File Movement FactBox;
                GroupType=Group }

    { 1000000014;2;Field  ;
                SourceExpr="Currect File Location" }

    { 1000000015;2;Field  ;
                SourceExpr="Loc Description" }

    { 1000000016;2;Field  ;
                SourceExpr=User }

  }
  CODE
  {
    VAR
      LatestCustLedgerEntry@1020000 : Record 21;
      CustLedgerEntry@1020001 : ARRAY [4] OF Record 21;
      AgingTitle@1020002 : ARRAY [4] OF Text[30];
      AgingPeriod@1020003 : DateFormula;
      I@1020004 : Integer;
      PeriodStart@1020005 : Date;
      PeriodEnd@1020006 : Date;
      Text002@1020009 : TextConst 'ENU=Not Yet Due;ESM=Sin retraso;FRC=Pas encore d–;ENC=Not Yet Due';
      Text003@1020010 : TextConst 'ENU=Over %1 Days;ESM=M s de %1 d¡as;FRC=Plus de %1 jours;ENC=Over %1 Days';
      Text004@1020011 : TextConst 'ENU=%1-%2 Days;ESM=%1-%2 d¡as;FRC=%1 … %2 jours;ENC=%1-%2 Days';

    PROCEDURE CalculateAgingForPeriod@7(PeriodBeginDate@1020000 : Date;PeriodEndDate@1020001 : Date;Index@1020002 : Integer);
    VAR
      CustLedgerEntry2@1020005 : Record 21;
      NumDaysToBegin@1020003 : Integer;
      NumDaysToEnd@1020004 : Integer;
    BEGIN
      // Calculate the Aged Balance for a particular Date Range
      IF PeriodEndDate = 0D THEN
        CustLedgerEntry[Index].SETFILTER("Due Date",'%1..',PeriodBeginDate)
      ELSE
        CustLedgerEntry[Index].SETRANGE("Due Date",PeriodBeginDate,PeriodEndDate);

      CustLedgerEntry2.COPY(CustLedgerEntry[Index]);
      CustLedgerEntry[Index]."Remaining Amt. (LCY)" := 0;
      IF CustLedgerEntry2.FIND('-') THEN
        REPEAT
          CustLedgerEntry2.CALCFIELDS("Remaining Amt. (LCY)");
          CustLedgerEntry[Index]."Remaining Amt. (LCY)" :=
            CustLedgerEntry[Index]."Remaining Amt. (LCY)" + CustLedgerEntry2."Remaining Amt. (LCY)";
        UNTIL CustLedgerEntry2.NEXT = 0;

      IF PeriodBeginDate <> 0D THEN
        NumDaysToBegin := WORKDATE - PeriodBeginDate;
      IF PeriodEndDate <> 0D THEN
        NumDaysToEnd := WORKDATE - PeriodEndDate;
      IF PeriodEndDate = 0D THEN
        AgingTitle[Index] := Text002
      ELSE
        IF PeriodBeginDate = 0D THEN
          AgingTitle[Index] := STRSUBSTNO(Text003,NumDaysToEnd - 1)
        ELSE
          AgingTitle[Index] := STRSUBSTNO(Text004,NumDaysToEnd,NumDaysToBegin);
    END;

    PROCEDURE CalculateAging@5();
    BEGIN
      // Calculate the Entire Aging (four Periods)
      FOR I := 1 TO ARRAYLEN(CustLedgerEntry) DO BEGIN
        CASE I OF
          1:
            BEGIN
              PeriodEnd := 0D;
              PeriodStart := WORKDATE;
            END;
          ARRAYLEN(CustLedgerEntry):
            BEGIN
              PeriodEnd := PeriodStart - 1;
              PeriodStart := 0D;
            END;
          ELSE
            BEGIN
            PeriodEnd := PeriodStart - 1;
            PeriodStart := CALCDATE('-' + FORMAT(AgingPeriod),PeriodStart);
          END;
        END;
        CalculateAgingForPeriod(PeriodStart,PeriodEnd,I);
      END;
    END;

    PROCEDURE GetLatestPayment@6();
    BEGIN
      // Find the Latest Payment
      IF LatestCustLedgerEntry.FINDLAST THEN
        LatestCustLedgerEntry.CALCFIELDS("Amount (LCY)")
      ELSE
        LatestCustLedgerEntry.INIT;
    END;

    PROCEDURE ChangeCustomer@2();
    BEGIN
      // Change the Customer Filters
      LatestCustLedgerEntry.SETRANGE("Customer No.","No.");
      FOR I := 1 TO ARRAYLEN(CustLedgerEntry) DO
        CustLedgerEntry[I].SETRANGE("Customer No.","No.");
    END;

    PROCEDURE DrillDown@11(Index@1020000 : Integer);
    BEGIN
      IF Index = 0 THEN
        PAGE.RUNMODAL(PAGE::"Customer Ledger Entries",LatestCustLedgerEntry)
      ELSE
        PAGE.RUNMODAL(PAGE::"Customer Ledger Entries",CustLedgerEntry[Index]);
    END;

    BEGIN
    END.
  }
}

