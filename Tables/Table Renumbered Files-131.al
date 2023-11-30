OBJECT table 17249 Loan Collateral Set-up
{
  OBJECT-PROPERTIES
  {
    Date=04/09/21;
    Time=[ 4:31:42 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516285;
    DrillDownPageID=Page51516285;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnValidate=BEGIN
                                                                {IF LoanApplications.GET(Code) THEN
                                                                Category:=LoanApplications."Loan Product Type";    }
                                                              END;

                                                   NotBlank=Yes }
    { 2   ;   ;Type                ;Option        ;OptionCaptionML=ENU=" ,Shares,Deposits,Collateral,Fixed Deposit";
                                                   OptionString=[ ,Shares,Deposits,Collateral,Fixed Deposit];
                                                   NotBlank=Yes }
    { 3   ;   ;Security Description;Text50         }
    { 5   ;   ;Category            ;Option        ;OptionCaptionML=ENU=" ,Cash,Government Securities,Corporate Bonds,Equity,Mortgage Securities,Fixed Deposit";
                                                   OptionString=[ ,Cash,Government Securities,Corporate Bonds,Equity,Mortgage Securities,Fixed Deposit] }
    { 6   ;   ;Collateral Multiplier;Decimal      ;OnValidate=BEGIN
                                                                //"Guarantee Value":="Collateral Multiplier"*0.7;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Code,Type,Security Description          ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LoanApplications@1000000000 : Record 51516230;

    BEGIN
    END.
  }
}

