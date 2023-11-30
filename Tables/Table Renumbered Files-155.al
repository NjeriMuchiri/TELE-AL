OBJECT table 17273 Refunds
{
  OBJECT-PROPERTIES
  {
    Date=01/06/16;
    Time=[ 2:00:54 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Member No.          ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Transaction Type    ;Option        ;OnValidate=BEGIN
                                                                IF "Transaction Type" = "Transaction Type"::"Unallocated Funds" THEN BEGIN
                                                                IF Cust.GET("Member No.") THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Un-allocated Funds");
                                                                Amount:=Cust."Un-allocated Funds" * -1;
                                                                END;
                                                                END;
                                                              END;

                                                   OptionString=[ ,Shares Contribution,Repayment,Interest,Unallocated Funds];
                                                   NotBlank=Yes }
    { 3   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                IF "Transaction Type" = "Transaction Type"::"Unallocated Funds" THEN BEGIN
                                                                IF Cust.GET("Member No.") THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Un-allocated Funds");
                                                                IF Amount > (Cust."Un-allocated Funds"*-1) THEN
                                                                ERROR('Amount cannot be greater than the un-allocated funds: %1',(Cust."Un-allocated Funds"*-1));;
                                                                END;
                                                                END;

                                                                IF  Amount <> 0 THEN BEGIN

                                                                IF "Transaction Type" = "Transaction Type"::"Shares Contribution" THEN BEGIN
                                                                IF Cust.GET("Member No.") THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Current Shares");
                                                                IF Amount > (Cust."Current Shares"*-1) THEN
                                                                ERROR('Amount cannot be greater than the current shares: %1',(Cust."Current Shares"*-1));;
                                                                END;
                                                                END;


                                                                IF "Transaction Type" = "Transaction Type"::Repayment THEN BEGIN
                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Current Repayment");
                                                                IF Amount > (Loans."Current Repayment"*-1) THEN
                                                                ERROR('Amount cannot be greater than the total repayments: %1',(Loans."Current Repayment"*-1));;
                                                                END;
                                                                END;

                                                                IF "Transaction Type" = "Transaction Type"::Interest THEN BEGIN
                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Interest Paid");
                                                                IF Amount > (Loans."Interest Paid"*-1) THEN
                                                                ERROR('Amount cannot be greater than the interest paid: %1',(Loans."Interest Paid"*-1));;
                                                                END;
                                                                END;
                                                                END;
                                                              END;

                                                   NotBlank=Yes }
    { 4   ;   ;Loan No.            ;Code20        ;TableRelation=IF (Transaction Type=CONST(Repayment)) "Absence Preferences"."Include Weekends" WHERE (Field4=FIELD(Member No.))
                                                                 ELSE IF (Transaction Type=CONST(Interest)) "Absence Preferences"."Include Weekends" WHERE (Field4=FIELD(Member No.));
                                                   OnValidate=BEGIN

                                                                IF "Transaction Type" = "Transaction Type"::Repayment THEN BEGIN
                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Current Repayment");
                                                                IF Amount > (Loans."Current Repayment"*-1) THEN
                                                                ERROR('Amount cannot be greater than the total repayments: %1',(Loans."Current Repayment"*-1));;
                                                                END;
                                                                END;


                                                                IF "Transaction Type" = "Transaction Type"::Interest THEN BEGIN
                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Interest Paid");
                                                                IF Amount > (Loans."Interest Paid"*-1) THEN
                                                                ERROR('Amount cannot be greater than the interest paid: %1',(Loans."Interest Paid"*-1));;
                                                                END;
                                                                END;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Member No.,Transaction Type,Loan No.    ;SumIndexFields=Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Cust@1102760000 : Record 51516223;
      Loans@1102760001 : Record 51516230;

    BEGIN
    END.
  }
}

