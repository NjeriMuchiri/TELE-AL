OBJECT table 20490 TotalsLoans
{
  OBJECT-PROPERTIES
  {
    Date=02/12/19;
    Time=[ 1:04:40 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN


               EnteredBY:=USERID;
               // VALIDATE(AppliedAmount);
               // LoansReg.VALIDATE("Client Code");
               VALIDATE(Installments);
             END;

    OnModify=BEGIN
               // VALIDATE(AppliedAmount);
               // LoansReg.VALIDATE("Client Code");
               VALIDATE(Installments);
             END;

  }
  FIELDS
  {
    { 1   ;   ;Entry               ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;LoanNo              ;Code20         }
    { 3   ;   ;CLientCode          ;Code20        ;TableRelation="Members Register".No. }
    { 4   ;   ;ApprovedAmount      ;Decimal        }
    { 5   ;   ;ApplcationId        ;Code20         }
    { 6   ;   ;DocNo               ;Code70         }
    { 7   ;   ;LoanAmountInwords   ;Text70         }
    { 8   ;   ;LoanPurpose         ;Text70         }
    { 9   ;   ;AppliedAmount       ;Decimal       ;OnValidate=BEGIN

                                                                Setup.RESET;
                                                                Setup.SETRANGE(Setup.Code, LoanType);
                                                                IF Setup.FIND('-') THEN BEGIN

                                                                  IF Installments>Setup."Default Installements" THEN
                                                                  ERROR('Recommended Loan period for this loan is '+FORMAT( Setup."Default Installements")+ ' please apply use the recommended installments or below');
                                                                  END;
                                                              END;
                                                               }
    { 10  ;   ;DocNo2              ;Code20         }
    { 11  ;   ;Source              ;Code30         }
    { 12  ;   ;EnteredBY           ;Code50         }
    { 13  ;   ;LoanType            ;Code60        ;OnValidate=BEGIN
                                                                Setup.RESET;
                                                                Setup.SETRANGE(Code, LoanType);
                                                                IF Setup.FIND('-') THEN BEGIN
                                                                  LoanTypeName:=Setup."Product Description";
                                                                  Installments:=Setup."No of Installment";
                                                                  IntrestRate:=Setup."Interest rate";
                                                                  END ELSE
                                                                  ERROR('Product does not exist');
                                                              END;
                                                               }
    { 14  ;   ;LoanTypeName        ;Text60         }
    { 15  ;   ;MainPurpose         ;Text100        }
    { 16  ;   ;Submitted           ;Boolean       ;OnValidate=BEGIN
                                                                IF Submitted=TRUE THEN BEGIN
                                                                 // Setup.RESET;

                                                                  IF Rec.GET(Entry) THEN BEGIN
                                                                    Setup.RESET;
                                                                Setup.SETRANGE(Code, LoanType);
                                                                IF Setup.FIND('-') THEN BEGIN

                                                                   LoansReg.INIT;
                                                                   IF Setup.Source=Setup.Source::BOSA THEN BEGIN
                                                                   LoansReg.Source:=LoansReg.Source::BOSA;
                                                                    END
                                                                    ELSE BEGIN
                                                                   IF Setup.Source=Setup.Source::FOSA THEN
                                                                   LoansReg.Source:=LoansReg.Source::FOSA;
                                                                   END;
                                                                   LoansReg."Loan  No.":='';
                                                                   LoansReg."Requested Amount":=AppliedAmount;
                                                                   LoansReg."Loan Product Type":=LoanType;
                                                                    LoansReg."Application Date":=TODAY;
                                                                   LoansReg."Client Code":=CLientCode;
                                                                   LoansReg.Installments:=Installments;
                                                                   LoansReg."Approved Amount":=AppliedAmount;
                                                                   LoansReg.DocLink:=Entry;
                                                                   LoansReg.INSERT(TRUE);
                                                                   LoansReg.VALIDATE(LoansReg."Loan Product Type");
                                                                   LoansReg.VALIDATE(LoansReg."Client Code");
                                                                  LoansReg.MODIFY;
                                                                 END;
                                                                 END;
                                                                LoansReg.RESET;
                                                                LoansReg.SETRANGE(LoansReg."Client Code", CLientCode);
                                                                IF LoansReg.FINDLAST THEN
                                                                PortalGuarantors.RESET;
                                                                  PortalGuarantors.SETFILTER(PortalGuarantors.MemberNo, CLientCode);
                                                                  PortalGuarantors.SETFILTER(PortalGuarantors.Response,'%1', TRUE);
                                                                 //  IF PortalGuarantors.FINDSET THEN BEGIN
                                                                  PortalGuarantors.SETRANGE(PortalGuarantors.LoanNO, Entry);
                                                                 IF PortalGuarantors.FIND('-') THEN  BEGIN
                                                                       REPEAT
                                                                    //  LoansGuranteedetatiasl.INIT;

                                                                      LoansGuranteedetatiasl."Loan No":=LoansReg."Loan  No.";

                                                                      LoansGuranteedetatiasl."Amount Committed":=PortalGuarantors.AmountGuaranteed;
                                                                      LoansGuranteedetatiasl."Amont Guaranteed":=PortalGuarantors.AmountGuaranteed;
                                                                      LoansGuranteedetatiasl."Member No":=PortalGuarantors.MemberNo;

                                                                     LoansGuranteedetatiasl.VALIDATE(LoansGuranteedetatiasl."Member No");

                                                                      LoansGuranteedetatiasl.VALIDATE(LoansGuranteedetatiasl."Member No");
                                                                      LoansGuranteedetatiasl.VALIDATE(LoansGuranteedetatiasl."Amont Guaranteed");

                                                                     LoansGuranteedetatiasl.INSERT;

                                                                       LoansGuranteedetatiasl."Amount Committed":=PortalGuarantors.AmountGuaranteed;
                                                                      LoansGuranteedetatiasl."Amont Guaranteed":=PortalGuarantors.AmountGuaranteed;
                                                                     LoansGuranteedetatiasl.MODIFY;
                                                                     UNTIL PortalGuarantors.NEXT=0;
                                                                     END;
                                                                     Submitted:=TRUE;
                                                                    MODIFY;
                                                                END;
                                                                //COMMIT;
                                                              END;
                                                               }
    { 17  ;   ;Installments        ;Integer       ;OnValidate=BEGIN
                                                                Setup.RESET;
                                                                Setup.SETRANGE(Setup.Code, LoanType);
                                                                IF Setup.FIND('-') THEN BEGIN

                                                                  IF Installments>Setup."Default Installements" THEN
                                                                  ERROR('Recommended Loan period for this loan is '+FORMAT( Setup."Default Installements")+ 'Months please apply use the recommended installments or below');
                                                                  END;
                                                              END;
                                                               }
    { 18  ;   ;IntrestRate         ;Decimal        }
    { 19  ;   ;OfficerRecommendation;Decimal      ;FieldClass=Normal }
    { 20  ;   ;RegionalRecommendation;Decimal     ;OnValidate=BEGIN
                                                                // LoansReg.RESET;
                                                                // LoansReg.SETRANGE("Loan  No.", LoanNo);
                                                                // IF LoansReg.FIND('-') THEN BEGIN
                                                                //   TotalsLoans.RESET;
                                                                //   TotalsLoans.SETRANGE(LoanNo, Rec.LoanNo);
                                                                //
                                                                // IF TotalsLoans.FIND('-') THEN BEGIN
                                                                //
                                                                // REPEAT
                                                                //   RecAmount:=RecAmount+TotalsLoans.OfficerRecommendation;
                                                                //   UNTIL TotalsLoans.NEXT=0;
                                                                //   END;
                                                                //   LoansReg."Recommended Amount":=RecAmount;
                                                                //   LoansReg.MODIFY;
                                                                //   END;
                                                              END;
                                                               }
    { 21  ;   ;CommitteeRecommendation;Decimal     }
    { 22  ;   ;Tenure              ;Decimal        }
    { 23  ;   ;Typeofinstallment   ;Option        ;OptionCaptionML=ENU=Daily,Weekly,Monthly,Quaterly,Semi Annually,Annually,Bullet;
                                                   OptionString=Daily,Weekly,Monthly,Quaterly,Semi Annually,Annually,Bullet }
    { 24  ;   ;InstallmentAmount   ;Decimal        }
    { 25  ;   ;Monthly             ;Decimal        }
    { 26  ;   ;Yearly              ;Decimal        }
    { 27  ;   ;Quaterly            ;Decimal        }
    { 28  ;   ;Semiannually        ;Decimal        }
    { 31  ;   ;Seucrity            ;Text60         }
    { 32  ;   ;Bullet              ;Decimal        }
    { 33  ;   ;Repayment Frequency ;Option        ;OnValidate=BEGIN
                                                                 IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
                                                                 EVALUATE(Installments,'1D')
                                                                 ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
                                                                 EVALUATE(Installments,'1W')
                                                                 ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
                                                                 EVALUATE(Installments,'1M')
                                                                 ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
                                                                 EVALUATE(Installments,'1Q');
                                                              END;

                                                   OptionCaptionML=ENU=Daily,Weekly,Monthly,Quaterly,Semi Annually,Annually,Bullet;
                                                   OptionString=Daily,Weekly,Monthly,Quaterly,Semi Annually,Annually,Bullet }
    { 34  ;   ;BulletCycle         ;Option        ;OptionCaptionML=ENU=Yearly, HalfYear;
                                                   OptionString=Yearly, HalfYear }
    { 35  ;   ;BulletAmount        ;Decimal        }
    { 36  ;   ;Justification       ;Text250        }
    { 37  ;   ;RepaymentStartDate  ;Date           }
    { 38  ;   ;DisbursmentDate     ;Date           }
    { 39  ;   ;Confirmed           ;Boolean        }
    { 41  ;   ;AmountGuaranteed    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum(Guarantors_Portal.AmountGuaranteed WHERE (LoanNO=FIELD(Entry),
                                                                                                             Response=CONST(Yes))) }
  }
  KEYS
  {
    {    ;Entry                                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Setup@1120054000 : Record 51516240;
      TotalsLoans@1120054001 : Record 51516908;
      LoansReg@1120054002 : Record 51516230;
      LoanAmount@1120054003 : Decimal;
      RecAmount@1120054004 : Decimal;
      LoansGuranteedetatiasl@1120054005 : Record 51516231;
      PortalGuarantors@1120054006 : Record 51516909;

    BEGIN
    END.
  }
}

