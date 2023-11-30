OBJECT table 20436 Guarantorship Substitution H
{
  OBJECT-PROPERTIES
  {
    Date=05/26/22;
    Time=[ 4:40:08 PM];
    Modified=Yes;
    Version List=GuarantorSub Ver1.0;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Document No" = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Guarantor Substitution");
                 NoSeriesMgt.InitSeries(SalesSetup."Guarantor Substitution",xRec."No. Series",0D,"Document No","No. Series");
               END;

               "Application Date":=TODAY;
               "Created By":=USERID;
             END;

    LookupPageID=Page51516916;
    DrillDownPageID=Page51516916;
  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20        ;OnValidate=BEGIN
                                                                IF "Document No" <> xRec."Document No" THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Guarantor Substitution");
                                                                  "No. Series" := '';
                                                                  END;
                                                              END;
                                                               }
    { 2   ;   ;Application Date    ;Date           }
    { 3   ;   ;Loanee Member No    ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                IF Cust.GET("Loanee Member No") THEN BEGIN
                                                                  "Loanee Name":=Cust.Name;
                                                                  END;
                                                              END;
                                                               }
    { 4   ;   ;Loanee Name         ;Code60         }
    { 5   ;   ;Loan Guaranteed     ;Code30        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Loanee Member No));
                                                   OnValidate=BEGIN
                                                                GuarantorshipLine.RESET;
                                                                GuarantorshipLine.SETRANGE(GuarantorshipLine."Document No","Document No");
                                                                IF GuarantorshipLine.FINDSET THEN BEGIN
                                                                  GuarantorshipLine.DELETEALL;
                                                                  END;



                                                                    LoanGuarantors.RESET;
                                                                    LoanGuarantors.SETRANGE(LoanGuarantors."Loan No","Loan Guaranteed");
                                                                    IF LoanGuarantors.FINDSET THEN BEGIN
                                                                        REPEAT

                                                                        TGrAmount:=0;
                                                                        GrAmount:=0;
                                                                        FGrAmount:=0;

                                                                          LoanGuar.RESET;
                                                                          LoanGuar.SETRANGE(LoanGuar."Loan No","Loan Guaranteed");
                                                                            IF LoanGuar.FIND('-') THEN BEGIN
                                                                              REPEAT
                                                                                GrAmount:=LoanGuar."Amont Guaranteed";
                                                                                TGrAmount:=TGrAmount+GrAmount;
                                                                                FGrAmount:=TGrAmount+LoanGuar."Amont Guaranteed";
                                                                              UNTIL LoanGuar.NEXT=0;
                                                                            END;


                                                                      IF LoansRec.GET("Loan Guaranteed") THEN BEGIN
                                                                      //Defaulter loan clear
                                                                      LoansRec.CALCFIELDS(LoansRec."Outstanding Balance",LoansRec."Interest Due");
                                                                      Lbal:=ROUND(LoansRec."Outstanding Balance",1,'=');
                                                                        IF LoansRec."Oustanding Interest">0 THEN BEGIN
                                                                          INTBAL:=ROUND(LoansRec."Oustanding Interest",1,'=');
                                                                          COMM:=ROUND((LoansRec."Oustanding Interest"*0.5),1,'=');
                                                                          LoansRec."Attached Amount":=Lbal;
                                                                          LoansRec.PenaltyAttached:=COMM;
                                                                          LoansRec.InDueAttached:=INTBAL;
                                                                          MODIFY;
                                                                        END;




                                                                        GenSetUp.GET();
                                                                        GenSetUp."Defaulter LN":=GenSetUp."Defaulter LN"+10;
                                                                        GenSetUp.MODIFY;
                                                                        DLN:='DLN_'+FORMAT(GenSetUp."Defaulter LN");
                                                                        TGrAmount:=TGrAmount+GrAmount;
                                                                        GrAmount:=LoanGuarantors."Amont Guaranteed";



                                                                      IF loanTypes.GET(LoansRec."Loan Product Type") THEN BEGIN





                                                                {
                                                                      GuarantorshipLine.INIT;
                                                                      GuarantorshipLine."Document No":="Document No";
                                                                      GuarantorshipLine."Loan No.":=LoanGuarantors."Loan No";
                                                                      GuarantorshipLine."Member No":=LoanGuarantors."Member No";
                                                                      GuarantorshipLine."Member Name":=LoanGuarantors.Name;
                                                                      GuarantorshipLine."Amount Guaranteed":=LoanGuarantors."Amont Guaranteed";
                                                                      GuarantorshipLine."Current Commitment":=((GrAmount/FGrAmount)*(Lbal+INTBAL+COMM));
                                                                      GuarantorshipLine.Substituted:=LoanGuarantors.Substituted;
                                                                      GuarantorshipLine.VALIDATE(GuarantorshipLine."Loan No.");
                                                                      GuarantorshipLine.INSERT;}
                                                                      END;
                                                                      END;
                                                                      UNTIL LoanGuarantors.NEXT=0;
                                                                  END;
                                                              END;
                                                               }
    { 6   ;   ;Substituting Member ;Code30        ;TableRelation="Loans Guarantee Details"."Member No" WHERE (Loan No=FIELD(Loan Guaranteed));
                                                   OnValidate=BEGIN
                                                                IF Cust.GET("Substituting Member") THEN BEGIN
                                                                  "Substituting Member Name":=Cust.Name;
                                                                  END;
                                                              END;
                                                               }
    { 7   ;   ;Substituting Member Name;Code60     }
    { 8   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 9   ;   ;Created By          ;Code100        }
    { 10  ;   ;Substituted By      ;Code40         }
    { 11  ;   ;Date Substituted    ;Date           }
    { 12  ;   ;No. Series          ;Code20         }
    { 13  ;   ;Substituted         ;Boolean        }
    { 14  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=,Guarantor Replacement,Share Increment;
                                                   OptionString=,Guarantor Replacement,Share Increment }
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
      SalesSetup@1000000005 : Record 51516258;
      NoSeriesMgt@1000000004 : Codeunit 396;
      Cust@1000000003 : Record 51516223;
      GuarantorshipLine@1000000002 : Record 51516557;
      LoanRec@1000000001 : Record 51516230;
      LoanGuarantors@1000000000 : Record 51516231;
      TGrAmount@1000000006 : Decimal;
      GrAmount@1000000007 : Decimal;
      FGrAmount@1000000008 : Decimal;
      LoanGuar@1000000009 : Record 51516231;
      LoansRec@1000000010 : Record 51516230;
      GenSetUp@1000000011 : Record 51516257;
      Lbal@1000000012 : Decimal;
      INTBAL@1000000013 : Decimal;
      COMM@1000000014 : Decimal;
      DLN@1000000015 : Code[20];
      loanTypes@1000000016 : Record 51516240;

    BEGIN
    END.
  }
}

