OBJECT page 20398 PettyCash Payment List
{
  OBJECT-PROPERTIES
  {
    Date=11/13/15;
    Time=[ 9:14:43 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Payment Type=CONST(Petty Cash),
                          Posted=CONST(No));
    PageType=List;
    CardPageID=PettyCash Payment Card;
    OnNewRecord=BEGIN
                    "Payment Mode":="Payment Mode"::Cash;
                    "Payment Type":="Payment Type"::"Petty Cash";
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

  }
  CODE
  {

    BEGIN
    END.
  }
}

