OBJECT page 172140 HR Leave Applications List
{
  OBJECT-PROPERTIES
  {
    Date=08/29/22;
    Time=[ 5:05:25 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516191;
    SourceTableView=WHERE(Status=FILTER(<>Approved),
                          Posted=FILTER(No));
    PageType=List;
    CardPageID=HR Leave Application Card;
    OnOpenPage=BEGIN
                 HREmp.RESET;
                 HREmp.SETRANGE(HREmp."User ID",USERID);
                 IF HREmp.GET THEN
                 SETRANGE("User ID",HREmp."User ID")
                 ELSE
                 //user id may not be the creator of the doc
                 SETRANGE("User ID",USERID);
               END;

    ActionList=ACTIONS
    {
      { 1000000012;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000011;1 ;ActionGroup;
                      CaptionML=ENU=&Show }
      { 1000000009;1 ;ActionGroup;
                      CaptionML=ENU=F&unctions }
      { 1000000004;2 ;Action    ;
                      CaptionML=ENU=Print;
                      Promoted=Yes;
                      Image=PrintForm;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HRLeaveApp.RESET;
                                 HRLeaveApp.SETRANGE(HRLeaveApp."Application Code","Application Code");
                                 IF HRLeaveApp.FIND('-') THEN
                                   REPORT.RUN(51516610,TRUE,TRUE,HRLeaveApp);
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

    { 1   ;2   ;Field     ;
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

    { 1000000001;2;Field  ;
                SourceExpr=Status;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755002;0;Container;
                ContainerType=FactBoxArea }

    { 1102755006;1;Part   ;
                SubPageLink=No.=FIELD(Employee No);
                PagePartID=Page51516880;
                PartType=Page }

    { 1102755004;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

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
      LeaveFamily@1102755000 : Record 51516408;
      LeaveFamilyEmployees@1102755001 : Record 51516408;
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
      UNTIL LeaveFamilyEmployees.NEXT = 0;}
    END;

    BEGIN
    END.
  }
}

