OBJECT table 17315 Banks
{
  OBJECT-PROPERTIES
  {
    Date=04/03/16;
    Time=[ 4:47:09 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516317;
    DrillDownPageID=Page51516317;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Bank Name           ;Text150        }
    { 3   ;   ;Branch              ;Text150        }
    { 4   ;   ;Bank Code           ;Code20         }
  }
  KEYS
  {
    {    ;Code,Branch                             ;Clustered=Yes }
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

