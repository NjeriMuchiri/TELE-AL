OBJECT table 17230 Member Account Signatories
{
  OBJECT-PROPERTIES
  {
    Date=01/06/16;
    Time=[ 1:46:57 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Account No          ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Names               ;Text50        ;NotBlank=Yes }
    { 3   ;   ;Date Of Birth       ;Date           }
    { 4   ;   ;Staff/Payroll       ;Code20         }
    { 5   ;   ;ID No.              ;Code50        ;OnValidate=BEGIN
                                                                CUST.RESET;
                                                                CUST.SETRANGE(CUST."ID No.","ID No.");
                                                                IF CUST.FIND('-')  THEN BEGIN
                                                                "BOSA No.":=CUST."No.";
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 6   ;   ;Signatory           ;Boolean        }
    { 7   ;   ;Must Sign           ;Boolean        }
    { 8   ;   ;Must be Present     ;Boolean        }
    { 9   ;   ;Picture             ;BLOB          ;CaptionML=ENU=Picture;
                                                   SubType=Bitmap }
    { 10  ;   ;Signature           ;BLOB          ;CaptionML=ENU=Signature;
                                                   SubType=Bitmap }
    { 11  ;   ;Expiry Date         ;Date           }
    { 12  ;   ;Sections Code       ;Code20        ;TableRelation=Table51516159.Field1 }
    { 13  ;   ;Company Code        ;Code20        ;TableRelation="Sacco Employers".Code }
    { 14  ;   ;BOSA No.            ;Code30        ;TableRelation="Members Register".No. }
    { 15  ;   ;Email Address       ;Text50         }
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
    VAR
      CUST@1102755000 : Record 51516223;

    BEGIN
    END.
  }
}

