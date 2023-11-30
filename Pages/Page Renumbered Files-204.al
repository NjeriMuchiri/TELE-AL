OBJECT page 17395 Posted Loan Batch - List
{
  OBJECT-PROPERTIES
  {
    Date=06/20/17;
    Time=12:21:08 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516236;
    SourceTableView=WHERE(Posted=FILTER(Yes));
    PageType=List;
    CardPageID=Posted Loans Batch Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755011;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755010;1 ;ActionGroup;
                      Name=LoansB;
                      CaptionML=ENU=Batch }
      { 1102755009;2 ;Action    ;
                      CaptionML=ENU=Loans Schedule;
                      Image=SuggestPayment;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LoansBatch.RESET;
                                 LoansBatch.SETRANGE(LoansBatch."Batch No.","Batch No.");
                                 IF LoansBatch.FIND('-') THEN BEGIN
                                 REPORT.RUN(51516231,TRUE,FALSE,LoansBatch);
                                 END;
                               END;
                                }
      { 1102755008;2 ;Separator  }
      { 1102755007;2 ;Action    ;
                      Name=Member Card;
                      CaptionML=ENU=Member Card;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.GetLoanNo);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",LoanApp."Client Code");
                                 IF Cust.FIND('-') THEN
                                 PAGE.RUNMODAL(,Cust);
                                 END;
                                 }
                               END;
                                }
      { 1102755006;2 ;Action    ;
                      Name=Loan Application;
                      CaptionML=ENU=Loan Application Card;
                      Promoted=Yes;
                      Visible=FALSE;
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
      { 1102755005;2 ;Action    ;
                      Name=Loan Appraisal;
                      CaptionML=ENU=Loan Appraisal;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LoanApp.RESET;
                                 //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 IF COPYSTR(LoanApp."Loan Product Type",1,2) = 'PL' THEN
                                 REPORT.RUN(51516244,TRUE,FALSE,LoanApp)
                                 ELSE
                                 REPORT.RUN(51516244,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 1102755004;2 ;Separator  }
      { 1102755003;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::Batches;
                                 ApprovalEntries.Setfilters(DATABASE::"Salary Step/Notch Transactions",DocumentType,"Batch No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755002;2 ;Action    ;
                      Name=Send A&pproval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                                 Text001@1102755001 : TextConst 'ENU=This Batch is already pending approval';
                               BEGIN
                                 LBatches.RESET;
                                 LBatches.SETRANGE(LBatches."Batch No.","Batch No.");
                                 IF LBatches.FIND('-') THEN BEGIN
                                    IF LBatches.Status<>LBatches.Status::Open THEN
                                       ERROR(Text001);
                                 END;

                                 //End allocate batch number
                                 //ApprovalMgt.SendBatchApprRequest(LBatches);
                               END;
                                }
      { 1102755001;2 ;Action    ;
                      Name=Canel Approval Request;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 //IF ApprovalMgt.CancelBatchAppr(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755000;2 ;Action    ;
                      Name=Post;
                      CaptionML=ENU=Post;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=The Batch need to be approved.';
                               BEGIN
                                 IF Posted = TRUE THEN
                                 ERROR('Batch already posted.');

                                 IF Status<>Status::Approved THEN
                                 ERROR(FORMAT(Text001));

                                 CALCFIELDS(Location);

                                 IF ("Mode Of Disbursement" = "Mode Of Disbursement"::Cheque) OR
                                    ("Mode Of Disbursement" = "Mode Of Disbursement"::"Individual Cheques") THEN
                                 TESTFIELD("BOSA Bank Account");


                                 TESTFIELD("Description/Remarks");
                                 TESTFIELD("Posting Date");
                                 TESTFIELD("Document No.");

                                 //For branch loans - only individual cheques
                                 IF "Batch Type" = "Batch Type"::"Branch Loans" THEN BEGIN
                                 IF "Mode Of Disbursement"<>"Mode Of Disbursement"::"Individual Cheques" THEN
                                 ERROR('Mode of disbursement must be Individual Cheques for branch loans.');
                                 END;

                                 {IF "Mode Of Disbursement" <> "Mode Of Disbursement"::"Individual Cheques" THEN
                                 TESTFIELD("Cheque No.");}

                                 IF CONFIRM('Are you sure you want to post this batch?',TRUE) = FALSE THEN
                                 EXIT;

                                 //PRORATED DAYS
                                 EndMonth:=CALCDATE('-1D',CALCDATE('1M',DMY2DATE(1,DATE2DMY("Posting Date",2),DATE2DMY("Posting Date",3))));
                                 RemainingDays:=(EndMonth-"Posting Date")+1;
                                 TMonthDays:=DATE2DMY(EndMonth,1);
                                 //PRORATED DAYS


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 GenJournalLine.DELETEALL;


                                 GenSetUp.GET();

                                 DActivity:='BOSA';
                                 DBranch:='NAIROBI';

                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
                                 LoanApps.SETRANGE(LoanApps."System Created",FALSE);
                                 //LoanApps.SETRANGE(LoanApps.Source,LoanApps.Source::BOSA);
                                 LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                 IF LoanApps.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoanApps.CALCFIELDS(LoanApps."Special Loan Amount");

                                 IF (LoanApps.Source = LoanApps.Source::FOSA) AND
                                    ("Mode Of Disbursement" <> "Mode Of Disbursement"::"FOSA Loans") THEN
                                 ERROR('Mode of disbursement must be FOSA Loans for FOSA Loans.');

                                 IF (LoanApps.Source = LoanApps.Source::BOSA) AND
                                    ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") THEN
                                 ERROR('Mode of disbursement connot be FOSA loans for BOSA Loans.');


                                 IF "Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans" THEN BEGIN
                                 DActivity:='';
                                 DBranch:='';
                                 IF Vend.GET(LoanApps."Client Code") THEN BEGIN
                                 DActivity:=Vend."Global Dimension 1 Code";
                                 DBranch:=Vend."Global Dimension 2 Code";
                                 END;

                                 END;

                                 IF "Batch Type" = "Batch Type"::"Appeal Loans" THEN
                                 LoanDisbAmount:=LoanApps."Appeal Amount"
                                 ELSE
                                 LoanDisbAmount:=LoanApps."Approved Amount";

                                 IF (LoanApps."Special Loan Amount" > 0) AND (LoanApps."Bridging Loan Posted" = FALSE) THEN
                                 ERROR('Bridging Loans must be posted before the loans are disbursed. ' + LoanApps."Loan  No.");

                                 TCharges:=0;
                                 TopUpComm:=0;
                                 TotalTopupComm:=0;


                                 IF LoanApps."Loan Status"<>LoanApps."Loan Status"::Approved THEN
                                 ERROR('Loan status must be Approved for you to post Loan. - ' + LoanApps."Loan  No.");

                                 IF "Batch Type" <> "Batch Type"::"Appeal Loans" THEN BEGIN
                                   IF LoanApps.Posted = TRUE THEN
                                   ERROR('Loan has already been posted. - ' + LoanApps."Loan  No.");
                                 END;

                                 LoanApps.CALCFIELDS(LoanApps."Top Up Amount");



                                 RunningDate:="Posting Date";


                                 //Generate and post Approved Loan Amount
                                 IF NOT GenBatch.GET('GENERAL','LOANS') THEN
                                 BEGIN
                                 GenBatch.INIT;
                                 GenBatch."Journal Template Name":='GENERAL';
                                 GenBatch.Name:='LOANS';
                                 GenBatch.INSERT;
                                 END;

                                 PCharges.RESET;
                                 PCharges.SETRANGE(PCharges."Product Code",LoanApps."Loan Product Type");
                                 IF PCharges.FIND('-') THEN BEGIN
                                 REPEAT
                                     PCharges.TESTFIELD(PCharges."G/L Account");

                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=PCharges."G/L Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description;
                                     IF PCharges."Use Perc" = TRUE THEN
                                     GenJournalLine.Amount:=(LoanDisbAmount * PCharges.Percentage/100) * -1
                                     ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //Don't top up charges on principle
                                     IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") THEN BEGIN
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     END ELSE BEGIN

                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Client Code";

                                     END;
                                     //Don't top up charges on principle
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);


                                 UNTIL PCharges.NEXT = 0;
                                 END;

                                 //Boosting Shares Commision
                                 IF LoanApps."Boosting Commision" > 0 THEN BEGIN
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=GenSetUp."Boosting Fees Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Boosting Commision';
                                     GenJournalLine.Amount:=LoanApps."Boosting Commision" * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //Don't top up charges on principle
                                     IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") THEN BEGIN
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     END;
                                     //Don't top up charges on principle
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);

                                 END;

                                 //Don't top up charges on principle
                                 TCharges:=0;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":=LoanApps."Client Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Document No.":="Document No.";
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine.Description:='Principal Amount';
                                 GenJournalLine.Amount:=LoanDisbAmount+ TCharges;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                 GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //POST INTEREST DIFFERENCE
                                 IF (LoanApps."Loan Product Type"='BELA') OR (LoanApps."Loan Product Type"='EMERGENCY') OR
                                  (LoanApps."Loan Product Type"='ADDITIONAL')
                                 OR (LoanApps."Loan Product Type"='JITEGEMEE') THEN BEGIN
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest Due';
                                     GenJournalLine.Amount:=((LoanApps.Repayment*LoanApps.Installments))-LoanApps."Approved Amount";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                    // GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                    // GenJournalLine."Bal. Account No.":=LoanType."Loan Interest Account";
                                    // GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                                     //GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest Due';
                                     GenJournalLine.Amount:=(((LoanApps.Repayment*LoanApps.Installments))-LoanApps."Approved Amount")*-1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                    // GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     //GenJournalLine."Bal. Account No.":=LoanType."Loan Interest Account";
                                    // GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;







                                 END;

                                 //Post Interest Due




                                 IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                 LoanTopUp.RESET;
                                 LoanTopUp.SETRANGE(LoanTopUp."Loan No.",LoanApps."Loan  No.");
                                 IF LoanTopUp.FIND('-') THEN BEGIN
                                 REPEAT
                                     //Principle
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Off Set By - ' +LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=LoanTopUp."Total Top Up" * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     //Interest (Reversed if top up)
                                    IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest Due rev on top up ' + LoanApps."Loan Product Type Name";
                                     GenJournalLine.Amount:=LoanTopUp."Interest Top Up" * -1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Bal. Account No.":=LoanType."Receivable Interest Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     END;
                                     //Commision
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     IF LoanType."Top Up Commision" > 0 THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Commision on Loan Top Up';
                                     TopUpComm:=(LoanTopUp."Principle Top Up") * (LoanType."Top Up Commision"/100);
                                     TotalTopupComm:=TotalTopupComm+TopUpComm;
                                     GenJournalLine.Amount:=TopUpComm*-1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     END;
                                     END;



                                 UNTIL LoanTopUp.NEXT = 0;

                                 END;



                                 //IF Top Up
                                 IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                 IF "Mode Of Disbursement"="Mode Of Disbursement"::"Individual Cheques" THEN BEGIN
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     LoanApps.TESTFIELD(LoanApps."Cheque No.");
                                     GenJournalLine."External Document No.":=LoanApps."Cheque No.";
                                     IF "Post to Loan Control" = TRUE THEN BEGIN
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":='024005';
                                     END ELSE BEGIN
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                     GenJournalLine."Account No.":="BOSA Bank Account";
                                     END;
                                     //GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                     //GenJournalLine."Account No.":="BOSA Bank Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:=LoanApps."Client Name";
                                     GenJournalLine.Amount:=(LoanDisbAmount-(LoanApps."Top Up Amount"+TotalTopupComm))*-1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 END;
                                 END;



                                 END ELSE BEGIN
                                     IF "Mode Of Disbursement"="Mode Of Disbursement"::"Individual Cheques" THEN BEGIN
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     LoanApps.TESTFIELD(LoanApps."Cheque No.");
                                     GenJournalLine."External Document No.":=LoanApps."Cheque No.";
                                     IF "Post to Loan Control" = TRUE THEN BEGIN
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":='024005';
                                     END ELSE BEGIN
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                     GenJournalLine."Account No.":="BOSA Bank Account";
                                     END;
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:=LoanApps."Client Name";
                                     GenJournalLine.Amount:=LoanDisbAmount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     END;
                                 END;

                                 //END;
                                 //END;
                                 BatchTopUpAmount:=BatchTopUpAmount+LoanApps."Top Up Amount";
                                 BatchTopUpComm:=BatchTopUpComm+TotalTopupComm;


                                 LoanApps."Issued Date":="Posting Date";
                                 LoanApps.Advice:=TRUE;
                                 LoanApps."Advice Type":=LoanApps."Advice Type"::"Fresh Loan";
                                 LoanApps.Posted:=TRUE;
                                 LoanApps.MODIFY;


                                 //Contractual Shares Variation
                                 IF GenSetUp."Contactual Shares (%)" <> 0 THEN BEGIN
                                 IF Cust.GET(LoanApps."Client Code") THEN BEGIN
                                 ContractualShares:=ROUND(((LoanDisbAmount * GenSetUp."Contactual Shares (%)")*0.01),1);
                                 IF ContractualShares > GenSetUp."Max. Contactual Shares" THEN
                                 ContractualShares := GenSetUp."Max. Contactual Shares";

                                 IF Cust."Monthly Contribution" < ContractualShares THEN BEGIN
                                 Cust."Monthly Contribution" := ContractualShares;
                                 Cust.Advice:=TRUE;
                                 Cust."Advice Type":=Cust."Advice Type"::"Shares Adjustment";
                                 Cust.MODIFY;
                                 END;
                                 END;
                                 END;
                                 //Contractual Shares Variation


                                 UNTIL LoanApps.NEXT = 0;
                                 END;

                                 //BOSA Bank Entry
                                 IF "Mode Of Disbursement" = "Mode Of Disbursement"::Cheque THEN BEGIN
                                    //No Cheque for STIMA
                                    //("Mode Of Disbursement"="Mode Of Disbursement"::"Transfer to FOSA") THEN BEGIN
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="Document No.";
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="BOSA Bank Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:="Description/Remarks";
                                 IF "Batch Type" = "Batch Type"::"Appeal Loans" THEN
                                 GenJournalLine.Amount:=("Total Appeal Amount"-(BatchTopUpAmount+BatchTopUpComm))*-1
                                 ELSE
                                 GenJournalLine.Amount:=("Total Loan Amount"-(BatchTopUpAmount+BatchTopUpComm))*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;


                                 //Transfer to FOSA
                                 IF ("Mode Of Disbursement"="Mode Of Disbursement"::"Transfer to FOSA") OR
                                    ("Mode Of Disbursement"="Mode Of Disbursement"::"FOSA Loans") THEN BEGIN
                                 DActivity:='FOSA';
                                 DBranch:='NAIROBI';

                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
                                 LoanApps.SETRANGE(LoanApps."System Created",FALSE);
                                 //LoanApps.SETRANGE(LoanApps.Source,LoanApps.Source::BOSA);
                                 LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                 IF LoanApps.FIND('-') THEN BEGIN
                                 REPEAT
                                     LoanApps.CALCFIELDS(LoanApps."Special Loan Amount",LoanApps."Other Commitments Clearance");

                                     IF "Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans" THEN BEGIN
                                     DActivity:='';
                                     DBranch:='';
                                     IF Vend.GET(LoanApps."Client Code") THEN BEGIN
                                     DActivity:=Vend."Global Dimension 1 Code";
                                     DBranch:=Vend."Global Dimension 2 Code";
                                     END;

                                     END;


                                     IF "Batch Type" = "Batch Type"::"Appeal Loans" THEN
                                     LoanDisbAmount:=LoanApps."Appeal Amount"
                                     ELSE IF "Batch Type" = "Batch Type"::"Personal Loans" THEN
                                     LoanDisbAmount:=LoanApps."Approved Amount"-(LoanApps."Approved Amount"*0.025)
                                     ELSE
                                     LoanDisbAmount:=LoanApps."Approved Amount";


                                     //Top Up Commision
                                     TopUpComm:=0;
                                     TotalTopupComm:=0;

                                     IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                     LoanTopUp.RESET;
                                     LoanTopUp.SETRANGE(LoanTopUp."Loan No.",LoanApps."Loan  No.");
                                     IF LoanTopUp.FIND('-') THEN BEGIN
                                     REPEAT
                                     TopUpComm:=(LoanTopUp."Principle Top Up") * (LoanType."Top Up Commision"/100);
                                     TotalTopupComm:=TotalTopupComm+TopUpComm;

                                     UNTIL LoanTopUp.NEXT = 0;

                                     END;
                                     END;



                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     //LoanApps.TESTFIELD(LoanApps."Account No");
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     IF (LoanApps."Account No" = '350011') OR (LoanApps."Account No" = '350012') THEN BEGIN
                                     GenJournalLine.Description:=LoanApps."Client Name";
                                     IF Cust.GET(LoanApps."Client Code") THEN BEGIN
                                     GenJournalLine."External Document No.":=Cust."ID No.";
                                     GenJournalLine.Description:= Cust."Payroll/Staff No" + ' - ' + GenJournalLine.Description;
                                     END;
                                     END ELSE
                                     GenJournalLine.Description:=LoanApps."Loan Product Type Name";
                                     //IPF Loan to CIC Account
                                     IF (LoanApps."Loan Product Type" = 'IPF') THEN BEGIN
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":='4-10-000540';
                                     GenJournalLine."External Document No.":=Cust."ID No.";
                                     GenJournalLine.Description:=COPYSTR(LoanApps."Client Name" +'-'+Cust."Payroll/Staff No",1,30);
                                     END;
                                     GenJournalLine.Amount:=(LoanDisbAmount-(LoanApps."Top Up Amount"+TotalTopupComm))*-1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     //sms
                                     IF (Vend.GET(LoanApps."Account No" ) )THEN
                                     IF (Vend."Phone No." <>'') THEN
                                     //sms.SendSms('Loantofosa',Vend."Phone No.",'Your '+ LoanApps."Loan Product Type" + ' has been credited to your FOSA Account at Waumini Sacco.');

                                     //Recover Special Loan
                                     //IF LoanApps."Bridging Loan Posted" = TRUE THEN BEGIN

                                     Loans.RESET;
                                     Loans.SETCURRENTKEY(Loans."BOSA Loan No.",Loans."Account No",Loans."Batch No.");
                                     //Loans.SETRANGE(Loans."BOSA Loan No.",LoanApps."Loan  No.");
                                     Loans.SETRANGE(Loans."Loan Product Type",'BRIDGING');
                                     Loans.SETRANGE(Loans."Account No",LoanApps."Account No");
                                     Loans.SETFILTER(Loans."Outstanding Balance",'>0');
                                     IF Loans.FIND('-') THEN BEGIN
                                     REPEAT

                                     Loans.CALCFIELDS(Loans."Outstanding Balance");

                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Bridging Loan Recovery';
                                     GenJournalLine.Amount:=-Loans."Outstanding Balance";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=Loans."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     //SpecialComm:=ROUND((LoanApps."Special Loan Amount"+LoanApps."Other Commitments Clearance")*0.05,0.01);
                                     //Special Commision
                                     SpecialComm:=0;
                                     BridgedLoans.RESET;
                                     BridgedLoans.SETCURRENTKEY(BridgedLoans."Loan No.");
                                     BridgedLoans.SETRANGE(BridgedLoans."Loan No.",LoanApps."Loan  No.");
                                     IF BridgedLoans.FIND('-') THEN BEGIN
                                     REPEAT
                                     IF BridgedLoans.Source = BridgedLoans.Source::FOSA THEN BEGIN
                                     IF BridgedLoans."Loan Type" = 'SUPER' THEN
                                     SpecialComm:=SpecialComm+(BridgedLoans."Total Off Set"*0.1)
                                     ELSE
                                     SpecialComm:=SpecialComm+(BridgedLoans."Total Off Set"*0.1);
                                     END ELSE BEGIN
                                     SpecialComm:=SpecialComm+(BridgedLoans."Total Off Set"*0.1);
                                     END;
                                     UNTIL BridgedLoans.NEXT = 0;
                                     END;

                                     //POLICESpecialComm:=ROUND(SpecialComm+(LoanApps."Other Commitments Clearance"*0.05),0.01);
                                     //SPecial Commision


                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     LoanApps.TESTFIELD(LoanApps."Account No");
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Bridging Loan Commision';
                                     GenJournalLine.Amount:=SpecialComm;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     LoanApps.TESTFIELD(LoanApps."Account No");
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     IF (LoanApps."Account No" = '350011') OR (LoanApps."Account No" = '350012') THEN BEGIN
                                     GenJournalLine.Description:=LoanApps."Client Name";
                                     IF Cust.GET(LoanApps."Client Code") THEN
                                     GenJournalLine."External Document No.":=Cust."ID No.";
                                     END ELSE
                                     GenJournalLine.Description:='Bridging Loan Recovery';
                                     GenJournalLine.Amount:=(Loans."Outstanding Balance"-SpecialComm);
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     UNTIL Loans.NEXT = 0;


                                     END ELSE BEGIN
                                     IF (LoanApps."Special Loan Amount"+LoanApps."Other Commitments Clearance") > 0 THEN
                                     ERROR('Bridging loan for %1 not found.',LoanApps."Loan  No.");
                                     END;


                                     //Transfer Project Loan Amount
                                     IF LoanApps."Project Amount" > 0 THEN BEGIN
                                     LoanApps.TESTFIELD(LoanApps."Project Account No");
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Project Account No";
                                     LoanApps.TESTFIELD(LoanApps."Account No");
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Transfer to Project';
                                     GenJournalLine.Amount:=LoanApps."Project Amount";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Account No";
                                     LoanApps.TESTFIELD(LoanApps."Account No");
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Project Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:=LoanApps."Client Name";
                                     GenJournalLine.Amount:=-LoanApps."Project Amount";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                    // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;



                                     END;
                                     //Transfer Project Loan Amount
                                 UNTIL LoanApps.NEXT = 0;
                                 END;

                                 END;
















                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                 END;

                                 //Post New

                                 Posted:=TRUE;
                                 MODIFY;


                                 MESSAGE('Batch posted successfully.');

                                 //Post
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1102760020;2;Field  ;
                SourceExpr=Source }

    { 1000000002;2;Field  ;
                SourceExpr="Prepared By" }

    { 1102760003;2;Field  ;
                SourceExpr="Description/Remarks" }

    { 1000000000;2;Field  ;
                SourceExpr="Posting Date" }

    { 1102760018;2;Field  ;
                SourceExpr="No of Loans";
                Editable=FALSE }

    { 1102760016;2;Field  ;
                SourceExpr="Mode Of Disbursement";
                Editable=TRUE }

    { 1000000001;2;Field  ;
                SourceExpr="Approved By" }

  }
  CODE
  {
    VAR
      ApprovalsSetup@1142 : Record 452;
      MovementTracker@1141 : Record 51516254;
      FileMovementTracker@1140 : Record 51516254;
      NextStage@1139 : Integer;
      EntryNo@1138 : Integer;
      NextLocation@1137 : Text[100];
      LoansBatch@1136 : Record 51516236;
      i@1135 : Integer;
      LoanType@1134 : Record 51516240;
      PeriodDueDate@1133 : Date;
      ScheduleRep@1132 : Record 51516234;
      RunningDate@1131 : Date;
      G@1130 : Integer;
      IssuedDate@1129 : Date;
      GracePeiodEndDate@1128 : Date;
      InstalmentEnddate@1127 : Date;
      GracePerodDays@1126 : Integer;
      InstalmentDays@1125 : Integer;
      NoOfGracePeriod@1124 : Integer;
      NewSchedule@1123 : Record 51516234;
      RSchedule@1122 : Record 51516234;
      GP@1121 : Text[30];
      ScheduleCode@1120 : Code[20];
      PreviewShedule@1119 : Record 51516234;
      PeriodInterval@1118 : Code[10];
      CustomerRecord@1117 : Record 51516223;
      Gnljnline@1116 : Record 81;
      Jnlinepost@1115 : Codeunit 12;
      CumInterest@1114 : Decimal;
      NewPrincipal@1113 : Decimal;
      PeriodPrRepayment@1112 : Decimal;
      GenBatch@1111 : Record 232;
      LineNo@1110 : Integer;
      GnljnlineCopy@1109 : Record 81;
      NewLNApplicNo@1108 : Code[10];
      Cust@1107 : Record 51516223;
      LoanApp@1106 : Record 51516230;
      TestAmt@1105 : Decimal;
      CustRec@1104 : Record 51516223;
      CustPostingGroup@1103 : Record 92;
      GenSetUp@1102 : Record 51516257;
      PCharges@1101 : Record 51516242;
      TCharges@1100 : Decimal;
      LAppCharges@1099 : Record 51516244;
      Loans@1098 : Record 51516230;
      LoanAmount@1097 : Decimal;
      InterestRate@1096 : Decimal;
      RepayPeriod@1095 : Integer;
      LBalance@1094 : Decimal;
      RunDate@1093 : Date;
      InstalNo@1092 : Decimal;
      RepayInterval@1091 : DateFormula;
      TotalMRepay@1090 : Decimal;
      LInterest@1089 : Decimal;
      LPrincipal@1088 : Decimal;
      RepayCode@1087 : Code[40];
      GrPrinciple@1086 : Integer;
      GrInterest@1085 : Integer;
      QPrinciple@1084 : Decimal;
      QCounter@1083 : Integer;
      InPeriod@1082 : DateFormula;
      InitialInstal@1081 : Integer;
      InitialGraceInt@1080 : Integer;
      GenJournalLine@1079 : Record 81;
      FOSAComm@1078 : Decimal;
      BOSAComm@1077 : Decimal;
      GLPosting@1076 : Codeunit 12;
      LoanTopUp@1075 : Record 51516235;
      Vend@1074 : Record 23;
      BOSAInt@1073 : Decimal;
      TopUpComm@1072 : Decimal;
      DActivity@1071 : Code[20];
      DBranch@1070 : Code[20];
      UsersID@1069 : Record 2000000120;
      TotalTopupComm@1068 : Decimal;
      Notification@1067 : Codeunit 397;
      CustE@1066 : Record 51516223;
      DocN@1065 : Text[50];
      DocM@1064 : Text[100];
      DNar@1063 : Text[250];
      DocF@1062 : Text[50];
      MailBody@1061 : Text[250];
      ccEmail@1060 : Text[250];
      LoanG@1059 : Record 51516231;
      SpecialComm@1058 : Decimal;
      LoanApps@1057 : Record 51516230;
      Banks@1056 : Record 270;
      BatchTopUpAmount@1055 : Decimal;
      BatchTopUpComm@1054 : Decimal;
      TotalSpecialLoan@1053 : Decimal;
      SpecialLoanCl@1052 : Record 51516238;
      Loans2@1051 : Record 51516230;
      DActivityBOSA@1050 : Code[20];
      DBranchBOSA@1049 : Code[20];
      Refunds@1048 : Record 51516240;
      TotalRefunds@1047 : Decimal;
      WithdrawalFee@1046 : Decimal;
      NetPayable@1045 : Decimal;
      NetRefund@1044 : Decimal;
      FWithdrawal@1043 : Decimal;
      OutstandingInt@1042 : Decimal;
      TSC@1041 : Decimal;
      LoanDisbAmount@1040 : Decimal;
      NegFee@1039 : Decimal;
      DValue@1038 : Record 349;
      ChBank@1037 : Code[20];
      Trans@1036 : Record 51516299;
      TransactionCharges@1035 : Record 51516300;
      BChequeRegister@1034 : Record 51516313;
      OtherCommitments@1033 : Record 51516262;
      BoostingComm@1032 : Decimal;
      BoostingCommTotal@1031 : Decimal;
      BridgedLoans@1030 : Record 51516238;
      InterestDue@1029 : Decimal;
      ContractualShares@1028 : Decimal;
      BridgingChanged@1027 : Boolean;
      BankersChqNo@1026 : Code[20];
      LastPayee@1025 : Text[100];
      RunningAmount@1024 : Decimal;
      BankersChqNo2@1023 : Code[20];
      BankersChqNo3@1022 : Code[20];
      EndMonth@1021 : Date;
      RemainingDays@1020 : Integer;
      PrincipalRepay@1019 : Decimal;
      InterestRepay@1018 : Decimal;
      TMonthDays@1017 : Integer;
      SMSMessage@1016 : Record 51516232;
      iEntryNo@1015 : Integer;
      Temp@1014 : Record 18;
      Jtemplate@1013 : Code[30];
      JBatch@1012 : Code[30];
      LBatches@1011 : Record 51516236;
      ApprovalMgt@1010 : Codeunit 439;
      DocumentType@1009 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      DescriptionEditable@1008 : Boolean;
      ModeofDisburementEditable@1007 : Boolean;
      DocumentNoEditable@1006 : Boolean;
      PostingDateEditable@1005 : Boolean;
      SourceEditable@1004 : Boolean;
      PayingAccountEditable@1003 : Boolean;
      ChequeNoEditable@1002 : Boolean;
      ChequeNameEditable@1001 : Boolean;
      upfronts@1000 : Decimal;

    BEGIN
    END.
  }
}

