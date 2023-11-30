OBJECT table 50043 Purchase Quote Header
{
  OBJECT-PROPERTIES
  {
    Date=04/13/18;
    Time=[ 9:49:34 AM];
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               //Check if the number has been inserted by the user
               IF "No."='' THEN
                 BEGIN
                   PurchSetup.RESET;
                   PurchSetup.GET();
                   PurchSetup.TESTFIELD(PurchSetup."Quotation Request No");
                   NoSeriesMgt.InitSeries(PurchSetup."Quotation Request No",xRec."No. Series",TODAY,"No.","No. Series");
                 END;
             END;

    OnModify=BEGIN
               IF xRec."No."<>"No." THEN
                 BEGIN
                   PurchSetup.GET();
                   NoSeriesMgt.TestManual(PurchSetup."Quotation Request No");
                 END;
             END;

    CaptionML=ENU=Purchase Header;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=ENU=Document Type;
                                                   OptionCaptionML=ENU=Quotation Request,Open Tender,Restricted Tender;
                                                   OptionString=Quotation Request,Open Tender,Restricted Tender }
    { 3   ;   ;No.                 ;Code20        ;CaptionML=ENU=No.;
                                                   Editable=No }
    { 11  ;   ;Your Reference      ;Text30        ;CaptionML=ENU=Your Reference }
    { 12  ;   ;Ship-to Code        ;Code10        ;TableRelation=Location.Code WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                IF "Ship-to Code"<>'' THEN BEGIN
                                                                  location.GET("Ship-to Code");
                                                                    "Location Code":="Ship-to Code";
                                                                    "Ship-to Name":=location.Name;
                                                                    "Ship-to Name 2":=location."Name 2";
                                                                    "Ship-to Address":=location.Address;
                                                                    "Ship-to Address 2":=location."Address 2";
                                                                    "Ship-to City":=location.City;
                                                                    "Ship-to Contact":=location.Contact;
                                                                END
                                                              END;

                                                   CaptionML=ENU=Ship-to Code }
    { 13  ;   ;Ship-to Name        ;Text50        ;CaptionML=ENU=Ship-to Name }
    { 14  ;   ;Ship-to Name 2      ;Text50        ;CaptionML=ENU=Ship-to Name 2 }
    { 15  ;   ;Ship-to Address     ;Text50        ;CaptionML=ENU=Ship-to Address }
    { 16  ;   ;Ship-to Address 2   ;Text50        ;CaptionML=ENU=Ship-to Address 2 }
    { 17  ;   ;Ship-to City        ;Text30        ;CaptionML=ENU=Ship-to City }
    { 18  ;   ;Ship-to Contact     ;Text50        ;CaptionML=ENU=Ship-to Contact }
    { 19  ;   ;Expected Opening Date;Date         ;CaptionML=ENU=Expected Opening Date }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=ENU=Posting Date }
    { 21  ;   ;Expected Closing Date;Date         ;CaptionML=ENU=Expected Closing Date }
    { 22  ;   ;Posting Description ;Text50        ;CaptionML=ENU=Posting Description }
    { 23  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=ENU=Payment Terms Code }
    { 24  ;   ;Due Date            ;Date          ;CaptionML=ENU=Due Date }
    { 25  ;   ;Payment Discount %  ;Decimal       ;CaptionML=ENU=Payment Discount %;
                                                   DecimalPlaces=0:5 }
    { 26  ;   ;Pmt. Discount Date  ;Date          ;CaptionML=ENU=Pmt. Discount Date }
    { 27  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=ENU=Shipment Method Code }
    { 28  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=ENU=Location Code }
    { 29  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Shortcut Dimension 1 Code;
                                                   CaptionClass='1,2,1' }
    { 30  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   CaptionClass='1,2,2' }
    { 31  ;   ;Vendor Posting Group;Code10        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=ENU=Vendor Posting Group;
                                                   Editable=No }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code }
    { 33  ;   ;Currency Factor     ;Decimal       ;CaptionML=ENU=Currency Factor;
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 35  ;   ;Prices Including VAT;Boolean       ;OnValidate=VAR
                                                                PurchLine@1000 : Record 39;
                                                                Currency@1001 : Record 4;
                                                                RecalculatePrice@1002 : Boolean;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Prices Including VAT }
    { 37  ;   ;Invoice Disc. Code  ;Code20        ;CaptionML=ENU=Invoice Disc. Code }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=ENU=Language Code }
    { 43  ;   ;Purchaser Code      ;Code10        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=VAR
                                                                ApprovalEntry@1001 : Record 454;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Purchaser Code }
    { 45  ;   ;Order Class         ;Code10        ;CaptionML=ENU=Order Class }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Purch. Comment Line" WHERE (Document Type=FIELD(Document Type),
                                                                                                  No.=FIELD(No.),
                                                                                                  Document Line No.=CONST(0)));
                                                   CaptionML=ENU=Comment;
                                                   Editable=No }
    { 47  ;   ;No. Printed         ;Integer       ;CaptionML=ENU=No. Printed;
                                                   Editable=No }
    { 51  ;   ;On Hold             ;Code3         ;CaptionML=ENU=On Hold }
    { 52  ;   ;Applies-to Doc. Type;Option        ;CaptionML=ENU=Applies-to Doc. Type;
                                                   OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 53  ;   ;Applies-to Doc. No. ;Code20        ;CaptionML=ENU=Applies-to Doc. No. }
    { 55  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   CaptionML=ENU=Bal. Account No. }
    { 57  ;   ;Receive             ;Boolean       ;CaptionML=ENU=Receive }
    { 58  ;   ;Invoice             ;Boolean       ;CaptionML=ENU=Invoice }
    { 60  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line".Amount WHERE (Document Type=FIELD(Document Type),
                                                                                                 Document No.=FIELD(No.)));
                                                   CaptionML=ENU=Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amount Including VAT" WHERE (Document Type=FIELD(Document Type),
                                                                                                                 Document No.=FIELD(No.)));
                                                   CaptionML=ENU=Amount Including VAT;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 62  ;   ;Receiving No.       ;Code20        ;CaptionML=ENU=Receiving No. }
    { 63  ;   ;Posting No.         ;Code20        ;CaptionML=ENU=Posting No. }
    { 64  ;   ;Last Receiving No.  ;Code20        ;TableRelation="Purch. Rcpt. Header";
                                                   CaptionML=ENU=Last Receiving No.;
                                                   Editable=No }
    { 65  ;   ;Last Posting No.    ;Code20        ;TableRelation="Purch. Inv. Header";
                                                   CaptionML=ENU=Last Posting No.;
                                                   Editable=No }
    { 73  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=ENU=Reason Code }
    { 74  ;   ;Gen. Bus. Posting Group;Code10     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=ENU=Gen. Bus. Posting Group }
    { 76  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=ENU=Transaction Type }
    { 77  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=ENU=Transport Method }
    { 78  ;   ;VAT Country/Region Code;Code10     ;TableRelation=Country/Region;
                                                   CaptionML=ENU=VAT Country/Region Code }
    { 91  ;   ;Ship-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Ship-to Post Code }
    { 92  ;   ;Ship-to County      ;Text30        ;CaptionML=ENU=Ship-to County }
    { 93  ;   ;Ship-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=ENU=Ship-to Country/Region Code }
    { 94  ;   ;Bal. Account Type   ;Option        ;CaptionML=ENU=Bal. Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Bank Account;
                                                   OptionString=G/L Account,Bank Account }
    { 95  ;   ;Order Address Code  ;Code10        ;OnValidate=VAR
                                                                PayToVend@1000 : Record 23;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Order Address Code }
    { 97  ;   ;Entry Point         ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=ENU=Entry Point }
    { 98  ;   ;Correction          ;Boolean       ;CaptionML=ENU=Correction }
    { 99  ;   ;Document Date       ;Date          ;CaptionML=ENU=Document Date }
    { 101 ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=ENU=Area }
    { 102 ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=ENU=Transaction Specification }
    { 104 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=ENU=Payment Method Code }
    { 107 ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 108 ;   ;Posting No. Series  ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Posting No. Series }
    { 109 ;   ;Receiving No. Series;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Receiving No. Series }
    { 114 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=ENU=Tax Area Code }
    { 115 ;   ;Tax Liable          ;Boolean       ;CaptionML=ENU=Tax Liable }
    { 116 ;   ;VAT Bus. Posting Group;Code10      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=ENU=VAT Bus. Posting Group }
    { 118 ;   ;Applies-to ID       ;Code20        ;OnValidate=VAR
                                                                TempVendLedgEntry@1000 : Record 25;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Applies-to ID }
    { 119 ;   ;VAT Base Discount % ;Decimal       ;OnValidate=VAR
                                                                ChangeLogMgt@1002 : Codeunit 423;
                                                                RecRef@1001 : RecordRef;
                                                                xRecRef@1000 : RecordRef;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=VAT Base Discount %;
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 120 ;   ;Status              ;Option        ;CaptionML=ENU=Status;
                                                   OptionCaptionML=ENU=Open,Released,Pending Approval,Pending Prepayment;
                                                   OptionString=Open,Released,Pending Approval,Pending Prepayment,Closed,Cancelled,Stopped;
                                                   Editable=No }
    { 121 ;   ;Invoice Discount Calculation;Option;CaptionML=ENU=Invoice Discount Calculation;
                                                   OptionCaptionML=ENU=None,%,Amount;
                                                   OptionString=None,%,Amount;
                                                   Editable=No }
    { 122 ;   ;Invoice Discount Value;Decimal     ;CaptionML=ENU=Invoice Discount Value;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 123 ;   ;Send IC Document    ;Boolean       ;CaptionML=ENU=Send IC Document }
    { 124 ;   ;IC Status           ;Option        ;CaptionML=ENU=IC Status;
                                                   OptionCaptionML=ENU=New,Pending,Sent;
                                                   OptionString=New,Pending,Sent }
    { 125 ;   ;Buy-from IC Partner Code;Code20    ;TableRelation="IC Partner";
                                                   CaptionML=ENU=Buy-from IC Partner Code;
                                                   Editable=No }
    { 126 ;   ;Pay-to IC Partner Code;Code20      ;TableRelation="IC Partner";
                                                   CaptionML=ENU=Pay-to IC Partner Code;
                                                   Editable=No }
    { 129 ;   ;IC Direction        ;Option        ;CaptionML=ENU=IC Direction;
                                                   OptionCaptionML=ENU=Outgoing,Incoming;
                                                   OptionString=Outgoing,Incoming }
    { 151 ;   ;Quote No.           ;Code20        ;CaptionML=ENU=Quote No.;
                                                   Editable=No }
    { 5043;   ;No. of Archived Versions;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Max("Purchase Header Archive"."Version No." WHERE (Document Type=FIELD(Document Type),
                                                                                                                  No.=FIELD(No.),
                                                                                                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
                                                   CaptionML=ENU=No. of Archived Versions;
                                                   Editable=No }
    { 5048;   ;Doc. No. Occurrence ;Integer       ;CaptionML=ENU=Doc. No. Occurrence }
    { 5050;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   CaptionML=ENU=Campaign No. }
    { 5052;   ;Buy-from Contact No.;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                ContBusinessRelation@1000 : Record 5054;
                                                                Cont@1002 : Record 5050;
                                                              BEGIN
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusinessRelation@1000 : Record 5054;
                                                            BEGIN
                                                            END;

                                                   CaptionML=ENU=Buy-from Contact No. }
    { 5053;   ;Pay-to Contact No.  ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                ContBusinessRelation@1004 : Record 5054;
                                                                Cont@1002 : Record 5050;
                                                              BEGIN
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1000 : Record 5050;
                                                              ContBusinessRelation@1001 : Record 5054;
                                                            BEGIN
                                                            END;

                                                   CaptionML=ENU=Pay-to Contact No. }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation=Table56016;
                                                   CaptionML=ENU=Responsibility Center }
    { 5752;   ;Completely Received ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Purchase Line"."Completely Received" WHERE (Document Type=FIELD(Document Type),
                                                                                                                Document No.=FIELD(No.),
                                                                                                                Type=FILTER(<>' '),
                                                                                                                Location Code=FIELD(Location Filter)));
                                                   CaptionML=ENU=Completely Received;
                                                   Editable=No }
    { 5753;   ;Posting from Whse. Ref.;Integer    ;CaptionML=ENU=Posting from Whse. Ref. }
    { 5754;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   CaptionML=ENU=Location Filter }
    { 5790;   ;Requested Receipt Date;Date        ;CaptionML=ENU=Requested Receipt Date }
    { 5791;   ;Promised Receipt Date;Date         ;CaptionML=ENU=Promised Receipt Date }
    { 5792;   ;Lead Time Calculation;DateFormula  ;CaptionML=ENU=Lead Time Calculation }
    { 5793;   ;Inbound Whse. Handling Time;DateFormula;
                                                   CaptionML=ENU=Inbound Whse. Handling Time }
    { 5796;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Date Filter }
    { 5801;   ;Return Shipment No. ;Code20        ;CaptionML=ENU=Return Shipment No. }
    { 5802;   ;Return Shipment No. Series;Code10  ;TableRelation="No. Series";
                                                   CaptionML=ENU=Return Shipment No. Series }
    { 5803;   ;Ship                ;Boolean       ;CaptionML=ENU=Ship }
    { 5804;   ;Last Return Shipment No.;Code20    ;TableRelation="Return Shipment Header";
                                                   CaptionML=ENU=Last Return Shipment No.;
                                                   Editable=No }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   CaptionML=ENU=Assigned User ID }
    { 54240;  ;Copied              ;Boolean        }
    { 54241;  ;Debit Note          ;Boolean        }
    { 54243;  ;PRF No              ;Code10        ;TableRelation="Purchase Header".No. WHERE (Document Type=CONST(Quote),
                                                                                              Status=FILTER(Released));
                                                   OnValidate=BEGIN
                                                                  AutoPopPurchLine;
                                                              END;

                                                   OnLookup=BEGIN
                                                              PurchHeader.RESET;
                                                              PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                                                              PurchHeader.SETRANGE(PurchHeader.DocApprovalType,PurchHeader.DocApprovalType::Requisition);
                                                              PurchHeader.SETRANGE(PurchHeader.Status,PurchHeader.Status::Released);
                                                              IF PAGE.RUNMODAL(53,PurchHeader)=ACTION::LookupOK THEN
                                                              BEGIN
                                                                "PRF No":=PurchHeader."No.";
                                                                VALIDATE("PRF No");
                                                              END
                                                            END;
                                                             }
    { 54244;  ;Released By         ;Code50         }
    { 54245;  ;Release Date        ;Date           }
    { 55536;  ;Cancelled           ;Boolean        }
    { 55537;  ;Cancelled By        ;Code50         }
    { 55538;  ;Cancelled Date      ;Date           }
    { 55539;  ;DocApprovalType     ;Option        ;OptionString=Purchase,Requisition,Quote }
    { 55540;  ;Procurement Type Code;Code20       ;TableRelation=Transactions }
    { 99008500;;Date Received      ;Date          ;CaptionML=ENU=Date Received }
    { 99008501;;Time Received      ;Time          ;CaptionML=ENU=Time Received }
    { 99008504;;BizTalk Purchase Quote;Boolean    ;CaptionML=ENU=BizTalk Purchase Quote }
    { 99008505;;BizTalk Purch. Order Cnfmn.;Boolean;
                                                   CaptionML=ENU=BizTalk Purch. Order Cnfmn. }
    { 99008506;;BizTalk Purchase Invoice;Boolean  ;CaptionML=ENU=BizTalk Purchase Invoice }
    { 99008507;;BizTalk Purchase Receipt;Boolean  ;CaptionML=ENU=BizTalk Purchase Receipt }
    { 99008508;;BizTalk Purchase Credit Memo;Boolean;
                                                   CaptionML=ENU=BizTalk Purchase Credit Memo }
    { 99008509;;Date Sent          ;Date          ;CaptionML=ENU=Date Sent }
    { 99008510;;Time Sent          ;Time          ;CaptionML=ENU=Time Sent }
    { 99008511;;BizTalk Request for Purch. Qte;Boolean;
                                                   CaptionML=ENU=BizTalk Request for Purch. Qte }
    { 99008512;;BizTalk Purchase Order;Boolean    ;CaptionML=ENU=BizTalk Purchase Order }
    { 99008520;;Vendor Quote No.   ;Code20        ;CaptionML=ENU=Vendor Quote No. }
    { 99008521;;BizTalk Document Sent;Boolean     ;CaptionML=ENU=BizTalk Document Sent }
  }
  KEYS
  {
    {    ;Document Type,No.                       ;Clustered=Yes }
    {    ;No.,Document Type                        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=Do you want to print receipt %1?';
      Text001@1001 : TextConst 'ENU=Do you want to print invoice %1?';
      Text002@1002 : TextConst 'ENU=Do you want to print credit memo %1?';
      Text003@1003 : TextConst 'ENU=You cannot rename a %1.';
      Text004@1004 : TextConst 'ENU=Do you want to change %1?';
      Text005@1005 : TextConst 'ENU=You cannot reset %1 because the document still has one or more lines.';
      Text006@1006 : TextConst 'ENU=You cannot change %1 because the order is associated with one or more sales orders.';
      Text007@1007 : TextConst 'ENU=%1 is greater than %2 in the %3 table.\';
      Text008@1008 : TextConst 'ENU=Confirm change?';
      Text009@1009 : TextConst 'ENU="Deleting this document will cause a gap in the number series for receipts. "';
      Text010@1010 : TextConst 'ENU=An empty receipt %1 will be created to fill this gap in the number series.\\';
      Text011@1011 : TextConst 'ENU=Do you want to continue?';
      Text012@1012 : TextConst 'ENU="Deleting this document will cause a gap in the number series for posted invoices. "';
      Text013@1013 : TextConst 'ENU=An empty posted invoice %1 will be created to fill this gap in the number series.\\';
      Text014@1014 : TextConst 'ENU="Deleting this document will cause a gap in the number series for posted credit memos. "';
      Text015@1015 : TextConst 'ENU=An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
      Text016@1016 : TextConst 'ENU=If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\';
      Text018@1017 : TextConst 'ENU=You must delete the existing purchase lines before you can change %1.';
      Text019@1018 : TextConst 'ENU=You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\';
      Text020@1019 : TextConst 'ENU=You must update the existing purchase lines manually.';
      Text021@1020 : TextConst 'ENU=The change may affect the exchange rate used on the price calculation of the purchase lines.';
      Text022@1021 : TextConst 'ENU=Do you want to update the exchange rate?';
      Text023@1022 : TextConst 'ENU=You cannot delete this document. Your identification is set up to process from %1 %2 only.';
      Text024@1023 : TextConst 'ENU=Do you want to print return shipment %1?';
      Text025@1024 : TextConst 'ENU="You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. "';
      Text027@1026 : TextConst 'ENU=Do you want to update the %2 field on the lines to reflect the new value of %1?';
      Text028@1027 : TextConst 'ENU=Your identification is set up to process from %1 %2 only.';
      Text029@1028 : TextConst 'ENU="Deleting this document will cause a gap in the number series for return shipments. "';
      Text030@1029 : TextConst 'ENU=An empty return shipment %1 will be created to fill this gap in the number series.\\';
      Text032@1031 : TextConst 'ENU=You have modified %1.\\';
      Text033@1032 : TextConst 'ENU=Do you want to update the lines?';
      Text034@1072 : TextConst 'ENU=You cannot change the %1 when the %2 has been filled in.';
      Text037@1076 : TextConst 'ENU=Contact %1 %2 is not related to vendor %3.';
      Text038@1075 : TextConst 'ENU=Contact %1 %2 is related to a different company than vendor %3.';
      Text039@1077 : TextConst 'ENU=Contact %1 %2 is not related to a vendor.';
      Text040@1079 : TextConst 'ENU="You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8."';
      Text041@1182 : TextConst 'ENU=The purchase %1 %2 has item tracking. Do you want to delete it anyway?';
      Text042@1084 : TextConst 'ENU=You must cancel the approval process if you wish to change the %1.';
      Text043@1083 : TextConst 'ENU=Do you want to print prepayment invoice %1?';
      Text044@1085 : TextConst 'ENU=Do you want to print prepayment credit memo %1?';
      Text045@1086 : TextConst 'ENU="Deleting this document will cause a gap in the number series for prepayment invoices. "';
      Text046@1087 : TextConst 'ENU=An empty prepayment invoice %1 will be created to fill this gap in the number series.\\';
      Text047@1088 : TextConst 'ENU="Deleting this document will cause a gap in the number series for prepayment credit memos. "';
      Text049@1092 : TextConst 'ENU=%1 is set up to process from %2 %3 only.';
      Text050@1067 : TextConst 'ENU=Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\';
      PurchSetup@1102756000 : Record 312;
      NoSeriesMgt@1102756001 : Codeunit 396;
      location@1102755000 : Record 14;
      PurchHeader@1102755001 : Record 38;

    PROCEDURE AutoPopPurchLine@1000000000();
    VAR
      reqLine@1000000006 : Record 39;
      PurchLine2@1000000007 : Record 51516055;
      LineNo@1000000008 : Integer;
      delReqLine@1000000000 : Record 51516055;
    BEGIN
      PurchLine2.SETRANGE("Document Type","Document Type");
      PurchLine2.SETRANGE("Document No.","No.");
      PurchLine2.DELETEALL;
      PurchLine2.RESET;

      //reqLine.SETRANGE(reqLine."Document Type","Document Type");
      reqLine.SETRANGE(reqLine."Document No.","PRF No");

      IF reqLine.FIND('-') THEN
       BEGIN
        PurchLine2.INIT;
        REPEAT
         IF reqLine.Quantity<>0 THEN
         BEGIN
           LineNo:=LineNo+1000;
           PurchLine2."Document Type":="Document Type";
           PurchLine2.VALIDATE("Document Type");
           PurchLine2."Document No.":="No.";
           PurchLine2.VALIDATE("Document No.");
           PurchLine2."Line No.":=LineNo;
           PurchLine2.Type:=reqLine.Type;
           PurchLine2."Expense Code":=reqLine."Expense Code";    //Denno added---
           PurchLine2."No.":=reqLine."No.";
           PurchLine2.VALIDATE("No.");
           PurchLine2.Description:=reqLine.Description;
           PurchLine2.Quantity:=reqLine.Quantity;
           PurchLine2.VALIDATE(Quantity);
           PurchLine2."Unit of Measure Code":=reqLine."Unit of Measure Code";
           PurchLine2.VALIDATE("Unit of Measure Code");
           PurchLine2."Unit of Measure":=reqLine."Unit of Measure";
           PurchLine2."Direct Unit Cost":=reqLine."Direct Unit Cost";
           PurchLine2.VALIDATE("Direct Unit Cost");
           PurchLine2."Location Code":=reqLine."Location Code";
           PurchLine2."Location Code":="Location Code";
           PurchLine2."Shortcut Dimension 1 Code":="Shortcut Dimension 1 Code";
           PurchLine2."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
           PurchLine2.INSERT(TRUE);
         END
        UNTIL reqLine.NEXT=0;
       END;
    END;

    BEGIN
    END.
  }
}

