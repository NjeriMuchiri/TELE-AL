OBJECT table 20470 Mpesa Rec. Header
{
  OBJECT-PROPERTIES
  {
    Date=12/15/20;
    Time=[ 5:00:21 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 2   ;   ;Start Date          ;Date           }
    { 3   ;   ;Reconciled          ;Boolean       ;Editable=No }
    { 4   ;   ;Reconciled By       ;Code50        ;Editable=No }
    { 5   ;   ;End Date            ;Date           }
    { 6   ;   ;Found               ;Boolean        }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
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

