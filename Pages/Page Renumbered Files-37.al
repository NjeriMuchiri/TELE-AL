OBJECT page 20401 Posted PettyCash Payment List
{
  OBJECT-PROPERTIES
  {
    Date=06/15/16;
    Time=[ 9:27:12 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Payment Type=CONST(Petty Cash),
                          Posted=CONST(Yes));
    PageType=List;
    CardPageID=Posted PettyCash Payment Card;
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

  }
  CODE
  {

    BEGIN
    END.
  }
}

