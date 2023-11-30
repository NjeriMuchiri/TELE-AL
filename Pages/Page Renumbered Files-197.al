OBJECT page 17388 Loans Sub-Page List
{
  OBJECT-PROPERTIES
  {
    Date=08/30/21;
    Time=10:32:22 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516230;
    PageType=ListPart;
    OnClosePage=BEGIN
                  loan.RESET;
                  loan.SETRANGE(loan."Loan  No.","Loan  No.");
                  IF loan.FINDSET THEN  BEGIN
                  REPEAT
                    Repayment:="Loan Principle Repayment"+"Loan Interest Repayment";
                   MODIFY;
                      UNTIL loan.NEXT=0;
                     END;
                END;

    OnAfterGetRecord=BEGIN
                       Repayment:="Loan Principle Repayment"+"Loan Interest Repayment";
                     END;

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
                SourceExpr="Client Code" }

    { 1120054000;2;Field  ;
                SourceExpr=Defaulted }

    { 1102760028;2;Field  ;
                SourceExpr="Staff No";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                CaptionML=ENU=Installments;
                SourceExpr=Installments;
                Editable=TRUE }

    { 1102760018;2;Field  ;
                SourceExpr="Requested Amount";
                Editable=TRUE }

    { 1000000015;2;Field  ;
                SourceExpr="Approved Amount";
                Editable=TRUE }

    { 1102755000;2;Field  ;
                SourceExpr="Loan Principle Repayment" }

    { 1102755002;2;Field  ;
                SourceExpr="Loan Interest Repayment" }

    { 1102755005;2;Field  ;
                SourceExpr=Repayment;
                Editable=TRUE;
                OnValidate=BEGIN
                             //"Loan  No.".reset;
                             //SETRANGE("Loan  No.","Loan  No.");
                             Repayment:="Loan Principle Repayment"+"Loan Interest Repayment";
                             ///MODIFY;
                           END;
                            }

    { 1102760010;2;Field  ;
                SourceExpr="Loan Status";
                Editable=FALSE }

    { 1000000021;2;Field  ;
                SourceExpr="Outstanding Balance";
                Editable=FALSE }

    { 1102755007;2;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1102760032;2;Field  ;
                SourceExpr="No. Of Guarantors";
                Visible=FALSE;
                Enabled=TRUE;
                Editable=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr="Interest Paid" }

    { 1102760008;2;Field  ;
                SourceExpr="Interest Due";
                Editable=FALSE }

    { 1102755008;2;Field  ;
                SourceExpr="Penalty Paid" }

    { 1000000003;2;Field  ;
                SourceExpr="Recovery Mode" }

    { 1102755009;2;Field  ;
                SourceExpr="Penalty Charged" }

    { 1102760000;2;Field  ;
                SourceExpr="Issued Date";
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr="Expected Date of Completion" }

    { 1102760026;2;Field  ;
                SourceExpr="Last Pay Date";
                Visible=FALSE;
                Editable=FALSE }

    { 1102760030;2;Field  ;
                SourceExpr="Account No";
                Editable=FALSE }

    { 1102756000;2;Field  ;
                SourceExpr=Advice;
                Visible=FALSE }

    { 1102756002;2;Field  ;
                SourceExpr="Advice Type";
                Visible=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr=Posted;
                Editable=false }

    { 1   ;2   ;Field     ;
                SourceExpr=Source }

    { 2   ;2   ;Field     ;
                SourceExpr="Oustanding Interest" }

    { 1102755012;2;Field  ;
                SourceExpr="Loans Insurance" }

    { 1102755010;2;Field  ;
                CaptionML=ENU=Payment Mode;
                SourceExpr="Mode of Disbursement" }

    { 1102755011;2;Field  ;
                SourceExpr="Loan Disbursed Amount" }

  }
  CODE
  {
    VAR
      LoanType@1000000000 : Record 51516240;
      NoSeriesMgt@1000000001 : Codeunit 396;
      loan@1120054000 : Record 51516230;

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

