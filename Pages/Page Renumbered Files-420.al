OBJECT page 172015 Denominations
{
  OBJECT-PROPERTIES
  {
    Date=05/11/16;
    Time=[ 5:28:03 PM];
    Modified=Yes;
    Version List=CBS;
  }
  PROPERTIES
  {
    SourceTable=Table51516303;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                SourceExpr=Value }

    { 6   ;2   ;Field     ;
                SourceExpr=Type }

    { 7   ;2   ;Field     ;
                SourceExpr=Priority }

  }
  CODE
  {

    BEGIN
    END.
  }
}

