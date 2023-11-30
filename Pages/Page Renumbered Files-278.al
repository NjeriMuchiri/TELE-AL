OBJECT page 17469 Fixed deposit Types list
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=10:49:55 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516305;
    PageType=List;
    CardPageID=Fixed Deposit Types Card;
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
                SourceExpr=Duration }

    { 1102755004;2;Field  ;
                SourceExpr=Description }

    { 1102755005;2;Field  ;
                SourceExpr="No. of Months" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

