OBJECT page 172178 Debt Collectors List
{
  OBJECT-PROPERTIES
  {
    Date=02/02/23;
    Time=[ 1:51:19 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516918;
    PageType=List;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr=Code }

    { 1120054003;2;Field  ;
                SourceExpr="Collectors Name" }

    { 1120054004;2;Field  ;
                SourceExpr=Rate }

    { 1120054005;2;Field  ;
                SourceExpr=UserID }

  }
  CODE
  {

    BEGIN
    END.
  }
}

