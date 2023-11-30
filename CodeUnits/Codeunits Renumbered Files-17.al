OBJECT CodeUnit 20381 Payroll Management1
{
  OBJECT-PROPERTIES
  {
    Date=05/31/16;
    Time=[ 1:17:18 PM];
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
      PersonalRelief@1061 : Decimal;
      "PersonalRelief(LCY)"@1102 : Decimal;
      InsuranceRelief@1062 : Decimal;
      "InsuranceRelief(LCY)"@1103 : Decimal;
      MorgageRelief@1063 : Decimal;
      "MorgageRelief(LCY)"@1104 : Decimal;
      MaximumRelief@1064 : Decimal;
      "MaximumRelief(LCY)"@1105 : Decimal;
      NssfEmployee@1065 : Decimal;
      "NssfEmployee(LCY)"@1106 : Decimal;
      NssfEmployerFactor@1066 : Decimal;
      "NssfEmployerFactor(LCY)"@1107 : Decimal;
      NHIFBasedOn@1067 : 'Gross,Basic,Taxable Pay';
      NSSFBasedOn@1068 : 'Gross,Basic,Taxable Pay';
      MaxPensionContrib@1070 : Decimal;
      "MaxPensionContrib(LCY)"@1084 : Decimal;
      RateTaxExPension@1069 : Decimal;
      "RateTaxExPension(LCY)"@1108 : Decimal;
      OOIMaxMonthlyContrb@1071 : Decimal;
      "OOIMaxMonthlyContrb(LCY)"@1109 : Decimal;
      OOIDecemberDedc@1072 : Decimal;
      "OOIDecemberDedc(LCY)"@1110 : Decimal;
      LoanMarketRate@1073 : Decimal;
      "LoanMarketRate(LCY)"@1111 : Decimal;
      LoanCorpRate@1074 : Decimal;
      "LoanCorpRate(LCY)"@1112 : Decimal;
      NSSFBaseAmount@1058 : Decimal;
      "NSSFBaseAmount(LCY)"@1077 : Decimal;
      NHIFBaseAmount@1060 : Decimal;
      "NHIFBaseAmount(LCY)"@1078 : Decimal;
      EmpBasicPay@1000 : Decimal;
      "EmpBasicPay(LCY)"@1015 : Decimal;
      EmpEarning@1001 : Decimal;
      "EmpEarning(LCY)"@1016 : Decimal;
      EmpDeduction@1002 : Decimal;
      "EmpDeduction(LCY)"@1017 : Decimal;
      EmpPaye@1003 : Decimal;
      "EmpPaye(LCY)"@1018 : Decimal;
      EmpPayeBenefit@1096 : Decimal;
      "EmpPayeBenefit(LCY)"@1097 : Decimal;
      EmpGrossPay@1004 : Decimal;
      "EmpGrossPay(LCY)"@1019 : Decimal;
      EmpGrossTaxable@1091 : Decimal;
      "EmpGrossTaxable(LCY)"@1090 : Decimal;
      EmpBenefits@1092 : Decimal;
      "EmpBenefits(LCY)"@1093 : Decimal;
      EmpValueOfQuarters@1094 : Decimal;
      "EmpValueOfQuarters(LCY)"@1095 : Decimal;
      EmpTaxableEarning@1005 : Decimal;
      "EmpTaxableEarning(LCY)"@1020 : Decimal;
      EmpPersonalRelief@1098 : Decimal;
      "EmpPersonalRelief(LCY)"@1099 : Decimal;
      EmpUnusedRelief@1100 : Decimal;
      "EmpUnusedRelief(LCY)"@1101 : Decimal;
      EmpNetPay@1126 : Decimal;
      "EmpNetPay(LCY)"@1127 : Decimal;
      currentAmount@1006 : Decimal;
      "currentAmount(LCY)"@1021 : Decimal;
      Description@1007 : Text[100];
      "Account Type"@1008 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      "Account No."@1009 : Code[20];
      "Posting Type"@1010 : ' ,Debit,Credit';
      "Transaction Code"@1011 : Code[20];
      "Transaction Type"@1012 : Code[50];
      Grouping@1013 : Integer;
      SubGrouping@1014 : Integer;
      TransDescription@1113 : Text[100];
      ExchangeRateDate@1022 : Date;
      CurrExchRate@1023 : Record 330;
      PayrollPostingGroup@1035 : Record 51516187;
      PayrollGenSetup@1024 : Record 51516219;
      EmployeeTransactions@1025 : Record 51516182;
      EmpTotalAllowances@1026 : Decimal;
      "EmpTotalAllowances(LCY)"@1042 : Decimal;
      PayrollTransactions@1027 : Record 51516181;
      TransFormula@1028 : Text[250];
      CurBalance@1029 : Decimal;
      "CurBalance(LCY)"@1031 : Decimal;
      EmpTotalNonTaxAllowances@1032 : Decimal;
      "EmpTotalNonTaxAllowances(LCY)"@1043 : Decimal;
      Customer@1033 : Record 51516223;
      TALLOWANCE@1034 : TextConst 'ENU=ALLOWANCE';
      CurMonth@1036 : Integer;
      CurYear@1037 : Integer;
      TCODE_BPAY@1038 : TextConst 'ENU=BPAY';
      TTYPE_BPAY@1039 : TextConst 'ENU=Basic Pay';
      TotalSalaryArrears@1040 : Decimal;
      currentGrossPay@1041 : Decimal;
      "currentGrossPay(LCY)"@1044 : Decimal;
      EmpSalaryArrear@1045 : Decimal;
      "EmpSalaryArrear(LCY)"@1046 : Decimal;
      TCODE_GPAY@1048 : TextConst 'ENU=GPAY';
      TTYPE_GPAY@1047 : TextConst 'ENU=Gross Pay';
      EmpPAYEArrears@1050 : Decimal;
      "EmpPAYEArrears(LCY)"@1051 : Decimal;
      "Salary Arrears"@1049 : Record 51516188;
      TCODE_SARREARS@1053 : TextConst 'ENU=ARREARS';
      TTYPE_SARREARS@1052 : TextConst 'ENU=Salary Arrears';
      TCODE_PARREARS@1055 : TextConst 'ENU=PYAR';
      TTYPE_STATUTORIES@1054 : TextConst 'ENU=STATUTORIES';
      EmpLoan@1056 : Decimal;
      "EmpLoan(LCY)"@1057 : Decimal;
      EmpFringeBenefit@1059 : Decimal;
      TCODE_NSSF@1075 : TextConst 'ENU=NSSF';
      TCODE_NSSFEMP@1076 : TextConst 'ENU=NSSFEMP';
      "EmpFringeBenefit(LCY)"@1079 : Decimal;
      TCODE_NHIF@1080 : TextConst 'ENU=NHIF';
      EmpDefinedContrib@1081 : Decimal;
      "EmpDefinedContrib(LCY)"@1082 : Decimal;
      EmpStaffPension@1085 : Decimal;
      "EmpStaffPension(LCY)"@1086 : Decimal;
      EmpLessAllowanceNSSF@1083 : Decimal;
      "EmpLessAllowanceNSSF(LCY)"@1087 : Decimal;
      EmpLessAllowanceNHIF@1088 : Decimal;
      "EmpLessAllowanceNHIF(LCY)"@1089 : Decimal;
      EmpPensionStaff@1030 : Decimal;
      "EmpPensionStaff(LCY)"@1114 : Decimal;
      EmpOOI@1115 : Decimal;
      "EmpOOI(LCY)"@1116 : Decimal;
      EmpHOSP@1117 : Decimal;
      "EmpHOSP(LCY)"@1118 : Decimal;
      EmpNonTaxable@1119 : Decimal;
      "EmpNonTaxable(LCY)"@1120 : Decimal;
      EmpTaxCharged@1121 : Decimal;
      "EmpTaxCharged(LCY)"@1122 : Decimal;
      InsuranceReliefAmount@1123 : Decimal;
      "InsuranceReliefAmount(LCY)"@1124 : Decimal;
      UnusedRelief@1125 : Record 51516186;
      EmpNSSF@1128 : Decimal;
      "EmpNSSF(LCY)"@1129 : Decimal;
      EmpNHIF@1130 : Decimal;
      "EmpNHIF(LCY)"@1131 : Decimal;
      EmpTotalDeductions@1134 : Decimal;
      "EmpTotalDeductions(LCY)"@1135 : Decimal;
      ProvidentAmount@1000000000 : Decimal;
      "co-op"@1000000001 : 'None,Shares,Loan,Loan Interest,Emergency Loan,Emergency Loan Interest,School Fees Loan,School Fees Loan Interest,Welfare,Pension,NSSF,Overtime,WSS';
      LoanNo@1000000002 : Code[10];
      PrEmployee@1000000003 : Record 51516180;
      TCODE_PFUND@1000000004 : TextConst 'ENU=PROVIDENT';

    PROCEDURE ProcessPayroll@26("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimeSheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20];PaysPAYE@1015 : Boolean;PaysNHIF@1014 : Boolean;PaysNSSF@1013 : Boolean;GetsPAYERelief@1016 : Boolean;GetsPAYEBenefit@1017 : Boolean;Secondary@1019 : Boolean;PayeBenefitPercent@1018 : Decimal);
    VAR
      SpecialTransType@1000000000 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';
    BEGIN
        Initialize("Payroll Period");
        //Basic Pay
        ProcessBasicPay("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                        BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);
        //SalaryArrears
        ProcessSalaryArrears("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                        BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);
        //Earnings
        ProcessEarnings("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                        BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);
        //GrossPay
        ProcessGrossPay("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                        BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);
        //Deductions
        ProcessDeductions("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                        BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);
        //NSSF
        IF PaysNSSF THEN BEGIN
          ProcessEmployeeNSSF("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                          BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department,PaysNSSF);
          ProcessEmployerNSSF("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                          BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department,PaysNSSF);
        END;

        // process provident
       CalculateSpecialTrans("Employee No",CurMonth,CurYear,SpecialTransType::"Defined Contribution",FALSE) ;
       ProcessEmployerProvident("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                          BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);

        //NHIF
        IF PaysNHIF THEN BEGIN
          ProcessNHIF("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                          BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department,PaysNHIF);
        END;

        //Gross Taxable
        ProcessGrossTaxable();

        //Taxable Pay
        ProcessTaxablePay("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                        BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);

        //PAYE
        IF PaysPAYE THEN BEGIN
          //Personal Relief
          //IF GetsPAYERelief THEN BEGIN
            ProcessPersonalRelief("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                          BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);
          //END ELSE BEGIN
           // EmpPersonalRelief:=0;
            //"EmpPersonalRelief(LCY)":=0;
         // END;
          //Process PAYE
          ProcessEmpPAYE("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                          BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department,Secondary,GetsPAYEBenefit,PayeBenefitPercent);
        END;
        //NetPay
        ProcessNetPay("Employee No","Payroll Period","Posting Group",BasicPay,"BasicPay(LCY)","Currency Code","Currency Factor","Joining Date","Leaving Date",
                        BasedOnTimeSheet,"Global Dimension 1 Code","Global Dimension 2 Code",Department);

        //End
    END;

    LOCAL PROCEDURE Initialize@24("Payroll Period"@1000 : Date);
    BEGIN
       CurMonth:=DATE2DMY("Payroll Period",2);
       CurYear:=DATE2DMY("Payroll Period",3);
       //Constants
       PayrollGenSetup.GET;

       PersonalRelief:=PayrollGenSetup."Tax Relief";
       InsuranceRelief:=PayrollGenSetup."Insurance Relief";
       MorgageRelief:=PayrollGenSetup."Mortgage Relief";
       MaximumRelief:=PayrollGenSetup."Max Relief";
       NssfEmployee:=PayrollGenSetup."NSSF Employee";
       NssfEmployerFactor:=PayrollGenSetup."NSSF Employer Factor";
       NHIFBasedOn:=PayrollGenSetup."NHIF Based on";
       NSSFBasedOn:=PayrollGenSetup."NSSF Based on";
       MaxPensionContrib:=PayrollGenSetup."Max Pension Contribution";
       RateTaxExPension:=PayrollGenSetup."Tax On Excess Pension";
       OOIMaxMonthlyContrb:=PayrollGenSetup."OOI Deduction";
       OOIDecemberDedc:=PayrollGenSetup."OOI December";
       LoanMarketRate:=PayrollGenSetup."Loan Market Rate";
       LoanCorpRate:=PayrollGenSetup."Loan Corporate Rate";
    END;

    LOCAL PROCEDURE ProcessBasicPay@1("Employee No"@1003 : Code[20];"Payroll Period"@1004 : Date;"Posting Group"@1014 : Code[20];BasicPay@1000 : Decimal;"BasicPay(LCY)"@1009 : Decimal;"Currency Code"@1001 : Code[20];"Currency Factor"@1002 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1006 : Date;BasedOnTimeSheet@1010 : Boolean;"Global Dimension 1 Code"@1013 : Code[20];"Global Dimension 2 Code"@1012 : Code[20];Department@1011 : Code[20]);
    VAR
      DaysInMonth@1007 : Integer;
      DaysWorked@1008 : Integer;
    BEGIN
        //Setup Constants
        "Transaction Code":=TCODE_BPAY;
        "Transaction Type":=TTYPE_BPAY;
        TransDescription:='Basic Pay';
        Grouping:=1;SubGrouping:=1;
        EmpBasicPay:=0;
        "EmpBasicPay(LCY)":=0;
        currentAmount:=0;
        "currentAmount(LCY)":=0;

        //Calculate the Basic Pay
        EmpBasicPay:=BasicPay;
        "EmpBasicPay(LCY)":="BasicPay(LCY)";

        //If Based on Timesheet then Prorate
        PayrollGenSetup.GET;
        IF BasedOnTimeSheet THEN BEGIN
          DaysInMonth:=GetDaysInMonth("Payroll Period");
          DaysWorked:=GetDaysWorkedTimesheet("Employee No","Payroll Period");
          EmpBasicPay:=CalculateProratedAmount("Employee No",EmpBasicPay,DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
          "EmpBasicPay(LCY)":=CalculateProratedAmount("Employee No","EmpBasicPay(LCY)",DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
         //End Based on Timesheet
        END ELSE BEGIN
          //If Employed on this Payroll Period then Prorate Amount
          IF(DATE2DMY("Joining Date",2)=DATE2DMY("Payroll Period",2)) AND (DATE2DMY("Joining Date",3)=DATE2DMY("Payroll Period",3)) THEN BEGIN
              DaysInMonth:=GetDaysInMonth("Joining Date");
              DaysWorked:=GetDaysWorked("Joining Date",FALSE);
              EmpBasicPay:=CalculateProratedAmount("Employee No",EmpBasicPay,DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
              "EmpBasicPay(LCY)":=CalculateProratedAmount("Employee No","EmpBasicPay(LCY)",DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
          END;
          //If Terminated on this Payroll Period then Prorate Amount
          IF "Leaving Date"<>0D THEN
            IF(DATE2DMY("Leaving Date",2)=DATE2DMY("Payroll Period",2)) AND (DATE2DMY("Leaving Date",3)=DATE2DMY("Payroll Period",3)) THEN BEGIN
                DaysInMonth:=GetDaysInMonth("Joining Date");
                DaysWorked:=GetDaysWorked("Joining Date",TRUE);
                EmpBasicPay:=CalculateProratedAmount("Employee No",EmpBasicPay,DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
                "EmpBasicPay(LCY)":=CalculateProratedAmount("Employee No","EmpBasicPay(LCY)",DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
            END;
        END;
        //Insert Into Monthly Transactions
        currentAmount:=EmpBasicPay;
        "currentAmount(LCY)":="EmpBasicPay(LCY)";

       IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
          "Account Type":="Account Type"::"G/L Account";
          "Account No.":=PayrollPostingGroup."Salary Account";
       END;
       "co-op":="co-op"::None;

        //Insert Into Monthly Transactions
        InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
        TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
        "Account No.","Posting Type"::Debit,"Global Dimension 1 Code","Global Dimension 2 Code",EmployeeTransactions.Membership,
        EmployeeTransactions."Reference No",Department,"co-op",LoanNo);
    END;

    LOCAL PROCEDURE ProcessSalaryArrears@21("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimeSheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20]);
    BEGIN
       //Salary Arrears
      { "Salary Arrears".RESET;
       "Salary Arrears".SETRANGE("Salary Arrears"."Employee Code","Employee No");
       "Salary Arrears".SETRANGE("Salary Arrears"."Period Month",CurMonth);
       "Salary Arrears".SETRANGE("Salary Arrears"."Period Year",CurYear);
       IF "Salary Arrears".FINDFIRST THEN BEGIN
          //Salary Arrears------------------------------------------------------------------------------------------------------------
            //Setup Constants
            "Transaction Code":=TCODE_SARREARS;
            "Transaction Type":=TTYPE_SARREARS;
            TransDescription:=FORMAT(TTYPE_SARREARS)+':'+FORMAT("Payroll Period");
            Grouping:=1;SubGrouping:=2;
            currentAmount:=0;
            "currentAmount(LCY)":=0;
            SalaryArrear:=0;
            "SalaryArrear(LCY)":=0;

            SalaryArrear:="Salary Arrears"."Salary Arrears";
            "SalaryArrear(LCY)":="Salary Arrears"."Salary Arrears(LCY)";

            currentAmount:=SalaryArrears;
            "currentAmount(LCY)":="SalaryArrears(LCY)";

            IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
               "Account Type":="Account Type"::"G/L Account";
               "Account No.":=PayrollPostingGroup."Salary Account";
            END;

            //Insert Into Monthly Transactions
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
             TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
             "Account No.","Posting Type"::Debit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
             '',Department);
          //End Salary Arrears--------------------------------------------------------------------------------------------------------

          //PAYE Arrears--------------------------------------------------------------------------------------------------------------

            //Setup Constants
            "Transaction Code":=TCODE_PARREARS;
            "Transaction Type":=TTYPE_PARREARS;
            TransDescription:=FORMAT(TTYPE_PARREARS)+':'+FORMAT("Payroll Period");
            Grouping:=7;SubGrouping:=4;
            currentAmount:=0;
            "currentAmount(LCY)":=0;
            PAYEArrear:=0;
            "PAYEArrear(LCY)":=0;


            PAYEArrear:="Salary Arrears"."PAYE Arrears";
            "PAYEArrear(LCY)":="Salary Arrears"."PAYE Arrears(LCY)";
            currentAmount:=PAYEArrears;
            "currentAmount(LCY)":="PAYEArrears(LCY)";

            IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
               "Account Type":="Account Type"::"G/L Account";
               "Account No.":=PayrollPostingGroup."Income Tax Account";
            END;

            //Insert Into Monthly Transactions
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
             TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
             "Account No.","Posting Type"::Debit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
             '',Department);

           //End PAYE Arrears----------------------------------------------------------------------------------------------------------
       END;
       }
    END;

    LOCAL PROCEDURE ProcessEarnings@2("Employee No"@1007 : Code[20];"Payroll Period"@1006 : Date;"Posting Group"@1016 : Code[20];BasicPay@1005 : Decimal;"BasicPay(LCY)"@1004 : Decimal;"Currency Code"@1003 : Code[20];"Currency Factor"@1002 : Decimal;"Joining Date"@1001 : Date;"Leaving Date"@1000 : Date;BasedOnTimesheet@1010 : Boolean;"Global Dimension 1 Code"@1013 : Code[20];"Global Dimension 2 Code"@1014 : Code[20];Department@1015 : Code[20]);
    VAR
      DaysInMonth@1012 : Integer;
      DaysWorked@1011 : Integer;
    BEGIN
       EmpTotalAllowances:= 0;
       "EmpTotalAllowances(LCY)":=0;
       EmpTotalNonTaxAllowances:=0;
       "EmpTotalNonTaxAllowances(LCY)":=0;

       //Get Earnings
       EmployeeTransactions.RESET;
       EmployeeTransactions.SETRANGE(EmployeeTransactions."No.","Employee No");
       EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Month",CurMonth);
       EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Year",CurYear);
       EmployeeTransactions.SETRANGE(EmployeeTransactions."Transaction Type",EmployeeTransactions."Transaction Type"::Income);
       IF EmployeeTransactions.FINDSET THEN BEGIN
         REPEAT
           currentAmount:=0;"currentAmount(LCY)":=0;CurBalance := 0; TransDescription := ''; TransFormula:= '';
           "Transaction Code":='';Grouping:=0;SubGrouping:=0;

           PayrollTransactions.RESET;
           PayrollTransactions.SETRANGE(PayrollTransactions."Transaction Code",EmployeeTransactions."Transaction Code");
           IF PayrollTransactions.FINDFIRST THEN BEGIN
              IF PayrollTransactions."Is Formulae" THEN BEGIN
                 TransFormula:=ExpandFormula("Employee No",CurMonth,CurYear,PayrollTransactions.Formulae);
                 currentAmount:=FormulaResult(TransFormula);
                 "currentAmount(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",currentAmount,"Currency Factor"),1,'<');
              END ELSE BEGIN
                 currentAmount:=EmployeeTransactions.Amount;
                 "currentAmount(LCY)":=EmployeeTransactions."Amount(LCY)";
              END;
              //If Based on Timesheet then Prorate
            PayrollGenSetup.GET;
            IF BasedOnTimesheet THEN BEGIN
               DaysInMonth:=GetDaysInMonth("Payroll Period");
               DaysWorked:=GetDaysWorkedTimesheet("Employee No","Payroll Period");
               currentAmount:=CalculateProratedAmount("Employee No",currentAmount,DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
               "currentAmount(LCY)":=CalculateProratedAmount("Employee No","currentAmount(LCY)",DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
              //End Based on Timesheet
            END ELSE BEGIN
               //If Employed on this Payroll Period then Prorate Amount
               IF(DATE2DMY("Joining Date",2)=DATE2DMY("Payroll Period",2)) AND (DATE2DMY("Joining Date",3)=DATE2DMY("Payroll Period",3)) THEN BEGIN
                   DaysInMonth:=GetDaysInMonth("Joining Date");
                   DaysWorked:=GetDaysWorked("Joining Date",FALSE);
                   currentAmount:=CalculateProratedAmount("Employee No",currentAmount,DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
                   "currentAmount(LCY)":=CalculateProratedAmount("Employee No","currentAmount(LCY)",DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
               END;
               //If Terminated on this Payroll Period then Prorate Amount
               IF "Leaving Date"<>0D THEN
                IF(DATE2DMY("Leaving Date",2)=DATE2DMY("Payroll Period",2)) AND (DATE2DMY("Leaving Date",3)=DATE2DMY("Payroll Period",3)) THEN BEGIN
                    DaysInMonth:=GetDaysInMonth("Joining Date");
                    DaysWorked:=GetDaysWorked("Joining Date",TRUE);
                    currentAmount:=CalculateProratedAmount("Employee No",currentAmount,DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
                    "currentAmount(LCY)":=CalculateProratedAmount("Employee No","currentAmount(LCY)",DATE2DMY("Payroll Period",2),DATE2DMY("Payroll Period",3),DaysInMonth,DaysWorked);
                END;
             END;
             //Calculate Transaction Balances
             IF PayrollTransactions."Balance Type"=PayrollTransactions."Balance Type"::None THEN BEGIN  //Balance Type None
                 CurBalance:= 0;
                 "CurBalance(LCY)":=0;
             END;
             IF PayrollTransactions."Balance Type"=PayrollTransactions."Balance Type"::Increasing THEN BEGIN//Balance Type Increasing
                 CurBalance:= EmployeeTransactions.Balance+ currentAmount;
                 "CurBalance(LCY)":=EmployeeTransactions."Balance(LCY)"+"currentAmount(LCY)";
             END;
             IF PayrollTransactions."Balance Type"=PayrollTransactions."Balance Type"::Reducing THEN BEGIN//Balance Type Decreasing
                 CurBalance :=EmployeeTransactions.Balance - currentAmount;
                 "CurBalance(LCY)":=EmployeeTransactions."Balance(LCY)"-"currentAmount(LCY)";
             END;
             //Sum All NonTaxable Allowances
             IF (NOT PayrollTransactions.Taxable) AND (PayrollTransactions."Special Transaction" =PayrollTransactions."Special Transaction"::Ignore) THEN BEGIN
                 EmpTotalNonTaxAllowances:=EmpTotalNonTaxAllowances+currentAmount;
                 "EmpTotalNonTaxAllowances(LCY)":="EmpTotalNonTaxAllowances(LCY)"+"currentAmount(LCY)";
             END;
             //Exclude Special transaction that are not taxable in list of Allowances
             IF (NOT PayrollTransactions.Taxable) AND (PayrollTransactions."Special Transaction"<>PayrollTransactions."Special Transaction"::Ignore) THEN BEGIN
                currentAmount:=0;
                "currentAmount(LCY)":=0;
             END;
             //Sum All Allowances
             EmpTotalAllowances:=EmpTotalAllowances+currentAmount;
             "EmpTotalAllowances(LCY)":="EmpTotalAllowances(LCY)"+"currentAmount(LCY)";

             TransDescription :=PayrollTransactions."Transaction Name";
             "Transaction Type" :=TALLOWANCE;
             Grouping:= 3;SubGrouping:=0;

             //Posting Details
             IF PayrollTransactions.SubLedger<>PayrollTransactions.SubLedger::" " THEN BEGIN
                IF PayrollTransactions.SubLedger=PayrollTransactions.SubLedger::Customer THEN BEGIN
                    Customer.RESET;
                    Customer.SETRANGE(Customer."No.","Employee No");
                    IF Customer.FINDFIRST THEN BEGIN
                       "Account Type":="Account Type"::Member;
                       "Account No.":=Customer."No.";
                    END;
                END;


              END ELSE IF PayrollTransactions.SubLedger=PayrollTransactions.SubLedger::Vendor THEN BEGIN
                Customer.RESET;
                    Customer.SETRANGE(Customer."Payroll/Staff No","Employee No");
                    IF Customer.FIND('-') THEN BEGIN
                       "Account Type":="Account Type"::Vendor;
                       "Account No.":=Customer."FOSA Account";
                       "co-op":=PayrollTransactions."Co-Op Parameters";

                    END;


              END ELSE BEGIN
                "Account Type":="Account Type"::"G/L Account";
                "Account No.":=PayrollTransactions."G/L Account";
              END;
              //End posting Details
              "co-op":="co-op"::None;
              InsertMonthlyTransactions("Employee No",PayrollTransactions."Transaction Code","Transaction Type",Grouping,SubGrouping,
               TransDescription,currentAmount,"currentAmount(LCY)",CurBalance,"CurBalance(LCY)","Payroll Period",CurMonth, CurYear,"Account Type",
               "Account No.","Posting Type"::Debit,"Global Dimension 1 Code","Global Dimension 2 Code",EmployeeTransactions.Membership,
               EmployeeTransactions."Reference No",Department,"co-op",LoanNo);

           END;
         UNTIL EmployeeTransactions.NEXT=0;
       END;
    END;

    LOCAL PROCEDURE ProcessGrossPay@15("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimeSheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20]);
    BEGIN
       //Set Variables
        "Transaction Code":=TCODE_GPAY;
        "Transaction Type":=TTYPE_GPAY;
        TransDescription:='Gross Pay';
        Grouping:=4;SubGrouping:=0;
        EmpGrossPay:=0;
        "EmpGrossPay(LCY)":=0;
        currentAmount:=0;
        "currentAmount(LCY)":=0;


       EmpGrossPay := (EmpBasicPay+EmpTotalAllowances+EmpSalaryArrear);
       "EmpGrossPay(LCY)":=("EmpBasicPay(LCY)"+"EmpTotalAllowances(LCY)"+"EmpSalaryArrear(LCY)");

       currentAmount:=EmpGrossPay;
       "currentAmount(LCY)":="EmpGrossPay(LCY)";
       "co-op":="co-op"::None;
       //Insert into Monthly Transaction
       InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
       TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
       "Account No.","Posting Type"::" ","Global Dimension 1 Code","Global Dimension 2 Code",'',
        '',Department,"co-op",LoanNo);
    END;

    LOCAL PROCEDURE ProcessDeductions@3("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimesheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20]);
    BEGIN
      EmpDeduction:=0;
      "EmpDeduction(LCY)":=0;

       //Get Earnings
       EmployeeTransactions.RESET;
       EmployeeTransactions.SETRANGE(EmployeeTransactions."No.","Employee No");
       EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Month",CurMonth);
       EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Year",CurYear);
       EmployeeTransactions.SETRANGE(EmployeeTransactions."Transaction Type",EmployeeTransactions."Transaction Type"::Deduction);
       IF EmployeeTransactions.FINDSET THEN BEGIN
         REPEAT
           currentAmount:=0;"currentAmount(LCY)":=0;CurBalance := 0; TransDescription := ''; TransFormula:= '';
           "Transaction Code":='';Grouping:=0;SubGrouping:=0;

           PayrollTransactions.RESET;
           PayrollTransactions.SETRANGE(PayrollTransactions."Transaction Code",EmployeeTransactions."Transaction Code");
           IF PayrollTransactions.FIND('-') THEN BEGIN
              IF PayrollTransactions."Is Formulae" THEN BEGIN
                 TransFormula:=ExpandFormula("Employee No",CurMonth,CurYear,PayrollTransactions.Formulae);
                 currentAmount:=FormulaResult(TransFormula);
                 "currentAmount(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",currentAmount,"Currency Factor"),1,'<');
              END ELSE BEGIN
                 currentAmount:=EmployeeTransactions.Amount;
                 "currentAmount(LCY)":=EmployeeTransactions."Amount(LCY)";
              END;

              PayrollGenSetup.GET;
              IF (PayrollTransactions."Special Transaction"=PayrollTransactions."Special Transaction"::"Life Insurance")AND (PayrollTransactions."Deduct Premium"=FALSE) THEN BEGIN
                 currentAmount:=0;
                 "currentAmount(LCY)":=0;
              END;

              IF(PayrollTransactions."Special Transaction"=PayrollTransactions."Special Transaction"::Morgage)AND (PayrollTransactions."Deduct Mortgage"=FALSE) THEN BEGIN
                 currentAmount:=0;
                 "currentAmount(LCY)":=0;
              END;

                //IF PayrollTransactions.GET()
             //Posting Details
             //IF PayrollTransactions.SubLedger<>PayrollTransactions.SubLedger::" " THEN BEGIN
                IF PayrollTransactions.SubLedger=PayrollTransactions.SubLedger::Customer THEN BEGIN
                    Customer.RESET;
                    Customer.SETRANGE(Customer."Payroll/Staff No","Employee No");
                    IF Customer.FIND('-') THEN BEGIN
                       "Account Type":="Account Type"::Member;
                       "Account No.":=Customer."No.";
                       "co-op":=PayrollTransactions."Co-Op Parameters";

                    END;
                //END;
              END  ELSE IF PayrollTransactions.SubLedger=PayrollTransactions.SubLedger::Vendor THEN BEGIN
                Customer.RESET;
                    Customer.SETRANGE(Customer."Payroll/Staff No","Employee No");
                    IF Customer.FIND('-') THEN BEGIN
                       "Account Type":="Account Type"::Vendor;
                       "Account No.":=Customer."FOSA Account";
                       "co-op":=PayrollTransactions."Co-Op Parameters";

                    END;
                    END ELSE BEGIN
                 "Account Type":="Account Type"::"G/L Account";
                "Account No.":=PayrollTransactions."G/L Account";
              END;
             //End posting Details

             //Amortized Loan Calculation
              IF (PayrollTransactions."Special Transaction"=PayrollTransactions."Special Transaction"::"Staff Loan") AND
                 (PayrollTransactions."Repayment Method"=PayrollTransactions."Repayment Method"::Amortized) THEN BEGIN

                 currentAmount:=0; "currentAmount(LCY)":=0; EmpLoan:=0;"EmpLoan(LCY)":=0;
                 EmpLoan:=CalculateLoanInterest ("Employee No",EmployeeTransactions."Transaction Code",
                              PayrollTransactions."Interest Rate",PayrollTransactions."Repayment Method",
                              EmployeeTransactions."Original Amount",EmployeeTransactions.Balance,"Payroll Period",FALSE);
                 IF "Currency Code"<>'' THEN
                    "EmpLoan(LCY)":=CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",EmpLoan,"Currency Factor")
                 ELSE
                    "EmpLoan(LCY)":=0;
                 LoanNo:=EmployeeTransactions."Loan Number";
                 //Post the Interest
                 IF (EmpLoan<>0) THEN BEGIN
                        currentAmount := EmpLoan;
                        "currentAmount(LCY)":="EmpLoan(LCY)";

                        EmpDeduction:=EmpDeduction+currentAmount;
                        "EmpDeduction(LCY)":="EmpDeduction(LCY)"+"currentAmount(LCY)";

                        CurBalance:=0;"CurBalance(LCY)":=0;

                        "Transaction Code":=EmployeeTransactions."Transaction Code"+'-INT';
                        TransDescription:=EmployeeTransactions."Transaction Name"+ 'Interest';
                        "Transaction Type":= 'DEDUCTIONS';
                        Grouping:= 8;SubGrouping:=1;
                        InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
                            TransDescription,currentAmount,"currentAmount(LCY)",CurBalance,"CurBalance(LCY)","Payroll Period",CurMonth, CurYear,"Account Type",
                            "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'','',Department,"co-op",LoanNo);

                  END;
                 currentAmount:=EmployeeTransactions."Amtzd Loan Repay Amt"-EmpLoan;
                 "currentAmount(LCY)":=EmployeeTransactions."Amtzd Loan Repay Amt(LCY)"-"EmpLoan(LCY)";
              END;
             //End Amortized Loan

             //Calculate Transaction Balances
             IF PayrollTransactions."Balance Type"=PayrollTransactions."Balance Type"::None THEN BEGIN  //Balance Type None
                 CurBalance:= 0;
                 "CurBalance(LCY)":=0;
             END;
             IF PayrollTransactions."Balance Type"=PayrollTransactions."Balance Type"::Increasing THEN BEGIN//Balance Type Increasing
                 CurBalance:= EmployeeTransactions.Balance+ currentAmount;
                 "CurBalance(LCY)":=EmployeeTransactions."Balance(LCY)"+"currentAmount(LCY)";
             END;
             IF PayrollTransactions."Balance Type"=PayrollTransactions."Balance Type"::Reducing THEN BEGIN//Balance Type Decreasing
                IF EmployeeTransactions.Balance < EmployeeTransactions.Amount THEN BEGIN
                  currentAmount:=EmployeeTransactions.Balance;
                  "currentAmount(LCY)":=EmployeeTransactions."Balance(LCY)";
                  CurBalance:= 0;
                  "CurBalance(LCY)":=0;
                END ELSE BEGIN
                  CurBalance:=EmployeeTransactions.Balance-currentAmount;
                  "CurBalance(LCY)":=EmployeeTransactions."Balance(LCY)"-"currentAmount(LCY)";
                END;
                IF CurBalance < 0 THEN BEGIN
                   currentAmount:=0;"currentAmount(LCY)":=0;
                   CurBalance:=0;"CurBalance(LCY)":=0;
                END;
             END;
             EmpDeduction:=EmpDeduction+currentAmount;
             "EmpDeduction(LCY)":="EmpDeduction(LCY)"+"currentAmount(LCY)";
              LoanNo:=EmployeeTransactions."Loan Number";
             "Transaction Code":=PayrollTransactions."Transaction Code";
             TransDescription:=PayrollTransactions."Transaction Name";
             "Transaction Type":='DEDUCTIONS';
             Grouping:= 8;SubGrouping:=0;
             InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
                   TransDescription,currentAmount,"currentAmount(LCY)",CurBalance,"CurBalance(LCY)","Payroll Period",CurMonth, CurYear,"Account Type",
                   "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'','',Department,"co-op",LoanNo);

              //If transaction is loan. Do Loan Calculation
              IF (PayrollTransactions."Special Transaction"=PayrollTransactions."Special Transaction"::"Staff Loan") AND
                 (PayrollTransactions."Repayment Method" <> PayrollTransactions."Repayment Method"::Amortized) THEN BEGIN

                 EmpLoan:=CalculateLoanInterest ("Employee No",EmployeeTransactions."Transaction Code",
                              PayrollTransactions."Interest Rate",PayrollTransactions."Repayment Method",
                              EmployeeTransactions."Original Amount",EmployeeTransactions.Balance,"Payroll Period",FALSE);
                 IF "Currency Code"<>'' THEN
                    "EmpLoan(LCY)":=CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",EmpLoan,"Currency Factor")
                 ELSE
                    "EmpLoan(LCY)":=0;

                 IF EmpLoan>0 THEN BEGIN
                    currentAmount:= EmpLoan;
                    "currentAmount(LCY)":="EmpLoan(LCY)";

                    EmpDeduction:=EmpDeduction+currentAmount;
                    "EmpDeduction(LCY)":="EmpDeduction(LCY)"+"currentAmount(LCY)";
                    LoanNo:=EmployeeTransactions."Loan Number";
                    CurBalance:=0;
                    "Transaction Code":=EmployeeTransactions."Transaction Code"+'-INT';
                    TransDescription:=EmployeeTransactions."Transaction Name"+' '+ 'Interest';
                    "Transaction Type":= 'DEDUCTIONS';
                    Grouping:= 8;SubGrouping:=1;
                    InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
                            TransDescription,currentAmount,"currentAmount(LCY)",CurBalance,"CurBalance(LCY)","Payroll Period",CurMonth, CurYear,"Account Type",
                            "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'','',Department,"co-op",LoanNo);

                   END;
             END;
             //End Loan Calculation
             //Fringe Benefits and Low interest Benefits
             IF PayrollTransactions."Fringe Benefit" = TRUE THEN BEGIN
                 IF PayrollTransactions."Interest Rate" < LoanMarketRate THEN BEGIN
                     EmpFringeBenefit := (((LoanMarketRate - PayrollTransactions."Interest Rate") * LoanCorpRate) / 1200)* EmployeeTransactions.Balance;
                     "EmpFringeBenefit(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",EmpFringeBenefit,"Currency Factor"));
                 END;
              END ELSE BEGIN
                  EmpFringeBenefit := 0;
              END;
              IF EmpFringeBenefit>0 THEN
                 InsertEmployerDeductions("Employee No", EmployeeTransactions."Transaction Code"+'-FRG',
                         'EMP', Grouping, SubGrouping,'Fringe Benefit Tax',EmpFringeBenefit,"EmpFringeBenefit(LCY)",0,0,CurMonth, CurYear,
                          EmployeeTransactions.Membership,EmployeeTransactions."Reference No","Payroll Period",'');

             //End Fringe Benefits

            //Create Employer Deduction
            IF (PayrollTransactions."Employer Deduction") OR (PayrollTransactions."Include Employer Deduction") THEN BEGIN

              IF PayrollTransactions."Formulae for Employer"<>'' THEN BEGIN
                  TransFormula :=ExpandFormula("Employee No",CurMonth,CurYear,PayrollTransactions."Formulae for Employer");
                  currentAmount:=FormulaResult(TransFormula);
                  "currentAmount(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",currentAmount,"Currency Factor"));
              END ELSE BEGIN
                 ProvidentAmount:=(1.5 *EmployeeTransactions."Employer Amount");
               // MESSAGE('%1',ProvidentAmount);
                 currentAmount:=EmployeeTransactions."Employer Amount";
                "currentAmount(LCY)":=EmployeeTransactions."Employer Amount(LCY)";
              END;
              IF currentAmount>0 THEN
                 InsertEmployerDeductions("Employee No", EmployeeTransactions."Transaction Code",
                         'EMP', Grouping, SubGrouping,'DEDUCTION',currentAmount,"currentAmount(LCY)",0,0,CurMonth, CurYear,
                            EmployeeTransactions.Membership,EmployeeTransactions."Reference No","Payroll Period",'');

              IF ProvidentAmount> 0 THEN
                  InsertEmployerDeductions("Employee No", EmployeeTransactions."Transaction Code",
                         'EMP', Grouping, SubGrouping,'PROV DEDUCTION',ProvidentAmount,"currentAmount(LCY)",0,0,CurMonth, CurYear,
                          EmployeeTransactions.Membership,EmployeeTransactions."Reference No","Payroll Period",'');

            END;
            //Employer deductions
           END;
         UNTIL EmployeeTransactions.NEXT=0;
       END;
    END;

    LOCAL PROCEDURE ProcessEmployeeNSSF@22("Employee No"@1014 : Code[20];"Payroll Period"@1013 : Date;"Posting Group"@1012 : Code[20];BasicPay@1011 : Decimal;"BasicPay(LCY)"@1010 : Decimal;"Currency Code"@1009 : Code[20];"Currency Factor"@1008 : Decimal;"Joining Date"@1007 : Date;"Leaving Date"@1006 : Date;BasedOnTimeSheet@1005 : Boolean;"Global Dimension 1 Code"@1004 : Code[20];"Global Dimension 2 Code"@1003 : Code[20];Department@1002 : Code[20];PayesNSSF@1000 : Boolean);
    VAR
      NSSFAmt@1001 : Decimal;
      "NSSFAmt(LCY)"@1015 : Decimal;
    BEGIN
       NSSFBaseAmount:=0;
       "NSSFBaseAmount(LCY)":=0;
       EmpNSSF:=0;
       "EmpNSSF(LCY)":=0;
       currentAmount:=0;
       "currentAmount(LCY)":=0;

       IF PayesNSSF THEN BEGIN
            IF NSSFBasedOn=NSSFBasedOn::Gross THEN BEGIN
              NSSFBaseAmount:=EmpGrossPay;
              "NSSFBaseAmount(LCY)":="EmpGrossPay(LCY)";
            END;
            IF NSSFBasedOn=NSSFBasedOn::Basic THEN BEGIN
              NSSFBaseAmount:=EmpBasicPay;
              "NSSFBaseAmount(LCY)":="EmpBasicPay(LCY)";
            END;
             EmpNSSF:=CalculateEmployeeNSSF(NSSFBaseAmount);
             "EmpNSSF(LCY)":=CalculateEmployeeNSSF("NSSFBaseAmount(LCY)");
             currentAmount:=EmpNSSF;
             "currentAmount(LCY)":="EmpNSSF(LCY)";

            "Transaction Code":=TCODE_NSSF;
            TransDescription:='N.S.S.F';
            "Transaction Type":=TTYPE_STATUTORIES;
            Grouping:= 7;
            SubGrouping:=1;
            IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
               "Account Type":="Account Type"::"G/L Account";
               "Account No.":=PayrollPostingGroup."SSF Employee Account";
            END;

            //Insert Into Monthly Transactions
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
            "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department,"co-op",LoanNo);
       END;
    END;

    LOCAL PROCEDURE ProcessEmployerNSSF@28("Employee No"@1014 : Code[20];"Payroll Period"@1013 : Date;"Posting Group"@1012 : Code[20];BasicPay@1011 : Decimal;"BasicPay(LCY)"@1010 : Decimal;"Currency Code"@1009 : Code[20];"Currency Factor"@1008 : Decimal;"Joining Date"@1007 : Date;"Leaving Date"@1006 : Date;BasedOnTimeSheet@1005 : Boolean;"Global Dimension 1 Code"@1004 : Code[20];"Global Dimension 2 Code"@1003 : Code[20];Department@1002 : Code[20];PayesNSSF@1000 : Boolean);
    VAR
      NSSFAmt@1001 : Decimal;
      ExpenseAccount@1015 : Code[20];
      "NSSFAmt(LCY)"@1016 : Decimal;
      curProvident@1000000000 : Decimal;
      curProvTransAmount@1000000001 : Decimal;
      SpecialTransType@1000000002 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';
      TransAmount@1000000003 : Decimal;
    BEGIN
       {NSSFBaseAmount:=0;
       "NSSFBaseAmount(LCY)":=0;
       NSSFAmt:=0;
       "NSSFAmt(LCY)":=0;
       currentAmount:=0;
       "currentAmount(LCY)":=0;

       IF PayesNSSF THEN BEGIN
            IF NSSFBasedOn=NSSFBasedOn::Gross THEN BEGIN
              NSSFBaseAmount:=EmpGrossPay;
              "NSSFBaseAmount(LCY)":="EmpGrossPay(LCY)";
            END;
            IF NSSFBasedOn=NSSFBasedOn::Basic THEN BEGIN
              NSSFBaseAmount:=EmpBasicPay;
              "NSSFBaseAmount(LCY)":="EmpBasicPay(LCY)";
            END;
             NSSFAmt:=CalculateEmployeeNSSF(NSSFBaseAmount);
             "NSSFAmt(LCY)":=CalculateEmployerNSSF("NSSFBaseAmount(LCY)");
             currentAmount:=NSSFAmt;
             "currentAmount(LCY)":="NSSFAmt(LCY)";

            "Transaction Code":=TCODE_NSSFEMP;
            TransDescription:='N.S.S.F';
            "Transaction Type":=TTYPE_STATUTORIES;
            Grouping:= 7;
            SubGrouping:=1;
            IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
               "Account Type":="Account Type"::"G/L Account";
               "Account No.":=PayrollPostingGroup."SSF Employee Account";
               ExpenseAccount:=PayrollPostingGroup."SSF Employer Account"
            END;

            //Insert Into Monthly Transactions
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
            "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department);
            //Debit to Expense A/C
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
            ExpenseAccount,"Posting Type"::Debit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department);
            //Remove Employer Deductions
            RemoveEmployerDeduction("Employee No","Transaction Code",CurMonth,CurYear);
            //Insert Employer Deductions
            InsertEmployerDeductions("Employee No","Transaction Code","Transaction Type",Grouping, SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,CurMonth, CurYear,'','',"Payroll Period",'');
            }
            //Insert Defined contribution
             NSSFAmt:=CalculateEmployeeNSSF(NSSFBaseAmount);
             "NSSFAmt(LCY)":=CalculateEmployerNSSF("NSSFBaseAmount(LCY)");
             //provident
             TransAmount:=CalculateSpecialTrans("Employee No",CurMonth,CurYear,SpecialTransType::"Defined Contribution",FALSE) ;


            "Transaction Code":='DEFCON';
            "Transaction Type":='TAX CALCULATIONS';
            TransDescription := 'Defined Contributions';
            Grouping:=6;
            SubGrouping:=1;
            EmpDefinedContrib:=NSSFAmt+TransAmount; //(NSSFAmt + StaffPension + TotalNonTaxAllowances) - MorgageRelief
            "EmpDefinedContrib(LCY)":="NSSFAmt(LCY)";//(NSSFAmt(LCY) + StaffPension(LCY) + TotalNonTaxAllowances(LCY)) - MorgageRelief(LCY)
            currentAmount:=EmpDefinedContrib;
            "currentAmount(LCY)":="EmpDefinedContrib(LCY)";




            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type"::"G/L Account",
            '',"Posting Type"::" ","Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department,"co-op",LoanNo);
       //END;
    END;

    LOCAL PROCEDURE ProcessEmployerProvident@1000000000("Employee No"@1014 : Code[20];"Payroll Period"@1013 : Date;"Posting Group"@1012 : Code[20];BasicPay@1011 : Decimal;"BasicPay(LCY)"@1010 : Decimal;"Currency Code"@1009 : Code[20];"Currency Factor"@1008 : Decimal;"Joining Date"@1007 : Date;"Leaving Date"@1006 : Date;BasedOnTimeSheet@1005 : Boolean;"Global Dimension 1 Code"@1004 : Code[20];"Global Dimension 2 Code"@1003 : Code[20];Department@1002 : Code[20]);
    VAR
      NSSFAmt@1001 : Decimal;
      ExpenseAccount@1015 : Code[20];
      "NSSFAmt(LCY)"@1016 : Decimal;
      curProvident@1000000000 : Decimal;
      curProvTransAmount@1000000001 : Decimal;
      SpecialTransType@1000000002 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';
      TransAmount@1000000003 : Decimal;
    BEGIN
       BasicPay:=0;
       currentAmount:=0;
       "currentAmount(LCY)":=0;

       //IF PayesNSSF THEN BEGIN
            IF PrEmployee.GET("Employee No") THEN
              BasicPay:=PrEmployee."Basic Pay";

             currentAmount:=BasicPay*0.15;
             //"currentAmount(LCY)":="NSSFAmt(LCY)";

            "Transaction Code":=TCODE_PFUND;
            TransDescription:='PROVIDENT';
            "Transaction Type":=TCODE_PFUND;
            Grouping:= 8;
            SubGrouping:=1;
            IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
               "Account Type":="Account Type"::"G/L Account";
               "Account No.":=PayrollPostingGroup."Provident Employee Acc";
               ExpenseAccount:=PayrollPostingGroup."Provident Employer Acc"
            END;
            {
            //Insert Into Monthly Transactions
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
            "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department);
            //Debit to Expense A/C
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
            ExpenseAccount,"Posting Type"::Debit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department);
            }
            //Remove Employer Deductions
            RemoveEmployerDeduction("Employee No","Transaction Code",CurMonth,CurYear);
            //Insert Employer Deductions
            InsertEmployerDeductions("Employee No","Transaction Code","Transaction Type",Grouping, SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,CurMonth, CurYear,'','',"Payroll Period",'');

            {
            //Insert Defined contribution
             NSSFAmt:=CalculateEmployeeNSSF(NSSFBaseAmount);
             "NSSFAmt(LCY)":=CalculateEmployerNSSF("NSSFBaseAmount(LCY)");
             //provident
             TransAmount:=CalculateSpecialTrans("Employee No",CurMonth,CurYear,SpecialTransType::"Defined Contribution",FALSE) ;


            "Transaction Code":='DEFCON';
            "Transaction Type":='TAX CALCULATIONS';
            TransDescription := 'Defined Contributions';
            Grouping:=6;
            SubGrouping:=1;
            EmpDefinedContrib:=NSSFAmt+TransAmount; //(NSSFAmt + StaffPension + TotalNonTaxAllowances) - MorgageRelief
            "EmpDefinedContrib(LCY)":="NSSFAmt(LCY)";//(NSSFAmt(LCY) + StaffPension(LCY) + TotalNonTaxAllowances(LCY)) - MorgageRelief(LCY)
            currentAmount:=EmpDefinedContrib;
            "currentAmount(LCY)":="EmpDefinedContrib(LCY)";




            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type"::"G/L Account",
            '',"Posting Type"::" ","Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department,"co-op",LoanNo);
       //END;
       }
    END;

    LOCAL PROCEDURE ProcessNHIF@29("Employee No"@1015 : Code[20];"Payroll Period"@1014 : Date;"Posting Group"@1013 : Code[20];BasicPay@1012 : Decimal;"BasicPay(LCY)"@1011 : Decimal;"Currency Code"@1010 : Code[20];"Currency Factor"@1009 : Decimal;"Joining Date"@1008 : Date;"Leaving Date"@1007 : Date;BasedOnTimeSheet@1006 : Boolean;"Global Dimension 1 Code"@1005 : Code[20];"Global Dimension 2 Code"@1004 : Code[20];Department@1003 : Code[20];PayesNHIF@1002 : Boolean);
    VAR
      NHIFAmt@1000 : Decimal;
      "NHIFAmt(LCY)"@1001 : Decimal;
    BEGIN
       NHIFBaseAmount:=0;
       "NHIFBaseAmount(LCY)":=0;
       EmpNHIF:=0;
       "EmpNHIF(LCY)":=0;
       currentAmount:=0;
       "currentAmount(LCY)":=0;

       IF PayesNHIF THEN BEGIN
            IF NHIFBasedOn=NHIFBasedOn::Gross THEN BEGIN
              NHIFBaseAmount:=EmpGrossPay;
              "NHIFBaseAmount(LCY)":="EmpGrossPay(LCY)";
            END;
            IF NHIFBasedOn=NHIFBasedOn::Basic THEN BEGIN
              NHIFBaseAmount:=EmpBasicPay;
              "NHIFBaseAmount(LCY)":="EmpBasicPay(LCY)";
            END;
             EmpNHIF:=CalculateNHIF(NHIFBaseAmount);
             "EmpNHIF(LCY)":=CalculateNHIF("NHIFBaseAmount(LCY)");
             currentAmount:=EmpNHIF;
             "currentAmount(LCY)":="EmpNHIF(LCY)";

            "Transaction Code":=TCODE_NHIF;
            TransDescription:='N.H.I.F';
            "Transaction Type":=TTYPE_STATUTORIES;
            Grouping:= 7;
            SubGrouping:=2;
            IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
               "Account Type":="Account Type"::"G/L Account";
               "Account No.":=PayrollPostingGroup."NHIF Employee Account";
            END;

            //Insert Into Monthly Transactions
            InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
            TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
            "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
            '',Department,"co-op",LoanNo);
       END;
    END;

    LOCAL PROCEDURE ProcessGrossTaxable@32();
    BEGIN
       EmpGrossTaxable:=0;"EmpGrossTaxable(LCY)":=0;
       //Get the Gross taxable amount
       EmpGrossTaxable:=EmpGrossPay+EmpBenefits+EmpValueOfQuarters;
       "EmpGrossTaxable(LCY)":="EmpGrossPay(LCY)"+"EmpBenefits(LCY)"+"EmpValueOfQuarters(LCY)";

       //If EmpGrossTaxable = 0 Then DefinedContrib ToPost = 0
       IF EmpGrossTaxable = 0 THEN EmpDefinedContrib := 0;
       IF "EmpGrossTaxable(LCY)"= 0 THEN "EmpDefinedContrib(LCY)":= 0;
    END;

    LOCAL PROCEDURE ProcessPersonalRelief@37("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimeSheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20]);
    BEGIN
       "Transaction Code":='PSNR';
       "Transaction Type":='TAX CALCULATIONS';
       Grouping:= 6;SubGrouping:=9;
       TransDescription:='Personal Relief';
       EmpPersonalRelief:=0;"EmpPersonalRelief(LCY)":=0;

       EmpPersonalRelief:=PersonalRelief+EmpUnusedRelief;
       "EmpPersonalRelief(LCY)":="PersonalRelief(LCY)"+"EmpUnusedRelief(LCY)";

       currentAmount:=EmpPersonalRelief;
       "currentAmount(LCY)":="EmpPersonalRelief(LCY)";

       "Account Type":="Account Type"::"G/L Account";
       "Account No.":='';
       //Insert Into Monthly Transactions
       InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
        TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
        "Account No.","Posting Type"::" ","Global Dimension 1 Code","Global Dimension 2 Code",'',
        '',Department,"co-op",LoanNo);
    END;

    LOCAL PROCEDURE ProcessTaxablePay@25("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimeSheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20]);
    BEGIN
       "Transaction Code":='TXBP';
       "Transaction Type":='TAX CALCULATIONS';
       Grouping:= 6;SubGrouping:=6;
       TransDescription:='Taxable Pay';
       EmpTaxableEarning:=0;"EmpTaxableEarning(LCY)":=0;

       IF EmpPensionStaff > MaxPensionContrib THEN
         EmpTaxableEarning:= EmpGrossTaxable - (EmpSalaryArrear + EmpDefinedContrib +MaxPensionContrib+EmpOOI+EmpHOSP+EmpNonTaxable)
       ELSE
         EmpTaxableEarning:= EmpGrossTaxable - (EmpSalaryArrear + EmpDefinedContrib +EmpPensionStaff+EmpOOI+EmpHOSP+EmpNonTaxable);

       IF "Currency Code"<>'' THEN
         "EmpTaxableEarning(LCY)":=CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",EmpTaxableEarning,"Currency Factor")
       ELSE
         "EmpTaxableEarning(LCY)":=EmpTaxableEarning;

       currentAmount:=EmpTaxableEarning;
       "currentAmount(LCY)":="EmpTaxableEarning(LCY)";

       "Account Type":="Account Type"::"G/L Account";
       "Account No.":='';

       //Insert Into Monthly Transactions
       InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
       TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
       "Account No.","Posting Type"::" ","Global Dimension 1 Code","Global Dimension 2 Code",'',
       '',Department,"co-op",LoanNo);
    END;

    LOCAL PROCEDURE ProcessEmpPAYE@42("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimeSheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20];Secondary@1013 : Boolean;GetsPayeBenefit@1014 : Boolean;PayeBenefitPercent@1015 : Decimal);
    BEGIN
       //Get the Tax charged for the month
       "Transaction Code":='TXCHRG';
       "Transaction Type":='TAX CALCULATIONS';
       Grouping:= 6;SubGrouping:=7;
       TransDescription:='Tax Charged';
       EmpTaxCharged:=0;"EmpTaxCharged(LCY)":=0;

       IF Secondary=FALSE THEN BEGIN
         EmpTaxCharged := CalculatePAYE(EmpTaxableEarning,FALSE);
       END ELSE BEGIN
         EmpTaxCharged := CalculatePAYE(EmpTaxableEarning,TRUE);
       END;
       IF "Currency Code"<>'' THEN
         "EmpTaxCharged(LCY)":=CurrExchRate.ExchangeAmtFCYToLCY("Payroll Period","Currency Code",EmpTaxCharged,"Currency Factor")
       ELSE
         "EmpTaxCharged(LCY)":=EmpTaxCharged;

       currentAmount := (EmpTaxCharged);
       "currentAmount(LCY)":="EmpTaxCharged(LCY)";

       "Account Type":="Account Type"::"G/L Account";
       "Account No.":='';
       //Insert Into Monthly Transactions
       InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
       TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
       "Account No.","Posting Type"::" ","Global Dimension 1 Code","Global Dimension 2 Code",'',
       '',Department,"co-op",LoanNo);

       //Insert PAYE amount to post for the month
       "Transaction Code":='PAYE';
       "Transaction Type":='STATUTORIES';
       Grouping:=7;SubGrouping:=3;
       TransDescription:='P.A.Y.E';
       EmpPaye:=0;"EmpPaye(LCY)":=0;

       IF (EmpPersonalRelief+InsuranceReliefAmount)>MaximumRelief THEN BEGIN
         EmpPaye:=EmpTaxCharged-MaximumRelief;
         "EmpPaye(LCY)":="EmpTaxCharged(LCY)"-"MaximumRelief(LCY)";
       END ELSE BEGIN
         EmpPaye:=EmpTaxCharged-(EmpPersonalRelief+InsuranceReliefAmount);
         "EmpPaye(LCY)":="EmpTaxCharged(LCY)"-("EmpPersonalRelief(LCY)"+"InsuranceReliefAmount(LCY)");
       END;
       //If EmpPaye>0 then "Insert into MonthlyTrans table
       IF EmpPaye>0 THEN BEGIN
         currentAmount:=(EmpPaye);
         "currentAmount(LCY)":="EmpPaye(LCY)";

         IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
          "Account Type":="Account Type"::"G/L Account";
          "Account No.":=PayrollPostingGroup."Income Tax Account";
         END;
         //Insert Into Monthly Transactions
         InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
          TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
          "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
          '',Department,"co-op",LoanNo);
       END;

       //If EmpPaye<0 then "Insert into Uuused Relif table
       IF EmpPaye< 0 THEN BEGIN
          UnusedRelief.RESET;
          UnusedRelief.SETRANGE(UnusedRelief."Employee No.","Employee No");
          UnusedRelief.SETRANGE(UnusedRelief."Period Month",CurMonth);
          UnusedRelief.SETRANGE(UnusedRelief."Period Year",CurYear);
          IF UnusedRelief.FINDSET THEN
             UnusedRelief.DELETE;

          UnusedRelief.RESET;
          WITH UnusedRelief DO BEGIN
              INIT;
              "Employee No." :="Employee No";
              "Unused Relief":=EmpPaye;
              "Unused Relief(LCY)":="EmpPaye(LCY)";
              "Period Month":=CurMonth;
              "Period Year":=CurYear;
              INSERT;
          END;
       END;

       //PAYE Benefit
       IF GetsPayeBenefit THEN BEGIN
          "Transaction Code":='PAYEBEN';
          "Transaction Type":='STATUTORIES';
          Grouping:=7;SubGrouping:=10;
          TransDescription:='P.A.Y.E Benefit';
          EmpPayeBenefit:=0;"EmpPayeBenefit(LCY)":=0;

          EmpPayeBenefit:=EmpPaye*(PayeBenefitPercent/100);
          "EmpPayeBenefit(LCY)":="EmpPaye(LCY)"*(PayeBenefitPercent/100);

         currentAmount:=(EmpPayeBenefit);
         "currentAmount(LCY)":="EmpPayeBenefit(LCY)";
         IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
          "Account Type":="Account Type"::"G/L Account";
          "Account No.":=PayrollPostingGroup."PAYE Benefit A/C";
         END;
         //Insert Into Monthly Transactions
         InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
          TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
          "Account No.","Posting Type"::Debit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
          '',Department,"co-op",LoanNo);
       END;
    END;

    LOCAL PROCEDURE ProcessNetPay@23("Employee No"@1012 : Code[20];"Payroll Period"@1011 : Date;"Posting Group"@1010 : Code[20];BasicPay@1009 : Decimal;"BasicPay(LCY)"@1008 : Decimal;"Currency Code"@1007 : Code[20];"Currency Factor"@1006 : Decimal;"Joining Date"@1005 : Date;"Leaving Date"@1004 : Date;BasedOnTimeSheet@1003 : Boolean;"Global Dimension 1 Code"@1002 : Code[20];"Global Dimension 2 Code"@1001 : Code[20];Department@1000 : Code[20]);
    BEGIN
       "Transaction Code":='NPAY';
       "Transaction Type":='NET PAY';
       Grouping:=9;SubGrouping:=0;
       TransDescription:='Net Pay';
       EmpNetPay:=0;"EmpNetPay(LCY)":=0;

       EmpNetPay:=EmpGrossPay-(EmpNSSF+EmpNHIF+EmpPaye+EmpPAYEArrears+EmpDeduction);
       "EmpNetPay(LCY)":="EmpGrossPay(LCY)"-("EmpNSSF(LCY)"+"EmpNHIF(LCY)"+"EmpPaye(LCY)"+"EmpPAYEArrears(LCY)"+"EmpDeduction(LCY)");

       currentAmount:=(EmpNetPay+(EmpPayeBenefit));
       "currentAmount(LCY)":="EmpNetPay(LCY)"+("EmpPayeBenefit(LCY)");

       IF PayrollPostingGroup.GET("Posting Group") THEN BEGIN
          "Account Type":="Account Type"::"G/L Account";
          "Account No.":=PayrollPostingGroup."Net Salary Payable";
       END;
       //Insert Into Monthly Transactions
       InsertMonthlyTransactions("Employee No","Transaction Code","Transaction Type",Grouping,SubGrouping,
          TransDescription,currentAmount,"currentAmount(LCY)",0,0,"Payroll Period",CurMonth, CurYear,"Account Type",
          "Account No.","Posting Type"::Credit,"Global Dimension 1 Code","Global Dimension 2 Code",'',
          '',Department,"co-op",LoanNo);
    END;

    LOCAL PROCEDURE CalculateProratedAmount@4("Employee No"@1000 : Code[20];"Basic Pay"@1001 : Decimal;"Payroll Month"@1002 : Integer;"Payroll Year"@1003 : Integer;DaysInMonth@1004 : Integer;DaysWorked@1005 : Integer) Amount : Decimal;
    BEGIN
        Amount:= ROUND((DaysWorked / DaysInMonth) * "Basic Pay");
    END;

    PROCEDURE GetDaysInMonth@1102756006(dtDate@1102756000 : Date) DaysInMonth : Integer;
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
       IF SysDate.FINDSET THEN
          DaysInMonth:=SysDate.COUNT;
    END;

    PROCEDURE GetDaysWorked@1102756012(dtDate@1102756000 : Date;IsTermination@1102756006 : Boolean) DaysWorked : Integer;
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
       IF SysDate.FINDSET THEN
          DaysWorked:=SysDate.COUNT;
    END;

    PROCEDURE GetDaysWorkedTimesheet@19(EmployeeNo@1102756000 : Code[20];PayrollPeriod@1102756006 : Date) DaysWorked : Integer;
    VAR
      Day@1102756001 : Integer;
      SysDate@1102756005 : Record 2000000007;
      Expr1@1102756004 : Text[30];
      FirstDay@1102756003 : Date;
      LastDate@1102756002 : Date;
      TodayDate@1102756007 : Date;
      EmployeeTimesheet@1000 : Record 51516150;
      BaseCalender@1001 : Record 7600;
      BaseCalenderLines@1002 : Record 7601;
      HRSetup@1003 : Record 51516179;
      NonWorkingDays@1004 : Integer;
      DayDate@1005 : Date;
      DayName@1006 : Text;
      Nonworking@1007 : Boolean;
      CalendarMgmt@1008 : Codeunit 7600;
    BEGIN
      { DaysWorked:=0;NonWorkingDays:=0;
       EmployeeTimesheet.RESET;
       EmployeeTimesheet.SETRANGE(EmployeeTimesheet."Employee No",EmployeeNo);
       EmployeeTimesheet.SETRANGE(EmployeeTimesheet."Period Month",DATE2DMY(PayrollPeriod,2));
       EmployeeTimesheet.SETRANGE(EmployeeTimesheet."Period Year",DATE2DMY(PayrollPeriod,3));
       IF EmployeeTimesheet.FINDSET THEN BEGIN
        REPEAT
           DaysWorked:=DaysWorked+1;
        UNTIL EmployeeTimesheet.NEXT=0;
       END;
       //Get Nonworking Days
       //Get the HR Base Calender
       IF HRSetup.GET THEN BEGIN
        FirstDay:=PayrollPeriod;
        LastDate:=CALCDATE('<CM>',FirstDay);
        SysDate.RESET;
        SysDate.SETRANGE(SysDate."Period Type",SysDate."Period Type"::Date);
        SysDate.SETRANGE(SysDate."Period Start",FirstDay,LastDate);
        IF SysDate.FINDSET THEN BEGIN
          REPEAT
            Nonworking := CalendarMgmt.CheckDateStatus(HRSetup."HR Base Calender",SysDate."Period Start",Description);
            IF Nonworking THEN
              NonWorkingDays:=NonWorkingDays+1;
          UNTIL SysDate.NEXT=0;
        END;
       END;
       //return days worked + non working days
       DaysWorked:=DaysWorked+NonWorkingDays;
       }
    END;

    LOCAL PROCEDURE CalculatePAYE@7(TaxablePay@1001 : Decimal;IsSecondary@1000 : Boolean) PAYE : Decimal;
    VAR
      PAYESetup@1004 : Record 51516213;
      TempAmount@1003 : Decimal;
      Count@1002 : Integer;
    BEGIN
      Count:=0;
      PAYESetup.RESET;
      IF IsSecondary=FALSE THEN BEGIN
        IF PAYESetup.FINDFIRST THEN BEGIN
          IF TaxablePay < PAYESetup."PAYE Tier" THEN EXIT;
          REPEAT
            Count+=1;
            TempAmount:= TaxablePay;
            IF TaxablePay = 0 THEN EXIT;
                  IF Count = PAYESetup.COUNT THEN   //If Last Record
                     TaxablePay := TempAmount
                   ELSE                             //If Not Last Record
                      IF TempAmount >= PAYESetup."PAYE Tier" THEN
                       TempAmount := PAYESetup."PAYE Tier"
                      ELSE
                       TempAmount := TempAmount;

           PAYE := PAYE + (TempAmount * (PAYESetup.Rate / 100));
           TaxablePay := TaxablePay - TempAmount;
        UNTIL PAYESetup.NEXT=0;
        END;
      END ELSE BEGIN
        IF PAYESetup.FINDLAST THEN BEGIN
           PAYE:=TaxablePay*(PAYESetup.Rate/100);
        END;
      END
    END;

    LOCAL PROCEDURE CalculateNHIF@5(BaseAmount@1000 : Decimal) NHIF : Decimal;
    VAR
      NHIFSetup@1001 : Record 51516214;
    BEGIN
      NHIFSetup.RESET;
      NHIFSetup.SETCURRENTKEY(NHIFSetup."Tier Code");
      IF NHIFSetup.FINDSET THEN BEGIN
        REPEAT
          IF ((BaseAmount>=NHIFSetup."Lower Limit") AND (BaseAmount<=NHIFSetup."Upper Limit")) THEN
              NHIF:=NHIFSetup.Amount;
        UNTIL NHIFSetup.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE CalculateEmployerNSSF@8(BaseAmount@1000 : Decimal) NSSF : Decimal;
    VAR
      NSSFSetup@1001 : Record 51516215;
    BEGIN
      NSSFSetup.RESET;
      NSSFSetup.SETCURRENTKEY(NSSFSetup."Tier Code");
      IF NSSFSetup.FINDSET THEN BEGIN
        REPEAT
          IF ((BaseAmount>=NSSFSetup."Lower Limit") AND (BaseAmount<=NSSFSetup."Upper Limit")) THEN
              NSSF:=NSSFSetup."Tier 1 Employer Contribution" + NSSFSetup."Tier 2 Employer Contribution";
        UNTIL NSSFSetup.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE CalculateEmployeeNSSF@18(BaseAmount@1000 : Decimal) NSSF : Decimal;
    VAR
      NSSFSetup@1001 : Record 51516215;
    BEGIN
      NSSFSetup.RESET;
      NSSFSetup.SETCURRENTKEY(NSSFSetup."Tier Code");
      IF NSSFSetup.FINDSET THEN BEGIN
        REPEAT
          IF ((BaseAmount>=NSSFSetup."Lower Limit") AND (BaseAmount<=NSSFSetup."Upper Limit")) THEN
              NSSF:=NSSFSetup."Tier 1 Employee Deduction" + NSSFSetup."Tier 2 Employee Deduction";
        UNTIL NSSFSetup.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE CalculateTaxablePay@16();
    BEGIN
    END;

    LOCAL PROCEDURE CalculateNetPay@17();
    BEGIN
    END;

    PROCEDURE CalculateLoanInterest@1102756027(EmpCode@1102756000 : Code[20];TransCode@1102756001 : Code[20];InterestRate@1102756002 : Decimal;RecoveryMethod@1102756003 : 'Reducing,Straight line,Amortized';LoanAmount@1102756004 : Decimal;Balance@1102756005 : Decimal;CurrPeriod@1102756007 : Date;Welfare@1102756010 : Boolean) LnInterest : Decimal;
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
            //MESSAGE(FORMAT(balance));
               curLoanInt := (InterestRate / 1200) * Balance;

          IF RecoveryMethod = RecoveryMethod::Amortized THEN //Amortized [2]
               curLoanInt := (InterestRate / 1200) * Balance;
      END ELSE
          curLoanInt := 0;

      //Return the Amount
      LnInterest:=curLoanInt;
    END;

    LOCAL PROCEDURE CalculateSpecialTrans@46(EmpCode@1007 : Code[20];Month@1006 : Integer;Year@1005 : Integer;TransID@1004 : 'Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters,Morgage';CompDeduction@1003 : Boolean) TransAmount : Decimal;
    VAR
      EmployeeTransactions@1002 : Record 51516182;
      TransactionCodes@1001 : Record 51516181;
      TransFormula@1000 : Text[250];
      ProvCompAmount@1000000000 : Decimal;
    BEGIN
      TransAmount:=0;
      TransactionCodes.RESET;
      TransactionCodes.SETRANGE(TransactionCodes."Special Transaction",TransID);
      IF TransactionCodes.FINDSET THEN BEGIN
      REPEAT
         EmployeeTransactions.RESET;
         EmployeeTransactions.SETRANGE(EmployeeTransactions."No.",EmpCode);
         EmployeeTransactions.SETRANGE(EmployeeTransactions."Transaction Code",TransactionCodes."Transaction Code");
         EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Month",Month);
         EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Year",Year);
         EmployeeTransactions.SETRANGE(EmployeeTransactions.Suspended,FALSE);
         IF EmployeeTransactions.FINDFIRST THEN BEGIN
            CASE TransID OF
              TransID::"Defined Contribution":
                IF TransactionCodes."Is Formulae" THEN BEGIN
                    TransFormula:='';
                    TransFormula:=ExpandFormula(EmployeeTransactions."No.",Month,Year,TransactionCodes.Formulae);
                    TransAmount:=TransAmount+FormulaResult(TransFormula);
                END ELSE
                    TransAmount := TransAmount+EmployeeTransactions.Amount;


              TransID::"Life Insurance":
                  TransAmount:=TransAmount+((InsuranceRelief/100)*EmployeeTransactions.Amount);

              TransID::"Owner Occupier Interest":
                  TransAmount:=TransAmount+EmployeeTransactions.Amount;


              TransID::"Home Ownership Savings Plan":
                  TransAmount:=TransAmount+EmployeeTransactions.Amount;

              TransID::Morgage:
              BEGIN
                  TransAmount :=TransAmount+ MorgageRelief;
                  IF TransAmount>MorgageRelief THEN BEGIN
                    TransAmount:=MorgageRelief
                   END;
              END;

            END;
         END;
       UNTIL TransactionCodes.NEXT=0;
      END;
      TransAmount:=TransAmount;
      ProvCompAmount := (1.5*TransAmount );
    END;

    LOCAL PROCEDURE InsertMonthlyTransactions@6(EmpNo@1018 : Code[20];TransCode@1017 : Code[20];TransType@1016 : Code[20];Grouping@1015 : Integer;SubGrouping@1014 : Integer;Description@1013 : Text[50];Amount@1012 : Decimal;"Amount(LCY)"@1021 : Decimal;Balance@1011 : Decimal;"Balance(LCY)"@1022 : Decimal;"Payroll Period"@1019 : Date;Month@1010 : Integer;Year@1009 : Integer;"Account Type"@1006 : ' ,G/L Account,Customer,Vendor';"Account No"@1004 : Code[20];"Posting Type"@1003 : ' ,Debit,Credit';"Global Dimension 1 Code"@1001 : Code[50];"Global Dimension 2 Code"@1000 : Code[50];Membership@1007 : Text[30];ReferenceNo@1005 : Text[30];Department@1002 : Code[20];"co-op"@1000000000 : 'None,Shares,Loan,Loan Interest,Emergency Loan,Emergency Loan Interest,School Fees Loan,School Fees Loan Interest,Welfare,Pension,NSSF,Overtime,WSS';LoanNo@1000000001 : Code[10]);
    VAR
      MonthlyTransactions@1020 : Record 51516183;
      PayrollEmployee@1008 : Record 51516180;
    BEGIN
      IF currentAmount = 0 THEN EXIT;
          MonthlyTransactions.INIT;
          MonthlyTransactions."No." := EmpNo;
          MonthlyTransactions."Transaction Code" := TransCode;
          MonthlyTransactions."Group Text" := TransType;
          MonthlyTransactions."Transaction Name":= Description;
          MonthlyTransactions.Amount:=(Amount);
          MonthlyTransactions."Amount(LCY)":=ROUND("Amount(LCY)");
          MonthlyTransactions.Balance:=Balance;
          MonthlyTransactions."Balance(LCY)":="Balance(LCY)";
          MonthlyTransactions.Grouping:=Grouping;
          MonthlyTransactions.SubGrouping:=SubGrouping;
          MonthlyTransactions.Membership:=Membership;
          MonthlyTransactions."Reference No":=ReferenceNo;
          MonthlyTransactions."Period Month":=Month;
          MonthlyTransactions."Period Year" :=Year;
          MonthlyTransactions."Payroll Period":="Payroll Period";
          //MonthlyTransactions."Department Code":=Department;
          MonthlyTransactions."Posting Type":="Posting Type";
          MonthlyTransactions."Account Type":="Account Type";
          MonthlyTransactions."Account No":="Account No";
          MonthlyTransactions."Loan Number":=LoanNo;
          //MonthlyTransactions."Payroll Code":=PayrollCode;
          MonthlyTransactions."Co-Op parameters":="co-op";
          MonthlyTransactions."Global Dimension 1":="Global Dimension 1 Code";
          MonthlyTransactions."Global Dimension 2":="Global Dimension 2 Code";
          IF PayrollEmployee.GET(EmpNo) THEN
            MonthlyTransactions."Payment Mode":=PayrollEmployee."Payment Mode";

         IF MonthlyTransactions.INSERT THEN
            //Update Employee Transactions  with the Amount
            UpdateEmployeeTransactions(EmpNo,TransCode,Amount,"Amount(LCY)","Payroll Period",Month,Year);
    END;

    LOCAL PROCEDURE UpdateEmployeeTransactions@10(EmpNo@1005 : Code[20];TransCode@1004 : Code[20];Amount@1003 : Decimal;"Amount(LCY)"@1007 : Decimal;PayrollPeriod@1006 : Date;Month@1002 : Integer;Year@1001 : Integer);
    VAR
      PayrollEmpTrans@1000 : Record 51516182;
    BEGIN
         PayrollEmpTrans.RESET;
         PayrollEmpTrans.SETRANGE(PayrollEmpTrans."No.",EmpNo);
         PayrollEmpTrans.SETRANGE(PayrollEmpTrans."Transaction Code",TransCode);
         PayrollEmpTrans.SETRANGE(PayrollEmpTrans."Payroll Period",PayrollPeriod);
         PayrollEmpTrans.SETRANGE(PayrollEmpTrans."Period Month",Month);
         PayrollEmpTrans.SETRANGE(PayrollEmpTrans."Period Year",Year);
         IF PayrollEmpTrans.FINDFIRST THEN BEGIN
           PayrollEmpTrans.Amount:=Amount;
           PayrollEmpTrans."Amount(LCY)":="Amount(LCY)";
           PayrollEmpTrans.MODIFY;
         END;
    END;

    LOCAL PROCEDURE InsertEmployeeDeductions@11();
    BEGIN
    END;

    LOCAL PROCEDURE InsertEmployerDeductions@12(EmpCode@1012 : Code[20];TransCode@1011 : Code[20];TransType@1010 : Code[20];Grouping@1009 : Integer;SubGrouping@1008 : Integer;Description@1007 : Text[50];currentAmount@1006 : Decimal;"currentAmount(LCY)"@1015 : Decimal;currentBalance@1005 : Decimal;"currentBalance(LCY)"@1016 : Decimal;Month@1004 : Integer;Year@1003 : Integer;Membership@1002 : Text[30];ReferenceNo@1001 : Text[30];PayrollPeriod@1000 : Date;PayrollCode@1014 : Code[20]);
    VAR
      EmployerDeductions@1013 : Record 51516190;
    BEGIN
      IF currentAmount = 0 THEN EXIT;
      WITH EmployerDeductions DO BEGIN
          INIT;
          "Employee Code":=EmpCode;
          "Transaction Code":=TransCode;
           Amount:=currentAmount;
          "Period Month":=Month;
          "Period Year":=Year;
          "Payroll Period":=PayrollPeriod;
          "Payroll Code":=PayrollCode;
          "Amount(LCY)":="currentAmount(LCY)";
          Group:=Grouping;
          SubGroup:=SubGrouping;
          "Transaction Type":=TransType;
          Description:=Description;
          Balance:=currentBalance;
          "Balance(LCY)":="currentBalance(LCY)";
          "Membership No":=Membership;
          "Reference No":=ReferenceNo;
          INSERT;
      END;
    END;

    LOCAL PROCEDURE RemoveEmployerDeduction@30(EmpCode@1000 : Code[20];TransCode@1001 : Code[20];Month@1002 : Integer;Year@1003 : Integer);
    VAR
      "Payroll Employer Ded"@1004 : Record 51516190;
    BEGIN
       "Payroll Employer Ded".RESET;
       "Payroll Employer Ded".SETRANGE("Payroll Employer Ded"."Employee Code",EmpCode);
       "Payroll Employer Ded".SETRANGE("Payroll Employer Ded"."Transaction Code",TransCode);
       "Payroll Employer Ded".SETRANGE("Payroll Employer Ded"."Period Month",Month);
       "Payroll Employer Ded".SETRANGE("Payroll Employer Ded"."Period Year",Year);
       IF "Payroll Employer Ded".FINDSET THEN
          "Payroll Employer Ded".DELETEALL;
    END;

    LOCAL PROCEDURE InsertSalaryArrears@13();
    BEGIN
    END;

    LOCAL PROCEDURE UpdateP9Information@35(Month@1000 : Integer;Year@1001 : Integer;"Payroll Period"@1002 : Date);
    VAR
      P9BasicPay@1003 : Decimal;
      P9Allowances@1004 : Decimal;
      P9Benefits@1005 : Decimal;
      P9ValueOfQuarters@1007 : Decimal;
      P9DefinedContribution@1008 : Decimal;
      P9OwnerOccupierInterest@1009 : Decimal;
      P9GrossPay@1010 : Decimal;
      P9TaxablePay@1011 : Decimal;
      P9TaxCharged@1012 : Decimal;
      P9InsuranceRelief@1013 : Decimal;
      P9TaxRelief@1014 : Decimal;
      P9Paye@1015 : Decimal;
      P9NSSF@1016 : Decimal;
      P9NHIF@1017 : Decimal;
      P9Deductions@1018 : Decimal;
      P9NetPay@1019 : Decimal;
      PayrollEmployee@1020 : Record 51516180;
      MonthlyTransactions@1021 : Record 51516183;
    BEGIN
      P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
      P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
      P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
      P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
      P9Deductions := 0; P9NetPay := 0;

      PayrollEmployee.RESET;
      PayrollEmployee.SETRANGE(PayrollEmployee.Status,PayrollEmployee.Status::Active);
      IF PayrollEmployee.FINDSET THEN BEGIN
       REPEAT
        P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
        P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
        P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
        P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
        P9Deductions := 0; P9NetPay := 0;

        MonthlyTransactions.RESET;
        MonthlyTransactions.SETRANGE(MonthlyTransactions."Period Month",Month);
        MonthlyTransactions.SETRANGE(MonthlyTransactions."Period Year",Year);
        MonthlyTransactions.SETRANGE(MonthlyTransactions."No.",PayrollEmployee."No.");
        IF MonthlyTransactions.FINDSET THEN BEGIN
         REPEAT
            CASE MonthlyTransactions.Grouping OF
                1: //Basic pay & Arrears
                BEGIN
                  IF SubGrouping = 1 THEN P9BasicPay :=MonthlyTransactions.Amount; //Basic Pay
                  IF SubGrouping = 2 THEN P9BasicPay := P9BasicPay+MonthlyTransactions.Amount; //Basic Pay Arrears
                END;
                3:  //Allowances
                BEGIN
                 P9Allowances := P9Allowances+MonthlyTransactions.Amount
                END;
                4: //Gross Pay
                BEGIN
                  P9GrossPay :=MonthlyTransactions.Amount
                END;
                6: //Taxation
                BEGIN
                  IF SubGrouping = 1 THEN P9DefinedContribution :=MonthlyTransactions.Amount; //Defined Contribution
                  IF SubGrouping = 9 THEN P9TaxRelief :=MonthlyTransactions.Amount; //Tax Relief
                  IF SubGrouping = 8 THEN P9InsuranceRelief :=MonthlyTransactions.Amount; //Insurance Relief
                  IF SubGrouping = 6 THEN P9TaxablePay :=MonthlyTransactions.Amount; //Taxable Pay
                  IF SubGrouping = 7 THEN P9TaxCharged :=MonthlyTransactions.Amount; //Tax Charged
                END;
                7: //Statutories
                BEGIN
                  IF SubGrouping = 1 THEN P9NSSF :=MonthlyTransactions.Amount; //Nssf
                  IF SubGrouping = 2 THEN P9NHIF :=MonthlyTransactions.Amount; //Nhif
                  IF SubGrouping = 3 THEN P9Paye :=MonthlyTransactions.Amount; //paye
                  IF SubGrouping = 4 THEN P9Paye :=P9Paye+MonthlyTransactions.Amount; //Paye Arrears
                END;
                8://Deductions
                BEGIN
                  P9Deductions := P9Deductions +MonthlyTransactions.Amount;
                END;
                9: //NetPay
                BEGIN
                  P9NetPay :=MonthlyTransactions.Amount;
                END;
             END;
          UNTIL MonthlyTransactions.NEXT=0;
         END;
         //Insert the P9 Details
         IF P9NetPay <> 0 THEN
           InsertP9Information(PayrollEmployee."No.","Payroll Period",P9BasicPay, P9Allowances, P9Benefits, P9ValueOfQuarters, P9DefinedContribution,
              P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged, P9InsuranceRelief, P9TaxRelief, P9Paye, P9NSSF,
              P9NHIF,P9Deductions,P9NetPay);
        UNTIL PayrollEmployee.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE InsertP9Information@14(EmpCode@1017 : Code[20];"Payroll Period"@1018 : Date;P9BasicPay@1016 : Decimal;P9Allowances@1015 : Decimal;P9Benefits@1014 : Decimal;P9ValueOfQuarters@1012 : Decimal;P9DefinedContribution@1011 : Decimal;P9OwnerOccupierInterest@1010 : Decimal;P9GrossPay@1009 : Decimal;P9TaxablePay@1008 : Decimal;P9TaxCharged@1007 : Decimal;P9InsuranceRelief@1006 : Decimal;P9TaxRelief@1005 : Decimal;P9Paye@1004 : Decimal;P9NSSF@1003 : Decimal;P9NHIF@1002 : Decimal;P9Deductions@1001 : Decimal;P9NetPay@1000 : Decimal);
    VAR
      Month@1013 : Integer;
      Year@1019 : Integer;
      PayrollP9@1020 : Record 51516184;
    BEGIN
      Month := DATE2DMY("Payroll Period",2);
      Year := DATE2DMY("Payroll Period",3);

      PayrollP9.RESET;
      WITH PayrollP9 DO BEGIN
          INIT;
          "Employee Code":=EmpCode;
          "Basic Pay":=P9BasicPay;
          Allowances:=P9Allowances;
          Benefits:=P9Benefits;
          "Value Of Quarters":=P9ValueOfQuarters;
          "Defined Contribution":=P9DefinedContribution;
          "Owner Occupier Interest":=P9OwnerOccupierInterest;
          "Gross Pay":=P9GrossPay;
          "Taxable Pay":=P9TaxablePay;
          "Tax Charged":=P9TaxCharged;
          "Insurance Relief":=P9InsuranceRelief;
          "Tax Relief":=P9TaxRelief;
          PAYE:=P9Paye;
          NSSF:=P9NSSF;
          NHIF:=P9NHIF;
          Deductions:=P9Deductions;
          "Net Pay":=P9NetPay;
          "Period Month":=Month;
          "Period Year":=Year;
          "Payroll Period":="Payroll Period";
          INSERT;
      END;
    END;

    LOCAL PROCEDURE InsertNegativePay@36(Month@1002 : Integer;Year@1001 : Integer;"Payroll Period"@1000 : Date);
    VAR
      NewPayrollPeriod@1003 : Date;
      NewMonth@1004 : Integer;
      NewYear@1005 : Integer;
      MonthlyTransactions@1006 : Record 51516183;
      EmployeeTrans@1007 : Record 51516182;
      TCODE@1008 : TextConst 'ENU=NEGP';
      TNAME@1009 : TextConst 'ENU=Negative Pay';
    BEGIN
      NewPayrollPeriod := CALCDATE('1M',"Payroll Period");
      NewMonth := DATE2DMY(NewPayrollPeriod,2);
      NewYear := DATE2DMY(NewPayrollPeriod,3);

      MonthlyTransactions.RESET;
      MonthlyTransactions.SETRANGE(MonthlyTransactions."Period Month",Month);
      MonthlyTransactions.SETRANGE(MonthlyTransactions."Period Year",Year);
      MonthlyTransactions.SETRANGE(MonthlyTransactions.Grouping,9);
      MonthlyTransactions.SETFILTER(MonthlyTransactions.Amount,'<0');
      IF MonthlyTransactions.FINDFIRST THEN BEGIN
        REPEAT
          WITH EmployeeTrans DO BEGIN
            INIT;
            "No.":=MonthlyTransactions."No.";
            "Transaction Code":=TCODE;
            "Transaction Name":=TNAME;
            "Transaction Type":="Transaction Type"::Deduction;
            Amount:=MonthlyTransactions.Amount;
            "Amount(LCY)":=MonthlyTransactions."Amount(LCY)";
            Balance:= 0;
            "Original Amount":=0;
            "Period Month":=NewMonth;
            "Period Year":=NewYear;
            "Payroll Period":=NewPayrollPeriod;
            INSERT;
          END;
        UNTIL MonthlyTransactions.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE ExpandFormula@9(EmpNo@1003 : Code[20];Month@1002 : Integer;Year@1001 : Integer;strFormula@1000 : Text[250]) Formula : Text[250];
    VAR
      Where@1016 : Text[30];
      Which@1015 : Text[30];
      i@1014 : Integer;
      TransCode@1013 : Code[20];
      Char@1012 : Text[1];
      FirstBracket@1011 : Integer;
      StartCopy@1010 : Boolean;
      FinalFormula@1009 : Text[250];
      TransCodeAmount@1008 : Decimal;
      AccSchedLine@1007 : Record 85;
      ColumnLayout@1006 : Record 334;
      CalcAddCurr@1005 : Boolean;
      AccSchedMgt@1004 : Codeunit 8;
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
          TransCodeAmount:=GetTransAmount(EmpNo, TransCode,Month,Year);
          //Reset Transcode
           TransCode:='';
          //Get Final Formula
           FinalFormula:=FinalFormula+FORMAT(TransCodeAmount);
          //End Get Transcode
         END;
         END;
         Formula:=FinalFormula;
    END;

    LOCAL PROCEDURE GetTransAmount@20(EmpNo@1003 : Code[20];TransCode@1002 : Code[20];Month@1001 : Integer;Year@1000 : Integer) TransAmount : Decimal;
    VAR
      EmployeeTransactions@1005 : Record 51516182;
      MonthlyTransactions@1004 : Record 51516183;
      EmpPayrollCard@1006 : Record 51516180;
    BEGIN
      EmployeeTransactions.RESET;
      EmployeeTransactions.SETRANGE(EmployeeTransactions."No.",EmpNo);
      EmployeeTransactions.SETRANGE(EmployeeTransactions."Transaction Code",TransCode);
      EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Month",Month);
      EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Year",Year);
      EmployeeTransactions.SETRANGE(EmployeeTransactions.Suspended,FALSE);
      IF EmployeeTransactions.FINDFIRST THEN BEGIN
        TransAmount:=EmployeeTransactions.Amount;
        IF EmployeeTransactions."No of Units"<>0 THEN
           TransAmount:=EmployeeTransactions."No of Units";
      END;

      IF TransAmount=0 THEN BEGIN
        MonthlyTransactions.RESET;
        MonthlyTransactions.SETRANGE(MonthlyTransactions."No.",EmpNo);
        MonthlyTransactions.SETRANGE(MonthlyTransactions."Transaction Code",TransCode);
        MonthlyTransactions.SETRANGE(MonthlyTransactions."Period Month",Month);
        MonthlyTransactions.SETRANGE(MonthlyTransactions."Period Year",Year);
        IF MonthlyTransactions.FINDFIRST THEN
          TransAmount:=MonthlyTransactions.Amount;
      END;

      IF (TransAmount=0)AND (TransCode='BPAY') THEN BEGIN
        EmpPayrollCard.RESET;
        EmpPayrollCard.SETRANGE(EmpPayrollCard."No.",EmpNo);
        IF EmpPayrollCard.FINDFIRST THEN BEGIN
         TransAmount:=EmpPayrollCard."Basic Pay";
        END;
      END;
    END;

    LOCAL PROCEDURE FormulaResult@27(Formula@1004 : Text[250]) Results : Decimal;
    VAR
      AccSchedLine@1003 : Record 85;
      ColumnLayout@1002 : Record 334;
      CalcAddCurr@1001 : Boolean;
      AccSchedMgt@1000 : Codeunit 8;
    BEGIN
      Results:=AccSchedMgt.EvaluateExpression(TRUE,Formula,AccSchedLine,ColumnLayout,CalcAddCurr);
    END;

    PROCEDURE ClosePayrollPeriod@31(CurrentPayrollPeriod@1003 : Date);
    VAR
      NewPayrollPeriod@1000 : Date;
      NewYear@1001 : Integer;
      NewMonth@1002 : Integer;
      EmployeeTransactions2@1004 : Record 51516182;
      PayrollCalender@1005 : Record 51516185;
      NewPayrollCalender@1006 : Record 51516185;
      CurrentMonth@1007 : Integer;
      CurrentYear@1008 : Integer;
      Month@1009 : Integer;
      Year@1010 : Integer;
    BEGIN
      currentAmount:=0;
      "currentAmount(LCY)":=0;
      CurBalance:= 0;
      "CurBalance(LCY)":= 0;

      CurrentMonth:= DATE2DMY(CurrentPayrollPeriod,2);
      CurrentYear:= DATE2DMY(CurrentPayrollPeriod,3);
      Month := DATE2DMY(CurrentPayrollPeriod,2);
      Year := DATE2DMY(CurrentPayrollPeriod,3);

      NewPayrollPeriod := CALCDATE('1M',CurrentPayrollPeriod);
      NewYear:= DATE2DMY(NewPayrollPeriod,3);
      NewMonth:= DATE2DMY(NewPayrollPeriod,2);

      EmployeeTransactions.RESET;
      EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Month",Month);
      EmployeeTransactions.SETRANGE(EmployeeTransactions."Period Year",Year);
      IF EmployeeTransactions.FINDSET THEN BEGIN
        REPEAT
         PayrollTransactions.RESET;
         PayrollTransactions.SETRANGE(PayrollTransactions."Transaction Code",EmployeeTransactions."Transaction Code");
         IF PayrollTransactions.FINDFIRST THEN BEGIN
            CASE PayrollTransactions."Balance Type" OF
               PayrollTransactions."Balance Type"::None:
               BEGIN
                currentAmount:=EmployeeTransactions.Amount;
                "currentAmount(LCY)":=EmployeeTransactions."Amount(LCY)";
                CurBalance:= 0;
                "CurBalance(LCY)":= 0;
               END;

               PayrollTransactions."Balance Type"::Increasing:
               BEGIN
                currentAmount:=EmployeeTransactions.Amount;
                "currentAmount(LCY)":=EmployeeTransactions."Amount(LCY)";
                CurBalance:=EmployeeTransactions.Balance + EmployeeTransactions.Amount;
                "CurBalance(LCY)":=EmployeeTransactions.Balance + EmployeeTransactions.Amount;
               END;

               PayrollTransactions."Balance Type"::Reducing:
               BEGIN
                currentAmount:=EmployeeTransactions.Amount;
                "currentAmount(LCY)":=EmployeeTransactions."Amount(LCY)";
                 IF EmployeeTransactions.Balance < EmployeeTransactions.Amount THEN BEGIN
                     currentAmount:= EmployeeTransactions.Balance;
                     CurBalance:= 0;
                     "CurBalance(LCY)":=0;
                 END ELSE BEGIN
                    CurBalance:=EmployeeTransactions.Balance - EmployeeTransactions.Amount;
                    "CurBalance(LCY)":=EmployeeTransactions.Balance - EmployeeTransactions.Amount;
                 END;
                 IF CurBalance < 0 THEN BEGIN
                     currentAmount:=0;
                     "currentAmount(LCY)":=0;
                     CurBalance:=0;
                     "CurBalance(LCY)":=0;
                 END;
                END;
               END;
          //Transactions with Start and End Date Specified
             IF(EmployeeTransactions."Start Date"<>0D) AND (EmployeeTransactions."End Date"<>0D) THEN BEGIN
                 IF EmployeeTransactions."End Date"<NewPayrollPeriod THEN BEGIN
                     currentAmount:=0;
                     "currentAmount(LCY)":=0;
                     CurBalance:=0;
                     "CurBalance(LCY)":=0;
                 END;
             END;
          //End Transactions with Start and End Date

          IF (PayrollTransactions.Frequency=PayrollTransactions.Frequency::Fixed) AND(EmployeeTransactions."Stop for Next Period"=FALSE) THEN BEGIN
             IF (currentAmount <> 0) THEN BEGIN
               IF ((PayrollTransactions."Balance Type"=PayrollTransactions."Balance Type"::Reducing) AND (CurBalance <> 0)) OR (PayrollTransactions."Balance Type"<>PayrollTransactions."Balance Type"::Reducing) THEN
                  EmployeeTransactions.Balance:=CurBalance;
               EmployeeTransactions.MODIFY;
               //Insert record for the next period
               WITH EmployeeTransactions2 DO BEGIN
                  INIT;
                 "No.":=EmployeeTransactions."No.";
                  "Transaction Code":=EmployeeTransactions."Transaction Code";
                  "Transaction Name":=EmployeeTransactions."Transaction Name";
                  Amount:= currentAmount;
                  "Amount(LCY)":="currentAmount(LCY)";
                  Balance:=CurBalance;
                  "Balance(LCY)":="CurBalance(LCY)";
                  "Amtzd Loan Repay Amt":=EmployeeTransactions."Amtzd Loan Repay Amt";
                  "Amtzd Loan Repay Amt(LCY)":=EmployeeTransactions."Amtzd Loan Repay Amt(LCY)";
                  "Original Amount":=EmployeeTransactions."Original Amount";
                  Membership:=EmployeeTransactions.Membership;
                  "Reference No":=EmployeeTransactions."Reference No";
                  "Loan Number":=EmployeeTransactions."Loan Number";
                  "Period Month":=NewMonth;
                  "Period Year":=NewYear;
                  "Payroll Period":=NewPayrollPeriod;
                  INSERT;
               END;
             END;
           END;
          END;
        UNTIL EmployeeTransactions.NEXT=0;
      END;

      //Close Payroll Period
      PayrollCalender.RESET;
      PayrollCalender.SETRANGE(PayrollCalender."Period Year",CurrentYear);
      PayrollCalender.SETRANGE(PayrollCalender."Period Month",CurrentMonth);
      PayrollCalender.SETRANGE(PayrollCalender.Closed,FALSE);
      IF PayrollCalender.FINDFIRST THEN BEGIN
         PayrollCalender.Closed:=TRUE;
         PayrollCalender."Date Closed":=TODAY;
         PayrollCalender.MODIFY;
      END;

      //Enter a New Period
      WITH NewPayrollCalender DO BEGIN
        INIT;
        "Period Month":=NewMonth;
        "Period Year":=NewYear;
        "Period Name":=FORMAT(NewPayrollPeriod,0,'<Month Text>')+' - '+FORMAT(NewYear);
        "Date Opened":=NewPayrollPeriod;
        Closed :=FALSE;
        INSERT;
      END;

      //Update P9 Information
      UpdateP9Information(CurrentMonth,CurrentYear,CurrentPayrollPeriod);

      //If there are any Negative Payments Take Them to Next Period as Deductions
      InsertNegativePay(CurrentMonth,CurrentYear,CurrentPayrollPeriod);
    END;

    BEGIN
    {
        {MultiCurrency Ready}
    }
    END.
  }
}

