OBJECT page 20496 File Movement Header
{
  OBJECT-PROPERTIES
  {
    Date=07/22/20;
    Time=[ 4:28:22 PM];
    Modified=Yes;
    Version List=File Movement Beta(Suretep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516400;
    PageType=Card;
    OnOpenPage=BEGIN
                 // IF Status = Status::Approved THEN
                 //   CurrPage.EDITABLE:=FALSE;
                 // "Issuing File Location":='REGISRTY';
               END;

    OnAfterGetCurrRecord=BEGIN
                           FieldsEditable:=TRUE;
                           IF "File Requested"=TRUE THEN
                           FieldsEditable:=FALSE;
                         END;

    ActionList=ACTIONS
    {
      { 1120054007;  ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1120054006;1 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 DocumentType:=DocumentType::"File Movement";
                                 ApprovalEntries.Setfilters(DATABASE::"File Movement Header",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1120054005;1 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 //OnSend Approval
                                  //IF ApprovalsMgmt.CHECKFI(Rec) THEN
                                  // ApprovalsMgmt.OnSendFileMovementDocForApproval(Rec);
                               END;
                                }
      { 1120054004;1 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Reject;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 // IF ApprovalsMgmt.CheckFileMovementApprovalWorkflowEnabled(Rec) THEN
                                 //   ApprovalsMgmt.OnCancelFileMovementApprovalRequest(Rec);
                               END;
                                }
      { 1120054003;1 ;Action    ;
                      Name=Dispatch File;
                      CaptionML=ENU=Dispatch File;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Allocate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 usersetup.GET(USERID);
                                 IF usersetup."Registry user"=FALSE THEN
                                   ERROR('You do not have permissions to dispatch a file');

                                 IF "File Requested"=TRUE THEN BEGIN
                                   ERROR('File has already been issued');
                                   END;

                                 //Add Record Tracking
                                 NoSeries.GET();
                                 MovementLines.RESET;
                                 MovementLines.SETRANGE(MovementLines."Document No.","No.");
                                 IF MovementLines.FINDFIRST THEN BEGIN
                                 REPEAT
                                  UserTracking.INIT;
                                  IF UserTracking.FIND('+') THEN
                                  "Tracking No":=UserTracking.No+1
                                  ELSE
                                  "Tracking No":=1;
                                  UserTracking.INIT;
                                  UserTracking.No:="Tracking No";
                                  UserTracking."Transaction Type":='File Request';
                                  UserTracking."User Id":=USERID;
                                  UserTracking."Date Requested":=TODAY;
                                  UserTracking."Member Number":=MovementLines."Account No.";
                                  UserTracking."Member Name":=MovementLines."Account Name";
                                  UserTracking."File Type":=MovementLines."File Type";
                                  UserTracking."Destination File Location":=MovementLines."Destination File Location";
                                  UserTracking."File Number":=MovementLines."File Number";
                                  UserTracking."Transaction No":=MovementLines."Document No.";
                                  UserTracking.INSERT;
                                 UNTIL MovementLines.NEXT=0;
                                 END;
                                  //UserTracking.
                                 //End Record Tracking
                                 "Retrieved By":=USERID;
                                 "File Requested":=TRUE;
                                 "Issued Date":=TODAY;
                                 "File Movement Status" := "File Movement Status"::Issued;
                                 MODIFY;
                                 MESSAGE('File has been issued successfully');
                               END;
                                }
      { 1120054002;1 ;Action    ;
                      Name=Receive File;
                      CaptionML=ENU=Receive File;
                      Promoted=Yes;
                      Image=Add;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 usersetup.GET(USERID);
                                 IF usersetup."Registry user"=FALSE THEN
                                   ERROR('You do not have permissions to receive a file into registry');
                                 IF "Requested By"<>USERID THEN
                                 ERROR('You are not allowed to Receive This File');

                                 IF "File Dispatched"=TRUE THEN
                                  ERROR('File Has Already Been Dispatched.');
                                 //Add Record Tracking
                                 NoSeries.GET();
                                 MovementLines.RESET;
                                 MovementLines.SETRANGE(MovementLines."Document No.","No.");
                                 IF MovementLines.FINDFIRST THEN BEGIN
                                 REPEAT
                                  IF UserTracking.FIND('+') THEN
                                  "Tracking No":=UserTracking.No+1
                                  ELSE
                                  "Tracking No":=1;
                                  UserTracking.INIT;
                                  UserTracking.No:="Tracking No";
                                  UserTracking."Transaction Type":='File Dispatch';
                                  UserTracking."User Id":="Requested By";
                                  UserTracking."Date Requested":=TODAY;
                                  UserTracking."Member Number":=MovementLines."Account No.";
                                  UserTracking."Member Name":=MovementLines."Account Name";
                                  UserTracking."File Type":=MovementLines."File Type";
                                  UserTracking."Destination File Location":=MovementLines."Destination File Location";
                                  UserTracking."File Number":=MovementLines."File Number";
                                  UserTracking."Transaction No":=MovementLines."Document No.";
                                  UserTracking.INSERT;
                                 UNTIL MovementLines.NEXT=0;
                                 END;
                                 "File Dispatched":=TRUE;
                                 "Received By":=USERID;
                                 "Received Date":=TODAY;
                                  Posted:=TRUE;
                                 MODIFY;
                                  //UserTracking.
                                 //End Record Tracking
                               END;
                                }
      { 1120054001;1 ;Action    ;
                      Name=Transfer File;
                      CaptionML=ENU=Transfer File;
                      Promoted=Yes;
                      Visible=false;
                      Image=AssemblyBOM;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 "Current File Location":='REGISRTY';
                                 NoSeries.GET();
                                 MovementLines.RESET;
                                 MovementLines.SETRANGE(MovementLines."Document No.","No.");
                                 IF MovementLines.FINDFIRST THEN BEGIN
                                 REPEAT
                                  IF UserTracking.FIND('+') THEN
                                  "Tracking No":=UserTracking.No+1
                                  ELSE
                                  "Tracking No":=1;
                                  UserTracking.INIT;
                                  UserTracking.No:="Tracking No";
                                  UserTracking."Transaction Type":='File Transfer';
                                  UserTracking."User Id":="Transfer To";
                                  UserTracking."Date Requested":=TODAY;
                                  UserTracking."Member Number":=MovementLines."Account No.";
                                  UserTracking."Member Name":=MovementLines."Account Name";
                                  UserTracking."File Type":=MovementLines."File Type";
                                  UserTracking."Destination File Location":=MovementLines."Destination File Location";
                                  UserTracking."File Number":=MovementLines."File Number";
                                  UserTracking."Transaction No":=MovementLines."Document No.";
                                  UserTracking.INSERT;
                                 UNTIL MovementLines.NEXT=0;
                                 END;
                               END;
                                }
      { 1120054000;1 ;Action    ;
                      Name=Reject Request;
                      CaptionML=ENU=Reject;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 usersetup.GET(USERID);
                                 IF usersetup."Registry user"=FALSE THEN
                                   ERROR('You do not have permissions to dispatch a file');

                                 IF CONFIRM('Are you sure you want to reject the request') THEN BEGIN
                                 "File Movement Status" := "File Movement Status"::Rejected;
                                 MODIFY;
                                 END;

                                 MESSAGE('Rejected successfully');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000002;2;Field  ;
                SourceExpr="No.";
                Editable=false }

    { 1   ;2   ;Field     ;
                SourceExpr="Member No";
                Editable=FieldsEditable }

    { 2   ;2   ;Field     ;
                SourceExpr="Member Name" }

    { 1000000007;2;Field  ;
                SourceExpr="Date Requested" }

    { 1000000008;2;Field  ;
                SourceExpr="Requested By";
                Editable=FieldsEditable }

    { 1000000009;2;Field  ;
                SourceExpr="Date Retrieved" }

    { 1000000012;2;Field  ;
                SourceExpr="Duration Requested";
                Visible=false;
                HideValue=true }

    { 1000000011;2;Field  ;
                SourceExpr="Expected Return Date";
                Visible=false;
                HideValue=true }

    { 1000000013;2;Field  ;
                SourceExpr="Date Returned" }

    { 1000000016;2;Field  ;
                SourceExpr="Retrieved By";
                Editable=FieldsEditable }

    { 1000000017;2;Field  ;
                SourceExpr="Returned By" }

    { 1000000018;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                ShowMandatory=TRUE }

    { 1000000019;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                ShowMandatory=TRUE }

    { 1000000020;2;Field  ;
                OptionCaptionML=ENU=<,Issued,Returned,Transferred>;
                SourceExpr=Status;
                Visible=False;
                HideValue=True }

    { 1000000021;2;Field  ;
                SourceExpr="User ID" }

    { 1000000003;2;Field  ;
                SourceExpr="File Movement Status";
                Visible=True;
                HideValue=False }

    { 1000000004;2;Field  ;
                SourceExpr="Current File Location";
                Visible=false;
                OnValidate=BEGIN
                             "Issuing File Location":='REGISRTY';
                           END;
                            }

    { 1000000023;1;Part   ;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page51516205;
                Editable=FieldsEditable;
                PartType=Page }

  }
  CODE
  {
    VAR
      DocumentType@1000000000 : ' ,Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Withdrawal,Membership Reg,Loan Batches,Payment Voucher,Petty Cash,Loan,Interbank,Checkoff,Savings Product Opening,Standing Order,ChangeRequest,Custodial,File Movement';
      ApprovalEntries@1000000001 : Page 658;
      ApprovalsMgmt@1000000002 : Codeunit 1535;
      usersetup@1000 : Record 91;
      UserTracking@1001 : Record 51516404;
      MovementLines@1002 : Record 51516401;
      NoSeries@1003 : Record 51516258;
      "Tracking No"@1004 : Integer;
      FieldsEditable@1120054000 : Boolean;

    BEGIN
    END.
  }
}

