OBJECT page 20387 Payment Card
{
  OBJECT-PROPERTIES
  {
    Date=07/06/23;
    Time=10:54:44 AM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Payment Type=CONST(Normal),
                          Posted=CONST(No),
                          Investor Payment=CONST(No));
    PageType=Card;
    RefreshOnActivate=Yes;
    OnNewRecord=BEGIN
                    "Payment Mode":="Payment Mode"::Cheque;
                    "Payment Type":="Payment Type"::Normal;
                END;

    ActionList=ACTIONS
    {
      { 36      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 37      ;1   ;Action    ;
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

                                     {//IF Post THEN  BEGIN
                                     Posted:=TRUE;
                                     Status:=PHeader.Status::Posted;
                                     "Posted By":=USERID;
                                     "Date Posted":=TODAY;
                                     "Time Posted":=TIME;
                                     MODIFY;

                                 // Modify PV LINES
                                   payline.RESET;
                                   payline.SETRANGE(payline.No,PHeader."No.");
                                   IF payline.FIND('-') THEN BEGIN
                                     payline.Posted:=TRUE;
                                     payline."Date Posted":=TODAY;
                                     payline.Status:=payline.Status::Posted;
                                     payline."Posted By":=USERID;
                                     payline."Time Posted":=TIME;
                                    payline.MODIFY;
                                     END;}
                                   END ELSE BEGIN
                                     ERROR('User Account Not Setup, Contact the System Administrator');
                                   END;


                               END;
                                }
      { 38      ;1   ;Action    ;
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
                                      REPORT.RUNMODAL(REPORT::"Payment Voucher",TRUE,FALSE,PHeader);
                                     END;
                                 {
                                 //IF Post THEN  BEGIN
                                     Posted:=TRUE;
                                     Status:=PHeader.Status::Posted;
                                     "Posted By":=USERID;
                                     "Date Posted":=TODAY;
                                     "Time Posted":=TIME;
                                     MODIFY;

                                 // Modify PV LINES
                                   payline.RESET;
                                   payline.SETRANGE(payline.No,PHeader."No.");
                                   IF payline.FIND('-') THEN BEGIN
                                     payline.Posted:=TRUE;
                                     payline."Date Posted":=TODAY;
                                     payline.Status:=payline.Status::Posted;
                                     payline."Posted By":=USERID;
                                     payline."Time Posted":=TIME;
                                    payline.MODIFY;
                                     END;}

                                   END ELSE BEGIN
                                     ERROR('User Account Not Setup, Contact the System Administrator');
                                   END
                               END;
                                }
      { 28      ;1   ;Action    ;
                      Name=Send Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 {
                                  TESTFIELD(Status,Status::New);

                                  DocType:=DocType::"Payment Voucher";
                                  CLEAR(TableID);
                                  TableID:=DATABASE::"Payment Header";
                                  IF ApprovalMgt.SendApproval(TableID,Rec."No.",DocType,Status) THEN;
                                 }
                                 IF ApprovalsMgmt.CheckPaymentApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.IsPaymentApprovalsWorkflowEnabled(Rec);
                                   MESSAGE('Approval request sent');

                                 //Status:=Status::Approved;
                                 //MODIFY;
                               END;
                                }
      { 39      ;1   ;Action    ;
                      Name=Cancel Approval Request;
                      OnAction=BEGIN
                                 ApprovalsMgmt.OnCancelPaymentApprovalRequest(Rec);
                               END;
                                }
      { 40      ;1   ;Action    ;
                      Name=Approvals }
      { 42      ;1   ;Action    ;
                      Name=Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                   PHeader.RESET;
                                   PHeader.SETRANGE(PHeader."No.","No.");
                                   IF PHeader.FINDFIRST THEN BEGIN
                                     REPORT.RUNMODAL(REPORT::"Payment Voucher",TRUE,FALSE,PHeader);
                                   END;
                               END;
                                }
      { 41      ;1   ;Action    ;
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
      { 4       ;1   ;Action    ;
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
      { 1000000000;1 ;Action    ;
                      Name=Print Cheque;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                   PHeader.RESET;
                                   PHeader.SETRANGE(PHeader."No.","No.");
                                   IF PHeader.FINDFIRST THEN BEGIN
                                     REPORT.RUNMODAL(REPORT::"Cheque Print",TRUE,FALSE,PHeader);
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

    { 25  ;2   ;Field     ;
                CaptionML=ENU=Date;
                SourceExpr="Document Date" }

    { 24  ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 5   ;2   ;Field     ;
                SourceExpr="Payment Mode";
                Editable=True }

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

    { 27  ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 26  ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

    { 7   ;2   ;Field     ;
                SourceExpr="Responsibility Center" }

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
    VAR
      FundsUser@1000 : Record 51516031;
      FundsManager@1001 : Codeunit 51516000;
      JTemplate@1002 : Code[20];
      JBatch@1003 : Code[20];
      DocType@1004 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Staff Advance,Staff Advance Accounting';
      TableID@1005 : Integer;
      ApprovalMgt@1006 : Codeunit 51516010;
      PHeader@1007 : Record 51516000;
      ApprovalsMgmt@1000000000 : Codeunit 1535;
      payline@1120054000 : Record 51516001;

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

