OBJECT table 17280 Special Loan Clearances
{
  OBJECT-PROPERTIES
  {
    Date=04/06/16;
    Time=[ 3:39:52 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page39004250;
    DrillDownPageID=Page39004250;
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20        ;TableRelation="Loans Register"."Loan  No." }
    { 2   ;   ;Loan Top Up         ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Client Code),
                                                                                                     Posted=CONST(Yes),
                                                                                                     Outstanding Balance=FILTER(>0),
                                                                                                     Loan Product Type=CONST(BCL));
                                                   OnValidate=BEGIN
                                                                "Loan Type":='';
                                                                "Principle Top Up":=0;
                                                                "Interest Top Up":=0;
                                                                "Total Top Up":=0;
                                                                Loantypes.RESET;
                                                                Loantypes.SETRANGE(Loantypes.Code,"Loan Type");
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due");
                                                                "Loan Type":=Loans."Loan Product Type";
                                                                IF Cust.GET(Loans."Account No") THEN BEGIN
                                                                "ID. NO":=Cust."ID No.";
                                                                END;

                                                                "Principle Top Up":=Loans."Outstanding Balance";
                                                                "Interest Top Up":="Principle Top Up"*(Loans.Interest/100/12);
                                                                "Total Top Up":="Principle Top Up" +"Interest Top Up";
                                                                "Monthly Repayment":=Loans.Repayment;


                                                                IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                Commision:=("Principle Top Up"+"Interest Top Up")*(Loantypes."Top Up Commision"/100);
                                                                END;
                                                                "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Client Code         ;Code20         }
    { 4   ;   ;Loan Type           ;Code20         }
    { 5   ;   ;Principle Top Up    ;Decimal       ;OnValidate=BEGIN
                                                                //IF Loantypes.GET("Loan Type") THEN BEGIN
                                                                //"Interest Top Up":="Principle Top Up"*(Loantypes."Interest rate"/100);
                                                                //END;

                                                                //"Interest Top Up":="Principle Top Up"*(1.75/100);


                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance");
                                                                //IF "Principle Top Up" > Loans."Outstanding Balance" THEN
                                                                //ERROR('Amount cannot be greater than the loan oustanding balance.');
                                                                 "Interest Top Up":="Principle Top Up"*(Loans.Interest/100);
                                                                END;



                                                                "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;
                                                              END;
                                                               }
    { 6   ;   ;Interest Top Up     ;Decimal       ;OnValidate=BEGIN
                                                                "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;

                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Interest Due");
                                                                IF "Principle Top Up" < Loans."Outstanding Balance" THEN
                                                                ERROR('Amount cannot be greater than the interest due.');

                                                                END;
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
                                                                  "Total Top Up":="Principle Top Up" +"Interest Top Up"+Commision;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Loan No.,Client Code                    ;SumIndexFields=Total Top Up,Principle Top Up;
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

    BEGIN
    END.
  }
}

