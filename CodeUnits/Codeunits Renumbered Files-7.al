OBJECT CodeUnit 20371 Payroll Management
{
  OBJECT-PROPERTIES
  {
    Date=08/23/23;
    Time=[ 6:14:05 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
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
      VitalSetup@1102756020 : Record 51516219;
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
      PostingGroup@1102756029 : Record 51516187;
      TaxAccount@1102756028 : Code[20];
      salariesAcc@1102756027 : Code[20];
      PayablesAcc@1102756026 : Code[20];
      NSSFEMPyer@1102756025 : Code[20];
      PensionEMPyer@1102756024 : Code[20];
      NSSFEMPyee@1102756023 : Code[20];
      NHIFEMPyer@1102756022 : Code[20];
      NHIFEMPyee@1102756021 : Code[20];
      HrEmployee@1102756030 : Record 51516160;
      CoopParameters@1102756031 : 'none,shares,loan,loan Interest,Emergency loan,Emergency loan Interest,School Fees loan,School Fees loan Interest,Welfare,Pension,NSSF,Overtime,DevShare,NHIF';
      PayrollType@1102756032 : Code[20];
      SpecialTranAmount@1102755000 : Decimal;
      EmpSalary@1102755001 : Record 51516180;
      txBenefitAmt@1102755002 : Decimal;
      TelTaxACC@1000000000 : Code[20];
      PensionEmployer@1000000001 : Decimal;
      Hollawance@1000000002 : Decimal;
      GlobalBasicAmount@1000000003 : Decimal;
      PayrollSetup@1120054000 : Integer;
      PayrollGeneralSetup@1120054001 : Record 51516219;
      NHIFReliefAmount@1120054002 : Decimal;
      LoanInterest@1120054003 : Decimal;
      Members@1120054004 : Record 51516223;

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
      prPeriodTransactions@1102756033 : Record 51516183;
      intYear@1102756034 : Integer;
      intMonth@1102756035 : Integer;
      LeapYear@1102756036 : Boolean;
      CountDaysofMonth@1102756037 : Integer;
      DaysWorked@1102756038 : Integer;
      prSalaryArrears@1102756041 : Record 51516188;
      prEmployeeTransactions@1102756042 : Record 51516182;
      prTransactionCodes@1102756043 : Record 51516181;
      strExtractedFrml@1102756044 : Text[250];
      SpecialTransType@1102756045 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';
      TransactionType@1102756046 : 'Income,Deduction';
      curPensionCompany@1102756047 : Decimal;
      curTaxOnExcessPension@1102756048 : Decimal;
      prUnusedRelief@1102756049 : Record 51516186;
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
      prEmployerDeductions@1102756063 : Record 51516190;
      JournalPostingType@1102756065 : ' ,G/L Account,Customer,Vendor';
      JournalAcc@1102756066 : Code[20];
      Customer@1102756067 : Record 51516223;
      JournalPostAs@1102756068 : ' ,Debit,Credit';
      IsCashBenefit@1102756070 : Decimal;
      Teltax@1000000000 : Decimal;
      Teltax2@1000000001 : Decimal;
      prEmployeeTransactions2@1000000002 : Record 51516182;
      prTransactionCodes3@1000000003 : Record 51516181;
      curTransAmount2@1000000004 : Decimal;
      TransCode@1000000005 : Code[100];
      FosaAcc@1120054000 : Record 23;
      Deductions@1120054001 : Record 51516181;
    BEGIN


      //Initialize
      fnInitialize;
      fnGetJournalDet(strEmpCode);

      //PayrollType
      PayrollType:=PayrollCode;

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
       GlobalBasicAmount:=curBasicPay;
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
       prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
       prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
       prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
       prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
       IF prEmployeeTransactions.FIND('-') THEN BEGIN
         curTotAllowances:= 0;
         IsCashBenefit:=0;
         REPEAT
           prTransactionCodes.RESET;
           prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
           prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Type",prTransactionCodes."Transaction Type"::Income);
           prTransactionCodes.SETRANGE(prTransactionCodes."Special Transaction",prTransactionCodes."Special Transaction"::Ignore);
           IF prTransactionCodes.FIND('-') THEN BEGIN
             curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';
             IF prTransactionCodes."Is Formulae" THEN BEGIN
                 strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formulae);
                 curTransAmount := ROUND(fnFormulaResult(strExtractedFrml)); //Get the calculated amount

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
               IF (NOT prTransactionCodes.Taxable) AND (prTransactionCodes."Special Transaction" =
               prTransactionCodes."Special Transaction"::Ignore) THEN
                   curNonTaxable:=curNonTaxable+curTransAmount;


               //Added to ensure special transaction that are not taxable are not inlcuded in list of Allowances
               IF (NOT prTransactionCodes.Taxable) AND (prTransactionCodes."Special Transaction" <>
               prTransactionCodes."Special Transaction"::Ignore) THEN
                  curTransAmount:=0;


               curTotAllowances := curTotAllowances + curTransAmount; //Sum-up all the allowances
               curTransAmount := curTransAmount;
               curTransBalance := curTransBalance;
               strTransDescription := prTransactionCodes."Transaction Name";
               TGroup := 'ALLOWANCE'; TGroupOrder := 3; TSubGroupOrder := 0;

               //Get the posting Details
               JournalPostingType:=JournalPostingType::" ";JournalAcc:='';
               IF prTransactionCodes.SubLedger<>prTransactionCodes.SubLedger::" " THEN BEGIN
                  IF prTransactionCodes.SubLedger=prTransactionCodes.SubLedger::Customer THEN BEGIN
                      HrEmployee.GET(strEmpCode);
                      Customer.RESET;
                      Customer.SETRANGE(Customer."Payroll/Staff No",HrEmployee."No.");
                      IF Customer.FIND('-') THEN BEGIN
                         JournalAcc:=Customer."No.";
                         //MESSAGE('%1',JournalAcc);
                         JournalPostingType:=JournalPostingType::Customer;
                      END;
                  END;
               END ELSE BEGIN
                  JournalAcc:=prTransactionCodes."G/L Account";
                  JournalPostingType:=JournalPostingType::"G/L Account";
               END;

                //Get is Cash Benefits
                IF prTransactionCodes."Is Cash" THEN
                     IsCashBenefit:=IsCashBenefit+curTransAmount;
               //End posting Details

                          fnUpdatePeriodTrans(strEmpCode,prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
               strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,prEmployeeTransactions.Membership,
               prEmployeeTransactions."Reference No",SelectedPeriod,Dept,JournalAcc,JournalPostAs::Debit,JournalPostingType,'',
               prTransactionCodes."Co-Op Parameters");

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
      //Housing Levy
      Deductions.RESET;
      Deductions.SETRANGE(Deductions."Is Housing Levy",TRUE);

      IF Deductions.FINDFIRST THEN BEGIN
        prEmployeeTransactions.RESET;  //==
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",Deductions."Transaction Code");
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
        IF prEmployeeTransactions.FIND('-') THEN BEGIN
         // MESSAGE('Here');
        prEmployeeTransactions.DELETE;
      END;
        prEmployeeTransactions.RESET;  //==
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",Deductions."Transaction Code");
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
        IF NOT prEmployeeTransactions.FIND('-') THEN BEGIN
        prEmployeeTransactions.INIT;
        prEmployeeTransactions."No.":=strEmpCode;
        prEmployeeTransactions."Period Month":=intMonth;
        prEmployeeTransactions."Period Year":=intYear;
        prEmployeeTransactions."Transaction Code":=Deductions."Transaction Code";
        prEmployeeTransactions."Transaction Name":=Deductions."Transaction Name";
        prEmployeeTransactions.Amount:=((Deductions."Housing Levy%"/100)*curGrossPay);
        prEmployeeTransactions."Amount(LCY)":=((Deductions."Housing Levy%"/100)*curGrossPay);
        prEmployeeTransactions."Transaction Type":=prEmployeeTransactions."Transaction Type"::Deduction;
        prEmployeeTransactions.INSERT;

      END;




      END;


      //Housing Levy
       //Get the NSSF amount
       IF blnPaysNssf THEN
         //curNSSF := curNssfEmployee;
         //MESSAGE('hERE%1',curGrossPay);
       curNSSF:=FnCalculateEmployeeNSSF(curGrossPay);
       curTransAmount := curNSSF;
       strTransDescription := 'N.S.S.F';

       TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 1;
       fnUpdatePeriodTrans (strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
       strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,NSSFEMPyee,
       JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::NSSF);


      //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
       curDefinedContrib :=curNSSF; //(curNSSF + curPensionStaff + curNonTaxable); //- curMorgageReliefAmount //
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
      // if get relief is ticked  - MUTINDA ADDED
      IF blnGetsPAYERelief THEN
      BEGIN
        //MESSAGE('Currelief%1CurUnusedrelief%2STaff%3',curReliefPersonal,curUnusedRelief,strEmpCode);
       curReliefPersonal := curReliefPersonal + curUnusedRelief; //*****Get curUnusedRelief
       curTransAmount := curReliefPersonal;
       strTransDescription := 'Personal Relief';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 9;

       fnUpdatePeriodTrans (strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
        CoopParameters::none);
      END ;
      //ELSE
      // curReliefPersonal := 0;

      //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       //>Pension Contribution [self] relief
       curPensionStaff := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
       SpecialTransType::"Defined Contribution",FALSE) ;//Self contrib Pension is 1 on [Special Transaction]
       IF curPensionStaff > 0 THEN BEGIN
          //MESSAGE('Staff%1Contribution%2',strEmpCode,curPensionStaff);
           IF curPensionStaff > curMaxPensionContrib THEN
               curTransAmount :=curMaxPensionContrib
           ELSE
               curTransAmount :=curPensionStaff;
           //MESSAGE('pension is %1',curPensionStaff);
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
        SpecialTranAmount:=0;
        curInsuranceReliefAmount:=fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
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
      IF curNonTaxable>3499 THEN BEGIN
                  Teltax:=0;
                  Teltax2:=0;

                  Teltax:=curNonTaxable*0.3;
                  Teltax2:=Teltax*0.3;
                  //curTransAmount := Teltax2;
                  //MESSAGE('The telephone tax is %1',Teltax2);


            strTransDescription := 'Telephone Tax';
            TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 5;
            fnUpdatePeriodTrans (strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            Teltax2, 0, intMonth, intYear,'','',SelectedPeriod,Dept,TelTaxACC,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',
            CoopParameters::none);
      END;

      {
      IF curNonTaxable>0 THEN BEGIN
            strTransDescription := 'Other Non-Taxable Benefits';
            TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 5;
            fnUpdatePeriodTrans (strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            curNonTaxable, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
            CoopParameters::none);
      END;
      }

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
               strTransDescription := 'Excess Pension Employee';
               TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 5;
               fnUpdatePeriodTrans (strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                intMonth,intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',CoopParameters::none);

               curTaxOnExcessPension := (curRateTaxExPension / 100) * curExcessPension;
               curTransAmount := curTaxOnExcessPension;
               strTransDescription := 'Tax on ExPension Employee';
               TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 6;
               fnUpdatePeriodTrans (strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                intMonth,intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',CoopParameters::none);

               strTransDescription := 'Tax on ExPension Employer';
               TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 6;
               fnUpdatePeriodTrans (strEmpCode, 'TXEP2', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, 65780, 0,
                intMonth,intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',CoopParameters::none);


           END;
       END;

       }
       //Get the Taxable amount for calculation of PAYE
       //>prTaxablePay = (GrossTaxable - SalaryArrears) - (TheDefinedToPost + curSelfPensionContrb + MorgageRelief)


        //Add HOSP and MORTGAGE {}
       IF curPensionStaff > curMaxPensionContrib THEN
         curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curMaxPensionContrib+curOOI+curHOSP+curNonTaxable)

       ELSE
           curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curPensionStaff+curOOI+curHOSP+curNonTaxable);
      //Taxable Benefit
      txBenefitAmt:=0;
      IF EmpSalary.GET(strEmpCode) THEN BEGIN
      IF EmpSalary."Pays NSSF"=FALSE THEN BEGIN
      IF fnCheckPaysPension(strEmpCode,SelectedPeriod)= TRUE THEN BEGIN
      IF (EmpSalary."Basic Pay"*0.1) >20000 THEN BEGIN
       txBenefitAmt := EmpSalary."Basic Pay"*0.2;
      END ELSE BEGIN
       txBenefitAmt := ((EmpSalary."Basic Pay"*0.2)+(EmpSalary."Basic Pay"*0.1))-20000;
       IF txBenefitAmt<0 THEN
          txBenefitAmt:=0;
      END;
       strTransDescription := 'Taxable Pension';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 6;
       fnUpdatePeriodTrans (strEmpCode, 'TXBB', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        txBenefitAmt, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
        CoopParameters::none);
       END;
      END;
      END;
       curTransAmount := curTaxablePay+txBenefitAmt;
       strTransDescription := 'Taxable Pay';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 6;
       fnUpdatePeriodTrans (strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
        CoopParameters::none);
      //MESSAGE('Relif%1%2',NHIFReliefAmount,EmpSalary.);
       //Get the Tax charged for the month
       curTaxablePay:=curTaxablePay+txBenefitAmt;

      //Added
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
        //curNHIF:=320;
        PayrollGeneralSetup.GET();
        curTransAmount := curNHIF;
        NHIFReliefAmount:=0;

        NHIFReliefAmount:=PayrollGeneralSetup."NHIF Relief"*curNHIF/100;
        END;
      //Added

       curTaxCharged := fnGetEmployeePaye(curTaxablePay)-(curInsuranceReliefAmount+NHIFReliefAmount+curReliefPersonal);
       //
       //MESSAGE('StrEMp%1Payee%2InsuranceRelief%3NHIFRelief%4CurRelief%5',strEmpCode,fnGetEmployeePaye(curTaxablePay),curInsuranceReliefAmount,NHIFReliefAmount,curReliefPersonal);
       IF curTaxCharged<0 THEN BEGIN
       curTaxCharged:=0;
       curTaxablePay:=0;
       curReliefPersonal:=0;
       curTransAmount := curTaxCharged;
       END ELSE BEGIN
       //
       curTransAmount := curTaxCharged+1280;
       END;
       strTransDescription := 'Tax Charged';
       TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 7;

       fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
       curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
       CoopParameters::none);


       //Get the Net PAYE amount to post for the month
       IF (curReliefPersonal + curInsuranceReliefAmount)>curMaximumRelief THEN
         curPAYE := curTaxCharged - curMaximumRelief

       ELSE
       //curPAYE := curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount);
        curPAYE := curTaxCharged;
       IF NOT blnPaysPaye THEN curPAYE := 0; //Get statutory Exemption for the staff. If exempted from tax, set PAYE=0
       curTransAmount := curPAYE;//+curTransAmount2;
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
       prUnusedRelief.SETRANGE(prUnusedRelief."Employee No.",strEmpCode);
       prUnusedRelief.SETRANGE(prUnusedRelief."Period Month",intMonth);
       prUnusedRelief.SETRANGE(prUnusedRelief."Period Year",intYear);
       IF prUnusedRelief.FIND('-') THEN
          prUnusedRelief.DELETE;

       prUnusedRelief.RESET;
       WITH prUnusedRelief DO BEGIN
           INIT;
           "Employee No." := strEmpCode;
           "Unused Relief" := curPAYE;
           "Period Month" := intMonth;
           "Period Year" := intYear;
           INSERT;

           curPAYE:=0;
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
        //curNHIF:=320;
        PayrollGeneralSetup.GET();
        curTransAmount := curNHIF;
        NHIFReliefAmount:=0;

        NHIFReliefAmount:=PayrollGeneralSetup."NHIF Relief"*curNHIF/100;
        //MESSAGE('Employee%1Nhif%2',strEmpCode,NHIFReliefAmount);
        strTransDescription := 'N.H.I.F';
        TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 2;
        fnUpdatePeriodTrans (strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
         curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
         NHIFEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::NHIF);
       END;

        prEmployeeTransactions.RESET;  //==
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
        prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
        IF prEmployeeTransactions.FIND('-') THEN BEGIN
          curTotalDeductions:= 0;
          REPEAT
            prTransactionCodes.RESET;
            prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
            prTransactionCodes.SETRANGE(prTransactionCodes."Transaction Type",prTransactionCodes."Transaction Type"::Deduction);
            IF prTransactionCodes.FIND('-') THEN BEGIN
              curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';

              IF prTransactionCodes."Is Formulae" THEN BEGIN
                  strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formulae);
                  curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount

              END ELSE BEGIN
                  curTransAmount := prEmployeeTransactions.Amount;
              END;

             //**************************If "deduct Premium" is not ticked and the type is insurance- *****
             IF (prTransactionCodes."Special Transaction"=prTransactionCodes."Special Transaction"::"Life Insurance")
               AND (prTransactionCodes."Deduct Premium"=FALSE) THEN
              BEGIN
               curTransAmount:=0;
              END;

             //**************************If "deduct Premium" is not ticked and the type is mortgage- *****
             IF(prTransactionCodes."Special Transaction"=prTransactionCodes."Special Transaction"::Morgage)
              AND (prTransactionCodes."Deduct Mortgage"=FALSE) THEN
              BEGIN
               curTransAmount:=0;
              END;


          //Get the posting Details
               JournalPostingType:=JournalPostingType::" ";JournalAcc:='';
               IF prTransactionCodes.SubLedger<>prTransactionCodes.SubLedger::" " THEN BEGIN
                  IF prTransactionCodes.SubLedger=prTransactionCodes.SubLedger::Customer THEN BEGIN
                      Customer.RESET;
                      HrEmployee.GET(strEmpCode);
                      Customer.RESET;
                      //IF prTransactionCodes.CustomerPostingGroup ='' THEN
                        //Customer.SETRANGE(Customer."Employer Code",'KPSS');

                      IF prTransactionCodes."Customer Posting Group" <>'' THEN
                      Customer.SETRANGE(Customer."Customer Posting Group",prTransactionCodes."Customer Posting Group");

                      Customer.SETRANGE(Customer."Payroll/Staff No",HrEmployee."No.");
                      IF Customer.FIND('-') THEN BEGIN
                         JournalAcc:=Customer."No.";
                         //MESSAGE('%1',JournalAcc);
                         JournalPostingType:=JournalPostingType::Customer;
                      END;
                  END;
               END ELSE BEGIN
                  JournalAcc:=prTransactionCodes."G/L Account";
                  //MESSAGE('POST AS IS %1',JournalAcc);
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
                 //IF (curLoanInt<>0) THEN BEGIN
                        //curTransAmount := curLoanInt;
                        curTransAmount := prEmployeeTransactions.Amount;
                         MESSAGE('TUKO1');
                        curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                        curTransBalance:=0;
                        strTransCode := prEmployeeTransactions."Transaction Code"+'-REP';
                        strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Principle';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;

                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                          CoopParameters::loan);
                 // END;
                 //Get the Principal Amt
                 //curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                 curTransAmount := prEmployeeTransactions.Amount;
                  //Modify PREmployeeTransaction Table
                  prEmployeeTransactions.Amount:=curTransAmount;
                  prEmployeeTransactions.MODIFY;
              END;
              //Loan Calculation Amortized

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
              curTransBalance := curTransBalance;
              strTransDescription := prTransactionCodes."Transaction Name";
              TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 0;
              IF strEmpCode='STA00040' THEN
                 MESSAGE('13 %1 %2 %3 %4 %5 %6 %7',strEmpCode,prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
               strTransDescription, curTransAmount);
              fnUpdatePeriodTrans (strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
               strTransDescription,curTransAmount, curTransBalance, intMonth,
               intYear, prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
               JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
               prTransactionCodes."coop parameters");

      //Check if transaction is loan. Get the Interest on the loan & post it at this point before moving next ****Loan Calculation
              IF (prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::"Staff Loan") AND
                 (prTransactionCodes."Repayment Method" <> prTransactionCodes."Repayment Method"::Amortized) THEN BEGIN

                   curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                  prTransactionCodes."Interest Rate",
                   prTransactionCodes."Repayment Method", prEmployeeTransactions."Original Amount",
                   prEmployeeTransactions.Balance,SelectedPeriod,prTransactionCodes.Welfare);
                   // IF curLoanInt > 0 THEN BEGIN
                       // curTransAmount := curLoanInt;
                        curTransAmount:=prEmployeeTransactions.Amount;
                       // MESSAGE('TUKO2');

                        curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                        curTransBalance:=0;
                        strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                        strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Interest';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                          CoopParameters::"loan Interest");
                   //END;
             END;

      }
             //End Loan transaction calculation
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


      // PRINCIPLE LOAN
              //Loan Calculation is Amortized do Calculations here -Monthly Principal and Interest Keeps on Changing
              IF (prTransactionCodes."Special Transaction"=prTransactionCodes."Special Transaction"::"Staff Loan") AND
                 (prTransactionCodes."Repayment Method" = prTransactionCodes."Repayment Method"::Amortized) THEN BEGIN
                 curTransAmount:=0; curLoanInt:=0;
                 curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                 prTransactionCodes."Interest Rate",prTransactionCodes."Repayment Method",
                    prEmployeeTransactions."Original Amount",prEmployeeTransactions.Balance,SelectedPeriod,FALSE);
                 //Post the Interest
                 //IF (curLoanInt<>0) THEN BEGIN
                        //curTransAmount := curLoanInt;
                        curTransAmount := prEmployeeTransactions.Amount;


                        curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                        curTransBalance:=0;
                        strTransCode := prEmployeeTransactions."Transaction Code"+'-REP';
                        strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Principle';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                          CoopParameters::loan);
                 // END;
                 //Get the Principal Amt
                 //curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                 curTransAmount := prEmployeeTransactions.Amount;
                  //Modify PREmployeeTransaction Table
                  prEmployeeTransactions.Amount:=curTransAmount;
                  prEmployeeTransactions.MODIFY;
              END;
              //Loan Calculation Amortized

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


               //SURESTEP interest within
              IF (prTransactionCodes."Special Transaction"=prTransactionCodes."Special Transaction"::"Staff Loan") AND
                 (prTransactionCodes."Repayment Method" = prTransactionCodes."Repayment Method"::Reducing) THEN BEGIN
                 curTransAmount:=0; curLoanInt:=0;LoanInterest:=0;// prTransactionCodes."Interest Rate"
                 LoanInterest:=FnDetermineLoanInterestRate(prEmployeeTransactions."Loan Number");
                 curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                 LoanInterest,prTransactionCodes."Repayment Method",
                    prEmployeeTransactions."Original Amount",prEmployeeTransactions.Balance,SelectedPeriod,FALSE);
                    //MESSAGE('Employee%1 Loan%2 Amount%3 Int%4',strEmpCode,prEmployeeTransactions."Loan Number",curLoanInt,LoanInterest);
                 //Post the Interest
                 //IF (curLoanInt<>0) THEN BEGIN
                        curTransAmount := curLoanInt;
                        //curTransAmount := prEmployeeTransactions.Amount;
                        //MESSAGE('Staff%1TransName%2Amount%3',strEmpCode,prEmployeeTransactions."Transaction Name",curTransAmount);
                        curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                        curTransBalance:=0;
                        strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                        strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Interest';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                          CoopParameters::"loan Interest");
                 // END;
                 //Get the Principal Amt
                 //curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                 curTransAmount :=prEmployeeTransactions.Amount;
                  //Modify PREmployeeTransaction Table
                  prEmployeeTransactions.Amount:=curTransAmount;
                  prEmployeeTransactions.MODIFY;
              END;
              //Loan Calculation Amortized

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
           IF prEmployeeTransactions."Transaction Code"='D002' THEN BEGIN
           Members.RESET;
           Members.SETRANGE(Members."Payroll/Staff No",prEmployeeTransactions."No.");
           IF Members.FINDFIRST THEN BEGIN
           Members.CALCFIELDS(Members."School Fees Shares");
           curTransBalance:=Members."School Fees Shares";
           prEmployeeTransactions.Balance:=Members."School Fees Shares";
           prEmployeeTransactions.MODIFY
           END;
           END;


               //SURESTEP interest within
              // curTotalDeductions := curTotalDeductions + curTransAmount;
              //===curTotalDeductions := curTotalDeductions + curTransAmount + curPAYE+curNHIF+ curNSSF; //< Sum-up all the deductions
              curTransAmount := curTransAmount;
              curTransBalance := curTransBalance;
              strTransDescription := prTransactionCodes."Transaction Name";
              TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 0;
               IF prTransactionCodes."Transaction Code"='D009' THEN
               curTransAmount:=prEmployeeTransactions.Amount;//(GlobalBasicAmount+Hollawance)*0.125;

      //This is where Employer Pension is Calculated @Dmutinda
              fnUpdatePeriodTrans (strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
               strTransDescription,curTransAmount, curTransBalance, intMonth,
               intYear, prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
               JournalAcc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
               prTransactionCodes."Co-Op Parameters");

      //SURESTEP PRINCIPLE LOAN

            //Create Employer Deduction
            IF (prTransactionCodes."Employer Deduction") OR (prTransactionCodes."Include Employer Deduction") THEN BEGIN
              IF prTransactionCodes."Formulae for Employer"<>'' THEN BEGIN
              //ERROR('%1 %2 %3',prTransactionCodes."Formulae for Employer",GlobalBasicAmount,(GlobalBasicAmount+Hollawance)*0.125);
                  strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear,prTransactionCodes."Formulae for Employer");
                  curTransAmount :=(GlobalBasicAmount+Hollawance)*0.125;//prEmployeeTransactions.Amount;

                  TransCode:=prTransactionCodes."Transaction Code";
                  //MESSAGE('%1', curTransAmount ); //Get the calculated amount  fnFormulaResult(strExtractedFrml);
              END ELSE BEGIN
                  curTransAmount :=(GlobalBasicAmount+Hollawance)*0.125;// prEmployeeTransactions."Employer Amount";

              END;
              PensionEmployer:=(GlobalBasicAmount+Hollawance)*0.125;//fnFormulaResult(strExtractedFrml);


                    IF  PensionEmployer>0 THEN
                    //MESSAGE('%1 %2,%3',PensionEmployer,prEmployeeTransactions."No.",TransCode);

                        fnUpdateEmployerDeductions(strEmpCode, TransCode,
                         'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod)

            END;
            //Employer deductions

              curTotalDeductions := curTotalDeductions+curTransAmount//+curPAYE+curNHIF+curNSSF; //Sum-up all the deductions

            END;
        UNTIL prEmployeeTransactions.NEXT=0;

         curTotalDeductions := curTotalDeductions+curPAYE+curNHIF+curNSSF;
         //curTotalDeductions := (curTotalDeductions+curNHIF+curNSSF+curPAYE-(curInsuranceReliefAmount+curReliefPersonal));  //-curDefinedContrib;  //+curNHIF+curNSSF- //Sum-up all the deductions
             curTransBalance:=0;
                        strTransCode := 'TOT-DED';
                        strTransDescription := 'TOTAL DEDUCTION';
                        TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 9;
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTotalDeductions, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                          '',JournalPostAs::" ",JournalPostingType::" ",'',CoopParameters::none)


       END;

        //Net Pay: calculate the Net pay for the month in the following manner:
        //>Nett = Gross - (xNssfAmount + curMyNhifAmt + PAYE + PayeArrears + prTotDeductions)
        //...Tot Deductions also include (SumLoan + SumInterest)
        curNetPay := curGrossPay - (curPayeArrears + curTotalDeductions+IsCashBenefit+Teltax2);//<
        //curNetPay := curGrossPay - (curNSSF + curNHIF + curPAYE + curPayeArrears + curTotalDeductions+IsCashBenefit+Teltax2);


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

        FosaAcc.RESET;
        FosaAcc.SETRANGE(FosaAcc."Staff No",strEmpCode);
        IF FosaAcc.FINDFIRST THEN BEGIN
           FosaAcc."Net Salary":=curTransAmount;
           FosaAcc.MODIFY;
        END;

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

    PROCEDURE fnUpdatePeriodTrans@1102756008(EmpCode@1102756000 : Code[20];TCode@1102756001 : Code[20];TGroup@1102756002 : Code[20];GroupOrder@1102756003 : Integer;SubGroupOrder@1102756004 : Integer;Description@1102756005 : Text[50];curAmount@1102756006 : Decimal;curBalance@1102756007 : Decimal;Month@1102756008 : Integer;Year@1102756009 : Integer;mMembership@1102756010 : Text[30];ReferenceNo@1102756011 : Text[30];dtOpenPeriod@1102756013 : Date;Department@1102756014 : Code[20];JournalAC@1102756017 : Code[20];PostAs@1102756016 : ' ,Debit,Credit';JournalACType@1102756015 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';LoanNo@1102756018 : Code[20];CoopParam@1102756019 : '
    None,Shares,Loan,Loan Interest,Emergency Loan,Emergency Loan Interest,School Fees Loan,School Fees Loan Interest,Welfare,Pension,NSSF,Overtime,WSS');
    VAR
      prPeriodTransactions@1102756012 : Record 51516183;
      prSalCard@1102756020 : Record 51516160;
    BEGIN
      IF curAmount = 0 THEN EXIT;
      WITH prPeriodTransactions DO BEGIN
          INIT;
          "No." := EmpCode;
          "Transaction Code" := TCode;
          "Group Text" := TGroup;
          "Transaction Name" := Description;
           Amount := ROUND(curAmount,0.05,'=');

           Balance := curBalance;
           prPeriodTransactions."Original Amount":= Balance;
          prPeriodTransactions.Grouping:= GroupOrder;
           prPeriodTransactions.SubGrouping:= SubGroupOrder;
           Membership := mMembership;
           "Reference No" := ReferenceNo;
          "Period Month" := Month;
          "Period Year" := Year;
          "Payroll Period" := dtOpenPeriod;
           Department:=Department;
           prPeriodTransactions."Account Type":=JournalACType;
           prPeriodTransactions."Posting Type":=PostAs;
           //JournalAC:=JournalAC;
           prPeriodTransactions."Account No":=JournalAC;
           prPeriodTransactions."Co-Op parameters":=CoopParam;
          "Loan Number":=LoanNo;

           "Payroll Code":=PayrollType;
           //Paymode
           IF prSalCard.GET(EmpCode) THEN
              //payment mode:=prSalCard."Payment Mode"; //>>mutinda
          INSERT;
         //Update the prEmployee Transactions  with the Amount
         fnUpdateEmployeeTrans( "No.","Transaction Code",Amount,"Period Month","Period Year","Payroll Period");
      END;
    END;

    PROCEDURE fnGetSpecialTransAmount@1102756003(strEmpCode@1102756000 : Code[20];intMonth@1102756001 : Integer;intYear@1102756002 : Integer;intSpecTransID@1102756003 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';blnCompDedc@1102756004 : Boolean) SpecialTransAmount : Decimal;
    VAR
      prEmployeeTransactions@1102756005 : Record 51516182;
      prTransactionCodes@1102756006 : Record 51516181;
      strExtractedFrml@1102756007 : Text[250];
    BEGIN
      SpecialTransAmount:=0;
      Hollawance:=0;
        prEmployeeTransactions.RESET;
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",'D009');
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
         IF prEmployeeTransactions.FIND('-') THEN BEGIN
           Hollawance:=prEmployeeTransactions.Amount;
           END;

      prTransactionCodes.RESET;
      prTransactionCodes.SETRANGE(prTransactionCodes."Special Transaction",intSpecTransID);
      IF prTransactionCodes.FIND('-') THEN BEGIN
      REPEAT
         prEmployeeTransactions.RESET;
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
         IF prEmployeeTransactions.FIND('-') THEN BEGIN

          //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
          //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
            CASE intSpecTransID OF
              intSpecTransID::"Defined Contribution":
                IF prTransactionCodes."Is Formulae" THEN BEGIN
                    strExtractedFrml := '';
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formulae);
                    //SpecialTransAmount := (Hollawance+GlobalBasicAmount)*0.125;// (SpecialTransAmount+Hollawance)+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                    //ERROR('%1 %2 %3',Hollawance,strExtractedFrml, (Hollawance+GlobalBasicAmount)*0.125);
                     //pecialTransAmount := (Hollawance+GlobalBasicAmount)*0.125;
                      SpecialTransAmount := Hollawance;//(GlobalBasicAmount*0.15);
                END ELSE
                    SpecialTransAmount := (SpecialTransAmount+Hollawance)+prEmployeeTransactions.Amount;
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
       //MESSAGE('GlobalBasic%1Hollaance%2Staff%3',GlobalBasicAmount,Hollawance,strEmpCode);
       UNTIL prTransactionCodes.NEXT=0;
      END;
      SpecialTranAmount:=SpecialTransAmount;
      ///SAGE('Specia%1',SpecialTranAmount);
    END;

    PROCEDURE fnGetEmployeePaye@1102756038(curTaxablePay@1102756000 : Decimal) PAYE : Decimal;
    VAR
      prPAYE@1102756001 : Record 51516213;
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
      prNHIF@1102756001 : Record 51516214;
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
      prEmployeeTransactions@1102756004 : Record 51516182;
      prPeriodTransactions@1102756005 : Record 51516183;
    BEGIN
      prEmployeeTransactions.RESET;
      prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
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
      prPeriodTransactions.SETRANGE(prPeriodTransactions."No.",strEmpCode);
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
      prEmployeeTransactions@1102756005 : Record 51516182;
      prPeriodTransactions@1102756004 : Record 51516183;
      intMonth@1102756007 : Integer;
      intYear@1102756006 : Integer;
      prTransactionCodes@1102756008 : Record 51516181;
      curTransAmount@1102756009 : Decimal;
      curTransBalance@1102756010 : Decimal;
      prEmployeeTrans@1102756011 : Record 51516182;
      prPayrollPeriods@1102756012 : Record 51516185;
      prNewPayrollPeriods@1102756013 : Record 51516185;
      CreateTrans@1102756014 : Boolean;
      ControlInfo@1102756016 : Record 51516212;
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
           (prEmployeeTransactions."Stop for Next Period"=FALSE) THEN //MUTINDA ADDED THIS TO CHECK FREQUENCY AND STOP IF MARKED
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
            "No.":= prEmployeeTransactions."No.";
            "Transaction Code":= prEmployeeTransactions."Transaction Code";
            "Transaction Name":= prEmployeeTransactions."Transaction Name";
             Amount:= curTransAmount;
             Balance:= curTransBalance;
            "Amtzd Loan Repay Amt":=prEmployeeTransactions."Amtzd Loan Repay Amt";
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
      prPeriodTransactions@1102756003 : Record 51516183;
      prEmployeeTransactions@1102756004 : Record 51516182;
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
      prPeriodTransactions.SETRANGE(prPeriodTransactions.Grouping,9);
      prPeriodTransactions.SETFILTER(prPeriodTransactions.Amount,'<0');

      IF prPeriodTransactions.FIND('-') THEN BEGIN
      REPEAT
        WITH  prEmployeeTransactions DO BEGIN
          INIT;
          "No.":= prPeriodTransactions."No.";
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
      prPeriodTransactions@1102756020 : Record 51516183;
      prEmployee@1102756021 : Record 51516180;
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
      prPeriodTransactions.SETRANGE(prPeriodTransactions."No.",prEmployee."No.");
      IF prPeriodTransactions.FIND('-') THEN BEGIN
        REPEAT
        WITH prPeriodTransactions DO BEGIN
          CASE prPeriodTransactions.Grouping OF
              1: //Basic pay & Arrears
              BEGIN
                IF SubGrouping = 1 THEN P9BasicPay := Amount; //Basic Pay
                IF SubGrouping = 2 THEN P9BasicPay := P9BasicPay + Amount; //Basic Pay Arrears
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
                IF SubGrouping = 1 THEN P9DefinedContribution := Amount; //Defined Contribution
                IF SubGrouping = 9 THEN P9TaxRelief := Amount; //Tax Relief
                IF SubGrouping = 8 THEN P9InsuranceRelief := Amount; //Insurance Relief
                IF SubGrouping = 6 THEN P9TaxablePay := Amount; //Taxable Pay
                IF SubGrouping = 7 THEN P9TaxCharged := Amount; //Tax Charged
              END;
              7: //Statutories
              BEGIN
                IF SubGrouping = 1 THEN P9NSSF := Amount; //Nssf
                IF SubGrouping = 2 THEN P9NHIF := Amount; //Nhif
                IF SubGrouping= 3 THEN P9Paye := Amount; //paye
                IF SubGrouping = 4 THEN P9Paye := P9Paye + Amount; //Paye Arrears
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
      prEmployeeP9Info@1102756018 : Record 51516184;
      intYear@1102756019 : Integer;
      intMonth@1102756020 : Integer;
      PayrollEmployeeP9@1120054000 : Record 51516184;
    BEGIN
      intMonth := DATE2DMY(dtCurrPeriod,2);
      intYear := DATE2DMY(dtCurrPeriod,3);

      PayrollEmployeeP9.RESET;
      PayrollEmployeeP9.SETRANGE(PayrollEmployeeP9."Employee Code",P9EmployeeCode);
      PayrollEmployeeP9.SETRANGE(PayrollEmployeeP9."Payroll Period",dtCurrPeriod);
      IF PayrollEmployeeP9.FINDFIRST THEN
        PayrollEmployeeP9.DELETE;

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
      "prEmployee P9 Info"@1102756008 : Record 51516184;
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
      "prSalary Arrears"@1102756009 : Record 51516188;
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

    PROCEDURE fnCalcLoanInterest@1102756027(strEmpCode@1102756000 : Code[20];strTransCode@1102756001 : Code[20];InterestRate@1102756002 : Decimal;RecoveryMethod@1102756003 : 'Reducing,Straight line,Amortized';LoanAmount@1102756004 : Decimal;Balance@1102756005 : Decimal;CurrPeriod@1102756007 : Date;Welfare@1102756010 : Boolean) LnInterest : Decimal;
    VAR
      curLoanInt@1102756006 : Decimal;
      intMonth@1102756008 : Integer;
      intYear@1102756009 : Integer;
    BEGIN
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
    END;

    PROCEDURE fnUpdateEmployerDeductions@1102756017(EmpCode@1102756000 : Code[20];TCode@1102756001 : Code[20];TGroup@1102756002 : Code[20];GroupOrder@1102756003 : Integer;SubGroupOrder@1102756004 : Integer;Description@1102756005 : Text[50];curAmount@1102756006 : Decimal;curBalance@1102756007 : Decimal;Month@1102756008 : Integer;Year@1102756009 : Integer;mMembership@1102756010 : Text[30];ReferenceNo@1102756011 : Text[30];dtOpenPeriod@1102756013 : Date);
    VAR
      prEmployerDeductions@1102756012 : Record 51516190;
    BEGIN
      //ERROR('%1',PensionEmployer);
      IF curAmount = 0 THEN EXIT;
      WITH prEmployerDeductions DO BEGIN
          INIT;
          "Employee Code" := EmpCode;
          "Transaction Code" := TCode;
           Amount := PensionEmployer;
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
      prEmployeeTrans@1102756006 : Record 51516182;
    BEGIN
         prEmployeeTrans.RESET;
         prEmployeeTrans.SETRANGE(prEmployeeTrans."No.",EmpCode);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Transaction Code",TransCode);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Payroll Period",PayrollPeriod);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Period Month",Month);
         prEmployeeTrans.SETRANGE(prEmployeeTrans."Period Year",Year);
         IF prEmployeeTrans.FIND('-') THEN BEGIN
           prEmployeeTrans.Amount:=Amount;
           prEmployeeTrans.MODIFY;
         END

    END;

    PROCEDURE fnGetJournalDet@1102756018(strEmpCode@1102756000 : Code[20]);
    VAR
      SalaryCard@1102756001 : Record 51516180;
    BEGIN
      //Get Payroll Posting Accounts
      IF SalaryCard.GET(strEmpCode) THEN BEGIN
      IF PostingGroup.GET(SalaryCard."Posting Group") THEN //>>Mutinda
       BEGIN
         //Comment This for the Time Being

         PostingGroup.TESTFIELD("Salary Account");
         PostingGroup.TESTFIELD("Income Tax Account");
         PostingGroup.TESTFIELD("Net Salary Payable");
         PostingGroup.TESTFIELD("SSF Employer Account");
         PostingGroup.TESTFIELD("Pension Employer Acc");

        TaxAccount:=PostingGroup."Income Tax Account";
        salariesAcc:=PostingGroup."Salary Account";
        PayablesAcc:=PostingGroup."Net Salary Payable";
       // PayablesAcc:=SalaryCard."Bank Account Number";
        NSSFEMPyer:= PostingGroup."SSF Employer Account";
        NSSFEMPyee:= PostingGroup."SSF Employee Account";
        //NHIFEMPyee:=PostingGroup."NHIF Employee Account";
        NHIFEMPyee:=PostingGroup."NHIF Employee Account";
        PensionEMPyer:=PostingGroup."Pension Employer Acc";
        //TelTaxACC:=PostingGroup."Telephone Tax Acc"; //>>Mutinda
       END ELSE BEGIN
       ERROR('Please specify Posting Group in Employee No.  '+strEmpCode);
       END;
      END;
      //End Get Payroll Posting Accounts
    END;

    PROCEDURE fnGetSpecialTransAmount2@1102755006(strEmpCode@1102756000 : Code[20];intMonth@1102756001 : Integer;intYear@1102756002 : Integer;intSpecTransID@1102756003 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';blnCompDedc@1102756004 : Boolean);
    VAR
      prEmployeeTransactions@1102756005 : Record 51516182;
      prTransactionCodes@1102756006 : Record 51516181;
      strExtractedFrml@1102756007 : Text[250];
    BEGIN
      SpecialTranAmount:=0;
      Hollawance:=0;
        prEmployeeTransactions.RESET;
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",'E001');
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
         IF prEmployeeTransactions.FIND('-') THEN BEGIN
           Hollawance:=prEmployeeTransactions.Amount;

           END;

      prTransactionCodes.RESET;
      prTransactionCodes.SETRANGE(prTransactionCodes."Special Transaction",intSpecTransID);
      IF prTransactionCodes.FIND('-') THEN BEGIN
      REPEAT
         prEmployeeTransactions.RESET;
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."No.",strEmpCode);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
         IF prEmployeeTransactions.FIND('-') THEN BEGIN

          //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
          //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
            CASE intSpecTransID OF
              intSpecTransID::"Defined Contribution":
                IF prTransactionCodes."Is Formulae" THEN BEGIN
                    strExtractedFrml := '';
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formulae);
                    SpecialTranAmount := (SpecialTranAmount+Hollawance)+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount

                END ELSE
                   SpecialTranAmount := (SpecialTranAmount+Hollawance)+prEmployeeTransactions.Amount;


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
           pnEmpTrans.SETRANGE(pnEmpTrans."No.",pnEmpCode);
           pnEmpTrans.SETRANGE(pnEmpTrans."Payroll Period",pnPayperiod);
            IF pnEmpTrans.FIND('-') THEN BEGIN
            REPEAT
            IF pnTranCode.GET(pnEmpTrans."Transaction Code") THEN
            IF pnTranCode."Co-Op Parameters"=pnTranCode."Co-Op Parameters"::Pension THEN
            PaysPens:=TRUE;
            UNTIL pnEmpTrans.NEXT=0;
            END;
    END;

    LOCAL PROCEDURE FnBasicPay@1000000001(EmployeeCode@1000000000 : Code[50]) BasicPay : Decimal;
    BEGIN
    END;

    LOCAL PROCEDURE FnDetermineLoanInterestRate@1120054000(LoanNumber@1120054000 : Code[20]) : Decimal;
    VAR
      LoansRegister@1120054001 : Record 51516230;
      LoanInterest@1120054002 : Decimal;
      LoanProduct@1120054003 : Record 51516240;
    BEGIN
      LoansRegister.RESET;
      LoansRegister.SETRANGE(LoansRegister."Loan  No.",LoanNumber);
      IF LoansRegister.FINDFIRST THEN BEGIN
      LoanProduct.RESET;
      LoanProduct.SETRANGE(LoanProduct.Code,LoansRegister."Loan Product Type");
      IF LoanProduct.FINDFIRST THEN BEGIN
      LoanInterest:=LoanProduct."Interest rate";
      END;
      END;
      EXIT(LoanInterest);
    END;

    LOCAL PROCEDURE FnCalculateEmployeeNSSF@1120054001(GrossNSSF@1120054000 : Decimal) : Decimal;
    VAR
      NSSFSetup@1120054001 : Record 51516215;
      NSSF@1120054002 : Decimal;
    BEGIN
      NSSF:=0;
      IF GrossNSSF>17999 THEN BEGIN
      NSSFSetup.RESET;
      NSSFSetup.SETCURRENTKEY(NSSFSetup."Tier Code");
      IF NSSFSetup.FINDSET THEN BEGIN
        REPEAT
          IF ((GrossNSSF>=NSSFSetup."Lower Limit") AND (GrossNSSF<=NSSFSetup."Upper Limit")) THEN
              NSSF:=NSSFSetup."Tier 1 Employee Deduction" + NSSFSetup."Tier 2 Employee Deduction";
        UNTIL NSSFSetup.NEXT=0;
      END;
      END ELSE IF GrossNSSF<18000 THEN BEGIN
      NSSF:=GrossNSSF*0.06;
      END;
      EXIT(NSSF);
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

