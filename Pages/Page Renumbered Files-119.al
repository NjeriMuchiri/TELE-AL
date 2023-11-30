OBJECT page 20460 HR Meeting Rooms Card
{
  OBJECT-PROPERTIES
  {
    Date=02/17/23;
    Time=[ 6:23:31 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516165;
    PageType=Card;
    OnOpenPage=BEGIN
                 SetAsEditableOrNot;
               END;

    OnAfterGetRecord=BEGIN
                       SetAsEditableOrNot;
                     END;

    OnModifyRecord=BEGIN
                     SetAsEditableOrNot;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           SetAsEditableOrNot;
                         END;

    ActionList=ACTIONS
    {
      { 1120054016;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054017;1 ;ActionGroup }
      { 1120054018;2 ;Action    ;
                      Name=Book Room;
                      Promoted=Yes;
                      Visible=BookRoomVisible;
                      PromotedIsBig=Yes;
                      Image=Reserve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 BookRoom;
                               END;
                                }
      { 1120054019;2 ;Action    ;
                      Name=Confirm Room;
                      Promoted=Yes;
                      Visible=Decline_ConfirmRoomVisible;
                      PromotedIsBig=Yes;
                      Image=Confirm;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ConfirmRoom;
                               END;
                                }
      { 1120054020;2 ;Action    ;
                      Name=Decline Room;
                      Promoted=Yes;
                      Visible=Decline_ConfirmRoomVisible;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DeclineRoom;
                               END;
                                }
      { 1120054024;1 ;ActionGroup;
                      CaptionML=[ENU=Request Approval;
                                 ESM=Aprobaci¢n solic.;
                                 FRC=Approbation de demande;
                                 ENC=Request Approval] }
      { 1120054023;2 ;Action    ;
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
      { 1120054022;2 ;Action    ;
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
      { 1120054021;2 ;Action    ;
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

    { 1120054005;2;Field  ;
                SourceExpr="Start Date" }

    { 1120054006;2;Field  ;
                SourceExpr="End Date" }

    { 1120054007;2;Field  ;
                SourceExpr="Start Time" }

    { 1120054008;2;Field  ;
                SourceExpr="End Time" }

    { 1120054003;2;Field  ;
                SourceExpr=Room }

    { 1120054004;2;Field  ;
                SourceExpr="Meeting Description";
                MultiLine=Yes }

    { 1120054009;2;Field  ;
                SourceExpr=Status }

    { 1120054010;2;Field  ;
                SourceExpr="DateTime Entered" }

    { 1120054011;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054012;2;Field  ;
                SourceExpr="Booked By" }

    { 1120054013;2;Field  ;
                SourceExpr="Confirmed/Declined By" }

    { 1120054014;2;Field  ;
                SourceExpr="Booked On" }

    { 1120054015;2;Field  ;
                SourceExpr="Confirmed/Declied On" }

  }
  CODE
  {
    VAR
      BookRoomVisible@1120054000 : Boolean INDATASET;
      Decline_ConfirmRoomVisible@1120054001 : Boolean INDATASET;
      ApprovalMgt@1120054005 : Codeunit 1535;
      ApprovalEntry@1120054004 : Record 454;
      CustomApprovals@1120054003 : Codeunit 51516163;
      VarVariant@1120054002 : Variant;

    LOCAL PROCEDURE SetAsEditableOrNot@1120054000();
    BEGIN
      CurrPage.EDITABLE:=FALSE;
      IF Rec.Status=Rec.Status::Open THEN
        CurrPage.EDITABLE:=TRUE;
      BookRoomVisible:=FALSE;
      Decline_ConfirmRoomVisible:=FALSE;
      CASE Status OF
        Rec.Status::Open:
          BookRoomVisible:=TRUE;
        Rec.Status::Booked:
          Decline_ConfirmRoomVisible:=TRUE;
        END;
    END;

    BEGIN
    END.
  }
}

