OBJECT table 17236 Loan Appraisal Salary Details
{
  OBJECT-PROPERTIES
  {
    Date=04/08/21;
    Time=[ 3:04:01 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Client Code         ;Code20         }
    { 2   ;   ;Code                ;Code20        ;TableRelation="Appraisal Salary Set-up".Code;
                                                   OnValidate=BEGIN
                                                                IF "SalarySet-up".GET(Code) THEN BEGIN
                                                                Description:="SalarySet-up".Description;
                                                                Type:="SalarySet-up".Type;
                                                                Statutory:="SalarySet-up"."Statutory Ded";
                                                                "Statutory Amount":="SalarySet-up"."Statutory Amount";
                                                                Amount:="Statutory Amount";
                                                                "Long Term Deduction":="SalarySet-up"."Long Term Deductions";

                                                                END;

                                                                IF "SalarySet-up".GET(Code) THEN BEGIN
                                                                IF "SalarySet-up"."Statutory(%)"<>0 THEN BEGIN
                                                                IF Code='001' THEN
                                                                Amount:="SalarySet-up"."Statutory(%)"*  Amount;

                                                                END;
                                                                END;
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text30         }
    { 4   ;   ;Type                ;Option        ;OptionCaptionML=ENU=" ,Earnings,Deductions,Basic,Other Allowances";
                                                   OptionString=[ ,Earnings,Deductions,Basic,Other Allowances] }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Loan No             ;Code20        ;TableRelation="Loans Register" }
    { 7   ;   ;Statutory           ;Boolean        }
    { 8   ;   ;Statutory Amount    ;Decimal        }
    { 9   ;   ;Long Term Deduction ;Boolean        }
    { 10  ;   ;Basic               ;Boolean        }
    { 11  ;   ;Basic1              ;Integer        }
    { 12  ;   ;Appraisal Type      ;Option        ;OptionCaptionML=ENU=" ,Balance Sheet,Salary,Rental,Farming";
                                                   OptionString=[ ,Balance Sheet,Salary,Rental,Farming] }
    { 13  ;   ;A third             ;Decimal        }
    { 14  ;   ;Two Thirds          ;Decimal        }
    { 62010;  ;Salary Type         ;Option        ;OptionCaptionML=ENU=" ,Salary,Pension,Delegate Allowance,Interest";
                                                   OptionString=[ ,Salary,Pension,Delegate Allowance,Interest] }
  }
  KEYS
  {
    {    ;Loan No,Client Code,Code                ;Clustered=Yes }
    {    ;Code,Client Code,Type                   ;SumIndexFields=Amount }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      "SalarySet-up"@1102755000 : Record 51516255;

    BEGIN
    END.
  }
}

