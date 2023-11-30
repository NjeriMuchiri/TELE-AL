OBJECT table 17218 Payroll NHIF Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/11/15;
    Time=[ 1:30:10 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Tier Code           ;Code10         }
    { 11  ;   ;NHIF Tier           ;Decimal        }
    { 12  ;   ;Amount              ;Decimal        }
    { 13  ;   ;Lower Limit         ;Decimal        }
    { 14  ;   ;Upper Limit         ;Decimal        }
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

