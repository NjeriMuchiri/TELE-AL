OBJECT table 17243 Loans Calculator
{
  OBJECT-PROPERTIES
  {
    Date=11/29/16;
    Time=[ 5:17:02 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 2   ;   ;Loan Product Type   ;Code20        ;TableRelation="Loan Products Setup".Code;
                                                   OnValidate=BEGIN
                                                                 LoanType.RESET;
                                                                 LoanType.SETRANGE(LoanType.Code,"Loan Product Type");
                                                                IF LoanType.FIND('-') THEN BEGIN
                                                                "Interest rate":=LoanType."Interest rate";
                                                                "Repayment Method":=LoanType."Repayment Method";
                                                                "Product Description":=LoanType."Product Description";
                                                                Installments:=LoanType."No of Installment";
                                                                //"Administration Fee":=LoanType."Administration Fee";
                                                                "Instalment Period":=LoanType."Instalment Period";

                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Installments        ;Integer       ;OnValidate=BEGIN

                                                                TotalMRepay:=0;
                                                                LPrincipal:=0;
                                                                LInterest:=0;
                                                                InterestRate:="Interest rate";
                                                                LoanAmount:="Requested Amount";
                                                                RepayPeriod:=Installments;
                                                                LBalance:="Requested Amount";




                                                                //cyrus
                                                                //Repayments for amortised method
                                                                IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.05,'>');
                                                                LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                                                LPrincipal:=TotalMRepay-LInterest;
                                                                Repayment:=TotalMRepay;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                 "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                 "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;

                                                                END;
                                                                //End Repayments for amortised method

                                                                //cyrus
                                                                 //cyrus
                                                                //Repayments for Straight line method

                                                                IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
                                                                //Grace Period Interest
                                                                //LInterest:=ROUND((LInterest*InitialInstal)/(InitialInstal-InitialGraceInt),0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                 "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                 "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;

                                                                END;

                                                                //End Repayments for Straight Line method

                                                                 //cyrus
                                                                //cyrus
                                                                //Repayments for reducing balance method
                                                                IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;
                                                                //MESSAGE('%1',RepayPeriod);
                                                                END;
                                                                //cyrus
                                                              END;
                                                               }
    { 4   ;   ;Principle Repayment ;Decimal        }
    { 5   ;   ;Interest Repayment  ;Decimal        }
    { 6   ;   ;Total Monthly Repayment;Decimal     }
    { 7   ;   ;Product Description ;Text30         }
    { 8   ;   ;Interest rate       ;Decimal        }
    { 9   ;   ;Repayment Method    ;Option        ;OnValidate=BEGIN

                                                                TotalMRepay:=0;
                                                                LPrincipal:=0;
                                                                LInterest:=0;
                                                                InterestRate:="Interest rate";
                                                                LoanAmount:="Requested Amount";
                                                                RepayPeriod:=Installments;
                                                                LBalance:="Requested Amount";




                                                                //cyrus
                                                                //Repayments for amortised method
                                                                IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.05,'>');
                                                                LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                                                LPrincipal:=TotalMRepay-LInterest;
                                                                Repayment:=TotalMRepay;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                 "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                 "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;

                                                                END;
                                                                //End Repayments for amortised method

                                                                //cyrus
                                                                 //cyrus
                                                                //Repayments for Straight line method

                                                                IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
                                                                //Grace Period Interest
                                                                //LInterest:=ROUND((LInterest*InitialInstal)/(InitialInstal-InitialGraceInt),0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                 "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                 "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;

                                                                END;

                                                                //End Repayments for Straight Line method

                                                                 //cyrus
                                                                //cyrus
                                                                //Repayments for reducing balance method
                                                                IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;
                                                                //MESSAGE('%1',RepayPeriod);
                                                                END;
                                                                //cyrus
                                                              END;

                                                   OptionString=Amortised,Reducing Balance,Straight Line,Constants }
    { 10  ;   ;Requested Amount    ;Decimal       ;OnValidate=BEGIN

                                                                TotalMRepay:=0;
                                                                LPrincipal:=0;
                                                                LInterest:=0;
                                                                InterestRate:="Interest rate";
                                                                LoanAmount:="Requested Amount";
                                                                RepayPeriod:=Installments;
                                                                LBalance:="Requested Amount";




                                                                //cyrus
                                                                //Repayments for amortised method
                                                                IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.05,'>');
                                                                LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                                                LPrincipal:=TotalMRepay-LInterest;
                                                                Repayment:=TotalMRepay;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                 "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                 "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;

                                                                END;
                                                                //End Repayments for amortised method

                                                                //cyrus
                                                                 //cyrus
                                                                //Repayments for Straight line method

                                                                IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
                                                                //Grace Period Interest
                                                                //LInterest:=ROUND((LInterest*InitialInstal)/(InitialInstal-InitialGraceInt),0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                 "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                 "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;

                                                                END;

                                                                //End Repayments for Straight Line method

                                                                 //cyrus
                                                                //cyrus
                                                                //Repayments for reducing balance method
                                                                IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
                                                                TESTFIELD("Interest rate");
                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                "Principle Repayment":=LPrincipal;
                                                                "Interest Repayment":=LInterest;
                                                                "Total Monthly Repayment":= "Principle Repayment"+"Interest Repayment"+"Administration Fee";
                                                                "Average Repayment":="Total Monthly Repayment"*RepayPeriod/RepayPeriod;
                                                                //MESSAGE('%1',RepayPeriod);
                                                                END;
                                                                //cyrus
                                                              END;
                                                               }
    { 11  ;   ;Administration Fee  ;Decimal        }
    { 12  ;   ;Repayment           ;Decimal        }
    { 13  ;   ;Average Repayment   ;Decimal        }
    { 14  ;   ;Repayment Start Date;Date           }
    { 15  ;   ;Instalment Period   ;DateFormula    }
    { 16  ;   ;Grace Period - Principle (M);Integer }
    { 17  ;   ;Grace Period - Interest (M);Integer }
    { 18  ;   ;Eligible Amount     ;Decimal        }
    { 19  ;   ;Princible Repayment 2;Decimal       }
    { 20  ;   ;Interest Repayment 2;Decimal        }
    { 21  ;   ;Total Monthly Repayment 2;Decimal   }
    { 22  ;   ;Total Outstanding Bosa Loans;Decimal }
    { 23  ;   ;Member No           ;Code20        ;TableRelation=Table51516154;
                                                   OnValidate=BEGIN
                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."No.","Member No");

                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Outstanding Balance");
                                                                "Total Loans Outstanding":=Cust."Outstanding Balance";


                                                                END;
                                                                MODIFY;
                                                                 {
                                                                Cust.CALCFIELDS(Cust."Outstanding Balance");
                                                                IF Cust.GET("Member No")  THEN BEGIN
                                                                "Total Loans Outstanding":=Cust."Outstanding Balance";
                                                                END;}
                                                                MESSAGE('"Total Loans Outstanding" IS %1',"Total Loans Outstanding");
                                                              END;
                                                               }
    { 24  ;   ;Total Loans Outstanding;Decimal     }
  }
  KEYS
  {
    {    ;Loan Product Type                       ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LoanType@1102755000 : Record 51516240;
      TotalMRepay@1102755001 : Decimal;
      LPrincipal@1102755002 : Decimal;
      LInterest@1102755003 : Decimal;
      InterestRate@1102755004 : Decimal;
      LoanAmount@1102755005 : Decimal;
      RepayPeriod@1102755006 : Integer;
      LBalance@1102755007 : Decimal;
      BosaLoans@1102755008 : Record 51516230;
      FosaLoans@1102755009 : Record 23;
      Cust@1102755010 : Record 51516223;

    BEGIN
    END.
  }
}

