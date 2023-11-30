OBJECT page 20386 Payment List
{
  OBJECT-PROPERTIES
  {
    Date=07/06/23;
    Time=11:05:12 AM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Payment Type=CONST(Normal),
                          Posted=CONST(No),
                          Investor Payment=CONST(No));
    PageType=List;
    CardPageID=Payment Card;
    OnNewRecord=BEGIN
                    "Payment Mode":="Payment Mode"::Cheque;
                    "Payment Type":="Payment Type"::Normal;
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

    { 1000000000;2;Field  ;
                SourceExpr=Cashier }

    { 1120054000;2;Field  ;
                SourceExpr=Status }

  }
  CODE
  {

    BEGIN
    END.
  }
}

