OBJECT page 172028 Processed Guarantor Sub Card
{
  OBJECT-PROPERTIES
  {
    Date=07/11/18;
    Time=[ 3:06:58 PM];
    Modified=Yes;
    Version List=GuarantorSub Ver1.0;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516397;
    PageType=Card;
    OnAfterGetRecord=BEGIN
                       FNAddRecordRestriction();
                     END;

    OnAfterGetCurrRecord=BEGIN
                           FNAddRecordRestriction();
                         END;

    ActionList=ACTIONS
    {
      { 1000000015;  ;ActionContainer;
                      Name=Root;
                      ActionContainerType=NewDocumentItems }
      { 1000000019;1 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::GuarantorSubstitution;

                                 ApprovalEntries.Setfilters(DATABASE::Table51516903,DocumentType,"Document No");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1000000018;1 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalsMgmt@1102755001 : Codeunit 1535;
                               BEGIN
                                 IF Status<>Status::"0" THEN
                                 ERROR(text001);
                                 {
                                 IF ApprovalsMgmt.CheckGuarantorSubApplicationApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendGuarantorSubApplicationForApproval(Rec);
                                   }
                               END;
                                }
      { 1000000017;1 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel A&pproval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 1535;
                               BEGIN
                                    IF Status<>Status::"0" THEN
                                       ERROR(text001);

                                    //ApprovalMgt.Cancelg;
                               END;
                                }
      { 1000000016;1 ;Action    ;
                      Name=Process Substitution;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Status<>Status::"2" THEN
                                   //ERROR('This Application has to be Approved');

                                 LGuarantor.RESET;
                                 LGuarantor.SETRANGE(LGuarantor."Loan No","Loan Guaranteed");
                                 LGuarantor.SETRANGE(LGuarantor."Member No","Substituting Member");
                                 IF LGuarantor.FINDSET THEN BEGIN

                                   GSubLine.RESET;
                                   GSubLine.SETRANGE(GSubLine."Document No","Document No");
                                   GSubLine.SETRANGE(GSubLine."Member No","Substituting Member");
                                   IF GSubLine.FINDSET THEN BEGIN
                                     LGuarantor.Substituted:=TRUE;
                                     LGuarantor."Substituted Guarantor":=GSubLine."Substitute Member";
                                     LGuarantor."Substituted Guarantor Name":=GSubLine."Substitute Member Name";
                                     LGuarantor.MODIFY;


                                       LGuarantor.INIT;
                                       LGuarantor."Loan No":="Loan Guaranteed";
                                       LGuarantor."Member No":=GSubLine."Substitute Member";
                                       LGuarantor.Name:=GSubLine."Substitute Member Name";
                                       LGuarantor."Amont Guaranteed":=GSubLine."Sub Amount Guaranteed";
                                       LGuarantor.INSERT;
                                     END;
                                   END;

                                 Substituted:=TRUE;
                                 "Date Substituted":=TODAY;
                                 "Substituted By":=USERID;
                                 MODIFY;

                                 MESSAGE('Guarantor Substituted Succesfully');
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
                SourceExpr="Document No";
                Editable=FALSE }

    { 1000000003;2;Field  ;
                SourceExpr="Application Date";
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr="Loanee Member No";
                Editable=LoaneeNoEditable }

    { 1000000005;2;Field  ;
                SourceExpr="Loanee Name";
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr="Loan Guaranteed";
                Editable=LoanGuaranteedEditable }

    { 1000000007;2;Field  ;
                SourceExpr="Substituting Member";
                Editable=SubMemberEditable }

    { 1000000008;2;Field  ;
                SourceExpr="Substituting Member Name";
                Editable=FALSE }

    { 1000000009;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1000000010;2;Field  ;
                SourceExpr="Created By";
                Editable=FALSE }

    { 1000000011;2;Field  ;
                SourceExpr=Substituted;
                Editable=FALSE }

    { 1000000012;2;Field  ;
                SourceExpr="Date Substituted";
                Editable=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr="Substituted By";
                Editable=FALSE }

    { 1000000014;1;Part   ;
                SubPageLink=Document No=FIELD(Field1);
                PagePartID=Page51516497;
                PartType=Page }

  }
  CODE
  {
    VAR
      DocumentType@1000000000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ,Purchase Requisition,RFQ,Store Requisition,Payment Voucher,MembershipApplication,LoanApplication,LoanDisbursement,ProductApplication,StandingOrder,MembershipWithdrawal,ATMCard,GuarantorRecovery,ChangeRequest,TreasuryTransactions,FundsTransfer,SaccoTransfers,ChequeDiscounting,ImprestRequisition,ImprestSurrender,LeaveApplication,GuarantorSubstitution';
      ApprovalsMgmt@1000000001 : Codeunit 1535;
      LGuarantor@1000000002 : Record 51516231;
      GSubLine@1000000003 : Record 51516398;
      LoaneeNoEditable@1000000004 : Boolean;
      LoanGuaranteedEditable@1000000005 : Boolean;
      SubMemberEditable@1000000006 : Boolean;

    LOCAL PROCEDURE FNAddRecordRestriction@1000000000();
    BEGIN
      IF Status=Status::"0" THEN BEGIN
         LoaneeNoEditable:=TRUE;
         LoanGuaranteedEditable:=TRUE;
         SubMemberEditable:=TRUE
         END ELSE
          IF Status=Status::"1" THEN BEGIN
           LoaneeNoEditable:=FALSE;
           LoanGuaranteedEditable:=FALSE;
           SubMemberEditable:=FALSE
           END ELSE
            IF Status=Status::"2" THEN BEGIN
             LoaneeNoEditable:=FALSE;
             LoanGuaranteedEditable:=FALSE;
             SubMemberEditable:=FALSE;
             END;
    END;

    BEGIN
    END.
  }
}

