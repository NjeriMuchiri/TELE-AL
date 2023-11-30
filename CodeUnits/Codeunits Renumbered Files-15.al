OBJECT CodeUnit 20379 prPayrollProcessing
{
  OBJECT-PROPERTIES
  {
    Date=10/27/16;
    Time=[ 5:27:59 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text020@1102756006 : TextConst 'ENU=Because of circular references, the program cannot calculate a formula.';
      Text012@1102756005 : TextConst 'ENU=You have entered an illegal value or a nonexistent row number.';
      Text013@1102756004 : TextConst 'ENU=You have entered an illegal value or a nonexistent column number.';
      Text017@1102756003 : TextConst 'ENU=The error occurred when the program tried to calculate:\';
      Text018@1102756002 : TextConst 'ENU="Acc. Sched. Line: Row No. = %1, Line No. = %2, Totaling = %3\"';
      Text019@1102756001 : TextConst 'ENU="Acc. Sched. Column: Column No. = %4, Line No. = %5, Formula  = %6"';
      Text023@1102756000 : TextConst 'ENU=Formulas ending with a percent sign require %2 %1 on a line before it.';
      VitalSetup@1102756020 : Record 39004013;
      curReliefPersonal@1102756019 : Decimal;
      curReliefInsurance@1102756018 : Decimal;
      curReliefMorgage@1102756017 : Decimal;
      curMaximumRelief@1102756016 : Decimal;
      curNssfEmployee@1102756015 : Decimal;
      curNssf_Employer_Factor@1102756014 : Decimal;
      intNHIF_BasedOn@1102756013 : 'Gross,Basic,Taxable Pay';
      curMaxPensionContrib@1102756012 : Decimal;
      curRateTaxExPension@1102756011 : Decimal;
      curOOIMaxMonthlyContrb@1102756010 : Decimal;
      curOOIDecemberDedc@1102756009 : Decimal;
      curLoanMarketRate@1102756008 : Decimal;
      curLoanCorpRate@1102756007 : Decimal;
      PostingGroup@1102756029 : Record 39004022;
      TaxAccount@1102756028 : Code[20];
      salariesAcc@1102756027 : Code[20];
      PayablesAcc@1102756026 : Code[20];
      NSSFEMPyer@1102756025 : Code[20];
      PensionEMPyer@1102756024 : Code[20];
      NSSFEMPyee@1102756023 : Code[20];
      NHIFEMPyer@1102756022 : Code[20];
      NHIFEMPyee@1102756021 : Code[20];
      HrEmployee@1102756030 : Record 39003917;
      CoopParameters@1102756031 : 'none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension,NSSF,Overtime,DevShare,NHIF';
      PayrollType@1102756032 : Code[20];
      SpecialTranAmount@1102755000 : Decimal;
      EmpSalary@1102755001 : Record 39004014;
      txBenefitAmt@1102755002 : Decimal;
      TelTaxACC@1000000000 : Code[20];
      Loans@1000 : Record 39004241;
      Vendor@1001 : Record 23;

    PROCEDURE fnInitialize@1102756000();
    BEGIN
      //Initialize Global Setup Items
      VitalSetup.FINDFIRST;
      WITH VitalSetup DO BEGIN
              curReliefPersonal := "Tax Relief";
              curReliefInsurance := "Insurance Relief";
              curReliefMorgage := "Mortgage Relief"; //Same as HOSP
              curMaximumRelief := "Max Relief";
              curNssfEmployee := "NSSF Employee";
              curNssf_Employer_Factor:= "NSSF Employer Factor";
              intNHIF_BasedOn := "NHIF Based on";
              curMaxPensionContrib := "Max Pension Contribution";
              curRateTaxExPension := "Tax On Excess Pension";
              curOOIMaxMonthlyContrb := "OOI Deduction";
              curOOIDecemberDedc := "OOI December";
              curLoanMarketRate := "Loan Market Rate";
              curLoanCorpRate := "Loan Corporate Rate";


      END;
    END;

    PROCEDURE fnProcesspayroll@1102756001(strEmpCode@1102756025 : Code[20];dtDOE@1102756026 : Date;curBasicPay@1102756027 : Decimal;blnPaysPaye@1102756028 : Boolean;blnPaysNssf@1102756029 : Boolean;blnPaysNhif@1102756030 : Boolean;SelectedPeriod@1102756031 : Date;dtOpenPeriod@1102756032 : Date;Membership@1102756039 : Text[30];ReferenceNo@1102756040 : Text[30];dtTermination@1102756056 : Date;blnGetsPAYERelief@1102756057 : Boolean;Dept@1102756064 : Code[20];PayrollCode@1102756069 : Code[20]);
    VAR
      strTableName@1102756024 : Text[50];
      curTransAmount@1102756023 : Decimal;
      curTransBalance@1102756022 : Decimal;
      strTransDescription@1102756021 : Text[50];
      TGroup@1102756020 : Text[30];
      TGroupOrder@1102756019 : Integer;
      TSubGroupOrder@1102756018 : Integer;
      curSalaryArrears@1102756017 : Decimal;
      curPayeArrears@1102756016 : Decimal;
      curGrossPay@1102756015 : Decimal;
      curTotAllowances@1102756014 : Decimal;
      curExcessPension@1102756013 : Decimal;
      curNSSF@1102756012 : Decimal;
      curDefinedContrib@1102756011 : Decimal;
      curPensionStaff@1102756010 : Decimal;
      curNonTaxable@1102756009 : Decimal;
      curGrossTaxable@1102756008 : Decimal;
      curBenefits@1102756007 : Decimal;
      curValueOfQuarters@1102756006 : Decimal;
      curUnusedRelief@1102756005 : Decimal;
      curInsuranceReliefAmount@1102756004 : Decimal;
      curMorgageReliefAmount@1102756003 : Decimal;
      curTaxablePay@1102756002 : Decimal;
      curTaxCharged@1102756001 : Decimal;
      curPAYE@1102756000 : Decimal;
      prPeriodTransactions@1102756033 : Record 39004001;
      intYear@1102756034 : Integer;
      intMonth@1102756035 : Integer;
      LeapYear@1102756036 : Boolean;
      CountDaysofMonth@1102756037 : Integer;
      DaysWorked@1102756038 : Integer;
      prSalaryArrears@1102756041 : Record 39003997;
      prEmployeeTransactions@1102756042 : Record 39004000;
      prTransactionCodes@1102756043 : Record 39003991;
      strExtractedFrml@1102756044 : Text[250];
      SpecialTransType@1102756045 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';
      TransactionType@1102756046 : 'Income,Deduction';
      curPensionCompany@1102756047 : Decimal;
      curTaxOnExcessPension@1102756048 : Decimal;
      prUnusedRelief@1102756049 : Record 39003999;
      curNhif_Base_Amount@1102756050 : Decimal;
      curNHIF@1102756051 : Decimal;
      curTotalDeductions@1102756052 : Decimal;
      curNetRnd_Effect@1102756053 : Decimal;
      curNetPay@1102756054 : Decimal;
      curTotCompanyDed@1102756055 : Decimal;
      curOOI@1102756058 : Decimal;
      curHOSP@1102756059 : Decimal;
      curLoanInt@1102756060 : Decimal;
      strTransCode@1102756061 : Text[250];
      fnCalcFringeBenefit@1102756062 : Decimal;
      prEmployerDeductions@1102756063 : Record 39004003;
      JournalPostingType@1102756065 : ' ,G/L Account,Customer,Vendor';
      JournalAcc@1102756066 : Code[20];
      Customer@1102756067 : Record 39004418;
      JournalPostAs@1102756068 : ' ,Debit,Credit';
      IsCashBenefit@1102756070 : Decimal;
      Teltax@1000000000 : Decimal;
      Teltax2@1000000001 : Decimal;
      prEmployeeTransactions2@1000000002 : Record 39004000;
      prTransactionCodes3@1000000003 : Record 39003991;
      curTransAmount2@1000000004 : Decimal;
    BEGIN

      //Initialize
      fnInitialize;
      fnGetJournalDet(strEmpCode);
      MESSAGE('TEST');
      //check if the period selected=current period. If not, do NOT run this function
      IF SelectedPeriod <> dtOpenPeriod THEN EXIT;
      intMonth:=DATE2DMY(SelectedPeriod,2);intYear:=DATE2DMY(SelectedPeriod,3);

      IF curBasicPay >0 THEN
      BEGIN
         //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
         IF (DATE2DMY(dtDOE,2)=DATE2DMY(dtOpenPeriod,2)) AND (DATE2DMY(dtDOE,3)=DATE2DMY(dtOpenPeriod,3))THEN BEGIN
            CountDaysofMonth:=fnDaysInMonth(dtDOE);
            DaysWorked:=fnDaysWorked(dtDOE,FALSE);
            curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay,DaysWorked,CountDaysofMonth)
         END;

        //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
        IF dtTermination<>0D THEN BEGIN
         IF (DATE2DMY(dtTermination,2)=DATE2DMY(dtOpenPeriod,2)) AND (DATE2DMY(dtTermination,3)=DATE2DMY(dtOpenPeriod,3))THEN BEGIN
           CountDaysofMonth:=fnDaysInMonth(dtTermination);
           DaysWorked:=fnDaysWorked(dtTermination,TRUE);
           curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay,DaysWorked,CountDaysofMonth)
         END;
        END;

       curTransAmount := curBasicPay;
       strTransDescription := 'Basic Pay';
       TGroup := 'BASIC SALARY'; TGroupOrder := 1; TSubGroupOrder := 1;
       fnUpdatePeriodTrans(strEmpCode, 'BPAY', TGroup, TGroupOrder,
       TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
       salariesAcc,JournalPostAs::Debit,JournalPostingType::"G/L Account",'',CoopParameters::none);


       //Salary Arrears
       prSalaryArrears.RESET;
       prSalaryArrears.SETRANGE(prSalaryArrears."Employee Code",strEmpCode);
       prSalaryArrears.SETRANGE(prSalaryArrears."Period Month",intMonth);
       prSalaryArrears.SETRANGE(prSalaryArrears."Period Year",intYear);
       IF prSalaryArrears.FIND('-') THEN BEGIN
       REPEAT
            curSalaryArrears := prSalaryArrears."Salary Arrears";
            curPayeArrears := prSalaryArrears."PAYE Arrears";

            //Insert [Salary Arrears] into period trans [ARREARS]
            curTransAmount := curSalaryArrears;
            strTransDescription := 'Salary Arrears';
            TGroup := 'ARREARS'; TGroupOrder := 1; TSubGroupOrder := 2;
            fnUpdatePeriodTrans(strEmpCode, prSalaryArrears."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
              strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,salariesAcc,
              JournalPostAs::Debit,JournalPostingType::"G/L Account",'',CoopParameters::none);

            //Insert [PAYE Arrears] into period trans [PYAR]
            curTransAmount:= curPayeArrears;
            strTransDescription := 'P.A.Y.E Arrears';
            TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 4;
            fnUpdatePeriodTrans(strEmpCode, 'PYAR', TGroup, TGroupOrder, TSubGroupOrder,
               strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
               TaxAccount,JournalPostAs::Debit,JournalPostingType::"G/L Account",'',CoopParameters::none)

       UNTIL prSalaryArrears.NEXT=0;
       END;

       //Get Earnings
       prEmployeeTransactions.RESET;
       prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",strEmpCode);
       prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
       prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
       IF prEmployeeTransactions.FIND('-') THEN BEGIN
         curTotAllowances:= 0;
         REPEAT
           prTransactionCodes.RESET;
           prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
           prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Type",prTransactionCodes."Transaction Type"::Income);

           IF prTransactionCodes.FIND('-') THEN BEGIN
             curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';
             IF prTransactionCodes."Is Formula" THEN BEGIN
                 strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                 curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount

             END ELSE BEGIN
                 curTransAmount := prEmployeeTransactions.Amount;
             END;

            IF prTransactionCodes."Balance Type"=prTransactionCodes."Balance Type"::None THEN //[0=None, 1=Increasing, 2=Reducing]
                      curTransBalance := 0;
            IF prTransactionCodes."Balance Type"=prTransactionCodes."Balance Type"::Increasing THEN
                      curTransBalance := prEmployeeTransactions.Balance+ curTransAmount;
            IF prTransactionCodes."Balance Type"= prTransactionCodes."Balance Type"::Reducing THEN
                      curTransBalance := prEmployeeTransactions.Balance - curTransAmount;


               //Prorate Allowances Here
                //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
                IF (DATE2DMY(dtDOE,2)=DATE2DMY(dtOpenPeriod,2)) AND (DATE2DMY(dtDOE,3)=DATE2DMY(dtOpenPeriod,3))THEN BEGIN
                   CountDaysofMonth:=fnDaysInMonth(dtDOE);
                   DaysWorked:=fnDaysWorked(dtDOE,FALSE);
                   curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount,DaysWorked,CountDaysofMonth)
                END;

               //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
               IF dtTermination<>0D THEN BEGIN
                IF (DATE2DMY(dtTermination,2)=DATE2DMY(dtOpenPeriod,2)) AND (DATE2DMY(dtTermination,3)=DATE2DMY(dtOpenPeriod,3))THEN
      BEGIN
                  CountDaysofMonth:=fnDaysInMonth(dtTermination);
                  DaysWorked:=fnDaysWorked(dtTermination,TRUE);
                  curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount,DaysWorked,CountDaysofMonth)
                END;
               END;
              // Prorate Allowances Here

               //Add Non Taxable Here
               IF (NOT prTransactionCodes.Taxable) AND (prTransactionCodes."Special Transactions" =
               prTransactionCodes."Special Transactions"::Ignore) THEN
                   curNonTaxable:=curNonTaxable+curTransAmount;

               //Added to ensure special transaction that are not taxable are not inlcuded in list of Allowances
               IF (NOT prTransactionCodes.Taxable) AND (prTransactionCodes."Special Transactions" <>
               prTransactionCodes."Special Transactions"::Ignore) THEN
                  curTransAmount:=0;

               curTotAllowances := curTotAllowances + curTransAmount; //Sum-up all the allowances
               curTransAmount := curTransAmount;
               curTransBalance := curTransBalance;
               strTransDescription := prTransactionCodes."Transaction Name";
               TGroup := 'ALLOWANCE'; TGroupOrder := 3; TSubGroupOrder := 0;

               //Get the posting Details
               JournalPostingType:=JournalPostingType::" ";JournalAcc:='';
               IF prTransactionCodes.Subledger<>prTransactionCodes.Subledger::" " THEN BEGIN
                  IF prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer THEN BEGIN
                      HrEmployee.GET(strEmpCode);
                      Customer.RESET;
                                      Customer.SETRANGE(Customer."Payroll/Staff No",HrEmployee."Sacco Staff No");
                     //Customer.SETRANGE(Customer."No.",HrEmployee."No.");
                      IF Customer.FIND('-') THEN BEGIN
                         JournalAcc:=Customer."No.";
                         JournalPostingType:=JournalPostingType::Customer;
                      END;
                  END;
               END ELSE BEGIN
                  JournalAcc:=prTransactionCodes."GL Account";
                  JournalPostingType:=JournalPostingType::"G/L Account";
               END;

               //End posting Details

               fnUpdatePeriodTrans(strEmpCode,prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
               strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,prEmployeeTransactions.Membership,
               prEmployeeTransactions."Reference No",SelectedPeriod,Dept,JournalAcc,JournalPostAs::Debit,JournalPostingType,'',
               prTransactionCodes."coop parameters");

           END;
         UNTIL prEmployeeTransactions.NEXT=0;
       END;

       //Calc GrossPay = (BasicSalary + Allowances + SalaryArrears) [Group Order = 4]
       curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears);
       curTransAmount := curGrossPay;
       strTransDescription := 'Gross Pay';
       TGroup := 'GROSS PAY'; TGroupOrder := 4; TSubGroupOrder := 0;
       fnUpdatePeriodTrans (strEmpCode, 'GPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth,
        intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',CoopParameters::none);


           {

        //Get the N.S.S.F amount for the month GBT
       curNssf_Base_Amount :=0;
       IF intNSSF_BasedOn =intNSSF_BasedOn::Gross THEN //>NSSF calculation can be based on:
               curNssf_Base_Amount := curGrossPay;
       IF intNSSF_BasedOn = intNSSF_BasedOn::Basic THEN
              curNssf_Base_Amount := curBasicPay;

           }

       //Get the NSSF amount
       IF blnPaysNssf THEN
        curNSSF := curNssfEmployee;
      // curNSSF:=fnGetEmployeeNSSF(curNssf_Base_Amount);
       curTransAmount := curNSSF;
       strTransDescription := 'N.S.S.F';
       TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 1;
       fnUpdatePeriodTrans (strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
       strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,NSSFEMPyee,
       JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::NSSF);


      //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
       curDefinedContrib := curNSSF; //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
       curTransAmount := curDefinedContrib;
       strTransDescription := 'Defined Contributions';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder:= 6; TSubGroupOrder:= 1;
       fnUpdatePeriodTrans(strEmpCode, 'DEFCON', TGroup, TGroupOrder, TSubGroupOrder,
        strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",
        JournalPostingType::" ",'',CoopParameters::none);


       //Get the Gross taxable amount
       //>GrossTaxable = Gross + Benefits + nValueofQuarters  ******Confirm CurValueofQuaters
       curGrossTaxable := curGrossPay + curBenefits + curValueOfQuarters;

       //>If GrossTaxable = 0 Then TheDefinedToPost = 0
       IF curGrossTaxable = 0 THEN curDefinedContrib := 0;

       //Personal Relief
      // if get relief is ticked  - DENNO ADDED
      IF blnGetsPAYERelief THEN
      BEGIN
       curReliefPersonal := curReliefPersonal + curUnusedRelief; //*****Get curUnusedRelief
       curTransAmount := curReliefPersonal;
       strTransDescription := 'Personal Relief';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 9;
       fnUpdatePeriodTrans (strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
        CoopParameters::none);
      END
      ELSE
       curReliefPersonal := 0;

      //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       //>Pension Contribution [self] relief
       curPensionStaff := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
       SpecialTransType::"Defined Contribution",FALSE) ;//Self contrib Pension is 1 on [Special Transaction]
       IF curPensionStaff > 0 THEN BEGIN
           IF curPensionStaff > curMaxPensionContrib THEN
               curTransAmount :=curMaxPensionContrib
           ELSE
               curTransAmount :=curPensionStaff;
           strTransDescription := 'Pension Relief';
           TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 2;
           fnUpdatePeriodTrans (strEmpCode, 'PNSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
           curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
           CoopParameters::none)
       END;

      //if he PAYS paye only*******************I
      IF blnPaysPaye AND blnGetsPAYERelief THEN
      BEGIN
        //Get Insurance Relief
        curInsuranceReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
        SpecialTransType::"Life Insurance",FALSE); //Insurance is 3 on [Special Transaction]
        IF curInsuranceReliefAmount > 0 THEN BEGIN
            curTransAmount := curInsuranceReliefAmount;
            strTransDescription := 'Insurance Relief';
            TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 8;
            fnUpdatePeriodTrans (strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
            CoopParameters::none);
        END;

       //>OOI
        curOOI := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
        SpecialTransType::"Owner Occupier Interest",FALSE); //Morgage is LAST on [Special Transaction]
        IF curOOI > 0 THEN BEGIN
          IF curOOI<=curOOIMaxMonthlyContrb THEN
            curTransAmount := curOOI
          ELSE
            curTransAmount:=curOOIMaxMonthlyContrb;

            strTransDescription := 'Owner Occupier Interest';
            TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 3;
            fnUpdatePeriodTrans (strEmpCode, 'OOI', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
            CoopParameters::none);
        END;

      //HOSP
        curHOSP := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
        SpecialTransType::"Home Ownership Savings Plan",FALSE); //Home Ownership Savings Plan
        IF curHOSP > 0 THEN BEGIN
          IF curHOSP<=curReliefMorgage THEN
            curTransAmount := curHOSP
          ELSE
            curTransAmount:=curReliefMorgage;

            strTransDescription := 'Home Ownership Savings Plan';
            TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 4;
            fnUpdatePeriodTrans (strEmpCode, 'HOSP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
            CoopParameters::none);
        END;

      //Enter NonTaxable Amount
      IF curNonTaxable>0 THEN BEGIN
            strTransDescription := 'Other Non-Taxable Benefits';
            TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 5;
            fnUpdatePeriodTrans (strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            curNonTaxable, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
            CoopParameters::none);
      END;

      END;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      {
       //>Company pension, Excess pension, Tax on excess pension
       curPensionCompany := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear, SpecialTransType::"Defined Contribution",
       TRUE); //Self contrib Pension is 1 on [Special Transaction]
       IF curPensionCompany > 0 THEN BEGIN
           curTransAmount := curPensionCompany;
           strTransDescription := 'Pension (Company)';
           //Update the Employer deductions table

           curExcessPension:= curPensionCompany - curMaxPensionContrib;
           IF curExcessPension > 0 THEN BEGIN
               curTransAmount := curExcessPension;
               strTransDescription := 'Excess Pension';
               TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 5;
               fnUpdatePeriodTrans (strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                intMonth,intYear,'','',SelectedPeriod);

               curTaxOnExcessPension := (curRateTaxExPension / 100) * curExcessPension;
               curTransAmount := curTaxOnExcessPension;
               strTransDescription := 'Tax on ExPension';
               TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 6;
               fnUpdatePeriodTrans (strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                intMonth,intYear,'','',SelectedPeriod);
           END;
       END;
       }

       //Get the Taxable amount for calculation of PAYE
       //>prTaxablePay = (GrossTaxable - SalaryArrears) - (TheDefinedToPost + curSelfPensionContrb + MorgageRelief)


        //Add HOSP and MORTGAGE KIM{}
       IF curPensionStaff > curMaxPensionContrib THEN
         curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curMaxPensionContrib+curOOI+curHOSP+
         curNonTaxable)
       ELSE
           curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curPensionStaff+curOOI+curHOSP+
           curNonTaxable);
       curTransAmount := curTaxablePay;
       strTransDescription := 'Taxable Pay';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 6;
       fnUpdatePeriodTrans (strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
        CoopParameters::none);

       //Get the Tax charged for the month
       curTaxCharged := fnGetEmployeePaye(curTaxablePay);
       curTransAmount := curTaxCharged;
       strTransDescription := 'Tax Charged';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 7;
       fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
       curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
       CoopParameters::none);


       //Get the Net PAYE amount to post for the month
       IF (curReliefPersonal + curInsuranceReliefAmount)>curMaximumRelief THEN
         curPAYE := ROUND(curTaxCharged - curMaximumRelief)
       ELSE
       curPAYE := ROUND(curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount));

       IF NOT blnPaysPaye THEN curPAYE := 0; //Get statutory Exemption for the staff. If exempted from tax, set PAYE=0
       curTransAmount := curPAYE;
       IF curPAYE<0 THEN curTransAmount := 0;
       strTransDescription := 'P.A.Y.E';
       TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 3;
       fnUpdatePeriodTrans (strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,TaxAccount,JournalPostAs::Credit,
        JournalPostingType::"G/L Account",'',CoopParameters::none);

       //Store the unused relief for the current month
       //>If Paye<0 then "Insert into tblprUNUSEDRELIEF
       IF curPAYE < 0 THEN BEGIN
       prUnusedRelief.RESET;
       prUnusedRelief.SETRANGE(prUnusedRelief."Employee Code",strEmpCode);
       prUnusedRelief.SETRANGE(prUnusedRelief."Period Month",intMonth);
       prUnusedRelief.SETRANGE(prUnusedRelief."Period Year",intYear);
       IF prUnusedRelief.FIND('-') THEN
          prUnusedRelief.DELETE;

       prUnusedRelief.RESET;
       WITH prUnusedRelief DO BEGIN
           INIT;
           "Employee Code" := strEmpCode;
           "Unused Relief" := curPAYE;
           "Period Month" := intMonth;
           "Period Year" := intYear;
           INSERT;
       END;
      END;

       //Deductions: get all deductions for the month
       //Loans: calc loan deduction amount, interest, fringe benefit (employer deduction), loan balance
       //>Balance = (Openning Bal + Deduction)...//Increasing balance
       //>Balance = (Openning Bal - Deduction)...//Reducing balance
       //>NB: some transactions (e.g Sacco shares) can be made by cheque or cash. Allow user to edit the outstanding balance

       //Get the N.H.I.F amount for the month GBT
       curNhif_Base_Amount :=0;

       IF intNHIF_BasedOn =intNHIF_BasedOn::Gross THEN //>NHIF calculation can be based on:
               curNhif_Base_Amount := curGrossPay;
       IF intNHIF_BasedOn = intNHIF_BasedOn::Basic THEN
              curNhif_Base_Amount := curBasicPay;
       IF intNHIF_BasedOn =intNHIF_BasedOn::"Taxable Pay" THEN
              curNhif_Base_Amount := curTaxablePay;

       IF blnPaysNhif THEN BEGIN
        curNHIF:=fnGetEmployeeNHIF(curNhif_Base_Amount);
        curTransAmount := curNHIF;
        strTransDescription := 'N.H.I.F';
        TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 2;
        fnUpdatePeriodTrans (strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
         curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
         NHIFEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
       END;

        prEmployeeTransactions.RESET;
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",strEmpCode);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
        IF prEmployeeTransactions.FIND('-') THEN BEGIN
          curTotalDeductions:= 0;
          REPEAT
            prTransactionCodes.RESET;
            prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
            prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Type",prTransactionCodes."Transaction Type"::Deduction);
            IF prTransactionCodes.FIND('-') THEN BEGIN
              curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';

              IF prTransactionCodes."Is Formula" THEN BEGIN
                  strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                  curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount

              END ELSE BEGIN
                  curTransAmount := prEmployeeTransactions.Amount;
              END;

             //**************************If "deduct Premium" is not ticked and the type is insurance- Dennis*****
             IF (prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::"Life Insurance")
               AND (prTransactionCodes."Deduct Premium"=FALSE) THEN
              BEGIN
               curTransAmount:=0;
              END;

             //**************************If "deduct Premium" is not ticked and the type is mortgage- Dennis*****
             IF(prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::Morgage)
              AND (prTransactionCodes."Deduct Mortgage"=FALSE) THEN
              BEGIN
               curTransAmount:=0;
              END;
            //MESSAGE(FORMAT(curTransAmount));

          //Get the posting Details
               JournalPostingType:=JournalPostingType::" ";JournalAcc:='';
               IF prTransactionCodes.Subledger<>prTransactionCodes.Subledger::" " THEN BEGIN
                  IF prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer THEN BEGIN
                      Customer.RESET;
                      HrEmployee.GET(strEmpCode);
                      Customer.RESET;
                      //IF prTransactionCodes.CustomerPostingGroup ='' THEN
                        //Customer.SETRANGE(Customer."Employer Code",'KPSS');

                       IF prTransactionCodes.CustomerPostingGroup ='STAFF' THEN
                        Customer.SETRANGE(Customer."Customer Posting Group",prTransactionCodes.CustomerPostingGroup);
                        //Customer.SETRANGE(Customer."HR. No",HrEmployee."No.");
                        IF Customer.FIND('-') THEN BEGIN
                         JournalAcc:=Customer."No.";
                        // MESSAGE('Hapa tuko sawa1');
                         JournalPostingType:=JournalPostingType::Customer;
                      END;

                      IF prTransactionCodes.CustomerPostingGroup <>'' THEN
                      Customer.SETRANGE(Customer."Customer Posting Group",prTransactionCodes.CustomerPostingGroup);
                       //cyrus 180613
                      //Customer.SETRANGE(Customer."Payroll/Staff No",HrEmployee."Sacco Staff No");
                      Customer.SETRANGE(Customer."Payroll/Staff No",HrEmployee."No.");
                      IF Customer.FIND('-') THEN BEGIN
                         JournalAcc:=Customer."No.";
                         JournalPostingType:=JournalPostingType::Customer;
                      END;

                  END;
      //Added to cater for vendor
      IF prTransactionCodes.Subledger=prTransactionCodes.Subledger::Vendor THEN BEGIN
      HrEmployee.GET(strEmpCode);
                         JournalAcc:=HrEmployee."FOSA Account";//Customer."No.";
                         JournalPostingType:=JournalPostingType::Vendor;

      END;
      //Added to cater for vendor

               END ELSE BEGIN
                  JournalAcc:=prTransactionCodes."GL Account";
                  JournalPostingType:=JournalPostingType::"G/L Account";
               END;

              //End posting Details

                   {
              //Loan Calculation is Amortized do Calculations here -Monthly Principal and Interest Keeps on Changing
              IF (prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::"Staff Loan") AND
                 (prTransactionCodes."Repayment Method" = prTransactionCodes."Repayment Method"::Amortized) THEN BEGIN
                 curTransAmount:=0; curLoanInt:=0;
                 curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                 prTransactionCodes."Interest Rate",prTransactionCodes."Repayment Method",
                    prEmployeeTransactions."Original Amount",prEmployeeTransactions.Balance,SelectedPeriod,FALSE);
                 //Post the Interest
                 IF (curLoanInt<>0) THEN BEGIN
                        curTransAmount := curLoanInt;
                        curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                        curTransBalance:=0;
                        strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                        strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Interest';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                          CoopParameters::"loan Interest")
                  END;
                 //Get the Principal Amt
                 curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                  //Modify PREmployeeTransaction Table
                  prEmployeeTransactions.Amount:=curTransAmount;
                  prEmployeeTransactions.MODIFY;
              END;
              //Loan Calculation Amortized
                       }
              CASE prTransactionCodes."Balance Type" OF //[0=None, 1=Increasing, 2=Reducing]
                  prTransactionCodes."Balance Type"::None:
                       curTransBalance := 0;
                  prTransactionCodes."Balance Type"::Increasing:
                      curTransBalance := prEmployeeTransactions.Balance+ curTransAmount;
                 prTransactionCodes."Balance Type"::Reducing:
                 BEGIN
                      //curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                      IF prEmployeeTransactions.Balance < prEmployeeTransactions.Amount THEN BEGIN
                           curTransAmount := prEmployeeTransactions.Balance;
                           curTransBalance := 0;
                       END ELSE BEGIN
                           curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                       END;
                       IF curTransBalance < 0 THEN BEGIN
                           curTransAmount := 0;
                           curTransBalance := 0;
                       END;
                 END
            END;

              curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
              curTransAmount := curTransAmount;
              //Added for POLICE SACCO there is a minimum to Share Contribution of a percentage
              {IF prTransactionCodes."coop parameters"=prTransactionCodes."coop parameters"::shares THEN BEGIN
                 IF prTransactionCodes."Min Share Contrib[%]"<>0 THEN BEGIN
                    IF curTransAmount<((prTransactionCodes."Min Share Contrib[%]"/100)* curBasicPay) THEN
                        curTransAmount:=((prTransactionCodes."Min Share Contrib[%]"/100)* curBasicPay);
                 END;

              END; }
              //End addition for POLICE SACCO for min share contribution
              curTransBalance := curTransBalance;
              strTransDescription := prTransactionCodes."Transaction Name";
              TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 0;
              fnUpdatePeriodTrans (strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
               strTransDescription,curTransAmount, curTransBalance, intMonth,
               intYear, prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
               JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
               prTransactionCodes."coop parameters");
               {
      //Check if transaction is loan. Get the Interest on the loan & post it at this point before moving next ****Loan Calculation
              IF (prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::"Staff Loan") AND
                 (prTransactionCodes."Repayment Method" <> prTransactionCodes."Repayment Method"::Amortized) THEN BEGIN

                   curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                  prTransactionCodes."Interest Rate",
                   prTransactionCodes."Repayment Method", prEmployeeTransactions."Original Amount",
                   prEmployeeTransactions.Balance,SelectedPeriod,prTransactionCodes.Welfare);
                    IF curLoanInt > 0 THEN BEGIN
                        curTransAmount := curLoanInt;
                        curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                        curTransBalance:=0;
                        strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                        strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Interest';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                          CoopParameters::"loan Interest")
                   END;
             END;
             //End Loan transaction calculation
             }

             //Fringe Benefits and Low interest Benefits
                    IF prTransactionCodes."Fringe Benefit" = TRUE THEN BEGIN
                        IF prTransactionCodes."Interest Rate" < curLoanMarketRate THEN BEGIN
                            fnCalcFringeBenefit := (((curLoanMarketRate - prTransactionCodes."Interest Rate") * curLoanCorpRate) / 1200)
                             * prEmployeeTransactions.Balance;
                        END;
                    END ELSE BEGIN
                        fnCalcFringeBenefit := 0;
                    END;
                    IF  fnCalcFringeBenefit>0 THEN BEGIN
                        fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code"+'-FRG',
                         'EMP', TGroupOrder, TSubGroupOrder,'Fringe Benefit Tax', fnCalcFringeBenefit, 0, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod)

                    END;
             //End Fringe Benefits

            //Create Employer Deduction
            IF (prTransactionCodes."Employer Deduction") OR (prTransactionCodes."Include Employer Deduction") THEN BEGIN
              IF prTransactionCodes."Is Formula for employer"<>'' THEN BEGIN
                  strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear,prTransactionCodes."Is Formula for employer");
                  curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
              END ELSE BEGIN
                  curTransAmount := prEmployeeTransactions."Employer Amount";
              END;
                    IF  curTransAmount>0 THEN
                        fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                         'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod)

            END;
            //Employer deductions

            END;

        UNTIL prEmployeeTransactions.NEXT=0;
           //GET TOTAL DEDUCTIONS
                        curTransBalance:=0;
                        strTransCode := 'TOT-DED';
                        strTransDescription := 'TOTAL DEDUCTION';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 9;
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTotalDeductions, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          '',JournalPostAs::" ",JournalPostingType::" ",'',CoopParameters::none)

           //END GET TOTAL DEDUCTIONS
       END;

        //Net Pay: calculate the Net pay for the month in the following manner:
        //>Nett = Gross - (xNssfAmount + curMyNhifAmt + PAYE + PayeArrears + prTotDeductions)
        //...Tot Deductions also include (SumLoan + SumInterest)
        curNetPay := curGrossPay - (curNSSF + curNHIF + curPAYE + curPayeArrears + curTotalDeductions);

        //>Nett = Nett - curExcessPension
        //...Excess pension is only used for tax. Staff is not paid the amount hence substract it
        curNetPay := curNetPay; //- curExcessPension

        //>Nett = Nett - cSumEmployerDeductions
        //...Employer Deductions are used for reporting as cost to company BUT dont affect Net pay
        curNetPay := curNetPay - curTotCompanyDed; //******Get Company Deduction*****

        curNetRnd_Effect := curNetPay - ROUND(curNetPay);
        curTransAmount := curNetPay;
        strTransDescription := 'Net Pay';
        TGroup := 'NET PAY'; TGroupOrder := 9; TSubGroupOrder := 0;
        fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
        PayablesAcc,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);

        //Rounding Effect: if the Net pay is rounded, take the rounding effect &
        //save it as an earning for the staff for the next month
            //>Insert the Netpay rounding effect into the tblRoundingEffect table


        //Negative pay: if the NetPay<0 then log the entry
            //>Display an on screen report
            //>Through a pop-up to the user
            //>Send an email to the user or manager
      END
    END;

    PROCEDURE fnBasicPayProrated@1102756007(strEmpCode@1102756000 : Code[20];Month@1102756001 : Integer;Year@1102756002 : Integer;BasicSalary@1102756004 : Decimal;DaysWorked@1102756003 : Integer;DaysInMonth@1102756005 : Integer) ProratedAmt : Decimal;
    BEGIN
       ProratedAmt:= ROUND((DaysWorked / DaysInMonth) * BasicSalary);
    END;

    PROCEDURE fnDaysInMonth@1102756006(dtDate@1102756000 : Date) DaysInMonth : Integer;
    VAR
      Day@1102756001 : Integer;
      SysDate@1102756005 : Record 2000000007;
      Expr1@1102756004 : Text[30];
      FirstDay@1102756003 : Date;
      LastDate@1102756002 : Date;
      TodayDate@1102756006 : Date;
    BEGIN
      TodayDate:=dtDate;

       Day:=DATE2DMY(TodayDate,1);
       Expr1:=FORMAT(-Day)+'D+1D';
       FirstDay:=CALCDATE(Expr1,TodayDate);
       LastDate:=CALCDATE('1M-1D',FirstDay);

       SysDate.RESET;
       SysDate.SETRANGE(SysDate."Period Type",SysDate."Period Type"::Date);
       SysDate.SETRANGE(SysDate."Period Start",FirstDay,LastDate);
      // SysDate.SETFILTER(SysDate."Period No.",'1..5');
       IF SysDate.FIND('-') THEN
          DaysInMonth:=SysDate.COUNT;
    END;

    PROCEDURE fnUpdatePeriodTrans@1102756008(EmpCode@1102756000 : Code[20];TCode@1102756001 : Code[20];TGroup@1102756002 : Code[20];GroupOrder@1102756003 : Integer;SubGroupOrder@1102756004 : Integer;Description@1102756005 : Text[50];curAmount@1102756006 : Decimal;curBalance@1102756007 : Decimal;Month@1102756008 : Integer;Year@1102756009 : Integer;mMembership@1102756010 : Text[30];ReferenceNo@1102756011 : Text[30];dtOpenPeriod@1102756013 : Date;Department@1102756014 : Code[20];JournalAC@1102756017 : Code[20];PostAs@1102756016 : ' ,Debit,Credit';JournalACType@1102756015 : ' ,G/L Account,Customer,Vendor';LoanNo@1102756018 : Code[20];CoopParam@1102756019 : 'none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension');
    VAR
      prPeriodTransactions@1102756012 : Record 39004001;
      prSalCard@1102756020 : Record 39003917;
    BEGIN

      IF curAmount = 0 THEN EXIT;
      WITH prPeriodTransactions DO BEGIN
          INIT;
          "Employee Code" := EmpCode;
          "Transaction Code" := TCode;
          "Group Text" := TGroup;
          "Transaction Name" := Description;
           Amount := ROUND(curAmount,0.05,'=');
           Balance := curBalance;
          "Original Amount" := Balance;
          "Group Order" := GroupOrder;
          "Sub Group Order" := SubGroupOrder;
           Membership := mMembership;
           "Reference No" := ReferenceNo;
          "Period Month" := Month;
          "Period Year" := Year;
          "Payroll Period" := dtOpenPeriod;
          "Department Code":=Department;
          "Journal Account Type":=JournalACType;
          "Post As":=PostAs;
          "Journal Account Code":=JournalAC;
           "Loan Number":=LoanNo;
           "coop parameters":=CoopParam;
           "Payroll Code":=PayrollType;
           //Paymode
           IF prSalCard.GET(EmpCode) THEN
              "Payment Mode":=prSalCard."Payment Mode";
          INSERT;
         //Update the prEmployee Transactions  with the Amount
         fnUpdateEmployeeTrans( "Employee Code","Transaction Code",Amount,"Period Month","Period Year","Payroll Period");
      END;
    END;

    PROCEDURE fnGetSpecialTransAmount@1102756003(strEmpCode@1102756000 : Code[20];intMonth@1102756001 : Integer;intYear@1102756002 : Integer;intSpecTransID@1102756003 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';blnCompDedc@1102756004 : Boolean) SpecialTransAmount : Decimal;
    VAR
      prEmployeeTransactions@1102756005 : Record 39004000;
      prTransactionCodes@1102756006 : Record 39003991;
      strExtractedFrml@1102756007 : Text[250];
    BEGIN
      SpecialTransAmount:=0;
      prTransactionCodes.RESET;
      prTransactionCodes.SETRANGE(prTransactionCodes."Special Transactions",intSpecTransID);
      IF prTransactionCodes.FIND('-') THEN BEGIN
      REPEAT
         prEmployeeTransactions.RESET;
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",strEmpCode);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
         IF prEmployeeTransactions.FIND('-') THEN BEGIN

          //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
          //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
            CASE intSpecTransID OF
              intSpecTransID::"Defined Contribution":
                IF prTransactionCodes."Is Formula" THEN BEGIN
                    strExtractedFrml := '';
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                    SpecialTransAmount := SpecialTransAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                END ELSE
                    SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;

              intSpecTransID::"Life Insurance":
                  SpecialTransAmount :=SpecialTransAmount+( (curReliefInsurance / 100) * prEmployeeTransactions.Amount);

      //
              intSpecTransID::"Owner Occupier Interest":
                    SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;


              intSpecTransID::"Home Ownership Savings Plan":
                    SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;

              intSpecTransID::Morgage:
                BEGIN
                  SpecialTransAmount :=SpecialTransAmount+ curReliefMorgage;

                  IF SpecialTransAmount > curReliefMorgage THEN
                   BEGIN
                    SpecialTransAmount:=curReliefMorgage
                   END;

                END;

            END;
         END;
       UNTIL prTransactionCodes.NEXT=0;
      END;
      SpecialTranAmount:=SpecialTransAmount;
    END;

    PROCEDURE fnGetEmployeePaye@1102756038(curTaxablePay@1102756000 : Decimal) PAYE : Decimal;
    VAR
      prPAYE@1102756001 : Record 39003985;
      curTempAmount@1102756002 : Decimal;
      KeepCount@1102756003 : Integer;
    BEGIN
      KeepCount:=0;
      prPAYE.RESET;
      IF prPAYE.FINDFIRST THEN BEGIN
      IF curTaxablePay < prPAYE."PAYE Tier" THEN EXIT;
      REPEAT
       KeepCount+=1;
       curTempAmount:= curTaxablePay;
       IF curTaxablePay = 0 THEN EXIT;
             IF KeepCount = prPAYE.COUNT THEN   //this is the last record or loop
                curTaxablePay := curTempAmount
              ELSE
                 IF curTempAmount >= prPAYE."PAYE Tier" THEN
                  curTempAmount := prPAYE."PAYE Tier"
                 ELSE
                   curTempAmount := curTempAmount;

      PAYE := PAYE + (curTempAmount * (prPAYE.Rate / 100));
      curTaxablePay := curTaxablePay - curTempAmount;

      UNTIL prPAYE.NEXT=0;
      END;
    END;

    PROCEDURE fnGetEmployeeNHIF@1102756053(curBaseAmount@1102756000 : Decimal) NHIF : Decimal;
    VAR
      prNHIF@1102756001 : Record 39003984;
    BEGIN
      prNHIF.RESET;
      prNHIF.SETCURRENTKEY(prNHIF."Tier Code");
      IF prNHIF.FINDFIRST THEN BEGIN
      REPEAT
      IF ((curBaseAmount>=prNHIF."Lower Limit") AND (curBaseAmount<=prNHIF."Upper Limit")) THEN
          NHIF:=prNHIF.Amount;
      UNTIL prNHIF.NEXT=0;
      END;
    END;

    PROCEDURE fnPureFormula@1102756005(strEmpCode@1102756000 : Code[20];intMonth@1102756001 : Integer;intYear@1102756002 : Integer;strFormula@1102756003 : Text[250]) Formula : Text[250];
    VAR
      Where@1102756005 : Text[30];
      Which@1102756004 : Text[30];
      i@1102756011 : Integer;
      TransCode@1102756009 : Code[20];
      Char@1102756008 : Text[1];
      FirstBracket@1102756007 : Integer;
      StartCopy@1102756006 : Boolean;
      FinalFormula@1102756010 : Text[250];
      TransCodeAmount@1102756012 : Decimal;
      AccSchedLine@1102756016 : Record 85;
      ColumnLayout@1102756015 : Record 334;
      CalcAddCurr@1102756014 : Boolean;
      AccSchedMgt@1102756013 : Codeunit 8;
    BEGIN
         TransCode:='';
         FOR i:=1 TO STRLEN(strFormula) DO BEGIN
         Char:=COPYSTR(strFormula,i,1);
         IF Char='[' THEN  StartCopy:=TRUE;

         IF StartCopy THEN TransCode:=TransCode+Char;
         //Copy Characters as long as is not within []
         IF NOT StartCopy THEN
            FinalFormula:=FinalFormula+Char;
         IF Char=']' THEN BEGIN
          StartCopy:=FALSE;
          //Get Transcode
            Where := '=';
            Which := '[]';
            TransCode := DELCHR(TransCode, Where, Which);
          //Get TransCodeAmount
          TransCodeAmount:=fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear);
          //Reset Transcode
           TransCode:='';
          //Get Final Formula
           FinalFormula:=FinalFormula+FORMAT(TransCodeAmount);
          //End Get Transcode
         END;
         END;
         Formula:=FinalFormula;
    END;

    PROCEDURE fnGetTransAmount@1102756004(strEmpCode@1102756000 : Code[20];strTransCode@1102756001 : Code[20];intMonth@1102756002 : Integer;intYear@1102756003 : Integer) TransAmount : Decimal;
    VAR
      prEmployeeTransactions@1102756004 : Record 39004000;
      prPeriodTransactions@1102756005 : Record 39004001;
    BEGIN
      prEmployeeTransactions.RESET;
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",strEmpCode);
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",strTransCode);
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
      IF prEmployeeTransactions.FINDFIRST THEN BEGIN

        TransAmount:=prEmployeeTransactions.Amount;
        IF prEmployeeTransactions."No of Units"<>0 THEN
           TransAmount:=prEmployeeTransactions."No of Units";

      END;
      IF TransAmount=0 THEN BEGIN
      prPeriodTransactions.RESET;
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Employee Code",strEmpCode);
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Transaction Code",strTransCode);
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Period Month",intMonth);
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Period Year",intYear);
      IF prPeriodTransactions.FINDFIRST THEN
        TransAmount:=prPeriodTransactions.Amount;
      END;
    END;

    PROCEDURE fnFormulaResult@1102756009(strFormula@1102756000 : Text[250]) Results : Decimal;
    VAR
      AccSchedLine@1102756004 : Record 85;
      ColumnLayout@1102756003 : Record 334;
      CalcAddCurr@1102756002 : Boolean;
      AccSchedMgt@1102756001 : Codeunit 8;
    BEGIN
      Results:=
      AccSchedMgt.EvaluateExpression(TRUE,strFormula,AccSchedLine,ColumnLayout,CalcAddCurr);
    END;

    PROCEDURE fnClosePayrollPeriod@1102756014(dtOpenPeriod@1102756000 : Date;PayrollCode@1102756015 : Code[20]) Closed : Boolean;
    VAR
      dtNewPeriod@1102756001 : Date;
      intNewMonth@1102756002 : Integer;
      intNewYear@1102756003 : Integer;
      prEmployeeTransactions@1102756005 : Record 39004000;
      prPeriodTransactions@1102756004 : Record 39004001;
      intMonth@1102756007 : Integer;
      intYear@1102756006 : Integer;
      prTransactionCodes@1102756008 : Record 39003991;
      curTransAmount@1102756009 : Decimal;
      curTransBalance@1102756010 : Decimal;
      prEmployeeTrans@1102756011 : Record 39004000;
      prPayrollPeriods@1102756012 : Record 39003990;
      prNewPayrollPeriods@1102756013 : Record 39003990;
      CreateTrans@1102756014 : Boolean;
      ControlInfo@1102756016 : Record 39004026;
    BEGIN
      ControlInfo.GET();
      dtNewPeriod := CALCDATE('1M', dtOpenPeriod);
      intNewMonth := DATE2DMY(dtNewPeriod,2);
      intNewYear := DATE2DMY(dtNewPeriod,3);

      intMonth := DATE2DMY(dtOpenPeriod,2);
      intYear := DATE2DMY(dtOpenPeriod,3);

      prEmployeeTransactions.RESET;
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);

      //Multiple Payroll
      IF ControlInfo."Multiple Payroll" THEN
          prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Payroll Code",PayrollCode);

      //prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",'KPSS091');


      IF prEmployeeTransactions.FIND('-') THEN BEGIN
        REPEAT
         prTransactionCodes.RESET;
         prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
         IF prTransactionCodes.FIND('-') THEN BEGIN
          WITH prTransactionCodes DO BEGIN
            CASE prTransactionCodes."Balance Type" OF
              prTransactionCodes."Balance Type"::None:
               BEGIN
                curTransAmount:= prEmployeeTransactions.Amount;
                curTransBalance:= 0;
               END;
              prTransactionCodes."Balance Type"::Increasing:
               BEGIN
                 curTransAmount := prEmployeeTransactions.Amount;
                 curTransBalance := prEmployeeTransactions.Balance + prEmployeeTransactions.Amount;
               END;
              prTransactionCodes."Balance Type"::Reducing:
               BEGIN
                 curTransAmount := prEmployeeTransactions.Amount;
                 IF prEmployeeTransactions.Balance < prEmployeeTransactions.Amount THEN BEGIN
                     curTransAmount := prEmployeeTransactions.Balance;
                     curTransBalance := 0;
                 END ELSE BEGIN
                     curTransBalance := prEmployeeTransactions.Balance - prEmployeeTransactions.Amount;
                 END;
                 IF curTransBalance < 0 THEN
                  BEGIN
                     curTransAmount:=0;
                     curTransBalance:=0;
                  END;
                END;
            END;
          END;
         END;

          //For those transactions with Start and End Date Specified
             IF (prEmployeeTransactions."Start Date"<>0D) AND (prEmployeeTransactions."End Date"<>0D) THEN BEGIN
                 IF prEmployeeTransactions."End Date"<dtNewPeriod THEN BEGIN
                     curTransAmount:=0;
                     curTransBalance:=0;
                 END;
             END;
          //End Transactions with Start and End Date

        IF (prTransactionCodes.Frequency=prTransactionCodes.Frequency::Fixed) AND
           (prEmployeeTransactions."Stop for Next Period"=FALSE) THEN //DENNO ADDED THIS TO CHECK FREQUENCY AND STOP IF MARKED
         BEGIN
          IF (curTransAmount <> 0) THEN  //Update the employee transaction table
           BEGIN
           IF ((prTransactionCodes."Balance Type"=prTransactionCodes."Balance Type"::Reducing) AND (curTransBalance <> 0)) OR
            (prTransactionCodes."Balance Type"<>prTransactionCodes."Balance Type"::Reducing) THEN
            prEmployeeTransactions.Balance:=curTransBalance;
            prEmployeeTransactions.MODIFY;


         //Insert record for the next period
          WITH prEmployeeTrans DO BEGIN
            INIT;
            "Employee Code":= prEmployeeTransactions."Employee Code";
            "Transaction Code":= prEmployeeTransactions."Transaction Code";
            "Transaction Name":= prEmployeeTransactions."Transaction Name";
             Amount:= curTransAmount;
             Balance:= curTransBalance;
             "Amortized Loan Total Repay Amt":=prEmployeeTransactions. "Amortized Loan Total Repay Amt";
            "Original Amount":= prEmployeeTransactions."Original Amount";
             Membership:= prEmployeeTransactions.Membership;
            "Reference No":= prEmployeeTransactions."Reference No";
            "Loan Number":=prEmployeeTransactions."Loan Number";
            "Period Month":= intNewMonth;
            "Period Year":= intNewYear;
            "Payroll Period":= dtNewPeriod;
            "Payroll Code" :=PayrollCode;
             INSERT;
           END;
        END;
        END
        UNTIL prEmployeeTransactions.NEXT=0;
      END;

      //Update the Period as Closed
      prPayrollPeriods.RESET;
      prPayrollPeriods.SETRANGE(prPayrollPeriods."Period Month",intMonth);
      prPayrollPeriods.SETRANGE(prPayrollPeriods."Period Year",intYear);
      prPayrollPeriods.SETRANGE(prPayrollPeriods.Closed,FALSE);
      IF ControlInfo."Multiple Payroll" THEN
          prPayrollPeriods.SETRANGE(prPayrollPeriods."Payroll Code",PayrollCode);

      IF prPayrollPeriods.FIND('-') THEN BEGIN
         prPayrollPeriods.Closed:=TRUE;
         prPayrollPeriods."Date Closed":=TODAY;
         prPayrollPeriods.MODIFY;
      END;

      //Enter a New Period
      WITH prNewPayrollPeriods DO BEGIN
        INIT;
          "Period Month":=intNewMonth;
          "Period Year":= intNewYear;
          "Period Name":= FORMAT(dtNewPeriod,0,'<Month Text>');//+' '+FORMAT(intNewYear);
          "Date Opened":= dtNewPeriod;
           Closed :=FALSE;
           "Payroll Code":=PayrollCode;
          INSERT;
      END;

      //Effect the transactions for the P9
      fnP9PeriodClosure (intMonth, intYear, dtOpenPeriod,PayrollCode);

      //Take all the Negative pay (Net) for the current month & treat it as a deduction in the new period
      fnGetNegativePay(intMonth, intYear,dtOpenPeriod);
    END;

    PROCEDURE fnGetNegativePay@1102756013(intMonth@1102756000 : Integer;intYear@1102756001 : Integer;dtOpenPeriod@1102756002 : Date);
    VAR
      prPeriodTransactions@1102756003 : Record 39004001;
      prEmployeeTransactions@1102756004 : Record 39004000;
      intNewMonth@1102756006 : Integer;
      intNewYear@1102756005 : Integer;
      dtNewPeriod@1102756007 : Date;
    BEGIN
      dtNewPeriod := CALCDATE('1M', dtOpenPeriod);
      intNewMonth := DATE2DMY(dtNewPeriod,2);
      intNewYear := DATE2DMY(dtNewPeriod,3);

      prPeriodTransactions.RESET;
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Period Month",intMonth);
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Period Year",intYear);
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Group Order",9);
      prPeriodTransactions.SETFILTER(prPeriodTransactions.Amount,'<0');

      IF prPeriodTransactions.FIND('-') THEN BEGIN
      REPEAT
        WITH  prEmployeeTransactions DO BEGIN
          INIT;
          "Employee Code":= prPeriodTransactions."Employee Code";
          "Transaction Code":= 'NEGP';
          "Transaction Name":='Negative Pay';
          Amount:= prPeriodTransactions.Amount;
          Balance:= 0;
          "Original Amount":=0;
          "Period Month":= intNewMonth;
          "Period Year":= intNewYear;
          "Payroll Period":=dtNewPeriod;
          INSERT;
        END;
      UNTIL prPeriodTransactions.NEXT=0;
      END;
    END;

    PROCEDURE fnP9PeriodClosure@1102756010(intMonth@1102756000 : Integer;intYear@1102756001 : Integer;dtCurPeriod@1102756002 : Date;PayrollCode@1102756022 : Code[20]);
    VAR
      P9EmployeeCode@1102756003 : Code[20];
      P9BasicPay@1102756004 : Decimal;
      P9Allowances@1102756005 : Decimal;
      P9Benefits@1102756006 : Decimal;
      P9ValueOfQuarters@1102756007 : Decimal;
      P9DefinedContribution@1102756008 : Decimal;
      P9OwnerOccupierInterest@1102756009 : Decimal;
      P9GrossPay@1102756010 : Decimal;
      P9TaxablePay@1102756011 : Decimal;
      P9TaxCharged@1102756012 : Decimal;
      P9InsuranceRelief@1102756013 : Decimal;
      P9TaxRelief@1102756014 : Decimal;
      P9Paye@1102756015 : Decimal;
      P9NSSF@1102756016 : Decimal;
      P9NHIF@1102756017 : Decimal;
      P9Deductions@1102756018 : Decimal;
      P9NetPay@1102756019 : Decimal;
      prPeriodTransactions@1102756020 : Record 39004001;
      prEmployee@1102756021 : Record 39003917;
    BEGIN
      P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
      P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
      P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
      P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
      P9Deductions := 0; P9NetPay := 0;

      prEmployee.RESET;
      prEmployee.SETRANGE(prEmployee.Status,prEmployee.Status::Active);
      IF prEmployee.FIND('-') THEN BEGIN
      REPEAT

      P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
      P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
      P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
      P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
      P9Deductions := 0; P9NetPay := 0;

      prPeriodTransactions.RESET;
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Period Month",intMonth);
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Period Year",intYear);
      prPeriodTransactions.SETRANGE(prPeriodTransactions."Employee Code",prEmployee."No.");
      IF prPeriodTransactions.FIND('-') THEN BEGIN
        REPEAT
        WITH prPeriodTransactions DO BEGIN
          CASE prPeriodTransactions."Group Order" OF
              1: //Basic pay & Arrears
              BEGIN
                IF "Sub Group Order" = 1 THEN P9BasicPay := Amount; //Basic Pay
                IF "Sub Group Order" = 2 THEN P9BasicPay := P9BasicPay + Amount; //Basic Pay Arrears
              END;
              3:  //Allowances
              BEGIN
               P9Allowances := P9Allowances + Amount
              END;
              4: //Gross Pay
              BEGIN
                P9GrossPay := Amount
              END;
              6: //Taxation
              BEGIN
                IF "Sub Group Order" = 1 THEN P9DefinedContribution := Amount; //Defined Contribution
                IF "Sub Group Order" = 9 THEN P9TaxRelief := Amount; //Tax Relief
                IF "Sub Group Order" = 8 THEN P9InsuranceRelief := Amount; //Insurance Relief
                IF "Sub Group Order" = 6 THEN P9TaxablePay := Amount; //Taxable Pay
                IF "Sub Group Order" = 7 THEN P9TaxCharged := Amount; //Tax Charged
              END;
              7: //Statutories
              BEGIN
                IF "Sub Group Order" = 1 THEN P9NSSF := Amount; //Nssf
                IF "Sub Group Order" = 2 THEN P9NHIF := Amount; //Nhif
                IF "Sub Group Order" = 3 THEN P9Paye := Amount; //paye
                IF "Sub Group Order" = 4 THEN P9Paye := P9Paye + Amount; //Paye Arrears
              END;
              8://Deductions
              BEGIN
                P9Deductions := P9Deductions + Amount;
              END;
              9: //NetPay
              BEGIN
                P9NetPay := Amount;
              END;
          END;
        END;
        UNTIL prPeriodTransactions.NEXT=0;
      END;
      //Update the P9 Details

      IF P9NetPay <> 0 THEN
       fnUpdateP9Table (prEmployee."No.", P9BasicPay, P9Allowances, P9Benefits, P9ValueOfQuarters, P9DefinedContribution,
           P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged, P9InsuranceRelief, P9TaxRelief, P9Paye, P9NSSF,
           P9NHIF, P9Deductions, P9NetPay, dtCurPeriod,PayrollCode);

      UNTIL prEmployee.NEXT=0;
      END;
    END;

    PROCEDURE fnUpdateP9Table@1102756011(P9EmployeeCode@1102756016 : Code[20];P9BasicPay@1102756015 : Decimal;P9Allowances@1102756014 : Decimal;P9Benefits@1102756013 : Decimal;P9ValueOfQuarters@1102756012 : Decimal;P9DefinedContribution@1102756011 : Decimal;P9OwnerOccupierInterest@1102756010 : Decimal;P9GrossPay@1102756009 : Decimal;P9TaxablePay@1102756008 : Decimal;P9TaxCharged@1102756007 : Decimal;P9InsuranceRelief@1102756006 : Decimal;P9TaxRelief@1102756005 : Decimal;P9Paye@1102756004 : Decimal;P9NSSF@1102756003 : Decimal;P9NHIF@1102756002 : Decimal;P9Deductions@1102756001 : Decimal;P9NetPay@1102756000 : Decimal;dtCurrPeriod@1102756017 : Date;prPayrollCode@1102756021 : Code[20]);
    VAR
      prEmployeeP9Info@1102756018 : Record 39004002;
      intYear@1102756019 : Integer;
      intMonth@1102756020 : Integer;
    BEGIN
      intMonth := DATE2DMY(dtCurrPeriod,2);
      intYear := DATE2DMY(dtCurrPeriod,3);

      prEmployeeP9Info.RESET;
      WITH prEmployeeP9Info DO BEGIN
          INIT;
          "Employee Code":= P9EmployeeCode;
          "Basic Pay":= P9BasicPay;
          Allowances:= P9Allowances;
          Benefits:= P9Benefits;
          "Value Of Quarters":= P9ValueOfQuarters;
          "Defined Contribution":= P9DefinedContribution;
          "Owner Occupier Interest":= P9OwnerOccupierInterest;
          "Gross Pay":= P9GrossPay;
          "Taxable Pay":= P9TaxablePay;
          "Tax Charged":= P9TaxCharged;
          "Insurance Relief":= P9InsuranceRelief;
          "Tax Relief":= P9TaxRelief;
          PAYE:= P9Paye;
          NSSF:= P9NSSF;
          NHIF:= P9NHIF;
          Deductions:= P9Deductions;
          "Net Pay":= P9NetPay;
          "Period Month":= intMonth;
          "Period Year":= intYear;
          "Payroll Period":= dtCurrPeriod;
          "Payroll Code":=prPayrollCode;
          INSERT;
      END;
    END;

    PROCEDURE fnDaysWorked@1102756012(dtDate@1102756000 : Date;IsTermination@1102756006 : Boolean) DaysWorked : Integer;
    VAR
      Day@1102756001 : Integer;
      SysDate@1102756005 : Record 2000000007;
      Expr1@1102756004 : Text[30];
      FirstDay@1102756003 : Date;
      LastDate@1102756002 : Date;
      TodayDate@1102756007 : Date;
    BEGIN
      TodayDate:=dtDate;

       Day:=DATE2DMY(TodayDate,1);
       Expr1:=FORMAT(-Day)+'D+1D';
       FirstDay:=CALCDATE(Expr1,TodayDate);
       LastDate:=CALCDATE('1M-1D',FirstDay);

       SysDate.RESET;
       SysDate.SETRANGE(SysDate."Period Type",SysDate."Period Type"::Date);
       IF NOT IsTermination THEN
        SysDate.SETRANGE(SysDate."Period Start",dtDate,LastDate)
       ELSE
        SysDate.SETRANGE(SysDate."Period Start",FirstDay,dtDate);
       // SysDate.SETFILTER(SysDate."Period No.",'1..5');
       IF SysDate.FIND('-') THEN
          DaysWorked:=SysDate.COUNT;
    END;

    PROCEDURE fnSalaryArrears@1102756015(EmpCode@1102756000 : Text[30];TransCode@1102756001 : Text[30];CBasic@1102756002 : Decimal;StartDate@1102756003 : Date;EndDate@1102756004 : Date;dtOpenPeriod@1102756020 : Date;dtDOE@1102756023 : Date;dtTermination@1102756024 : Date);
    VAR
      FirstMonth@1102756005 : Boolean;
      startmonth@1102756006 : Integer;
      startYear@1102756007 : Integer;
      "prEmployee P9 Info"@1102756008 : Record 39004002;
      P9BasicPay@1102756009 : Decimal;
      P9taxablePay@1102756010 : Decimal;
      P9PAYE@1102756011 : Decimal;
      ProratedBasic@1102756012 : Decimal;
      SalaryArrears@1102756013 : Decimal;
      SalaryVariance@1102756014 : Decimal;
      SupposedTaxablePay@1102756015 : Decimal;
      SupposedTaxCharged@1102756016 : Decimal;
      SupposedPAYE@1102756017 : Decimal;
      PAYEVariance@1102756018 : Decimal;
      PAYEArrears@1102756019 : Decimal;
      PeriodMonth@1102756021 : Integer;
      PeriodYear@1102756022 : Integer;
      CountDaysofMonth@1102756025 : Integer;
      DaysWorked@1102756026 : Integer;
    BEGIN
      fnInitialize;

      FirstMonth := TRUE;
      IF EndDate>StartDate THEN
       BEGIN
        WHILE StartDate < EndDate DO
         BEGIN
          //fnGetEmpP9Info
            startmonth:=DATE2DMY(StartDate,2);
            startYear:=DATE2DMY(StartDate,3);

            "prEmployee P9 Info".RESET;
            "prEmployee P9 Info".SETRANGE("prEmployee P9 Info"."Employee Code",EmpCode);
            "prEmployee P9 Info".SETRANGE("prEmployee P9 Info"."Period Month",startmonth);
            "prEmployee P9 Info".SETRANGE("prEmployee P9 Info"."Period Year",startYear);
            IF "prEmployee P9 Info".FIND('-') THEN
             BEGIN
              P9BasicPay:="prEmployee P9 Info"."Basic Pay";
              P9taxablePay:="prEmployee P9 Info"."Taxable Pay";
              P9PAYE:="prEmployee P9 Info".PAYE;

              IF P9BasicPay > 0 THEN   //Staff payment history is available
               BEGIN
                IF FirstMonth THEN
                 BEGIN                 //This is the first month in the arrears loop
                  IF DATE2DMY(StartDate,1) <> 1 THEN //if the date doesn't start on 1st, we have to prorate the salary
                   BEGIN
                  //ProratedBasic := ProratePay.fnProratePay(P9BasicPay, CBasic, StartDate); ********
                //Get the Basic Salary (prorate basic pay if needed) //Termination Remaining
                IF (DATE2DMY(dtDOE,2)=DATE2DMY(StartDate,2)) AND (DATE2DMY(dtDOE,3)=DATE2DMY(StartDate,3))THEN BEGIN
                    CountDaysofMonth:=fnDaysInMonth(dtDOE);
                    DaysWorked:=fnDaysWorked(dtDOE,FALSE);
                    ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay,DaysWorked,CountDaysofMonth)
                END;

                //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                IF dtTermination<>0D THEN BEGIN
                IF (DATE2DMY(dtTermination,2)=DATE2DMY(StartDate,2)) AND (DATE2DMY(dtTermination,3)=DATE2DMY(StartDate,3))THEN BEGIN
                    CountDaysofMonth:=fnDaysInMonth(dtTermination);
                    DaysWorked:=fnDaysWorked(dtTermination,TRUE);
                    ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay,DaysWorked,CountDaysofMonth)
                END;
              END;

                       SalaryArrears := (CBasic - ProratedBasic)
                   END
                 ELSE
                   BEGIN
                      SalaryArrears := (CBasic - P9BasicPay);
                   END;
               END;
               SalaryVariance := SalaryVariance + SalaryArrears;
               SupposedTaxablePay := P9taxablePay + SalaryArrears;

               //To calc paye arrears, check if the Supposed Taxable Pay is > the taxable pay for the loop period
               IF SupposedTaxablePay > P9taxablePay THEN
                BEGIN
                     SupposedTaxCharged := fnGetEmployeePaye(SupposedTaxablePay);
                     SupposedPAYE := SupposedTaxCharged - curReliefPersonal;
                     PAYEVariance := SupposedPAYE - P9PAYE;
                     PAYEArrears := PAYEArrears + PAYEVariance ;
                END;
               FirstMonth := FALSE;               //reset the FirstMonth Boolean to False
             END;
           END;
            StartDate :=CALCDATE('+1M',StartDate);
         END;
       IF SalaryArrears <> 0 THEN
         BEGIN
         PeriodYear:=DATE2DMY(dtOpenPeriod,3);
         PeriodMonth:=DATE2DMY(dtOpenPeriod,2);
          fnUpdateSalaryArrears(EmpCode,TransCode,StartDate,EndDate,SalaryArrears, PAYEArrears,PeriodMonth,PeriodYear,
          dtOpenPeriod);
         END

       END
      ELSE
       ERROR('The start date must be earlier than the end date');
    END;

    PROCEDURE fnUpdateSalaryArrears@1102756002(EmployeeCode@1102756000 : Text[50];TransCode@1102756001 : Text[50];OrigStartDate@1102756002 : Date;EndDate@1102756003 : Date;SalaryArrears@1102756004 : Decimal;PayeArrears@1102756005 : Decimal;intMonth@1102756006 : Integer;intYear@1102756007 : Integer;payperiod@1102756008 : Date);
    VAR
      FirstMonth@1102756024 : Boolean;
      ProratedBasic@1102756022 : Decimal;
      SalaryVariance@1102756021 : Decimal;
      PayeVariance@1102756018 : Decimal;
      SupposedTaxablePay@1102756017 : Decimal;
      SupposedTaxCharged@1102756016 : Decimal;
      SupposedPaye@1102756015 : Decimal;
      CurrentBasic@1102756012 : Decimal;
      StartDate@1102756011 : Date;
      "prSalary Arrears"@1102756009 : Record 39003997;
    BEGIN
       "prSalary Arrears".RESET;
       "prSalary Arrears".SETRANGE("prSalary Arrears"."Employee Code",EmployeeCode);
       "prSalary Arrears".SETRANGE("prSalary Arrears"."Transaction Code",TransCode);
       "prSalary Arrears".SETRANGE("prSalary Arrears"."Period Month",intMonth);
       "prSalary Arrears".SETRANGE("prSalary Arrears"."Period Year",intYear);
       IF "prSalary Arrears".FIND('-')=FALSE THEN
       BEGIN
          "prSalary Arrears".INIT;
          "prSalary Arrears"."Employee Code" := EmployeeCode;
          "prSalary Arrears"."Transaction Code" := TransCode;
          "prSalary Arrears"."Start Date" := OrigStartDate;
          "prSalary Arrears"."End Date" := EndDate;
          "prSalary Arrears"."Salary Arrears" := SalaryArrears;
          "prSalary Arrears"."PAYE Arrears" := PayeArrears;
          "prSalary Arrears"."Period Month" := intMonth;
          "prSalary Arrears"."Period Year" := intYear;
          "prSalary Arrears"."Payroll Period" := payperiod;
          "prSalary Arrears".INSERT;
       END
    END;

    PROCEDURE fnCalcLoanInterest@1102756027(strEmpCode@1102756000 : Code[20];strTransCode@1102756001 : Code[20];InterestRate@1102756002 : Decimal;RecoveryMethod@1102756003 : 'Reducing,Straight line,Amortized';LoanAmount@1102756004 : Decimal;Balance@1102756005 : Decimal;CurrPeriod@1102756007 : Date;Welfare@1102756010 : Boolean;LoanNumber@1000 : Code[10]) LnInterest : Decimal;
    VAR
      curLoanInt@1102756006 : Decimal;
      intMonth@1102756008 : Integer;
      intYear@1102756009 : Integer;
    BEGIN
      {
      intMonth := DATE2DMY(CurrPeriod,2);
      intYear := DATE2DMY(CurrPeriod,3);
      curLoanInt := 0;
      IF InterestRate > 0 THEN BEGIN
          IF RecoveryMethod = RecoveryMethod::"Straight line" THEN //Straight Line Method [1]
               curLoanInt := (InterestRate / 1200) * LoanAmount;
          IF RecoveryMethod = RecoveryMethod::Reducing THEN //Reducing Balance [0]
               curLoanInt := (InterestRate / 1200) * Balance;
          IF RecoveryMethod = RecoveryMethod::Amortized THEN //Amortized [2]
               curLoanInt := (InterestRate / 1200) * Balance;
      END ELSE
          curLoanInt := 0;
      //Return the Amount
      LnInterest:=ROUND(curLoanInt,1);
      }


      intMonth := DATE2DMY(CurrPeriod,2);
      intYear := DATE2DMY(CurrPeriod,3);

      curLoanInt := 0;

      IF InterestRate > 0 THEN BEGIN

          Loans.RESET;
          Loans.SETRANGE(Loans."Staff No",strEmpCode);
          Loans.SETRANGE(Loans."Loan  No.",LoanNumber);
          IF Loans.FIND('-') THEN BEGIN
          REPEAT
          Loans.CALCFIELDS(Loans."Oustanding Interest");
           curLoanInt :=Loans."Oustanding Interest";
           //-- MESSAGE('StaffNo: %1 LoanNo: %2 IntBal: %3',strEmpCode,LoanNumber,Loans."Oustanding Interest");
           UNTIL Loans.NEXT =0;
          END;
       END;

          {IF RecoveryMethod = RecoveryMethod::"Straight line" THEN BEGIN
          Loans.RESET;
          Loans.SETRANGE(Loans."Client Code",strEmpCode);
          Loans.SETRANGE(Loans."Loan  No.",LoanNumber);
          IF Loans.FIND('-') THEN BEGIN
          Loans.CALCFIELDS(Loans."Oustanding Interest");
               curLoanInt :=Loans."Oustanding Interest";
          END;
          END ELSE
          IF RecoveryMethod = RecoveryMethod::Reducing THEN BEGIN //Reducing Balance [0]
          Loans.RESET;
          Loans.SETRANGE(Loans."Staff No",strEmpCode);
          Loans.SETRANGE(Loans."Loan  No.",LoanNumber);
          IF Loans.FIND('-') THEN BEGIN
          //--END;
          Loans.CALCFIELDS(Loans."Oustanding Interest");
               curLoanInt :=Loans."Oustanding Interest";
          END;
          END ELSE
          IF RecoveryMethod = RecoveryMethod::Amortized THEN BEGIN //Amortized [2]
          Loans.RESET;
          Loans.SETRANGE(Loans."Staff No",strEmpCode);
          Loans.SETRANGE(Loans."Loan  No.",LoanNumber);
          IF Loans.FIND('-') THEN BEGIN
          Loans.CALCFIELDS(Loans."Oustanding Interest");
            curLoanInt :=Loans."Oustanding Interest";
             //--MESSAGE('StaffNo: %1 LoanNo: %2 IntBal: %3',strEmpCode,LoanNumber,Loans."Oustanding Interest");
          END; END;
          END ELSE
          curLoanInt := 0; }

      //Return the Amount
      LnInterest:=ROUND(curLoanInt,1);
    END;

    PROCEDURE fnUpdateEmployerDeductions@1102756017(EmpCode@1102756000 : Code[20];TCode@1102756001 : Code[20];TGroup@1102756002 : Code[20];GroupOrder@1102756003 : Integer;SubGroupOrder@1102756004 : Integer;Description@1102756005 : Text[50];curAmount@1102756006 : Decimal;curBalance@1102756007 : Decimal;Month@1102756008 : Integer;Year@1102756009 : Integer;mMembership@1102756010 : Text[30];ReferenceNo@1102756011 : Text[30];dtOpenPeriod@1102756013 : Date);
    VAR
      prEmployerDeductions@1102756012 : Record 39004003;
    BEGIN

      IF curAmount = 0 THEN EXIT;
      WITH prEmployerDeductions DO BEGIN
          INIT;
          "Employee Code" := EmpCode;
          "Transaction Code" := TCode;
           Amount := curAmount;
          "Period Month" := Month;
          "Period Year" := Year;
          "Payroll Period" := dtOpenPeriod;
          INSERT;
      END;
    END;

    PROCEDURE fnDisplayFrmlValues@1102756016(EmpCode@1102756000 : Code[30];intMonth@1102756001 : Integer;intYear@1102756002 : Integer;Formula@1102756003 : Text[50]) curTransAmount : Decimal;
    VAR
      pureformula@1102756004 : Text[50];
    BEGIN
         pureformula := fnPureFormula(EmpCode, intMonth, intYear, Formula);
         curTransAmount := fnFormulaResult(pureformula); //Get the calculated amount
    END;

    PROCEDURE fnUpdateEmployeeTrans@1102756029(EmpCode@1102756000 : Code[20];TransCode@1102756001 : Code[20];Amount@1102756002 : Decimal;Month@1102756003 : Integer;Year@1102756004 : Integer;PayrollPeriod@1102756005 : Date);
    VAR
      prEmployeeTrans@1102756006 : Record 39004000;
    BEGIN
         prEmployeeTrans.RESET;
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Employee Code",EmpCode);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Transaction Code",TransCode);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Payroll Period",PayrollPeriod);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Period Month",Month);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Period Year",Year);
         IF prEmployeeTrans.FIND('-') THEN BEGIN
           prEmployeeTrans.Amount:=Amount;
           prEmployeeTrans.MODIFY;
         END;
    END;

    PROCEDURE fnGetJournalDet@1102756018(strEmpCode@1102756000 : Code[20]);
    VAR
      SalaryCard@1102756001 : Record 39003917;
    BEGIN
      //Get Payroll Posting Accounts
      IF SalaryCard.GET(strEmpCode) THEN BEGIN
      IF PostingGroup.GET(SalaryCard."Posting Group") THEN
       BEGIN
         //Comment This for the Time Being

         PostingGroup.TESTFIELD("Salary Account");
         PostingGroup.TESTFIELD("Income Tax Account");
         PostingGroup.TESTFIELD("Net Salary Payable");
         PostingGroup.TESTFIELD("NSSF Employer Account");
         PostingGroup.TESTFIELD("Pension Employer Acc");

        TaxAccount:=PostingGroup."Income Tax Account";
        salariesAcc:=PostingGroup."Salary Account";
        PayablesAcc:=PostingGroup."Net Salary Payable";
       // PayablesAcc:=SalaryCard."Bank Account Number";
        NSSFEMPyer:= PostingGroup."NSSF Employer Account";
        NSSFEMPyee:= PostingGroup."NSSF Employee Account";
        NHIFEMPyee:=PostingGroup."NHIF Employee Account";
      NHIFEMPyee:=PostingGroup."NHIF Payable Acc";

        PensionEMPyer:=PostingGroup."Pension Employer Acc";

        //TelTaxACC:=PostingGroup."Telephone Tax Acc";
       END ELSE BEGIN
       ERROR('Please specify Posting Group in Employee No.  '+strEmpCode);
       END;
      END;
      //End Get Payroll Posting Accounts
    END;

    PROCEDURE fnGetSpecialTransAmount2@1102755006(strEmpCode@1102756000 : Code[20];intMonth@1102756001 : Integer;intYear@1102756002 : Integer;intSpecTransID@1102756003 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';blnCompDedc@1102756004 : Boolean);
    VAR
      prEmployeeTransactions@1102756005 : Record 39004000;
      prTransactionCodes@1102756006 : Record 39003991;
      strExtractedFrml@1102756007 : Text[250];
    BEGIN
      SpecialTranAmount:=0;
      prTransactionCodes.RESET;
      prTransactionCodes.SETRANGE(prTransactionCodes."Special Transactions",intSpecTransID);
      IF prTransactionCodes.FIND('-') THEN BEGIN
      REPEAT
         prEmployeeTransactions.RESET;
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",strEmpCode);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
         IF prEmployeeTransactions.FIND('-') THEN BEGIN

          //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
          //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
            CASE intSpecTransID OF
              intSpecTransID::"Defined Contribution":
                IF prTransactionCodes."Is Formula" THEN BEGIN
                    strExtractedFrml := '';
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                    SpecialTranAmount := SpecialTranAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                END ELSE
                    SpecialTranAmount := SpecialTranAmount+prEmployeeTransactions.Amount;

              intSpecTransID::"Life Insurance":
                  SpecialTranAmount :=SpecialTranAmount+( (curReliefInsurance / 100) * prEmployeeTransactions.Amount);

      //
              intSpecTransID::"Owner Occupier Interest":
                    SpecialTranAmount := SpecialTranAmount+prEmployeeTransactions.Amount;


              intSpecTransID::"Home Ownership Savings Plan":
                    SpecialTranAmount := SpecialTranAmount+prEmployeeTransactions.Amount;

              intSpecTransID::Morgage:
                BEGIN
                  SpecialTranAmount :=SpecialTranAmount+ curReliefMorgage;

                  IF SpecialTranAmount > curReliefMorgage THEN
                   BEGIN
                    SpecialTranAmount:=curReliefMorgage
                   END;

                END;

            END;
         END;
       UNTIL prTransactionCodes.NEXT=0;
      END;
    END;

    PROCEDURE fnCheckPaysPension@1102755000(pnEmpCode@1102755000 : Code[20];pnPayperiod@1102755003 : Date) PaysPens : Boolean;
    VAR
      pnTranCode@1102755001 : Record 51516181;
      pnEmpTrans@1102755002 : Record 51516182;
    BEGIN
           PaysPens:=FALSE;
           pnEmpTrans.RESET;
           pnEmpTrans.SETRANGE(pnEmpTrans."Employee Code",pnEmpCode);
           pnEmpTrans.SETRANGE(pnEmpTrans."Payroll Period",pnPayperiod);
            IF pnEmpTrans.FIND('-') THEN BEGIN
            REPEAT
            IF pnTranCode.GET(pnEmpTrans."Transaction Code") THEN
            IF pnTranCode."coop parameters"=pnTranCode."coop parameters"::Pension THEN
            PaysPens:=TRUE;
            UNTIL pnEmpTrans.NEXT=0;
            END;
    END;

    BEGIN
    {
      ++Note
      Tax on Excess Pension Not Clear /Not indicated anywhere
      Low Interest Benefits
      VOQ
    }
    END.
  }
}

