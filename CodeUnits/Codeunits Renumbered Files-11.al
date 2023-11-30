OBJECT CodeUnit 20375 Surestep Workflow Events
{
  OBJECT-PROPERTIES
  {
    Date=11/08/19;
    Time=[ 3:21:52 PM];
    Modified=Yes;
    Version List=Surestep Workflow EventsV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      WFHandler@1000000000 : Codeunit 1520;
      WorkflowManagement@1000000001 : Codeunit 1501;

    PROCEDURE AddEventsToLib@1000000000();
    BEGIN
      //---------------------------------------------1. Approval Events--------------------------------------------------------------
        //Payment Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendPaymentDocForApprovalCode,
                                    DATABASE::"Payment Header",'Approval of a Payment Document is Requested.',0,FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelPaymentApprovalRequestCode,
                                    DATABASE::"Payment Header",'An Approval request for a Payment Document is Canceled.',0,FALSE);
        //Receipt Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendReceiptDocForApprovalCode,
                                    DATABASE::"Receipt Header",'Approval of a Receipt Document is Requested.',0,FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelReceiptApprovalRequestCode,
                                    DATABASE::"Receipt Header",'An Approval request for a Receipt Document is Canceled.',0,FALSE);
        //Client Application
        WFHandler.AddEventToLibrary(RunWorkflowOnSendClientApplicationForApprovalCode,
                                    DATABASE::"Membership Applications",'Approval of a Member Application is Requested.',0,FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelClientApplicationApprovalRequestCode,
                                    DATABASE::"Membership Applications",'An Approval request for a Member Application is canceled.',0,FALSE);
        //Loan Booking
        WFHandler.AddEventToLibrary(RunWorkflowOnSendLoanBookingForApprovalCode,
                                    DATABASE::"Loans Register",'Approval of a Loan Application is Requested.',0,FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelLoanBookingApprovalRequestCode,
                                    DATABASE::"Loans Register",'An Approval request for a Loan Application is canceled.',0,FALSE);
        //Loan Disbursement
        WFHandler.AddEventToLibrary(RunWorkflowOnSendLoanDisbursementForApprovalCode,
                                    DATABASE::"Loan Disburesment-Batching",'Approval of a Loan Disbursement is Requested.',0,FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelLoanDisbursementApprovalRequestCode,
                                    DATABASE::"Loan Disburesment-Batching",'An Approval request for a Loan Disbursement is canceled.',0,FALSE);


      //Purchase Requisition
        WFHandler.AddEventToLibrary(RunWorkflowOnSendPurchaseRequisitionForApprovalCode,
                                    DATABASE::"Purchase Header",'Approval of  Purchase Requisition is Requested.',0,FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode,
                                    DATABASE::"Purchase Header",'An Approval request for  Purchase Requisition is canceled.',0,FALSE);

      //                               //Petty Cash
      //   WFHandler.AddEventToLibrary(RunWorkflowOnSendPurchaseRequisitionForApprovalCode,
      //                               DATABASE::"Purchase Header",'Approval of  Purchase Requisition is Requested.',0,FALSE);
      //   WFHandler.AddEventToLibrary(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode,
      //                               DATABASE::"Purchase Header",'An Approval request for  Purchase Requisition is canceled.',0,FALSE);
      //

        ///petty cash
         WFHandler.AddEventToLibrary(RunWorkflowOnSendPettyCashForApprovalCode,
                                    DATABASE::"Payment Header",'Approval of  Petty Cash is Requested.',0,FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelPettyCashApprovalRequestCode,
                                    DATABASE::"Payment Header",'An Approval request for  Petty Cash is canceled.',0,FALSE);
        //-------------------------------------------End Approval Events-------------------------------------------------------------
    END;

    PROCEDURE AddEventsPredecessor@1000000003();
    BEGIN

      //--------------------------------------1.Approval,Rejection,Delegation Predecessors------------------------------------------------
        //Payment Header
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendPaymentDocForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendPaymentDocForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendPaymentDocForApprovalCode);
        //Receipt Header
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendReceiptDocForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendReceiptDocForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendReceiptDocForApprovalCode);
        //Client Application
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendClientApplicationForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendClientApplicationForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendClientApplicationForApprovalCode);
        //Loan Booking
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendLoanBookingForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendLoanBookingForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendLoanBookingForApprovalCode);
        //Loan Disbursement
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode,RunWorkflowOnSendLoanDisbursementForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode,RunWorkflowOnSendLoanDisbursementForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode,RunWorkflowOnSendLoanDisbursementForApprovalCode);
      //---------------------------------------End Approval,Rejection,Delegation Predecessors---------------------------------------------
    END;

    PROCEDURE RunWorkflowOnSendPaymentDocForApprovalCode@1000000005() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendPaymentDocForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelPaymentApprovalRequestCode@1000000004() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnCancelPaymentApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,1535,OnSendPaymentDocForApproval)]
    PROCEDURE RunWorkflowOnSendPaymentDocForApproval@1000000002(VAR PaymentHeader@1000 : Record 51516000);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnSendPaymentDocForApprovalCode,PaymentHeader);
    END;

    [EventSubscriber(Codeunit,1535,OnCancelPaymentApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelPaymentApprovalRequest@1000000001(VAR PaymentHeader@1000 : Record 51516000);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnCancelPaymentApprovalRequestCode,PaymentHeader);
    END;

    PROCEDURE RunWorkflowOnSendClientApplicationForApprovalCode@1000000009() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendClientApplicationForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelClientApplicationApprovalRequestCode@1000000008() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnCancelClientApplicationApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,1535,OnSendClientApplicationForApproval)]
    PROCEDURE RunWorkflowOnSendClientApplicationForApproval@1000000007(VAR ClientApplication@1000000000 : Record 51516223);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnSendClientApplicationForApprovalCode,ClientApplication);
    END;

    [EventSubscriber(Codeunit,1535,OnCancelClientApplicationApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelClientApplicationApprovalRequest@1000000006(VAR ClientApplication@1000000000 : Record 51516223);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnCancelClientApplicationApprovalRequestCode,ClientApplication);
    END;

    PROCEDURE RunWorkflowOnSendLoanBookingForApprovalCode@1000000013() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendLoanBookingForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelLoanBookingApprovalRequestCode@1000000012() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnCancelLoanBookingApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,1535,OnSendLoanBookingForApproval)]
    PROCEDURE RunWorkflowOnSendLoanBookingForApproval@1000000011(VAR LoanBooking@1000000000 : Record 51516230);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnSendLoanBookingForApprovalCode,LoanBooking);
    END;

    [EventSubscriber(Codeunit,1535,OnCancelLoanBookingApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelLoanBookingApprovalRequest@1000000010(VAR LoanBooking@1000000000 : Record 51516230);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnCancelLoanBookingApprovalRequestCode,LoanBooking);
    END;

    PROCEDURE RunWorkflowOnSendLoanDisbursementForApprovalCode@1000000021() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendLoanDisbursementForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelLoanDisbursementApprovalRequestCode@1000000020() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnCancelLoanDisbursementApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,1535,OnSendLoanDisbursementForApproval)]
    PROCEDURE RunWorkflowOnSendLoanDisbursementForApproval@1000000019(VAR LoanDisbursement@1000000000 : Record 51516236);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnSendLoanDisbursementForApprovalCode,LoanDisbursement);
    END;

    [EventSubscriber(Codeunit,1535,OnCancelLoanDisbursementApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelLoanDisbursementApprovalRequest@1000000018(VAR LoanDisbursement@1000000000 : Record 51516236);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnCancelLoanDisbursementApprovalRequestCode,LoanDisbursement);
    END;

    PROCEDURE RunWorkflowOnSendReceiptDocForApprovalCode@1000000015() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendReceiptDocForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelReceiptApprovalRequestCode@1000000014() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnCancelReceiptApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,1535,OnSendReceiptDocForApproval)]
    PROCEDURE RunWorkflowOnSendReceiptDocForApproval@1000000025(VAR ReceiptHeader@1000 : Record 51516002);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnSendReceiptDocForApprovalCode,ReceiptHeader);
    END;

    [EventSubscriber(Codeunit,1535,OnCancelReceiptApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelReceiptApprovalRequest@1000000024(VAR ReceiptHeader@1000 : Record 51516002);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnCancelReceiptApprovalRequestCode,ReceiptHeader);
    END;

    PROCEDURE RunWorkflowOnSendPurchaseRequisitionForApprovalCode@16() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendPurchaseRequisitionForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode@15() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnCancelPurchaseRequisitionApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,1535,OnSendPurchaseRequisitionForApproval)]
    PROCEDURE RunWorkflowOnSendPurchaseRequisitionForApproval@14(VAR PRequest@1000000000 : Record 38);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseRequisitionForApprovalCode,PRequest);
    END;

    [EventSubscriber(Codeunit,1535,OnCancelPurchaseRequisitionApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelPurchaseRequisitionApprovalRequest@13(VAR PRequest@1000000000 : Record 38);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode,PRequest);
    END;

    PROCEDURE RunWorkflowOnSendPettyCashForApprovalCode@28() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendPettyCashForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelPettyCashApprovalRequestCode@27() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnCancelPettyCashApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,1535,OnSendPettyCashForApproval)]
    PROCEDURE RunWorkflowOnSendPettyCashForApproval@26(VAR PettyCash@1000000000 : Record 51516000);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnSendPettyCashForApprovalCode,PettyCash);
    END;

    [EventSubscriber(Codeunit,1535,OnCancelPettyCashApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelPettyCashApprovalRequest@25(VAR PettyCash@1000 : Record 51516000);
    BEGIN
      WorkflowManagement.HandleEvent(RunWorkflowOnCancelPettyCashApprovalRequestCode,PettyCash);
    END;

    BEGIN
    END.
  }
}

