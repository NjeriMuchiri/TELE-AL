OBJECT table 20413 Interest Rates
{
  OBJECT-PROPERTIES
  {
    Date=03/04/20;
    Time=[ 1:04:44 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 3   ;   ;Charge Amount       ;Decimal        }
    { 5   ;   ;Percentage of Amount;Decimal       ;OnValidate=BEGIN
                                                                IF Percentage>100 THEN
                                                                ERROR('You cannot exceed 100. Please enter a valid number.');
                                                              END;
                                                               }
    { 6   ;   ;Use Percentage      ;Boolean        }
    { 7   ;   ;GL Account          ;Code20        ;TableRelation="G/L Account" }
    { 8   ;   ;Minimum             ;Decimal       ;OnValidate=BEGIN
                                                                IF Maximum<>0 THEN BEGIN
                                                                IF Maximum<Minimum THEN
                                                                ERROR('The maximum amount cannot be less than the minimum amount.');
                                                                END;
                                                              END;
                                                               }
    { 9   ;   ;Maximum             ;Decimal       ;OnValidate=BEGIN
                                                                IF Minimum<>0 THEN BEGIN
                                                                IF Minimum>Maximum THEN
                                                                ERROR('The minimum amount cannot be more than the maximum amount.');
                                                                END;
                                                              END;
                                                               }
    { 10  ;   ;Code                ;Code20         }
    { 11  ;   ;Description         ;Text150        }
    { 12  ;   ;Percentage          ;Decimal        }
    { 13  ;   ;Sacco Amount        ;Decimal        }
    { 14  ;   ;Bank Account        ;Code20         }
    { 15  ;   ;Charge Type         ;Option        ;OptionCaptionML=ENU=" ,Loans,Special Advance,Discounting,Standing Order Fee,Failed Standing Order Fee,External Standing Order Fee,Cheque Book,Cheque Processing";
                                                   OptionString=[ ,Loans,Special Advance,Discounting,Standing Order Fee,Failed Standing Order Fee,External Standing Order Fee,Cheque Book,Cheque Processing] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      TransactionCharges@1120054000 : Record 51516442;

    BEGIN
    END.
  }
}

