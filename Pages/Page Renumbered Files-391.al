OBJECT page 50087 Investor Payment Card
{
  OBJECT-PROPERTIES
  {
    Date=11/23/15;
    Time=[ 3:20:37 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516000;
    PageType=Card;
    OnNewRecord=BEGIN
                   "Investor Payment":=TRUE;
                END;

    ActionList=ACTIONS
    {
      { 36      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 45      ;1   ;Action    ;
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
      { 44      ;1   ;Action    ;
                      Name=Post and Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                   IF FundsUser.GET(USERID) THEN BEGIN
                                     FundsUser.TESTFIELD(FundsUser."Payment Journal Template");
                                     FundsUser.TESTFIELD(FundsUser."Payment Journal Batch");
                                     JTemplate:=FundsUser."Payment Journal Template";JBatch:=FundsUser."Payment Journal Batch";
                                     FundsManager.PostPayment(Rec,JTemplate,JBatch);
                                     COMMIT;
                                     PHeader.RESET;
                                     PHeader.SETRANGE(PHeader."No.","No.");
                                     IF PHeader.FINDFIRST THEN BEGIN
                                      REPORT.RUNMODAL(REPORT::"Investor Payment Voucher",TRUE,FALSE,PHeader);
                                     END;
                                   END ELSE BEGIN
                                     ERROR('User Account Not Setup, Contact the System Administrator');
                                   END
                               END;
                                }
      { 43      ;1   ;Action    ;
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
                                  IF ApprovalMgt.SendApproval(TableID,Rec."No.",DocType,Status) THEN;
                               END;
                                }
      { 42      ;1   ;Action    ;
                      Name=Cancel Approval Request }
      { 41      ;1   ;Action    ;
                      Name=Approvals }
      { 40      ;1   ;Action    ;
                      Name=Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                   PHeader.RESET;
                                   PHeader.SETRANGE(PHeader."No.","No.");
                                   IF PHeader.FINDFIRST THEN BEGIN
                                     REPORT.RUNMODAL(REPORT::"Investor Payment Voucher",TRUE,FALSE,PHeader);
                                   END;
                               END;
                                }
      { 39      ;1   ;Action    ;
                      Name=Check Budget Availability;
                      CaptionML=ENU=Check Budget Availability;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Balance;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 BCSetup@1102756001 : Record 51516051;
                               BEGIN
                                 {IF NOT(Status=Status::Pending) THEN BEGIN
                                   ERROR('Document must be Pending/Open');
                                 END;

                                 BCSetup.GET;
                                 IF NOT BCSetup.Mandatory THEN
                                    EXIT;

                                     IF NOT AllFieldsEntered THEN
                                      ERROR('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                                   //First Check whether other lines are already committed.
                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"Payment Voucher");
                                   Commitments.SETRANGE(Commitments."Document No.","No.");
                                   IF Commitments.FIND('-') THEN BEGIN
                                     IF CONFIRM('Lines in this Document appear to be committed do you want to re-commit?',FALSE)=FALSE THEN BEGIN EXIT END;
                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"Payment Voucher");
                                   Commitments.SETRANGE(Commitments."Document No.","No.");
                                   Commitments.DELETEALL;
                                  END;

                                     CheckBudgetAvail.CheckPayments(Rec);
                                  }
                               END;
                                }
      { 7       ;1   ;Action    ;
                      Name=Cancel Budget Commitment;
                      CaptionML=ENU=Cancel Budget Commitment;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CancelAllLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 {IF NOT(Status=Status::Pending) THEN BEGIN
                                   ERROR('Document must be Pending/Open');
                                 END;

                                     IF CONFIRM('Do you Wish to Cancel the Commitment entries for this document',FALSE)=FALSE THEN BEGIN EXIT END;

                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"Payment Voucher");
                                   Commitments.SETRANGE(Commitments."Document No.","No.");
                                   Commitments.DELETEALL;

                                   PayLine.RESET;
                                   PayLine.SETRANGE(PayLine.No,"No.");
                                   IF PayLine.FIND('-') THEN BEGIN
                                     REPEAT
                                       PayLine.Committed:=FALSE;
                                       PayLine.MODIFY;
                                     UNTIL PayLine.NEXT=0;
                                   END;
                                 }
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
                SourceExpr="Payment Mode";
                Editable=TRUE }

    { 6   ;2   ;Field     ;
                SourceExpr="Currency Code" }

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
                PagePartID=Page51516455;
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

