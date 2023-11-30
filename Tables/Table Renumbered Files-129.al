OBJECT table 17247 Loan Product Cycles
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 5:38:38 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Product Code        ;Code20        ;TableRelation="Share Capital Recoveries"."Entry No.";
                                                   NotBlank=Yes }
    { 2   ;   ;Cycle               ;Integer       ;NotBlank=Yes }
    { 3   ;   ;Max. Installments   ;Integer        }
    { 4   ;   ;Max. Amount         ;Decimal        }
  }
  KEYS
  {
    {    ;Product Code,Cycle                      ;Clustered=Yes }
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

