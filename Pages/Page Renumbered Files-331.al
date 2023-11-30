OBJECT page 50022 Loan List All
{
  OBJECT-PROPERTIES
  {
    Date=04/17/18;
    Time=[ 2:10:36 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=Yes;
    DeleteAllowed=Yes;
    ModifyAllowed=Yes;
    SourceTable=Table51516230;
    SourceTableView=SORTING(Client Code,Loan Product Type,Posted,Issued Date);
    PageType=List;
    CardPageID=Loan Application Card;
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

    { 1000000003;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1000000002;2;Field  ;
                SourceExpr="Oustanding Interest" }

    { 1102755003;2;Field  ;
                SourceExpr="Application Date" }

    { 1102755004;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1102755005;2;Field  ;
                CaptionML=ENU=Member  No;
                SourceExpr="Client Code" }

    { 1102755006;2;Field  ;
                SourceExpr="Group Code" }

    { 1102755007;2;Field  ;
                SourceExpr="Client Name" }

    { 1102755008;2;Field  ;
                SourceExpr="Requested Amount" }

    { 1102755009;2;Field  ;
                SourceExpr="Approved Amount" }

    { 1   ;2   ;Field     ;
                SourceExpr="Loans Category" }

    { 2   ;2   ;Field     ;
                SourceExpr="Loans Category-SASRA" }

    { 1102755010;2;Field  ;
                SourceExpr="Loan Status" }

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

