OBJECT table 20404 Sms Lines
{
  OBJECT-PROPERTIES
  {
    Date=10/23/20;
    Time=[ 2:23:17 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=No }
    { 2   ;   ;Mobile No           ;Code20         }
    { 3   ;   ;Primary Key         ;Integer       ;AutoIncrement=Yes }
    { 4   ;   ;Message To Send     ;Text250        }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
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

