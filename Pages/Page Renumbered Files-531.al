OBJECT page 172126 Posted Property Receipt List
{
  OBJECT-PROPERTIES
  {
    Date=10/21/15;
    Time=[ 7:23:15 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516002;
    SourceTableView=WHERE(Receipt Category=CONST(Property),
                          Posted=CONST(Yes));
    PageType=List;
    CardPageID=Posted Property Receipt Card;
    OnNewRecord=BEGIN
                    "Receipt Category":="Receipt Category"::Property;
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

