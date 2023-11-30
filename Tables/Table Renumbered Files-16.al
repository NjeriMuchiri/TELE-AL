OBJECT table 50035 CshMgt Approvals
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 5:07:37 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Document Type       ;Option        ;OptionString=PV,PC }
    { 3   ;   ;Document No.        ;Code20         }
    { 4   ;   ;Document Date       ;Date           }
    { 5   ;   ;Process Date        ;Date           }
    { 6   ;   ;Process Time        ;Time           }
    { 7   ;   ;Process User ID     ;Code20         }
    { 8   ;   ;Process Name        ;Code20         }
    { 9   ;   ;Process Machine     ;Text30         }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
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

