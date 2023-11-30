OBJECT table 17242 Loan Special Clearance
{
  OBJECT-PROPERTIES
  {
    Date=01/15/16;
    Time=11:26:59 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20        ;TableRelation="Absence Preferences"."Include Weekends";
                                                   NotBlank=Yes }
    { 2   ;   ;Loan Off Set        ;Code20        ;OnValidate=BEGIN
                                                                "Loan Type":='';
                                                                "Principle Off Set":=0;
                                                                "Interest Off Set":=0;
                                                                "Total Off Set":=0;
                                                                PrincipleRepayment:=0;

                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Off Set");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Source:=Loans.Source;
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due");
                                                                "Loan Type":=Loans."Loan Product Type";
                                                                PrincipleRepayment:=Loans.Repayment-Loans."Interest Due";
                                                                IF PrincipleRepayment < 0 THEN BEGIN
                                                                "Interest Off Set":=PrincipleRepayment*-1;
                                                                PrincipleRepayment:=0;
                                                                END;

                                                                IF ("Loan Type" = 'ADVANCE') OR ("Loan Type" = 'SAL ADV') OR ("Loan Type" = 'FLEX') OR ("Loan Type" = 'OMEGA ADV')  THEN BEGIN
                                                                "Principle Off Set":=Loans."Outstanding Balance";
                                                                IF Loans."Interest Due" > 0 THEN
                                                                "Interest Off Set":=Loans."Interest Due";
                                                                END ELSE
                                                                "Principle Off Set":=Loans."Outstanding Balance"-PrincipleRepayment;
                                                                //Bett"Principle Off Set":=Loans."Outstanding Balance"-(Loans."Amortised Repayment"-PrincipleRepayment);

                                                                //PKKIF Loans."Interest Due" > 0 THEN
                                                                //PKK"Interest Off Set":=Loans."Interest Due";
                                                                END;

                                                                //PKK SUPER WEEKLY
                                                                {
                                                                IF ("Loan Type" = 'SUPER') THEN BEGIN
                                                                "Principle Off Set":=0;
                                                                "Interest Off Set":=0;
                                                                IF Loans."Outstanding Balance" > 0 THEN
                                                                "Principle Off Set":=Loans."Outstanding Balance";
                                                                IF Loans."Interest Due" > 0 THEN
                                                                "Interest Off Set":=Loans."Interest Due";
                                                                END;
                                                                }
                                                                //PKK SUPER WEEKLY

                                                                "Monthly Repayment":=Loans.Repayment;


                                                                IF "Principle Off Set" < 0 THEN
                                                                "Principle Off Set" := 0;

                                                                IF "Interest Off Set" < 0 THEN
                                                                "Interest Off Set":=0;

                                                                IF ("Principle Off Set"+"Interest Off Set") > 0 THEN
                                                                "Total Off Set":="Principle Off Set"+"Interest Off Set";
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Client Code         ;Code20         }
    { 4   ;   ;Loan Type           ;Code20         }
    { 5   ;   ;Principle Off Set   ;Decimal       ;OnValidate=BEGIN
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Off Set");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance");
                                                                IF "Principle Off Set" > Loans."Outstanding Balance" THEN
                                                                ERROR('Amount cannot be greater than the loan oustanding balance.');

                                                                END;

                                                                "Total Off Set":="Principle Off Set"+"Interest Off Set";
                                                              END;
                                                               }
    { 6   ;   ;Interest Off Set    ;Decimal       ;OnValidate=BEGIN
                                                                "Total Off Set":="Principle Off Set"+"Interest Off Set";

                                                                IF  "Interest Off Set" <> 0 THEN BEGIN
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan Off Set");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Interest Due");
                                                                IF "Interest Off Set" > Loans."Interest Due" THEN
                                                                ERROR('Amount cannot be greater than the interest due.');

                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 7   ;   ;Total Off Set       ;Decimal       ;Editable=No }
    { 8   ;   ;Monthly Repayment   ;Decimal        }
    { 9   ;   ;Source              ;Option        ;OptionCaptionML=ENU=BOSA,FOSA;
                                                   OptionString=BOSA,FOSA }
  }
  KEYS
  {
    {    ;Loan No.,Client Code,Loan Off Set       ;SumIndexFields=Total Off Set;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Loans@1102760000 : Record 51516230;
      PrincipleRepayment@1102760001 : Decimal;

    BEGIN
    END.
  }
}

