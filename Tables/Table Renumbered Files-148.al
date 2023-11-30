OBJECT table 17266 Other Commitements Clearance
{
  OBJECT-PROPERTIES
  {
    Date=11/18/19;
    Time=11:56:37 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516365;
    DrillDownPageID=Page51516365;
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20        ;TableRelation="Loans Register"."Loan  No.";
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Payee               ;Text50        ;ValidateTableRelation=No;
                                                   NotBlank=Yes }
    { 4   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                IF Amount < 0 THEN
                                                                ERROR('Amount cannot be less than 0');
                                                              END;
                                                               }
    { 5   ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 6   ;   ;Bankers Cheque No   ;Code20         }
    { 7   ;   ;Bankers Cheque No 2 ;Code20         }
    { 8   ;   ;Bankers Cheque No 3 ;Code20         }
    { 9   ;   ;Batch No.           ;Code20         }
  }
  KEYS
  {
    {    ;Loan No.,Payee                          ;SumIndexFields=Amount;
                                                   Clustered=Yes }
    {    ;Payee                                    }
    {    ;Batch No.                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

