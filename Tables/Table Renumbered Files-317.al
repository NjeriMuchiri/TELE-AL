OBJECT table 20461 Mbanking Application Details
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:10:03 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Application No      ;Code30        ;NotBlank=Yes }
    { 2   ;   ;Account Type        ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=,Creditor;
                                                   OptionString=,Creditor;
                                                   NotBlank=Yes }
    { 3   ;   ;Account No.         ;Code20        ;TableRelation=Vendor;
                                                   OnValidate=BEGIN

                                                                 MpesaApplications.RESET;
                                                                 MpesaApplications.SETRANGE(MpesaApplications.No,"Application No");
                                                                 IF MpesaApplications.FIND('-') THEN BEGIN

                                                                   IF MpesaApplications."Account No" <> "Account No." THEN
                                                                   BEGIN

                                                                     ERROR('Account Not For Selected Member');

                                                                   END;

                                                                 END;

                                                                CASE "Account Type" OF
                                                                  "Account Type"::"0":
                                                                    BEGIN
                                                                      Cust.GET("Account No.");
                                                                      Description := Cust.Name;
                                                                    END;
                                                                  "Account Type"::Creditor:
                                                                    BEGIN
                                                                     Cust.GET("Account No.");
                                                                      Description := Cust.Name;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Account No.;
                                                   NotBlank=Yes }
    { 4   ;   ;Description         ;Text50        ;CaptionML=ENU=Description }
  }
  KEYS
  {
    {    ;Application No,Account Type,Account No. ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Cust@1102756000 : Record 51516223;
      MpesaApplications@1000 : Record 51516703;

    BEGIN
    END.
  }
}

