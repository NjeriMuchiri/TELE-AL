OBJECT table 20480 Loan Exempt Interest
{
  OBJECT-PROPERTIES
  {
    Date=08/29/17;
    Time=[ 5:36:05 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan Product        ;Code10        ;TableRelation="Loan Products Setup".Code;
                                                   OnValidate=BEGIN
                                                                LoansProduct.RESET;
                                                                LoansProduct.SETRANGE(LoansProduct.Code,"Loan Product");
                                                                IF LoansProduct.FINDFIRST THEN
                                                                  BEGIN
                                                                    "Loan Product Name":=LoansProduct."Product Description";
                                                                  END;
                                                              END;
                                                               }
    { 2   ;   ;Loan Product Name   ;Text50        ;Editable=No }
  }
  KEYS
  {
    {    ;Loan Product                            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LoansProduct@1000000000 : Record 51516240;

    BEGIN
    END.
  }
}

