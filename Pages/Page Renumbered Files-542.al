OBJECT page 172137 HR Leave Batches
{
  OBJECT-PROPERTIES
  {
    Date=11/16/17;
    Time=10:40:22 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516196;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755005;2;Field  ;
                SourceExpr=Description }

    { 1102755001;2;Field  ;
                SourceExpr="Posting Description" }

    { 1102755002;2;Field  ;
                SourceExpr=Type }

  }
  CODE
  {

    BEGIN
    END.
  }
}

