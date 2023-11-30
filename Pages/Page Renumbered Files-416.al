OBJECT page 172011 Accounting Role Center
{
  OBJECT-PROPERTIES
  {
    Date=07/22/16;
    Time=[ 1:39:41 PM];
    Modified=Yes;
    Version List=surestep role center;
  }
  PROPERTIES
  {
    CaptionML=[ENU=Role Center;
               ESM=µrea de tareas;
               FRC=Tableau de bord;
               ENC=Role Centre];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1       ;1   ;Action    ;
                      CaptionML=ENU=POST MONTHLY INTEREST;
                      RunObject=Report 51516280 }
      { 32      ;1   ;Action    ;
                      CaptionML=[ENU=&G/L Trial Balance;
                                 ESM=Balance comprobaci¢n con&tabilidad;
                                 FRC=Balance de v‚rification du &GL;
                                 ENC=&G/L Trial Balance];
                      RunObject=Report 10022;
                      Image=Report }
      { 1480103 ;1   ;Action    ;
                      CaptionML=[ENU=Chart of Accounts;
                                 ESM=Cat logo de cuentas;
                                 FRC=Plan comptable;
                                 ENC=Chart of Accounts];
                      RunObject=Report 10002;
                      Image=Report }
      { 33      ;1   ;Action    ;
                      CaptionML=[ENU=&Bank Detail Trial Balance;
                                 ESM=&Balance comprobaci¢n detalles bancarios;
                                 FRC=&Balance de v‚rification bancaire d‚taill‚e;
                                 ENC=&Bank Detail Trial Balance];
                      RunObject=Report 1404;
                      Image=Report }
      { 1480105 ;1   ;Action    ;
                      CaptionML=[ENU=Account Schedule Layout;
                                 ESM=Plantilla Estructura de Cuentas;
                                 FRC=Disposition de tableau d'analyse;
                                 ENC=Account Schedule Layout];
                      RunObject=Report 10000;
                      Image=Report }
      { 34      ;1   ;Action    ;
                      CaptionML=[ENU=&Account Schedule;
                                 ESM=Estr&uctura de Cuentas;
                                 FRC=Tablea&u d'analyse;
                                 ENC=&Account Schedule];
                      RunObject=Report 25;
                      Image=Report }
      { 1480106 ;1   ;Action    ;
                      CaptionML=[ENU=Account Balances by GIFI Code;
                                 ESM=Contrapartidas por c¢d. GIFI;
                                 FRC=Solde des comptes par code IGRF;
                                 ENC=Account Balances by GIFI Code];
                      RunObject=Report 10004;
                      Image=Report }
      { 35      ;1   ;Action    ;
                      CaptionML=[ENU=Budget;
                                 ESM=Presupuesto;
                                 FRC=Budget;
                                 ENC=Budget];
                      RunObject=Report 10001;
                      Image=Report }
      { 36      ;1   ;Action    ;
                      CaptionML=[ENU=Trial Bala&nce/Budget;
                                 ESM=Balance s&umas y saldos/Ppto.;
                                 FRC=Bala&nce de v‚rification/budget;
                                 ENC=Trial Bala&nce/Budget];
                      RunObject=Report 9;
                      Image=Report }
      { 1480009 ;1   ;Action    ;
                      CaptionML=[ENU=Trial Bala&nce, Spread Periods;
                                 ESM=&Balance comprob., period. extend.;
                                 FRC=&Bal. v‚rif. toutes les p‚riodes;
                                 ENC=Trial Bala&nce, Spread Periods];
                      RunObject=Report 10026;
                      Image=Report }
      { 1480007 ;1   ;Action    ;
                      CaptionML=[ENU=Trial Balance, per Global Dim.;
                                 ESM=Balance comprobaci¢n, por Dim. global;
                                 FRC=Balance de v‚rification, par dimension globale;
                                 ENC=Trial Balance, per Global Dim.];
                      RunObject=Report 10023;
                      Image=Report }
      { 1480008 ;1   ;Action    ;
                      CaptionML=[ENU=Trial Balance, Spread G. Dim.;
                                 ESM=Balance comprob., dimen. global extendida;
                                 FRC=Balance v‚rif., dim. globale ‚tendue;
                                 ENC=Trial Balance, Spread G. Dim.];
                      RunObject=Report 10025;
                      Image=Report }
      { 1020001 ;1   ;Action    ;
                      CaptionML=[ENU=Trial Balance Detail/Summary;
                                 ESM=Balance compr./resumen;
                                 FRC=Balance v‚rif. d‚tail/sommaire;
                                 ENC=Trial Balance Detail/Summary];
                      RunObject=Report 10021;
                      Image=Report }
      { 46      ;1   ;Action    ;
                      CaptionML=[ENU=&Fiscal Year Balance;
                                 ESM=Saldo del e&jercicio;
                                 FRC=Solde exercice &financier;
                                 ENC=&Fiscal Year Balance];
                      RunObject=Report 36;
                      Image=Report }
      { 47      ;1   ;Action    ;
                      CaptionML=[ENU=Balance Comp. - Prev. Y&ear;
                                 ESM=Comp. de saldo - A¤o a&nterior;
                                 FRC=Comparaison solde - exercice ant‚ri&eur;
                                 ENC=Balance Comp. - Pr&ev. Year];
                      RunObject=Report 37;
                      Image=Report }
      { 48      ;1   ;Action    ;
                      CaptionML=[ENU=&Closing Trial Balance;
                                 ESM=Cierr&e del balance de comprobaci¢n;
                                 FRC=Balan&ce de v‚rification de fermeture;
                                 ENC=&Closing Trial Balance];
                      RunObject=Report 10003;
                      Image=Report }
      { 1020000 ;1   ;Action    ;
                      CaptionML=[ENU=Consol. Trial Balance;
                                 ESM=Balance comprobaci¢n consol.;
                                 FRC=Balance de v‚rification consol.;
                                 ENC=Consol. Trial Balance];
                      RunObject=Report 10007;
                      Image=Report }
      { 49      ;1   ;Separator  }
      { 104     ;1   ;Action    ;
                      CaptionML=[ENU=Cash Flow Date List;
                                 ESM=Lista fechas flujo efectivo;
                                 FRC=Liste date tr‚sorerie;
                                 ENC=Cash Flow Date List];
                      RunObject=Report 846;
                      Image=Report }
      { 115     ;1   ;Separator  }
      { 50      ;1   ;Action    ;
                      CaptionML=[ENU=Aged Accounts &Receivable;
                                 ESM=&Antigedad cobros;
                                 FRC=Comptes clients class‚s ch&ronologiquement;
                                 ENC=Aged Accounts &Receivable];
                      RunObject=Report 10040;
                      Image=Report }
      { 51      ;1   ;Action    ;
                      CaptionML=[ENU=Aged Accounts Pa&yable;
                                 ESM=Antigedad pa&gos;
                                 FRC=C&omptes fournisseurs class‚s chronologiquement;
                                 ENC=Aged Accounts Pa&yable];
                      RunObject=Report 10085;
                      Image=Report }
      { 1400010 ;1   ;Action    ;
                      CaptionML=[ENU=Projected Cash Receipts;
                                 ESM=Cobros proyectados;
                                 FRC=Encaissements pr‚vus;
                                 ENC=Projected Cash Receipts];
                      RunObject=Report 10057;
                      Image=Report }
      { 1400013 ;1   ;Action    ;
                      CaptionML=[ENU=Cash Requirem. by Due Date;
                                 ESM=Req. efectivo por fecha venc.;
                                 FRC=Besoin d'encaisse par date d'‚ch‚ance;
                                 ENC=Cash Requirem. by Due Date];
                      RunObject=Report 10088;
                      Image=Report }
      { 1400011 ;1   ;Action    ;
                      CaptionML=[ENU=Projected Cash Payments;
                                 ESM=Pagos al contado pronost.;
                                 FRC=Paiements encaisse pr‚vus;
                                 ENC=Projected Cash Payments];
                      RunObject=Report 10098;
                      Image=PaymentForecast }
      { 1400012 ;1   ;Action    ;
                      CaptionML=[ENU=Reconcile Cust. and Vend. Accs;
                                 ESM=Reconc. ctas. client. y prov.;
                                 FRC=Rapprocher comptes clients et fournisseurs;
                                 ENC=Reconcile Cust. and Vend. Accs];
                      RunObject=Report 33;
                      Image=Report }
      { 1400014 ;1   ;Action    ;
                      CaptionML=[ENU=Daily Invoicing Report;
                                 ESM=Informe fact. diario;
                                 FRC=Rapport facturation quotidienne;
                                 ENC=Daily Invoicing Report];
                      RunObject=Report 10050;
                      Image=Report }
      { 1400015 ;1   ;Action    ;
                      CaptionML=[ENU=Bank Account - Reconcile;
                                 ESM=Banco - Control;
                                 FRC=Compte bancaire - Rapprochement;
                                 ENC=Bank Account - Reconcile];
                      RunObject=Report 10409;
                      Image=Report }
      { 53      ;1   ;Separator  }
      { 1480110 ;1   ;Separator ;
                      CaptionML=[ENU=Sales Tax;
                                 ESM=Impto. vtas.;
                                 FRC=Taxe de vente;
                                 ENC=Sales Tax];
                      IsHeader=Yes }
      { 1480111 ;1   ;Action    ;
                      CaptionML=[ENU=Sales Tax Details;
                                 ESM=Detalles impuesto ventas;
                                 FRC=D‚tails taxes de vente;
                                 ENC=Sales Tax Details];
                      RunObject=Report 10323;
                      Image=Report }
      { 1480112 ;1   ;Action    ;
                      CaptionML=[ENU=Sales Tax Groups;
                                 ESM=Grupos impuesto ventas;
                                 FRC=Groupes taxes de vente;
                                 ENC=Sales Tax Groups];
                      RunObject=Report 10324;
                      Image=Report }
      { 1480113 ;1   ;Action    ;
                      CaptionML=[ENU=Sales Tax Jurisdictions;
                                 ESM=Jurisdicci¢n impuesto ventas;
                                 FRC=Juridictions de taxe de vente;
                                 ENC=Sales Tax Jurisdictions];
                      RunObject=Report 10325;
                      Image=Report }
      { 1480114 ;1   ;Action    ;
                      CaptionML=[ENU=Sales Tax Areas;
                                 ESM=µreas impuesto ventas;
                                 FRC=R‚gions de taxe de vente;
                                 ENC=Sales Tax Areas];
                      RunObject=Report 10321;
                      Image=Report }
      { 1480115 ;1   ;Action    ;
                      CaptionML=[ENU=Sales Tax Detail by Area;
                                 ESM=Det. impto. vtas. por  rea;
                                 FRC=D‚tails de la taxe de vente par r‚gion;
                                 ENC=Sales Tax Detail by Area];
                      RunObject=Report 10322;
                      Image=Report }
      { 1480116 ;1   ;Action    ;
                      CaptionML=[ENU=Sales Taxes Collected;
                                 ESM=Impuestos venta cobrados;
                                 FRC=Taxes de vente pr‚lev‚es;
                                 ENC=Sales Taxes Collected];
                      RunObject=Report 24;
                      Image=Report }
      { 56      ;1   ;Action    ;
                      CaptionML=[ENU=Tax Statement;
                                 ESM=Declaraci¢n IVA;
                                 FRC=Relev‚ fiscal;
                                 ENC=Tax Statement];
                      RunObject=Report 12;
                      Image=Report }
      { 57      ;1   ;Action    ;
                      CaptionML=[ENU=VAT - VIES Declaration Tax Aut&h;
                                 ESM=I&VA - Admon. fiscal decl. VIES;
                                 FRC=TVA - Aut&h. fiscales d‚claration VIES;
                                 ENC=Tax - VIES Declaration Tax Aut&h];
                      RunObject=Report 19;
                      Image=Report }
      { 58      ;1   ;Action    ;
                      CaptionML=[ENU=VAT - VIES Declaration Dis&k;
                                 ESM=IVA - Declar. int&racom. disco;
                                 FRC=TVA - Dis&que de d‚claration VIES;
                                 ENC=Tax - VIES Declaration Dis&k];
                      RunObject=Report 88;
                      Image=Report }
      { 59      ;1   ;Action    ;
                      CaptionML=[ENU=EC Sales &List;
                                 ESM=&Lista venta CE;
                                 FRC=&Liste de vente EC;
                                 ENC=EC Sales &List];
                      RunObject=Report 130;
                      Image=Report }
      { 60      ;1   ;Separator  }
      { 61      ;1   ;Action    ;
                      CaptionML=[ENU=&Intrastat - Checklist;
                                 ESM=Intra&stat - Test;
                                 FRC=&Intrastat - Liste de v‚rification;
                                 ENC=&Intrastat - Checklist];
                      RunObject=Report 502;
                      Image=Report }
      { 62      ;1   ;Action    ;
                      CaptionML=[ENU=Intrastat - For&m;
                                 ESM=Intrastat - Formular&io;
                                 FRC=Intrastat - For&mulaire;
                                 ENC=Intrastat - For&m];
                      RunObject=Report 501;
                      Image=Report }
      { 4       ;1   ;Separator  }
      { 7       ;1   ;Action    ;
                      CaptionML=[ENU=Cost Accounting P/L Statement;
                                 ESM=Estado de cuenta P/G costos;
                                 FRC=Rapport pertes/profits de comptabilit‚ analytique;
                                 ENC=Cost Accounting P/L Statement];
                      RunObject=Report 1126;
                      Image=Report }
      { 15      ;1   ;Action    ;
                      CaptionML=[ENU=CA P/L Statement per Period;
                                 ESM=Estado de cuenta P/G costos por periodo;
                                 FRC=Rapport pertes/profits CA par p‚riode;
                                 ENC=CA P/L Statement per Period];
                      RunObject=Report 1123;
                      Image=Report }
      { 21      ;1   ;Action    ;
                      CaptionML=[ENU=CA P/L Statement with Budget;
                                 ESM=Estado de cuenta P/G costos con ppto.;
                                 FRC=Rapport pertes/profits CA avec budget;
                                 ENC=CA P/L Statement with Budget];
                      RunObject=Report 1133;
                      Image=Report }
      { 42      ;1   ;Action    ;
                      CaptionML=[ENU=Cost Accounting Analysis;
                                 ESM=An lisis de contabilidad de costos;
                                 FRC=Analyse Comptabilit‚ analytique;
                                 ENC=Cost Accounting Analysis];
                      RunObject=Report 1127;
                      Image=Report }
      { 1400022 ;1   ;Separator  }
      { 1400023 ;1   ;Action    ;
                      CaptionML=[ENU=Outstanding Purch. Order Aging;
                                 ESM=Antigedad pedido compra pdte.;
                                 FRC=Bons de commande en suspens class‚s chronologiquement;
                                 ENC=Outstanding Purch. Order Aging];
                      RunObject=Report 10095;
                      Image=Report }
      { 1400024 ;1   ;Action    ;
                      CaptionML=[ENU=Inventory Valuation;
                                 ESM=Valuaci¢n de inventarios;
                                 FRC=valuation de l'inventaire;
                                 ENC=Inventory Valuation];
                      RunObject=Report 10139;
                      Image=Report }
      { 1400025 ;1   ;Action    ;
                      CaptionML=[ENU=Item Turnover;
                                 ESM=An lisis producto;
                                 FRC=Rotation d'articles;
                                 ENC=Item Turnover];
                      RunObject=Report 10146;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 2       ;1   ;Action    ;
                      CaptionML=[ENU=Chart of Accounts;
                                 ESM=Cat logo de cuentas;
                                 FRC=Plan comptable;
                                 ENC=Chart of Accounts];
                      RunObject=20366 }
      { 8       ;1   ;Action    ;
                      CaptionML=[ENU=Vendors;
                                 ESM=Proveedores;
                                 FRC=Fournisseurs;
                                 ENC=Vendors];
                      RunObject=20374;
                      Image=Vendor }
      { 5       ;1   ;Action    ;
                      CaptionML=[ENU=Balance;
                                 ESM=Saldo;
                                 FRC=Solde;
                                 ENC=Balance];
                      RunObject=20374;
                      RunPageView=WHERE(Balance (LCY)=FILTER(<>0));
                      Image=Balance }
      { 6       ;1   ;Action    ;
                      CaptionML=[ENU=Purchase Orders;
                                 ESM=Pedidos compra;
                                 FRC=Bons de commande;
                                 ENC=Purchase Orders];
                      RunObject=Page 9307 }
      { 76      ;1   ;Action    ;
                      CaptionML=[ENU=Budgets;
                                 ESM=Presupuestos;
                                 FRC=Budgets;
                                 ENC=Budgets];
                      RunObject=Page 121 }
      { 9       ;1   ;Action    ;
                      CaptionML=[ENU=Bank Accounts;
                                 ESM=Bancos;
                                 FRC=Comptes bancaires;
                                 ENC=Bank Accounts];
                      RunObject=Page 371;
                      Image=BankAccount }
      { 10      ;1   ;Action    ;
                      CaptionML=[ENU=Tax Statements;
                                 ESM=Declaraciones IVA;
                                 FRC=Relev‚s fiscaux;
                                 ENC=Tax Statements];
                      RunObject=Page 320 }
      { 11      ;1   ;Action    ;
                      CaptionML=[ENU=Items;
                                 ESM=Productos;
                                 FRC=Articles;
                                 ENC=Items];
                      RunObject=Page 20377;
                      Image=Item }
      { 12      ;1   ;Action    ;
                      CaptionML=[ENU=Customers;
                                 ESM=Clientes;
                                 FRC=Clients;
                                 ENC=Customers];
                      RunObject=20371;
                      Image=Customer }
      { 13      ;1   ;Action    ;
                      CaptionML=[ENU=Balance;
                                 ESM=Saldo;
                                 FRC=Solde;
                                 ENC=Balance];
                      RunObject=20371;
                      RunPageView=WHERE(Balance (LCY)=FILTER(<>0));
                      Image=Balance }
      { 14      ;1   ;Action    ;
                      CaptionML=[ENU=Sales Orders;
                                 ESM=Pedidos venta;
                                 FRC=Documents de vente;
                                 ENC=Sales Orders];
                      RunObject=Page 9305;
                      Image=Order }
      { 1102601003;1 ;Action    ;
                      CaptionML=[ENU=Reminders;
                                 ESM=Recordatorios;
                                 FRC=Rappels;
                                 ENC=Reminders];
                      RunObject=Page 436;
                      Image=Reminder }
      { 1102601004;1 ;Action    ;
                      CaptionML=[ENU=Finance Charge Memos;
                                 ESM=Docs. inter‚s;
                                 FRC=Notes de frais financiers;
                                 ENC=Finance Charge Memos];
                      RunObject=Page 448;
                      Image=FinChargeMemo }
      { 119     ;1   ;Action    ;
                      CaptionML=[ENU=Incoming Documents;
                                 ESM=Documentos entrantes;
                                 FRC=Documents entrants;
                                 ENC=Incoming Documents];
                      RunObject=Page 190;
                      Image=Documents }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 107     ;1   ;ActionGroup;
                      CaptionML=[ENU=Journals;
                                 ESM=Diarios;
                                 FRC=Journaux;
                                 ENC=Journals];
                      Image=Journals }
      { 117     ;2   ;Action    ;
                      CaptionML=[ENU=Purchase Journals;
                                 ESM=Diarios de compras;
                                 FRC=Journaux d'achat;
                                 ENC=Purchase Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Purchases),
                                        Recurring=CONST(No)) }
      { 118     ;2   ;Action    ;
                      CaptionML=[ENU=Sales Journals;
                                 ESM=Diarios de ventas;
                                 FRC=Journaux de ventes;
                                 ENC=Sales Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Sales),
                                        Recurring=CONST(No)) }
      { 113     ;2   ;Action    ;
                      CaptionML=[ENU=Cash Receipt Journals;
                                 ESM=Diarios de recibos de efectivo;
                                 FRC=Journaux des encaissements;
                                 ENC=Cash Receipt Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Cash Receipts),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 114     ;2   ;Action    ;
                      CaptionML=[ENU=Payment Journals;
                                 ESM=Diarios de pagos;
                                 FRC=Journaux des paiements;
                                 ENC=Payment Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Payments),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 1102601000;2 ;Action    ;
                      CaptionML=[ENU=IC General Journals;
                                 ESM=Diarios generales IC;
                                 FRC=Journaux g‚n‚raux IC;
                                 ENC=IC General Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Intercompany),
                                        Recurring=CONST(No)) }
      { 1102601001;2 ;Action    ;
                      CaptionML=[ENU=General Journals;
                                 ESM=Diarios generales;
                                 FRC=Journaux g‚n‚raux;
                                 ENC=General Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(No));
                      Image=Journal }
      { 1102601002;2 ;Action    ;
                      CaptionML=[ENU=Intrastat Journals;
                                 ESM=Diarios Intrastat;
                                 FRC=Journaux Intrastat;
                                 ENC=Intrastat Journals];
                      RunObject=Page 327;
                      Image=Report }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[ENU=Fixed Assets;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      Image=FixedAssets }
      { 17      ;2   ;Action    ;
                      CaptionML=[ENU=Fixed Assets;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      RunObject=Page 5601 }
      { 18      ;2   ;Action    ;
                      CaptionML=[ENU=Insurance;
                                 ESM=Seguros;
                                 FRC=Assurance;
                                 ENC=Insurance];
                      RunObject=Page 5645 }
      { 19      ;2   ;Action    ;
                      CaptionML=[ENU=Fixed Assets G/L Journals;
                                 ESM=Diarios generales A/F;
                                 FRC=Journaux grand livre immobilisations;
                                 ENC=Fixed Assets G/L Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Assets),
                                        Recurring=CONST(No)) }
      { 24      ;2   ;Action    ;
                      CaptionML=[ENU=Fixed Assets Journals;
                                 ESM=Diarios activos fijos;
                                 FRC=Journaux des immobilisations;
                                 ENC=Fixed Assets Journals];
                      RunObject=Page 5633;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 20      ;2   ;Action    ;
                      CaptionML=[ENU=Fixed Assets Reclass. Journals;
                                 ESM=Diario reclasific. activos fijos;
                                 FRC=Journaux reclass. immobilisations;
                                 ENC=Fixed Assets Reclass. Journals];
                      RunObject=Page 5640 }
      { 22      ;2   ;Action    ;
                      CaptionML=[ENU=Insurance Journals;
                                 ESM=Diarios de seguros;
                                 FRC=Journaux d'assurance;
                                 ENC=Insurance Journals];
                      RunObject=Page 5655 }
      { 3       ;2   ;Action    ;
                      Name=<Action3>;
                      CaptionML=[ENU=Recurring General Journals;
                                 ESM=Diarios generales peri¢dicos;
                                 FRC=Journaux g‚n‚raux r‚currents;
                                 ENC=Recurring General Journals];
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(Yes)) }
      { 23      ;2   ;Action    ;
                      CaptionML=[ENU=Recurring Fixed Asset Journals;
                                 ESM=Diarios activos peri¢dicos;
                                 FRC=Journaux r‚currents d'immobilisations;
                                 ENC=Recurring Fixed Asset Journals];
                      RunObject=Page 5633;
                      RunPageView=WHERE(Recurring=CONST(Yes)) }
      { 1000000025;1 ;ActionGroup;
                      CaptionML=ENU=Invoicing }
      { 1000000026;2 ;Action    ;
                      CaptionML=ENU=Purchase Invoice;
                      RunObject=Page 9308 }
      { 1000000004;1 ;ActionGroup;
                      CaptionML=ENU=Payments & Loan Disbursement }
      { 1000000003;2 ;Action    ;
                      CaptionML=ENU=New Payment Vouchers;
                      RunObject=page 20386;
                      RunPageView=WHERE(Status=CONST(New)) }
      { 1000000002;2 ;Action    ;
                      CaptionML=ENU=Pending Payment  Vouchers List;
                      RunObject=page 20386;
                      RunPageView=WHERE(Status=CONST(Pending Approval)) }
      { 1000000000;2 ;Action    ;
                      CaptionML=ENU=Approved Payment Vouchers;
                      RunObject=page 20386;
                      RunPageView=WHERE(Status=CONST(Approved)) }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=New Petty Cash Vouchers List;
                      RunObject=page 20398;
                      RunPageView=WHERE(Status=CONST(New)) }
      { 1000000006;2 ;Action    ;
                      CaptionML=ENU=Pending Petty Cash Vouchers List;
                      RunObject=page 20398;
                      RunPageView=WHERE(Status=CONST(Pending Approval)) }
      { 1000000001;2 ;Action    ;
                      CaptionML=ENU=Approved Petty Cash Vouchers List;
                      RunObject=page 20398;
                      RunPageView=WHERE(Status=CONST(Approved)) }
      { 1000000015;2 ;Action    ;
                      CaptionML=ENU=Loan Disbursement Batch;
                      RunObject=page 17393 }
      { 1000000016;2 ;Action    ;
                      CaptionML=ENU=BOSA Transfer;
                      RunObject=page 50012 }
      { 1000000020;2 ;Action    ;
                      CaptionML=ENU=checkoff;
                      RunObject=page 50004 }
      { 1000000019;2 ;Action    ;
                      CaptionML=ENU=members;
                      RunObject=page 17364 }
      { 1000000017;2 ;Action    ;
                      CaptionML=ENU=Loans Register;
                      RunObject=page 17382 }
      { 1000000018;2 ;Action    ;
                      CaptionML=ENU=Loan List;
                      RunObject=page 17382 }
      { 1000000027;2 ;Action    ;
                      CaptionML=ENU=Member Withdrawals;
                      RunObject=page 17406 }
      { 1000000028;2 ;Action    ;
                      CaptionML=ENU=Member Editable;
                      RunObject=page 17374 }
      { 1000000009;1 ;ActionGroup;
                      CaptionML=ENU=Receipts & Bank Transfer;
                      Image=Journals }
      { 1000000008;2 ;Action    ;
                      CaptionML=ENU=Receipts List;
                      RunObject=page 20410 }
      { 1000000007;2 ;Action    ;
                      CaptionML=ENU=Bank Transfer List;
                      RunObject=page 20416 }
      { 1000000021;1 ;ActionGroup;
                      CaptionML=ENU=setups }
      { 1000000022;2 ;Action    ;
                      CaptionML=ENU=Payment Types;
                      RunObject=page 20435 }
      { 1000000014;1 ;ActionGroup;
                      CaptionML=ENU=Posted Documents;
                      Image=FiledPosted }
      { 1000000013;2 ;Action    ;
                      CaptionML=ENU=Posted Payment Vouchers List;
                      RunObject=page 20389 }
      { 1000000012;2 ;Action    ;
                      CaptionML=ENU=Posted Petty Cash Vouchers;
                      RunObject=page 20401 }
      { 1000000011;2 ;Action    ;
                      CaptionML=ENU=Posted Receipt List;
                      RunObject=page 20413 }
      { 1000000010;2 ;Action    ;
                      CaptionML=ENU=" Posted IBT  List";
                      RunObject=page 20419 }
      { 25      ;2   ;Action    ;
                      CaptionML=[ENU=Posted Sales Invoices;
                                 ESM=Hist¢rico facturas venta;
                                 FRC=Factures ventes report‚es;
                                 ENC=Posted Sales Invoices];
                      RunObject=Page 143;
                      Image=PostedOrder }
      { 26      ;2   ;Action    ;
                      CaptionML=[ENU=Posted Sales Credit Memos;
                                 ESM=Notas de cr‚dito ventas registradas;
                                 FRC=Notes cr‚dit ventes report‚es;
                                 ENC=Posted Sales Credit Memos];
                      RunObject=Page 144;
                      Image=PostedOrder }
      { 27      ;2   ;Action    ;
                      CaptionML=[ENU=Posted Purchase Invoices;
                                 ESM=Hist¢rico facturas compra;
                                 FRC=Factures d'achat report‚es;
                                 ENC=Posted Purchase Invoices];
                      RunObject=Page 146 }
      { 28      ;2   ;Action    ;
                      CaptionML=[ENU=Posted Purchase Credit Memos;
                                 ESM=Notas de cr‚dito compras registradas;
                                 FRC=Notes de cr‚dit achat report‚es;
                                 ENC=Posted Purchase Credit Memos];
                      RunObject=Page 147 }
      { 29      ;2   ;Action    ;
                      CaptionML=[ENU=Issued Reminders;
                                 ESM=Recordatorios emitidos;
                                 FRC=Rappels ‚mis;
                                 ENC=Issued Reminders];
                      RunObject=Page 440;
                      Image=OrderReminder }
      { 30      ;2   ;Action    ;
                      CaptionML=[ENU=Issued Fin. Charge Memos;
                                 ESM=Docs. de inter‚s emitidos;
                                 FRC=Notes de frais fin. ‚mis;
                                 ENC=Issued Fin. Charge Memos];
                      RunObject=Page 452;
                      Image=PostedMemo }
      { 92      ;2   ;Action    ;
                      CaptionML=[ENU=G/L Registers;
                                 ESM=Registro movs. contabilidad;
                                 FRC=Registres GL;
                                 ENC=G/L Registers];
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 83      ;2   ;Action    ;
                      CaptionML=[ENU=Cost Accounting Registers;
                                 ESM=Registros contabilidad costos;
                                 FRC=Historiques des transactions Comptabilit‚ analytique;
                                 ENC=Cost Accounting Registers];
                      RunObject=Page 1104 }
      { 91      ;2   ;Action    ;
                      CaptionML=[ENU=Cost Accounting Budget Registers;
                                 ESM=Registros presupuestos contabilidad costos;
                                 FRC=Historiques des transactions budg‚taires Comptabilit‚ analytique;
                                 ENC=Cost Accounting Budget Registers];
                      RunObject=Page 1121 }
      { 1400016 ;2   ;Action    ;
                      CaptionML=[ENU=Posted Deposits;
                                 ESM=Dep¢sitos registrados;
                                 FRC=D‚p“ts report‚s;
                                 ENC=Posted Deposits];
                      RunObject=Page 10147;
                      Image=PostedDeposit }
      { 1400020 ;2   ;Action    ;
                      CaptionML=[ENU=Posted Bank Recs.;
                                 ESM=Conciliaciones registradas;
                                 FRC=Rapprochements bancaires report‚s;
                                 ENC=Posted Bank Recs.];
                      RunObject=Page 10129 }
      { 1020003 ;2   ;Action    ;
                      CaptionML=[ENU=Bank Statements;
                                 ESM=Estados de cuenta banco;
                                 FRC=Relev‚s bancaires;
                                 ENC=Bank Statements];
                      RunObject=Page 389 }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[ENU=Administration;
                                 ESM=Administraci¢n;
                                 FRC=Administration;
                                 ENC=Administration];
                      Image=Administration }
      { 38      ;2   ;Action    ;
                      CaptionML=[ENU=Currencies;
                                 ESM=Divisas;
                                 FRC=Devises;
                                 ENC=Currencies];
                      RunObject=Page 5;
                      Image=Currency }
      { 40      ;2   ;Action    ;
                      CaptionML=[ENU=Accounting Periods;
                                 ESM=Periodos contables;
                                 FRC=P‚riodes comptables;
                                 ENC=Accounting Periods];
                      RunObject=Page 100;
                      Image=AccountingPeriods }
      { 41      ;2   ;Action    ;
                      CaptionML=[ENU=Number Series;
                                 ESM=Serie num‚rica;
                                 FRC=S‚rie de num‚ros;
                                 ENC=Number Series];
                      RunObject=Page 456 }
      { 43      ;2   ;Action    ;
                      CaptionML=[ENU=Analysis Views;
                                 ESM=Vistas an lisis;
                                 FRC=Vues d'analyse;
                                 ENC=Analysis Views];
                      RunObject=Page 556 }
      { 93      ;2   ;Action    ;
                      CaptionML=[ENU=Account Schedules;
                                 ESM=Estructuras de Cuentas;
                                 FRC=Tableaux d'analyse;
                                 ENC=Account Schedules];
                      RunObject=Page 103 }
      { 44      ;2   ;Action    ;
                      CaptionML=[ENU=Dimensions;
                                 ESM=Dimensiones;
                                 FRC=Dimensions;
                                 ENC=Dimensions];
                      RunObject=Page 536;
                      Image=Dimensions }
      { 45      ;2   ;Action    ;
                      CaptionML=[ENU=Bank Account Posting Groups;
                                 ESM=Grupos contables bancos;
                                 FRC=ParamŠtres report compte bancaire;
                                 ENC=Bank Account Posting Groups];
                      RunObject=Page 373 }
      { 1400000 ;2   ;Action    ;
                      CaptionML=[ENU=IRS 1099 Form-Box;
                                 ESM=Form. IRS 1099-Campo;
                                 FRC=Case du formulaire IRS 1099;
                                 ENC=IRS 1099 Form-Box];
                      RunObject=Page 10015;
                      Image=1099Form }
      { 1400001 ;2   ;Action    ;
                      CaptionML=[ENU=GIFI Codes;
                                 ESM=C¢d. GIFI;
                                 FRC=Codes IGRF;
                                 ENC=GIFI Codes];
                      RunObject=Page 10017 }
      { 1400002 ;2   ;Action    ;
                      CaptionML=[ENU=Tax Areas;
                                 ESM=µreas impuesto;
                                 FRC=R‚gions fiscales;
                                 ENC=Tax Areas];
                      RunObject=Page 469 }
      { 1400003 ;2   ;Action    ;
                      CaptionML=[ENU=Tax Jurisdictions;
                                 ESM=Jurisdicciones impuesto;
                                 FRC=Juridictions fiscales;
                                 ENC=Tax Jurisdictions];
                      RunObject=Page 466 }
      { 1400004 ;2   ;Action    ;
                      CaptionML=[ENU=Tax Groups;
                                 ESM=Grupos impuesto;
                                 FRC=Groupes fiscaux;
                                 ENC=Tax Groups];
                      RunObject=Page 467 }
      { 1400005 ;2   ;Action    ;
                      CaptionML=[ENU=Tax Details;
                                 ESM=Detalles impuesto;
                                 FRC=D‚tails fiscaux;
                                 ENC=Tax Details];
                      RunObject=Page 468 }
      { 1400006 ;2   ;Action    ;
                      CaptionML=[ENU=Tax  Business Posting Groups;
                                 ESM=Grupos registro de IVA compa¤¡a;
                                 FRC=ParamŠtres report march‚ fiscal;
                                 ENC=Tax  Business Posting Groups];
                      RunObject=Page 470 }
      { 1400007 ;2   ;Action    ;
                      CaptionML=[ENU=Tax Product Posting Groups;
                                 ESM=Grupos registro IVA producto;
                                 FRC=ParamŠtres report produit fiscal;
                                 ENC=Tax Product Posting Groups];
                      RunObject=Page 471 }
      { 1400009 ;1   ;ActionGroup;
                      CaptionML=[ENU=Cash Management;
                                 ESM=Tesorer¡a;
                                 FRC=Gestion de tr‚sorerie;
                                 ENC=Cash Management] }
      { 1400017 ;2   ;Action    ;
                      CaptionML=[ENU=Bank Accounts;
                                 ESM=Bancos;
                                 FRC=Comptes bancaires;
                                 ENC=Bank Accounts];
                      RunObject=Page 371;
                      Image=BankAccount }
      { 1400018 ;2   ;Action    ;
                      CaptionML=[ENU=Deposit;
                                 ESM=Dep¢sito;
                                 FRC=D‚p“t;
                                 ENC=Deposit];
                      RunObject=Page 36646;
                      Image=DepositSlip }
      { 1400019 ;2   ;Action    ;
                      CaptionML=[ENU=Bank Rec.;
                                 ESM=Conc. &banco;
                                 FRC=Rapprochement bancaire;
                                 ENC=Bank Rec.];
                      RunObject=Page 388 }
      { 105     ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 66      ;1   ;Action    ;
                      CaptionML=[ENU=Sales &Credit Memo;
                                 ESM=Nota cr‚&dito venta;
                                 FRC=Note de &cr‚dit de vente;
                                 ENC=Sales &Credit Memo];
                      RunObject=Page 44;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 65      ;1   ;Action    ;
                      CaptionML=[ENU=P&urchase Credit Memo;
                                 ESM=&Nota cr‚dito compra;
                                 FRC=N&ote de cr‚dit d'achat;
                                 ENC=P&urchase Credit Memo];
                      RunObject=Page 52;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1020002 ;1   ;Action    ;
                      CaptionML=[ENU=Bank Account Reconciliation;
                                 ESM=Conciliaci¢n banco;
                                 FRC=Rapprochement de compte bancaire;
                                 ENC=Bank Account Reconciliation];
                      RunObject=Page 388;
                      Promoted=No;
                      Image=BankAccountRec;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000023;1 ;Action    ;
                      CaptionML=ENU=Import Salaries;
                      RunObject=XMLport 51516009;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process }
      { 1000000024;1 ;Action    ;
                      CaptionML=ENU=Salaries Buffer;
                      RunObject=page 17478;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process }
      { 64      ;1   ;Separator ;
                      CaptionML=[ENU=Tasks;
                                 ESM=Tareas;
                                 FRC=Tƒches;
                                 ENC=Tasks];
                      IsHeader=Yes }
      { 94      ;1   ;Action    ;
                      CaptionML=[ENU=Cas&h Receipt Journal;
                                 ESM=&Diario de recibos de efectivo;
                                 FRC=Journal des encai&ssements;
                                 ENC=Cas&h Receipt Journal];
                      RunObject=Page 255;
                      Image=CashReceiptJournal }
      { 95      ;1   ;Action    ;
                      CaptionML=[ENU=Pa&yment Journal;
                                 ESM=Diario &pagos;
                                 FRC=Journal des pa&iements;
                                 ENC=Pa&yment Journal];
                      RunObject=Page 256;
                      Image=PaymentJournal }
      { 1480096 ;1   ;Action    ;
                      CaptionML=[ENU=Purchase Journal;
                                 ESM=Diario compras;
                                 FRC=Journal des achats;
                                 ENC=Purchase Journal];
                      RunObject=Page 254;
                      Image=Journals }
      { 1480100 ;1   ;Action    ;
                      CaptionML=[ENU=Deposit;
                                 ESM=Dep¢sito;
                                 FRC=D‚p“t;
                                 ENC=Deposit];
                      RunObject=Page 10140;
                      Image=DepositSlip }
      { 67      ;1   ;Separator  }
      { 110     ;1   ;Action    ;
                      CaptionML=[ENU=Analysis &Views;
                                 ESM=Vistas &an lisis;
                                 FRC=&Vues d'analyse;
                                 ENC=Analysis &Views];
                      RunObject=Page 556;
                      Image=AnalysisView }
      { 98      ;1   ;Action    ;
                      CaptionML=[ENU=Analysis by &Dimensions;
                                 ESM=An lisis por dim&ensiones;
                                 FRC=Anal&yse par dimensions;
                                 ENC=Analysis by &Dimensions];
                      RunObject=Page 554;
                      Image=AnalysisViewDimension }
      { 68      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Calculate Deprec&iation;
                                 ESM=Calcular amort&izaci¢n;
                                 FRC=Calculer l'amortisseme&nt;
                                 ENC=Calculate Deprec&iation];
                      RunObject=Report 5692;
                      Image=CalculateDepreciation }
      { 69      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Import Co&nsolidation from Database;
                                 ESM=Importar c&onsolidaci¢n de base de datos;
                                 FRC=Importer la consolidation de la &base de donn‚es;
                                 ENC=Import Co&nsolidation from Database];
                      RunObject=Report 90;
                      Image=ImportDatabase }
      { 70      ;1   ;Action    ;
                      CaptionML=[ENU=Bank Account R&econciliation;
                                 ESM=Conciliaci¢n b&anco;
                                 FRC=Rapproch&ement de compte bancaire;
                                 ENC=Bank Account R&econciliation];
                      RunObject=Page 388;
                      Image=BankAccountRec }
      { 71      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Adjust E&xchange Rates;
                                 ESM=A&justar tipos de cambio;
                                 FRC=Ajuster tau&x de change;
                                 ENC=Adjust E&xchange Rates];
                      RunObject=Report 595;
                      Image=AdjustExchangeRates }
      { 72      ;1   ;Action    ;
                      CaptionML=[ENU=P&ost Inventory Cost to G/L;
                                 ESM=Regis. variaci¢n in&ventario;
                                 FRC=Reporter le co–t des stocks a&u grand livre;
                                 ENC=Post In&ventory Cost to G/L];
                      RunObject=Report 1002;
                      Image=PostInventoryToGL }
      { 97      ;1   ;Separator  }
      { 78      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=C&reate Reminders;
                                 ESM=C&rear recordatorios;
                                 FRC=C&r‚er rappels;
                                 ENC=C&reate Reminders];
                      RunObject=Report 188;
                      Image=CreateReminders }
      { 79      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Create Finance Charge &Memos;
                                 ESM=Crear doc&umentos inter‚s;
                                 FRC=Cr‚er factures d'int‚&rˆts;
                                 ENC=Create Finance Charge &Memos];
                      RunObject=Report 191;
                      Image=CreateFinanceChargememo }
      { 73      ;1   ;Separator  }
      { 81      ;1   ;Action    ;
                      CaptionML=[ENU=Intrastat &Journal;
                                 ESM=Diario In&trastat;
                                 FRC=&Journal Intrastat;
                                 ENC=Intrastat &Journal];
                      RunObject=Page 327;
                      Image=Journal }
      { 82      ;1   ;Action    ;
                      CaptionML=[ENU=Calc. and Pos&t Tax Settlement;
                                 ESM=Calc. y registrar li&q. IVA;
                                 FRC=Calculer et repor&ter le relev‚ de TVA;
                                 ENC=Calc. and Pos&t Tax Settlement];
                      RunObject=Report 20;
                      Image=SettleOpenTransactions }
      { 80      ;1   ;Separator ;
                      CaptionML=[ENU=Administration;
                                 ESM=Administraci¢n;
                                 FRC=Administration;
                                 ENC=Administration];
                      IsHeader=Yes }
      { 85      ;1   ;Action    ;
                      CaptionML=[ENU=General &Ledger Setup;
                                 ESM=Confi&guraci¢n contabilidad;
                                 FRC=Configuration du grand &livre;
                                 ENC=General &Ledger Setup];
                      RunObject=Page 118;
                      Image=Setup }
      { 86      ;1   ;Action    ;
                      CaptionML=[ENU=&Sales && Receivables Setup;
                                 ESM=Configuraci¢n venta&s y cobros;
                                 FRC=Configuration des ventes && des co&mptes … recevoir;
                                 ENC=&Sales && Receivables Setup];
                      RunObject=Page 459;
                      Image=Setup }
      { 87      ;1   ;Action    ;
                      CaptionML=[ENU=&Purchases && Payables Setup;
                                 ESM=&Configuraci¢n compras y pagos;
                                 FRC=Configuration des achats && des comptes … &payer;
                                 ENC=&Purchases && Payables Setup];
                      RunObject=Page 460;
                      Image=Setup }
      { 88      ;1   ;Action    ;
                      CaptionML=[ENU=&Fixed Asset Setup;
                                 ESM=Configuraci¢n &activos;
                                 FRC=&Configuration des immobilisations;
                                 ENC=&Fixed Asset Setup];
                      RunObject=Page 5607;
                      Image=Setup }
      { 101     ;1   ;Action    ;
                      CaptionML=[ENU=Cash Flow Setup;
                                 ESM=Configuraci¢n flujos efectivo;
                                 FRC=Configuration tr‚sorerie;
                                 ENC=Cash Flow Setup];
                      RunObject=Page 846;
                      Image=CashFlowSetup }
      { 96      ;1   ;Action    ;
                      CaptionML=[ENU=Cost Accounting Setup;
                                 ESM=Configuraci¢n contabilidad costos;
                                 FRC=Configuration comptabilit‚ analytique;
                                 ENC=Cost Accounting Setup];
                      RunObject=Page 1113;
                      Image=CostAccountingSetup }
      { 89      ;1   ;Separator ;
                      CaptionML=[ENU=History;
                                 ESM=Historial;
                                 FRC=Historique;
                                 ENC=History];
                      IsHeader=Yes }
      { 90      ;1   ;Action    ;
                      CaptionML=[ENU=Navi&gate;
                                 ESM=&Navegar;
                                 FRC=Navi&guer;
                                 ENC=Navi&gate];
                      RunObject=Page 344;
                      Image=Navigate }
      { 1480099 ;1   ;Action    ;
                      CaptionML=[ENU=Export GIFI Info. to Excel;
                                 ESM=Exportar info GIFI a Excel;
                                 FRC=Exporter donn‚es IGRF vers fichier Excel;
                                 ENC=Export GIFI Info. to Excel];
                      RunObject=Report 10005;
                      Image=ExportToExcel }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 99  ;2   ;Part      ;
                PagePartID=Page762;
                Visible=false;
                PartType=Page }

    { 1902304208;2;Part   ;
                PagePartID=Page9030;
                PartType=Page }

    { 1907692008;2;Part   ;
                PagePartID=Page9150;
                PartType=Page }

    { 1900724708;1;Group   }

    { 103 ;2   ;Part      ;
                PagePartID=Page760;
                Visible=FALSE;
                PartType=Page }

    { 106 ;2   ;Part      ;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 100 ;2   ;Part      ;
                PagePartID=Page869;
                PartType=Page }

    { 1902476008;2;Part   ;
                PagePartID=Page9151;
                PartType=Page }

    { 108 ;2   ;Part      ;
                PagePartID=Page681;
                PartType=Page }

    { 1903012608;2;Part   ;
                PagePartID=Page9175;
                PartType=Page }

    { 1901377608;2;Part   ;
                PartType=System;
                SystemPartID=MyNotes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

