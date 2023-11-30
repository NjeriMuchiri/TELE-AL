OBJECT page 50030 Loan Approved Card
{
  OBJECT-PROPERTIES
  {
    Date=07/12/23;
    Time=[ 2:58:32 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=Yes;
    DeleteAllowed=No;
    SourceTable=Table51516230;
    DelayedInsert=No;
    SourceTableView=WHERE(Source=CONST(BOSA),
                          Posted=CONST(No),
                          Approval Status=CONST(Approved));
    PageType=Card;
    ShowFilter=No;
    OnOpenPage=BEGIN
                 SETRANGE(Posted,FALSE);
                 {IF "Loan Status"="Loan Status"::Approved THEN
                 CurrPage.EDITABLE:=FALSE;}
                 //CurrPage.EDITABLE:=FALSE;
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
                      Visible=True;
                      Enabled=true;
                      Image=Aging;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF FnLoanProductHasBalance > FnLoanProductTopupAmount THEN
                                   ERROR('Clear balances for this product type before we can issue you with another loan of the same type.Current Balance is %1',FnLoanProductHasBalance);

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 //LoanApp.SETRANGE(LoanApp."Checked By",USERID);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 REPORT.RUN(51516335,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 1000000014;2 ;Action    ;
                      Name=Update PAYE;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN


                                 GenSetUp.GET();

                                 MODIFY;


                                 GrossPay:="Basic Pay H"+"Medical AllowanceH"+"House AllowanceH"+"Transport/Bus Fare";
                                 "Gross Pay":=GrossPay;
                                 MODIFY;

                                 //CALCFIELDS("Bridge Amount Release");

                                 "Utilizable Amount":=0;
                                 NetUtilizable:=0;
                                 NetRealizable:=0;

                                 OTrelief:="Other Tax Relief";

                                 IF Disabled<>TRUE THEN BEGIN
                                  { Rec.PAYE:=SFactory.FnCalculatePaye("Chargeable Pay");
                                 END;}

                                 //CALCULATE PAYE
                                 IF TAXABLEPAY.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF (GrossPay>=TAXABLEPAY."Lower Limit") AND (GrossPay<=TAXABLEPAY."Upper Limit") THEN BEGIN
                                 Chargeable:=ROUND(GrossPay-"Pension Scheme"-"Other Non-Taxable",1);
                                 Taxrelief:=1408;

                                 IF TAXABLEPAY."Tax Band"='01' THEN BEGIN
                                 BAND1:= 12298*0.1;
                                 PAYE:=ROUND(BAND1-Taxrelief-OTrelief);
                                 END ELSE
                                 IF TAXABLEPAY."Tax Band"='02' THEN BEGIN
                                 BAND1:=12298*0.1;
                                 BAND2:=(Chargeable-TAXABLEPAY."Lower Limit")*0.15;
                                 PAYE:=ROUND(BAND1+BAND2-Taxrelief-OTrelief);
                                 END ELSE
                                 IF TAXABLEPAY."Tax Band"='03' THEN BEGIN
                                 BAND1:= 12298*0.1;
                                 BAND2:=11587*0.15;
                                 BAND3:=(Chargeable-TAXABLEPAY."Lower Limit")*0.2;
                                 PAYE:=ROUND(BAND1+BAND2+BAND3-Taxrelief-OTrelief,1);
                                 END ELSE BEGIN
                                 IF TAXABLEPAY."Tax Band"='04' THEN BEGIN
                                 BAND1:= 12298*0.1;
                                 BAND2:=11587*0.15;
                                 BAND3:=11587*0.2;
                                 BAND4:=(Chargeable-TAXABLEPAY."Lower Limit")*0.25;
                                 PAYE:=ROUND(BAND1+BAND2+BAND3+BAND4-Taxrelief-OTrelief);
                                 END ELSE BEGIN
                                 IF TAXABLEPAY."Tax Band"='05' THEN BEGIN
                                 BAND1:= 12298*0.1;
                                 BAND2:=11587*0.15;
                                 BAND3:=11587*0.2;
                                 BAND4:=11587*0.25;
                                 BAND5:=(Chargeable-TAXABLEPAY."Lower Limit")*0.3;
                                 PAYE:=ROUND(BAND1+BAND2+BAND3+BAND4+BAND5-Taxrelief-OTrelief);

                                 IF ("Recovery Mode"="Recovery Mode"::Checkoff) OR ("Recovery Mode"="Recovery Mode"::Salary) THEN BEGIN
                                   PAYE:=PAYE
                                   END ELSE
                                   PAYE:=PAYE;
                                 IF "Exempted from PAYE" = TRUE THEN
                                 PAYE:=0;
                                 MODIFY;
                                 //MESSAGE('PAYE is %1',PAYE)
                                  // PAYE:=0;


                                 END;
                                 END;
                                 END;

                                  xRec.PAYE:=PAYE;

                                 END;
                                 UNTIL TAXABLEPAY.NEXT=0;
                                 END;
                                 END;
                                 //END;
                                 //nssfCalculation
                                 prNSSF.RESET;
                                 prNSSF.SETRANGE(prNSSF."Tier Code");
                                 IF prNSSF.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF ((GrossPay>=prNSSF."Lower Limit") AND (GrossPay<=prNSSF."Upper Limit")) THEN
                                     CalcNSSF:=prNSSF."Tier 1 Employee Deduction" + prNSSF."Tier 2 Employee Deduction";
                                    // MESSAGE('CalcNSSF %1',CalcNSSF);
                                 UNTIL prNSSF.NEXT=0;
                                 END;

                                 NSSF:=200;//CalcNSSF;
                                 MODIFY;
                                 //end of nssf calculation
                                 //calcNHIF


                                 prNHIF.RESET;
                                 prNHIF.SETCURRENTKEY(prNHIF."Tier Code");
                                 IF prNHIF.FINDFIRST THEN BEGIN
                                 REPEAT
                                 IF ((GrossPay>=prNHIF."NHIF Tier") AND (GrossPay<=prNHIF.Amount)) THEN
                                     CalcNHIF:=prNHIF."Lower Limit";
                                 UNTIL prNHIF.NEXT=0;
                                 END;

                                 NHIF:=CalcNHIF;
                                 MODIFY;
                                 //End Calc NHIF

                                 //insert Member Contribution Range
                                 TotalLoanOutstanding:=0;

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Loan  No.","Loan  No.");
                                 IF LoansR.FIND ('-') THEN BEGIN
                                 TotalLoanOutstanding:=LoansR."Total Outstanding Loan BAL";

                                 END;


                                 ContribTier.RESET;
                                 ContribTier.SETCURRENTKEY(ContribTier."Line No");
                                 IF ContribTier.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF ((TotalLoanOutstanding>=ContribTier."Lower Limit") AND (TotalLoanOutstanding<=ContribTier."Upper Limit")) THEN
                                     CalcContrib:=ContribTier."Contribution Amount";
                                     //MESSAGE('CalcContrib %1',CalcContrib);
                                     //MESSAGE('TotalLoanOutstanding %1',TotalLoanOutstanding);
                                     UNTIL ContribTier.NEXT=0;
                                 END;
                                 "Monthly Contribution":=CalcContrib;//CalcNSSF;
                                 MODIFY;
                                 //insert Member Contribution Range_End

                                 //+Nettakehome
                                 "Utilizable Amount":=(GrossPay{+"Other Incomes Amount"})-("Monthly Contribution"+NSSF+NHIF+PAYE{+"Staff Union Contribution"}+"Medical Insurance"
                                 +"Life Insurance"+"Other Liabilities"+"Other Loans Repayments"+"Sacco Deductions");


                                 TotalDeductions:="Monthly Contribution"+NSSF+NHIF+PAYE{+"Staff Union Contribution"}+"Medical Insurance"
                                 +"Life Insurance"+"Other Liabilities"{+Nettakehome}+"Other Loans Repayments"+"Sacco Deductions";
                                 //MESSAGE('%1,%2',NSSF,NHIF);




                                 Nettakehome:="Gross Pay"{+("Other Incomes Amount")}-TotalDeductions;

                                 NetUtilizable:="Utilizable Amount"+"Bridge Amount Release"-(1/3*"Gross Pay");
                                 "Utilizable Amount":="Utilizable Amount";
                                 "Net Utilizable Amount":=NetUtilizable;
                                 "Total DeductionsH":=TotalDeductions;
                                 "Net take Home":=Nettakehome;
                                 "Net Income":=GrossPay;
                                 MODIFY;


                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","Client Code");
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF "Monthly Contribution"=0 THEN BEGIN
                                 "Monthly Contribution":=Cust."Monthly Contribution";
                                 MODIFY;
                                 END;
                                 END;
                               END;
                                }
      { 1000000028;2 ;Action    ;
                      Name=Loan Appraisal New;
                      CaptionML=ENU=Loan Appraisal New;
                      Promoted=Yes;
                      Visible=False;
                      Enabled=true;
                      Image=Aging;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {IF "Loan Product Type" = 'R' THEN
                                   TESTFIELD("Top Up Amount");}
                                 TESTFIELD(PAYE);
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 REPORT.RUN(51516384,TRUE,FALSE,LoanApp);
                                 END;
                                 {//END ELSE
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 REPORT.RUN(51516384,TRUE,FALSE,LoanApp);
                                 END;
                                 }
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
      { 1000000054;2 ;Action    ;
                      Name=View Schedule;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=View Schedule;
                      Promoted=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Report;
                      OnAction=BEGIN
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
                                 RSchedule."Loan Balance":=LBalance;
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

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(0,USERID,'Loan Schedule Viewed.',"Requested Amount",
                                 'CREDIT',TODAY,TIME,"Loan  No.","Loan  No.","Client Code",'');
                                 COMMIT;
                                 //End Create Audit Entry

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
      { 1120054002;2 ;Action    ;
                      Name=View Schedulen;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=View Schedulen;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=ViewDetails;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 SFactory.FnGenerateLoanSchedule("Loan  No.");

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
      { 1102755012;2 ;Separator  }
      { 1102760008;2 ;Action    ;
                      CaptionML=ENU=Loans to Offset;
                      RunObject=page 17387;
                      RunPageLink=Loan No.=FIELD(Loan  No.),
                                  Client Code=FIELD(Client Code);
                      Promoted=Yes;
                      Image=AddAction;
                      PromotedCategory=Process }
      { 1102760039;2 ;Separator  }
      { 1102755018;2 ;Action    ;
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

                                 {
                                 IF LoanApps."Loan Status"<>LoanApps."Loan Status"::Approved THEN
                                 ERROR('Loan status must be Approved for you to post Loan. - ' + LoanApps."Loan  No.");
                                 }
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
                                 //SMS MESSAGE/// Loan Approved

                                    //SMS MESSAGE
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
                                       SMSMessages."Account No":="Account No";
                                       SMSMessages."Date Entered":=TODAY;
                                       SMSMessages."Time Entered":=TIME;
                                       SMSMessages.Source:='LOAN ISSUE';
                                       SMSMessages."Entered By":=USERID;
                                       SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
                                       //SMSMessages."Sent To Server":=SMSMessages."Sent To Server::No;
                                       SMSMessages."SMS Message":='Your loan application of KSHs.'+FORMAT("Approved Amount")+
                                                                 ' has been issued. SHIRIKA SACCO LTD';
                                       Cust.RESET;
                                       IF Cust.GET("Account No") THEN
                                       SMSMessages."Telephone No" := Cust."Phone No.";
                                       SMSMessages.INSERT;



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

                                 {
                                 IF LoanApps."Loan Status"<>LoanApps."Loan Status"::Approved THEN
                                 ERROR('Loan status must be Approved for you to post Loan. - ' + LoanApps."Loan  No.");
                                 }
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
                                        // IF ("Mode of Disbursement"="Mode of Disbursement"::Cheque) THEN BEGIN
                                     LineNo:=LineNo+10000;
                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='LOANS';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Document No.":="Loan  No.";;
                                     GenJournalLine."Posting Date":="Posting Date";
                                     GenJournalLine."External Document No.":="Cheque No.";
                                     GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                     GenJournalLine."Account No.":='NBL';
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine.Description:=Remarks;
                                     GenJournalLine.Amount:=LoanDisbAmount*-1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                     //END;


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


                                 IF ("Mode of Disbursement"="Mode of Disbursement"::Cheque) THEN BEGIN
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="Loan  No.";;
                                 GenJournalLine."Posting Date":="Posting Date";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":='NBL';
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:=Remarks;
                                 GenJournalLine.Amount:="Approved Amount"*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;

                                 {
                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PAYMENTS');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                                 END;
                                 }
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
      { 5       ;2   ;ActionGroup;
                      Name=More details }
      { 3       ;2   ;Action    ;
                      Name=Loan Securities;
                      CaptionML=ENU=Securities;
                      RunObject=page 17386;
                      RunPageLink=Loan No=FIELD(Loan  No.);
                      Promoted=Yes;
                      Visible=TRUE;
                      Image=AllLines;
                      PromotedCategory=Process }
      { 2       ;2   ;Action    ;
                      Name=Salary Details;
                      CaptionML=ENU=Salary Details;
                      RunObject=page 17384;
                      RunPageLink=Loan No=FIELD(Loan  No.),
                                  Client Code=FIELD(Client Code);
                      Promoted=Yes;
                      Visible=True;
                      Enabled=True;
                      Image=StatisticsGroup;
                      PromotedCategory=Process }
      { 1102755004;1 ;ActionGroup;
                      CaptionML=ENU=Approvals;
                      ActionContainerType=NewDocumentItems }
      { 1102755007;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=False;
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
                                 ApprovalEntries.Setfilters(DATABASE::"Loans Register",DocumentType,"Loan  No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755005;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Visible=False;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This transaction is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN

                                 SalDetails.RESET;
                                 SalDetails.SETRANGE(SalDetails."Loan No","Loan  No.");
                                 IF SalDetails.FIND('-')=FALSE THEN BEGIN
                                   ERROR('Please Insert Loan Applicant Salary details Information')
                                   END;

                                 IF "Loan Product Type" <> 'L05' THEN BEGIN
                                 LGuarantors.RESET;
                                 LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                 IF LGuarantors.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Guarantor Information');
                                 END;

                                 END;


                                  TESTFIELD("Requested Amount");
                                 //SMS MESSAGE

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
                                       SMSMessages."Account No":="Client Code";
                                       SMSMessages."Date Entered":=TODAY;
                                       SMSMessages."Time Entered":=TIME;
                                       SMSMessages.Source:='LOAN APPL';
                                       SMSMessages."Entered By":=USERID;
                                       SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
                                       SMSMessages."SMS Message":='Your loan application of KSHs.'+FORMAT("Requested Amount")+
                                                                 ' has been received. TELEPOST SACCO.';
                                       Cust.RESET;
                                       IF Cust.GET("Client Code") THEN
                                       SMSMessages."Telephone No":=Cust."Phone No.";
                                       SMSMessages.INSERT;


                                 LoanGuar.RESET;
                                 LoanGuar.SETRANGE(LoanGuar."Loan No","Loan  No.");
                                 IF LoanGuar.FIND('-') THEN BEGIN
                                 REPEAT

                                   Cust.RESET;
                                   Cust.SETRANGE(Cust."No.",LoanGuar."Member No");
                                   //Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                   IF Cust.FIND('-') THEN BEGIN

                                   //SMS MESSAGE

                                   SMSMessages.RESET;
                                   IF SMSMessages.FIND('+') THEN BEGIN
                                   iEntryNo:=SMSMessages."Entry No";
                                   iEntryNo:=iEntryNo+1;
                                   END
                                   ELSE BEGIN
                                   iEntryNo:=1;
                                   END;

                                   SMSMessages.INIT;
                                   SMSMessages."Entry No":=iEntryNo;
                                   SMSMessages."Account No":=LoanGuar."Member No";
                                   SMSMessages."Date Entered":=TODAY;
                                   SMSMessages."Time Entered":=TIME;
                                   SMSMessages.Source:='LOAN GUARANTORS';
                                   SMSMessages."Entered By":=USERID;
                                   SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
                                   //IF LoanApp.GET(LoanGuar."Loan No") THEN
                                   {SMSMessages."SMS Message":='You have guaranteed a loan of '+FORMAT(LoanGuar."Amont Guaranteed")
                                   +' to '+"Client Name"+' '+'Staff No:-'+"Staff No"+' '+
                                   'Loan Type '+"Loan Product Type"+' '+'of '+FORMAT("Requested Amount") +' at TELEPOST SACCO Ltd.'
                                   ;}

                                    SMSMessages."SMS Message":='You have guaranteed an amount of '+FORMAT(LoanGuar."Amont Guaranteed")+' to '+"Client Name"+' '+'Loan Type '+"Loan Product Type"+' at TELEPOST SACCO'
                                       +' '+'Please call '+compinfo."Phone No."+ 'if in dispute.';

                                   SMSMessages."Telephone No":=Cust."Phone No.";
                                   SMSMessages.INSERT;
                                 //MESSAGE('%1',Cust."Phone No.");
                                     END;
                                  UNTIL LoanGuar.NEXT=0;
                                   END;

                                 {   //SMS MESSAGE
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
                                       SMSMessages."Account No":="Account No";
                                       SMSMessages."Date Entered":=TODAY;
                                       SMSMessages."Time Entered":=TIME;
                                       SMSMessages.Source:='LOAN ISSUE';
                                       SMSMessages."Entered By":=USERID;
                                       SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
                                       //SMSMessages."Sent To Server":=SMSMessages."Sent To Server::No;
                                       SMSMessages."SMS Message":='Your loan application of KSHs.'+FORMAT("Approved Amount")+
                                                                 ' has been issued. HAZINA SACCO LTD';
                                       Cust.RESET;
                                       IF Cust.GET("Account No") THEN
                                       SMSMessages."Telephone No" := Cust."Phone No.";
                                       SMSMessages.INSERT;

                                 }
                                  {
                                 SalDetails.RESET;
                                 SalDetails.SETRANGE(SalDetails."Loan No","Loan  No.");
                                 IF SalDetails.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Salary Information');
                                 END;
                                    }
                                    {
                                 IF "Loan Product Type" <> 'SDV' THEN BEGIN
                                 LGuarantors.RESET;
                                 LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                 IF LGuarantors.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Guarantor Information');
                                 END;
                                 END;
                                 }
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
                                 IF "Loan Status"<>"Loan Status"::Application THEN
                                 ERROR(Text001);

                                 Doc_Type:=Doc_Type::Loan;
                                 Table_id:=DATABASE::"Loans Register";

                                 IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendLoanAppDocForApproval(Rec);

                                 {
                                 Doc_Type:=Doc_Type::Loan;
                                 Table_id:=DATABASE::"Loans Register";
                                 IF ApprovalMgt.SendApproval(Table_id,"Loan  No.",Doc_Type,"Loan Status")THEN;
                                 }
                                 {
                                 "Loan Status":="Loan Status"::Approved;
                                 "Approval Status":="Approval Status"::Approved;
                                 MODIFY;
                                 MESSAGE('APPROVED SUCCESFULLY');
                                 }
                                 //End allocate batch number
                                   {
                                    LGuarantors.RESET;
                                    LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                    IF LGuarantors.FINDFIRST THEN BEGIN
                                    REPEAT
                                    IF Cust.GET(LGuarantors."Member No") THEN
                                    IF  Cust."Mobile Phone No"<>'' THEN
                                    Sms.SendSms('Guarantors' ,Cust."Mobile Phone No",'You have guaranteed '+ "Client Name" + ' ' + "Loan Product Type" +' of KES. '+FORMAT("Approved Amount")+
                                    '. Call 0707428064 if in dispute. Sacco.',Cust."No.");
                                    UNTIL LGuarantors.NEXT =0;
                                    END
                                 }
                               END;
                                }
      { 1102755003;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Visible=False;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN

                                 IF "Loan Status"<>"Loan Status"::Appraisal THEN
                                 ERROR(Text002);

                                 IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelLoanAppApprovalRequest(Rec);
                               END;
                                }
      { 1000000010;2 ;Action    ;
                      Name=Reopen;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Calculate;
                      OnAction=BEGIN
                                 "Loan Status":="Loan Status"::Application;
                                 "Approval Status":="Approval Status"::Open;
                                 MODIFY
                                 //ApprovalsMgmt.OnCancelLoanAppApprovalRequest(Rec);
                               END;
                                }
      { 1000000024;2 ;Action    ;
                      Name=Return To Appraisal;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Confirm;
                      OnAction=BEGIN
                                 "Loan Status":="Loan Status"::Appraisal;
                                 "Approval Status":="Approval Status"::Open;
                                 "Appraised By":='';
                                 MODIFY

                                 {IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelLoanAppApprovalRequest(Rec);
                                 }
                               END;
                                }
      { 1000000052;2 ;Action    ;
                      Name=Reject Loan;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      OnAction=BEGIN
                                 TESTFIELD("Reason For Loan Rejection");
                                 "Loan Status":="Loan Status"::Rejected;
                                 "Approval Status":="Approval Status"::Rejected;
                                 MODIFY

                                 {IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelLoanAppApprovalRequest(Rec);
                                 }
                               END;
                                }
      { 1120054005;2 ;Action    ;
                      Name=Mark As Express Loan;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MakeOrder;
                      OnAction=BEGIN
                                 MarkLoanAsExpress;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=General;
                Editable=FALSE }

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

    { 1102755020;2;Field  ;
                SourceExpr="Member Deposits" }

    { 1000000003;2;Field  ;
                SourceExpr="Application Date";
                OnValidate=BEGIN
                              TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 4   ;2   ;Field     ;
                SourceExpr="Offset Loan" }

    { 1102755006;2;Field  ;
                SourceExpr="Loan Product Type";
                TableRelation="Loan Products Setup".Code WHERE (Source=FILTER(BOSA));
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

    { 1120054006;2;Field  ;
                SourceExpr="Loan Product Type Name" }

    { 1102755019;2;Field  ;
                Name=<Telephone No>;
                CaptionML=ENU=Telephone No;
                SourceExpr="Phone No.";
                Editable=TRUE }

    { 1102760011;2;Field  ;
                SourceExpr=Installments;
                Editable=InstallmentEditable;
                OnValidate=BEGIN
                             TESTFIELD(Posted,FALSE);
                           END;
                            }

    { 1102755002;2;Field  ;
                SourceExpr=Interest;
                Editable=false }

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

    { 1000000016;2;Field  ;
                CaptionML=ENU=Approved Amount;
                SourceExpr="Approved Amount";
                Editable=false;
                OnValidate=BEGIN
                             TESTFIELD(Posted,FALSE);
                           END;
                            }

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

    { 1000000012;2;Field  ;
                SourceExpr="Loan Principle Repayment";
                Editable=false }

    { 1000000013;2;Field  ;
                SourceExpr="Loan Interest Repayment";
                Editable=FALSE }

    { 1102760013;2;Field  ;
                SourceExpr=Repayment;
                Editable=false }

    { 1102755037;2;Field  ;
                SourceExpr="Approved Repayment";
                Visible=FALSE }

    { 1000000039;2;Field  ;
                SourceExpr="Loan Status";
                Editable=FALSE;
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

    { 1000000006;2;Field  ;
                SourceExpr="Approval Status" }

    { 1102755008;2;Field  ;
                SourceExpr="Captured By";
                Editable=FALSE }

    { 1102755010;2;Field  ;
                CaptionML=ENU=Bridged Amount;
                SourceExpr="Top Up Amount" }

    { 1000000007;2;Field  ;
                SourceExpr="Other Commitments Clearance" }

    { 1102755009;2;Field  ;
                SourceExpr="Repayment Frequency";
                Editable=RepayFrequencyEditable }

    { 1000000011;2;Field  ;
                SourceExpr="Recovery Mode" }

    { 1102760002;2;Field  ;
                SourceExpr="Mode of Disbursement";
                Editable=ModeofDisburesmentEdit }

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

    { 1120054000;2;Field  ;
                SourceExpr="Appraised By" }

    { 1102755013;2;Field  ;
                SourceExpr="External EFT";
                Visible=FALSE }

    { 1102755029;2;Field  ;
                SourceExpr="partially Bridged" }

    { 1000000033;2;Field  ;
                SourceExpr=Posted;
                Visible=FALSE;
                Editable=FALSE }

    { 1102755031;2;Field  ;
                SourceExpr="Total TopUp Commission" }

    { 1000000053;2;Field  ;
                SourceExpr="Reason For Loan Rejection" }

    { 1000000055;2;Field  ;
                SourceExpr="Emp Loan Codes" }

    { 1120054004;2;Field  ;
                SourceExpr="Express Loan" }

    { 1120054001;2;Field  ;
                SourceExpr=LoantypeCode;
                Editable=false }

    { 1120054003;1;Group  ;
                Name=Batching;
                Editable=TRUE;
                GroupType=Group }

    { 1000000036;2;Field  ;
                SourceExpr="Loan Disbursement Date";
                Editable=true }

    { 1102760004;2;Field  ;
                SourceExpr="Batch No." }

    { 1000000051;1;Group  ;
                CaptionML=ENU=Earnings;
                Editable=FALSE;
                GroupType=Group }

    { 1000000050;2;Field  ;
                CaptionML=ENU=Basic Pay;
                SourceExpr="Basic Pay H" }

    { 1000000049;2;Field  ;
                CaptionML=ENU=House Allowance;
                SourceExpr="House AllowanceH" }

    { 1000000048;2;Field  ;
                CaptionML=ENU=Medical Allowance;
                SourceExpr="Medical AllowanceH" }

    { 1000000047;2;Field  ;
                SourceExpr="Exempted from PAYE" }

    { 1000000046;2;Field  ;
                SourceExpr="Other Income" }

    { 1000000044;2;Field  ;
                Name=GrossPay;
                SourceExpr=GrossPay }

    { 1000000042;2;Field  ;
                CaptionML=ENU=Total Income;
                SourceExpr="Net Income" }

    { 1000000041;2;Field  ;
                Name=Nettakehome;
                SourceExpr=Nettakehome }

    { 1000000040;1;Group  ;
                CaptionML=ENU=Non-Taxable Deductions;
                Editable=FALSE;
                GroupType=Group }

    { 1000000038;2;Field  ;
                SourceExpr="Pension Scheme" }

    { 1000000037;2;Field  ;
                SourceExpr="Other Non-Taxable" }

    { 1000000035;2;Field  ;
                SourceExpr="Other Tax Relief" }

    { 1000000034;1;Group  ;
                CaptionML=ENU=Deductions;
                Editable=FALSE;
                GroupType=Group }

    { 1000000032;2;Field  ;
                SourceExpr="Monthly Contribution" }

    { 1000000031;2;Field  ;
                SourceExpr=NHIF }

    { 1000000030;2;Field  ;
                SourceExpr=NSSF }

    { 1000000029;2;Field  ;
                SourceExpr=PAYE }

    { 1000000027;2;Field  ;
                SourceExpr="Medical Insurance" }

    { 1000000026;2;Field  ;
                SourceExpr="Life Insurance" }

    { 1000000025;2;Field  ;
                SourceExpr="Other Liabilities" }

    { 1000000045;2;Field  ;
                Name=Loan Repayment;
                CaptionML=ENU=Loan Repayment;
                SourceExpr=Repayment }

    { 1000000023;2;Field  ;
                SourceExpr="Sacco Deductions" }

    { 1000000022;2;Field  ;
                CaptionML=ENU=Bank Loan Repayments;
                SourceExpr="Other Loans Repayments" }

    { 1000000021;2;Field  ;
                Name=TotalDeductions;
                CaptionML=ENU=Total Deductions;
                SourceExpr=TotalDeductions }

    { 1000000020;2;Field  ;
                Name=UtilizableAmount;
                SourceExpr="Utilizable Amount" }

    { 1000000018;2;Field  ;
                CaptionML=ENU=Cleared Loan Repayment;
                SourceExpr="Bridge Amount Release" }

    { 1000000017;2;Field  ;
                Name=NetUtilizable;
                CaptionML=ENU=Net Utilizable Amount;
                SourceExpr=NetUtilizable }

    { 1000000002;1;Part   ;
                CaptionML=ENU=Salary Details;
                SubPageLink=Loan No=FIELD(Loan  No.),
                            Client Code=FIELD(Client Code);
                PagePartID=Page51516246;
                Editable=FALSE;
                PartType=Page }

    { 1000000004;1;Part   ;
                CaptionML=ENU=Guarantors  Detail;
                SubPageLink=Loan No=FIELD(Loan  No.);
                PagePartID=Page51516585;
                Editable=False;
                PartType=Page }

    { 1000000005;1;Part   ;
                CaptionML=ENU=Other Securities;
                SubPageLink=Loan No=FIELD(Loan  No.);
                PagePartID=Page51516248;
                Editable=FALSE;
                PartType=Page }

    { 1000000009;0;Container;
                ContainerType=FactBoxArea }

    { 1000000008;1;Part   ;
                SubPageLink=No.=FIELD(Client Code);
                PagePartID=Page51516371;
                PartType=Page }

  }
  CODE
  {
    VAR
      LoanGuar@1000000055 : Record 51516231;
      SMSMessages@1000000054 : Record 51516329;
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
      GenSetUp@1000000035 : Record 51516257;
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
      LoanG@1102760027 : Record 51516231;
      SpecialComm@1102760028 : Decimal;
      FOSAName@1102760029 : Text[150];
      IDNo@1102760030 : Code[50];
      MovementTracker@1102760032 : Record 51516253;
      DiscountingAmount@1102760033 : Decimal;
      StatusPermissions@1102760034 : Record 51516310;
      BridgedLoans@1102760035 : Record 51516238;
      SMSMessage@1102756000 : Record 51516329;
      InstallNo2@1102755000 : Integer;
      currency@1102755001 : Record 330;
      CURRENCYFACTOR@1102755002 : Decimal;
      LoanApps@1102755003 : Record 51516230;
      LoanDisbAmount@1102755004 : Decimal;
      BatchTopUpAmount@1102755005 : Decimal;
      BatchTopUpComm@1102755006 : Decimal;
      Disbursement@1102755007 : Record 51516236;
      SchDate@1102755010 : Date;
      DisbDate@1102755009 : Date;
      WhichDay@1102755008 : Integer;
      LBatches@1102755012 : Record 51516230;
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
      AccountNoEditable@1102755031 : Boolean;
      LNBalance@1102755029 : Decimal;
      ApprovalEntries@1102755030 : Record 454;
      RejectionRemarkEditable@1102755032 : Boolean;
      ApprovalEntry@1102755034 : Record 454;
      Table_id@1002 : Integer;
      Doc_No@1001 : Code[20];
      Doc_Type@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening,Member Closure,Loan';
      ApprovalsMgmt@1000000000 : Codeunit 1535;
      compinfo@1000000031 : Record 79;
      iEntryNo@1000000052 : Integer;
      eMAIL@1000000053 : Text;
      "Telephone No"@1000000056 : Integer;
      Text002@1000000057 : TextConst 'ENU=Status must be Pending';
      GrossPay@1000000111 : Decimal;
      Nettakehome@1000000110 : Decimal;
      TotalDeductions@1000000109 : Decimal;
      UtilizableAmount@1000000108 : Decimal;
      NetUtilizable@1000000107 : Decimal;
      Deductions@1000000106 : Decimal;
      Benov@1000000105 : Decimal;
      TAXABLEPAY@1000000104 : Record 51516483;
      PAYE@1000000103 : Decimal;
      PAYESUM@1000000102 : Decimal;
      BAND1@1000000101 : Decimal;
      BAND2@1000000100 : Decimal;
      BAND3@1000000099 : Decimal;
      BAND4@1000000098 : Decimal;
      BAND5@1000000097 : Decimal;
      Taxrelief@1000000096 : Decimal;
      OTrelief@1000000095 : Decimal;
      Chargeable@1000000094 : Decimal;
      PartPay@1000000093 : Record 51516494;
      PartPayTotal@1000000092 : Decimal;
      AmountPayable@1000000091 : Decimal;
      RepaySched@1000000090 : Record 51516234;
      LoanReferee1NameEditable@1000000089 : Boolean;
      LoanReferee2NameEditable@1000000088 : Boolean;
      LoanReferee1MobileEditable@1000000087 : Boolean;
      LoanReferee2MobileEditable@1000000086 : Boolean;
      LoanReferee1AddressEditable@1000000085 : Boolean;
      LoanReferee2AddressEditable@1000000084 : Boolean;
      LoanReferee1PhyAddressEditable@1000000083 : Boolean;
      LoanReferee2PhyAddressEditable@1000000082 : Boolean;
      LoanReferee1RelationEditable@1000000081 : Boolean;
      LoanReferee2RelationEditable@1000000080 : Boolean;
      LoanPurposeEditable@1000000079 : Boolean;
      WitnessEditable@1000000078 : Boolean;
      CummulativeGuarantee@1000000076 : Decimal;
      LoansRec@1000000075 : Record 51516230;
      RecoveryModeEditable@1000000074 : Boolean;
      RemarksEditable@1000000073 : Boolean;
      CopyofIDEditable@1000000072 : Boolean;
      CopyofPayslipEditable@1000000071 : Boolean;
      ScheduleBal@1000000070 : Decimal;
      SFactory@1000000069 : Codeunit 51516022;
      Appraisal@1000000068 : Report 51516244;
      NetRealizable@1000000067 : Decimal;
      RefinanceEnabled@1000000066 : Boolean;
      prNSSF@1000000065 : Record 51516215;
      CalcNSSF@1000000064 : Decimal;
      prNHIF@1000000063 : Record 51516214;
      CalcNHIF@1000000062 : Decimal;
      ScaleContribution@1000000061 : Record 51516093;
      ContribTier@1000000060 : Record 51516093;
      CalcContrib@1000000059 : Decimal;
      TotalLoanOutstanding@1000000058 : Decimal;
      ObjLoasToOffset@1000000077 : Record 51516235;
      Register@1000000112 : Record 51516230;
      AuditTrail@1120054002 : Codeunit 51516107;
      Trail@1120054001 : Record 51516655;
      EntryNo@1120054000 : Integer;

    PROCEDURE UpdateControl@1102755000();
    BEGIN

      IF "Loan Status"="Loan Status"::Application THEN BEGIN
      MNoEditable:=TRUE;
      ApplcDateEditable:=FALSE;
      LoanStatusEditable:=TRUE;
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

    PROCEDURE SendSMS@1000000000();
    BEGIN


      GenSetUp.GET;
      compinfo.GET;


      IF GenSetUp."Send SMS Notifications"=TRUE THEN BEGIN


      //SMS MESSAGE
      SMSMessage.RESET;
      IF SMSMessage.FIND('+') THEN BEGIN
      iEntryNo:=SMSMessage."Entry No";
      iEntryNo:=iEntryNo+1;
      END
      ELSE BEGIN
      iEntryNo:=1;
      END;

      SMSMessage.INIT;
      SMSMessage."Entry No":=iEntryNo;
      SMSMessage."Batch No":="Batch No.";
      SMSMessage."Document No":="Loan  No.";
      SMSMessage."Account No":="Account No";
      SMSMessage."Date Entered":=TODAY;
      SMSMessage."Time Entered":=TIME;
      SMSMessage.Source:='LOANS';
      SMSMessage."Entered By":=USERID;
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      SMSMessage."SMS Message":='Your Loan of amount '+FORMAT("Requested Amount")+' for '+
      "Client Code"+' '+"Client Name"+' has been received and is being Processed '
      +compinfo.Name+' '+GenSetUp."Customer Care No";
      Cust.RESET;
      Cust.SETRANGE(Cust."No.","Client Code");
      IF Cust.FIND('-') THEN BEGIN
      SMSMessage."Telephone No":=Cust."Mobile Phone No";//Cust."Phone No.";
      END;
      SMSMessage.INSERT;

      END;
    END;

    PROCEDURE SendMail@1000000001();
    BEGIN
      GenSetUp.GET;

      IF Cust.GET(LoanApps."Client Code") THEN BEGIN
      eMAIL:=Cust."E-Mail (Personal)";
      END;

      IF GenSetUp."Send Email Notifications" = TRUE THEN BEGIN

      Notification.CreateMessage('Dynamics NAV',GenSetUp."Sender Address",eMAIL,'Loan Receipt Notification',
                      'Loan application '+ LoanApps."Loan  No." +' , ' +LoanApps."Loan Product Type"+' has been received and is being processed'
                     + ' (Dynamics NAV ERP)',TRUE,FALSE);

      Notification.Send;

      END;
    END;

    LOCAL PROCEDURE FnLoanProductHasBalance@1000000003() : Decimal;
    VAR
      TotalOutstandingBalance@1000000000 : Decimal;
    BEGIN
      LoanApp.RESET;
      LoanApp.SETRANGE(LoanApp."Loan  No.","Loan  No.");
      LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
      IF LoanApp.FIND('-') THEN BEGIN
        REPEAT
          LoanApp.CALCFIELDS(LoanApp."Outstanding Balance",LoanApp."Oustanding Interest");
          IF (LoanApp."Outstanding Balance">0) OR (LoanApp."Oustanding Interest">0) THEN
            TotalOutstandingBalance:=TotalOutstandingBalance+LoanApp."Outstanding Balance"+LoanApp."Oustanding Interest";
        UNTIL LoanApp.NEXT=0;
      END;
      EXIT(TotalOutstandingBalance);
    END;

    LOCAL PROCEDURE FnLoanProductTopupAmount@1000000004() : Decimal;
    VAR
      TotalOutstandingBalance@1000000000 : Decimal;
    BEGIN
      ObjLoasToOffset.RESET;
      ObjLoasToOffset.SETRANGE(ObjLoasToOffset."Loan Type","Loan Product Type");
      ObjLoasToOffset.SETRANGE(ObjLoasToOffset."Loan Top Up","Loan  No.");
      IF ObjLoasToOffset.FIND('-') THEN BEGIN
        REPEAT
         TotalOutstandingBalance:=TotalOutstandingBalance+ObjLoasToOffset."Principle Top Up"+ObjLoasToOffset."Interest Top Up";
        UNTIL ObjLoasToOffset.NEXT=0;
      END;
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
    END.
  }
}

