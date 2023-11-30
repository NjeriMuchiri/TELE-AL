OBJECT table 17316 Bank Branch
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 4:15:38 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Bank No             ;Code20        ;TableRelation="Bank Account".No.;
                                                   NotBlank=Yes }
    { 2   ;   ;Branch No           ;Code20        ;NotBlank=Yes }
    { 3   ;   ;Branch Name         ;Text100        }
    { 4   ;   ;Telephone No        ;Text50         }
    { 5   ;   ;Postal Address      ;Text50         }
    { 6   ;   ;Physical Address    ;Text50         }
  }
  KEYS
  {
    {    ;Bank No,Branch No                       ;Clustered=Yes }
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

