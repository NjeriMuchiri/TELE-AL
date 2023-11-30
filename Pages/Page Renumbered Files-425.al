OBJECT page 172020 Guarantors Recovery Header
{
  OBJECT-PROPERTIES
  {
    Date=07/12/22;
    Time=10:41:00 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516390;
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
                           //EnableCreateMember:=FALSE;
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
                           //CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
                           EnabledApprovalWorkflowsExist :=TRUE;
                           IF Rec.Status=Status::Approved THEN BEGIN
                             OpenApprovalEntriesExist:=FALSE;
                             CanCancelApprovalForRecord:=FALSE;
                             EnabledApprovalWorkflowsExist:=FALSE;
                             END;
                             IF (Rec.Status=Status::Approved) THEN
                               //EnableCreateMember:=TRUE;
                         END;

    ActionList=ACTIONS
    {
      { 1000000011;  ;ActionContainer;
                      CaptionML=ENU=Root;
                      ActionContainerType=NewDocumentItems }
      { 1000000019;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1000000012;2 ;Action    ;
                      Name=Post Transaction;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 LineNo@1000000001 : Integer;
                                 TotalLoanRecovered@1000000002 : Decimal;
                               BEGIN

                                 BATCH_TEMPLATE:='GENERAL';
                                 BATCH_NAME:='RECOVERIES';
                                 DOCUMENT_NO:="Document No";
                                 EXTERNAL_DOC_NO:="Loan to Attach";
                                 Datefilter:='..'+FORMAT("Loan Disbursement Date");

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
                                 GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
                                 GenJournalLine.DELETEALL;

                                 IF "Recovery Type"="Recovery Type"::"Recover From Guarantor Deposits" THEN BEGIN
                                   LineNo:=0;
                                 LoanDetails.RESET;
                                 LoanDetails.SETRANGE(LoanDetails."Loan No.","Loan to Attach");
                                 IF LoanDetails.FINDFIRST THEN BEGIN
                                 REPEAT
                                 IF CustRec.GET(LoanDetails."Guarantor Number") THEN BEGIN
                                 CustRec.CALCFIELDS(CustRec."Shares Retained");
                                 //MESSAGE('LoanDetails%1',LoanDetails."Guarantor Number");
                                 LineNo:=LineNo+1000;
                                 GenJournalLines.RESET;
                                 GenJournalLines."Document No.":="Document No";
                                 GenJournalLines."Line No.":=LineNo;
                                 GenJournalLines."Transaction Type":=GenJournalLines."Transaction Type"::Loan;
                                 GenJournalLines."Account Type":=GenJournalLines."Account Type"::Member;
                                 GenJournalLines."Account No.":=LoanDetails."Member No";
                                 GenJournalLines.Amount:=-LoanDetails.Amount;
                                 GenJournalLines."Loan No":="Loan to Attach";
                                 GenJournalLines.Description:='Defaulter recovery Loan'+' '+"Loan to Attach";
                                 GenJournalLines."Journal Batch Name":=BATCH_NAME;
                                 GenJournalLines."Journal Template Name":=BATCH_TEMPLATE;
                                 GenJournalLines."Posting Date":=TODAY;
                                 GenJournalLines."External Document No.":="Loan to Attach";
                                 GenJournalLines."Account No.":=CustRec."No.";
                                 GenJournalLines.INSERT;

                                 LineNo:=LineNo+1000;
                                 GenJournalLine.RESET;
                                 GenJournalLine."Document No.":="Document No";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account No.":=LoanDetails."Guarantor Number";
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine.Amount:=LoanDetails.Amount;
                                 GenJournalLine.Description:='Defaulter recovery Loan'+' '+"Loan to Attach";
                                 GenJournalLine."Journal Batch Name":=BATCH_NAME;
                                 GenJournalLine."Journal Template Name":=BATCH_TEMPLATE;
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="Loan to Attach";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":=CustRec."No.";
                                 GenJournalLine.INSERT;
                                 END;
                                 UNTIL LoanDetails.NEXT=0;
                                 END;
                                 END;

                                 {//Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'RECOVERIES');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;}

                                 {ObjGuarantorRec.RESET;
                                 ObjGuarantorRec.SETRANGE("Loan No","Loan No");
                                 IF ObjGuarantorRec.FIND('-') THEN BEGIN
                                   "Loans Generated":=Posted;
                                    Posted:=TRUE;
                                    "Loans Generated":=Posted;
                                    "Posting Date":=TODAY;
                                    MODIFY;
                                 END;}
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Relieve Guarantors;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 LineNo@1000000001 : Integer;
                                 TotalLoanRecovered@1000000002 : Decimal;
                               BEGIN

                                 IF CONFIRM('Are you sure you want to post this transaction?',TRUE,FALSE)=TRUE THEN BEGIN
                                 BATCH_TEMPLATE:='GENERAL';
                                 BATCH_NAME:='RECOVERIES';
                                 DOCUMENT_NO:="Document No";
                                 EXTERNAL_DOC_NO:="Loan to Attach";
                                 Datefilter:='..'+FORMAT("Loan Disbursement Date");

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
                                 GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
                                 GenJournalLine.DELETEALL;


                                   LineNo:=0;
                                 LoanDetails.RESET;
                                 LoanDetails.SETRANGE(LoanDetails."Loan No.","Loan to Attach");
                                 IF LoanDetails.FINDFIRST THEN BEGIN
                                 REPEAT
                                 IF CustRec.GET(LoanDetails."Member No") THEN BEGIN
                                 CustRec.CALCFIELDS(CustRec."Shares Retained");

                                 LineNo:=LineNo+1000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Document No.":="Document No";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account No.":=LoanDetails."Guarantor Number";
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine.Amount:=-LoanDetails.Amount;
                                 GenJournalLine.Description:='Defaulter recovery Loan'+' '+"Loan to Attach";
                                 GenJournalLine."Journal Batch Name":=BATCH_NAME;
                                 GenJournalLine."Journal Template Name":=BATCH_TEMPLATE;
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="Loan to Attach";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine.INSERT(TRUE);

                                 LineNo:=LineNo+1000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Document No.":="Document No";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account No.":="Member No";
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                 GenJournalLine."Loan No":="Loan to Attach";
                                 GenJournalLine.Amount:=LoanDetails.Amount;
                                 GenJournalLine.Description:='Defaulter recovery Loan'+' '+"Loan to Attach";
                                 GenJournalLine."Journal Batch Name":=BATCH_NAME;
                                 GenJournalLine."Journal Template Name":=BATCH_TEMPLATE;
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="Loan to Attach";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine.INSERT(TRUE);
                                 END;
                                 UNTIL LoanDetails.NEXT=0;
                                 END;

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'RECOVERIES');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;

                                 ObjGuarantorRec.RESET;
                                 ObjGuarantorRec.SETRANGE("Loan No","Loan No");
                                 IF ObjGuarantorRec.FIND('-') THEN BEGIN
                                   "Loans Generated":=Posted;
                                    Posted:=TRUE;
                                    "Loans Generated":=Posted;
                                    "Posting Date":=TODAY;
                                    MODIFY;
                                 END;
                                 END;
                               END;
                                }
      { 1000000013;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Visible=False;
                      Enabled=(NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist;
                      Image=SendApprovalRequest;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalsMgmt@1102755001 : Codeunit 1535;
                               BEGIN
                                 IF (Status=Status::Approved) OR (Status=Status::Pending) THEN
                                 ERROR(text001);
                                 TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 // IF ApprovalsMgmt.CheckGuarantorRecoveryApprovalsWorkflowEnabled(Rec) THEN
                                 //   ApprovalsMgmt.OnSendGuarantorRecoveryForApproval(Rec);
                               END;
                                }
      { 1000000007;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel A&pproval Request;
                      Promoted=Yes;
                      Visible=False;
                      Enabled=CanCancelApprovalForRecord;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 1535;
                               BEGIN
                                    IF (Status=Status::Open) OR (Status=Status::Approved) THEN
                                       ERROR(text001);
                                 //
                                 //  IF ApprovalsMgmt.CheckGuarantorRecoveryApprovalsWorkflowEnabled(Rec) THEN
                                 //    ApprovalsMgmt.OnCancelGuarantorRecoveryApprovalRequest(Rec);
                               END;
                                }
      { 1000000018;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=False;
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
      { 1000000030;2 ;Action    ;
                      Name=Load Guarantors;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CalculateLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 LoanDetails@1000000000 : Record 51516391;
                                 GCount@1000000001 : Integer;
                               BEGIN
                                 IF ((Status=Status::Pending) OR (Posted=TRUE)) THEN
                                       ERROR('You cannot L a document which is not approved');
                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Loan  No.","Loan to Attach");
                                 IF LoansR.FINDFIRST THEN BEGIN
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");
                                 RecoveredAmount:=0;
                                 RecoveredAmount:=LoansR."Outstanding Balance"+LoansR."Oustanding Interest";

                                 IF "Recovery Type"="Recovery Type"::"Recover From Guarantor Deposits" THEN BEGIN
                                 LoanDetails.RESET;
                                 LoanDetails.SETRANGE(LoanDetails."Loan No.","Loan to Attach");
                                 LoanDetails.SETRANGE(LoanDetails."Member No","Member No");
                                 IF LoanDetails.FIND('-') THEN
                                   LoanDetails.DELETEALL;

                                 LoanGuarantors.RESET;
                                 LoanGuarantors.SETRANGE(LoanGuarantors."Loan No","Loan to Attach");
                                   IF LoanGuarantors.FINDSET THEN BEGIN
                                   GCount:=LoanGuarantors.COUNT;
                                     REPEAT
                                         LoanDetails.INIT;
                                         LoanGuarantors.CALCFIELDS(LoanGuarantors."Outstanding Balance");
                                         LoanDetails."Document No":="Document No";
                                         LoanDetails."Member No":="Member No";
                                         LoanDetails."Loan Type":='L18';
                                         IF LoanType.GET(LoanDetails."Loan Type") THEN BEGIN
                                         LoanDetails."Loan Instalments":=LoanType."No of Installment";
                                         LoanDetails."Interest Rate":=LoanType."Interest rate";
                                         END;
                                         LoanDetails.Amount:=ROUND((RecoveredAmount/LoansR."Approved Amount"*LoanGuarantors."Amont Guaranteed"),0.01,'=');
                                         LoanDetails."Approved Loan Amount":=LoanGuarantors."Amont Guaranteed";
                                         LoanDetails."Guarantor Number":=LoanGuarantors."Member No";
                                         LoanDetails."Loan No.":=LoanGuarantors."Loan No";
                                         LoanDetails."Amont Guaranteed":=LoanGuarantors."Amont Guaranteed";
                                         LoanDetails."Outstanding Balance":=LoanGuarantors."Outstanding Balance";
                                         LoanDetails."Outstanding Interest":=FnGetInterestForLoanToAttach();
                                         LoanDetails."Defaulter Loan":=ROUND(FnGetDefaultorLoanAmount("Loan Distributed to Guarantors",LoanGuarantors."Amont Guaranteed",LoanGuarantors."Total Loans Guaranteed",GCount),0.05,'>');
                                         LoanDetails.INSERT;
                                     UNTIL LoanGuarantors.NEXT=0;
                                       END;
                                       END;
                                  END;
                                 //Post New
                                 {GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'RECOVERIES');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;}
                               END;
                                }
      { 1000000038;2 ;Action    ;
                      Name=View Report;
                      RunPageOnRec=No;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Receipt;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 RHeader.RESET;
                                 RHeader.SETRANGE(RHeader."Document No","Document No");
                                 IF RHeader.FIND('-') THEN
                                 REPORT.RUN(51516618,TRUE,FALSE);
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
                Visible=False;
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
                SubPageLink=Document No=FIELD(Document No),
                            Member No=FIELD(Member No);
                PagePartID=Page51516492;
                Visible=TRUE;
                Enabled=TRUE;
                Editable=GuarantorLoansDetailsEdit;
                PartType=Page }

  }
  CODE
  {
    VAR
      PayOffDetails@1000000000 : Record 51516396;
      GenJournalLine@1000000001 : Record 81;
      GenJournalLines@1120054002 : Record 81;
      LineNo@1000000002 : Integer;
      LoanType@1000000003 : Record 51516240;
      LoansRec@1000000004 : Record 51516230;
      TotalRecovered@1000000005 : Decimal;
      TotalInsuarance@1000000006 : Decimal;
      DActivity@1000000007 : Code[20];
      DBranch@1000000008 : Code[20];
      GLoanDetails@1000000009 : Record 51516391;
      TotalOustanding@1000000010 : Decimal;
      ClosingDepositBalance@1000000011 : Decimal;
      RemainingAmount@1000000012 : Decimal;
      AMOUNTTOBERECOVERED@1000000014 : Decimal;
      PrincipInt@1000000015 : Decimal;
      TotalLoansOut@1000000016 : Decimal;
      LastFieldNo@1000000065 : Integer;
      FooterPrinted@1000000064 : Boolean;
      PDate@1000000063 : Date;
      Interest@1000000062 : Decimal;
      TextDateFormula2@1000000060 : Text[30];
      TextDateFormula1@1000000059 : Text[30];
      DateFormula2@1000000058 : DateFormula;
      DateFormula1@1000000057 : DateFormula;
      Lbal@1000000054 : Decimal;
      GenLedgerSetup@1000000051 : Record 98;
      Hesabu@1000000050 : Integer;
      "Loan&int"@1000000048 : Decimal;
      TotDed@1000000047 : Decimal;
      Available@1000000045 : Decimal;
      Distributed@1000000044 : Decimal;
      WINDOW@1000000043 : Dialog;
      PostingCode@1000000042 : Codeunit 12;
      SHARES@1000000041 : Decimal;
      TOTALLOANS@1000000040 : Decimal;
      LineN@1000000038 : Integer;
      instlnclr@1000000037 : Decimal;
      appotbal@1000000036 : Decimal;
      PRODATA@1000000034 : Decimal;
      LOANAMOUNT2@1000000033 : Decimal;
      TOTALLOANSB@1000000032 : Decimal;
      NETSHARES@1000000031 : Decimal;
      Tinst@1000000030 : Decimal;
      Finst@1000000029 : Decimal;
      Floans@1000000028 : Decimal;
      GrAmount@1000000027 : Decimal;
      TGrAmount@1000000026 : Decimal;
      FGrAmount@1000000025 : Decimal;
      LOANBAL@1000000024 : Decimal;
      Serie@1000000023 : Integer;
      DLN@1000000022 : Code[10];
      "LN Doc"@1000000021 : Code[20];
      INTBAL@1000000020 : Decimal;
      COMM@1000000019 : Decimal;
      loanTypes@1000000018 : Record 51516240;
      DocumentType@1000000046 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ,Purchase Requisition,RFQ,Store Requisition,Payment Voucher,MembershipApplication,LoanApplication,LoanDisbursement,ProductApplication,StandingOrder,MembershipWithdrawal,ATMCard,GuarantorRecovery,ChangeRequest,TreasuryTransactions,FundsTransfer,SaccoTransfers,ChequeDiscounting,ImprestRequisition,ImprestSurrender,LeaveApplication';
      MemberNoEditable@1000000052 : Boolean;
      RecoveryTypeEditable@1000000053 : Boolean;
      Global1Editable@1000000066 : Boolean;
      Global2Editable@1000000067 : Boolean;
      LoantoAttachEditable@1000000068 : Boolean;
      GuarantorLoansDetailsEdit@1000000069 : Boolean;
      TotalRecoverable@1000000070 : Decimal;
      LoanGuarantors@1000000071 : Record 51516231;
      AmounttoRecover@1000000072 : Decimal;
      BaltoRecover@1000000073 : Decimal;
      InstRecoveredAmount@1000000074 : Decimal;
      X@1000000075 : Decimal;
      ObjGuarantorML@1000000076 : Record 51516391;
      ApprovalsMgmt@1000000077 : Codeunit 1535;
      RunBal@1000000078 : Decimal;
      TotalSharesUsed@1000000079 : Decimal;
      i@1000000239 : Integer;
      PeriodDueDate@1000000237 : Date;
      ScheduleRep@1000000236 : Record 51516234;
      LoanGuar@1000000235 : Record 51516231;
      RunningDate@1000000234 : Date;
      G@1000000233 : Integer;
      IssuedDate@1000000232 : Date;
      SMSMessages@1000000231 : Record 51516329;
      iEntryNo@1000000230 : Integer;
      GracePeiodEndDate@1000000229 : Date;
      InstalmentEnddate@1000000228 : Date;
      GracePerodDays@1000000227 : Integer;
      InstalmentDays@1000000226 : Integer;
      NoOfGracePeriod@1000000225 : Integer;
      NewSchedule@1000000224 : Record 51516234;
      RSchedule@1000000223 : Record 51516234;
      GP@1000000222 : Text[30];
      ScheduleCode@1000000221 : Code[20];
      PreviewShedule@1000000220 : Record 51516234;
      PeriodInterval@1000000219 : Code[10];
      CustomerRecord@1000000218 : Record 51516223;
      Gnljnline@1000000217 : Record 81;
      Jnlinepost@1000000216 : Codeunit 12;
      CumInterest@1000000215 : Decimal;
      NewPrincipal@1000000214 : Decimal;
      PeriodPrRepayment@1000000213 : Decimal;
      GenBatch@1000000212 : Record 232;
      GnljnlineCopy@1000000210 : Record 81;
      NewLNApplicNo@1000000209 : Code[10];
      Cust@1000000208 : Record 51516223;
      LoanApp@1000000207 : Record 51516230;
      TestAmt@1000000206 : Decimal;
      CustRec@1000000205 : Record 51516223;
      CustPostingGroup@1000000204 : Record 92;
      GenSetUp@1000000203 : Record 51516257;
      PCharges@1000000202 : Record 51516242;
      TCharges@1000000201 : Decimal;
      LAppCharges@1000000200 : Record 51516244;
      LoansR@1000000199 : Record 51516230;
      LoanAmount@1000000198 : Decimal;
      InterestRate@1000000197 : Decimal;
      RepayPeriod@1000000196 : Integer;
      LBalance@1000000195 : Decimal;
      RunDate@1000000194 : Date;
      InstalNo@1000000193 : Decimal;
      RepayInterval@1000000192 : DateFormula;
      TotalMRepay@1000000191 : Decimal;
      LInterest@1000000190 : Decimal;
      LPrincipal@1000000189 : Decimal;
      RepayCode@1000000188 : Code[40];
      GrPrinciple@1000000187 : Integer;
      GrInterest@1000000186 : Integer;
      QPrinciple@1000000185 : Decimal;
      QCounter@1000000184 : Integer;
      InPeriod@1000000183 : DateFormula;
      InitialInstal@1000000182 : Integer;
      InitialGraceInt@1000000181 : Integer;
      FOSAComm@1000000179 : Decimal;
      BOSAComm@1000000178 : Decimal;
      GLPosting@1000000177 : Codeunit 12;
      LoanTopUp@1000000176 : Record 51516235;
      Vend@1000000175 : Record 23;
      BOSAInt@1000000174 : Decimal;
      TopUpComm@1000000173 : Decimal;
      TotalTopupComm@1000000170 : Decimal;
      CustE@1000000168 : Record 51516223;
      DocN@1000000167 : Text[50];
      DocM@1000000166 : Text[100];
      DNar@1000000165 : Text[250];
      DocF@1000000164 : Text[50];
      MailBody@1000000163 : Text[250];
      ccEmail@1000000162 : Text[250];
      LoanG@1000000161 : Record 51516231;
      SpecialComm@1000000160 : Decimal;
      FOSAName@1000000159 : Text[150];
      IDNo@1000000158 : Code[50];
      MovementTracker@1000000157 : Record 51516253;
      DiscountingAmount@1000000156 : Decimal;
      StatusPermissions@1000000155 : Record 51516310;
      BridgedLoans@1000000154 : Record 51516238;
      SMSMessage@1000000153 : Record 51516329;
      InstallNo2@1000000152 : Integer;
      currency@1000000151 : Record 330;
      CURRENCYFACTOR@1000000150 : Decimal;
      LoanApps@1000000149 : Record 51516230;
      LoanDisbAmount@1000000148 : Decimal;
      BatchTopUpAmount@1000000147 : Decimal;
      BatchTopUpComm@1000000146 : Decimal;
      Disbursement@1000000145 : Record 51516236;
      SchDate@1000000144 : Date;
      DisbDate@1000000143 : Date;
      WhichDay@1000000142 : Integer;
      LBatches@1000000141 : Record 51516230;
      SalDetails@1000000140 : Record 51516232;
      LGuarantors@1000000139 : Record 51516231;
      CurrpageEditable@1000000137 : Boolean;
      LoanStatusEditable@1000000136 : Boolean;
      MNoEditable@1000000135 : Boolean;
      ApplcDateEditable@1000000134 : Boolean;
      LProdTypeEditable@1000000133 : Boolean;
      InstallmentEditable@1000000132 : Boolean;
      AppliedAmountEditable@1000000131 : Boolean;
      ApprovedAmountEditable@1000000130 : Boolean;
      RepayMethodEditable@1000000129 : Boolean;
      RepaymentEditable@1000000128 : Boolean;
      BatchNoEditable@1000000127 : Boolean;
      RepayFrequencyEditable@1000000126 : Boolean;
      ModeofDisburesmentEdit@1000000125 : Boolean;
      DisbursementDateEditable@1000000124 : Boolean;
      AccountNoEditable@1000000123 : Boolean;
      LNBalance@1000000122 : Decimal;
      ApprovalEntries@1000000121 : Record 454;
      RejectionRemarkEditable@1000000120 : Boolean;
      ApprovalEntry@1000000119 : Record 454;
      Table_id@1000000118 : Integer;
      Doc_No@1000000117 : Code[20];
      Doc_Type@1000000116 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening,Member Closure,Loan';
      GrossPay@1000000114 : Decimal;
      Nettakehome@1000000113 : Decimal;
      TotalDeductions@1000000112 : Decimal;
      UtilizableAmount@1000000111 : Decimal;
      NetUtilizable@1000000110 : Decimal;
      Deductions@1000000109 : Decimal;
      Benov@1000000108 : Decimal;
      TAXABLEPAY@1000000107 : Record 51516478;
      PAYE@1000000106 : Decimal;
      PAYESUM@1000000105 : Decimal;
      BAND1@1000000104 : Decimal;
      BAND2@1000000103 : Decimal;
      BAND3@1000000102 : Decimal;
      BAND4@1000000101 : Decimal;
      BAND5@1000000100 : Decimal;
      Taxrelief@1000000099 : Decimal;
      OTrelief@1000000098 : Decimal;
      Chargeable@1000000097 : Decimal;
      PartPay@1000000096 : Record 51516494;
      PartPayTotal@1000000095 : Decimal;
      AmountPayable@1000000094 : Decimal;
      RepaySched@1000000093 : Record 51516234;
      LoanReferee1NameEditable@1000000092 : Boolean;
      LoanReferee2NameEditable@1000000091 : Boolean;
      LoanReferee1MobileEditable@1000000090 : Boolean;
      LoanReferee2MobileEditable@1000000089 : Boolean;
      LoanReferee1AddressEditable@1000000088 : Boolean;
      LoanReferee2AddressEditable@1000000087 : Boolean;
      LoanReferee1PhyAddressEditable@1000000086 : Boolean;
      LoanReferee2PhyAddressEditable@1000000085 : Boolean;
      LoanReferee1RelationEditable@1000000084 : Boolean;
      LoanReferee2RelationEditable@1000000083 : Boolean;
      LoanPurposeEditable@1000000082 : Boolean;
      WitnessEditable@1000000081 : Boolean;
      compinfo@1000000080 : Record 79;
      LoanRepa@1000000013 : Record 51516234;
      ObjGuarantorRec@1000000017 : Record 51516390;
      Text0001@1000000035 : TextConst 'ENU=Please consider recovering from the Loanee Shares Before Attaching to Guarantors';
      BATCH_TEMPLATE@1000000039 : Code[30];
      BATCH_NAME@1000000049 : Code[30];
      DOCUMENT_NO@1000000055 : Code[30];
      EXTERNAL_DOC_NO@1000000061 : Code[40];
      SFactory@1000000056 : Codeunit 51516022;
      DLoan@1000000115 : Code[20];
      Datefilter@1000000138 : Text;
      LoanDetails@1000000169 : Record 51516391;
      OpenApprovalEntriesExist@1000000241 : Boolean;
      EnabledApprovalWorkflowsExist@1000000240 : Boolean;
      CanCancelApprovalForRecord@1000000211 : Boolean;
      EventFilter@1000000180 : Text;
      EnableCreateMember@1000000172 : Boolean;
      RHeader@1000000171 : Record 51516390;
      RecoveredAmount@1120054000 : Decimal;
      ApprovedAmount@1120054001 : Decimal;

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
      ObjLoanDetails@1000000000 : Record 51516391;
    BEGIN
      {IF LoansRec.GET("Loan to Attach") THEN BEGIN
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLine (BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
        GenJournalLine."Account Type"::Member,LoansRec."Client Code","Loan Disbursement Date",TDefaulterLoan*-1,FORMAT(LoanApps.Source),EXTERNAL_DOC_NO,
        'Defaulted Loan Recovered-'+"Loan to Attach","Loan to Attach");
      END;
      }
    END;

    LOCAL PROCEDURE FnGetInterestForLoanToAttach@1000000046() : Decimal;
    VAR
      ObjLoansRegisterLocal@1000000000 : Record 51516230;
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
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
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
      {IF RunningBalance > 0 THEN BEGIN
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
      }
    END;

    LOCAL PROCEDURE FnRunPrinciple@1000000013(RunningBalance@1000000001 : Decimal);
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
    BEGIN
      {   BEGIN
          IF LoansRec.GET("Loan to Attach") THEN BEGIN
            //---------------------PAY-------------------------------
            LineNo:=LineNo+10000;
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
            GenJournalLine."Account Type"::Member,LoansRec."Client Code","Loan Disbursement Date","Deposits Aportioned"*-1,FORMAT(LoansRec.Source),EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::Repayment),"Loan to Attach");
            //--------------------RECOVER-----------------------------
            LineNo:=LineNo+10000;
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Deposit Contribution",
            GenJournalLine."Account Type"::Member,"Member No","Loan Disbursement Date","Deposits Aportioned",FORMAT(LoansRec.Source),EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::"Deposit Contribution")+'-'+LoansRec."Loan Product Type",'');
            END;
          END;
          }
    END;

    LOCAL PROCEDURE FnLoansGenerated@1000000008();
    BEGIN
    END;

    LOCAL PROCEDURE FnDefaulterLoansDisbursement@1000000015(ObjLoanDetails@1000000001 : Record 51516391;LineNo@1000000003 : Integer) : Code[40];
    VAR
      GenJournalLine@1000000000 : Record 81;
      CUNoSeriesManagement@1000000002 : Codeunit 396;
      DocNumber@1000000004 : Code[100];
      loanTypes@1000000005 : Record 51516240;
      ObjLoanX@1000000006 : Record 51516230;
    BEGIN
        loanTypes.RESET;
        loanTypes.SETRANGE(loanTypes.Code,'L18');
        IF loanTypes.FIND('-') THEN
          BEGIN
            DocNumber:=CUNoSeriesManagement.GetNextNo('LOANSB',0D,TRUE);
            LoansRec.INIT;
            LoansRec."Loan  No.":=DocNumber;
            LoansRec.INSERT;

            IF LoansRec.GET(LoansRec."Loan  No.") THEN BEGIN
            LoansRec."Client Code":=ObjLoanDetails."Guarantor Number";
            LoansRec.VALIDATE(LoansRec."Client Code");
            LoansRec."Loan Product Type":='L18';
            LoansRec.VALIDATE(LoansRec."Loan Product Type");
            LoansRec.Interest:=ObjLoanDetails."Interest Rate";
            LoansRec."Loan Status":=LoansRec."Loan Status"::Issued;
            LoansRec."Application Date":="Loan Disbursement Date";
            LoansRec."Issued Date":="Loan Disbursement Date";
            LoansRec."Loan Disbursement Date":="Loan Disbursement Date";
            LoansRec."Expected Date of Completion":="Expected Date of Completion";
            LoansRec.VALIDATE(LoansRec."Loan Disbursement Date");
            LoansRec."Mode of Disbursement":=LoansRec."Mode of Disbursement"::"Transfer to FOSA";
            LoansRec."Repayment Start Date":="Repayment Start Date";
            LoansRec."Global Dimension 1 Code":=FORMAT(LoanApps.Source);
            LoansRec."Branch Code":='NAIROBI';
            LoansRec.Source:=LoansRec.Source::BOSA;
            LoansRec."Approval Status":=LoansRec."Approval Status"::Approved;
            LoansRec.Repayment:=ObjLoanDetails."Approved Loan Amount";
            LoansRec."Requested Amount":=0;
            LoansRec."Approved Amount":=ObjLoanDetails."Approved Loan Amount";
            LoansRec."Mode of Disbursement":=LoansRec."Mode of Disbursement"::"Transfer to FOSA";
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
        IF ((LoansR."Loan Product Type"='L18') AND (LoansR."Issued Date"<>0D) AND (LoansR."Repayment Start Date"<>0D)) THEN BEGIN
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
      {IF RunningBalance > 0 THEN BEGIN
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
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
            GenJournalLine."Account Type"::Member,LoanApp."Client Code","Loan Disbursement Date","Mobile Loan"*-1,'FOSA',EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::Repayment),LoanApp."Loan  No.");
            //--------------------RECOVER-----------------------------
            LineNo:=LineNo+10000;
            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Deposit Contribution",
            GenJournalLine."Account Type"::Member,"Member No","Loan Disbursement Date","Mobile Loan",'BOSA',EXTERNAL_DOC_NO,
            FORMAT(GenJournalLine."Transaction Type"::"Deposit Contribution")+'-'+LoanApp."Loan Product Type",LoanApp."Loan  No.");
          END;
      END;
      }
    END;

    LOCAL PROCEDURE FnRunPrincipleThirdparty@1000000001(RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjReceiptTransactions@1000000003 : Record 51516246;
      varTotalRepay@1000000004 : Decimal;
      varMultipleLoan@1000000005 : Decimal;
      varLRepayment@1000000006 : Decimal;
      PRpayment@1000000007 : Decimal;
      ReceiptLine@1000000008 : Record 51516282;
    BEGIN
      {IF RunningBalance > 0 THEN BEGIN
      varTotalRepay:=0;
      varMultipleLoan:=0;
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Client Code","Member No");
      LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      LoanApp.SETFILTER(LoanApp."Loan Product Type",'L18');
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
                          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                          GenJournalLine."Account Type"::Member,LoanApp."Client Code","Loan Disbursement Date",AmountToDeduct*-1,FORMAT(LoanApp.Source),EXTERNAL_DOC_NO,
                          FORMAT(GenJournalLine."Transaction Type"::Repayment),LoanApp."Loan  No.");
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
      }
    END;

    LOCAL PROCEDURE FnGenerateDefaulterLoans@1000000022();
    VAR
      DLoanAmount@1000000000 : Decimal;
    BEGIN
      {LoanDetails.RESET;
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
        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
        GenJournalLine."Account Type"::Member,LoansRec."Client Code","Loan Disbursement Date",DLoanAmount*-1,FORMAT(LoanApps.Source),EXTERNAL_DOC_NO,
        'Defaulted Loan Recovered-'+LoansRec."Loan Product Type","Loan to Attach");
        LoansRec."Defaulted Loan":=LoansRec."Loan  No.";
        LoansRec.MODIFY;
      END;
      }
    END;

    LOCAL PROCEDURE FnCalculateTotalInterestDue@1000000000(Loans@1000000000 : Record 51516230) InterestDue : Decimal;
    VAR
      ObjRepaymentSchedule@1000000001 : Record 51516234;
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

