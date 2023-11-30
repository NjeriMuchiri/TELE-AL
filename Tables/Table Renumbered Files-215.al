OBJECT table 17336 MPESA Application Details
{
  OBJECT-PROPERTIES
  {
    Date=04/14/16;
    Time=10:18:06 AM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Application No      ;Code30        ;TableRelation="MPESA Applications";
                                                   NotBlank=Yes }
    { 2   ;   ;Account Type        ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=Debtor,Creditor;
                                                   OptionString=Customer,Vendor;
                                                   NotBlank=Yes }
    { 3   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(Vendor)) Vendor;
                                                   OnValidate=BEGIN

                                                                CASE "Account Type" OF
                                                                  "Account Type"::Customer:
                                                                    BEGIN
                                                                      Cust.GET("Account No.");
                                                                      Description := Cust.Name;
                                                                    END;
                                                                  "Account Type"::Vendor:
                                                                    BEGIN
                                                                      Vend.GET("Account No.");
                                                                      Description := Vend.Name;
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
      Vend@1102756001 : Record 23;

    BEGIN
    END.
  }
}

