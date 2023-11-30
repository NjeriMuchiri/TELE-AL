OBJECT page 17394 Loan Disburesment Batch Card
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=12:15:29 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516236;
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
                                 DocumentType:=DocumentType::Batches;
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
                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
                                 IF LoanApps.FIND('-')=FALSE THEN
                                 ERROR('You cannot send an empty batch for approval');


                                 TESTFIELD("Description/Remarks");
                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);

                                 //End allocate batch number
                                 Doc_Type:=Doc_Type::"Loan Batch";
                                 Table_id:=DATABASE::"Loan Disburesment-Batching";

                                 IF ApprovalsMgmt.CheckLBatcApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendLBatchDocForApproval(Rec);

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Loan Batch Sent For Approval',0,
                                 'CREDIT',TODAY,TIME,'',"Batch No.",'','');
                                 //End Create Audit Entry
                                 //TESTFIELD("Document No.");
                                 //TESTFIELD("Posting Date");



                                 {Status:=Status::Approved;
                                 MODIFY;
                                 MESSAGE('approved succesfully');}
                                 //ApprovalMgt.SendBatchApprRequest(LBatches);
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
                                 //IF ApprovalMgt.CancelBatchAppr(Rec,TRUE,TRUE) THEN

                                 IF ApprovalsMgmt.CheckLBatcApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelLBatcApprovalRequest(Rec);
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
                               BEGIN
                                 IF Status<>Status::Approved THEN
                                   ERROR('The batch must be approved.');




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
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 GenJournalLine.DELETEALL;


                                 GenSetUp.GET;

                                 DActivity:='';
                                 DBranch:='';


                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
                                 LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                 IF LoanApps.FIND('-') THEN BEGIN

                                 REPEAT
                                 IF USERID=LoanApps."Approved By" THEN
                                 ERROR('Loan approver %1 is not permitted to disburse loan %2',USERID,LoanApps."Loan  No.");

                                 TCharges:=0;

                                  IF "Mode Of Disbursement" = "Mode Of Disbursement"::EFT THEN BEGIN
                                 TopUpComm:=0;
                                 TotalTopupComm:=0;
                                 BatchTopUpAmount:=0;
                                 ShareAmount:=0;
                                 EftAmount:=0;
                                 END;

                                 LoanApps.CALCFIELDS(LoanApps."Special Loan Amount");

                                 IF (LoanApps.Source = LoanApps.Source::FOSA) AND
                                    ("Mode Of Disbursement" <> "Mode Of Disbursement"::"FOSA Loans") THEN
                                 ERROR('Mode of disbursement must be FOSA Loans for FOSA Loans.');

                                 IF (LoanApps.Source = LoanApps.Source::BOSA) AND
                                    ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") THEN
                                 ERROR('Mode of disbursement connot be FOSA loans for BOSA Loans.');

                                 //LIMIT INDIVIDUAL CHEQUE
                                 IF (LoanApps.Source = LoanApps.Source::BOSA) AND
                                    ("Mode Of Disbursement" = "Mode Of Disbursement"::"Individual Cheques") THEN
                                 ERROR('Mode of disbursement connot be Individual cheque loans. ');


                                 IF "Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans" THEN BEGIN
                                 DActivity:='';
                                 DBranch:='';
                                 IF Vend.GET(LoanApps."Client Code") THEN BEGIN
                                 DActivity:=Vend."Global Dimension 1 Code";
                                 DBranch:=Vend."Global Dimension 2 Code";
                                 END;
                                 END;

                                 IF "Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA" THEN BEGIN
                                 DActivity:='';
                                 DBranch:='';
                                 IF Cust.GET(LoanApps."Client Code") THEN BEGIN
                                 DActivity:=Cust."Global Dimension 1 Code";
                                 DBranch:=Cust."Global Dimension 2 Code";
                                 END;
                                 END;


                                 IF "Batch Type" = "Batch Type"::"Appeal Loans" THEN
                                 LoanDisbAmount:=LoanApps."Appeal Amount"
                                 ELSE
                                 LoanDisbAmount:=LoanApps."Approved Amount";

                                 IF (LoanApps."Special Loan Amount" > 0) AND (LoanApps."Bridging Loan Posted" = FALSE) THEN
                                 ERROR('Bridging Loans must be posted before the loans are disbursed. ' + LoanApps."Loan  No.");


                                 {
                                 IF LoanApps."Loan Status"<>LoanApps."Loan Status"::Approved THEN
                                 ERROR('Loan status must be Approved for you to post Loan. - ' + LoanApps."Loan  No.");

                                 IF "Batch Type" <> "Batch Type"::"Appeal Loans" THEN BEGIN
                                   IF LoanApps.Posted = TRUE THEN
                                   ERROR('Loan has already been posted. - ' + LoanApps."Loan  No.");
                                 END;
                                 }

                                 //Deduct first principle repayment
                                   //LineNo:=0;
                                   // MESSAGE('saDzfghvjb');
                                   //LoanApps.RESET;
                                 //LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
                                 //LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                 //IF LoanApps.FIND('-') THEN BEGIN

                                   //MESSAGE('saDzfghvjb');

                                  //END;


                                  {
                                   IF LoanApps."Loan Product Type Name"='Instant Loan' THEN
                                     GenJournalLine."Account No.":='100-200-201'

                                     ELSE IF LoanApps."Loan Product Type Name"='Reloaded Plus' THEN
                                     GenJournalLine."Account No.":='100-200-217'

                                    ELSE IF LoanApps."Loan Product Type Name"='FDA Advance Loan' THEN
                                    GenJournalLine."Account No.":='100-200-219'

                                    ELSE IF LoanApps."Loan Product Type Name"='Golden age advance Loan' THEN
                                    GenJournalLine."Bal. Account No.":='100-200-220'

                                    ELSE IF LoanApps."Loan Product Type Name"='Golden age advance Loan' THEN
                                    GenJournalLine."Account No.":='100-200-220'

                                    ELSE IF LoanApps."Loan Product Type Name"='Okoa Loan' THEN
                                    GenJournalLine."Account No.":='100-200-216'

                                    ELSE IF LoanApps."Loan Product Type Name"='Normal Loan' THEN
                                    GenJournalLine."Account No.":='100-200-211'

                                    ELSE IF LoanApps."Loan Product Type Name"='Emergency Loan' THEN
                                    GenJournalLine."Account No.":='100-200-215'

                                    ELSE IF LoanApps."Loan Product Type Name"='ESS Loan' THEN
                                    GenJournalLine."Account No.":='100-200-215'

                                    ELSE IF LoanApps."Loan Product Type Name"='super loan' THEN
                                    GenJournalLine."Account No.":='100-200-208'

                                   ELSE IF LoanApps."Loan Product Type Name"='Jijenge Loan' THEN
                                    GenJournalLine."Account No.":='100-200-209'

                                    ELSE IF LoanApps."Loan Product Type Name"='Salary Advance Bosa' THEN
                                    GenJournalLine."Account No.":='100-200-204';
                                    }
                                     //LoanApps.RESET;
                                    //LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
                                   // //LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                    //IF LoanApps.FIND('-') THEN BEGIN

                                 {
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     //GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='1st loan repayment';
                                     GenJournalLine.Amount:=LoanApps."Loan Principle Repayment";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");

                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     }

                                  //IF GenJournalLine.Amount<>0 THEN

                                   // GenJournalLine.INSERT;






                                 LoanApps.CALCFIELDS(LoanApps."Top Up Amount");



                                 RunningDate:="Posting Date";


                                 //Generate and post Approved Loan Amount
                                 IF NOT GenBatch.GET('PAYMENTS','LOANS') THEN
                                 BEGIN
                                 GenBatch.INIT;
                                 GenBatch."Journal Template Name":='PAYMENTS';
                                 GenBatch.Name:='LOANS';
                                 GenBatch.INSERT;
                                 END;
                                 //ERROR('Error Posting');
                                 //Kit
                                 IF ("Mode Of Disbursement"<>"Mode Of Disbursement"::Cheque)    THEN BEGIN
                                 //TCharges:=0;
                                 PCharges.RESET;
                                 PCharges.SETRANGE(PCharges."Product Code",LoanApps."Loan Product Type");
                                 IF PCharges.FIND('-') THEN BEGIN
                                 REPEAT
                                 //TCharges:=0;
                                     //PCharges.TESTFIELD(PCharges."G/L Account");

                                     LineNo:=LineNo+10000;

                                  IF PCharges."G/L Account"<>'' THEN BEGIN
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=PCharges."G/L Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     {IF (PCharges."Use Perc"=TRUE) AND (PCharges.Code<>'INS') THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amounta * -1;}
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;

                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //Don't top up charges on principle
                                     //IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") OR
                                     //   ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") THEN BEGIN


                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     //END;
                                     //Don't top up charges on principle
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                 //GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine."Account Type"=GenJournalLine."Account Type"::Member THEN
                                     GenJournalLine."Posting Group":='';
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                                       TCharges:=TCharges+(GenJournalLine.Amount*-1);




                                 ODAuth.RESET;
                                 ODAuth.SETRANGE(ODAuth.Status,ODAuth.Status::Approved);
                                 ODAuth.SETRANGE(ODAuth.Expired,FALSE);
                                 ODAuth.SETRANGE(ODAuth.Liquidated,FALSE);
                                 ODAuth.SETRANGE(ODAuth.Posted,TRUE);
                                 ODAuth.SETRANGE(ODAuth."Account No.",LoanApps."Account No");
                                 IF ODAuth.FINDFIRST THEN BEGIN
                                     ODAuth.MODIFYALL(ODAuth.Expired,TRUE);
                                     ODAuth.MODIFYALL(ODAuth.Liquidated,TRUE);
                                 END;



                                 END;
                                 LineNo:=LineNo+10000;
                                  IF PCharges."Retain Deposits"=TRUE THEN BEGIN
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                                       TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                 END;
                                 LineNo:=LineNo+10000;
                                 IF PCharges."Retain ShareCapital"=TRUE THEN BEGIN
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                                       TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                 END;
                                 UNTIL PCharges.NEXT = 0;
                                 END;



                                 //Boosting Shares Commision
                                 IF LoanApps."Boosting Commision" > 0 THEN BEGIN
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     {
                                     IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::EFT) THEN BEGIN
                                        }
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     //END;
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     //Don't top up charges on pri0nciple
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     //GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);

                                 END;

                                 BoostDeposits(LoanApps);
                                 ExpressLoanCharge(LoanApps);
                                 //TCharges:=0;
                                 ShareAmount:=0;
                                 Scharge:=0;



                                 //Recover Other Committments Commision
                                 LoanApps.CALCFIELDS(LoanApps."Other Commitments Clearance");
                                 IF LoanApps."Other Commitments Clearance">0 THEN BEGIN
                                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=LoanType."Top Up Commision Account";//LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Commission on Other Committments';
                                     GenJournalLine.Amount:=(LoanApps."Other Commitments Clearance"*(LoanType."Bank Comm %"/100))*-1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     {
                                     IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::EFT) THEN BEGIN
                                        }
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     //END;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";

                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                         TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                  END;
                                 END;


                                 //Other Commitment clearance
                                 Commitm:=0;

                                 LoanApps.CALCFIELDS(LoanApps."Other Commitments Clearance");
                                 IF LoanApps."Other Commitments Clearance" > 0 THEN BEGIN
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="Document No.";;
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=LoanType."Bank Comm A/c";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Bridged Payroll Commitements';
                                 GenJournalLine.Amount:=-LoanApps."Other Commitments Clearance";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 {
                                 IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") OR
                                        ("Mode Of Disbursement" = "Mode Of Disbursement"::EFT) THEN BEGIN
                                        }
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                 //END;
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                 //Commitm:=(Commitm+GenJournalLine.Amount)*-1;
                                 //PostBankersCheq()


                                 END;
                                 //Other Commitment clearance

                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                           GenJournalLine."Account No.":=LoanApps."Client Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='Principal Amount1';
                                           GenJournalLine.Amount:=LoanDisbAmount;
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                           GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           {
                                           IF ("Mode Of Disbursement" = "Mode Of Disbursement"::EFT) THEN BEGIN
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                 END;
                                 }
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           EftAmount:=EftAmount+GenJournalLine.Amount;

                                 END;

                                 //Generate Data Sheet Advice
                                     PTEN:='';

                                     IF STRLEN(LoanApps."Staff No")=10 THEN BEGIN
                                     PTEN:=COPYSTR(LoanApps."Staff No",10);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=9 THEN BEGIN
                                      PTEN:=COPYSTR(Loans."Staff No",9);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=8 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",8);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=7 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",7);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=6 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",6);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=5 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",5);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=4 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",4);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=3 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",3);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=2 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",2);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=1 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",1);
                                      END;


                                     IF LoanTypes.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     IF Customer.GET(LoanApps."Client Code") THEN BEGIN
                                     //Loans."Staff No":=Customer."Payroll/Staff No";

                                     DataSheet.RESET;
                                     DataSheet.SETRANGE(DataSheet."PF/Staff No",LoanApps."Staff No");
                                     DataSheet.SETRANGE(DataSheet."Type of Deduction",LoanApps."Loan Product Type");
                                     DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                     IF DataSheet.FIND('-') THEN BEGIN
                                     DataSheet.DELETE;
                                     END;

                                     DataSheet.RESET;
                                     DataSheet.SETRANGE(DataSheet."PF/Staff No",LoanApps."Staff No");
                                     DataSheet.SETRANGE(DataSheet."Type of Deduction",LoanApps."Loan Product Type");
                                     DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                     IF DataSheet.FIND('-') THEN BEGIN
                                     END;
                                     END;
                                     END;



                                 IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                                 BatchTopUpAmount:=0;
                                 //BatchTopUpAmount:=BatchTopUpAmount+(LoanApps."Top Up Amount"+LoanTopUp.Commision);
                                 IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                 LoanTopUp.RESET;
                                 LoanTopUp.SETRANGE(LoanTopUp."Loan No.",LoanApps."Loan  No.");
                                 LoanTopUp.SETFILTER(LoanTopUp."Client Code",LoanApps."Client Code");
                                 IF LoanTopUp.FIND('-') THEN BEGIN

                                 REPEAT

                                     //Principle
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Off Set By - ' +LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=LoanTopUp."Principle Top Up"* -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";

                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     BatchTopUpAmount:=BatchTopUpAmount+(GenJournalLine.Amount*-1);


                                     //Interest (Reversed if top up)
                                    IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     //charge first
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest Due charged on top up ' ;
                                     GenJournalLine.Amount:=LoanTopUp."Interest Charged";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);

                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Bal. Account No.":=LoanType."Loan Interest Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");

                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     //end of charge

                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest Due Paid on top up ' ;
                                     GenJournalLine.Amount:=-LoanTopUp."Interest Top Up";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     BatchTopUpAmount:=BatchTopUpAmount+(GenJournalLine.Amount*-1);



                                     END;
                                     //Commision
                                     TopUpComm:=0;
                                     TotalTopupComm:=0;
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN

                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest on topup';
                                     TopUpComm:= LoanTopUp.Commision;
                                     TotalTopupComm:=TotalTopupComm+TopUpComm;
                                     GenJournalLine.Amount:=TopUpComm*-1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     BatchTopUpAmount:=BatchTopUpAmount+(GenJournalLine.Amount*-1);
                                     END;
                                 UNTIL LoanTopUp.NEXT = 0;

                                 END;

                                 //IF Top Up
                                 IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                 IF "Mode Of Disbursement"="Mode Of Disbursement"::"Individual Cheques" THEN BEGIN
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     GenJournalLine.Amount:=(LoanDisbAmount-(LoanApps."Top Up Amount"+TotalTopupComm))*-1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 END;
                                 END;



                                 END ELSE BEGIN
                                     IF "Mode Of Disbursement"="Mode Of Disbursement"::"Individual Cheques" THEN BEGIN
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     END;
                                 END;


                                 TotBoost:=0;

                                 //Cyrus Boost Shares
                                 IF LoanApps."Bridge Shares">0 THEN BEGIN

                                 //Bridging Shares
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";//LoanApps."BOSA No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Share Boost by: ' + LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=-LoanApps."Bridge Shares";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivityBOSA;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranchBOSA;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     TotBoost:=TotBoost+ABS(GenJournalLine.Amount);

                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=GenSetUp."Boosting Commission Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Commision on Shares boost';
                                     GenJournalLine.Amount:=(LoanApps."Bridge Shares"*(GenSetUp."Boosting Shares %"/100))*-1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     TotBoost:=TotBoost+ABS(GenJournalLine.Amount);


                                 END;
                                 //Cyrus Boost Shares


                                 //Cyrus Post LPO Discount
                                 IF LoanApps."Discount Amount">0 THEN BEGIN

                                 //Bridging Shares
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     GenJournalLine."Account No.":=LoanType."Discount G/L Account";
                                     END;
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Discount: ' + LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=-LoanApps."Discount Amount";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivityBOSA;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranchBOSA;
                                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                 END;

                                 //Cyrus post LPO Discount
                                 {
                                 LoanApps.CALCFIELDS(LoanApps."Top Up Amount");
                                 //END;
                                 BatchTopUpAmount:=BatchTopUpAmount+(LoanApps."Top Up Amount");
                                 //BatchTopUpComm:=BatchTopUpComm+TotalTopupComm;
                                 }




                                 //SendSMS;
                                 //SendMail;

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

                                 //Contractual Shares Variation//surestep
                                 LoanApps."Issued Date":="Posting Date";
                                 LoanApps.Advice:=TRUE;
                                 LoanApps."Advice Type":=LoanApps."Advice Type"::"Fresh Loan";
                                 LoanApps.Posted:=TRUE;
                                 LoanApps."Loan Disbursement Date":=TODAY;
                                 LoanApps."Loan Status":=LoanApps."Loan Status"::Issued;
                                 LoanApps."Disbursed By":=USERID;
                                 LoanApps."Disbursement Date":=TODAY;
                                 LoanApps."Disbursed Time":=TIME;
                                 LoanApps.MODIFY;

                                 //SMS MESSAGE
                                 {
                                       SMSMessages.RESET;
                                       IF SMSMessages.FIND('+') THEN BEGIN
                                       iEntryNo:=SMSMessages."Entry No";
                                       iEntryNo:=iEntryNo+1;
                                       END
                                       ELSE BEGIN
                                       iEntryNo:=1;
                                       END;

                                       SMSMessages.RESET;
                                       SMSMessages.INIT;
                                       SMSMessages."Entry No":=iEntryNo;
                                       SMSMessages."Account No":=LoanApps."Client Code";
                                       SMSMessages."Date Entered":=TODAY;
                                       SMSMessages."Time Entered":=TIME;
                                       SMSMessages.Source:='LOAN APPL';
                                       SMSMessages."Entered By":=USERID;
                                       SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
                                       SMSMessages."SMS Message":='Dear '+LoanApps."Client Name"+', your '+LoanApps."Loan Product Type Name"+' of Ksh.'+FORMAT(LoanApps."Approved Amount")+
                                                                  ' has been disbursed to your FOSA Account. TELEPOST SACCO.';
                                       Cust.RESET;
                                       Cust.SETRANGE(Cust."No.",LoanApps."Client Code");
                                       IF Cust.FIND('-') THEN
                                       SMSMessages."Telephone No":=Cust."Phone No.";
                                       SMSMessages.INSERT;
                                   }


                                     IF Cust.GET(LoanApps."Client Code") THEN BEGIN
                                         LoanApps."Account No" := Cust."FOSA Account";
                                         Msg := 'Dear '+LoanApps."Client Name"+', your '+LoanApps."Loan Product Type Name"+' of Ksh.'+FORMAT(LoanApps."Approved Amount")+
                                                                  ' has been disbursed to your FOSA Account. TELEPOST SACCO.';


                                         SkyMbanking.SendSms(SMSSource::LOAN_POSTED,Cust."Phone No.",Msg,LoanApps."Loan  No.",LoanApps."Account No",TRUE,0,TRUE);
                                     END;






                                 IF "Mode Of Disbursement" = "Mode Of Disbursement"::EFT THEN BEGIN


                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="Document No.";
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="BOSA Bank Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:="Description/Remarks";
                                 //MESSAGE('%1',ShareAmount);
                                 IF "Batch Type" = "Batch Type"::"Appeal Loans" THEN
                                 GenJournalLine.Amount:=(EftAmount-(BatchTopUpAmount+BatchTopUpComm+TCharges+Commitm))*-1
                                 ELSE
                                 GenJournalLine.Amount:=(EftAmount-(BatchTopUpAmount+BatchTopUpComm+TCharges+Commitm))*-1;

                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                  GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                  GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                  GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;


                                 UNTIL LoanApps.NEXT = 0;

                                 END;

                                 //BOSA Bank Entry
                                 IF "Mode Of Disbursement" = "Mode Of Disbursement"::Cheque THEN BEGIN
                                 TCharges:=0;
                                 linecharges:=0;
                                 PCharges.RESET;
                                 PCharges.SETRANGE(PCharges."Product Code",LoanApps."Loan Product Type");
                                 IF PCharges.FIND('-') THEN BEGIN
                                 REPEAT
                                   //  PCharges.TESTFIELD(PCharges."G/L Account");

                                     LineNo:=LineNo+10000;
                                     IF PCharges."G/L Account"<>'' THEN BEGIN
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=PCharges."G/L Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     {IF (PCharges."Use Perc"=TRUE) AND (PCharges.Code<>'INS') THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;}
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;

                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //Don't top up charges on principle
                                     //IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") OR
                                     //   ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") THEN BEGIN


                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     //END;
                                     //Don't top up charges on principle
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                 //GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine."Account Type"=GenJournalLine."Account Type"::Member THEN
                                     GenJournalLine."Posting Group":='';
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                                       TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                 END;
                                 LineNo:=LineNo+10000;
                                  IF PCharges."Retain Deposits"=TRUE THEN BEGIN
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                                       TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                 END;
                                 LineNo:=LineNo+10000;
                                 IF PCharges."Retain ShareCapital"=TRUE THEN BEGIN
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     //GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * (PCharges.Percentage/100))
                                     END ELSE
                                     GenJournalLine.Amount:=PCharges.Amount * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                    IF "Mode Of Disbursement"="Mode Of Disbursement"::Cheque THEN
                                    TCharges:=(TCharges+GenJournalLine.Amount);
                                    END;
                                 UNTIL PCharges.NEXT = 0;
                                 linecharges:=(TCharges)*-1;
                                 END;
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                 GenJournalLine.Amount:=("Total Appeal Amount"-(BatchTopUpAmount+BatchTopUpComm+Commitm+(linecharges*-1)))*-1
                                 ELSE
                                 GenJournalLine.Amount:=("Total Loan Amount"-(BatchTopUpAmount+BatchTopUpComm+Commitm+linecharges))*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;

                                 //END;



                                 //Transfer to FOSA
                                 IF ("Mode Of Disbursement"="Mode Of Disbursement"::"Transfer to FOSA") OR
                                    ("Mode Of Disbursement"="Mode Of Disbursement"::"FOSA Loans") OR
                                    ("Mode Of Disbursement"="Mode Of Disbursement"::EFT) THEN BEGIN
                                 //DActivity:='FOSA';
                                 //DBranch:='NAIROBI';
                                 IF "Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans" THEN BEGIN
                                 DActivity:='';
                                 DBranch:='';
                                 IF Vend.GET(LoanApps."Client Code") THEN BEGIN
                                 DActivity:=Vend."Global Dimension 1 Code";
                                 DBranch:=Vend."Global Dimension 2 Code";
                                 END;
                                 END;


                                 IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"Transfer to FOSA") OR ("Mode Of Disbursement" = "Mode Of Disbursement"::EFT) THEN BEGIN
                                 DActivity:='';
                                 DBranch:='';
                                 IF Cust.GET(LoanApps."Client Code") THEN BEGIN
                                 DActivity:=Cust."Global Dimension 1 Code";
                                 DBranch:=Cust."Global Dimension 2 Code";
                                 END;
                                 END;

                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
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
                                     BatchTopUpAmount:=0;

                                     LoanApps.CALCFIELDS(LoanApps."Top Up Amount");
                                     IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                     LoanTopUp.RESET;
                                     LoanTopUp.SETRANGE(LoanTopUp."Loan No.",LoanApps."Loan  No.");
                                     LoanTopUp.SETFILTER(LoanTopUp."Client Code",LoanApps."Client Code");
                                     IF LoanTopUp.FIND('-') THEN BEGIN
                                     //TopUpComm:=LoanTopUp.Commision;
                                     REPEAT
                                     //TopUpComm:=LoanTopUp.Commision;
                                     //TotalInterestTopUpNew:=ROUND(LoanTopUp."Interest Top Up",0.01,'>');
                                     TotalTopupComm:=TotalTopupComm+LoanTopUp.Commision+LoanTopUp."Principle Top Up"+LoanTopUp."Interest Top Up";
                                     //TotalTopupComm:=TotalTopupComm+LoanTopUp.Commision+LoanTopUp."Principle Top Up"+TotalInterestTopUpNew;
                                     TotalInterestTopUp+=LoanTopUp."Interest Top Up"+LoanTopUp."Principle Top Up"+LoanTopUp.Commision;
                                        UNTIL LoanTopUp.NEXT = 0;
                                     //BatchTopUpAmount:=TotalTopupComm+lo;
                                     END;
                                     END;

                                     BatchTopUpAmount:=TotalTopupComm;;

                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                    // LoanApps.TESTFIELD(LoanApps."Account No");
                                    // MESSAGE('found');
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No"; //newwork
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     IF (LoanApps."Account No" = '350011') OR (LoanApps."Account No" = '350012') THEN BEGIN
                                     GenJournalLine.Description:=LoanApps."Client Name";
                                     IF Cust.GET(LoanApps."Client Code") THEN BEGIN
                                     GenJournalLine."External Document No.":=Cust."ID No.";
                                     GenJournalLine.Description:= Cust."Payroll/Staff No" + ' - ' + GenJournalLine.Description;
                                     END;
                                     END ELSE
                                     GenJournalLine.Description:=LoanApps."Loan Product Type Name";
                                     // Loan to CIC Account
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     IF LoanType."Post to G/L Account"=TRUE THEN BEGIN
                                     LoanType.TESTFIELD(LoanType."G/L Account No");
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=LoanType."G/L Account No";
                                     GenJournalLine."External Document No.":=Cust."ID No.";
                                     GenJournalLine.Description:=COPYSTR(LoanApps."Client Name" +'-'+Cust."Payroll/Staff No",1,30);
                                     END;
                                     END;
                                     {
                                     //IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     //IF LoanType."Post to Deposits"=TRUE THEN BEGIN
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine."Account No.":=LoanApps."BOSA No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."External Document No.":=Cust."ID No.";
                                     GenJournalLine.Description:=LoanApps."Loan Product Type Name";
                                     END;
                                     END;
                                     }
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     IF LoanType."Post to Vendor"=TRUE THEN BEGIN
                                      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     IF LoanType."Vendor Account No"='' THEN
                                     GenJournalLine."Account No.":=LoanApps."Vendor No"
                                     ELSE IF LoanType."Vendor Account No"<>'' THEN
                                     GenJournalLine."Account No.":=LoanType."Vendor Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."External Document No.":=Cust."ID No.";
                                     GenJournalLine.Description:=COPYSTR(LoanApps."Client Name" +'-'+Cust."Payroll/Staff No",1,30);
                                     END;
                                     END;
                                     //GenJournalLine.Amount:=(LoanDisbAmount-(LoanApps."Top Up Amount"+TotalTopupComm))*-1;
                                     //GenJournalLine.Amount:=(LoanDisbAmount-(LoanApps."Top Up Amount"+LoanApps."Bridge Shares"))*-1;
                                     GenJournalLine.Amount:=(LoanDisbAmount-(LoanApps."Discount Amount"))*-1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                      IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                     //Split entries to FOSA******Yidah
                                      //Total Top up
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Total Top up recovery';
                                     GenJournalLine.Amount:=BatchTopUpAmount;//LoanApps."Top Up Amount"+LoanTopUp.Commision;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                      //Total Top up
                                 END;
                                 //upfrront
                                 IF LoanApp."interest upfront Amount1" >0 THEN BEGIN
                                  LineNo:=LineNo+10000;

                                             GenJournalLine.INIT;
                                             GenJournalLine."Journal Template Name":='PAYMENTS';
                                             GenJournalLine."Journal Batch Name":='LOANS';
                                             GenJournalLine."Line No.":=LineNo;
                                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                             GenJournalLine."Account No.":=LoanApps."Client Code";
                                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                             GenJournalLine."Document No.":="Document No.";
                                             GenJournalLine."Posting Date":="Posting Date";
                                             GenJournalLine.Description:='Interest Due';
                                             GenJournalLine.Amount:=LoanApp."interest upfront Amount1";
                                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                             GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                                             GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                             GenJournalLine."Group Code":=LoanApps."Group Code";
                                             GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                             GenJournalLine."Bal. Account No.":=LoanType."Loan Interest Account";
                                             GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                             GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                             IF GenJournalLine.Amount<>0 THEN
                                             GenJournalLine.INSERT;


                                     END;

                                 //pension

                                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                  LineNo:=LineNo+10000;

                                             GenJournalLine.INIT;
                                             GenJournalLine."Journal Template Name":='PAYMENTS';
                                             GenJournalLine."Journal Batch Name":='LOANS';
                                             GenJournalLine."Line No.":=LineNo;
                                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                             GenJournalLine."Account No.":=LoanApps."Client Code";
                                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                             GenJournalLine."Document No.":="Document No.";
                                             GenJournalLine."Posting Date":="Posting Date";
                                             GenJournalLine.Description:='Pension deposit deduction ';
                                             GenJournalLine.Amount:=-LoanApps."Approved Amount"*LoanType."Pens dep %";
                                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                             GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                             GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                             GenJournalLine."Group Code":=LoanApps."Group Code";
                                             GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                             GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                             GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                             GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                             IF GenJournalLine.Amount<>0 THEN
                                             GenJournalLine.INSERT;

                                 END;
                                 //sharecapital
                                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                  LineNo:=LineNo+10000;
                                             GenJournalLine.INIT;
                                             GenJournalLine."Journal Template Name":='PAYMENTS';
                                             GenJournalLine."Journal Batch Name":='LOANS';
                                             GenJournalLine."Line No.":=LineNo;
                                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                             GenJournalLine."Account No.":=LoanApps."Client Code";
                                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                             GenJournalLine."Document No.":="Document No.";
                                             GenJournalLine."Posting Date":="Posting Date";
                                             GenJournalLine.Description:='Share Capital  deduction ';
                                             GenJournalLine.Amount:=-LoanApps."Approved Amount"*LoanType."Share Cap %";
                                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                             GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
                                             GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                             GenJournalLine."Group Code":=LoanApps."Group Code";
                                 //             GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 //             GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                             GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                             GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                             IF GenJournalLine.Amount<>0 THEN
                                             GenJournalLine.INSERT;

                                  LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Share Capital  deduction ';
                                     GenJournalLine.Amount:=LoanApps."Approved Amount"*LoanType."Share Cap %";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                 END;
                                 //END;
                                 //end



                                     //Bridge Shares
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Share boost recovery';
                                     GenJournalLine.Amount:=LoanApps."Bridge Shares";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     //Bridge Shares


                                     //Split entries to FOSA******Yidah

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
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
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
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     UNTIL Loans.NEXT = 0;


                                     END;

                                     { ELSE BEGIN


                                     IF (LoanApps."Special Loan Amount"+LoanApps."Other Commitments Clearance") > 0 THEN
                                     ERROR('Bridging loan for %1 not found.',LoanApps."Loan  No.");
                                     END;
                                 }

                                     //Transfer Project Loan Amount
                                     IF LoanApps."Project Amount" > 0 THEN BEGIN
                                     LoanApps.TESTFIELD(LoanApps."Project Account No");
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;



                                     END;
                                     //Transfer Project Loan Amount


                                 UNTIL LoanApps.NEXT = 0;
                                 END;


                                 //eft

                                 END;

                                 //first interest repayment

                                    //IF LoanApps."Recovery Mode"=LoanApps."Recovery Mode"::Checkoff THEN  BEGIN
                                    //IF CONFIRM('Are you sure to charge 1st month interest?') = FALSE THEN
                                   // EXIT;
                                   Chargeinterest:=FALSE;
                                    IF CONFIRM('Are you sure to charge 1st month interest',FALSE)=TRUE THEN
                                    Chargeinterest:=TRUE;

                                   IF Chargeinterest=TRUE THEN BEGIN
                                    IF interestDays<=0 THEN
                                   ERROR('Interest Days cannot be less or equal to 0');


                                     //charge interest first
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine.Description:='Interest Due';
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":= GenJournalLine."Transaction Type"::"Interest Due";
                                     GenJournalLine.Amount:=((LoanApps."Loan Interest Repayment"/30)*interestDays);
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Bal. Account No.":=LoanType."Loan Interest Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     END;
                                     IF GenJournalLine.Amount<>0 THEN
                                       GenJournalLine.INSERT;
                                     //end of charge



                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;

                                    // GenJournalLine."Account No.":=LoanApps."Account No";

                                     GenJournalLine.Description:='1st interest repayment';
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     //MESSAGE('int repay is %1',LoanApps."Loan Interest Repayment");
                                     GenJournalLine.Amount:=(LoanApps."Loan Interest Repayment"/30)*interestDays;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     //GenJournalLine."Transaction Type":= GenJournalLine."Transaction Type"::"Interest Paid";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                    // MESSAGE('sdfghj');

                                    //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";

                                    //MESSAGE('saDzfghvjb int22');

                                    // IF LoanApps."Loan Product Type"='L01' THEN BEGIN
                                     // GenJournalLine."Account No.":='300-000-010'

                                   // IF LoanApps."Loan Product Type "=' L01' THEN
                                  // GenJournalLine."Account No.":='300-000-010'
                                  //MESSAGE('saDzfghvjb int');
                                  //IF LoanApps.GET(LoansBatch."Batch No.") THEN
                                  // MESSAGE('success');
                                   {
                                     IF LoanApps."Loan Product Type Name"='Normal Loan ' THEN BEGIN
                                      GenJournalLine."Bal. Account No.":='300-000-012';
                                      END;
                                     IF LoanApps."Loan Product Type Name"='Instant Loan' THEN BEGIN
                                    // MESSAGE('asdxfgchjb');
                                     GenJournalLine."Bal. Account No.":='300-000-002';
                                    END;
                                      IF LoanApps."Loan Product Type Name"='Reloaded Plus' THEN BEGIN
                                     GenJournalLine."Bal. Account No.":='300-000-018';
                                     END;
                                     IF LoanApps."Loan Product Type Name"='FDA Advance Loan' THEN BEGIN
                                     GenJournalLine."Bal. Account No.":='300-000-020';
                                     END;
                                    IF LoanApps."Loan Product Type Name"='Golden age advance Loan' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-021';
                                    END;
                                    IF LoanApps."Loan Product Type Name"='Okoa Loan' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-017';
                                    END;
                                    IF LoanApps."Loan Product Type Name"='Normal Loan' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-012';
                                    END;

                                    IF LoanApps."Loan Product Type Name"='Emergency Loan' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-016';
                                    END;

                                    IF LoanApps."Loan Product Type Name"='ESS Loan' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-016';
                                    END;

                                    IF LoanApps."Loan Product Type Name"='Consumer Loan 2015' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-022';
                                    END;

                                    IF LoanApps."Loan Product Type Name"='super loan' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-009';
                                    END;

                                  IF LoanApps."Loan Product Type Name"='Jijenge Loan' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-010';
                                    END;
                                   // ELSE IF LoanApps."Loan Product Type Name"='Normal Loan' THEN
                                     //GenJournalLine."Bal. Account No.":='100-200-211'

                                    IF LoanApps."Loan Product Type Name"='Salary Advance Bosa' THEN BEGIN
                                    GenJournalLine."Bal. Account No.":='300-000-005';
                                    END;
                                    }
                                    //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                    //MESSAGE('amount is %1',GenJournalLine.Amount);

                                    IF GenJournalLine.Amount<>0 THEN

                                    GenJournalLine.INSERT;




                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;

                                    // GenJournalLine."Account No.":=LoanApps."Account No";

                                     GenJournalLine.Description:='1st interest repayment';
                                     GenJournalLine."Document No.":="Document No.";
                                    // GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                    //MESSAGE('int repay is %1',LoanApps."Loan  No.");
                                     GenJournalLine.Amount:=-1*((LoanApps."Loan Interest Repayment"/30)*interestDays);
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine."Transaction Type":= GenJournalLine."Transaction Type"::"Interest Paid";
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN

                                    GenJournalLine.INSERT;
                                    END;

                                 //End first month repayment

                                 //ERROR('Loans cant be posted.Contact Telepost');



                                 //End Agency Disbursement


                                 //kiganya
                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;

                                 //Post New

                                 Posted:=TRUE;
                                 MODIFY;


                                 MESSAGE('Batch posted successfully.');

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Batch Posting',0,
                                 'CREDIT',TODAY,TIME,'',"Batch No.",'','');
                                 //End Create Audit Entry
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Post Agency;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SMSCharges@1120054000 : Record 51516554;
                                 SMSCharge@1120054001 : Decimal;
                                 SMSExcise@1120054002 : Decimal;
                               BEGIN
                                 IF "Mode Of Disbursement"<>"Mode Of Disbursement"::Agency THEN
                                 ERROR('This is only available for agency loans.');
                                 IF Status<>Status::Approved THEN
                                   ERROR('The batch must be approved.');
                                 TESTFIELD("Description/Remarks");
                                 TESTFIELD("Posting Date");
                                 IF CONFIRM('Are you sure you want to post this batch?',TRUE,FALSE) = TRUE THEN BEGIN


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 GenJournalLine.DELETEALL;


                                 GenSetUp.GET;

                                 DActivity:='';
                                 DBranch:='';


                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Batch No.","Batch No.");
                                 LoanApps.SETRANGE(LoanApps."Loan Status",LoanApps."Loan Status"::Approved);
                                 IF LoanApps.FIND('-') THEN BEGIN
                                 REPEAT

                                 IF USERID=LoanApps."Approved By" THEN
                                 ERROR('Loan approver %1 is not permitted to disburse loan %2',USERID,LoanApps."Loan  No.");
                                 LoanDisbAmount:=LoanApps."Approved Amount";
                                 //Disburse Loans via Agency
                                 RunningDeductions:=0;
                                 IF "Mode Of Disbursement"="Mode Of Disbursement"::Agency THEN BEGIN
                                 //TCharges:=0;
                                 PCharges.RESET;
                                 PCharges.SETRANGE(PCharges."Product Code",LoanApps."Loan Product Type");
                                 IF PCharges.FIND('-') THEN BEGIN
                                 REPEAT


                                     LineNo:=LineNo+10000;
                                     PercAmount:=0;
                                    IF PCharges."G/L Account"<>'' THEN BEGIN
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=PCharges."G/L Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description+'-'+LoanApps."Loan Product Type Name";
                                     IF PCharges."Use Perc"=TRUE THEN
                                     PercAmount:=(LoanDisbAmount * (PCharges.Percentage/100))*-1
                                     ELSE
                                     PercAmount:=PCharges.Amount * -1;
                                      //MESSAGE('Pcharge%1 Charge%2',PCharges.Code,PercAmount);
                                     GenJournalLine.Amount:=PercAmount;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine."Account Type"=GenJournalLine."Account Type"::Member THEN
                                     GenJournalLine."Posting Group":='';
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     //  TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                     RunningDeductions:=RunningDeductions+PercAmount;



                                 ODAuth.RESET;
                                 ODAuth.SETRANGE(ODAuth.Status,ODAuth.Status::Approved);
                                 ODAuth.SETRANGE(ODAuth.Expired,FALSE);
                                 ODAuth.SETRANGE(ODAuth.Liquidated,FALSE);
                                 ODAuth.SETRANGE(ODAuth.Posted,TRUE);
                                 ODAuth.SETRANGE(ODAuth."Account No.",LoanApps."Account No");
                                 IF ODAuth.FINDFIRST THEN BEGIN
                                     ODAuth.MODIFYALL(ODAuth.Expired,TRUE);
                                     ODAuth.MODIFYALL(ODAuth.Liquidated,TRUE);
                                 END;
                                 END;
                                 UNTIL PCharges.NEXT = 0;
                                 END;
                                 END;


                                 //Boosting Shares Commision
                                 IF LoanApps."Boosting Commision" > 0 THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
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
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                     RunningDeductions:=RunningDeductions+LoanApps."Boosting Commision";
                                 END;

                                 BoostDeposits(LoanApps);
                                 ExpressLoanCharge(LoanApps);
                                 //TCharges:=0;
                                 ShareAmount:=0;
                                 Scharge:=0;
                                 //Shares transfer Commision
                                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                 IF LoanType.Source=LoanType.Source::BOSA THEN BEGIN
                                 IF LoanType."Post to Deposits"=TRUE THEN BEGIN
                                 //post deeboster to share deposit
                                 IF LoanType.Code='L16' THEN BEGIN
                                 LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Deeboster Deposit Transfer';
                                     ShareAmount:=(LoanDisbAmount*(50/100));
                                     GenJournalLine.Amount:=ShareAmount*-1;
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     IF "Mode Of Disbursement"<>"Mode Of Disbursement"::EFT THEN
                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                     //Scharge:=Scharge+(GenJournalLine.Amount)*-1;
                                     ShareAmount:=0;



                                      LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Deeboster Deposit Transfer';
                                     ShareAmount:=(LoanDisbAmount*(50/100));
                                     GenJournalLine.Amount:=ShareAmount ;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Bal. Account No.":=LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");

                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     TCharges:=TCharges+(GenJournalLine.Amount);
                                     RunningDeductions:=RunningDeductions+ShareAmount;



                                     //topup commision on debooster
                                     ShareAmount:=0;
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":=Rec."Posting Date";
                                     GenJournalLine.Description:='Deeboster Topup Commision';
                                     ShareAmount:=(LoanDisbAmount*(50/100));
                                     GenJournalLine.Amount:=ShareAmount ;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 END;

                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":=Rec."Posting Date";
                                     GenJournalLine.Description:='Share Transfer';
                                     ShareAmount:=(LoanDisbAmount*(LoanType."Share Cap %"/100));
                                     IF ShareAmount > LoanType."Max Share Cap" THEN
                                     GenJournalLine.Amount:=LoanType."Max Share Cap"*-1
                                     ELSE
                                     GenJournalLine.Amount:=(LoanDisbAmount*(LoanType."Share Cap %"/100))*-1;
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     //IF "Mode Of Disbursement"<>"Mode Of Disbursement"::EFT THEN
                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                     ShareAmount:=0;



                                      LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Share Transfer';
                                     ShareAmount:=(LoanDisbAmount*(LoanType."Share Cap %"/100));
                                    IF ShareAmount > LoanType."Max Share Cap" THEN
                                     GenJournalLine.Amount:=LoanType."Max Share Cap"
                                     ELSE
                                     GenJournalLine.Amount:=(LoanDisbAmount*(LoanType."Share Cap %"/100));
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                       //  IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                                     TCharges:=TCharges+(GenJournalLine.Amount);

                                   END;
                                 END;
                                 END;

                                 //Recover Other Committments Commision
                                 LoanApps.CALCFIELDS(LoanApps."Other Commitments Clearance");
                                 IF LoanApps."Other Commitments Clearance">0 THEN BEGIN
                                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=LoanType."Top Up Commision Account";//LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Commission on Other Committments';
                                     GenJournalLine.Amount:=(LoanApps."Other Commitments Clearance"*(LoanType."Bank Comm %"/100))*-1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";

                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                         TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                  END;
                                 END;


                                 //Other Commitment clearance
                                 Commitm:=0;

                                 LoanApps.CALCFIELDS(LoanApps."Other Commitments Clearance");
                                 IF LoanApps."Other Commitments Clearance" > 0 THEN BEGIN
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="Document No.";;
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=LoanType."Bank Comm A/c";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Bridged Payroll Commitements';
                                 GenJournalLine.Amount:=-LoanApps."Other Commitments Clearance";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                 //END;
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 TCharges:=TCharges+(GenJournalLine.Amount*-1);
                                 //Commitm:=(Commitm+GenJournalLine.Amount)*-1;
                                 //PostBankersCheq()
                                 END;


                                 //Other Commitment clearance

                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                           GenJournalLine."Account No.":=LoanApps."Client Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='Principal Amount';
                                           GenJournalLine.Amount:=LoanDisbAmount;
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                           GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           EftAmount:=EftAmount+GenJournalLine.Amount;


                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                           GenJournalLine."Account No.":=LoanApps."Account No";
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='Principal Amount Credit FOSA';
                                           GenJournalLine.Amount:=-LoanDisbAmount;
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                           GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           EftAmount:=EftAmount+GenJournalLine.Amount;

                                 //MESSAGE('RunningDed%1',RunningDeductions);
                                 RunningDeductions:=RunningDeductions*-1;



                                 //Loan Offset
                                 IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                 LoanTopUp.RESET;
                                 LoanTopUp.SETRANGE(LoanTopUp."Loan No.",LoanApps."Loan  No.");
                                 LoanTopUp.SETFILTER(LoanTopUp."Client Code",LoanApps."Client Code");
                                 IF LoanTopUp.FIND('-') THEN BEGIN

                                 REPEAT

                                     //Principle
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Off Set By - ' +LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=LoanTopUp."Principle Top Up"* -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";

                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     BatchTopUpAmount:=BatchTopUpAmount+(GenJournalLine.Amount*-1);


                                     //Interest (Reversed if top up)
                                    IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     //charge first
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest Due charged on top up ' ;
                                     GenJournalLine.Amount:=LoanTopUp."Interest Charged";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);

                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Bal. Account No.":=LoanType."Loan Interest Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");

                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Due";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     //end of charge

                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest Due Paid on top up ' ;
                                     GenJournalLine.Amount:=-LoanTopUp."Interest Top Up";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     BatchTopUpAmount:=BatchTopUpAmount+(GenJournalLine.Amount*-1);



                                     END;
                                     //Commision
                                     TopUpComm:=0;
                                     TotalTopupComm:=0;
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN

                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Document No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest on topup';
                                     TopUpComm:= LoanTopUp.Commision;
                                     TotalTopupComm:=TotalTopupComm+TopUpComm;
                                     GenJournalLine.Amount:=TopUpComm*-1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     BatchTopUpAmount:=BatchTopUpAmount+(GenJournalLine.Amount*-1);
                                     END;
                                 UNTIL LoanTopUp.NEXT = 0;
                                 END;
                                 END;
                                 //End Loan Offset
                                 RunningDeductions:=RunningDeductions-BatchTopUpAmount;

                                 //SMS Charge
                                           SMSCharges.GET('LOAN APPL');
                                           SMSCharge:=SMSCharges.Amount;
                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                           GenJournalLine."Account No.":=LoanApps."Account No";
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='SMS Charge';
                                           GenJournalLine.Amount:=SMSCharge;
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           EftAmount:=EftAmount+GenJournalLine.Amount;


                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                           GenJournalLine."Account No.":='100-500-304';
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='SMS Charge';
                                           GenJournalLine.Amount:=-SMSCharge;
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                         RunningDeductions:=RunningDeductions+SMSCharge;
                                 //END;


                                 //SMS Excise Duty
                                           SMSExcise:=(SMSCharge * (GenSetUp."Excise Duty(%)"/100));
                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                           GenJournalLine."Account No.":=LoanApps."Account No";
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='SMS Excise duty';
                                           GenJournalLine.Amount:=SMSExcise;
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           EftAmount:=EftAmount+GenJournalLine.Amount;


                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                           GenJournalLine."Account No.":=GenSetUp."Excise Duty Account";
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='SMS Excise Duty';
                                           GenJournalLine.Amount:=-SMSExcise;
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           RunningDeductions:=RunningDeductions+SMSExcise;
                                 //SMS Excise Duty End


                                 //Debit FOSA Account
                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                           GenJournalLine."Account No.":=LoanApps."Account No";
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='Principal Amount less deductions';
                                           GenJournalLine.Amount:=(LoanDisbAmount-RunningDeductions);
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           EftAmount:=EftAmount+GenJournalLine.Amount;


                                           LineNo:=LineNo+10000;

                                           GenJournalLine.INIT;
                                           GenJournalLine."Journal Template Name":='PAYMENTS';
                                           GenJournalLine."Journal Batch Name":='LOANS';
                                           GenJournalLine."Line No.":=LineNo;
                                           GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                           GenJournalLine."Account No.":='100-500-304';
                                           GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                           GenJournalLine."Document No.":="Document No.";
                                           GenJournalLine."Posting Date":="Posting Date";
                                           GenJournalLine.Description:='Principal Amount Credit';
                                           GenJournalLine.Amount:=-(LoanDisbAmount-RunningDeductions);
                                           GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                           GenJournalLine."Group Code":=LoanApps."Group Code";
                                           GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                           GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                           GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                           GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                           IF GenJournalLine.Amount<>0 THEN
                                           GenJournalLine.INSERT;
                                           //BOSA Bank Entry
                                           EftAmount:=EftAmount+GenJournalLine.Amount;
                                 //end fosa


                                 //Generate Data Sheet Advice
                                     PTEN:='';

                                     IF STRLEN(LoanApps."Staff No")=10 THEN BEGIN
                                     PTEN:=COPYSTR(LoanApps."Staff No",10);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=9 THEN BEGIN
                                      PTEN:=COPYSTR(Loans."Staff No",9);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=8 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",8);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=7 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",7);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=6 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",6);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=5 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",5);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=4 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",4);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=3 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",3);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=2 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",2);
                                     END ELSE IF STRLEN(LoanApps."Staff No")=1 THEN BEGIN
                                      PTEN:=COPYSTR(LoanApps."Staff No",1);
                                      END;


                                     IF LoanTypes.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     IF Customer.GET(LoanApps."Client Code") THEN BEGIN
                                     //Loans."Staff No":=Customer."Payroll/Staff No";

                                     DataSheet.RESET;
                                     DataSheet.SETRANGE(DataSheet."PF/Staff No",LoanApps."Staff No");
                                     DataSheet.SETRANGE(DataSheet."Type of Deduction",LoanApps."Loan Product Type");
                                     DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                     IF DataSheet.FIND('-') THEN BEGIN
                                     DataSheet.DELETE;
                                     END;

                                     DataSheet.RESET;
                                     DataSheet.SETRANGE(DataSheet."PF/Staff No",LoanApps."Staff No");
                                     DataSheet.SETRANGE(DataSheet."Type of Deduction",LoanApps."Loan Product Type");
                                     DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                     IF DataSheet.FIND('-') THEN BEGIN
                                     END;
                                     END;
                                     END;
                                 //LoanApps."Loan Status":=Loans."Loan Status"::Issued;
                                 //LoanApps.Posted:=TRUE;
                                 //LoanApps.MODIFY;
                                 UNTIL LoanApps.NEXT=0;
                                 END;
                                 {
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;

                                 //Post New

                                 Posted:=TRUE;
                                 MODIFY;


                                 MESSAGE('Batch posted successfully.');

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Batch Posting',0,
                                 'CREDIT',TODAY,TIME,'',"Batch No.",'','');
                                 //End Create Audit Entrys
                                 }
                                 END;
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
                               END;
                                }
      { 1120054001;2 ;Action    ;
                      Name=ReJect Bactch;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to reject this batch?') = FALSE THEN EXIT;
                                 Status:=Status::Rejected;
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
                Editable=SourceEditable }

    { 1102760032;1;Field  ;
                SourceExpr="Batch Type";
                Editable=FALSE }

    { 1102760003;1;Field  ;
                SourceExpr="Description/Remarks";
                Editable=DescriptionEditable }

    { 1120054002;1;Field  ;
                Name=interestDays;
                CaptionML=ENU=interestDays;
                SourceExpr=interestDays }

    { 1102755000;1;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102760019;1;Field  ;
                SourceExpr="Total Loan Amount" }

    { 1102760029;1;Field  ;
                SourceExpr="No of Loans" }

    { 1102760011;1;Field  ;
                SourceExpr="Mode Of Disbursement";
                OnValidate=BEGIN
                             {IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                             "Cheque No.":="Batch No.";
                             MODIFY;  }
                             IF "Mode Of Disbursement"<>"Mode Of Disbursement"::"Transfer to FOSA" THEN
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
                Editable=PayingAccountEditable }

    { 1000000000;1;Field  ;
                Name=Cheque No.;
                SourceExpr=LoansBatch."Cheque No.";
                Editable=ChequeNoEditable }

    { 1000000001;1;Field  ;
                SourceExpr="Prepared By" }

    { 1102755001;1;Part   ;
                Name=Loans Sub-Page List;
                SubPageLink=Batch No.=FIELD(Batch No.),
                            System Created=CONST(No);
                PagePartID=Page51516250;
                Editable=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      Text001@1102755004 : TextConst 'ENU=Status must be open';
      ODAuth@1120054009 : Record 51516328;
      MovementTracker@1132 : Record 51516254;
      FileMovementTracker@1131 : Record 51516254;
      NextStage@1130 : Integer;
      TotalInterestTopUp@1120054010 : Decimal;
      TotalInterestTopUpNew@1120054011 : Decimal;
      EntryNo@1129 : Integer;
      NextLocation@1128 : Text[100];
      LoansBatch@1127 : Record 51516236;
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
      DocumentType@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
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
      Doc_Type@1144 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening,Member Closure,Loan,Loan Batch';
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
      SMSMessages@1120054002 : Record 51516329;
      AuditTrail@1120054005 : Codeunit 51516107;
      Trail@1120054004 : Record 51516655;
      EntryNos@1120054003 : Integer;
      SkyMbanking@1120054008 : Codeunit 51516701;
      SMSSource@1120054007 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,WITHDRAWAL';
      Msg@1120054006 : Text;
      RunningDeductions@1120054012 : Decimal;
      PercAmount@1120054013 : Integer;
      BoostingAmount@1120054014 : Decimal;

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

    LOCAL PROCEDURE BoostDeposits@1120054000(LoansRegister@1120054000 : Record 51516230);
    VAR
      LoanProductsSetup@1120054001 : Record 51516240;
      AmtToBoost@1120054002 : Decimal;
    BEGIN
      LoanProductsSetup.GET(LoansRegister."Loan Product Type");
      IF LoanProductsSetup."Deposit Boost %"<=0 THEN EXIT;

      WITH LoansRegister DO BEGIN

          AmtToBoost := "Approved Amount"*LoanProductsSetup."Deposit Boost %"*0.01;

          LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='PAYMENTS';
          GenJournalLine."Journal Batch Name":='LOANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
          GenJournalLine."Account No.":="Client Code";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":="Document No.";
          GenJournalLine."External Document No.":="Loan  No.";
          GenJournalLine."Posting Date":=Rec."Posting Date";
          GenJournalLine.Description:='Deposit Boost Transfer';
          GenJournalLine.Amount:=-AmtToBoost;
          //GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          {
          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
          GenJournalLine."Bal. Account No.":=LoanApps."Account No";
          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      }
          GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
          GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;



          LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='PAYMENTS';
          GenJournalLine."Journal Batch Name":='LOANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
          GenJournalLine."Account No.":="Account No";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":="Document No.";
          GenJournalLine."External Document No.":="Loan  No.";
          GenJournalLine."Posting Date":=Rec."Posting Date";
          GenJournalLine.Description:='Deposit Boost Transfer';
          GenJournalLine.Amount:=AmtToBoost ;
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
          GenJournalLine."Bal. Account No.":='';
          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
          GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
          GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;

      END;
    END;

    LOCAL PROCEDURE ExpressLoanCharge@1120054001(LoansRegister@1120054000 : Record 51516230);
    VAR
      LoanProductsSetup@1120054001 : Record 51516240;
      AmtToCharge@1120054002 : Decimal;
      GenSetup@1120054003 : Record 51516257;
    BEGIN
      GenSetup.GET;
      IF NOT LoansRegister."Express Loan" THEN EXIT;

      IF GenSetup."Express Loan Charge" > 0 THEN BEGIN

      WITH LoansRegister DO BEGIN

          AmtToCharge := "Approved Amount"*GenSetup."Express Loan Charge"*0.01;

          LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='PAYMENTS';
          GenJournalLine."Journal Batch Name":='LOANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
          GenJournalLine."Account No.":="Account No";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":="Document No.";
          GenJournalLine."External Document No.":="Loan  No.";
          GenJournalLine."Posting Date":=Rec."Posting Date";
          GenJournalLine.Description:='Express Loan Charge';
          GenJournalLine.Amount:=AmtToCharge ;
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
          GenJournalLine."Bal. Account No.":='300-000-062';
          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
          GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
          GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;

      END;
      END;
    END;

    LOCAL PROCEDURE FnMarkAsPosted@1120054031(LoanNumber@1120054000 : Code[10]);
    VAR
      Loan@1120054001 : Record 51516230;
    BEGIN
      Loans.RESET;
      Loans.SETRANGE(Loans."Loan  No.",LoanNumber);
      IF Loans.FINDFIRST THEN BEGIN
      Loans."Loan Status":=Loans."Loan Status"::Issued;
      Loans.Posted:=TRUE;
      Loans.MODIFY;
      END;
    END;

    BEGIN
    END.
  }
}

