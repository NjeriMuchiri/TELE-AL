OBJECT table 20440 HR Applicant Hobbies
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=10:17:03 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Job Application No  ;Code20        ;TableRelation="HR Job Applications"."Application No" }
    { 2   ;   ;Hobby               ;Text200        }
  }
  KEYS
  {
    {    ;Job Application No,Hobby                ;Clustered=Yes }
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

