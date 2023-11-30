OBJECT table 20406 Tariff Codes
{
  OBJECT-PROPERTIES
  {
    Date=08/21/16;
    Time=10:04:29 PM;
    Modified=Yes;
    Version List=FUNDS;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
                 PaymentLine.RESET;
                 PaymentLine.SETRANGE(PaymentLine."VAT Code",Code);
                 IF PaymentLine.FIND('-') THEN
                    ERROR('You cannot delete the %1 Code its already used',Type);

                 PaymentLine.RESET;
                 PaymentLine.SETRANGE(PaymentLine."Withholding Tax Code",Code);
                 IF PaymentLine.FIND('-') THEN
                    ERROR('You cannot delete the %1 Code its already used',Type);
             END;

  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Percentage          ;Decimal        }
    { 4   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account".No. WHERE (Direct Posting=CONST(Yes)) ELSE IF (Account Type=CONST(Vendor)) Vendor.No. }
    { 5   ;   ;Type                ;Option        ;OptionString=[ ,W/Tax,VAT,Excise,Others,Retention] }
    { 12  ;   ;Account Type        ;Option        ;OnValidate=VAR
                                                                PayLines@1102756000 : Record 39004406;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PaymentLine@1102755000 : Record 51516001;

    BEGIN
    END.
  }
}

