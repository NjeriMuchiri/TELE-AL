OBJECT table 17246 Loan Product Charges
{
  OBJECT-PROPERTIES
  {
    Date=05/05/23;
    Time=12:59:32 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Product Code        ;Code20        ;TableRelation="Loan Products Setup".Code;
                                                   NotBlank=Yes }
    { 2   ;   ;Code                ;Code20        ;TableRelation="Loan Charges".Code;
                                                   OnValidate=BEGIN
                                                                IF Charges.GET(Code) THEN BEGIN
                                                                Description:=Charges.Description;
                                                                Amount:=Charges.Amount;
                                                                Percentage:=Charges.Percentage;
                                                                "G/L Account":=Charges."G/L Account";
                                                                "Use Perc":=Charges."Use Perc";
                                                                "Upfront Interest":=Charges."Upfront Interest";
                                                                END;
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text30         }
    { 4   ;   ;Amount              ;Decimal        }
    { 5   ;   ;Percentage          ;Decimal        }
    { 6   ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account".No. }
    { 7   ;   ;Use Perc            ;Boolean        }
    { 8   ;   ;Use Band            ;Boolean       ;OnValidate=BEGIN
                                                                IF "Use Band" THEN
                                                                 Amount:=0; Percentage:=0; "Use Perc":=FALSE;
                                                              END;
                                                               }
    { 9   ;   ;Account Type        ;Code100       ;TableRelation="Account Types-Saving Products".Code;
                                                   OnValidate=BEGIN
                                                                IF "Account Type"<>'' THEN BEGIN
                                                                  "G/L Account":='';
                                                                  "Retain Deposits":=FALSE;
                                                                  "Retain ShareCapital":=FALSE;
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 10  ;   ;Retain Deposits     ;Boolean       ;OnValidate=BEGIN
                                                                IF "Retain Deposits"=TRUE THEN BEGIN
                                                                  "G/L Account":='';
                                                                  "Account Type":='';
                                                                  "Retain ShareCapital":=FALSE;
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 11  ;   ;Retain ShareCapital ;Boolean       ;OnValidate=BEGIN
                                                                IF "Retain ShareCapital"=TRUE THEN BEGIN
                                                                  "G/L Account":='';
                                                                  "Retain Deposits":=FALSE;
                                                                  "Account Type":='';

                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 12  ;   ;Upfront Interest    ;Boolean        }
  }
  KEYS
  {
    {    ;Product Code,Code                       ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Charges@1000000000 : Record 51516241;
      loantype@1102755000 : Record 51516240;

    BEGIN
    END.
  }
}

