OBJECT table 50031 Coop Reconcillation trans.
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=[ 3:36:51 PM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    LookupPageID=Page170041;
    DrillDownPageID=Page170041;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code10         }
    { 2   ;   ;Member Account      ;Code30         }
    { 3   ;   ;Document No.        ;Code30         }
    { 4   ;   ;Transaction Date    ;Date           }
    { 5   ;   ;ATM No.             ;Code30         }
    { 6   ;   ;Description 1       ;Code50         }
    { 7   ;   ;Amount              ;Decimal        }
    { 8   ;   ;Reconcilled         ;Boolean        }
    { 9   ;   ;Reconcillation Header;Code20        }
  }
  KEYS
  {
    {    ;Document No.                            ;Clustered=Yes }
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

