OBJECT table 17295 Accounts App Kin Details
{
  OBJECT-PROPERTIES
  {
    Date=06/22/16;
    Time=12:25:40 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 2   ;   ;Name                ;Text50        ;NotBlank=Yes }
    { 3   ;   ;Relationship        ;Text30        ;TableRelation="Relationship Types" }
    { 4   ;   ;Beneficiary         ;Boolean        }
    { 5   ;   ;Date of Birth       ;Date           }
    { 6   ;   ;Address             ;Text30         }
    { 7   ;   ;Telephone           ;Code20         }
    { 8   ;   ;Fax                 ;Code10         }
    { 9   ;   ;Email               ;Text30         }
    { 10  ;   ;Account No          ;Code20        ;TableRelation="Accounts Applications Details".No. }
    { 11  ;   ;ID No.              ;Code20         }
    { 12  ;   ;%Allocation         ;Decimal       ;OnValidate=BEGIN
                                                                 CALCFIELDS("Total Allocation");
                                                                 IF "%Allocation">"Maximun Allocation %" THEN
                                                                   ERROR(' Total allocation should be equal to 100 %');
                                                              END;
                                                               }
    { 13  ;   ;Total Allocation    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Accounts App Kin Details".%Allocation WHERE (Account No=FIELD(Account No))) }
    { 14  ;   ;Maximun Allocation %;Decimal        }
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

