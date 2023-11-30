OBJECT table 17237 Loan Collateral Details
{
  OBJECT-PROPERTIES
  {
    Date=04/09/21;
    Time=[ 4:44:48 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516248;
    DrillDownPageID=Page51516248;
  }
  FIELDS
  {
    { 1   ;   ;Loan No             ;Code20        ;TableRelation="Loans Register"."Loan  No.";
                                                   OnValidate=BEGIN
                                                                IF LoanApplications.GET("Loan No") THEN
                                                                "Loan Type":=LoanApplications."Loan Product Type";
                                                              END;

                                                   NotBlank=Yes }
    { 2   ;   ;Type                ;Option        ;OptionCaptionML=ENU=" ,Shares,Deposits,Collateral,Fixed Deposit";
                                                   OptionString=[ ,Shares,Deposits,Collateral,Fixed Deposit];
                                                   NotBlank=Yes }
    { 3   ;   ;Security Details    ;Text150        }
    { 4   ;   ;Remarks             ;Text250        }
    { 5   ;   ;Loan Type           ;Code20        ;TableRelation=Table50005.Field3 }
    { 6   ;   ;Value               ;Decimal       ;OnValidate=BEGIN
                                                                //"Guarantee Value":=Value*0.7;
                                                                "Guarantee Value":=Value*"Collateral Multiplier";
                                                                IF Type=Type::"Fixed Deposit" THEN
                                                                ERROR('The cannot change the value for fixed deposit');
                                                              END;
                                                               }
    { 7   ;   ;Guarantee Value     ;Decimal       ;Editable=No }
    { 8   ;   ;Code                ;Code20        ;TableRelation="Loan Collateral Set-up".Code;
                                                   OnValidate=BEGIN
                                                                //IF SecSetup.GET(Code) THEN BEGIN
                                                                SecSetup.RESET;
                                                                SecSetup.SETRANGE(SecSetup.Code,Code);
                                                                IF SecSetup.FIND('-') THEN BEGIN

                                                                  Type:=SecSetup.Type;
                                                                  "Security Details":=SecSetup."Security Description";
                                                                  "Collateral Multiplier":=SecSetup."Collateral Multiplier";
                                                                  "Guarantee Value":=Value*"Collateral Multiplier";
                                                                  Category:=SecSetup.Category;

                                                                END;
                                                                //END;
                                                              END;
                                                               }
    { 9   ;   ;Category            ;Option        ;OptionCaptionML=ENU=" ,Cash,Government Securities,Corporate Bonds,Equity,Morgage Securities";
                                                   OptionString=[ ,Cash,Government Securities,Corporate Bonds,Equity,Morgage Securities] }
    { 10  ;   ;Collateral Multiplier;Decimal      ;OnValidate=BEGIN
                                                                "Guarantee Value":="Collateral Multiplier"*Value;
                                                              END;
                                                               }
    { 11  ;   ;View Document       ;Code20        ;OnValidate=BEGIN
                                                                HYPERLINK('C:\SAMPLIR.DOC');
                                                              END;
                                                               }
    { 12  ;   ;Assesment Done      ;Boolean        }
    { 13  ;   ;Account No          ;Code20        ;TableRelation=Vendor.No. WHERE (Vendor Posting Group=CONST(FIXED));
                                                   OnValidate=BEGIN
                                                                IF Vendor.GET("Account No") THEN BEGIN
                                                                Vendor.CALCFIELDS(Vendor."Balance (LCY)");
                                                                  Value:=Vendor."Balance (LCY)";
                                                                END;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Loan No,Type,Security Details,Code      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LoanApplications@1000000000 : Record 51516230;
      SecSetup@1102755000 : Record 51516245;
      Vendor@1102755001 : Record 23;

    BEGIN
    END.
  }
}

