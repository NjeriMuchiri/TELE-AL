OBJECT page 172145 HR Jobs Card
{
  OBJECT-PROPERTIES
  {
    Date=04/22/20;
    Time=[ 2:52:02 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516100;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Functions,Job;
    OnAfterGetRecord=BEGIN
                       UpdateControls;

                       VALIDATE("Vacant Positions");
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755025;1 ;ActionGroup;
                      Name=Job }
      { 1102755027;2 ;Action    ;
                      CaptionML=ENU=Requirements;
                      RunObject=page 172149;
                      RunPageLink=Job Id=FIELD(Job ID);
                      Promoted=Yes;
                      Image=Card;
                      PromotedCategory=Category5 }
      { 1102755028;2 ;Action    ;
                      CaptionML=ENU=Responsibilities;
                      RunObject=page 172151;
                      RunPageLink=Job ID=FIELD(Job ID);
                      Promoted=Yes;
                      Image=JobResponsibility;
                      PromotedCategory=Category5 }
      { 1102755033;2 ;Action    ;
                      CaptionML=ENU=Occupants;
                      RunObject=page 172121;
                      RunPageLink=Job ID=FIELD(Job ID);
                      Promoted=Yes;
                      Image=ContactPerson;
                      PromotedCategory=Category5 }
      { 1102755038;1 ;ActionGroup;
                      Name=Functions;
                      CaptionML=ENU=Functions }
      { 1000000003;1 ;ActionGroup;
                      CaptionML=[ENU=Request Approval;
                                 ESM=Aprobaci¢n solic.;
                                 FRC=Approbation de demande;
                                 ENC=Request Approval] }
      { 1000000002;2 ;Action    ;
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
                                  IF CONFIRM('Send this Application for Approval?',TRUE)=FALSE THEN EXIT;

                                 {IF ApprovalsMgmt.CheckNewJobApprovalWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendNewJobForApproval(Rec);}
                                   Status:=Status::Approved;
                                   MODIFY;
                               END;
                                }
      { 1000000001;2 ;Action    ;
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
                                 IF CONFIRM('Cancel Document?',TRUE)=FALSE THEN EXIT;
                                 Status:=Status::New;
                                 MODIFY;
                                 {IF ApprovalsMgmt.CheckNewJobApprovalWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelNewJobApprovalRequest(Rec);}
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755001;2;Field  ;
                SourceExpr="Job ID";
                Importance=Promoted }

    { 1102755003;2;Field  ;
                SourceExpr="Job Description";
                Importance=Promoted }

    { 1102755005;2;Field  ;
                SourceExpr="Position Reporting to";
                Importance=Promoted }

    { 1102755009;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1102755013;2;Field  ;
                SourceExpr=Grade }

    { 1102755015;2;Field  ;
                SourceExpr="Main Objective" }

    { 1102755036;2;Field  ;
                SourceExpr="Supervisor/Manager" }

    { 1102755011;2;Field  ;
                SourceExpr="Supervisor Name" }

    { 1102755017;2;Field  ;
                SourceExpr="No of Posts";
                Importance=Promoted }

    { 1102755019;2;Field  ;
                SourceExpr="Occupied Positions";
                Importance=Promoted }

    { 1102755021;2;Field  ;
                SourceExpr="Vacant Positions";
                Importance=Promoted }

    { 1102755042;2;Field  ;
                SourceExpr="Responsibility Center" }

    { 1102755034;2;Field  ;
                SourceExpr="Employee Requisitions" }

    { 1102755023;2;Field  ;
                SourceExpr="Key Position" }

    { 1102755008;2;Field  ;
                SourceExpr="Date Created";
                Editable=false;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000000;2;Field  ;
                SourceExpr="Is Supervisor" }

    { 3   ;2   ;Field     ;
                SourceExpr="G/L Account" }

    { 1102755039;2;Field  ;
                SourceExpr=Status;
                Importance=Promoted;
                Editable=false;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755007;;Container;
                ContainerType=FactBoxArea }

    { 1102755004;1;Part   ;
                SubPageLink=Job ID=FIELD(Job ID);
                PagePartID=Page51516884;
                PartType=Page }

    { 1102755006;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      HREmployees@1102755000 : Record 51516160;
      ApprovalsMgmt@1000000005 : Codeunit 1535;
      OpenApprovalEntriesExistForCurrUser@1000000004 : Boolean;
      OpenApprovalEntriesExist@1000000003 : Boolean;
      ShowWorkflowStatus@1000000002 : Boolean;

    LOCAL PROCEDURE UpdateControls@1();
    BEGIN
      IF Status = Status::New THEN
      BEGIN
          CurrPage.EDITABLE:=TRUE;
      END ELSE
      BEGIN
          CurrPage.EDITABLE:=FALSE;
      END;
    END;

    PROCEDURE RecordLinkCheck@2(job@1002 : Record 51516100) RecordLnkExist : Boolean;
    VAR
      objRecordLnk@1000 : Record 2000000068;
      TableCaption@1001 : RecordID;
      objRecord_Link@1003 : RecordRef;
    BEGIN
      objRecord_Link.GETTABLE(job);
      TableCaption:= objRecord_Link.RECORDID;
      objRecordLnk.RESET;
      objRecordLnk.SETRANGE(objRecordLnk."Record ID",TableCaption);
      IF objRecordLnk.FIND('-') THEN EXIT(TRUE) ELSE EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

