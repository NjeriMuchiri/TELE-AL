OBJECT page 172155 Fixed deposit list
{
  OBJECT-PROPERTIES
  {
    Date=08/20/20;
    Time=[ 3:21:14 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516015;
    SourceTableView=WHERE(Fixed=FILTER(No));
    PageType=List;
    CardPageID=Fixed deposit card;
    ActionList=ACTIONS
    {
      { 1120054020;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054017;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054016;1 ;Action    ;
                      Name=[Credit fixed deposit ];
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //credit savings

                                 IF Credited=TRUE THEN
                                   ERROR('This account has already been credited');

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 //MESSAGE('amount is %1',Amount);
                                 AccP.RESET;
                                 AccP.SETRANGE(AccP."ID No.","ID NO");
                                 IF AccP.FIND('-') THEN
                                   REPEAT

                                  IF AccP."Vendor Posting Group"='FIXED' THEN
                                 fixedno:=AccP."No.";
                                 // IF fixedno='' THEN
                                  //ERROR('open a fixed deposit account');
                                 MESSAGE('debit fixed deposit %1',fixedno);

                                 UNTIL AccP.NEXT=0;

                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=fixedno;
                                 GenJournalLine."Document No.":='fixed deposit';
                                 //IF "Account No"='00-0000000000' THEN
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Fixed deposit ';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 //GenJournalLine."Bal. Account No.":=fixedno;
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 //IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //END credit fixed deposit


                                 //Debit ordinary
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Account No";
                                 GenJournalLine."Document No.":=Acc.Name;
                                 //IF "Account No"='00-0000000000' THEN
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":='fixed deposit';
                                 GenJournalLine.Description:='Fixed deposit ';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 //GenJournalLine."Bal. Account No.":=fixedno;
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 //IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 //end debit ordinary savings

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
                                 END;
                                 Credited:=TRUE;
                                 MODIFY;
                                 //END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="FD No" }

    { 1120054003;2;Field  ;
                SourceExpr="Account No" }

    { 1120054004;2;Field  ;
                SourceExpr="Account Name" }

    { 1120054005;2;Field  ;
                SourceExpr="Fd Duration" }

    { 1120054007;2;Field  ;
                SourceExpr=Amount }

    { 1120054008;2;Field  ;
                SourceExpr=InterestRate }

    { 1120054006;2;Field  ;
                SourceExpr="ID NO";
                Editable=false }

    { 1120054009;2;Field  ;
                SourceExpr="Creted by" }

    { 1120054010;2;Field  ;
                CaptionML=ENU=<interest Less Tax>;
                SourceExpr=interestLessTax }

    { 1120054011;2;Field  ;
                SourceExpr="Amount After maturity" }

    { 1120054012;2;Field  ;
                SourceExpr=Date }

    { 1120054013;2;Field  ;
                SourceExpr=MaturityDate }

    { 1120054015;2;Field  ;
                SourceExpr=matured }

  }
  CODE
  {
    VAR
      GenJournalLine@1120054097 : Record 81;
      TCharges@1120054090 : Decimal;
      LineNo@1120054089 : Integer;
      AccountTypes@1120054088 : Record 51516295;
      chqtransactions@1120054066 : Record 51516299;
      Trans@1120054065 : Record 51516299;
      TotalUnprocessed@1120054064 : Decimal;
      CustAcc@1120054063 : Record 51516223;
      AmtAfterWithdrawal@1120054062 : Decimal;
      TransactionsRec@1120054061 : Record 51516299;
      LoansTotal@1120054060 : Decimal;
      Interest@1120054059 : Decimal;
      InterestRate@1120054058 : Decimal;
      OBal@1120054057 : Decimal;
      Principal@1120054056 : Decimal;
      ATMTrans@1120054055 : Decimal;
      ATMBalance@1120054054 : Decimal;
      TotalBal@1120054053 : Decimal;
      DenominationsRec@1120054052 : Record 51516303;
      TillNo@1120054051 : Code[20];
      FOSASetup@1120054050 : Record 312;
      Acc@1120054049 : Record 23;
      DValue@1120054041 : Record 349;
      AccP@1120054025 : Record 23;
      LoansR@1120054024 : Record 51516230;
      "Transaction DateEditable"@1120054015 : Boolean INDATASET;
      Excise@1120054014 : Decimal;
      Echarge@1120054013 : Decimal;
      BankLedger@1120054012 : Record 271;
      SMSMessage@1120054011 : Record 51516329;
      iEntryNo@1120054010 : Integer;
      Vend1@1120054009 : Record 23;
      TransDesc@1120054008 : Text;
      TransTypes@1120054007 : Record 51516298;
      fixedno@1120054001 : Code[30];
      fixeddeposit@1120054000 : Record 51516015;
      DActivity@1120054002 : Code[30];
      DBranch@1120054003 : Code[30];

    BEGIN
    END.
  }
}

