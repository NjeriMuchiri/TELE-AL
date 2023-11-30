OBJECT table 20381 Guarantors Member Loans
{
  OBJECT-PROPERTIES
  {
    Date=07/06/22;
    Time=12:31:04 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LinkedObject=No;
    LookupPageID=Page51516389;
    DrillDownPageID=Page51516389;
  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20        ;TableRelation="Guarantors Recovery Header"."Document No" }
    { 2   ;   ;Loan No.            ;Code20        ;TableRelation="Guarantors Recovery Header"."Loan to Attach";
                                                   OnValidate=BEGIN
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.",Loans."Client Code");

                                                                IF CONFIRM('Are you Sure you Want to PayOff this loan?',TRUE)=TRUE THEN BEGIN

                                                                "Loan Type":='';
                                                                "Approved Loan Amount":=0;
                                                                "Loan Instalments":=0;
                                                                "Monthly Repayment":=0;
                                                                Loantypes.RESET;
                                                                Loantypes.SETRANGE(Loantypes.Code,"Loan Type");



                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan No.");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due",Loans."Oustanding Interest");
                                                                "Loan Type":=Loans."Loan Product Type";
                                                                IF Cust.GET(Loans."Client Code") THEN BEGIN
                                                                  "Staff No":=Cust."ID No.";
                                                                  "Staff No":=Cust."Payroll/Staff No";
                                                                    END;

                                                                "Approved Loan Amount":=Loans."Outstanding Balance";
                                                                "Loan Instalments":=Loans."Oustanding Interest";
                                                                "Monthly Repayment":="Approved Loan Amount" +"Loan Instalments";
                                                                "Loan Outstanding":="Monthly Repayment";
                                                                "Outstanding Balance":=Loans.Repayment;
                                                                GenSetUp.GET();
                                                                IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                END;
                                                                END;
                                                                "Monthly Repayment":="Approved Loan Amount" +"Loan Instalments";
                                                                Loans.Bridged:=TRUE;
                                                                Loans.MODIFY
                                                                END;


                                                                IF Loans.GET("Document No") THEN BEGIN
                                                                IF "Monthly Repayment">Loans."Requested Amount" THEN
                                                                ERROR('You Can not PayOff more than the requested amount');
                                                                END;
                                                                "Monthly Repayment":="Approved Loan Amount" +"Loan Instalments";
                                                              END;
                                                               }
    { 3   ;   ;Member No           ;Code20         }
    { 4   ;   ;Loan Type           ;Code20         }
    { 5   ;   ;Approved Loan Amount;Decimal        }
    { 6   ;   ;Loan Instalments    ;Decimal        }
    { 7   ;   ;Monthly Repayment   ;Decimal        }
    { 8   ;   ;Outstanding Balance ;Decimal        }
    { 9   ;   ;Outstanding Interest;Decimal        }
    { 10  ;   ;Interest Rate       ;Decimal        }
    { 11  ;   ;ID. NO              ;Code20         }
    { 12  ;   ;Staff No            ;Code20         }
    { 13  ;   ;Posted              ;Boolean        }
    { 14  ;   ;Posting Date        ;Date           }
    { 15  ;   ;Loan Outstanding    ;Decimal        }
    { 16  ;   ;Amont Guaranteed    ;Decimal       ;OnValidate=BEGIN
                                                                //Shares:=Shares*-1;
                                                                //MESSAGE('SHARE %1',Shares);




                                                                IF "Amont Guaranteed">(Shares) THEN
                                                                ERROR('You cannot guarantee more than your shares of %1',Shares);


                                                                {
                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Outstanding Balance",Cust."Current Shares");//,Cust."Loans Guaranteed"
                                                                Name:=Cust.Name;
                                                                "Loan Balance":=Cust."Outstanding Balance";
                                                                Shares:=Cust."Current Shares"*-1;
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 17  ;   ;Shares              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Member No),
                                                                                                        Transaction Type=FILTER(Loan),
                                                                                                        Posting Date=FIELD(Date Filter)));
                                                   Editable=Yes }
    { 18  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Date Filter }
    { 19  ;   ;Defaulter Loan      ;Decimal        }
    { 20  ;   ;Guarantor Number    ;Code50         }
    { 22  ;   ;Guarantors Committed Shares;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Guarantee Details"."Amont Guaranteed" WHERE (Member No=FIELD(Guarantor Number))) }
    { 23  ;   ;Guarantors Free Shares;Decimal      }
    { 24  ;   ;Guarantors Current Shares;Decimal  ;FieldClass=Normal }
    { 25  ;   ;Defaulter Loan No   ;Code50         }
    { 26  ;   ;Amount              ;Decimal        }
  }
  KEYS
  {
    {    ;Document No,Member No,Loan No.,Guarantor Number;
                                                   SumIndexFields=Monthly Repayment,Approved Loan Amount;
                                                   Clustered=Yes }
    {    ;Approved Loan Amount                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Member No,Loan Type,Approved Loan Amount,Loan Instalments,Monthly Repayment,Outstanding Balance,Outstanding Interest,Interest Rate,ID. NO,Posted }
  }
  CODE
  {
    VAR
      Loans@1102760000 : Record 51516230;
      Loantypes@1000000000 : Record 51516240;
      Interest@1000000001 : Decimal;
      Cust@1102755000 : Record 51516223;
      LoansTop@1102755001 : Record 51516230;
      GenSetUp@1102755002 : Record 51516257;
      LoansG@1000000002 : Record 51516231;
      GuarantorRecH@1000000003 : Record 51516390;
      LoanResch@1000000004 : Record 51516234;

    BEGIN
    END.
  }
}

