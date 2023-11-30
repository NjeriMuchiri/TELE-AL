OBJECT table 20407 Micro Profitability Analysis
{
  OBJECT-PROPERTIES
  {
    Date=08/02/16;
    Time=12:40:28 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;TableRelation="Profitability Set up-Micro".Code WHERE (Type=CONST(Profitability));
                                                   OnValidate=BEGIN

                                                                ProfitSetUp.RESET;
                                                                ProfitSetUp.SETRANGE(ProfitSetUp.Code,Code);
                                                                IF ProfitSetUp.FINDFIRST THEN BEGIN
                                                                Description:=ProfitSetUp.Description ;
                                                                "Code Type":=ProfitSetUp."Code Type";
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Client Code         ;Code20         }
    { 3   ;   ;Average Monthly Sales;Decimal       }
    { 4   ;   ;Average Monthly Purchase;Decimal    }
    { 5   ;   ;Gross Profit        ;Decimal        }
    { 6   ;   ;Loan No.            ;Code10        ;TableRelation="Loans Register" }
    { 7   ;   ;Amount              ;Decimal        }
    { 8   ;   ;Description         ;Text80        ;Editable=No }
    { 9   ;   ;Code Type           ;Option        ;OptionCaptionML=ENU=" ,Purchase,Sales";
                                                   OptionString=[ ,Purchase,Sales];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Loan No.,Client Code,Code               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ProfitSetUp@1000000000 : Record 51516432;

    BEGIN
    END.
  }
}

