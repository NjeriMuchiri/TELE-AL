OBJECT table 17226 Member App Signatories
{
  OBJECT-PROPERTIES
  {
    Date=01/06/16;
    Time=[ 1:41:44 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Account No          ;Code20        ;TableRelation="Membership Applications".No.;
                                                   NotBlank=Yes }
    { 2   ;   ;Names               ;Text50        ;NotBlank=Yes }
    { 3   ;   ;Date Of Birth       ;Date           }
    { 4   ;   ;Staff/Payroll       ;Code20         }
    { 5   ;   ;ID No.              ;Code50         }
    { 6   ;   ;Signatory           ;Boolean        }
    { 7   ;   ;Must Sign           ;Boolean        }
    { 8   ;   ;Must be Present     ;Boolean        }
    { 9   ;   ;Picture             ;BLOB          ;CaptionML=ENU=Picture;
                                                   SubType=Bitmap }
    { 10  ;   ;Signature           ;BLOB          ;CaptionML=ENU=Signature;
                                                   SubType=Bitmap }
    { 11  ;   ;Expiry Date         ;Date           }
    { 12  ;   ;BOSA No.            ;Code30        ;TableRelation="Members Register" }
    { 13  ;   ;Email Address       ;Text50         }
  }
  KEYS
  {
    {    ;Account No,Names                        ;Clustered=Yes }
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

