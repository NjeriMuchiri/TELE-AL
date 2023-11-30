OBJECT page 20391 Posted Payment Line
{
  OBJECT-PROPERTIES
  {
    Date=11/12/15;
    Time=[ 5:12:54 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516001;
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

    { 13  ;2   ;Field     ;
                SourceExpr="VAT Code" }

    { 14  ;2   ;Field     ;
                SourceExpr="VAT Amount" }

    { 15  ;2   ;Field     ;
                SourceExpr="VAT Amount(LCY)" }

    { 16  ;2   ;Field     ;
                SourceExpr="W/TAX Code" }

    { 17  ;2   ;Field     ;
                SourceExpr="W/TAX Amount" }

    { 18  ;2   ;Field     ;
                SourceExpr="W/TAX Amount(LCY)" }

    { 22  ;2   ;Field     ;
                SourceExpr="Net Amount" }

    { 23  ;2   ;Field     ;
                SourceExpr="Net Amount(LCY)" }

    { 30  ;2   ;Field     ;
                SourceExpr="Applies-to Doc. Type" }

    { 31  ;2   ;Field     ;
                SourceExpr="Applies-to Doc. No." }

    { 32  ;2   ;Field     ;
                SourceExpr="Applies-to ID" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

