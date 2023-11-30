OBJECT table 20437 Guarantorship Substitution L
{
  OBJECT-PROPERTIES
  {
    Date=10/18/21;
    Time=[ 2:47:06 PM];
    Modified=Yes;
    Version List=GuarantorSub Ver1.0;
  }
  PROPERTIES
  {
    LookupPageID=Page51516389;
    DrillDownPageID=Page51516389;
  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20        ;TableRelation="Guarantorship Substitution H"."Document No";
                                                   Editable=No }
    { 2   ;   ;Loan No.            ;Code20        ;OnValidate=BEGIN
                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                  Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                                                                  "Loan Type":=Loans."Loan Product Type";
                                                                  "Approved Loan Amount":=Loans."Approved Amount";
                                                                  "Loan Instalments":=Loans.Installments;
                                                                  "Monthly Repayment":=Loans.Repayment;
                                                                  "Outstanding Balance":=Loans."Outstanding Balance";
                                                                  "Outstanding Interest":=Loans."Oustanding Interest";
                                                                  END;
                                                                  //MESSAGE('tuko');

                                                                ObjLoanGuar.RESET;
                                                                ObjLoanGuar.SETRANGE(ObjLoanGuar."Loan No","Loan No.");

                                                                IF ObjLoanGuar.FINDSET THEN
                                                                  BEGIN
                                                                    TGrAmount:=0;
                                                                    GrAmount:=0;
                                                                    FGrAmount:=0;
                                                                    REPEAT
                                                                      GrAmount:=ObjLoanGuar."Amont Guaranteed";
                                                                      TGrAmount:=TGrAmount+GrAmount;
                                                                      FGrAmount:=TGrAmount+ObjLoanGuar."Amont Guaranteed";
                                                                      UNTIL ObjLoanGuar.NEXT=0;
                                                                    END;

                                                                ObjLoanGuar.RESET;
                                                                ObjLoanGuar.SETRANGE(ObjLoanGuar."Loan No","Loan No.");
                                                                ObjLoanGuar.SETRANGE(ObjLoanGuar."Member No","Member No");
                                                                IF ObjLoanGuar.FINDSET THEN
                                                                  BEGIN
                                                                     "Amount Guaranteed":=ObjLoanGuar."Amont Guaranteed";
                                                                    // "Current Commitment":=ObjLoanGuar."Committed Shares";
                                                                    END;
                                                              END;

                                                   Editable=No }
    { 3   ;   ;Member No           ;Code20        ;OnValidate=BEGIN
                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                  "Member Name":=Cust.Name;
                                                                  "ID. NO":=Cust."ID No.";
                                                                  "Staff No":=Cust."Payroll/Staff No";
                                                                  END;
                                                              END;

                                                   Editable=No }
    { 4   ;   ;Loan Type           ;Code20        ;Editable=No }
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
    { 15  ;   ;Amount Guaranteed   ;Decimal        }
    { 16  ;   ;Member Name         ;Code60        ;Editable=No }
    { 17  ;   ;Substituted         ;Boolean        }
    { 18  ;   ;Current Commitment  ;Decimal       ;Editable=No }
    { 19  ;   ;Substitute Member   ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                ObjLoanGuar.RESET;
                                                                ObjLoanGuar.SETRANGE(ObjLoanGuar."Loan No","Loan No.");
                                                                ObjLoanGuar.SETRANGE(ObjLoanGuar."Member No","Member No");
                                                                IF ObjLoanGuar.FINDSET THEN
                                                                  BEGIN
                                                                     "Amount Guaranteed":=ObjLoanGuar."Amont Guaranteed";
                                                                    // "Current Commitment":=ObjLoanGuar."Committed Shares";





                                                                IF Cust.GET("Substitute Member") THEN BEGIN
                                                                  Cust.CALCFIELDS("Current Savings");
                                                                  "Substitute Member Name":=Cust.Name;
                                                                  "Current Shares":=Cust."Current Savings";
                                                                  //"Sub Amount Guaranteed":="Current Shares";
                                                                  "Sub Amount Guaranteed":="Amount Guaranteed"
                                                                 END;
                                                                 IF "Current Shares" < 1 THEN
                                                                   ERROR('You do not have enough deposits');

                                                                 END;
                                                              END;
                                                               }
    { 20  ;   ;Substitute Member Name;Code60       }
    { 21  ;   ;Sub Amount Guaranteed;Decimal       }
    { 22  ;   ;Current Shares      ;Decimal       ;FieldClass=Normal }
  }
  KEYS
  {
    {    ;Document No,Member No,Loan No.,Substitute Member;
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
      ObjLoanGuar@1000000002 : Record 51516231;
      TGrAmount@1000000005 : Decimal;
      GrAmount@1000000004 : Decimal;
      FGrAmount@1000000003 : Decimal;
      GuarantorshipSubstitutionL@1000000006 : Record 51516557;

    BEGIN
    END.
  }
}

