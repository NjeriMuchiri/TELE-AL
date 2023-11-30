OBJECT table 17309 Fixed Deposit Type
{
  OBJECT-PROPERTIES
  {
    Date=07/23/20;
    Time=[ 4:44:35 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code30        ;NotBlank=Yes }
    { 2   ;   ;Duration            ;DateFormula    }
    { 3   ;   ;Description         ;Text50         }
    { 4   ;   ;No. of Months       ;Integer        }
    { 5   ;   ;Int Duration        ;Integer        }
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

