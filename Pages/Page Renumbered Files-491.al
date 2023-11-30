OBJECT page 172086 Paybill Transactions
{
  OBJECT-PROPERTIES
  {
    Date=12/15/20;
    Time=[ 5:31:53 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516712;
    SourceTableView=WHERE(Transaction Type=FILTER(Paybill|Loan Repayment|Withdrawal),
                          Reconcilled=CONST(No));
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Transaction ID" }

    { 1120054003;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1120054004;2;Field  ;
                SourceExpr="Paybill Account Entered" }

    { 1120054006;2;Field  ;
                SourceExpr=Amount }

    { 1120054007;2;Field  ;
                SourceExpr=Posted }

    { 1120054008;2;Field  ;
                SourceExpr=Reconcilled }

  }
  CODE
  {

    BEGIN
    END.
  }
}

