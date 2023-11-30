OBJECT page 17487 Mpesa changes
{
  OBJECT-PROPERTIES
  {
    Date=04/05/16;
    Time=[ 9:52:38 AM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516335;
    SourceTableView=WHERE(Status=CONST(Open));
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755018;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755019;1 ;ActionGroup;
                      Name=Mpesa Changes }
      { 1102755020;2 ;Action    ;
                      Name=Send for Approval;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Do you want to send for approval?') = TRUE THEN BEGIN

                                 MPESAChanges.RESET;
                                 MPESAChanges.SETRANGE(MPESAChanges.No,No);
                                 IF MPESAChanges.FIND('-') THEN BEGIN
                                 MPESAChanges.Status:=MPESAChanges.Status::Pending;
                                 MPESAChanges."Send For Approval By":=USERID;
                                 MPESAChanges."Date Sent For Approval":=TODAY;
                                 MPESAChanges."Time Sent For Approval":=TIME;
                                 MPESAChanges.MODIFY;
                                 END;

                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;;Container;
                ContainerType=ContentArea }

    { 1102755008;1;Group  ;
                GroupType=Group }

    { 1102755001;1;Field  ;
                SourceExpr=No }

    { 1102755002;1;Field  ;
                SourceExpr="Transaction Date";
                Editable=FALSE }

    { 1102755003;1;Field  ;
                SourceExpr="Initiated By";
                Editable=FALSE }

    { 1102755004;1;Field  ;
                SourceExpr="MPESA Receipt No" }

    { 1102755005;1;Field  ;
                SourceExpr="Account No";
                Editable=FALSE }

    { 1102755006;1;Field  ;
                SourceExpr="New Account No" }

    { 1102755007;1;Field  ;
                SourceExpr=Comments }

    { 1102755009;1;Group  ;
                GroupType=Group }

    { 1102755010;2;Field  ;
                SourceExpr="Date Approved";
                Editable=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr="Approved By";
                Editable=FALSE }

    { 1102755012;2;Field  ;
                SourceExpr="Time Approved";
                Editable=FALSE }

    { 1102755013;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102755014;2;Field  ;
                SourceExpr="Send For Approval By";
                Editable=FALSE }

    { 1102755015;2;Field  ;
                SourceExpr="Date Sent For Approval";
                Editable=FALSE }

    { 1102755016;2;Field  ;
                SourceExpr="Time Sent For Approval";
                Editable=FALSE }

    { 1102755017;2;Field  ;
                SourceExpr=Changed;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MPESAChanges@1102755000 : Record 51516335;

    BEGIN
    END.
  }
}

