OBJECT table 17219 Payroll NSSF Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/11/15;
    Time=[ 1:30:31 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Tier Code           ;Code10         }
    { 11  ;   ;Earnings            ;Decimal        }
    { 12  ;   ;Pensionable Earnings;Decimal        }
    { 13  ;   ;Tier 1 earnings     ;Decimal        }
    { 14  ;   ;Tier 1 Employee Deduction;Decimal   }
    { 15  ;   ;Tier 1 Employer Contribution;Decimal }
    { 16  ;   ;Tier 2 earnings     ;Decimal        }
    { 17  ;   ;Tier 2 Employee Deduction;Decimal   }
    { 18  ;   ;Tier 2 Employer Contribution;Decimal }
    { 19  ;   ;Lower Limit         ;Decimal        }
    { 20  ;   ;Upper Limit         ;Decimal        }
  }
  KEYS
  {
    {    ;Tier Code                               ;Clustered=Yes }
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

