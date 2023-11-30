OBJECT page 20481 Payroll NHIF Setup
{
  OBJECT-PROPERTIES
  {
    Date=05/30/16;
    Time=10:10:53 AM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516214;
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
                SourceExpr="NHIF Tier" }

    { 5   ;2   ;Field     ;
                SourceExpr=Amount }

    { 6   ;2   ;Field     ;
                SourceExpr="Lower Limit" }

    { 7   ;2   ;Field     ;
                SourceExpr="Upper Limit" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

