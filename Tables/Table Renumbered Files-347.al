OBJECT table 20492 Attachments
{
  OBJECT-PROPERTIES
  {
    Date=02/12/19;
    Time=11:35:43 AM;
    Modified=Yes;
    Version List=Web system;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry               ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Loan                ;Code20         }
    { 3   ;   ;LocaLAttacmentLink  ;Text70         }
    { 4   ;   ;PublicLink          ;Text70        ;ExtendedDatatype=URL }
    { 5   ;   ;Type                ;Code70         }
    { 6   ;   ;Name                ;Text70         }
    { 7   ;   ;DateUploaded        ;Date           }
  }
  KEYS
  {
    {    ;Entry                                   ;Clustered=Yes }
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

