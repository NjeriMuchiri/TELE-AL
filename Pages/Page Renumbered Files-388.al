OBJECT page 50084 Investor Receipt Card
{
  OBJECT-PROPERTIES
  {
    Date=11/07/15;
    Time=10:32:54 AM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516002;
    SourceTableView=WHERE(Receipt Category=CONST(Investor),
                          Posted=CONST(No));
    PageType=Card;
    OnNewRecord=BEGIN
                      "Receipt Category":="Receipt Category"::Investor;
                END;

    ActionList=ACTIONS
    {
      { 21      ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 24      ;1   ;Action    ;
                      Name=Post Receipt;
                      CaptionML=ENU=Post Receipt;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      OnAction=BEGIN
                                 //TESTFIELD(Status,Status::Approved);
                                 CALCFIELDS("Investor Net Amount","Investor Net Amount(LCY)","Total Amount");
                                 IF "Total Amount"<>"Amount Received" THEN
                                   ERROR('The amount received entered must be equal to the total amount in lines');
                                 ok:=CONFIRM('Post Receipt No:'+FORMAT("No.")+'. The Investor account will be credited with KES:'+FORMAT("Investor Net Amount(LCY)")+' Continue?');
                                 IF ok THEN BEGIN
                                   DocNo:="No.";
                                   IF FundsUser.GET(USERID) THEN BEGIN
                                     FundsUser.TESTFIELD(FundsUser."Receipt Journal Template");
                                     FundsUser.TESTFIELD(FundsUser."Receipt Journal Batch");
                                     JTemplate:=FundsUser."Receipt Journal Template";JBatch:=FundsUser."Receipt Journal Batch";
                                     PostedEntry:=FundsManager.PostInvestorReceipt(Rec,JTemplate,JBatch);

                                     {IF PostedEntry THEN BEGIN
                                       ReceiptHeader.RESET;
                                       ReceiptHeader.SETRANGE(ReceiptHeader."No.",DocNo);
                                       IF ReceiptHeader.FINDFIRST THEN BEGIN
                                         REPORT.RUNMODAL(REPORT::"Investor Receipt",TRUE,FALSE,ReceiptHeader);
                                       END;
                                     END;}
                                   END ELSE BEGIN
                                     ERROR('User Account Not Setup');
                                   END;
                                 END;
                               END;
                                }
      { 28      ;1   ;Action    ;
                      Name=Print;
                      OnAction=BEGIN
                                   ReceiptHeader.RESET;
                                   ReceiptHeader.SETRANGE(ReceiptHeader."No.",DocNo);
                                   IF ReceiptHeader.FINDFIRST THEN BEGIN
                                      REPORT.RUNMODAL(REPORT::"Investor Receipt",TRUE,FALSE,ReceiptHeader);
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
      PostedEntry@1006 : Boolean;
      DocNo@1007 : Code[20];

    BEGIN
    END.
  }
}

