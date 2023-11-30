OBJECT page 50017 Member Monthly Contributions
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=[ 9:02:23 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516339;
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
                SourceExpr="No.";
                Visible=FALSE }

    { 1102755003;2;Field  ;
                SourceExpr=Type }

    { 1000000000;2;Field  ;
                SourceExpr="Loan No" }

    { 1000000001;2;Field  ;
                SourceExpr="Amount Off" }

    { 1102755004;2;Field  ;
                SourceExpr="Amount ON" }

    { 1102755006;2;Field  ;
                SourceExpr="Check Off Priority" }

    { 1102755005;2;Field  ;
                SourceExpr="Last Advice Date" }

    { 1   ;2   ;Field     ;
                SourceExpr=Balance }

    { 1000000002;2;Field  ;
                SourceExpr="Balance 2" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

