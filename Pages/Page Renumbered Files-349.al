OBJECT page 50040 Pending Approvals card
{
  OBJECT-PROPERTIES
  {
    Date=11/05/22;
    Time=[ 4:27:38 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516230;
    SourceTableView=WHERE(Source=CONST(FOSA),
                          Posted=CONST(No));
    PageType=Card;
    OnOpenPage=BEGIN
                 SETRANGE(Posted,FALSE);
                 CurrPage.EDITABLE := FALSE;
               END;

    OnNextRecord=BEGIN
                   IF "Loan Status"="Loan Status"::Approved THEN
                   CurrPage.EDITABLE:=FALSE;
                 END;

    OnNewRecord=BEGIN
                  Source:=Source::FOSA;
                  "Mode of Disbursement":="Mode of Disbursement"::"Transfer to FOSA";
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
      { 13      ;2   ;Action    ;
                      Name=Mark As Posted;
                      CaptionML=ENU=Mark As Posted;
                      Visible=FALSE;
                      OnAction=BEGIN
                                 Posted := TRUE;
                                 MODIFY;
                               END;
                                }
      { 1000000006;2 ;Action    ;
                      Name=Update Employer Loan Codes;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 CheckoffMatrix.RESET;
                                 CheckoffMatrix.SETRANGE(CheckoffMatrix."Employer Code","Employer Code");
                                 CheckoffMatrix.SETRANGE(CheckoffMatrix."Loan Product Code","Loan Product Type");
                                 CheckoffMatrix.SETRANGE(CheckoffMatrix."check Interest",FALSE);
                                 IF CheckoffMatrix.FIND('-') THEN BEGIN
                                 "Emp Loan Codes":=CheckoffMatrix."Check off Code";
                                 MODIFY;
                                 END;
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=Loan Appraisal;
                      CaptionML=ENU=Loan Appraisal;
                      Promoted=Yes;
                      Enabled=true;
                      Image=Aging;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Register.RESET;
                                 Register.SETRANGE(Register."Client Code","Client Code");
                                 Register.SETRANGE(Register."Loan Product Type","Loan Product Type");
                                 Register.SETFILTER(Register."Outstanding Balance",'>0');
                                 IF Register.FIND('-') THEN BEGIN
                                   OffsetDetails.RESET;
                                   OffsetDetails.SETRANGE(OffsetDetails."Client Code",Register."Client Code");
                                   OffsetDetails.SETFILTER(OffsetDetails."Loan Type",Register."Loan Product Type");
                                   IF OffsetDetails.FIND('-')=FALSE THEN BEGIN
                                   ERROR('Offset the previous %1 to continue',"Loan Product Type Name")
                                     END;
                                 END;

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 REPORT.RUN(51516263,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 11      ;2   ;Separator  }
      { 10      ;2   ;Action    ;
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

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN
                                 REPORT.RUN(51516317,TRUE,FALSE,LoanApp);
                               END;
                                }
      { 9       ;2   ;Separator  }
      { 8       ;2   ;Action    ;
                      CaptionML=ENU=Loans Top Up;
                      RunObject=page 17387;
                      RunPageLink=Loan No.=FIELD(Loan  No.),
                                  Client Code=FIELD(Client Code);
                      Promoted=Yes;
                      Image=AddAction;
                      PromotedCategory=Process }
      { 7       ;2   ;Separator  }
      { 6       ;2   ;Separator  }
      { 5       ;2   ;Action    ;
                      Name=Post Loan;
                      CaptionML=ENU=Post Loan;
                      Visible=FALSE;
                      OnAction=BEGIN
                                 //SMS MESSAGE/// To Applicant
                                       SMSMessage.RESET;
                                       IF SMSMessage.FIND('+') THEN BEGIN
                                       iEntryNo:=SMSMessage."Entry No";
                                       iEntryNo:=iEntryNo+1;
                                       END
                                       ELSE BEGIN
                                       iEntryNo:=1;
                                       END;

                                       SMSMessage.RESET;
                                       SMSMessage.INIT;
                                       SMSMessage."Entry No":=iEntryNo;
                                       SMSMessage."Account No":="Account No";
                                       SMSMessage."Date Entered":=TODAY;
                                       SMSMessage."Time Entered":=TIME;
                                       SMSMessage.Source:='LOAN ISSUE';
                                       SMSMessage."Entered By":=USERID;
                                       SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                       SMSMessage."SMS Message":='Your loan application of KSHs.'+FORMAT("Approved Amount")+
                                                                 ' has been issued. SHIRIKA SACCO LTD';
                                       VEND1.RESET;
                                       IF VEND1.GET("Account No") THEN
                                       SMSMessage."Telephone No" := VEND1."Phone No.";
                                       SMSMessage.INSERT;

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
      { 4       ;2   ;Separator  }
      { 3       ;2   ;Action    ;
                      Name=Loan Securities;
                      CaptionML=ENU=Securities;
                      RunObject=page 20471;
                      RunPageLink=Employee Code=FIELD(Loan  No.);
                      Promoted=Yes;
                      Visible=TRUE;
                      Image=AllLines;
                      PromotedCategory=Process }
      { 2       ;2   ;Action    ;
                      CaptionML=ENU=Salary Details;
                      RunObject=page 17384;
                      RunPageLink=Loan No=FIELD(Loan  No.),
                                  Client Code=FIELD(Client Code);
                      Promoted=Yes;
                      Visible=False;
                      Enabled=true;
                      Image=CheckList;
                      PromotedCategory=Process }
      { 1       ;2   ;Action    ;
                      CaptionML=ENU=Guarantors;
                      RunObject=page 17385;
                      RunPageLink=Loan No=FIELD(Loan  No.);
                      Promoted=Yes;
                      Visible=true;
                      Image=Allocations;
                      PromotedCategory=Process }
      { 1102755004;1 ;ActionGroup;
                      CaptionML=ENU=Approvals;
                      ActionContainerType=NewDocumentItems }
      { 1120054001;2 ;Action    ;
                      Name=Approvals;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      OnAction=BEGIN
                                 ApprovalMgt.OpenApprovalEntriesPage(RECORDID)
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Reject;
                      Promoted=Yes;
                      Image=Reject;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 //IF "Loan Status"<>"Loan Status"::Appraisal THEN
                                 // ERROR(Text001);
                                  {
                                 Doc_Type:=Doc_Type::Loan;
                                 Table_id:=DATABASE::"Loans Register";
                                 }
                                 {
                                 IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendLoanAppDocForApproval(Rec);
                                   }
                                 {
                                 Doc_Type:=Doc_Type::Loan;
                                 Table_id:=DATABASE::"Loans Register";
                                 IF ApprovalMgt.SendApproval(Table_id,"Loan  No.",Doc_Type,"Loan Status")THEN;

                                 }

                                 "Loan Status":="Loan Status"::Rejected;
                                 "Approval Status":="Approval Status"::Rejected;
                                 MODIFY;
                                 MESSAGE('Loan rejection successful');
                               END;
                                }
      { 1102755007;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=true;
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
      { 1102755003;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN
                                 {IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelLoanAppApprovalRequest(Rec);}
                                   "Loan Status":="Loan Status"::Application;
                                 "Approval Status":="Approval Status"::Open;
                                 MODIFY
                               END;
                                }
      { 1000000000;2 ;Action    ;
                      Name=Reopen;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Calculate;
                      OnAction=BEGIN
                                 "Loan Status":="Loan Status"::Application;
                                 "Approval Status":="Approval Status"::Open;
                                 MODIFY

                                 {IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelLoanAppApprovalRequest(Rec);
                                 }
                               END;
                                }
      { 1120054002;2 ;Action    ;
                      Name=Return to Appraisal;
                      CaptionML=ENU=Return to Appraisal;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Calculate;
                      OnAction=BEGIN
                                 "Loan Status":="Loan Status"::Appraisal;
                                 "Approval Status":="Approval Status"::Open;
                                 MODIFY

                                 {IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelLoanAppApprovalRequest(Rec);
                                 }
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 50  ;0   ;Container ;
                ContainerType=ContentArea }

    { 49  ;1   ;Group     ;
                CaptionML=ENU=General }

    { 48  ;2   ;Field     ;
                SourceExpr="Loan  No.";
                Editable=FALSE }

    { 47  ;2   ;Field     ;
                CaptionML=ENU=Staff No;
                SourceExpr="Staff No";
                Editable=FALSE }

    { 46  ;2   ;Field     ;
                CaptionML=ENU=FOSA Account No;
                SourceExpr="Account No";
                Editable=MNoEditable }

    { 45  ;2   ;Field     ;
                SourceExpr="Client Name";
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                SourceExpr="ID NO";
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                SourceExpr="Application Date";
                Editable=ApplcDateEditable;
                OnValidate=BEGIN
                              TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 42  ;2   ;Field     ;
                SourceExpr="Loan Product Type";
                Editable=LProdTypeEditable;
                OnValidate=BEGIN
                             Register.RESET;
                             Register.SETRANGE(Register."Client Code","Client Code");
                             Register.SETRANGE(Register."Loan Product Type","Loan Product Type");
                             Register.SETFILTER(Register."Outstanding Balance",'>0');
                             IF Register.FIND('-') THEN BEGIN
                             ERROR('This member has an existing type of loan.');
                             END;
                           END;
                            }

    { 41  ;2   ;Field     ;
                SourceExpr=Installments;
                Editable=InstallmentEditable;
                OnValidate=BEGIN
                             TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 40  ;2   ;Field     ;
                SourceExpr=Interest;
                Editable=Interrest }

    { 39  ;2   ;Field     ;
                SourceExpr="Product Currency Code";
                Enabled=TRUE;
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                CaptionML=ENU=Amount Applied;
                SourceExpr="Requested Amount";
                Editable=AppliedAmountEditable;
                OnValidate=BEGIN
                              TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 36  ;2   ;Field     ;
                CaptionML=ENU=Approved Amount;
                SourceExpr="Approved Amount";
                Editable=ApprovedAmountEditable;
                OnValidate=BEGIN
                             TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 35  ;2   ;Field     ;
                SourceExpr="Loan Purpose";
                Visible=FALSE;
                Editable=TRUE }

    { 33  ;2   ;Field     ;
                SourceExpr=Remarks;
                Visible=TRUE;
                Editable=TRUE }

    { 32  ;2   ;Field     ;
                SourceExpr="Repayment Method";
                Editable=RepayMethodEditable }

    { 31  ;2   ;Field     ;
                SourceExpr=Repayment;
                Editable=RepaymentEditable }

    { 30  ;2   ;Field     ;
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

    { 28  ;2   ;Field     ;
                SourceExpr="Captured By";
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                SourceExpr="Batch No.";
                Editable=BatchNoEditable }

    { 1000000002;2;Field  ;
                SourceExpr="Top Up Amount" }

    { 1000000001;2;Field  ;
                SourceExpr="Total TopUp Commission" }

    { 26  ;2   ;Field     ;
                SourceExpr="Other Commitments Clearance";
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                SourceExpr="Repayment Frequency";
                Editable=RepayFrequencyEditable }

    { 24  ;2   ;Field     ;
                SourceExpr="Recovery Mode" }

    { 23  ;2   ;Field     ;
                SourceExpr="Mode of Disbursement";
                Editable=ModeofDisburesmentEdit }

    { 22  ;2   ;Field     ;
                SourceExpr="Loan Disbursement Date";
                Editable=DisbursementDateEditable }

    { 21  ;2   ;Field     ;
                SourceExpr="Cheque No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             IF STRLEN("Cheque No.") > 6 THEN
                               ERROR('Document No. cannot contain More than 6 Characters.');
                           END;
                            }

    { 20  ;2   ;Field     ;
                SourceExpr="Repayment Start Date";
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                SourceExpr="Expected Date of Completion";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                SourceExpr="External EFT";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                SourceExpr="Approval Status";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                SourceExpr="Transacting Branch";
                Visible=TRUE;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                SourceExpr="Recommended Amount";
                Editable=FALSE }

    { 56  ;1   ;Group     ;
                CaptionML=ENU=Earnings;
                GroupType=Group }

    { 55  ;2   ;Field     ;
                CaptionML=ENU=Basic Pay;
                SourceExpr="Basic Pay H" }

    { 1000000005;2;Field  ;
                SourceExpr="Other Income." }

    { 57  ;2   ;Field     ;
                SourceExpr="Total Earnings(Salary)" }

    { 15  ;2   ;Field     ;
                SourceExpr="Total Deductions(Salary)" }

    { 1000000004;2;Field  ;
                SourceExpr="Third basic" }

    { 1000000003;2;Field  ;
                SourceExpr="Two Thirds Basic" }

    { 27  ;2   ;Field     ;
                CaptionML=ENU=Ability;
                SourceExpr="Net take Home" }

  }
  CODE
  {
    VAR
      iEntryNo@1000000054 : Integer;
      VEND1@1000000055 : Record 23;
      LoanGuar@1000000057 : Record 51516231;
      SMSMessage@1000000053 : Record 51516329;
      SMSMessages@1000000056 : Record 51516329;
      i@1000000001 : Integer;
      LoanType@1000000002 : Record 51516240;
      PeriodDueDate@1000000003 : Date;
      ScheduleRep@1000000004 : Record 51516234;
      RunningDate@1000000005 : Date;
      G@1000000006 : Integer;
      IssuedDate@1000000007 : Date;
      GracePeiodEndDate@1000000008 : Date;
      InstalmentEnddate@1000000009 : Date;
      GracePerodDays@1000000010 : Integer;
      InstalmentDays@1000000011 : Integer;
      NoOfGracePeriod@1000000012 : Integer;
      NewSchedule@1000000013 : Record 51516234;
      RSchedule@1000000040 : Record 51516234;
      GP@1000000014 : Text[30];
      ScheduleCode@1000000015 : Code[20];
      PreviewShedule@1000000016 : Record 51516234;
      PeriodInterval@1000000017 : Code[10];
      CustomerRecord@1000000032 : Record 51516223;
      Gnljnline@1000000027 : Record 81;
      Jnlinepost@1000000026 : Codeunit 12;
      CumInterest@1000000025 : Decimal;
      NewPrincipal@1000000024 : Decimal;
      PeriodPrRepayment@1000000023 : Decimal;
      GenBatch@1000000022 : Record 232;
      LineNo@1000000021 : Integer;
      GnljnlineCopy@1000000020 : Record 81;
      NewLNApplicNo@1000000018 : Code[10];
      Cust@1000000028 : Record 51516223;
      LoanApp@1000000029 : Record 51516230;
      TestAmt@1000000030 : Decimal;
      CustRec@1000000033 : Record 51516223;
      CustPostingGroup@1000000034 : Record 92;
      GenSetUp@1000000035 : Record 311;
      PCharges@1000000036 : Record 51516242;
      TCharges@1000000037 : Decimal;
      LAppCharges@1000000038 : Record 51516244;
      LoansR@1000000039 : Record 51516230;
      LoanAmount@1000000041 : Decimal;
      InterestRate@1000000042 : Decimal;
      RepayPeriod@1000000043 : Integer;
      LBalance@1000000044 : Decimal;
      RunDate@1000000045 : Date;
      InstalNo@1000000046 : Decimal;
      RepayInterval@1000000047 : DateFormula;
      TotalMRepay@1000000048 : Decimal;
      LInterest@1000000049 : Decimal;
      LPrincipal@1000000050 : Decimal;
      RepayCode@1000000051 : Code[40];
      GrPrinciple@1102760000 : Integer;
      GrInterest@1102760001 : Integer;
      QPrinciple@1102760002 : Decimal;
      QCounter@1102760003 : Integer;
      InPeriod@1102760004 : DateFormula;
      InitialInstal@1102760005 : Integer;
      InitialGraceInt@1102760006 : Integer;
      GenJournalLine@1102760007 : Record 81;
      FOSAComm@1102760008 : Decimal;
      BOSAComm@1102760009 : Decimal;
      GLPosting@1102760010 : Codeunit 12;
      LoanTopUp@1102760011 : Record 51516235;
      Vend@1102760012 : Record 23;
      BOSAInt@1102760013 : Decimal;
      TopUpComm@1102760014 : Decimal;
      DActivity@1102760015 : Code[20];
      DBranch@1102760016 : Code[20];
      TotalTopupComm@1102760018 : Decimal;
      Notification@1102760026 : Codeunit 397;
      CustE@1102760025 : Record 51516223;
      DocN@1102760024 : Text[50];
      DocM@1102760023 : Text[100];
      DNar@1102760022 : Text[250];
      DocF@1102760021 : Text[50];
      MailBody@1102760020 : Text[250];
      ccEmail@1102760019 : Text[250];
      LoanG@1102760027 : Record 51516230;
      SpecialComm@1102760028 : Decimal;
      FOSAName@1102760029 : Text[150];
      IDNo@1102760030 : Code[50];
      MovementTracker@1102760032 : Record 51516254;
      DiscountingAmount@1102760033 : Decimal;
      StatusPermissions@1102760034 : Record 51516310;
      BridgedLoans@1102760035 : Record 51516235;
      InstallNo2@1102755000 : Integer;
      currency@1102755001 : Record 330;
      CURRENCYFACTOR@1102755002 : Decimal;
      LoanApps@1102755003 : Record 51516230;
      LoanDisbAmount@1102755004 : Decimal;
      BatchTopUpAmount@1102755005 : Decimal;
      BatchTopUpComm@1102755006 : Decimal;
      SchDate@1102755010 : Date;
      DisbDate@1102755009 : Date;
      WhichDay@1102755008 : Integer;
      LBatches@1102755012 : Record 51516236;
      SalDetails@1102755014 : Record 51516232;
      LGuarantors@1102755013 : Record 51516231;
      Text001@1102755015 : TextConst 'ENU=Status Must Be Open';
      DocumentType@1000000019 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      CurrpageEditable@1102755011 : Boolean;
      LoanStatusEditable@1102755016 : Boolean;
      MNoEditable@1102755017 : Boolean;
      ApplcDateEditable@1102755018 : Boolean;
      LProdTypeEditable@1102755019 : Boolean;
      InstallmentEditable@1102755026 : Boolean;
      AppliedAmountEditable@1102755020 : Boolean;
      ApprovedAmountEditable@1102755021 : Boolean;
      RepayMethodEditable@1102755022 : Boolean;
      RepaymentEditable@1102755023 : Boolean;
      BatchNoEditable@1102755027 : Boolean;
      RepayFrequencyEditable@1102755024 : Boolean;
      ModeofDisburesmentEdit@1102755025 : Boolean;
      DisbursementDateEditable@1102755028 : Boolean;
      Interrest@1000000000 : Boolean;
      InterestSal@1102755029 : Decimal;
      NetIncome@1000000031 : Boolean;
      ApprovalsMgmt@1000000052 : Codeunit 1535;
      Register@1000000058 : Record 51516230;
      OffsetDetails@1000000059 : Record 51516235;
      LRegister@1000000060 : Record 51516230;
      CheckoffMatrix@1000000061 : Record 51516286;
      ApprovalMgt@1120054003 : Codeunit 1535;
      ApprovalEntry@1120054002 : Record 454;
      CustomApprovals@1120054001 : Codeunit 51516163;
      VarVariant@1120054000 : Variant;

    PROCEDURE UpdateControl@1102755000();
    BEGIN
      IF "Loan Status"="Loan Status"::Application THEN BEGIN
      MNoEditable:=TRUE;
      ApplcDateEditable:=TRUE;
      LoanStatusEditable:=FALSE;
      LProdTypeEditable:=TRUE;
      InstallmentEditable:=TRUE;
      NetIncome:=TRUE;
      Interrest:=FALSE;
      AppliedAmountEditable:=TRUE;
      ApprovedAmountEditable:=TRUE;
      RepayMethodEditable:=TRUE;
      RepaymentEditable:=TRUE;
      BatchNoEditable:=FALSE;
      RepayFrequencyEditable:=TRUE;
      ModeofDisburesmentEdit:=TRUE;
      DisbursementDateEditable:=TRUE;
      END;

      IF "Loan Status"="Loan Status"::Appraisal THEN BEGIN
      MNoEditable:=FALSE;
      ApplcDateEditable:=TRUE;
      LoanStatusEditable:=FALSE;
      LProdTypeEditable:=FALSE;
      Interrest:=FALSE;
      NetIncome:=TRUE;
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
      ApplcDateEditable:=FALSE;
      LoanStatusEditable:=FALSE;
      LProdTypeEditable:=FALSE;
      InstallmentEditable:=FALSE;
      AppliedAmountEditable:=FALSE;
      NetIncome:=FALSE;
      Interrest:=FALSE;
      ApprovedAmountEditable:=FALSE;
      RepayMethodEditable:=FALSE;
      RepaymentEditable:=FALSE;
      BatchNoEditable:=FALSE;
      RepayFrequencyEditable:=FALSE;
      ModeofDisburesmentEdit:=FALSE;
      DisbursementDateEditable:=FALSE;
      END;

      IF "Loan Status"="Loan Status"::Approved THEN BEGIN
      MNoEditable:=FALSE;
      LoanStatusEditable:=FALSE;
      ApplcDateEditable:=FALSE;
      Interrest:=FALSE;
      LProdTypeEditable:=FALSE;
      NetIncome:=FALSE;
      InstallmentEditable:=FALSE;
      AppliedAmountEditable:=FALSE;
      ApprovedAmountEditable:=FALSE;
      RepayMethodEditable:=FALSE;
      RepaymentEditable:=FALSE;
      BatchNoEditable:=TRUE;
      RepayFrequencyEditable:=FALSE;
      ModeofDisburesmentEdit:=TRUE;
      DisbursementDateEditable:=TRUE;
      END;
    END;

    PROCEDURE LoanAppPermisions@1102760000();
    BEGIN
    END;

    BEGIN
    END.
  }
}

