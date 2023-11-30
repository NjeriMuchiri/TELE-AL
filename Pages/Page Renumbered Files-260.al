OBJECT page 17451 Over Draft Authorisation
{
  OBJECT-PROPERTIES
  {
    Date=07/14/21;
    Time=12:27:42 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516328;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 UpdateControl;
               END;

    OnAfterGetRecord=BEGIN
                       UpdateControl;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateControl();
                         END;

    ActionList=ACTIONS
    {
      { 1102755020;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755019;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1102755016;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                 TESTFIELD(Status,Status::Open);

                                 TESTFIELD("Account No.");
                                 TESTFIELD("Effective/Start Date");
                                 TESTFIELD(Duration);
                                 TESTFIELD("Expiry Date");
                                 TESTFIELD("Requested Amount");
                                 TESTFIELD("Approved Amount");

                                 Status:=Status::Pending;
                                 MODIFY;
                                 MESSAGE('Application set to pending approval!');

                               END;
                                }
      { 1102755013;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel A&pproval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                 IF NOT CONFIRM('Cancel approval request?',FALSE) THEN EXIT;

                                 TESTFIELD(Status,Status::Pending);
                                 Status:=Status::Open;
                                 MODIFY;

                                 MESSAGE('Document reopened');
                               END;
                                }
      { 1120054009;2 ;Action    ;
                      Name=Approve;
                      CaptionML=ENU=Approve;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Approve;
                               END;
                                }
      { 1120054008;2 ;Action    ;
                      Name=Reject;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 RejectOverDraft;
                               END;
                                }
      { 1120054012;2 ;Action    ;
                      Name=RePend;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReturnOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 text001@1120054000 : TextConst 'ENU=Return to status pending';
                               BEGIN
                                 IF NOT CONFIRM(text001,FALSE) THEN EXIT;

                                 TESTFIELD("Approved By",USERID);
                                 TESTFIELD(Rec.Status,Rec.Status::Approved);

                                 Rec.Status:=Rec.Status::Pending;
                                 Rec.MODIFY;
                               END;
                                }
      { 1120054015;2 ;Action    ;
                      Name=Un Liquidate;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Recalculate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 text001@1120054000 : TextConst 'ENU=Unliquidate selected od?';
                                 UserSetup@1120054001 : Record 91;
                               BEGIN
                                 UserSetup.GET(USERID);
                                 UserSetup.TESTFIELD(UserSetup.Administration);

                                 IF NOT CONFIRM(text001,FALSE) THEN EXIT;


                                 IF "Expiry Date"<TODAY THEN
                                   ERROR('The overdraft has already expired!');

                                 Rec.Liquidated:=FALSE;
                                 Rec."Liquidated By":='';
                                 Rec.Expired:=FALSE;
                                 Rec.MODIFY;
                               END;
                                }
      { 1102755004;2 ;Action    ;
                      Name=Post;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostOverDraft;
                               END;
                                }
      { 1102755006;2 ;Action    ;
                      Name=Account;
                      RunObject=page 17434;
                      RunPageLink=No.=FIELD(Account No.);
                      Promoted=Yes;
                      Image=Planning;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                Editable=StatusOpen;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr="No.";
                Editable=FALSE }

    { 1102755003;2;Field  ;
                SourceExpr="Account No.";
                Editable=AccNo }

    { 1102755005;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Net Salary" }

    { 1102755023;2;Field  ;
                SourceExpr="Requested Amount";
                Editable=ReqAmount }

    { 1120054013;2;Field  ;
                CaptionML=ENU=Withdrawal Amount;
                SourceExpr="Withdrawal Amount" }

    { 1120054010;2;Field  ;
                SourceExpr="Recommended Amount" }

    { 1102755012;2;Field  ;
                SourceExpr="Approved Amount";
                OnValidate=BEGIN
                             ApprovedAmount:=Account."Net Salary"*701/100;
                             ApprovedAmount:=70/100*Account."Net Salary";
                           END;
                            }

    { 1102755018;2;Field  ;
                SourceExpr="Overdraft Interest %" }

    { 1102755007;2;Field  ;
                SourceExpr="Effective/Start Date" }

    { 1102755009;2;Field  ;
                SourceExpr=Duration }

    { 1102755008;2;Field  ;
                SourceExpr="Expiry Date";
                Editable=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr=Remarks }

    { 1102755026;2;Field  ;
                SourceExpr="Overdraft Fee" }

    { 1120054001;2;Field  ;
                SourceExpr="Amount Available" }

    { 1102755014;2;Field  ;
                SourceExpr="Transacting Branch" }

    { 1102755010;2;Field  ;
                SourceExpr=Status }

    { 1120054003;2;Field  ;
                SourceExpr="Approved By" }

    { 1120054002;2;Field  ;
                SourceExpr="Date Approved" }

    { 1102755015;2;Field  ;
                SourceExpr="Created By" }

    { 1120054004;2;Field  ;
                SourceExpr="Date Created" }

    { 1102755024;2;Field  ;
                SourceExpr=Expired }

    { 1102755027;2;Field  ;
                SourceExpr=Liquidated }

    { 1102755028;2;Field  ;
                SourceExpr="Date Liquidated" }

    { 1102755029;2;Field  ;
                SourceExpr="Liquidated By" }

    { 1120054005;2;Field  ;
                SourceExpr=Posted }

    { 1120054006;2;Field  ;
                SourceExpr="Date Posted" }

    { 1120054007;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054011;1;Group  ;
                Name=Approver;
                Visible=StatusPending;
                Editable=StatusPending;
                GroupType=Group }

    { 1120054014;2;Field  ;
                Name=Approver's Withdrawable Amount;
                SourceExpr="Withdrawal Amount" }

    { 1102755032;0;Container;
                ContainerType=FactBoxArea }

    { 1102755034;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

    { 1102755035;1;Part   ;
                PartType=System;
                SystemPartID=MyNotes }

    { 1102755036;1;Part   ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      ApprovalEntries@1102755000 : Page 658;
      DocumentType@1102755001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTransport Request,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft';
      AvailableBalance@1102755003 : Decimal;
      MinAccBal@1102755002 : Decimal;
      StatusPermissions@1102755012 : Record 51516310;
      BankName@1102755011 : Text[200];
      Banks@1102755010 : Record 51516311;
      UsersID@1102755009 : Record 2000000120;
      AccP@1102755007 : Record 23;
      AccountTypes@1102755006 : Record 51516295;
      GenJournalLine@1102755005 : Record 81;
      LineNo@1102755004 : Integer;
      Account@1102755019 : Record 23;
      i@1102755016 : Integer;
      DActivity@1102755015 : Code[20];
      DBranch@1102755014 : Code[20];
      ODCharge@1102755013 : Decimal;
      AccNo@1102755008 : Boolean;
      ReqAmount@1102755017 : Boolean;
      AppAmount@1102755018 : Boolean;
      ODInt@1102755020 : Boolean;
      EstartDate@1102755021 : Boolean;
      Durationn@1102755022 : Boolean;
      ODFee@1102755023 : Boolean;
      Remmarks@1102755024 : Boolean;
      text001@1102755025 : TextConst 'ENU=This application must be open';
      ApprovedAmount@1120054000 : Decimal;
      Benki@1120054001 : Record 270;
      StatusOpen@1120054002 : Boolean INDATASET;
      StatusPending@1120054003 : Boolean INDATASET;

    PROCEDURE CalcAvailableBal@1102760000();
    BEGIN
      AvailableBalance:=0;
      MinAccBal:=0;

      IF Account.GET("Account No.") THEN BEGIN
      Account.CALCFIELDS(Account.Balance,Account."Uncleared Cheques",Account."ATM Transactions",
                         Account."Authorised Over Draft");

      AccountTypes.RESET;
      AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      IF AccountTypes.FIND('-') THEN BEGIN
      MinAccBal:=AccountTypes."Minimum Balance";

      AvailableBalance:=(Account.Balance+Account."Authorised Over Draft") - MinAccBal - Account."Uncleared Cheques" -
                        Account."EFT Transactions"-Account."ATM Transactions";


      END;
      END;
    END;

    PROCEDURE UpdateControl@1102755000();
    BEGIN


      IF Status=Status::Open THEN BEGIN
      AccNo:=TRUE;
      ReqAmount:=TRUE;
      AppAmount:=TRUE;
      ODInt:=TRUE;
      EstartDate:=TRUE;
      Durationn:=TRUE;
      ODFee:=TRUE;
      Remmarks:=TRUE;
      END;


      IF Status=Status::Pending THEN BEGIN
      AccNo:=FALSE;
      ReqAmount:=FALSE;
      AppAmount:=TRUE;
      ODInt:=TRUE;
      EstartDate:=TRUE;
      Durationn:=TRUE;
      ODFee:=TRUE;
      Remmarks:=TRUE;
      END;


      IF Status=Status::Rejected THEN BEGIN
      AccNo:=FALSE;
      ReqAmount:=FALSE;
      AppAmount:=FALSE;
      ODInt:=FALSE;
      EstartDate:=FALSE;
      Durationn:=FALSE;
      ODFee:=FALSE;
      Remmarks:=FALSE;

      END;

      IF Status=Status::Approved THEN BEGIN
      AccNo:=FALSE;
      ReqAmount:=FALSE;
      AppAmount:=FALSE;
      ODInt:=FALSE;
      EstartDate:=FALSE;
      Durationn:=FALSE;
      ODFee:=FALSE;
      Remmarks:=FALSE;

      END;


      //CurrPage.EDITABLE :=
      StatusOpen:=Status=Status::Open;
      StatusPending:=Status=Status::Pending;
    END;

    BEGIN
    END.
  }
}

