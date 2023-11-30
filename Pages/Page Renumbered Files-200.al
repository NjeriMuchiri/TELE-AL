OBJECT page 17391 Loans Posted List
{
  OBJECT-PROPERTIES
  {
    Date=08/22/23;
    Time=[ 5:39:25 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516230;
    SourceTableView=WHERE(Source=FILTER(BOSA|FOSA),
                          Posted=CONST(Yes),
                          Totals Outstanding=FILTER(>0));
    PageType=List;
    CardPageID=Loans Posted Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnAfterGetRecord=BEGIN
                       Overdue := Overdue::" ";
                       IF FormatField(Rec) THEN
                         Overdue := Overdue::Yes;
                       StatusColor:='';
                       IF "Loans Category"="Loans Category"::Perfoming THEN BEGIN
                       StatusColor:='Favorable';
                       END ELSE IF "Loans Category"="Loans Category"::Watch THEN BEGIN
                       StatusColor:='Ambiguous';
                       END ELSE IF "Loans Category"="Loans Category"::Watch THEN BEGIN
                       StatusColor:='Attention';
                       END ELSE BEGIN
                       StatusColor:='Unfavorable';
                       END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Outstanding Balance","Oustanding Interest");
                           //IF "Outstanding Balance"=0 OR "Oustanding Interest"=0 THEN
                           //Rec.SETFILTER();
                         END;

    ActionList=ACTIONS
    {
      { 14      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 13      ;1   ;ActionGroup;
                      CaptionML=ENU=Loan;
                      Image=AnalysisView }
      { 12      ;2   ;Action    ;
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
                                 REPORT.RUN(50039,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=Member Statement;
                      Promoted=Yes;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","Client Code");
                                 REPORT.RUN(50031,TRUE,FALSE,Cust);
                               END;
                                }
      { 10      ;2   ;Separator  }
      { 9       ;2   ;Action    ;
                      Name=View Schedule;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=View Schedule;
                      Promoted=Yes;
                      Visible=false;
                      Image=ViewDetails;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 GenerateSchedule@1120054000 : Codeunit 51516161;
                               BEGIN
                                 //IF Posted=TRUE THEN
                                 //ERROR('Loan has been posted, Can only preview schedule');
                                 RSchedule.RESET;
                                 RSchedule.SETRANGE(RSchedule."Loan No.","Loan  No.");
                                 IF NOT RSchedule.FINDFIRST THEN
                                   GenerateSchedule.Autogenerateschedule("Loan  No.");
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
                                 LNBalance:=LoansR."Outstanding Balance";
                                 RunDate:="Repayment Start Date";

                                 InstalNo:=0;
                                 EVALUATE(RepayInterval,'1W');

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


                                 //*************Repayment Frequency***********************//
                                 IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
                                 RunDate:=CALCDATE('1D',RunDate)
                                 ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
                                 RunDate:=CALCDATE('1W',RunDate)
                                 ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
                                 RunDate:=CALCDATE('1M',RunDate)
                                 ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
                                 RunDate:=CALCDATE('1Q',RunDate);






                                 //*******************If Amortised****************************//
                                 IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                 TESTFIELD(Installments);
                                 TESTFIELD(Interest);
                                 TESTFIELD(Installments);
                                 //TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,1,'>');
                                 TotalMRepay:=(InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount;
                                 LInterest:=ROUND(LBalance / 100 / 12 * InterestRate);

                                 LPrincipal:=TotalMRepay-LInterest;
                                 END;



                                 IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
                                 TESTFIELD(Installments);
                                 LPrincipal:=ROUND(LoanAmount/RepayPeriod,1,'>');
                                 IF ("Loan Product Type" = 'INST') OR ("Loan Product Type" = 'MAZAO') THEN BEGIN
                                 LInterest:=0;
                                 END ELSE BEGIN
                                 LInterest:=ROUND((InterestRate/100)*LoanAmount,1,'>');
                                 END;

                                 Repayment:=LPrincipal+LInterest;
                                 "Loan Principle Repayment":=LPrincipal;
                                 "Loan Interest Repayment":=LInterest;
                                 END;


                                 IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
                                 TESTFIELD(Interest);
                                 TESTFIELD(Installments);
                                 LPrincipal:=ROUND(LoanAmount/RepayPeriod,1,'>');
                                 LInterest:=ROUND((InterestRate/12/100)*LBalance,1,'>');
                                 END;

                                 IF "Repayment Method"="Repayment Method"::Constants THEN BEGIN
                                 TESTFIELD(Repayment);
                                 IF LBalance < Repayment THEN
                                 LPrincipal:=LBalance
                                 ELSE
                                 LPrincipal:=Repayment;
                                 LInterest:=Interest;
                                 END;


                                 //Grace Period
                                 IF GrPrinciple > 0 THEN BEGIN
                                 LPrincipal:=0
                                 END ELSE BEGIN
                                 IF "Instalment Period" <> InPeriod THEN
                                 LBalance:=LBalance-LPrincipal;

                                 END;

                                 IF GrInterest > 0 THEN
                                 LInterest:=0;

                                 GrPrinciple:=GrPrinciple-1;
                                 GrInterest:=GrInterest-1;

                                 //Grace Period
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
                                 WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);


                                 UNTIL LBalance < 1

                                 END;

                                 COMMIT;
                                 }
                                 {
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN
                                 IF LoanApp."Loan Product Type" <> 'INST' THEN BEGIN
                                 REPORT.RUN(50040,TRUE,FALSE,LoanApp);
                                 END ELSE BEGIN
                                 REPORT.RUN(,TRUE,FALSE,LoanApp);

                                 END;
                                 }
                               END;
                                }
      { 1120054009;2 ;Action    ;
                      Name=Update Classification;
                      ShortCutKey=Ctrl+F7;
                      RunObject=Codeunit 51516159;
                      Promoted=Yes;
                      Image=Category;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 GenerateSchedule@1120054000 : Codeunit 51516161;
                               BEGIN
                               END;
                                }
      { 1120054015;2 ;Action    ;
                      Name=Update Individual Classification;
                      ShortCutKey=Ctrl+F7;
                      Promoted=Yes;
                      Image=Category;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 GenerateSchedule@1120054000 : Codeunit 51516161;
                               BEGIN
                                 LoanAge.FnClassifyLoansIndividual("Loan  No.");
                               END;
                                }
      { 8       ;2   ;Separator  }
      { 7       ;2   ;Action    ;
                      CaptionML=ENU=Loans to Offset;
                      RunObject=page 17387;
                      RunPageLink=Loan No.=FIELD(Loan  No.),
                                  Client Code=FIELD(Client Code);
                      Promoted=Yes;
                      Visible=false;
                      Image=AddAction;
                      PromotedCategory=Process }
      { 6       ;2   ;Separator  }
      { 5       ;2   ;Action    ;
                      Name=Post Loan;
                      CaptionML=ENU=Post Loan;
                      Promoted=Yes;
                      Visible=false;
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
                                 END; }
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

                                 //LoanAppPermisions()
                                 //CurrForm.EDITABLE:=TRUE;
                                 //end;
                               END;
                                }
      { 4       ;1   ;ActionGroup;
                      CaptionML=ENU=Approvals;
                      ActionContainerType=NewDocumentItems }
      { 3       ;2   ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=false;
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
                                 ApprovalEntries.Setfilters(DATABASE::"Salary Step/Notch Transactions",DocumentType,"Loan  No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 2       ;2   ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Visible=false;
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
                                     // Commet during testing Enock-To uncomment
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
                                        //End of Comment

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
                                    {LGuarantors.RESET;
                                    LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                    IF LGuarantors.FINDFIRST THEN BEGIN
                                    REPEAT
                                    IF Cust.GET(LGuarantors."Member No") THEN
                                    IF  Cust."Mobile Phone No"<>'' THEN
                                    Sms.SendSms('Guarantors' ,Cust."Mobile Phone No",'You have guaranteed '+ "Client Name" + ' ' + "Loan Product Type" +' of KES. '+FORMAT("Approved Amount")+
                                    '. Call 0734666226 if in dispute. Waumini Sacco.',Cust."No.");
                                    UNTIL LGuarantors.NEXT =0;
                                    END}
                               END;
                                }
      { 1       ;2   ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Visible=false;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN
                                  //ApprovalMgt.SendLoanApprRequest(Rec);
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Next SMS Date;
                      OnAction=BEGIN

                                 "Issued Date" := CALCDATE('-1M-7D',TODAY);
                                 MODIFY;


                                 SkyMbanking.LoanReminders("Loan  No.",FALSE);
                                 SkyMbanking.LoanPenalty("Loan  No.");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1102755004;2;Field  ;
                CaptionML=ENU=OverDue;
                ToolTipML=ENU=OverDue Entry;
                OptionCaptionML=ENU=Yes;
                SourceExpr=Overdue;
                Editable=False }

    { 1000000001;2;Field  ;
                SourceExpr="Loan  No.";
                Editable=FALSE;
                StyleExpr=StatusColor }

    { 1102756013;2;Field  ;
                SourceExpr="Old Account No.";
                Editable=FALSE }

    { 1120054014;2;Field  ;
                SourceExpr="No Of Defaulted Loans" }

    { 1120054005;2;Field  ;
                SourceExpr="Loans Category";
                StyleExpr=StatusColor }

    { 1120054007;2;Field  ;
                SourceExpr="Loans Category-SASRA";
                StyleExpr=StatusColor }

    { 1120054006;2;Field  ;
                SourceExpr="Current Interest Paid" }

    { 1000000025;2;Field  ;
                SourceExpr="Loan Product Type";
                Editable=FALSE }

    { 1120054012;2;Field  ;
                SourceExpr="FOSA Balance" }

    { 1120054008;2;Field  ;
                Name=Available Balance;
                SourceExpr=SFactory.FnGetAccountAvailableBalance("Account No");
                Editable=FALSE }

    { 1120054013;2;Field  ;
                SourceExpr="Debt Collectors Name" }

    { 1000000011;2;Field  ;
                SourceExpr="Advice Type" }

    { 15  ;2   ;Field     ;
                SourceExpr="Emp Loan Codes" }

    { 1102755006;2;Field  ;
                SourceExpr="Expected Date of Completion" }

    { 1000000006;2;Field  ;
                SourceExpr="Recovery Mode" }

    { 1102760020;2;Field  ;
                SourceExpr="Application Date";
                Editable=FALSE;
                StyleExpr=StatusColor }

    { 1120054002;2;Field  ;
                SourceExpr="Employer Code" }

    { 1000000007;2;Field  ;
                SourceExpr="Client Code";
                Editable=FALSE }

    { 1102755002;2;Field  ;
                SourceExpr="BOSA No" }

    { 1102756011;2;Field  ;
                SourceExpr="Issued Date";
                Editable=FALSE }

    { 1120054001;2;Field  ;
                SourceExpr="Repayment Start Date" }

    { 1000000033;2;Field  ;
                SourceExpr="Client Name";
                Editable=FALSE;
                StyleExpr=StatusColor }

    { 1102756000;2;Field  ;
                SourceExpr="Staff No";
                Editable=FALSE;
                StyleExpr=StatusColor }

    { 1102760046;2;Field  ;
                SourceExpr=Repayment }

    { 1000000002;2;Field  ;
                SourceExpr="loan  Interest" }

    { 1000000003;2;Field  ;
                SourceExpr="Loan Principle Repayment" }

    { 1000000004;2;Field  ;
                SourceExpr="Loan Interest Repayment" }

    { 1102760022;2;Field  ;
                SourceExpr="Requested Amount";
                Editable=FALSE }

    { 1000000015;2;Field  ;
                SourceExpr="Approved Amount";
                Editable=FALSE }

    { 1120054010;2;Field  ;
                SourceExpr="Loan Arrears" }

    { 1000000021;2;Field  ;
                SourceExpr="Outstanding Balance";
                Visible=TRUE;
                Editable=FALSE;
                StyleExpr=StatusColor }

    { 1102760008;2;Field  ;
                SourceExpr="Oustanding Interest";
                Visible=TRUE;
                StyleExpr=StatusColor }

    { 1102756002;2;Field  ;
                SourceExpr="Interest Debit";
                Visible=FALSE;
                Editable=FALSE }

    { 1102760040;2;Field  ;
                SourceExpr="Special Loan Amount";
                Visible=FALSE }

    { 1102760044;2;Field  ;
                SourceExpr="Other Commitments Clearance";
                Visible=FALSE;
                Editable=FALSE }

    { 1102760038;2;Field  ;
                SourceExpr="Commitements Offset";
                Visible=FALSE;
                Editable=FALSE }

    { 1102760025;2;Field  ;
                SourceExpr="No. Of Guarantors";
                Visible=FALSE;
                Editable=FALSE }

    { 1102760027;2;Field  ;
                SourceExpr="No. Of Guarantors-FOSA";
                Visible=FALSE;
                Editable=FALSE }

    { 1102760010;2;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1102760002;2;Field  ;
                CaptionML=ENU=Installments;
                SourceExpr=Installments;
                Editable=FALSE }

    { 1000000009;2;Field  ;
                SourceExpr=Interest;
                Editable=FALSE }

    { 1102760016;2;Field  ;
                SourceExpr="Loan Status";
                Editable=FALSE }

    { 1102760018;2;Field  ;
                SourceExpr="Discounted Amount";
                Editable=FALSE }

    { 1102760042;2;Field  ;
                SourceExpr="Last Pay Date" }

    { 1000000013;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1102755000;2;Field  ;
                SourceExpr="Account No" }

    { 1102756004;2;Field  ;
                SourceExpr=Remarks;
                Visible=FALSE;
                Editable=FALSE }

    { 1102755025;2;Field  ;
                SourceExpr="Loans Insurance" }

    { 1000000005;2;Field  ;
                SourceExpr="Check Int" }

    { 1120054003;2;Field  ;
                SourceExpr="Schedule Repayments" }

    { 1120054004;2;Field  ;
                SourceExpr="Total Repayment" }

    { 1000000008;2;Field  ;
                SourceExpr="Approved By" }

    { 1120054011;2;Field  ;
                SourceExpr="Oustanding Penalty" }

    { 1120054016;2;Field  ;
                SourceExpr="Totals Outstanding" }

  }
  CODE
  {
    VAR
      i@1117 : Integer;
      LoanType@1116 : Record 51516240;
      PeriodDueDate@1115 : Date;
      ScheduleRep@1114 : Record 51516234;
      RunningDate@1113 : Date;
      G@1112 : Integer;
      IssuedDate@1111 : Date;
      GracePeiodEndDate@1110 : Date;
      InstalmentEnddate@1109 : Date;
      GracePerodDays@1108 : Integer;
      InstalmentDays@1107 : Integer;
      NoOfGracePeriod@1106 : Integer;
      NewSchedule@1105 : Record 51516234;
      RSchedule@1104 : Record 51516234;
      GP@1103 : Text[30];
      ScheduleCode@1102 : Code[20];
      PreviewShedule@1101 : Record 51516234;
      PeriodInterval@1100 : Code[10];
      CustomerRecord@1099 : Record 51516223;
      Gnljnline@1098 : Record 81;
      Jnlinepost@1097 : Codeunit 12;
      CumInterest@1096 : Decimal;
      NewPrincipal@1095 : Decimal;
      PeriodPrRepayment@1094 : Decimal;
      GenBatch@1093 : Record 232;
      LineNo@1092 : Integer;
      GnljnlineCopy@1091 : Record 81;
      NewLNApplicNo@1090 : Code[10];
      Cust@1089 : Record 51516223;
      LoanApp@1088 : Record 51516230;
      TestAmt@1087 : Decimal;
      CustRec@1086 : Record 51516223;
      CustPostingGroup@1085 : Record 92;
      GenSetUp@1084 : Record 311;
      PCharges@1083 : Record 51516242;
      TCharges@1082 : Decimal;
      LAppCharges@1081 : Record 51516244;
      LoansR@1080 : Record 51516230;
      LoanAmount@1079 : Decimal;
      InterestRate@1078 : Decimal;
      RepayPeriod@1077 : Integer;
      LBalance@1076 : Decimal;
      RunDate@1075 : Date;
      InstalNo@1074 : Decimal;
      RepayInterval@1073 : DateFormula;
      TotalMRepay@1072 : Decimal;
      LInterest@1071 : Decimal;
      LPrincipal@1070 : Decimal;
      RepayCode@1069 : Code[40];
      GrPrinciple@1068 : Integer;
      GrInterest@1067 : Integer;
      QPrinciple@1066 : Decimal;
      QCounter@1065 : Integer;
      InPeriod@1064 : DateFormula;
      InitialInstal@1063 : Integer;
      InitialGraceInt@1062 : Integer;
      GenJournalLine@1061 : Record 81;
      FOSAComm@1060 : Decimal;
      BOSAComm@1059 : Decimal;
      GLPosting@1058 : Codeunit 12;
      LoanTopUp@1057 : Record 51516235;
      Vend@1056 : Record 23;
      BOSAInt@1055 : Decimal;
      TopUpComm@1054 : Decimal;
      DActivity@1053 : Code[20];
      DBranch@1052 : Code[20];
      TotalTopupComm@1051 : Decimal;
      Notification@1050 : Codeunit 397;
      CustE@1049 : Record 51516223;
      DocN@1048 : Text[50];
      DocM@1047 : Text[100];
      DNar@1046 : Text[250];
      DocF@1045 : Text[50];
      MailBody@1044 : Text[250];
      ccEmail@1043 : Text[250];
      LoanG@1042 : Record 51516231;
      SpecialComm@1041 : Decimal;
      FOSAName@1040 : Text[150];
      IDNo@1039 : Code[50];
      MovementTracker@1038 : Record 51516253;
      DiscountingAmount@1037 : Decimal;
      StatusPermissions@1036 : Record 51516310;
      BridgedLoans@1035 : Record 51516238;
      SMSMessage@1034 : Record 51516223;
      InstallNo2@1033 : Integer;
      currency@1032 : Record 330;
      CURRENCYFACTOR@1031 : Decimal;
      LoanApps@1030 : Record 51516230;
      LoanDisbAmount@1029 : Decimal;
      BatchTopUpAmount@1028 : Decimal;
      BatchTopUpComm@1027 : Decimal;
      Disbursement@1026 : Record 51516236;
      SchDate@1025 : Date;
      DisbDate@1024 : Date;
      WhichDay@1023 : Integer;
      LBatches@1022 : Record 51516230;
      SalDetails@1021 : Record 51516232;
      LGuarantors@1020 : Record 51516231;
      DocumentType@1019 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      CurrpageEditable@1018 : Boolean;
      LoanStatusEditable@1017 : Boolean;
      MNoEditable@1016 : Boolean;
      ApplcDateEditable@1015 : Boolean;
      LProdTypeEditable@1014 : Boolean;
      InstallmentEditable@1013 : Boolean;
      AppliedAmountEditable@1012 : Boolean;
      ApprovedAmountEditable@1011 : Boolean;
      RepayMethodEditable@1010 : Boolean;
      RepaymentEditable@1009 : Boolean;
      BatchNoEditable@1008 : Boolean;
      RepayFrequencyEditable@1007 : Boolean;
      ModeofDisburesmentEdit@1006 : Boolean;
      DisbursementDateEditable@1005 : Boolean;
      AccountNoEditable@1004 : Boolean;
      LNBalance@1003 : Decimal;
      ApprovalEntries@1002 : Record 454;
      RejectionRemarkEditable@1001 : Boolean;
      ApprovalEntry@1000 : Record 454;
      Overdue@1118 : 'Yes, ';
      SkyMbanking@1120054000 : Codeunit 51516701;
      StatusColor@1120054001 : Text;
      SFactory@1120054002 : Codeunit 51516022;
      LoanAge@1120054003 : Codeunit 51516159;

    PROCEDURE GetVariables@1000000000(VAR LoanNo@1000000000 : Code[20];VAR LoanProductType@1000000001 : Code[20]);
    BEGIN
      LoanNo:="Loan  No.";
      LoanProductType:="Loan Product Type";
    END;

    PROCEDURE FormatField@2(Rec@1000 : Record 51516230) OK : Boolean;
    BEGIN
      IF "Outstanding Balance">0 THEN BEGIN
        IF (Rec."Expected Date of Completion" < TODAY) THEN
          EXIT(TRUE)
        ELSE
          EXIT(FALSE);
      END;
    END;

    PROCEDURE CalledFrom@3();
    BEGIN
      Overdue := Overdue::" ";
    END;

    BEGIN
    END.
  }
}

