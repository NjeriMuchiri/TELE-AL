OBJECT page 20393 Cash Payment Card
{
  OBJECT-PROPERTIES
  {
    Date=08/25/20;
    Time=[ 3:00:12 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Payment Type=CONST(Cash Purchase),
                          Posted=CONST(No));
    PageType=Card;
    OnNewRecord=BEGIN
                    "Payment Mode":="Payment Mode"::Cash;
                    "Payment Type":="Payment Type"::"Cash Purchase";
                END;

    ActionList=ACTIONS
    {
      { 36      ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 42      ;1   ;Action    ;
                      Name=Post Payment;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Payment;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                   CheckRequiredItems;
                                   IF FundsUser.GET(USERID) THEN BEGIN
                                     FundsUser.TESTFIELD(FundsUser."Payment Journal Template");
                                     FundsUser.TESTFIELD(FundsUser."Payment Journal Batch");
                                     JTemplate:=FundsUser."Payment Journal Template";JBatch:=FundsUser."Payment Journal Batch";
                                     FundsManager.PostPayment(Rec,JTemplate,JBatch);
                                   END ELSE BEGIN
                                     ERROR('User Account Not Setup, Contact the System Administrator');
                                   END
                               END;
                                }
      { 41      ;1   ;Action    ;
                      Name=Post and Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                   CheckRequiredItems;
                                   IF FundsUser.GET(USERID) THEN BEGIN
                                     FundsUser.TESTFIELD(FundsUser."Payment Journal Template");
                                     FundsUser.TESTFIELD(FundsUser."Payment Journal Batch");
                                     JTemplate:=FundsUser."Payment Journal Template";JBatch:=FundsUser."Payment Journal Batch";
                                     FundsManager.PostPayment(Rec,JTemplate,JBatch);
                                     COMMIT;
                                     PHeader.RESET;
                                     PHeader.SETRANGE(PHeader."No.","No.");
                                     IF PHeader.FINDFIRST THEN BEGIN
                                      REPORT.RUNMODAL(REPORT::"Cash Voucher",TRUE,FALSE,PHeader);
                                     END;
                                   END ELSE BEGIN
                                     ERROR('User Account Not Setup, Contact the System Administrator');
                                   END
                               END;
                                }
      { 1120054000;1 ;Action    ;
                      Name=Print Payment Voucher;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Voucher;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 PHeader.RESET;
                                   PHeader.SETRANGE(PHeader."No.","No.");
                                   IF PHeader.FINDFIRST THEN BEGIN
                                     REPORT.RUNMODAL(REPORT::"Cash Payment Voucher",TRUE,FALSE,PHeader);
                                   END;
                               END;
                                }
      { 39      ;1   ;Action    ;
                      Name=Send Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                  TESTFIELD(Status,Status::New);

                                  DocType:=DocType::"Payment Voucher";
                                  CLEAR(TableID);
                                  TableID:=DATABASE::"Payment Header";
                                  TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD(Payee);
                                 TESTFIELD("Responsibility Center");

                                 //Release the CV for Approval;
                                 {IF ApprovalsMgmt.CheckPaymentApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.IsPaymentApprovalsWorkflowEnabled(Rec);}

                                 Status:=Status::"Pending Approval";
                                 MODIFY;

                                 MESSAGE('Cash Payment Pending Approval');
                                  //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Cash Payment Sent For Approval',0,'FINANCE',TODAY,TIME,'',"No.","Bank Account",'');
                                 //End Create Audit Entry
                                 CurrPage.CLOSE();

                               END;
                                }
      { 40      ;1   ;Action    ;
                      Name=Cancel Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ApprovalsMgmt.OnCancelPaymentApprovalRequest(Rec);
                               END;
                                }
      { 38      ;1   ;Action    ;
                      Name=Approvals;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4 }
      { 37      ;1   ;Action    ;
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

    { 43  ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 5   ;2   ;Field     ;
                SourceExpr="Payment Mode" }

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
                SourceExpr=Status;
                Visible=true;
                Editable=false }

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
                PagePartID=Page51516008;
                PartType=Page }

  }
  CODE
  {
    VAR
      FundsUser@1007 : Record 51516031;
      FundsManager@1006 : Codeunit 51516000;
      JTemplate@1005 : Code[20];
      JBatch@1004 : Code[20];
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Staff Advance,Staff Advance Accounting';
      TableID@1002 : Integer;
      ApprovalMgt@1001 : Codeunit 439;
      PHeader@1000 : Record 51516000;
      ApprovalsMgmt@1120054000 : Codeunit 1535;
      AuditTrail@1120054003 : Codeunit 51516107;
      Trail@1120054002 : Record 51516655;
      EntryNo@1120054001 : Integer;

    LOCAL PROCEDURE CheckRequiredItems@2();
    BEGIN
       TESTFIELD(Status,Status::Approved);
       TESTFIELD("Posting Date");
       TESTFIELD(Payee);
       TESTFIELD("Bank Account");
       TESTFIELD("Payment Description");
       TESTFIELD("Global Dimension 1 Code");
       TESTFIELD("Global Dimension 2 Code");
    END;

    BEGIN
    END.
  }
}

