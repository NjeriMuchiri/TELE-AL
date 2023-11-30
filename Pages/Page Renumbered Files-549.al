OBJECT page 172144 HR Jobs List
{
  OBJECT-PROPERTIES
  {
    Date=04/22/20;
    Time=[ 2:52:09 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=Yes;
    DeleteAllowed=Yes;
    ModifyAllowed=No;
    SourceTable=Table51516100;
    DelayedInsert=No;
    PageType=List;
    CardPageID=HR Jobs Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=New,Process,Report,Functions,Job,Administration;
    ActionList=ACTIONS
    {
      { 1000000015;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000010;1 ;ActionGroup;
                      Name=Functions;
                      CaptionML=ENU=Functions }
      { 1000000003;2 ;Action    ;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 DocumentType@1102755000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Bank Slip,Grant,Grant Surrender,Employee Requisition,Leave Application,Training Application,Transport Requisition,Job';
                                 ApprovalEntries@1102755001 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::Job;
                                 ApprovalEntries.Setfilters(DATABASE::"HR Jobs",DocumentType,"Job ID");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 {
                                 IF CONFIRM('Send this job position for Approval?',TRUE)=FALSE THEN EXIT;
                                 AppMgmt.SendJobApprovalReq(Rec);
                                 }
                               END;
                                }
      { 1000000001;2 ;Action    ;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=CancelAllLines;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 {
                                 IF CONFIRM('Cancel Approval Request?',TRUE)=FALSE THEN EXIT;
                                 AppMgmt.CancelJobAppRequest(Rec,TRUE,TRUE);
                                  }
                               END;
                                }
      { 1102755014;1 ;ActionGroup;
                      CaptionML=ENU=Job }
      { 1000000006;2 ;Action    ;
                      CaptionML=ENU=Requirements;
                      RunObject=page 172149;
                      RunPageLink=Job Id=FIELD(Job ID);
                      Promoted=Yes;
                      Image=Card;
                      PromotedCategory=Category5 }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=Responsibilities;
                      RunObject=page 172151;
                      RunPageLink=Job ID=FIELD(Job ID);
                      Promoted=Yes;
                      Image=JobResponsibility;
                      PromotedCategory=Category5 }
      { 1000000004;2 ;Action    ;
                      CaptionML=ENU=Occupants;
                      RunObject=page 172121;
                      RunPageLink=Job ID=FIELD(Job ID);
                      Promoted=Yes;
                      Image=ContactPerson;
                      PromotedCategory=Category5 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="Job ID";
                Importance=Promoted }

    { 1000000016;2;Field  ;
                SourceExpr="Job Description" }

    { 1000000017;2;Field  ;
                SourceExpr="No of Posts" }

    { 1102755011;2;Field  ;
                SourceExpr="Responsibility Center";
                Enabled=false }

    { 1102755012;2;Field  ;
                SourceExpr="Date Created";
                StyleExpr=TRUE }

    { 1102755010;2;Field  ;
                SourceExpr=Status;
                Style=StandardAccent;
                StyleExpr=TRUE }

    { 1000000000;;Container;
                ContainerType=FactBoxArea }

    { 1102755002;1;Part   ;
                SubPageLink=Job ID=FIELD(Job ID);
                PagePartID=Page51516884;
                PartType=Page }

    { 1102755004;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {

    BEGIN
    END.
  }
}

