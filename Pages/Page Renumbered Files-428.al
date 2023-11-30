OBJECT page 172023 Posted Guar Recovery Header
{
  OBJECT-PROPERTIES
  {
    Date=06/13/18;
    Time=[ 3:52:29 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516550;
    PageType=Card;
    OnOpenPage=BEGIN
                 //UpdateControls();
               END;

    OnNewRecord=BEGIN
                  "Created By":=USERID;
                  "Application Date":=TODAY;
                END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateControls();
                           UpdateControls();
                           EnableCreateMember:=FALSE;
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
                           EnabledApprovalWorkflowsExist :=TRUE;
                           IF Rec.Status=Status::Approved THEN BEGIN
                             OpenApprovalEntriesExist:=FALSE;
                             CanCancelApprovalForRecord:=FALSE;
                             EnabledApprovalWorkflowsExist:=FALSE;
                             END;
                             IF (Rec.Status=Status::Approved) THEN
                               EnableCreateMember:=TRUE;
                         END;

    ActionList=ACTIONS
    {
      { 1000000011;  ;ActionContainer;
                      CaptionML=ENU=Root;
                      ActionContainerType=NewDocumentItems }
      { 1000000019;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1000000018;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::GuarantorRecovery;

                                 ApprovalEntries.Setfilters(DATABASE::"Guarantors Recovery Header",DocumentType,"Document No");
                                 ApprovalEntries.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000002;2;Field  ;
                SourceExpr="Document No";
                Editable=FALSE }

    { 1000000003;2;Field  ;
                SourceExpr="Member No";
                Editable=MemberNoEditable }

    { 1000000004;2;Field  ;
                SourceExpr="Member Name";
                Importance=Promoted;
                Editable=FALSE }

    { 1000000008;2;Field  ;
                CaptionML=ENU=Member Deposits;
                SourceExpr="Current Shares";
                Importance=Promoted;
                Editable=FALSE;
                Style=Favorable;
                StyleExpr=TRUE }

    { 1000000037;2;Field  ;
                SourceExpr="Total Outstanding Loans";
                Editable=false;
                Style=Unfavorable;
                StyleExpr=TRUE }

    { 1000000031;2;Field  ;
                CaptionML=ENU=Transaction Date;
                SourceExpr="Loan Disbursement Date";
                Editable=true }

    { 1000000024;2;Field  ;
                SourceExpr="Loan to Attach";
                Editable=LoantoAttachEditable }

    { 1000000023;2;Field  ;
                CaptionML=ENU=Outstanding Balance;
                SourceExpr="Loan Liabilities";
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000028;2;Field  ;
                Name=Interest Repayment;
                CaptionML=ENU=Interest Repayment;
                SourceExpr="Interest Repayment";
                Visible=FALSE;
                Enabled=FALSE;
                Editable=FALSE;
                HideValue=TRUE }

    { 1000000029;2;Field  ;
                Name=Principal Repayment;
                CaptionML=ENU=Principal Repayment;
                SourceExpr="Principal Repayment";
                Visible=FALSE;
                Enabled=FALSE;
                Editable=FALSE;
                HideValue=TRUE }

    { 1000000025;2;Field  ;
                SourceExpr="Total Interest Due Recovered";
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000026;2;Field  ;
                SourceExpr="Total Thirdparty Loans";
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000036;2;Field  ;
                SourceExpr="Mobile Loan";
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000034;2;Field  ;
                ToolTipML=[ENU=(Outstanding Balance/Total Loans Outstanding Balance)*(Deposits-(Total Accrued Interest+Thirdparty Loans+Mobile Loan));
                           ENG=(Outstanding Balance/Total Loans Outstanding Balance)*(Deposits-(Total Accrued Interest+Thirdparty Loans+Mobile Loan))];
                SourceExpr="Deposits Aportioned";
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000035;2;Field  ;
                SourceExpr="Loan Distributed to Guarantors";
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000010;2;Field  ;
                SourceExpr="FOSA Account No";
                Editable=FALSE }

    { 1000000027;2;Field  ;
                Name=Recovery Difference;
                CaptionML=ENU=Recovery Difference;
                SourceExpr="Recovery Difference";
                Visible=FALSE;
                Enabled=FALSE;
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr="Recovery Type";
                Editable=RecoveryTypeEditable }

    { 1000000020;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1000000021;2;Field  ;
                Name=Activity Code;
                OptionCaptionML=ENU=Activity;
                SourceExpr="Global Dimension 1 Code";
                Editable=Global1Editable }

    { 1000000014;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Editable=false }

    { 1000000022;2;Field  ;
                SourceExpr="Created By";
                Editable=FALSE }

    { 1000000005;2;Field  ;
                CaptionML=ENU=Date Created;
                SourceExpr="Application Date";
                Editable=FALSE }

    { 1000000015;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1000000033;2;Field  ;
                SourceExpr="Loans Generated";
                Editable=FALSE }

    { 1000000016;2;Field  ;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 1000000032;2;Field  ;
                SourceExpr="Repayment Start Date";
                Editable=FALSE }

    { 1000000017;2;Field  ;
                SourceExpr="Posted By";
                Editable=FALSE }

    { 1000000009;1;Part   ;
                SubPageLink=Document No=FIELD(Document No), Member No=FIELD(Member No);
                PagePartID=Page51516617;
                Visible=TRUE;
                Enabled=TRUE;
                Editable=GuarantorLoansDetailsEdit;
                PartType=Page }

  }
  CODE
  {
    VAR
      Text0001@1000000035 : TextConst 'ENU=Please consider recovering from the Loanee Shares Before Attaching to Guarantors';

    PROCEDURE UpdateControls@1102755003();
    BEGIN

           IF Status=Status::Open THEN BEGIN
           MemberNoEditable:=TRUE;
           RecoveryTypeEditable:=TRUE;
           LoantoAttachEditable:=TRUE;
           Global1Editable:=TRUE;
           Global2Editable:=TRUE;
           GuarantorLoansDetailsEdit:=TRUE;
           END;
           IF Status=Status::Pending THEN BEGIN
           MemberNoEditable:=FALSE;
           RecoveryTypeEditable:=FALSE;
           LoantoAttachEditable:=FALSE;
           Global1Editable:=FALSE;
           Global2Editable:=FALSE;
           GuarantorLoansDetailsEdit:=TRUE;
           END;
           IF Status=Status::Approved THEN BEGIN
           MemberNoEditable:=FALSE;
           RecoveryTypeEditable:=FALSE;
           LoantoAttachEditable:=FALSE;
           Global1Editable:=FALSE;
           Global2Editable:=FALSE;
           GuarantorLoansDetailsEdit:=TRUE;
           END
    END;

    LOCAL PROCEDURE FnGetDefaultorLoanAmount@1000000014(OutstandingBalance@1000000000 : Decimal;GuaranteedAmount@1000000001 : Decimal;TotalGuaranteedAmount@1000000002 : Decimal;GuarantorCount@1000000003 : Integer) : Decimal;
    BEGIN
      EXIT(OutstandingBalance/GuarantorCount);
      //EXIT(ROUND(GuaranteedAmount/TotalGuaranteedAmount*("Loan Liabilities"),0.05,'>'));
    END;

    PROCEDURE FnPostRepaymentJournal@1000000020(TDefaulterLoan@1000000002 : Decimal);
    VAR
      ObjLoanDetails@1000000000 : Record 51516551;
    BEGIN
      IF LoansRec.GET("Loan to Attach") THEN BEGIN
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Loan Repayment",
        GenJournalLine."Account Type"::Member,LoansRec."Client Code","Loan Disbursement Date",TDefaulterLoan*-1,FORMAT(LoanApps.Source),EXTERNAL_DOC_NO,
        'Defaulted Loan Recovered-'+"Loan to Attach","Loan to Attach");
      END;
    END;

    LOCAL PROCEDURE FnGetInterestForLoanToAttach@1000000046() : Decimal;
    VAR
      ObjLoansRegisterLocal@1000000000 : Record 51516371;
    BEGIN
      ObjLoansRegisterLocal.RESET;
      ObjLoansRegisterLocal.SETRANGE(ObjLoansRegisterLocal."Loan  No.","Loan to Attach");
      IF ObjLoansRegisterLocal.FIND('-') THEN BEGIN
        ObjLoansRegisterLocal.CALCFIELDS(ObjLoansRegisterLocal."Oustanding Interest");
         EXIT(ObjLoansRegisterLocal."Oustanding Interest");
        END;
    END;

    LOCAL PROCEDURE FnRecoverFromGuarantorDeposits@1000000003();
    BEGIN
      IF CONFIRM('Are you absolutely sure you want to recover the loans from guarantors deposits') = FALSE THEN
      EXIT;
      TotalRecovered:=0;
      TotalInsuarance:=0;
      DActivity:="Global Dimension 1 Code";
      DBranch:="Global Dimension 2 Code";

      IF ObjGuarantorML."Guarantors Free Shares" <= "Loan Liabilities" THEN BEGIN
      AmounttoRecover:=ObjGuarantorML."Guarantors Free Shares"-"Loan Liabilities";
      IF ObjGuarantorML."Guarantors Free Shares" < "Loan Liabilities" THEN BEGIN
      AmounttoRecover:=ObjGuarantorML."Guarantors Free Shares";
      BaltoRecover:="Loan Liabilities"-ObjGuarantorML."Guarantors Free Shares";
      //X:="Recovery Difference";





      ClosingDepositBalance:=(ObjGuarantorML."Guarantors Free Shares");
      IF ClosingDepositBalance > 0 THEN BEGIN
       RemainingAmount:=ClosingDepositBalance;

      LoanGuarantors.RESET;
      LoanGuarantors.SETRANGE(LoanGuarantors."Loan No","Member No");


      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Client Code","Member No");
      LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
      IF LoansR.FIND('-') THEN BEGIN
      REPEAT
      AMOUNTTOBERECOVERED:=0;
      LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
      TotalInsuarance:=TotalInsuarance+LoansR."Loans Insurance";
      UNTIL LoansR.NEXT=0;
      END;
      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Client Code","Member No");
      //LoansR.SETRANGE(LoansR.Source,LoansR.Source::FOSA);
      IF LoansR.FIND('-') THEN BEGIN
      REPEAT
      AMOUNTTOBERECOVERED:=0;
      LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
      InstRecoveredAmount:=LoansR."Outstanding Balance"+LoansR."Oustanding Interest";
      IF InstRecoveredAmount > ObjGuarantorML."Guarantors Free Shares" THEN
      ClosingDepositBalance:=0;
      IF InstRecoveredAmount < ObjGuarantorML."Guarantors Free Shares" THEN
      ClosingDepositBalance:= (ObjGuarantorML."Guarantors Free Shares"-InstRecoveredAmount);
      X:=(ObjGuarantorML."Guarantors Free Shares"-LoansR."Oustanding Interest");

      //Off Set BOSA Loans
      //Interest
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='RECOVERIES';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":="Document No";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."External Document No.":="Document No";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
      GenJournalLine."Account No.":="Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Interest Recovered From Guarantor Deposits: ' + "Document No";
      GenJournalLine.Amount:=-ROUND(LoansR."Oustanding Interest");
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Insurance Contribution";
      GenJournalLine."Loan No":=LoansR."Loan  No.";
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='RECOVERIES';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":="Document No";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."External Document No.":="Document No";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
      GenJournalLine."Account No.":="Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Interest Recovered From Guarantor Deposits: ' + "Document No";
      GenJournalLine.Amount:=ROUND(LoansR."Oustanding Interest");
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Share Capital";
      GenJournalLine."Loan No":=LoansR."Loan  No.";
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      PrincipInt:=0;
      TotalLoansOut:=0;

      ClosingDepositBalance:=(ObjGuarantorML."Guarantors Free Shares");

      IF RemainingAmount > 0 THEN BEGIN
      PrincipInt:=(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
      TotalLoansOut:=(GLoanDetails."Outstanding Balance"+GLoanDetails."Outstanding Interest");

      //Principle
      LineNo:=LineNo+10000;
      //AMOUNTTOBERECOVERED:=ROUND(((LoansR."Outstanding Balance"+LoansR."Oustanding Interest")/("Outstanding Balance"+"Outstanding Interest")))*ClosingDepositBalance;
      AMOUNTTOBERECOVERED:=ROUND((PrincipInt/"Loan Liabilities")*ClosingDepositBalance,0.01,'=');
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='RECOVERIES';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":="Document No";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."External Document No.":="Document No";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
      GenJournalLine."Account No.":="Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Loan Against Deposits: ' + "Document No";
      IF AMOUNTTOBERECOVERED > (LoansR."Outstanding Balance"+LoansR."Oustanding Interest") THEN BEGIN
      IF RemainingAmount > (LoansR."Outstanding Balance"+LoansR."Oustanding Interest") THEN BEGIN
      GenJournalLine.Amount:=-ROUND(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
      END ELSE BEGIN
      GenJournalLine.Amount:=-(RemainingAmount-LoansR."Oustanding Interest");
      END;

      END ELSE BEGIN
      IF RemainingAmount > AMOUNTTOBERECOVERED THEN BEGIN
      GenJournalLine.Amount:=-AMOUNTTOBERECOVERED;
      END ELSE BEGIN
      GenJournalLine.Amount:=-(RemainingAmount-LoansR."Oustanding Interest");
      END;
      END;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
      GenJournalLine."Loan No":=LoansR."Loan  No.";
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      RemainingAmount:=RemainingAmount+GenJournalLine.Amount;

      TotalRecovered:=TotalRecovered+((GenJournalLine.Amount));
      END;




      UNTIL LoansR.NEXT = 0;
      END;
      END;
      //Deposit
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='RECOVERIES';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":="Document No";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."External Document No.":="Document No";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
      GenJournalLine."Account No.":="Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Defaulted Loans Against Deposits';
      GenJournalLine.Amount:=(TotalRecovered)*-1;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
      GenJournalLine."Loan No":=LoansR."Loan  No.";
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      Posted:=TRUE;
      IF Cust.GET("Member No") THEN BEGIN
      Cust."Defaulted Loans Recovered":=TRUE;
      Cust.MODIFY;
      END;

      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
      GenJournalLine.SETRANGE("Journal Batch Name",'Recoveries');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
      END;

      END;
      END;
    END;

    LOCAL PROCEDURE FnRecoverFromLoaneesDeposits@1000000009();
    BEGIN
            RunBal:=0;
            TotalSharesUsed:=0;
            RunBal:="Free Shares";
            //RunBal:=FnRunInterest("Loan to Attach",RunBal);
           // RunBal:=FnRunPrinciple("Loan to Attach",RunBal);

            //Deposit
            LineN:=LineN+10000;
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name":='GENERAL';
            GenJournalLine."Journal Batch Name":='RECOVERIES';
            GenJournalLine."Line No.":=LineN;
            GenJournalLine."Document No.":="Document No";
            GenJournalLine."Posting Date":=TODAY;
            GenJournalLine."External Document No.":="Document No";
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
            GenJournalLine."Account No.":="Member No";
            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
            GenJournalLine.Description:='Defaulted Loans Against Deposits';
            GenJournalLine.Amount:=TotalSharesUsed;
            GenJournalLine.VALIDATE(GenJournalLine.Amount);
            GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
            GenJournalLine."Loan No":=LoansR."Loan  No.";
            GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
            GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
            GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
            IF GenJournalLine.Amount<>0 THEN
            GenJournalLine.INSERT;
    END;

    LOCAL PROCEDURE FnRunInterest@1000000011(RunningBalance@1000000001 : Decimal);
    VAR
      AmountToDeduct@1000000002 : Decimal;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE("BOSA No","Member No");
      LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      IF LoanApp.FIND('-') THEN
        BEGIN
          REPEAT
              IF  RunningBalance > 0 THEN
                BEGIN
                  AmountToDeduct:=0;
                  AmountToDeduct:=FnCalculateTotalInterestDue(LoanApp);
                  IF RunningBalance <= AmountToDeduct THEN
                  AmountToDeduct:=RunningBalance;

                  LineNo:=LineNo+10000;
                  SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                  GenJournalLine."Account Type"::Member,LoanApp."Client Code","Loan Disbursement Date",AmountToDeduct*-1,FORMAT(LoanApp.Source),EXTERNAL_DOC_NO,
                  FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),LoanApp."Loan  No.");
                  RunningBalance:=RunningBalance-AmountToDeduct;
              END;
      UNTIL LoanApp.NEXT = 0;
      LineNo:=LineNo+10000;
      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Deposit Contribution",
      GenJournalLine."Account Type"::Member,"Member No","Loan Disbursement Date","Total Interest Due Recovered",'BOSA',EXTERNAL_DOC_NO,
      FORMAT(GenJournalLine."Transaction Type"::"Deposit Contribution")+'-'+LoanApp."Loan Product Type",'');
      END;
      END;
    END;

    LOCAL PROCEDURE FnRunPrinciple@1000000013(RunningBalance@1000000001 : Decimal);
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
    BEGIN
         BEGIN
          IF LoansRec.GET("Loan to Attach") THEN BEGIN
            //---------------------PAY-------------------------------
            LineNo:=LineNo+10000;
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Loan Repayment",
            GenJournalLine."Account Type"::Member,LoansRec."Client Code","Loan Disbursement Date","Deposits Aportioned"*-1,FORMAT(LoansRec.Source),EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::"Loan Repayment"),"Loan to Attach");
            //--------------------RECOVER-----------------------------
            LineNo:=LineNo+10000;
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Deposit Contribution",
            GenJournalLine."Account Type"::Member,"Member No","Loan Disbursement Date","Deposits Aportioned",FORMAT(LoansRec.Source),EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::"Deposit Contribution")+'-'+LoansRec."Loan Product Type",'');
            END;
          END;
    END;

    LOCAL PROCEDURE FnLoansGenerated@1000000008();
    BEGIN
    END;

    LOCAL PROCEDURE FnDefaulterLoansDisbursement@1000000015(ObjLoanDetails@1000000001 : Record 51516551;LineNo@1000000003 : Integer) : Code[40];
    VAR
      GenJournalLine@1000000000 : Record 81;
      CUNoSeriesManagement@1000000002 : Codeunit 396;
      DocNumber@1000000004 : Code[100];
      loanTypes@1000000005 : Record 51516381;
      ObjLoanX@1000000006 : Record 51516371;
    BEGIN
        loanTypes.RESET;
        loanTypes.SETRANGE(loanTypes.Code,'GUR');
        IF loanTypes.FIND('-') THEN
          BEGIN
            DocNumber:=CUNoSeriesManagement.GetNextNo('LOANSB',0D,TRUE);
            LoansRec.INIT;
            LoansRec."Loan  No.":=DocNumber;
            LoansRec.INSERT;

            IF LoansRec.GET(LoansRec."Loan  No.") THEN BEGIN
            LoansRec."Client Code":=ObjLoanDetails."Guarantor Number";
            LoansRec.VALIDATE(LoansRec."Client Code");
            LoansRec."Loan Product Type":='GUR';
            LoansRec.VALIDATE(LoansRec."Loan Product Type");
            LoansRec.Interest:=ObjLoanDetails."Interest Rate";
            LoansRec."Loan Status":=LoansRec."Loan Status"::Issued;
            LoansRec."Application Date":="Loan Disbursement Date";
            LoansRec."Issued Date":="Loan Disbursement Date";
            LoansRec."Loan Disbursement Date":="Loan Disbursement Date";
            LoansRec."Expected Date of Completion":="Expected Date of Completion";
            LoansRec.VALIDATE(LoansRec."Loan Disbursement Date");
            LoansRec."Mode of Disbursement":=LoansRec."Mode of Disbursement"::"Bank Transfer";
            LoansRec."Repayment Start Date":="Repayment Start Date";
            LoansRec."Global Dimension 1 Code":=FORMAT(LoanApps.Source);
            LoansRec."Global Dimension 2 Code":=SFactory.FnGetUserBranch();
            LoansRec.Source:=LoansRec.Source::BOSA;
            LoansRec."Approval Status":=LoansRec."Approval Status"::Approved;
            LoansRec.Repayment:=ObjLoanDetails."Approved Loan Amount";
            LoansRec."Requested Amount":=0;
            LoansRec."Approved Amount":=ObjLoanDetails."Approved Loan Amount";
            LoansRec."Mode of Disbursement":=LoansRec."Mode of Disbursement"::"Bank Transfer";
            LoansRec.Posted:=TRUE;
            LoansRec."Advice Date":=TODAY;
            LoansRec.MODIFY;
            END;
         END;
         EXIT(DocNumber);
    END;

    LOCAL PROCEDURE FnGenerateRepaymentSchedule@1000000010(LoanNumber@1000000000 : Code[50]);
    BEGIN
      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Loan  No.",LoansRec."Loan  No.");
      LoansR.SETFILTER(LoansR."Approved Amount",'>%1',0);
      LoansR.SETFILTER(LoansR.Posted,'=%1',TRUE);
      IF LoansR.FIND('-') THEN BEGIN
        IF ((LoansR."Loan Product Type"='GUR') AND (LoansR."Issued Date"<>0D) AND (LoansR."Repayment Start Date"<>0D)) THEN BEGIN
      LoansRec.TESTFIELD(LoansRec."Loan Disbursement Date");
      LoansRec.TESTFIELD(LoansRec."Repayment Start Date");

      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",LoansR."Loan  No.");
      RSchedule.DELETEALL;

      LoanAmount:=LoansR."Approved Amount";
      InterestRate:=LoansR.Interest;
      RepayPeriod:=LoansR.Installments;
      InitialInstal:=LoansR.Installments+LoansRec."Grace Period - Principle (M)";
      LBalance:=LoansR."Approved Amount";
      RunDate:="Repayment Start Date";
      InstalNo:=0;

      //Repayment Frequency
      IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('-1D',RunDate)
      ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('-1W',RunDate)
      ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('-1M',RunDate)
      ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('-1Q',RunDate);
      //Repayment Frequency


      REPEAT
      InstalNo:=InstalNo+1;
      //Repayment Frequency
      IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('1D',RunDate)
      ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('1W',RunDate)
      ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('1M',RunDate)
      ELSE IF LoansRec."Repayment Frequency"=LoansRec."Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('1Q',RunDate);

      IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Amortised THEN BEGIN
      //LoansRec.TESTFIELD(LoansRec.Interest);
      LoansRec.TESTFIELD(LoansRec.Installments);
      TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.0001,'>');
      LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.0001,'>');
      LPrincipal:=TotalMRepay-LInterest;
      END;

      IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Straight Line" THEN BEGIN
      LoansRec.TESTFIELD(LoansRec.Interest);
      LoansRec.TESTFIELD(LoansRec.Installments);
      LPrincipal:=LoanAmount/RepayPeriod;
      LInterest:=(InterestRate/12/100)*LoanAmount/RepayPeriod;
      END;

      IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::"Reducing Balance" THEN BEGIN
      LoansRec.TESTFIELD(LoansRec.Interest);
      LoansRec.TESTFIELD(LoansRec.Installments);
      LPrincipal:=LoanAmount/RepayPeriod;
      LInterest:=(InterestRate/12/100)*LBalance;
      END;

      IF LoansRec."Repayment Method"=LoansRec."Repayment Method"::Constants THEN BEGIN
      LoansRec.TESTFIELD(LoansRec.Repayment);
      IF LBalance < LoansRec.Repayment THEN
      LPrincipal:=LBalance
      ELSE
      LPrincipal:=LoansRec.Repayment;
      LInterest:=LoansRec.Interest;
      END;

      //Grace Period
      IF GrPrinciple > 0 THEN BEGIN
      LPrincipal:=0
      END ELSE BEGIN
      LBalance:=LBalance-LPrincipal;

      END;

      IF GrInterest > 0 THEN
      LInterest:=0;

      GrPrinciple:=GrPrinciple-1;
      GrInterest:=GrInterest-1;
      EVALUATE(RepayCode,FORMAT(InstalNo));


      RSchedule.INIT;
      RSchedule."Repayment Code":=RepayCode;
      RSchedule."Interest Rate":=InterestRate;
      RSchedule."Loan No.":=LoansRec."Loan  No.";
      RSchedule."Loan Amount":=LoanAmount;
      RSchedule."Instalment No":=InstalNo;
      RSchedule."Repayment Date":=RunDate;
      RSchedule."Member No.":=LoansRec."Client Code";
      RSchedule."Loan Category":=LoansRec."Loan Product Type";
      RSchedule."Monthly Repayment":=LInterest + LPrincipal;
      RSchedule."Monthly Interest":=LInterest;
      RSchedule."Principal Repayment":=LPrincipal;
      RSchedule.INSERT;
      WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
      UNTIL LBalance < 1

      END;
      END;

      COMMIT;
    END;

    LOCAL PROCEDURE FnRecoverMobileLoanPrincipal@1000000012(RunningBalance@1000000001 : Decimal);
    VAR
      AmountToDeduct@1000000002 : Decimal;
      varLRepayment@1000000003 : Decimal;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."BOSA No","Member No");
      LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      LoanApp.SETFILTER(Source,FORMAT(LoanApp.Source::FOSA));
      LoanApp.SETFILTER("Loan Product Type",'MSADV');
      LoanApp.SETFILTER(Posted,'Yes');
      IF LoanApp.FIND('-') THEN
         BEGIN
            //---------------------PAY-------------------------------
            LineNo:=LineNo+10000;
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Loan Repayment",
            GenJournalLine."Account Type"::Member,LoanApp."Client Code","Loan Disbursement Date","Mobile Loan"*-1,'FOSA',EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::"Loan Repayment"),LoanApp."Loan  No.");
            //--------------------RECOVER-----------------------------
            LineNo:=LineNo+10000;
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Deposit Contribution",
            GenJournalLine."Account Type"::Member,"Member No","Loan Disbursement Date","Mobile Loan",'BOSA',EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::"Deposit Contribution")+'-'+LoanApp."Loan Product Type",LoanApp."Loan  No.");
          END;
      END;
    END;

    LOCAL PROCEDURE FnRunPrincipleThirdparty@1000000001(RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjReceiptTransactions@1000000003 : Record 51516387;
      varTotalRepay@1000000004 : Decimal;
      varMultipleLoan@1000000005 : Decimal;
      varLRepayment@1000000006 : Decimal;
      PRpayment@1000000007 : Decimal;
      ReceiptLine@1000000008 : Record 51516415;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      varTotalRepay:=0;
      varMultipleLoan:=0;
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Client Code","Member No");
      LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      LoanApp.SETFILTER(LoanApp."Loan Product Type",'GUR');
      IF LoanApp.FIND('-') THEN BEGIN
        REPEAT
          IF  RunningBalance > 0 THEN
            BEGIN
              LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
              IF LoanApp."Outstanding Balance" > 0 THEN
                BEGIN
                  varLRepayment:=0;
                  PRpayment:=0;
                  varLRepayment:=LoanApp."Outstanding Balance";
                  IF varLRepayment >0 THEN
                    BEGIN
                       IF RunningBalance > 0 THEN
                        BEGIN
                          IF RunningBalance > varLRepayment THEN
                            BEGIN
                                AmountToDeduct:=varLRepayment;
                              END
                          ELSE
                                AmountToDeduct:=RunningBalance;
                          END;
                          LineNo:=LineNo+10000;
                          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Loan Repayment",
                          GenJournalLine."Account Type"::Member,LoanApp."Client Code","Loan Disbursement Date",AmountToDeduct*-1,FORMAT(LoanApp.Source),EXTERNAL_DOC_NO,
                          FORMAT(GenJournalLine."Transaction Type"::"Loan Repayment"),LoanApp."Loan  No.");
                          RunningBalance:=RunningBalance-AmountToDeduct;
                    END;
                END;
            END;

      UNTIL LoanApp.NEXT = 0;
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Deposit Contribution",
        GenJournalLine."Account Type"::Member,"Member No","Loan Disbursement Date","Total Thirdparty Loans",'BOSA',EXTERNAL_DOC_NO,
        FORMAT(GenJournalLine."Transaction Type"::"Deposit Contribution")+'-'+LoanApp."Loan Product Type",'');
      END;
      EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnGenerateDefaulterLoans@1000000022();
    VAR
      DLoanAmount@1000000000 : Decimal;
    BEGIN
      LoanDetails.RESET;
      LoanDetails.SETRANGE(LoanDetails."Loan No.","Loan to Attach");
      LoanDetails.SETRANGE(LoanDetails."Member No","Member No");
      IF LoanDetails.FINDSET THEN BEGIN
        REPEAT
            LineNo:=LineNo+1000;
            DLoan:=FnDefaulterLoansDisbursement(LoanDetails,LineNo);
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Loan,
            GenJournalLine."Account Type"::Member,LoanDetails."Guarantor Number","Loan Disbursement Date",LoanDetails."Defaulter Loan",FORMAT(LoansRec.Source::BOSA),"Loan to Attach",
            'Defaulter Recovery-'+"Loan to Attach",DLoan);
            DLoanAmount:=DLoanAmount+LoanDetails."Defaulter Loan";
        UNTIL LoanDetails.NEXT=0;
      END;

      IF LoansRec.GET("Loan to Attach") THEN BEGIN
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Loan Repayment",
        GenJournalLine."Account Type"::Member,LoansRec."Client Code","Loan Disbursement Date",DLoanAmount*-1,FORMAT(LoanApps.Source),EXTERNAL_DOC_NO,
        'Defaulted Loan Recovered-'+LoansRec."Loan Product Type","Loan to Attach");
      END;
    END;

    LOCAL PROCEDURE FnCalculateTotalInterestDue@1000000000(Loans@1000000000 : Record 51516371) InterestDue : Decimal;
    VAR
      ObjRepaymentSchedule@1000000001 : Record 51516375;
      "Loan Age"@1000000002 : Integer;
    BEGIN
      ObjRepaymentSchedule.RESET;
      ObjRepaymentSchedule.SETRANGE("Loan No.",Loans."Loan  No.");
      ObjRepaymentSchedule.SETFILTER("Repayment Date",'<=%1',"Loan Disbursement Date");
      IF ObjRepaymentSchedule.FIND('-') THEN
       "Loan Age":=ObjRepaymentSchedule.COUNT;
      Loans.CALCFIELDS("Outstanding Balance","Interest Paid");

      InterestDue:=((0.01*Loans."Approved Amount"+0.01*Loans."Outstanding Balance")*Loans.Interest/12*("Loan Age"))/2-ABS(Loans."Interest Paid");
      IF (DATE2DMY("Loan Disbursement Date",1) >15) THEN BEGIN
      InterestDue:=((0.01*Loans."Approved Amount"+0.01*Loans."Outstanding Balance")*Loans.Interest/12*("Loan Age"+1))/2-ABS(Loans."Interest Paid");
      END;
      IF InterestDue <= 0 THEN
        EXIT(0);
      //MESSAGE('Approved=%1 Loan Age=%2 OBalance=%3 InterestPaid=%4 InterestDue=%5',Loans."Approved Amount","Loan Age",Loans."Outstanding Balance",Loans."Interest Paid",InterestDue);
      EXIT(InterestDue);
    END;

    BEGIN
    END.
  }
}

