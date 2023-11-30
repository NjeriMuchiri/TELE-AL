OBJECT page 172147 HR Employee Requisitions List
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 1:04:22 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516103;
    DelayedInsert=No;
    PageType=List;
    CardPageID=HR Employee Requisition Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Job,Functions,Employee;
    ShowFilter=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755030;1 ;ActionGroup;
                      CaptionML=ENU=Job }
      { 1102755032;2 ;Action    ;
                      CaptionML=ENU=Requirements;
                      RunObject=page 172149;
                      RunPageLink=Job Id=FIELD(Job ID);
                      Promoted=Yes;
                      Image=JobListSetup;
                      PromotedCategory=Category4 }
      { 1102755033;2 ;Action    ;
                      CaptionML=ENU=Responsibilities;
                      RunObject=page 172151;
                      RunPageLink=Job ID=FIELD(Job ID);
                      Promoted=Yes;
                      Image=JobResponsibility;
                      PromotedCategory=Category4 }
      { 1000000011;1 ;ActionGroup;
                      CaptionML=ENU=Fu&nctions }
      { 1000000010;2 ;Action    ;
                      CaptionML=ENU=Advertise;
                      Promoted=Yes;
                      Image=Salutation;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 {
                                 HREmp.RESET;
                                 REPEAT
                                 HREmp.TESTFIELD(HREmp."Company E-Mail");
                                 SMTP.CreateMessage('Job Advertisement','dgithahu@coretec.co.ke',HREmp."Company E-Mail",
                                 'URAIA Job Vacancy','A vacancy with the job description' +"Job Description"+'is open for applications',TRUE);
                                 SMTP.Send();
                                 UNTIL HREmp.NEXT=0;
                                 }
                                 TESTFIELD("Requisition Type","Requisition Type"::Internal);
                                 HREmp.SETRANGE(HREmp.Status,HREmp.Status::Active);
                                 IF HREmp.FIND('-') THEN

                                 //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                                 HREmailParameters.RESET;
                                 HREmailParameters.SETRANGE(HREmailParameters."Associate With",HREmailParameters."Associate With"::"Vacancy Advertisements");
                                 IF HREmailParameters.FIND('-') THEN
                                 BEGIN
                                      REPEAT
                                      HREmp.TESTFIELD(HREmp."Company E-Mail");
                                      SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."Company E-Mail",
                                      HREmailParameters.Subject,'Dear'+' '+ HREmp."First Name" +' '+
                                      HREmailParameters.Body+' '+ "Job Description" +' '+ HREmailParameters."Body 2"+' '+ FORMAT("Closing Date")+'. '+
                                      HREmailParameters."Body 3",TRUE);
                                      SMTP.Send();
                                      UNTIL HREmp.NEXT=0;

                                 MESSAGE('All Employees have been notified about this vacancy');
                                 END;
                               END;
                                }
      { 1000000006;2 ;Action    ;
                      CaptionML=ENU=Mark as Closed/Open;
                      Promoted=Yes;
                      Image=ReopenCancelled;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 IF Closed THEN
                                 BEGIN
                                   IF NOT CONFIRM('Are you sure you want to Re-Open this Document',FALSE) THEN EXIT;
                                   Closed:=FALSE;
                                   MODIFY;
                                   MESSAGE('Employee Requisition %1 has been Re-Opened',"Requisition No.");

                                 END ELSE
                                 BEGIN
                                   IF NOT CONFIRM('Are you sure you want to close this Document',FALSE) THEN EXIT;
                                   Closed:=TRUE;
                                   MODIFY;
                                   MESSAGE('Employee Requisition %1 has been marked as Closed',"Requisition No.");
                                 END;
                               END;
                                }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=&Print;
                      Promoted=Yes;
                      Image=PrintReport;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 HREmpReq.RESET;
                                 HREmpReq.SETRANGE(HREmpReq."Requisition No.","Requisition No.");
                                 IF HREmpReq.FIND('-') THEN
                                 REPORT.RUN(53918,TRUE,TRUE,HREmpReq);
                               END;
                                }
      { 1000000004;2 ;Action    ;
                      CaptionML=ENU=Re-Open;
                      Promoted=Yes;
                      Visible=false;
                      Image=ReOpen;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                           Status:=Status::New;
                                           MODIFY;
                               END;
                                }
      { 1000000002;1 ;ActionGroup;
                      CaptionML=[ENU=Request Approval;
                                 ESM=Aprobaci¢n solic.;
                                 FRC=Approbation de demande;
                                 ENC=Request Approval] }
      { 1000000001;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[ENU=Send A&pproval Request;
                                 ESM=Enviar solicitud a&probaci¢n;
                                 FRC=Envoyer demande d'a&pprobation;
                                 ENC=Send A&pproval Request];
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      OnAction=BEGIN
                                 //IF ApprovalsMgmt.CheckSalesApprovalsWorkflowEnabled(Rec) THEN
                                  // ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 1000000000;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[ENU=Cancel Approval Re&quest;
                                 ESM=&Cancelar solicitud aprobaci¢n;
                                 FRC=Annuler demande d'appro&bation;
                                 ENC=Cancel Approval Re&quest];
                      Promoted=Yes;
                      Enabled=OpenApprovalEntriesExist;
                      Image=Cancel;
                      PromotedCategory=Category9;
                      OnAction=BEGIN
                                 //ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="Requisition No.";
                StyleExpr=TRUE }

    { 1102755003;2;Field  ;
                SourceExpr="Requisition Date";
                StyleExpr=TRUE }

    { 1102755007;2;Field  ;
                SourceExpr="Job Description" }

    { 1102755002;2;Field  ;
                SourceExpr=Requestor }

    { 1102755009;2;Field  ;
                SourceExpr="Reason For Request" }

    { 1102755013;2;Field  ;
                SourceExpr="Required Positions" }

    { 1102755004;2;Field  ;
                CaptionML=ENU=Contract;
                SourceExpr="Type of Contract Required";
                Editable=false }

    { 1102755023;2;Field  ;
                SourceExpr="Closing Date" }

    { 1102755010;2;Field  ;
                SourceExpr=Closed }

    { 1102755019;2;Field  ;
                SourceExpr=Status;
                Editable=TRUE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755005;;Container;
                ContainerType=FactBoxArea }

    { 1102755006;1;Part   ;
                SubPageLink=Job ID=FIELD(Job ID);
                PagePartID=Page51516850;
                PartType=Page }

    { 1102755008;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      HREmp@1000000000 : Record 51516160;
      HREmailParameters@1000000001 : Record 51516202;
      SMTP@1000000002 : Codeunit 400;
      DocumentType@1000000003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Bank Slip,Grant,Grant Surrender,Employee Requisition';
      ApprovalEntries@1000000005 : Page 658;
      HREmpReq@1000000006 : Record 51516103;
      ApprovalsMgmt@1000000009 : Codeunit 1535;
      OpenApprovalEntriesExistForCurrUser@1000000008 : Boolean;
      OpenApprovalEntriesExist@1000000007 : Boolean;
      ShowWorkflowStatus@1000000004 : Boolean;

    PROCEDURE TESTFIELDS@1102755000();
    BEGIN
      TESTFIELD("Job ID");
      TESTFIELD("Closing Date");
      TESTFIELD("Type of Contract Required");
      TESTFIELD("Requisition Type");
      TESTFIELD("Required Positions");
      IF "Reason For Request"="Reason For Request"::Other THEN
      TESTFIELD("Reason for Request(Other)");
    END;

    BEGIN
    END.
  }
}

