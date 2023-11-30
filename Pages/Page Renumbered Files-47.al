OBJECT page 20411 Receipt Header Card
{
  OBJECT-PROPERTIES
  {
    Date=02/23/16;
    Time=12:26:33 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516002;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1000000005;  ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 1000000004;1 ;Action    ;
                      Name=Post Receipt;
                      CaptionML=ENU=Post Receipt;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      OnAction=BEGIN
                                 IF Posted THEN
                                 ERROR('This receipt is already posted');

                                 //TESTFIELD(Status,Status::Approved);
                                 CALCFIELDS("Total Amount","Total Amount(LCY)");

                                 ok:=CONFIRM('Post Receipt No:'+FORMAT("No.")+'. The account will be credited with KES:'+FORMAT("Total Amount(LCY)")+' Continue?');
                                 IF ok THEN BEGIN
                                   DocNo:="No.";
                                   IF FundsUser.GET(USERID) THEN BEGIN
                                     FundsUser.TESTFIELD(FundsUser."Receipt Journal Template");
                                     FundsUser.TESTFIELD(FundsUser."Receipt Journal Batch");
                                     JTemplate:=FundsUser."Receipt Journal Template";JBatch:=FundsUser."Receipt Journal Batch";
                                     PostedEntry:=FundsManager.PostPropertyReceipt(Rec,JTemplate,JBatch,"Property Code","No.",'',"Received From","Total Amount(LCY)");
                                     IF PostedEntry THEN BEGIN
                                       ReceiptHeader.RESET;
                                       ReceiptHeader.SETRANGE(ReceiptHeader."No.",DocNo);
                                       IF ReceiptHeader.FINDFIRST THEN BEGIN
                                         REPORT.RUNMODAL(REPORT::"Investor Receipt",TRUE,FALSE,ReceiptHeader);
                                       END;
                                     END;
                                   END ELSE BEGIN
                                     ERROR('User Account Not Setup');
                                   END;
                                 END;
                               END;
                                }
      { 1000000001;1 ;Action    ;
                      Name=Approvals }
      { 1000000000;1 ;Action    ;
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
                SourceExpr="Currency Factor" }

    { 12  ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

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
                PagePartID=Page51516026;
                PartType=Page }

  }
  CODE
  {
    VAR
      FundsManager@1000000007 : Codeunit 51516000;
      JTemplate@1000000006 : Code[20];
      JBatch@1000000005 : Code[20];
      FundsUser@1000000004 : Record 51516031;
      ok@1000000003 : Boolean;
      ReceiptHeader@1000000002 : Record 51516002;
      PostedEntry@1000000001 : Boolean;
      DocNo@1000000000 : Code[20];

    BEGIN
    END.
  }
}

