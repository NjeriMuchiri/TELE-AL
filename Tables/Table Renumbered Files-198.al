OBJECT table 17317 Banker Cheque Register
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 4:51:58 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Banker Cheque No.   ;Code30         }
    { 2   ;   ;Issued              ;Boolean        }
    { 3   ;   ;Cancelled           ;Boolean        }
  }
  KEYS
  {
    {    ;Banker Cheque No.                       ;Clustered=Yes }
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

