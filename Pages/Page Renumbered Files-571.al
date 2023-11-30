OBJECT page 172166 Credited FD Card
{
  OBJECT-PROPERTIES
  {
    Date=07/23/20;
    Time=[ 2:49:35 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516191;
    SourceTableView=WHERE(Status=FILTER(<>Posted));
    PageType=List;
    CardPageID=Intermediate Leave  Card;
    OnOpenPage=BEGIN
                 {Usersetup.RESET;
                 Usersetup.SETRANGE(Usersetup."User ID",USERID);
                 IF Usersetup.FIND('-') THEN
                   //IF Usersetup."View All HR Items"=FALSE THEN
                    HREmp.RESET;
                    HREmp.SETRANGE(HREmp."User ID",USERID);
                    IF HREmp.GET THEN
                    SETRANGE("User ID",HREmp."User ID")
                    ELSE}
                 //user id may not be the creator of the doc
                    //SETRANGE("User ID",USERID);
                 Usersetup.RESET;
                 Usersetup.SETRANGE(Usersetup."User ID",USERID);
                 IF Usersetup.FIND('-') THEN
                 IF NOT (Usersetup."User ID"='TELEPOST\ADMINISTRATOR') OR (Usersetup."User ID"='TELEPOST\MNDEKEI') THEN
                 ERROR('You have no permissions to view this records');
               END;

    ActionList=ACTIONS
    {
      { 1000000012;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000011;1 ;ActionGroup;
                      CaptionML=ENU=&Show }
      { 1000000009;1 ;ActionGroup;
                      CaptionML=ENU=F&unctions }
      { 1000000008;2 ;Action    ;
                      CaptionML=ENU=&Approvals;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 DocumentType:=DocumentType::"Leave Application";
                                 ApprovalEntries.Setfilters(DATABASE::"HR Leave Application",DocumentType,"Application Code");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1000000007;2 ;Action    ;
                      CaptionML=ENU=&Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 TESTFIELDS;
                                 TestLeaveFamily;

                                 IF CONFIRM('Send this Application for Approval?',TRUE)=FALSE THEN EXIT;
                                 Selected:=TRUE;
                                 "User ID":=USERID;

                                 //ApprovalMgt.SendLeaveAppApprovalReq(Rec);
                               END;
                                }
      { 1000000006;2 ;Action    ;
                      CaptionML=ENU=&Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 //ApprovalMgt.CancelLeaveAppRequest(Rec,TRUE,TRUE);
                               END;
                                }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=Re-Open;
                      Promoted=Yes;
                      Image=ReopenCancelled;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                                          Status:=Status::New;
                                                          MODIFY;
                               END;
                                }
      { 1000000004;2 ;Action    ;
                      CaptionML=ENU=Print;
                      Promoted=Yes;
                      Image=PrintForm;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HRLeaveApp.RESET;
                                 HRLeaveApp.SETRANGE(HRLeaveApp."Application Code","Application Code");
                                 IF HRLeaveApp.FIND('-') THEN
                                 REPORT.RUN(51516170,TRUE,TRUE,HRLeaveApp);
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      CaptionML=ENU=Create Leave Ledger Entries;
                      Promoted=Yes;
                      Visible=false;
                      Image=CreateLinesFromJob;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                                             CreateLeaveLedgerEntries;
                                                             RESET;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                CaptionML=ENU=Application No;
                SourceExpr="Application Code";
                StyleExpr=TRUE }

    { 1102755003;2;Field  ;
                SourceExpr="Employee No" }

    { 1000000003;2;Field  ;
                SourceExpr="Employee Name" }

    { 1102755005;2;Field  ;
                SourceExpr="Leave Type";
                Editable=false }

    { 1102755009;2;Field  ;
                SourceExpr="Days Applied" }

    { 1000000000;2;Field  ;
                SourceExpr="Start Date" }

    { 1102755013;2;Field  ;
                SourceExpr="Return Date" }

    { 1102755017;2;Field  ;
                SourceExpr="End Date" }

    { 1102755027;2;Field  ;
                SourceExpr="Reliever Name" }

  }
  CODE
  {
    VAR
      ApprovalMgt@1000000002 : Codeunit 1535;
      ApprovalEntries@1000000001 : Page 658;
      ApprovalComments@1000000000 : Page 660;
      DocumentType@1000000003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Bank Slip,Grant,Grant Surrender,Employee Requisition,Leave Application';
      HRLeaveApp@1000000004 : Record 51516191;
      HREmp@1000000005 : Record 51516160;
      Usersetup@1000000006 : Record 91;

    PROCEDURE TESTFIELDS@1102755002();
    BEGIN
                                      TESTFIELD("Leave Type");
                                      TESTFIELD("Days Applied");
                                      TESTFIELD("Start Date");
                                      TESTFIELD(Reliever);
                                      TESTFIELD(Supervisor);
    END;

    PROCEDURE TestLeaveFamily@1102755000();
    VAR
      Employees@1102755002 : Record 51516160;
    BEGIN
      {LeaveFamilyEmployees.SETRANGE(LeaveFamilyEmployees."Employee No","Employee No");
      IF LeaveFamilyEmployees.FINDSET THEN //find the leave family employee is associated with
      REPEAT
        LeaveFamily.SETRANGE(LeaveFamily.Code,LeaveFamilyEmployees.Family);
        LeaveFamily.SETFILTER(LeaveFamily."Max Employees On Leave",'>0');
        IF LeaveFamily.FINDSET THEN //find the status other employees on the same leave family
          BEGIN
            Employees.SETRANGE(Employees."No.",LeaveFamilyEmployees."Employee No");
            Employees.SETRANGE(Employees."Leave Status",Employees."Leave Status"::" ");
            IF Employees.COUNT>LeaveFamily."Max Employees On Leave" THEN
            ERROR('The Maximum number of employees on leave for this family has been exceeded, Contact th HR manager for more information');
          END
      UNTIL LeaveFamilyEmployees.NEXT = 0;
      }
    END;

    BEGIN
    END.
  }
}

