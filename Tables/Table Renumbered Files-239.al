OBJECT table 20380 Guarantors Recovery Header
{
  OBJECT-PROPERTIES
  {
    Date=07/06/22;
    Time=[ 3:22:03 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF "Document No" = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Change Request No");
                 NoSeriesMgt.InitSeries(SalesSetup."Change Request No",xRec."No. Series",0D,"Document No","No. Series");
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20        ;OnValidate=BEGIN
                                                                IF "Document No" <> xRec."Document No" THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Change Request No");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Member No           ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                 CLEAR("Loan to Attach");
                                                                 CLEAR("Deposits Aportioned");
                                                                 CLEAR("Current Shares");
                                                                 CLEAR("Total Outstanding Loans");
                                                                 CLEAR("Loan Liabilities");
                                                                 CLEAR("Loan Distributed to Guarantors");
                                                                 CLEAR("Member Name");
                                                                 CLEAR("FOSA Account No");
                                                                 "Global Dimension 2 Code":='NAIROBI';
                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                  Cust.CALCFIELDS(Cust."Current Shares");
                                                                  "Member Name":=Cust.Name;
                                                                  "FOSA Account No":=Cust."FOSA Account";
                                                                  "Personal No":=Cust."Payroll/Staff No";
                                                                  "Current Shares":=Cust."Current Shares";

                                                                  "Free Shares" := (Cust."Current Shares");

                                                                LoanDetails.RESET;
                                                                LoanDetails.SETRANGE(LoanDetails."Guarantor Number","Member No");
                                                                IF LoanDetails.FIND ('-') THEN BEGIN
                                                                  LoanDetails."Guarantors Free Shares":=(LoanGuarantors."Deposits variance"-LoanGuarantors."Share capital");

                                                                IF "Loan Liabilities" > 0 THEN BEGIN
                                                                  "Recovery Difference" := "Free Shares"-"Loan Liabilities";
                                                                IF "Loan Liabilities" < 1 THEN
                                                                  "Recovery Difference":=0;
                                                                END;
                                                                END;

                                                                //Clear Existing Lines
                                                                LoanDetails.RESET;
                                                                LoanDetails.SETRANGE(LoanDetails."Document No","Document No");
                                                                IF LoanDetails.FINDSET (TRUE) THEN BEGIN
                                                                LoanDetails.DELETEALL;
                                                                END;
                                                                FnCalculateTotalOutstandingLoans();

                                                                  END;

                                                                VALIDATE("Loan to Attach");
                                                              END;
                                                               }
    { 3   ;   ;Member Name         ;Code30         }
    { 4   ;   ;Application Date    ;Date           }
    { 7   ;   ;Created By          ;Code50         }
    { 8   ;   ;No. Series          ;Code20         }
    { 9   ;   ;FOSA Account No     ;Code20        ;TableRelation=Vendor.No. }
    { 10  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 11  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 12  ;   ;Posted              ;Boolean        }
    { 13  ;   ;Posting Date        ;Date           }
    { 14  ;   ;Posted By           ;Code40         }
    { 15  ;   ;Personal No         ;Code100        }
    { 16  ;   ;Recovery Type       ;Option        ;OnValidate=VAR
                                                                LoanDetails@1000000000 : Record 51516392;
                                                              BEGIN
                                                              END;

                                                   OptionCaptionML=ENU=" ,Recover From Loanee Deposits,Recover From Guarantor Deposits";
                                                   OptionString=[ ,Recover From Loanee Deposits,Recover From Guarantor Deposits] }
    { 17  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 18  ;   ;Current Shares      ;Decimal        }
    { 19  ;   ;Loan Liabilities    ;Decimal        }
    { 20  ;   ;Loan to Attach      ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Member No),
                                                                                                     Account No=FIELD(FOSA Account No),
                                                                                                     Outstanding Balance=FILTER(>0));
                                                   OnValidate=VAR
                                                                TotalInterestDue@1000000000 : Decimal;
                                                                TotalThirdParty@1000000001 : Decimal;
                                                                RunBal@1000000002 : Decimal;
                                                              BEGIN
                                                                TotalInterestDue:=0;
                                                                TotalThirdParty:=0;
                                                                "Total Interest Due Recovered":=0;
                                                                "Total Thirdparty Loans":=0;
                                                                TotalDepositsDeducted:=0;
                                                                RunBal:=ROUND("Current Shares",0.05,'>');
                                                                LoanRec.RESET;
                                                                LoanRec.SETRANGE(LoanRec."BOSA No","Member No");
                                                                LoanRec.SETRANGE(LoanRec."Loan  No.","Loan to Attach");
                                                                  IF LoanRec.FIND('-') THEN BEGIN
                                                                    LoanRec.CALCFIELDS(LoanRec."Outstanding Balance",LoanRec."Oustanding Interest");
                                                                    "Outstanding Interest":=LoanRec."Oustanding Interest";
                                                                      IF (LoanRec."Outstanding Balance">0) OR (LoanRec."Oustanding Interest">0) THEN BEGIN
                                                                      "Loan Liabilities":=ROUND(LoanRec."Outstanding Balance");
                                                                      END;

                                                                    REPEAT
                                                                      TotalInterestDue:=TotalInterestDue+FnCalculateTotalInterestDue(LoanRec);
                                                                    UNTIL LoanRec.NEXT=0;
                                                                    "Total Interest Due Recovered":=TotalInterestDue;
                                                                  END;
                                                                RunBal:=RunBal-TotalInterestDue;
                                                                RunBal:=FnCalculateTotalThirdpartyLoans(RunBal);
                                                                RunBal:=FnCalculateMobileLoan(RunBal);

                                                                TotalDepositsDeducted:="Total Interest Due Recovered"+"Total Thirdparty Loans"+"Mobile Loan";
                                                                DepositsBalance:="Current Shares"-TotalDepositsDeducted;
                                                                FnCalculateLoanPrincipalAportionment("Loan Liabilities",DepositsBalance);
                                                                "Loan Distributed to Guarantors":="Loan Liabilities"-"Deposits Aportioned";
                                                                LoanDetails.RESET;
                                                                LoanDetails.SETRANGE("Member No","Loan to Attach");
                                                                LoanDetails.DELETEALL;
                                                              END;
                                                               }
    { 21  ;   ;Committed Shares    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Guarantee Details"."Amont Guaranteed" WHERE (Member No=FIELD(Member No))) }
    { 22  ;   ;Free Shares         ;Decimal        }
    { 23  ;   ;Recovery Difference ;Decimal        }
    { 24  ;   ;Interest Repayment  ;Decimal        }
    { 25  ;   ;Principal Repayment ;Decimal        }
    { 26  ;   ;Loan No             ;Code40        ;TableRelation="Loans Guarantee Details"."Loan No";
                                                   NotBlank=Yes }
    { 27  ;   ;Amont Guaranteed    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Guarantee Details"."Amont Guaranteed" WHERE (Loan No=FIELD(Loan to Attach))) }
    { 28  ;   ;Guarantor Number    ;Code50         }
    { 29  ;   ;Repayment Start Date;Date           }
    { 30  ;   ;Loan Disbursement Date;Date        ;OnValidate=BEGIN
                                                                "Issued Date":="Loan Disbursement Date";
                                                                GenSetUp.GET;
                                                                currYear := DATE2DMY(TODAY,3);
                                                                StartDate := 0D;
                                                                EndDate := 0D;
                                                                Month:=DATE2DMY("Loan Disbursement Date",2);
                                                                DAY:=DATE2DMY("Loan Disbursement Date",1);
                                                                StartDate := DMY2DATE(1, Month, currYear);
                                                                IF Month=12 THEN BEGIN
                                                                Month:=0;
                                                                currYear:=currYear+1;
                                                                END;
                                                                EndDate := DMY2DATE(1, Month+1, currYear)-1;
                                                                IF DAY <=23 THEN BEGIN
                                                                "Repayment Start Date":=CALCDATE('CM',"Loan Disbursement Date");
                                                                END ELSE BEGIN
                                                                "Repayment Start Date":=CALCDATE('CM',CALCDATE('CM+1M',"Loan Disbursement Date"));
                                                                END;
                                                                "Expected Date of Completion":=CALCDATE(FORMAT(Installments)+'M',"Loan Disbursement Date");
                                                              END;
                                                               }
    { 31  ;   ;Loans Generated     ;Boolean        }
    { 32  ;   ;Issued Date         ;Date           }
    { 33  ;   ;Expected Date of Completion;Date    }
    { 34  ;   ;Total Interest Due Recovered;Decimal }
    { 35  ;   ;Total Thirdparty Loans;Decimal      }
    { 36  ;   ;Deposits Aportioned ;Decimal        }
    { 37  ;   ;Loan Distributed to Guarantors;Decimal }
    { 38  ;   ;Mobile Loan         ;Decimal        }
    { 39  ;   ;Total Outstanding Loans;Decimal     }
    { 40  ;   ;Outstanding Interest;Decimal        }
  }
  KEYS
  {
    {    ;Document No                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesSetup@1000000001 : Record 51516258;
      NoSeriesMgt@1000000000 : Codeunit 396;
      Cust@1000000002 : Record 51516223;
      LoanDetails@1000000003 : Record 51516391;
      LoanRec@1000000004 : Record 51516230;
      LoanGuarantors@1000000005 : Record 51516231;
      GenSetUp@1000000006 : Record 51516257;
      currYear@1000000007 : Integer;
      StartDate@1000000008 : Date;
      EndDate@1000000009 : Date;
      Month@1000000010 : Integer;
      DAY@1000000011 : Integer;
      Installments@1000000012 : Integer;
      TotalDepositsDeducted@1000000013 : Decimal;
      DepositsBalance@1000000014 : Decimal;
      SFactory@1000000015 : Codeunit 51516007;

    LOCAL PROCEDURE FnCalculateTotalInterestDue@1000000000(Loans@1000000000 : Record 51516230) InterestDue : Decimal;
    VAR
      ObjRepaymentSchedule@1000000001 : Record 51516234;
      "Loan Age"@1000000002 : Integer;
    BEGIN
      ObjRepaymentSchedule.RESET;
      ObjRepaymentSchedule.SETRANGE("Loan No.",Loans."Loan  No.");
      //ObjRepaymentSchedule.SETFILTER("Repayment Date",'<=%1',"Loan Disbursement Date");
      IF ObjRepaymentSchedule.FIND('-') THEN
       "Loan Age":=ObjRepaymentSchedule.COUNT;
      Loans.CALCFIELDS("Outstanding Balance","Interest Paid");

      InterestDue:=((0.01*Loans."Approved Amount"+0.01*Loans."Outstanding Balance")*Loans.Interest/12*("Loan Age"))/2-ABS(Loans."Interest Paid");
      IF (DATE2DMY("Loan Disbursement Date",1) >15) THEN BEGIN
      InterestDue:=((0.01*Loans."Approved Amount"+0.01*Loans."Outstanding Balance")*Loans.Interest/12*("Loan Age"+1))/2-ABS(Loans."Interest Paid");
      END;
      IF InterestDue <= 0 THEN
        EXIT(0);
      //MESSAGE('Approved=%1 Loan Age=%2 OBalance=%3 InterestPaid=%4 InterestDue=%5',Loans."Approved Amount","Loan Age",Loans."Outstanding Balance",Loans."Interest Paid",InterestDue);
      EXIT(InterestDue);
    END;

    LOCAL PROCEDURE FnCalculateTotalThirdpartyLoans@1000000018(RunningBal@1000000004 : Decimal) : Decimal;
    VAR
      ObjRepaymentSchedule@1000000001 : Record 51516234;
      "Loan Age"@1000000002 : Integer;
      ObjLoans@1000000000 : Record 51516230;
      RecAmount@1000000003 : Decimal;
    BEGIN
      IF RunningBal >0 THEN BEGIN
      ObjLoans.RESET;
      ObjLoans.SETRANGE("Client Code","Member No");
      ObjLoans.SETRANGE("Loan Product Type",'GUR');
      IF ObjLoans.FIND('-') THEN BEGIN
        REPEAT
          IF RunningBal >0 THEN BEGIN
            ObjLoans.CALCFIELDS(ObjLoans."Outstanding Balance");
            IF ObjLoans."Outstanding Balance" > 0 THEN BEGIN
            RecAmount:=ObjLoans."Outstanding Balance"+RecAmount;
            RunningBal:=RunningBal-ObjLoans."Outstanding Balance";
            END;
          END;
      UNTIL ObjLoans.NEXT=0;
      END;
      "Total Thirdparty Loans":=RecAmount;
      EXIT(RunningBal);
      END;
    END;

    LOCAL PROCEDURE FnCalculateMobileLoan@1000000046(RunningBal@1000000004 : Decimal) : Decimal;
    VAR
      ObjRepaymentSchedule@1000000001 : Record 51516234;
      "Loan Age"@1000000002 : Integer;
      ObjLoans@1000000000 : Record 51516230;
      RecAmount@1000000003 : Decimal;
    BEGIN
      IF RunningBal >0 THEN BEGIN
      ObjLoans.RESET;
      ObjLoans.SETRANGE("BOSA No","Member No");
      //ObjLoans.SETRANGE("Loan Product Type",'MSADV');
      IF ObjLoans.FIND('-') THEN BEGIN
        REPEAT
          IF RunningBal >0 THEN BEGIN
            ObjLoans.CALCFIELDS(ObjLoans."Outstanding Balance");
            IF ObjLoans."Outstanding Balance" > 0 THEN BEGIN
              RecAmount:=ObjLoans."Outstanding Balance"+RecAmount;
              RunningBal:=RunningBal-ObjLoans."Outstanding Balance";
          END;
          END;
      UNTIL ObjLoans.NEXT=0;
      END;
      "Mobile Loan":=RecAmount;
      EXIT(RunningBal);
      END;
    END;

    LOCAL PROCEDURE FnCalculateLoanPrincipalAportionment@1000000002(LoanAmount@1000000004 : Decimal;DepositsBalance@1000000005 : Decimal);
    VAR
      ObjRepaymentSchedule@1000000001 : Record 51516234;
      "Loan Age"@1000000002 : Integer;
      ObjLoans@1000000000 : Record 51516230;
      RecAmount@1000000003 : Decimal;
    BEGIN
      ObjLoans.RESET;
      ObjLoans.SETRANGE("BOSA No","Member No");
      //ObjLoans.SETFILTER("Date filter",'..'+FORMAT("Loan Disbursement Date"));//("Date filter",'..'+FORMAT("Loan Disbursement Date"))
      IF ObjLoans.FIND('-') THEN BEGIN
        REPEAT
          ObjLoans.CALCFIELDS(ObjLoans."Outstanding Balance");
          IF ObjLoans."Outstanding Balance" > 0 THEN BEGIN
          RecAmount:=ObjLoans."Outstanding Balance"+RecAmount;
          END;
      UNTIL ObjLoans.NEXT=0;
      END;
      "Deposits Aportioned":=ROUND((LoanAmount/RecAmount)*DepositsBalance,0.05,'>');
    END;

    LOCAL PROCEDURE FnCalculateTotalOutstandingLoans@1000000007();
    VAR
      ObjRepaymentSchedule@1000000001 : Record 51516234;
      "Loan Age"@1000000002 : Integer;
      ObjLoans@1000000000 : Record 51516230;
      RecAmount@1000000003 : Decimal;
    BEGIN
      ObjLoans.RESET;
      ObjLoans.SETRANGE("BOSA No","Member No");
      //ObjLoans.SETFILTER("Date filter",'..'+FORMAT("Loan Disbursement Date"));
      IF ObjLoans.FIND('-') THEN BEGIN
        REPEAT
          ObjLoans.CALCFIELDS(ObjLoans."Outstanding Balance");
          IF ObjLoans."Outstanding Balance" > 0 THEN BEGIN
          RecAmount:=ObjLoans."Outstanding Balance"+RecAmount;
          END;
      UNTIL ObjLoans.NEXT=0;
      END;
      "Total Outstanding Loans":=RecAmount;
    END;

    BEGIN
    END.
  }
}

