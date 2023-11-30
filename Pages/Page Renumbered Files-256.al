OBJECT page 17447 Standing Order Card
{
  OBJECT-PROPERTIES
  {
    Date=02/07/23;
    Time=11:47:20 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516307;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnInit=BEGIN
             IF Status=Status::Open THEN
              CurrPage.EDITABLE:=TRUE;
           END;

    OnOpenPage=BEGIN
                 // IF Status=Status::Approved THEN
                 // CurrPage.EDITABLE:=FALSE;
               END;

    OnAfterGetRecord=BEGIN
                       BankName:='';
                       IF Banks.GET("Bank Code") THEN
                       BankName:=Banks."Bank Name";
                     END;

    OnNewRecord=BEGIN
                  IF Status=Status::Open THEN
                   CurrPage.EDITABLE:=TRUE;
                END;

    OnAfterGetCurrRecord=BEGIN
                           IF Status=Status::Open THEN
                            CurrPage.EDITABLE:=TRUE;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760053;1 ;Action    ;
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
      { 1102760047;1 ;Action    ;
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
      { 1102760046;1 ;Action    ;
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
      { 1102760048;1 ;Action    ;
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
                                 //Status:=Status::"2";
                                 //MODIFY;
                                 END;
                               END;
                                }
      { 1102755005;1 ;ActionGroup;
                      Name=Approvals }
      { 1102755004;2 ;Action    ;
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
      { 1102755003;2 ;Action    ;
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


                                  {
                                 //End allocate batch number
                                 IF Approvalmgt.SendFOSASTOApprovalRequest(Rec) THEN;
                                   }
                                   Status:=Status::Approved;
                               END;
                                }
      { 1102755002;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=ReOpen;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 439;
                               BEGIN
                                 TESTFIELD(Status,Status::Approved);
                                 Status:=Status::Open;
                                 MODIFY;
                                 //IF Approvalmgt.CancelFOSASTOApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755007;0 ;ActionContainer;
                      Name=Creation;
                      ActionContainerType=NewDocumentItems }
      { 1102755001;1 ;Action    ;
                      Name=Create_STO;
                      CaptionML=ENU=Create_STO;
                      Promoted=Yes;
                      Visible=FALSE;
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

                                 //IF Status<>Status::"2" THEN
                                 //ERROR('Standing order status must be approved for you to create it');

                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Standing Order");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to change the standing order status.');
                               END;
                                }
      { 1000000001;1 ;Action    ;
                      Name=Reactivate_STO;
                      CaptionML=ENU=Reactivate_STO;
                      Promoted=Yes;
                      Visible=TRUE;
                      Enabled=TRUE;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Standing Order");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to re-activate the standing order.');

                                 IF Status<>Status::Stopped THEN
                                 ERROR('Standing order status must be stopped');

                                 IF CONFIRM('Are you sure you want to reactivate the standing order?',FALSE) = TRUE THEN BEGIN
                                 Status:=Status::Open;
                                 MODIFY;
                                 END;
                               END;
                                }
      { 1102755006;1 ;Action    ;
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
                                 ERROR('You do not have permissions to stop the standing order.');

                                 IF CONFIRM('Are you sure you want to stop the standing order?',FALSE) = TRUE THEN BEGIN
                                 Status:=Status::Stopped;
                                 MODIFY;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 29  ;0   ;Container ;
                ContainerType=ContentArea }

    { 28  ;1   ;Group     ;
                CaptionML=ENU=General }

    { 27  ;2   ;Field     ;
                SourceExpr="No.";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                AssistEdit=No;
                SourceExpr="Source Account No.";
                Editable=TRUE }

    { 25  ;2   ;Field     ;
                SourceExpr="Staff/Payroll No.";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                SourceExpr=Amount }

    { 22  ;2   ;Field     ;
                SourceExpr="Destination Account Type" }

    { 21  ;2   ;Field     ;
                SourceExpr="Destination Account No." }

    { 1120054000;2;Field  ;
                SourceExpr="Destination Transaction Type" }

    { 20  ;2   ;Field     ;
                SourceExpr="Destination Account Name" }

    { 19  ;2   ;Field     ;
                SourceExpr="Bank Code";
                OnValidate=BEGIN
                             BankName:='';
                             IF Banks.GET("Bank Code") THEN
                             BankName:=Banks."Bank Name";
                           END;
                            }

    { 18  ;2   ;Field     ;
                SourceExpr=BankName }

    { 17  ;2   ;Field     ;
                SourceExpr="BOSA Account No." }

    { 16  ;2   ;Field     ;
                SourceExpr="Allocated Amount" }

    { 15  ;2   ;Field     ;
                SourceExpr="Effective/Start Date" }

    { 14  ;2   ;Field     ;
                SourceExpr=Duration }

    { 13  ;2   ;Field     ;
                SourceExpr="End Date" }

    { 12  ;2   ;Field     ;
                SourceExpr=Frequency }

    { 11  ;2   ;Field     ;
                SourceExpr="Don't Allow Partial Deduction" }

    { 10  ;2   ;Field     ;
                SourceExpr=Remarks }

    { 9   ;2   ;Field     ;
                SourceExpr=Unsuccessfull;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                SourceExpr="Next Run Date" }

    { 7   ;2   ;Field     ;
                SourceExpr=Balance;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr=Effected;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="Auto Process";
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr="Income Type" }

    { 3   ;2   ;Field     ;
                SourceExpr="Date Reset";
                Editable=FALSE }

    { 1   ;2   ;Field     ;
                SourceExpr=Status;
                Editable=FALSE;
                OnValidate=BEGIN
                             IF Status=Status::Open THEN
                              CurrPage.EDITABLE:=TRUE;
                           END;
                            }

    { 2   ;2   ;Field     ;
                SourceExpr="Company Code";
                Editable=False }

  }
  CODE
  {
    VAR
      StatusPermissions@1102760000 : Record 51516310;
      BankName@1102760001 : Text[200];
      Banks@1102760002 : Record 51516311;
      UsersID@1102760003 : Record 2000000120;
      RAllocations@1102760004 : Record 51516246;
      DocumentType@1102755000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,STO';

    LOCAL PROCEDURE AllocatedAmountOnDeactivate@19031695();
    BEGIN
      CurrPage.UPDATE:=TRUE;
    END;

    BEGIN
    END.
  }
}

