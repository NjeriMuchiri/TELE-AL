OBJECT page 20477 Payroll Earnings Card
{
  OBJECT-PROPERTIES
  {
    Date=05/18/22;
    Time=[ 4:58:05 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516181;
    SourceTableView=WHERE(Transaction Type=CONST(Income));
    PageType=Card;
    OnNewRecord=BEGIN
                    "Transaction Type":="Transaction Type"::Income;
                END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="Transaction Code" }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Name" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 1120054000;2;Field  ;
                SourceExpr=Allowance }

    { 6   ;2   ;Field     ;
                SourceExpr="Balance Type" }

    { 7   ;2   ;Field     ;
                SourceExpr=Frequency }

    { 8   ;2   ;Field     ;
                SourceExpr=Taxable }

    { 9   ;2   ;Field     ;
                SourceExpr="Is Cash" }

    { 10  ;2   ;Field     ;
                SourceExpr="Is Formulae" }

    { 11  ;2   ;Field     ;
                SourceExpr=Formulae }

    { 12  ;2   ;Field     ;
                SourceExpr="G/L Account" }

    { 13  ;2   ;Field     ;
                SourceExpr="G/L Account Name" }

    { 14  ;2   ;Field     ;
                SourceExpr=SubLedger }

    { 15  ;2   ;Field     ;
                SourceExpr="Customer Posting Group" }

    { 16  ;1   ;Group     ;
                Name=Loan Details;
                GroupType=Group }

    { 17  ;2   ;Field     ;
                SourceExpr="Deduct Premium" }

    { 18  ;2   ;Field     ;
                SourceExpr="Interest Rate" }

    { 19  ;2   ;Field     ;
                SourceExpr="Repayment Method" }

    { 20  ;2   ;Field     ;
                SourceExpr="IsCo-Op/LnRep" }

    { 21  ;2   ;Field     ;
                SourceExpr="Deduct Mortgage" }

    { 22  ;1   ;Group     ;
                Name=Other Setup;
                GroupType=Group }

    { 23  ;2   ;Field     ;
                SourceExpr="Special Transaction" }

    { 24  ;2   ;Field     ;
                SourceExpr="Amount Preference" }

    { 25  ;2   ;Field     ;
                SourceExpr="Fringe Benefit" }

    { 26  ;2   ;Field     ;
                SourceExpr=IsHouseAllowance }

    { 27  ;2   ;Field     ;
                SourceExpr="Employer Deduction" }

    { 28  ;2   ;Field     ;
                SourceExpr="Include Employer Deduction" }

    { 29  ;2   ;Field     ;
                SourceExpr="Formulae for Employer" }

    { 30  ;2   ;Field     ;
                SourceExpr="Co-Op Parameters" }

    { 31  ;2   ;Field     ;
                SourceExpr=Welfare }

  }
  CODE
  {

    BEGIN
    END.
  }
}

