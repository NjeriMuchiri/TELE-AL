OBJECT page 50081 Investor Statistics FactBox
{
  OBJECT-PROPERTIES
  {
    Date=11/16/15;
    Time=[ 9:52:51 AM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    CaptionML=ENU=Investor Statistics;
    SourceTable=Table51516433;
    PageType=CardPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 19  ;1   ;Field     ;
                CaptionML=ENU=Investor No.;
                SourceExpr=Code;
                OnDrillDown=BEGIN
                              ShowDetails;
                            END;
                             }

    { 13  ;1   ;Field     ;
                SourceExpr="Balance (LCY)";
                OnDrillDown=VAR
                              DtldInvestorLedgEntry@1000 : Record 51516435;
                              InvestorLedgEntry@1001 : Record 51516434;
                            BEGIN
                              DtldInvestorLedgEntry.SETRANGE("Exit Target",Code);
                              COPYFILTER("Global Dimension 1 Filter",DtldInvestorLedgEntry."Initial Entry Global Dim. 1");
                              COPYFILTER("Global Dimension 2 Filter",DtldInvestorLedgEntry."Initial Entry Global Dim. 2");
                              COPYFILTER("Currency Filter",DtldInvestorLedgEntry.Status);
                              InvestorLedgEntry.DrillDownOnEntries(DtldInvestorLedgEntry);
                            END;
                             }

  }
  CODE
  {
    VAR
      Text000@1024 : TextConst 'ENU=Overdue Amounts (LCY) as of %1';

    PROCEDURE ShowDetails@1102601000();
    BEGIN
      PAGE.RUN(PAGE::"Investor Active Account Card",Rec);
    END;

    BEGIN
    END.
  }
}

