OBJECT page 17491 Mpesa Approval
{
  OBJECT-PROPERTIES
  {
    Date=04/05/16;
    Time=[ 1:23:08 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516335;
    SourceTableView=WHERE(Status=CONST(Pending));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755018;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755019;1 ;ActionGroup;
                      CaptionML=ENU=Mpesa Changes }
      { 1102755020;2 ;Action    ;
                      Name=Finalise Change;
                      Promoted=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Mpesa Change");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('Please contact system Admin for this permission.');

                                 {

                                 ReversalMngt.RESET;
                                 ReversalMngt.SETRANGE(ReversalMngt.UserId,USERID);
                                 ReversalMngt.SETFILTER(ReversalMngt.Status,'Mpesa Change');
                                 IF ReversalMngt.FIND('-') = FALSE THEN BEGIN
                                 ERROR('Please contact system Admin for this permission')
                                 END;
                                 }
                                 IF "Initiated By"=UPPERCASE(USERID) THEN
                                 ERROR('You cannot initiate and finalise same change');

                                 IF CONFIRM('Do you want to send for approval?') = TRUE THEN BEGIN

                                 MPESAChanges.RESET;
                                 MPESAChanges.SETRANGE(MPESAChanges.No,No);
                                 IF MPESAChanges.FIND('-') THEN BEGIN

                                 IF MPESAChanges."Initiated By"=USERID THEN BEGIN
                                 ERROR('The user who initiated the transaction cannot be the same as the one who finalises it.');
                                 EXIT;
                                 END;

                                 MPESATransactions.RESET;
                                 MPESATransactions.SETRANGE(MPESATransactions."Document No.","MPESA Receipt No");
                                 IF MPESATransactions.FIND('-') THEN BEGIN

                                 IF MPESATransactions.Changed=FALSE THEN BEGIN
                                 MPESATransactions."Original Account No":=MPESATransactions."Account No.";
                                 END;

                                 MPESATransactions."Old Account No":=MPESATransactions."Account No.";
                                 MPESATransactions."Account No.":=MPESAChanges."New Account No";
                                 MPESATransactions."Change Transaction No":=MPESAChanges.No;
                                 MPESATransactions.Changed:=TRUE;
                                 MPESATransactions."Date Changed":=TODAY;
                                 MPESATransactions."Time Changed":=TIME;
                                 MPESATransactions."Changed By":=MPESAChanges."Initiated By";
                                 MPESATransactions."Approved By":=USERID;
                                 MPESATransactions.MODIFY;
                                 END;

                                 ///////////
                                 MPESAChanges.Status:=MPESAChanges.Status::Approved;
                                 MPESAChanges."Approved By":=USERID;
                                 MPESAChanges."Date Approved":=TODAY;
                                 MPESAChanges."Time Approved":=TIME;
                                 MPESAChanges.Changed:=TRUE;
                                 MPESAChanges.MODIFY;
                                 END;
                                 END;
                               END;
                                }
      { 1102755021;2 ;Action    ;
                      Name=Reject Change;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Do you want to reject the transaction?') = TRUE THEN BEGIN
                                 TESTFIELD("Reasons for rejection");
                                 MPESAChanges.RESET;
                                 MPESAChanges.SETRANGE(MPESAChanges.No,No);
                                 IF MPESAChanges.FIND('-') THEN BEGIN

                                 IF MPESAChanges."Initiated By"=USERID THEN BEGIN
                                 ERROR('The user who initiated the transaction cannot be the same as the one who rejects it.');
                                 EXIT;
                                 END;


                                 MPESAChanges.Status:=MPESAChanges.Status::Rejected;
                                 MPESAChanges."Approved By":=USERID;
                                 MPESAChanges."Date Approved":=TODAY;
                                 MPESAChanges."Time Approved":=TIME;
                                 MPESAChanges.MODIFY;
                                 END;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1102755003;2;Field  ;
                SourceExpr="Transaction Date";
                Editable=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr="Time Approved";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Send For Approval By";
                Editable=FALSE }

    { 1102755007;2;Field  ;
                SourceExpr="Date Sent For Approval";
                Editable=FALSE }

    { 1102755008;2;Field  ;
                SourceExpr="Time Sent For Approval";
                Editable=FALSE }

    { 1102755009;2;Field  ;
                SourceExpr=Changed;
                Editable=FALSE }

    { 1102755010;2;Field  ;
                SourceExpr="Initiated By";
                Editable=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr="MPESA Receipt No";
                Editable=FALSE }

    { 1102755012;2;Field  ;
                SourceExpr="Account No";
                Editable=FALSE }

    { 1102755013;2;Field  ;
                SourceExpr="New Account No";
                Editable=FALSE }

    { 1102755014;2;Field  ;
                SourceExpr=Comments;
                Editable=FALSE }

    { 1102755015;2;Field  ;
                SourceExpr="Reasons for rejection" }

    { 1102755016;2;Field  ;
                SourceExpr="Date Approved";
                Editable=FALSE }

    { 1102755017;2;Field  ;
                SourceExpr="Approved By";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MPESAChanges@1102755002 : Record 51516335;
      MPESATransactions@1102755001 : Record 51516334;
      StatusPermissions@1102755000 : Record 51516310;

    BEGIN
    END.
  }
}

