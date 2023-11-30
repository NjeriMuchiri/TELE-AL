OBJECT page 17445 Standing Orders - List
{
  OBJECT-PROPERTIES
  {
    Date=08/09/23;
    Time=12:17:16 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516307;
    SourceTableView=WHERE(Remarks=CONST(<>Postel Shares|<>Postel Subscription));
    PageType=List;
    CardPageID=Standing Order Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755012;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755011;1 ;Action    ;
                      CaptionML=ENU=Reset;
                      Promoted=Yes;
                      Visible=false;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to reset the standing order?') = TRUE THEN BEGIN

                                 Effected:=FALSE;
                                 Balance:=0;
                                 Unsuccessfull:=FALSE;
                                 "Auto Process":=FALSE;
                                 "Date Reset":=TODAY;
                                 MODIFY;

                                 RAllocations.RESET;
                                 RAllocations.SETRANGE(RAllocations."Document No","No.");
                                 IF RAllocations.FIND('-') THEN BEGIN
                                 REPEAT
                                 RAllocations."Amount Balance":=0;
                                 RAllocations."Interest Balance":=0;
                                 RAllocations.MODIFY;
                                 UNTIL RAllocations.NEXT = 0;
                                 END;

                                 END;
                               END;
                                }
      { 1102755010;1 ;Action    ;
                      Name=Approve;
                      CaptionML=ENU=Approve;
                      Promoted=Yes;
                      Visible=false;
                      Enabled=true;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD("Source Account No.");
                                 IF "Destination Account Type" <> "Destination Account Type"::BOSA THEN
                                 TESTFIELD("Destination Account No.");
                                 TESTFIELD("Effective/Start Date");
                                 TESTFIELD(Frequency);
                                 TESTFIELD("Next Run Date");

                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Standing Order");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to change the standing order status.');
                               END;
                                }
      { 1102755009;1 ;Action    ;
                      Name=Reject;
                      CaptionML=ENU=Reject;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Reject;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Standing Order");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to change the standing status.');
                               END;
                                }
      { 1102755008;1 ;Action    ;
                      Name=Stop;
                      CaptionML=ENU=Stop;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Standing Order");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to stop the standing order.');

                                 IF CONFIRM('Are you sure you want to stop the standing order?',FALSE) = TRUE THEN BEGIN
                                 END;
                               END;
                                }
      { 1102755007;1 ;ActionGroup;
                      Name=Approvals }
      { 1102755006;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::STO;
                                 ApprovalEntries.Setfilters(DATABASE::"Payroll Company Setup",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755005;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 Approvalmgt@1102755001 : Codeunit 439;
                               BEGIN
                                 TESTFIELD("Source Account No.");
                                 IF "Destination Account Type" <> "Destination Account Type"::BOSA THEN
                                 TESTFIELD("Destination Account No.");

                                 TESTFIELD("Effective/Start Date");
                                 TESTFIELD(Frequency);
                                 TESTFIELD("Next Run Date");

                                 IF "Destination Account Type" = "Destination Account Type"::BOSA THEN BEGIN
                                 CALCFIELDS("Allocated Amount");
                                 IF Amount<>"Allocated Amount" THEN
                                 ERROR('Allocated amount must be equal to amount');
                                 END;

                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);



                                 //End allocate batch number
                                 //IF Approvalmgt.SendFOSASTOApprovalRequest(Rec) THEN;
                               END;
                                }
      { 1102755004;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 439;
                               BEGIN

                                 //IF Approvalmgt.CancelFOSASTOApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755003;0 ;ActionContainer;
                      Name=Creation;
                      ActionContainerType=NewDocumentItems }
      { 1102755002;1 ;Action    ;
                      Name=Create_STO;
                      CaptionML=ENU=Create_STO;
                      Promoted=Yes;
                      Visible=false;
                      Enabled=true;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD("Source Account No.");
                                 IF "Destination Account Type" <> "Destination Account Type"::BOSA THEN
                                 TESTFIELD("Destination Account No.");
                                 TESTFIELD("Effective/Start Date");
                                 TESTFIELD(Frequency);
                                 TESTFIELD("Next Run Date");

                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Standing Order");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to change the standing order status.');
                               END;
                                }
      { 1102755001;1 ;Action    ;
                      Name=Stop_STO;
                      CaptionML=ENU=Stop_STO;
                      Promoted=Yes;
                      Image=Stop;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Standing Order");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 //ERROR('You do not have permissions to stop the standing order.');

                                 IF CONFIRM('Are you sure you want to stop the standing order?',FALSE) = TRUE THEN BEGIN
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr="No." }

    { 1102760003;2;Field  ;
                SourceExpr="Source Account No." }

    { 1120054003;2;Field  ;
                SourceExpr="FOSA Balance" }

    { 1120054000;2;Field  ;
                SourceExpr="BOSA Account No." }

    { 1102760005;2;Field  ;
                SourceExpr="Staff/Payroll No." }

    { 1102760007;2;Field  ;
                SourceExpr="Account Name" }

    { 1102755000;2;Field  ;
                SourceExpr="None Salary" }

    { 1102755013;2;Field  ;
                SourceExpr="Next Run Date" }

    { 1120054001;2;Field  ;
                SourceExpr="End Date" }

    { 1102755014;2;Field  ;
                SourceExpr="Effective/Start Date" }

    { 1102760020;2;Field  ;
                SourceExpr=Amount }

    { 1102760009;2;Field  ;
                SourceExpr="Destination Account Type" }

    { 1102760011;2;Field  ;
                SourceExpr="Destination Account No." }

    { 1102760013;2;Field  ;
                SourceExpr="Destination Account Name" }

    { 1000000000;2;Field  ;
                SourceExpr=Remarks }

    { 1000000001;2;Field  ;
                SourceExpr=Status }

    { 1120054002;2;Field  ;
                SourceExpr="Destination Transaction Type" }

  }
  CODE
  {
    VAR
      StatusPermissions@1102755005 : Record 51516310;
      BankName@1102755004 : Text[200];
      Banks@1102755003 : Record 51516311;
      UsersID@1102755002 : Record 2000000120;
      RAllocations@1102755001 : Record 51516246;
      DocumentType@1102755000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,STO';

    BEGIN
    END.
  }
}

