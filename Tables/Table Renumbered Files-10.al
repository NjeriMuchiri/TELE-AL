OBJECT table 50029 Coop ATM Charges
{
  OBJECT-PROPERTIES
  {
    Date=04/17/21;
    Time=[ 4:30:57 PM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10         }
    { 2   ;   ;Minimum             ;Decimal        }
    { 3   ;   ;Maximum             ;Decimal        }
    { 4   ;   ;Bank Commission     ;Decimal        }
    { 5   ;   ;Sacco Commission    ;Decimal        }
    { 6   ;   ;Terminal            ;Code10         }
    { 7   ;   ;Channel             ;Code10         }
    { 8   ;   ;Sacco Per Every     ;Decimal        }
    { 9   ;   ;Daily Limit         ;Decimal        }
  }
  KEYS
  {
    {    ;Code,Terminal,Channel,Minimum           ;Clustered=Yes }
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

