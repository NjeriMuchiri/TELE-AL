OBJECT page 20478 Payroll Deductions List
{
  OBJECT-PROPERTIES
  {
    Date=07/24/20;
    Time=[ 1:28:20 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516181;
    SourceTableView=WHERE(Transaction Type=CONST(Deduction));
    PageType=List;
    CardPageID=Payroll Deductions Card;
    OnOpenPage=BEGIN
                 IF UserSetup.GET(USERID) THEN
                 BEGIN
                 IF (UserSetup."Accounts Department"<>TRUE) AND (UserSetup."ICT Department"<>TRUE) THEN
                 ERROR('You Dont Have Permission To View This Module.Kindly Contact the Sytem Administrator.');
                 END;
               END;

    OnNewRecord=BEGIN
                    "Transaction Type":="Transaction Type"::Deduction;
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
    VAR
      UserSetup@1120054000 : Record 91;

    BEGIN
    END.
  }
}

