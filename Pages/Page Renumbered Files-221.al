OBJECT page 17412 Deposits tier Setups
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=[ 6:56:29 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516261;
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
                SourceExpr=Code }

    { 1102755003;2;Field  ;
                SourceExpr=Description }

    { 1102755004;2;Field  ;
                SourceExpr="Minimum Amount" }

    { 1102755005;2;Field  ;
                SourceExpr="Maximum Amount" }

    { 1102755006;2;Field  ;
                SourceExpr="Minimum Dep Contributions" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

