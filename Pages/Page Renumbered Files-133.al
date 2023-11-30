OBJECT page 20474 Payroll Employee Earnings
{
  OBJECT-PROPERTIES
  {
    Date=09/02/20;
    Time=[ 3:21:59 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=Yes;
    SourceTable=Table51516182;
    SourceTableView=WHERE(Transaction Type=CONST(Income));
    PageType=List;
    OnOpenPage=BEGIN

                 PayPeriod.RESET;
                 PayPeriod.SETRANGE(PayPeriod.Closed,FALSE);
                 IF PayPeriod.FIND('-') THEN
                 BEGIN
                 PPeriod:=PayPeriod."Date Opened";

                 END;
                 SETFILTER("Payroll Period",FORMAT(PayPeriod."Date Opened"));
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
                SourceExpr="Transaction Code";
                TableRelation="Payroll Transaction Code"."Transaction Code" WHERE (Transaction Type=CONST(Income)) }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Name" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 6   ;2   ;Field     ;
                SourceExpr=Amount }

    { 7   ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 8   ;2   ;Field     ;
                SourceExpr=Balance }

    { 9   ;2   ;Field     ;
                SourceExpr="Balance(LCY)" }

    { 10  ;2   ;Field     ;
                SourceExpr="Period Month" }

    { 11  ;2   ;Field     ;
                SourceExpr="Period Year" }

    { 12  ;2   ;Field     ;
                SourceExpr="Payroll Period" }

  }
  CODE
  {
    VAR
      PayPeriod@1000000000 : Record 51516185;
      PPeriod@1000000001 : Date;

    BEGIN
    END.
  }
}

