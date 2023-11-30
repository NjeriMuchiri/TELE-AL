OBJECT page 17419 Loan Product Charges
{
  OBJECT-PROPERTIES
  {
    Date=11/09/22;
    Time=10:22:04 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516242;
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
                SourceExpr="Product Code" }

    { 4   ;2   ;Field     ;
                SourceExpr=Code }

    { 5   ;2   ;Field     ;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                SourceExpr=Amount }

    { 7   ;2   ;Field     ;
                SourceExpr=Percentage }

    { 8   ;2   ;Field     ;
                SourceExpr="G/L Account" }

    { 9   ;2   ;Field     ;
                SourceExpr="Use Perc" }

    { 1120054000;2;Field  ;
                SourceExpr="Account Type";
                Visible=false }

    { 1120054001;2;Field  ;
                SourceExpr="Retain Deposits" }

    { 1120054002;2;Field  ;
                CaptionML=ENU=Retain Share Capital;
                SourceExpr="Retain ShareCapital" }

    { 1120054003;2;Field  ;
                SourceExpr="Upfront Interest" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

