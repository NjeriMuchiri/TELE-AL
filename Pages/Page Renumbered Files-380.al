OBJECT page 50071 Investor Group List
{
  OBJECT-PROPERTIES
  {
    Date=10/04/15;
    Time=[ 8:36:47 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516438;
    PageType=List;
    CardPageID=Investor Group Card;
    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=NewDocumentItems }
      { 7       ;1   ;ActionGroup;
                      Name=Card }
      { 8       ;2   ;Action    ;
                      Name=View Card;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Card;
                      OnAction=BEGIN
                                    PAGE.RUN(PAGE::"Investor Group Card",Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="ID/Passport No" }

    { 4   ;2   ;Field     ;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                SourceExpr="Mobile No." }

  }
  CODE
  {

    BEGIN
    END.
  }
}

