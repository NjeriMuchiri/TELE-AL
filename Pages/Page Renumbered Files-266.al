OBJECT page 17457 Loans List - Advances
{
  OBJECT-PROPERTIES
  {
    Date=04/09/21;
    Time=[ 2:07:53 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516230;
    SourceTableView=WHERE(Posted=FILTER(No),
                          Source=CONST(FOSA),
                          Loan Status=CONST(Application));
    PageType=List;
    CardPageID=Loan Application CardAdvances;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnAfterGetRecord=BEGIN
                       Overdue := Overdue::" ";
                       IF FormatField(Rec) THEN
                         Overdue := Overdue::Yes;
                     END;

    ActionList=ACTIONS
    {
      { 1102755024;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755023;1 ;ActionGroup;
                      CaptionML=ENU=Loan;
                      Image=AnalysisView }
      { 1102755022;2 ;Action    ;
                      Name=Mark As Posted;
                      CaptionML=ENU=Mark As Posted;
                      Visible=FALSE;
                      OnAction=BEGIN
                                 Posted := TRUE;
                                 MODIFY;
                               END;
                                }
      { 1102755021;2 ;Action    ;
                      Name=Loan Appraisal;
                      CaptionML=ENU=Loan Appraisal;
                      Promoted=Yes;
                      Enabled=FALSE;
                      Image=Aging;
                      PromotedCategory=Report }
      { 1102755020;2 ;Separator  }
      { 1102755019;2 ;Action    ;
                      Name=View Schedule;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=View Schedule;
                      Promoted=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 //IF Posted=TRUE THEN
                                 //ERROR('Loan has been posted, Can only preview schedule');

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
                                 {
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,LoanApp);
                                 }
                               END;
                                }
      { 1102755018;2 ;Separator  }
      { 1102755017;2 ;Action    ;
                      CaptionML=ENU=Loans Top Up;
                      RunObject=page 20472;
                      RunPageLink=Field1=FIELD(Loan  No.),
                                  Field3=FIELD(Client Code);
                      Promoted=Yes;
                      Image=AddAction;
                      PromotedCategory=Process }
      { 1102755016;2 ;Separator  }
      { 1102755014;2 ;Separator  }
      { 1102755013;2 ;Action    ;
                      Name=Post Loan;
                      CaptionML=ENU=Post Loan;
                      Visible=FALSE;
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
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
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
      { 1102755012;2 ;Separator  }
      { 1102755011;2 ;Action    ;
                      Name=Loan Securities;
                      CaptionML=ENU=Securities;
                      RunObject=page 20471;
                      RunPageLink=Employee Code=FIELD(Loan  No.);
                      Promoted=Yes;
                      Visible=TRUE;
                      Image=AllLines;
                      PromotedCategory=Process }
      { 1102755010;2 ;Action    ;
                      CaptionML=ENU=Salary Details;
                      RunObject=Page 51516177;
                      RunPageLink=Field6=FIELD(Loan  No.),
                                  Field1=FIELD(Client Code);
                      Promoted=Yes;
                      Enabled=FALSE;
                      Image=CheckList;
                      PromotedCategory=Process }
      { 1102755009;2 ;Action    ;
                      CaptionML=ENU=Guarantors;
                      RunObject=page 20470;
                      RunPageLink=No.=FIELD(Loan  No.);
                      Promoted=Yes;
                      Image=Allocations;
                      PromotedCategory=Process }
      { 1102755008;2 ;Separator  }
      { 1102755007;1 ;ActionGroup;
                      CaptionML=ENU=Approvals;
                      ActionContainerType=NewDocumentItems }
      { 1102755005;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::Loan;
                                 ApprovalEntries.Setfilters(DATABASE::"Absence Preferences",DocumentType,"Loan  No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755003;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This transaction is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN

                                 SalDetails.RESET;
                                 SalDetails.SETRANGE(SalDetails."Client Code","Client Code");
                                 IF SalDetails.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Salary Information');
                                 END;

                                 LGuarantors.RESET;
                                 LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                 IF LGuarantors.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Guarantor Information');
                                 END;

                                 IF ("Mode of Disbursement"="Mode of Disbursement"::Cheque) OR
                                 ("Mode of Disbursement"="Mode of Disbursement"::"Transfer to FOSA") OR
                                 ("Mode of Disbursement"="Mode of Disbursement"::" ")THEN
                                 ERROR('Mode of disbursment must be FOSA Loans');

                                 TESTFIELD("Approved Amount");
                                 TESTFIELD("Loan Product Type");


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
                               END;
                                }
      { 1102755001;2 ;Action    ;
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
    { 15  ;0   ;Container ;
                ContainerType=ContentArea }

    { 14  ;1   ;Group     ;
                GroupType=Repeater }

    { 13  ;2   ;Field     ;
                SourceExpr="Loan  No.";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                SourceExpr="Old Account No.";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                SourceExpr="Loan Product Type";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                SourceExpr="Advice Type" }

    { 9   ;2   ;Field     ;
                SourceExpr="Expected Date of Completion" }

    { 8   ;2   ;Field     ;
                SourceExpr="Application Date";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="Client Code";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr="BOSA No" }

    { 5   ;2   ;Field     ;
                SourceExpr="Issued Date";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr="Client Name";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                SourceExpr="Account No" }

    { 1   ;2   ;Field     ;
                SourceExpr=Remarks;
                Visible=FALSE;
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Loan Status" }

  }
  CODE
  {
    VAR
      LoanType@1000000000 : Record 51516240;
      NoSeriesMgt@1000000001 : Codeunit 396;
      LoanApp@1102760002 : Record 51516230;
      DiscountingAmount@1102760001 : Decimal;
      StatusPermissions@1102760000 : Record 51516310;
      SpecialComm@1102760003 : Decimal;
      GenJournalLine@1102760004 : Record 81;
      LoansR@1102760005 : Record 51516230;
      DActivity@1102760006 : Code[20];
      DBranch@1102760007 : Code[20];
      Vend@1102760008 : Record 23;
      LineNo@1102760009 : Integer;
      DoubleComm@1102760010 : Boolean;
      AvailableBal@1102760011 : Decimal;
      Account@1102760012 : Record 23;
      RunBal@1102760013 : Decimal;
      TotalRecovered@1102760014 : Decimal;
      OInterest@1102760015 : Decimal;
      OBal@1102760016 : Decimal;
      ReffNo@1102760017 : Code[20];
      DiscountCommission@1102760018 : Decimal;
      BridgedLoans@1102760019 : Record 51516235;
      LoanAdj@1102756000 : Decimal;
      LoanAdjInt@1102756001 : Decimal;
      AdjustRemarks@1102755000 : Text[30];
      Princip@1102755001 : Decimal;
      Overdue@1102755002 : 'Yes, ';
      i@1102755101 : Integer;
      PeriodDueDate@1102755099 : Date;
      ScheduleRep@1102755098 : Record 51516234;
      RunningDate@1102755097 : Date;
      G@1102755096 : Integer;
      IssuedDate@1102755095 : Date;
      GracePeiodEndDate@1102755094 : Date;
      InstalmentEnddate@1102755093 : Date;
      GracePerodDays@1102755092 : Integer;
      InstalmentDays@1102755091 : Integer;
      NoOfGracePeriod@1102755090 : Integer;
      NewSchedule@1102755089 : Record 51516234;
      RSchedule@1102755088 : Record 51516234;
      GP@1102755087 : Text[30];
      ScheduleCode@1102755086 : Code[20];
      PreviewShedule@1102755085 : Record 51516234;
      PeriodInterval@1102755084 : Code[10];
      CustomerRecord@1102755083 : Record 51516223;
      Gnljnline@1102755082 : Record 81;
      Jnlinepost@1102755081 : Codeunit 12;
      CumInterest@1102755080 : Decimal;
      NewPrincipal@1102755079 : Decimal;
      PeriodPrRepayment@1102755078 : Decimal;
      GenBatch@1102755077 : Record 232;
      GnljnlineCopy@1102755075 : Record 81;
      NewLNApplicNo@1102755074 : Code[10];
      Cust@1102755073 : Record 51516223;
      TestAmt@1102755071 : Decimal;
      CustRec@1102755070 : Record 51516223;
      CustPostingGroup@1102755069 : Record 92;
      GenSetUp@1102755068 : Record 311;
      PCharges@1102755067 : Record 51516242;
      TCharges@1102755066 : Decimal;
      LAppCharges@1102755065 : Record 51516232;
      LoanAmount@1102755063 : Decimal;
      InterestRate@1102755062 : Decimal;
      RepayPeriod@1102755061 : Integer;
      LBalance@1102755060 : Decimal;
      RunDate@1102755059 : Date;
      InstalNo@1102755058 : Decimal;
      RepayInterval@1102755057 : DateFormula;
      TotalMRepay@1102755056 : Decimal;
      LInterest@1102755055 : Decimal;
      LPrincipal@1102755054 : Decimal;
      RepayCode@1102755053 : Code[40];
      GrPrinciple@1102755052 : Integer;
      GrInterest@1102755051 : Integer;
      QPrinciple@1102755050 : Decimal;
      QCounter@1102755049 : Integer;
      InPeriod@1102755048 : DateFormula;
      InitialInstal@1102755047 : Integer;
      InitialGraceInt@1102755046 : Integer;
      FOSAComm@1102755044 : Decimal;
      BOSAComm@1102755043 : Decimal;
      GLPosting@1102755042 : Codeunit 12;
      LoanTopUp@1102755041 : Record 51516235;
      BOSAInt@1102755039 : Decimal;
      TopUpComm@1102755038 : Decimal;
      TotalTopupComm@1102755035 : Decimal;
      Notification@1102755034 : Codeunit 397;
      CustE@1102755033 : Record 51516223;
      DocN@1102755032 : Text[50];
      DocM@1102755031 : Text[100];
      DNar@1102755030 : Text[250];
      DocF@1102755029 : Text[50];
      MailBody@1102755028 : Text[250];
      ccEmail@1102755027 : Text[250];
      LoanG@1102755026 : Record 51516231;
      FOSAName@1102755024 : Text[150];
      IDNo@1102755023 : Code[50];
      MovementTracker@1102755022 : Record 51516254;
      SMSMessage@1102755018 : Record 51516223;
      InstallNo2@1102755017 : Integer;
      currency@1102755016 : Record 330;
      CURRENCYFACTOR@1102755015 : Decimal;
      LoanApps@1102755014 : Record 51516230;
      LoanDisbAmount@1102755013 : Decimal;
      BatchTopUpAmount@1102755012 : Decimal;
      BatchTopUpComm@1102755011 : Decimal;
      SchDate@1102755009 : Date;
      DisbDate@1102755008 : Date;
      WhichDay@1102755007 : Integer;
      LBatches@1102755006 : Record 51516230;
      SalDetails@1102755005 : Record 51516232;
      LGuarantors@1102755004 : Record 51516231;
      DocumentType@1102755003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';

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

