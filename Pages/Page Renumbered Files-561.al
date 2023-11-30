OBJECT page 172156 Fixed deposit card
{
  OBJECT-PROPERTIES
  {
    Date=05/16/22;
    Time=[ 4:56:08 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516015;
    PageType=Card;
    OnAfterGetCurrRecord=BEGIN
                           FosaTransEnabled:=TRUE;
                           IF Fixed=TRUE THEN
                           FosaTransEnabled:=FALSE;

                           CreditEnabled:=FALSE;
                           IF Fixed=TRUE THEN
                           CreditEnabled:=TRUE;

                           LinesEditable:=TRUE;
                           IF Fixed=TRUE THEN
                           LinesEditable:=FALSE;
                         END;

    ActionList=ACTIONS
    {
      { 1120054035;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054016;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054020;1 ;Action    ;
                      Name=Transfer From FOSA;
                      Promoted=Yes;
                      Enabled=FosaTransEnabled;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //credit savings
                                 IF Credited=TRUE THEN
                                   ERROR('This account has already been credited');
                                 IF CONFIRM('Are you sure you want to tranfer funds from ordinary account?',TRUE,FALSE)=TRUE THEN BEGIN
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                                 GenJournalLine.DELETEALL;

                                 AccP.RESET;
                                 AccP.SETRANGE(AccP."ID No.","ID NO");
                                 AccP.SETFILTER(AccP."Account Type",'FIXED');
                                 IF AccP.FIND('-') THEN BEGIN
                                 fixedno:=AccP."No.";



                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=fixedno;
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Fixed deposit';
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
                                 //IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //END credit fixed deposit


                                 //Debit ordinary
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Account No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine.Description:='Fixed deposit ';
                                 GenJournalLine.Amount:=Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
                                 //IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 //end debit ordinary savings

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
                                 END;

                                 Fixed:=TRUE;
                                 "Fixed Date":=TODAY;
                                 "Fixed By":=USERID;
                                 MODIFY;


                                 //Create Audit Entry
                                 IF Trail.FINDLAST THEN
                                 BEGIN
                                 EntryNo:=Trail."Entry No"+1;
                                 END ELSE BEGIN
                                 EntryNo:=1;
                                 END;
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'FD Fixing',Amount,
                                 'FIXED DEPOSIT',TODAY,TIME,'',"FD No","Account No",'');
                                 //End Create Audit Entry

                                 COMMIT;

                                 FixedR.RESET;
                                 FixedR.SETRANGE(FixedR."FD No","FD No");
                                 IF FixedR.FINDFIRST THEN BEGIN
                                 REPORT.RUN(51516632,TRUE,TRUE,FixedR)
                                 END;
                                 END;
                                 END;
                               END;
                                }
      { 1120054011;1 ;Action    ;
                      Name=Transfer Fixed To FOSA;
                      Promoted=Yes;
                      Enabled=CreditEnabled;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //credit savings
                                 IF Credited=TRUE THEN
                                   ERROR('This account has already been credited');
                                 IF TODAY<MaturityDate THEN
                                 ERROR('This fixed deposit has not matured yet.');
                                 IF CONFIRM('Are you sure you want to tranfer funds to ordinary account?',TRUE,FALSE)=TRUE THEN BEGIN
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                                 GenJournalLine.DELETEALL;

                                 //MESSAGE('amount is %1',Amount);
                                 AccP.RESET;
                                 AccP.SETRANGE(AccP."ID No.","ID NO");
                                 AccP.SETFILTER(AccP."Account Type",'FIXED');
                                 IF AccP.FIND('-') THEN BEGIN
                                 fixedno:=AccP."No.";




                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=fixedno;
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Fixed deposit';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //END credit fixed deposit


                                 //Debit ordinary
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Account No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine.Description:='Fixed deposit ';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Interest Earned
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='400-000-205';
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Fixed deposit';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-"Interest Earned";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;




                                 //Credit
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Account No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine.Description:='Fixed deposit ';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:="Interest Earned";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 //end debit ordinary savings

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
                                 END;
                                 Credited:=TRUE;
                                 "Posted Date":=TODAY;
                                 "Posted By":=USERID;
                                 Posted:=TRUE;
                                 MODIFY;
                                 END;
                                 END;
                               END;
                                }
      { 1120054021;1 ;Action    ;
                      Name=Terminate Fixed Deposit;
                      Promoted=Yes;
                      Enabled=CreditEnabled;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //credit savings
                                 IF Posted=TRUE THEN
                                 ERROR('This account has already been credited');
                                 IF TODAY>=MaturityDate THEN
                                 ERROR('This fixed deposit has already matured.');
                                 IF CONFIRM('Are you sure you want to terminate this fixed deposit?',TRUE,FALSE)=TRUE THEN BEGIN
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                                 GenJournalLine.DELETEALL;

                                 //MESSAGE('amount is %1',Amount);
                                 AccP.RESET;
                                 AccP.SETRANGE(AccP."ID No.","ID NO");
                                 AccP.SETFILTER(AccP."Account Type",'FIXED');
                                 IF AccP.FIND('-') THEN BEGIN
                                 fixedno:=AccP."No.";


                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=fixedno;
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Fixed deposit';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //END credit fixed deposit


                                 //Debit ordinary
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FXDEP';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Account No";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="FD No";
                                 GenJournalLine.Description:='Fixed deposit ';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //end debit ordinary savings

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
                                 END;
                                 Credited:=TRUE;
                                 "Posted Date":=TODAY;
                                 "Posted By":=USERID;
                                 Posted:=TRUE;
                                 MODIFY;
                                 END;
                                 END;
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
                SourceExpr="FD No";
                Editable=false }

    { 1120054003;2;Field  ;
                SourceExpr="Account No";
                Editable=LinesEditable }

    { 1120054004;2;Field  ;
                SourceExpr="Account Name";
                Editable=false }

    { 1120054012;2;Field  ;
                SourceExpr="ID NO";
                Editable=false }

    { 1120054005;2;Field  ;
                SourceExpr="Fd Duration";
                Editable=LinesEditable }

    { 1120054007;2;Field  ;
                SourceExpr=Amount;
                Editable=LinesEditable;
                ShowMandatory=true }

    { 1120054008;2;Field  ;
                SourceExpr=InterestRate }

    { 1120054015;2;Field  ;
                SourceExpr="Interest Earned";
                Editable=False }

    { 1120054017;2;Field  ;
                SourceExpr="Withholding Tax";
                Visible=False }

    { 1120054018;2;Field  ;
                CaptionML=ENU=interest Less Tax;
                SourceExpr=interestLessTax;
                Visible=False }

    { 1120054006;2;Field  ;
                SourceExpr="Amount After maturity";
                Editable=false }

    { 1120054009;2;Field  ;
                CaptionML=ENU=Created by;
                SourceExpr="Creted by";
                Editable=false }

    { 1120054010;2;Field  ;
                CaptionML=ENU=Fixing Date;
                SourceExpr=Date;
                Editable=false }

    { 1120054019;2;Field  ;
                SourceExpr=MaturityDate;
                Editable=false }

    { 1120054013;2;Field  ;
                SourceExpr=Fixed;
                Editable=false }

    { 1120054022;2;Field  ;
                SourceExpr="Fixed By" }

    { 1120054014;2;Field  ;
                SourceExpr="Fixed Date" }

  }
  CODE
  {
    VAR
      LoanBalance@1120054100 : Decimal;
      AvailableBalance@1120054099 : Decimal;
      UnClearedBalance@1120054098 : Decimal;
      LoanSecurity@1120054097 : Decimal;
      LoanGuaranteed@1120054096 : Decimal;
      GenJournalLine@1120054095 : Record 81;
      DefaultBatch@1120054094 : Record 232;
      GLPosting@1120054093 : Codeunit 12;
      window@1120054092 : Dialog;
      Account@1120054091 : Record 23;
      TransactionTypes@1120054090 : Record 51516298;
      TransactionCharges@1120054089 : Record 51516300;
      TCharges@1120054088 : Decimal;
      LineNo@1120054087 : Integer;
      AccountTypes@1120054086 : Record 51516295;
      GenLedgerSetup@1120054085 : Record 98;
      MinAccBal@1120054084 : Decimal;
      FeeBelowMinBal@1120054083 : Decimal;
      AccountNo@1120054082 : Code[30];
      NewAccount@1120054081 : Boolean;
      CurrentTellerAmount@1120054080 : Decimal;
      TellerTill@1120054079 : Record 270;
      IntervalPenalty@1120054078 : Decimal;
      StandingOrders@1120054077 : Record 51516307;
      AccountAmount@1120054076 : Decimal;
      STODeduction@1120054075 : Decimal;
      Charges@1120054074 : Record 51516297;
      "Total Deductions"@1120054073 : Decimal;
      STODeductedAmount@1120054072 : Decimal;
      NoticeAmount@1120054071 : Decimal;
      AccountNotices@1120054070 : Record 51516296;
      Cust@1120054069 : Record 51516223;
      AccountHolders@1120054068 : Record 23;
      ChargesOnFD@1120054067 : Decimal;
      TotalGuaranted@1120054066 : Decimal;
      VarAmtHolder@1120054065 : Decimal;
      chqtransactions@1120054064 : Record 51516299;
      Trans@1120054063 : Record 51516299;
      TotalUnprocessed@1120054062 : Decimal;
      CustAcc@1120054061 : Record 51516223;
      AmtAfterWithdrawal@1120054060 : Decimal;
      TransactionsRec@1120054059 : Record 51516299;
      LoansTotal@1120054058 : Decimal;
      Interest@1120054057 : Decimal;
      InterestRate@1120054056 : Decimal;
      OBal@1120054055 : Decimal;
      Principal@1120054054 : Decimal;
      ATMTrans@1120054053 : Decimal;
      ATMBalance@1120054052 : Decimal;
      TotalBal@1120054051 : Decimal;
      DenominationsRec@1120054050 : Record 51516303;
      TillNo@1120054049 : Code[20];
      FOSASetup@1120054048 : Record 312;
      Acc@1120054047 : Record 23;
      ChequeTypes@1120054046 : Record 51516304;
      ChargeAmount@1120054045 : Decimal;
      TChargeAmount@1120054044 : Decimal;
      DActivity@1120054043 : Code[20];
      DBranch@1120054042 : Code[20];
      UsersID@1120054041 : Record 2000000120;
      ChBank@1120054040 : Code[20];
      DValue@1120054039 : Record 349;
      ReceiptAllocations@1120054038 : Record 51516246;
      Loans@1120054037 : Record 51516230;
      Commision@1120054036 : Decimal;
      Cheque@1120054035 : Boolean;
      LOustanding@1120054034 : Decimal;
      TotalCommision@1120054033 : Decimal;
      TotalOustanding@1120054032 : Decimal;
      BOSABank@1120054031 : Code[20];
      InterestPaid@1120054030 : Decimal;
      PaymentAmount@1120054029 : Decimal;
      RunBal@1120054028 : Decimal;
      Recover@1120054027 : Boolean;
      genSetup@1120054026 : Record 51516257;
      MailContent@1120054025 : Text[150];
      supervisor@1120054024 : Record 51516309;
      AccP@1120054023 : Record 23;
      LoansR@1120054022 : Record 51516230;
      ClearingCharge@1120054021 : Decimal;
      ClearingRate@1120054020 : Decimal;
      FChequeVisible@1120054019 : Boolean INDATASET;
      BChequeVisible@1120054018 : Boolean INDATASET;
      BReceiptVisible@1120054017 : Boolean INDATASET;
      BOSAReceiptChequeVisible@1120054016 : Boolean INDATASET;
      "Branch RefferenceVisible"@1120054015 : Boolean INDATASET;
      LRefVisible@1120054014 : Boolean INDATASET;
      "Transaction DateEditable"@1120054013 : Boolean INDATASET;
      Excise@1120054012 : Decimal;
      Echarge@1120054011 : Decimal;
      BankLedger@1120054010 : Record 271;
      SMSMessage@1120054009 : Record 51516329;
      iEntryNo@1120054008 : Integer;
      Vend1@1120054007 : Record 23;
      TransDesc@1120054006 : Text;
      TransTypes@1120054005 : Record 51516298;
      ObjTransactionCharges@1120054004 : Record 51516300;
      AccountBalance@1120054003 : Decimal;
      MinimumBalance@1120054002 : Decimal;
      TransactionAmount@1120054001 : Decimal;
      WithCharges@1120054000 : Decimal;
      fixedno@1120054101 : Code[30];
      fixeddeposit@1120054102 : Record 51516015;
      FosaTransEnabled@1120054103 : Boolean;
      CreditEnabled@1120054104 : Boolean;
      LinesEditable@1120054105 : Boolean;
      FixedR@1120054106 : Record 51516015;
      AuditTrail@1120054109 : Codeunit 51516107;
      Trail@1120054108 : Record 51516655;
      EntryNo@1120054107 : Integer;

    BEGIN
    END.
  }
}

