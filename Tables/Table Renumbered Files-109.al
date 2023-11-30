OBJECT table 17227 Members Register
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=10:49:19 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Permissions=TableData 21=r;
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               {
               IF "No." = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Members Nos");
                 NoSeriesMgt.InitSeries(SalesSetup."Members Nos",xRec."No. Series",0D,"No.","No. Series");
               END;

               }


               IF "Group Account"<>TRUE THEN BEGIN
               IF "No." = '' THEN BEGIN
               SalesSetup.GET;
               SalesSetup.TESTFIELD(SalesSetup."Members Nos");
               NoSeriesMgt.InitSeries(SalesSetup."Members Nos",xRec."No. Series",0D,"No.","No. Series");
               END;
               END ELSE

               IF "No." = '' THEN BEGIN
               SalesSetup.GET;
               SalesSetup.TESTFIELD(SalesSetup."Micro Group Nos.");
               NoSeriesMgt.InitSeries(SalesSetup."Micro Group Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;
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
                  ("Business Loan Officer" <> xRec."Business Loan Officer") OR
                  ("Country/Region Code" <> xRec."Country/Region Code") OR
                  ("Fax No." <> xRec."Fax No.") OR
                  ("Telex Answer Back" <> xRec."Telex Answer Back") OR
                  ("VAT Registration No." <> xRec."VAT Registration No.") OR
                  ("Post Code" <> xRec."Post Code") OR
                  (County <> xRec.County) OR
                  ("E-Mail" <> xRec."E-Mail") OR
                  ("Home Page" <> xRec."Home Page") OR
                  (Contact <> xRec.Contact)
               THEN BEGIN
                 MODIFY;
                 //UpdateContFromCust.OnModify(Rec);
               END;

             END;

    OnDelete=VAR
               CampaignTargetGr@1000 : Record 7030;
               ContactBusRel@1001 : Record 5054;
               Job@1004 : Record 167;
               CreditCards@1005 : Record 827;
               CampaignTargetGrMgmt@1002 : Codeunit 7030;
               StdCustSalesCode@1003 : Record 172;
             BEGIN
               //CreditCards.DeleteByCustomer(Rec);

               ERROR('You cannot delete a member');

               ServiceItem.SETRANGE("Customer No.","No.");
               IF ServiceItem.FIND('-') THEN
                 IF CONFIRM(
                      Text008,
                      FALSE,
                      TABLECAPTION,
                      "No.",
                      ServiceItem.FIELDCAPTION("Customer No."))
                 THEN
                   ServiceItem.MODIFYALL("Customer No.",'')
                 ELSE
                   ERROR(Text009);

               Job.SETRANGE("Bill-to Customer No.","No.");
               IF Job.FIND('-') THEN
                 ERROR(Text015,TABLECAPTION,"No.",Job.TABLECAPTION);

               MoveEntries.MoveMembEntries(Rec);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Customer);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               CustBankAcc.SETRANGE("Customer No.","No.");
               CustBankAcc.DELETEALL;

               ShipToAddr.SETRANGE("Customer No.","No.");
               ShipToAddr.DELETEALL;

               SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Customer);
               SalesPrice.SETRANGE("Sales Code","No.");
               SalesPrice.DELETEALL;

               SalesLineDisc.SETRANGE("Sales Type",SalesLineDisc."Sales Type"::Customer);
               SalesLineDisc.SETRANGE("Sales Code","No.");
               SalesLineDisc.DELETEALL;

               SalesPrepmtPct.SETCURRENTKEY("Sales Type","Sales Code");
               SalesPrepmtPct.SETRANGE("Sales Type",SalesPrepmtPct."Sales Type"::Customer);
               SalesPrepmtPct.SETRANGE("Sales Code","No.");
               SalesPrepmtPct.DELETEALL;

               StdCustSalesCode.SETRANGE("Customer No.","No.");
               StdCustSalesCode.DELETEALL(TRUE);

               ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
               ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
               ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
               ItemCrossReference.DELETEALL;

               SalesOrderLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
               SalesOrderLine.SETFILTER(
                 "Document Type",'%1|%2',
                 SalesOrderLine."Document Type"::Order,
                 SalesOrderLine."Document Type"::"Return Order");
               SalesOrderLine.SETRANGE("Bill-to Customer No.","No.");
               IF SalesOrderLine.FIND('-') THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",SalesOrderLine."Document Type");

               SalesOrderLine.SETRANGE("Bill-to Customer No.");
               SalesOrderLine.SETRANGE("Sell-to Customer No.","No.");
               IF SalesOrderLine.FIND('-') THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",SalesOrderLine."Document Type");

               //CampaignTargetGr.SETRANGE("No.",Rec."No.");
               //CampaignTargetGr.SETRANGE(Type,CampaignTargetGr.Type::Customer);
               //IF CampaignTargetGr.FIND('-') THEN BEGIN
               //  ContactBusRel.SETRANGE("Link to Table",ContactBusRel."Link to Table"::Customer);
               //  ContactBusRel.SETRANGE("No.",Rec."No.");
               //  ContactBusRel.FIND('-');
               //  REPEAT
               //    CampaignTargetGrMgmt.ConverttoContact(Rec,ContactBusRel."Contact No.");
               //  UNTIL CampaignTargetGr.NEXT = 0;
               //END;

               ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
               ServContract.SETRANGE("Customer No.","No.");
               IF ServContract.FIND('-') THEN
                 ERROR(
                   Text007,
                   TABLECAPTION,"No.");

               ServContract.SETRANGE(Status);
               ServContract.MODIFYALL("Customer No.",'');

               ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
               ServContract.SETRANGE("Bill-to Customer No.","No.");
               IF ServContract.FIND('-') THEN
                 ERROR(
                   Text007,
                   TABLECAPTION,"No.");

               ServContract.SETRANGE(Status);
               ServContract.MODIFYALL("Bill-to Customer No.",'');

               ServHeader.SETCURRENTKEY("Customer No.","Order Date");
               ServHeader.SETRANGE("Customer No.","No.");
               IF ServHeader.FIND('-') THEN
                 ERROR(
                   Text013,
                   TABLECAPTION,"No.",ServHeader."Document Type");

               ServHeader.SETRANGE("Bill-to Customer No.");
               IF ServHeader.FIND('-') THEN
                 ERROR(
                   Text013,
                   TABLECAPTION,"No.",ServHeader."Document Type");

               //UpdateContFromCust.OnDelete(Rec);

               DimMgt.DeleteDefaultDim(DATABASE::Customer,"No.");

               //MobSalesmgt.CustOnDelete(Rec);
               CALCFIELDS("Current Shares","Shares Retained");
               IF ("Current Shares"*-1 > 0) OR ("Shares Retained"*-1 >0) THEN
               ERROR(Text001);
             END;

    OnRename=BEGIN
               "Last Date Modified" := TODAY;
             END;

    CaptionML=ENU=Members Register;
    LookupPageID=Page51516226;
    DrillDownPageID=Page51516226;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;AltSearchField=Search Name;
                                                   OnValidate=BEGIN
                                                                IF "Group Account"<>TRUE THEN BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN

                                                                SalesSetup.GET;
                                                                NoSeriesMgt.TestManual(SalesSetup."Members Nos");
                                                                "No. Series" := '';
                                                                END;

                                                                END ELSE
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                SalesSetup.GET;
                                                                NoSeriesMgt.TestManual(SalesSetup."Micro Group Nos.");
                                                                "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=ENU=No.;
                                                   SQL Data Type=Varchar;
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text60        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Name;
                                                              END;

                                                   CaptionML=ENU=Name }
    { 3   ;   ;Search Name         ;Code55        ;CaptionML=ENU=Search Name }
    { 4   ;   ;Name 2              ;Text50        ;CaptionML=ENU=Name 2 }
    { 5   ;   ;Address             ;Text50        ;CaptionML=ENU=Address }
    { 6   ;   ;Address 2           ;Text50        ;CaptionML=ENU=Address 2 }
    { 7   ;   ;City                ;Text30        ;CaptionML=ENU=City }
    { 8   ;   ;Contact             ;Text50        ;CaptionML=ENU=Contact }
    { 9   ;   ;Phone No.           ;Text50        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=ENU=Phone No. }
    { 10  ;   ;Telex No.           ;Text23        ;CaptionML=ENU=Telex No. }
    { 14  ;   ;Our Account No.     ;Text20        ;CaptionML=ENU=Our Account No. }
    { 15  ;   ;Territory Code      ;Code10        ;TableRelation=Territory;
                                                   CaptionML=ENU=Territory Code }
    { 16  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 17  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 18  ;No ;Chain Name          ;Code10        ;CaptionML=ENU=Chain Name }
    { 19  ;   ;Budgeted Amount     ;Decimal       ;CaptionML=ENU=Budgeted Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 20  ;   ;Credit Limit (LCY)  ;Decimal       ;CaptionML=ENU=Credit Limit (LCY);
                                                   AutoFormatType=1 }
    { 21  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=ENU=Customer Posting Group }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code }
    { 23  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=ENU=Customer Price Group }
    { 24  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=ENU=Language Code }
    { 26  ;   ;Statistics Group    ;Integer       ;CaptionML=ENU=Statistics Group }
    { 27  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=ENU=Payment Terms Code }
    { 28  ;No ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   CaptionML=ENU=Fin. Charge Terms Code }
    { 29  ;   ;Business Loan Officer;Code15       ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=ENU=Salesperson Code }
    { 30  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=ENU=Shipment Method Code }
    { 31  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   OnValidate=BEGIN
                                                                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                                                                  VALIDATE("Shipping Agent Service Code",'');
                                                              END;

                                                   CaptionML=ENU=Shipping Agent Code }
    { 32  ;   ;Place of Export     ;Code20        ;CaptionML=ENU=Place of Export }
    { 33  ;   ;Invoice Disc. Code  ;Code20        ;TableRelation=Customer;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Invoice Disc. Code }
    { 34  ;   ;Customer Disc. Group;Code10        ;TableRelation="Customer Discount Group";
                                                   CaptionML=ENU=Customer Disc. Group }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=ENU=Country/Region Code }
    { 36  ;   ;Collection Method   ;Code20        ;CaptionML=ENU=Collection Method }
    { 37  ;   ;Amount              ;Decimal       ;CaptionML=ENU=Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 38  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Customer),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=ENU=Comment;
                                                   Editable=No }
    { 39  ;   ;Blocked             ;Option        ;CaptionML=ENU=Blocked;
                                                   OptionCaptionML=ENU=" ,Ship,Invoice,All";
                                                   OptionString=[ ,Ship,Invoice,All] }
    { 40  ;   ;Invoice Copies      ;Integer       ;CaptionML=ENU=Invoice Copies }
    { 41  ;   ;Last Statement No.  ;Integer       ;CaptionML=ENU=Last Statement No. }
    { 42  ;   ;Print Statements    ;Boolean       ;CaptionML=ENU=Print Statements }
    { 45  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=ENU=Bill-to Customer No. }
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
    { 58  ;   ;Balance             ;Decimal       ;CaptionML=ENU=Balance;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Balance (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;Net Change          ;Decimal       ;CaptionML=ENU=Net Change;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Net Change (LCY)    ;Decimal       ;CaptionML=ENU=Net Change (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Sales (LCY)         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cust. Ledger Entry"."Sales (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                             Posting Date=FIELD(Date Filter),
                                                                                                             Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Sales (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 63  ;   ;Profit (LCY)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cust. Ledger Entry"."Profit (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                              Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                              Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Profit (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 64  ;   ;Inv. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cust. Ledger Entry"."Inv. Discount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                     Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Posting Date=FIELD(Date Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Inv. Discounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 65  ;   ;Pmt. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount..'Payment Discount (VAT Adjustment)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Pmt. Discounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 66  ;   ;Balance Due         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                      Posting Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                      Initial Entry Due Date=FIELD(Date Filter),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Balance Due (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 69  ;   ;Payments            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Payment),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Customer No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Payments;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Invoice Amounts     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Invoice),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Invoice Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 71  ;   ;Cr. Memo Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Customer No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Cr. Memo Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 72  ;   ;Finance Charge Memo Amounts;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Finance Charge Memo Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 74  ;   ;Payments (LCY)      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Payment),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Customer No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Payments (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 75  ;   ;Inv. Amounts (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Inv. Amounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 76  ;   ;Cr. Memo Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Customer No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Cr. Memo Amounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 77  ;   ;Fin. Charge Memo Amounts (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Fin. Charge Memo Amounts (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 78  ;   ;Outstanding Orders  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount" WHERE (Document Type=CONST(Order),
                                                                                                            Bill-to Customer No.=FIELD(No.),
                                                                                                            Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                            Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                            Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Orders;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 79  ;   ;Shipped Not Invoiced;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Shipped Not Invoiced" WHERE (Document Type=CONST(Order),
                                                                                                              Bill-to Customer No.=FIELD(No.),
                                                                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Shipped Not Invoiced;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 80  ;   ;Application Method  ;Option        ;CaptionML=ENU=Application Method;
                                                   OptionCaptionML=ENU=Manual,Apply to Oldest;
                                                   OptionString=Manual,Apply to Oldest }
    { 82  ;   ;Prices Including VAT;Boolean       ;CaptionML=ENU=Prices Including VAT }
    { 83  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=ENU=Location Code }
    { 84  ;   ;Fax No.             ;Text30        ;CaptionML=ENU=Fax No. }
    { 85  ;   ;Telex Answer Back   ;Text20        ;CaptionML=ENU=Telex Answer Back }
    { 86  ;   ;VAT Registration No.;Text20        ;OnValidate=VAR
                                                                VATRegNoFormat@1000 : Record 381;
                                                              BEGIN
                                                                VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Customer);
                                                              END;

                                                   CaptionML=ENU=VAT Registration No. }
    { 87  ;   ;Combine Shipments   ;Boolean       ;CaptionML=ENU=Combine Shipments }
    { 88  ;   ;Gen. Bus. Posting Group;Code10     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=ENU=Gen. Bus. Posting Group }
    { 89  ;   ;Picture             ;BLOB          ;OnValidate=BEGIN
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."No.","FOSA Account");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                Vend.Picture:=Picture;
                                                                Vend.MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Picture;
                                                   SubType=Bitmap }
    { 91  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code";
                                                   OnValidate=BEGIN
                                                                //PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Post Code }
    { 92  ;   ;County              ;Text30        ;CaptionML=ENU=County }
    { 97  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE (Customer No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Credit Amount" WHERE (Customer No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE (Customer No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                             Entry Type=FILTER(<>Application),
                                                                                                                             Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                             Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                             Posting Date=FIELD(Date Filter),
                                                                                                                             Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Credit Amount (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 102 ;   ;E-Mail              ;Text80        ;ExtendedDatatype=E-Mail;
                                                   CaptionML=ENU=E-Mail }
    { 103 ;   ;Home Page           ;Text10        ;ExtendedDatatype=URL;
                                                   CaptionML=ENU=Home Page }
    { 104 ;   ;Reminder Terms Code ;Code10        ;TableRelation="Reminder Terms";
                                                   CaptionML=ENU=Reminder Terms Code }
    { 105 ;   ;Reminder Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Reminder),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Reminder Amounts;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 106 ;   ;Reminder Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                  Bill-to Customer No.=FIELD(No.),
                                                                                                                  Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Orders (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 114 ;   ;Shipped Not Invoiced (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Shipped Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                    Bill-to Customer No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Shipped Not Invoiced (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 115 ;   ;Reserve             ;Option        ;InitValue=Optional;
                                                   CaptionML=ENU=Reserve;
                                                   OptionCaptionML=ENU=Never,Optional,Always;
                                                   OptionString=Never,Optional,Always }
    { 116 ;   ;Block Payment Tolerance;Boolean    ;CaptionML=ENU=Block Payment Tolerance }
    { 117 ;   ;Pmt. Disc. Tolerance (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount Tolerance|'Payment Discount Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Pmt. Disc. Tolerance (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 118 ;   ;Pmt. Tolerance (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
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
                                                                CustLedgEntry@1001 : Record 21;
                                                                AccountingPeriod@1000 : Record 50;
                                                                ICPartner@1002 : Record 413;
                                                              BEGIN
                                                                IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
                                                                  CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
                                                                  CustLedgEntry.SETRANGE("Customer No.","No.");
                                                                  AccountingPeriod.SETRANGE(Closed,FALSE);
                                                                  IF AccountingPeriod.FIND('-') THEN
                                                                    CustLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                                                                  IF CustLedgEntry.FIND('-') THEN
                                                                    IF NOT CONFIRM(Text011,FALSE,TABLECAPTION) THEN
                                                                      "IC Partner Code" := xRec."IC Partner Code";

                                                                  CustLedgEntry.RESET;
                                                                  IF NOT CustLedgEntry.SETCURRENTKEY("Customer No.",Open) THEN
                                                                    CustLedgEntry.SETCURRENTKEY("Customer No.");
                                                                  CustLedgEntry.SETRANGE("Customer No.","No.");
                                                                  CustLedgEntry.SETRANGE(Open,TRUE);
                                                                  IF CustLedgEntry.FIND('+') THEN
                                                                    ERROR(Text012,FIELDCAPTION("IC Partner Code"),TABLECAPTION);
                                                                END;

                                                                IF "IC Partner Code" <> '' THEN BEGIN
                                                                  ICPartner.GET("IC Partner Code");
                                                                  IF (ICPartner."Customer No." <> '') AND (ICPartner."Customer No." <> "No.") THEN
                                                                    ERROR(Text010,FIELDCAPTION("IC Partner Code"),"IC Partner Code",TABLECAPTION,ICPartner."Customer No.");
                                                                  ICPartner."Customer No." := "No.";
                                                                  ICPartner.MODIFY;
                                                                END;

                                                                IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
                                                                  ICPartner."Customer No." := '';
                                                                  ICPartner.MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=IC Partner Code }
    { 120 ;   ;Refunds             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Refund),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Refunds }
    { 121 ;   ;Refunds (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Refund),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Refunds (LCY) }
    { 122 ;   ;Other Amounts       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(" "),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Other Amounts }
    { 123 ;   ;Other Amounts (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(" "),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Other Amounts (LCY) }
    { 124 ;   ;Prepayment %        ;Decimal       ;CaptionML=ENU=Prepayment %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 125 ;   ;Outstanding Invoices (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                                                                  Bill-to Customer No.=FIELD(No.),
                                                                                                                  Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Invoices (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 126 ;   ;Outstanding Invoices;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount" WHERE (Document Type=CONST(Invoice),
                                                                                                            Bill-to Customer No.=FIELD(No.),
                                                                                                            Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                            Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                            Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Invoices;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 130 ;   ;Bill-to No. Of Archived Doc.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                   Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-to No. Of Archived Doc. }
    { 131 ;   ;Sell-to No. Of Archived Doc.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                   Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Sell-to No. Of Archived Doc. }
    { 5049;   ;Primary Contact No. ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1000 : Record 5050;
                                                                ContBusRel@1001 : Record 5054;
                                                              BEGIN
                                                                Contact := '';
                                                                IF "Primary Contact No." <> '' THEN BEGIN
                                                                  Cont.GET("Primary Contact No.");

                                                                  ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                                  ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                                                                  ContBusRel.SETRANGE("No.","No.");
                                                                  ContBusRel.FIND('-');

                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);

                                                                  IF Cont.Type = Cont.Type::Person THEN
                                                                    Contact := Cont.Name
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1000 : Record 5050;
                                                              ContBusRel@1001 : Record 5054;
                                                            BEGIN
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "Primary Contact No." <> '' THEN
                                                                IF Cont.GET("Primary Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN
                                                                VALIDATE("Primary Contact No.",Cont."No.");
                                                            END;

                                                   CaptionML=ENU=Primary Contact No. }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=ENU=Responsibility Center }
    { 5750;   ;Shipping Advice     ;Option        ;CaptionML=ENU=Shipping Advice;
                                                   OptionCaptionML=ENU=Partial,Complete;
                                                   OptionString=Partial,Complete }
    { 5790;   ;Shipping Time       ;DateFormula   ;CaptionML=ENU=Shipping Time }
    { 5792;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   OnValidate=BEGIN
                                                                IF ("Shipping Agent Code" <> '') AND
                                                                   ("Shipping Agent Service Code" <> '')
                                                                THEN
                                                                  IF ShippingAgentService.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                                                                    "Shipping Time" := ShippingAgentService."Shipping Time"
                                                                  ELSE
                                                                    EVALUATE("Shipping Time",'<>');
                                                              END;

                                                   CaptionML=ENU=Shipping Agent Service Code }
    { 5900;   ;Service Zone Code   ;Code10        ;TableRelation="Service Zone";
                                                   CaptionML=ENU=Service Zone Code }
    { 5902;   ;Contract Gain/Loss Amount;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Contract Gain/Loss Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                            Ship-to Code=FIELD(Ship-to Filter),
                                                                                                            Change Date=FIELD(Date Filter)));
                                                   CaptionML=ENU=Contract Gain/Loss Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5903;   ;Ship-to Filter      ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(No.));
                                                   CaptionML=ENU=Ship-to Filter }
    { 5910;   ;Outstanding Serv. Orders (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                    Bill-to Customer No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Outstanding Serv. Orders (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5911;   ;Serv Shipped Not Invoiced(LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Line"."Shipped Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                      Bill-to Customer No.=FIELD(No.),
                                                                                                                      Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                      Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=ENU=Serv Shipped Not Invoiced(LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5912;   ;Outstanding Serv.Invoices(LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                                                                    Bill-to Customer No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Outstanding Serv.Invoices($);
                                                              ESM=Facturas de serv. pendientes ($);
                                                              FRC=Factures de service en attente en $;
                                                              ENC=Outstanding Serv.Invoices($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=ENU=Allow Line Disc. }
    { 7171;   ;No. of Approved Loans;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loan Status=CONST(Approved),
                                                                                             Client Code=FIELD(No.),
                                                                                             Outstanding Balance=FILTER(<>0)));
                                                   CaptionML=ENU=No. of Quotes;
                                                   Editable=No }
    { 7172;   ;No. of Issued Loans ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loan Status=CONST(Issued),
                                                                                             Client Code=FIELD(No.)));
                                                   CaptionML=ENU=No. of Blanket Orders;
                                                   Editable=No }
    { 7173;   ;No. of Rejected Loans;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loan Status=CONST(Rejected),
                                                                                             Client Code=FIELD(No.)));
                                                   CaptionML=ENU=No. of Orders;
                                                   Editable=No }
    { 7174;   ;No. of Invoices     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Invoice),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Invoices;
                                                   Editable=No }
    { 7175;   ;No. of Members Guaranteed;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Guarantee Details" WHERE (Member No=FIELD(No.),
                                                                                                      Outstanding Balance=FILTER(<>0),
                                                                                                      Substituted=FILTER(No)));
                                                   CaptionML=ENU=No. Members Guaranteed;
                                                   Editable=No }
    { 7176;   ;No. of Credit Memos ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Credit Memos;
                                                   Editable=No }
    { 7177;   ;No. of Pstd. Shipments;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Shipment Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Shipments;
                                                   Editable=No }
    { 7178;   ;No. of Pstd. Invoices;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Invoice Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Invoices;
                                                   Editable=No }
    { 7179;   ;No. of Pstd. Return Receipts;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Receipt Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Return Receipts;
                                                   Editable=No }
    { 7180;   ;No. of Pstd. Credit Memos;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Cr.Memo Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Pstd. Credit Memos;
                                                   Editable=No }
    { 7181;   ;No. of Ship-to Addresses;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Count("Ship-to Address" WHERE (Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=No. of Ship-to Addresses;
                                                   Editable=No }
    { 7182;   ;Bill-To No. of Quotes;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Quote),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Quotes;
                                                   Editable=No }
    { 7183;   ;Bill-To No. of Blanket Orders;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Blanket Order),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Blanket Orders;
                                                   Editable=No }
    { 7184;   ;Bill-To No. of Orders;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Order),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Orders;
                                                   Editable=No }
    { 7185;   ;Bill-To No. of Invoices;Integer    ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Invoice),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Invoices;
                                                   Editable=No }
    { 7186;   ;Bill-To No. of Return Orders;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Return Order),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Return Orders;
                                                   Editable=No }
    { 7187;   ;Bill-To No. of Credit Memos;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Credit Memos;
                                                   Editable=No }
    { 7188;   ;Bill-To No. of Pstd. Shipments;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Shipment Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Pstd. Shipments;
                                                   Editable=No }
    { 7189;   ;Bill-To No. of Pstd. Invoices;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Invoice Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Pstd. Invoices;
                                                   Editable=No }
    { 7190;   ;Bill-To No. of Pstd. Return R.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Receipt Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Pstd. Return R.;
                                                   Editable=No }
    { 7191;   ;Bill-To No. of Pstd. Cr. Memos;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Cr.Memo Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=ENU=Bill-To No. of Pstd. Cr. Memos;
                                                   Editable=No }
    { 7600;   ;Base Calendar Code  ;Code10        ;TableRelation="Base Calendar";
                                                   CaptionML=ENU=Base Calendar Code }
    { 7601;   ;Copy Sell-to Addr. to Qte From;Option;
                                                   CaptionML=ENU=Copy Sell-to Addr. to Qte From;
                                                   OptionCaptionML=ENU=Company,Person;
                                                   OptionString=Company,Person }
    { 68000;  ;Customer Type       ;Option        ;OptionCaptionML=ENU=" ,Member,FOSA,Investments,Property,MicroFinance";
                                                   OptionString=[ ,Member,FOSA,Investments,Property,MicroFinance] }
    { 68001;  ;Registration Date   ;Date           }
    { 68002;  ;Current Loan        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=CONST(Loan),
                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                       Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68003;  ;Current Shares      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Deposit Contribution),
                                                                                                        Posting Date=FIELD(Date Filter)));
                                                   Editable=No }
    { 68004;  ;Total Repayments    ;Decimal       ;Editable=No }
    { 68005;  ;Principal Balance   ;Decimal        }
    { 68006;  ;Principal Repayment ;Decimal        }
    { 68008;  ;Debtors Type        ;Option        ;OptionCaptionML=ENU=" ,Staff,Client,Others";
                                                   OptionString=[ ,Staff,Client,Others] }
    { 68011;  ;Outstanding Balance ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment|Loan Adjustment|Interest Due|Interest Paid),
                                                                                                       Posting Date=FIELD(Date Filter)));
                                                   Editable=No }
    { 68012;  ;Status              ;Option        ;OptionCaptionML=ENU=Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter,Awaiting Withdrawal,Closed;
                                                   OptionString=Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter,Awaiting Withdrawal,Closed }
    { 68013;  ;FOSA Account        ;Code20        ;TableRelation=Vendor.No. }
    { 68015;  ;Old Account No.     ;Code20         }
    { 68016;  ;Loan Product Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Loan Products Setup".Code }
    { 68017;  ;Employer Code       ;Code20        ;TableRelation="Sacco Employers";
                                                   OnValidate=BEGIN
                                                                Vend2.RESET;
                                                                Vend2.SETRANGE(Vend2."BOSA Account No","No.");
                                                                IF Vend2.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Vend2."Company Code":="Employer Code";
                                                                Vend2.MODIFY;
                                                                UNTIL Vend2.NEXT = 0;
                                                                END;
                                                              END;
                                                               }
    { 68018;  ;Date of Birth       ;Date           }
    { 68019;  ;E-Mail (Personal)   ;Text50         }
    { 68020;  ;Station/Department  ;Code20        ;TableRelation="Loans Guarantee Details"."Loan No" WHERE (Name=FIELD(Employer Code)) }
    { 68021;  ;Home Address        ;Text40         }
    { 68022;  ;Location            ;Text40         }
    { 68023;  ;Sub-Location        ;Text40         }
    { 68024;  ;District            ;Text50         }
    { 68025;  ;Resons for Status Change;Text80     }
    { 68026;  ;Payroll/Staff No    ;Code20         }
    { 68027;  ;ID No.              ;Code40         }
    { 68028;  ;Mobile Phone No     ;Code40         }
    { 68029;  ;Marital Status      ;Option        ;OptionString=[ ,Single,Married,Devorced,Widower] }
    { 68030;  ;Signature           ;BLOB          ;OnValidate=BEGIN
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."No.","FOSA Account");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                Vend.Signature:=Signature;
                                                                Vend.MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Signature;
                                                   SubType=Bitmap }
    { 68031;  ;Passport No.        ;Code40         }
    { 68032;  ;Gender              ;Option        ;OptionCaptionML=ENU=Male,Female;
                                                   OptionString=[ ,Male,Female] }
    { 68033;  ;Withdrawal Date     ;Date           }
    { 68034;  ;Withdrawal Fee      ;Decimal       ;FieldClass=Normal;
                                                   Editable=No }
    { 68035;  ;Status - Withdrawal App.;Option    ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Membership Withdrawals".Status WHERE (Member No.=FIELD(No.)));
                                                   OptionCaptionML=ENU=" ,Application,Being Processed,Approved,Rejected,Canceled";
                                                   OptionString=[ ,Application,Being Processed,Approved,Rejected,Canceled] }
    { 68036;  ;Withdrawal Application Date;Date   ;OnValidate=BEGIN
                                                                IF "Withdrawal Application Date" <> 0D THEN
                                                                "Withdrawal Date":=CALCDATE('2M',"Withdrawal Application Date");
                                                              END;
                                                               }
    { 68037;  ;Investment Monthly Cont;Decimal     }
    { 68038;  ;Investment Max Limit.;Decimal       }
    { 68039;  ;Current Investment Total;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=CONST(Investment),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68040;  ;Document No. Filter ;Code20        ;FieldClass=FlowFilter }
    { 68041;  ;Shares Retained     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=CONST(Shares Capital),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68043;  ;Registration Fee Paid;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                Transaction Type=CONST(Registration Fee)));
                                                   Editable=No }
    { 68044;  ;Registration Fee    ;Decimal        }
    { 68045;  ;Society Code        ;Code20         }
    { 68046;  ;Insurance Fund      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Benevolent Fund),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68047;  ;Monthly Contribution;Decimal       ;OnValidate=BEGIN

                                                                "Previous Share Contribution":=xRec."Monthly Contribution";
                                                                Advice:=TRUE;
                                                                //"Advice Type":="Advice Type"::Adjustment;
                                                                IF ("Monthly Contribution"<>xRec."Monthly Contribution") THEN BEGIN
                                                                  "Variation Date Deposits":=TODAY;
                                                                END;
                                                              END;
                                                               }
    { 68048;  ;Investment B/F      ;Decimal        }
    { 68049;  ;Dividend Amount     ;Decimal        }
    { 68050;  ;Name of Chief       ;Text40         }
    { 68051;  ;Office Telephone No.;Code20         }
    { 68052;  ;Extension No.       ;Code30         }
    { 68053;  ;Insurance Contribution;Decimal     ;OnValidate=BEGIN
                                                                //Advice:=TRUE;
                                                              END;
                                                               }
    { 68054;  ;Advice              ;Boolean        }
    { 68055;  ;Province            ;Code50         }
    { 68056;  ;Previous Share Contribution;Decimal }
    { 68057;  ;Un-allocated Funds  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=CONST(Unallocated Funds),
                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                       Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68058;  ;Refund Request Amount;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum(Refunds.Amount WHERE (Member No.=FIELD(No.)));
                                                   Editable=No }
    { 68059;  ;Refund Issued       ;Boolean       ;Editable=No }
    { 68060;  ;Batch No.           ;Code20        ;OnValidate=BEGIN
                                                                {IF "Refund Issued"=TRUE THEN BEGIN
                                                                RefundsR.RESET;
                                                                RefundsR.SETRANGE(RefundsR."Member No.","No.");
                                                                IF RefundsR.FIND('-') THEN
                                                                RefundsR.DELETEALL;

                                                                "Refund Issued":=FALSE;
                                                                END;

                                                                IF "Batch No." <> '' THEN BEGIN
                                                                MovementTracker.RESET;
                                                                MovementTracker.SETRANGE(MovementTracker."Document No.","Batch No.");
                                                                MovementTracker.SETRANGE(MovementTracker."Current Location",TRUE);
                                                                IF MovementTracker.FIND('-') THEN BEGIN
                                                                ApprovalsUsers.RESET;
                                                                ApprovalsUsers.SETRANGE(ApprovalsUsers."Approval Type",MovementTracker."Approval Type");
                                                                ApprovalsUsers.SETRANGE(ApprovalsUsers.Stage,MovementTracker.Stage);
                                                                ApprovalsUsers.SETRANGE(ApprovalsUsers."User ID",USERID);
                                                                IF ApprovalsUsers.FIND('-') = FALSE THEN
                                                                ERROR('You cannot assign a batch which is in %1.',MovementTracker.Station);

                                                                END;
                                                                END; }
                                                              END;
                                                               }
    { 68061;  ;Current Status      ;Option        ;OptionString=Approved,Rejected }
    { 68062;  ;Cheque No.          ;Code20         }
    { 68063;  ;Cheque Date         ;Date           }
    { 68064;  ;Accrued Interest    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Interest Due)));
                                                   Editable=No }
    { 68065;  ;Defaulted Loans Recovered;Boolean   }
    { 68066;  ;Withdrawal Posted   ;Boolean        }
    { 68069;  ;Loan No. Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(No.)) }
    { 68070;  ;Currect File Location;Code50       ;FieldClass=FlowField;
                                                   CalcFormula=Max("File Movement Tracker".Station WHERE (Member No.=FIELD(No.)));
                                                   Editable=No }
    { 68071;  ;Move To1            ;Integer       ;TableRelation="Approvals Set Up".Stage WHERE (Approval Type=CONST(File Movement)) }
    { 68073;  ;File Movement Remarks;Text50        }
    { 68076;  ;Status Change Date  ;Date           }
    { 68077;  ;Last Payment Date   ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Customer No.=FIELD(No.),
                                                                                                               Transaction Type=FILTER(Deposit Contribution),
                                                                                                               Credit Amount=FILTER(>0))) }
    { 68078;  ;Discounted Amount   ;Decimal        }
    { 68079;  ;Current Savings     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=CONST(Deposit Contribution)));
                                                   Editable=No }
    { 68080;  ;Payroll Updated     ;Boolean        }
    { 68081;  ;Last Marking Date   ;Date           }
    { 68082;  ;Dividends Capitalised %;Decimal    ;OnValidate=BEGIN
                                                                {IF ("Dividends Capitalised %" < 0) OR ("Dividends Capitalised %" > 100)THEN
                                                                ERROR('Invalied Entry.');}
                                                              END;
                                                               }
    { 68083;  ;FOSA Outstanding Balance;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment|Loan Adjustment),
                                                                                                       Global Dimension 1 Code=FILTER(FOSA))) }
    { 68084;  ;FOSA Oustanding Interest;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Interest Due))) }
    { 68085;  ;Formation/Province  ;Code20        ;OnValidate=BEGIN
                                                                {Vend.RESET;
                                                                Vend.SETRANGE(Vend."Staff No","Payroll/Staff No");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Vend."Formation/Province":="Formation/Province";
                                                                Vend.MODIFY;
                                                                UNTIL Vend.NEXT=0;
                                                                END;}
                                                              END;
                                                               }
    { 68086;  ;Division/Department ;Code20        ;TableRelation=Table51516158.Field1 }
    { 68087;  ;Station/Section     ;Code20        ;TableRelation=Table51516159.Field1 }
    { 68088;  ;Closing Deposit Balance;Decimal     }
    { 68089;  ;Closing Loan Balance;Decimal        }
    { 68090;  ;Closing Insurance Balance;Decimal   }
    { 68091;  ;Dividend Progression;Decimal        }
    { 68092;  ;Closing Date        ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Cust. Ledger Entry"."Posting Date" WHERE (Customer No.=FIELD(No.))) }
    { 68093;  ;Welfare Fund        ;Decimal       ;FieldClass=Normal;
                                                   Editable=No }
    { 68094;  ;Discounted Dividends;Decimal        }
    { 68095;  ;Mode of Dividend Payment;Option    ;OptionCaptionML=ENU=" ,FOSA,EFT,Cheque,Defaulted Loan (Capitalised)";
                                                   OptionString=[ ,FOSA,EFT,Cheque,Defaulted Loan] }
    { 68096;  ;Qualifying Shares   ;Decimal        }
    { 68097;  ;Defaulter Overide Reasons;Text10    }
    { 68098;  ;Defaulter Overide   ;Boolean       ;OnValidate=BEGIN
                                                                {TESTFIELD("Defaulter Overide Reasons");

                                                                StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Loan External EFT");
                                                                IF StatusPermissions.FIND('-') = FALSE THEN
                                                                ERROR('You do not have permissions to overide defaulters.'); }
                                                              END;
                                                               }
    { 68099;  ;Closure Remarks     ;Text30         }
    { 68100;  ;Bank Account No.    ;Code20         }
    { 68101;  ;Bank Code           ;Code20        ;TableRelation="Member App Signatories"."Account No";
                                                   ValidateTableRelation=No }
    { 68102;  ;Dividend Processed  ;Boolean        }
    { 68103;  ;Dividend Error      ;Boolean        }
    { 68104;  ;Dividend Capitalized;Decimal        }
    { 68105;  ;Dividend Paid FOSA  ;Decimal        }
    { 68106;  ;Dividend Paid EFT   ;Decimal        }
    { 68107;  ;Dividend Withholding Tax;Decimal    }
    { 68109;  ;Loan Last Payment Date;Date        ;FieldClass=Normal }
    { 68110;  ;Outstanding Interest;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                               Transaction Type=FILTER(Interest Paid|Interest Due))) }
    { 68111;  ;Last Transaction Date;Date         ;FieldClass=Normal }
    { 68112;  ;Account Category    ;Option        ;OptionCaptionML=ENU=Individual,Joint,Corporate,Group,Junior;
                                                   OptionString=Single,Joint,Corporate,Group,Junior }
    { 68113;  ;Type Of Organisation;Option        ;OptionCaptionML=ENU=" ,Club,Association,Partnership,Investment,Merry go round,Other,Group";
                                                   OptionString=[ ,Club,Association,Partnership,Investment,Merry go round,Other,Group] }
    { 68114;  ;Source Of Funds     ;Option        ;OptionCaptionML=ENU=" ,Business Receipts,Income from Investment,Salary,Other";
                                                   OptionString=[ ,Business Receipts,Income from Investment,Salary,Other] }
    { 68115;  ;MPESA Mobile No     ;Code20         }
    { 68120;  ;Force No.           ;Code20         }
    { 68121;  ;Last Advice Date    ;Date           }
    { 68122;  ;Advice Type         ;Option        ;OptionString=[ ,New Member,Shares Adjustment,ABF Adjustment,Registration Fees,Withdrawal,Reintroduction,Reintroduction With Reg Fees] }
    { 68140;  ;Share Balance BF    ;Decimal        }
    { 68143;  ;Move to             ;Integer       ;TableRelation="Approvals Set Up".Stage WHERE (Approval Type=CONST(File Movement));
                                                   OnValidate=BEGIN
                                                                 Approvalsetup.RESET;
                                                                 Approvalsetup.SETRANGE(Approvalsetup.Stage,"Move to");
                                                                 IF Approvalsetup.FIND('-') THEN BEGIN
                                                                "Move to description":=Approvalsetup.Station;
                                                                END;
                                                              END;
                                                               }
    { 68144;  ;File Movement Remarks1;Option      ;OptionCaptionML=ENU=" ,Reconciliation purposes,Auditing purposes,Refunds,Loan & Signatories,Withdrawal,Risks payment,Cheque Payment,Custody,Document Filing,Passbook,Complaint Letters,Defaulters,Dividends,Termination,New Members Details,New Members Verification";
                                                   OptionString=[ ,Reconciliation purposes,Auditing purposes,Refunds,Loan & Signatories,Withdrawal,Risks payment,Cheque Payment,Custody,Document Filing,Passbook,Complaint Letters,Defaulters,Dividends,Termination,New Members Details,New Members Verification] }
    { 68145;  ;File MVT User ID    ;Code20         }
    { 68146;  ;File MVT Time       ;Time           }
    { 68147;  ;File Previous Location;Code20       }
    { 68148;  ;File MVT Date       ;Date           }
    { 68149;  ;file received date  ;Date           }
    { 68150;  ;File received Time  ;Time           }
    { 68151;  ;File Received by    ;Code30         }
    { 68152;  ;file Received       ;Boolean        }
    { 68153;  ;User                ;Code30         }
    { 68154;  ;Change Log          ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Change Log Entry" WHERE (Primary Key Field 1 Value=FIELD(No.))) }
    { 68155;  ;Section             ;Code40        ;TableRelation=IF (Section=CONST()) "Top Savers Buffer"."Member No" }
    { 68156;  ;rejoined            ;Boolean        }
    { 68157;  ;Job title           ;Code30         }
    { 68158;  ;Pin                 ;Code20         }
    { 68160;  ;Remitance mode      ;Option        ;OptionCaptionML=ENU=,Check off,Cash,Standing Order;
                                                   OptionString=,Check off,Cash,Standing Order }
    { 68161;  ;Terms of Service    ;Option        ;OptionCaptionML=ENU=,Permanent,Temporary,Contract;
                                                   OptionString=,Permanent,Temporary,Contract }
    { 68162;  ;Comment1            ;Text10         }
    { 68163;  ;Comment2            ;Text20         }
    { 68164;  ;Current file location;Code10        }
    { 68165;  ;Work Province       ;Code10         }
    { 68166;  ;Work District       ;Code10         }
    { 68167;  ;Bank Name           ;Text50         }
    { 68168;  ;Bank Branch         ;Text50         }
    { 68169;  ;Customer Paypoint   ;Code10         }
    { 68170;  ;Date File Opened    ;Date           }
    { 68171;  ;File Status         ;Code10         }
    { 68172;  ;Customer Title      ;Code10         }
    { 68173;  ;Folio Number        ;Code20         }
    { 68174;  ;Move to description ;Text20         }
    { 68175;  ;Filelocc            ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Max("File Movement Tracker"."Entry No." WHERE (Member No.=FIELD(No.))) }
    { 68176;  ;S Card No.          ;Code10         }
    { 68177;  ;Reason for file overstay;Text40     }
    { 68179;  ;Loc Description     ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("File Movement Tracker".Description WHERE (Entry No.=FIELD(UPPERLIMIT(Filelocc)),
                                                                                                                 Member No.=FIELD(No.))) }
    { 68180;  ;Current Balance     ;Decimal        }
    { 68181;  ;Member Transfer Date;Date           }
    { 68182;  ;Contact Person      ;Code20         }
    { 68183;  ;Member withdrawable Deposits;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                       Document No.=FIELD(Document No. Filter),
                                                                                                       Transaction Type=CONST(Withdrawable Deposits))) }
    { 68184;  ;Current Location    ;Text20         }
    { 68185;  ;Group Code          ;Code20         }
    { 68186;  ;Holiday Savers      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=CONST(Xmas Contribution),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68187;  ;Benevolent Fund     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=CONST(Benevolent Fund)));
                                                   Editable=No }
    { 68188;  ;Office Branch       ;Code20         }
    { 68189;  ;Department          ;Code20        ;TableRelation=Table51516158.Field1 }
    { 68190;  ;Occupation          ;Text30         }
    { 68191;  ;Designation         ;Text30         }
    { 68192;  ;Village/Residence   ;Text3         ;CaptionML=ENU=Work Station }
    { 68193;No;Incomplete Shares   ;Boolean        }
    { 68194;  ;Contact Person Phone;Code15         }
    { 68195;  ;Development Shares  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Dev Shares),
                                                                                                       Posting Date=FIELD(Date Filter))) }
    { 68196;Yes;Fanikisha savings  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Co-op Shares),
                                                                                                        Posting Date=FIELD(Date Filter))) }
    { 68197;  ;Old Fosa Account    ;Code25         }
    { 68198;  ;Recruited By        ;Code35         }
    { 68200;  ;ContactPerson Relation;Code20      ;TableRelation=Table50091 }
    { 68201;No;ContactPerson Occupation;Code20     }
    { 68202;  ;Member No. 2        ;Code20         }
    { 68203;No;Juja                ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Juja),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68204;  ;Junior Savings      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Konza),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68205;  ;Gpange Savings      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Lukenya),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 68206;  ;Insurance on Shares ;Decimal        }
    { 68207;  ;Physical States     ;Option        ;OptionCaptionML=ENU=Normal,Deaf,Blind;
                                                   OptionString=Normal,Deaf,Blind }
    { 68208;  ;DIOCESE             ;Code5          }
    { 68212;  ;Mobile No. 2        ;Code15         }
    { 68213;  ;Employer Name       ;Text40         }
    { 68214;  ;Title               ;Option        ;OptionCaptionML=ENU=" ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.";
                                                   OptionString=[ ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.] }
    { 68215;  ;Town                ;Code15        ;TableRelation="Post Code".City;
                                                   Editable=No }
    { 68222;  ;Home Town           ;Code30        ;Editable=No }
    { 69038;  ;Loans Defaulter Status;Option      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loans Register"."Loans Category-SASRA" WHERE (Client Code=FIELD(No.)));
                                                   OptionCaptionML=ENU=Perfoming,Watch,Substandard,Doubtful,Loss;
                                                   OptionString=Perfoming,Watch,Substandard,Doubtful,Loss }
    { 69039;  ;Home Postal Code    ;Code10        ;TableRelation="Post Code".Code }
    { 69040;  ;Total Loans Outstanding;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment))) }
    { 69041;  ;No of Loans Guaranteed;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Guarantee Details" WHERE (Member No=FIELD(No.),
                                                                                                      Outstanding Balance=FILTER(<>0),
                                                                                                      Substituted=CONST(No)));
                                                   Editable=No }
    { 69042;  ;Member Found        ;Boolean        }
    { 69043;  ;Housing Title       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Housing Title),
                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                       Document No.=FIELD(Document No. Filter))) }
    { 69044;  ;Housing Water       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Housing Water),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter))) }
    { 69045;  ;Housing Main        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Housing Main),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter))) }
    { 69046;  ;Member Can Guarantee  Loan;Boolean  }
    { 69047;  ;FOSA  Account Bal   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(FOSA Account),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Currency Code=FIELD(Currency Filter),
                                                                                                                Posting Date=FIELD(Date Filter))) }
    { 69048;  ;Rejoining Date      ;Date           }
    { 69049;  ;Active Loans Guarantor;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Guarantee Details" WHERE (Member No=FIELD(No.),
                                                                                                      Outstanding Balance=FILTER(>0)));
                                                   Editable=No }
    { 69050;  ;Loans Guaranteed    ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Guarantee Details" WHERE (Substituted Guarantor=FIELD(No.)));
                                                   Editable=No }
    { 69051;  ;Member Deposit *3   ;Decimal        }
    { 69052;  ;New loan Eligibility;Decimal        }
    { 69053;  ;Share Certificate No;Integer        }
    { 69054;  ;Last Share Certificate No;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Max("Members Register"."Share Certificate No") }
    { 69055;  ;No Of Days          ;Integer        }
    { 69056;  ;Amount Withheld     ;Decimal        }
    { 69057;  ;Group Account No    ;Code10        ;TableRelation="Members Register" WHERE (Customer Posting Group=FILTER(MICRO),
                                                                                           Group Account=FILTER(Yes)) }
    { 69064;  ;Account Type        ;Option        ;OptionCaptionML=ENU=" ,Single,Group";
                                                   OptionString=[ ,Single,Group] }
    { 69072;  ;Repayment Method    ;Option        ;OptionCaptionML=ENU=" ,Amortised,Reducing Balance,Straight Line,Constants,Ukulima Flat";
                                                   OptionString=[ ,Amortised,Reducing Balance,Straight Line,Constants,Ukulima Flat] }
    { 69073;  ;Sms Notification    ;Boolean        }
    { 69074;  ;Group Account       ;Boolean        }
    { 69075;  ;Group Account Name  ;Code10         }
    { 69076;  ;BOSA Account No.    ;Code10         }
    { 69077;  ;School Fees Shares  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(SchFee Shares),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 69078;  ;Monthly Sch.Fees Cont.;Decimal     ;OnValidate=BEGIN
                                                                IF ("Monthly Sch.Fees Cont."<>xRec."Monthly Sch.Fees Cont.") THEN BEGIN
                                                                   "Variation Date ESS":=TODAY;
                                                                  END;
                                                              END;
                                                               }
    { 69079;  ;Password            ;Text20         }
    { 69080;  ;Principle Unallocated;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Principle Unallocated),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 69081;  ;Interest Unallocated;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Interest Unallocated),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 69082;  ;Created By          ;Code20        ;Editable=No }
    { 69083;  ;Staff UserID        ;Code20        ;TableRelation="User Setup"."User ID" }
    { 69084;  ;Password Set Date   ;Date           }
    { 69085;  ;PasswordSameID      ;Boolean        }
    { 69086;  ;Variation Date Deposits;Date        }
    { 69087;  ;Variation Date ESS  ;Date           }
    { 69088;  ;Outstanding Balance New;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment|Loan Adjustment|Interest Due|Interest Paid),
                                                                                                       Posting Date=FILTER(>12/31/17),
                                                                                                       Amount=FIELD(Loan Principal Amount)));
                                                   Editable=No }
    { 69089;  ;Loan Principal Amount;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loan Repayment Schedule"."Loan Amount" WHERE (Member No.=FIELD(No.))) }
    { 69090;  ;Principle Balance   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment|Loan Adjustment)));
                                                   Editable=No }
    { 69091;  ;Member Category     ;Code30        ;TableRelation="Member Groups".Code }
    { 69092;  ;BVF Contribution    ;Decimal        }
    { 69093;  ;Front Side ID       ;BLOB          ;SubType=Bitmap }
    { 69094;  ;Back Side ID        ;BLOB          ;SubType=Bitmap }
    { 69095;  ;Checked By          ;Text20         }
    { 69096;  ;ID Picture          ;BLOB          ;OnValidate=BEGIN
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."No.","FOSA Account");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                Vend.Signature:=Signature;
                                                                Vend.MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Signature;
                                                   SubType=Bitmap }
    { 69097;  ;Pays Benevolent     ;Boolean        }
    { 69098;  ;Loan Defaulter      ;Boolean        }
    { 69099;  ;Defaulter           ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Loans Register" WHERE (Outstanding Balance=FILTER(>0),
                                                                                             Client Code=FIELD(No.),
                                                                                             Defaulted=FILTER(Yes))) }
    { 69100;  ;Co-operative Shares ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Co-op Shares),
                                                                                                        Posting Date=FIELD(Date Filter)));
                                                   Editable=No }
    { 69101;  ;Date Of Retirement  ;Date          ;Editable=No }
    { 69102;  ;Crblisting          ;Boolean        }
    { 69103;  ;Region              ;Code20         }
    { 69104;  ;Station             ;Text60         }
    { 69105;  ;ESS Interest Amount ;Decimal        }
    { 69106;  ;Deposits Interest Amount;Decimal    }
    { 69107;  ;Expiry Date(Passport);Date          }
    { 69108;  ;Sub-County          ;Code20         }
    { 69109;  ;Contract Expiry Date;Date           }
    { 69111;  ;Employment Type     ;Option        ;OptionCaptionML=ENU=,Self Employed,Employed;
                                                   OptionString=,Self Employed,Employed }
    { 69112;  ;Name of Business    ;Text40         }
    { 69113;  ;Nature of Business  ;Text40         }
    { 69114;  ;Terms And Conditions;Text30         }
    { 69115;  ;Registration Fee Paid.;Boolean      }
    { 69116;  ;ESS Monthly Contribution;Decimal    }
    { 69117;  ;ESS Last Contribution Date;Date    ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Customer No.=FIELD(No.),
                                                                                                               Transaction Type=CONST(SchFee Shares))) }
    { 69118;  ;Last Deposit Date Sch;Date         ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Transaction Type=FILTER(SchFee Shares),
                                                                                                               Customer No.=FIELD(No.))) }
    { 69119;  ;Last Deposit Date Deposit;Date     ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Transaction Type=FILTER(Deposit Contribution),
                                                                                                               Customer No.=FIELD(No.))) }
    { 69120;  ;Checkoff Member     ;Boolean        }
    { 69121;  ;Salary Member       ;Boolean        }
    { 69122;  ;Last Checkoff Date  ;Date           }
    { 69123;  ;Last Salary Date    ;Date           }
    { 69124;  ;Last Salary Amount  ;Decimal        }
    { 69125;  ;Last Checkoff Amount;Decimal        }
    { 69126;  ;Insider Classification;Option      ;OptionCaptionML=ENU=Member,Delegate,Board Member,Staff;
                                                   OptionString=Member,Delegate,Board Member,Staff;
                                                   Editable=No }
    { 69127;  ;Benovelent Funds    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=CONST(Benevolent Fund),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FIELD(Document No. Filter)));
                                                   Editable=No }
    { 69128;  ;BBF                 ;Decimal        }
    { 69129;  ;Membership Status   ;Option        ;OptionCaptionML=ENU=Active,Re-instated,Awaiting Withdrawal,Closed;
                                                   OptionString=Active,Re-instated,Awaiting Withdrawal,Closed }
    { 69130;  ;Open Bal Deposits   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=CONST(Deposit Contribution),
                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                        Document No.=FILTER(OPENBAL-DEP)));
                                                   Editable=No }
    { 69131;  ;Loan Status         ;Option        ;OptionCaptionML=ENU=Performing,Defaulter;
                                                   OptionString=Performing,Defaulter }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Customer Posting Group                   }
    {    ;Currency Code                            }
    {    ;Country/Region Code                      }
    {    ;Gen. Bus. Posting Group                  }
    {    ;Name,Address,City                        }
    {    ;VAT Registration No.                     }
    {    ;Name                                    ;KeyGroups=SearchCol }
    {    ;City                                    ;KeyGroups=SearchCol }
    {    ;Post Code                               ;KeyGroups=SearchCol }
    {    ;Phone No.                               ;KeyGroups=SearchCol }
    {    ;Contact                                 ;KeyGroups=SearchCol }
    {    ;Employer Code                            }
    {    ;Payroll/Staff No,Customer Type           }
    { No ;                                         }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
      Text002@1001 : TextConst 'ENU=Do you wish to create a contact for %1 %2?';
      SalesSetup@1002 : Record 51516258;
      CommentLine@1004 : Record 97;
      SalesOrderLine@1005 : Record 37;
      CustBankAcc@1006 : Record 287;
      ShipToAddr@1007 : Record 222;
      PostCode@1008 : Record 225;
      GenBusPostingGrp@1009 : Record 250;
      ShippingAgentService@1010 : Record 5790;
      ItemCrossReference@1016 : Record 5717;
      RMSetup@1018 : Record 5079;
      SalesPrice@1021 : Record 7002;
      SalesLineDisc@1022 : Record 7004;
      SalesPrepmtPct@1003 : Record 459;
      ServContract@1026 : Record 5965;
      ServHeader@1034 : Record 5900;
      ServiceItem@1027 : Record 5940;
      NoSeriesMgt@1011 : Codeunit 396;
      MoveEntries@1012 : Codeunit 361;
      UpdateContFromCust@1013 : Codeunit 5056;
      DimMgt@1014 : Codeunit 408;
      InsertFromContact@1015 : Boolean;
      Text003@1020 : TextConst 'ENU=Contact %1 %2 is not related to customer %3 %4.';
      Text004@1023 : TextConst 'ENU=post';
      Text005@1024 : TextConst 'ENU=create';
      Text006@1025 : TextConst 'ENU=You cannot %1 this type of document when Customer %2 is blocked with type %3';
      Text007@1028 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
      Text008@1029 : TextConst 'ENU=Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?';
      Text009@1030 : TextConst 'ENU=Cannot delete customer.';
      Text010@1031 : TextConst 'ENU=The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';
      Text011@1033 : TextConst 'ENU=Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
      Text012@1032 : TextConst 'ENU=You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
      Text013@1035 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
      Text014@1017 : TextConst 'ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      Text015@1036 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one %3 associated to this customer.';
      Loans@1102755011 : Record 51516230;
      GenSetUp@1102755010 : Record 51516257;
      MinShares@1102755009 : Decimal;
      MovementTracker@1102755008 : Record 51516253;
      Cust@1102755006 : Record 51516223;
      Vend@1102755005 : Record 23;
      CustFosa@1102755004 : Code[20];
      Vend2@1102755003 : Record 23;
      FOSAAccount@1102755002 : Record 23;
      StatusPermissions@1102755001 : Record 51516310;
      RefundsR@1102755000 : Record 51516269;
      Text001@1102755007 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one transaction %3 for this customer.';
      Approvalsetup@1000000000 : Record 51516268;
      DataSheet@1000000001 : Record 51516341;
      UserIDViscible@1000000002 : Boolean;

    PROCEDURE TestNoEntriesExist@1006(CurrentFieldName@1000 : Text[100];GLNO@1102755000 : Code[20]);
    VAR
      MemberLedgEntry@1001 : Record 51516224;
    BEGIN
       //To prevent change of field
       MemberLedgEntry.SETCURRENTKEY(MemberLedgEntry."Customer No.");
       MemberLedgEntry.SETRANGE(MemberLedgEntry."Customer No.","No.");
      IF MemberLedgEntry.FIND('-') THEN
        ERROR(
        Text000,
         CurrentFieldName);
    END;

    PROCEDURE AssistEdit@2(OldCust@1000 : Record 51516223) : Boolean;
    VAR
      Cust@1001 : Record 51516223;
    BEGIN
      WITH Cust DO BEGIN
        Cust := Rec;
        SalesSetup.GET;
        SalesSetup.TESTFIELD(SalesSetup."Members Nos");
        IF NoSeriesMgt.SelectSeries(SalesSetup."Members Nos",OldCust."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := Cust;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Customer,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    PROCEDURE ShowContact@1();
    VAR
      ContBusRel@1000 : Record 5054;
      Cont@1001 : Record 5050;
    BEGIN
      IF "No." = '' THEN
        EXIT;

      ContBusRel.SETCURRENTKEY("Link to Table","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
      ContBusRel.SETRANGE("No.","No.");
      IF NOT ContBusRel.FINDFIRST THEN BEGIN
        IF NOT CONFIRM(Text002,FALSE,TABLECAPTION,"No.") THEN
          EXIT;
        UpdateContFromCust.InsertNewContactMemb(Rec,FALSE);
        ContBusRel.FINDFIRST;
      END;
      COMMIT;

      Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
      Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
      PAGE.RUN(PAGE::"Contact List",Cont);
    END;

    PROCEDURE SetInsertFromContact@3(FromContact@1000 : Boolean);
    BEGIN
      InsertFromContact := FromContact;
    END;

    PROCEDURE CheckBlockedMembOnDocs@5(Cust2@1000 : Record 51516223;DocType@1001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';Shipment@1005 : Boolean;Transaction@1003 : Boolean);
    BEGIN
      WITH Cust2 DO BEGIN
        IF ((Blocked = Blocked::All) OR
            ((Blocked = Blocked::Invoice) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"])) OR
            ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::"Blanket Order"]) AND
             (NOT Transaction)) OR
            ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"]) AND
             Shipment AND Transaction))
        THEN
          CustBlockedErrorMessage(Cust2,Transaction);
      END;
    END;

    PROCEDURE CheckBlockedMembOnJnls@7(Cust2@1003 : Record 51516223;DocType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';Transaction@1000 : Boolean);
    BEGIN
      WITH Cust2 DO BEGIN
        IF (Blocked = Blocked::All) OR
           ((Blocked = Blocked::Invoice) AND (DocType IN [DocType::Invoice,DocType::" "]))
        THEN
          CustBlockedErrorMessage(Cust2,Transaction)
      END;
    END;

    PROCEDURE CustBlockedErrorMessage@4(Cust2@1001 : Record 51516223;Transaction@1000 : Boolean);
    VAR
      Action@1002 : Text[30];
    BEGIN
      // IF Transaction THEN
      //   Action := Text004
      // ELSE
      //   Action := Text005;
      // ERROR(Text006,Action,Cust2."No.",Cust2.Blocked);
    END;

    PROCEDURE DisplayMap@8();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::Customer,GETPOSITION)
      ELSE
        MESSAGE(Text014);
    END;

    PROCEDURE GetTotalAmountLCY@10() : Decimal;
    BEGIN
      CALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
        "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

      EXIT(GetTotalAmountLCYCommon);
    END;

    PROCEDURE GetTotalAmountLCYUI@16() : Decimal;
    BEGIN
      SETAUTOCALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
        "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

      EXIT(GetTotalAmountLCYCommon);
    END;

    LOCAL PROCEDURE GetTotalAmountLCYCommon@17() : Decimal;
    VAR
      SalesLine@1000 : Record 37;
      ServiceLine@1002 : Record 5902;
      SalesOutstandingAmountFromShipment@1001 : Decimal;
      ServOutstandingAmountFromShipment@1003 : Decimal;
      InvoicedPrepmtAmountLCY@1004 : Decimal;
    BEGIN
      SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
      ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
      InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCY;

      EXIT("Balance (LCY)" + "Outstanding Orders (LCY)" + "Shipped Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" +
        "Outstanding Serv. Orders (LCY)" + "Serv Shipped Not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
        SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY);
    END;

    PROCEDURE GetSalesLCY@13() : Decimal;
    VAR
      CustomerSalesYTD@1005 : Record 51516223;
      AccountingPeriod@1004 : Record 50;
      StartDate@1001 : Date;
      EndDate@1000 : Date;
    BEGIN
      StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
      EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);
      CustomerSalesYTD := Rec;
      CustomerSalesYTD."SECURITYFILTERING"("SECURITYFILTERING");
      CustomerSalesYTD.SETRANGE("Date Filter",StartDate,EndDate);
      CustomerSalesYTD.CALCFIELDS("Sales (LCY)");
      EXIT(CustomerSalesYTD."Sales (LCY)");
    END;

    PROCEDURE CalcAvailableCredit@9() : Decimal;
    BEGIN
      EXIT(CalcAvailableCreditCommon(FALSE));
    END;

    PROCEDURE CalcAvailableCreditUI@15() : Decimal;
    BEGIN
      EXIT(CalcAvailableCreditCommon(TRUE));
    END;

    LOCAL PROCEDURE CalcAvailableCreditCommon@14(CalledFromUI@1000 : Boolean) : Decimal;
    BEGIN
      IF "Credit Limit (LCY)" = 0 THEN
        EXIT(0);
      IF CalledFromUI THEN
        EXIT("Credit Limit (LCY)" - GetTotalAmountLCYUI);
      EXIT("Credit Limit (LCY)" - GetTotalAmountLCY);
    END;

    PROCEDURE CalcOverdueBalance@11() OverDueBalance : Decimal;
    VAR
      CustLedgEntryRemainAmtQuery@1000 : Query 21 SECURITYFILTERING(Filtered);
    BEGIN
      CustLedgEntryRemainAmtQuery.SETRANGE(Customer_No,"No.");
      CustLedgEntryRemainAmtQuery.SETRANGE(IsOpen,TRUE);
      CustLedgEntryRemainAmtQuery.SETFILTER(Due_Date,'<%1',WORKDATE);
      CustLedgEntryRemainAmtQuery.OPEN;

      IF CustLedgEntryRemainAmtQuery.READ THEN
        OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    END;

    PROCEDURE ValidateRFCNo@1020000(Length@1020000 : Integer);
    BEGIN

      {
      IF STRLEN("RFC No.") <> Length THEN
        ERROR(Text10000,"RFC No.");
      }
    END;

    PROCEDURE GetLegalEntityType@6() : Text;
    BEGIN
      //EXIT(FORMAT("Tax Identification Type"));
    END;

    PROCEDURE GetLegalEntityTypeLbl@26() : Text;
    BEGIN
      //EXIT(FIELDCAPTION("Tax Identification Type"));
    END;

    PROCEDURE SetStyle@12() : Text;
    BEGIN
      IF CalcAvailableCredit < 0 THEN
        EXIT('Unfavorable');
      EXIT('');
    END;

    PROCEDURE HasValidDDMandate@23(Date@1000 : Date) : Boolean;
    VAR
      SEPADirectDebitMandate@1001 : Record 1230;
    BEGIN
      EXIT(SEPADirectDebitMandate.GetDefaultMandate("No.",Date) <> '');
    END;

    PROCEDURE GetInvoicedPrepmtAmountLCY@18() : Decimal;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
      SalesLine.SETRANGE("Bill-to Customer No.","No.");
      SalesLine.CALCSUMS("Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
      EXIT(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    END;

    PROCEDURE CalcCreditLimitLCYExpendedPct@19() : Decimal;
    BEGIN
      IF "Credit Limit (LCY)" = 0 THEN
        EXIT(0);

      IF "Balance (LCY)" / "Credit Limit (LCY)" < 0 THEN
        EXIT(0);

      IF "Balance (LCY)" / "Credit Limit (LCY)" > 1 THEN
        EXIT(10000);

      EXIT(ROUND("Balance (LCY)" / "Credit Limit (LCY)" * 10000,1));
    END;

    PROCEDURE CreateAndShowNewInvoice@21();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUNMODAL(PAGE::"Mini Sales Invoice",SalesHeader)
    END;

    PROCEDURE CreateAndShowNewCreditMemo@22();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUNMODAL(PAGE::"Mini Sales Credit Memo",SalesHeader)
    END;

    PROCEDURE CreateAndShowNewQuote@24();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUNMODAL(PAGE::"Mini Sales Quote",SalesHeader)
    END;

    LOCAL PROCEDURE UpdatePaymentTolerance@20(UseDialog@1000 : Boolean);
    BEGIN
      {
      IF "Block Payment Tolerance" THEN BEGIN
        IF UseDialog THEN
          IF NOT CONFIRM(RemovePaymentRoleranceQst,FALSE) THEN
            EXIT;
        PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
      END ELSE BEGIN
        IF UseDialog THEN
          IF NOT CONFIRM(AllowPaymentToleranceQst,FALSE) THEN
            EXIT;
        PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
      END;
      }
    END;

    PROCEDURE GetBillToCustomerNo@27() : Code[20];
    BEGIN
      IF "Bill-to Customer No." <> '' THEN
        EXIT("Bill-to Customer No.");
      EXIT("No.");
    END;

    PROCEDURE ValidateDateOfBirth@1120054000();
    VAR
      err_dob@1120054000 : TextConst 'ENU=%1, does not have a date of birth in the BOSA Account.';
    BEGIN
      IF "Date of Birth" = 0D THEN
          ERROR(STRSUBSTNO(err_dob,"No."+' '+Name));
    END;

    BEGIN
    END.
  }
}

