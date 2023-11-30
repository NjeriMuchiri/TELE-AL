OBJECT page 17425 Posted Member Withdrawal Card
{
  OBJECT-PROPERTIES
  {
    Date=03/25/22;
    Time=12:59:51 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516259;
    SourceTableView=WHERE(Posted=FILTER(Yes),
                          Registered=CONST(Yes),
                          Withdrawal Status=FILTER(Posted));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption;
    OnAfterGetCurrRecord=BEGIN
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
                                    IF Status<>Status::Open THEN
                                       ERROR(text001);

                                   //End allocate batch number
                                    //IF ApprovalMgt.SendClosurelRequest(Rec) THEN;
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
                                    IF Status<>Status::Open THEN
                                       ERROR(text001);

                                   //End allocate batch number
                                    //ApprovalMgt.CancelClosureApprovalRequest(Rec);
                               END;
                                }
      { 1102755004;2 ;Action    ;
                      Name=Account closure Slip;
                      Promoted=Yes;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN
                                 REPORT.RUN(51516250,TRUE,FALSE,cust);
                               END;
                                }
      { 1102755021;2 ;Action    ;
                      Name=Print Cheque;
                      Promoted=Yes;
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
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you absolutely sure you want to recover the loans from member deposit') = FALSE THEN
                                 EXIT;

                                 IF cust.GET("Member No.") THEN BEGIN
                                 IF ("Closure Type"="Closure Type"::Notice ) OR ("Closure Type"="Closure Type"::Expulsion ) THEN BEGIN
                                 cust."Withdrawal Fee":=1000;

                                 //Delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'Closure');
                                 Gnljnline.DELETEALL;
                                 //End of deletion


                                 Totalrecovered:=0;
                                 TotalInsuarance:=0;

                                 DActivity:=cust."Global Dimension 1 Code";
                                 DBranch:=cust."Global Dimension 2 Code";
                                 cust.CALCFIELDS(cust."Outstanding Balance","Accrued Interest","Current Shares");

                                 cust.CALCFIELDS(cust."Outstanding Balance",cust."Outstanding Interest","FOSA Outstanding Balance","Accrued Interest","Insurance Fund","Current Shares");
                                 TotalOustanding:=cust."Outstanding Balance"+cust."Outstanding Interest";

                                 //GETTING WITHDRWAL FEE
                                 Generalsetup.GET();
                                 cust."Withdrawal Fee":=Generalsetup."Withdrawal Fee";
                                 // END OF GETTING WITHDRWAL FEE

                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 Totalrecovered:=Totalrecovered+GenJournalLine.Amount;
                                 cust."Closing Deposit Balance":=(cust."Current Shares"-cust."Withdrawal Fee");



                                 IF cust."Closing Deposit Balance" > 0 THEN BEGIN
                                 "Remaining Amount":=cust."Closing Deposit Balance";

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","Member No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
                                 TotalInsuarance:=TotalInsuarance+LoansR."Loans Insurance";
                                 UNTIL LoansR.NEXT=0;
                                 END;
                                 END;

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","Member No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 "AMOUNTTO BE RECOVERED":=0;
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");



                                 //Loan Insurance
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 UNTIL LoansR.NEXT=0;
                                 END;

                                 cust."Closing Deposit Balance":=(cust."Closing Deposit Balance"-LoansR."Loans Insurance");


                                 //Capitalize Interest to Loans
                                 IF cust."Closing Deposit Balance" > 0 THEN BEGIN
                                 "Remaining Amount":=cust."Closing Deposit Balance";

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","Member No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 "AMOUNTTO BE RECOVERED":=0;

                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":="Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Interest Capitalized: ' + "No.";
                                 GenJournalLine.Amount:=-ROUND(LoansR."Oustanding Interest");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
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
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":="Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Interest Capitalized: ' + "No.";
                                 GenJournalLine.Amount:=ROUND(LoansR."Oustanding Interest");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 UNTIL LoansR.NEXT=0;
                                 END;
                                 END;
                                 ////End of Capitalize Interest to Loans




                                 //GET LOANS TO RECOVER

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","Member No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
                                 IF LoansR."Outstanding Balance">0 THEN BEGIN
                                 //Loans Outstanding
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":="Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Cleared by deposits: ' + "No.";
                                 GenJournalLine.Amount:=-ROUND(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 TotalLoansOut:="Total Loan"+"Total Interest";
                                 END;
                                 UNTIL LoansR.NEXT=0;
                                 END;

                                 //RECOVER LOANS FROM DEPOIST
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 cust."Closing Deposit Balance":=(cust."Closing Deposit Balance"-TotalLoansOut);


                                 //AMOUNT PAYABLE TO THE MEMBER
                                 IF cust."Closing Deposit Balance">0 THEN BEGIN

                                 //***DEBIT MEMBER DEPOSITS
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":="Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Account Closure No: ' + "No.";
                                 GenJournalLine.Amount:=cust."Closing Deposit Balance";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //***CREDIT PAYING BANK
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="Paying Bank";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Account Closure No: ' + "No.";
                                 GenJournalLine.Amount:=-cust."Closing Deposit Balance";
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




                                 //ACCOUNT CLOSURE-DEATH

                                 IF "Closure Type"="Closure Type"::Death THEN BEGIN
                                 //Transfer Deposits
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 IF "Mode Of Disbursement"="Mode Of Disbursement"::"FOSA Transfer" THEN
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 GenJournalLine."Account No.":=cust."FOSA Account";

                                 IF "Mode Of Disbursement"="Mode Of Disbursement"::Cheque THEN
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="Paying Bank";

                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Member Withdrawal'+' '+"Member No.";
                                 GenJournalLine.Amount:=-("Member Deposits");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;



                                 //Deposit
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":="Member No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Membership Closure';
                                 GenJournalLine.Amount:="Member Deposits";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;



                                 //Funeral Expense
                                 Generalsetup.GET();

                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Closure';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="Paying Bank";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Member Withdrawal(Death)'+' '+"Member No.";
                                 GenJournalLine.Amount:=-Generalsetup."Funeral Expense Amount";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=Generalsetup."Funeral Expenses Account";
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;





                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Closure');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;



                                 MESSAGE('Closure posted successfully.');


                                 //CHANGE ACCOUNT STATUS
                                 cust.RESET;
                                 cust.SETRANGE(cust."No.","Member No.");
                                 IF cust.FIND('-') THEN BEGIN
                                 cust.Status:=cust.Status::Withdrawal;
                                 cust.Blocked:=cust.Blocked::All;
                                 cust.MODIFY;
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
                SourceExpr="Payroll/Staff No" }

    { 1120054001;2;Field  ;
                SourceExpr="ID No." }

    { 11  ;2   ;Field     ;
                SourceExpr="Closing Date";
                Editable=ClosingDateEditable }

    { 10  ;2   ;Field     ;
                SourceExpr=Status;
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                SourceExpr="Closure Type";
                Editable=ClosureTypeEditable }

    { 8   ;2   ;Field     ;
                SourceExpr="Total Loan";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="Total Interest";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr="Member Deposits";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="Mode Of Disbursement" }

    { 4   ;2   ;Field     ;
                SourceExpr="Paying Bank" }

    { 3   ;2   ;Field     ;
                SourceExpr="Cheque No." }

    { 2   ;2   ;Field     ;
                SourceExpr="FOSA Account No.";
                Editable=false }

    { 1   ;2   ;Field     ;
                SourceExpr=Payee }

    { 1120054002;2;Field  ;
                SourceExpr="Current Deposits" }

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

    PROCEDURE UpdateControl@1102755001();
    BEGIN
      IF Status=Status::Open THEN BEGIN
      MNoEditable:=TRUE;
      ClosingDateEditable:=FALSE;
      ClosureTypeEditable:=TRUE;
      END;

      IF Status=Status::Pending THEN BEGIN
      MNoEditable:=FALSE;
      ClosingDateEditable:=FALSE;
      ClosureTypeEditable:=FALSE
      END;

      IF Status=Status::Rejected THEN BEGIN
      MNoEditable:=FALSE;
      ClosingDateEditable:=FALSE;
      ClosureTypeEditable:=FALSE;
      END;

      IF Status=Status::Approved THEN BEGIN
      MNoEditable:=FALSE;
      ClosingDateEditable:=TRUE;
      ClosureTypeEditable:=FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

