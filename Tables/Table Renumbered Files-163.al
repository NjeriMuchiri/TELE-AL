OBJECT table 17281 Boosting Shares
{
  OBJECT-PROPERTIES
  {
    Date=04/06/16;
    Time=[ 3:43:54 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page39004250;
    DrillDownPageID=Page39004250;
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20        ;TableRelation="Loans Register"."Loan  No." }
    { 2   ;   ;Client Code         ;Code20         }
    { 3   ;   ;Boosting Amount     ;Decimal       ;OnValidate=BEGIN
                                                                Commision:=("Boosting Amount"*0.1);
                                                              END;
                                                               }
    { 4   ;   ;Commision           ;Decimal       ;Editable=No }
  }
  KEYS
  {
    {    ;Loan No.,Client Code                    ;SumIndexFields=Boosting Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Boosting Amount,Commision,Field5,Field6,Field7,Field8,Field9,Field10,Field11,Field13 }
  }
  CODE
  {
    VAR
      Loans@1102760000 : Record 51516230;
      Loantypes@1000000000 : Record 51516240;
      Interest@1000000001 : Decimal;
      Cust@1102755000 : Record 51516223;

    BEGIN
    END.
  }
}

