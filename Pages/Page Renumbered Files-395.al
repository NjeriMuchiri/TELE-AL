OBJECT page 50091 Posted Investor Receipt Card
{
  OBJECT-PROPERTIES
  {
    Date=10/09/15;
    Time=[ 5:31:20 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516002;
    SourceTableView=WHERE(Posted=CONST(Yes));
    PageType=Card;
    ActionList=ACTIONS
    {
      { 21      ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 28      ;1   ;Action    ;
                      Name=Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      OnAction=BEGIN
                                  IF Posted THEN BEGIN
                                   ReceiptHeader.RESET;
                                   ReceiptHeader.SETRANGE(ReceiptHeader."No.","No.");
                                   IF ReceiptHeader.FINDFIRST THEN
                                     REPORT.RUN(REPORT::"Investor Receipt",TRUE,FALSE,ReceiptHeader);
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
                SourceExpr=Date }

    { 5   ;2   ;Field     ;
                SourceExpr="Posting Date";
                ShowMandatory=True }

    { 10  ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 15  ;2   ;Field     ;
                SourceExpr="Investor No." }

    { 31  ;2   ;Field     ;
                SourceExpr="Investor Name" }

    { 18  ;2   ;Field     ;
                SourceExpr="Interest Code" }

    { 6   ;2   ;Field     ;
                SourceExpr="Bank Code";
                ShowMandatory=True }

    { 7   ;2   ;Field     ;
                SourceExpr="Bank Name" }

    { 23  ;2   ;Field     ;
                SourceExpr="Bank Balance" }

    { 8   ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code";
                ShowMandatory=True }

    { 9   ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code";
                ShowMandatory=True }

    { 12  ;2   ;Field     ;
                SourceExpr="Received From";
                ShowMandatory=True }

    { 13  ;2   ;Field     ;
                SourceExpr=Description }

    { 16  ;2   ;Field     ;
                SourceExpr="Amount Received";
                ShowMandatory=True }

    { 17  ;2   ;Field     ;
                SourceExpr="Amount Received(LCY)" }

    { 19  ;2   ;Field     ;
                SourceExpr="Total Amount" }

    { 20  ;2   ;Field     ;
                SourceExpr="Total Amount(LCY)" }

    { 11  ;2   ;Field     ;
                SourceExpr="Investor Net Amount" }

    { 14  ;2   ;Field     ;
                SourceExpr="Investor Net Amount(LCY)" }

    { 30  ;2   ;Field     ;
                SourceExpr="User ID" }

    { 29  ;2   ;Field     ;
                SourceExpr=Status }

    { 22  ;1   ;Part      ;
                SubPageLink=Document No=FIELD(No.);
                PagePartID=Page51516452;
                PartType=Page }

  }
  CODE
  {
    VAR
      FundsManager@1003 : Codeunit 51516000;
      JTemplate@1002 : Code[20];
      JBatch@1001 : Code[20];
      FundsUser@1000 : Record 51516031;
      ok@1004 : Boolean;
      ReceiptHeader@1005 : Record 51516002;

    BEGIN
    END.
  }
}

