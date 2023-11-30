OBJECT table 50024 Bank Stmt Import Buffer
{
  OBJECT-PROPERTIES
  {
    Date=05/25/15;
    Time=[ 1:21:14 PM];
    Modified=Yes;
    Version List=SureStep Members Module v1.0;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Transaction Date    ;Date           }
    { 11  ;   ;Description         ;Text50         }
    { 12  ;   ;Check/Slip Number   ;Code50         }
    { 13  ;   ;Amount              ;Decimal        }
  }
  KEYS
  {
    {    ;Check/Slip Number                       ;Clustered=Yes }
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

