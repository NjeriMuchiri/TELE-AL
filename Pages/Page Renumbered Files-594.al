OBJECT page 172189 Debt Change List
{
  OBJECT-PROPERTIES
  {
    Date=09/23/22;
    Time=12:47:45 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516925;
    SourceTableView=WHERE(Posted=CONST(No));
    PageType=List;
    CardPageID=Debt Change Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Change No" }

    { 1120054003;2;Field  ;
                SourceExpr="Collector Code" }

    { 1120054004;2;Field  ;
                SourceExpr="Collector Name" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

