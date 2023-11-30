OBJECT page 172002 Shares Transfer Card
{
  OBJECT-PROPERTIES
  {
    Date=12/07/20;
    Time=12:23:02 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516169;
    PageType=Card;
    OnOpenPage=BEGIN
                 SetEditable;
               END;

    OnAfterGetRecord=BEGIN
                       SetEditable;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           SetEditable;
                         END;

    ActionList=ACTIONS
    {
      { 1120054034;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054035;1 ;ActionGroup }
      { 1120054036;2 ;Action    ;
                      Name=Post Transaction;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=TransferFunds;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostSharesTransfer;
                               END;
                                }
      { 1120054037;2 ;Action    ;
                      Name=Member Page;
                      RunObject=page 17350;
                      RunPageLink=No.=FIELD(Member No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Card;
                      PromotedCategory=Category4 }
      { 1120054048;2 ;Action    ;
                      Name=Member Statement;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 MemReg.RESET;
                                 MemReg.SETRANGE(MemReg."No.",Rec."Member No.");
                                 IF MemReg.FINDFIRST THEN
                                   REPORT.RUN(51516223,TRUE,FALSE,MemReg);
                               END;
                                }
      { 1120054038;2 ;Action    ;
                      Name=Destination Member Page;
                      RunObject=page 17350;
                      RunPageLink=No.=FIELD(Trade To Member No);
                      Promoted=Yes;
                      Visible=Trading;
                      PromotedIsBig=Yes;
                      Image=Card;
                      PromotedCategory=Category4 }
      { 1120054047;2 ;Action    ;
                      Name=Destination Member Statement;
                      Promoted=Yes;
                      Visible=Trading;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 MemReg.RESET;
                                 MemReg.SETRANGE(MemReg."No.",Rec."Trade To Member No");
                                 IF MemReg.FINDFIRST THEN
                                   REPORT.RUN(51516223,TRUE,FALSE,MemReg);
                               END;
                                }
      { 1120054039;2 ;Action    ;
                      Name=Fosa Account Page;
                      RunObject=page 17434;
                      RunPageLink=No.=FIELD(Fosa Account No.);
                      Promoted=Yes;
                      Visible=TransferFromFosa;
                      PromotedIsBig=Yes;
                      Image=OpenWorksheet;
                      PromotedCategory=Category4 }
      { 1120054046;2 ;Action    ;
                      Name=Fosa Statement;
                      Promoted=Yes;
                      Visible=TransferFromFosa;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 FosaStmt@1120054000 : Record 23;
                               BEGIN
                                 FosaStmt.RESET;
                                 FosaStmt.SETRANGE(FosaStmt."No.","Fosa Account No.");
                                 IF FosaStmt.FINDFIRST THEN
                                   REPORT.RUN(51516201,TRUE,FALSE,FosaStmt);
                               END;
                                }
      { 1120054049;2 ;Action    ;
                      Name=Shares Transfer Slip;
                      Promoted=Yes;
                      Visible=TrasferslipVisible;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 FosaStmt@1120054000 : Record 23;
                                 CooperativeSharesTransfer@1120054001 : Record 51516169;
                               BEGIN
                                 TESTFIELD(Status,Status::Posted);

                                 CooperativeSharesTransfer.RESET;
                                 CooperativeSharesTransfer.SETRANGE(CooperativeSharesTransfer.Code,Rec.Code);
                                 IF CooperativeSharesTransfer.FINDFIRST THEN
                                    REPORT.RUN(51516025,TRUE,FALSE,CooperativeSharesTransfer);
                               END;
                                }
      { 1120054043;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1000 : Page 658;
                                 ApprovalsMgmt@1120054000 : Codeunit 1535;
                               BEGIN

                                 ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 1120054042;2 ;Action    ;
                      Name=Send A&pproval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755001 : TextConst 'ENU=This Batch is already pending approval';
                                 ApprovalsMgmt@1000000000 : Codeunit 1535;
                               BEGIN
                                 Rec.ApprovalsRequest(0);
                               END;
                                }
      { 1120054041;2 ;Action    ;
                      Name=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 1535;
                               BEGIN
                                 Rec.ApprovalsRequest(1);
                               END;
                                }
      { 1120054040;2 ;Action    ;
                      CaptionML=ENU=Re-Open;
                      Promoted=Yes;
                      Image=ReopenCancelled;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 DocReopened@1120054000 : TextConst 'ENU=Document %1 has been reopened successfully!';
                               BEGIN
                                 TESTFIELD(Status,Rec.Status::Approved);
                                 TESTFIELD("Approved By",USERID);
                                 Status:=Status::Open;
                                 CLEAR("Approved By");
                                 CLEAR("Approved On");
                                 MODIFY;
                                 MESSAGE(DocReopened,Code);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Initiate;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr=Code }

    { 1120054003;2;Field  ;
                SourceExpr="Member No." }

    { 1120054004;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054005;2;Field  ;
                SourceExpr=Type;
                OnValidate=BEGIN
                             SetEditable;
                           END;
                            }

    { 1120054006;2;Field  ;
                SourceExpr="Staff No" }

    { 1120054007;2;Field  ;
                SourceExpr="Employer code" }

    { 1120054008;2;Field  ;
                SourceExpr="Deposit Contribution" }

    { 1120054009;2;Field  ;
                SourceExpr="Co-operative Shares Balance" }

    { 1120054010;1;Group  ;
                Name=Transfer From Fosa;
                Visible=TransferFromFosa;
                GroupType=Group }

    { 1120054011;2;Field  ;
                SourceExpr="Fosa Account No." }

    { 1120054012;2;Field  ;
                SourceExpr="Fosa Account Name" }

    { 1120054013;2;Field  ;
                SourceExpr="Fosa Available Balance" }

    { 1120054014;1;Group  ;
                Name=Trade;
                Visible=Trading;
                GroupType=Group }

    { 1120054015;2;Field  ;
                SourceExpr="Trade To Member No" }

    { 1120054016;2;Field  ;
                SourceExpr="Trade To Member Name" }

    { 1120054017;2;Field  ;
                SourceExpr="Trade To Staff No" }

    { 1120054018;2;Field  ;
                SourceExpr="Trade To Employer Code" }

    { 1120054019;2;Field  ;
                SourceExpr="Trade To Shares Balance" }

    { 1120054029;1;Group  ;
                Name=Share Transaction;
                GroupType=Group }

    { 1120054030;2;Field  ;
                SourceExpr="Price Per Share" }

    { 1120054031;2;Field  ;
                SourceExpr="No Of Shares" }

    { 1120054032;2;Field  ;
                SourceExpr="Total Amount" }

    { 1120054033;2;Field  ;
                SourceExpr="Amount Charged" }

    { 1120054020;1;Group  ;
                Name=Logs;
                GroupType=Group }

    { 1120054021;2;Field  ;
                SourceExpr="Posting Date" }

    { 1120054022;2;Field  ;
                SourceExpr=Status }

    { 1120054023;2;Field  ;
                SourceExpr="Created By" }

    { 1120054024;2;Field  ;
                SourceExpr="Created On" }

    { 1120054025;2;Field  ;
                SourceExpr="Last Updated On" }

    { 1120054026;2;Field  ;
                SourceExpr="Last Updated By" }

    { 1120054044;2;Field  ;
                SourceExpr="Approved By" }

    { 1120054045;2;Field  ;
                SourceExpr="Approved On" }

    { 1120054027;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054028;2;Field  ;
                SourceExpr="Posted On" }

  }
  CODE
  {
    VAR
      TransferFromFosa@1120054000 : Boolean INDATASET;
      TransferFromBosa@1120054001 : Boolean;
      Trading@1120054002 : Boolean INDATASET;
      MemReg@1120054003 : Record 51516223;
      TrasferslipVisible@1120054004 : Boolean INDATASET;

    LOCAL PROCEDURE SetEditable@1120054000();
    BEGIN
      CurrPage.EDITABLE := Status=Status::Open;
      TransferFromFosa:=Type=Type::"Transfer From Fosa";
      TransferFromBosa:=Type=Type::"Transfer From Bosa";
      Trading:=Type=Type::Trade;
      TrasferslipVisible:=Status=Status::Posted;
    END;

    BEGIN
    END.
  }
}

