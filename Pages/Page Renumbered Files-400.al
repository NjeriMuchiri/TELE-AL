OBJECT page 50096 Cheque List
{
  OBJECT-PROPERTIES
  {
    Date=02/20/20;
    Time=[ 9:24:11 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516000;
    SourceTableView=WHERE(Cheque No=CONST(YES),
                          Status=CONST(Pending Approval),
                          Posted=CONST(No));
    PageType=List;
    CardPageID=Cashier Transactions Card;
    ActionList=ACTIONS
    {
      { 1120054050;  ;ActionContainer;
                      Name=Cheque List;
                      ActionContainerType=NewDocumentItems }
      { 1120054051;1 ;Action    ;
                      Name=Send Approval Request;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                  TESTFIELD(Status,Status::"Pending Approval");

                                  DocType:=DocType::"Payment Voucher";
                                  CLEAR(TableID);
                                  TableID:=DATABASE::"Payment Header";
                                  TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD(Payee);
                                 TESTFIELD("Responsibility Center");

                                 //Release the PV for Approval;
                                 IF ApprovalMgt.CheckPettyCashApprovalsWorkflowEnabled(Rec) THEN
                                    ApprovalMgt.OnSendPettyCashForApproval(Rec);

                               END;
                                }
      { 1120054052;1 ;Action    ;
                      Name=Approve;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF Status<>Status::"Pending Approval" THEN
                                 ERROR('Status must be pending approval');

                                 IF CONFIRM('Are you sure you want to approve this cash payment?',TRUE)=FALSE THEN EXIT;

                                 Status:=Status::Approved;
                                 MODIFY;

                                 MESSAGE('Cash Payment Approved');
                               END;
                                }
      { 1120054053;1 ;Action    ;
                      Name=Cancel Approval Request;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="No." }

    { 1120054003;2;Field  ;
                SourceExpr="Document Type" }

    { 1120054004;2;Field  ;
                SourceExpr="Document Date" }

    { 1120054005;2;Field  ;
                SourceExpr="Posting Date" }

    { 1120054006;2;Field  ;
                SourceExpr="Currency Code" }

    { 1120054007;2;Field  ;
                SourceExpr="Currency Factor" }

    { 1120054008;2;Field  ;
                SourceExpr=Payee }

    { 1120054009;2;Field  ;
                SourceExpr="On Behalf Of" }

    { 1120054010;2;Field  ;
                SourceExpr="Payment Mode" }

    { 1120054011;2;Field  ;
                SourceExpr=Amount }

    { 1120054012;2;Field  ;
                SourceExpr="Amount(LCY)" }

    { 1120054013;2;Field  ;
                SourceExpr="VAT Amount" }

    { 1120054014;2;Field  ;
                SourceExpr="VAT Amount(LCY)" }

    { 1120054015;2;Field  ;
                SourceExpr="WithHolding Tax Amount" }

    { 1120054016;2;Field  ;
                SourceExpr="WithHolding Tax Amount(LCY)" }

    { 1120054017;2;Field  ;
                SourceExpr="Net Amount" }

    { 1120054018;2;Field  ;
                SourceExpr="Net Amount(LCY)" }

    { 1120054019;2;Field  ;
                SourceExpr="Bank Account" }

    { 1120054020;2;Field  ;
                SourceExpr="Bank Account Name" }

    { 1120054021;2;Field  ;
                SourceExpr="Bank Account Balance" }

    { 1120054022;2;Field  ;
                SourceExpr="Cheque Type" }

    { 1120054023;2;Field  ;
                SourceExpr="Cheque No" }

    { 1120054024;2;Field  ;
                SourceExpr="Payment Description" }

    { 1120054025;2;Field  ;
                SourceExpr="Global Dimension 1 Code" }

    { 1120054026;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1120054027;2;Field  ;
                SourceExpr="Shortcut Dimension 3 Code" }

    { 1120054028;2;Field  ;
                SourceExpr="Shortcut Dimension 4 Code" }

    { 1120054029;2;Field  ;
                SourceExpr="Shortcut Dimension 5 Code" }

    { 1120054030;2;Field  ;
                SourceExpr="Shortcut Dimension 6 Code" }

    { 1120054031;2;Field  ;
                SourceExpr="Shortcut Dimension 7 Code" }

    { 1120054032;2;Field  ;
                SourceExpr="Shortcut Dimension 8 Code" }

    { 1120054033;2;Field  ;
                SourceExpr=Status }

    { 1120054034;2;Field  ;
                SourceExpr=Posted }

    { 1120054035;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054036;2;Field  ;
                SourceExpr="Date Posted" }

    { 1120054037;2;Field  ;
                SourceExpr="Time Posted" }

    { 1120054038;2;Field  ;
                SourceExpr=Cashier }

    { 1120054039;2;Field  ;
                SourceExpr="No. Series" }

    { 1120054040;2;Field  ;
                SourceExpr="Responsibility Center" }

    { 1120054041;2;Field  ;
                SourceExpr="Retention Amount" }

    { 1120054042;2;Field  ;
                SourceExpr="Retention Amount(LCY)" }

    { 1120054043;2;Field  ;
                SourceExpr="User ID" }

    { 1120054044;2;Field  ;
                SourceExpr="Payment Type" }

    { 1120054045;2;Field  ;
                SourceExpr="Investor Payment" }

    { 1120054046;2;Field  ;
                SourceExpr="Expense Account" }

    { 1120054047;2;Field  ;
                SourceExpr="Total Payment Amount" }

    { 1120054048;2;Field  ;
                SourceExpr="Paying Type" }

    { 1120054049;2;Field  ;
                SourceExpr="Payments Type" }

  }
  CODE
  {
    VAR
      FundsUser@1120054008 : Record 51516031;
      FundsManager@1120054007 : Codeunit 51516000;
      JTemplate@1120054006 : Code[20];
      JBatch@1120054005 : Code[20];
      DocType@1120054004 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Staff Advance,Staff Advance Accounting';
      TableID@1120054003 : Integer;
      ApprovalMgt@1120054002 : Codeunit 439;
      PHeader@1120054001 : Record 51516000;
      ApprovalsMgmt@1120054000 : Codeunit 1535;

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

