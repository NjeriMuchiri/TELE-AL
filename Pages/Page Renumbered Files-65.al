OBJECT page 20429 Loans Edibale SubList
{
  OBJECT-PROPERTIES
  {
    Date=12/15/20;
    Time=[ 9:26:06 AM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516230;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1000000001;2;Field  ;
                SourceExpr="Loan  No.";
                Editable=FALSE }

    { 1102755003;2;Field  ;
                SourceExpr="Application Date";
                Editable=FALSE }

    { 1000000002;2;Field  ;
                SourceExpr="Loan Product Type Name";
                Editable=false }

    { 1000000025;2;Field  ;
                SourceExpr="Loan Product Type";
                Editable=FALSE }

    { 1102755001;2;Field  ;
                SourceExpr="Client Code";
                Editable=false }

    { 1000000015;2;Field  ;
                SourceExpr="Approved Amount";
                Editable=false }

    { 1120054002;2;Field  ;
                SourceExpr=Installments }

    { 1102755000;2;Field  ;
                SourceExpr="Loan Principle Repayment" }

    { 1102755002;2;Field  ;
                SourceExpr="Loan Interest Repayment" }

    { 1120054001;2;Field  ;
                SourceExpr=Repayment }

    { 1000000021;2;Field  ;
                SourceExpr="Outstanding Balance";
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Recovery Mode" }

  }
  CODE
  {
    VAR
      LoanType@1000000000 : Record 51516240;
      NoSeriesMgt@1000000001 : Codeunit 396;

    PROCEDURE GetVariables@1000000000(VAR LoanNo@1000000000 : Code[20];VAR LoanProductType@1000000001 : Code[20];VAR MemberNo@1102760000 : Code[20]);
    BEGIN
      LoanNo:="Loan  No.";
      LoanProductType:="Loan Product Type";
      MemberNo:="Client Code";
    END;

    BEGIN
    END.
  }
}

