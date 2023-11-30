OBJECT CodeUnit 20414 AU Approvals
{
  OBJECT-PROPERTIES
  {
    Date=02/17/23;
    Time=[ 6:17:41 PM];
    Modified=Yes;
    Version List=CD V1.0;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      WorkflowManagement@1000 : Codeunit 1501;
      UnsupportedRecordTypeErr@1001 : TextConst '@@@=Record type Customer is not supported by this workflow response.;ENU=Record type %1 is not supported by this workflow response.';
      NoWorkflowEnabledErr@1002 : TextConst 'ENU=This record is not supported by related approval workflow.';
      WorkflowResponseHandling@1129 : Codeunit 1521;
      "--Employee Requisition----"@100000009 : TextConst 'ENU=**************';
      OnSendEmployeeRequisitionApprovalRequestTxt@100000008 : TextConst 'ENU=Approval of an Employee Requisition is requested';
      RunWorkflowOnSendEmployeeRequisitionForApprovalCode@100000007 : TextConst 'ENU=RUNWORKFLOWONSENDEMPLOYEEREQUISITIONFORAPPROVAL';
      OnCancelEmployeeRequisitionApprovalRequestTxt@100000006 : TextConst 'ENU=An Approval of a Employee Requisition  is canceled';
      RunWorkflowOnCancelEmployeeRequisitionForApprovalCode@100000005 : TextConst 'ENU=RUNWORKFLOWONCANCELEMPLOYEEREQUISITIONFORAPPROVAL';
      CalcPurchase@1023 : Codeunit 1535;
      CalcSales@1024 : Codeunit 1535;
      "--Loans Workflows----"@1120054004 : TextConst 'ENU=**************';
      OnSendLoansApprovalRequestTxt@1120054003 : TextConst 'ENU=Approval of Loans is requested';
      RunWorkflowOnSendLoansForApprovalCode@1120054002 : TextConst 'ENU=RUNWORKFLOWONSENDLOANSFORAPPROVAL';
      OnCancelLoansApprovalRequestTxt@1120054001 : TextConst 'ENU=An Approval of Loans  is canceled';
      RunWorkflowOnCancelLoansForApprovalCode@1120054000 : TextConst 'ENU=RUNWORKFLOWONCANCELLOANSFORAPPROVAL';
      "--Movement Workflows----"@1120054009 : TextConst 'ENU=**************';
      OnSendMovementApprovalRequestTxt@1120054008 : TextConst 'ENU=Approval of Movement is requested';
      RunWorkflowOnSendMovementForApprovalCode@1120054007 : TextConst 'ENU=RUNWORKFLOWONSENDMOVEMENTFORAPPROVAL';
      OnCancelMovementApprovalRequestTxt@1120054006 : TextConst 'ENU=An Approval of Movement  is canceled';
      RunWorkflowOnCancelMovementForApprovalCode@1120054005 : TextConst 'ENU=RUNWORKFLOWONCANCELMOVEMENTFORAPPROVAL';

    PROCEDURE CheckApprovalsWorkflowEnabled@5(VAR Variant@1000 : Variant) : Boolean;
    VAR
      RecRef@1001 : RecordRef;
      WorkflowEventHandling@1004 : Codeunit 1520;
    BEGIN
      RecRef.GETTABLE(Variant);
      CASE RecRef.NUMBER OF
        //Employee Requisition
        DATABASE::"HR Employee Requisitions":
          EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendEmployeeRequisitionForApprovalCode));

        //Loans
        DATABASE::"Loans Register":
          EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendLoansForApprovalCode));

          //Movement
        DATABASE::"Loans Register":
          EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendMovementForApprovalCode));
      ELSE
        ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
      END;
    END;

    PROCEDURE CheckApprovalsWorkflowEnabledCode@9(VAR Variant@1000 : Variant;CheckApprovalsWorkflowTxt@1005 : Text) : Boolean;
    VAR
      RecRef@1001 : RecordRef;
      WorkflowEventHandling@1004 : Codeunit 1520;
    BEGIN
      BEGIN
        IF NOT WorkflowManagement.CanExecuteWorkflow(Variant,CheckApprovalsWorkflowTxt) THEN
          ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
      END;
    END;

    [Integration]
    PROCEDURE OnSendDocForApproval@6(VAR Variant@1000 : Variant);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnCancelDocApprovalRequest@7(VAR Variant@1000 : Variant);
    BEGIN
    END;

    [EventSubscriber(Codeunit,1520,OnAddWorkflowEventsToLibrary)]
    LOCAL PROCEDURE AddWorkflowEventsToLibrary@22();
    VAR
      WorkFlowEventHandling@1000 : Codeunit 1520;
    BEGIN
      //Employee Requisition
      WorkFlowEventHandling.AddEventToLibrary(
      RunWorkflowOnSendEmployeeRequisitionForApprovalCode,DATABASE::"HR Employee Requisitions",OnSendEmployeeRequisitionApprovalRequestTxt,0,FALSE);
      WorkFlowEventHandling.AddEventToLibrary(
      RunWorkflowOnCancelEmployeeRequisitionForApprovalCode,DATABASE::"HR Employee Requisitions",OnCancelEmployeeRequisitionApprovalRequestTxt,0,FALSE);

      //Loans
      WorkFlowEventHandling.AddEventToLibrary(
      RunWorkflowOnSendLoansForApprovalCode,DATABASE::"Loans Register",OnSendLoansApprovalRequestTxt,0,FALSE);
      WorkFlowEventHandling.AddEventToLibrary(
      RunWorkflowOnCancelLoansForApprovalCode,DATABASE::"Loans Register",OnCancelLoansApprovalRequestTxt,0,FALSE);
      //Movement
      WorkFlowEventHandling.AddEventToLibrary(
      RunWorkflowOnSendMovementForApprovalCode,DATABASE::"HR Meeting Rooms Bookings",OnSendMovementApprovalRequestTxt,0,FALSE);
      WorkFlowEventHandling.AddEventToLibrary(
      RunWorkflowOnCancelMovementForApprovalCode,DATABASE::"HR Meeting Rooms Bookings",OnCancelMovementApprovalRequestTxt,0,FALSE);
    END;

    LOCAL PROCEDURE RunWorkflowOnSendApprovalRequestCode@27() : Code[128];
    BEGIN
      EXIT(UPPERCASE('RunWorkflowOnSendApprovalRequest'));
    END;

    [EventSubscriber(Codeunit,51516163,OnSendDocForApproval)]
    PROCEDURE RunWorkflowOnSendApprovalRequest@8(VAR Variant@1000 : Variant);
    VAR
      RecRef@1002 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Variant);
      CASE RecRef.NUMBER OF
        //Employee Requisition
        DATABASE::"HR Employee Requisitions":
           WorkflowManagement.HandleEvent(RunWorkflowOnSendEmployeeRequisitionForApprovalCode,Variant);

          //Loans
        DATABASE::"Loans Register":
           WorkflowManagement.HandleEvent(RunWorkflowOnSendLoansForApprovalCode,Variant);
            //Movement
        DATABASE::"HR Meeting Rooms Bookings":
           WorkflowManagement.HandleEvent(RunWorkflowOnSendMovementForApprovalCode,Variant);
      ELSE
        ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
      END;
    END;

    [EventSubscriber(Codeunit,51516163,OnCancelDocApprovalRequest)]
    PROCEDURE RunWorkflowOnCancelApprovalRequest@10(VAR Variant@1000 : Variant);
    VAR
      RecRef@1002 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Variant);
      CASE RecRef.NUMBER OF
        //Employee Requisition
        DATABASE::"HR Employee Requisitions":
           WorkflowManagement.HandleEvent(RunWorkflowOnCancelEmployeeRequisitionForApprovalCode,Variant);
        //Loans
        DATABASE::"Loans Register":
           WorkflowManagement.HandleEvent(RunWorkflowOnCancelLoansForApprovalCode,Variant);
        //Movement
        DATABASE::"HR Meeting Rooms Bookings":
           WorkflowManagement.HandleEvent(RunWorkflowOnCancelMovementForApprovalCode,Variant);
      ELSE
        ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
      END;
    END;

    PROCEDURE ReOpen@23(VAR Variant@1001 : Variant);
    VAR
      RecRef@1000 : RecordRef;
      Handled@1002 : Boolean;
      ERequisition@1063 : Record 51516103;
      Loans@1120054000 : Record 51516230;
      Movement@1120054001 : Record 51516165;
    BEGIN
      RecRef.GETTABLE(Variant);
      CASE RecRef.NUMBER OF
        //Employee Requisition
        DATABASE::"HR Employee Requisitions":
          BEGIN
            RecRef.SETTABLE(ERequisition);
            ERequisition.VALIDATE(Status,ERequisition.Status::New);
            ERequisition.MODIFY;
            Variant := ERequisition;
          END;

        //Loans
        DATABASE::"Loans Register":
          BEGIN
            RecRef.SETTABLE(Loans);
            Loans.VALIDATE("Approval Status",Loans."Approval Status"::Open);
            Loans.MODIFY;
            Variant := Loans;
          END;
        //Movement
        DATABASE::"HR Meeting Rooms Bookings":
          BEGIN
            RecRef.SETTABLE(Movement);
            Movement.VALIDATE("Approval Status",Movement."Approval Status"::Open);
            Movement.MODIFY;
            Variant := Movement;
          END;
        ELSE BEGIN
          OnOpenDocument(RecRef,Handled);
          IF NOT Handled THEN
            ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
        END;
      END
    END;

    PROCEDURE Release@1(VAR Variant@1001 : Variant);
    VAR
      RecRef@1000 : RecordRef;
      Handled@1028 : Boolean;
      ERequisition@1120054000 : Record 51516103;
      Loans@1120054001 : Record 51516230;
      Movement@1120054002 : Record 51516165;
    BEGIN
      RecRef.GETTABLE(Variant);
      CASE RecRef.NUMBER OF
        //Employee Requisition
        DATABASE::"HR Employee Requisitions":
          BEGIN
            RecRef.SETTABLE(ERequisition);
            ERequisition.VALIDATE(Status,ERequisition.Status::Approved);
            ERequisition.MODIFY;
            Variant := ERequisition;
          END;
        //Loans
        DATABASE::"Loans Register":
          BEGIN
            RecRef.SETTABLE(Loans);
            IF Loans."Loan Product Type"<>'M_OD' THEN BEGIN
            IF Loans."Appraised By"=USERID THEN
            ERROR('You can not approve a loan that you appraised.');
            END;
            Loans."Appraisal Status":=Loans."Approval Status"::Approved;
            Loans."Loan Status":=Loans."Loan Status"::Approved;
            Loans."Approved By":=USERID;
            Loans.MODIFY;
            Variant := Loans;
          END;
        //Movement
          DATABASE::"HR Meeting Rooms Bookings":
          BEGIN
            RecRef.SETTABLE(Movement);
            Movement.VALIDATE("Approval Status",Movement."Approval Status"::Approved);
            Movement.MODIFY;
            Variant := Movement;
          END;
        ELSE BEGIN

          OnReleaseDocument(RecRef,Handled);
          IF NOT Handled THEN
            ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);

         END;
      END
    END;

    PROCEDURE SetStatusToPending@2(VAR Variant@1001 : Variant);
    VAR
      RecRef@1000 : RecordRef;
      IsHandled@1085 : Boolean;
      ERequisition@1120054000 : Record 51516103;
      Loans@1120054001 : Record 51516230;
      Movement@1120054002 : Record 51516165;
    BEGIN
      RecRef.GETTABLE(Variant);
      CASE RecRef.NUMBER OF
        //Employee Requisition
        DATABASE::"HR Employee Requisitions":
          BEGIN
            RecRef.SETTABLE(ERequisition);
            ERequisition.VALIDATE(Status,ERequisition.Status::"Pending Approval");
            ERequisition.MODIFY;
            Variant := ERequisition;
          END;
        //Loans
        DATABASE::"Loans Register":
          BEGIN
            RecRef.SETTABLE(Loans);
            Loans.VALIDATE("Approval Status",Loans."Approval Status"::Pending);
            Loans.MODIFY;
            Variant := Loans;
          END;
        //Movement
          DATABASE::"HR Meeting Rooms Bookings":
          BEGIN
            RecRef.SETTABLE(Movement);
            Movement.VALIDATE("Approval Status",Movement."Approval Status"::"Pending Approval");
            Movement.MODIFY;
            Variant := Movement;
          END;

        ELSE BEGIN
          IsHandled := FALSE;
          OnSetStatusToPendingApproval(RecRef,Variant,IsHandled);
          IF NOT IsHandled THEN
            ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
          END;
      END
    END;

    PROCEDURE PopulateApprovalEntryArgument@80(RecRef@1000 : RecordRef;VAR ApprovalEntryArgument@1001 : Record 454) Found : Boolean;
    VAR
      ApprovalsMgmt@1004 : Codeunit 1535;
      ERequisition@1002 : Record 51516103;
      Loans@1120054000 : Record 51516230;
      Movement@1120054001 : Record 51516165;
    BEGIN
      Found := TRUE;
      CASE RecRef.NUMBER OF
        //Employee Requisition
        DATABASE::"HR Employee Requisitions":
          BEGIN
            RecRef.SETTABLE(ERequisition);
            ApprovalEntryArgument."Document No.":=ERequisition."Requisition No.";
          END;
        //Loans
        DATABASE::"Loans Register":
          BEGIN
            RecRef.SETTABLE(Loans);
            ApprovalEntryArgument."Document No.":=Loans."Loan  No.";
            ApprovalEntryArgument."Document Type":=ApprovalEntryArgument."Document Type"::Loan;
          END;
        //Movement
        DATABASE::"HR Meeting Rooms Bookings":
          BEGIN
            RecRef.SETTABLE(Movement);
            ApprovalEntryArgument."Document No.":=Movement.No;
            ApprovalEntryArgument."Document Type":=ApprovalEntryArgument."Document Type"::Movement;
          END;
        ELSE
          Found := FALSE;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnReleaseDocument@75(RecRef@1001 : RecordRef;VAR Handled@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnOpenDocument@73(RecRef@1000 : RecordRef;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnSetStatusToPendingApproval@126(RecRef@1000 : RecordRef;VAR Variant@1001 : Variant;VAR IsHandled@1002 : Boolean);
    BEGIN
    END;

    PROCEDURE Reject@3(VAR Variant@1001 : Variant);
    VAR
      RecRef@1000 : RecordRef;
      Handled@1002 : Boolean;
      ERequisition@1120054000 : Record 51516103;
      Loans@1120054001 : Record 51516230;
      Movement@1120054002 : Record 51516165;
    BEGIN
      RecRef.GETTABLE(Variant);

      CASE RecRef.NUMBER OF
         //Employee Requisition
        DATABASE::"HR Employee Requisitions":
          BEGIN
            RecRef.SETTABLE(ERequisition);
            ERequisition.VALIDATE(Status,ERequisition.Status::Canceled);
            ERequisition.MODIFY;
            Variant := ERequisition;
          END;
        //Loans
        DATABASE::"Loans Register":
          BEGIN
            RecRef.SETTABLE(Loans);
            Loans.VALIDATE("Approval Status",Loans."Approval Status"::Open);
            Loans.MODIFY;
            Variant :=Loans;
          END;
        //Movement
          DATABASE::"HR Meeting Rooms Bookings":
          BEGIN
            RecRef.SETTABLE(Movement);
            Movement.VALIDATE("Approval Status",Movement."Approval Status"::Open);
            Movement.MODIFY;
            Variant := Movement;
          END;
        ELSE BEGIN

          OnReleaseDocument(RecRef,Handled);
          IF NOT Handled THEN
            ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
         END;
      END
    END;

    BEGIN
    END.
  }
}

