OBJECT table 20456 Sky PIN Change Log
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=11:46:04 AM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Date                ;DateTime       }
    { 2   ;   ;Account No.         ;Code20         }
    { 3   ;   ;Account Name        ;Text100        }
    { 4   ;   ;Changed By          ;Code50         }
    { 5   ;   ;Old Value           ;Text100        }
    { 6   ;   ;New Value           ;Text100        }
    { 7   ;   ;Field Modified      ;Text30         }
  }
  KEYS
  {
    {    ;Date                                    ;Clustered=Yes }
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

