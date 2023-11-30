OBJECT page 172096 LoansReg
{
  OBJECT-PROPERTIES
  {
    Date=02/05/19;
    Time=[ 5:39:06 PM];
    Modified=Yes;
    Version List=Web System;
  }
  PROPERTIES
  {
    SourceTable=Table51516230;
    PageType=List;
    OnModifyRecord=BEGIN
                     // IF EntrySource='WEB' THEN BEGIN
                     //   TotalsLoans.RESET;
                     //   TotalsLoans.SETRANGE(LoanNo, TotalsLoans.LoanNo);
                     //   IF TotalsLoans.FIND('-') THEN BEGIN
                     //     "Client Code":=TotalsLoans.CLientCode;
                     //    REPEAT
                     //      "Requested Amount":="Requested Amount"+TotalsLoans.AppliedAmount;
                     //
                     //      UNTIL TotalsLoans.NEXT=0;
                     //     END;
                     // VALIDATE("Client Code");
                     // VALIDATE("Requested Amount");
                     // MODIFY;
                     // END;
                   END;

  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Loan  No." }

    { 1120054003;2;Field  ;
                SourceExpr="Application Date" }

    { 1120054004;2;Field  ;
                SourceExpr="Client Code" }

    { 1120054005;2;Field  ;
                SourceExpr="Requested Amount" }

    { 1120054010;2;Field  ;
                SourceExpr="Loan Purpose" }

    { 1120054008;2;Field  ;
                SourceExpr="Client Name" }

    { 1120054009;2;Field  ;
                SourceExpr="Approved Amount" }

    { 1120054011;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1120054014;2;Field  ;
                SourceExpr=Interest }

    { 1120054016;2;Field  ;
                SourceExpr=Installments }

    { 1120054017;2;Field  ;
                SourceExpr="Loan Product Type Name" }

    { 1120054019;2;Field  ;
                SourceExpr="Repayment Method" }

    { 1120054020;2;Field  ;
                SourceExpr="Repayment Frequency" }

    { 1120054021;2;Field  ;
                SourceExpr="Appraisal Status" }

    { 1120054022;2;Field  ;
                SourceExpr="Approval Status" }

    { 1120054024;2;Field  ;
                SourceExpr=Posted }

    { 1120054025;2;Field  ;
                SourceExpr="Mode of Disbursement" }

    { 1120054026;2;Field  ;
                SourceExpr="Loan Disbursement Date" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

