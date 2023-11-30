OBJECT page 17423 Loan Collateral Setup
{
  OBJECT-PROPERTIES
  {
    Date=11/02/15;
    Time=[ 1:33:06 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516245;
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
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                SourceExpr=Type }

    { 5   ;2   ;Field     ;
                SourceExpr="Security Description" }

    { 6   ;2   ;Field     ;
                SourceExpr=Category }

    { 7   ;2   ;Field     ;
                SourceExpr="Collateral Multiplier" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

