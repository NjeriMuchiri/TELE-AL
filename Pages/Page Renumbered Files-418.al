OBJECT page 172013 Accounting Role Center-M
{
  OBJECT-PROPERTIES
  {
    Date=07/20/16;
    Time=[ 5:01:44 PM];
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
      { 1000000048;1 ;Action    ;
                      CaptionML=ENU=Master Payroll Summary;
                      RunObject=Report 51516474;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1000000033;1 ;Action    ;
                      CaptionML=ENU=All Deductions Summary;
                      RunObject=Report 51516472;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1000000032;1 ;Action    ;
                      CaptionML=ENU=All Earnings Summary;
                      RunObject=Report 51516473;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1000000030;1 ;Action    ;
                      CaptionML=ENU=vew payslip;
                      RunObject=Report 51516414;
                      Promoted=Yes;
                      Image=Report }
      { 1000000029;1 ;Action    ;
                      CaptionML=ENU=Payroll summary;
                      RunObject=Report 51516480;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1000000028;1 ;Action    ;
                      CaptionML=ENU=Deductions Summary;
                      RunObject=Report 51516470;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1000000027;1 ;Action    ;
                      CaptionML=ENU=Earnings Summary;
                      RunObject=Report 51516471;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1000000026;1 ;Action    ;
                      CaptionML=ENU=Provident Schedule;
                      RunObject=Report 51516484;
                      Image=Report }
      { 1000000025;1 ;Action    ;
                      CaptionML=ENU=NSSF Schedule;
                      RunObject=Report 51516479;
                      Image=Report }
      { 1000000023;1 ;Action    ;
                      CaptionML=ENU=NHIF Schedule;
                      RunObject=Report 51516478 }
      { 1000000022;1 ;Action    ;
                      CaptionML=ENU=bank Schedule;
                      RunObject=Report 51516437;
                      Image=Report }
      { 1000000021;1 ;Action    ;
                      CaptionML=ENU=Employee Details;
                      RunObject=Report 51516472;
                      Image=Report }
      { 1000000018;1 ;Action    ;
                      CaptionML=ENU=Net Salary Transfer to FOSA.;
                      RunObject=Report 51516314 }
      { 1000000017;1 ;Action    ;
                      CaptionML=ENU=Payroll Journal Transfer;
                      RunObject=Report 51516200 }
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
      { 48      ;1   ;Action    ;
                      CaptionML=[ENU=&Closing Trial Balance;
                                 ESM=Cierr&e del balance de comprobaci¢n;
                                 FRC=Balan&ce de v‚rification de fermeture;
                                 ENC=&Closing Trial Balance];
                      RunObject=Report 10003;
                      Image=Report }
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
      { 1000000052;1 ;Action    ;
                      CaptionML=ENU=POST MONTHLY INTEREST;
                      RunObject=Report 51516280 }
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
      { 1000000050;2 ;Action    ;
                      CaptionML=ENU=Loans;
                      RunObject=page 17382 }
      { 1000000051;2 ;Action    ;
                      CaptionML=ENU=Fosa Loans;
                      RunObject=page 17457 }
      { 1000000055;2 ;Action    ;
                      CaptionML=ENU=Posted Loans;
                      RunObject=page 17391 }
      { 1000000009;1 ;ActionGroup;
                      CaptionML=ENU=Receipts & Bank Transfer;
                      Image=Journals }
      { 1000000008;2 ;Action    ;
                      CaptionML=ENU=Receipts List;
                      RunObject=page 20410 }
      { 1000000007;2 ;Action    ;
                      CaptionML=ENU=Bank Transfer List;
                      RunObject=page 20416 }
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
      { 1000000024;1 ;ActionGroup;
                      CaptionML=ENU=Payroll }
      { 1000000031;2 ;Action    ;
                      CaptionML=ENU=Employee List;
                      RunObject=page 20472 }
      { 1000000037;2 ;Action    ;
                      CaptionML=ENU=" Earnings List";
                      RunObject=page 20476 }
      { 1000000038;2 ;Action    ;
                      CaptionML=ENU=Deductions List;
                      RunObject=page 20478 }
      { 1000000039;2 ;Action    ;
                      CaptionML=ENU=PAYE Setup;
                      RunObject=page 20480 }
      { 1000000040;2 ;Action    ;
                      CaptionML=ENU=NHIF Setup;
                      RunObject=page 20481 }
      { 1000000041;2 ;Action    ;
                      CaptionML=ENU=NSSF Setup;
                      RunObject=page 20482 }
      { 1000000042;2 ;Action    ;
                      CaptionML=ENU=" Posting Group";
                      RunObject=page 20483 }
      { 1000000043;2 ;Action    ;
                      CaptionML=ENU=Transaction List;
                      RunObject=page 20485 }
      { 1000000044;2 ;Action    ;
                      CaptionML=ENU=Payroll Calender;
                      RunObject=page 20490 }
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
      { 1000000049;2 ;Action    ;
                      CaptionML=ENU=Fosa Authorization;
                      RunObject=page 17438 }
      { 1000000053;2 ;Action    ;
                      CaptionML=ENU=ATM LINKAGE;
                      RunObject=page 17460 }
      { 1000000054;2 ;Action    ;
                      CaptionML=ENU=ATM LOG;
                      RunObject=page 17481 }
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
      { 1000000047;1 ;Action    ;
                      CaptionML=ENU=Import Salaries;
                      RunObject=XMLport 51516009;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process }
      { 1000000046;1 ;Action    ;
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
      { 1000000034;1 ;Separator  }
      { 1000000035;1 ;Action    ;
                      CaptionML=ENU=Employee Earnings;
                      RunObject=page 20474 }
      { 1000000036;1 ;Action    ;
                      CaptionML=ENU=Employee Deductions;
                      RunObject=page 20475 }
      { 1000000045;1 ;Action    ;
                      CaptionML=ENU=Payroll General Setup;
                      RunObject=page 20484 }
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

