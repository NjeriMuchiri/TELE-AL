OBJECT page 172056 MBanking Applications List
{
  OBJECT-PROPERTIES
  {
    Date=12/21/20;
    Time=[ 1:42:32 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516703;
    PageType=List;
    CardPageID=Mbanking Application Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr=No }

    { 4   ;2   ;Field     ;
                SourceExpr="Date Entered" }

    { 5   ;2   ;Field     ;
                SourceExpr="Time Entered" }

    { 6   ;2   ;Field     ;
                SourceExpr="Entered By" }

    { 7   ;2   ;Field     ;
                SourceExpr="Document Serial No" }

    { 8   ;2   ;Field     ;
                SourceExpr="Document Date" }

    { 9   ;2   ;Field     ;
                SourceExpr="Customer ID No" }

    { 10  ;2   ;Field     ;
                SourceExpr="Customer Name" }

    { 1120054000;2;Field  ;
                SourceExpr="MPESA Mobile No" }

    { 1120054001;2;Field  ;
                SourceExpr=Status }

  }
  CODE
  {

    BEGIN
    END.
  }
}

