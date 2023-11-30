OBJECT table 17229 Members Next Kin Details
{
  OBJECT-PROPERTIES
  {
    Date=03/10/22;
    Time=[ 2:42:16 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Captured By":=USERID;
             END;

    OnModify=BEGIN
               "Captured By":=USERID;
             END;

  }
  FIELDS
  {
    { 2   ;   ;Name                ;Text50        ;OnValidate=BEGIN
                                                                Name:=UPPERCASE(Name);
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Relationship        ;Text30        ;TableRelation="Relationship Types" }
    { 4   ;   ;Beneficiary         ;Boolean        }
    { 5   ;   ;Date of Birth       ;Date           }
    { 6   ;   ;Address             ;Text150        }
    { 7   ;   ;Telephone           ;Code20         }
    { 8   ;   ;Fax                 ;Code10         }
    { 9   ;   ;Email               ;Text30         }
    { 10  ;   ;Account No          ;Code20        ;TableRelation="Members Register".No. }
    { 11  ;   ;ID No.              ;Code20         }
    { 12  ;   ;%Allocation         ;Decimal        }
    { 13  ;   ;New Upload          ;Boolean        }
    { 14  ;   ;Type                ;Option        ;OptionCaptionML=ENU=Nominee,Spouse,Children;
                                                   OptionString=Next of Kin,Spouse,Benevolent Beneficiary }
    { 15  ;   ;test                ;Text30         }
    { 16  ;   ;Captured By         ;Code80         }
  }
  KEYS
  {
    {    ;Account No,Name,Type                    ;Clustered=Yes }
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

