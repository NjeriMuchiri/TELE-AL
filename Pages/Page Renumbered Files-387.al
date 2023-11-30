OBJECT page 50083 Investor Receipt List
{
  OBJECT-PROPERTIES
  {
    Date=11/03/15;
    Time=[ 6:38:29 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516002;
    SourceTableView=WHERE(Receipt Category=CONST(Investor),
                          Posted=CONST(No));
    PageType=List;
    CardPageID=Investor Receipt Card;
    OnOpenPage=BEGIN
                  SETRANGE("User ID",USERID);
                  SETRANGE("Receipt Category","Receipt Category"::Investor);
               END;

    OnNewRecord=BEGIN
                     "Receipt Category":="Receipt Category"::Investor;
                END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr=Date }

    { 5   ;2   ;Field     ;
                SourceExpr="Bank Name" }

    { 6   ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 7   ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

    { 8   ;2   ;Field     ;
                SourceExpr="Amount Received" }

    { 9   ;2   ;Field     ;
                SourceExpr="User ID" }

    { 10  ;2   ;Field     ;
                SourceExpr=Status }

  }
  CODE
  {

    BEGIN
    END.
  }
}

