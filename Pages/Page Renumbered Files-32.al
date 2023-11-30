OBJECT page 20396 Posted Cash Payment Card
{
  OBJECT-PROPERTIES
  {
    Date=11/27/15;
    Time=[ 5:47:16 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Payment Type=CONST(Cash Purchase),
                          Posted=CONST(Yes));
    PageType=Card;
    ActionList=ACTIONS
    {
      { 36      ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 38      ;1   ;Action    ;
                      Name=Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                   PHeader.RESET;
                                   PHeader.SETRANGE(PHeader."No.","No.");
                                   IF PHeader.FINDFIRST THEN BEGIN
                                     REPORT.RUNMODAL(REPORT::"Cash Voucher",TRUE,FALSE,PHeader);
                                   END;
                               END;
                                }
    }
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
                SourceExpr="Document Date" }

    { 7   ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 6   ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                SourceExpr="Bank Account" }

    { 9   ;2   ;Field     ;
                SourceExpr="Bank Account Name" }

    { 10  ;2   ;Field     ;
                SourceExpr="Bank Account Balance" }

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
                PagePartID=Page51516011;
                PartType=Page }

  }
  CODE
  {
    VAR
      PHeader@1000 : Record 51516000;

    BEGIN
    END.
  }
}

