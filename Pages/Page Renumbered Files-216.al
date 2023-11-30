OBJECT page 17407 Membership Withdrawal Card
{
  OBJECT-PROPERTIES
  {
    Date=07/06/23;
    Time=11:32:36 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    InsertAllowed=Yes;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516259;
    SourceTableView=WHERE(Posted=FILTER(No),
                          Withdrawal Status=FILTER(Processed),
                          Registered=CONST(Yes));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption;
    OnAfterGetCurrRecord=BEGIN
                           PostActivated:=FALSE;
                           IF Status=Status::Approved THEN
                           PostActivated:=TRUE;
                           ReportEnabled:=TRUE;
                           IF Status=Status::Pending THEN
                           ReportEnabled:=FALSE;
                           UpdateControl();
                         END;

    ActionList=ACTIONS
    {
      { 1102755010;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755011;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1102755006;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"Member Closure";
                                 ApprovalEntries.Setfilters(DATABASE::"Payroll Employer Deductions",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755008;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                 { //MESSAGE('aszdfxcghjbkn');
                                  TESTFIELD("Batch No.");
                                 IF ClosureR.GET(ClosureR."Member No.") THEN
                                   IF ClosureR."Closure Type"=ClosureR."Closure Type"::Notice THEN
                                       TESTFIELD("Notice Date");
                                    BEGIN

                                 IF Status<>Status::Open THEN
                                 ERROR(text001);

                                 TESTFIELD("Guarantorship Check",TRUE);
                                   //MESSAGE('aszdfxcghjbkn');

                                       {TotGuaranteed:=0;
                                       Loanguara.RESET;
                                       Loanguara.SETRANGE(Loanguara."Member No",ClosureR."Member No.");
                                       Loanguara.SETRANGE(Loanguara.Substituted,FALSE);
                                       IF Loanguara.FIND('-') THEN
                                       REPEAT
                                         IF Loanguara."Member No"="Member No."THEN
                                         Loanguara.CALCFIELDS(Loanguara."Outstanding Balance");
                                            IF Loanguara."Outstanding Balance">0 THEN BEGIN
                                              IF Loanguara.Substituted=FALSE THEN BEGIN
                                                 TotGuaranteed:=TotGuaranteed+Loanguara."Amont Guaranteed";
                                                 END;
                                               END;
                                            UNTIL Loanguara.NEXT=0;

                                             MESSAGE('Guaranteed amount %1',TotGuaranteed);

                                             IF TotGuaranteed>0 THEN

                                              IF  "Closure Type"="Closure Type"::Notice THEN BEGIN
                                               ERROR('You must find substitute guarantor for loans you guaranteed before exiting %1',TotGuaranteed);
                                             END;}
                                   END;

                                  //  MESSAGE('aszdfxcghjbkn %1',ClosureR."Closure Type");
                                 //End allocate batch number
                                 Doc_Type:=Doc_Type::"Member Closure";
                                 Table_id:=DATABASE::"Membership Withdrawals";
                                 //MESSAGE('Proceed');
                                 IF ApprovalMgmt.CheckMWithdrawalApprovalWorkflowEnabled(Rec) THEN
                                   ApprovalMgmt.OnSendMWithdrawalForApproval(Rec);

                                 //MESSAGE('Proceed');

                                 {Status:=Status::Approved;
                                 MESSAGE('approved succesful');
                                 }
                                 }
                                 IF CONFIRM('Move to approved List?',TRUE,FALSE)=TRUE THEN BEGIN
                                 IF ApprovalMgmt.CheckMWithdrawalApprovalWorkflowEnabled(Rec) THEN
                                   ApprovalMgmt.OnSendMWithdrawalForApproval(Rec);
                                 // Status:=Status::Approved;
                                 // "Approved By":=USERID;
                                 // MODIFY;
                                 END;
                               END;
                                }
      { 1102755002;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel A&pproval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                    IF (Status = Status::Open ) THEN
                                       ERROR(Text002);


                                  IF ApprovalMgmt.CheckMWithdrawalApprovalWorkflowEnabled(Rec) THEN
                                   ApprovalMgmt.OnCancelMWithdrawalApprovalRequest(Rec);

                               END;
                                }
      { 1102755004;2 ;Action    ;
                      Name=Account closure Slip;
                      Promoted=Yes;
                      Enabled=ReportEnabled;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 IF "Closure Type"<>"Closure Type"::Death THEN BEGIN
                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN
                                 REPORT.RUN(51516250,TRUE,FALSE,cust);
                                 END ELSE IF "Closure Type"="Closure Type"::Death THEN BEGIN
                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN
                                 REPORT.RUN(51516630,TRUE,FALSE,cust);
                                 END;
                                 {
                                 ClosureR.RESET;
                                 ClosureR.SETRANGE(ClosureR."Member No.","Member No.");
                                 IF ClosureR.FIND('-') THEN
                                 REPORT.RUN(51516250,TRUE,FALSE,cust);
                                 }
                               END;
                                }
      { 1102755021;2 ;Action    ;
                      Name=Print Cheque;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 ClosureR.RESET;
                                 ClosureR.SETRANGE(ClosureR."Member No.","Member No.");
                                 IF ClosureR.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,ClosureR);
                                 }
                               END;
                                }
      { 1102755012;2 ;Action    ;
                      Name=Post;
                      CaptionML=ENU=Post;
                      Promoted=Yes;
                      Visible=True;
                      Enabled=PostActivated;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LineNo:=0;
                                 {IF TODAY-"Date Registered" > 60 THEN BEGIN
                                   ERROR('The Registration Period has elapsed');
                                 END;
                                 }

                                 UserSetup.RESET;
                                 UserSetup.SETRANGE(UserSetup."User ID",USERID);
                                 UserSetup.SETRANGE(UserSetup."Membership Withdrawal",FALSE);
                                 IF UserSetup.FIND('-') THEN BEGIN
                                 IF "Closure Type"<>"Closure Type"::Death THEN
                                 ERROR('Used Only For Death Closure.');
                                 {IF "Closure Type"<>"Closure Type"::Death THEN
                                 ERROR('You do not have the rights to withdraw member');

                                 {IF Status<>Status::Approved THEN
                                       ERROR('The Application must be approved');}

                                 IF ("Total Loan"+"Total Interest")>"Member Deposits" THEN
                                   ERROR('The member does not have enough deposits to clear loan');

                                 IF CONFIRM('Are you absolutely sure you want to recover the loans from member deposit') = FALSE THEN
                                 EXIT;
                                 END;
                                 IF cust.GET("Member No.") THEN BEGIN
                                 IF ("Closure Type"="Closure Type"::Notice ) OR ("Closure Type"="Closure Type"::Expulsion )  //OR ("Closure Type"="Closure Type"::Death)
                                    THEN BEGIN
                                 //cust."Withdrawal Fee":=1000;

                                 //Delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'Closure');
                                 Gnljnline.DELETEALL;
                                 //End of deletion

                                 RecoverSharecapital("Member No.");

                                 Totalrecovered:=0;
                                 TotalInsuarance:=0;
                                 RunBal:=0;
                                 runbal1:=0;
                                 TotalAmount:=0;
                                 DActivity:=cust."Global Dimension 1 Code";
                                 DBranch:=cust."Global Dimension 2 Code";
                                 cust.CALCFIELDS(cust."Outstanding Balance","Accrued Interest","Current Shares",cust."School Fees Shares");

                                 cust.CALCFIELDS(cust."Outstanding Balance",cust."Outstanding Interest","FOSA Outstanding Balance","Accrued Interest","Insurance Fund",cust."Current Shares",cust."School Fees Shares");
                                 TotalOustanding:=cust."Outstanding Balance"+cust."Outstanding Interest";
                                 RunBal:=cust."Current Shares"+cust."School Fees Shares";
                                 //GETTING WITHDRWAL FEE
                                 Generalsetup.GET();
                                 cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                 // END OF GETTING WITHDRWAL FEE
                                 IF Generalsetup."Withdrawal Fee">0 THEN BEGIN
                                 LineNo:=LineNo+100000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":="Member No.";
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

                                 {
                                 IF RunBal > 0 THEN BEGIN
                                 //withdrawal commision
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=Generalsetup."Withdrawal Fee Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Withdrawal commision';
                                 GenJournalLine.Amount:=-Generalsetup."Withdrawal Commision";
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
                                 }

                                 IF RunBal > 0 THEN BEGIN
                                 //excise duty on withdrawal
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
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
                                 LoansR.SETRANGE(LoansR."Client Code","Member No.");
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF RunBal > 0 THEN BEGIN
                                     "AMOUNTTO BE RECOVERED":=0;

                                     LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");

                                     Linterest:="Total Interest";

                                     // clear .................Loan Insurance
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='Closure';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="No.";
                                     GenJournalLine."Posting Date":=TODAY;
                                     GenJournalLine."External Document No.":="No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":="Member No.";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Cleared by deposits: ' + "No.";
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
                                 cust."Closing Deposit Balance":=(cust."Closing Deposit Balance"-LoansR."Loans Insurance");

                                 TotalLoansOut:=0;
                                 //Capitalize Interest to Loans
                                 IF RunBal > 0 THEN BEGIN
                                 "Remaining Amount":=cust."Closing Deposit Balance";

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","Member No.");
                                 //LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF RunBal > 0 THEN BEGIN
                                   "AMOUNTTO BE RECOVERED":=0;
                                   Interestrecovery:=0;
                                   LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");
                                   Linterest:=LoansR."Oustanding Interest";
                                   Interestrecovery:=LoansR."Oustanding Interest";

                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":="No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":="No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":="Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine.Description:='Interest Offset: ' + "No.";
                                   IF RunBal < Linterest THEN
                                   GenJournalLine.Amount:=-1*RunBal
                                   ELSE
                                   GenJournalLine.Amount:=-1*Linterest;
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
                                 LoansR.SETRANGE(LoansR."Client Code","Member No.");
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
                                     GenJournalLine."Document No.":="No.";
                                     GenJournalLine."Posting Date":=TODAY;
                                     GenJournalLine."External Document No.":="No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":="Member No.";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Loan Cleared by deposits: ' + "No.";
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
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":="Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Loans Recovered From Shares: ' + "No.";
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
                                 cust."Closing Deposit Balance":=(cust."Closing Deposit Balance"-TotalLoansOut);
                                 TotalAmount:=TotalAmount*-1;
                                 //AMOUNT PAYABLE TO THE MEMBER
                                 END;

                                 IF RunBal >0 THEN BEGIN
                                 //***DEBIT PAYING BANK MEMBER
                                   Generalsetup.GET();
                                   cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                   IF Vend.GET("FOSA Account No.") THEN BEGIN
                                     Vend.CALCFIELDS(Vend.Balance);
                                   LineNo:=LineNo+10000;
                                   GenJournalLine.INIT;
                                   GenJournalLine."Journal Template Name":='GENERAL';
                                   GenJournalLine."Journal Batch Name":='Closure';
                                   GenJournalLine."Line No.":=LineNo;
                                   GenJournalLine."Document No.":="No.";
                                   GenJournalLine."Posting Date":=TODAY;
                                   GenJournalLine."External Document No.":="Cheque No.";
                                   GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                   GenJournalLine."Account No.":="Member No.";
                                   GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                   GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                   GenJournalLine.Description:='Membership Withdrawal' + "No.";
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
                                 cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                 IF Vend.GET("FOSA Account No.") THEN BEGIN
                                   Vend.CALCFIELDS(Vend.Balance);
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=Vend."No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Withdrawal;
                                 GenJournalLine.Description:='Membership Withdrawal' + "No.";
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
                                 END;}
                                 END;

                                 //**********************************Death Withdrawal************************************
                                 IF cust.GET("Member No.") THEN BEGIN
                                 IF ("Closure Type"="Closure Type"::Death)
                                 THEN BEGIN
                                 cust.CALCFIELDS(cust."Benevolent Fund");
                                 IF cust."Benevolent Fund">0 THEN
                                 //Delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'Closure');
                                 Gnljnline.DELETEALL;

                                 IF cust.CALCFIELDS(cust."Shares Retained","Current Shares","School Fees Shares") THEN
                                 //*********************School Fees Shares*****************************
                                 IF "School Fees Shares">0 THEN BEGIN
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"SchFee Shares";
                                 GenJournalLine."Account No.":=cust."No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='School Fees Shares' + "No.";
                                 GenJournalLine.Amount:=cust."School Fees Shares";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
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
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=cust."FOSA Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='School Fees Shares' + "No.";
                                 GenJournalLine.Amount:=-cust."School Fees Shares";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;


                                 //**********************Shares Refund****************
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='200-000-170';
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Shares Refund from Benovelent' + "No.";
                                 GenJournalLine.Amount:=cust."Current Shares";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
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
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=cust."FOSA Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Shares Refund from Benovelent' + "No.";
                                 GenJournalLine.Amount:=-cust."Current Shares";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //************************Deposits Refund*************
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":=cust."No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Deposits Refund ' + "No.";
                                 GenJournalLine.Amount:=cust."Current Shares";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
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
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=cust."FOSA Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Deposits Refund To FOSA ' + "No.";
                                 GenJournalLine.Amount:=-cust."Current Shares";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //*********************Loans Payment*********************

                                 Loans.RESET;
                                 Loans.SETRANGE(Loans."BOSA No",cust."No.");
                                 IF Loans.FIND('-') THEN BEGIN
                                 REPEAT
                                 Loans.CALCFIELDS(Loans."Outstanding Balance");
                                 IF Loans."Outstanding Balance">0 THEN BEGIN
                                 //MESSAGE('Client%1LoanBal%2',cust."No.",Loans."Outstanding Balance");
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='200-000-170';
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Benevolent Loan repayment ' + Loans."Loan Product Type Name";
                                 GenJournalLine.Amount:=Loans."Outstanding Balance";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Loan No":=Loans."Loan  No.";
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
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                 GenJournalLine."Account No.":=cust."No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Loan Repayment  ' + "No."+Loans."Loan Product Type Name";
                                 GenJournalLine.Amount:=-Loans."Outstanding Balance";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Loan No":=Loans."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;
                                 UNTIL Loans.NEXT=0;
                                 END;

                                 Loans.RESET;
                                 Loans.SETRANGE(Loans."BOSA No",cust."No.");
                                 IF Loans.FIND('-') THEN BEGIN
                                 REPEAT
                                 Loans.CALCFIELDS(Loans."Oustanding Interest");
                                 IF Loans."Oustanding Interest">0 THEN BEGIN
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='200-000-170';
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Benevolent Interest repayment ' + Loans."Loan Product Type Name";
                                 GenJournalLine.Amount:=Loans."Oustanding Interest";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Loan No":=Loans."Loan  No.";
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
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                 GenJournalLine."Account No.":=cust."No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Interest Repayment  ' + "No."+Loans."Loan Product Type Name";
                                 GenJournalLine.Amount:=-Loans."Oustanding Interest";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Loan No":=Loans."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;
                                 UNTIL Loans.NEXT=0;
                                 END;
                                 END;
                                 END;


                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Closure');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;
                                 "Closing Date":=TODAY;
                                  Posted:=TRUE;
                                 "Posted By":=USERID;
                                 "Member Deposits":=cust."Current Shares";
                                 "Withdrawal Status":="Withdrawal Status"::Posted;
                                 MODIFY;
                                 MESSAGE('Closure posted successfully.');


                                 //CHANGE ACCOUNT STATUS
                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN BEGIN
                                 cust.Status:=cust.Status::Withdrawal;
                                 //cust.Blocked:=cust.Blocked::All;
                                 cust.MODIFY;
                                 END;

                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN
                                 REPORT.RUN(51516250,FALSE,FALSE,cust);
                               END;
                                }
      { 1000000001;2 ;Action    ;
                      Name=RE-OPEN;
                      OnAction=BEGIN
                                 Status:=Status::Open;
                                 MODIFY;
                               END;
                                }
      { 1120054007;2 ;Action    ;
                      Name=[Calculate ];
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Calculate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN BEGIN
                                  cust.CALCFIELDS(cust."Outstanding Balance",cust."Outstanding Interest",cust."Current Savings");
                                 "Total Loan":=cust."Outstanding Balance";
                                 "Total Interest":=cust."Outstanding Interest";
                                 "Member Deposits":=cust."Current Savings";

                                 END;
                               END;
                                }
      { 1120054006;2 ;Action    ;
                      Name=Detailed Statement;
                      CaptionML=ENU=Detailed Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Custs.RESET;
                                 Custs.SETRANGE(Custs."No.","Member No.");
                                 IF Custs.FIND('-') THEN
                                 REPORT.RUN(51516223,TRUE,FALSE,Custs);
                               END;
                                }
      { 1120054008;2 ;Action    ;
                      Name=Member is  a Guarantor;
                      CaptionML=ENU=Member is  a Guarantor;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Custs.RESET;
                                 Custs.SETRANGE(Custs."No.","Member No.");
                                 IF Custs.FIND('-') THEN
                                 REPORT.RUN(51516226,TRUE,FALSE,Custs);
                               END;
                                }
      { 1120054011;2 ;Action    ;
                      Name=Check Guarantorship;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CheckList;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF "Closure Type"<>"Closure Type"::Death THEN BEGIN
                                 Loanguara.RESET;
                                 Loanguara.SETRANGE(Loanguara."Member No","Member No.");
                                 Loanguara.SETFILTER(Loanguara."Outstanding Balance",'>0');
                                 Loanguara.SETRANGE(Loanguara.Substituted,FALSE);
                                   IF Loanguara.FIND('-') THEN BEGIN
                                     ERROR('You must find substitute guarantor for loans you guaranteed before exiting')
                                   END;
                                 MESSAGE('Member has no guaranteed loans. Send for approval');

                                  "Guarantorship Check":=TRUE;
                                 END;
                                 IF "Closure Type"="Closure Type"::Death THEN BEGIN
                                 "Guarantorship Check":=TRUE;
                                 END;
                               END;
                                }
      { 1120054016;2 ;Action    ;
                      Name=Reverse Withdrawal;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReverseRegister;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD("Member No.");
                                 TESTFIELD(Registered,TRUE);


                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN BEGIN
                                   cust.Status:=cust.Status::Active;
                                   cust.MODIFY;
                                 END;
                                 Registered:=FALSE;
                                 "Withdrawal Status":="Withdrawal Status"::Initiated;
                                 MODIFY;
                               END;
                                }
      { 1120054024;2 ;Action    ;
                      Name=Cancel Withdrawal;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CancelLine;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to cancel this withdrawal?',TRUE,FALSE)=TRUE THEN BEGIN
                                 Status:=Status::Canceled;
                                 MODIFY;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 16  ;0   ;Container ;
                ContainerType=ContentArea }

    { 15  ;1   ;Group     ;
                CaptionML=ENU=General }

    { 14  ;2   ;Field     ;
                SourceExpr="No.";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                SourceExpr="Member No.";
                Editable=MNoEditable }

    { 12  ;2   ;Field     ;
                SourceExpr="Member Name";
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Payroll/Staff No";
                Editable=false }

    { 1120054001;2;Field  ;
                SourceExpr="ID No.";
                Editable=false }

    { 1120054015;2;Field  ;
                SourceExpr="Date Registered";
                Editable=false }

    { 10  ;2   ;Field     ;
                SourceExpr=Status;
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                SourceExpr="Closure Type" }

    { 1000000003;2;Field  ;
                SourceExpr="Notice Date";
                Enabled=DateEditable }

    { 11  ;2   ;Field     ;
                SourceExpr="Due Date";
                Editable=false }

    { 1120054002;2;Field  ;
                SourceExpr="Current Shares";
                Visible=false }

    { 1120054003;2;Field  ;
                SourceExpr="Outstanding Balance";
                Visible=false }

    { 1120054004;2;Field  ;
                SourceExpr="Outstanding Interest";
                Visible=false }

    { 1120054005;2;Field  ;
                SourceExpr="Principle Balance";
                Visible=false }

    { 8   ;2   ;Field     ;
                SourceExpr="Total Loan";
                Visible=true;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="Total Interest";
                Visible=true;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr="Member Deposits";
                Visible=true;
                Editable=FALSE }

    { 1120054018;2;Field  ;
                SourceExpr="School Fees Shares";
                Editable=false }

    { 1000000000;2;Field  ;
                SourceExpr="BBF Amount";
                Editable=true }

    { 5   ;2   ;Field     ;
                SourceExpr="Mode Of Disbursement" }

    { 1120054009;2;Field  ;
                SourceExpr="Net Pay";
                Visible=false }

    { 1120054017;2;Field  ;
                SourceExpr="Net Refund";
                Editable=false }

    { 1120054020;2;Field  ;
                SourceExpr="Disbursement Type" }

    { 1120054022;2;Field  ;
                SourceExpr="Number of Installments" }

    { 1120054021;2;Field  ;
                SourceExpr="Amount to Refund" }

    { 1120054019;2;Field  ;
                SourceExpr="Batch No." }

    { 4   ;2   ;Field     ;
                SourceExpr="Paying Bank";
                Visible=false }

    { 3   ;2   ;Field     ;
                SourceExpr="Cheque No." }

    { 2   ;2   ;Field     ;
                SourceExpr="FOSA Account No.";
                Editable=false }

    { 1120054012;2;Field  ;
                SourceExpr="Guarantorship Check" }

    { 1   ;2   ;Field     ;
                SourceExpr=Payee }

    { 1120054013;2;Field  ;
                SourceExpr="Withdrawal Status" }

    { 1120054023;2;Field  ;
                SourceExpr="Reason for Withdrawal";
                Editable=false }

    { 1120054014;2;Field  ;
                SourceExpr=Registered }

    { 1000000002;2;Field  ;
                SourceExpr="Captured By" }

    { 1120054010;1;Part   ;
                SubPageLink=Member No=FIELD(Member No.),
                            Outstanding Balance=FILTER(>0);
                PagePartID=Page51516247;
                Editable=false;
                PartType=Page }

  }
  CODE
  {
    VAR
      Closure@1102755000 : Integer;
      Text001@1102755001 : TextConst 'ENU=Not Approved';
      cust@1102755002 : Record 51516223;
      UBFRefund@1102755003 : Decimal;
      Generalsetup@1102755004 : Record 51516257;
      Totalavailable@1102755005 : Decimal;
      UnpaidDividends@1102755006 : Decimal;
      TotalOustanding@1102755007 : Decimal;
      Vend@1102755008 : Record 23;
      value2@1102755009 : Decimal;
      Gnljnline@1102755010 : Record 81;
      Totalrecovered@1102755011 : Decimal;
      Advice@1102755012 : Boolean;
      TotalDefaulterR@1102755013 : Decimal;
      AvailableShares@1102755014 : Decimal;
      Loans@1102755015 : Record 51516230;
      Value1@1102755016 : Decimal;
      Interest@1102755017 : Decimal;
      LineN@1102755018 : Integer;
      LRepayment@1102755019 : Decimal;
      Vendno@1102755020 : Code[20];
      DocumentType@1102755021 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff';
      MNoEditable@1102755022 : Boolean;
      ClosingDateEditable@1102755023 : Boolean;
      ClosureTypeEditable@1102755024 : Boolean;
      TotalFOSALoan@1102755025 : Decimal;
      TotalInsuarance@1102755026 : Decimal;
      DActivity@1102755027 : Code[30];
      DBranch@1102755028 : Code[30];
      LineNo@1102755029 : Integer;
      GenJournalLine@1102755030 : Record 81;
      "Remaining Amount"@1102755031 : Decimal;
      LoansR@1102755032 : Record 51516230;
      "AMOUNTTO BE RECOVERED"@1102755033 : Decimal;
      PrincipInt@1102755034 : Decimal;
      TotalLoansOut@1102755035 : Decimal;
      ClosureR@1102755036 : Record 51516259;
      Table_id@1002 : Integer;
      Doc_No@1001 : Code[20];
      Doc_Type@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening,Member Closure,Loan,Loan Batch';
      TotalAdd@1000000000 : Decimal;
      RunBal@1000000001 : Decimal;
      Linterest@1000000002 : Decimal;
      Lprinciple@1000000003 : Decimal;
      runbal1@1000000004 : Decimal;
      ApprovalMgmt@1000000005 : Codeunit 1535;
      DateEditable@1000000006 : Boolean;
      UserSetup@1000000007 : Record 91;
      Loanguara@1120054000 : Record 51516231;
      TotGuaranteed@1120054001 : Decimal;
      Custs@1120054002 : Record 51516223;
      Loanrecovery@1120054003 : Decimal;
      Interestrecovery@1120054004 : Decimal;
      TotalAmount@1120054005 : Decimal;
      Text002@1120054006 : TextConst 'ENU=This document has not been sent for approval yet';
      SharesN@1120054007 : Decimal;
      PostActivated@1120054008 : Boolean;
      ReportEnabled@1120054009 : Boolean;

    PROCEDURE UpdateControl@1102755001();
    BEGIN
      IF Status=Status::Open THEN BEGIN
      MNoEditable:=TRUE;
      ClosingDateEditable:=FALSE;
      ClosureTypeEditable:=TRUE;
      DateEditable:=TRUE;
      END;
      IF Status=Status::Pending THEN BEGIN
      MNoEditable:=FALSE;
      ClosingDateEditable:=FALSE;
      ClosureTypeEditable:=FALSE;
      DateEditable:=FALSE;
      END;

      IF Status=Status::Rejected THEN BEGIN
      MNoEditable:=FALSE;
      ClosingDateEditable:=FALSE;
      ClosureTypeEditable:=FALSE;
      DateEditable:=TRUE;
      END;

      IF Status=Status::Approved THEN BEGIN
      MNoEditable:=FALSE;
      ClosingDateEditable:=TRUE;
      ClosureTypeEditable:=FALSE;
      DateEditable:=FALSE;
      END;
    END;

    LOCAL PROCEDURE RecoverSharecapital@1120054033(MemberNo@1120054000 : Code[50]);
    VAR
      minSharescapital@1120054001 : Decimal;
      difShareamount@1120054002 : Decimal;
    BEGIN
      IF cust.GET(MemberNo) THEN BEGIN
        cust.CALCFIELDS(cust."Outstanding Balance","Accrued Interest","Current Shares",cust."School Fees Shares",cust."Shares Retained");
        Generalsetup.GET();
        minSharescapital:=Generalsetup."Retained Shares";

      IF cust."Shares Retained">=minSharescapital THEN
        difShareamount:=0
      ELSE
        difShareamount:=minSharescapital-cust."Shares Retained";

      IF cust."Current Shares">=difShareamount THEN BEGIN

      IF difShareamount >0 THEN BEGIN

        //.....................debit deposit
          LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='Closure';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Document No.":="No.";
          GenJournalLine."Posting Date":=TODAY;
          GenJournalLine."External Document No.":="Cheque No.";
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
          GenJournalLine."Account No.":="Member No.";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
          GenJournalLine.Description:='Deposit capitalization ' + "No.";
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
          GenJournalLine."Document No.":="No.";
          GenJournalLine."Posting Date":=TODAY;
          GenJournalLine."External Document No.":="Cheque No.";
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
          GenJournalLine."Account No.":="Member No.";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
          GenJournalLine.Description:='Deposit capitalization' + "No.";
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

    BEGIN
    END.
  }
}

