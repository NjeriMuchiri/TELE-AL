OBJECT table 17310 FD Interest Calculation Criter
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 4:04:40 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code30         }
    { 2   ;   ;Minimum Amount      ;Decimal       ;NotBlank=Yes }
    { 3   ;   ;Maximum Amount      ;Decimal       ;NotBlank=Yes }
    { 4   ;   ;Interest Rate       ;Decimal        }
  }
  KEYS
  {
    {    ;Code,Minimum Amount                     ;Clustered=Yes }
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

