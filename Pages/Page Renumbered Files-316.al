OBJECT page 50007 Data Sheet Main
{
  OBJECT-PROPERTIES
  {
    Date=02/07/23;
    Time=[ 5:05:45 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516341;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       OutstandingBalnace:=0;
                       Outstandinginterest:=0;
                       LoanApp.RESET;
                       LoanApp.SETRANGE(LoanApp."Loan  No.","Remark/LoanNO");
                       LoanApp.SETAUTOCALCFIELDS(LoanApp."Oustanding Interest",LoanApp."Outstanding Balance");
                       IF LoanApp.FIND('-') THEN BEGIN
                         OutstandingBalnace:=LoanApp."Outstanding Balance";
                         Outstandinginterest:=LoanApp."Oustanding Interest";
                         END;
                     END;

    ActionList=ACTIONS
    {
      { 1000000044;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 1000000043;1 ;Action    ;
                      Name=Generate DataSHEET;
                      CaptionML=ENU=Generate Data SHEET;
                      RunObject=Report 51516012;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=process;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {

                                   SaccoCode:='1872';

                                   Dia.OPEN('Generatating Datasheet \'+
                                   'Now :#1#########################################');

                                   DataSheet.RESET;
                                   IF DataSheet.FIND('-') THEN BEGIN
                                      Dia.UPDATE(1,'Deleting Old Records');
                                     DataSheet.DELETEALL;
                                   END;

                                 //Insert Shares
                                 Cust.RESET;
                                 Cust.SETFILTER(Cust."Monthly Contribution",'>%1',0);
                                 IF Cust.FIND('-') THEN BEGIN
                                   REPEAT
                                   Dia.UPDATE(1,'Updating Monthly Contribution for '+Cust.Name);
                                   DataSheet.INIT;
                                   DataSheet."PF/Staff No":=Cust."Payroll/Staff No";
                                   DataSheet.Name:=Cust.Name;
                                   DataSheet."Amount ON":=Cust."Monthly Contribution";
                                   DataSheet."Approved Amount":=Cust."Monthly Contribution";
                                   DataSheet.Employer:=Cust."Employer Code";
                                   DataSheet.Date:=Cust."Variation Date Deposits";
                                   DataSheet."Type of Deduction":='Shares';
                                   IF Cust."Employer Code"='TELKOM' THEN BEGIN
                                   DataSheet."REF.":='377';
                                   END ELSE IF Cust."Employer Code"='POSTAL CORP' THEN BEGIN
                                   DataSheet."REF.":='77';
                                    END ELSE
                                    DataSheet."REF.":='377';
                                   DataSheet.INSERT;
                                 UNTIL Cust.NEXT=0;
                                  END;

                                 //End Shares

                                 //Insert Shares
                                 Cust.RESET;
                                 Cust.SETFILTER(Cust."Registration Date",'>%1',211016D);
                                 IF Cust.FIND('-') THEN BEGIN
                                   Cust.CALCFIELDS(Cust."Registration Fee Paid");
                                   IF  (Cust."Registration Fee Paid"=0) THEN
                                   REPEAT
                                   Dia.UPDATE(1,'Updating Registration Fee for '+Cust.Name);
                                   DataSheet.INIT;
                                   DataSheet."PF/Staff No":=Cust."Payroll/Staff No";
                                   DataSheet.Name:=Cust.Name;
                                   DataSheet."Amount ON":=500;
                                   DataSheet."Approved Amount":=500;
                                   DataSheet.Employer:=Cust."Employer Code";
                                   DataSheet."ID NO.":=Cust."ID No.";
                                   DataSheet."Type of Deduction":='MembershipFee';
                                   IF Cust."Employer Code"='TELKOM' THEN BEGIN
                                   DataSheet."REF.":='678';
                                   END ELSE IF Cust."Employer Code"='POSTAL CORP' THEN BEGIN
                                   DataSheet."REF.":='77';
                                    END ELSE
                                    DataSheet."REF.":='';
                                   DataSheet.INSERT;
                                 UNTIL Cust.NEXT=0;
                                  END;

                                 //End Shares

                                 //Insert EE Shares
                                 Cust.RESET;
                                 Cust.SETFILTER(Cust."Monthly Sch.Fees Cont.",'>%1',0);
                                 IF Cust.FIND('-') THEN BEGIN
                                   REPEAT
                                   Dia.UPDATE(1,'Updating School Fees for '+Cust.Name);
                                   DataSheet.INIT;
                                   DataSheet."PF/Staff No":=Cust."Payroll/Staff No";
                                   DataSheet.Name:=Cust.Name;
                                   DataSheet."Amount ON":=Cust."Monthly Sch.Fees Cont.";
                                   DataSheet."Approved Amount":=Cust."Monthly Sch.Fees Cont.";
                                   DataSheet.Employer:=Cust."Employer Code";
                                   DataSheet.Date:=Cust."Variation Date ESS";
                                   DataSheet."Type of Deduction":='ESSSHARES';
                                   IF Cust."Employer Code"='TELKOM' THEN BEGIN
                                   DataSheet."REF.":='38J';
                                   END ELSE IF Cust."Employer Code"='POSTAL CORP' THEN BEGIN
                                    DataSheet."REF.":='7J';
                                    END ELSE
                                    DataSheet."REF.":='';
                                   DataSheet.INSERT;
                                 UNTIL Cust.NEXT=0;
                                  END;

                                 IssuedDatetel:=191016D;
                                 loansAppz.RESET;
                                 loansAppz.SETRANGE(loansAppz."Loan Status",loansAppz."Loan Status"::Issued);
                                 loansAppz.SETRANGE(loansAppz."Recovery Mode",loansAppz."Recovery Mode"::Checkoff);
                                 loansAppz.SETRANGE(loansAppz.Posted,TRUE);
                                 loansAppz.SETFILTER(loansAppz."Issued Date",'>%1',IssuedDatetel);
                                 loansAppz.SETFILTER(loansAppz."Approved Amount",'>%1',0);
                                 IF loansAppz.FIND('-') THEN BEGIN
                                  REPEAT

                                 loansAppz.CALCFIELDS(loansAppz."Outstanding Balance");
                                 IF (loansAppz."Outstanding Balance">0) THEN BEGIN
                                  Dia.UPDATE(1,'Updating Loan for '+loansAppz."Client Name");


                                 DataSheet.INIT;
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",loansAppz."Client Code");
                                 IF Cust.FIND('-') THEN BEGIN
                                 DataSheet."PF/Staff No":=Cust."Payroll/Staff No";
                                 DataSheet.Name:=loansAppz."Client Name";
                                  END;

                                 LoanTypes.RESET;
                                 LoanTypes.SETRANGE(LoanTypes.Code,loansAppz."Loan Product Type");
                                 IF LoanTypes.FIND('-') THEN BEGIN
                                 DataSheet."Type of Deduction":=LoanTypes."Product Description";
                                 END;
                                 DataSheet."Remark/LoanNO":=loansAppz."Loan  No.";
                                 DataSheet."Approved Amount":=loansAppz."Approved Amount";

                                 DataSheet."ID NO.":=Cust."ID No.";
                                  IF Cust."Employer Code"='TELKOM' THEN BEGIN
                                      IF loansAppz.Source=loansAppz.Source::BOSA THEN BEGIN
                                       DataSheet."Amount ON":=loansAppz."Approved Amount";
                                       END;
                                       IF  loansAppz.Source=loansAppz.Source::FOSA THEN BEGIN
                                        DataSheet."Amount ON":=loansAppz."Approved Amount"+FnGetInt(loansAppz."Loan  No.",loansAppz."Client Code");
                                      END;

                                 END ELSE IF Cust."Employer Code"='POSTAL CORP' THEN BEGIN
                                       DataSheet."Amount ON":=loansAppz."Approved Amount"+FnGetInt(loansAppz."Loan  No.",loansAppz."Client Code");
                                       DataSheet."Pck Principle Amount":= ROUND(DataSheet."Amount ON"/loansAppz.Installments,0.01,'>');
                                 END;

                                 //DataSheet."Amount OFF":=xRec.Repayment;


                                 DataSheet."REF.":='2026';
                                 DataSheet."New Balance":=loansAppz."Outstanding Balance";
                                 DataSheet.Date:=loansAppz."Issued Date";
                                 DataSheet.Employer:=loansAppz."Employer Code";
                                 DataSheet.Installments:=FORMAT(loansAppz.Installments);
                                 DataSheet.Ceased:=loansAppz.Bridged;
                                 DataSheet."Principal Amount":=loansAppz.Repayment;
                                 DataSheet."Transaction Type":=DataSheet."Transaction Type"::"FRESH FEED";
                                 //DataSheet."Sort Code":=PTEN;
                                 DataSheet.INSERT(TRUE);
                                 END;

                                 //Insert Loans Offset
                                 IF (loansAppz.Posted=TRUE)  AND (loansAppz."Outstanding Balance">0) THEN BEGIN
                                 LoansOffset.RESET;
                                 LoansOffset.SETRANGE(LoansOffset."Loan No.",loansAppz."Loan  No.");

                                 IF LoansOffset.FIND('-') THEN BEGIN
                                 REPEAT
                                  Dia.UPDATE(1,'Updating Loan offset for '+loansAppz."Client Name");
                                 DataSheet.INIT;
                                 DataSheet."REF.":='2026';
                                 DataSheet."Remark/LoanNO":=LoansOffset."Loan Top Up";
                                 DataSheet."PF/Staff No":=Cust."Payroll/Staff No";
                                 DataSheet.Name:=Cust.Name;
                                 IF loansAppz."Employer Code"='TELKOM' THEN BEGIN
                                 DataSheet."Amount ON":=LoansOffset."Principle Top Up"
                                 END ELSE IF loansAppz."Employer Code"='POSTAL CORP' THEN BEGIN
                                 DataSheet."Amount ON":=0;
                                 DataSheet."Amount OFF":=LoansOffset."Principle Top Up";
                                 END;
                                 DataSheet."New Balance":=0;
                                 DataSheet.Installments:='0';
                                 DataSheet.Date:=loansAppz."Issued Date";
                                 DataSheet.Employer:=loansAppz."Employer Code";
                                 DataSheet."Principal Amount":=0;
                                 DataSheet."Type of Deduction":=LoansOffset."Loan Type";
                                 DataSheet."Transaction Type":=DataSheet."Transaction Type"::STOPPAGE;
                                 DataSheet.Ceased:=TRUE;
                                 DataSheet.INSERT(TRUE);
                                 UNTIL LoansOffset.NEXT=0;
                                 END;
                                 END;
                                 //Insert Loans Offset
                                 UNTIL loansAppz.NEXT=0;
                                 END;
                                 Dia.CLOSE;

                                 MESSAGE('Data Sheet Generated Successfully');
                                 }
                               END;
                                }
      { 1000000045;1 ;Action    ;
                      CaptionML=ENU=Validate Data Sheet;
                      RunObject=Report 51516483;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=[process ];
                      PromotedCategory=Process }
      { 1000000039;1 ;Action    ;
                      CaptionML=ENU=Advise Codes;
                      RunObject=page 50097;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ImportCodes;
                      PromotedCategory=Process }
      { 1000000040;1 ;Action    ;
                      Name=DatasheetRepoot;
                      CaptionML=ENU=DATASHEET REPORT;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AnalysisView;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUN(50014);
                                 {
                                 Options := Text000;
                                 // Sets the default to option 3
                                 Selected := DIALOG.STRMENU(Options, 1, Text002);
                                         IF (Selected=1) THEN BEGIN
                                              ERROR('Please Choose Employer');

                                         END ELSE IF (Selected=2) THEN BEGIN

                                                   DatasheetMain.RESET;
                                                   DatasheetMain.SETRANGE(DatasheetMain.Employer,'TELKOM');
                                                   IF DatasheetMain.FIND('-') THEN BEGIN
                                                      REPORT.RUN(51516294,TRUE,FALSE);
                                                   END;
                                          END ELSE IF (Selected=3) THEN BEGIN
                                                   DatasheetMain.RESET;
                                                   DatasheetMain.SETRANGE(DatasheetMain.Employer,'POSTAL CORP');
                                                   IF DatasheetMain.FIND('-') THEN BEGIN
                                                      REPORT.RUN(51516315,TRUE,FALSE);
                                                   END;

                                          END ELSE  IF (Selected=4) THEN BEGIN

                                          END;
                                          }
                               END;
                                }
      { 1120054001;1 ;Action    ;
                      Name=Advice Updates;
                      RunObject=page 20440;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Action;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="PF/Staff No" }

    { 1000000003;2;Field  ;
                SourceExpr=Name;
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr="ID NO.";
                Editable=FALSE }

    { 1000000005;2;Field  ;
                SourceExpr="Type of Deduction" }

    { 1000000006;2;Field  ;
                SourceExpr="Amount ON" }

    { 1000000007;2;Field  ;
                SourceExpr="Amount OFF";
                Visible=FALSE }

    { 1000000008;2;Field  ;
                SourceExpr="New Balance" }

    { 1000000009;2;Field  ;
                SourceExpr="REF." }

    { 1000000010;2;Field  ;
                SourceExpr="Remark/LoanNO" }

    { 1000000011;2;Field  ;
                SourceExpr="Sort Code" }

    { 1000000012;2;Field  ;
                SourceExpr=Employer }

    { 1000000013;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1000000014;2;Field  ;
                SourceExpr=Date }

    { 1000000015;2;Field  ;
                Name=Payroll Month;
                SourceExpr=FORMAT(Date,0,'<Month Text> <Year4>') }

    { 1000000016;2;Field  ;
                SourceExpr="Interest Amount";
                Visible=FALSE }

    { 1000000017;2;Field  ;
                SourceExpr="Approved Amount" }

    { 1000000018;2;Field  ;
                SourceExpr="Uploaded Interest";
                Visible=FALSE }

    { 1000000019;2;Field  ;
                SourceExpr="Batch No.";
                Visible=FALSE }

    { 1000000020;2;Field  ;
                SourceExpr="Principal Amount";
                Visible=FALSE }

    { 1000000021;2;Field  ;
                SourceExpr=UploadInt;
                Visible=FALSE }

    { 1000000022;2;Field  ;
                SourceExpr=Source }

    { 1000000023;2;Field  ;
                SourceExpr=Code;
                Visible=FALSE }

    { 1000000024;2;Field  ;
                SourceExpr="Shares OFF";
                Visible=FALSE }

    { 1000000025;2;Field  ;
                SourceExpr="Adjustment Type";
                Visible=FALSE }

    { 1000000026;2;Field  ;
                SourceExpr=Period;
                Visible=FALSE }

    { 1000000027;2;Field  ;
                SourceExpr="aMOUNT ON 1";
                Visible=FALSE }

    { 1000000028;2;Field  ;
                SourceExpr="Vote Code";
                Visible=FALSE }

    { 1000000029;2;Field  ;
                SourceExpr=EDCode;
                Visible=FALSE }

    { 1000000030;2;Field  ;
                SourceExpr="Current Balance";
                Visible=FALSE }

    { 1000000031;2;Field  ;
                SourceExpr=TranType;
                Visible=FALSE }

    { 1000000032;2;Field  ;
                SourceExpr=TranName;
                Visible=FALSE }

    { 1000000033;2;Field  ;
                SourceExpr=Action;
                Visible=FALSE }

    { 1000000034;2;Field  ;
                SourceExpr="Interest Fee";
                Visible=FALSE }

    { 1000000035;2;Field  ;
                SourceExpr=Recoveries;
                Visible=FALSE }

    { 1000000036;2;Field  ;
                SourceExpr="Date Filter";
                Visible=FALSE }

    { 1000000037;2;Field  ;
                SourceExpr="Interest Off";
                Visible=FALSE }

    { 1000000038;2;Field  ;
                SourceExpr="Repayment Method";
                Visible=FALSE }

    { 1000000041;2;Field  ;
                Name=SaccoCode;
                SourceExpr=SaccoCode;
                Visible=FALSE }

    { 1000000042;2;Field  ;
                SourceExpr="Emp Loan Code";
                Visible=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Advice Option" }

    { 1120054003;2;Field  ;
                CaptionML=ENU=Outstanding Balance;
                SourceExpr=OutstandingBalnace }

    { 1120054002;2;Field  ;
                Name=Outstandinginterest;
                CaptionML=ENU=Outstanding Interest;
                SourceExpr=Outstandinginterest }

  }
  CODE
  {
    VAR
      LoanType@1000000097 : Record 51516240;
      i@1000000096 : Integer;
      OutstandingBalnace@1120054001 : Decimal;
      Outstandinginterest@1120054002 : Decimal;
      PeriodDueDate@1000000095 : Date;
      ScheduleRep@1000000094 : Record 51516234;
      RunningDate@1000000093 : Date;
      G@1000000092 : Integer;
      IssuedDate@1000000091 : Date;
      GracePeiodEndDate@1000000090 : Date;
      InstalmentEnddate@1000000089 : Date;
      GracePerodDays@1000000088 : Integer;
      InstalmentDays@1000000087 : Integer;
      NoOfGracePeriod@1000000086 : Integer;
      NewSchedule@1000000085 : Record 51516234;
      RSchedule@1000000084 : Record 51516234;
      GP@1000000083 : Text[30];
      ScheduleCode@1000000082 : Code[20];
      PreviewShedule@1000000081 : Record 51516234;
      PeriodInterval@1000000080 : Code[10];
      CustomerRecord@1000000079 : Record 51516223;
      Gnljnline@1000000078 : Record 81;
      Jnlinepost@1000000077 : Codeunit 12;
      CumInterest@1000000076 : Decimal;
      NewPrincipal@1000000075 : Decimal;
      PeriodPrRepayment@1000000074 : Decimal;
      GenBatch@1000000073 : Record 232;
      LineNo@1000000072 : Integer;
      GnljnlineCopy@1000000071 : Record 81;
      NewLNApplicNo@1000000070 : Code[10];
      Cust@1000000069 : Record 51516223;
      LoanApp@1000000068 : Record 51516230;
      TestAmt@1000000067 : Decimal;
      CustRec@1000000066 : Record 51516223;
      CustPostingGroup@1000000065 : Record 92;
      GenSetUp@1000000064 : Record 311;
      PCharges@1000000063 : Record 51516242;
      TCharges@1000000062 : Decimal;
      LAppCharges@1000000061 : Record 51516244;
      LoansR@1000000060 : Record 51516230;
      LoanAmount@1000000059 : Decimal;
      InterestRate@1000000058 : Decimal;
      RepayPeriod@1000000057 : Integer;
      LBalance@1000000056 : Decimal;
      RunDate@1000000055 : Date;
      InstalNo@1000000054 : Decimal;
      RepayInterval@1000000053 : DateFormula;
      TotalMRepay@1000000052 : Decimal;
      LInterest@1000000051 : Decimal;
      LPrincipal@1000000050 : Decimal;
      RepayCode@1000000049 : Code[40];
      GrPrinciple@1000000048 : Integer;
      GrInterest@1000000047 : Integer;
      QPrinciple@1000000046 : Decimal;
      QCounter@1000000045 : Integer;
      InPeriod@1000000044 : DateFormula;
      InitialInstal@1000000043 : Integer;
      InitialGraceInt@1000000042 : Integer;
      GenJournalLine@1000000041 : Record 81;
      FOSAComm@1000000040 : Decimal;
      BOSAComm@1000000039 : Decimal;
      GLPosting@1000000038 : Codeunit 12;
      LoanTopUp@1000000037 : Record 51516235;
      Vend@1000000036 : Record 23;
      BOSAInt@1000000035 : Decimal;
      TopUpComm@1000000034 : Decimal;
      DActivity@1000000033 : Code[20];
      DBranch@1000000032 : Code[20];
      UsersID@1000000031 : Record 2000000120;
      TotalTopupComm@1000000030 : Decimal;
      Notification@1000000029 : Codeunit 397;
      CustE@1000000028 : Record 51516223;
      DocN@1000000027 : Text[50];
      DocM@1000000026 : Text[100];
      DNar@1000000025 : Text[250];
      DocF@1000000024 : Text[50];
      MailBody@1000000023 : Text[250];
      ccEmail@1000000022 : Text[250];
      LoanG@1000000021 : Record 51516231;
      SpecialComm@1000000020 : Decimal;
      FOSAName@1000000019 : Text[150];
      IDNo@1000000018 : Code[50];
      ApprovalUsers@1000000017 : Record 51516256;
      MovementTracker@1000000016 : Record 51516253;
      DiscountingAmount@1000000015 : Decimal;
      StatusPermissions@1000000014 : Record 51516310;
      BridgedLoans@1000000013 : Record 51516276;
      SMSMessage@1000000012 : Record 51516223;
      InstallNo2@1000000011 : Integer;
      currency@1000000010 : Record 330;
      CURRENCYFACTOR@1000000009 : Decimal;
      LoanApps@1000000008 : Record 51516230;
      LoanDisbAmount@1000000007 : Decimal;
      BatchTopUpAmount@1000000006 : Decimal;
      BatchTopUpComm@1000000005 : Decimal;
      Disbursement@1000000004 : Record 51516236;
      Vendor@1000000003 : Record 23;
      LoanTypes@1000000002 : Record 51516240;
      DataSheet@1000000001 : Record 51516341;
      IssuedDatetel@1000000000 : Date;
      loansAppz@1000000098 : Record 51516230;
      DatasheetMain@1000000099 : Record 51516341;
      Text000@1000000100 : TextConst 'ENU=,TELKOM,POSTAL CORP,MULTIMEDIA';
      Text001@1000000101 : TextConst 'ENU=You selected option%1.';
      Text002@1000000102 : TextConst 'ENU=Choose one of the following options:';
      Options@1000000103 : Code[50];
      Selected@1000000104 : Integer;
      LoansOffset@1000000105 : Record 51516235;
      SaccoCode@1000000106 : Code[10];
      Dia@1120054000 : Dialog;

    LOCAL PROCEDURE FnGetInt@1000000002(LoanNumber@1000000000 : Code[50];CustNumber@1000000007 : Code[50]) InterestAmount : Decimal;
    VAR
      LoansReg@1000000001 : Record 51516230;
      Installment@1000000002 : Integer;
      NewApprovedAmount@1000000003 : Decimal;
      Count@1000000004 : Integer;
      Interest@1000000005 : Decimal;
      TotalInterest@1000000006 : Decimal;
    BEGIN
      Count:=0;
      LoansReg.RESET;
      LoansReg.SETRANGE(LoansReg."Loan  No.",LoanNumber);
      //LoansReg.SETRANGE(LoansReg."Client Code",CustNumber);
      IF LoansReg.FIND('-') THEN BEGIN
        Installment:=LoansReg.Installments;
          //REPEAT
          WHILE (Count<Installment) DO BEGIN
            Interest:=(LoansReg."Approved Amount"-(LoansReg."Loan Principle Repayment"*Count))*(LoansReg.Interest/1200);
            TotalInterest:=TotalInterest+ Interest;
          //UNTIL Count=Installment;
          Count:=Count+1;
          END;
            InterestAmount:=ROUND(TotalInterest,1,'>');
      END;
      EXIT(InterestAmount);
    END;

    LOCAL PROCEDURE GetContributionDeductionAmount@1120054001(TransactionType@1120054001 : Option;ProductCode@1120054002 : Code[20]) : Decimal;
    VAR
      AdvProduct@1120054000 : Record 51516019;
    BEGIN
      AdvProduct.RESET;
    END;

    BEGIN
    END.
  }
}

