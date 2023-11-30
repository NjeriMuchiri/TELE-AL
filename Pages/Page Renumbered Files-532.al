OBJECT page 172127 Posted Property Receipt Card
{
  OBJECT-PROPERTIES
  {
    Date=10/21/15;
    Time=[ 8:13:05 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516002;
    SourceTableView=WHERE(Receipt Category=CONST(Property),
                          Posted=CONST(Yes));
    PageType=Card;
    OnNewRecord=BEGIN
                     "Receipt Category":="Receipt Category"::Property;
                END;

    ActionList=ACTIONS
    {
      { 27      ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 29      ;1   ;Action    ;
                      Name=Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                   ReceiptHeader.RESET;
                                   ReceiptHeader.SETRANGE(ReceiptHeader."No.","No.");
                                   IF ReceiptHeader.FINDFIRST THEN BEGIN
                                      REPORT.RUNMODAL(REPORT::"Property Receipt",TRUE,FALSE,ReceiptHeader);
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
                SourceExpr="Document Type" }

    { 5   ;2   ;Field     ;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 7   ;2   ;Field     ;
                SourceExpr="Bank Code" }

    { 8   ;2   ;Field     ;
                SourceExpr="Bank Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Bank Balance" }

    { 10  ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 11  ;2   ;Field     ;
                SourceExpr="Project Code" }

    { 24  ;2   ;Field     ;
                SourceExpr="Project Name" }

    { 25  ;2   ;Field     ;
                SourceExpr="Property Code" }

    { 26  ;2   ;Field     ;
                SourceExpr="Property Name" }

    { 12  ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 13  ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

    { 14  ;2   ;Field     ;
                SourceExpr="Responsibility Center" }

    { 15  ;2   ;Field     ;
                SourceExpr="Amount Received" }

    { 16  ;2   ;Field     ;
                SourceExpr="Amount Received(LCY)" }

    { 17  ;2   ;Field     ;
                SourceExpr="Total Amount" }

    { 18  ;2   ;Field     ;
                SourceExpr=Status }

    { 19  ;2   ;Field     ;
                SourceExpr=Description }

    { 20  ;2   ;Field     ;
                SourceExpr="Received From" }

    { 21  ;2   ;Field     ;
                SourceExpr="User ID" }

    { 22  ;2   ;Field     ;
                SourceExpr="Total Amount(LCY)" }

    { 23  ;1   ;Part      ;
                SubPageLink=Document No=FIELD(No.);
                PagePartID=Page51516865;
                PartType=Page }

  }
  CODE
  {
    VAR
      FundsManager@1007 : Codeunit 51516000;
      JTemplate@1006 : Code[20];
      JBatch@1005 : Code[20];
      FundsUser@1004 : Record 51516031;
      ok@1003 : Boolean;
      ReceiptHeader@1002 : Record 51516002;
      PostedEntry@1001 : Boolean;
      DocNo@1000 : Code[20];

    BEGIN
    END.
  }
}

