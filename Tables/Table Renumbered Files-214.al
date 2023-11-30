OBJECT table 17335 MPESA Withdrawal Limits
{
  OBJECT-PROPERTIES
  {
    Date=04/14/16;
    Time=10:17:54 AM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Limit Amount        ;Decimal        }
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

