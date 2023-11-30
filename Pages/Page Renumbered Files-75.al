OBJECT page 20416 Cash Payment List(Pending)
{
  OBJECT-PROPERTIES
  {
    Date=12/10/19;
    Time=10:06:14 AM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Payment Type=CONST(Cash Purchase),
                          Posted=CONST(No),
                          Status=FILTER(Pending Approval));
    PageType=List;
    CardPageID=Cash Payment Card(Pending);
    OnNewRecord=BEGIN
                    "Payment Mode":="Payment Mode"::Cash;
                    "Payment Type":="Payment Type"::"Cash Purchase";
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
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr="Document Type" }

    { 5   ;2   ;Field     ;
                SourceExpr="Document Date" }

    { 6   ;2   ;Field     ;
                SourceExpr=Payee }

    { 7   ;2   ;Field     ;
                SourceExpr=Amount }

    { 8   ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 1000000001;2;Field  ;
                SourceExpr=Cashier }

  }
  CODE
  {

    BEGIN
    END.
  }
}

