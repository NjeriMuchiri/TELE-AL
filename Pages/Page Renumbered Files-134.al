OBJECT page 20475 Payroll Employee Deductions
{
  OBJECT-PROPERTIES
  {
    Date=09/02/20;
    Time=[ 3:18:55 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516182;
    SourceTableView=WHERE(Transaction Type=CONST(Deduction));
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
                TableRelation="Payroll Transaction Code"."Transaction Code" WHERE (Transaction Type=CONST(Deduction)) }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Name" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type";
                Editable=true }

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

    { 1000000000;2;Field  ;
                SourceExpr="Loan Number" }

    { 1000000001;2;Field  ;
                SourceExpr="No." }

    { 1000000003;2;Field  ;
                SourceExpr="No of Units" }

    { 1000000002;2;Field  ;
                SourceExpr="Original Amount" }

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

