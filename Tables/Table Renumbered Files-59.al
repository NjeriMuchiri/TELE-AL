OBJECT table 50078 HR Salary Notch
{
  OBJECT-PROPERTIES
  {
    Date=02/01/19;
    Time=11:30:54 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55533;
    DrillDownPageID=Page55533;
  }
  FIELDS
  {
    { 1   ;   ;Salary Grade        ;Code20        ;TableRelation="prPayroll Periods"."Period Month";
                                                   NotBlank=Yes }
    { 2   ;   ;Salary Notch        ;Code20        ;NotBlank=Yes }
    { 3   ;   ;Description         ;Text100        }
    { 4   ;   ;Salary Amount       ;Decimal       ;OnValidate=BEGIN
                                                                "Annual Salary Amount":="Salary Amount"*12;
                                                              END;
                                                               }
    { 5   ;   ;Hourly Rate         ;Decimal        }
    { 6   ;   ;Annual Salary Amount;Decimal       ;OnValidate=BEGIN
                                                                IF "Annual Salary Amount">0 THEN
                                                                "Salary Amount":="Annual Salary Amount"/12;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Salary Grade,Salary Notch               ;Clustered=Yes }
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

