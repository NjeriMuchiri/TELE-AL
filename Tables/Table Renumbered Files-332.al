OBJECT table 20477 Property No Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/18/15;
    Time=[ 8:18:28 AM];
    Modified=Yes;
    Version List=Project ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Project Code        ;Code20        ;TableRelation="Fixed Asset".No. WHERE (Project Asset=CONST(Yes)) }
    { 11  ;   ;Property Type       ;Code20        ;TableRelation="Property Sizes".Code }
    { 12  ;   ;NoPart              ;Code10         }
    { 13  ;   ;Starting Date       ;Date           }
    { 14  ;   ;Starting No         ;Code5          }
    { 15  ;   ;Last No Used        ;Code5          }
    { 16  ;   ;Increment By        ;Decimal        }
  }
  KEYS
  {
    {    ;Project Code,Property Type              ;Clustered=Yes }
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

