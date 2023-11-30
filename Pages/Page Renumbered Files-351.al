OBJECT page 50042 Member Withdrawal Batch Card
{
  OBJECT-PROPERTIES
  {
    Date=12/13/22;
    Time=[ 2:47:10 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516353;
    SourceTableView=WHERE(Posted=CONST(No));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnAfterGetCurrRecord=BEGIN
                           UpdateControl();
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760025;1 ;ActionGroup;
                      Name=LoansB;
                      CaptionML=ENU=Batch }
      { 1102760026;2 ;Action    ;
                      CaptionML=ENU=Loans Schedule;
                      Promoted=Yes;
                      Image=SuggestPayment;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF Posted = TRUE THEN
                                 ERROR('Batch already posted.');


                                 LoansBatch.RESET;
                                 LoansBatch.SETRANGE(LoansBatch."Batch No.","Batch No.");
                                 IF LoansBatch.FIND('-') THEN BEGIN
                                 IF LoansBatch."Batch Type" = LoansBatch."Batch Type"::"Personal Loans" THEN
                                 REPORT.RUN(51516232,TRUE,FALSE,LoansBatch)
                                 ELSE IF LoansBatch."Batch Type" = LoansBatch."Batch Type"::"Branch Loans" THEN
                                 REPORT.RUN(51516232,TRUE,FALSE,LoansBatch)
                                 ELSE IF LoansBatch."Batch Type" = LoansBatch."Batch Type"::"Appeal Loans" THEN
                                 REPORT.RUN(51516232,TRUE,FALSE,LoansBatch)
                                 ELSE
                                 REPORT.RUN(51516232,TRUE,FALSE,LoansBatch);
                                 END;
                               END;
                                }
      { 1102760034;2 ;Separator  }
      { 1       ;2   ;Action    ;
                      Name=Export EFT;
                      CaptionML=ENU=Export EFT;
                      Image=SuggestPayment;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Batch No.","Batch No.");
                                 IF LoanApp.FIND('-') THEN BEGIN

                                 XMLPORT.RUN(51516012,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 1102760058;2 ;Action    ;
                      Name=Member Card;
                      CaptionML=ENU=Member Card;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 {LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm);
                                 IF LoanApp.FIND('-') THEN BEGIN}

                                 {Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",LoanApp."Client Code");
                                 IF Cust.FIND('-') THEN
                                 PAGE.RUNMODAL(,Cust);}
                                 //END;
                               END;
                                }
      { 1102760052;2 ;Action    ;
                      Name=Loan Application;
                      CaptionML=ENU=Loan Application Card;
                      Image=Loaners;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 LoanApp.RESET;
                                 //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
                                 IF LoanApp.FIND('-') THEN
                                 PAGE.RUNMODAL(,LoanApp);
                                 }
                               END;
                                }
      { 1102760053;2 ;Action    ;
                      Name=Loan Appraisal;
                      CaptionML=ENU=Loan Appraisal;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 LoanApp.RESET;
                                 //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 IF COPYSTR(LoanApp."Loan Product Type",1,2) = 'PL' THEN
                                 REPORT.RUN(,TRUE,FALSE,LoanApp)
                                 ELSE
                                 REPORT.RUN(,TRUE,FALSE,LoanApp);
                                 END;
                                 }
                               END;
                                }
      { 1102760045;2 ;Separator  }
      { 1102755002;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"Withdrawal Batch";
                                 ApprovalEntries.Setfilters(DATABASE::"Approvals Users Set Up",DocumentType,"Batch No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755003;2 ;Action    ;
                      Name=Send A&pproval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755001 : TextConst 'ENU=This Batch is already pending approval';
                                 ApprovalsMgmt@1000000000 : Codeunit 1535;
                               BEGIN
                                 {
                                 MembWith.RESET;
                                 MembWith.SETRANGE(MembWith."Batch No.","Batch No.");
                                 IF MembWith.FIND('-')=FALSE THEN
                                 ERROR('You cannot send an empty batch for approval');

                                 Doc_Type:=Doc_Type::"Withdrawal Batch";
                                 Table_id:=DATABASE::"Membership Withdrawal-Batching";

                                 IF ApprovalsMgmt.CheckWBatcApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendWBatchDocForApproval(Rec);
                                 }
                                 IF Status=Status::Open THEN
                                 Status:=Status::Approved;
                                 MODIFY;
                               END;
                                }
      { 1102755004;2 ;Action    ;
                      Name=Canel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN
                                 {
                                 IF ApprovalsMgmt.CheckWBatcApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelWBatcApprovalRequest(Rec);
                                 }
                                 IF Status=Status::Approved THEN
                                 Status:=Status::Open;
                                 MODIFY;
                               END;
                                }
      { 1102755005;2 ;Action    ;
                      Name=Post;
                      CaptionML=ENU=Post;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=The Batch need to be approved.';
                                 BenevolentAmount@1120054000 : Decimal;
                                 TotalPayingAmount@1120054001 : Decimal;
                               BEGIN

                                 IF Status<>Status::Approved THEN
                                   ERROR('The batch must be approved.');

                                 //TESTFIELD("BOSA Bank Account");
                                 TESTFIELD("Description/Remarks");
                                 TESTFIELD("Posting Date");
                                 TESTFIELD("Document No.");

                                 UserSetup.RESET;
                                 UserSetup.SETRANGE(UserSetup."User ID",USERID);
                                 UserSetup.SETRANGE(UserSetup."Membership Withdrawal",FALSE);
                                 IF UserSetup.FIND('-') THEN
                                   ERROR('You do not have the rights to withdraw member');
                                 //only individual cheques

                                 IF CONFIRM('Are you sure you want to post this batch?',TRUE,TRUE) = TRUE THEN BEGIN



                                 //Delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'Closure');
                                 Gnljnline.DELETEALL;
                                 //End of deletion

                                 MembWith.RESET;
                                 MembWith.SETRANGE(MembWith."Batch No.","Batch No.");
                                 MembWith.SETFILTER(MembWith.Status,'%1',MembWith.Status::Approved);
                                 MembWith.SETFILTER(MembWith."Withdrawal Status",'%1',MembWith."Withdrawal Status"::Processed);
                                 IF MembWith.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF MembWith."Disbursement Type"=MembWith."Disbursement Type"::"Full Amount" THEN BEGIN
                                 IF Cust.GET(MembWith."Member No.") THEN
                                 Cust.CALCFIELDS(Cust."Outstanding Balance",Cust."Outstanding Interest",Cust."Current Savings");
                                 IF (Cust."Outstanding Balance"+Cust."Outstanding Interest")>Cust."Current Savings" THEN
                                   ERROR('The member "%1" does not have enough deposits to clear loan ',MembWith."Member No.");

                                 IF Cust.GET(MembWith."Member No.") THEN BEGIN
                                 IF (MembWith."Closure Type"=MembWith."Closure Type"::Notice ) OR (MembWith."Closure Type"=MembWith."Closure Type"::Expulsion ) THEN BEGIN

                                 RecoverSharecapital(MembWith."Member No.");

                                 Totalrecovered:=0;
                                 TotalInsuarance:=0;
                                 RunBal:=0;
                                 runbal1:=0;
                                 TotalAmount:=0;
                                 DActivity:=Cust."Global Dimension 1 Code";
                                 DBranch:=Cust."Global Dimension 2 Code";
                                 Cust.CALCFIELDS(Cust."Outstanding Balance","Accrued Interest","Current Shares",Cust."School Fees Shares");

                                 Cust.CALCFIELDS(Cust."Outstanding Balance",Cust."Outstanding Interest","FOSA Outstanding Balance","Accrued Interest","Insurance Fund",Cust."Current Shares",Cust."School Fees Shares");
                                 TotalOustanding:=Cust."Outstanding Balance"+Cust."Outstanding Interest";
                                 RunBal:=Cust."Current Shares"+Cust."School Fees Shares";//+Cust."Insurance Fund";
                                 //GETTING WITHDRWAL FEE
                                 Generalsetup.GET();
                                 Cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                 // END OF GETTING WITHDRWAL FEE
                                 IF Generalsetup."Withdrawal Fee">0 THEN BEGIN
                                 LineNo:=LineNo+100000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":=MembWith."No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=MembWith."No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":=MembWith."Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Withdrawal Fee';
                                 GenJournalLine.Amount:=Generalsetup."Withdrawal Fee";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Bal. Account No." :=Generalsetup."Withdrawal Fee Account";
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 TotalAdd+=GenJournalLine.Amount;
                                 RunBal:=RunBal-(GenJournalLine.Amount);
                                 TotalAmount:=TotalAmount+(GenJournalLine.Amount);
                                 END;


                                 IF RunBal > 0 THEN BEGIN
                                 //excise duty on withdrawal
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":=MembWith."No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=MembWith."No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=Generalsetup."Excise Duty Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='excise Duty';
                                 GenJournalLine.Amount:=-(Generalsetup."Withdrawal Commision"*(Generalsetup."Excise Duty(%)"/100));
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 TotalAdd+=GenJournalLine.Amount;
                                 RunBal:=RunBal-(GenJournalLine.Amount*-1);
                                 TotalAmount:=TotalAmount+(GenJournalLine.Amount*-1);
                                 END;


                                 IF RunBal > 0 THEN BEGIN


                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code",MembWith."Member No.");
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF RunBal > 0 THEN BEGIN
                                     "AMOUNTTO BE RECOVERED":=0;

                                     LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");

                                     LInterest:=MembWith."Total Interest";

                                     // clear .................Loan Insurance
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='Closure';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":=MembWith."No.";
                                     GenJournalLine."Posting Date":=TODAY;
                                     GenJournalLine."External Document No.":=MembWith."No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=MembWith."Member No.";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Cleared by deposits: ' + MembWith."No.";
                                     GenJournalLine.Amount:=-ROUND(LoansR."Loans Insurance");
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Insurance Paid";
                                     GenJournalLine."Loan No":=LoansR."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     TotalLoansOut:=TotalLoansOut+(GenJournalLine.Amount*-1);
                                     RunBal:=RunBal-(GenJournalLine.Amount*-1);
                                     TotalAmount:=TotalAmount+(GenJournalLine.Amount*-1);
                                   END;
                                 UNTIL LoansR.NEXT=0;
                                 END;
                                 END;
                                 Cust."Closing Deposit Balance":=(Cust."Closing Deposit Balance"-LoansR."Loans Insurance");

                                 TotalLoansOut:=0;
                                 //Capitalize Interest to Loans
                                 IF RunBal > 0 THEN BEGIN
                                 "Remaining Amount":=Cust."Closing Deposit Balance";

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code",MembWith."Member No.");
                                 //LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF RunBal > 0 THEN BEGIN
                                   "AMOUNTTO BE RECOVERED":=0;
                                   Interestrecovery:=0;
                                   LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");
                                   LInterest:=LoansR."Oustanding Interest";
                                   Interestrecovery:=LoansR."Oustanding Interest";

                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":=MembWith."Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine.Description:='Interest Offset: ' + MembWith."No.";
                                   IF RunBal < LInterest THEN
                                   GenJournalLine.Amount:=-1*RunBal
                                   ELSE
                                   GenJournalLine.Amount:=-1*LInterest;
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                   GenJournalLine."Loan No":=LoansR."Loan  No.";
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                   TotalLoansOut:=TotalLoansOut+(GenJournalLine.Amount*-1);
                                   RunBal:=RunBal-(GenJournalLine.Amount*-1);
                                   TotalAmount:=TotalAmount+(GenJournalLine.Amount*-1);
                                   END;
                                 UNTIL LoansR.NEXT=0;
                                 END;
                                 END;
                                 ////End of Capitalize Interest to Loans

                                 Lprinciple:=0;

                                 IF RunBal > 0 THEN BEGIN
                                 //GET LOANS TO RECOVER

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code",MembWith."Member No.");
                                 //LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
                                 Lprinciple:=LoansR."Outstanding Balance";
                                 IF RunBal > 0 THEN BEGIN
                                     IF Lprinciple >0 THEN BEGIN
                                     //Loans Outstanding
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='Closure';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":=MembWith."No.";
                                     GenJournalLine."Posting Date":=TODAY;
                                     GenJournalLine."External Document No.":=MembWith."No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=MembWith."Member No.";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Loan Cleared by deposits: ' + MembWith."No.";
                                     IF RunBal < Lprinciple THEN
                                     GenJournalLine.Amount:=-1*RunBal
                                     ELSE
                                     GenJournalLine.Amount:=-1*Lprinciple;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=LoansR."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     TotalLoansOut:=TotalLoansOut+(GenJournalLine.Amount*-1);
                                     RunBal:=RunBal-(GenJournalLine.Amount*-1);
                                     TotalAmount:=TotalAmount+(GenJournalLine.Amount*-1);
                                     END;
                                  END;
                                 UNTIL LoansR.NEXT=0;
                                 END;
                                 END;

                                 IF TotalLoansOut> 0 THEN BEGIN
                                 //IF RunBal>0 THEN
                                 //RECOVER LOANS FROM DEPOIST
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":=MembWith."No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=MembWith."No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":=MembWith."Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Loans Recovered From Shares: ' + MembWith."No.";
                                 GenJournalLine.Amount:=ROUND(TotalLoansOut);
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 //RunBal:=RunBal-(GenJournalLine.Amount);
                                 Cust."Closing Deposit Balance":=(Cust."Closing Deposit Balance"-TotalLoansOut);
                                 TotalAmount:=TotalAmount*-1;
                                 //AMOUNT PAYABLE TO THE MEMBER
                                 END;

                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":=MembWith."Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"SchFee Shares";
                                   GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                   GenJournalLine.Amount:=Cust."School Fees Shares";
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;

                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":=MembWith."Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                   GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                   GenJournalLine.Amount:=-(Cust."School Fees Shares");
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                 IF RunBal >0 THEN BEGIN
                                 //***DEBIT PAYING BANK MEMBER
                                   Generalsetup.GET();
                                   Cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                   IF Vend.GET(MembWith."FOSA Account No.") THEN BEGIN
                                     Vend.CALCFIELDS(Vend.Balance);
                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":=MembWith."Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                   GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                   GenJournalLine.Amount:=(RunBal);
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                   END;

                                 //***CREDIT PAYING BANK
                                 Generalsetup.GET();
                                 Cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                 IF Vend.GET(MembWith."FOSA Account No.") THEN BEGIN
                                   Vend.CALCFIELDS(Vend.Balance);
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":=MembWith."No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=MembWith."FOSA Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Withdrawal;
                                 GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                 GenJournalLine.Amount:=-(RunBal);
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;


                                 END;
                                 END;
                                 END;
                                 IF (MembWith."Closure Type"=MembWith."Closure Type"::Death) THEN BEGIN
                                 //Kitui
                                 IF Customer.GET(Cust."No.") THEN
                                 //MESSAGE('Customer%1',Customer."No.");
                                 Customer.CALCFIELDS(Customer."Current Shares",Customer."School Fees Shares");
                                 //Deposits deduction
                                 IF Customer."Current Shares">0 THEN BEGIN
                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":=MembWith."Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                   GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                   GenJournalLine.Amount:=Customer."Current Shares";
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;


                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                   GenJournalLine."Account No.":=MembWith."FOSA Account No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                   GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                   GenJournalLine.Amount:=-Customer."Current Shares";
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                   TotalPayingAmount:=TotalPayingAmount+Customer."Current Shares";
                                 END;
                                 //School fees Shares Deduction
                                 IF Customer."School Fees Shares">0 THEN BEGIN
                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":=MembWith."Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"SchFee Shares";
                                   GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                   GenJournalLine.Amount:=Customer."School Fees Shares";
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;


                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                   GenJournalLine."Account No.":=MembWith."FOSA Account No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"SchFee Shares";
                                   GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                   GenJournalLine.Amount:=-Customer."School Fees Shares";
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                   TotalPayingAmount:=TotalPayingAmount+Customer."School Fees Shares";
                                 END;

                                 //Deduct benovelent
                                 IF Customer."Current Shares">0 THEN BEGIN
                                 BenevolentAmount:=0;
                                 BenevolentAmount:=Customer."Current Shares";
                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                   GenJournalLine."Account No.":='200-000-170';
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine.Description:='Membership Withdrawal Benevolent' + MembWith."No.";
                                   GenJournalLine.Amount:=BenevolentAmount;
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                   TotalPayingAmount:=TotalPayingAmount+BenevolentAmount;
                                 END;

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."BOSA No",Customer."No.");
                                 IF LoanApp.FINDFIRST THEN BEGIN
                                 REPEAT
                                 LoanApp.CALCFIELDS(LoanApp."Outstanding Balance",LoanApp."Oustanding Interest");
                                 IF LoanApp."Outstanding Balance">0 THEN BEGIN
                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Loan No":=LoanApp."Loan  No.";
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                   GenJournalLine."Account No.":=Customer."No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine.Description:='Membership Withdrawal Loan Repayment' + MembWith."No.";
                                   GenJournalLine.Amount:=-LoanApp."Outstanding Balance";
                                   GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                   GenJournalLine."Bal. Account No.":='200-000-170';
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                 END;

                                 IF LoanApp."Oustanding Interest">0 THEN BEGIN
                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":=MembWith."No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                   GenJournalLine."Loan No":=LoanApp."Loan  No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                   GenJournalLine."Account No.":=Customer."No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine.Description:='Membership Withdrawal Interest Paid' + MembWith."No.";
                                   GenJournalLine.Amount:=-LoanApp."Oustanding Interest";
                                   GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                   GenJournalLine."Bal. Account No.":='200-000-170';
                                   GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                   GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                   GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                   GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                   IF GenJournalLine.Amount<>0 THEN
                                   GenJournalLine.INSERT;
                                 END;

                                 UNTIL LoanApp.NEXT=0;
                                 END;

                                 //***CREDIT PAYING BANK
                                 Generalsetup.GET();
                                 Cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                 IF Vend.GET(MembWith."FOSA Account No.") THEN BEGIN
                                   Vend.CALCFIELDS(Vend.Balance);
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":=MembWith."No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=MembWith."Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=MembWith."FOSA Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
                                 GenJournalLine.Amount:=-BenevolentAmount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;

                                 END;




                                 END;
                                 //Add tranche payments
                                 IF MembWith."Disbursement Type"=MembWith."Disbursement Type"::Tranches THEN BEGIN
                                 FnTrancheDisbursement(MembWith."No.",MembWith."Amount to Refund");
                                 END;

                                 //End Tranche payments
                                 MembWith."Net Pay":=(RunBal);
                                 MembWith."Closing Date":=TODAY;
                                 MembWith."Member Deposits":=Cust."Current Shares";
                                 MembWith.Posted:=TRUE;
                                 IF MembWith."Disbursement Type"<>MembWith."Disbursement Type"::Tranches THEN BEGIN
                                 //MembWith."Withdrawal Status":=MembWith."Withdrawal Status"::Posted;
                                 END;
                                 MembWith.MODIFY;

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Closure');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;
                                 Posted:=TRUE;
                                 "Posted By":=USERID;
                                 MODIFY;
                                 //MESSAGE('Closure posted successfully.');


                                 //CHANGE ACCOUNT STATUS
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",MembWith."Member No.");
                                 IF Cust.FIND('-') THEN BEGIN
                                 Cust.Status:=Cust.Status::Withdrawal;
                                 Cust.Blocked:=Cust.Blocked::All;
                                 Cust.MODIFY;
                                 END;
                                 //END;


                                 UNTIL MembWith.NEXT=0;
                                 END;
                                 END;
                                 // end the loop here *Kiganya*
                                 MESSAGE('Batch posted successfully.');
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      Name=ReOpen;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Status:=Status::Open;
                                 MODIFY
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760005;1;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1102755006;1;Field  ;
                SourceExpr=Source;
                Visible=FAlse;
                Editable=SourceEditable }

    { 1102760032;1;Field  ;
                SourceExpr="Batch Type";
                Editable=FALSE }

    { 1102760003;1;Field  ;
                SourceExpr="Description/Remarks";
                Editable=DescriptionEditable }

    { 1102755000;1;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102760019;1;Field  ;
                SourceExpr="Total Net Refund Amount" }

    { 1102760029;1;Field  ;
                SourceExpr="No of Withdrawals" }

    { 1102760011;1;Field  ;
                SourceExpr="Mode Of Disbursement";
                Editable=ModeofDisburementEditable;
                OnValidate=BEGIN
                             {IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                             "Cheque No.":="Batch No.";
                             MODIFY;  }
                             IF "Mode Of Disbursement"<>"Mode Of Disbursement"::"2" THEN
                             "Cheque No.":="Batch No.";
                             MODIFY;
                           END;
                            }

    { 1102760013;1;Field  ;
                SourceExpr="Document No.";
                Editable=DocumentNoEditable;
                OnValidate=BEGIN
                             {IF STRLEN("Document No.") > 6 THEN
                               ERROR('Document No. cannot contain More than 6 Characters.');
                               }
                           END;
                            }

    { 1102760009;1;Field  ;
                SourceExpr="Posting Date";
                Editable=PostingDateEditable }

    { 1102760015;1;Field  ;
                CaptionML=ENU=Paying Bank;
                SourceExpr="BOSA Bank Account";
                Visible=false;
                Editable=PayingAccountEditable }

    { 1000000000;1;Field  ;
                Name=Cheque No.;
                SourceExpr=LoansBatch."Cheque No.";
                Visible=false;
                Editable=ChequeNoEditable }

    { 1000000001;1;Field  ;
                SourceExpr="Prepared By" }

    { 1102755001;1;Part   ;
                Name=Withdrawal Sub-Page List;
                SubPageLink=Batch No.=FIELD(Batch No.);
                PagePartID=Page51516409;
                Editable=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      Text001@1102755004 : TextConst 'ENU=Status must be open';
      Generalsetup@1120054003 : Record 51516257;
      UserSetup@1120054004 : Record 91;
      LoansR@1120054012 : Record 51516230;
      "AMOUNTTO BE RECOVERED"@1120054013 : Decimal;
      Interestrecovery@1120054016 : Decimal;
      TotalLoansOut@1120054014 : Decimal;
      "Remaining Amount"@1120054015 : Decimal;
      Totalrecovered@1120054005 : Decimal;
      TotalInsuarance@1120054006 : Decimal;
      Lprinciple@1120054017 : Decimal;
      RunBal@1120054007 : Decimal;
      runbal1@1120054008 : Decimal;
      TotalAmount@1120054009 : Decimal;
      TotalOustanding@1120054010 : Decimal;
      TotalAdd@1120054011 : Decimal;
      MovementTracker@1132 : Record 51516254;
      FileMovementTracker@1131 : Record 51516254;
      NextStage@1130 : Integer;
      EntryNo@1129 : Integer;
      NextLocation@1128 : Text[100];
      LoansBatch@1127 : Record 51516236;
      MembWith@1120054002 : Record 51516259;
      i@1126 : Integer;
      LoanType@1125 : Record 51516240;
      PeriodDueDate@1124 : Date;
      ScheduleRep@1123 : Record 51516234;
      RunningDate@1122 : Date;
      G@1121 : Integer;
      IssuedDate@1120 : Date;
      GracePeiodEndDate@1119 : Date;
      InstalmentEnddate@1118 : Date;
      GracePerodDays@1117 : Integer;
      InstalmentDays@1116 : Integer;
      NoOfGracePeriod@1115 : Integer;
      NewSchedule@1114 : Record 51516234;
      RSchedule@1113 : Record 51516234;
      GP@1112 : Text[30];
      ScheduleCode@1111 : Code[20];
      PreviewShedule@1110 : Record 51516234;
      PeriodInterval@1109 : Code[10];
      CustomerRecord@1108 : Record 51516223;
      Gnljnline@1107 : Record 81;
      Jnlinepost@1106 : Codeunit 12;
      CumInterest@1105 : Decimal;
      NewPrincipal@1104 : Decimal;
      PeriodPrRepayment@1103 : Decimal;
      GenBatch@1102 : Record 232;
      LineNo@1101 : Integer;
      GnljnlineCopy@1100 : Record 81;
      NewLNApplicNo@1099 : Code[10];
      Cust@1098 : Record 51516223;
      LoanApp@1097 : Record 51516230;
      TestAmt@1096 : Decimal;
      CustRec@1095 : Record 51516223;
      CustPostingGroup@1094 : Record 92;
      GenSetUp@1093 : Record 51516257;
      PCharges@1092 : Record 51516242;
      TCharges@1091 : Decimal;
      LAppCharges@1090 : Record 51516244;
      Loans@1089 : Record 51516230;
      LoanAmount@1088 : Decimal;
      InterestRate@1087 : Decimal;
      RepayPeriod@1086 : Integer;
      LBalance@1085 : Decimal;
      RunDate@1084 : Date;
      InstalNo@1083 : Decimal;
      RepayInterval@1082 : DateFormula;
      TotalMRepay@1081 : Decimal;
      LInterest@1080 : Decimal;
      LPrincipal@1079 : Decimal;
      RepayCode@1078 : Code[40];
      GrPrinciple@1077 : Integer;
      GrInterest@1076 : Integer;
      QPrinciple@1075 : Decimal;
      QCounter@1074 : Integer;
      InPeriod@1073 : DateFormula;
      InitialInstal@1072 : Integer;
      InitialGraceInt@1071 : Integer;
      GenJournalLine@1070 : Record 81;
      FOSAComm@1069 : Decimal;
      BOSAComm@1068 : Decimal;
      GLPosting@1067 : Codeunit 12;
      LoanTopUp@1066 : Record 51516235;
      Vend@1065 : Record 23;
      BOSAInt@1064 : Decimal;
      TopUpComm@1063 : Decimal;
      DActivity@1062 : Code[20];
      DBranch@1061 : Code[20];
      UsersID@1060 : Record 2000000120;
      TotalTopupComm@1059 : Decimal;
      Notification@1058 : Codeunit 397;
      CustE@1057 : Record 51516223;
      DocN@1056 : Text[50];
      DocM@1055 : Text[100];
      DNar@1054 : Text[250];
      DocF@1053 : Text[50];
      MailBody@1052 : Text[250];
      ccEmail@1051 : Text[250];
      LoanG@1050 : Record 51516231;
      SpecialComm@1049 : Decimal;
      LoanApps@1048 : Record 51516230;
      Banks@1047 : Record 270;
      BatchTopUpAmount@1046 : Decimal;
      BatchTopUpComm@1045 : Decimal;
      TotalSpecialLoan@1044 : Decimal;
      SpecialLoanCl@1043 : Record 51516238;
      Loans2@1042 : Record 51516230;
      DActivityBOSA@1041 : Code[20];
      DBranchBOSA@1040 : Code[20];
      Refunds@1039 : Record 51516240;
      TotalRefunds@1038 : Decimal;
      WithdrawalFee@1037 : Decimal;
      NetPayable@1036 : Decimal;
      NetRefund@1035 : Decimal;
      FWithdrawal@1034 : Decimal;
      OutstandingInt@1033 : Decimal;
      TSC@1032 : Decimal;
      LoanDisbAmount@1031 : Decimal;
      NegFee@1030 : Decimal;
      DValue@1029 : Record 349;
      ChBank@1028 : Code[20];
      Trans@1027 : Record 51516299;
      TransactionCharges@1026 : Record 51516300;
      BChequeRegister@1025 : Record 51516313;
      OtherCommitments@1024 : Record 51516262;
      BoostingComm@1023 : Decimal;
      BoostingCommTotal@1022 : Decimal;
      BridgedLoans@1021 : Record 51516238;
      InterestDue@1020 : Decimal;
      ContractualShares@1019 : Decimal;
      BridgingChanged@1018 : Boolean;
      BankersChqNo@1017 : Code[20];
      LastPayee@1016 : Text[100];
      RunningAmount@1015 : Decimal;
      BankersChqNo2@1014 : Code[20];
      BankersChqNo3@1013 : Code[20];
      EndMonth@1012 : Date;
      RemainingDays@1011 : Integer;
      PrincipalRepay@1010 : Decimal;
      InterestRepay@1009 : Decimal;
      TMonthDays@1008 : Integer;
      SMSMessage@1007 : Record 51516232;
      iEntryNo@1006 : Integer;
      Temp@1005 : Record 18;
      Jtemplate@1004 : Code[30];
      JBatch@1003 : Code[30];
      LBatches@1002 : Record 51516236;
      ApprovalMgt@1001 : Codeunit 439;
      DocumentType@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank,Withdrawal Batch';
      DescriptionEditable@1134 : Boolean;
      ModeofDisburementEditable@1135 : Boolean;
      DocumentNoEditable@1136 : Boolean;
      PostingDateEditable@1137 : Boolean;
      SourceEditable@1138 : Boolean;
      PayingAccountEditable@1139 : Boolean;
      ChequeNoEditable@1140 : Boolean;
      ChequeNameEditable@1141 : Boolean;
      upfronts@1142 : Decimal;
      EmergencyInt@1143 : Decimal;
      Table_id@1146 : Integer;
      Doc_No@1145 : Code[20];
      Doc_Type@1144 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening,Member Closure,Loan,Loan Batch,Withdrawal Batch';
      Deductions@1000000000 : Decimal;
      BatchBoostingCom@1000000001 : Decimal;
      HisaRepayment@1000000002 : Decimal;
      HisaLoan@1000000003 : Record 51516230;
      BatchHisaRepayment@1000000004 : Decimal;
      BatchFosaHisaComm@1000000005 : Decimal;
      BatchHisaShareBoostComm@1000000006 : Decimal;
      BatchShareCap@1000000007 : Decimal;
      BatchIntinArr@1000000008 : Decimal;
      Loaninsurance@1000000009 : Decimal;
      TLoaninsurance@1000000010 : Decimal;
      ProductCharges@1000000011 : Record 51516242;
      InsuranceAcc@1000000012 : Code[20];
      PTEN@1000000013 : Code[20];
      LoanTypes@1000000014 : Record 51516240;
      Customer@1000000015 : Record 51516223;
      DataSheet@1000000016 : Record 51516341;
      TotBoost@1000000017 : Decimal;
      ShareAmount@1000000018 : Decimal;
      Commitm@1000000019 : Decimal;
      Scharge@1000000020 : Decimal;
      EftAmount@1000000021 : Decimal;
      EFTDeduc@1000000022 : Decimal;
      linecharges@1000000023 : Decimal;
      ApprovalsMgmt@1000000024 : Codeunit 1535;
      interestDays@1120054000 : Integer;
      Chargeinterest@1120054001 : Boolean;
      MWithdrawal@1120054018 : Record 51516259;
      RunningBal@1120054019 : Integer;
      Memb@1120054020 : Record 51516223;

    PROCEDURE UpdateControl@1102755002();
    BEGIN
      IF Status=Status::Open THEN BEGIN
      DescriptionEditable:=TRUE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=TRUE;
      PayingAccountEditable:=TRUE;
      ChequeNoEditable:=FALSE;
      ChequeNameEditable:=FALSE;
      END;

      IF Status=Status::"Pending Approval" THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=FALSE;
      PayingAccountEditable:=FALSE;
      ChequeNoEditable:=FALSE;
      ChequeNameEditable:=FALSE;

      END;

      IF Status=Status::Rejected THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=FALSE;
      PayingAccountEditable:=FALSE;
      ChequeNoEditable:=FALSE;
      ChequeNameEditable:=FALSE;
      END;

      IF Status=Status::Approved THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=TRUE;
      DocumentNoEditable:=TRUE;
      SourceEditable:=FALSE;
      PostingDateEditable:=TRUE;
      PayingAccountEditable:=TRUE;//FALSE;
      ChequeNoEditable:=TRUE;
      ChequeNameEditable:=TRUE;

      END;
    END;

    LOCAL PROCEDURE RecoverSharecapital@1120054033(MemberNo@1120054000 : Code[50]);
    VAR
      minSharescapital@1120054001 : Decimal;
      difShareamount@1120054002 : Decimal;
    BEGIN
      IF Cust.GET(MemberNo) THEN BEGIN
        Cust.CALCFIELDS(Cust."Outstanding Balance","Accrued Interest","Current Shares",Cust."School Fees Shares",Cust."Shares Retained");
        Generalsetup.GET();
        minSharescapital:=Generalsetup."Retained Shares";

      IF Cust."Shares Retained">=minSharescapital THEN
        difShareamount:=0
      ELSE
        difShareamount:=minSharescapital-Cust."Shares Retained";

      IF Cust."Current Shares">=difShareamount THEN BEGIN

      IF difShareamount >0 THEN BEGIN

        //.....................debit deposit
          LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='Closure';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Document No.":=MembWith."No.";
          GenJournalLine."Posting Date":=TODAY;
          GenJournalLine."External Document No.":=MembWith."Cheque No.";
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
          GenJournalLine."Account No.":=MembWith."Member No.";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
          GenJournalLine.Description:='Deposit capitalization ' + MembWith."No.";
          GenJournalLine.Amount:=(difShareamount);
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
          GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;

      // credit shares
         LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='Closure';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Document No.":=MembWith."No.";
          GenJournalLine."Posting Date":=TODAY;
          GenJournalLine."External Document No.":="Cheque No.";
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
          GenJournalLine."Account No.":=MembWith."Member No.";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
          GenJournalLine.Description:='Deposit capitalization' + MembWith."No.";
          GenJournalLine.Amount:=-(difShareamount);
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
          GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
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
    END;

    LOCAL PROCEDURE FnTrancheDisbursement@1120054004(Document@1120054000 : Code[10];DisbursementAmount@1120054004 : Decimal);
    VAR
      MembWith@1120054001 : Record 51516259;
      Entry@1120054002 : Integer;
      PartEntry@1120054003 : Record 51516917;
      CShares@1120054005 : Decimal;
      RunBal@1120054006 : Decimal;
    BEGIN
      MembWith.RESET;
      MembWith.SETRANGE(MembWith."No.",Document);
      IF MembWith.FINDFIRST THEN BEGIN

      Entry:=1;
      IF PartEntry.FINDLAST THEN
      Entry:=PartEntry."Entry No"+1
      ELSE
      Entry:=Entry;
      PartEntry.INIT;
      PartEntry."Entry No":=Entry;
      PartEntry."Client Number":=MembWith."Member No.";
      PartEntry."Amount Disbursed":=MembWith."Amount to Refund";
      PartEntry."Date Disbursed":=TODAY;
      PartEntry."Document No":=MembWith."No.";
      PartEntry.INSERT;

      RunningBal:=MembWith."Amount to Refund";

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
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
      GenJournalLine.Description:='Membership Withdrawal' + MembWith."No.";
      GenJournalLine.Amount:=DisbursementAmount-Generalsetup."Withdrawal Fee";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
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
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      // credit GL Membership withdrawal fee
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='Closure';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=Memb."No.";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."External Document No.":="Cheque No.";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No.":=Generalsetup."Withdrawal Fee Account";;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");;
      GenJournalLine.Description:='Charge membership withdrawal' + MembWith."No.";
      GenJournalLine.Amount:=Generalsetup."Withdrawal Fee";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      END;
      END;
    END;

    BEGIN
    END.
  }
}

