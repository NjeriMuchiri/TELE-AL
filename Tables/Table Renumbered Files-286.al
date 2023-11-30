OBJECT table 20430 PAYE Brackets Credit
{
  OBJECT-PROPERTIES
  {
    Date=06/05/18;
    Time=12:42:00 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Tax Band            ;Code10        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Table Code          ;Code10         }
    { 4   ;   ;Lower Limit         ;Decimal        }
    { 5   ;   ;Upper Limit         ;Decimal        }
    { 6   ;   ;Amount              ;Decimal        }
    { 7   ;   ;Percentage          ;Decimal        }
    { 8   ;   ;From Date           ;Date           }
    { 9   ;   ;End Date            ;Date           }
    { 10  ;   ;Pay period          ;Date           }
    { 11  ;   ;Taxable Amount      ;Decimal        }
    { 12  ;   ;Total taxable       ;Decimal        }
    { 13  ;   ;Factor Without Housing;Decimal     ;DecimalPlaces=2: }
    { 14  ;   ;Factor With Housing ;Decimal       ;DecimalPlaces=2: }
  }
  KEYS
  {
    {    ;Tax Band                                ;Clustered=Yes }
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

