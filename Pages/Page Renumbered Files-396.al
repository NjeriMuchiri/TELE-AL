OBJECT page 50092 Investor Posting Group
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=11:45:10 PM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516450;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Posting Code" }

    { 4   ;2   ;Field     ;
                SourceExpr="Posting Group Description" }

    { 5   ;2   ;Field     ;
                SourceExpr="Investor Deposit A/C" }

    { 6   ;2   ;Field     ;
                SourceExpr="Interest Payables A/C" }

    { 7   ;2   ;Field     ;
                SourceExpr="Interest Expense A/C" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

