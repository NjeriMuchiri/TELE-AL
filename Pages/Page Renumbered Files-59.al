OBJECT page 20423 Loans Calculator
{
  OBJECT-PROPERTIES
  {
    Date=03/17/17;
    Time=[ 9:04:04 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516239;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1102755006;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755011;1 ;ActionGroup }
      { 1102755012;2 ;Action    ;
                      Name=View Schedule;
                      Promoted=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Report;
                      OnAction=BEGIN




                                 //IF Posted=TRUE THEN
                                 //ERROR('Loan has been posted, Can only preview schedule');


                                 InstallNo2:=3;
                                 QCounter:=0;
                                 QCounter:=3;
                                 EVALUATE(InPeriod,'1Q');
                                 GrPrinciple:="Grace Period - Principle (M)";
                                 GrInterest:="Grace Period - Interest (M)";
                                 InitialGraceInt:="Grace Period - Interest (M)";


                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Loan Product Type","Loan Product Type");
                                 IF LoansR.FIND('-') THEN BEGIN

                                 RSchedule.RESET;
                                 //RSchedule.SETRANGE(RSchedule."Loan Category","Loan Product Type");
                                 RSchedule.DELETEALL;


                                 LBalance:=LoansR."Requested Amount";
                                 LoanAmount:=LoansR."Requested Amount";
                                 InterestRate:="Interest rate";
                                 RepayPeriod:=Installments;
                                 RunDate:="Repayment Start Date";
                                 //InitialInstal:=LoansR.Installments;

                                 InstalNo:=0;
                                 EVALUATE(RepayInterval,'1M');
                                 REPEAT
                                 InstallNo2:=InstallNo2-1;
                                 InstalNo:=InstalNo+1;


                                 IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                 TESTFIELD("Interest rate");
                                 TESTFIELD(Installments);
                                 TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.05,'>');
                                 LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                 LPrincipal:=TotalMRepay-LInterest;
                                 END;

                                 IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
                                 TESTFIELD("Interest rate");
                                 TESTFIELD(Installments);
                                 LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                 LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
                                 //Grace Period Interest
                                 LInterest:=ROUND((LInterest*InitialInstal)/(InitialInstal-InitialGraceInt),0.05,'>');
                                 END;

                                 IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
                                 TESTFIELD("Interest rate");
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
                                 LInterest:="Interest rate";
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

                                 EVALUATE(RepayCode,FORMAT(InstalNo));



                                 RSchedule.INIT;
                                 RSchedule."Repayment Code":=RepayCode;
                                 RSchedule."Loan Amount":=LoanAmount;
                                 RSchedule."Instalment No":=InstalNo;
                                 //RSchedule."Member No.":="Member No.";
                                 //RSchedule."Loan No.":="Loan No.";
                                 RSchedule."Repayment Date":=CALCDATE('CM',RunDate);
                                 RSchedule."Loan Category":="Loan Product Type";
                                 RSchedule."Monthly Repayment":=LInterest + LPrincipal+"Administration Fee";
                                 RSchedule."Monthly Interest":=LInterest;
                                 //RSchedule."Administration Fee":="Administration Fee";
                                 RSchedule."Principal Repayment":=LPrincipal;
                                 RSchedule.INSERT;


                                 RunDate:=CALCDATE('1M',RunDate);

                                 UNTIL LBalance < 1;
                                 //UNTIL InstallNo2=0;

                                 END;

                                 COMMIT;

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Loan Product Type","Loan Product Type");
                                 IF LoansR.FIND('-') THEN
                                 REPORT.RUN(51516231,TRUE,FALSE,LoansR);


                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1102755007;2;Field  ;
                SourceExpr="Product Description" }

    { 1102755008;2;Field  ;
                SourceExpr="Interest rate";
                Editable=FALSE }

    { 1102755003;2;Field  ;
                SourceExpr=Installments }

    { 1102755015;2;Field  ;
                SourceExpr="Instalment Period";
                Editable=FALSE }

    { 1102755009;2;Field  ;
                SourceExpr="Repayment Method" }

    { 1102755010;2;Field  ;
                SourceExpr="Requested Amount" }

    { 1102755004;2;Field  ;
                SourceExpr="Principle Repayment";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Interest Repayment";
                Editable=FALSE }

    { 1102755014;2;Field  ;
                SourceExpr="Repayment Start Date" }

  }
  CODE
  {
    VAR
      i@1000000094 : Integer;
      LoanType@1000000093 : Record 51516240;
      PeriodDueDate@1000000092 : Date;
      ScheduleRep@1000000091 : Record 51516436;
      RunningDate@1000000090 : Date;
      G@1000000089 : Integer;
      IssuedDate@1000000088 : Date;
      GracePeiodEndDate@1000000087 : Date;
      InstalmentEnddate@1000000086 : Date;
      GracePerodDays@1000000085 : Integer;
      InstalmentDays@1000000084 : Integer;
      NoOfGracePeriod@1000000083 : Integer;
      NewSchedule@1000000082 : Record 51516436;
      RSchedule@1000000081 : Record 51516436;
      GP@1000000080 : Text[30];
      ScheduleCode@1000000079 : Code[20];
      PreviewShedule@1000000078 : Record 51516436;
      PeriodInterval@1000000077 : Code[10];
      CustomerRecord@1000000076 : Record 51516223;
      Gnljnline@1000000075 : Record 81;
      Jnlinepost@1000000074 : Codeunit 12;
      CumInterest@1000000073 : Decimal;
      NewPrincipal@1000000072 : Decimal;
      PeriodPrRepayment@1000000071 : Decimal;
      GenBatch@1000000070 : Record 232;
      LineNo@1000000069 : Integer;
      GnljnlineCopy@1000000068 : Record 81;
      NewLNApplicNo@1000000067 : Code[10];
      Cust@1000000066 : Record 51516223;
      LoanApp@1000000065 : Record 51516230;
      TestAmt@1000000064 : Decimal;
      CustRec@1000000063 : Record 51516223;
      CustPostingGroup@1000000062 : Record 92;
      GenSetUp@1000000061 : Record 311;
      PCharges@1000000060 : Record 51516242;
      TCharges@1000000059 : Decimal;
      LAppCharges@1000000058 : Record 51516244;
      LoansR@1000000057 : Record 51516239;
      LoanAmount@1000000056 : Decimal;
      InterestRate@1000000055 : Decimal;
      RepayPeriod@1000000054 : Integer;
      LBalance@1000000053 : Decimal;
      RunDate@1000000052 : Date;
      InstalNo@1000000051 : Decimal;
      RepayInterval@1000000050 : DateFormula;
      TotalMRepay@1000000049 : Decimal;
      LInterest@1000000048 : Decimal;
      LPrincipal@1000000047 : Decimal;
      RepayCode@1000000046 : Code[40];
      GrPrinciple@1000000045 : Integer;
      GrInterest@1000000044 : Integer;
      QPrinciple@1000000043 : Decimal;
      QCounter@1000000042 : Integer;
      InPeriod@1000000041 : DateFormula;
      InitialInstal@1000000040 : Integer;
      InitialGraceInt@1000000039 : Integer;
      GenJournalLine@1000000038 : Record 81;
      FOSAComm@1000000037 : Decimal;
      BOSAComm@1000000036 : Decimal;
      GLPosting@1000000035 : Codeunit 12;
      LoanTopUp@1000000034 : Record 51516235;
      Vend@1000000033 : Record 23;
      BOSAInt@1000000032 : Decimal;
      TopUpComm@1000000031 : Decimal;
      DActivity@1000000030 : Code[20];
      DBranch@1000000029 : Code[20];
      UsersID@1000000028 : Record 2000000120;
      TotalTopupComm@1000000027 : Decimal;
      Notification@1000000026 : Codeunit 397;
      CustE@1000000025 : Record 51516230;
      DocN@1000000024 : Text[50];
      DocM@1000000023 : Text[100];
      DNar@1000000022 : Text[250];
      DocF@1000000021 : Text[50];
      MailBody@1000000020 : Text[250];
      ccEmail@1000000019 : Text[250];
      LoanG@1000000018 : Record 51516231;
      SpecialComm@1000000017 : Decimal;
      FOSAName@1000000016 : Text[150];
      IDNo@1000000015 : Code[50];
      ApprovalUsers@1000000014 : Record 51516256;
      MovementTracker@1000000013 : Record 51516253;
      DiscountingAmount@1000000012 : Decimal;
      StatusPermissions@1000000011 : Record 51516310;
      BridgedLoans@1000000010 : Record 51516230;
      SMSMessage@1000000009 : Record 51516329;
      InstallNo2@1000000008 : Integer;
      currency@1000000007 : Record 330;
      CURRENCYFACTOR@1000000006 : Decimal;
      LoanApps@1000000005 : Record 51516230;
      LoanDisbAmount@1000000004 : Decimal;
      BatchTopUpAmount@1000000003 : Decimal;
      BatchTopUpComm@1000000002 : Decimal;
      Disbursement@1000000001 : Record 51516236;
      LoansCalc@1000000000 : Record 51516239;

    BEGIN
    END.
  }
}

