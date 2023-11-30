OBJECT page 172109 Loan Officer Card
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=11:27:24 PM;
    Modified=Yes;
    Version List=Micro FinanceV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516435;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1000000023;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000022;1 ;Separator  }
      { 1000000021;1 ;Action    ;
                      Name=Approval;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                   ///rereer
                               END;
                                }
      { 1000000020;1 ;Separator  }
      { 1000000019;1 ;Action    ;
                      Name=Send Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalMgt@1000000000 : Codeunit 439;
                               BEGIN

                                 //ApprovalMgt.SendLOFFApprovalRequest(Rec);
                               END;
                                }
      { 1000000017;1 ;Separator  }
      { 1000000018;1 ;Action    ;
                      Name=Cancel Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalMgt@1000000000 : Codeunit 439;
                               BEGIN

                                 //IF ApprovalMgt.CancelLOFFApprovalrequest(Rec,TRUE,TRUE) THEN;
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

    { 1000000013;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000014;2;Field  ;
                SourceExpr="Account No." }

    { 1000000015;2;Field  ;
                SourceExpr="Account Name" }

    { 1000000002;2;Field  ;
                SourceExpr="Group Target" }

    { 1000000006;2;Field  ;
                SourceExpr="Savings Target" }

    { 1000000007;2;Field  ;
                SourceExpr="Member Target" }

    { 1000000008;2;Field  ;
                SourceExpr="Disbursement Target" }

    { 1000000009;2;Field  ;
                SourceExpr="Payment Target" }

    { 1000000005;2;Field  ;
                SourceExpr="No. of Loans" }

    { 1000000010;2;Field  ;
                SourceExpr="Exit Target" }

    { 1000000011;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1000000003;2;Field  ;
                SourceExpr=Branch }

    { 1000000012;2;Field  ;
                SourceExpr=Created }

    { 1000000004;2;Field  ;
                SourceExpr="Staff Status" }

  }
  CODE
  {

    PROCEDURE UpdateControls@1000000000();
    BEGIN
          { IF Status=Status::Approved THEN BEGIN
           ReasonEditable:=FALSE;
           "Transfer TypeEditable":=FALSE;
           TranscodeEditable:=FALSE;
           DocumentNoEditable:=FALSE;
           FTransferLineEditable:=FALSE;
           END;

           IF Status=Status::Pending THEN BEGIN
            ReasonEditable :=TRUE;
           "Transfer TypeEditable":=TRUE;
           TranscodeEditable:=TRUE;
           DocumentNoEditable:=TRUE;
           FTransferLineEditable:=TRUE;
           END;

           IF Status=Status::Cancelled THEN BEGIN
           ReasonEditable:=FALSE;
           "Transfer TypeEditable":=FALSE;
           TranscodeEditable:=FALSE;
           DocumentNoEditable:=FALSE;
           FTransferLineEditable:=FALSE;
           END;
           }
    END;

    BEGIN
    END.
  }
}

