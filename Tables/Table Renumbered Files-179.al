OBJECT table 17297 Accounts Next Of Kin Details
{
  OBJECT-PROPERTIES
  {
    Date=11/18/19;
    Time=11:57:27 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 2   ;   ;Name                ;Text50        ;NotBlank=Yes }
    { 3   ;   ;Relationship        ;Text30        ;TableRelation=Members-Group."Account No." }
    { 4   ;   ;Beneficiary         ;Boolean        }
    { 5   ;   ;Date of Birth       ;Date           }
    { 6   ;   ;Address             ;Text30         }
    { 7   ;   ;Telephone           ;Code20         }
    { 8   ;   ;Fax                 ;Code10         }
    { 9   ;   ;Email               ;Text30         }
    { 10  ;   ;Account No          ;Code20        ;TableRelation=Vendor.No. }
    { 11  ;   ;ID No.              ;Code20         }
    { 12  ;   ;%Allocation         ;Decimal        }
    { 13  ;   ;Total Allocation    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Accounts Next Of Kin Details".%Allocation WHERE (Account No=FIELD(Account No))) }
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
    VAR
      TOTALALLO@1102755000 : Decimal;
      NextKin@1102755001 : Record 51516291;

    BEGIN
    END.
  }
}

