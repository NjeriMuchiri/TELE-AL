OBJECT table 20493 Membership Withdrawal New
{
  OBJECT-PROPERTIES
  {
    Date=09/06/19;
    Time=[ 4:22:13 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Closure  Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Member No.          ;Code20        ;TableRelation="Members Register";
                                                   OnValidate=BEGIN
                                                                IntTotal:=0;
                                                                LoanTotal:=0;

                                                                IF Cust.GET("Member No.") THEN BEGIN
                                                                "Member Name":=Cust.Name;
                                                                Cust.CALCFIELDS(Cust."Current Savings");
                                                                "Member Deposits":=Cust."Current Savings";
                                                                "FOSA Account No.":=Cust."FOSA Account";
                                                                "Unpaid Dividends":=Cust."Dividend Amount";
                                                                "E-Mail (Personal)":=Cust."E-Mail";

                                                                //"Risk Fund":=Cust."Risk Fund";
                                                                //IF Cust."Risk Fund"<0 THEN
                                                                //"Risk Beneficiary":=TRUE;

                                                                GenSetup.GET();
                                                                {IF "Risk Beneficiary"<>TRUE THEN
                                                                "Risk Refundable":=(GenSetup."Risk Beneficiary (%)"/100)*"Risk Fund";}
                                                                END;

                                                                "Total Adds":="Member Deposits"+"Risk Refundable"+"Unpaid Dividends";


                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","Member No.");
                                                                Loans.SETRANGE(Loans.Posted,TRUE);
                                                                Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                                                Loans.SETFILTER(Loans."Outstanding Balance",'>0');
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                                                                IntTotal:=IntTotal+Loans."Oustanding Interest";
                                                                LoanTotal:=LoanTotal+Loans."Outstanding Balance";
                                                                UNTIL Loans.NEXT=0;
                                                                END;
                                                                //FOSA Loans
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","FOSA Account No.");
                                                                Loans.SETRANGE(Loans.Posted,TRUE);
                                                                Loans.SETRANGE(Loans.Source,Loans.Source::FOSA);
                                                                Loans.SETFILTER(Loans."Outstanding Balance",'>0');
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                                                                IntTotalFOSA:=IntTotalFOSA+Loans."Oustanding Interest";
                                                                LoanTotalFOSA:=LoanTotalFOSA+Loans."Outstanding Balance";
                                                                UNTIL Loans.NEXT=0;
                                                                END;


                                                                "Total Loan":=LoanTotal;
                                                                "Total Interest":=IntTotal;
                                                                "Total Loans FOSA":=LoanTotalFOSA;
                                                                "Total Oustanding Int FOSA":=IntTotalFOSA;
                                                                "Total Lesses":="Total Loan"+"Total Interest"+"Total Loans FOSA"+"Total Oustanding Int FOSA";
                                                                "Net Payable to the Member":="Total Adds"-"Total Lesses";

                                                                //Exists as a guarantor
                                                                LoanGuar.RESET;
                                                                LoanGuar.SETRANGE(LoanGuar."Member No","Member No.");
                                                                LoanGuar.SETFILTER(LoanGuar."Outstanding Balance",'>%1',0);
                                                                LoanGuar.SETFILTER(LoanGuar."Self Guarantee",'<>%1',TRUE);
                                                                IF LoanGuar.FIND('-') THEN
                                                                  BEGIN
                                                                    ERROR(GuarantorError);
                                                                  END;
                                                              END;
                                                               }
    { 3   ;   ;Member Name         ;Text50         }
    { 4   ;   ;Closing Date        ;Date           }
    { 5   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 6   ;   ;Posted              ;Boolean        }
    { 7   ;   ;Total Loan          ;Decimal        }
    { 8   ;   ;Total Interest      ;Decimal        }
    { 9   ;   ;Member Deposits     ;Decimal        }
    { 10  ;   ;No. Series          ;Code20         }
    { 11  ;   ;Closure Type        ;Option        ;OptionString=Withdrawal - Normal,Withdrawal - Death,Withdrawal - Death(Defaulter) }
    { 12  ;   ;Mode Of Disbursement;Option        ;OptionCaptionML=ENU=FOSA Transfer,Cheque,EFT;
                                                   OptionString=FOSA Transfer,Cheque,EFT }
    { 13  ;   ;Paying Bank         ;Code20        ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                IF ("Mode Of Disbursement"="Mode Of Disbursement"::Cheque) OR ("Mode Of Disbursement"="Mode Of Disbursement"::EFT) THEN BEGIN
                                                                IF "Paying Bank"='' THEN
                                                                ERROR('You Must Specify the Paying bank');
                                                                END;
                                                              END;
                                                               }
    { 14  ;   ;Cheque No.          ;Code20         }
    { 15  ;   ;FOSA Account No.    ;Code20         }
    { 16  ;   ;Payee               ;Text80         }
    { 17  ;   ;Net Pay             ;Decimal        }
    { 18  ;   ;Risk Fund           ;Decimal        }
    { 19  ;   ;Risk Beneficiary    ;Boolean        }
    { 20  ;   ;Risk Refundable     ;Decimal        }
    { 21  ;   ;Total Adds          ;Decimal        }
    { 22  ;   ;Total Lesses        ;Decimal        }
    { 23  ;   ;Unpaid Dividends    ;Decimal        }
    { 24  ;   ;Total Loans FOSA    ;Decimal        }
    { 25  ;   ;Total Oustanding Int FOSA;Decimal   }
    { 26  ;   ;Net Payable to the Member;Decimal   }
    { 27  ;   ;E-Mail (Personal)   ;Code50         }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesSetup@1120054010 : Record 51516258;
      NoSeriesMgt@1120054009 : Codeunit 396;
      Cust@1120054008 : Record 51516223;
      Loans@1120054007 : Record 51516230;
      MemLed@1120054006 : Record 51516224;
      IntTotal@1120054005 : Decimal;
      LoanTotal@1120054004 : Decimal;
      GenSetup@1120054003 : Record 51516257;
      IntTotalFOSA@1120054002 : Decimal;
      LoanTotalFOSA@1120054001 : Decimal;
      LoanGuar@1120054000 : Record 51516231;
      GuarantorError@1120054011 : TextConst 'ENU=Member has guaranteed an outstanding loan therefore cannnot exit';

    BEGIN
    END.
  }
}

