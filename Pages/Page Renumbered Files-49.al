OBJECT page 20413 Posted Receipt Header List
{
  OBJECT-PROPERTIES
  {
    Date=02/10/22;
    Time=[ 5:08:13 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516002;
    PageType=List;
    CardPageID=Posted Receipt Header Card;
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

