OBJECT table 50045 Travel Destination
{
  OBJECT-PROPERTIES
  {
    Date=03/04/16;
    Time=12:19:35 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page55981;
    DrillDownPageID=Page55981;
  }
  FIELDS
  {
    { 1   ;   ;Destination Code    ;Code10        ;NotBlank=Yes }
    { 2   ;   ;Destination Name    ;Text50         }
    { 3   ;   ;Destination Type    ;Option        ;OptionString=Local,Foreign }
    { 4   ;   ;Currency            ;Code10        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Table51516059.Field3 WHERE (Field2=FIELD(Destination Code))) }
  }
  KEYS
  {
    {    ;Destination Code                        ;Clustered=Yes }
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

