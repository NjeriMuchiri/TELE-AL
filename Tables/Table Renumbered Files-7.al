OBJECT table 50026 Coop ATM  Setup
{
  OBJECT-PROPERTIES
  {
    Date=03/17/21;
    Time=[ 8:39:07 AM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer        }
    { 2   ;   ;Coop Commission Account;Code20     ;TableRelation="Bank Account" }
    { 3   ;   ;Coop Fee Account    ;Code20        ;TableRelation="G/L Account" }
    { 4   ;   ;Coop Bank Account   ;Code20        ;TableRelation="Bank Account" }
    { 5   ;   ;Daily Withdrawal Limit;Decimal      }
    { 6   ;   ;Transactional Withdrawal Limit;Decimal }
    { 7   ;   ;Institution Code    ;Text30         }
    { 8   ;   ;Institutio Name     ;Text50         }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
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

