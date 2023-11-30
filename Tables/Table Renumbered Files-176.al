OBJECT table 17294 Accounts Applications Details
{
  OBJECT-PROPERTIES
  {
    Date=02/17/23;
    Time=[ 5:02:00 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Permissions=TableData 25=r;
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 PurchSetup.GET;
                 PurchSetup.TESTFIELD(PurchSetup."Applicants Nos.");
                 NoSeriesMgt.InitSeries(PurchSetup."Applicants Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;
               IF "Invoice Disc. Code" = '' THEN
                 "Invoice Disc. Code" := "No.";

               "Created By":=USERID;

               {F UsersID.GET(USERID) THEN BEGIN
               "Global Dimension 2 Code":=UsersID.Branch;
               VALIDATE("Global Dimension 2 Code");
               END;}


               {
               DimMgt.UpdateDefaultDim(
                 DATABASE::Vendor,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
               }
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;

               IF (Name <> xRec.Name) OR
                  ("Search Name" <> xRec."Search Name") OR
                  ("Name 2" <> xRec."Name 2") OR
                  (Address <> xRec.Address) OR
                  ("Address 2" <> xRec."Address 2") OR
                  (City <> xRec.City) OR
                  ("Phone No." <> xRec."Phone No.") OR
                  ("Telex No." <> xRec."Telex No.") OR
                  ("Territory Code" <> xRec."Territory Code") OR
                  ("Currency Code" <> xRec."Currency Code") OR
                  ("Language Code" <> xRec."Language Code") OR
                  ("Purchaser Code" <> xRec."Purchaser Code") OR
                  ("Country/Region Code" <> xRec."Country/Region Code") OR
                  ("Fax No." <> xRec."Fax No.") OR
                  ("Telex Answer Back" <> xRec."Telex Answer Back") OR
                  ("VAT Registration No." <> xRec."VAT Registration No.") OR
                  ("Post Code" <> xRec."Post Code") OR
                  (County <> xRec.County) OR
                  ("E-Mail" <> xRec."E-Mail") OR
                  ("Home Page" <> xRec."Home Page")
               THEN BEGIN
                 MODIFY;

               END;
             END;

    OnDelete=VAR
               ItemVendor@1000 : Record 99;
               PurchPrice@1001 : Record 7012;
               PurchLineDiscount@1002 : Record 7014;
             BEGIN


               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Vendor);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;


               VendBankAcc.SETRANGE("Vendor No.","No.");
               VendBankAcc.DELETEALL;

               OrderAddr.SETRANGE("Vendor No.","No.");
               OrderAddr.DELETEALL;

               ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
               ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
               ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
               ItemCrossReference.DELETEALL;

               PurchOrderLine.SETCURRENTKEY("Document Type","Pay-to Vendor No.");
               PurchOrderLine.SETFILTER(
                 "Document Type",'%1|%2',
                 PurchOrderLine."Document Type"::Order,
                 PurchOrderLine."Document Type"::"Return Order");
               PurchOrderLine.SETRANGE("Pay-to Vendor No.","No.");
               IF PurchOrderLine.FIND('-') THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",
                   PurchOrderLine."Document Type");

               PurchOrderLine.SETRANGE("Pay-to Vendor No.");
               PurchOrderLine.SETRANGE("Buy-from Vendor No.","No.");
               IF PurchOrderLine.FIND('-') THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.");


               DimMgt.DeleteDefaultDim(DATABASE::Vendor,"No.");

               ServiceItem.SETRANGE("Vendor No.","No.");
               ServiceItem.MODIFYALL("Vendor No.",'');

               ItemVendor.SETRANGE("Vendor No.","No.");
               ItemVendor.DELETEALL(TRUE);

               PurchPrice.SETCURRENTKEY("Vendor No.");
               PurchPrice.SETRANGE("Vendor No.","No.");
               PurchPrice.DELETEALL(TRUE);

               PurchLineDiscount.SETCURRENTKEY("Vendor No.");
               PurchLineDiscount.SETRANGE("Vendor No.","No.");
               PurchLineDiscount.DELETEALL(TRUE);

               PurchLineDiscount.SETCURRENTKEY("Vendor No.");
               PurchLineDiscount.SETRANGE("Vendor No.","No.");
               PurchLineDiscount.DELETEALL(TRUE);
             END;

    OnRename=BEGIN
               "Last Date Modified" := TODAY;
             END;

    CaptionML=ENU=Accounts Applications;
    LookupPageID=Page51516290;
    DrillDownPageID=Page51516290;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;AltSearchField=Search Name;
                                                   OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  NoSeriesMgt.TestManual(PurchSetup."Applicants Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                                IF "Invoice Disc. Code" = '' THEN
                                                                  "Invoice Disc. Code" := "No.";
                                                              END;

                                                   CaptionML=ENU=No. }
    { 2   ;   ;Name                ;Text50        ;OnValidate=BEGIN
                                                                Name:=UPPERCASE(Name);

                                                                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Name;
                                                              END;

                                                   CaptionML=ENU=Name }
    { 3   ;   ;Search Name         ;Code50        ;CaptionML=ENU=Search Name }
    { 4   ;   ;Name 2              ;Text50        ;CaptionML=ENU=Name 2 }
    { 5   ;   ;Address             ;Text50        ;CaptionML=ENU=Address }
    { 6   ;   ;Address 2           ;Text50        ;CaptionML=ENU=Address 2 }
    { 7   ;   ;City                ;Text30        ;OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                                //PostCode.ValidateCity(City,"Post Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              //PostCode.LookUpCity(City,"Post Code",TRUE);
                                                            END;

                                                   CaptionML=ENU=City }
    { 8   ;   ;Contact             ;Text50        ;CaptionML=ENU=Contact }
    { 9   ;   ;Phone No.           ;Text30        ;CaptionML=ENU=Phone No. }
    { 10  ;   ;Telex No.           ;Text20        ;CaptionML=ENU=Telex No. }
    { 14  ;   ;Our Account No.     ;Text20        ;CaptionML=ENU=Our Account No. }
    { 15  ;   ;Territory Code      ;Code10        ;TableRelation=Territory;
                                                   CaptionML=ENU=Territory Code }
    { 16  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 17  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 19  ;   ;Budgeted Amount     ;Decimal       ;CaptionML=ENU=Budgeted Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 21  ;   ;Vendor Posting Group;Code10        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=ENU=Vendor Posting Group }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code }
    { 24  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=ENU=Language Code }
    { 26  ;   ;Statistics Group    ;Integer       ;CaptionML=ENU=Statistics Group }
    { 27  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=ENU=Payment Terms Code }
    { 28  ;   ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   CaptionML=ENU=Fin. Charge Terms Code }
    { 29  ;   ;Purchaser Code      ;Code10        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=ENU=Purchaser Code }
    { 30  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=ENU=Shipment Method Code }
    { 31  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   CaptionML=ENU=Shipping Agent Code }
    { 33  ;   ;Invoice Disc. Code  ;Code20        ;TableRelation=Vendor;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Invoice Disc. Code }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=ENU=Country/Region Code }
    { 38  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Vendor),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=ENU=Comment;
                                                   Editable=No }
    { 39  ;   ;Blocked             ;Option        ;CaptionML=ENU=Blocked;
                                                   OptionCaptionML=ENU=" ,Payment,All";
                                                   OptionString=[ ,Payment,All] }
    { 45  ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=ENU=Pay-to Vendor No. }
    { 46  ;   ;Priority            ;Integer       ;CaptionML=ENU=Priority }
    { 47  ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=ENU=Payment Method Code }
    { 54  ;   ;Last Date Modified  ;Date          ;CaptionML=ENU=Last Date Modified;
                                                   Editable=No }
    { 55  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Date Filter }
    { 56  ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Filter;
                                                   CaptionClass='1,3,1' }
    { 57  ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Filter;
                                                   CaptionClass='1,3,2' }
    { 58  ;   ;Balance             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Balance;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Balance (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Net Change;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Net Change (LCY)    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Net Change (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Purchases (LCY)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Vendor Ledger Entry"."Purchase (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Purchases (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 64  ;   ;Inv. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Vendor Ledger Entry"."Inv. Discount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                       Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Inv. Discounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 65  ;   ;Pmt. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount..'Payment Discount (VAT Adjustment)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Pmt. Discounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 66  ;   ;Balance Due         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Posting Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                Initial Entry Due Date=FIELD(Date Filter),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Balance Due;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 67  ;   ;Balance Due (LCY)   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Posting Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                        Initial Entry Due Date=FIELD(Date Filter),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Balance Due (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 69  ;   ;Payments            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Payment),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Vendor No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Payments;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Invoice Amounts     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Invoice Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 71  ;   ;Cr. Memo Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Vendor No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Cr. Memo Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 72  ;   ;Finance Charge Memo Amounts;Decimal;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Finance Charge Memo Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 74  ;   ;Payments (LCY)      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Payment),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Vendor No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Payments (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 75  ;   ;Inv. Amounts (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Inv. Amounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 76  ;   ;Cr. Memo Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Vendor No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Cr. Memo Amounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 77  ;   ;Fin. Charge Memo Amounts (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Fin. Charge Memo Amounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 78  ;   ;Outstanding Orders  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount" WHERE (Document Type=CONST(Order),
                                                                                                               Pay-to Vendor No.=FIELD(No.),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Orders;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 79  ;   ;Amt. Rcd. Not Invoiced;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amt. Rcd. Not Invoiced" WHERE (Document Type=CONST(Order),
                                                                                                                   Pay-to Vendor No.=FIELD(No.),
                                                                                                                   Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                   Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                   Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Amt. Rcd. Not Invoiced;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 80  ;   ;Application Method  ;Option        ;CaptionML=ENU=Application Method;
                                                   OptionCaptionML=ENU=Manual,Apply to Oldest;
                                                   OptionString=Manual,Apply to Oldest }
    { 82  ;   ;Prices Including VAT;Boolean       ;OnValidate=VAR
                                                                PurchPrice@1000 : Record 7012;
                                                                Item@1001 : Record 27;
                                                                VATPostingSetup@1002 : Record 325;
                                                                Currency@1003 : Record 4;
                                                              BEGIN
                                                                PurchPrice.SETCURRENTKEY("Vendor No.");
                                                                PurchPrice.SETRANGE("Vendor No.","No.");
                                                                IF PurchPrice.FIND('-') THEN BEGIN
                                                                  IF VATPostingSetup.GET('','') THEN;
                                                                  IF CONFIRM(
                                                                       STRSUBSTNO(
                                                                         Text002,
                                                                         FIELDCAPTION("Prices Including VAT"),"Prices Including VAT",PurchPrice.TABLECAPTION),TRUE)
                                                                  THEN
                                                                    REPEAT
                                                                      IF PurchPrice."Item No." <> Item."No." THEN
                                                                        Item.GET(PurchPrice."Item No.");
                                                                      IF ("VAT Bus. Posting Group" <> VATPostingSetup."VAT Bus. Posting Group") OR
                                                                         (Item."VAT Prod. Posting Group" <> VATPostingSetup."VAT Prod. Posting Group")
                                                                      THEN
                                                                        VATPostingSetup.GET("VAT Bus. Posting Group",Item."VAT Prod. Posting Group");
                                                                      IF PurchPrice."Currency Code" = '' THEN
                                                                        Currency.InitRoundingPrecision
                                                                      ELSE
                                                                        IF PurchPrice."Currency Code" <> Currency.Code THEN
                                                                          Currency.GET(PurchPrice."Currency Code");
                                                                      IF VATPostingSetup."VAT %" <> 0 THEN BEGIN
                                                                        IF "Prices Including VAT" THEN
                                                                          PurchPrice."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchPrice."Direct Unit Cost" * (1 + VATPostingSetup."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision")
                                                                        ELSE
                                                                          PurchPrice."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchPrice."Direct Unit Cost" / (1 + VATPostingSetup."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision");
                                                                        PurchPrice.MODIFY;
                                                                      END;
                                                                    UNTIL PurchPrice.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Prices Including VAT }
    { 84  ;   ;Fax No.             ;Text30        ;CaptionML=ENU=Fax No. }
    { 85  ;   ;Telex Answer Back   ;Text20        ;CaptionML=ENU=Telex Answer Back }
    { 86  ;   ;VAT Registration No.;Text20        ;OnValidate=VAR
                                                                VATRegNoFormat@1000 : Record 381;
                                                              BEGIN
                                                                VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor);
                                                              END;

                                                   CaptionML=ENU=VAT Registration No. }
    { 88  ;   ;Gen. Bus. Posting Group;Code10     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=ENU=Gen. Bus. Posting Group }
    { 89  ;   ;Picture             ;BLOB          ;CaptionML=ENU=Picture;
                                                   SubType=Bitmap }
    { 91  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Post Code }
    { 92  ;   ;County              ;Text30        ;CaptionML=ENU=County }
    { 97  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(<>Application),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Debit Amount;
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 98  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Entry Type=FILTER(<>Application),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Credit Amount;
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 99  ;   ;Debit Amount (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                             Entry Type=FILTER(<>Application),
                                                                                                                             Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                             Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                             Posting Date=FIELD(Date Filter),
                                                                                                                             Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Debit Amount (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 100 ;   ;Credit Amount (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                              Entry Type=FILTER(<>Application),
                                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Credit Amount (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 102 ;   ;E-Mail              ;Text80        ;CaptionML=ENU=E-Mail }
    { 103 ;   ;Home Page           ;Text80        ;CaptionML=ENU=Home Page }
    { 104 ;   ;Reminder Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Reminder Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 105 ;   ;Reminder Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Reminder Amounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 107 ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 108 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=ENU=Tax Area Code }
    { 109 ;   ;Tax Liable          ;Boolean       ;CaptionML=ENU=Tax Liable }
    { 110 ;   ;VAT Bus. Posting Group;Code10      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=ENU=VAT Bus. Posting Group }
    { 111 ;   ;Currency Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Currency;
                                                   CaptionML=ENU=Currency Filter }
    { 113 ;   ;Outstanding Orders (LCY);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                     Pay-to Vendor No.=FIELD(No.),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Orders (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 114 ;   ;Amt. Rcd. Not Invoiced (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                         Pay-to Vendor No.=FIELD(No.),
                                                                                                                         Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                         Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                         Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Amt. Rcd. Not Invoiced (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 116 ;   ;Block Payment Tolerance;Boolean    ;CaptionML=ENU=Block Payment Tolerance }
    { 117 ;   ;Pmt. Disc. Tolerance (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount Tolerance|'Payment Discount Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Pmt. Disc. Tolerance (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 118 ;   ;Pmt. Tolerance (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Tolerance|'Payment Tolerance (VAT Adjustment)'|'Payment Tolerance (VAT Excl.)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Pmt. Tolerance (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 119 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   OnValidate=VAR
                                                                VendLedgEntry@1001 : Record 25;
                                                                AccountingPeriod@1000 : Record 50;
                                                                ICPartner@1002 : Record 413;
                                                              BEGIN
                                                                IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
                                                                  VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
                                                                  VendLedgEntry.SETRANGE("Vendor No.","No.");
                                                                  AccountingPeriod.SETRANGE(Closed,FALSE);
                                                                  IF AccountingPeriod.FIND('-') THEN
                                                                    VendLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                                                                  IF VendLedgEntry.FIND('-') THEN
                                                                    IF NOT CONFIRM(Text009,FALSE,TABLECAPTION) THEN
                                                                      "IC Partner Code" := xRec."IC Partner Code";

                                                                  VendLedgEntry.RESET;
                                                                  IF NOT VendLedgEntry.SETCURRENTKEY("Vendor No.",Open) THEN
                                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.");
                                                                  VendLedgEntry.SETRANGE("Vendor No.","No.");
                                                                  VendLedgEntry.SETRANGE(Open,TRUE);
                                                                  IF VendLedgEntry.FIND('+') THEN
                                                                    ERROR(Text010,FIELDCAPTION("IC Partner Code"),TABLECAPTION);
                                                                END;

                                                                IF "IC Partner Code" <> '' THEN BEGIN
                                                                  ICPartner.GET("IC Partner Code");
                                                                  IF (ICPartner."Vendor No." <> '') AND (ICPartner."Vendor No." <> "No.") THEN
                                                                    ERROR(Text008,FIELDCAPTION("IC Partner Code"),"IC Partner Code",TABLECAPTION,ICPartner."Vendor No.");
                                                                  ICPartner."Vendor No." := "No.";
                                                                  ICPartner.MODIFY;
                                                                END;

                                                                IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
                                                                  ICPartner."Vendor No." := '';
                                                                  ICPartner.MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=IC Partner Code }
    { 120 ;   ;Refunds             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Refund),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Refunds }
    { 121 ;   ;Refunds (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Refund),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Refunds (LCY) }
    { 122 ;   ;Other Amounts       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(" "),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Other Amounts }
    { 123 ;   ;Other Amounts (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(" "),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Other Amounts (LCY) }
    { 124 ;   ;Prepayment %        ;Decimal       ;CaptionML=ENU=Prepayment %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 125 ;   ;Outstanding Invoices;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount" WHERE (Document Type=CONST(Invoice),
                                                                                                               Pay-to Vendor No.=FIELD(No.),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Invoices;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 126 ;   ;Outstanding Invoices (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                                                                     Pay-to Vendor No.=FIELD(No.),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Invoices (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5049;   ;Primary Contact No. ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1001 : Record 5050;
                                                                ContBusRel@1000 : Record 5054;
                                                              BEGIN
                                                                Contact := '';
                                                                IF "Primary Contact No." <> '' THEN BEGIN
                                                                  Cont.GET("Primary Contact No.");

                                                                  ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                                  ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                                  ContBusRel.SETRANGE("No.","No.");
                                                                  ContBusRel.FIND('-');

                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text004,Cont."No.",Cont.Name,"No.",Name);

                                                                  IF Cont.Type = Cont.Type::Person THEN
                                                                    Contact := Cont.Name
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusRel@1000 : Record 5054;
                                                            BEGIN
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FIND('-') THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.");

                                                              IF "Primary Contact No." <> '' THEN
                                                                IF Cont.GET("Primary Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN
                                                                VALIDATE("Primary Contact No.",Cont."No.");
                                                            END;

                                                   CaptionML=ENU=Primary Contact No. }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=ENU=Responsibility Center }
    { 5701;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=ENU=Location Code }
    { 5790;   ;Lead Time Calculation;DateFormula  ;CaptionML=ENU=Lead Time Calculation }
    { 7177;   ;No. of Pstd. Receipts;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Rcpt. Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Receipts;
                                                   Editable=No }
    { 7178;   ;No. of Pstd. Invoices;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Inv. Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Invoices;
                                                   Editable=No }
    { 7179;   ;No. of Pstd. Return Shipments;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Shipment Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Return Shipments;
                                                   Editable=No }
    { 7180;   ;No. of Pstd. Credit Memos;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Cr. Memo Hdr." WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Credit Memos;
                                                   Editable=No }
    { 7600;   ;Base Calendar Code  ;Code10        ;TableRelation="Base Calendar";
                                                   CaptionML=ENU=Base Calendar Code }
    { 55019;  ;Debtor Type 2       ;Option        ;OptionString=Vendor Account,FOSA Account }
    { 68000;  ;Debtor Type         ;Option        ;OptionCaptionML=ENU=FOSA Account,Micro Finance;
                                                   OptionString=FOSA Account,Micro Finance }
    { 68001;  ;Staff No            ;Code20         }
    { 68002;  ;ID No.              ;Code50         }
    { 68003;  ;Last Maintenance Date;Date          }
    { 68004;  ;Activate Sweeping Arrangement;Boolean }
    { 68005;  ;Sweeping Balance    ;Decimal        }
    { 68006;  ;Sweep To Account    ;Code30        ;TableRelation=Vendor }
    { 68007;  ;Fixed Deposit Status;Option        ;OptionCaptionML=ENU=" ,Active,Matured,Closed,Not Matured";
                                                   OptionString=[ ,Active,Matured,Closed,Not Matured] }
    { 68008;  ;Call Deposit        ;Boolean        }
    { 68009;  ;Mobile Phone No     ;Code50        ;OnValidate=BEGIN
                                                                {
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."Staff No","Staff No");
                                                                IF Vend.FIND('-') THEN
                                                                Vend.MODIFYALL(Vend."Mobile Phone No","Mobile Phone No");

                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."Staff No","Staff No");
                                                                IF Cust.FIND('-') THEN
                                                                Cust.MODIFYALL(Cust."Mobile Phone No","Mobile Phone No");
                                                                }
                                                              END;
                                                               }
    { 68010;  ;Marital Status      ;Option        ;OptionCaptionML=ENU=" ,Single,Married,Devorced,Widower";
                                                   OptionString=[ ,Single,Married,Devorced,Widower] }
    { 68011;  ;Registration Date   ;Date           }
    { 68012;  ;BOSA Account No     ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                {
                                                                IF ("Micro Single"<>FALSE) OR  ("Micro Group"<>FALSE) THEN
                                                                ERROR('Bosa account No cannot be selected with a micro account');
                                                                }
                                                                //"Debtor Type":="Debtor Type"::"Micro Finance";
                                                                IF Cust.GET("BOSA Account No") THEN BEGIN
                                                                Cust.CALCFIELDS(Cust.Picture,Cust.Signature);
                                                                Name:=Cust.Name;
                                                                "Search Name":=Cust."Search Name";
                                                                Address:=Cust.Address;
                                                                "Address 2":=Cust."Address 2";
                                                                "Staff No":=Cust."Payroll/Staff No";
                                                                "Employer Code":=Cust."Employer Code";
                                                                Section:=Cust."Station/Department";
                                                                "Phone No.":=Cust."Phone No.";
                                                                "Fax No.":=Cust."Fax No.";
                                                                "Post Code":=Cust."Post Code";
                                                                "Country/Region Code" := Cust."Country/Region Code";
                                                                County:=Cust.County;
                                                                "E-Mail":=Cust."E-Mail";
                                                                "ID No.":=Cust."ID No.";
                                                                Picture:=Cust.Picture;
                                                                Gender:=Cust.Gender;
                                                                Signature:=Cust.Signature;
                                                                "Formation/Province":=Cust."Formation/Province";
                                                                "Division/Department":=Cust."Division/Department";
                                                                "Station/Sections":=Cust."Station/Section";
                                                                //"Global Dimension 2 Code":=Cust."Global Dimension 2 Code";
                                                                "Force No.":=Cust."Force No.";
                                                                IF "Account Type" <> 'CHILDREN' THEN
                                                                "Date of Birth":=Cust."Date of Birth";


                                                                NOKApp.RESET;
                                                                NOKApp.SETRANGE(NOKApp."Account No","No.");
                                                                IF NOKApp.FIND('-') THEN
                                                                NOKApp.DELETEALL;


                                                                NOKBOSA.RESET;
                                                                NOKBOSA.SETRANGE(NOKBOSA."Account No","BOSA Account No");
                                                                NOKBOSA.SETRANGE(NOKBOSA.Beneficiary,TRUE);
                                                                IF NOKBOSA.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                NOKApp.INIT;
                                                                NOKApp."Account No":="No.";
                                                                NOKApp.Name:=NOKBOSA.Name;
                                                                NOKApp.Relationship:=NOKBOSA.Relationship;
                                                                NOKApp."Date of Birth":=NOKBOSA."Date of Birth";
                                                                NOKApp.Address:=NOKBOSA.Address;
                                                                NOKApp.Telephone:=NOKBOSA.Telephone;
                                                                NOKApp.Fax:=NOKBOSA.Fax;
                                                                NOKApp.Email:=NOKBOSA.Email;
                                                                NOKApp."ID No.":=NOKBOSA."ID No.";
                                                                NOKApp.INSERT;

                                                                UNTIL NOKBOSA.NEXT = 0;
                                                                END;

                                                                END;


                                                                VendorFDR.RESET;
                                                                VendorFDR.SETRANGE(VendorFDR."BOSA Account No","BOSA Account No");
                                                                VendorFDR.SETRANGE(VendorFDR."Account Type",'WSS');
                                                                IF VendorFDR.FIND('-') THEN
                                                                "Savings Account No.":=VendorFDR."No.";
                                                              END;
                                                               }
    { 68013;  ;Signature           ;BLOB          ;SubType=Bitmap }
    { 68014;  ;Passport No.        ;Code50         }
    { 68015;  ;Employer Code       ;Code20        ;TableRelation="Sacco Employers".Code }
    { 68016;  ;Status              ;Option        ;OnValidate=BEGIN
                                                                IF (Status = Status::Open) OR (Status = Status::"4") THEN
                                                                Blocked:=Blocked::" "
                                                                ELSE
                                                                Blocked:=Blocked::All
                                                              END;

                                                   OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 68017;  ;Account Type        ;Code20        ;TableRelation="Account Types-Saving Products".Code;
                                                   OnValidate=BEGIN
                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                AccountTypes.TESTFIELD(AccountTypes."Posting Group");
                                                                "Vendor Posting Group":=AccountTypes."Posting Group";
                                                                "Allow Multiple Accounts":=AccountTypes."Allow Multiple Accounts";
                                                                IF AccountTypes."Activity Code"=AccountTypes."Activity Code"::FOSA THEN
                                                                "Global Dimension 1 Code":='FOSA'
                                                                ELSE
                                                                "Global Dimension 1 Code":='MICRO';

                                                                IF AccountTypes."Fixed Deposit"=TRUE THEN BEGIN

                                                                "Fixed Deposit":=TRUE;

                                                                END;
                                                                END;

                                                                IF "Account Type" = 'JUNIOR' THEN
                                                                "Date of Birth":=0D;
                                                              END;
                                                               }
    { 68018;  ;Account Category    ;Option        ;OptionCaptionML=ENU=Single,Joint,Corporate,Group;
                                                   OptionString=Single,Joint,Corporate,Group }
    { 68019;  ;FD Marked for Closure;Boolean       }
    { 68020;  ;Last Withdrawal Date;Date           }
    { 68021;  ;Last Overdraft Date ;Date           }
    { 68022;  ;Last Min. Balance Date;Date         }
    { 68023;  ;Last Deposit Date   ;Date           }
    { 68024;  ;Last Transaction Date;Date          }
    { 68025;  ;Date Closed         ;Date           }
    { 68026;  ;Uncleared Cheques   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum(Transactions.Amount WHERE (Account No=FIELD(No.),
                                                                                              Deposited=CONST(Yes),
                                                                                              Cheque Processed=CONST(No))) }
    { 68027;  ;Expected Maturity Date;Date         }
    { 68028;  ;ATM Transactions    ;Decimal        }
    { 68029;  ;Date of Birth       ;Date          ;OnValidate=BEGIN
                                                                 IF "Date of Birth" > TODAY THEN
                                                                 ERROR('Date of birth cannot be greater than today');


                                                                IF "Account Type"<>'JUNIOR' THEN BEGIN
                                                                IF "Date of Birth" <> 0D THEN BEGIN
                                                                IF GenSetUp.GET() THEN BEGIN
                                                                IF CALCDATE(GenSetUp."Min. Member Age","Date of Birth") > TODAY THEN
                                                                ERROR('Applicant bellow the mininmum membership age of %1',GenSetUp."Min. Member Age");
                                                                END;
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 68030;  ;Application Status  ;Option        ;OptionCaptionML=ENU=Pending,Approved,Converted,Rejected;
                                                   OptionString=Pending,Approved,Converted,Rejected }
    { 68031;  ;Application Date    ;Date           }
    { 68032;  ;E-Mail (Personal)   ;Text50         }
    { 68033;  ;Station             ;Code50         }
    { 68034;  ;Home Address        ;Text50         }
    { 68035;  ;Location            ;Text50         }
    { 68036;  ;Sub-Location        ;Text50         }
    { 68037;  ;District            ;Text50         }
    { 68038;  ;Savings Account No. ;Code20        ;TableRelation=Vendor.No. WHERE (BOSA Account No=FIELD(BOSA Account No)) }
    { 68039;  ;Parent Account No.  ;Code20        ;TableRelation=Vendor.No. }
    { 68040;  ;Kin No              ;Code10         }
    { 68041;  ;Section             ;Code20        ;TableRelation=Stations.Code WHERE (Employer Code=FIELD(Employer Code)) }
    { 68042;  ;Signing Instructions;Text250        }
    { 68043;  ;Fixed Deposit Type  ;Code20        ;TableRelation="Fixed Deposit Type".Code;
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Application Date");
                                                                IF FDType.GET("Fixed Deposit Type") THEN BEGIN
                                                                "FD Maturity Date":=CALCDATE(FDType.Duration,"Application Date");

                                                                "FD Duration":=FDType."No. of Months";
                                                                END;
                                                              END;
                                                               }
    { 68044;  ;FD Maturity Date    ;Date           }
    { 68045;  ;Monthly Contribution;Decimal        }
    { 68046;  ;Formation/Province  ;Code20         }
    { 68047;  ;Division/Department ;Code20        ;TableRelation="Member Departments".No. }
    { 68048;  ;Station/Sections    ;Code20        ;TableRelation="Member Section".No. }
    { 68120;  ;Force No.           ;Code20         }
    { 68121;  ;Micro Group         ;Boolean       ;OnValidate=BEGIN
                                                                 IF ("Micro Single"=TRUE) THEN // OR ("BOSA Account No" <> '') THEN
                                                                 ERROR('You cannot select both Micro Single and Micro Group');
                                                                //"Debtor Type":="Debtor Type"::"Micro Finance"
                                                                //END;

                                                                //IF "Micro Group"=FALSE THEN
                                                                //"Debtor Type":="Debtor Type"::"FOSA Account";
                                                              END;
                                                               }
    { 68122;  ;Micro Single        ;Boolean       ;OnValidate=BEGIN
                                                                IF ("Micro Group"=TRUE) THEN //OR ("BOSA Account No" <> '') THEN
                                                                ERROR('You cannot select both Micro Single and Micro Group');

                                                                //"Debtor Type":="Debtor Type"::"Micro Finance";

                                                                //IF "Micro Single"=FALSE THEN
                                                                //"Debtor Type":="Debtor Type"::"FOSA Account";
                                                              END;
                                                               }
    { 68123;  ;Group Code          ;Code10        ;TableRelation=Vendor.No. WHERE (Group Account=CONST(Yes));
                                                   OnValidate=BEGIN
                                                                 IF "Micro Single"<> TRUE THEN
                                                                 ERROR('Can only be used with Micro Credit individual accounts');

                                                                "Global Dimension 1 Code":='MICRO';
                                                              END;
                                                               }
    { 68124;  ;ContactPerson Relation;Code20       }
    { 68125;  ;ContacPerson Occupation;Code20      }
    { 68126;  ;ContacPerson Phone  ;Text30         }
    { 68127;  ;Recruited By        ;Code20        ;TableRelation="Members Register".No. }
    { 68128;  ;Fixed Deposit       ;Boolean        }
    { 68129;  ;Neg. Interest Rate  ;Decimal        }
    { 68130;  ;FD Duration         ;Integer       ;OnValidate=BEGIN

                                                                  "FD Maturity Date":="Application Date"+("FD Duration"*30);
                                                                  MODIFY;
                                                              END;
                                                               }
    { 68131;  ;FD Maturity Instructions;Option    ;OptionCaptionML=ENU=" ,Transfer to Savings,Transfer Interest & Renew,Renew";
                                                   OptionString=[ ,Transfer to Savings,Transfer Interest & Renew,Renew] }
    { 68132;  ;Allow Multiple Accounts;Boolean     }
    { 68133;  ;Sms Notification    ;Boolean        }
    { 68134;  ;Approved By         ;Code30         }
    { 68135;  ;Created By          ;Code30        ;Editable=No }
    { 68136;  ;Expiry Date(Passport);Date          }
    { 68137;  ;Sub-County          ;Code20         }
    { 68138;  ;Contract Expiry Date;Date           }
    { 68139;  ;Source Of Funds     ;Option        ;OptionCaptionML=ENU=,Salary,Business,Pension,Others;
                                                   OptionString=,Salary,Business,Pension,Others }
    { 68140;  ;Employment Type     ;Option        ;OptionCaptionML=ENU=,Self Employed,Employed;
                                                   OptionString=,Self Employed,Employed }
    { 68141;  ;Name of Business    ;Text120        }
    { 68142;  ;Nature of Business  ;Text120        }
    { 68143;  ;Terms And Conditions;Text150        }
    { 68144;  ;Gender              ;Option        ;OnValidate=BEGIN
                                                                {Vend2.RESET;
                                                                Vend2.SETRANGE(Vend2."Staff No","Payroll/Staff No");
                                                                IF Vend2.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Vend2.Gender:=Gender;
                                                                Vend2.MODIFY;
                                                                UNTIL Vend2.NEXT = 0;
                                                                END;
                                                                 }
                                                              END;

                                                   OptionCaptionML=ENU=Male,Female;
                                                   OptionString=[ ,Male,Female] }
    { 68145;  ;Parent Account      ;Code20        ;TableRelation="Members Register".No. }
    { 68146;  ;Child Name          ;Text40         }
    { 68147;  ;Childs Date Of Birth;Date           }
    { 68148;  ;Childs Birth Certificate No;Code20  }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Vendor Posting Group                     }
    {    ;Currency Code                            }
    {    ;Priority                                 }
    {    ;Country/Region Code                      }
    {    ;Gen. Bus. Posting Group                  }
    {    ;VAT Registration No.                     }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one outstanding Purchase %3 for this vendor.';
      Text002@1001 : TextConst 'ENU=You have set %1 to %2. Do you want to update the %3 price list accordingly?';
      Text003@1002 : TextConst 'ENU=Do you wish to create a contact for %1 %2?';
      PurchSetup@1003 : Record 51516258;
      CommentLine@1005 : Record 97;
      PurchOrderLine@1006 : Record 39;
      PostCode@1007 : Record 225;
      VendBankAcc@1008 : Record 288;
      OrderAddr@1009 : Record 224;
      GenBusPostingGrp@1010 : Record 250;
      ItemCrossReference@1016 : Record 5717;
      RMSetup@1020 : Record 5079;
      ServiceItem@1024 : Record 5940;
      NoSeriesMgt@1011 : Codeunit 396;
      MoveEntries@1012 : Codeunit 361;
      UpdateContFromVend@1013 : Codeunit 5057;
      DimMgt@1014 : Codeunit 408;
      InsertFromContact@1015 : Boolean;
      Text004@1019 : TextConst 'ENU=Contact %1 %2 is not related to vendor %3 %4.';
      Text005@1021 : TextConst 'ENU=post';
      Text006@1022 : TextConst 'ENU=create';
      Text007@1023 : TextConst 'ENU=You cannot %1 this type of document when Vendor %2 is blocked with type %3';
      Text008@1025 : TextConst 'ENU=The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.';
      Text009@1027 : TextConst 'ENU=Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
      Text010@1026 : TextConst 'ENU=You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
      AccountTypes@1102760000 : Record 51516295;
      UsersID@1102760001 : Record 2000000120;
      FDType@1102760002 : Record 51516305;
      Cust@1102760003 : Record 51516223;
      NOKBOSA@1102760004 : Record 51516225;
      NOKApp@1102760005 : Record 51516291;
      GenSetUp@1102755000 : Record 51516257;
      VendorFDR@1102755001 : Record 23;

    PROCEDURE AssistEdit@2(OldVend@1000 : Record 23) : Boolean;
    VAR
      Vend@1001 : Record 23;
    BEGIN
    END;

    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Vendor,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    PROCEDURE LookupShortcutDimCode@28(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Vendor,"No.",FieldNumber,ShortcutDimCode);
    END;

    PROCEDURE ShowContact@1();
    VAR
      ContBusRel@1000 : Record 5054;
      Cont@1001 : Record 5050;
    BEGIN
    END;

    PROCEDURE SetInsertFromContact@3(FromContact@1000 : Boolean);
    BEGIN
      InsertFromContact := FromContact;
    END;

    PROCEDURE CheckBlockedVendOnDocs@4(Vend2@1003 : Record 23;Transaction@1000 : Boolean);
    BEGIN
      IF Vend2.Blocked = Vend2.Blocked::All THEN
        VendBlockedErrorMessage(Vend2,Transaction);
    END;

    PROCEDURE CheckBlockedVendOnJnls@5(Vend2@1005 : Record 23;DocType@1004 : ' ,Payment,Invoice,Credit Memo,Finance Charge,Reminder,Refund';Transaction@1003 : Boolean);
    BEGIN
      WITH Vend2 DO BEGIN
        IF (Blocked = Blocked::All) OR
           (Blocked = Blocked::Payment) AND (DocType = DocType::Payment)
        THEN
          VendBlockedErrorMessage(Vend2,Transaction);
      END;
    END;

    PROCEDURE VendBlockedErrorMessage@6(Vend2@1001 : Record 23;Transaction@1002 : Boolean);
    VAR
      Action@1000 : Text[30];
    BEGIN
      IF Transaction THEN
        Action := Text005
      ELSE
        Action := Text006;
      ERROR(Text007,Action,Vend2."No.",Vend2.Blocked);
    END;

    BEGIN
    END.
  }
}

