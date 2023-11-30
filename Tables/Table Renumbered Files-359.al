OBJECT table 17354 Debt Change Lines
{
  OBJECT-PROPERTIES
  {
    Date=09/23/22;
    Time=12:31:22 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer        }
    { 2   ;   ;Loan Number         ;Code20        ;Editable=No }
    { 3   ;   ;Debt Collector      ;Text60        ;Editable=No }
    { 4   ;   ;Outstanding Balance ;Decimal       ;Editable=No }
    { 5   ;   ;Outstanding Interest;Decimal       ;Editable=No }
    { 6   ;   ;Selected            ;Boolean        }
    { 7   ;   ;Change No           ;Code20         }
    { 8   ;   ;Client Code         ;Code20        ;Editable=No }
    { 9   ;   ;CLient Name         ;Text150       ;Editable=No }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
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

