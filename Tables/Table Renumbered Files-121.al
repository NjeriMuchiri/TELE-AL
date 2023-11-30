OBJECT table 17239 Loan Offset Details
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=12:20:38 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516249;
    DrillDownPageID=Page51516249;
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20        ;TableRelation="Loans Register"."Loan  No." }
    { 2   ;   ;Loan Top Up         ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Client Code),
                                                                                                     Posted=CONST(Yes),
                                                                                                     Outstanding Balance=FILTER(>0));
                                                   OnValidate=BEGIN

                                                                IF Rec."Loan Top Up"<>xRec."Loan Top Up" THEN BEGIN
                                                                IF NOT CONFIRM('Are you Sure you Want to Offset this loan?',FALSE) THEN EXIT;
                                                                  MESSAGE('Enter expected Repayment');

                                                                END;

                                                                "Loan Type":='';
                                                                "Principle Top Up":=0;
                                                                "Interest Top Up":=0;
                                                                "Total Top Up":=0;
                                                                PenaltyTopup:=0;
                                                                //Loantypes.GET();



                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due",Loans."Oustanding Interest",Loans."Oustanding Penalty");
                                                                "Loan Type":=Loans."Loan Product Type";
                                                                IF Cust.GET(Loans."BOSA No") THEN BEGIN
                                                                  "ID. NO":=Cust."ID No.";
                                                                  "Staff No":=Cust."Payroll/Staff No";
                                                                //   "Principle Top Up":=ROUND(Loans."Outstanding Balance",1,'>');Kitui12/09/23
                                                                // "Interest Top Up":=ROUND(Loans."Oustanding Interest",1,'>');Kitui12/09/23
                                                                // PenaltyTopup:=ROUND(Loans."Oustanding Penalty",1,'>');Kitui12/09/23
                                                                  "Principle Top Up":=Loans."Outstanding Balance";
                                                                "Interest Top Up":=Loans."Oustanding Interest";
                                                                PenaltyTopup:=Loans."Oustanding Penalty";
                                                                "Total Top Up":="Principle Top Up";// +"Interest Top Up";
                                                                "Monthly Repayment":=Loans.Repayment;
                                                                Loans.Bridged:=TRUE;
                                                                Loans.MODIFY
                                                                END;
                                                                END;
                                                                IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                Commision:=ROUND(("Principle Top Up"-"Expected Repayment")*(Loantypes."Top Up Commision"/100),1,'>');
                                                                interesttopup:=ROUND((Loans."Outstanding Balance")*((Loantypes."Interest rate"/12)/100),0.01,'>');
                                                                "Interest Top Up":=ROUND(Loans."Oustanding Interest",1,'>')+interesttopup;
                                                                "Interest Charged":=interesttopup;
                                                                "Total Top Up":="Total Top Up"+Commision+"Interest Top Up"+PenaltyTopup;
                                                                END;
                                                                {IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                Commision:=ROUND(("Principle Top Up"-"Expected Repayment")*(Loantypes."Top Up Commision"/100),1,'>');
                                                                interesttopup:=ROUND((Loans."Outstanding Balance")*((Loantypes."Interest rate"/12)/100),0.01,'>');
                                                                  END;
                                                                "Interest Top Up":=ROUND(Loans."Oustanding Interest",1,'>')+interesttopup;

                                                                 "Total Top Up":="Principle Top Up"+"Interest Top Up"+Commision;
                                                                END;}
                                                              END;
                                                               }
    { 3   ;   ;Client Code         ;Code20         }
    { 4   ;   ;Loan Type           ;Code20         }
    { 5   ;   ;Principle Top Up    ;Decimal       ;OnValidate=BEGIN
                                                                //Loantypes.GET();
                                                                IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                "Interest Top Up":=ROUND("Principle Top Up"*(Loantypes."Interest rate"/100),0.01,'>');

                                                                  END;


                                                                //IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                Commision:=ROUND(("Principle Top Up"-"Expected Repayment")*(Loantypes."Top Up Commision"/100),1,'>');
                                                                  //END;
                                                                 "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;

                                                                //"Interest Top Up":="Principle Top Up"*(1.75/100);


                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance");


                                                                  //MESSAGE('%1',Loans."Outstanding Balance");
                                                                {IF "Principle Top Up" > Loans."Outstanding Balance" THEN
                                                                ERROR('Amount cannot be greater than the loan oustanding balance.');}
                                                                // "Interest Top Up":="Principle Top Up"*(Loans.Interest/100);
                                                                END;

                                                                {IF "Principle Top Up" > Loans."Requested Amount" THEN
                                                                ERROR('Amount cannot be greater than the loan oustanding balance.');}
                                                                 //"Interest Top Up":="Principle Top Up"*(Loans.Interest/100);
                                                                //END;
                                                                {
                                                                IF  Commision < 500 THEN BEGIN
                                                                 Commision:=500
                                                                END ELSE BEGIN
                                                                Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');

                                                                END;
                                                                }



                                                                "Total Top Up":="Principle Top Up";// +"Interest Top Up";
                                                              END;
                                                               }
    { 6   ;   ;Interest Top Up     ;Decimal       ;OnValidate=BEGIN
                                                                {"Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;

                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Interest Due");
                                                                IF "Principle Top Up" < Loans."Outstanding Balance" THEN
                                                                ERROR('Amount cannot be greater than the interest due.');

                                                                END;
                                                                }
                                                                GenSetUp.GET();
                                                                Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');
                                                                 "Total Top Up":="Principle Top Up";// +"Interest Top Up";//+Commision;
                                                                Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');
                                                                {
                                                                IF  Commision < 500 THEN BEGIN
                                                                 Commision:=500
                                                                END ELSE BEGIN
                                                                Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');

                                                                END;
                                                                }
                                                              END;
                                                               }
    { 7   ;   ;Total Top Up        ;Decimal        }
    { 8   ;   ;Monthly Repayment   ;Decimal        }
    { 9   ;   ;Interest Paid       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Loan No=FIELD(Loan Top Up),
                                                                                                       Transaction Type=FILTER(Interest Paid))) }
    { 10  ;   ;Outstanding Balance ;Decimal       ;FieldClass=Normal }
    { 11  ;   ;Interest Rate       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register".Interest WHERE (Loan  No.=FIELD(Loan Top Up),
                                                                                                    Client Code=FIELD(Client Code))) }
    { 12  ;   ;ID. NO              ;Code20         }
    { 13  ;   ;Commision           ;Decimal       ;OnValidate=BEGIN
                                                                  "Total Top Up":="Principle Top Up";// +"Interest Top Up"+Commision;
                                                              END;
                                                               }
    { 14  ;   ;Partial Bridged     ;Boolean       ;OnValidate=BEGIN

                                                                 LoansTop.RESET;
                                                                 LoansTop.SETRANGE(LoansTop."Loan  No.","Loan Top Up");
                                                                 IF LoansTop.FIND('-') THEN BEGIN
                                                                 IF "Partial Bridged"=TRUE THEN
                                                                 LoansTop."partially Bridged":=TRUE;
                                                                 LoansTop.MODIFY;
                                                                 END;
                                                              END;
                                                               }
    { 15  ;   ;Remaining Installments;Decimal      }
    { 16  ;   ;Finale Instalment   ;Decimal        }
    { 17  ;   ;Penalty Charged     ;Decimal        }
    { 18  ;   ;Outstanding Interest;Decimal        }
    { 20  ;   ;Staff No            ;Code20         }
    { 21  ;   ;Interest On Top Up  ;Decimal        }
    { 22  ;   ;Expected Repayment  ;Decimal       ;OnValidate=BEGIN

                                                                VALIDATE("Loan Top Up");
                                                                IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                        "Principle Top Up":=ROUND(("Principle Top Up"-"Expected Repayment"));
                                                                        Commision:=ROUND(("Principle Top Up")*(Loantypes."Top Up Commision"/100),1,'>');
                                                                        "Total Top Up":="Principle Top Up"+"Interest Top Up"+Commision;

                                                                END;
                                                              END;
                                                               }
    { 23  ;   ;Mark Adviced        ;Boolean        }
    { 24  ;   ;Interest Charged    ;Decimal        }
  }
  KEYS
  {
    {    ;Loan No.,Client Code,Loan Top Up        ;SumIndexFields=Total Top Up,Principle Top Up;
                                                   Clustered=Yes }
    {    ;Principle Top Up                         }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Client Code,Loan Type,Principle Top Up,Interest Top Up,Total Top Up,Monthly Repayment,Interest Paid,Outstanding Balance,Interest Rate,Commision }
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
      interesttopup@1120054000 : Decimal;
      PenaltyTopup@1120054001 : Decimal;

    BEGIN
    END.
  }
}

