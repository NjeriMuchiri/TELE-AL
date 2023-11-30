OBJECT page 172010 Credit Role Center
{
  OBJECT-PROPERTIES
  {
    Date=10/29/19;
    Time=[ 4:21:52 PM];
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
                      CaptionML=[ENU=Members Account List;
                                 ESM=Balance comprobaci¢n con&tabilidad;
                                 FRC=Balance de v‚rification du &GL;
                                 ENC=&G/L Trial Balance];
                      RunObject=Report 51516220;
                      Image=Report }
      { 1480103 ;1   ;Action    ;
                      CaptionML=[ENU=Member Balances;
                                 ESM=Cat logo de cuentas;
                                 FRC=Plan comptable;
                                 ENC=Chart of Accounts];
                      RunObject=Report 51516222;
                      Image=Report }
      { 33      ;1   ;Action    ;
                      CaptionML=[ENU=Member Staement;
                                 ESM=&Balance comprobaci¢n detalles bancarios;
                                 FRC=&Balance de v‚rification bancaire d‚taill‚e;
                                 ENC=&Bank Detail Trial Balance];
                      RunObject=Report 51516223;
                      Image=Report }
      { 1480105 ;1   ;Action    ;
                      CaptionML=[ENU=Member Guarantors;
                                 ESM=Plantilla Estructura de Cuentas;
                                 FRC=Disposition de tableau d'analyse;
                                 ENC=Account Schedule Layout];
                      RunObject=Report 51516225;
                      Image=Report }
      { 1000000016;1 ;Action    ;
                      CaptionML=ENU=Credit Loans Register;
                      RunObject=Report 51516267 }
      { 34      ;1   ;Action    ;
                      CaptionML=[ENU=Members Loan Register;
                                 ESM=Estr&uctura de Cuentas;
                                 FRC=Tablea&u d'analyse;
                                 ENC=&Account Schedule];
                      RunObject=Report 51516227;
                      Image=Report }
      { 1480106 ;1   ;Action    ;
                      CaptionML=[ENU=Loan Aging Interest;
                                 ESM=Contrapartidas por c¢d. GIFI;
                                 FRC=Solde des comptes par code IGRF;
                                 ENC=Account Balances by GIFI Code];
                      RunObject=Report 51516228;
                      Image=Report }
      { 35      ;1   ;Action    ;
                      CaptionML=[ENU=Loans Guaranteed;
                                 ESM=Presupuesto;
                                 FRC=Budget;
                                 ENC=Budget];
                      RunObject=Report 51516226;
                      Image=Report }
      { 36      ;1   ;Action    ;
                      CaptionML=[ENU=Loans Potfolio Analysis;
                                 ESM=Balance s&umas y saldos/Ppto.;
                                 FRC=Bala&nce de v‚rification/budget;
                                 ENC=Trial Bala&nce/Budget];
                      RunObject=Report 51516230;
                      Image=Report }
      { 1480007 ;1   ;Action    ;
                      CaptionML=[ENU=Loans Repayment Schedule;
                                 ESM=Balance comprobaci¢n, por Dim. global;
                                 FRC=Balance de v‚rification, par dimension globale;
                                 ENC=Trial Balance, per Global Dim.];
                      RunObject=Report 51516231;
                      Image=Report }
      { 1480008 ;1   ;Action    ;
                      CaptionML=[ENU=Loans Batch Schedule;
                                 ESM=Balance comprob., dimen. global extendida;
                                 FRC=Balance v‚rif., dim. globale ‚tendue;
                                 ENC=Trial Balance, Spread G. Dim.];
                      RunObject=Report 51516232;
                      Image=Report }
      { 1020001 ;1   ;Action    ;
                      CaptionML=[ENU=Loans Appraisal;
                                 ESM=Balance compr./resumen;
                                 FRC=Balance v‚rif. d‚tail/sommaire;
                                 ENC=Trial Balance Detail/Summary];
                      RunObject=Report 51516244;
                      Image=Report }
      { 46      ;1   ;Action    ;
                      CaptionML=[ENU=Loans Underpaid/Overpaid;
                                 ESM=Saldo del e&jercicio;
                                 FRC=Solde exercice &financier;
                                 ENC=&Fiscal Year Balance];
                      RunObject=Report 51516253;
                      Image=Report }
      { 47      ;1   ;Action    ;
                      CaptionML=[ENU=Loan Balances;
                                 ESM=Comp. de saldo - A¤o a&nterior;
                                 FRC=Comparaison solde - exercice ant‚ri&eur;
                                 ENC=Balance Comp. - Pr&ev. Year];
                      RunObject=Report 51516255;
                      Image=Report }
      { 48      ;1   ;Action    ;
                      CaptionML=[ENU=Loans Defaulter Aging;
                                 ESM=Cierr&e del balance de comprobaci¢n;
                                 FRC=Balan&ce de v‚rification de fermeture;
                                 ENC=&Closing Trial Balance];
                      RunObject=Report 51516256;
                      Image=Report }
      { 1020000 ;1   ;Action    ;
                      CaptionML=[ENU=Loan Guard;
                                 ESM=Balance comprobaci¢n consol.;
                                 FRC=Balance de v‚rification consol.;
                                 ENC=Consol. Trial Balance];
                      RunObject=Report 51516257;
                      Image=Report }
      { 49      ;1   ;Action    ;
                      CaptionML=ENU=Loans Defaulters;
                      RunObject=Report 51516254 }
      { 104     ;1   ;Action    ;
                      CaptionML=[ENU=Membership Closure;
                                 ESM=Lista fechas flujo efectivo;
                                 FRC=Liste date tr‚sorerie;
                                 ENC=Cash Flow Date List];
                      RunObject=Report 51516258;
                      Image=Report }
      { 1120054000;1 ;Action    ;
                      CaptionML=[ENU=Loans Disbursed - Per Product;
                                 ESM=Lista fechas flujo efectivo;
                                 FRC=Liste date tr‚sorerie;
                                 ENC=Cash Flow Date List];
                      RunObject=Report 51516621;
                      Image=Report }
      { 1000000009;1 ;Separator ;
                      CaptionML=ENU=Dividends }
      { 50      ;1   ;Action    ;
                      CaptionML=[ENU=Prorated Dividends Processing;
                                 ESM=&Antigedad cobros;
                                 FRC=Comptes clients class‚s ch&ronologiquement;
                                 ENC=Aged Accounts &Receivable];
                      RunObject=Report 51516238;
                      Image=Report }
      { 51      ;1   ;Action    ;
                      CaptionML=[ENU=Flat Rate Dividends Processing;
                                 ESM=Antigedad pa&gos;
                                 FRC=C&omptes fournisseurs class‚s chronologiquement;
                                 ENC=Aged Accounts Pa&yable];
                      RunObject=Report 51516239;
                      Image=Report }
      { 1000000014;1 ;Action    ;
                      CaptionML=[ENU=Dividends Register;
                                 ESM=&Antigedad cobros;
                                 FRC=Comptes clients class‚s ch&ronologiquement;
                                 ENC=Aged Accounts &Receivable];
                      RunObject=Report 51516240;
                      Image=Report }
      { 1000000013;1 ;Action    ;
                      CaptionML=[ENU=Dividends Progression;
                                 ESM=Antigedad pa&gos;
                                 FRC=C&omptes fournisseurs class‚s chronologiquement;
                                 ENC=Aged Accounts Pa&yable];
                      RunObject=Report 51516241;
                      Image=Report }
      { 1000000019;1 ;Separator  }
      { 1000000020;1 ;Action    ;
                      CaptionML=ENU=Checkoff Main;
                      RunObject=Report 51516297 }
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
                      CaptionML=[ENU=Members;
                                 ESM=Diarios;
                                 FRC=Journaux;
                                 ENC=Journals];
                      Image=Journals }
      { 1000000011;2 ;Action    ;
                      CaptionML=ENU=Member List;
                      RunObject=page 17364 }
      { 1000000010;2 ;Action    ;
                      CaptionML=[ENU=Member List Editable;
                                 ESM=Diarios de ventas;
                                 FRC=Journaux de ventes;
                                 ENC=Sales Journals];
                      RunObject=page 17374 }
      { 107     ;1   ;ActionGroup;
                      CaptionML=[ENU=Loans;
                                 ESM=Diarios;
                                 FRC=Journaux;
                                 ENC=Journals];
                      Image=Journals }
      { 117     ;2   ;Action    ;
                      CaptionML=ENU=Open Loans;
                      RunObject=page 17382;
                      RunPageView=WHERE(Approval Status=CONST(Open)) }
      { 118     ;2   ;Action    ;
                      CaptionML=[ENU=Pending Loans;
                                 ESM=Diarios de ventas;
                                 FRC=Journaux de ventes;
                                 ENC=Sales Journals];
                      RunObject=page 17382;
                      RunPageView=WHERE(Approval Status=CONST(Pending)) }
      { 113     ;2   ;Action    ;
                      CaptionML=[ENU=Approved Loans;
                                 ESM=Diarios de recibos de efectivo;
                                 FRC=Journaux des encaissements;
                                 ENC=Cash Receipt Journals];
                      RunObject=page 17382;
                      RunPageView=WHERE(Approval Status=CONST(Approved));
                      Image=Journals }
      { 114     ;2   ;Action    ;
                      CaptionML=[ENU=Issued Loans;
                                 ESM=Diarios de pagos;
                                 FRC=Journaux des paiements;
                                 ENC=Payment Journals];
                      RunObject=page 17391;
                      Image=Journals }
      { 1102601000;2 ;Action    ;
                      CaptionML=[ENU=Rejected Loans;
                                 ESM=Diarios generales IC;
                                 FRC=Journaux g‚n‚raux IC;
                                 ENC=IC General Journals];
                      RunObject=page 17382;
                      RunPageView=WHERE(Approval Status=CONST(Open)) }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[ENU=Credit Processing;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      Image=FixedAssets }
      { 17      ;2   ;Action    ;
                      CaptionML=[ENU=Credit Application Master - Bosa;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      RunObject=page 17382 }
      { 1120054001;2 ;Action    ;
                      CaptionML=[ENU=Loans Appraisal - Bosa;
                                 ESM=Activos fijos;
                                 FRC=Immobilisations;
                                 ENC=Fixed Assets];
                      RunObject=page 50027 }
      { 18      ;2   ;Action    ;
                      CaptionML=[ENU=Loans Application - Fosa;
                                 ESM=Seguros;
                                 FRC=Assurance;
                                 ENC=Insurance];
                      RunObject=page 17457 }
      { 1120054002;2 ;Action    ;
                      CaptionML=[ENU=Loans Appraisal - Fosa;
                                 ESM=Seguros;
                                 FRC=Assurance;
                                 ENC=Insurance];
                      RunObject=page 50031 }
      { 121     ;1   ;ActionGroup;
                      CaptionML=[ENU=Processed Credits;
                                 ESM=Flujo de caja;
                                 FRC=Tr‚sorerie;
                                 ENC=Cash Flow] }
      { 102     ;2   ;Action    ;
                      CaptionML=[ENU=Posted Credit List;
                                 ESM=Previsiones de flujo de caja;
                                 FRC=Pr‚visions de la tr‚sorerie;
                                 ENC=Cash Flow Forecasts];
                      RunObject=page 17391 }
      { 142     ;2   ;Action    ;
                      CaptionML=[ENU=Posted Loan Batch;
                                 ESM=Cat logo de cuentas de flujo de caja;
                                 FRC=Plan comptable de tr‚sorerie;
                                 ENC=Chart of Cash Flow Accounts];
                      RunObject=page 17395 }
      { 84      ;1   ;ActionGroup;
                      CaptionML=[ENU=Member Withdrawal;
                                 ESM=Contabilidad de costos;
                                 FRC=Comptabilit‚ analytique;
                                 ENC=Cost Accounting] }
      { 77      ;2   ;Action    ;
                      CaptionML=ENU=Withdrawal Registration List;
                      RunObject=page 50062 }
      { 75      ;2   ;Action    ;
                      CaptionML=ENU=Membership Withdrawal List;
                      RunObject=page 17406 }
      { 1000000002;2 ;Action    ;
                      CaptionML=ENU=Member WithdrawalList-Approved;
                      RunObject=page 50045 }
      { 1000000003;2 ;Action    ;
                      CaptionML=ENU=Member Withdrawal Batch List;
                      RunObject=page 50041 }
      { 1000000004;2 ;Action    ;
                      CaptionML=ENU=Posted Member Withdrawal List;
                      RunObject=page 17424 }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=Member WithBatch List posted;
                      RunObject=page 50043 }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[ENU=Setup;
                                 ESM=Administraci¢n;
                                 FRC=Administration;
                                 ENC=Administration];
                      Image=Administration }
      { 38      ;2   ;Action    ;
                      CaptionML=[ENU=Sacco General Setup;
                                 ESM=Divisas;
                                 FRC=Devises;
                                 ENC=Currencies];
                      Image=Currency }
      { 40      ;2   ;Action    ;
                      CaptionML=[ENU=Loans Products Setup;
                                 ESM=Periodos contables;
                                 FRC=P‚riodes comptables;
                                 ENC=Accounting Periods];
                      RunObject=page 17408;
                      Image=AccountingPeriods }
      { 41      ;2   ;Action    ;
                      CaptionML=[ENU=Interest Due Periods;
                                 ESM=Serie num‚rica;
                                 FRC=S‚rie de num‚ros;
                                 ENC=Number Series];
                      RunObject=page 17410 }
      { 43      ;2   ;Action    ;
                      CaptionML=[ENU=Deposits Tier Setup;
                                 ESM=Vistas an lisis;
                                 FRC=Vues d'analyse;
                                 ENC=Analysis Views];
                      RunObject=page 17412 }
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
      { 95      ;1   ;Action    ;
                      CaptionML=[ENU=Sacco No Series;
                                 ESM=Diario &pagos;
                                 FRC=Journal des pa&iements;
                                 ENC=Pa&yment Journal];
                      RunObject=page 17411;
                      Image=Setup }
      { 110     ;1   ;Action    ;
                      CaptionML=[ENU=Import Members;
                                 ESM=Vistas &an lisis;
                                 FRC=&Vues d'analyse;
                                 ENC=Analysis &Views];
                      RunObject=XMLport 51516004;
                      Image=Import }
      { 98      ;1   ;Action    ;
                      CaptionML=[ENU=Import FOSA Accounts;
                                 ESM=An lisis por dim&ensiones;
                                 FRC=Anal&yse par dimensions;
                                 ENC=Analysis by &Dimensions];
                      RunObject=XMLport 51516005;
                      Image=Import }
      { 68      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Import Checkoff Distributed;
                                 ESM=Calcular amort&izaci¢n;
                                 FRC=Calculer l'amortisseme&nt;
                                 ENC=Calculate Deprec&iation];
                      RunObject=XMLport 51516003;
                      Image=Import }
      { 1000000008;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Import Checkoff Block;
                                 ESM=Calcular amort&izaci¢n;
                                 FRC=Calculer l'amortisseme&nt;
                                 ENC=Calculate Deprec&iation];
                      RunObject=XMLport 51516002;
                      Image=Import }
      { 69      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Import Salaries;
                                 ESM=Importar c&onsolidaci¢n de base de datos;
                                 FRC=Importer la consolidation de la &base de donn‚es;
                                 ENC=Import Co&nsolidation from Database];
                      RunObject=XMLport 51516009;
                      Image=Import }
      { 1000000021;1 ;Action    ;
                      CaptionML=ENU=Sacco General Setup;
                      RunObject=page 17409 }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1000000018;1;Part   ;
                PagePartID=Page51516480;
                PartType=Page }

    { 1000000017;1;Part   ;
                PagePartID=Page51516479;
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

