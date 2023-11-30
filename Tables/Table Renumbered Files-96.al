OBJECT table 17214 HR Applicant Referees
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=10:16:24 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Job Application No  ;Code20        ;TableRelation="HR Job Applications"."Application No" }
    { 2   ;   ;Names               ;Text200        }
    { 3   ;   ;Designation         ;Text100        }
    { 4   ;   ;Institution         ;Text100        }
    { 5   ;   ;Address             ;Text200        }
    { 6   ;   ;Telephone No        ;Text100        }
    { 7   ;   ;E-Mail              ;Text100        }
    { 8   ;   ;Employee No         ;Code30         }
  }
  KEYS
  {
    {    ;Job Application No,Names                ;Clustered=Yes }
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

