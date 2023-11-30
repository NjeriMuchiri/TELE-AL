OBJECT page 17420 Employer list
{
  OBJECT-PROPERTIES
  {
    Date=11/02/15;
    Time=[ 6:25:54 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516260;
    PageType=List;
    CardPageID=Paybill Processing Header;
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
                SourceExpr="Repayment Method" }

    { 6   ;2   ;Field     ;
                SourceExpr="Check Off" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

