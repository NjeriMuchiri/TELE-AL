OBJECT table 50049 Purchase Quote Params
{
  OBJECT-PROPERTIES
  {
    Date=09/08/16;
    Time=11:14:03 AM;
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=Quotation Request,Open Tender,Restricted Tender;
                                                   OptionString=Quotation Request,Open Tender,Restricted Tender }
    { 2   ;   ;Document No.        ;Code20         }
    { 3   ;   ;Specification       ;Code20        ;TableRelation="Quote Specifications".Code;
                                                   OnValidate=BEGIN
                                                                Spec.RESET;
                                                                Spec.SETRANGE(Spec.Code,Specification);
                                                                IF Spec.FINDFIRST THEN
                                                                  BEGIN
                                                                    Description:=Spec.Description;
                                                                  END;
                                                              END;
                                                               }
    { 4   ;   ;Description         ;Text60         }
    { 5   ;   ;Line No.            ;Integer       ;AutoIncrement=No }
    { 6   ;   ;Value               ;Decimal        }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Specification,Line No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Spec@1102756000 : Record 51516067;

    BEGIN
    END.
  }
}

