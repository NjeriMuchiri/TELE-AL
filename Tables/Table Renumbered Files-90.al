OBJECT table 17208 Job-Journal Line
{
  OBJECT-PROPERTIES
  {
    Date=11/05/14;
    Time=[ 2:33:01 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               LOCKTABLE;
               JobJnlTemplate.GET("Journal Template Name");
               JobJnlBatch.GET("Journal Template Name","Journal Batch Name");

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
               //DimMgt.InsertJnlLineDim(
               //  DATABASE::"Job Journal Line",
               //  "Journal Template Name","Journal Batch Name","Line No.",0,
               //  "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
             END;

    OnModify=BEGIN
               //IF (Rec.Type = Type::Item) AND (xRec.Type = Type::Item) THEN
               //  ReserveJobJnlLine.VerifyChange(Rec,xRec)
               //ELSE
                 //IF (Rec.Type <> Type::Item) AND (xRec.Type = Type::Item) THEN
               //    ReserveJobJnlLine.DeleteLine(xRec);
             END;

    OnDelete=BEGIN
               IF Type = Type::Item THEN
               //  ReserveJobJnlLine.DeleteLine(Rec);
                 {
               DimMgt.UpdateJobTaskDim(
                 DATABASE::"Job Journal Line",
                 "Journal Template Name","Journal Batch Name","Line No.",0);
                  }
             END;

    OnRename=BEGIN
               //ReserveJobJnlLine.RenameLine(Rec,xRec);
             END;

    CaptionML=ENU=Job Journal Line;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Job-Journal Template";
                                                   CaptionML=ENU=Journal Template Name }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=ENU=Line No. }
    { 3   ;   ;Job No.             ;Code20        ;TableRelation=Jobs;
                                                   OnValidate=BEGIN
                                                                IF "Job No." = '' THEN BEGIN
                                                                  VALIDATE("Currency Code",'');
                                                                  VALIDATE("Job Task No.",'');
                                                                  CreateDim(
                                                                    DATABASE::Job,"Job No.",
                                                                    DimMgt.TypeToTableID2(Type),"No.",
                                                                    DATABASE::"Resource Group","Resource Group No.");
                                                                  EXIT;
                                                                END;

                                                                GetJob;
                                                                Job.TestBlocked;
                                                                //Job.TESTFIELD("Bill-to Partner No.");
                                                                //Cust.GET(Job."Bill-to Partner No.");
                                                                VALIDATE("Job Task No.",'');
                                                                "Customer Price Group" := Job."Customer Price Group";
                                                                VALIDATE("Currency Code",Job."Currency Code");
                                                                CreateDim(
                                                                  DATABASE::Job,"Job No.",
                                                                  DimMgt.TypeToTableID2(Type),"No.",
                                                                  DATABASE::"Resource Group","Resource Group No.");
                                                                VALIDATE("Country/Region Code",Cust."Country/Region Code");
                                                              END;

                                                   CaptionML=ENU=Job No. }
    { 4   ;   ;Posting Date        ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Document Date","Posting Date");
                                                                IF "Currency Code" <> '' THEN BEGIN
                                                                  UpdateCurrencyFactor;
                                                                  UpdateAllAmounts;
                                                                END
                                                              END;

                                                   CaptionML=ENU=Posting Date }
    { 5   ;   ;Document No.        ;Code20        ;CaptionML=ENU=Document No. }
    { 6   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                VALIDATE("No.",'');
                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Type;
                                                   OptionCaptionML=ENU=Resource,Item,G/L Account;
                                                   OptionString=Resource,Item,G/L Account }
    { 8   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Resource)) Resource ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(G/L Account)) "G/L Account";
                                                   OnValidate=BEGIN
                                                                IF ("No." = '') OR ("No." <> xRec."No.") THEN BEGIN
                                                                  Description := '';
                                                                  "Unit of Measure Code" := '';
                                                                  "Qty. per Unit of Measure" := 1;
                                                                  "Variant Code" := '';
                                                                  "Work Type Code" := '';
                                                                  DeleteAmounts;
                                                                  "Cost Factor" := 0;
                                                                  "Applies-to Entry" := 0;
                                                                  "Applies-from Entry" := 0;
                                                                  CheckedAvailability := FALSE;
                                                                  IF "No." = '' THEN BEGIN
                                                                    CreateDim(
                                                                      DimMgt.TypeToTableID2(Type),"No.",
                                                                      DATABASE::Job,"Job No.",
                                                                      DATABASE::"Resource Group","Resource Group No.");
                                                                    EXIT;
                                                                  END ELSE BEGIN
                                                                    // Preserve quantities after resetting all amounts:
                                                                    Quantity := xRec.Quantity;
                                                                    "Quantity (Base)" := xRec."Quantity (Base)";
                                                                  END;
                                                                END;

                                                                CASE Type OF
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      Res.GET("No.");
                                                                      Res.TESTFIELD(Blocked,FALSE);
                                                                      Description := Res.Name;
                                                                      "Description 2" := Res."Name 2";
                                                                      "Resource Group No." := Res."Resource Group No.";
                                                                      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                                                                      VALIDATE("Unit of Measure Code",Res."Base Unit of Measure");
                                                                    END;
                                                                  Type::Item:
                                                                    BEGIN
                                                                      GetItem;
                                                                      Item.TESTFIELD(Blocked,FALSE);
                                                                      Description := Item.Description;
                                                                      "Description 2" := Item."Description 2";
                                                                      IF Job."Language Code" <> '' THEN
                                                                        GetItemTranslation;
                                                                      "Posting Group" := Item."Inventory Posting Group";
                                                                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                                                                      VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                    END;
                                                                  Type::"G/L Account":
                                                                    BEGIN
                                                                      GLAcc.GET("No.");
                                                                      GLAcc.CheckGLAcc;
                                                                      GLAcc.TESTFIELD("Direct Posting",TRUE);
                                                                      Description := GLAcc.Name;
                                                                      "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                                                                      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                                                                      "Unit of Measure Code" := '';
                                                                      "Direct Unit Cost (LCY)" := 0;
                                                                      "Unit Cost (LCY)" := 0;
                                                                      "Unit Price" := 0;
                                                                    END;
                                                                END;

                                                                VALIDATE(Quantity);

                                                                CreateDim(
                                                                  DimMgt.TypeToTableID2(Type),"No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::"Resource Group","Resource Group No.");
                                                              END;

                                                   CaptionML=ENU=No. }
    { 9   ;   ;Description         ;Text50        ;CaptionML=ENU=Description }
    { 10  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                CheckItemAvailable;

                                                                //IF Item."Item Tracking Code" <> '' THEN
                                                                //  ReserveJobJnlLine.VerifyQuantity(Rec,xRec);

                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Quantity;
                                                   DecimalPlaces=0:5 }
    { 12  ;   ;Direct Unit Cost (LCY);Decimal     ;CaptionML=ENU=Direct Unit Cost (LCY);
                                                   AutoFormatType=2;
                                                   MinValue=0 }
    { 13  ;   ;Unit Cost (LCY)     ;Decimal       ;OnValidate=BEGIN
                                                                IF (Type = Type::Item) AND
                                                                   Item.GET("No.") AND
                                                                   (Item."Costing Method" = Item."Costing Method"::Standard) THEN
                                                                  UpdateAllAmounts
                                                                ELSE BEGIN
                                                                  GetJob;
                                                                  "Unit Cost" := ROUND(
                                                                      CurrExchRate.ExchangeAmtLCYToFCY(
                                                                        "Posting Date","Currency Code",
                                                                        "Unit Cost (LCY)","Currency Factor"),
                                                                      UnitAmountRoundingPrecision);
                                                                  UpdateAllAmounts;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Unit Cost (LCY);
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   MinValue=0 }
    { 14  ;   ;Total Cost (LCY)    ;Decimal       ;CaptionML=ENU=Total Cost (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 15  ;   ;Unit Price (LCY)    ;Decimal       ;OnValidate=BEGIN
                                                                GetJob;
                                                                "Unit Price" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Posting Date","Currency Code",
                                                                      "Unit Price (LCY)","Currency Factor"),
                                                                    UnitAmountRoundingPrecision);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Unit Price (LCY);
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 16  ;   ;Total Price (LCY)   ;Decimal       ;CaptionML=ENU=Total Price (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Resource Group No.  ;Code20        ;TableRelation="Resource Group";
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Resource Group","Resource Group No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DimMgt.TypeToTableID2(Type),"No.");
                                                              END;

                                                   CaptionML=ENU=Resource Group No.;
                                                   Editable=No }
    { 18  ;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.)) ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.)) ELSE "Unit of Measure";
                                                   OnValidate=VAR
                                                                Resource@1000 : Record 156;
                                                              BEGIN
                                                                GetGLSetup;
                                                                CASE Type OF
                                                                  Type::Item:
                                                                    BEGIN
                                                                      Item.GET("No.");
                                                                      "Qty. per Unit of Measure" :=
                                                                        UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                    END;
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      IF CurrFieldNo <> FIELDNO("Work Type Code") THEN
                                                                        IF "Work Type Code" <> '' THEN BEGIN
                                                                          WorkType.GET("Work Type Code");
                                                                          IF WorkType."Unit of Measure Code" <> '' THEN
                                                                            TESTFIELD("Unit of Measure Code",WorkType."Unit of Measure Code");
                                                                        END ELSE TESTFIELD("Work Type Code",'');
                                                                      IF "Unit of Measure Code" = '' THEN BEGIN
                                                                        Resource.GET("No.");
                                                                        "Unit of Measure Code" := Resource."Base Unit of Measure";
                                                                      END;
                                                                      ResUnitofMeasure.GET("No.","Unit of Measure Code");
                                                                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                                                                      "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                                                                    END;
                                                                  Type::"G/L Account":
                                                                    BEGIN
                                                                      "Qty. per Unit of Measure" := 1;
                                                                    END;
                                                                END;
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=ENU=Unit of Measure Code }
    { 21  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                "Bin Code" := '';
                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                  VALIDATE(Quantity);
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Location Code }
    { 22  ;   ;Chargeable          ;Boolean       ;OnValidate=BEGIN
                                                                IF Chargeable <> xRec.Chargeable THEN
                                                                  IF Chargeable = FALSE THEN
                                                                    VALIDATE("Unit Price",0)
                                                                  ELSE
                                                                    VALIDATE("No.");
                                                              END;

                                                   InitValue=Yes;
                                                   CaptionML=ENU=Chargeable }
    { 30  ;   ;Posting Group       ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group" ELSE IF (Type=CONST(G/L Account)) "G/L Account";
                                                   CaptionML=ENU=Posting Group;
                                                   Editable=No }
    { 31  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 1 Code;
                                                   CaptionClass='1,2,1' }
    { 32  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   CaptionClass='1,2,2' }
    { 33  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Resource);
                                                                VALIDATE("Line Discount %",0);
                                                                IF ("Work Type Code" = '') AND (xRec."Work Type Code" <> '') THEN BEGIN
                                                                  Res.GET("No.");
                                                                  "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                  VALIDATE("Unit of Measure Code");
                                                                END;
                                                                IF WorkType.GET("Work Type Code") THEN BEGIN
                                                                  IF WorkType."Unit of Measure Code" <> '' THEN BEGIN
                                                                    "Unit of Measure Code" := WorkType."Unit of Measure Code";
                                                                    IF ResUnitofMeasure.GET("No.","Unit of Measure Code") THEN
                                                                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                                                                  END ELSE BEGIN
                                                                    Res.GET("No.");
                                                                    "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                    VALIDATE("Unit of Measure Code");
                                                                  END;
                                                                END;
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=ENU=Work Type Code }
    { 34  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   OnValidate=BEGIN
                                                                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                                                                  UpdateAllAmounts;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Customer Price Group }
    { 37  ;   ;Applies-to Entry    ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                GetJob;
                                                                TESTFIELD(Type,Type::Item);
                                                                IF "Applies-to Entry" <> 0 THEN BEGIN
                                                                  ItemLedgEntry.GET("Applies-to Entry");
                                                                  TESTFIELD(Quantity);
                                                                  IF Quantity < 0 THEN
                                                                    FIELDERROR(Quantity,Text002);
                                                                  ItemLedgEntry.TESTFIELD(Open,TRUE);
                                                                  ItemLedgEntry.TESTFIELD(Positive,TRUE);
                                                                  "Location Code" := ItemLedgEntry."Location Code";
                                                                  "Variant Code" := ItemLedgEntry."Variant Code";
                                                                  GetItem;
                                                                  IF Item."Costing Method" <> Item."Costing Method"::Standard THEN BEGIN
                                                                    "Unit Cost" := ROUND(
                                                                        CurrExchRate.ExchangeAmtLCYToFCY(
                                                                          "Posting Date","Currency Code",
                                                                          CalcUnitCost(ItemLedgEntry),"Currency Factor"),
                                                                        UnitAmountRoundingPrecision);
                                                                    UpdateAllAmounts;
                                                                  END;
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Applies-to Entry"));
                                                            END;

                                                   CaptionML=ENU=Applies-to Entry }
    { 61  ;   ;Entry Type          ;Option        ;CaptionML=ENU=Entry Type;
                                                   OptionCaptionML=ENU=Usage,Sale;
                                                   OptionString=Usage,Sale;
                                                   Editable=No }
    { 62  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=ENU=Source Code;
                                                   Editable=No }
    { 73  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Job-Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   CaptionML=ENU=Journal Batch Name }
    { 74  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=ENU=Reason Code }
    { 75  ;   ;Recurring Method    ;Option        ;CaptionML=ENU=Recurring Method;
                                                   OptionCaptionML=ENU=,Fixed,Variable;
                                                   OptionString=,Fixed,Variable;
                                                   BlankZero=Yes }
    { 76  ;   ;Expiration Date     ;Date          ;CaptionML=ENU=Expiration Date }
    { 77  ;   ;Recurring Frequency ;DateFormula   ;CaptionML=ENU=Recurring Frequency }
    { 79  ;   ;Gen. Bus. Posting Group;Code10     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=ENU=Gen. Bus. Posting Group }
    { 80  ;   ;Gen. Prod. Posting Group;Code10    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=ENU=Gen. Prod. Posting Group }
    { 81  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=ENU=Transaction Type }
    { 82  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=ENU=Transport Method }
    { 83  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=ENU=Country/Region Code }
    { 86  ;   ;Entry/Exit Point    ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=ENU=Entry/Exit Point }
    { 87  ;   ;Document Date       ;Date          ;CaptionML=ENU=Document Date }
    { 88  ;   ;External Document No.;Code20       ;CaptionML=ENU=External Document No. }
    { 89  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=ENU=Area }
    { 90  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=ENU=Transaction Specification }
    { 91  ;   ;Serial No.          ;Code20        ;OnLookup=BEGIN
                                                              TESTFIELD(Type,Type::Item);
                                                              SelectItemEntry(FIELDNO("Serial No."));
                                                            END;

                                                   CaptionML=ENU=Serial No. }
    { 92  ;   ;Posting No. Series  ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Posting No. Series }
    { 93  ;   ;Source Currency Code;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Source Currency Code;
                                                   Editable=No }
    { 94  ;   ;Source Currency Total Cost;Decimal ;CaptionML=ENU=Source Currency Total Cost;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 95  ;   ;Source Currency Total Price;Decimal;CaptionML=ENU=Source Currency Total Price;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 96  ;   ;Source Currency Line Amount;Decimal;CaptionML=ENU=Source Currency Line Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=ENU=Dimension Set ID;
                                                   Editable=No }
    { 1000;   ;Job Task No.        ;Code20        ;TableRelation=Job-Task."Grant Task No." WHERE (Grant No.=FIELD(Job No.));
                                                   OnValidate=VAR
                                                                JobTask@1000 : Record 53926;
                                                              BEGIN
                                                                IF ("Job Task No." = '') OR (("Job Task No." <> xRec."Job Task No.") AND (xRec."Job Task No." <> '')) THEN BEGIN
                                                                  VALIDATE("No.",'');
                                                                  EXIT;
                                                                END;

                                                                TESTFIELD("Job No.");
                                                                JobTask.GET("Job No.","Job Task No.");
                                                                JobTask.TESTFIELD("Grant Task Type",JobTask."Grant Task Type"::Posting);
                                                              END;

                                                   CaptionML=ENU=Job Task No. }
    { 1001;   ;Total Cost          ;Decimal       ;CaptionML=ENU=Total Cost;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1002;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Unit Price;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code";
                                                   MinValue=0 }
    { 1003;   ;Line Type           ;Option        ;CaptionML=ENU=Line Type;
                                                   OptionCaptionML=ENU=" ,Schedule,Contract,Both Schedule and Contract";
                                                   OptionString=[ ,Schedule,Contract,Both Schedule and Contract] }
    { 1004;   ;Applies-from Entry  ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                GetJob;
                                                                TESTFIELD(Type,Type::Item);
                                                                IF "Applies-from Entry" <> 0 THEN BEGIN
                                                                  TESTFIELD(Quantity);
                                                                  IF Quantity > 0 THEN
                                                                    FIELDERROR(Quantity,Text003);
                                                                  ItemLedgEntry.GET("Applies-from Entry");
                                                                  ItemLedgEntry.TESTFIELD(Positive,FALSE);
                                                                  IF Item."Costing Method" <> Item."Costing Method"::Standard THEN BEGIN
                                                                    "Unit Cost" := ROUND(
                                                                        CurrExchRate.ExchangeAmtLCYToFCY(
                                                                          "Posting Date","Currency Code",
                                                                          CalcUnitCostFrom(ItemLedgEntry."Entry No."),"Currency Factor"),
                                                                        UnitAmountRoundingPrecision);
                                                                    UpdateAllAmounts;
                                                                  END;
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Applies-from Entry"));
                                                            END;

                                                   CaptionML=ENU=Applies-from Entry;
                                                   MinValue=0 }
    { 1005;   ;Job Posting Only    ;Boolean       ;CaptionML=ENU=Job Posting Only }
    { 1006;   ;Line Discount %     ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Line Discount %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 1007;   ;Line Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Line Discount Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1008;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                UpdateCurrencyFactor;
                                                              END;

                                                   CaptionML=ENU=Currency Code;
                                                   Editable=No }
    { 1009;   ;Line Amount         ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Line Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1010;   ;Currency Factor     ;Decimal       ;OnValidate=BEGIN
                                                                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                                                                  FIELDERROR("Currency Factor",STRSUBSTNO(Text001,FIELDCAPTION("Currency Code")));
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Currency Factor;
                                                   DecimalPlaces=0:15;
                                                   Editable=No;
                                                   MinValue=0 }
    { 1011;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Unit Cost;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1012;   ;Line Amount (LCY)   ;Decimal       ;OnValidate=BEGIN
                                                                GetJob;
                                                                "Line Amount" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Posting Date","Currency Code",
                                                                      "Line Amount (LCY)","Currency Factor"),
                                                                    AmountRoundingPrecision);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Line Amount (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1013;   ;Line Discount Amount (LCY);Decimal ;OnValidate=BEGIN
                                                                GetJob;
                                                                "Line Discount Amount" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Posting Date","Currency Code",
                                                                      "Line Discount Amount (LCY)","Currency Factor"),
                                                                    AmountRoundingPrecision);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=ENU=Line Discount Amount (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1014;   ;Total Price         ;Decimal       ;CaptionML=ENU=Total Price;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1015;   ;Cost Factor         ;Decimal       ;CaptionML=ENU=Cost Factor;
                                                   Editable=No }
    { 1016;   ;Description 2       ;Text50        ;CaptionML=ENU=Description 2 }
    { 1017;   ;Ledger Entry Type   ;Option        ;CaptionML=ENU=Ledger Entry Type;
                                                   OptionCaptionML=ENU=" ,Resource,Item,G/L Account";
                                                   OptionString=[ ,Resource,Item,G/L Account] }
    { 1018;   ;Ledger Entry No.    ;Integer       ;TableRelation=IF (Ledger Entry Type=CONST(Resource)) "Res. Ledger Entry" ELSE IF (Ledger Entry Type=CONST(Item)) "Item Ledger Entry" ELSE IF (Ledger Entry Type=CONST(G/L Account)) "G/L Entry";
                                                   CaptionML=ENU=Ledger Entry No.;
                                                   BlankZero=Yes }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=BEGIN
                                                                IF "Variant Code" = '' THEN BEGIN
                                                                  IF Type = Type::Item THEN BEGIN
                                                                    Item.GET("No.");
                                                                    Description := Item.Description;
                                                                    "Description 2" := Item."Description 2";
                                                                    GetItemTranslation;
                                                                  END;
                                                                  EXIT;
                                                                END;

                                                                TESTFIELD(Type,Type::Item);

                                                                ItemVariant.GET("No.","Variant Code");
                                                                Description := ItemVariant.Description;
                                                                "Description 2" := ItemVariant."Description 2";

                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=ENU=Variant Code }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Location Code");
                                                                CheckItemAvailable;
                                                              END;

                                                   CaptionML=ENU=Bin Code }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=ENU=Qty. per Unit of Measure;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5410;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                              END;

                                                   CaptionML=ENU=Quantity (Base);
                                                   DecimalPlaces=0:5 }
    { 5468;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Journal Template Name), Source Ref. No.=FIELD(Line No.), Source Type=CONST(1011), Source Subtype=FIELD(Entry Type), Source Batch Name=FIELD(Journal Batch Name), Source Prod. Order Line=CONST(0), Reservation Status=CONST(Reservation)));
                                                   CaptionML=ENU=Reserved Qty. (Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5900;   ;Service Order No.   ;Code20        ;CaptionML=ENU=Service Order No. }
    { 5901;   ;Posted Service Shipment No.;Code20 ;CaptionML=ENU=Posted Service Shipment No. }
    { 6501;   ;Lot No.             ;Code20        ;CaptionML=ENU=Lot No.;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Line No.;
                                                   Clustered=Yes }
    {    ;Journal Template Name,Journal Batch Name,Type,No.,Unit of Measure Code,Work Type Code;
                                                   MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You cannot change %1 when %2 is %3.';
      Location@1007 : Record 14;
      Item@1001 : Record 27;
      Res@1002 : Record 156;
      Cust@1039 : Record 23;
      ItemJnlLine@1003 : Record 83;
      GLAcc@1004 : Record 15;
      Job@1005 : Record 53913;
      WorkType@1009 : Record 200;
      JobJnlTemplate@1011 : Record 53916;
      JobJnlBatch@1012 : Record 53922;
      JobJnlLine@1013 : Record 53917;
      ItemVariant@1015 : Record 5401;
      ResUnitofMeasure@1008 : Record 205;
      ResCost@1018 : Record 202;
      ItemTranslation@1040 : Record 30;
      Currency@1031 : Record 4;
      CurrExchRate@1029 : Record 330;
      SKU@1028 : Record 5700;
      GLSetup@1010 : Record 98;
      SalesPriceCalcMgt@1014 : Codeunit 7000;
      PurchPriceCalcMgt@1006 : Codeunit 7010;
      ResFindUnitCost@1027 : Codeunit 220;
      ItemCheckAvail@1020 : Codeunit 311;
      NoSeriesMgt@1021 : Codeunit 396;
      UOMMgt@1022 : Codeunit 5402;
      DimMgt@1023 : Codeunit 408;
      ReserveJobJnlLine@1032 : Codeunit 99000844;
      DontCheckStandardCost@1037 : Boolean;
      Text001@1060 : TextConst 'ENU=cannot be specified without %1';
      Text002@1033 : TextConst 'ENU=must be positive';
      Text003@1038 : TextConst 'ENU=must be negative';
      HasGotGLSetup@1016 : Boolean;
      CurrencyDate@1030 : Date;
      UnitAmountRoundingPrecision@1024 : Decimal;
      AmountRoundingPrecision@1025 : Decimal;
      CheckedAvailability@1017 : Boolean;

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CheckItemAvailable@5();
    BEGIN
      IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND (Quantity > 0) AND NOT CheckedAvailability THEN BEGIN
        ItemJnlLine."Item No." := "No.";
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
        ItemJnlLine."Location Code" := "Location Code";
        ItemJnlLine."Variant Code" := "Variant Code";
        ItemJnlLine."Bin Code" := "Bin Code";
        ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        ItemJnlLine.Quantity := Quantity;
        ItemCheckAvail.ItemJnlCheckLine(ItemJnlLine);
        CheckedAvailability := TRUE;
      END;
    END;

    PROCEDURE EmptyLine@8() : Boolean;
    BEGIN
      EXIT(("Job No." = '') AND ("No." = '') AND (Quantity = 0));
    END;

    PROCEDURE SetUpNewLine@9(LastJobJnlLine@1000 : Record 53917);
    BEGIN
      JobJnlTemplate.GET("Journal Template Name");
      JobJnlBatch.GET("Journal Template Name","Journal Batch Name");
      JobJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      JobJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      IF JobJnlLine.FIND('-') THEN BEGIN
        "Posting Date" := LastJobJnlLine."Posting Date";
        "Document Date" := LastJobJnlLine."Posting Date";
        "Document No." := LastJobJnlLine."Document No.";
        Type := LastJobJnlLine.Type;
        VALIDATE("Line Type",LastJobJnlLine."Line Type");
      END ELSE BEGIN
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        IF JobJnlBatch."No. Series" <> '' THEN BEGIN
          CLEAR(NoSeriesMgt);
          "Document No." := NoSeriesMgt.TryGetNextNo(JobJnlBatch."No. Series","Posting Date");
        END;
      END;
      "Recurring Method" := LastJobJnlLine."Recurring Method";
      "Entry Type" := "Entry Type"::Usage;
      "Source Code" := JobJnlTemplate."Source Code";
      "Reason Code" := JobJnlBatch."Reason Code";
      "Posting No. Series" := JobJnlBatch."Posting No. Series";
    END;

    PROCEDURE CreateDim@13(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20]);
    VAR
      TableID@1006 : ARRAY [10] OF Integer;
      No@1007 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      //DimMgt.GetDefaultDim(
      //  TableID,No,"Source Code",
      //  "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      IF "Line No." <> 0 THEN
       // DimMgt.UpdateJnlLineDefaultDim(
       //   DATABASE::"Job Journal Line",
       //   "Journal Template Name","Journal Batch Name","Line No.",0,
       //   "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    PROCEDURE ValidateShortcutDimCode@10(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      IF "Line No." <> 0 THEN
        DimMgt.SaveJnlLineDim(
          DATABASE::"Job Journal Line","Journal Template Name",
          "Journal Batch Name","Line No.",0,FieldNumber,ShortcutDimCode)
      ELSE
      //  DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
    END;

    PROCEDURE LookupShortcutDimCode@18(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      IF "Line No." <> 0 THEN
        DimMgt.SaveJnlLineDim(
          DATABASE::"Job Journal Line","Journal Template Name",
          "Journal Batch Name","Line No.",0,FieldNumber,ShortcutDimCode)
      ELSE
      //  DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
    END;

    PROCEDURE ShowShortcutDimCode@15(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      {IF "Line No." <> 0 THEN
        DimMgt.GetDimSetIDsForFilter(
          DATABASE::"Job Journal Line","Journal Template Name",
          "Journal Batch Name","Line No.",0,ShortcutDimCode)
      ELSE
        DimMgt.ClearDimSetFilter(ShortcutDimCode);
       }
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    PROCEDURE GetJob@16();
    BEGIN
      TESTFIELD("Job No.");
      IF "Job No." <> Job."No." THEN BEGIN
        Job.GET("Job No.");
        IF Job."Currency Code" = '' THEN BEGIN
          GetGLSetup;
          Currency.InitRoundingPrecision;
          AmountRoundingPrecision := GLSetup."Amount Rounding Precision";
          UnitAmountRoundingPrecision := GLSetup."Unit-Amount Rounding Precision";
        END ELSE BEGIN
          GetCurrency;
          Currency.GET(Job."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
          AmountRoundingPrecision := Currency."Amount Rounding Precision";
          UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateCurrencyFactor@17();
    BEGIN
      IF "Currency Code" <> '' THEN BEGIN
        IF "Posting Date" = 0D THEN
          CurrencyDate := WORKDATE
        ELSE
          CurrencyDate := "Posting Date";
        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
      END ELSE
        "Currency Factor" := 0;
    END;

    LOCAL PROCEDURE GetItem@19();
    BEGIN
      TESTFIELD("No.");
      IF "No." <> Item."No." THEN
        Item.GET("No.");
    END;

    LOCAL PROCEDURE GetSKU@5806() : Boolean;
    BEGIN
      IF (SKU."Location Code" = "Location Code") AND
         (SKU."Item No." = "No.") AND
         (SKU."Variant Code" = "Variant Code")
      THEN
        EXIT(TRUE);

      IF SKU.GET("Location Code","No.","Variant Code") THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    PROCEDURE OpenItemTrackingLines@6500(IsReclass@1000 : Boolean);
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ///ReserveJobJnlLine.CallItemTracking(Rec,IsReclass);
    END;

    LOCAL PROCEDURE GetCurrency@23();
    BEGIN
      IF "Currency Code" = '' THEN BEGIN
        CLEAR(Currency);
        Currency.InitRoundingPrecision
      END ELSE BEGIN
        Currency.GET("Currency Code");
        Currency.TESTFIELD("Amount Rounding Precision");
        Currency.TESTFIELD("Unit-Amount Rounding Precision");
      END;
    END;

    PROCEDURE DontCheckStdCost@26();
    BEGIN
      DontCheckStandardCost := TRUE;
    END;

    LOCAL PROCEDURE CalcUnitCost@5809(ItemLedgEntry@1000 : Record 32) : Decimal;
    VAR
      ValueEntry@1001 : Record 5802;
      UnitCost@1004 : Decimal;
    BEGIN
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
      ValueEntry.CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
      UnitCost :=
        (ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)") / ItemLedgEntry.Quantity;

      EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    END;

    LOCAL PROCEDURE CalcUnitCostFrom@5804(ItemLedgEntryNo@1000 : Integer) : Decimal;
    VAR
      ValueEntry@1001 : Record 5802;
      InvoicedQty@1002 : Decimal;
      CostAmount@1003 : Decimal;
    BEGIN
      InvoicedQty := 0;
      CostAmount := 0;
      ValueEntry.RESET;
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      ValueEntry.SETRANGE("Expected Cost",FALSE);
      IF ValueEntry.FIND('-') THEN
        REPEAT
          InvoicedQty += ValueEntry."Invoiced Quantity";
          CostAmount += ValueEntry."Cost Amount (Actual)";
        UNTIL ValueEntry.NEXT = 0;
      EXIT(CostAmount / InvoicedQty * "Qty. per Unit of Measure");
    END;

    LOCAL PROCEDURE SelectItemEntry@1(CurrentFieldNo@1000 : Integer);
    VAR
      ItemLedgEntry@1001 : Record 32;
      JobJnlLine2@1002 : Record 53917;
    BEGIN
      ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code");
      ItemLedgEntry.SETRANGE("Item No.","No.");
      ItemLedgEntry.SETRANGE(Correction,FALSE);

      IF "Location Code" <> '' THEN
        ItemLedgEntry.SETRANGE("Location Code","Location Code");

      IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN BEGIN
        ItemLedgEntry.SETRANGE(Positive,TRUE);
        ItemLedgEntry.SETRANGE(Open,TRUE);
      END ELSE
        ItemLedgEntry.SETRANGE(Positive,FALSE);

      //IF FORM.RUNMODAL(FORM::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
        JobJnlLine2 := Rec;
        IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN
          JobJnlLine2.VALIDATE("Applies-to Entry",ItemLedgEntry."Entry No.")
        ELSE
          JobJnlLine2.VALIDATE("Applies-from Entry",ItemLedgEntry."Entry No.");
        Rec := JobJnlLine2;
      //END;
    END;

    PROCEDURE DeleteAmounts@4();
    BEGIN
      Quantity := 0;
      "Quantity (Base)" := 0;

      "Direct Unit Cost (LCY)" := 0;
      "Unit Cost (LCY)" := 0;
      "Unit Cost" := 0;

      "Total Cost (LCY)" := 0;
      "Total Cost" := 0;

      "Unit Price (LCY)" := 0;
      "Unit Price" := 0;

      "Total Price (LCY)" := 0;
      "Total Price" := 0;

      "Line Amount (LCY)" := 0;
      "Line Amount" := 0;

      "Line Discount %" := 0;

      "Line Discount Amount (LCY)" := 0;
      "Line Discount Amount" := 0;
    END;

    PROCEDURE SetCurrencyFactor@11(Factor@1000 : Decimal);
    BEGIN
      "Currency Factor" := Factor;
    END;

    PROCEDURE GetItemTranslation@42();
    BEGIN
      GetJob;
      IF ItemTranslation.GET("No.","Variant Code",Job."Language Code") THEN BEGIN
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@24();
    BEGIN
      IF HasGotGLSetup THEN
        EXIT;
      GLSetup.GET;
      HasGotGLSetup := TRUE;
    END;

    PROCEDURE UpdateAllAmounts@37();
    BEGIN
      GetJob;

      UpdateUnitCost;
      UpdateTotalCost;
      FindPriceAndDiscount(Rec,CurrFieldNo);
      HandleCostFactor;
      UpdateUnitPrice;
      UpdateTotalPrice;
      UpdateAmountsAndDiscounts;
    END;

    LOCAL PROCEDURE UpdateUnitCost@36();
    VAR
      RetrievedCost@1000 : Decimal;
    BEGIN
      IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
        IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
          IF NOT DontCheckStandardCost THEN BEGIN
            // Prevent manual change of unit cost on items with standard cost
            IF (("Unit Cost" <> xRec."Unit Cost") OR ("Unit Cost (LCY)" <> xRec."Unit Cost (LCY)")) AND
               (("No." = xRec."No.") AND ("Location Code" = xRec."Location Code") AND
                ("Variant Code" = xRec."Variant Code") AND ("Unit of Measure Code" = xRec."Unit of Measure Code")) THEN
              ERROR(
                Text000,
                FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
          END;
          IF RetrieveCostPrice THEN BEGIN
            IF GetSKU THEN
              "Unit Cost (LCY)" := SKU."Unit Cost" * "Qty. per Unit of Measure"
            ELSE
              "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",
                  "Unit Cost (LCY)","Currency Factor"),
                UnitAmountRoundingPrecision);
          END ELSE BEGIN
            IF "Unit Cost" <> xRec."Unit Cost" THEN
              "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Posting Date","Currency Code",
                    "Unit Cost","Currency Factor"),
                  UnitAmountRoundingPrecision)
            ELSE
              "Unit Cost" := ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    "Posting Date","Currency Code",
                    "Unit Cost (LCY)","Currency Factor"),
                  UnitAmountRoundingPrecision);
          END;
        END ELSE BEGIN
          IF RetrieveCostPrice THEN BEGIN
            IF GetSKU THEN
              RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
            ELSE
              RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecision);
            "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Posting Date","Currency Code",
                  "Unit Cost","Currency Factor"),
                UnitAmountRoundingPrecision);
          END ELSE BEGIN
            "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Posting Date","Currency Code",
                  "Unit Cost","Currency Factor"),
                UnitAmountRoundingPrecision);
          END;
        END;
      END ELSE
        IF (Type = Type::Resource) AND Res.GET("No.") THEN BEGIN
          IF RetrieveCostPrice THEN BEGIN
            ResCost.INIT;
            ResCost.Code := "No.";
            ResCost."Work Type Code" := "Work Type Code";
            ResFindUnitCost.RUN(ResCost);
            "Direct Unit Cost (LCY)" := ResCost."Direct Unit Cost" * "Qty. per Unit of Measure";
            RetrievedCost := ROUND(ResCost."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecision);
            "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Posting Date","Currency Code",
                  "Unit Cost","Currency Factor"),
                UnitAmountRoundingPrecision);
          END ELSE BEGIN
            "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Posting Date","Currency Code",
                  "Unit Cost","Currency Factor"),
                UnitAmountRoundingPrecision);
          END;
        END ELSE BEGIN
          "Unit Cost (LCY)" := ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date","Currency Code",
                "Unit Cost","Currency Factor"),
              UnitAmountRoundingPrecision);
        END;
    END;

    LOCAL PROCEDURE RetrieveCostPrice@35() : Boolean;
    BEGIN
      CASE Type OF
        Type::Item:
          IF ("No." <> xRec."No.") OR
             ("Location Code" <> xRec."Location Code") OR
             ("Variant Code" <> xRec."Variant Code") OR
             ("Unit of Measure Code" <> xRec."Unit of Measure Code") AND
             (("Applies-to Entry" = 0) AND ("Applies-from Entry" = 0)) THEN
            EXIT(TRUE);
        Type::Resource:
          IF ("No." <> xRec."No.") OR
             ("Work Type Code" <> xRec."Work Type Code") OR
             ("Unit of Measure Code" <> xRec."Unit of Measure Code") THEN
            EXIT(TRUE);
        Type::"G/L Account":
          IF "No." <> xRec."No." THEN
            EXIT(TRUE);
        ELSE
          EXIT(FALSE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE UpdateTotalCost@34();
    BEGIN
      "Total Cost" := ROUND("Unit Cost" * Quantity,AmountRoundingPrecision);
      "Total Cost (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",
            "Total Cost","Currency Factor"),
          AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE FindPriceAndDiscount@33(VAR JobJnlLine@1000 : Record 53917;CalledByFieldNo@1001 : Integer);
    BEGIN
      IF RetrieveCostPrice AND ("No." <> '') THEN BEGIN
      //  SalesPriceCalcMgt.FindJobJnlLinePrice(JobJnlLine,CalledByFieldNo);

       // IF Type <> Type::"G/L Account" THEN
      //    PurchPriceCalcMgt.FindJobJnlLinePrice(JobJnlLine,CalledByFieldNo)
        //ELSE BEGIN
          // Because the SalesPriceCalcMgt.FindJobJnlLinePrice function also retrieves costs for G/L Account,
          // cost and total cost need to get updated again.
          UpdateUnitCost;
          UpdateTotalCost;
        END;
      //END;
    END;

    LOCAL PROCEDURE HandleCostFactor@32();
    BEGIN
      IF ("Unit Cost" <> xRec."Unit Cost") OR ("Cost Factor" <> xRec."Cost Factor") THEN BEGIN
        IF "Cost Factor" <> 0 THEN
          "Unit Price" := ROUND("Unit Cost" * "Cost Factor",UnitAmountRoundingPrecision)
        ELSE
          IF xRec."Cost Factor" <> 0 THEN
            "Unit Price" := 0;
      END;
    END;

    LOCAL PROCEDURE UpdateUnitPrice@25();
    BEGIN
      "Unit Price (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",
            "Unit Price","Currency Factor"),
          UnitAmountRoundingPrecision);
    END;

    LOCAL PROCEDURE UpdateTotalPrice@6();
    BEGIN
      "Total Price" := ROUND(Quantity * "Unit Price",AmountRoundingPrecision);
      "Total Price (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",
            "Total Price","Currency Factor"),
          AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE UpdateAmountsAndDiscounts@31();
    BEGIN
      IF "Total Price" <> 0 THEN BEGIN
        IF ("Line Amount" <> xRec."Line Amount") AND ("Line Discount Amount" = xRec."Line Discount Amount") THEN BEGIN
          "Line Amount" := ROUND("Line Amount",AmountRoundingPrecision);
          "Line Discount Amount" := "Total Price" - "Line Amount";
          "Line Discount %" :=
            ROUND("Line Discount Amount" / "Total Price" * 100);
        END ELSE
          IF ("Line Discount Amount" <> xRec."Line Discount Amount") AND ("Line Amount" = xRec."Line Amount") THEN BEGIN
            "Line Discount Amount" := ROUND("Line Discount Amount",AmountRoundingPrecision);
            "Line Amount" := "Total Price" - "Line Discount Amount";
            "Line Discount %" :=
              ROUND("Line Discount Amount" / "Total Price" * 100);
          END ELSE BEGIN
            "Line Discount Amount" :=
              ROUND("Total Price" * "Line Discount %" / 100,AmountRoundingPrecision);
            "Line Amount" := "Total Price" - "Line Discount Amount";
          END;
      END ELSE BEGIN
        "Line Amount" := 0;
        "Line Discount Amount" := 0;
      END;

      "Line Amount (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",
            "Line Amount","Currency Factor"),
          AmountRoundingPrecision);

      "Line Discount Amount (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",
            "Line Discount Amount","Currency Factor"),
          AmountRoundingPrecision);
    END;

    PROCEDURE IsInbound@7() : Boolean;
    BEGIN
      IF "Entry Type" IN ["Entry Type"::Usage,"Entry Type"::Sale] THEN
        EXIT("Quantity (Base)" < 0);

      EXIT(FALSE);
    END;

    PROCEDURE ShowDimensions@2();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."));
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    BEGIN
    END.
  }
}

