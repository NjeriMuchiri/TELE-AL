OBJECT table 17290 Checkoff Distributed Matrix
{
  OBJECT-PROPERTIES
  {
    Date=08/22/18;
    Time=[ 8:33:02 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Employer Code       ;Code50        ;TableRelation="Sacco Employers" }
    { 2   ;   ;Loan Product Code   ;Code50        ;TableRelation="Loan Products Setup".Code;
                                                   OnValidate=BEGIN
                                                                LSetup.RESET;
                                                                LSetup.SETRANGE(LSetup.Code,"Loan Product Code");
                                                                IF LSetup.FIND('-') THEN
                                                                BEGIN
                                                                "Product Name":=LSetup."Product Description";
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Check off Code      ;Code50         }
    { 4   ;   ;check Interest      ;Boolean        }
    { 5   ;   ;Product Name        ;Text30         }
  }
  KEYS
  {
    {    ;Employer Code,Loan Product Code,Check off Code,Product Name;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LSetup@1120054000 : Record 51516240;

    BEGIN
    END.
  }
}

