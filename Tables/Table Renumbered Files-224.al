OBJECT table 20365 Data Sheet Main
{
  OBJECT-PROPERTIES
  {
    Date=02/07/23;
    Time=[ 4:54:45 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;PF/Staff No         ;Code30         }
    { 2   ;   ;Name                ;Code50         }
    { 3   ;   ;ID NO.              ;Code50         }
    { 4   ;   ;Type of Deduction   ;Code50         }
    { 5   ;   ;Amount ON           ;Decimal       ;OnValidate=BEGIN
                                                                Cust.RESET;
                                                                Cust.SETCURRENTKEY(Cust."Payroll/Staff No");
                                                                Cust.SETRANGE(Cust."Payroll/Staff No","PF/Staff No");
                                                                Cust.SETRANGE(Cust."ID No.","ID NO.");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Name:=Cust.Name;
                                                                "ID NO.":=Cust."ID No.";
                                                                "REF.":='2026';
                                                                Employer:=Cust."Employer Code";
                                                                Date2:=TODAY+30;
                                                                Date:=TODAY;
                                                                "Repayment Method":=Cust."Repayment Method";
                                                                "Payroll Month":=FORMAT(DATE2DMY(Date2,2))+'/'+FORMAT(DATE2DMY(Date2,3));
                                                                END;

                                                                PTEN:='';

                                                                IF STRLEN("PF/Staff No")=10 THEN BEGIN
                                                                PTEN:=COPYSTR("PF/Staff No",10);
                                                                END ELSE IF STRLEN("PF/Staff No")=9 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",9);
                                                                END ELSE IF STRLEN("PF/Staff No")=8 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",8);
                                                                END ELSE IF STRLEN("PF/Staff No")=7 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",7);
                                                                END ELSE IF STRLEN("PF/Staff No")=6 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",6);
                                                                END ELSE IF STRLEN("PF/Staff No")=5 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",5);
                                                                END ELSE IF STRLEN("PF/Staff No")=4 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",4);
                                                                END ELSE IF STRLEN("PF/Staff No")=3 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",3);
                                                                END ELSE IF STRLEN("PF/Staff No")=2 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",2);
                                                                END ELSE IF STRLEN("PF/Staff No")=1 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",1);
                                                                 END;

                                                                "Sort Code":=PTEN;


                                                                {IF LoanTypes.GET(LoanTopUp."Loan Type") THEN BEGIN
                                                                IF customer.GET(LoanTopUp."Client Code") THEN BEGIN
                                                                //Loans."Staff No":=customer."Payroll/Staff No";
                                                                DataSheet.INIT;
                                                                DataSheet."PF/Staff No":=LoanTopUp."Staff No";
                                                                DataSheet."Type of Deduction":=LoanTypes."Product Description";
                                                                DataSheet."Remark/LoanNO":=LoanTopUp."Loan Top Up";
                                                                DataSheet.Name:=LoanApps."Client Name";
                                                                DataSheet."ID NO.":=LoanApps."ID NO";
                                                                DataSheet."Amount ON":=0;
                                                                DataSheet."Amount OFF":=LoanTopUp."Total Top Up";
                                                                DataSheet."REF.":='2026';
                                                                DataSheet."New Balance":=0;
                                                                DataSheet.Date:=Loans."Issued Date";
                                                                DataSheet.Employer:=customer."Employer Code";
                                                                DataSheet."Transaction Type":=DataSheet."Transaction Type"::ADJUSTMENT;
                                                                DataSheet."Sort Code":=PTEN;
                                                                DataSheet.INSERT;
                                                                END;
                                                                END; }
                                                              END;
                                                               }
    { 6   ;   ;Amount OFF          ;Decimal       ;OnValidate=BEGIN
                                                                Cust.RESET;
                                                                Cust.SETCURRENTKEY(Cust."Payroll/Staff No");
                                                                Cust.SETRANGE(Cust."Payroll/Staff No","PF/Staff No");
                                                                Cust.SETRANGE(Cust."ID No.","ID NO.");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Name:=Cust.Name;
                                                                "ID NO.":=Cust."ID No.";
                                                                "REF.":='2026';
                                                                Employer:=Cust."Employer Code";
                                                                Date2:=TODAY+30;
                                                                Date:=TODAY;
                                                                "Payroll Month":=FORMAT(DATE2DMY(Date2,2))+'/'+FORMAT(DATE2DMY(Date2,3));
                                                                END;

                                                                PTEN:='';

                                                                IF STRLEN("PF/Staff No")=10 THEN BEGIN
                                                                PTEN:=COPYSTR("PF/Staff No",10);
                                                                END ELSE IF STRLEN("PF/Staff No")=9 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",9);
                                                                END ELSE IF STRLEN("PF/Staff No")=8 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",8);
                                                                END ELSE IF STRLEN("PF/Staff No")=7 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",7);
                                                                END ELSE IF STRLEN("PF/Staff No")=6 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",6);
                                                                END ELSE IF STRLEN("PF/Staff No")=5 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",5);
                                                                END ELSE IF STRLEN("PF/Staff No")=4 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",4);
                                                                END ELSE IF STRLEN("PF/Staff No")=3 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",3);
                                                                END ELSE IF STRLEN("PF/Staff No")=2 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",2);
                                                                END ELSE IF STRLEN("PF/Staff No")=1 THEN BEGIN
                                                                 PTEN:=COPYSTR("PF/Staff No",1);
                                                                 END;

                                                                "Sort Code":=PTEN;
                                                              END;
                                                               }
    { 7   ;   ;New Balance         ;Decimal        }
    { 8   ;   ;REF.                ;Code10         }
    { 9   ;   ;Remark/LoanNO       ;Text50        ;TableRelation="Loans Register"."Loan  No." WHERE (ID NO=FIELD(ID NO.));
                                                   ValidateTableRelation=No }
    { 10  ;   ;Sort Code           ;Code2          }
    { 11  ;   ;Employer            ;Text50        ;TableRelation="Sacco Employers".Code }
    { 12  ;   ;Transaction Type    ;Option        ;OnValidate=BEGIN
                                                                IF "Transaction Type"="Transaction Type"::VARIATION THEN BEGIN
                                                                 Source:=Source::BOSA;
                                                                END;
                                                              END;

                                                   OptionCaptionML=ENU=EFFECT,VARIATION,ADJUSTMENT LOAN,CEASE,OFFSET;
                                                   OptionString=EFFECT,VARIATION,ADJUSTMENT LOAN,CEASE,OFFSET;
                                                   ValuesAllowed=[EFFECT;VARIATION;CEASE] }
    { 13  ;   ;Date                ;Date          ;OnValidate=BEGIN
                                                                 // Month:=CALCDATE('CM',Date);
                                                                Month:= DATE2DMY(Date,2);
                                                                //MESSAGE('the current month is %1',Month);
                                                                IF Month=1 THEN
                                                                "Payroll Month":='January'
                                                                ELSE IF Month=2 THEN
                                                                "Payroll Month":='FEBRUARY'
                                                                ELSE IF Month=3 THEN
                                                                "Payroll Month":='MARCH'
                                                                ELSE IF Month=4 THEN
                                                                "Payroll Month":='APRIL'
                                                                ELSE IF Month=5 THEN
                                                                "Payroll Month":='MAY'
                                                                ELSE IF Month=6 THEN
                                                                "Payroll Month":='JUNE'
                                                                ELSE IF Month=7 THEN
                                                                "Payroll Month":='JULY'
                                                                ELSE IF Month=8 THEN
                                                                "Payroll Month":='AUGUST'
                                                                ELSE IF Month=9 THEN
                                                                "Payroll Month":='SEPTEMBER'
                                                                ELSE IF Month=10 THEN
                                                                "Payroll Month":='OCTOBER'
                                                                ELSE IF Month=11 THEN
                                                                "Payroll Month":='NOVEMBER'
                                                                ELSE IF Month=12 THEN
                                                                "Payroll Month":='DECEMBER';
                                                              END;
                                                               }
    { 14  ;   ;Payroll Month       ;Code30        ;OnValidate=BEGIN
                                                                 // Month:=CALCDATE('CM',Date);
                                                                  //MESSAGE('the current month is %1',Month);
                                                              END;
                                                               }
    { 15  ;   ;Interest Amount     ;Decimal        }
    { 16  ;   ;Approved Amount     ;Decimal        }
    { 17  ;   ;Uploaded Interest   ;Decimal        }
    { 18  ;   ;Batch No.           ;Code50         }
    { 19  ;   ;Principal Amount    ;Decimal        }
    { 20  ;   ;UploadInt           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Interest Variance ScheduX"."Monthly Interest" WHERE (Loan No.=FIELD(Remark/LoanNO))) }
    { 21  ;   ;Source              ;Option        ;OptionCaptionML=ENU=BOSA,FOSA;
                                                   OptionString=BOSA,FOSA }
    { 22  ;   ;Code                ;Code50         }
    { 23  ;   ;Shares OFF          ;Decimal        }
    { 24  ;   ;Adjustment Type     ;Option        ;OnValidate=BEGIN
                                                                {
                                                                IF "Adjustment Type"="Adjustment Type"::" " THEN BEGIN

                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"Additional Loan" THEN BEGIN
                                                                "Type of Deduction":='ADDITIONAL LOAN';
                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"BELA Loan" THEN BEGIN
                                                                "Type of Deduction":='BELA LOAN';
                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"Benevolent Fund" THEN BEGIN
                                                                "Type of Deduction":='Benevolent Fund';
                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"Defaulters Loan" THEN BEGIN
                                                                 "Type of Deduction":='Defaulters Loan';
                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"Emergency Loan" THEN BEGIN
                                                                "Type of Deduction":='Emergency Loan';
                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"Entrance Fee" THEN BEGIN
                                                                "Type of Deduction":='Entrance Fee';
                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"Jitegemee Loan" THEN BEGIN
                                                                "Type of Deduction":='Jitegemee Loan';
                                                                END ELSE IF "Adjustment Type"="Adjustment Type"::"Normal Loan" THEN BEGIN
                                                                 "Type of Deduction":='Normal Loan';
                                                                 END ELSE IF "Adjustment Type"="Adjustment Type"::"School Fee Loan" THEN BEGIN
                                                                "Type of Deduction":='School Fee Loan';
                                                                 END ELSE IF "Adjustment Type"="Adjustment Type"::Shares THEN BEGIN
                                                                "Type of Deduction":='shares';
                                                                 END ELSE IF "Adjustment Type"="Adjustment Type"::"Lariba loan" THEN BEGIN
                                                                "Type of Deduction":='Lariba Loan';
                                                                 END ELSE IF "Adjustment Type"="Adjustment Type"::"Chipukizi Loan" THEN BEGIN
                                                                "Type of Deduction":='Chipukizi Loan';


                                                                END;}
                                                              END;

                                                   OptionCaptionML=ENU=" ,Additional Loan,BELA Loan,Benevolent Fund,Defaulters Loan,Emergency Loan,Entrance Fee,Jitegemee Loan,Normal Loan,School Fee Loan,Shares,Lariba loan,Chipukizi Loan";
                                                   OptionString=[ ,Additional Loan,BELA Loan,Benevolent Fund,Defaulters Loan,Emergency Loan,Entrance Fee,Jitegemee Loan,Normal Loan,School Fee Loan,Shares,Lariba loan,Chipukizi Loan] }
    { 25  ;   ;Period              ;Integer        }
    { 26  ;   ;aMOUNT ON 1         ;Decimal        }
    { 27  ;   ;Vote Code           ;Code10         }
    { 28  ;   ;EDCode              ;Code10         }
    { 29  ;   ;Current Balance     ;Decimal        }
    { 30  ;   ;TranType            ;Decimal        }
    { 31  ;   ;TranName            ;Text50         }
    { 32  ;   ;Action              ;Option        ;OptionCaptionML=ENU=Existing Loan,New Loan;
                                                   OptionString=Existing Loan,New Loan }
    { 33  ;   ;Interest Fee        ;Option        ;OptionCaptionML=ENU=Interest,Interest Free;
                                                   OptionString=Interest,Interest Free }
    { 34  ;   ;Recoveries          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Remark/LoanNO),
                                                                                                       Transaction Type=FILTER(Repayment),
                                                                                                       Posting Date=FIELD(Date))) }
    { 35  ;   ;Date Filter         ;Date           }
    { 36  ;   ;Interest Off        ;Decimal        }
    { 69023;  ;Repayment Method    ;Option        ;OptionString=[ ,Amortised,Reducing Balance,Straight Line,Constants,Ukulima Flat] }
    { 69024;  ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 69025;  ;Installments        ;Code50         }
    { 69026;  ;Ceased              ;Boolean        }
    { 69027;  ;Pck Principle Amount;Decimal        }
    { 69028;  ;Emp Loan Code       ;Code20         }
    { 69029;  ;Advice Option       ;Option        ;OptionCaptionML=ENU=" ,Amount,Balance";
                                                   OptionString=[ ,Amount,Balance] }
    { 69030;  ;Entry Number        ;Integer        }
    { 69031;  ;Outstanding Interest;Decimal        }
    { 69032;  ;Outstanding balance ;Decimal        }
  }
  KEYS
  {
    {    ;PF/Staff No,Type of Deduction,Remark/LoanNO,Date,ID NO.,Entry No;
                                                   SumIndexFields=Amount ON;
                                                   Clustered=Yes }
    {    ;Sort Code                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Month@1000000004 : Integer;
      StatusPermissions@1000000003 : Record 51516310;
      Cust@1000000002 : Record 51516223;
      PTEN@1000000001 : Code[20];
      Date2@1000000000 : Date;

    PROCEDURE GetContributionDeductionCode@1120054001(TransactionType@1120054001 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';ProductCode@1120054002 : Code[20];EmployerCode@1120054003 : Code[20];"Amnt/Bal"@1120054004 : ' ,Advice Amount,Balance') : Code[20];
    VAR
      AdvProduct@1120054000 : Record 51516019;
    BEGIN
      AdvProduct.RESET;
      IF ProductCode<>'' THEN
        AdvProduct.SETRANGE("Product Code",ProductCode);
      IF TransactionType<>TransactionType::" " THEN
        AdvProduct.SETRANGE("Transaction Type",TransactionType);
      IF EmployerCode<>'' THEN
        AdvProduct.SETRANGE("Employer Code",EmployerCode);
      IF "Amnt/Bal"<>"Amnt/Bal"::" " THEN
        AdvProduct.SETRANGE("Monthly Ded or RunningBalance","Amnt/Bal");
      IF AdvProduct.FINDFIRST THEN
        EXIT(AdvProduct."CheckoffAdvise Code");
    END;

    BEGIN
    END.
  }
}

