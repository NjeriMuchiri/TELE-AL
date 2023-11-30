OBJECT table 17279 Product Cycles
{
  OBJECT-PROPERTIES
  {
    Date=11/11/19;
    Time=[ 3:45:28 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page39004396;
    DrillDownPageID=Page39004396;
  }
  FIELDS
  {
    { 1   ;   ;Product Code        ;Code20        ;TableRelation="Loan Products Setup".Code;
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

