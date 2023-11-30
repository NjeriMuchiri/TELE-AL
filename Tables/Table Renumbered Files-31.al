OBJECT table 50050 Item Groups
{
  OBJECT-PROPERTIES
  {
    Date=04/07/16;
    Time=12:21:21 PM;
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               ItemCategory.SETRANGE(ItemCategory.Code);
               ItemCategory.DELETEALL;
             END;

    LookupPageID=Page51516086;
    DrillDownPageID=Page51516086;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=ENU=Code;
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=ENU=Description }
    { 4   ;   ;Def. Gen. Prod. Posting Group;Code10;
                                                   TableRelation="Gen. Product Posting Group".Code;
                                                   CaptionML=ENU=Def. Gen. Prod. Posting Group }
    { 5   ;   ;Def. Inventory Posting Group;Code10;TableRelation="Inventory Posting Group".Code;
                                                   CaptionML=ENU=Def. Inventory Posting Group }
    { 6   ;   ;Def. Tax Group Code ;Code10        ;TableRelation="Tax Group".Code;
                                                   CaptionML=ENU=Def. Tax Group Code }
    { 7   ;   ;Def. Costing Method ;Option        ;CaptionML=ENU=Def. Costing Method;
                                                   OptionCaptionML=ENU=FIFO,LIFO,Specific,Average,Standard;
                                                   OptionString=FIFO,LIFO,Specific,Average,Standard }
    { 8   ;   ;Def. VAT Prod. Posting Group;Code10;TableRelation="VAT Product Posting Group".Code;
                                                   CaptionML=ENU=Def. VAT Prod. Posting Group }
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
      ItemCategory@1000 : Record 5722;

    BEGIN
    END.
  }
}

