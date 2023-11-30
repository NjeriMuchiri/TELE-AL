OBJECT table 17291 Checkoff Distributed MrtLatest
{
  OBJECT-PROPERTIES
  {
    Date=01/23/18;
    Time=[ 4:13:52 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Employer Code       ;Code50        ;TableRelation="Sacco Employers" }
    { 2   ;   ;Loan Product Code   ;Code50        ;TableRelation="Loan Products Setup".Code }
    { 3   ;   ;Check off Code      ;Code50         }
    { 4   ;   ;check Interest      ;Boolean        }
  }
  KEYS
  {
    {    ;Employer Code,Loan Product Code,Check off Code;
                                                   Clustered=Yes }
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

