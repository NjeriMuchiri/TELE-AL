OBJECT page 20406 Mobile Payment Line
{
  OBJECT-PROPERTIES
  {
    Date=10/21/15;
    Time=[ 6:57:15 PM];
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
                SourceExpr="Payment Type";
                TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Payment)) }

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

    { 9   ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 10  ;2   ;Field     ;
                SourceExpr="Currency Factor" }

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

    { 19  ;2   ;Field     ;
                SourceExpr="Retention Code" }

    { 20  ;2   ;Field     ;
                SourceExpr="Retention Amount" }

    { 21  ;2   ;Field     ;
                SourceExpr="Retention Amount(LCY)" }

    { 22  ;2   ;Field     ;
                SourceExpr="Net Amount" }

    { 23  ;2   ;Field     ;
                SourceExpr="Net Amount(LCY)" }

    { 24  ;2   ;Field     ;
                SourceExpr="Gen. Bus. Posting Group" }

    { 25  ;2   ;Field     ;
                SourceExpr="Gen. Prod. Posting Group" }

    { 26  ;2   ;Field     ;
                SourceExpr="VAT Bus. Posting Group" }

    { 27  ;2   ;Field     ;
                SourceExpr="VAT Prod. Posting Group" }

    { 28  ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 29  ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

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

