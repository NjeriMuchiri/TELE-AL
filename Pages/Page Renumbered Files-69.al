OBJECT page 20433 Receipt Types List
{
  OBJECT-PROPERTIES
  {
    Date=10/02/15;
    Time=[ 8:36:23 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516032;
    SourceTableView=WHERE(Transaction Type=CONST(Receipt));
    PageType=List;
    CardPageID=Receipt Types Card;
    OnNewRecord=BEGIN
                    "Transaction Type":="Transaction Type"::Receipt;
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
                SourceExpr="Transaction Code" }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Description" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 7   ;2   ;Field     ;
                SourceExpr="Account No" }

    { 8   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Default Grouping" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

