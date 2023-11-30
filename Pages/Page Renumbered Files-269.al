OBJECT page 17460 ATM Cards Application List
{
  OBJECT-PROPERTIES
  {
    Date=10/01/18;
    Time=10:16:24 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=Yes;
    SourceTable=Table51516321;
    PageType=List;
    CardPageID=ATM Applications Card;
  }
  CONTROLS
  {
    { 16  ;0   ;Container ;
                ContainerType=ContentArea }

    { 15  ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1120054000;2;Field  ;
                SourceExpr="Account No" }

    { 14  ;2   ;Field     ;
                SourceExpr="No." }

    { 13  ;2   ;Field     ;
                SourceExpr="Request Type" }

    { 12  ;2   ;Field     ;
                SourceExpr="Account No" }

    { 11  ;2   ;Field     ;
                SourceExpr="Branch Code" }

    { 10  ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 9   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 8   ;2   ;Field     ;
                SourceExpr=Address }

    { 7   ;2   ;Field     ;
                SourceExpr="Address 2" }

    { 6   ;2   ;Field     ;
                SourceExpr="Address 3" }

    { 5   ;2   ;Field     ;
                SourceExpr="Address 4" }

    { 4   ;2   ;Field     ;
                SourceExpr="Address 5" }

    { 3   ;2   ;Field     ;
                SourceExpr="Customer ID" }

    { 2   ;2   ;Field     ;
                SourceExpr="Relation Indicator" }

    { 1   ;2   ;Field     ;
                SourceExpr="Card Type" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

