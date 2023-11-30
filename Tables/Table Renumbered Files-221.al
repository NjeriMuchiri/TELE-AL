OBJECT table 17342 Bulk SMS Lines
{
  OBJECT-PROPERTIES
  {
    Date=10/31/16;
    Time=12:56:09 PM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;TableRelation="Bulk SMS Header".No;
                                                   NotBlank=Yes }
    { 2   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 3   ;   ;Description         ;Text100        }
  }
  KEYS
  {
    {    ;No,Code                                 ;Clustered=Yes }
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

