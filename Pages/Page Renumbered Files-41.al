OBJECT page 20405 Mobile Payment Card
{
  OBJECT-PROPERTIES
  {
    Date=09/22/15;
    Time=12:20:53 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516000;
    PageType=Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr="Document Type" }

    { 5   ;2   ;Field     ;
                SourceExpr="Payment Mode" }

    { 6   ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 7   ;2   ;Field     ;
                SourceExpr="Currency Factor" }

    { 8   ;2   ;Field     ;
                SourceExpr="Bank Account" }

    { 9   ;2   ;Field     ;
                SourceExpr="Bank Account Name" }

    { 10  ;2   ;Field     ;
                SourceExpr="Bank Account Balance" }

    { 11  ;2   ;Field     ;
                SourceExpr="Cheque Type" }

    { 12  ;2   ;Field     ;
                SourceExpr="Cheque No" }

    { 13  ;2   ;Field     ;
                SourceExpr=Payee }

    { 14  ;2   ;Field     ;
                SourceExpr="On Behalf Of" }

    { 15  ;2   ;Field     ;
                SourceExpr="Payment Description" }

    { 16  ;2   ;Field     ;
                SourceExpr=Amount }

    { 17  ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 18  ;2   ;Field     ;
                SourceExpr="VAT Amount" }

    { 19  ;2   ;Field     ;
                SourceExpr="VAT Amount(LCY)" }

    { 20  ;2   ;Field     ;
                SourceExpr="WithHolding Tax Amount" }

    { 21  ;2   ;Field     ;
                SourceExpr="WithHolding Tax Amount(LCY)" }

    { 22  ;2   ;Field     ;
                SourceExpr="Net Amount" }

    { 23  ;2   ;Field     ;
                SourceExpr="Net Amount(LCY)" }

    { 24  ;2   ;Field     ;
                SourceExpr="Document Date" }

    { 25  ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 26  ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 27  ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

    { 28  ;2   ;Field     ;
                SourceExpr="Responsibility Center" }

    { 29  ;2   ;Field     ;
                SourceExpr=Status }

    { 30  ;2   ;Field     ;
                SourceExpr=Posted }

    { 31  ;2   ;Field     ;
                SourceExpr="Posted By" }

    { 32  ;2   ;Field     ;
                SourceExpr="Date Posted" }

    { 33  ;2   ;Field     ;
                SourceExpr="Time Posted" }

    { 34  ;2   ;Field     ;
                SourceExpr=Cashier }

    { 35  ;1   ;Part      ;
                SubPageLink=Document No=FIELD(No.);
                PagePartID=Page51516002;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

