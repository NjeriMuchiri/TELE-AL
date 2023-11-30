OBJECT table 20466 Virtual Member Reg Images
{
  OBJECT-PROPERTIES
  {
    Date=10/27/20;
    Time=[ 1:22:18 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Image Entry Number  ;Text50         }
    { 2   ;   ;Registration Entry Number;Text50    }
    { 3   ;   ;Image Path          ;Text250        }
    { 4   ;   ;Picture             ;BLOB          ;SubType=Bitmap }
    { 5   ;   ;Type                ;Text30         }
  }
  KEYS
  {
    {    ;Image Entry Number,Registration Entry Number;
                                                   Clustered=Yes }
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

