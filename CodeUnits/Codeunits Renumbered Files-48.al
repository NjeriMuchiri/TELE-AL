OBJECT CodeUnit 20412 Generate Schedule
{
  OBJECT-PROPERTIES
  {
    Date=07/12/23;
    Time=[ 9:46:32 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnRun=VAR
            code@1120054000 : Code[10];
            Mkopo@1120054001 : Record 51516230;
          BEGIN
            {code:='LN008091';
            //Autogenerateschedule(cd);
            Mkopo.GET(code);
            MESSAGE(FORMAT(Mkopo.GetRepaymentStartDate));
            MESSAGE('Done');
            MESSAGE(FORMAT(CALCDATE('1D',CALCDATE('-CM',TODAY))));}
          END;

  }
  CODE
  {
    VAR
      i@1120054118 : Integer;
      LoanType@1120054117 : Record 51516240;
      PeriodDueDate@1120054116 : Date;
      ScheduleRep@1120054115 : Record 51516234;
      RunningDate@1120054114 : Date;
      G@1120054113 : Integer;
      IssuedDate@1120054112 : Date;
      GracePeiodEndDate@1120054111 : Date;
      InstalmentEnddate@1120054110 : Date;
      GracePerodDays@1120054109 : Integer;
      InstalmentDays@1120054108 : Integer;
      NoOfGracePeriod@1120054107 : Integer;
      NewSchedule@1120054106 : Record 51516234;
      RSchedule@1120054105 : Record 51516234;
      GP@1120054104 : Text[30];
      ScheduleCode@1120054103 : Code[20];
      PreviewShedule@1120054102 : Record 51516234;
      PeriodInterval@1120054101 : Code[10];
      CustomerRecord@1120054100 : Record 51516223;
      Gnljnline@1120054099 : Record 81;
      Jnlinepost@1120054098 : Codeunit 12;
      CumInterest@1120054097 : Decimal;
      NewPrincipal@1120054096 : Decimal;
      PeriodPrRepayment@1120054095 : Decimal;
      GenBatch@1120054094 : Record 232;
      LineNo@1120054093 : Integer;
      GnljnlineCopy@1120054092 : Record 81;
      NewLNApplicNo@1120054091 : Code[10];
      Cust@1120054090 : Record 51516223;
      LoanApp@1120054089 : Record 51516230;
      TestAmt@1120054088 : Decimal;
      CustRec@1120054087 : Record 51516223;
      CustPostingGroup@1120054086 : Record 92;
      GenSetUp@1120054085 : Record 311;
      PCharges@1120054084 : Record 51516242;
      TCharges@1120054083 : Decimal;
      LAppCharges@1120054082 : Record 51516244;
      LoansR@1120054081 : Record 51516230;
      LoanAmount@1120054080 : Decimal;
      InterestRate@1120054079 : Decimal;
      RepayPeriod@1120054078 : Integer;
      LBalance@1120054077 : Decimal;
      RunDate@1120054076 : Date;
      InstalNo@1120054075 : Decimal;
      RepayInterval@1120054074 : DateFormula;
      TotalMRepay@1120054073 : Decimal;
      LInterest@1120054072 : Decimal;
      LPrincipal@1120054071 : Decimal;
      RepayCode@1120054070 : Code[40];
      GrPrinciple@1120054069 : Integer;
      GrInterest@1120054068 : Integer;
      QPrinciple@1120054067 : Decimal;
      QCounter@1120054066 : Integer;
      InPeriod@1120054065 : DateFormula;
      InitialInstal@1120054064 : Integer;
      InitialGraceInt@1120054063 : Integer;
      GenJournalLine@1120054062 : Record 81;
      FOSAComm@1120054061 : Decimal;
      BOSAComm@1120054060 : Decimal;
      GLPosting@1120054059 : Codeunit 12;
      LoanTopUp@1120054058 : Record 51516235;
      Vend@1120054057 : Record 23;
      BOSAInt@1120054056 : Decimal;
      TopUpComm@1120054055 : Decimal;
      DActivity@1120054054 : Code[20];
      DBranch@1120054053 : Code[20];
      TotalTopupComm@1120054052 : Decimal;
      Notification@1120054051 : Codeunit 397;
      CustE@1120054050 : Record 51516223;
      DocN@1120054049 : Text[50];
      DocM@1120054048 : Text[100];
      DNar@1120054047 : Text[250];
      DocF@1120054046 : Text[50];
      MailBody@1120054045 : Text[250];
      ccEmail@1120054044 : Text[250];
      LoanG@1120054043 : Record 51516231;
      SpecialComm@1120054042 : Decimal;
      FOSAName@1120054041 : Text[150];
      IDNo@1120054040 : Code[50];
      MovementTracker@1120054039 : Record 51516253;
      DiscountingAmount@1120054038 : Decimal;
      StatusPermissions@1120054037 : Record 51516310;
      BridgedLoans@1120054036 : Record 51516238;
      SMSMessage@1120054035 : Record 51516223;
      InstallNo2@1120054034 : Integer;
      currency@1120054033 : Record 330;
      CURRENCYFACTOR@1120054032 : Decimal;
      LoanApps@1120054031 : Record 51516230;
      LoanDisbAmount@1120054030 : Decimal;
      BatchTopUpAmount@1120054029 : Decimal;
      BatchTopUpComm@1120054028 : Decimal;
      Disbursement@1120054027 : Record 51516236;
      SchDate@1120054026 : Date;
      DisbDate@1120054025 : Date;
      WhichDay@1120054024 : Integer;
      LBatches@1120054023 : Record 51516230;
      SalDetails@1120054022 : Record 51516232;
      LGuarantors@1120054021 : Record 51516231;
      DocumentType@1120054020 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      CurrpageEditable@1120054019 : Boolean;
      LoanStatusEditable@1120054018 : Boolean;
      MNoEditable@1120054017 : Boolean;
      ApplcDateEditable@1120054016 : Boolean;
      LProdTypeEditable@1120054015 : Boolean;
      InstallmentEditable@1120054014 : Boolean;
      AppliedAmountEditable@1120054013 : Boolean;
      ApprovedAmountEditable@1120054012 : Boolean;
      RepayMethodEditable@1120054011 : Boolean;
      RepaymentEditable@1120054010 : Boolean;
      BatchNoEditable@1120054009 : Boolean;
      RepayFrequencyEditable@1120054008 : Boolean;
      ModeofDisburesmentEdit@1120054007 : Boolean;
      DisbursementDateEditable@1120054006 : Boolean;
      AccountNoEditable@1120054005 : Boolean;
      LNBalance@1120054004 : Decimal;
      ApprovalEntries@1120054003 : Record 454;
      RejectionRemarkEditable@1120054002 : Boolean;
      ApprovalEntry@1120054001 : Record 454;
      Overdue@1120054000 : 'Yes, ';
      LoansRegister@1120054119 : Record 51516230;
      LN@1120054120 : Code[10];
      RScheduleB@1120054121 : Record 51516919;
      RDate@1120054122 : Date;

    PROCEDURE Autogenerateschedule@1120054001(VAR LOANNO@1120054000 : Code[100]);
    VAR
      LoanProductsSetup@1120054001 : Record 51516240;
      Mkopo@1120054002 : Record 51516230;
    BEGIN
      IF LoansRegister.GET(LOANNO) THEN BEGIN
      WITH LoansRegister DO BEGIN
          IF LoansRegister.Interest=0 THEN EXIT;

          IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
          EVALUATE(InPeriod,'1D')
          ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
          EVALUATE(InPeriod,'1W')
          ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
          EVALUATE(InPeriod,'1M')
          ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
          EVALUATE(InPeriod,'1Q');
          //MESSAGE(FORMAT("Repayment Start Date"));
          LoanProductsSetup.GET("Loan Product Type");

          Mkopo.GET(LOANNO);
          IF Mkopo."Issued Date"<>0D THEN
          IF Mkopo."Issued Date"<>Mkopo."Loan Disbursement Date" THEN BEGIN
              Mkopo."Loan Disbursement Date":=Mkopo."Issued Date";
              Mkopo."Repayment Start Date":=CALCDATE('CM',Mkopo."Issued Date");
              IF (Mkopo."Loan Product Type" = 'A01') OR (Mkopo."Loan Product Type" = 'A03') THEN
                Mkopo."Repayment Start Date" := Mkopo."Loan Disbursement Date";
              Mkopo.MODIFY;
           END;
         // MESSAGE(FORMAT("Repayment Start Date"));
          QCounter:=0;
          QCounter:=3;
          //EVALUATE(InPeriod,'1D');
          GrPrinciple:="Grace Period - Principle (M)";
          GrInterest:="Grace Period - Interest (M)";
          InitialGraceInt:="Grace Period - Interest (M)";

          LoansR.RESET;
          LoansR.SETRANGE(LoansR."Loan  No.","Loan  No.");
          IF LoansR.FIND('-') THEN BEGIN
            RDate:=LoansR."Repayment Start Date";
            TESTFIELD("Loan Disbursement Date");
            IF (LoansR."Loan Product Type" = 'A03') OR (LoansR."Loan Product Type" = 'A01') THEN BEGIN
              LoansR."Repayment Start Date" := LoansR."Loan Disbursement Date";
              LoansR."Expected Date of Completion" :=  CALCDATE(FORMAT(Installments)+'M',"Loan Disbursement Date");

            END ELSE BEGIN
              IF "Repayment Start Date"<>GetRepaymentStartDate THEN BEGIN
                "Repayment Start Date":=GetRepaymentStartDate;
                LoansR."Repayment Start Date":=GetRepaymentStartDate;
                IF Installments>0 THEN
                  LoansR."Expected Date of Completion":=CALCDATE(FORMAT(Installments)+'M',"Repayment Start Date");
              END;
            END;
          //MESSAGE(FORMAT("Repayment Start Date"));
          //LoansR.MODIFY;
         { IF "Repayment Start Date"=0D THEN BEGIN
             "Repayment Start Date":=CALCDATE('1M',"Loan Disbursement Date");

              IF DATE2DMY("Loan Disbursement Date",1) <=15 THEN
                 "Repayment Start Date":=CALCDATE('CM',"Loan Disbursement Date")
                ELSE
                  "Repayment Start Date":=CALCDATE('1M+CM',"Loan Disbursement Date");
            END;}
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
        // MESSAGE(FORMAT(RunDate));
          IF ("Loan Product Type" = 'A03') OR ("Loan Product Type" = 'A01') THEN
            RunDate :=  "Loan Disbursement Date";
          //MESSAGE(FORMAT(RunDate));
          //RunDate:=CALCDATE('-1W',RunDate);
          InstalNo:=0;
          //EVALUATE(RepayInterval,'1W');
          //EVALUATE(RepayInterval,InPeriod);

          //Repayment Frequency
      //     IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
      //     RunDate:=CALCDATE('-1D',RunDate)
      //     ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
      //     RunDate:=CALCDATE('-1W',RunDate)
      //     ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
      //     RunDate:=CALCDATE('-1M',RunDate)
      //     ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
      //     RunDate:=CALCDATE('-1Q',RunDate);
          //Repayment Frequency
          //MESSAGE(FORMAT(RunDate));
          // MESSAGE('Start%1',RunDate);
          REPEAT
          InstalNo:=InstalNo+1;
          //RunDate:=CALCDATE("Instalment Period",RunDate);
          //RunDate:=CALCDATE('1W',RunDate);


          //Repayment Frequency
          IF InstalNo>1 THEN BEGIN
          IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
          RunDate:=CALCDATE('1D',RunDate)
          ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
          RunDate:=CALCDATE('1W',RunDate)
          ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
          RunDate:=CALCDATE('1M',RunDate)
          ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
          RunDate:=CALCDATE('1Q',RunDate);
          END ELSE BEGIN
          IF InstalNo=1 THEN
          RunDate:=RDate;
          //MESSAGE('Ins%1Run%2Repay%3',InstalNo,RunDate,LoansR."Repayment Start Date");
          END;
          //Repayment Frequency

         IF (Interest=0) AND (LoanProductsSetup."Interest rate">0) THEN BEGIN
             LoanProductsSetup.GET("Loan Product Type");
              Interest:=LoanProductsSetup."Interest rate";
              MODIFY;
              //COMMIT;
           END;
            IF (Installments=0) AND (LoanProductsSetup."No of Installment">0) THEN BEGIN
             LoanProductsSetup.GET("Loan Product Type");
              Interest:=LoanProductsSetup."No of Installment";
              MODIFY;
              //COMMIT;
           END;

          IF LoanProductsSetup."Interest rate">0 THEN
            TESTFIELD(Interest);
          IF LoanProductsSetup."No of Installment">0 THEN
            TESTFIELD(Installments);

          IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
          TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.05,'>');
          LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
          LPrincipal:=TotalMRepay-LInterest;
          END;

          IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
          LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
          LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
          //Grace Period Interest
          LInterest:=ROUND((LInterest*InitialInstal)/(InitialInstal-InitialGraceInt),0.05,'>');
          END;

          IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
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


        IF LoanProductsSetup.Code = 'A16' THEN
        LInterest :=0;
         IF LoanProductsSetup.Code <> 'A16' THEN BEGIN
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
          END ELSE IF LoanProductsSetup.Code = 'A16' THEN BEGIN
           RSchedule.INIT;
          RSchedule."Repayment Code":=RepayCode;
          RSchedule."Loan No.":="Loan  No.";
          RSchedule."Loan Amount":=LoanAmount;
          RSchedule."Loan Balance":=LBalance;
          RSchedule."Repayment Date":=RunDate;
          RSchedule."Member No.":="Client Code";
          RSchedule."Loan Category":="Loan Product Type";
          RSchedule."Principal Repayment":=LPrincipal;
          RSchedule."Monthly Interest":= 0;
          RSchedule.INSERT;
          WhichDay:=DATE2DWY(RSchedule."Repayment Date",1);
          END;
          UNTIL LBalance < 1

          END;

      //COMMIT;
      END;
      END;
    END;

    PROCEDURE AutogeneratescheduleBuffer@1120054000(VAR LOANNO@1120054000 : Code[100]);
    VAR
      LoanProductsSetup@1120054001 : Record 51516240;
      Mkopo@1120054002 : Record 51516230;
    BEGIN
      IF LoansRegister.GET(LOANNO) THEN BEGIN
      IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Daily THEN
      EVALUATE(InPeriod,'1D')
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Weekly THEN
      EVALUATE(InPeriod,'1W')
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Monthly THEN
      EVALUATE(InPeriod,'1M')
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Quaterly THEN
      EVALUATE(InPeriod,'1Q');


      QCounter:=0;
      QCounter:=3;
      //EVALUATE(InPeriod,'1D');
      GrPrinciple:=LoansRegister."Grace Period - Principle (M)";
      GrInterest:=LoansRegister."Grace Period - Interest (M)";
      InitialGraceInt:=LoansRegister."Grace Period - Interest (M)";

      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Loan  No.",LoansRegister."Loan  No.");
      IF LoansR.FIND('-') THEN BEGIN

      //TESTFIELD("Loan Disbursement Date");
      //TESTFIELD("Repayment Start Date");

      RScheduleB.RESET;
      RScheduleB.SETRANGE(RScheduleB."Loan No.",LoansRegister."Loan  No.");
      RScheduleB.DELETEALL;

      LoanAmount:=LoansR."Approved Amount";
      InterestRate:=LoansR.Interest;
      RepayPeriod:=LoansR.Installments;
      InitialInstal:=LoansR.Installments+LoansRegister."Grace Period - Principle (M)";
      LBalance:=LoansR."Approved Amount";
      RunDate:=TODAY;//"Loan Disbursement Date";
      //RunDate:=CALCDATE('-1W',RunDate);
      InstalNo:=0;
      //EVALUATE(RepayInterval,'1W');
      //EVALUATE(RepayInterval,InPeriod);

      //Repayment Frequency
      IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('-1D',RunDate)
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('-1W',RunDate)
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('-1M',RunDate)
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('-1Q',RunDate);
      //Repayment Frequency


      REPEAT
      InstalNo:=InstalNo+1;
      //RunDate:=CALCDATE("Instalment Period",RunDate);
      //RunDate:=CALCDATE('1W',RunDate);


      //Repayment Frequency
      IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Daily THEN
      RunDate:=CALCDATE('1D',RunDate)
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Weekly THEN
      RunDate:=CALCDATE('1W',RunDate)
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Monthly THEN
      RunDate:=CALCDATE('1M',RunDate)
      ELSE IF LoansRegister."Repayment Frequency"=LoansRegister."Repayment Frequency"::Quaterly THEN
      RunDate:=CALCDATE('1Q',RunDate);
      //Repayment Frequency

      //kma
      //IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
      LoansRegister.TESTFIELD(LoansRegister.Interest);
      LoansRegister.TESTFIELD(LoansRegister.Installments);
      TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount),0.05,'>');
      LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
      LPrincipal:=TotalMRepay-LInterest;
      //END;

      {IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
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
      }


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
      RScheduleB.INIT;
      RScheduleB."Repayment Code":=RepayCode;
      RScheduleB."Loan No.":=LoansRegister."Loan  No.";
      RScheduleB."Loan Amount":=LoanAmount;
      RScheduleB."Instalment No":=InstalNo;
      RScheduleB."Repayment Date":=RunDate;
      RScheduleB."Member No.":=LoansRegister."Client Code";
      RScheduleB."Loan Category":=LoansRegister."Loan Product Type";
      RScheduleB."Monthly Repayment":=LInterest + LPrincipal;
      RScheduleB."Monthly Interest":=LInterest;
      RScheduleB."Principal Repayment":=LPrincipal;
      RScheduleB.INSERT;
      //WhichDay:=(DATE2DMY,RSchedule."Repayment Date",1);
       WhichDay:=DATE2DWY(RScheduleB."Repayment Date",1);
      //MESSAGE('which day is %1',WhichDay);
      //BEEP(2,10000);
      UNTIL LBalance < 1

      END;
      END;
    END;

    BEGIN
    END.
  }
}

