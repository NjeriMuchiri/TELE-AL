OBJECT page 20400 PettyCash Payment Line
{
  OBJECT-PROPERTIES
  {
    Date=11/27/15;
    Time=[ 5:44:01 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516001;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Payment Type" }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Type Description" }

    { 5   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="Account No." }

    { 7   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 8   ;2   ;Field     ;
                SourceExpr="Payment Description" }

    { 11  ;2   ;Field     ;
                SourceExpr=Amount }

    { 12  ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 22  ;2   ;Field     ;
                SourceExpr="Net Amount" }

    { 23  ;2   ;Field     ;
                SourceExpr="Net Amount(LCY)" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

