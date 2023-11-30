OBJECT page 20485 Payroll Transaction List
{
  OBJECT-PROPERTIES
  {
    Date=10/15/15;
    Time=[ 6:11:20 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516181;
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
                SourceExpr="Transaction Code" }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Name" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 6   ;2   ;Field     ;
                SourceExpr=Taxable }

  }
  CODE
  {

    BEGIN
    END.
  }
}

