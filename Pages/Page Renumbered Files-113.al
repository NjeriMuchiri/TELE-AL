OBJECT page 20454 HR Leave Family Groups List
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=11:56:54 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516408;
    PageType=List;
    CardPageID=HR Leave Family Groups Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=Code }

    { 1102755003;2;Field  ;
                SourceExpr=Description }

    { 1102755004;2;Field  ;
                SourceExpr=Remarks }

    { 1102755005;2;Field  ;
                SourceExpr="Max Employees On Leave" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

