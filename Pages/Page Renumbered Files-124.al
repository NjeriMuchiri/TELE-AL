OBJECT page 20465 HR Staff Movement Card
{
  OBJECT-PROPERTIES
  {
    Date=05/19/23;
    Time=[ 4:01:51 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516164;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054017;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054018;1 ;Action    ;
                      Name=Approve;
                      Promoted=Yes;
                      Visible=true;
                      PromotedIsBig=Yes;
                      Image=Confirm;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ConfirmRec;
                               END;
                                }
      { 1120054025;1 ;ActionGroup;
                      CaptionML=[ENU=Request Approval;
                                 ESM=Aprobaci¢n solic.;
                                 FRC=Approbation de demande;
                                 ENC=Request Approval] }
      { 1120054024;2 ;Action    ;
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
      { 1120054023;2 ;Action    ;
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
      { 1120054022;2 ;Action    ;
                      Name=Approvals;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      OnAction=BEGIN
                                 ApprovalMgt.OpenApprovalEntriesPage(RECORDID)
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr=No }

    { 1120054003;2;Field  ;
                SourceExpr="Staff No" }

    { 1120054004;2;Field  ;
                SourceExpr="Staff Name" }

    { 1120054005;2;Field  ;
                SourceExpr=Category }

    { 1120054006;2;Field  ;
                SourceExpr=Purpose }

    { 1120054007;2;Field  ;
                SourceExpr=Location }

    { 1120054008;2;Field  ;
                SourceExpr="Start Date" }

    { 1120054009;2;Field  ;
                SourceExpr="End date" }

    { 1120054010;2;Field  ;
                SourceExpr="Start Time" }

    { 1120054011;2;Field  ;
                SourceExpr="End Time" }

    { 1120054012;2;Field  ;
                SourceExpr="Back in Office On" }

    { 1120054019;2;Field  ;
                SourceExpr=Status }

    { 1120054013;2;Field  ;
                SourceExpr="Captured By" }

    { 1120054014;2;Field  ;
                SourceExpr="Datime Captured" }

    { 1120054015;2;Field  ;
                SourceExpr="Last DateTime Updated" }

    { 1120054016;2;Field  ;
                SourceExpr=Finalized }

    { 1120054020;2;Field  ;
                SourceExpr="Date Confirmed" }

    { 1120054021;2;Field  ;
                SourceExpr="Confirmed By" }

  }
  CODE
  {
    VAR
      ApprovalMgt@1120054003 : Codeunit 1535;
      ApprovalEntry@1120054002 : Record 454;
      CustomApprovals@1120054001 : Codeunit 51516163;
      VarVariant@1120054000 : Variant;

    BEGIN
    END.
  }
}

