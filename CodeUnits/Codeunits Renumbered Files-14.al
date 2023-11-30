OBJECT CodeUnit 20378 Surestep Workflow Responses
{
  OBJECT-PROPERTIES
  {
    Date=03/17/23;
    Time=[ 5:51:55 PM];
    Modified=Yes;
    Version List=Surestep Workflow ResponseV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      WFEventHandler@1000000000 : Codeunit 1520;
      SurestepWFEvents@1000000001 : CodeUnit 20375;
      WFResponseHandler@1000000002 : Codeunit 1521;

    PROCEDURE AddResponsesToLib@1000000000();
    BEGIN
    END;

    PROCEDURE AddResponsePredecessors@1000000001();
    BEGIN

        //Payment Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendPaymentDocForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnSendPaymentDocForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendPaymentDocForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelPaymentApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelPaymentApprovalRequestCode);
        //Receipt Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendReceiptDocForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnSendReceiptDocForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendReceiptDocForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelReceiptApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelReceiptApprovalRequestCode);
        //Client Application
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendClientApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnSendClientApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendClientApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelClientApplicationApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelClientApplicationApprovalRequestCode);
        //Loan Booking
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendLoanBookingForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnSendLoanBookingForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendLoanBookingForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelLoanBookingApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelLoanBookingApprovalRequestCode);
        //Loan Disbursement
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendLoanDisbursementForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnSendLoanDisbursementForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SurestepWFEvents.RunWorkflowOnSendLoanDisbursementForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelLoanDisbursementApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SurestepWFEvents.RunWorkflowOnCancelLoanDisbursementApprovalRequestCode);
      //-----------------------------End AddOn--------------------------------------------------------------------------------------
    END;

    PROCEDURE ReleasePaymentVoucher@1000000003(VAR PaymentHeader@1000000000 : Record 51516000);
    VAR
      PHeader@1000000001 : Record 51516000;
    BEGIN
        PHeader.RESET;
        PHeader.SETRANGE(PHeader."No.",PaymentHeader."No.");
        IF PHeader.FINDFIRST THEN BEGIN
          PHeader.Status:=PHeader.Status::Approved;
          PHeader.MODIFY;
        END;
    END;

    PROCEDURE ReOpenPaymentVoucher@1000000002(VAR PaymentHeader@1000000000 : Record 51516000);
    VAR
      PHeader@1000000001 : Record 51516000;
    BEGIN
        PHeader.RESET;
        PHeader.SETRANGE(PHeader."No.",PaymentHeader."No.");
        IF PHeader.FINDFIRST THEN BEGIN
          PHeader.Status:=PHeader.Status::New;
          PHeader.MODIFY;
        END;
    END;

    PROCEDURE ReleaseClientApplication@1000000005(VAR ClientApplication@1000000000 : Record 51516220);
    VAR
      ClientApp@1000000001 : Record 51516220;
    BEGIN
        ClientApp.RESET;
        ClientApp.SETRANGE(ClientApp."No.",ClientApplication."No.");
        IF ClientApp.FINDFIRST THEN BEGIN
          ClientApp.Status:=ClientApp.Status::Open;
          ClientApp.MODIFY;
        END;
    END;

    PROCEDURE ReOpenClientApplication@1000000004(VAR ClientApplication@1000000000 : Record 51516220);
    VAR
      ClientApp@1000000001 : Record 51516220;
    BEGIN
        ClientApp.RESET;
        ClientApp.SETRANGE(ClientApp."No.",ClientApplication."No.");
        IF ClientApp.FINDFIRST THEN BEGIN
          ClientApp.Status:=ClientApp.Status::Open;
          ClientApp.MODIFY;
        END;
    END;

    PROCEDURE ReleaseLoanBooking@1000000007(VAR LoanBooking@1000000000 : Record 51516230);
    VAR
      LoanB@1000000001 : Record 51516230;
    BEGIN
        LoanB.RESET;
        LoanB.SETRANGE(LoanB."Loan  No.",LoanBooking."Loan  No.");
        IF LoanB.FINDFIRST THEN BEGIN
            IF LoanB."Loan Product Type"<>'M_OD' THEN BEGIN
            IF LoanB."Appraised By"=USERID THEN
            ERROR('You can not approve a loan that you appraised.');
            END;
          LoanB."Loan Status":=LoanB."Loan Status"::Approved;
          LoanB."Approval Status":=LoanB."Approval Status"::Approved;
          LoanB."Approved Time":=TIME;
          LoanB."Appraised Date":=TODAY;
          LoanB.MODIFY;
        END;
    END;

    PROCEDURE ReOpenLoanBooking@1000000006(VAR LoanBooking@1000000000 : Record 51516230);
    VAR
      LoanB@1000000001 : Record 51516230;
    BEGIN
        LoanB.RESET;
        LoanB.SETRANGE(LoanB."Loan  No.",LoanBooking."Loan  No.");
        IF LoanB.FINDFIRST THEN BEGIN
          LoanB."Loan Status":=LoanB."Loan Status"::Application;
          LoanB.MODIFY;
        END;
    END;

    PROCEDURE ReleaseLoanDisbursement@1000000009(VAR LoanDisbursement@1000000000 : Record 51516236);
    VAR
      LoanD@1000000001 : Record 51516236;
    BEGIN
        LoanD.RESET;
        LoanD.SETRANGE(LoanD."Batch No.",LoanDisbursement."Batch No.");
        IF LoanD.FINDFIRST THEN BEGIN
          LoanD.Status:=LoanDisbursement.Status::Approved;
          LoanD.MODIFY;
        END;
    END;

    PROCEDURE ReOpenLoanDisbursement@1000000008(VAR LoanDisbursement@1000000000 : Record 51516236);
    VAR
      LoanD@1000000001 : Record 51516236;
    BEGIN
        LoanD.RESET;
        LoanD.SETRANGE(LoanD."Batch No.",LoanDisbursement."Batch No.");
        IF LoanD.FINDFIRST THEN BEGIN
          LoanD.Status:=LoanDisbursement.Status::Approved;
          LoanD.MODIFY;
        END;
    END;

    PROCEDURE ReleaseReceiptVoucher@1000000014(VAR ReceiptHeader@1000000000 : Record 51516002);
    VAR
      RHeader@1000000001 : Record 51516002;
    BEGIN
        RHeader.RESET;
        RHeader.SETRANGE(RHeader."No.",ReceiptHeader."No.");
        IF RHeader.FINDFIRST THEN BEGIN
          RHeader.Status:=RHeader.Status::Approved;
          RHeader.MODIFY;
        END;
    END;

    PROCEDURE ReOpenReceiptVoucher@1000000013(VAR ReceiptHeader@1000000000 : Record 51516002);
    VAR
      RHeader@1000000001 : Record 51516002;
    BEGIN
        RHeader.RESET;
        RHeader.SETRANGE(RHeader."No.",ReceiptHeader."No.");
        IF RHeader.FINDFIRST THEN BEGIN
          RHeader.Status:=RHeader.Status::New;
          RHeader.MODIFY;
        END;
    END;

    BEGIN
    END.
  }
}

