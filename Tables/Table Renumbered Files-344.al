OBJECT table 20489 Questionnaire
{
  OBJECT-PROPERTIES
  {
    Date=06/19/18;
    Time=12:58:05 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry               ;Integer        }
    { 2   ;   ;ServedBy            ;Text30         }
    { 3   ;   ;ReasonForVisit      ;Text30         }
    { 4   ;   ;Member              ;Code30         }
    { 5   ;   ;Time                ;Text30         }
    { 6   ;   ;MostImpressedwith   ;Text30         }
    { 7   ;   ;LeastImpressedWIth  ;Text30         }
    { 8   ;   ;Suggestions         ;Text30         }
    { 9   ;   ;Accounts            ;Option        ;OptionString=Excellent,Good,Average,Poor }
    { 10  ;   ;Customercare        ;Option        ;OptionString=Excellent,Good,Average,Poor }
    { 11  ;   ;OfficeAtmosphere    ;Option        ;OptionString=Excellent,Good,Average,Poor }
  }
  KEYS
  {
    {    ;Entry                                   ;Clustered=Yes }
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

