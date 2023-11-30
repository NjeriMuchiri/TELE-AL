OBJECT page 17389 Loans Rejected List
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=[ 5:26:29 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516230;
    SourceTableView=WHERE(Loan Status=FILTER(Rejected),
                          Approval Status=FILTER(Rejected));
    PageType=List;
    CardPageID=Loans Rejected Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="Loan  No." }

    { 1102755003;2;Field  ;
                SourceExpr="Application Date" }

    { 1102755004;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1102755005;2;Field  ;
                SourceExpr="Client Code" }

    { 1102755006;2;Field  ;
                SourceExpr="Requested Amount" }

    { 1102755007;2;Field  ;
                SourceExpr="Approved Amount" }

    { 1102755008;2;Field  ;
                SourceExpr=Interest }

    { 1102755009;2;Field  ;
                SourceExpr=Insurance }

    { 1102755010;2;Field  ;
                SourceExpr="Source of Funds" }

    { 1102755011;2;Field  ;
                SourceExpr="Client Cycle" }

    { 1102755012;2;Field  ;
                SourceExpr="Client Name" }

    { 1102755013;2;Field  ;
                SourceExpr="Loan Status" }

    { 1102755014;2;Field  ;
                SourceExpr="Issued Date" }

    { 1102755015;2;Field  ;
                SourceExpr=Installments }

    { 1102755016;2;Field  ;
                SourceExpr="Loan Disbursement Date" }

    { 1102755017;2;Field  ;
                SourceExpr="Mode of Disbursement" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

