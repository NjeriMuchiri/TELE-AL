OBJECT page 17448 EFT List
{
  OBJECT-PROPERTIES
  {
    Date=10/12/15;
    Time=[ 2:24:02 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516314;
    PageType=List;
    CardPageID=EFT Header Card;
  }
  CONTROLS
  {
    { 21  ;0   ;Container ;
                ContainerType=ContentArea }

    { 20  ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 19  ;2   ;Field     ;
                SourceExpr=No }

    { 18  ;2   ;Field     ;
                SourceExpr="No. Series" }

    { 17  ;2   ;Field     ;
                SourceExpr=Transferred }

    { 16  ;2   ;Field     ;
                SourceExpr="Date Transferred" }

    { 15  ;2   ;Field     ;
                SourceExpr="Time Transferred" }

    { 14  ;2   ;Field     ;
                SourceExpr="Transferred By" }

    { 13  ;2   ;Field     ;
                SourceExpr="Date Entered" }

    { 12  ;2   ;Field     ;
                SourceExpr="Time Entered" }

    { 11  ;2   ;Field     ;
                SourceExpr="Entered By" }

    { 10  ;2   ;Field     ;
                SourceExpr=Remarks }

    { 9   ;2   ;Field     ;
                SourceExpr="Payee Bank Name" }

    { 8   ;2   ;Field     ;
                SourceExpr="Bank  No" }

    { 7   ;2   ;Field     ;
                SourceExpr="Salary Processing No." }

    { 6   ;2   ;Field     ;
                SourceExpr="Salary Options" }

    { 5   ;2   ;Field     ;
                SourceExpr=Total }

    { 4   ;2   ;Field     ;
                SourceExpr="Total Count" }

    { 3   ;2   ;Field     ;
                SourceExpr=RTGS }

    { 2   ;2   ;Field     ;
                SourceExpr="Document No. Filter" }

    { 1   ;2   ;Field     ;
                SourceExpr="Date Filter" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

