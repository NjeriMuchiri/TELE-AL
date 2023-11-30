OBJECT page 20480 Payroll PAYE Setup
{
  OBJECT-PROPERTIES
  {
    Date=07/24/20;
    Time=[ 1:36:47 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516213;
    PageType=List;
    OnOpenPage=BEGIN
                 IF UserSetup.GET(USERID) THEN
                 BEGIN
                 IF (UserSetup."Accounts Department"<>TRUE) AND (UserSetup."ICT Department"<>TRUE) THEN
                 ERROR('You Dont Have Permission To View This Module.Kindly Contact the Sytem Administrator.');
                 END;
               END;

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
                SourceExpr="PAYE Tier" }

    { 5   ;2   ;Field     ;
                SourceExpr=Rate }

  }
  CODE
  {
    VAR
      UserSetup@1120054000 : Record 91;

    BEGIN
    END.
  }
}

