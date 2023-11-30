OBJECT page 20437 Funds Tax Codes List
{
  OBJECT-PROPERTIES
  {
    Date=10/04/15;
    Time=[ 8:51:10 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516033;
    PageType=List;
    CardPageID=Funds Tax Codes Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Tax Code" }

    { 4   ;2   ;Field     ;
                SourceExpr=Description }

  }
  CODE
  {

    BEGIN
    END.
  }
}

