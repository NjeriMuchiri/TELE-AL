OBJECT table 20383 Loans PayOff Details
{
  OBJECT-PROPERTIES
  {
    Date=06/13/18;
    Time=[ 3:00:20 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516389;
    DrillDownPageID=Page51516389;
  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20        ;TableRelation="Loan PayOff"."Document No" }
    { 2   ;   ;Loan to PayOff      ;Code20        ;TableRelation=IF (Source=FILTER(BOSA)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Member No),
                                                                                                                              Posted=CONST(Yes),
                                                                                                                              Outstanding Balance=FILTER(>0))
                                                                                                                              ELSE IF (Source=FILTER(FOSA)) "Loans Register"."Loan  No." WHERE (BOSA No=FIELD(Member No));
                                                   OnValidate=BEGIN

                                                                IF CONFIRM('Are you Sure you Want to PayOff this loan?',TRUE)=TRUE THEN BEGIN

                                                                "Loan Type":='';
                                                                "Principle PayOff":=0;
                                                                "Interest On PayOff":=0;
                                                                "Total PayOff":=0;
                                                                Loantypes.RESET;
                                                                Loantypes.SETRANGE(Loantypes.Code,"Loan Type");


                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan to PayOff");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due",Loans."Oustanding Interest");
                                                                "Loan Type":=Loans."Loan Product Type";
                                                                IF Cust.GET(Loans."Client Code") THEN BEGIN
                                                                  "ID. NO":=Cust."ID No.";
                                                                  "Staff No":=Cust."Payroll/Staff No";
                                                                END;

                                                                "Principle PayOff":=Loans."Outstanding Balance";
                                                                "Interest On PayOff":=Loans."Oustanding Interest";
                                                                "Total PayOff":="Principle PayOff" +"Interest On PayOff";
                                                                "Loan Outstanding":="Total PayOff";
                                                                "Monthly Repayment":=Loans.Repayment;
                                                                GenSetUp.GET();
                                                                IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                //"Commision on PayOff":=ROUND(("Principle PayOff"+"Interest On PayOff")*(Loantypes."Loan PayOff Fee(%)"/100),1,'>');
                                                                END;
                                                                END;
                                                                "Total PayOff":="Principle PayOff" +"Interest On PayOff"+"Commision on PayOff";
                                                                Loans.Bridged:=TRUE;
                                                                Loans.MODIFY
                                                                END;


                                                                IF Loans.GET("Document No") THEN BEGIN
                                                                IF "Total PayOff">Loans."Requested Amount" THEN
                                                                ERROR('You Can not PayOff more than the requested amount');
                                                                END;
                                                                "Total PayOff":="Principle PayOff" +"Interest On PayOff"+"Commision on PayOff";
                                                              END;
                                                               }
    { 3   ;   ;Member No           ;Code20        ;TableRelation=IF (Source=FILTER(BOSA)) "Members Register" }
    { 4   ;   ;Loan Type           ;Code20         }
    { 5   ;   ;Principle PayOff    ;Decimal       ;OnValidate=BEGIN
                                                                {//IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                //"Interest On PayOff":="Principle PayOff"*(Loantypes."Interest rate"/100);
                                                                //END;

                                                                //"Interest On PayOff":="Principle PayOff"*(1.75/100);


                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan to PayOff");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance");
                                                                IF "Principle PayOff" > Loans."Outstanding Balance" THEN
                                                                ERROR('Amount cannot be greater than the loan oustanding balance.');
                                                                // "Interest On PayOff":="Principle PayOff"*(Loans.Interest/100);
                                                                END;

                                                                IF "Principle PayOff" > Loans."Requested Amount" THEN
                                                                ERROR('Amount cannot be greater than the loan oustanding balance.');
                                                                 //"Interest On PayOff":="Principle PayOff"*(Loans.Interest/100);
                                                                //END;


                                                                IF  "Commision on PayOff" < 500 THEN BEGIN
                                                                 "Commision on PayOff":=500
                                                                END ELSE BEGIN
                                                                "Commision on PayOff":=ROUND(("Principle PayOff"+"Interest On PayOff")*(GenSetUp."Top up Commission"/100),1,'>');

                                                                END;
                                                                 "Total PayOff":="Principle PayOff" +"Interest On PayOff";//+Commision;


                                                                "Total PayOff":="Principle PayOff" +"Interest On PayOff";
                                                                }
                                                              END;
                                                               }
    { 6   ;   ;Interest On PayOff  ;Decimal       ;OnValidate=BEGIN
                                                                {{"Total PayOff":="Principle PayOff" +"Interest On PayOff"+Commision;

                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Interest Due");
                                                                IF "Principle PayOff" < Loans."Outstanding Balance" THEN
                                                                ERROR('Amount cannot be greater than the interest due.');

                                                                END;
                                                                }
                                                                GenSetUp.GET();
                                                                "Commision on PayOff":=ROUND(("Principle PayOff"+"Interest On PayOff")*(GenSetUp."Top up Commission"/100),1,'>');
                                                                 "Total PayOff":="Principle PayOff" +"Interest On PayOff";//+Commision;
                                                                "Commision on PayOff":=ROUND(("Principle PayOff"+"Interest On PayOff")*(GenSetUp."Top up Commission"/100),1,'>');

                                                                IF  "Commision on PayOff" < 500 THEN BEGIN
                                                                 "Commision on PayOff":=500
                                                                END ELSE BEGIN
                                                                "Commision on PayOff":=ROUND(("Principle PayOff"+"Interest On PayOff")*(GenSetUp."Top up Commission"/100),1,'>');

                                                                END;
                                                                }
                                                              END;
                                                               }
    { 7   ;   ;Total PayOff        ;Decimal        }
    { 8   ;   ;Monthly Repayment   ;Decimal        }
    { 9   ;   ;Interest Paid       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Member No),
                                                                                                       Loan No=FIELD(Loan to PayOff),
                                                                                                       Transaction Type=FILTER(Insurance Contribution))) }
    { 10  ;   ;Outstanding Balance ;Decimal       ;FieldClass=Normal }
    { 11  ;   ;Interest Rate       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register".Interest WHERE (Loan  No.=FIELD(Loan to PayOff),
                                                                                                    Client Code=FIELD(Member No))) }
    { 12  ;   ;ID. NO              ;Code20         }
    { 13  ;   ;Commision on PayOff ;Decimal       ;OnValidate=BEGIN
                                                                  "Total PayOff":="Principle PayOff" +"Interest On PayOff"+"Commision on PayOff";
                                                              END;
                                                               }
    { 14  ;   ;Partial Bridged     ;Boolean       ;OnValidate=BEGIN

                                                                 LoansTop.RESET;
                                                                 LoansTop.SETRANGE(LoansTop."Loan  No.","Loan to PayOff");
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
    { 18  ;   ;Staff No            ;Code20         }
    { 19  ;   ;Commissioning Balance;Decimal      ;OnValidate=BEGIN
                                                                {GenSetUp.GET();
                                                                "Commision on PayOff":=ROUND(("Commissioning Balance")*(GenSetUp."Top up Commission"/100),1,'>');
                                                                "Total PayOff":="Principle PayOff" +"Interest On PayOff"+"Commision on PayOff";
                                                                }
                                                              END;
                                                               }
    { 20  ;   ;Source              ;Option        ;OptionCaptionML=ENU=" ,BOSA,FOSA";
                                                   OptionString=[ ,BOSA,FOSA] }
    { 21  ;   ;Loan Outstanding    ;Decimal        }
    { 22  ;   ;Posted              ;Boolean        }
    { 23  ;   ;Posting Date        ;Date           }
  }
  KEYS
  {
    {    ;Document No,Member No,Loan to PayOff    ;SumIndexFields=Total PayOff,Principle PayOff;
                                                   Clustered=Yes }
    {    ;Principle PayOff                         }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Member No,Loan Type,Principle PayOff,Interest On PayOff,Total PayOff,Monthly Repayment,Interest Paid,Outstanding Balance,Interest Rate,Commision on PayOff }
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

    BEGIN
    END.
  }
}

