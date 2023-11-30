OBJECT table 50044 Purchase Quote Line
{
  OBJECT-PROPERTIES
  {
    Date=09/08/16;
    Time=11:05:16 AM;
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
    OnDelete=VAR
               PurchCommentLine@1001 : Record 43;
             BEGIN
             END;

    CaptionML=ENU=Purchase Quote Line;
    PasteIsValid=No;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=ENU=Document Type;
                                                   OptionCaptionML=ENU=Quotation Request,Open Tender,Restricted Tender;
                                                   OptionString=Quotation Request,Open Tender,Restricted Tender }
    { 2   ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=ENU=Buy-from Vendor No.;
                                                   Editable=No }
    { 3   ;   ;Document No.        ;Code20        ;CaptionML=ENU=Document No. }
    { 4   ;   ;Line No.            ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=ENU=Line No. }
    { 5   ;   ;Type                ;Option        ;CaptionML=ENU=Type;
                                                   OptionCaptionML=ENU=" ,G/L Account,Item,,Fixed Asset,Charge (Item)";
                                                   OptionString=[ ,G/L Account,Item,,Fixed Asset,Charge (Item)] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account".No. WHERE (Expense Code=FIELD(Expense Code))
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(3)) Resource
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
                                                   OnValidate=VAR
                                                                ICPartner@1000 : Record 413;
                                                                ItemCrossReference@1001 : Record 5717;
                                                                PrepmtMgt@1002 : Codeunit 441;
                                                              BEGIN
                                                                //,G/L Account,Item,,Fixed Asset,Charge (Item)
                                                                IF Type=Type::"G/L Account" THEN
                                                                  BEGIN
                                                                    GLAcc.RESET;
                                                                    GLAcc.GET("No.");
                                                                    Description:=GLAcc.Name;
                                                                  END
                                                                ELSE IF Type=Type::Item THEN
                                                                  BEGIN
                                                                    Item.RESET;
                                                                    Item.GET("No.");
                                                                    Description:=Item.Description;
                                                                  END
                                                                ELSE IF Type=Type::"Fixed Asset" THEN
                                                                  BEGIN
                                                                    FA.RESET;
                                                                    FA.GET("No.");
                                                                    Description:=FA.Description;
                                                                  END
                                                                ELSE IF Type=Type::"Charge (Item)" THEN
                                                                  BEGIN
                                                                    CItem.RESET;
                                                                    CItem.GET("No.");
                                                                    Description:=CItem.Description;
                                                                  END;
                                                              END;

                                                   CaptionML=ENU=No. }
    { 7   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=ENU=Location Code }
    { 8   ;   ;Posting Group       ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group"
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
                                                   CaptionML=ENU=Posting Group;
                                                   Editable=No }
    { 10  ;   ;Expected Receipt Date;Date         ;CaptionML=ENU=Expected Receipt Date }
    { 11  ;   ;Description         ;Text50        ;CaptionML=ENU=Description;
                                                   Editable=Yes }
    { 12  ;   ;Description 2       ;Text50        ;CaptionML=ENU=Description 2 }
    { 13  ;   ;Unit of Measure     ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure".Code;
                                                   CaptionML=ENU=Unit of Measure }
    { 15  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                IF "Direct Unit Cost"<>0 THEN
                                                                  BEGIN
                                                                    Amount:=Quantity * "Direct Unit Cost";
                                                                  END;
                                                              END;

                                                   CaptionML=ENU=Quantity;
                                                   DecimalPlaces=0:5 }
    { 16  ;   ;Outstanding Quantity;Decimal       ;CaptionML=ENU=Outstanding Quantity;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 17  ;   ;Qty. to Invoice     ;Decimal       ;CaptionML=ENU=Qty. to Invoice;
                                                   DecimalPlaces=0:5 }
    { 18  ;   ;Qty. to Receive     ;Decimal       ;CaptionML=ENU=Qty. to Receive;
                                                   DecimalPlaces=0:5 }
    { 22  ;   ;Direct Unit Cost    ;Decimal       ;OnValidate=BEGIN
                                                                IF Quantity<>0 THEN
                                                                  BEGIN
                                                                    Amount:=Quantity * "Direct Unit Cost";
                                                                  END;
                                                              END;

                                                   CaptionML=ENU=Direct Unit Cost;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 23  ;   ;Unit Cost (LCY)     ;Decimal       ;CaptionML=ENU=Unit Cost (LCY);
                                                   AutoFormatType=2 }
    { 25  ;   ;VAT %               ;Decimal       ;CaptionML=ENU=VAT %;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 27  ;   ;Line Discount %     ;Decimal       ;CaptionML=ENU=Line Discount %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 28  ;   ;Line Discount Amount;Decimal       ;CaptionML=ENU=Line Discount Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 29  ;   ;Amount              ;Decimal       ;CaptionML=ENU=Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 30  ;   ;Amount Including VAT;Decimal       ;CaptionML=ENU=Amount Including VAT;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 31  ;   ;Unit Price (LCY)    ;Decimal       ;CaptionML=ENU=Unit Price (LCY);
                                                   AutoFormatType=2 }
    { 32  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   CaptionML=ENU=Allow Invoice Disc. }
    { 34  ;   ;Gross Weight        ;Decimal       ;CaptionML=ENU=Gross Weight;
                                                   DecimalPlaces=0:5 }
    { 35  ;   ;Net Weight          ;Decimal       ;CaptionML=ENU=Net Weight;
                                                   DecimalPlaces=0:5 }
    { 36  ;   ;Units per Parcel    ;Decimal       ;CaptionML=ENU=Units per Parcel;
                                                   DecimalPlaces=0:5 }
    { 37  ;   ;Unit Volume         ;Decimal       ;CaptionML=ENU=Unit Volume;
                                                   DecimalPlaces=0:5 }
    { 38  ;   ;Appl.-to Item Entry ;Integer       ;CaptionML=ENU=Appl.-to Item Entry }
    { 40  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Shortcut Dimension 1 Code;
                                                   CaptionClass='1,2,1' }
    { 41  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   CaptionClass='1,2,2' }
    { 45  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   OnValidate=VAR
                                                                Job@1000 : Record 167;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Job No. }
    { 54  ;   ;Indirect Cost %     ;Decimal       ;CaptionML=ENU=Indirect Cost %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 57  ;   ;Outstanding Amount  ;Decimal       ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Outstanding Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 58  ;   ;Qty. Rcd. Not Invoiced;Decimal     ;CaptionML=ENU=Qty. Rcd. Not Invoiced;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 59  ;   ;Amt. Rcd. Not Invoiced;Decimal     ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Amt. Rcd. Not Invoiced;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Quantity Received   ;Decimal       ;CaptionML=ENU=Quantity Received;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 61  ;   ;Quantity Invoiced   ;Decimal       ;CaptionML=ENU=Quantity Invoiced;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 63  ;   ;Receipt No.         ;Code20        ;CaptionML=ENU=Receipt No.;
                                                   Editable=No }
    { 64  ;   ;Receipt Line No.    ;Integer       ;CaptionML=ENU=Receipt Line No.;
                                                   Editable=No }
    { 67  ;   ;Profit %            ;Decimal       ;CaptionML=ENU=Profit %;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 68  ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=ENU=Pay-to Vendor No.;
                                                   Editable=No }
    { 69  ;   ;Inv. Discount Amount;Decimal       ;CaptionML=ENU=Inv. Discount Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Vendor Item No.     ;Text20        ;CaptionML=ENU=Vendor Item No. }
    { 71  ;   ;Sales Order No.     ;Code20        ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=ENU=Sales Order No.;
                                                   Editable=No }
    { 72  ;   ;Sales Order Line No.;Integer       ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                              Document No.=FIELD(Sales Order No.));
                                                   CaptionML=ENU=Sales Order Line No.;
                                                   Editable=No }
    { 73  ;   ;Drop Shipment       ;Boolean       ;CaptionML=ENU=Drop Shipment;
                                                   Editable=No }
    { 74  ;   ;Gen. Bus. Posting Group;Code10     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=ENU=Gen. Bus. Posting Group }
    { 75  ;   ;Gen. Prod. Posting Group;Code10    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=ENU=Gen. Prod. Posting Group }
    { 77  ;   ;VAT Calculation Type;Option        ;CaptionML=ENU=VAT Calculation Type;
                                                   OptionCaptionML=ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 78  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=ENU=Transaction Type }
    { 79  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=ENU=Transport Method }
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Purchase Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                                                   Document No.=FIELD(Document No.));
                                                   CaptionML=ENU=Attached to Line No.;
                                                   Editable=No }
    { 81  ;   ;Entry Point         ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=ENU=Entry Point }
    { 82  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=ENU=Area }
    { 83  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=ENU=Transaction Specification }
    { 85  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=ENU=Tax Area Code }
    { 86  ;   ;Tax Liable          ;Boolean       ;CaptionML=ENU=Tax Liable }
    { 87  ;   ;Tax Group Code      ;Code10        ;TableRelation="Tax Group";
                                                   CaptionML=ENU=Tax Group Code }
    { 88  ;   ;Use Tax             ;Boolean       ;CaptionML=ENU=Use Tax }
    { 89  ;   ;VAT Bus. Posting Group;Code10      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=ENU=VAT Bus. Posting Group }
    { 90  ;   ;VAT Prod. Posting Group;Code10     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=ENU=VAT Prod. Posting Group }
    { 91  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code;
                                                   Editable=No }
    { 92  ;   ;Outstanding Amount (LCY);Decimal   ;CaptionML=ENU=Outstanding Amount (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 93  ;   ;Amt. Rcd. Not Invoiced (LCY);Decimal;
                                                   CaptionML=ENU=Amt. Rcd. Not Invoiced (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 95  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                                                       Source Ref. No.=FIELD(Line No.),
                                                                                                       Source Type=CONST(39),
                                                                                                       Source Subtype=FIELD(Document Type),
                                                                                                       Reservation Status=CONST(Reservation)));
                                                   CaptionML=ENU=Reserved Quantity;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 97  ;   ;Blanket Order No.   ;Code20        ;TableRelation="Purchase Header".No. WHERE (Document Type=CONST(Blanket Order));
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Blanket Order No. }
    { 98  ;   ;Blanket Order Line No.;Integer     ;TableRelation="Purchase Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                                                                   Document No.=FIELD(Blanket Order No.));
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Blanket Order Line No. }
    { 99  ;   ;VAT Base Amount     ;Decimal       ;CaptionML=ENU=VAT Base Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 100 ;   ;Unit Cost           ;Decimal       ;CaptionML=ENU=Unit Cost;
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 101 ;   ;System-Created Entry;Boolean       ;CaptionML=ENU=System-Created Entry;
                                                   Editable=No }
    { 103 ;   ;Line Amount         ;Decimal       ;CaptionML=ENU=Line Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 104 ;   ;VAT Difference      ;Decimal       ;CaptionML=ENU=VAT Difference;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 105 ;   ;Inv. Disc. Amount to Invoice;Decimal;
                                                   CaptionML=ENU=Inv. Disc. Amount to Invoice;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 106 ;   ;VAT Identifier      ;Code10        ;CaptionML=ENU=VAT Identifier;
                                                   Editable=No }
    { 107 ;   ;IC Partner Ref. Type;Option        ;CaptionML=ENU=IC Partner Ref. Type;
                                                   OptionCaptionML=ENU=" ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.,Vendor Item No.";
                                                   OptionString=[ ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.,Vendor Item No.] }
    { 108 ;   ;IC Partner Reference;Code20        ;OnLookup=VAR
                                                              ICGLAccount@1000 : Record 410;
                                                              ItemCrossReference@1001 : Record 5717;
                                                              ItemVendorCatalog@1003 : Record 99;
                                                            BEGIN
                                                            END;

                                                   CaptionML=ENU=IC Partner Reference }
    { 109 ;   ;Prepayment %        ;Decimal       ;OnValidate=VAR
                                                                GenPostingSetup@1001 : Record 252;
                                                                GLAcc@1000 : Record 15;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Prepayment %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 110 ;   ;Prepmt. Line Amount ;Decimal       ;CaptionML=ENU=Prepmt. Line Amount;
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 111 ;   ;Prepmt. Amt. Inv.   ;Decimal       ;CaptionML=ENU=Prepmt. Amt. Inv.;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 112 ;   ;Prepmt. Amt. Incl. VAT;Decimal     ;CaptionML=ENU=Prepmt. Amt. Incl. VAT;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 113 ;   ;Prepayment Amount   ;Decimal       ;CaptionML=ENU=Prepayment Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 114 ;   ;Prepmt. VAT Base Amt.;Decimal      ;CaptionML=ENU=Prepmt. VAT Base Amt.;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 115 ;   ;Prepayment VAT %    ;Decimal       ;CaptionML=ENU=Prepayment VAT %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 116 ;   ;Prepmt. VAT Calc. Type;Option      ;CaptionML=ENU=Prepmt. VAT Calc. Type;
                                                   OptionCaptionML=ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 117 ;   ;Prepayment VAT Identifier;Code10   ;CaptionML=ENU=Prepayment VAT Identifier;
                                                   Editable=No }
    { 118 ;   ;Prepayment Tax Area Code;Code20    ;TableRelation="Tax Area";
                                                   CaptionML=ENU=Prepayment Tax Area Code }
    { 119 ;   ;Prepayment Tax Liable;Boolean      ;CaptionML=ENU=Prepayment Tax Liable }
    { 120 ;   ;Prepayment Tax Group Code;Code10   ;TableRelation="Tax Group";
                                                   CaptionML=ENU=Prepayment Tax Group Code }
    { 121 ;   ;Prepmt Amt to Deduct;Decimal       ;CaptionML=ENU=Prepmt Amt to Deduct;
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 122 ;   ;Prepmt Amt Deducted ;Decimal       ;CaptionML=ENU=Prepmt Amt Deducted;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 123 ;   ;Prepayment Line     ;Boolean       ;CaptionML=ENU=Prepayment Line;
                                                   Editable=No }
    { 124 ;   ;Prepmt. Amount Inv. Incl. VAT;Decimal;
                                                   CaptionML=ENU=Prepmt. Amount Inv. Incl. VAT;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 129 ;   ;Prepmt. Amount Inv. (LCY);Decimal  ;CaptionML=ENU=Prepmt. Amount Inv. (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 130 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=ENU=IC Partner Code }
    { 135 ;   ;Prepayment VAT Difference;Decimal  ;CaptionML=ENU=Prepayment VAT Difference;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 136 ;   ;Prepmt VAT Diff. to Deduct;Decimal ;CaptionML=ENU=Prepmt VAT Diff. to Deduct;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 137 ;   ;Prepmt VAT Diff. Deducted;Decimal  ;CaptionML=ENU=Prepmt VAT Diff. Deducted;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=ENU=Job Task No. }
    { 1002;   ;Job Line Type       ;Option        ;CaptionML=ENU=Job Line Type;
                                                   OptionCaptionML=ENU=" ,Schedule,Contract,Both Schedule and Contract";
                                                   OptionString=[ ,Schedule,Contract,Both Schedule and Contract] }
    { 1003;   ;Job Unit Price      ;Decimal       ;CaptionML=ENU=Job Unit Price;
                                                   BlankZero=Yes }
    { 1004;   ;Job Total Price     ;Decimal       ;CaptionML=ENU=Job Total Price;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1005;   ;Job Line Amount     ;Decimal       ;CaptionML=ENU=Job Line Amount;
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1006;   ;Job Line Discount Amount;Decimal   ;CaptionML=ENU=Job Line Discount Amount;
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1007;   ;Job Line Discount % ;Decimal       ;CaptionML=ENU=Job Line Discount %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   BlankZero=Yes }
    { 1008;   ;Job Unit Price (LCY);Decimal       ;CaptionML=ENU=Job Unit Price (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1009;   ;Job Total Price (LCY);Decimal      ;CaptionML=ENU=Job Total Price (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1010;   ;Job Line Amount (LCY);Decimal      ;CaptionML=ENU=Job Line Amount (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1011;   ;Job Line Disc. Amount (LCY);Decimal;CaptionML=ENU=Job Line Disc. Amount (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1012;   ;Job Currency Factor ;Decimal       ;CaptionML=ENU=Job Currency Factor;
                                                   BlankZero=Yes }
    { 1013;   ;Job Currency Code   ;Code20        ;CaptionML=ENU=Job Currency Code }
    { 5401;   ;Prod. Order No.     ;Code20        ;TableRelation="Production Order".No. WHERE (Status=CONST(Released));
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Prod. Order No. }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=ENU=Variant Code }
    { 5403;   ;Bin Code            ;Code20        ;OnValidate=VAR
                                                                WMSManagement@1000 : Codeunit 7302;
                                                              BEGIN
                                                              END;

                                                   OnLookup=VAR
                                                              WMSManagement@1000 : Codeunit 7302;
                                                              BinCode@1001 : Code[20];
                                                            BEGIN
                                                            END;

                                                   CaptionML=ENU=Bin Code }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=ENU=Qty. per Unit of Measure;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   OnValidate=VAR
                                                                UnitOfMeasureTranslation@1000 : Record 5402;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Unit of Measure Code }
    { 5415;   ;Quantity (Base)     ;Decimal       ;CaptionML=ENU=Quantity (Base);
                                                   DecimalPlaces=0:5 }
    { 5416;   ;Outstanding Qty. (Base);Decimal    ;CaptionML=ENU=Outstanding Qty. (Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5417;   ;Qty. to Invoice (Base);Decimal     ;CaptionML=ENU=Qty. to Invoice (Base);
                                                   DecimalPlaces=0:5 }
    { 5418;   ;Qty. to Receive (Base);Decimal     ;CaptionML=ENU=Qty. to Receive (Base);
                                                   DecimalPlaces=0:5 }
    { 5458;   ;Qty. Rcd. Not Invoiced (Base);Decimal;
                                                   CaptionML=ENU=Qty. Rcd. Not Invoiced (Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5460;   ;Qty. Received (Base);Decimal       ;CaptionML=ENU=Qty. Received (Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5461;   ;Qty. Invoiced (Base);Decimal       ;CaptionML=ENU=Qty. Invoiced (Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5495;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source Type=CONST(39),
                                                                                                                Source Subtype=FIELD(Document Type),
                                                                                                                Source ID=FIELD(Document No.),
                                                                                                                Source Ref. No.=FIELD(Line No.),
                                                                                                                Reservation Status=CONST(Reservation)));
                                                   CaptionML=ENU=Reserved Qty. (Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5600;   ;FA Posting Date     ;Date          ;CaptionML=ENU=FA Posting Date }
    { 5601;   ;FA Posting Type     ;Option        ;CaptionML=ENU=FA Posting Type;
                                                   OptionCaptionML=ENU=" ,Acquisition Cost,Maintenance";
                                                   OptionString=[ ,Acquisition Cost,Maintenance] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   CaptionML=ENU=Depreciation Book Code }
    { 5603;   ;Salvage Value       ;Decimal       ;CaptionML=ENU=Salvage Value;
                                                   AutoFormatType=1 }
    { 5605;   ;Depr. until FA Posting Date;Boolean;CaptionML=ENU=Depr. until FA Posting Date }
    { 5606;   ;Depr. Acquisition Cost;Boolean     ;CaptionML=ENU=Depr. Acquisition Cost }
    { 5609;   ;Maintenance Code    ;Code10        ;TableRelation=Maintenance;
                                                   CaptionML=ENU=Maintenance Code }
    { 5610;   ;Insurance No.       ;Code20        ;TableRelation=Insurance;
                                                   CaptionML=ENU=Insurance No. }
    { 5611;   ;Budgeted FA No.     ;Code20        ;TableRelation="Fixed Asset";
                                                   CaptionML=ENU=Budgeted FA No. }
    { 5612;   ;Duplicate in Depreciation Book;Code10;
                                                   TableRelation="Depreciation Book";
                                                   CaptionML=ENU=Duplicate in Depreciation Book }
    { 5613;   ;Use Duplication List;Boolean       ;CaptionML=ENU=Use Duplication List }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=ENU=Responsibility Center;
                                                   Editable=No }
    { 5705;   ;Cross-Reference No. ;Code20        ;OnValidate=VAR
                                                                ReturnedCrossRef@1000 : Record 5717;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Cross-Reference No. }
    { 5706;   ;Unit of Measure (Cross Ref.);Code10;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=ENU=Unit of Measure (Cross Ref.) }
    { 5707;   ;Cross-Reference Type;Option        ;CaptionML=ENU=Cross-Reference Type;
                                                   OptionCaptionML=ENU=" ,Customer,Vendor,Bar Code";
                                                   OptionString=[ ,Customer,Vendor,Bar Code] }
    { 5708;   ;Cross-Reference Type No.;Code30    ;CaptionML=ENU=Cross-Reference Type No. }
    { 5709;   ;Item Category Code  ;Code10        ;TableRelation="Item Category";
                                                   CaptionML=ENU=Item Category Code }
    { 5710;   ;Nonstock            ;Boolean       ;CaptionML=ENU=Nonstock }
    { 5711;   ;Purchasing Code     ;Code10        ;TableRelation=Purchasing;
                                                   CaptionML=ENU=Purchasing Code }
    { 5712;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   CaptionML=ENU=Product Group Code }
    { 5713;   ;Special Order       ;Boolean       ;CaptionML=ENU=Special Order }
    { 5714;   ;Special Order Sales No.;Code20     ;TableRelation=IF (Special Order=CONST(Yes)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=ENU=Special Order Sales No. }
    { 5715;   ;Special Order Sales Line No.;Integer;
                                                   TableRelation=IF (Special Order=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                              Document No.=FIELD(Special Order Sales No.));
                                                   CaptionML=ENU=Special Order Sales Line No. }
    { 5750;   ;Whse. Outstanding Qty. (Base);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(39),
                                                                                                                             Source Subtype=FIELD(Document Type),
                                                                                                                             Source No.=FIELD(Document No.),
                                                                                                                             Source Line No.=FIELD(Line No.)));
                                                   CaptionML=ENU=Whse. Outstanding Qty. (Base);
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5752;   ;Completely Received ;Boolean       ;CaptionML=ENU=Completely Received;
                                                   Editable=No }
    { 5790;   ;Requested Receipt Date;Date        ;CaptionML=ENU=Requested Receipt Date }
    { 5791;   ;Promised Receipt Date;Date         ;CaptionML=ENU=Promised Receipt Date }
    { 5792;   ;Lead Time Calculation;DateFormula  ;CaptionML=ENU=Lead Time Calculation }
    { 5793;   ;Inbound Whse. Handling Time;DateFormula;
                                                   CaptionML=ENU=Inbound Whse. Handling Time }
    { 5794;   ;Planned Receipt Date;Date          ;CaptionML=ENU=Planned Receipt Date }
    { 5795;   ;Order Date          ;Date          ;CaptionML=ENU=Order Date }
    { 5800;   ;Allow Item Charge Assignment;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=ENU=Allow Item Charge Assignment }
    { 5801;   ;Qty. to Assign      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Charge Assignment (Purch)"."Qty. to Assign" WHERE (Document Type=FIELD(Document Type),
                                                                                                                            Document No.=FIELD(Document No.),
                                                                                                                            Document Line No.=FIELD(Line No.)));
                                                   CaptionML=ENU=Qty. to Assign;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5802;   ;Qty. Assigned       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Charge Assignment (Purch)"."Qty. Assigned" WHERE (Document Type=FIELD(Document Type),
                                                                                                                           Document No.=FIELD(Document No.),
                                                                                                                           Document Line No.=FIELD(Line No.)));
                                                   CaptionML=ENU=Qty. Assigned;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5803;   ;Return Qty. to Ship ;Decimal       ;CaptionML=ENU=Return Qty. to Ship;
                                                   DecimalPlaces=0:5 }
    { 5804;   ;Return Qty. to Ship (Base);Decimal ;CaptionML=ENU=Return Qty. to Ship (Base);
                                                   DecimalPlaces=0:5 }
    { 5805;   ;Return Qty. Shipped Not Invd.;Decimal;
                                                   CaptionML=ENU=Return Qty. Shipped Not Invd.;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5806;   ;Ret. Qty. Shpd Not Invd.(Base);Decimal;
                                                   CaptionML=ENU=Ret. Qty. Shpd Not Invd.(Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5807;   ;Return Shpd. Not Invd.;Decimal     ;OnValidate=VAR
                                                                Currency2@1000 : Record 4;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Return Shpd. Not Invd.;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 5808;   ;Return Shpd. Not Invd. (LCY);Decimal;
                                                   CaptionML=ENU=Return Shpd. Not Invd. (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5809;   ;Return Qty. Shipped ;Decimal       ;CaptionML=ENU=Return Qty. Shipped;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5810;   ;Return Qty. Shipped (Base);Decimal ;CaptionML=ENU=Return Qty. Shipped (Base);
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 6600;   ;Return Shipment No. ;Code20        ;CaptionML=ENU=Return Shipment No.;
                                                   Editable=No }
    { 6601;   ;Return Shipment Line No.;Integer   ;CaptionML=ENU=Return Shipment Line No.;
                                                   Editable=No }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   CaptionML=ENU=Return Reason Code }
    { 54240;  ;Committed           ;Boolean        }
    { 54241;  ;Expense Code        ;Code10        ;TableRelation=Stations.Code }
    { 54242;  ;Asset No.           ;Code10        ;TableRelation="Fixed Asset".No. }
    { 54243;  ;Specifications      ;Integer        }
    { 54244;  ;PRF No              ;Code20         }
    { 54245;  ;PRF Line No.        ;Integer        }
    { 54246;  ;Qty Received        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Rcpt. Line".Quantity WHERE (Document No.=FIELD(Document No.),
                                                                                                       Line No.=FIELD(Line No.)));
                                                   Description=if quantity received=quantity then the lines have been completely received }
    { 54353;  ;Extended Order Description;Text150  }
    { 99000750;;Routing No.        ;Code20        ;TableRelation="Routing Header";
                                                   CaptionML=ENU=Routing No. }
    { 99000751;;Operation No.      ;Code10        ;TableRelation="Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                                                                   Prod. Order No.=FIELD(Prod. Order No.),
                                                                                                                   Routing No.=FIELD(Routing No.));
                                                   OnValidate=VAR
                                                                ProdOrderRtngLine@1000 : Record 5409;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Operation No. }
    { 99000752;;Work Center No.    ;Code20        ;TableRelation="Work Center";
                                                   CaptionML=ENU=Work Center No. }
    { 99000753;;Finished           ;Boolean       ;CaptionML=ENU=Finished }
    { 99000754;;Prod. Order Line No.;Integer      ;TableRelation="Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..),
                                                                                                      Prod. Order No.=FIELD(Prod. Order No.));
                                                   CaptionML=ENU=Prod. Order Line No. }
    { 99000755;;Overhead Rate      ;Decimal       ;CaptionML=ENU=Overhead Rate;
                                                   DecimalPlaces=0:5 }
    { 99000756;;MPS Order          ;Boolean       ;CaptionML=ENU=MPS Order }
    { 99000757;;Planning Flexibility;Option       ;CaptionML=ENU=Planning Flexibility;
                                                   OptionCaptionML=ENU=Unlimited,None;
                                                   OptionString=Unlimited,None }
    { 99000758;;Safety Lead Time   ;DateFormula   ;CaptionML=ENU=Safety Lead Time }
    { 99000759;;Routing Reference No.;Integer     ;CaptionML=ENU=Routing Reference No. }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Line No.     ;SumIndexFields=Amount,Amount Including VAT;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Document No.,Line No.,Document Type      }
    {    ;Document Type,Type,No.,Variant Code,Drop Shipment,Location Code,Expected Receipt Date;
                                                   SumIndexFields=Outstanding Qty. (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Document Type,Pay-to Vendor No.,Currency Code;
                                                   SumIndexFields=Outstanding Amount,Amt. Rcd. Not Invoiced,Outstanding Amount (LCY),Amt. Rcd. Not Invoiced (LCY);
                                                   MaintainSIFTIndex=No }
    { No ;Document Type,Type,No.,Variant Code,Drop Shipment,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Location Code,Expected Receipt Date;
                                                   SumIndexFields=Outstanding Qty. (Base);
                                                   KeyGroups=Item(Dim);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    { No ;Document Type,Pay-to Vendor No.,Shortcut Dimension 1 Code,Shortcut Dimension 2 Code,Currency Code;
                                                   SumIndexFields=Outstanding Amount,Amt. Rcd. Not Invoiced,Outstanding Amount (LCY),Amt. Rcd. Not Invoiced (LCY);
                                                   KeyGroups=Vend(Dim);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Document Type,Blanket Order No.,Blanket Order Line No.;
                                                   KeyGroups=SOP(Blank) }
    {    ;Document Type,Type,Prod. Order No.,Prod. Order Line No.,Routing No.,Operation No.;
                                                   KeyGroups=Item(MFG) }
    {    ;Document Type,Document No.,Location Code }
    {    ;Document Type,Receipt No.,Receipt Line No. }
    {    ;Type,No.,Variant Code,Drop Shipment,Location Code,Document Type,Expected Receipt Date;
                                                   MaintainSQLIndex=No }
    {    ;Document Type,Buy-from Vendor No.        }
    {    ;Document Type,Job No.,Job Task No.      ;SumIndexFields=Outstanding Amount (LCY),Amt. Rcd. Not Invoiced (LCY) }
    {    ;Committed,Expected Receipt Date         ;SumIndexFields=Amount,Amount Including VAT }
    {    ;Document No.,Type,No.,Line No.           }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You cannot rename a %1.';
      Text001@1001 : TextConst 'ENU=You cannot change %1 because the order line is associated with sales order %2.';
      Text002@1002 : TextConst 'ENU=Prices including VAT cannot be calculated when %1 is %2.';
      Text003@1003 : TextConst 'ENU=You cannot purchase resources.';
      Text004@1004 : TextConst 'ENU=must not be less than %1';
      Text006@1005 : TextConst 'ENU=You cannot invoice more than %1 units.';
      Text007@1006 : TextConst 'ENU=You cannot invoice more than %1 base units.';
      Text008@1007 : TextConst 'ENU=You cannot receive more than %1 units.';
      Text009@1008 : TextConst 'ENU=You cannot receive more than %1 base units.';
      Text010@1009 : TextConst 'ENU=You cannot change %1 when %2 is %3.';
      Text011@1010 : TextConst 'ENU=" must be 0 when %1 is %2"';
      Text012@1011 : TextConst 'ENU="must not be specified when %1 = %2"';
      Text014@1012 : TextConst 'ENU=Change %1 from %2 to %3?';
      Text016@1014 : TextConst 'ENU="%1 is required for %2 = %3."';
      Text017@1015 : TextConst 'ENU=\The entered information will be disregarded by warehouse operations.';
      Text018@1016 : TextConst 'ENU=%1 %2 is earlier than the work date %3.';
      Text020@1018 : TextConst 'ENU=You cannot return more than %1 units.';
      Text021@1019 : TextConst 'ENU=You cannot return more than %1 base units.';
      Text022@1020 : TextConst 'ENU=You cannot change %1, if item charge is already posted.';
      Text023@1072 : TextConst 'ENU=You cannot change the %1 when the %2 has been filled in.';
      Text029@1077 : TextConst 'ENU=must be positive.';
      Text030@1076 : TextConst 'ENU=must be negative.';
      Text031@1056 : TextConst 'ENU=You cannot define item tracking on this line because it is linked to production order %1.';
      Text032@1017 : TextConst 'ENU=%1 must not be greater than %2.';
      Text033@1078 : TextConst 'ENU="Warehouse "';
      Text034@1079 : TextConst 'ENU="Inventory "';
      Text035@1048 : TextConst 'ENU=%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.';
      Text036@1081 : TextConst 'ENU=You must cancel the existing approval for this document to be able to change the %1 field.';
      Text037@1082 : TextConst 'ENU=cannot be %1.';
      Text038@1083 : TextConst 'ENU=cannot be less than %1.';
      Text039@1084 : TextConst 'ENU=cannot be more than %1.';
      Text99000000@1021 : TextConst 'ENU=You cannot change %1 when the purchase order is associated to a production order.';
      Text042@1088 : TextConst 'ENU=You cannot return more than the %1 units that you have received for %2 %3.';
      Text043@1089 : TextConst 'ENU=must be positive when %1 is not 0.';
      Text044@1080 : TextConst 'ENU=You cannot change %1 because this purchase order is associated with %2 %3.';
      GLAcc@1102756000 : Record 15;
      Item@1102756001 : Record 27;
      FA@1102756002 : Record 5600;
      CItem@1102756003 : Record 5800;

    BEGIN
    END.
  }
}

