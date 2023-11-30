OBJECT page 50037 Pending Approvals
{
  OBJECT-PROPERTIES
  {
    Date=11/05/22;
    Time=[ 3:44:39 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516230;
    SourceTableView=WHERE(Posted=CONST(No),
                          Source=FILTER(BOSA),
                          Loan Status=CONST(Appraisal),
                          Approval Status=CONST(Pending));
    PageType=List;
    CardPageID=Loan Appraised Card2;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="Loan  No." }

    { 1102755003;2;Field  ;
                SourceExpr="Application Date" }

    { 1102755004;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1102755005;2;Field  ;
                CaptionML=ENU=Member  No;
                SourceExpr="Client Code" }

    { 1120054002;2;Field  ;
                CaptionML=ENU=Staff No;
                SourceExpr="Staff No";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Group Code" }

    { 1102755007;2;Field  ;
                SourceExpr="Client Name" }

    { 1102755008;2;Field  ;
                SourceExpr="Requested Amount" }

    { 1102755009;2;Field  ;
                SourceExpr="Approved Amount" }

    { 1102755010;2;Field  ;
                SourceExpr="Loan Status" }

    { 1120054001;2;Field  ;
                SourceExpr="Approval Status" }

    { 1102755014;2;Field  ;
                SourceExpr="Issued Date" }

    { 1102755011;2;Field  ;
                SourceExpr="Expected Date of Completion" }

    { 1102755013;2;Field  ;
                SourceExpr=Installments }

    { 1102755012;2;Field  ;
                SourceExpr=Repayment }

    { 1102755015;2;Field  ;
                SourceExpr="Rejection  Remark" }

    { 1000000002;2;Field  ;
                SourceExpr="Captured By" }

    { 1000000003;2;Field  ;
                SourceExpr="Approved By" }

    { 1120054000;2;Field  ;
                SourceExpr=LoantypeCode }

    { 1000000001;0;Container;
                ContainerType=FactBoxArea }

    { 1000000000;1;Part   ;
                SubPageLink=No.=FIELD(Client Code);
                PagePartID=Page51516371;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

