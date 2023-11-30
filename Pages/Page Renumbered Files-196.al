OBJECT page 17387 Loan Offset Detail List
{
  OBJECT-PROPERTIES
  {
    Date=08/18/21;
    Time=11:25:42 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516235;
    PageType=List;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755003;2;Field  ;
                SourceExpr="Loan Top Up" }

    { 1102755004;2;Field  ;
                SourceExpr="Client Code";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Loan Type";
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Expected Repayment" }

    { 1102755006;2;Field  ;
                SourceExpr="Principle Top Up" }

    { 1102755016;2;Field  ;
                SourceExpr="Remaining Installments" }

    { 1102755007;2;Field  ;
                SourceExpr="Interest Top Up" }

    { 1102755008;2;Field  ;
                SourceExpr="Total Top Up" }

    { 1102755009;2;Field  ;
                SourceExpr="Monthly Repayment";
                Editable=FALSE }

    { 1102755010;2;Field  ;
                SourceExpr="Interest Paid" }

    { 1102755011;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1102755012;2;Field  ;
                SourceExpr="Interest Rate" }

    { 1102755013;2;Field  ;
                SourceExpr="ID. NO";
                Editable=FALSE }

    { 1102755014;2;Field  ;
                SourceExpr=Commision;
                Enabled=false }

    { 1102755015;2;Field  ;
                SourceExpr="Partial Bridged";
                Editable=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

