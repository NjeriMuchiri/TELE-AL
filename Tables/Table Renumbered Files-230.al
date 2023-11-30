OBJECT table 20371 ISO-Defined Data Elements
{
  OBJECT-PROPERTIES
  {
    Date=10/27/16;
    Time=12:21:11 PM;
    Modified=Yes;
    Version List=SURESTEP ATM;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Data Element        ;Integer       ;AutoIncrement=Yes;
                                                   Editable=Yes }
    { 2   ;   ;Type                ;Text50        ;Editable=Yes }
    { 3   ;   ;Usage               ;Text250       ;Editable=Yes }
    { 4   ;   ;Length              ;Integer       ;Editable=Yes }
    { 5   ;   ;Variable Field      ;Integer       ;Editable=Yes }
    { 6   ;   ;Variable Field Length;Integer      ;Editable=Yes }
  }
  KEYS
  {
    {    ;Data Element                            ;Clustered=Yes }
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

