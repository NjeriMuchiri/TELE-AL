OBJECT page 20482 Payroll NSSF Setup
{
  OBJECT-PROPERTIES
  {
    Date=02/27/23;
    Time=[ 2:12:20 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516215;
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
                SourceExpr="Tier Code" }

    { 4   ;2   ;Field     ;
                SourceExpr=Earnings }

    { 5   ;2   ;Field     ;
                SourceExpr="Pensionable Earnings" }

    { 6   ;2   ;Field     ;
                SourceExpr="Tier 1 earnings" }

    { 7   ;2   ;Field     ;
                SourceExpr="Tier 1 Employee Deduction" }

    { 8   ;2   ;Field     ;
                SourceExpr="Tier 1 Employer Contribution" }

    { 9   ;2   ;Field     ;
                SourceExpr="Tier 2 earnings" }

    { 10  ;2   ;Field     ;
                SourceExpr="Tier 2 Employee Deduction" }

    { 11  ;2   ;Field     ;
                SourceExpr="Tier 2 Employer Contribution" }

    { 12  ;2   ;Field     ;
                SourceExpr="Lower Limit" }

    { 13  ;2   ;Field     ;
                SourceExpr="Upper Limit" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

