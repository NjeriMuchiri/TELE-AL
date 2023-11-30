OBJECT table 17248 Loan Applicaton Charges
{
  OBJECT-PROPERTIES
  {
    Date=01/15/16;
    Time=11:29:48 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No             ;Code20        ;TableRelation="Absence Preferences"."Include Weekends";
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Amount              ;Decimal        }
    { 4   ;   ;Code                ;Code20        ;TableRelation=Table51516173.Field2 }
    { 5   ;   ;Use Perc            ;Boolean        }
    { 6   ;   ;Perc (%)            ;Decimal       ;OnValidate=BEGIN
                                                                IF "Use Perc" = TRUE THEN BEGIN
                                                                IF Loans.GET("Loan No") THEN
                                                                Amount:=Loans."Approved Amount"*"Perc (%)"*0.01;
                                                                END ELSE
                                                                ERROR('Only applicable for charges where percentage is applicable.');
                                                              END;
                                                               }
    { 7   ;   ;G/L Account         ;Code20         }
    { 8   ;   ;Paid Before Disb.   ;Boolean        }
    { 9   ;   ;Loan Type           ;Code20         }
  }
  KEYS
  {
    {    ;Loan No,Description                     ;Clustered=Yes }
    {    ;Loan No,G/L Account                      }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Loans@1102755000 : Record 51516230;

    BEGIN
    END.
  }
}

