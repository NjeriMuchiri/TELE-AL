OBJECT page 17392 Loans Posted Card
{
  OBJECT-PROPERTIES
  {
    Date=07/17/23;
    Time=[ 2:52:59 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516230;
    SourceTableView=WHERE(Source=FILTER(BOSA|FOSA),
                          Posted=CONST(Yes));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 SETRANGE(Posted,TRUE);
                 {IF "Loan Status"="Loan Status"::Approved THEN
                 CurrPage.EDITABLE:=FALSE;}
               END;

    OnNextRecord=BEGIN
                   {IF "Loan Status"="Loan Status"::Approved THEN
                   CurrPage.EDITABLE:=FALSE; }
                 END;

    OnNewRecord=BEGIN
                  Source:=Source::BOSA;
                END;

    OnModifyRecord=BEGIN
                     LoanAppPermisions();
                   END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateControl();
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760080;1 ;ActionGroup;
                      CaptionML=ENU=Loan;
                      Image=AnalysisView }
      { 1102760045;2 ;Action    ;
                      Name=Loan Appraisal;
                      CaptionML=ENU=Loan Appraisal;
                      Promoted=Yes;
                      Visible=FALSE;
                      Enabled=FALSE;
                      Image=Aging;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 REPORT.RUN(51516244,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 1102755038;2 ;Action    ;
                      Name=Member Statement;
                      Promoted=Yes;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","Client Code");
                                 REPORT.RUN(51516223,TRUE,FALSE,Cust);
                               END;
                                }
      { 1102760046;2 ;Separator  }
      { 1120054003;2 ;Action    ;
                      Name=View only;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=View only;
                      Promoted=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN
                                 IF LoanApp."Loan Product Type" <> 'INST' THEN BEGIN
                                 REPORT.RUN(51516317,TRUE,FALSE,LoanApp);
                                 END ELSE BEGIN
                                 REPORT.RUN(51516317,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 1000000010;2 ;Action    ;
                      Name=Appeal Loan;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=Appeal Loan;
                      Promoted=Yes;
                      Image=Apply;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN
                                 REPORT.RUN(51516264,TRUE,FALSE,LoanApp);
                               END;
                                }
      { 1120054006;2 ;Action    ;
                      Name=Mark Loan As Writeoff;
                      ShortCutKey=Ctrl+F7;
                      Promoted=Yes;
                      Image=Apply;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to mark this loan as a writeoff?',TRUE,FALSE)=TRUE THEN BEGIN
                                 WriteOff:=TRUE;
                                 MODIFY;
                                 MESSAGE('Record Updated.');
                                 END;
                               END;
                                }
      { 1000000006;2 ;Action    ;
                      Name=Assign Appeal Batch No.;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=Assign Appeal Batch No.;
                      Promoted=Yes;
                      Image=Attach;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN
                                 REPORT.RUN(51516290,TRUE,FALSE,LoanApp);
                               END;
                                }
      { 1102755012;2 ;Separator  }
      { 1102760008;2 ;Action    ;
                      CaptionML=ENU=Loans to Offset;
                      RunObject=page 17387;
                      RunPageLink=Loan No.=FIELD(Loan  No.);
                      Promoted=Yes;
                      Image=AddAction;
                      PromotedCategory=Process }
      { 1102760039;2 ;Separator  }
      { 1102755018;2 ;Action    ;
                      Name=Post Loan;
                      CaptionML=ENU=Post Loan;
                      Promoted=Yes;
                      Visible=true;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Posted = TRUE THEN
                                 ERROR('Loan already posted.');


                                 "Loan Disbursement Date":=TODAY;
                                 TESTFIELD("Loan Disbursement Date");
                                 "Posting Date":="Loan Disbursement Date";


                                 IF CONFIRM('Are you sure you want to post this loan?',TRUE) = FALSE THEN
                                 EXIT;

                                 {//PRORATED DAYS
                                 EndMonth:=CALCDATE('-1D',CALCDATE('1M',DMY2DATE(1,DATE2DMY("Posting Date",2),DATE2DMY("Posting Date",3))));
                                 RemainingDays:=(EndMonth-"Posting Date")+1;
                                 TMonthDays:=DATE2DMY(EndMonth,1);
                                 //PRORATED DAYS

                                 }
                                 IF "Mode of Disbursement"="Mode of Disbursement"::"Transfer to FOSA" THEN BEGIN

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 GenJournalLine.DELETEALL;


                                 GenSetUp.GET();

                                 DActivity:='BOSA';
                                 DBranch:='';//PKKS'NAIROBI';
                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Loan  No.","Loan  No.");
                                 LoanApps.SETRANGE(LoanApps."System Created",FALSE);
                                 LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                 IF LoanApps.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoanApps.CALCFIELDS(LoanApps."Special Loan Amount");
                                 DActivity:='';
                                 DBranch:='';
                                 IF Vend.GET(LoanApps."Client Code") THEN BEGIN
                                 DActivity:=Vend."Global Dimension 1 Code";
                                 DBranch:=Vend."Global Dimension 2 Code";
                                 END;

                                 LoanDisbAmount:=LoanApps."Approved Amount";

                                 IF (LoanApps."Special Loan Amount" > 0) AND (LoanApps."Bridging Loan Posted" = FALSE) THEN
                                 ERROR('Bridging Loans must be posted before the loans are disbursed. ' + LoanApps."Loan  No.");

                                 TCharges:=0;
                                 TopUpComm:=0;
                                 TotalTopupComm:=0;


                                 IF LoanApps."Loan Status"<>LoanApps."Loan Status"::Approved THEN
                                 ERROR('Loan status must be Approved for you to post Loan. - ' + LoanApps."Loan  No.");

                                 IF LoanApps.Posted = TRUE THEN
                                 ERROR('Loan has already been posted. - ' + LoanApps."Loan  No.");


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

                                 PCharges.RESET;
                                 PCharges.SETRANGE(PCharges."Product Code",LoanApps."Loan Product Type");
                                 IF PCharges.FIND('-') THEN BEGIN
                                 REPEAT
                                     PCharges.TESTFIELD(PCharges."G/L Account");

                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=PCharges."G/L Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description;
                                     IF PCharges."Use Perc" = TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * PCharges.Percentage/100) * -1;
                                     END  ELSE BEGIN
                                     GenJournalLine.Amount:=PCharges.Amount * -1;

                                    END;


                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //Don't top up charges on principle
                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     //Don't top up charges on principle
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);


                                 UNTIL PCharges.NEXT = 0;
                                 END;




                                 //Don't top up charges on principle
                                 TCharges:=0;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":="Client Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Document No.":="Loan  No.";
                                 GenJournalLine."External Document No.":="ID NO";
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine.Description:='Principal Amount';
                                 GenJournalLine.Amount:=LoanDisbAmount+ TCharges;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                 GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;




                                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                 IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                 LoanTopUp.RESET;
                                 LoanTopUp.SETRANGE(LoanTopUp."Loan No.",LoanApps."Loan  No.");
                                 IF LoanTopUp.FIND('-') THEN BEGIN
                                 REPEAT
                                     //Principle
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Off Set By - ' +LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=LoanTopUp."Principle Top Up" * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     //GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     //Principle
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Off Set By - ' +LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=LoanTopUp."Principle Top Up" ;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     //GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     //Interest (Reversed if top up)
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest paid ' + LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=-LoanTopUp."Interest Top Up";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     END;
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interest paid ' + LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=LoanTopUp."Interest Top Up";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     END;

                                     //Commision
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     IF LoanType."Top Up Commision" > 0 THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=LoanApps."Account No";

                                     GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     GenJournalLine."Bal. Account No.":=LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Commision on Loan Top Up';
                                     TopUpComm:=(LoanTopUp."Principle Top Up") * (LoanType."Top Up Commision"/100);
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

                                     END;
                                     END;
                                 UNTIL LoanTopUp.NEXT = 0;
                                 END;
                                 END;
                                 END;

                                 BatchTopUpAmount:=BatchTopUpAmount+LoanApps."Top Up Amount";
                                 BatchTopUpComm:=BatchTopUpComm+TotalTopupComm;
                                 UNTIL LoanApps.NEXT = 0;
                                 END;

                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=LoanApps."Account No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Document No.":="Loan  No.";
                                 GenJournalLine."External Document No.":="ID NO";
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine.Description:='Principal Amount';
                                 GenJournalLine.Amount:=(LoanApps."Approved Amount")*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;



                                 IF "Mode of Disbursement"="Mode of Disbursement"::Cheque THEN BEGIN

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 GenJournalLine.DELETEALL;


                                 GenSetUp.GET();

                                 DActivity:='BOSA';
                                 DBranch:='';//PKKS'NAIROBI';
                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Loan  No.","Loan  No.");
                                 LoanApps.SETRANGE(LoanApps."System Created",FALSE);
                                 LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                 IF LoanApps.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoanApps.CALCFIELDS(LoanApps."Special Loan Amount");



                                 DActivity:='';
                                 DBranch:='';
                                 IF Vend.GET(LoanApps."Client Code") THEN BEGIN
                                 DActivity:=Vend."Global Dimension 1 Code";
                                 DBranch:=Vend."Global Dimension 2 Code";
                                 END;



                                 LoanDisbAmount:=LoanApps."Approved Amount";

                                 IF (LoanApps."Special Loan Amount" > 0) AND (LoanApps."Bridging Loan Posted" = FALSE) THEN
                                 ERROR('Bridging Loans must be posted before the loans are disbursed. ' + LoanApps."Loan  No.");

                                 TCharges:=0;
                                 TopUpComm:=0;
                                 TotalTopupComm:=0;


                                 IF LoanApps."Loan Status"<>LoanApps."Loan Status"::Approved THEN
                                 ERROR('Loan status must be Approved for you to post Loan. - ' + LoanApps."Loan  No.");

                                 IF LoanApps.Posted = TRUE THEN
                                 ERROR('Loan has already been posted. - ' + LoanApps."Loan  No.");


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

                                 PCharges.RESET;
                                 PCharges.SETRANGE(PCharges."Product Code",LoanApps."Loan Product Type");
                                 IF PCharges.FIND('-') THEN BEGIN
                                 REPEAT
                                     PCharges.TESTFIELD(PCharges."G/L Account");

                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=PCharges."G/L Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:=PCharges.Description;
                                     IF PCharges."Use Perc" = TRUE THEN BEGIN
                                     GenJournalLine.Amount:=(LoanDisbAmount * PCharges.Percentage/100) * -1;
                                     END  ELSE BEGIN
                                     GenJournalLine.Amount:=PCharges.Amount * -1;

                                    END;


                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //Don't top up charges on principle
                                     //Don't top up charges on principle
                                     GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     TCharges:=TCharges+(GenJournalLine.Amount*-1);


                                 UNTIL PCharges.NEXT = 0;
                                 END;




                                 //Don't top up charges on principle
                                 TCharges:=0;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":="Client Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Document No.":="Loan  No.";
                                 GenJournalLine."External Document No.":="ID NO";
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine.Description:='Principal Amount';
                                 GenJournalLine.Amount:=LoanDisbAmount+ TCharges;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                 GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;




                                 IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                 IF LoanApps."Top Up Amount" > 0 THEN BEGIN
                                 LoanTopUp.RESET;
                                 LoanTopUp.SETRANGE(LoanTopUp."Loan No.",LoanApps."Loan  No.");
                                 IF LoanTopUp.FIND('-') THEN BEGIN
                                 REPEAT
                                     //Principle
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:='Off Set By - ' +LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=LoanTopUp."Principle Top Up" * -1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                    // GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     //GenJournalLine."Bal. Account No.":=LoanApps."Account No";
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     //Interest (Reversed if top up)
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                     GenJournalLine."Account No.":=LoanApps."Client Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Interestpaid ' + LoanApps."Loan  No.";
                                     GenJournalLine.Amount:=-LoanTopUp."Interest Top Up";
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                     //GenJournalLine."Bal. Account No.":=LoanType."Receivable Interest Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                     GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                     GenJournalLine."Loan No":=LoanTopUp."Loan Top Up";
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;


                                     END;

                                     //Commision
                                     IF LoanType.GET(LoanApps."Loan Product Type") THEN BEGIN
                                     IF LoanType."Top Up Commision" > 0 THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='PAYMENTS';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=LoanType."Top Up Commision Account";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":="Loan  No.";
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine.Description:='Commision on Loan Top Up';
                                     TopUpComm:=(LoanTopUp."Principle Top Up") * (LoanType."Top Up Commision"/100);
                                     TotalTopupComm:=TotalTopupComm+TopUpComm;
                                     GenJournalLine.Amount:=TopUpComm*-1;
                                     GenJournalLine."External Document No.":=LoanApps."Loan  No.";
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                     GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                     //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                     //GenJournalLine."Bal. Account No.":=LoanApps."Account No";

                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                     END;
                                     END;
                                 UNTIL LoanTopUp.NEXT = 0;
                                 END;
                                 END;
                                 END;

                                 BatchTopUpAmount:=BatchTopUpAmount+LoanApps."Top Up Amount";
                                 BatchTopUpComm:=BatchTopUpComm+TotalTopupComm;
                                 UNTIL LoanApps.NEXT = 0;
                                 END;

                                 LineNo:=LineNo+10000;
                                 {Disbursement.RESET;
                                 Disbursement.SETRANGE(Disbursement."Loan Number","Loan  No.");
                                 Disbursement.SETRANGE(Disbursement."Disbursement Date","Loan Disbursement Date");
                                 IF Disbursement.FIND('-') THEN BEGIN
                                 REPEAT
                                 Disbursement.Posted:=TRUE;
                                 Disbursement.MODIFY;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PAYMENTS';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=Disbursement."Disbursement Account Type";
                                 GenJournalLine."Account No.":=Disbursement."Disbursement Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Document No.":="Loan  No.";
                                 GenJournalLine."External Document No.":="ID NO";
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine.Description:='Principal Amount';
                                 GenJournalLine.Amount:=((LoanApps."Approved Amount")-(BatchTopUpAmount+BatchTopUpComm+TCharges))*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 UNTIL Disbursement.NEXT=0;
                                 END;}
                                 END;



                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::Codeunit50013,GenJournalLine);
                                 END;

                                 //Post New

                                 Posted:=TRUE;
                                 MODIFY;



                                 MESSAGE('Loan posted successfully.');

                                 //Post

                                 LoanAppPermisions()
                                 //CurrForm.EDITABLE:=TRUE;
                                 //end;
                               END;
                                }
      { 1102755004;1 ;ActionGroup;
                      CaptionML=ENU=Approvals;
                      ActionContainerType=NewDocumentItems }
      { 1102755007;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 {
                                 LBatches.RESET;
                                 LBatches.SETRANGE(LBatches."Loan  No.","Loan  No.");
                                 IF LBatches.FIND('-') THEN BEGIN
                                     ApprovalEntries.Setfilters(DATABASE::Loans,17,LBatches."Loan  No.");
                                       ApprovalEntries.RUN;
                                 END;
                                 }

                                 DocumentType:=DocumentType::Loan;
                                 ApprovalEntries.Setfilters(DATABASE::"Absence Preferences",DocumentType,"Loan  No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755005;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This transaction is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                  {
                                 SalDetails.RESET;
                                 SalDetails.SETRANGE(SalDetails."Loan No","Loan  No.");
                                 IF SalDetails.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Salary Information');
                                 END;
                                    }
                                 IF "Loan Product Type" <> 'SDV' THEN BEGIN
                                 LGuarantors.RESET;
                                 LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                 IF LGuarantors.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Guarantor Information');
                                 END;
                                 END;
                                 //TESTFIELD("Approved Amount");
                                 TESTFIELD("Loan Product Type");
                                 TESTFIELD("Mode of Disbursement");

                                       {
                                 IF "Mode of Disbursement"="Mode of Disbursement"::Cheque THEN
                                 ERROR('Mode of disbursment cannot be cheque, all loans are disbursed through FOSA')

                                 ELSE IF  ("Mode of Disbursement"="Mode of Disbursement"::"Bank Transfer") AND
                                  ("Account No"='') THEN
                                  ERROR('Member has no FOSA Savings Account linked to loan thus no means of disbursing the loan,')

                                 ELSE IF  (Source=Source::BOSA) AND ("Mode of Disbursement"="Mode of Disbursement"::"FOSA Loans")  THEN
                                  ERROR('This is not a FOSA loan thus select correct mode of disbursement')

                                 ELSE IF ("Mode of Disbursement"="Mode of Disbursement"::" ")THEN
                                 ERROR('Kindly specify mode of disbursement');
                                           }


                                 {
                                 RSchedule.RESET;
                                 RSchedule.SETRANGE(RSchedule."Loan No.","Loan  No.");
                                 IF NOT RSchedule.FIND('-') THEN
                                 ERROR('Loan Schedule must be generated and confirmed before loan is attached to batch');
                                   }

                                 {
                                 LBatches.RESET;
                                 LBatches.SETRANGE(LBatches."Loan  No.","Loan  No.");
                                 IF LBatches.FIND('-') THEN BEGIN
                                    IF LBatches."Approval Status"<>LBatches."Approval Status"::Open THEN
                                       ERROR(Text001);
                                 END;
                                 }
                                 //End allocate batch number
                                 //ApprovalMgt.SendLoanApprRequest(LBatches);
                                 //ApprovalMgt.SendLoanApprRequest(Rec);
                                   { LGuarantors.RESET;
                                    LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                    IF LGuarantors.FINDFIRST THEN BEGIN
                                    REPEAT
                                    IF Cust.GET(LGuarantors."Member No") THEN
                                    IF  Cust."Mobile Phone No"<>'' THEN
                                    Sms.SendSms('Guarantors' ,Cust."Mobile Phone No",'You have guaranteed '+ "Client Name" + ' ' + "Loan Product Type" +' of KES. '+FORMAT("Approved Amount")+
                                    '. Call 0720000000 if in dispute. Ekeza Sacco.',Cust."No.");
                                    UNTIL LGuarantors.NEXT =0;
                                    END
                                     }
                               END;
                                }
      { 1102755003;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN
                                  //ApprovalMgt.SendLoanApprRequest(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=General }

    { 1000000019;2;Field  ;
                SourceExpr="Loan  No.";
                Editable=FALSE }

    { 1102760024;2;Field  ;
                CaptionML=ENU=Staff No;
                SourceExpr="Staff No";
                Editable=FALSE }

    { 1102760000;2;Field  ;
                CaptionML=ENU=Member;
                SourceExpr="Client Code";
                Editable=MNoEditable }

    { 1102755030;2;Field  ;
                SourceExpr="Account No";
                Editable=AccountNoEditable }

    { 1000000043;2;Field  ;
                SourceExpr="Client Name";
                Editable=FALSE }

    { 1102755019;2;Field  ;
                SourceExpr="ID NO";
                Editable=FALSE }

    { 1102755020;2;Field  ;
                SourceExpr="Member Deposits" }

    { 1000000003;2;Field  ;
                SourceExpr="Application Date";
                Editable=ApplcDateEditable;
                OnValidate=BEGIN
                              TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 1102755006;2;Field  ;
                SourceExpr="Loan Product Type";
                Editable=LProdTypeEditable }

    { 1102760011;2;Field  ;
                SourceExpr=Installments;
                Editable=false;
                OnValidate=BEGIN
                             TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 1102755002;2;Field  ;
                SourceExpr=Interest;
                Editable=FALSE }

    { 1000000011;2;Field  ;
                SourceExpr="Recovery Mode" }

    { 1102755000;2;Field  ;
                SourceExpr="Product Currency Code";
                Enabled=TRUE;
                Editable=TRUE }

    { 1120054013;2;Field  ;
                SourceExpr=Source }

    { 1000000015;2;Field  ;
                CaptionML=ENU=Amount Applied;
                SourceExpr="Requested Amount";
                Editable=AppliedAmountEditable;
                OnValidate=BEGIN
                              TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 1102755033;2;Field  ;
                SourceExpr="Recommended Amount";
                Editable=false }

    { 1000000009;2;Field  ;
                CaptionML=ENU=Approved Amount;
                SourceExpr="Approved Amount";
                Editable=ApprovedAmountEditable;
                OnValidate=BEGIN
                             TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 1000000008;2;Field  ;
                SourceExpr="Appeal Amount" }

    { 1000000007;2;Field  ;
                SourceExpr="Appeal Date" }

    { 1102760007;2;Field  ;
                SourceExpr="Loan Purpose";
                Visible=FALSE;
                Editable=TRUE }

    { 1000000001;2;Field  ;
                SourceExpr=Remarks;
                Visible=TRUE;
                Editable=TRUE }

    { 1102760014;2;Field  ;
                SourceExpr="Repayment Method";
                Editable=False }

    { 1102760013;2;Field  ;
                SourceExpr=Repayment;
                Editable=RepaymentEditable }

    { 1102755037;2;Field  ;
                SourceExpr="Approved Repayment";
                Visible=FALSE }

    { 1000000039;2;Field  ;
                SourceExpr="Loan Status";
                Editable=LoanStatusEditable;
                OnValidate=BEGIN
                             UpdateControl();

                             {IF LoanType.GET('DISCOUNT') THEN BEGIN
                             IF (("Approved Amount")-("Special Loan Amount"+"Other Commitments Clearance"+SpecialComm))
                                  < 0 THEN
                             ERROR('Bridging amount more than the loans applied/approved.');

                             END;


                             IF "Loan Status" = "Loan Status"::Appraisal THEN BEGIN
                             StatusPermissions.RESET;
                             StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
                             StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Bosa Loan Appraisal");
                             IF StatusPermissions.FIND('-') = FALSE THEN
                             ERROR('You do not have permissions to Appraise this Loan.');

                             END ELSE BEGIN

                             IF "Loan Status" = "Loan Status"::Approved THEN BEGIN
                             StatusPermissions.RESET;
                             StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
                             StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Bosa Loan Approval");
                             IF StatusPermissions.FIND('-') = FALSE THEN
                             ERROR('You do not have permissions to Approve this Loan.');

                             "Date Approved":=TODAY;
                             END;
                             END;
                             //END;


                             {
                             ccEmail:='';

                             LoanG.RESET;
                             LoanG.SETRANGE(LoanG."Loan No","Loan  No.");
                             IF LoanG.FIND('-') THEN BEGIN
                             REPEAT
                             IF CustE.GET(LoanG."Member No") THEN BEGIN
                             IF CustE."E-Mail" <> '' THEN BEGIN
                             IF ccEmail = '' THEN
                             ccEmail:=CustE."E-Mail"
                             ELSE
                             ccEmail:=ccEmail + ';' + CustE."E-Mail";
                             END;
                             END;
                             UNTIL LoanG.NEXT = 0;
                             END;



                             IF "Loan Status"="Loan Status"::Approved THEN BEGIN
                             CLEAR(Notification);
                             IF CustE.GET("Client Code") THEN BEGIN
                             Notification.NewMessage(CustE."E-Mail",ccEmail,'Loan Status',
                             'We are happy to inform you that your ' + "Loan Product Type" + ' loan application of ' + FORMAT("Requested Amount")
                              + ' has been approved.' + ' (Dynamics NAV ERP)','',FALSE);
                             END;


                             END ELSE IF "Loan Status"="Loan Status"::Appraisal THEN BEGIN
                             DocN:='';
                             DocM:='';
                             DocF:='';
                             DNar:='';

                             IF "Copy of ID"= FALSE THEN BEGIN
                             DocN:='Please avail your ';
                             DocM:='Copy of ID.';
                             DocF:=' to facilitate further processing.'
                             END;

                             IF Contract= FALSE THEN BEGIN
                             DocN:='Please avail your ';
                             DocM:=DocM + ' Contract.';
                             DocF:=' to facilitate further processing.'
                             END;

                             IF Payslip= FALSE THEN BEGIN
                             DocN:='Please avail your ';
                             DocM:=DocM + ' Payslip.';
                             DocF:=' to facilitate further processing.'
                             END;

                             DNar:=DocN + DocM + DocF;


                             CLEAR(Notification);
                             IF CustE.GET("Client Code") THEN BEGIN
                             Notification.NewMessage(CustE."E-Mail",ccEmail,'Loan Status',
                             'Your ' + "Loan Product Type" + ' loan application of Ksh.' + FORMAT("Requested Amount")
                             + ' has been received and it is now at the appraisal stage. ' +
                              DNar + ' (Dynamics NAV ERP)'
                             ,'',FALSE);
                             END;


                             END ELSE BEGIN
                             CLEAR(Notification);

                             IF CustE.GET("Client Code") THEN BEGIN
                             Notification.NewMessage(CustE."E-Mail",ccEmail,'Loan Status',
                             'We are sorry to inform you that your ' + "Loan Product Type" + ' loan application of ' + FORMAT("Requested Amount")
                             + ' has been rejected.' + ' (Dynamics NAV ERP)'
                             ,'',FALSE);
                             END;

                             END;

                             }
                               {
                             //SMS Notification
                             Cust.RESET;
                             Cust.SETRANGE(Cust."No.","Client Code");
                             IF Cust.FIND('-') THEN BEGIN
                             Cust.TESTFIELD(Cust."Phone No.");
                             END;


                             Cust.RESET;
                             Cust.SETRANGE(Cust."No.","Client Code");
                             IF Cust.FIND('-') THEN BEGIN
                             SMSMessage.INIT;
                             SMSMessage."SMS Message":=Cust."Phone No."+'*'+' Your loan app. of date ' + FORMAT("Application Date")
                             + ' of type ' + "Loan Product Type" +' of amount ' +FORMAT("Approved Amount")+' has been issued. Thank you.';
                             SMSMessage."Date Entered":=TODAY;
                             SMSMessage."Time Entered":=TIME;
                             SMSMessage."SMS Sent":=SMSMessage."SMS Sent"::No;
                             SMSMessage.INSERT;
                             END;
                             //SMS Notification
                             }   }
                           END;
                            }

    { 1120054002;2;Field  ;
                SourceExpr="Issued Date";
                Editable=false }

    { 1102760004;2;Field  ;
                SourceExpr="Batch No.";
                Editable=BatchNoEditable }

    { 1102755008;2;Field  ;
                SourceExpr="Captured By";
                Editable=FALSE }

    { 1120054011;2;Field  ;
                SourceExpr="Appraised By";
                Editable=false }

    { 1120054012;2;Field  ;
                SourceExpr="Disbursed By";
                Editable=false }

    { 1102755010;2;Field  ;
                CaptionML=ENU=Bridged Amount;
                SourceExpr="Top Up Amount" }

    { 1102755009;2;Field  ;
                SourceExpr="Repayment Frequency";
                Editable=RepayFrequencyEditable }

    { 1120054007;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054008;2;Field  ;
                SourceExpr="Oustanding Interest" }

    { 1102760002;2;Field  ;
                SourceExpr="Mode of Disbursement";
                Editable=ModeofDisburesmentEdit }

    { 1000000036;2;Field  ;
                SourceExpr="Loan Disbursement Date";
                Editable=true }

    { 1102760019;2;Field  ;
                SourceExpr="Cheque No.";
                Visible=true;
                OnValidate=BEGIN
                             IF STRLEN("Cheque No.") > 6 THEN
                               ERROR('Document No. cannot contain More than 6 Characters.');
                           END;
                            }

    { 1102755014;2;Field  ;
                SourceExpr="Repayment Start Date";
                Editable=FALSE }

    { 1102755025;2;Field  ;
                SourceExpr="Expected Date of Completion";
                Editable=FALSE }

    { 1102755013;2;Field  ;
                SourceExpr="External EFT";
                Visible=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr="Approval Status";
                Editable=FALSE }

    { 1102755029;2;Field  ;
                SourceExpr="partially Bridged" }

    { 1000000033;2;Field  ;
                SourceExpr=Posted;
                Visible=FALSE;
                Editable=FALSE }

    { 1102755031;2;Field  ;
                SourceExpr="Total TopUp Commission" }

    { 1102755039;2;Field  ;
                SourceExpr="Rejection  Remark";
                Editable=RejectionRemarkEditable }

    { 1120054000;2;Field  ;
                SourceExpr="Loans Category-SASRA";
                Editable=false }

    { 1120054001;2;Field  ;
                SourceExpr="Loan Principle Repayment";
                Editable=false }

    { 1120054004;2;Field  ;
                SourceExpr="Do not Charge Interest" }

    { 1120054010;2;Field  ;
                SourceExpr="Days In Arrears" }

    { 1120054009;2;Field  ;
                SourceExpr="Debt Collectors Name" }

    { 1000000002;1;Part   ;
                CaptionML=ENU=Salary Details;
                SubPageLink=Loan No=FIELD(Loan  No.),
                            Client Code=FIELD(Client Code);
                PagePartID=Page51516246;
                PartType=Page }

    { 1000000004;1;Part   ;
                CaptionML=ENU=Guarantors  Detail;
                SubPageLink=Loan No=FIELD(Loan  No.);
                PagePartID=Page51516585;
                PartType=Page }

    { 1000000005;1;Part   ;
                CaptionML=ENU=Other Securities;
                SubPageLink=Loan No=FIELD(Loan  No.);
                PagePartID=Page51516248;
                PartType=Page }

    { 1120054005;1;Field  ;
                SourceExpr=1 }

  }
  CODE
  {
    VAR
      Text001@1102755015 : TextConst 'ENU=Status Must Be Open';
      i@1118 : Integer;
      LoanType@1117 : Record 51516240;
      PeriodDueDate@1116 : Date;
      ScheduleRep@1115 : Record 51516234;
      RunningDate@1114 : Date;
      G@1113 : Integer;
      IssuedDate@1112 : Date;
      GracePeiodEndDate@1111 : Date;
      InstalmentEnddate@1110 : Date;
      GracePerodDays@1109 : Integer;
      InstalmentDays@1108 : Integer;
      NoOfGracePeriod@1107 : Integer;
      NewSchedule@1106 : Record 51516234;
      RSchedule@1105 : Record 51516234;
      GP@1104 : Text[30];
      ScheduleCode@1103 : Code[20];
      PreviewShedule@1102 : Record 51516234;
      PeriodInterval@1101 : Code[10];
      CustomerRecord@1100 : Record 51516223;
      Gnljnline@1099 : Record 81;
      Jnlinepost@1098 : Codeunit 12;
      CumInterest@1097 : Decimal;
      NewPrincipal@1096 : Decimal;
      PeriodPrRepayment@1095 : Decimal;
      GenBatch@1094 : Record 232;
      LineNo@1093 : Integer;
      GnljnlineCopy@1092 : Record 81;
      NewLNApplicNo@1091 : Code[10];
      Cust@1090 : Record 51516223;
      LoanApp@1089 : Record 51516230;
      TestAmt@1088 : Decimal;
      CustRec@1087 : Record 51516223;
      CustPostingGroup@1086 : Record 92;
      GenSetUp@1085 : Record 311;
      PCharges@1084 : Record 51516242;
      TCharges@1083 : Decimal;
      LAppCharges@1082 : Record 51516244;
      LoansR@1081 : Record 51516230;
      LoanAmount@1080 : Decimal;
      InterestRate@1079 : Decimal;
      RepayPeriod@1078 : Integer;
      LBalance@1077 : Decimal;
      RunDate@1076 : Date;
      InstalNo@1075 : Decimal;
      RepayInterval@1074 : DateFormula;
      TotalMRepay@1073 : Decimal;
      LInterest@1072 : Decimal;
      LPrincipal@1071 : Decimal;
      RepayCode@1070 : Code[40];
      GrPrinciple@1069 : Integer;
      GrInterest@1068 : Integer;
      QPrinciple@1067 : Decimal;
      QCounter@1066 : Integer;
      InPeriod@1065 : DateFormula;
      InitialInstal@1064 : Integer;
      InitialGraceInt@1063 : Integer;
      GenJournalLine@1062 : Record 81;
      FOSAComm@1061 : Decimal;
      BOSAComm@1060 : Decimal;
      GLPosting@1059 : Codeunit 12;
      LoanTopUp@1058 : Record 51516235;
      Vend@1057 : Record 23;
      BOSAInt@1056 : Decimal;
      TopUpComm@1055 : Decimal;
      DActivity@1054 : Code[20];
      DBranch@1053 : Code[20];
      TotalTopupComm@1052 : Decimal;
      Notification@1051 : Codeunit 397;
      CustE@1050 : Record 51516223;
      DocN@1049 : Text[50];
      DocM@1048 : Text[100];
      DNar@1047 : Text[250];
      DocF@1046 : Text[50];
      MailBody@1045 : Text[250];
      ccEmail@1044 : Text[250];
      LoanG@1043 : Record 51516231;
      SpecialComm@1042 : Decimal;
      FOSAName@1041 : Text[150];
      IDNo@1040 : Code[50];
      MovementTracker@1039 : Record 51516253;
      DiscountingAmount@1038 : Decimal;
      StatusPermissions@1037 : Record 51516310;
      BridgedLoans@1036 : Record 51516238;
      SMSMessage@1035 : Record 51516223;
      InstallNo2@1034 : Integer;
      currency@1033 : Record 330;
      CURRENCYFACTOR@1032 : Decimal;
      LoanApps@1031 : Record 51516230;
      LoanDisbAmount@1030 : Decimal;
      BatchTopUpAmount@1029 : Decimal;
      BatchTopUpComm@1028 : Decimal;
      Disbursement@1027 : Record 51516236;
      SchDate@1026 : Date;
      DisbDate@1025 : Date;
      WhichDay@1024 : Integer;
      LBatches@1023 : Record 51516230;
      SalDetails@1022 : Record 51516232;
      LGuarantors@1021 : Record 51516231;
      DocumentType@1020 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      CurrpageEditable@1019 : Boolean;
      LoanStatusEditable@1018 : Boolean;
      MNoEditable@1017 : Boolean;
      ApplcDateEditable@1016 : Boolean;
      LProdTypeEditable@1015 : Boolean;
      InstallmentEditable@1014 : Boolean;
      AppliedAmountEditable@1013 : Boolean;
      ApprovedAmountEditable@1012 : Boolean;
      RepayMethodEditable@1011 : Boolean;
      RepaymentEditable@1010 : Boolean;
      BatchNoEditable@1009 : Boolean;
      RepayFrequencyEditable@1008 : Boolean;
      ModeofDisburesmentEdit@1007 : Boolean;
      DisbursementDateEditable@1006 : Boolean;
      AccountNoEditable@1005 : Boolean;
      LNBalance@1004 : Decimal;
      ApprovalEntries@1003 : Record 454;
      RejectionRemarkEditable@1002 : Boolean;
      ApprovalEntry@1001 : Record 454;
      Overdue@1000 : 'Yes, ';
      SFactory@1120054000 : Codeunit 51516022;

    PROCEDURE UpdateControl@1102755000();
    BEGIN

      IF "Loan Status"="Loan Status"::Application THEN BEGIN
      MNoEditable:=TRUE;
      ApplcDateEditable:=FALSE;
      LoanStatusEditable:=FALSE;
      LProdTypeEditable:=TRUE;
      InstallmentEditable:=TRUE;
      AppliedAmountEditable:=TRUE;
      ApprovedAmountEditable:=TRUE;
      RepayMethodEditable:=TRUE;
      RepaymentEditable:=TRUE;
      BatchNoEditable:=FALSE;
      RepayFrequencyEditable:=TRUE;
      ModeofDisburesmentEdit:=TRUE;
      DisbursementDateEditable:=FALSE;
      END;

      IF "Loan Status"="Loan Status"::Appraisal THEN BEGIN
      MNoEditable:=FALSE;
      ApplcDateEditable:=FALSE;
      LoanStatusEditable:=FALSE;
      LProdTypeEditable:=FALSE;
      InstallmentEditable:=FALSE;
      AppliedAmountEditable:=FALSE;
      ApprovedAmountEditable:=TRUE;
      RepayMethodEditable:=TRUE;
      RepaymentEditable:=TRUE;
      BatchNoEditable:=FALSE;
      RepayFrequencyEditable:=FALSE;
      ModeofDisburesmentEdit:=TRUE;
      DisbursementDateEditable:=FALSE;
      END;

      IF "Loan Status"="Loan Status"::Rejected THEN BEGIN
      MNoEditable:=FALSE;
      AccountNoEditable:=FALSE;
      ApplcDateEditable:=FALSE;
      LoanStatusEditable:=FALSE;
      LProdTypeEditable:=FALSE;
      InstallmentEditable:=FALSE;
      AppliedAmountEditable:=FALSE;
      ApprovedAmountEditable:=FALSE;
      RepayMethodEditable:=FALSE;
      RepaymentEditable:=FALSE;
      BatchNoEditable:=FALSE;
      RepayFrequencyEditable:=FALSE;
      ModeofDisburesmentEdit:=FALSE;
      DisbursementDateEditable:=FALSE;
      RejectionRemarkEditable:=FALSE
      END;

      IF "Approval Status"="Approval Status"::Approved THEN BEGIN
      MNoEditable:=FALSE;
      AccountNoEditable:=FALSE;
      LoanStatusEditable:=FALSE;
      ApplcDateEditable:=FALSE;
      LProdTypeEditable:=FALSE;
      InstallmentEditable:=FALSE;
      AppliedAmountEditable:=FALSE;
      ApprovedAmountEditable:=FALSE;
      RepayMethodEditable:=FALSE;
      RepaymentEditable:=FALSE;
      BatchNoEditable:=TRUE;
      RepayFrequencyEditable:=FALSE;
      ModeofDisburesmentEdit:=TRUE;
      DisbursementDateEditable:=TRUE;
      RejectionRemarkEditable:=FALSE;
      END;
    END;

    PROCEDURE LoanAppPermisions@1102760000();
    BEGIN
    END;

    PROCEDURE Autogenerateschedule@1120054001(VAR LOANNO@1120054000 : Code[100]);
    BEGIN
      Rec.SETRANGE("Loan  No.",LOANNO);
      IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
      EVALUATE(InPeriod,'1D')
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
      EVALUATE(InPeriod,'1W')
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
      EVALUATE(InPeriod,'1M')
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
      EVALUATE(InPeriod,'1Q');


      QCounter:=0;
      QCounter:=3;
      //EVALUATE(InPeriod,'1D');
      GrPrinciple:="Grace Period - Principle (M)";
      GrInterest:="Grace Period - Interest (M)";
      InitialGraceInt:="Grace Period - Interest (M)";

      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Loan  No.","Loan  No.");
      IF LoansR.FIND('-') THEN BEGIN

      TESTFIELD("Loan Disbursement Date");
      TESTFIELD("Repayment Start Date");

      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.","Loan  No.");
      RSchedule.DELETEALL;

      LoanAmount:=LoansR."Approved Amount";
      InterestRate:=LoansR.Interest;
      RepayPeriod:=LoansR.Installments;
      InitialInstal:=LoansR.Installments+"Grace Period - Principle (M)";
      LBalance:=LoansR."Approved Amount";
      RunDate:="Repayment Start Date";//"Loan Disbursement Date";
      //RunDate:=CALCDATE('-1W',RunDate);
      InstalNo:=0;
      //EVALUATE(RepayInterval,'1W');
      //EVALUATE(RepayInterval,InPeriod);

      //Repayment Frequency
      IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('-1D',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('-1W',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('-1M',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('-1Q',RunDate);
      //Repayment Frequency


      REPEAT
      InstalNo:=InstalNo+1;
      //RunDate:=CALCDATE("Instalment Period",RunDate);
      //RunDate:=CALCDATE('1W',RunDate);


      //Repayment Frequency
      IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('1D',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('1W',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('1M',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('1Q',RunDate);
      //Repayment Frequency

      //kma
      IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
      TESTFIELD(Interest);
      TESTFIELD(Installments);
      TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.05,'>');
      LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
      LPrincipal:=TotalMRepay-LInterest;
      END;

      IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
      TESTFIELD(Interest);
      TESTFIELD(Installments);
      LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
      LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
      //Grace Period Interest
      LInterest:=ROUND((LInterest*InitialInstal)/(InitialInstal-InitialGraceInt),0.05,'>');
      END;

      IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
      TESTFIELD(Interest);
      TESTFIELD(Installments);
      LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
      LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
      END;

      IF "Repayment Method"="Repayment Method"::Constants THEN BEGIN
      TESTFIELD(Repayment);
      IF LBalance < Repayment THEN
      LPrincipal:=LBalance
      ELSE
      LPrincipal:=Repayment;
      LInterest:=Interest;
      END;
      //kma



      //Grace Period
      IF GrPrinciple > 0 THEN BEGIN
      LPrincipal:=0
      END ELSE BEGIN
      //IF "Instalment Period" <> InPeriod THEN
      LBalance:=LBalance-LPrincipal;

      END;

      IF GrInterest > 0 THEN
      LInterest:=0;

      GrPrinciple:=GrPrinciple-1;
      GrInterest:=GrInterest-1;
      //Grace Period
       {
      //Q Principle
      IF "Instalment Period" = InPeriod THEN BEGIN
      //ADDED
      IF GrPrinciple <> 0 THEN
      GrPrinciple:=GrPrinciple-1;
      IF QCounter = 1 THEN BEGIN
      QCounter:=3;
      LPrincipal:=QPrinciple+LPrincipal;
      IF LPrincipal > LBalance THEN
      LPrincipal:=LBalance;
      LBalance:=LBalance-LPrincipal;
      QPrinciple:=0;
      END ELSE BEGIN
      QCounter:=QCounter - 1;
      QPrinciple:=QPrinciple+LPrincipal;
      //IF QPrinciple > LBalance THEN
      //QPrinciple:=LBalance;
      LPrincipal:=0;
      END

      END;
      //Q Principle
       }

      EVALUATE(RepayCode,FORMAT(InstalNo));
       {
      WhichDay:=DATE2DWY(RunDate,1);
      IF WhichDay=6 THEN
       RunDate:=RunDate+2
      ELSE IF WhichDay=7 THEN
       RunDate:=RunDate+1;
           }
      //MESSAGE('which day is %1',WhichDay);



      RSchedule.INIT;
      RSchedule."Repayment Code":=RepayCode;
      RSchedule."Loan No.":="Loan  No.";
      RSchedule."Loan Amount":=LoanAmount;
      RSchedule."Loan Balance":=LBalance;//..
      RSchedule."Instalment No":=InstalNo;
      RSchedule."Repayment Date":=RunDate;
      RSchedule."Member No.":="Client Code";
      RSchedule."Loan Category":="Loan Product Type";
      RSchedule."Monthly Repayment":=LInterest + LPrincipal;
      RSchedule."Monthly Interest":=LInterest;
      RSchedule."Principal Repayment":=LPrincipal;
      RSchedule.INSERT;
      //WhichDay:=(DATE2DMY,RSchedule."Repayment Date",1);
       WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
      //MESSAGE('which day is %1',WhichDay);
      //BEEP(2,10000);
      UNTIL LBalance < 1

      END;

      {//Create Audit Entry
      AuditTrail.FnGetLastEntry();
      AuditTrail.FnGetComputerName();
      AuditTrail.FnInsertAuditRecords(0,USERID,'Loan Schedule Viewed.',"Requested Amount",
      'CREDIT',TODAY,TIME,"Loan  No.","Loan  No.","Client Code",'');
      COMMIT;
      //End Create Audit Entry}
      COMMIT;
    END;

    BEGIN
    {

      //IF Posted=TRUE THEN
      //ERROR('Loan has been posted, Can only preview schedule');
      {
      IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
      EVALUATE(InPeriod,'1D')
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
      EVALUATE(InPeriod,'1W')
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
      EVALUATE(InPeriod,'1M')
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
      EVALUATE(InPeriod,'1Q');


      QCounter:=0;
      QCounter:=3;
      //EVALUATE(InPeriod,'1D');
      GrPrinciple:="Grace Period - Principle (M)";
      GrInterest:="Grace Period - Interest (M)";
      InitialGraceInt:="Grace Period - Interest (M)";

      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Loan  No.","Loan  No.");
      IF LoansR.FIND('-') THEN BEGIN

      TESTFIELD("Loan Disbursement Date");
      TESTFIELD("Repayment Start Date");

      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.","Loan  No.");
      RSchedule.DELETEALL;

      LoanAmount:=LoansR."Approved Amount";
      InterestRate:=LoansR.Interest;
      RepayPeriod:=LoansR.Installments;
      InitialInstal:=LoansR.Installments+"Grace Period - Principle (M)";
      LBalance:=LoansR."Approved Amount";
      RunDate:="Repayment Start Date";//"Loan Disbursement Date";

      InstalNo:=0;

      //Repayment Frequency
      IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('-1D',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('-1W',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('-1M',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('-1Q',RunDate);
      //Repayment Frequency


      REPEAT
      InstalNo:=InstalNo+1;


      //Repayment Frequency
      IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('1D',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('1W',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('1M',RunDate)
      ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('1Q',RunDate);
      //Repayment Frequency


      IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
      TESTFIELD(Interest);
      TESTFIELD(Installments);
      TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount));
      LInterest:=ROUND(LBalance / 100 / 12 * InterestRate);
      LPrincipal:=TotalMRepay-LInterest;
      END;

      IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
      TESTFIELD(Interest);
      TESTFIELD(Installments);
      LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
      LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
      //Grace Period Interest
      LInterest:=ROUND((LInterest*InitialInstal)/(InitialInstal-InitialGraceInt),0.05,'>');
      END;

      IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
      TESTFIELD(Interest);
      TESTFIELD(Installments);
      LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
      LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
      END;

      IF "Repayment Method"="Repayment Method"::Constants THEN BEGIN
      TESTFIELD(Repayment);
      IF LBalance < Repayment THEN
      LPrincipal:=LBalance
      ELSE
      LPrincipal:=Repayment;
      LInterest:=Interest;
      END;
      //kma

      //Grace Period
      IF GrPrinciple > 0 THEN BEGIN
      LPrincipal:=0
      END ELSE BEGIN
      //IF "Instalment Period" <> InPeriod THEN
      LBalance:=LBalance-LPrincipal;

      END;

      IF GrInterest > 0 THEN
      LInterest:=0;

      GrPrinciple:=GrPrinciple-1;
      GrInterest:=GrInterest-1;
      //Grace Period
      EVALUATE(RepayCode,FORMAT(InstalNo));



      RSchedule.INIT;
      RSchedule."Repayment Code":=RepayCode;
      RSchedule."Loan No.":="Loan  No.";
      RSchedule."Loan Amount":=LoanAmount;
      RSchedule."Instalment No":=InstalNo;
      RSchedule."Repayment Date":=RunDate;
      RSchedule."Member No.":="Client Code";
      RSchedule."Loan Category":="Loan Product Type";
      RSchedule."Monthly Repayment":=LInterest + LPrincipal;
      RSchedule."Monthly Interest":=LInterest;
      RSchedule."Principal Repayment":=LPrincipal;
      RSchedule.INSERT;
      //WhichDay:=(DATE2DMY,RSchedule."Repayment Date",1);
       WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
      //MESSAGE('which day is %1',WhichDay);
      //BEEP(2,10000);
      UNTIL LBalance < 1

      END;

      COMMIT;
      }
    }
    END.
  }
}

