OBJECT table 17300 Account Notices
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 3:52:20 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Account Type        ;Code20        ;TableRelation=PortalUps.LaonNo;
                                                   NotBlank=Yes }
    { 2   ;   ;Code                ;Code20        ;NotBlank=No }
    { 3   ;   ;Description         ;Text100        }
    { 4   ;   ;Duration            ;DateFormula    }
    { 5   ;   ;Penalty             ;Decimal        }
    { 6   ;   ;Type                ;Option        ;OptionString=Other,Limit Withdrawal,Account Closure }
    { 7   ;   ;GL Account          ;Code20        ;TableRelation="G/L Account" }
    { 8   ;   ;Percentage Of Amount;Decimal        }
    { 9   ;   ;Use Percentage      ;Boolean        }
    { 10  ;   ;Minimum             ;Decimal        }
    { 11  ;   ;Maximum             ;Decimal        }
  }
  KEYS
  {
    {    ;Account Type,Code                       ;Clustered=Yes }
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

