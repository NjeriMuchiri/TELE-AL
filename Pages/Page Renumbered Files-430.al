OBJECT page 172025 Guarantor Sub Card
{
  OBJECT-PROPERTIES
  {
    Date=06/30/22;
    Time=12:25:59 PM;
    Modified=Yes;
    Version List=GuarantorSub Ver1.0;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516556;
    SourceTableView=WHERE(Substituted=CONST(No));
    PageType=Card;
    OnAfterGetRecord=BEGIN
                       FNAddRecordRestriction();
                     END;

    OnAfterGetCurrRecord=BEGIN
                           FNAddRecordRestriction();
                           //EnableCreateMember:=FALSE;
                           //OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
                           //CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
                           EnabledApprovalWorkflowsExist :=TRUE;
                           IF Rec.Status=Status::Approved THEN BEGIN
                             OpenApprovalEntriesExist:=FALSE;
                             CanCancelApprovalForRecord:=FALSE;
                             EnabledApprovalWorkflowsExist:=FALSE;
                             END;
                           //   IF ((Rec.Status=Status::Approved)) THEN
                           //     EnableCreateMember:=TRUE;
                         END;

    ActionList=ACTIONS
    {
      { 1000000015;  ;ActionContainer;
                      Name=Root;
                      ActionContainerType=NewDocumentItems }
      { 1000000016;1 ;Action    ;
                      Name=Process Substitution;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 AmountCommitted@1120054003 : Decimal;
                                 MaximumAmountToCommit@1120054002 : Decimal;
                                 BalanceToCommit@1120054001 : Decimal;
                                 CustR@1120054005 : Record 51516223;
                                 GuarantorsDetails@1120054004 : Record 51516231;
                                 LoanApp@1120054000 : Record 51516230;
                               BEGIN
                                 IF Status<>Status::Approved THEN BEGIN
                                   //ERROR('This Application has to be Approved');
                                 IF "Transaction Type"="Transaction Type"::"Guarantor Replacement" THEN BEGIN
                                 LGuarantor.RESET;
                                 LGuarantor.SETRANGE(LGuarantor."Loan No","Loan Guaranteed");
                                 LGuarantor.SETRANGE(LGuarantor."Member No","Substituting Member");
                                 IF LGuarantor.FINDSET THEN BEGIN

                                   //Add All Replaced Amounts
                                   TotalReplaced:=0;
                                   GSubLine.RESET;
                                   GSubLine.SETRANGE(GSubLine."Document No","Document No");
                                   GSubLine.SETRANGE(GSubLine."Member No","Substituting Member");
                                   IF GSubLine.FINDSET THEN BEGIN
                                     REPEAT
                                       TotalReplaced:=TotalReplaced+GSubLine."Sub Amount Guaranteed";
                                       UNTIL GSubLine.NEXT=0;
                                     END;
                                   //End Add All Replaced Amounts

                                   //Compare with committed shares
                                 //  Commited:=LGuarantor."Committed Shares";
                                   IF TotalReplaced <Commited THEN
                                     ERROR('Guarantors replaced do not cover the whole amount');
                                   //End Compare with committed Shares

                                   //Create Lines
                                   GSubLine.RESET;
                                   GSubLine.SETRANGE(GSubLine."Document No","Document No");
                                   GSubLine.SETRANGE(GSubLine."Member No","Substituting Member");
                                   IF GSubLine.FINDSET THEN BEGIN
                                     REPEAT
                                       NewLGuar.INIT;
                                       NewLGuar."Loan No":="Loan Guaranteed";
                                       NewLGuar."Guar Sub Doc No.":="Document No";
                                       NewLGuar."Member No":=GSubLine."Substitute Member";
                                       NewLGuar.VALIDATE(NewLGuar."Member No");
                                       NewLGuar.Name:=GSubLine."Substitute Member Name";
                                      // NewLGuar."Committed Shares":=GSubLine."Sub Amount Guaranteed";
                                       NewLGuar."Amont Guaranteed":=CalculateAmountGuaranteed(GSubLine."Sub Amount Guaranteed",TotalReplaced,GSubLine."Amount Guaranteed");
                                       NewLGuar.INSERT;
                                       UNTIL GSubLine.NEXT=0;
                                     END;
                                     END;
                                   //End Create Lines

                                   //Edit Loan Guar
                                     LGuarantor.Substituted:=TRUE;
                                    // LGuarantor."Committed Shares" := 0;
                                     LGuarantor."Guar Sub Doc No.":="Document No";
                                     LGuarantor.MODIFY;
                                     //End Edit Loan Guar

                                   Substituted:=TRUE;
                                   "Date Substituted":=TODAY;
                                   "Substituted By":=USERID;
                                   MODIFY;

                                   MESSAGE('Guarantor Substituted Succesfully');

                                 END;


                                 IF "Transaction Type"="Transaction Type"::"Share Increment" THEN BEGIN
                                 AmountCommitted:=0;
                                 LGuarantors.RESET;
                                 LGuarantors.SETRANGE(LGuarantors."Document No","Document No");
                                 IF LGuarantors.FINDFIRST THEN BEGIN
                                 REPEAT
                                 //MESSAGE('Here%1',LGuarantor."Substituted Guarantor");
                                 GuarantorsDetails.RESET;
                                 GuarantorsDetails.SETRANGE(GuarantorsDetails."Member No",LGuarantors."Substitute Member");
                                 IF GuarantorsDetails.FINDFIRST THEN
                                 BEGIN
                                 REPEAT
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.",GuarantorsDetails."Loan No");
                                 LoanApp.SETAUTOCALCFIELDS(LoanApp."Outstanding Balance");
                                 LoanApp.SETFILTER(LoanApp."Outstanding Balance",'>%1',0);
                                 IF LoanApp.FINDFIRST THEN BEGIN
                                 AmountCommitted:=GuarantorsDetails."Amont Guaranteed"+AmountCommitted;
                                 END;
                                 UNTIL GuarantorsDetails.NEXT=0;


                                 IF CustR.GET(LGuarantors."Substitute Member") THEN
                                 CustR.CALCFIELDS(CustR."Current Shares");
                                 MaximumAmountToCommit:=0;
                                 MaximumAmountToCommit:=CustR."Current Shares"*4;
                                 IF AmountCommitted>MaximumAmountToCommit THEN BEGIN
                                 ERROR('You can only guarantee shares up to %1.Your current guaranteed amount is %2',MaximumAmountToCommit,AmountCommitted)
                                 END ELSE BEGIN
                                 BalanceToCommit:=MaximumAmountToCommit-AmountCommitted;
                                 MESSAGE('Maximum shares to guarantee is %1.Committed amount is %2 .Shares balance to guarantee is %3.',MaximumAmountToCommit,AmountCommitted,BalanceToCommit);
                                 END;
                                 END;



                                 //Update new guarantor
                                 NewLGuars.RESET;
                                 NewLGuars.SETRANGE(NewLGuars."Member No",LGuarantors."Substitute Member");
                                 NewLGuars.SETRANGE(NewLGuars."Loan No","Loan Guaranteed");
                                 IF NewLGuars.FINDFIRST THEN BEGIN
                                 NewLGuars."Amont Guaranteed":=NewLGuars."Amont Guaranteed"+LGuarantors."Amount Guaranteed";
                                 NewLGuars.MODIFY;
                                 END;
                                 //Update new guarantor

                                 FnUpdatePreviousRecord(LGuarantors."Loan No.",LGuarantors."Member No",LGuarantors."Document No");


                                 UNTIL LGuarantors.NEXT=0;
                                 END;

                                   Substituted:=TRUE;
                                   "Date Substituted":=TODAY;
                                   "Substituted By":=USERID;
                                   MODIFY;

                                   MESSAGE('Guarantor Substituted Succesfully');
                                 END;
                                 END;
                               END;
                                }
      { 1000000018;1 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Enabled=(NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalsMgmt@1102755001 : Codeunit 1535;
                               BEGIN
                                 //IF Status<>Status::Open THEN
                                 //ERROR(text001);
                                 // ApprovalsMgmt.CheckGuarantorSubWorkflowEnabled(Rec) THEN
                                  // ApprovalsMgmt.OnSendGuarantorSubForApproval(Rec);
                               END;
                                }
      { 1000000017;1 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel A&pproval Request;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 1535;
                               BEGIN

                                  // IF ApprovalsMgmt.CheckGuarantorSubWorkflowEnabled(Rec) THEN
                                   //  ApprovalsMgmt.OnCancelGuarantorSubApprovalRequest(Rec);
                               END;
                                }
      { 1000000019;1 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                                 DocumentType@1000000000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ,Purchase Requisition,RFQ,Store Requisition,Payment Voucher,MembershipApplication,LoanApplication,LoanDisbursement,ProductApplication,StandingOrder,MembershipWithdrawal,ATMCard,GuarantorRecovery,ChangeRequest,TreasuryTransactions,FundsTransfer,SaccoTransfers,ChequeDiscounting,ImprestRequisition,ImprestSurrender,LeaveApplication,FixedDeposits,CloudPesaApps,AgentApps,LoanOfficerDetails,GuarantorSub';
                               BEGIN
                                 // DocumentType:=DocumentType::GuarantorSub;

                                 // ApprovalEntries.Setfilters(DATABASE::"Guarantorship Substitution H",DocumentType,"Document No");
                                 // ApprovalEntries.RUN;
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

    { 1120054000;2;Field  ;
                SourceExpr="Transaction Type" }

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
                CaptionML=ENU=Member To Be Substituted;
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
                SubPageLink=Document No=FIELD(Document No),
                            Member No=FIELD(Substituting Member),
                            Loan No.=FIELD(Loan Guaranteed);
                PagePartID=Page51516497;
                PartType=Page }

  }
  CODE
  {
    VAR
      LGuarantor@1000000002 : Record 51516231;
      GSubLine@1000000003 : Record 51516557;
      LoaneeNoEditable@1000000004 : Boolean;
      LoanGuaranteedEditable@1000000005 : Boolean;
      SubMemberEditable@1000000006 : Boolean;
      TotalReplaced@1000000007 : Decimal;
      Commited@1000000008 : Decimal;
      NewLGuar@1000000009 : Record 51516231;
      DocumentType@1000000016 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ,Purchase Requisition,RFQ,Store Requisition,Payment Voucher,MembershipApplication,LoanApplication,LoanDisbursement,ProductApplication,StandingOrder,MembershipWithdrawal,ATMCard,GuarantorRecovery';
      OpenApprovalEntriesExist@1000000015 : Boolean;
      EnabledApprovalWorkflowsExist@1000000014 : Boolean;
      ApprovalsMgmt@1000000013 : Codeunit 1535;
      CanCancelApprovalForRecord@1000000012 : Boolean;
      EventFilter@1000000011 : Text;
      EnableCreateMember@1000000010 : Boolean;
      NewLGuars@1120054000 : Record 51516231;
      LGuarantors@1120054001 : Record 51516557;

    LOCAL PROCEDURE FNAddRecordRestriction@1000000000();
    BEGIN
      IF Status=Status::Open THEN BEGIN
         LoaneeNoEditable:=TRUE;
         LoanGuaranteedEditable:=TRUE;
         SubMemberEditable:=TRUE
         END ELSE
          IF Status=Status::Pending THEN BEGIN
           LoaneeNoEditable:=FALSE;
           LoanGuaranteedEditable:=FALSE;
           SubMemberEditable:=FALSE
           END ELSE
            IF Status=Status::Approved THEN BEGIN
             LoaneeNoEditable:=FALSE;
             LoanGuaranteedEditable:=FALSE;
             SubMemberEditable:=FALSE;
             END;
    END;

    LOCAL PROCEDURE CalculateAmountGuaranteed@1000000006(AmountReplaced@1000000000 : Decimal;TotalAmount@1000000001 : Decimal;AmountGuaranteed@1000000002 : Decimal) AmtGuar : Decimal;
    BEGIN
      AmtGuar:=((AmountReplaced/TotalAmount)*AmountGuaranteed);

      EXIT(AmtGuar);
    END;

    LOCAL PROCEDURE FnUpdatePreviousRecord@1120054000(LoanNumber@1120054000 : Code[40];GuarantorCode@1120054001 : Code[40];DocumentGur@1120054003 : Code[40]);
    VAR
      Guarantors@1120054002 : Record 51516231;
    BEGIN
      Guarantors.RESET;
      Guarantors.SETRANGE(Guarantors."Loan No",LoanNumber);
      Guarantors.SETRANGE(Guarantors."Member No",GuarantorCode);
      IF Guarantors.FIND('-') THEN BEGIN
      Guarantors."Amont Guaranteed":=0;
      Guarantors.Substituted:=TRUE;
      Guarantors."Guar Sub Doc No.":=DocumentGur;
      Guarantors.MODIFY;
      END;
    END;

    BEGIN
    END.
  }
}

