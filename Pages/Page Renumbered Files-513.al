OBJECT page 172108 Loan Officer Details
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=11:26:59 PM;
    Modified=Yes;
    Version List=Micro FinanceV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516435;
    PageType=List;
    CardPageID=Loan Officer Card;
    ActionList=ACTIONS
    {
      { 1000000011;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000012;1 ;Separator  }
      { 1000000013;1 ;Action    ;
                      Name=Approval;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                   ///rereer
                               END;
                                }
      { 1000000014;1 ;Separator  }
      { 1000000015;1 ;Action    ;
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
      { 1000000016;1 ;Separator  }
      { 1000000017;1 ;Action    ;
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
                Name=Group;
                GroupType=Repeater }

    { 1000000003;2;Field  ;
                SourceExpr="Account No." }

    { 1000000005;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000004;2;Field  ;
                SourceExpr="Account Name" }

    { 1000000006;2;Field  ;
                SourceExpr="Savings Target" }

    { 1000000007;2;Field  ;
                SourceExpr="Member Target" }

    { 1000000008;2;Field  ;
                SourceExpr="Disbursement Target" }

    { 1000000009;2;Field  ;
                SourceExpr="Payment Target" }

    { 1000000010;2;Field  ;
                SourceExpr="Exit Target" }

    { 1000000019;2;Field  ;
                SourceExpr="No. of Loans" }

    { 1000000002;2;Field  ;
                SourceExpr=Status }

    { 1000000018;2;Field  ;
                SourceExpr=Created }

  }
  CODE
  {

    BEGIN
    END.
  }
}

