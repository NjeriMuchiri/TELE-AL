OBJECT table 17245 Loan Charges
{
  OBJECT-PROPERTIES
  {
    Date=11/09/22;
    Time=10:20:21 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516284;
    DrillDownPageID=Page51516284;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnValidate=BEGIN
                                                                //MESSAGE('here');
                                                              END;

                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Amount              ;Decimal        }
    { 4   ;   ;Percentage          ;Decimal        }
    { 5   ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account".No. }
    { 6   ;   ;Use Perc            ;Boolean        }
    { 8   ;   ;Charge Excise       ;Boolean        }
    { 9   ;   ;Upfront Interest    ;Boolean        }
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

    BEGIN
    END.
  }
}

