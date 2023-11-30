OBJECT page 17455 Banks
{
  OBJECT-PROPERTIES
  {
    Date=10/12/15;
    Time=[ 3:35:44 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516311;
    PageType=Card;
  }
  CONTROLS
  {
    { 6   ;0   ;Container ;
                ContainerType=ContentArea }

    { 5   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                SourceExpr=Code }

    { 3   ;2   ;Field     ;
                SourceExpr="Bank Name" }

    { 2   ;2   ;Field     ;
                SourceExpr=Branch }

    { 1   ;2   ;Field     ;
                SourceExpr="Bank Code" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

