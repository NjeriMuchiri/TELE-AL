OBJECT page 172012 FOSA Role Center
{
  OBJECT-PROPERTIES
  {
    Date=06/23/16;
    Time=[ 5:15:30 PM];
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
      { 32      ;1   ;Action    ;
                      CaptionML=[ENU=Process Cheque Clearing;
                                 ESM=Balance comprobaci¢n con&tabilidad;
                                 FRC=Balance de v‚rification du &GL;
                                 ENC=&G/L Trial Balance];
                      RunObject=Report 51516271;
                      Image=Report }
      { 1480103 ;1   ;Action    ;
                      CaptionML=[ENU=Process Standing Orders;
                                 ESM=Cat logo de cuentas;
                                 FRC=Plan comptable;
                                 ENC=Chart of Accounts];
                      RunObject=Report 51516272;
                      Image=Report }
      { 33      ;1   ;Action    ;
                      CaptionML=[ENU=Generate FOSA Interest;
                                 ESM=&Balance comprobaci¢n detalles bancarios;
                                 FRC=&Balance de v‚rification bancaire d‚taill‚e;
                                 ENC=&Bank Detail Trial Balance];
                      RunObject=Report 51516273;
                      Image=Report }
      { 1480105 ;1   ;Action    ;
                      CaptionML=[ENU=Transfer FOSA Interest;
                                 ESM=Plantilla Estructura de Cuentas;
                                 FRC=Disposition de tableau d'analyse;
                                 ENC=Account Schedule Layout];
                      RunObject=Report 51516274;
                      Image=Report }
      { 34      ;1   ;Action    ;
                      CaptionML=[ENU=Calculate Fixed Int;
                                 ESM=Estr&uctura de Cuentas;
                                 FRC=Tablea&u d'analyse;
                                 ENC=&Account Schedule];
                      RunObject=Report 51516275;
                      Image=Report }
      { 1480106 ;1   ;Action    ;
                      CaptionML=[ENU=Accounts Status;
                                 ESM=Contrapartidas por c¢d. GIFI;
                                 FRC=Solde des comptes par code IGRF;
                                 ENC=Account Balances by GIFI Code];
                      RunObject=Report 51516276;
                      Image=Report }
      { 35      ;1   ;Action    ;
                      CaptionML=[ENU=Accounts Balances;
                                 ESM=Presupuesto;
                                 FRC=Budget;
                                 ENC=Budget];
                      RunObject=Report 51516277;
                      Image=Report }
      { 36      ;1   ;Action    ;
                      CaptionML=[ENU=Generate Dormant Accounts;
                                 ESM=Balance s&umas y saldos/Ppto.;
                                 FRC=Bala&nce de v‚rification/budget;
                                 ENC=Trial Bala&nce/Budget];
                      RunObject=Report 51516278;
                      Image=Report }
      { 1480009 ;1   ;Action    ;
                      CaptionML=[ENU=Loans Register;
                                 ESM=&Balance comprob., period. extend.;
                                 FRC=&Bal. v‚rif. toutes les p‚riodes;
                                 ENC=Trial Bala&nce, Spread Periods];
                      RunObject=Report 51516227;
                      Image=Report }
      { 1000000027;1 ;Action    ;
                      CaptionML=ENU=Cashier Report;
                      RunObject=Report 51516270;
                      Promoted=Yes;
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
      { 1000000012;1 ;ActionGroup;
                      CaptionML=[ENU=Account Opening;
                                 ESM=Diarios;
                                 FRC=Journaux;
                                 ENC=Journals];
                      Image=Journals }
      { 1000000011;2 ;Action    ;
                      CaptionML=ENU=Accounts Application List;
                      RunObject=page 17428 }
      { 1000000010;2 ;Action    ;
                      CaptionML=[ENU=Accounts Application History;
                                 ESM=Diarios de ventas;
                                 FRC=Journaux de ventes;
                                 ENC=Sales Journals];
                      RunObject=page 17426 }
      { 107     ;1   ;ActionGroup;
                      CaptionML=[ENU=Accounts Holders;
                                 ESM=Diarios;
                                 FRC=Journaux;
                                 ENC=Journals];
                      Image=Journals }
      { 117     ;2   ;Action    ;
                      CaptionML=ENU=Member Accounts List;
                      RunObject=page 17433 }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[ENU=Banking;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      Image=FixedAssets }
      { 17      ;2   ;Action    ;
                      CaptionML=[ENU=Cashier Transactions;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      RunObject=page 17439 }
      { 18      ;2   ;Action    ;
                      CaptionML=[ENU=Cashier Transactions Authorisation;
                                 ESM=Seguros;
                                 FRC=Assurance;
                                 ENC=Insurance];
                      RunObject=page 17438 }
      { 1000000003;2 ;Action    ;
                      CaptionML=ENU=ATM Log Entries;
                      RunObject=page 17479 }
      { 1000000004;2 ;Action    ;
                      CaptionML=ENU=ATM Transactions;
                      RunObject=page 17481 }
      { 1000000019;2 ;Action    ;
                      CaptionML=ENU=EFT List;
                      RunObject=page 17448 }
      { 1000000009;2 ;Action    ;
                      CaptionML=ENU=Fund Transfer;
                      RunObject=page 20416 }
      { 1000000008;2 ;Action    ;
                      CaptionML=ENU=Petty Cash;
                      RunObject=page 20398 }
      { 1000000024;2 ;Action    ;
                      CaptionML=ENU=Posted Petty Cash;
                      RunObject=page 20401 }
      { 1000000013;2 ;Action    ;
                      CaptionML=ENU=Receipts list-BOSA;
                      RunObject=page 17379 }
      { 1000000025;2 ;Action    ;
                      CaptionML=ENU=Posted BOSA Receipts List;
                      RunObject=page 17399 }
      { 1000000020;2 ;Action    ;
                      CaptionML=ENU=ATM Cards Application;
                      RunObject=page 17460 }
      { 1000000026;2 ;Action    ;
                      CaptionML=ENU=Bank Account List;
                      RunObject=Page 371 }
      { 1       ;2   ;Action    ;
                      CaptionML=ENU=GENERAL RECEIPTS;
                      RunObject=page 20410 }
      { 121     ;1   ;ActionGroup;
                      CaptionML=[ENU=Treasury & Teller Mgt;
                                 ESM=Flujo de caja;
                                 FRC=Tr‚sorerie;
                                 ENC=Cash Flow] }
      { 102     ;2   ;Action    ;
                      CaptionML=[ENU=Treasury List;
                                 ESM=Previsiones de flujo de caja;
                                 FRC=Pr‚visions de la tr‚sorerie;
                                 ENC=Cash Flow Forecasts];
                      RunObject=page 17477 }
      { 142     ;2   ;Action    ;
                      CaptionML=[ENU=Teller List;
                                 ESM=Cat logo de cuentas de flujo de caja;
                                 FRC=Plan comptable de tr‚sorerie;
                                 ENC=Chart of Cash Flow Accounts];
                      RunObject=page 17476 }
      { 1000000014;2 ;Action    ;
                      CaptionML=ENU=Teller & Treasury Transactions;
                      RunObject=page 17444 }
      { 1000000023;1 ;ActionGroup;
                      CaptionML=[ENU=Credit Processing;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      Image=FixedAssets }
      { 1000000028;2 ;Action    ;
                      CaptionML=ENU=Fosa Loans;
                      RunObject=page 17457 }
      { 1000000022;2 ;Action    ;
                      CaptionML=[ENU=All Loans;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      RunObject=page 17382 }
      { 1000000021;2 ;Action    ;
                      CaptionML=[ENU=Loans Disbursement Batch;
                                 ESM=Seguros;
                                 FRC=Assurance;
                                 ENC=Insurance];
                      RunObject=page 17393 }
      { 1000000029;2 ;Action    ;
                      CaptionML=ENU=Posted Loans;
                      RunObject=page 17391 }
      { 1000000030;2 ;Action    ;
                      CaptionML=ENU=Posted Batches;
                      RunObject=page 17395 }
      { 84      ;1   ;ActionGroup;
                      CaptionML=[ENU=Cheque Management;
                                 ESM=Contabilidad de costos;
                                 FRC=Comptabilit‚ analytique;
                                 ENC=Cost Accounting] }
      { 77      ;2   ;Action    ;
                      CaptionML=ENU=Banking Cheque Schedule;
                      RunObject=page 17452 }
      { 75      ;2   ;Action    ;
                      CaptionML=ENU=Bankers Cheque Schedule;
                      RunObject=page 17404 }
      { 1000000002;2 ;Action    ;
                      CaptionML=ENU=Bankers Cheque Register;
                      RunObject=page 17453 }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[ENU=Periodic Activities;
                                 ESM=Administraci¢n;
                                 FRC=Administration;
                                 ENC=Administration];
                      Image=Administration }
      { 38      ;2   ;Action    ;
                      CaptionML=[ENU=Standing Orders  List;
                                 ESM=Divisas;
                                 FRC=Devises;
                                 ENC=Currencies];
                      RunObject=page 17445;
                      Image=Currency }
      { 40      ;2   ;Action    ;
                      CaptionML=[ENU=Standing Order Register;
                                 ESM=Periodos contables;
                                 FRC=P‚riodes comptables;
                                 ENC=Accounting Periods];
                      RunObject=page 17446;
                      Image=AccountingPeriods }
      { 41      ;2   ;Action    ;
                      CaptionML=[ENU=Salaries Buffer;
                                 ESM=Serie num‚rica;
                                 FRC=S‚rie de num‚ros;
                                 ENC=Number Series];
                      RunObject=page 17478 }
      { 43      ;2   ;Action    ;
                      CaptionML=[ENU=Deposits Tier Setup;
                                 ESM=Vistas an lisis;
                                 FRC=Vues d'analyse;
                                 ENC=Analysis Views];
                      RunObject=page 17412 }
      { 1400009 ;1   ;ActionGroup;
                      CaptionML=[ENU=FOSA Setups;
                                 ESM=Tesorer¡a;
                                 FRC=Gestion de tr‚sorerie;
                                 ENC=Cash Management] }
      { 1400017 ;2   ;Action    ;
                      CaptionML=[ENU=Account Types List;
                                 ESM=Bancos;
                                 FRC=Comptes bancaires;
                                 ENC=Bank Accounts];
                      RunObject=page 17462;
                      Image=BankAccount }
      { 1400018 ;2   ;Action    ;
                      CaptionML=[ENU=FOSA Charges;
                                 ESM=Dep¢sito;
                                 FRC=D‚p“t;
                                 ENC=Deposit];
                      RunObject=page 17482;
                      Image=DepositSlip }
      { 1400019 ;2   ;Action    ;
                      CaptionML=[ENU=Transaction Type  List;
                                 ESM=Conc. &banco;
                                 FRC=Rapprochement bancaire;
                                 ENC=Bank Rec.];
                      RunObject=page 17471 }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=Supervisor Approvals Levels;
                      RunObject=page 17467 }
      { 1000000006;2 ;Action    ;
                      CaptionML=ENU=ATM Charges;
                      RunObject=page 17468 }
      { 1000000007;2 ;Action    ;
                      CaptionML=ENU=Status Change Permisions;
                      RunObject=page 17473 }
      { 1000000016;2 ;Action    ;
                      CaptionML=ENU=Account Details-editable;
                      RunObject=page 50010 }
      { 1000000017;2 ;Action    ;
                      CaptionML=ENU=User Branch Set Up;
                      RunObject=page 17483 }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1000000018;1;Part   ;
                CaptionML=ENU=FOSA Account Holders;
                PagePartID=Page51516295;
                PartType=Page }

    { 1000000015;1;Group  ;
                GroupType=Group }

    { 1000000001;1;Part   ;
                PagePartID=Page9175;
                PartType=Page }

    { 1000000000;1;Part   ;
                PartType=System;
                SystemPartID=MyNotes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

