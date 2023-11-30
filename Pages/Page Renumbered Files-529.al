OBJECT page 172124 HR Employee Requisition Card
{
  OBJECT-PROPERTIES
  {
    Date=04/08/22;
    Time=[ 2:41:18 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=Yes;
    DeleteAllowed=No;
    SourceTable=Table51516103;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Functions,Job;
    OnInit=BEGIN
             TypeofContractRequiredEditable := TRUE;
             AnyAdditionalInformationEditab := TRUE;
             "Required PositionsEditable" := TRUE;
             "Requisition TypeEditable" := TRUE;
             "Closing DateEditable" := TRUE;
             PriorityEditable := TRUE;
             ReasonforRequestOtherEditable := TRUE;
             "Reason For RequestEditable" := TRUE;
             "Responsibility CenterEditable" := TRUE;
             "Job IDEditable" := TRUE;
             "Requisition DateEditable" := TRUE;
             "Requisition No.Editable" := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       UpdateControls;

                       HRLookupValues.SETRANGE(HRLookupValues.Code,"Type of Contract Required");
                       IF HRLookupValues.FIND('-') THEN
                       ContractDesc:=HRLookupValues.Description;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755016;1 ;ActionGroup;
                      CaptionML=ENU=Fu&nctions }
      { 1102755014;2 ;Action    ;
                      CaptionML=ENU=Advertise;
                      Promoted=Yes;
                      Image=Salutation;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF Status<>Status::Approved THEN ERROR('The job position should first be approved');
                                 SMTPSetup.GET();
                                 HREmp.RESET;
                                 HREmp.SETRANGE(HREmp."No.");
                                 REPEAT
                                 IF HREmp."E-Mail"<>'' THEN
                                 SMTP.CreateMessage('Job Advertisement',SMTPSetup."Email Sender Address",HREmp."E-Mail",
                                 'Job Vacancy','A vacancy with the job description' +"Job Description"+'is open for applications',TRUE);
                                 SMTP.Send();
                                 UNTIL HREmp.NEXT=0;

                                 TESTFIELD("Requisition Type","Requisition Type"::Internal);

                                 MESSAGE('All Employees have been notified about this vacancy');
                               END;
                                }
      { 1102755006;2 ;Action    ;
                      CaptionML=ENU=Mark as Closed/Open;
                      Promoted=Yes;
                      Image=ReopenCancelled;
                      PromotedCategory=Category4;
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
      { 1102755004;2 ;Action    ;
                      CaptionML=ENU=&Print;
                      Promoted=Yes;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HREmpReq.RESET;
                                 HREmpReq.SETRANGE(HREmpReq."Requisition No.","Requisition No.");
                                 IF HREmpReq.FIND('-') THEN
                                 REPORT.RUN(51516609,TRUE,TRUE,HREmpReq);
                               END;
                                }
      { 1       ;2   ;Action    ;
                      CaptionML=ENU=&Send Mail to HR to add vacant position;
                      Promoted=Yes;
                      PromotedIsBig=No;
                      Image=Email;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                     objEmp.RESET;
                                     objEmp.SETRANGE(objEmp."Global Dimension 2 Code","Global Dimension 2 Code");
                                     objEmp.SETRANGE(objEmp.HR,TRUE);
                                     IF objEmp.FIND('-') THEN
                                     BEGIN
                                       IF objEmp."Company E-Mail"='' THEN ERROR('THe HR doesnt have an email Account');
                                       //**********************send mail**********************************

                                       MESSAGE('EMail Sent');
                                     END ELSE
                                     BEGIN
                                      MESSAGE('There is no employee marked as HR in that department');
                                     END;
                               END;
                                }
      { 1102755002;2 ;Action    ;
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
      { 1000000003;1 ;ActionGroup;
                      CaptionML=[ENU=Request Approval;
                                 ESM=Aprobaci¢n solic.;
                                 FRC=Approbation de demande;
                                 ENC=Request Approval] }
      { 1120054002;2 ;Action    ;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 VarVariant := Rec;
                                 IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                                   CustomApprovals.OnSendDocForApproval(VarVariant);
                               END;
                                }
      { 1120054001;2 ;Action    ;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 // IF ApprovalMgt.CancelImprestApprovalRequest(Rec,TRUE,TRUE) THEN;
                                 VarVariant := Rec;
                                 CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Approvals;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      OnAction=BEGIN
                                 ApprovalMgt.OpenApprovalEntriesPage(RECORDID)
                               END;
                                }
      { 1102755030;1 ;ActionGroup;
                      CaptionML=ENU=Job }
      { 1102755031;2 ;Action    ;
                      CaptionML=ENU=Requirements;
                      Promoted=Yes;
                      Image=JobListSetup;
                      PromotedCategory=Category5 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755001;2;Field  ;
                SourceExpr="Requisition No.";
                Importance=Promoted;
                Editable=False }

    { 1102755003;2;Field  ;
                SourceExpr="Requisition Date";
                Importance=Promoted;
                Editable=false }

    { 1102755005;2;Field  ;
                SourceExpr=Requestor;
                Importance=Promoted }

    { 1102755007;2;Field  ;
                SourceExpr="Job ID";
                Importance=Promoted;
                Editable="Job IDEditable" }

    { 1102755033;2;Field  ;
                SourceExpr="Job Description";
                Importance=Promoted }

    { 1102755041;2;Field  ;
                SourceExpr="Job Grade";
                Enabled=false }

    { 1102755011;2;Field  ;
                SourceExpr="Reason For Request";
                Editable="Reason For RequestEditable" }

    { 1102755009;2;Field  ;
                SourceExpr="Type of Contract Required" }

    { 1102755013;2;Field  ;
                SourceExpr=Priority;
                Editable=PriorityEditable }

    { 1102755015;2;Field  ;
                SourceExpr="Vacant Positions";
                Importance=Promoted }

    { 1102755017;2;Field  ;
                SourceExpr="Required Positions";
                Importance=Promoted;
                Editable="Required PositionsEditable" }

    { 1102755019;2;Field  ;
                SourceExpr="Closing Date";
                Importance=Promoted;
                Editable="Closing DateEditable" }

    { 2   ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

    { 1102755050;2;Field  ;
                SourceExpr="Responsibility Center";
                Importance=Promoted;
                Editable="Responsibility CenterEditable" }

    { 1102755035;2;Field  ;
                SourceExpr="Requisition Type";
                Importance=Promoted;
                Editable="Requisition TypeEditable" }

    { 1102755034;2;Field  ;
                SourceExpr=Closed }

    { 1102755021;2;Field  ;
                SourceExpr=Status;
                Importance=Promoted;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1905666001;1;Group  ;
                CaptionML=ENU=Additional Information }

    { 1102755023;2;Field  ;
                SourceExpr="Any Additional Information";
                Editable=AnyAdditionalInformationEditab }

    { 1102755025;2;Field  ;
                SourceExpr="Reason for Request(Other)";
                Editable=ReasonforRequestOtherEditable }

    { 1102755018;;Container;
                ContainerType=FactBoxArea }

    { 1000000000;1;Part   ;
                SubPageLink=Job ID=FIELD(Job ID);
                PagePartID=Page51516850;
                PartType=Page }

    { 1102755020;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      DocumentType@1102755001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Bank Slip,Grant,Grant Surrender,Employee Requisition,Leave Application,Training Requisition,Transport Requisition,JV,Grant Task,Concept Note,Proposal,Job Approval,Disciplinary Approvals,GRN,Clearence,Donation,Transfer,PayChange,Budget,GL';
      ApprovalEntries@1102755000 : Page 658;
      ApprovalsMgmt@1000000002 : Codeunit 1535;
      OpenApprovalEntriesExistForCurrUser@1000000001 : Boolean;
      OpenApprovalEntriesExist@1000000000 : Boolean;
      HREmpReq@1102755006 : Record 51516103;
      SMTP@1102755003 : Codeunit 400;
      HRSetup@1102755004 : Record 51516192;
      CTEXTURL@1102755007 : Text[30];
      HREmp@1102755008 : Record 51516160;
      HREmailParameters@1102755005 : Record 51516202;
      ContractDesc@1102755009 : Text[30];
      HRLookupValues@1102755010 : Record 51516163;
      "Requisition No.Editable"@19017990 : Boolean INDATASET;
      "Requisition DateEditable"@19016415 : Boolean INDATASET;
      "Job IDEditable"@19026165 : Boolean INDATASET;
      "Responsibility CenterEditable"@19002769 : Boolean INDATASET;
      "Reason For RequestEditable"@19076893 : Boolean INDATASET;
      ReasonforRequestOtherEditable@19047578 : Boolean INDATASET;
      PriorityEditable@19032936 : Boolean INDATASET;
      "Closing DateEditable"@19004462 : Boolean INDATASET;
      "Requisition TypeEditable"@19005089 : Boolean INDATASET;
      "Required PositionsEditable"@19065160 : Boolean INDATASET;
      AnyAdditionalInformationEditab@19064463 : Boolean INDATASET;
      TypeofContractRequiredEditable@19054034 : Boolean INDATASET;
      DimValue@1000 : Record 349;
      objEmp@1001 : Record 51516103;
      ApprovalMgt@1120054003 : Codeunit 1535;
      ApprovalEntry@1120054002 : Record 454;
      CustomApprovals@1120054001 : Codeunit 51516163;
      VarVariant@1120054000 : Variant;
      SMTPSetup@1120054004 : Record 409;

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

    PROCEDURE UpdateControls@1102755001();
    BEGIN

      IF Status=Status::New THEN BEGIN
      "Requisition No.Editable" :=TRUE;
      "Requisition DateEditable" :=TRUE;
      "Job IDEditable" :=TRUE;
      "Responsibility CenterEditable" :=TRUE;
      "Reason For RequestEditable" :=TRUE;
      ReasonforRequestOtherEditable :=TRUE;
      PriorityEditable :=TRUE;
      "Closing DateEditable" :=TRUE;
      "Requisition TypeEditable" :=TRUE;
      "Required PositionsEditable" :=TRUE;
      "Required PositionsEditable" :=TRUE;
      AnyAdditionalInformationEditab :=TRUE;
      TypeofContractRequiredEditable :=TRUE;
      END ELSE BEGIN
      "Requisition No.Editable" :=FALSE;
      "Requisition DateEditable" :=FALSE;
      "Job IDEditable" :=FALSE;
      "Responsibility CenterEditable" :=FALSE;
      "Reason For RequestEditable" :=FALSE;
      ReasonforRequestOtherEditable :=FALSE;
      PriorityEditable :=FALSE;
      "Closing DateEditable" :=FALSE;
      "Requisition TypeEditable" :=FALSE;
      "Required PositionsEditable" :=FALSE;
      "Required PositionsEditable" :=FALSE;
      AnyAdditionalInformationEditab :=FALSE;

      TypeofContractRequiredEditable :=FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

