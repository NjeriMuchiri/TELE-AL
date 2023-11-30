OBJECT page 20491 File Request Header
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 1:41:17 PM];
    Modified=Yes;
    Version List=File Movement Beta(Suretep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516400;
    PageType=Card;
    OnInit=BEGIN
              IF Status = Status::Request THEN
               CurrPage.EDITABLE:=FALSE;
           END;

    OnOpenPage=BEGIN
                 IF Status = Status::Request THEN
                   CurrPage.EDITABLE:=FALSE;
                 "Issuing File Location":='';
               END;

    OnNewRecord=BEGIN
                  "User ID":=USERID;
                END;

    ActionList=ACTIONS
    {
      { 1000000024;  ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1000000027;1 ;Action    ;
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
      { 1000000026;1 ;Action    ;
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
      { 1000000025;1 ;Action    ;
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
      { 1000000005;1 ;Action    ;
                      Name=Dispatch File;
                      CaptionML=ENU=Request File;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Allocate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 "Retrieved By":=USERID;
                                 files.RESET;
                                 files.SETRANGE("No.","No.");
                                 IF files.FIND('-') THEN BEGIN
                                   IF files."File Movement Status"<>files."File Movement Status"::Open THEN
                                    ERROR('File already sent to Registry')
                                   ELSE
                                     files."File Movement Status":= files."File Movement Status"::Request;
                                 files.MODIFY;
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
                                  UserTracking."Transaction Type":='File Request';
                                  UserTracking."User Id":="User ID";
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
                                 MESSAGE('File Requested Successfully');
                                 END;
                               END;
                                }
      { 1000000006;1 ;Action    ;
                      Name=Receive File;
                      CaptionML=ENU=Return  File;
                      Promoted=Yes;
                      Image=Add;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 "Returned By":=USERID;
                                 "File Movement Status":= "File Movement Status"::Returned;
                                 "User ID":='';
                                 MODIFY;
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
                                  UserTracking."Transaction Type":='File Return';
                                  UserTracking."User Id":=USERID;
                                  UserTracking."Date Requested":=TODAY;
                                  UserTracking."Member Number":=MovementLines."Account No.";
                                  UserTracking."Member Name":=MovementLines."Account Name";
                                  UserTracking."File Type":=MovementLines."File Type";
                                  UserTracking."File Number":=MovementLines."File Number";
                                  UserTracking."Destination File Location":=MovementLines."Destination File Location";
                                  UserTracking."Transaction No":=MovementLines."Document No.";
                                  UserTracking.INSERT;
                                 UNTIL MovementLines.NEXT=0;
                                 END;
                                  //UserTracking.
                                 //End Record Tracking
                                 MESSAGE('File returned successfully');
                                 {

                                 IF "File Movement Status" = "File Movement Status"::Returned THEN
                                   CurrPage.EDITABLE(FALSE);}
                               END;
                                }
      { 1000000014;1 ;Action    ;
                      Name=Transfer File;
                      CaptionML=ENU=Transfer File;
                      Promoted=Yes;
                      Visible=true;
                      Enabled=true;
                      Image=AssemblyBOM;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD("File Movement Status","File Movement Status"::Issued);
                                 IF "User ID"="Transfer To" THEN
                                   ERROR('Transfer To invalid');
                                 TESTFIELD("Transfer To");
                                 "User ID":="Transfer To";
                                 MODIFY;
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
                                  UserTracking."Transaction Type":='File Transfer';
                                  UserTracking."User Id":="User ID";
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
                                 MESSAGE('Transffered to %1 successfully',"Transfer To");
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
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                SourceExpr="Member No" }

    { 1000000007;2;Field  ;
                SourceExpr="Date Requested" }

    { 1000000010;2;Field  ;
                SourceExpr="Responsiblity Center";
                ShowMandatory=TRUE }

    { 1000000011;2;Field  ;
                SourceExpr="Expected Return Date";
                Visible=False;
                HideValue=True }

    { 1000000013;2;Field  ;
                SourceExpr="Date Returned" }

    { 1000000016;2;Field  ;
                CaptionML=ENU=Requested By;
                SourceExpr="Retrieved By" }

    { 1000000017;2;Field  ;
                CaptionML=ENU=Received By;
                SourceExpr="Returned By";
                Visible=false;
                HideValue=true }

    { 1000000018;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                ShowMandatory=TRUE }

    { 1000000019;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                ShowMandatory=TRUE }

    { 1000000020;2;Field  ;
                OptionCaptionML=ENU=<,Issued,Returned,Transferred>;
                SourceExpr=Status;
                Visible=false;
                HideValue=true }

    { 1000000021;2;Field  ;
                SourceExpr="User ID" }

    { 1000000022;2;Field  ;
                CaptionML=ENU=Requesting File Location;
                SourceExpr="Issuing File Location" }

    { 1000000003;2;Field  ;
                SourceExpr="File Movement Status";
                Visible=True;
                HideValue=false;
                OnValidate=BEGIN
                             IF "File Movement Status" = "File Movement Status"::Request THEN
                               CurrPage.EDITABLE:=FALSE;
                           END;
                            }

    { 1000000004;2;Field  ;
                SourceExpr="Current File Location";
                Visible=False;
                HideValue=TRUE }

    { 1   ;2   ;Field     ;
                SourceExpr="Transfer To" }

    { 1000000023;1;Part   ;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page51516203;
                PartType=Page }

  }
  CODE
  {
    VAR
      DocumentType@1000000000 : ' ,Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Withdrawal,Membership Reg,Loan Batches,Payment Voucher,Petty Cash,Loan,Interbank,Checkoff,Savings Product Opening,Standing Order,ChangeRequest,Custodial,File Movement';
      ApprovalEntries@1000000001 : Page 658;
      ApprovalsMgmt@1000000002 : Codeunit 1535;
      files@1000 : Record 51516400;
      UserTracking@1004 : Record 51516404;
      MovementLines@1003 : Record 51516401;
      NoSeries@1002 : Record 51516258;
      "Tracking No"@1001 : Integer;

    BEGIN
    END.
  }
}

