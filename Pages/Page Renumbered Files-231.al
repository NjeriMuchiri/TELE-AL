OBJECT page 17422 Loan Charges
{
  OBJECT-PROPERTIES
  {
    Date=11/09/22;
    Time=10:21:04 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516241;
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
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                SourceExpr=Amount }

    { 6   ;2   ;Field     ;
                SourceExpr=Percentage }

    { 7   ;2   ;Field     ;
                SourceExpr="G/L Account" }

    { 8   ;2   ;Field     ;
                SourceExpr="Use Perc" }

    { 1120054000;2;Field  ;
                SourceExpr="Upfront Interest" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

