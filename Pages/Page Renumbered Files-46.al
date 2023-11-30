OBJECT page 20410 Receipt Header List
{
  OBJECT-PROPERTIES
  {
    Date=11/03/15;
    Time=[ 6:37:57 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516002;
    PageType=List;
    CardPageID=Receipt Header Card;
    OnOpenPage=BEGIN
                  SETRANGE("User ID",USERID);
                  SETRANGE("Receipt Category","Receipt Category"::Normal);
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
                SourceExpr=Status }

    { 6   ;2   ;Field     ;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                SourceExpr="Received From" }

    { 16  ;2   ;Field     ;
                SourceExpr="Amount Received(LCY)" }

    { 17  ;2   ;Field     ;
                SourceExpr="Total Amount" }

    { 22  ;2   ;Field     ;
                SourceExpr="User ID" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

