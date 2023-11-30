OBJECT table 17225 Member App Next Of kin
{
  OBJECT-PROPERTIES
  {
    Date=06/27/16;
    Time=[ 1:07:42 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Account No          ;Code20        ;TableRelation="Membership Applications".No. }
    { 2   ;   ;Name                ;Text50        ;NotBlank=Yes }
    { 3   ;   ;Relationship        ;Text30        ;TableRelation="Relationship Types" }
    { 4   ;   ;Beneficiary         ;Boolean        }
    { 5   ;   ;Date of Birth       ;Date           }
    { 6   ;   ;Address             ;Text30         }
    { 7   ;   ;Telephone           ;Code20         }
    { 8   ;   ;Fax                 ;Code10         }
    { 9   ;   ;Email               ;Text30         }
    { 11  ;   ;ID No.              ;Code20         }
    { 12  ;   ;%Allocation         ;Decimal       ;OnValidate=BEGIN
                                                                 CALCFIELDS("Total Allocation");
                                                                 IF "%Allocation">"Maximun Allocation %" THEN
                                                                   ERROR(' Total allocation should be equal to 100 %');
                                                              END;
                                                               }
    { 13  ;   ;Total Allocation    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member App Next Of kin".%Allocation WHERE (Account No=FIELD(Account No))) }
    { 14  ;   ;Maximun Allocation %;Decimal        }
    { 15  ;   ;Type                ;Option        ;OptionCaptionML=ENU=Nominee,Spouse,Children;
                                                   OptionString=Next of Kin,Spouse,Benevolent Beneficiary }
  }
  KEYS
  {
    {    ;Account No,Name                         ;Clustered=Yes }
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

