OBJECT page 17494 MPESA Applications Approved
{
  OBJECT-PROPERTIES
  {
    Date=09/27/13;
    Time=[ 1:09:05 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516330;
    SourceTableView=WHERE(Status=CONST(Approved));
    PageType=Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr=No }

    { 1102755003;2;Field  ;
                SourceExpr="Document Serial No" }

    { 1102755004;2;Field  ;
                SourceExpr="Document Date" }

    { 1102755005;2;Field  ;
                SourceExpr="Customer ID No" }

    { 1102755006;2;Field  ;
                SourceExpr="Customer Name" }

    { 1102755007;2;Field  ;
                SourceExpr="MPESA Mobile No" }

    { 1102755008;2;Field  ;
                SourceExpr=Comments }

    { 1102755009;2;Field  ;
                SourceExpr="Rejection Reason" }

    { 1102755010;2;Field  ;
                SourceExpr="Date Entered" }

    { 1102755011;2;Field  ;
                SourceExpr="Time Entered" }

    { 1102755012;2;Field  ;
                SourceExpr="Entered By" }

    { 1102755013;2;Field  ;
                SourceExpr=Status }

    { 1102755014;2;Field  ;
                SourceExpr="Sent To Server" }

    { 1102755015;2;Field  ;
                SourceExpr="Date Approved" }

    { 1102755016;2;Field  ;
                SourceExpr="Time Approved" }

    { 1102755017;2;Field  ;
                SourceExpr="Approved By" }

    { 1102755018;2;Field  ;
                SourceExpr="Date Rejected" }

    { 1102755019;2;Field  ;
                SourceExpr="Time Rejected" }

    { 1102755020;2;Field  ;
                SourceExpr="Rejected By" }

    { 1102755021;2;Field  ;
                SourceExpr="Withdrawal Limit Amount" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

