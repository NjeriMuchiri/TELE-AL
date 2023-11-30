OBJECT page 17497 Change MPESA PIN No
{
  OBJECT-PROPERTIES
  {
    Date=04/05/16;
    Time=[ 1:43:16 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516336;
    SourceTableView=WHERE(Status=CONST(Open));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755018;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755019;1 ;ActionGroup;
                      CaptionML=ENU=Change Mpesa pin No }
      { 1102755020;2 ;Action    ;
                      Name=Approve;
                      Promoted=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN


                                 IF CONFIRM('Are you sure you would like to send a New PIN No to the customer?') = TRUE THEN BEGIN
                                 TESTFIELD("MPESA Application No");
                                 TESTFIELD(Comments);

                                 MPESAApp.RESET;
                                 MPESAApp.SETRANGE(MPESAApp.No,"MPESA Application No");
                                 IF MPESAApp.FIND('-') THEN BEGIN

                                   MPESAApp."Sent To Server":=MPESAApp."Sent To Server"::No;
                                   MPESAApp.MODIFY;

                                 END
                                 ELSE
                                 BEGIN
                                   ERROR('MPESA Application No not found');
                                   EXIT;
                                 END;

                                 Status:=Status::Pending;
                                 "Date Sent":=TODAY;
                                 "Time Sent":=TIME;
                                 "Sent By":=USERID;
                                 MODIFY;

                                 MESSAGE('New PIN No sent to Customer ' + "Customer Name" + '. The Customer will receive a confirmation SMS shortly.');

                                 END;
                               END;
                                }
      { 1102755021;2 ;Action    ;
                      Name=Reject;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you would like to reject the PIN change request?') = TRUE THEN BEGIN
                                 TESTFIELD("MPESA Application No");
                                 TESTFIELD("Rejection Reason");

                                 Status:=Status::Approved;
                                 "Date Rejected":=TODAY;
                                 "Time Rejected":=TIME;
                                 "Rejected By":=USERID;
                                 MODIFY;

                                 MESSAGE('PIN change request has been rejected.');

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
                SourceExpr=No }

    { 1102755003;2;Field  ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr="Time Entered";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Entered By";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="MPESA Application No" }

    { 1102755007;2;Field  ;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 1102755008;2;Field  ;
                SourceExpr="Customer ID No";
                Editable=FALSE }

    { 1102755009;2;Field  ;
                SourceExpr="Customer Name";
                Editable=FALSE }

    { 1102755010;2;Field  ;
                SourceExpr="MPESA Mobile No";
                Editable=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr="MPESA Corporate No";
                Editable=FALSE }

    { 1102755012;2;Field  ;
                SourceExpr=Comments }

    { 1102755013;2;Field  ;
                SourceExpr="Rejection Reason" }

    { 1102755014;2;Field  ;
                SourceExpr="Date Sent";
                Editable=FALSE }

    { 1102755015;2;Field  ;
                SourceExpr="Time Sent";
                Editable=FALSE }

    { 1102755016;2;Field  ;
                SourceExpr="Sent By";
                Editable=FALSE }

    { 1102755017;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MPESAApp@1102755000 : Record 51516330;

    BEGIN
    END.
  }
}

