OBJECT table 50058 Gen. Journal Line-tes
{
  OBJECT-PROPERTIES
  {
    Date=10/08/20;
    Time=[ 3:37:46 PM];
    Modified=Yes;
    Version List=NAVW19.00,NAVNA9.00;
  }
  PROPERTIES
  {
    Permissions=TableData 1221=rimd;
    OnInsert=BEGIN
               GenJnlAlloc.LOCKTABLE;
               LOCKTABLE;
             END;

    CaptionML=[ENU=Gen. Journal Line;
               ESM=L n. diario general;
               FRC=Ligne journal g n ral;
               ENC=Gen. Journal Line];
    PasteIsValid=No;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code20       ;TableRelation="Gen. Journal Template";
                                                   CaptionML=[ENU=Journal Template Name;
                                                              ESM=Nombre libro diario;
                                                              FRC=Nom mod le journal;
                                                              ENC=Journal Template Name] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[ENU=Line No.;
                                                              ESM=N  l nea;
                                                              FRC=N  ligne;
                                                              ENC=Line No.] }
    { 3   ;   ;Account Type        ;Option        ;CaptionML=[ENU=Account Type;
                                                              ESM=Tipo mov.;
                                                              FRC=Type de compte;
                                                              ENC=Account Type];
                                                   OptionCaptionML=[ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor;
                                                                    ESM=Cuenta,Cliente,Proveedor,Banco,Activo,Empresa vinculada asociada;
                                                                    FRC=Compte du grand livre,Client,Fournisseur,Compte bancaire,Immobilisation,Partenaire IC;
                                                                    ENC=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor }
    { 4   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                                                           Blocked=CONST(No))
                                                                                                                           ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                                                           ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                                                                           ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                                                           ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                           ELSE IF (Account Type=CONST(IC Partner)) "IC Partner"
                                                                                                                           ELSE IF (Account Type=CONST(Member)) "Members Register";
                                                   CaptionML=[ENU=Account No.;
                                                              ESM=N  cuenta;
                                                              FRC=N  de compte;
                                                              ENC=Account No.] }
    { 5   ;   ;Posting Date        ;Date          ;CaptionML=[ENU=Posting Date;
                                                              ESM=Fecha registro;
                                                              FRC=Date de report;
                                                              ENC=Posting Date];
                                                   ClosingDates=Yes }
    { 6   ;   ;Document Type       ;Option        ;CaptionML=[ENU=Document Type;
                                                              ESM=Tipo documento;
                                                              FRC=Type de document;
                                                              ENC=Document Type];
                                                   OptionCaptionML=[ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                                    ESM=" ,Pago,Factura,Nota cr dito,Docs. inter s,Recordatorio,Reembolso";
                                                                    FRC=" ,Paiement,Facture,Note de cr dit,Note de frais financiers,Rappel,Remboursement";
                                                                    ENC=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 7   ;   ;Document No.        ;Code30        ;CaptionML=[ENU=Document No.;
                                                              ESM=N  documento;
                                                              FRC=N  de document;
                                                              ENC=Document No.] }
    { 8   ;   ;Description         ;Text100       ;CaptionML=[ENU=Description;
                                                              ESM=Descripci n;
                                                              FRC=Description;
                                                              ENC=Description] }
    { 10  ;   ;VAT %               ;Decimal       ;CaptionML=[ENU=Tax %;
                                                              ESM=% IVA;
                                                              FRC=% TVA;
                                                              ENC=Tax %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 11  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                                                                Blocked=CONST(No))
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                                ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner";
                                                   CaptionML=[ENU=Bal. Account No.;
                                                              ESM=Cta. contrapartida;
                                                              FRC=N  compte contr le;
                                                              ENC=Bal. Account No.] }
    { 12  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[ENU=Currency Code;
                                                              ESM=C d. divisa;
                                                              FRC=Code devise;
                                                              ENC=Currency Code] }
    { 13  ;   ;Amount              ;Decimal       ;CaptionML=[ENU=Amount;
                                                              ESM=Importe;
                                                              FRC=Montant;
                                                              ENC=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Debit Amount        ;Decimal       ;CaptionML=[ENU=Debit Amount;
                                                              ESM=Importe debe;
                                                              FRC=Montant de d bit;
                                                              ENC=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Credit Amount       ;Decimal       ;CaptionML=[ENU=Credit Amount;
                                                              ESM=Importe haber;
                                                              FRC=Montant de cr dit;
                                                              ENC=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 16  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[ENU=Amount ($);
                                                              ESM=Importe ($);
                                                              FRC=Montant ($);
                                                              ENC=Amount ($)];
                                                   AutoFormatType=1 }
    { 17  ;   ;Balance (LCY)       ;Decimal       ;CaptionML=[ENU=Balance ($);
                                                              ESM=Saldo ($);
                                                              FRC=Solde ($);
                                                              ENC=Balance ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 18  ;   ;Currency Factor     ;Decimal       ;CaptionML=[ENU=Currency Factor;
                                                              ESM=Factor divisa;
                                                              FRC=Facteur devise;
                                                              ENC=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 19  ;   ;Sales/Purch. (LCY)  ;Decimal       ;CaptionML=[ENU=Sales/Purch. ($);
                                                              ESM=Venta/Compra ($);
                                                              FRC=Ventes/Achats ($);
                                                              ENC=Sales/Purch. ($)];
                                                   AutoFormatType=1 }
    { 20  ;   ;Profit (LCY)        ;Decimal       ;CaptionML=[ENU=Profit ($);
                                                              ESM=Bf  bruto ($);
                                                              FRC=Profit ($);
                                                              ENC=Profit ($)];
                                                   AutoFormatType=1 }
    { 21  ;   ;Inv. Discount (LCY) ;Decimal       ;CaptionML=[ENU=Inv. Discount ($);
                                                              ESM=Dto. factura ($);
                                                              FRC=Escompte facture ($);
                                                              ENC=Inv. Discount ($)];
                                                   AutoFormatType=1 }
    { 22  ;   ;Bill-to/Pay-to No.  ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
                                                   CaptionML=[ENU=Bill-to/Pay-to No.;
                                                              ESM=Fact./Pago a N .;
                                                              FRC=N  de Facture  /Paiement  ;
                                                              ENC=Bill-to/Pay-to No.];
                                                   Editable=No }
    { 23  ;   ;Posting Group       ;Code10        ;TableRelation=IF (Account Type=CONST(Customer)) "Customer Posting Group"
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group"
                                                                 ELSE IF (Account Type=CONST(Fixed Asset)) "FA Posting Group";
                                                   CaptionML=[ENU=Posting Group;
                                                              ESM=Grupo contable;
                                                              FRC=Param tre report;
                                                              ENC=Posting Group] }
    { 24  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[ENU=Shortcut Dimension 1 Code;
                                                              ESM=C d. dim. acceso dir. 1;
                                                              FRC=Code raccourci de dimension 1;
                                                              ENC=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 25  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[ENU=Shortcut Dimension 2 Code;
                                                              ESM=C d. dim. acceso dir. 2;
                                                              FRC=Code raccourci de dimension 2;
                                                              ENC=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 26  ;   ;Salespers./Purch. Code;Code10      ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[ENU=Salespers./Purch. Code;
                                                              ESM=C d. vendedor/comprador;
                                                              FRC=Code de repr sentant/d'achat;
                                                              ENC=Salespers./Purch. Code] }
    { 29  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[ENU=Source Code;
                                                              ESM=C d. origen;
                                                              FRC=Code d'origine;
                                                              ENC=Source Code];
                                                   Editable=No }
    { 30  ;   ;System-Created Entry;Boolean       ;CaptionML=[ENU=System-Created Entry;
                                                              ESM=Asiento autom tico;
                                                              FRC= criture syst me;
                                                              ENC=System-Created Entry];
                                                   Editable=No }
    { 34  ;   ;On Hold             ;Code3         ;CaptionML=[ENU=On Hold;
                                                              ESM=Esperar;
                                                              FRC=En attente;
                                                              ENC=On Hold] }
    { 35  ;   ;Applies-to Doc. Type;Option        ;OnValidate=BEGIN
                                                                IF "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" THEN
                                                                  VALIDATE("Applies-to Doc. No.",'');
                                                              END;

                                                   CaptionML=[ENU=Applies-to Doc. Type;
                                                              ESM=Liq. por tipo documento;
                                                              FRC=Type document affect   ;
                                                              ENC=Applies-to Doc. Type];
                                                   OptionCaptionML=[ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                                    ESM=" ,Pago,Factura,Nota cr dito,Docs. inter s,Recordatorio,Reembolso";
                                                                    FRC=" ,Paiement,Facture,Note de cr dit,Note de frais financiers,Rappel,Remboursement";
                                                                    ENC=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 36  ;   ;Applies-to Doc. No. ;Code20        ;OnValidate=VAR
                                                                CustLedgEntry@1000 : Record 21;
                                                                VendLedgEntry@1003 : Record 25;
                                                                TempGenJnlLine@1001 : TEMPORARY Record 81;
                                                              BEGIN
                                                              END;

                                                   OnLookup=VAR
                                                              PaymentToleranceMgt@1001 : Codeunit 426;
                                                              AccType@1002 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
                                                              AccNo@1003 : Code[20];
                                                            BEGIN
                                                            END;

                                                   CaptionML=[ENU=Applies-to Doc. No.;
                                                              ESM=Liq. por n  documento;
                                                              FRC=N  doc. affect   ;
                                                              ENC=Applies-to Doc. No.] }
    { 38  ;   ;Due Date            ;Date          ;CaptionML=[ENU=Due Date;
                                                              ESM=Fecha vencimiento;
                                                              FRC=Date d' ch ance;
                                                              ENC=Due Date] }
    { 39  ;   ;Pmt. Discount Date  ;Date          ;CaptionML=[ENU=Pmt. Discount Date;
                                                              ESM=Fecha dto. P.P.;
                                                              FRC=Date escompte de paiement;
                                                              ENC=Pmt. Discount Date] }
    { 40  ;   ;Payment Discount %  ;Decimal       ;CaptionML=[ENU=Payment Discount %;
                                                              ESM=% Dto. P.P.;
                                                              FRC=% escompte de paiement;
                                                              ENC=Payment Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 42  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[ENU=Job No.;
                                                              ESM=N  proyecto;
                                                              FRC=N  projet;
                                                              ENC=Job No.] }
    { 43  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE(Amount);
                                                              END;

                                                   CaptionML=[ENU=Quantity;
                                                              ESM=Cantidad;
                                                              FRC=Quantit ;
                                                              ENC=Quantity];
                                                   DecimalPlaces=0:5 }
    { 44  ;   ;VAT Amount          ;Decimal       ;CaptionML=[ENU=Tax Amount;
                                                              ESM=Importe IVA;
                                                              FRC=Montant de TVA;
                                                              ENC=Tax Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 45  ;   ;VAT Posting         ;Option        ;CaptionML=[ENU=Tax Posting;
                                                              ESM=Tipo mov. IVA;
                                                              FRC=Report TVA;
                                                              ENC=Tax Posting];
                                                   OptionCaptionML=[ENU=Automatic VAT Entry,Manual VAT Entry;
                                                                    ESM=Autom tico,Manual;
                                                                    FRC= criture TVA automatique, criture TVA manuelle;
                                                                    ENC=Automatic VAT Entry,Manual VAT Entry];
                                                   OptionString=Automatic VAT Entry,Manual VAT Entry;
                                                   Editable=No }
    { 47  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=[ENU=Payment Terms Code;
                                                              ESM=C d. t rminos pago;
                                                              FRC=Code modalit s de paiement;
                                                              ENC=Payment Terms Code] }
    { 48  ;   ;Applies-to ID       ;Code50        ;CaptionML=[ENU=Applies-to ID;
                                                              ESM=Liq. por id.;
                                                              FRC=Code affect   ;
                                                              ENC=Applies-to ID] }
    { 50  ;   ;Business Unit Code  ;Code10        ;TableRelation="Business Unit";
                                                   CaptionML=[ENU=Business Unit Code;
                                                              ESM=C d. empresa;
                                                              FRC=Code d'unit  fonctionnelle;
                                                              ENC=Business Unit Code] }
    { 51  ;   ;Journal Batch Name  ;Code20        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   CaptionML=[ENU=Journal Batch Name;
                                                              ESM=Nombre secci n diario;
                                                              FRC=Nom lot de journal;
                                                              ENC=Journal Batch Name] }
    { 52  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[ENU=Reason Code;
                                                              ESM=C d. auditor a;
                                                              FRC=Code motif;
                                                              ENC=Reason Code] }
    { 53  ;   ;Recurring Method    ;Option        ;OnValidate=BEGIN
                                                                IF "Recurring Method" IN
                                                                   ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]
                                                                THEN
                                                                  TESTFIELD("Currency Code",'');
                                                              END;

                                                   CaptionML=[ENU=Recurring Method;
                                                              ESM=Periodicidad;
                                                              FRC=M thode r currente;
                                                              ENC=Recurring Method];
                                                   OptionCaptionML=[ENU=" ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance";
                                                                    ESM=" ,F  Fijo,V  Variable,S Saldo,CF Contraasiento fijo,CV Contraasiento variable,CS Contraasiento saldo";
                                                                    FRC=" ,F Fixe,V Variable,S Solde,CF Contrepassation fixe,CV Contrepassation variable,CS Contrepassation solde";
                                                                    ENC=" ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance"];
                                                   OptionString=[ ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance];
                                                   BlankZero=Yes }
    { 54  ;   ;Expiration Date     ;Date          ;CaptionML=[ENU=Expiration Date;
                                                              ESM=Fecha caducidad;
                                                              FRC=Date d'expiration;
                                                              ENC=Expiration Date] }
    { 55  ;   ;Recurring Frequency ;DateFormula   ;CaptionML=[ENU=Recurring Frequency;
                                                              ESM=Frecuencia repetici n;
                                                              FRC=Fr quence de r currence;
                                                              ENC=Recurring Frequency] }
    { 56  ;   ;Allocated Amt. (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Gen. Jnl. Allocation".Amount WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                                                        Journal Batch Name=FIELD(Journal Batch Name),
                                                                                                        Journal Line No.=FIELD(Line No.)));
                                                   CaptionML=[ENU=Allocated Amt. ($);
                                                              ESM=Distribuir importe ($);
                                                              FRC=Montant imput  ($);
                                                              ENC=Allocated Amt. ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 57  ;   ;Gen. Posting Type   ;Option        ;CaptionML=[ENU=Gen. Posting Type;
                                                              ESM=Tipo IVA;
                                                              FRC=Type de report g n ral;
                                                              ENC=Gen. Posting Type];
                                                   OptionCaptionML=[ENU=" ,Purchase,Sale,Settlement";
                                                                    ESM=" ,Compra,Venta,Liquidaci n";
                                                                    FRC=" ,Achat,Vente,R glement";
                                                                    ENC=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 58  ;   ;Gen. Bus. Posting Group;Code10     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Gen. Bus. Posting Group",'');
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[ENU=Gen. Bus. Posting Group;
                                                              ESM=Grupo contable negocio;
                                                              FRC=Groupe de report de march ;
                                                              ENC=Gen. Bus. Posting Group] }
    { 59  ;   ;Gen. Prod. Posting Group;Code10    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Gen. Prod. Posting Group",'');
                                                                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[ENU=Gen. Prod. Posting Group;
                                                              ESM=Grupo contable producto;
                                                              FRC=Groupe de report de produit;
                                                              ENC=Gen. Prod. Posting Group] }
    { 60  ;   ;VAT Calculation Type;Option        ;CaptionML=[ENU=Tax Calculation Type;
                                                              ESM=Tipo c lculo IVA;
                                                              FRC=Type de calcul taxe;
                                                              ENC=Tax Calculation Type];
                                                   OptionCaptionML=[ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                                    ESM=Normal,Reversi n,Total,Impto. venta;
                                                                    FRC=TVA normale,Frais renvers s TVA,TVA compl te,Taxe de vente;
                                                                    ENC=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 61  ;   ;EU 3-Party Trade    ;Boolean       ;CaptionML=[ENU=EU 3-Party Trade;
                                                              ESM=Op. triangular;
                                                              FRC=Trans. tripartite UE;
                                                              ENC=EU 3-Party Trade];
                                                   Editable=No }
    { 62  ;   ;Allow Application   ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[ENU=Allow Application;
                                                              ESM=Permite liq. por;
                                                              FRC=Permettre affectation;
                                                              ENC=Allow Application] }
    { 63  ;   ;Bal. Account Type   ;Option        ;CaptionML=[ENU=Bal. Account Type;
                                                              ESM=Tipo contrapartida;
                                                              FRC=Type compte contr le;
                                                              ENC=Bal. Account Type];
                                                   OptionCaptionML=[ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor;
                                                                    ESM=Cuenta,Cliente,Proveedor,Banco,Activo,Empresa vinculada asociada;
                                                                    FRC=Compte du grand livre,Client,Fournisseur,Compte bancaire,Immobilisation,Partenaire IC;
                                                                    ENC=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor }
    { 64  ;   ;Bal. Gen. Posting Type;Option      ;CaptionML=[ENU=Bal. Gen. Posting Type;
                                                              ESM=Tipo regis. contrapartida;
                                                              FRC=Type report g n. solde;
                                                              ENC=Bal. Gen. Posting Type];
                                                   OptionCaptionML=[ENU=" ,Purchase,Sale,Settlement";
                                                                    ESM=" ,Compra,Venta,Liquidaci n";
                                                                    FRC=" ,Achat,Vente,R glement";
                                                                    ENC=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 65  ;   ;Bal. Gen. Bus. Posting Group;Code10;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Bal. Gen. Bus. Posting Group",'');
                                                                IF xRec."Bal. Gen. Bus. Posting Group" <> "Bal. Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Bal. Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("Bal. VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[ENU=Bal. Gen. Bus. Posting Group;
                                                              ESM=Gr. contable negocio contrap.;
                                                              FRC=Par. report march   quilibr ;
                                                              ENC=Bal. Gen. Bus. Posting Group] }
    { 66  ;   ;Bal. Gen. Prod. Posting Group;Code10;
                                                   TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Bal. Gen. Prod. Posting Group",'');
                                                                IF xRec."Bal. Gen. Prod. Posting Group" <> "Bal. Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Bal. Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("Bal. VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[ENU=Bal. Gen. Prod. Posting Group;
                                                              ESM=Gr. contable producto contrap.;
                                                              FRC=Par. report produit  quilibr ;
                                                              ENC=Bal. Gen. Prod. Posting Group] }
    { 67  ;   ;Bal. VAT Calculation Type;Option   ;CaptionML=[ENU=Bal. Tax Calculation Type;
                                                              ESM=Tipo c lculo IVA contrap.;
                                                              FRC=Solde type de calcul taxe;
                                                              ENC=Bal. Tax Calculation Type];
                                                   OptionCaptionML=[ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                                    ESM=Normal,Reversi n,Total,Impto. venta;
                                                                    FRC=TVA normale,Frais renvers s TVA,TVA compl te,Taxe de vente;
                                                                    ENC=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 68  ;   ;Bal. VAT %          ;Decimal       ;CaptionML=[ENU=Bal. Tax %;
                                                              ESM=% IVA contrap.;
                                                              FRC=Solde % taxe;
                                                              ENC=Bal. Tax %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 69  ;   ;Bal. VAT Amount     ;Decimal       ;CaptionML=[ENU=Bal. Tax Amount;
                                                              ESM=Importe IVA contrap.;
                                                              FRC=Solde montant de taxes;
                                                              ENC=Bal. Tax Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Bank Payment Type   ;Option        ;OnValidate=BEGIN
                                                                IF ("Bank Payment Type" <> "Bank Payment Type"::" ") AND
                                                                   ("Account Type" <> "Account Type"::"Bank Account") AND
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
                                                                THEN
                                                                  ERROR(
                                                                    Text007,
                                                                    FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));
                                                                IF ("Account Type" = "Account Type"::"Fixed Asset") AND
                                                                   ("Bank Payment Type" <> "Bank Payment Type"::" ")
                                                                THEN
                                                                  FIELDERROR("Account Type");
                                                              END;

                                                   AccessByPermission=TableData 270=R;
                                                   CaptionML=[ENU=Bank Payment Type;
                                                              ESM=Tipo pago por banco;
                                                              FRC=Type de paiement bancaire;
                                                              ENC=Bank Payment Type];
                                                   OptionCaptionML=[ENU=" ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT";
                                                                    ESM=" ,Cheque autom tico,Cheque manual,Pago electr nico,Pago electr nico-IAT";
                                                                    FRC=" ,Ch que informatis ,Ch que manuel,Paiement  lectronique,Paiement  lectronique-IAT";
                                                                    ENC=" ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT"];
                                                   OptionString=[ ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT] }
    { 71  ;   ;VAT Base Amount     ;Decimal       ;CaptionML=[ENU=Tax Base Amount;
                                                              ESM=Importe base IVA;
                                                              FRC=Montant de base de la taxe;
                                                              ENC=Tax Base Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 72  ;   ;Bal. VAT Base Amount;Decimal       ;CaptionML=[ENU=Bal. Tax Base Amount;
                                                              ESM=Imp. base IVA contrap.;
                                                              FRC=Solde montant de taxe de base;
                                                              ENC=Bal. Tax Base Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 73  ;   ;Correction          ;Boolean       ;OnValidate=BEGIN
                                                                VALIDATE(Amount);
                                                              END;

                                                   CaptionML=[ENU=Correction;
                                                              ESM=Correcci n;
                                                              FRC=Correction;
                                                              ENC=Correction] }
    { 75  ;   ;Check Printed       ;Boolean       ;AccessByPermission=TableData 272=R;
                                                   CaptionML=[ENU=Check Printed;
                                                              ESM=Cheque impreso;
                                                              FRC=Ch que imprim ;
                                                              ENC=Cheque Printed];
                                                   Editable=No }
    { 76  ;   ;Document Date       ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Payment Terms Code");
                                                              END;

                                                   CaptionML=[ENU=Document Date;
                                                              ESM=Fecha emisi n documento;
                                                              FRC=Date document;
                                                              ENC=Document Date];
                                                   ClosingDates=Yes }
    { 77  ;   ;External Document No.;Code35       ;CaptionML=[ENU=External Document No.;
                                                              ESM=N  documento externo;
                                                              FRC=N  document externe;
                                                              ENC=External Document No.] }
    { 78  ;   ;Source Type         ;Option        ;CaptionML=[ENU=Source Type;
                                                              ESM=Tipo procedencia mov.;
                                                              FRC=Type origine;
                                                              ENC=Source Type];
                                                   OptionCaptionML=[ENU=" ,Customer,Vendor,Bank Account,Fixed Asset,Member";
                                                                    ESM=" ,Cliente,Proveedor,Banco,Activo";
                                                                    FRC=" ,Client,Fournisseur,Compte bancaire,Immobilisation";
                                                                    ENC=" ,Customer,Vendor,Bank Account,Fixed Asset"];
                                                   OptionString=[ ,Customer,Vendor,Bank Account,Fixed Asset,Member] }
    { 79  ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[ENU=Source No.;
                                                              ESM=C d. procedencia mov.;
                                                              FRC=N  origine;
                                                              ENC=Source No.] }
    { 80  ;   ;Posting No. Series  ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=[ENU=Posting No. Series;
                                                              ESM=N  serie registro;
                                                              FRC=S ries de n  report;
                                                              ENC=Posting No. Series] }
    { 82  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[ENU=Tax Area Code;
                                                              ESM=C d.  rea impuesto;
                                                              FRC=Code de r gion fiscale;
                                                              ENC=Tax Area Code] }
    { 83  ;   ;Tax Liable          ;Boolean       ;OnValidate=BEGIN
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[ENU=Tax Liable;
                                                              ESM=Sujeto a impuesto;
                                                              FRC=Imposable;
                                                              ENC=Tax Liable] }
    { 84  ;   ;Tax Group Code      ;Code10        ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[ENU=Tax Group Code;
                                                              ESM=C d. grupo impuesto;
                                                              FRC=Code groupe fiscal;
                                                              ENC=Tax Group Code] }
    { 85  ;   ;Use Tax             ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD("Gen. Posting Type","Gen. Posting Type"::Purchase);
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[ENU=Use Tax;
                                                              ESM=Impuesto de importaci n;
                                                              FRC=Taxe de service;
                                                              ENC=Use Tax] }
    { 86  ;   ;Bal. Tax Area Code  ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[ENU=Bal. Tax Area Code;
                                                              ESM=C d.  rea impto. contrap.;
                                                              FRC=Code r gion fiscale solde;
                                                              ENC=Bal. Tax Area Code] }
    { 87  ;   ;Bal. Tax Liable     ;Boolean       ;OnValidate=BEGIN
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[ENU=Bal. Tax Liable;
                                                              ESM=Sujeto a impto. contrap.;
                                                              FRC=Solde imposable;
                                                              ENC=Bal. Tax Liable] }
    { 88  ;   ;Bal. Tax Group Code ;Code10        ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[ENU=Bal. Tax Group Code;
                                                              ESM=C d. grupo impto. contrap.;
                                                              FRC=Code groupe fiscal solde;
                                                              ENC=Bal. Tax Group Code] }
    { 89  ;   ;Bal. Use Tax        ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::Purchase);
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[ENU=Bal. Use Tax;
                                                              ESM=Impto. importaci n contrap.;
                                                              FRC=Solde taxe de service;
                                                              ENC=Bal. Use Tax] }
    { 90  ;   ;VAT Bus. Posting Group;Code10      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[ENU=Tax Bus. Posting Group;
                                                              ESM=Grupo registro IVA neg.;
                                                              FRC=Groupe de reports de taxe sur la valeur ajout e de l'entreprise;
                                                              ENC=Tax Bus. Posting Group] }
    { 91  ;   ;VAT Prod. Posting Group;Code10     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[ENU=Tax Prod. Posting Group;
                                                              ESM=Grupo registro IVA prod.;
                                                              FRC=Groupe de report de produit taxe;
                                                              ENC=Tax Prod. Posting Group] }
    { 92  ;   ;Bal. VAT Bus. Posting Group;Code10 ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN
                                                                   ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"]
                                                                THEN
                                                                  TESTFIELD("Bal. VAT Bus. Posting Group",'');

                                                                VALIDATE("Bal. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[ENU=Bal. Tax Bus. Posting Group;
                                                              ESM=Gr. registro IVA neg. contrap.;
                                                              FRC=Par. report march  taxe solde;
                                                              ENC=Bal. Tax Bus. Posting Group] }
    { 93  ;   ;Bal. VAT Prod. Posting Group;Code10;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[ENU=Bal. Tax Prod. Posting Group;
                                                              ESM=Gr. registro IVA prod. contrp.;
                                                              FRC=Par. report produit taxe solde;
                                                              ENC=Bal. Tax Prod. Posting Group] }
    { 95  ;   ;Additional-Currency Posting;Option ;CaptionML=[ENU=Additional-Currency Posting;
                                                              ESM=Registro div.-adic.;
                                                              FRC=Report devise additionnelle;
                                                              ENC=Additional-Currency Posting];
                                                   OptionCaptionML=[ENU=None,Amount Only,Additional-Currency Amount Only;
                                                                    ESM=Ninguno,S lo importe,S lo importe div.-adic.;
                                                                    FRC=Aucun,Montant seulement,Montant devise additionnelle seulement;
                                                                    ENC=None,Amount Only,Additional-Currency Amount Only];
                                                   OptionString=None,Amount Only,Additional-Currency Amount Only;
                                                   Editable=No }
    { 98  ;   ;FA Add.-Currency Factor;Decimal    ;CaptionML=[ENU=FA Add.-Currency Factor;
                                                              ESM=A/F Factor div.-adic.;
                                                              FRC=Facteur devise add. immo.;
                                                              ENC=FA Add.-Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0 }
    { 99  ;   ;Source Currency Code;Code10        ;TableRelation=Currency;
                                                   CaptionML=[ENU=Source Currency Code;
                                                              ESM=C d. divisa origen;
                                                              FRC=Code devise origine;
                                                              ENC=Source Currency Code];
                                                   Editable=No }
    { 100 ;   ;Source Currency Amount;Decimal     ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[ENU=Source Currency Amount;
                                                              ESM=Importe divisa origen;
                                                              FRC=Montant devise origine;
                                                              ENC=Source Currency Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 101 ;   ;Source Curr. VAT Base Amount;Decimal;
                                                   AccessByPermission=TableData 4=R;
                                                   CaptionML=[ENU=Source Curr. Tax Base Amount;
                                                              ESM=Importe base IVA divisa origen;
                                                              FRC=Montant devise tx base origine;
                                                              ENC=Source Curr. Tax Base Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 102 ;   ;Source Curr. VAT Amount;Decimal    ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[ENU=Source Curr. Tax Amount;
                                                              ESM=Importe IVA divisa origen;
                                                              FRC=Origine montant de taxes cour.;
                                                              ENC=Source Curr. Tax Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 103 ;   ;VAT Base Discount % ;Decimal       ;CaptionML=[ENU=VAT Base Discount %;
                                                              ESM=% Dto. base IVA;
                                                              FRC=% escompte base TVA;
                                                              ENC=VAT Base Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 104 ;   ;VAT Amount (LCY)    ;Decimal       ;CaptionML=[ENU=Tax Amount ($);
                                                              ESM=Importe IVA ($);
                                                              FRC=Montant de la taxe ($);
                                                              ENC=Tax Amount ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 105 ;   ;VAT Base Amount (LCY);Decimal      ;CaptionML=[ENU=Tax Base Amount ($);
                                                              ESM=Importe base IVA ($);
                                                              FRC=Montant de taxes de base($);
                                                              ENC=Tax Base Amount ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 106 ;   ;Bal. VAT Amount (LCY);Decimal      ;CaptionML=[ENU=Bal. Tax Amount ($);
                                                              ESM=Importe IVA contrap. ($);
                                                              FRC=Solde montant de taxe ($);
                                                              ENC=Bal. Tax Amount ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 107 ;   ;Bal. VAT Base Amount (LCY);Decimal ;CaptionML=[ENU=Bal. Tax Base Amount ($);
                                                              ESM=Importe base IVA contrap. ($);
                                                              FRC=Solde montant de taxe de base ($);
                                                              ENC=Bal. Tax Base Amount ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 108 ;   ;Reversing Entry     ;Boolean       ;CaptionML=[ENU=Reversing Entry;
                                                              ESM=Mov. reversi n;
                                                              FRC= critures de contrepassation;
                                                              ENC=Reversing Entry];
                                                   Editable=No }
    { 109 ;   ;Allow Zero-Amount Posting;Boolean  ;CaptionML=[ENU=Allow Zero-Amount Posting;
                                                              ESM=Permitir cero-registro importe;
                                                              FRC=Autoriser compta. montant nul;
                                                              ENC=Allow Zero-Amount Posting];
                                                   Editable=No }
    { 110 ;   ;Ship-to/Order Address Code;Code10  ;TableRelation=IF (Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.));
                                                   CaptionML=[ENU=Ship-to/Order Address Code;
                                                              ESM=Enviar a/C d. dir. pedido;
                                                              FRC=Code adr. destinat./commande;
                                                              ENC=Ship-to/Order Address Code] }
    { 111 ;   ;VAT Difference      ;Decimal       ;CaptionML=[ENU=Tax Difference;
                                                              ESM=Diferencia  IVA;
                                                              FRC=Diff rence TVA;
                                                              ENC=Tax Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 112 ;   ;Bal. VAT Difference ;Decimal       ;CaptionML=[ENU=Bal. Tax Difference;
                                                              ESM=Diferencia importe IVA;
                                                              FRC=Diff rence TVA contrepartie;
                                                              ENC=Bal. Tax Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 113 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=[ENU=IC Partner Code;
                                                              ESM=C digo socio IC;
                                                              FRC=Code de partenaire IC;
                                                              ENC=IC Partner Code];
                                                   Editable=No }
    { 114 ;   ;IC Direction        ;Option        ;CaptionML=[ENU=IC Direction;
                                                              ESM=Direcci n env o IC;
                                                              FRC=Direction IC;
                                                              ENC=IC Direction];
                                                   OptionCaptionML=[ENU=Outgoing,Incoming;
                                                                    ESM=Saliente,Entrante;
                                                                    FRC=Sortant,Entrant;
                                                                    ENC=Outgoing,Incoming];
                                                   OptionString=Outgoing,Incoming }
    { 116 ;   ;IC Partner G/L Acc. No.;Code20     ;TableRelation="IC G/L Account";
                                                   OnValidate=VAR
                                                                ICGLAccount@1000 : Record 410;
                                                              BEGIN
                                                              END;

                                                   CaptionML=[ENU=IC Partner G/L Acc. No.;
                                                              ESM=N  cuenta IC asociada;
                                                              FRC=N  compte G/L du partenaire IC;
                                                              ENC=IC Partner G/L Acc. No.] }
    { 117 ;   ;IC Partner Transaction No.;Integer ;CaptionML=[ENU=IC Partner Transaction No.;
                                                              ESM=N  transacci n IC asociada;
                                                              FRC=N  de trans. partenaire IC;
                                                              ENC=IC Partner Transaction No.];
                                                   Editable=No }
    { 118 ;   ;Sell-to/Buy-from No.;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
                                                   CaptionML=[ENU=Sell-to/Buy-from No.;
                                                              ESM=Venta a/Compra a-N ;
                                                              FRC=N  d biteur/fournisseur;
                                                              ENC=Sell-to/Buy-from No.] }
    { 119 ;   ;VAT Registration No.;Text20        ;OnValidate=VAR
                                                                VATRegNoFormat@1000 : Record 381;
                                                              BEGIN
                                                                VATRegNoFormat.Test("VAT Registration No.","Country/Region Code",'',0);
                                                              END;

                                                   CaptionML=[ENU=Tax Registration No.;
                                                              ESM=RFC/Curp;
                                                              FRC=N  identification de la TPS/TVH;
                                                              ENC=GST/HST Registration No.] }
    { 120 ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                VALIDATE("VAT Registration No.");
                                                              END;

                                                   CaptionML=[ENU=Country/Region Code;
                                                              ESM=C d. pa s/regi n;
                                                              FRC=Code pays/r gion;
                                                              ENC=Country/Region Code] }
    { 121 ;   ;Prepayment          ;Boolean       ;CaptionML=[ENU=Prepayment;
                                                              ESM=Anticipo;
                                                              FRC=Paiement anticip ;
                                                              ENC=Prepayment] }
    { 122 ;   ;Financial Void      ;Boolean       ;CaptionML=[ENU=Financial Void;
                                                              ESM=Vac o financiero;
                                                              FRC=Annulation financi re;
                                                              ENC=Financial Void];
                                                   Editable=No }
    { 165 ;   ;Incoming Document Entry No.;Integer;TableRelation="Incoming Document";
                                                   OnValidate=VAR
                                                                IncomingDocument@1000 : Record 130;
                                                              BEGIN
                                                              END;

                                                   CaptionML=[ENU=Incoming Document Entry No.;
                                                              ESM=N  mov. de documentos entrantes;
                                                              FRC=N  de s quence du document entrant;
                                                              ENC=Incoming Document Entry No.] }
    { 170 ;   ;Creditor No.        ;Code20        ;CaptionML=[ENU=Creditor No.;
                                                              ESM=N  acreedor;
                                                              FRC=N  cr diteur;
                                                              ENC=Creditor No.];
                                                   Numeric=Yes }
    { 171 ;   ;Payment Reference   ;Code50        ;OnValidate=BEGIN
                                                                IF "Payment Reference" <> '' THEN
                                                                  TESTFIELD("Creditor No.");
                                                              END;

                                                   CaptionML=[ENU=Payment Reference;
                                                              ESM=Referencia pago;
                                                              FRC=R f rence paiement;
                                                              ENC=Payment Reference];
                                                   Numeric=Yes }
    { 172 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=[ENU=Payment Method Code;
                                                              ESM=C d. forma pago;
                                                              FRC=Code mode de paiement;
                                                              ENC=Payment Method Code] }
    { 173 ;   ;Applies-to Ext. Doc. No.;Code35    ;CaptionML=[ENU=Applies-to Ext. Doc. No.;
                                                              ESM=Liq. por n  doc. externo;
                                                              FRC=N  ligne doc. ext. r f rence;
                                                              ENC=Applies-to Ext. Doc. No.] }
    { 288 ;   ;Recipient Bank Account;Code10      ;TableRelation=IF (Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Account No.))
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Account No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Bal. Account No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Bal. Account No.));
                                                   CaptionML=[ENU=Recipient Bank Account;
                                                              ESM=Cta. bancaria destinatario;
                                                              FRC=Cpte bancaire destinataire;
                                                              ENC=Recipient Bank Account] }
    { 289 ;   ;Message to Recipient;Text140       ;CaptionML=[ENU=Message to Recipient;
                                                              ESM=Mensaje al destinatario;
                                                              FRC=Message au destinataire;
                                                              ENC=Message to Recipient] }
    { 290 ;   ;Exported to Payment File;Boolean   ;CaptionML=[ENU=Exported to Payment File;
                                                              ESM=Exportado a archivo de pagos;
                                                              FRC=Export  dans fichier paiement;
                                                              ENC=Exported to Payment File];
                                                   Editable=No }
    { 291 ;   ;Has Payment Export Error;Boolean   ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Payment Jnl. Export Error Text" WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                                                             Journal Batch Name=FIELD(Journal Batch Name),
                                                                                                             Journal Line No.=FIELD(Line No.)));
                                                   CaptionML=[ENU=Has Payment Export Error;
                                                              ESM=Tiene error exportaci n pagos;
                                                              FRC=Pr sente erreur exportation paiement;
                                                              ENC=Has Payment Export Error];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   CaptionML=[ENU=Dimension Set ID;
                                                              ESM=Id. grupo dimensiones;
                                                              FRC=Code ensemble de dimensions;
                                                              ENC=Dimension Set ID];
                                                   Editable=No }
    { 827 ;   ;Credit Card No.     ;Code20        ;TableRelation=IF (Account Type=CONST(Customer),
                                                                     Document Type=FILTER(Payment|Refund),
                                                                     Bal. Account Type=CONST(Bank Account)) "DO Payment Credit Card" WHERE (Customer No.=FIELD(Account No.));
                                                   OnValidate=VAR
                                                                DOPaymentMgt@1000 : Codeunit 825;
                                                              BEGIN
                                                              END;

                                                   CaptionML=[ENU=Credit Card No.;
                                                              ESM=N  tarjeta de cr dito;
                                                              FRC=N  de carte de cr dit;
                                                              ENC=Credit Card No.] }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[ENU=Job Task No.;
                                                              ESM=N  tarea proyecto;
                                                              FRC=N  t che de projet;
                                                              ENC=Job Task No.] }
    { 1002;   ;Job Unit Price (LCY);Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Unit Price ($);
                                                              ESM=Precio unitario proyecto ($);
                                                              FRC=Prix unitaire du projet ($);
                                                              ENC=Job Unit Price ($)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 1003;   ;Job Total Price (LCY);Decimal      ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Total Price ($);
                                                              ESM=Precio total proyecto ($);
                                                              FRC=Prix total du projet ($);
                                                              ENC=Job Total Price ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1004;   ;Job Quantity        ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Quantity;
                                                              ESM=Cantidad proyecto;
                                                              FRC=Quantit  projet;
                                                              ENC=Job Quantity];
                                                   DecimalPlaces=0:5 }
    { 1005;   ;Job Unit Cost (LCY) ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Unit Cost ($);
                                                              ESM=Costo unitario proyecto ($);
                                                              FRC=Co t unitaire du projet ($);
                                                              ENC=Job Unit Cost ($)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 1006;   ;Job Line Discount % ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Line Discount %;
                                                              ESM=% dto. l nea proyecto;
                                                              FRC=% escompte de ligne de projet;
                                                              ENC=Job Line Discount %];
                                                   AutoFormatType=1 }
    { 1007;   ;Job Line Disc. Amount (LCY);Decimal;CaptionML=[ENU=Job Line Disc. Amount ($);
                                                              ESM=Importe dto. l nea proyecto ($);
                                                              FRC=Montant d'escompte de ligne de projet ($);
                                                              ENC=Job Line Disc. Amount ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1008;   ;Job Unit Of Measure Code;Code10    ;TableRelation="Unit of Measure";
                                                   CaptionML=[ENU=Job Unit Of Measure Code;
                                                              ESM=C d. unidad medida proyecto;
                                                              FRC=Code d'unit  de mesure du projet;
                                                              ENC=Job Unit Of Measure Code] }
    { 1009;   ;Job Line Type       ;Option        ;OnValidate=BEGIN
                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  ERROR(Text019,FIELDCAPTION("Job Line Type"),FIELDCAPTION("Job Planning Line No."));
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Line Type;
                                                              ESM=Tipo l nea proyecto;
                                                              FRC=Type ligne de projet;
                                                              ENC=Job Line Type];
                                                   OptionCaptionML=[ENU=" ,Schedule,Contract,Both Schedule and Contract";
                                                                    ESM=" ,Previsi n,Contrato,Previsi n y contrato";
                                                                    FRC=" ,Calendrier,Contrat,Calendrier et contrat";
                                                                    ENC=" ,Schedule,Contract,Both Schedule and Contract"];
                                                   OptionString=[ ,Schedule,Contract,Both Schedule and Contract] }
    { 1010;   ;Job Unit Price      ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Unit Price;
                                                              ESM=Precio unitario proyecto;
                                                              FRC=Prix unitaire du projet;
                                                              ENC=Job Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1011;   ;Job Total Price     ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Total Price;
                                                              ESM=Precio total proyecto;
                                                              FRC=Prix total du projet;
                                                              ENC=Job Total Price];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1012;   ;Job Unit Cost       ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Unit Cost;
                                                              ESM=Costo unitario proyecto;
                                                              FRC=Co t unitaire du projet;
                                                              ENC=Job Unit Cost];
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1013;   ;Job Total Cost      ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Total Cost;
                                                              ESM=Costo total proyecto;
                                                              FRC=Co t total du projet;
                                                              ENC=Job Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1014;   ;Job Line Discount Amount;Decimal   ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Line Discount Amount;
                                                              ESM=Importe dto. l nea proyecto;
                                                              FRC=Montant d'escompte de ligne de projet;
                                                              ENC=Job Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1015;   ;Job Line Amount     ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Line Amount;
                                                              ESM=Importe l nea proyecto;
                                                              FRC=Montant de ligne de projet;
                                                              ENC=Job Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1016;   ;Job Total Cost (LCY);Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Total Cost ($);
                                                              ESM=Costo total proyecto ($);
                                                              FRC=Co t total du projet ($);
                                                              ENC=Job Total Cost ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1017;   ;Job Line Amount (LCY);Decimal      ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Line Amount ($);
                                                              ESM=Importe l nea proyecto ($);
                                                              FRC=Montant de ligne de projet ($);
                                                              ENC=Job Line Amount ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1018;   ;Job Currency Factor ;Decimal       ;CaptionML=[ENU=Job Currency Factor;
                                                              ESM=Factor divisa proyecto;
                                                              FRC=Facteur devise du projet;
                                                              ENC=Job Currency Factor] }
    { 1019;   ;Job Currency Code   ;Code10        ;CaptionML=[ENU=Job Currency Code;
                                                              ESM=C digo divisa proyecto;
                                                              FRC=Code devise du projet;
                                                              ENC=Job Currency Code] }
    { 1020;   ;Job Planning Line No.;Integer      ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                {IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  JobPlanningLine.TESTFIELD("Job No.","Job No.");
                                                                  JobPlanningLine.TESTFIELD("Job Task No.","Job Task No.");
                                                                  JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::"G/L Account");
                                                                  JobPlanningLine.TESTFIELD("No.","Account No.");
                                                                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                                                                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);
                                                                  "Job Line Type" := JobPlanningLine."Line Type" + 1;
                                                                  VALIDATE("Job Remaining Qty.",JobPlanningLine."Remaining Qty." - "Job Quantity");
                                                                END ELSE
                                                                  VALIDATE("Job Remaining Qty.",0);
                                                                  }
                                                              END;

                                                   OnLookup=VAR
                                                              JobPlanningLine@1000 : Record 1003;
                                                            BEGIN
                                                              {JobPlanningLine.SETRANGE("Job No.","Job No.");
                                                              JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                                                              JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::"G/L Account");
                                                              JobPlanningLine.SETRANGE("No.","Account No.");
                                                              JobPlanningLine.SETRANGE("Usage Link",TRUE);
                                                              JobPlanningLine.SETRANGE("System-Created Entry",FALSE);

                                                              IF PAGE.RUNMODAL(0,JobPlanningLine) = ACTION::LookupOK THEN
                                                                VALIDATE("Job Planning Line No.",JobPlanningLine."Line No.");
                                                                }
                                                            END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Planning Line No.;
                                                              ESM=N  l nea planificaci n proyecto;
                                                              FRC=N  ligne planification projet;
                                                              ENC=Job Planning Line No.];
                                                   BlankZero=Yes }
    { 1030;   ;Job Remaining Qty.  ;Decimal       ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                {IF ("Job Remaining Qty." <> 0) AND ("Job Planning Line No." = 0) THEN
                                                                  ERROR(Text018,FIELDCAPTION("Job Remaining Qty."),FIELDCAPTION("Job Planning Line No."));

                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  IF JobPlanningLine.Quantity >= 0 THEN BEGIN
                                                                    IF "Job Remaining Qty." < 0 THEN
                                                                      "Job Remaining Qty." := 0;
                                                                  END ELSE BEGIN
                                                                    IF "Job Remaining Qty." > 0 THEN
                                                                      "Job Remaining Qty." := 0;
                                                                  END;
                                                                END;
                                                                }
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[ENU=Job Remaining Qty.;
                                                              ESM=Cdad. pendiente proyecto;
                                                              FRC=Quantit  travail   accomplir;
                                                              ENC=Job Remaining Qty.];
                                                   DecimalPlaces=0:5 }
    { 1200;   ;Direct Debit Mandate ID;Code35     ;TableRelation=IF (Account Type=CONST(Customer)) "SEPA Direct Debit Mandate" WHERE (Customer No.=FIELD(Account No.));
                                                   OnValidate=VAR
                                                                SEPADirectDebitMandate@1000 : Record 1230;
                                                              BEGIN
                                                                IF "Direct Debit Mandate ID" = '' THEN
                                                                  EXIT;
                                                                TESTFIELD("Account Type","Account Type"::Customer);
                                                                SEPADirectDebitMandate.GET("Direct Debit Mandate ID");
                                                                SEPADirectDebitMandate.TESTFIELD("Customer No.","Account No.");
                                                                "Recipient Bank Account" := SEPADirectDebitMandate."Customer Bank Account Code";
                                                              END;

                                                   CaptionML=[ENU=Direct Debit Mandate ID;
                                                              ESM=Id. de orden de domiciliaci n de adeudo directo;
                                                              FRC=ID mandat de pr l vement;
                                                              ENC=Direct Debit Mandate ID] }
    { 1220;   ;Data Exch. Entry No.;Integer       ;TableRelation="Data Exch.";
                                                   CaptionML=[ENU=Data Exch. Entry No.;
                                                              ESM=N.  mov. intercambio de datos;
                                                              FRC=N   criture  chge donn es;
                                                              ENC=Data Exch. Entry No.];
                                                   Editable=No }
    { 1221;   ;Payer Information   ;Text50        ;CaptionML=[ENU=Payer Information;
                                                              ESM=Informaci n del pagador;
                                                              FRC=Informations payeur;
                                                              ENC=Payer Information] }
    { 1222;   ;Transaction Information;Text100    ;CaptionML=[ENU=Transaction Information;
                                                              ESM=Informaci n de la transacci n;
                                                              FRC=Informations transaction;
                                                              ENC=Transaction Information] }
    { 1223;   ;Data Exch. Line No. ;Integer       ;CaptionML=[ENU=Data Exch. Line No.;
                                                              ESM=N.  l nea intercambio de datos;
                                                              FRC=N  ligne  chge donn es;
                                                              ENC=Data Exch. Line No.];
                                                   Editable=No }
    { 1224;   ;Applied Automatically;Boolean      ;CaptionML=[ENU=Applied Automatically;
                                                              ESM=Aplicado autom ticamente;
                                                              FRC=Affect  automatiquement;
                                                              ENC=Applied Automatically] }
    { 1700;   ;Deferral Code       ;Code10        ;TableRelation="Deferral Template"."Deferral Code";
                                                   OnValidate=VAR
                                                                DeferralUtilities@1002 : Codeunit 1720;
                                                              BEGIN
                                                              END;

                                                   CaptionML=[ENU=Deferral Code;
                                                              ESM=C digo de fraccionamiento;
                                                              FRC=Code  chelonnement;
                                                              ENC=Deferral Code] }
    { 1701;   ;Deferral Line No.   ;Integer       ;CaptionML=[ENU=Deferral Line No.;
                                                              ESM=N  l nea fraccionamiento;
                                                              FRC=N  ligne  chelonnement;
                                                              ENC=Deferral Line No.] }
    { 5050;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   CaptionML=[ENU=Campaign No.;
                                                              ESM=N  campa a;
                                                              FRC=N  promotion;
                                                              ENC=Campaign No.] }
    { 5400;   ;Prod. Order No.     ;Code20        ;CaptionML=[ENU=Prod. Order No.;
                                                              ESM=N  orden producci n;
                                                              FRC=N  bon de prod.;
                                                              ENC=Prod. Order No.];
                                                   Editable=No }
    { 5600;   ;FA Posting Date     ;Date          ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=FA Posting Date;
                                                              ESM=A/F Fecha registro;
                                                              FRC=Date report immo.;
                                                              ENC=FA Posting Date] }
    { 5601;   ;FA Posting Type     ;Option        ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=FA Posting Type;
                                                              ESM=A/F Tipo registro;
                                                              FRC=Type de report immo.;
                                                              ENC=FA Posting Type];
                                                   OptionCaptionML=[ENU=" ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance";
                                                                    ESM=" ,Costo,Amortizaci n,Depreciaci n,Revaluaci n,Adecuaci n,Provisi n,Venta/Baja,Mantenimiento.";
                                                                    FRC=" ,Co t acquisition,Amortissement,D valuation,Appr ciation,Param. 1,Param 2,Cession,Maintenance";
                                                                    ENC=" ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance"];
                                                   OptionString=[ ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   CaptionML=[ENU=Depreciation Book Code;
                                                              ESM=C d. libro amortizaci n;
                                                              FRC=Code registre amortissement;
                                                              ENC=Depreciation Book Code] }
    { 5603;   ;Salvage Value       ;Decimal       ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=Salvage Value;
                                                              ESM=Valor residual;
                                                              FRC=Valeur r siduelle;
                                                              ENC=Salvage Value];
                                                   AutoFormatType=1 }
    { 5604;   ;No. of Depreciation Days;Integer   ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=No. of Depreciation Days;
                                                              ESM=N  d as amortizaci n;
                                                              FRC=Nombre de jours amort.;
                                                              ENC=No. of Depreciation Days];
                                                   BlankZero=Yes }
    { 5605;   ;Depr. until FA Posting Date;Boolean;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=Depr. until FA Posting Date;
                                                              ESM=A/F Amort. hasta fecha reg.;
                                                              FRC=Amort. jusqu'  date report;
                                                              ENC=Depr. until FA Posting Date] }
    { 5606;   ;Depr. Acquisition Cost;Boolean     ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=Depr. Acquisition Cost;
                                                              ESM=Depr. de costo de adquisici n;
                                                              FRC=Amortissement co t acquisition;
                                                              ENC=Depr. Acquisition Cost] }
    { 5609;   ;Maintenance Code    ;Code10        ;TableRelation=Maintenance;
                                                   CaptionML=[ENU=Maintenance Code;
                                                              ESM=C d. mantenimiento;
                                                              FRC=Code entretien;
                                                              ENC=Maintenance Code] }
    { 5610;   ;Insurance No.       ;Code20        ;TableRelation=Insurance;
                                                   OnValidate=BEGIN
                                                                IF "Insurance No." <> '' THEN
                                                                  TESTFIELD("FA Posting Type","FA Posting Type"::"Acquisition Cost");
                                                              END;

                                                   CaptionML=[ENU=Insurance No.;
                                                              ESM=N  seguro;
                                                              FRC=N  assurance;
                                                              ENC=Insurance No.] }
    { 5611;   ;Budgeted FA No.     ;Code20        ;TableRelation="Fixed Asset";
                                                   OnValidate=BEGIN
                                                                IF "Budgeted FA No." <> '' THEN BEGIN
                                                                  FA.GET("Budgeted FA No.");
                                                                  FA.TESTFIELD("Budgeted Asset",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[ENU=Budgeted FA No.;
                                                              ESM=A/F N  pptdo.;
                                                              FRC=N  immo. budg t e;
                                                              ENC=Budgeted FA No.] }
    { 5612;   ;Duplicate in Depreciation Book;Code10;
                                                   TableRelation="Depreciation Book";
                                                   OnValidate=BEGIN
                                                                "Use Duplication List" := FALSE;
                                                              END;

                                                   CaptionML=[ENU=Duplicate in Depreciation Book;
                                                              ESM=Duplicado en libro amort.;
                                                              FRC=Registre amortiss. en double;
                                                              ENC=Duplicate in Depreciation Book] }
    { 5613;   ;Use Duplication List;Boolean       ;OnValidate=BEGIN
                                                                "Duplicate in Depreciation Book" := '';
                                                              END;

                                                   AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=Use Duplication List;
                                                              ESM=Utilizar lista duplicados;
                                                              FRC=Utiliser liste duplication;
                                                              ENC=Use Duplication List] }
    { 5614;   ;FA Reclassification Entry;Boolean  ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[ENU=FA Reclassification Entry;
                                                              ESM=A/F Mov. reclasificaci n;
                                                              FRC= critures reclass. immo.;
                                                              ENC=FA Reclassification Entry] }
    { 5615;   ;FA Error Entry No.  ;Integer       ;TableRelation="FA Ledger Entry";
                                                   CaptionML=[ENU=FA Error Entry No.;
                                                              ESM=A/F N  mov. anulado;
                                                              FRC=N   criture erreur immo.;
                                                              ENC=FA Error Entry No.];
                                                   BlankZero=Yes }
    { 5616;   ;Index Entry         ;Boolean       ;CaptionML=[ENU=Index Entry;
                                                              ESM=Mov. valor ajuste;
                                                              FRC= critures r  valuation;
                                                              ENC=Index Entry] }
    { 5617;   ;Source Line No.     ;Integer       ;CaptionML=[ENU=Source Line No.;
                                                              ESM=N  l n. origen;
                                                              FRC=N  de ligne source;
                                                              ENC=Source Line No.] }
    { 5618;   ;Comment             ;Text250       ;CaptionML=[ENU=Comment;
                                                              ESM=Comentario;
                                                              FRC=Commentaire;
                                                              ENC=Comment] }
    { 10005;  ;Check Exported      ;Boolean       ;CaptionML=[ENU=Check Exported;
                                                              ESM=Cheque exportado;
                                                              FRC=Ch que export ;
                                                              ENC=Cheque Exported];
                                                   Editable=No }
    { 10006;  ;Export File Name    ;Text30        ;CaptionML=[ENU=Export File Name;
                                                              ESM=Export. nomb. arch.;
                                                              FRC=Nom du fichier d'exportation;
                                                              ENC=Export File Name];
                                                   Editable=No }
    { 10007;  ;Check Transmitted   ;Boolean       ;CaptionML=[ENU=Check Transmitted;
                                                              ESM=Cheque emitido;
                                                              FRC=Ch que transmis;
                                                              ENC=Cheque Transmitted];
                                                   Editable=No }
    { 10011;  ;Tax Jurisdiction Code;Code10       ;TableRelation="Tax Jurisdiction";
                                                   CaptionML=[ENU=Tax Jurisdiction Code;
                                                              ESM=C d. jurisdicci n fiscal;
                                                              FRC=Code de juridiction fiscale;
                                                              ENC=Tax Jurisdiction Code];
                                                   Editable=Yes }
    { 10012;  ;Tax Type            ;Option        ;CaptionML=[ENU=Tax Type;
                                                              ESM=Tipo impto.;
                                                              FRC=Type de taxe;
                                                              ENC=Tax Type];
                                                   OptionCaptionML=[ENU=Sales and Use Tax,Excise Tax,Sales Tax Only,Use Tax Only;
                                                                    ESM=Impuesto de las ventas y sobre servicios,Impto. consumo,S lo impuesto de las ventas,S lo impto. sobre servicios;
                                                                    FRC=Taxe de vente et de service,Taxe d'accise,Taxe de vente uniquement,Taxe de service uniquement;
                                                                    ENC=Sales and Use Tax,Excise Tax,Sales Tax Only,Use Tax Only];
                                                   OptionString=Sales and Use Tax,Excise Tax,Sales Tax Only,Use Tax Only }
    { 10015;  ;Tax Exemption No.   ;Text30        ;CaptionML=[ENU=Tax Exemption No.;
                                                              ESM=N  exenci n fisc.;
                                                              FRC=N  d'exon ration fiscale;
                                                              ENC=Tax Exemption No.] }
    { 10018;  ;STE Transaction ID  ;Text20        ;CaptionML=[ENU=STE Transaction ID;
                                                              ESM=Id. transacci n STE;
                                                              FRC=ID de transaction STE;
                                                              ENC=STE Transaction ID];
                                                   Editable=No }
    { 10020;  ;IRS 1099 Code       ;Code10        ;TableRelation="IRS 1099 Form-Box";
                                                   OnValidate=BEGIN
                                                                IF "IRS 1099 Code" <> '' THEN BEGIN
                                                                  IF "Account Type" = "Account Type"::Vendor THEN
                                                                    "IRS 1099 Amount" := Amount
                                                                  ELSE
                                                                    "IRS 1099 Amount" := -Amount;
                                                                END ELSE
                                                                  "IRS 1099 Amount" := 0;
                                                              END;

                                                   CaptionML=[ENU=IRS 1099 Code;
                                                              ESM=C d. form. 1099 de IRS;
                                                              FRC=Code IRS 1099;
                                                              ENC=IRS 1099 Code] }
    { 10021;  ;IRS 1099 Amount     ;Decimal       ;CaptionML=[ENU=IRS 1099 Amount;
                                                              ESM=Imp. form. 1099 de IRS;
                                                              FRC=Montant IRS 1099;
                                                              ENC=IRS 1099 Amount] }
    { 10030;  ;Foreign Exchange Indicator;Option  ;CaptionML=[ENU=Foreign Exchange Indicator;
                                                              ESM=Indicador de divisa extranjera;
                                                              FRC=Indicateur de devise  trang re;
                                                              ENC=Foreign Exchange Indicator];
                                                   OptionCaptionML=[ENU=" ,FV,VF,FF";
                                                                    ESM=" ,FV,VF,FF";
                                                                    FRC=" ,FV,VF,FF";
                                                                    ENC=" ,FV,VF,FF"];
                                                   OptionString=[ ,FV,VF,FF] }
    { 10031;  ;Foreign Exchange Ref.Indicator;Option;
                                                   CaptionML=[ENU=Foreign Exchange Ref.Indicator;
                                                              ESM=Indicador de referencia de divisa extranjera;
                                                              FRC=Indicateur de r f. de la devise  trang re;
                                                              ENC=Foreign Exchange Ref.Indicator];
                                                   OptionCaptionML=[ENU=" ,1,2,3";
                                                                    ESM=" ,1,2,3";
                                                                    FRC=" ,1,2,3";
                                                                    ENC=" ,1,2,3"];
                                                   OptionString=[ ,1,2,3] }
    { 10032;  ;Foreign Exchange Reference;Code20  ;CaptionML=[ENU=Foreign Exchange Reference;
                                                              ESM=Referencia de divisa extranjera;
                                                              FRC=R f rence de la devise  trang re;
                                                              ENC=Foreign Exchange Reference] }
    { 10033;  ;Gateway Operator OFAC Scr.Inc;Option;
                                                   CaptionML=[ENU=Gateway Operator OFAC Scr.Inc;
                                                              ESM=Indicador de filtrado OFAC de operador de gateway;
                                                              FRC=Indic. filtr. OFAC op rateur de passerelle;
                                                              ENC=Gateway Operator OFAC Scr.Inc];
                                                   OptionCaptionML=[ENU=" ,0,1";
                                                                    ESM=" ,0,1";
                                                                    FRC=" ,0,1";
                                                                    ENC=" ,0,1"];
                                                   OptionString=[ ,0,1] }
    { 10034;  ;Secondary OFAC Scr.Indicator;Option;CaptionML=[ENU=Secondary OFAC Scr.Indicator;
                                                              ESM=Indicador de filtrado OFAC secundario;
                                                              FRC=Indicateur filtr. OFAC secondaire;
                                                              ENC=Secondary OFAC Scr.Indicator];
                                                   OptionCaptionML=[ENU=" ,0,1";
                                                                    ESM=" ,0,1";
                                                                    FRC=" ,0,1";
                                                                    ENC=" ,0,1"];
                                                   OptionString=[ ,0,1] }
    { 10035;  ;Origin. DFI ID Qualifier;Option    ;CaptionML=[ENU=Origin. DFI ID Qualifier;
                                                              ESM=Calificador Id. gen rico original;
                                                              FRC=Description code DFI origine;
                                                              ENC=Origin. DFI ID Qualifier];
                                                   OptionCaptionML=[ENU=" ,01,02,03";
                                                                    ESM=" ,01,02,03";
                                                                    FRC=" ,01,02,03";
                                                                    ENC=" ,01,02,03"];
                                                   OptionString=[ ,01,02,03] }
    { 10036;  ;Receiv. DFI ID Qualifier;Option    ;CaptionML=[ENU=Receiv. DFI ID Qualifier;
                                                              ESM=Calificador Id. gen rico deudor;
                                                              FRC=Description code DFI r cept.;
                                                              ENC=Receiv. DFI ID Qualifier];
                                                   OptionCaptionML=[ENU=" ,01,02,03";
                                                                    ESM=" ,01,02,03";
                                                                    FRC=" ,01,02,03";
                                                                    ENC=" ,01,02,03"];
                                                   OptionString=[ ,01,02,03] }
    { 10037;  ;Transaction Type Code;Option       ;InitValue=BUS;
                                                   CaptionML=[ENU=Transaction Type Code;
                                                              ESM=C digo de tipo de transacci n;
                                                              FRC=Code de type de transaction;
                                                              ENC=Transaction Type Code];
                                                   OptionCaptionML=[ENU=ANN,BUS,DEP,LOA,MIS,MOR,PEN,RLS,SAL,TAX;
                                                                    ESM=ANN,BUS,DEP,LOA,MIS,MOR,PEN,RLS,SAL,TAX;
                                                                    FRC=ANN,BUS,DEP,LOA,MIS,MOR,PEN,RLS,SAL,TAX;
                                                                    ENC=ANN,BUS,DEP,LOA,MIS,MOR,PEN,RLS,SAL,TAX];
                                                   OptionString=ANN,BUS,DEP,LOA,MIS,MOR,PEN,RLS,SAL,TAX }
    { 10038;  ;Transaction Code    ;Code3         ;CaptionML=[ENU=Transaction Code;
                                                              ESM=C digo de transacci n;
                                                              FRC=Code de transaction;
                                                              ENC=Transaction Code] }
    { 10039;  ;Company Entry Description;Text10   ;CaptionML=[ENU=Company Entry Description;
                                                              ESM=Descripci n de movimiento de empresa;
                                                              FRC=Description  criture compagnie;
                                                              ENC=Company Entry Description] }
    { 10040;  ;Payment Related Information 1;Text80;
                                                   CaptionML=[ENU=Payment Related Information 1;
                                                              ESM=Informaci n relacionada con el pago 1;
                                                              FRC=Informations li es au paiement 1;
                                                              ENC=Payment Related Information 1] }
    { 10041;  ;Payment Related Information 2;Text52;
                                                   CaptionML=[ENU=Payment Related Information 2;
                                                              ESM=Informaci n relacionada con el pago 2;
                                                              FRC=Informations li es au paiement 2;
                                                              ENC=Payment Related Information 2] }
    { 10045;  ;GST/HST             ;Option        ;CaptionML=[ENU=GST/HST;
                                                              ESM=GST/HST;
                                                              FRC=TPS/TVH;
                                                              ENC=GST/HST];
                                                   OptionCaptionML=[ENU=" ,Acquisition,Self Assessment,Rebate,New Housing Rebates,Pension Rebate";
                                                                    ESM=" ,Adquisici n,Autoevaluaci n,Devoluci n,Devoluciones de vivienda nueva,Devoluci n de pensiones";
                                                                    FRC=" ,Acquisition,Auto- valuation,Remise,Remises pour habitation neuve,Remise pour retraite";
                                                                    ENC=" ,Acquisition,Self Assessment,Rebate,New Housing Rebates,Pension Rebate"];
                                                   OptionString=[ ,Acquisition,Self Assessment,Rebate,New Housing Rebates,Pension Rebate] }
    { 51516220;;Transaction Type   ;Option        ;OnValidate=BEGIN
                                                                 IF "Transaction Type"="Transaction Type"::"Registration Fee" THEN
                                                                   Description:='Registration Fee';
                                                                 IF "Transaction Type"="Transaction Type"::Loan THEN
                                                                   Description:='Loan';
                                                                 IF "Transaction Type"="Transaction Type"::Repayment THEN
                                                                   Description:='Loan Repayment';
                                                                 IF "Transaction Type"="Transaction Type"::Withdrawal THEN
                                                                   Description:='Withdrawal';
                                                                 IF "Transaction Type"="Transaction Type"::"Interest Due" THEN
                                                                   Description:='Interest Due';
                                                                 IF "Transaction Type"="Transaction Type"::"Interest Paid" THEN
                                                                   Description:='Interest Paid';
                                                                 IF "Transaction Type"="Transaction Type"::"Benevolent Fund" THEN
                                                                   Description:='Benevolent Fund';
                                                                 IF "Transaction Type"="Transaction Type"::"Deposit Contribution" THEN
                                                                   Description:='Shares Contribution';
                                                                 IF "Transaction Type"="Transaction Type"::"Appraisal Fee" THEN
                                                                   Description:='Appraisal Fee';
                                                                 IF "Transaction Type"="Transaction Type"::"Application Fee" THEN
                                                                   Description:='Application Fee';
                                                                 IF "Transaction Type"="Transaction Type"::"Unallocated Funds" THEN
                                                                   Description:='Unallocated Funds';
                                                                 IF "Transaction Type"="Transaction Type"::"Insurance Contribution" THEN
                                                                   Description:='Insurance Contribution';
                                                                 IF "Transaction Type"="Transaction Type"::"Normal shares" THEN
                                                                   Description:= 'Normal shares';
                                                              END;

                                                   OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated] }
    { 51516221;;Loan No            ;Code20        ;TableRelation=IF (Account Type=CONST(Member)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Account No.)) }
    { 51516222;;Loan Product Type  ;Code20         }
    { 51516223;;Interest           ;Decimal        }
    { 51516224;;Principal          ;Decimal        }
    { 51516225;;Status             ;Option        ;OptionCaptionML=ENU=Pending,Verified,Approved,Canceled;
                                                   OptionString=Pending,Verified,Approved,Canceled }
    { 51516226;;User ID            ;Code25         }
    { 51516227;;Posted             ;Boolean        }
    { 51516228;;Charge             ;Code20        ;TableRelation=Resource.No.;
                                                   OnValidate=BEGIN
                                                                //IF Res.GET(Charge) THEN
                                                                //Description:=Res.Name;
                                                              END;
                                                               }
    { 51516229;;Calculate VAT      ;Boolean        }
    { 51516230;;VAT Value Amount   ;Decimal        }
    { 51516231;;Bank               ;Text30         }
    { 51516232;;Branch             ;Text30         }
    { 51516233;;Invoice to Post    ;Code20         }
    { 51516234;;Found              ;Boolean        }
    { 51516235;;Staff No.          ;Code20         }
    { 51516236;;Prepayment date    ;Date           }
    { 51516237;;LN                 ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loans Register"."Loan  No." WHERE (Loan  No.=FIELD(Loan No))) }
    { 51516238;;Group Code         ;Code20         }
    { 51516239;;Int Count          ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Gen. Journal Line" WHERE (Journal Template Name=CONST(GENERAL),
                                                                                                Journal Batch Name=CONST(INT DUE))) }
    { 51516240;;Member Name        ;Text70         }
    { 51516241;;Interest Due Amount;Decimal        }
    { 51516430;;Interest Code      ;Code50        ;Description=Investment Management Field;
                                                   Editable=No }
    { 51516431;;Investor Interest  ;Boolean        }
    { 51516432;;Int on Dep SMS     ;Boolean        }
    { 51516433;;Dividend SMS       ;Boolean        }
    { 51516434;;Text               ;Text30         }
    { 51516435;;Blocked            ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor.Blocked WHERE (No.=FIELD(Account No.)));
                                                   OptionCaptionML=ENU=" ,All,Payment";
                                                   OptionString=[ ,All,Payment] }
    { 51516436;;ATM SMS            ;Boolean        }
    { 51516437;;Trace ID           ;Code10         }
    { 51516438;;Description2       ;Text70         }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Line No.;
                                                   SumIndexFields=Balance (LCY),Amount;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Journal Template Name,Journal Batch Name,Posting Date,Document No.;
                                                   MaintainSQLIndex=No }
    {    ;Account Type,Account No.,Applies-to Doc. Type,Applies-to Doc. No. }
    {    ;Document No.                            ;MaintainSQLIndex=No }
    {    ;Incoming Document Entry No.              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@="%1=Account Type,%2=Balance Account Type";ENU=%1 or %2 must be a G/L account or bank account.;ESM=%1 o %2 deben ser tipo Cuenta o Banco.;FRC=%1 ou %2 doit  tre un compte du grand livre ou un compte bancaire.;ENC=%1 or %2 must be a G/L account or bank account.';
      Text001@1001 : TextConst 'ENU=You must not specify %1 when %2 is %3.;ESM=No se debe especificar %1 cuando %2 es %3.;FRC=Vous ne devez pas sp cifier %1 lorsque %2 est %3.;ENC=You must not specify %1 when %2 is %3.';
      Text002@1002 : TextConst 'ENU=cannot be specified without %1;ESM=no se puede especificar sin %1;FRC=ne peut  tre sp cifi  sans %1;ENC=cannot be specified without %1';
      Text003@1003 : TextConst 'ENU=The %1 in the %2 will be changed from %3 to %4.\Do you want to continue?;ESM=El %1 de %2 se cambiar  de %3 a %4.\ Desea continuar?;FRC=Le %1 dans le %2 va passer de %3   %4.\Voulez-vous continuer ?;ENC=The %1 in the %2 will be changed from %3 to %4.\Do you want to continue?';
      Text005@1005 : TextConst 'ENU=The update has been interrupted to respect the warning.;ESM=Se ha interrumpido la actualizaci n para respetar la advertencia.;FRC=La mise   jour a  t  interrompue pour respecter l''avertissement.;ENC=The update has been interrupted to respect the warning.';
      Text006@1006 : TextConst 'ENU=The %1 option can only be used internally in the system.;ESM=La opci n %1 es de uso interno del sistema.;FRC=L''option %1 ne peur  tre utilis e   l''int rieur du syst me.;ENC=The %1 option can only be used internally in the system.';
      Text007@1007 : TextConst '@@@="%1=Account Type,%2=Balance Account Type";ENU=%1 or %2 must be a bank account.;ESM=%1 o %2 debe ser de tipo Banco.;FRC=%1 ou %2 doit  tre un compte bancaire.;ENC=%1 or %2 must be a bank account.';
      Text008@1008 : TextConst 'ENU=" must be 0 when %1 is %2.";ESM=" debe ser 0 cuando %1 es %2.";FRC=" doit  tre 0 lorsque %1 est %2.";ENC=" must be 0 when %1 is %2."';
      Text009@1009 : TextConst 'ENU=USD;ESM=$;FRC=$;ENC=CAD';
      Text010@1010 : TextConst 'ENU=%1 must be %2 or %3.;ESM=%1 debe ser %2 o %3.;FRC=%1 doit  tre %2 ou %3.;ENC=%1 must be %2 or %3.';
      Text011@1011 : TextConst 'ENU=%1 must be negative.;ESM=El %1 debe ser negativo.;FRC=%1 doit  tre n gatif.;ENC=%1 must be negative.';
      Text012@1012 : TextConst 'ENU=%1 must be positive.;ESM=El %1 debe ser positivo.;FRC=%1 doit  tre positif.;ENC=%1 must be positive.';
      Text013@1013 : TextConst 'ENU=The %1 must not be more than %2.;ESM=%1 no debe ser m s que %2.;FRC=La %1 ne doit pas  tre sup rieure   %2.;ENC=The %1 must not be more than %2.';
      Text017@1065 : TextConst 'ENU=Credit card %1 has already been performed for this %2, but posting failed. You must complete posting of the document of type %2 with the number %3.;ESM=La tarjeta de cr dito %1 ya se us  para %2, pero se produjo un error de registro. Complete el registro del documento de tipo %2 con el n mero %3.;FRC=Le/la %1 de la carte de cr dit a d j   t  effectu (e) pour le/la %2, mais le report a  chou . Vous devez proc der au report du document de type %2 avec le num ro %3.;ENC=Credit card %1 has already been performed for this %2, but posting failed. You must complete posting of the document of type %2 with the number %3.';
      GenJnlTemplate@1014 : Record 80;
      GenJnlBatch@1015 : Record 232;
      GenJnlLine@1016 : Record 51516099;
      GLAcc@1017 : Record 15;
      Cust@1018 : Record 18;
      Vend@1020 : Record 23;
      ICPartner@1057 : Record 413;
      Currency@1022 : Record 4;
      CurrExchRate@1023 : Record 330;
      PaymentTerms@1024 : Record 3;
      CustLedgEntry@1025 : Record 21;
      VendLedgEntry@1026 : Record 25;
      GenJnlAlloc@1027 : Record 221;
      VATPostingSetup@1028 : Record 325;
      BankAcc@1029 : Record 270;
      BankAcc2@1030 : Record 270;
      BankAcc3@1031 : Record 270;
      FA@1032 : Record 5600;
      FASetup@1033 : Record 5603;
      FADeprBook@1034 : Record 5612;
      GenBusPostingGrp@1035 : Record 250;
      GenProdPostingGrp@1036 : Record 251;
      GLSetup@1037 : Record 98;
      Job@1060 : Record 167;
      JobJnlLine@1059 : TEMPORARY Record 210;
      TaxArea@1020000 : Record 318;
      NoSeriesMgt@1040 : Codeunit 396;
      CustCheckCreditLimit@1041 : Codeunit 312;
      SalesTaxCalculate@1042 : Codeunit 398;
      GenJnlApply@1043 : Codeunit 225;
      GenJnlShowCTEntries@1039 : Codeunit 16;
      CustEntrySetApplID@1044 : Codeunit 101;
      VendEntrySetApplID@1045 : Codeunit 111;
      DimMgt@1046 : Codeunit 408;
      PaymentToleranceMgt@1053 : Codeunit 426;
      DeferralUtilities@1051 : Codeunit 1720;
      ApprovalsMgmt@1069 : Codeunit 1535;
      Window@1004 : Dialog;
      DeferralDocType@1050 : 'Purchase,Sales,G/L';
      FromCurrencyCode@1048 : Code[10];
      ToCurrencyCode@1049 : Code[10];
      CurrencyCode@1052 : Code[10];
      Text014@1054 : TextConst 'ENU=The %1 %2 has a %3 %4.\Do you still want to use %1 %2 in this journal line?;ESM=El %1 %2 tiene un %3 %4.\ Todav a quiere utilizar %1 %2 en esta l nea del diario?;FRC=Le %1 %2 a un %3 %4.\D sirez-vous toujours utiliser %1 %2 sur cette ligne de journal?;ENC=The %1 %2 has a %3 %4.\Do you still want to use %1 %2 in this journal line?';
      TemplateFound@1056 : Boolean;
      Text015@1058 : TextConst 'ENU=You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.;ESM=No tiene permiso para aplicar ni registrar un movimiento con una fecha de registro anterior.\\En su lugar, registre %1 %2 y, a continuaci n, apl quelo a %3 %4.;FRC=Vous n''avez pas l''autorisation d''affecter et de reporter une  criture dans une  criture avec date de report ant rieure.\\Reportez plut t %1 %2 puis affectez-le   %3 %4.;ENC=You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.';
      CurrencyDate@1061 : Date;
      SourceCodeSetup@1063 : Record 242;
      Text016@1062 : TextConst 'ENU=%1 must be G/L Account or Bank Account.;ESM=%1 deber a ser una cuenta o banco.;FRC=%1 doit  tre un compte GL ou un compte bancaire.;ENC=%1 must be G/L Account or Bank Account.';
      HideValidationDialog@1064 : Boolean;
      Text018@1066 : TextConst 'ENU=%1 can only be set when %2 is set.;ESM=Solo se puede establecer %1 cuando se establece %2.;FRC=%1 ne peut  tre d termin  que si %2 est d fini.;ENC=%1 can only be set when %2 is set.';
      Text019@1067 : TextConst 'ENU=%1 cannot be changed when %2 is set.;ESM=%1 no se puede cambiar cuando se establece %2.;FRC=%1 ne peut pas  tre modifi  si %2 est d fini.;ENC=%1 cannot be changed when %2 is set.';
      GLSetupRead@1019 : Boolean;
      ExportAgainQst@1038 : TextConst 'ENU=One or more of the selected lines have already been exported. Do you want to export them again?;ESM=Una o m s de las l neas seleccionadas ya se han exportado.  Desea repetir la exportaci n?;FRC=Une ou plusieurs des lignes s lectionn es ont d j   t  export es. Souhaitez-vous les exporter   nouveau ?;ENC=One or more of the selected lines have already been exported. Do you want to export them again?';
      NothingToExportErr@1021 : TextConst 'ENU=There is nothing to export.;ESM=No hay nada que exportar.;FRC=Il n''y a rien   exporter.;ENC=There is nothing to export.';
      NotExistErr@1068 : TextConst 'ENU=Document No. %1 does not exist or is already closed.;ESM=El n  de documento %1 no existe o ya est  cerrado.;FRC=Le N  document %1 n''existe pas ou est d j  ferm .;ENC=Document No. %1 does not exist or is already closed.';
      DocNoFilterErr@1047 : TextConst 'ENU=The document numbers cannot be renumbered while there is an active filter on the Document No. field.;ESM=Los n meros de documento no se pueden volver a enumerar mientras haya un filtro activo en el campo N  documento.;FRC=Les num ros de document ne peuvent pas  tre modifi s lorsqu''un filtre est actif sur le champ N  document.;ENC=The document numbers cannot be renumbered while there is an active filter on the Document No. field.';
      DueDateMsg@1150 : TextConst 'ENU=This posting date will cause an overdue payment.;ESM=Esta fecha de registro resultar  en un pago vencido.;FRC=Cette date de report va entra ner un paiement  chu.;ENC=This posting date will cause an overdue payment.';
      CalcPostDateMsg@1169 : TextConst 'ENU=Processing payment journal lines #1##########;ESM=Procesando l ns. diario pagos #1##########;FRC=Traitement lignes journal paiement #1##########;ENC=Processing payment journal lines #1##########';
      AccTypeNotSupportedErr@1055 : TextConst 'ENU=You cannot specify a deferral code for this type of account.;ESM=No se puede especificar un c digo de fraccionamiento para este tipo de cuenta.;FRC=Vous ne pouvez pas sp cifier un code  chelonnement pour ce type de compte.;ENC=You cannot specify a deferral code for this type of account.';
      Memb@1000000000 : Record 51516223;

    BEGIN
    END.
  }
}

