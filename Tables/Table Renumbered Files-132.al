OBJECT table 17250 Receipt Allocation
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=[ 4:24:04 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516243;
    DrillDownPageID=Page51516243;
  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Member No           ;Code20        ;TableRelation="Members Register".No.;
                                                   NotBlank=Yes }
    { 3   ;   ;Transaction Type    ;Option        ;OnValidate=BEGIN
                                                                "Loan No.":='';
                                                                Amount:=0;

                                                                {
                                                                IF ("Transaction Type" = "Transaction Type"::Commision) OR ("Transaction Type" = "Transaction Type"::Investment) THEN BEGIN
                                                                IF "Loan No." = '' THEN
                                                                ERROR('You must specify loan no. for loan transactions.');
                                                                END;
                                                                 }
                                                                 {
                                                                IF ("Transaction Type" <> "Transaction Type"::Repayment) THEN BEGIN
                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                IF Cust."Customer Type" <> Cust."Customer Type"::Member THEN
                                                                ERROR('This transaction type only applicable for BOSA Members.');
                                                                END;
                                                                END;
                                                                 }
                                                              END;

                                                   OptionCaptionML=ENG=
                                                                   ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Holiday_Savers,Penalty Paid,Dev Shares,Fanikisha,Welfare Contribution 2,Loan Penalty,Loan Guard,Gpange,Junior,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,SchFees Shares;
                                                   OptionString=
                                                   ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Holiday_Savers,Penalty Paid,Dev Shares,Fanikisha,Welfare Contribution 2,Loan Penalty,Loan Guard,Gpange,Junior,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,SchFees Shares;
                                                   NotBlank=Yes }
    { 4   ;   ;Loan No.            ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Member No),
                                                                                                     Source=FILTER(FOSA|BOSA));
                                                   OnValidate=BEGIN

                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                                                                IF Loans."Outstanding Balance" > 0 THEN BEGIN
                                                                Amount:=Loans.Repayment-Loans."Oustanding Interest";
                                                                "Interest Amount":=Loans."Oustanding Interest";
                                                                END;
                                                                END;



                                                                "Total Amount":=Amount+"Interest Amount";
                                                              END;
                                                               }
    { 5   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                IF ("Transaction Type" = "Transaction Type"::Repayment) OR ("Transaction Type" = "Transaction Type"::"Interest Paid") THEN BEGIN
                                                                IF "Loan No." = '' THEN
                                                                ERROR('You must specify loan no. for loan transactions.');
                                                                END;

                                                                {IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance");
                                                                IF Loans.Posted = TRUE THEN BEGIN
                                                                IF Amount > Loans."Outstanding Balance" THEN
                                                                ERROR('Principle Repayment cannot be more than the loan oustanding balance.');
                                                                END;
                                                                END;     }

                                                                "Total Amount":=Amount+"Interest Amount";
                                                              END;
                                                               }
    { 6   ;   ;Interest Amount     ;Decimal       ;OnValidate=BEGIN

                                                                {IF ("Transaction Type" = "Transaction Type"::"Registration Fee") THEN BEGIN
                                                                IF "Loan No." = '' THEN
                                                                ERROR('You must specify loan no. for loan transactions.');
                                                                END;


                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Oustanding Interest");
                                                                IF "Interest Amount" > Loans."Oustanding Interest" THEN
                                                                ERROR('Interest Repayment cannot be more than the loan oustanding balance.');
                                                                END;


                                                                "Total Amount":=Amount+"Interest Amount"+"Loan Insurance";
                                                                }
                                                              END;
                                                               }
    { 7   ;   ;Total Amount        ;Decimal       ;Editable=No }
    { 8   ;   ;Amount Balance      ;Decimal        }
    { 9   ;   ;Interest Balance    ;Decimal        }
    { 10  ;   ;Loan ID             ;Code10         }
    { 11  ;   ;Prepayment Date     ;Date           }
    { 50000;  ;Loan Insurance      ;Decimal       ;OnValidate=BEGIN

                                                                //Loans.GET();
                                                                   CALCFIELDS("Applied Amount");

                                                                   IF "Applied Amount">100000 THEN
                                                                    //Loans.SETRANGE(Loans."Client Code","Member No");
                                                                   "Loan Insurance":="Applied Amount"*0.25;
                                                              END;

                                                   BlankZero=Yes }
    { 50001;  ;Applied Amount      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loans Register"."Approved Amount" WHERE (Loan  No.=FIELD(Loan No.))) }
    { 50002;  ;Insurance           ;Decimal        }
    { 50003;  ;Un Allocated Amount ;Decimal        }
    { 51516150;;Global Dimension 1 Code;Code20    ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1)) }
    { 51516151;;Global Dimension 2 Code;Code20    ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
  }
  KEYS
  {
    {    ;Document No,Member No,Transaction Type,Loan No.,Loan ID,Un Allocated Amount;
                                                   SumIndexFields=Total Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Loans@1102760000 : Record 51516230;
      Cust@1102760001 : Record 51516223;

    BEGIN
    END.
  }
}

