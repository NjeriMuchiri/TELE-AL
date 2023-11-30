OBJECT table 20473 Mbanking Phone Nos
{
  OBJECT-PROPERTIES
  {
    Date=12/06/21;
    Time=[ 4:33:11 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Account No.         ;Code20        ;TableRelation=Vendor.No.;
                                                   OnValidate=VAR
                                                                SkyUSSDAuth@1120054000 : Record 51516709;
                                                              BEGIN
                                                                SkyUSSDAuth.RESET;
                                                                SkyUSSDAuth.SETRANGE(SkyUSSDAuth."Account No.","Account No.");
                                                                IF NOT SkyUSSDAuth.FINDFIRST THEN
                                                                  ERROR('This Member is not a Beneficiary of mobile Banking');
                                                                "Created By":=USERID;
                                                                "Created At":=CURRENTDATETIME;
                                                              END;
                                                               }
    { 2   ;   ;Phone No.           ;Code20         }
    { 3   ;   ;Operator            ;Option        ;OptionString=[ ,T-KASH,M-PESA] }
    { 4   ;   ;Created By          ;Code50         }
    { 5   ;   ;Created At          ;DateTime       }
  }
  KEYS
  {
    {    ;Account No.                             ;Clustered=Yes }
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

