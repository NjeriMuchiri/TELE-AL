OBJECT page 20438 Purchase Order (Pending)
{
  OBJECT-PROPERTIES
  {
    Date=04/07/16;
    Time=[ 8:37:48 PM];
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[ENU=Purchase Orders;
               ESM=Pedidos compra;
               FRC=Bons de commande;
               ENC=Purchase Orders];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=CONST(Order),
                          Status=CONST(Pending Approval));
    PageType=List;
    CardPageID=Purchase Order;
    OnOpenPage=VAR
                 PurchasesPayablesSetup@1000 : Record 312;
               BEGIN
                 SetSecurityFilterOnRespCenter;

                 JobQueueActive := PurchasesPayablesSetup.JobQueueActive;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601026;1 ;ActionGroup;
                      CaptionML=[ENU=O&rder;
                                 ESM=Pedid&o;
                                 FRC=Co&mmande;
                                 ENC=O&rder];
                      Image=Order }
      { 1102601035;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[ENU=Dimensions;
                                 ESM=Dimensiones;
                                 FRC=Dimensions;
                                 ENC=Dimensions];
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601028;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[ENU=Statistics;
                                 ESM=Estad¡sticas;
                                 FRC=Statistiques;
                                 ENC=Statistics];
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenPurchaseOrderStatistics;
                               END;
                                }
      { 18      ;2   ;Action    ;
                      CaptionML=[ENU=Approvals;
                                 ESM=Aprobaciones;
                                 FRC=Approbations;
                                 ENC=Approvals];
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalEntries@1001 : Page 658;
                               BEGIN
                                 ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102601030;2 ;Action    ;
                      CaptionML=[ENU=Co&mments;
                                 ESM=Co&mentarios;
                                 FRC=Co&mmentaires;
                                 ENC=Co&mments];
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[ENU=Documents;
                                 ESM=Documentos;
                                 FRC=Documents;
                                 ENC=Documents];
                      Image=Documents }
      { 1102601031;2 ;Action    ;
                      CaptionML=[ENU=Receipts;
                                 ESM=Recepciones;
                                 FRC=Re‡us;
                                 ENC=Receipts];
                      RunObject=Page 145;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=PostedReceipts }
      { 1102601032;2 ;Action    ;
                      CaptionML=[ENU=Invoices;
                                 ESM=Facturas;
                                 FRC=Factures;
                                 ENC=Invoices];
                      RunObject=Page 146;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=Invoice }
      { 1102601033;2 ;Action    ;
                      CaptionML=[ENU=Prepa&yment Invoices;
                                 ESM=&Facturas anticipo;
                                 FRC=&Factures pour paiement anticip‚;
                                 ENC=Prepa&yment Invoices];
                      RunObject=Page 146;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentInvoice }
      { 1102601034;2 ;Action    ;
                      CaptionML=[ENU=Prepayment Credi&t Memos;
                                 ESM=&Notas cr‚dito anticipo;
                                 FRC=Notes de cr‚di&t pour paiement anticip‚;
                                 ENC=Prepayment Credi&t Memos];
                      RunObject=Page 147;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentCreditMemo }
      { 1102601037;2 ;Separator  }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[ENU=Warehouse;
                                 ESM=Almac‚n;
                                 FRC=Entrep“t;
                                 ENC=Warehouse];
                      Image=Warehouse }
      { 1102601039;2 ;Action    ;
                      CaptionML=[ENU=In&vt. Put-away/Pick Lines;
                                 ESM=L¡neas ubicac./ pic&k exist.;
                                 FRC=Lignes d'articles en stoc&k … classer/pr‚lever;
                                 ENC=In&vt. Put-away/Pick Lines];
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Purchase Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 1102601038;2 ;Action    ;
                      CaptionML=[ENU=Whse. Receipt Lines;
                                 ESM=L¡neas recep. alm.;
                                 FRC=Lignes r‚ception entrep“t;
                                 ENC=Whse. Receipt Lines];
                      RunObject=Page 7342;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(39),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ReceiptLines }
      { 1102601040;2 ;Separator  }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[ENU=General;
                                 ESM=General;
                                 FRC=G‚n‚ral;
                                 ENC=General];
                      Image=Print }
      { 55      ;2   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[ENU=&Print;
                                 ESM=&Imprimir;
                                 FRC=&Imprimer;
                                 ENC=&Print];
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DocPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[ENU=Release;
                                 ESM=Lanzar;
                                 FRC=Lib‚rer;
                                 ENC=Release];
                      Image=ReleaseDoc }
      { 1102601021;2 ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[ENU=Re&lease;
                                 ESM=Lan&zar;
                                 FRC=&Lib‚rer;
                                 ENC=Re&lease];
                      Visible=FALSE;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601022;2 ;Action    ;
                      Name=Reopen;
                      CaptionML=[ENU=Re&open;
                                 ESM=&Volver a abrir;
                                 FRC=R‚&ouvrir;
                                 ENC=Re&open];
                      Visible=FALSE;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601023;2 ;Separator  }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[ENU=F&unctions;
                                 ESM=Acci&ones;
                                 FRC=F&onctions;
                                 ENC=F&unctions];
                      Image=Action }
      { 1102601025;2 ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[ENU=Send IC Purchase Order;
                                 ESM=Env. ped. compra IC;
                                 FRC=Envoyer bon de commande IC;
                                 ENC=Send IC Purchase Order];
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInOutboxMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   ICInOutboxMgt.SendPurchDoc(Rec,FALSE);
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[ENU=Request Approval;
                                 ESM=Aprobaci¢n solic.;
                                 FRC=Approbation de demande;
                                 ENC=Request Approval] }
      { 1102601018;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[ENU=Send A&pproval Request;
                                 ESM=Enviar solicitud a&probaci¢n;
                                 FRC=Envoyer demande d'a&pprobation;
                                 ENC=Send A&pproval Request];
                      Enabled=NOT OpenApprovalEntriesExist;
                      Image=SendApprovalRequest;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 1102601019;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[ENU=Cancel Approval Re&quest;
                                 ESM=&Cancelar solicitud aprobaci¢n;
                                 FRC=Annuler demande d'appro&bation;
                                 ENC=Cancel Approval Re&quest];
                      Enabled=OpenApprovalEntriesExist;
                      Image=Cancel;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                               END;
                                }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[ENU=Warehouse;
                                 ESM=Almac‚n;
                                 FRC=Entrep“t;
                                 ENC=Warehouse];
                      Image=Warehouse }
      { 1102601015;2 ;Action    ;
                      AccessByPermission=TableData 7316=R;
                      CaptionML=[ENU=Create &Whse. Receipt;
                                 ESM=Crear &recep. almac‚n;
                                 FRC=Cr‚er un re‡u d'&entrep“t;
                                 ENC=Create &Whse. Receipt];
                      Image=NewReceipt;
                      OnAction=VAR
                                 GetSourceDocInbound@1001 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.CreateFromPurchOrder(Rec);

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 1102601016;2 ;Action    ;
                      AccessByPermission=TableData 7340=R;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Create Inventor&y Put-away/Pick;
                                 ESM=Crear &ubicac./ pick. inventario;
                                 FRC=Cr‚er une r‚servation/sortie de stoc&k;
                                 ENC=Create Inventor&y Put-away/Pick];
                      Image=CreatePutawayPick;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 1102601017;2 ;Separator  }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[ENU=P&osting;
                                 ESM=R&egistro;
                                 FRC=Rep&ort;
                                 ENC=P&osting];
                      Image=Post }
      { 51      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Test Report;
                                 ESM=Informe prueba;
                                 FRC=Tester le report;
                                 ENC=Test Report];
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 52      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[ENU=P&ost;
                                 ESM=R&egistrar;
                                 FRC=Rep&orter;
                                 ENC=P&ost];
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SendToPosting(CODEUNIT::"Purch.-Post (Yes/No)");
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[ENU=Preview Posting;
                                 ESM=Vista previa de registro;
                                 FRC=Aper‡u compta.;
                                 ENC=Preview Posting];
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PurchPostYesNo@1001 : Codeunit 91;
                               BEGIN
                                 PurchPostYesNo.Preview(Rec);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Post and &Print;
                                 ESM=Registrar e &imprimir;
                                 FRC=Reporter et im&primer;
                                 ENC=Post and &Print];
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SendToPosting(CODEUNIT::"Purch.-Post + Print");
                               END;
                                }
      { 54      ;2   ;Action    ;
                      Name=PostBatch;
                      Ellipsis=Yes;
                      CaptionML=[ENU=Post &Batch;
                                 ESM=Registrar por &lotes;
                                 FRC=Reporter &lot;
                                 ENC=Post &Batch];
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Purchase Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=RemoveFromJobQueue;
                      CaptionML=[ENU=Remove From Job Queue;
                                 ESM=Quitar de cola de proyecto;
                                 FRC=Supprimer de la file d'attente des travaux;
                                 ENC=Remove From Job Queue];
                      Visible=JobQueueActive;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr="Buy-from Vendor No." }

    { 13  ;2   ;Field     ;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr="Buy-from Vendor Name" }

    { 15  ;2   ;Field     ;
                SourceExpr="Vendor Authorization No." }

    { 27  ;2   ;Field     ;
                SourceExpr="Buy-from Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                SourceExpr="Buy-from Country/Region Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                SourceExpr="Buy-from Contact";
                Visible=FALSE }

    { 163 ;2   ;Field     ;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 161 ;2   ;Field     ;
                SourceExpr="Pay-to Name";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                SourceExpr="Pay-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                SourceExpr="Pay-to Country/Region Code";
                Visible=FALSE }

    { 151 ;2   ;Field     ;
                SourceExpr="Pay-to Contact";
                Visible=FALSE }

    { 147 ;2   ;Field     ;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 145 ;2   ;Field     ;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 135 ;2   ;Field     ;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 131 ;2   ;Field     ;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 113 ;2   ;Field     ;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE;
                OnLookup=BEGIN
                           DimMgt.LookupDimValueCodeNoUpdate(1);
                         END;
                          }

    { 111 ;2   ;Field     ;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE;
                OnLookup=BEGIN
                           DimMgt.LookupDimValueCodeNoUpdate(2);
                         END;
                          }

    { 115 ;2   ;Field     ;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 99  ;2   ;Field     ;
                SourceExpr="Purchaser Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102601001;2;Field  ;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601003;2;Field  ;
                SourceExpr=Status;
                Visible=FALSE }

    { 1102601005;2;Field  ;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                SourceExpr="Payment Method Code";
                Visible=FALSE }

    { 1102601013;2;Field  ;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 1102601027;2;Field  ;
                SourceExpr="Requested Receipt Date";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="Job Queue Status";
                Visible=JobQueueActive }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 14  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                PagePartID=Page193;
                Visible=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 1901138007;1;Part   ;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9093;
                Visible=TRUE;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;
      ReportPrint@1102601001 : Codeunit 228;
      DocPrint@1102601000 : Codeunit 229;
      JobQueueActive@1003 : Boolean INDATASET;
      OpenApprovalEntriesExist@1002 : Boolean;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    END;

    BEGIN
    END.
  }
}

