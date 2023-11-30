OBJECT page 20455 HR Leave Family Employees List
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=11:53:17 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516409;
    PageType=List;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=Family }

    { 1102755003;2;Field  ;
                SourceExpr="Employee No" }

    { 1102755004;2;Field  ;
                SourceExpr=Remarks }

  }
  CODE
  {

    BEGIN
    END.
  }
}

