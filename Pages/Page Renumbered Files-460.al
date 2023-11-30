OBJECT page 172055 Tranche Card
{
  OBJECT-PROPERTIES
  {
    Date=02/18/22;
    Time=[ 2:59:20 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516259;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054008;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054007;1 ;ActionGroup }
      { 1120054006;2 ;Action    ;
                      Name=Post Tranche;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to post this installment?',TRUE,FALSE)=TRUE THEN BEGIN
                                 FnTrancheDisbursement("No.","Amount to Refund");
                                 END;
                               END;
                                }
      { 1120054009;2 ;Action    ;
                      Name=Mark As Posted;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Posted:=TRUE;
                                 "Posted By":=USERID;
                                 "Closing Date":=TODAY;
                                 "Withdrawal Status":="Withdrawal Status"::Posted;
                                 MODIFY;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="No." }

    { 1120054003;2;Field  ;
                SourceExpr="Member No.";
                Editable=False }

    { 1120054004;2;Field  ;
                SourceExpr="Member Name";
                Editable=False }

    { 1120054005;2;Field  ;
                SourceExpr="Closing Date";
                Editable=False }

    { 1120054028;2;Field  ;
                SourceExpr="Payroll/Staff No";
                Editable=False }

    { 1120054029;2;Field  ;
                SourceExpr="ID No.";
                Editable=False }

    { 1120054030;2;Field  ;
                SourceExpr="ID No.2";
                Editable=false }

    { 1120054031;2;Field  ;
                SourceExpr="Payroll/Staff No2";
                Editable=FALSE }

    { 1120054035;2;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1120054036;2;Field  ;
                SourceExpr="Current Shares" }

    { 1120054044;2;Field  ;
                SourceExpr="Net Refund" }

    { 1120054050;2;Field  ;
                SourceExpr="Disbursement Type";
                Editable=fALSE }

    { 1120054051;2;Field  ;
                SourceExpr="Amount to Refund" }

    { 1120054052;2;Field  ;
                SourceExpr="Number of Installments" }

    { 1120054053;2;Field  ;
                SourceExpr="Total Amount Disbursed" }

  }
  CODE
  {

    LOCAL PROCEDURE FnTrancheDisbursement@1120054004(Document@1120054000 : Code[10];DisbursementAmount@1120054004 : Decimal);
    VAR
      MembWith@1120054001 : Record 51516259;
      Entry@1120054002 : Integer;
      PartEntry@1120054003 : Record 51516917;
      CShares@1120054005 : Decimal;
      Memb@1120054006 : Record 51516223;
      Generalsetup@1120054007 : Record 51516257;
      GenJournalLine@1120054008 : Record 81;
      LineNo@1120054009 : Integer;
    BEGIN
      MembWith.RESET;
      MembWith.SETRANGE(MembWith."No.",Document);
      IF MembWith.FINDFIRST THEN BEGIN

      Entry:=1;
      IF PartEntry.FINDLAST THEN
      Entry:=Entry+1
      ELSE
      Entry:=Entry;
      PartEntry.INIT;
      PartEntry."Entry No":=Entry;
      PartEntry."Client Number":=MembWith."Member No.";
      PartEntry."Amount Disbursed":=MembWith."Amount to Refund";
      PartEntry."Date Disbursed":=TODAY;
      PartEntry."Document No":=MembWith."No.";
      PartEntry.INSERT;



      Memb.RESET;
      Memb.SETRANGE(Memb."No.",MembWith."Member No.");
      IF Memb.FINDFIRST THEN BEGIN
      Memb.CALCFIELDS(Memb."Current Savings");
      CShares:=Memb."Current Savings";
      Generalsetup.GET();
      IF DisbursementAmount>CShares THEN
      ERROR('Amount to refund must not be greater than Current Savings of amount %1',CShares);

      //Debit Deposits with Part Amount
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='Closure';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=Memb."No.";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."External Document No.":="Cheque No.";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
      GenJournalLine."Account No.":=MembWith."Member No.";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
      GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
      GenJournalLine.Amount:=DisbursementAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":='';
      GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      // Credit Amount With Deposits
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='Closure';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=Memb."No.";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."External Document No.":="Cheque No.";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":=Memb."FOSA Account";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
      GenJournalLine.Amount:=-DisbursementAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":='';
      GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
      GenJournalLine.SETRANGE("Journal Batch Name",'Closure');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
      END;
      END;
      END;
    END;

    BEGIN
    END.
  }
}

