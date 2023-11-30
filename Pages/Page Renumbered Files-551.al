OBJECT page 172146 HR Jobs Factbox
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=[ 9:42:14 AM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516100;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                                        VALIDATE("Vacant Positions");
                     END;

  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755002;1;Field  ;
                SourceExpr="Job ID" }

    { 1102755003;1;Field  ;
                SourceExpr="Job Description" }

    { 1102755004;1;Field  ;
                SourceExpr="No of Posts" }

    { 1102755005;1;Field  ;
                SourceExpr="Position Reporting to" }

    { 1102755006;1;Field  ;
                SourceExpr="Occupied Positions" }

    { 1102755007;1;Field  ;
                SourceExpr="Vacant Positions" }

    { 1102755008;1;Field  ;
                SourceExpr=Category }

    { 1102755009;1;Field  ;
                SourceExpr=Grade }

    { 1102755010;1;Field  ;
                SourceExpr="Employee Requisitions" }

    { 1102755011;1;Field  ;
                SourceExpr="Supervisor Name" }

    { 1102755012;1;Field  ;
                SourceExpr=Status }

    { 1102755013;1;Field  ;
                SourceExpr="Responsibility Center" }

    { 1102755014;1;Field  ;
                SourceExpr="Date Created" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

