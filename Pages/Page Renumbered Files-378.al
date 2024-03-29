OBJECT page 50069 Investor NextOfKin List
{
  OBJECT-PROPERTIES
  {
    Date=09/13/15;
    Time=12:30:50 PM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516432;
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
                SourceExpr="ID/Birth Cert No" }

    { 4   ;2   ;Field     ;
                SourceExpr=Surname }

    { 5   ;2   ;Field     ;
                SourceExpr=Firstname }

    { 6   ;2   ;Field     ;
                SourceExpr=Lastname }

    { 7   ;2   ;Field     ;
                SourceExpr=Relationship }

    { 8   ;2   ;Field     ;
                SourceExpr=Percentage }

    { 9   ;2   ;Field     ;
                SourceExpr=Address }

  }
  CODE
  {

    BEGIN
    END.
  }
}

