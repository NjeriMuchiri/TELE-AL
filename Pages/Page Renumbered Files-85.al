OBJECT page 20426 Purchase Requisition Card
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=12:41:04 PM;
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    CaptionML=ENU=Task Order Card;
    DeleteAllowed=No;
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=CONST(Quote),
                          DocApprovalType=CONST(Requisition),
                          Status=FILTER(Open|Released|Pending Approval));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN

                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   FILTERGROUP(0);
                 END;
                 "Doc Type":="Doc Type"::PurchReq;
               END;

    OnNextRecord=BEGIN
                   UpdateControls;
                 END;

    OnAfterGetRecord=BEGIN
                       CurrPageUpdate;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetPurchasesFilter;
                  "Assigned User ID":=USERID;
                  PR:=TRUE;

                  Vendor.RESET;
                  Vendor.SETRANGE(Vendor."No.",'SUPP_0000');
                  IF Vendor.FINDFIRST THEN BEGIN
                    "Buy-from Vendor No.":= Vendor."No.";
                    VALIDATE("Buy-from Vendor No.");
                  END
                END;

    OnInsertRecord=BEGIN
                     DocApprovalType:=DocApprovalType::Requisition;
                   END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(ConfirmDeletion);
                      ERROR ('Not Allowed!');
                   END;

    OnAfterGetCurrRecord=BEGIN
                              UpdateControls;
                           {PurchHeader.RESET;
                           PurchHeader.SETRANGE("User ID",USERID);
                           PurchHeader.SETRANGE(PurchHeader.Status,PurchHeader.Status::Open);
                           //PurchHeader.SETRANGE(SHeader."Request date",TODAY);
                            IF PurchHeader.COUNT>1 THEN
                              ERROR('You have unused requisition records under your account,Please utilize/release them for approval'+
                                ' before creating a new record');
                              }
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 59      ;1   ;ActionGroup;
                      CaptionML=ENU=&Quote;
                      Image=Quote }
      { 61      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=ENU=Statistics;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Purchase Statistics",Rec);
                               END;
                                }
      { 62      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=ENU=Vendor;
                      RunObject=20373;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Image=Vendor }
      { 63      ;2   ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 111     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 152     ;2   ;Action    ;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1001 : Page 658;
                               BEGIN
                                 ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 70      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=&Print;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 //IF LinesCommitted THEN
                                    //ERROR('All Lines should be committed');
                                   RESET;
                                   SETRANGE("No.","No.");
                                   REPORT.RUN(51516004,TRUE,TRUE,Rec);
                                   RESET;
                                 //DocPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=ENU=Release;
                      Image=ReleaseDoc }
      { 148     ;2   ;Separator  }
      { 118     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=ENU=Re&lease;
                      Visible=false;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Name=Award Schedule;
                      RunObject=Page 55947 }
      { 119     ;2   ;Action    ;
                      CaptionML=ENU=Re&open;
                      Visible=false;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 64      ;1   ;ActionGroup;
                      CaptionML=ENU=F&unctions;
                      Image=Action }
      { 65      ;2   ;Action    ;
                      CaptionML=ENU=Calculate &Invoice Discount;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                               END;
                                }
      { 144     ;2   ;Separator  }
      { 143     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Get St&d. Vend. Purchase Codes;
                      Image=VendorCode;
                      OnAction=VAR
                                 StdVendPurchCode@1000 : Record 175;
                               BEGIN
                                 StdVendPurchCode.InsertPurchLines(Rec);
                               END;
                                }
      { 146     ;2   ;Separator  }
      { 66      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=ENU=Copy Document;
                      Promoted=Yes;
                      Image=CopyDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CopyPurchDoc.SetPurchHeader(Rec);
                                 CopyPurchDoc.RUNMODAL;
                                 CLEAR(CopyPurchDoc);
                               END;
                                }
      { 138     ;2   ;Action    ;
                      Name=Archive Document;
                      CaptionML=ENU=Archi&ve Document;
                      Image=Archive;
                      OnAction=BEGIN
                                 ArchiveManagement.ArchivePurchDocument(Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 147     ;2   ;Separator  }
      { 153     ;2   ;Action    ;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN



                                 //IF  LinesCommitted THEN
                                    //ERROR('Check Budget Availability Before Sending for Approval.');

                                 TESTFIELD(Status,Status::Open);
                                 IF (ApprovalsMgmt.CheckPurchaseRequisitionApprovalsWorkflowEnabled(Rec)) THEN
                                   ApprovalsMgmt.OnSendPurchaseRequisitionForApproval(Rec);
                               END;
                                }
      { 30      ;2   ;Action    ;
                      CaptionML=ENU=Approvals;
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
      { 154     ;2   ;Action    ;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1001 : Codeunit 439;
                               BEGIN
                                 TESTFIELD(Status,Status::"Pending Approval");
                                 IF ApprovalMgt.CancelPurchaseApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 10      ;2   ;Separator  }
      { 11      ;2   ;Action    ;
                      Name=Check Budget Availability;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Balance;
                      PromotedCategory=Category5;
                      OnAction=BEGIN

                                 BCSetup.GET;
                                 IF NOT BCSetup.Mandatory THEN
                                    EXIT;

                                 IF Status=Status::Released THEN
                                   ERROR('This document has already been released. This functionality is available for open documents only');
                                 IF SomeLinesCommitted THEN BEGIN
                                    IF NOT CONFIRM( 'Some or All the Lines Are already Committed do you want to continue',TRUE, "Document Type") THEN
                                         ERROR('Budget Availability Check and Commitment Aborted');
                                   DeleteCommitment.RESET;
                                   DeleteCommitment.SETRANGE(DeleteCommitment."Document Type",DeleteCommitment."Document Type"::Requisition);
                                   DeleteCommitment.SETRANGE(DeleteCommitment."Document No.","No.");
                                   DeleteCommitment.DELETEALL;
                                 END;


                                    Commitment.CommitPurchase(Rec);
                                    MESSAGE('Budget Availability Checking Complete');
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Cancel Budget Commitment;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CancelAllLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN

                                    IF NOT CONFIRM( 'Are you sure you want to Cancel All Commitments Done for this document',TRUE, "Document Type") THEN
                                         ERROR('Budget Availability Check and Commitment Aborted');

                                   DeleteCommitment.RESET;
                                   DeleteCommitment.SETRANGE(DeleteCommitment."Document Type",DeleteCommitment."Document Type"::Requisition);
                                   DeleteCommitment.SETRANGE(DeleteCommitment."Document No.","No.");
                                   DeleteCommitment.DELETEALL;
                                   //Tag all the Purchase Line entries as Uncommitted
                                   PurchLine.RESET;
                                   PurchLine.SETRANGE(PurchLine."Document Type","Document Type");
                                   PurchLine.SETRANGE(PurchLine."Document No.","No.");
                                   IF PurchLine.FIND('-') THEN BEGIN
                                      REPEAT
                                         PurchLine.Committed:=FALSE;
                                         PurchLine.MODIFY;
                                      UNTIL PurchLine.NEXT=0;
                                   END;

                                 MESSAGE('Commitments Cancelled Successfully for Doc. No %1',"No.");
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=ENU=Make Order;
                      Image=MakeOrder }
      { 69      ;2   ;Action    ;
                      Name=Make Order;
                      CaptionML=ENU=Make &Order;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SalesHeader@1000 : Record 36;
                                 ApprovalMgt@1001 : Codeunit 439;
                               BEGIN
                                 IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
                                   CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order (Yes/No)",Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;;Container;
                Name=S;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=ENU=General;
                Editable=statuseditable }

    { 2   ;2   ;Field     ;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=False;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 26  ;2   ;Field     ;
                SourceExpr="Received from (CLient)";
                Visible=False }

    { 16  ;2   ;Field     ;
                SourceExpr="Buy-from Vendor No.";
                Visible=true;
                Editable=true }

    { 110 ;2   ;Field     ;
                SourceExpr="Requested Receipt Date" }

    { 113 ;2   ;Field     ;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 4   ;2   ;Field     ;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 6   ;2   ;Field     ;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 8   ;2   ;Field     ;
                SourceExpr="Posting Description";
                Editable=FALSE }

    { 136 ;2   ;Field     ;
                SourceExpr="No. of Archived Versions";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                SourceExpr="Order Date";
                Importance=Promoted }

    { 19  ;2   ;Field     ;
                SourceExpr="Document Date" }

    { 14  ;2   ;Field     ;
                SourceExpr="Responsible Officer";
                Editable=false }

    { 9   ;2   ;Field     ;
                SourceExpr="Procurement Type Code";
                Visible=True;
                Editable=True }

    { 68  ;2   ;Field     ;
                SourceExpr="Assigned User ID";
                Importance=Additional;
                Editable=false }

    { 28  ;2   ;Field     ;
                SourceExpr="Document Type";
                Visible=false;
                Editable=true }

    { 107 ;2   ;Field     ;
                OptionCaptionML=ENU=Open,Released,Pending Approval;
                SourceExpr=Status;
                Importance=Promoted }

    { 27  ;2   ;Field     ;
                SourceExpr=Narration }

    { 29  ;2   ;Field     ;
                SourceExpr=Completed;
                Visible=True }

    { 58  ;1   ;Part      ;
                Name=PurchLines;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page97;
                Editable=statuseditable }

    { 1907468901;1;Group  ;
                CaptionML=ENU=Foreign Trade }

    { 102 ;2   ;Field     ;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrencyCodeOnAfterValidate;
                           END;

                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 54  ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 98  ;2   ;Field     ;
                SourceExpr="Transaction Specification" }

    { 56  ;2   ;Field     ;
                SourceExpr="Transport Method" }

    { 47  ;2   ;Field     ;
                SourceExpr="Entry Point" }

    { 96  ;2   ;Field     ;
                SourceExpr=Area }

    { 25  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 24  ;1   ;Part      ;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9093;
                Visible=FALSE;
                PartType=Page }

    { 23  ;1   ;Part      ;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9094;
                Visible=TRUE;
                PartType=Page }

    { 22  ;1   ;Part      ;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9095;
                Visible=TRUE;
                PartType=Page }

    { 21  ;1   ;Part      ;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9096;
                Visible=FALSE;
                PartType=Page }

    { 20  ;1   ;Part      ;
                SubPageLink=Table ID=CONST(38),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9092;
                Visible=FALSE;
                PartType=Page }

    { 18  ;1   ;Part      ;
                SubPageLink=Document Type=FIELD(Document Type),
                            No.=FIELD(No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9100;
                ProviderID=58;
                PartType=Page }

    { 17  ;1   ;Part      ;
                Visible=True;
                PartType=System;
                SystemPartID=RecordLinks }

    { 5   ;1   ;Part      ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ChangeExchangeRate@1001 : Page 511;
      CopyPurchDoc@1002 : Report 492;
      DocPrint@1003 : Codeunit 229;
      UserMgt@1004 : Codeunit 5700;
      ArchiveManagement@1005 : Codeunit 5063;
      Commitment@1008 : Codeunit 51516000;
      BCSetup@1007 : Record 51516051;
      DeleteCommitment@1006 : Record 51516050;
      PurchLine@1000 : Record 39;
      StatusEditable@1102755000 : Boolean;
      Vendor@1009 : Record 23;
      PurchHeader@1010 : Record 38;
      Items@1012 : Record 27;
      Group@1013 : Code[20];

    LOCAL PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE BuyfromVendorNoOnAfterValidate@19032492();
    BEGIN
      IF GETFILTER("Buy-from Vendor No.") = xRec."Buy-from Vendor No." THEN
        IF "Buy-from Vendor No." <> xRec."Buy-from Vendor No." THEN
          SETRANGE("Buy-from Vendor No.");
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE PurchaserCodeOnAfterValidate@19046120();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE PaytoVendorNoOnAfterValidate@19048314();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ShortcutDimension1CodeOnAfterV@19029405();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE CurrencyCodeOnAfterValidate@19068298();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    PROCEDURE LinesCommitted@1102755001() Exists : Boolean;
    VAR
      PurchLines@1102755000 : Record 39;
    BEGIN
       IF BCSetup.GET() THEN  BEGIN
          IF NOT BCSetup.Mandatory THEN BEGIN
             Exists:=FALSE;
             EXIT;
          END;
       END ELSE BEGIN
             Exists:=FALSE;
             EXIT;
       END;
      IF BCSetup.GET THEN BEGIN
       Exists:=FALSE;
       PurchLines.RESET;
       PurchLines.SETRANGE(PurchLines."Document Type","Document Type");
       PurchLines.SETRANGE(PurchLines."Document No.","No.");
       PurchLines.SETRANGE(PurchLines.Committed,FALSE);
        IF PurchLines.FIND('-') THEN
           Exists:=TRUE;
      END ELSE
          Exists:=FALSE;
    END;

    PROCEDURE SomeLinesCommitted@1102756000() Exists : Boolean;
    VAR
      PurchLines@1102755000 : Record 39;
    BEGIN
      IF BCSetup.GET THEN BEGIN
       Exists:=FALSE;
       PurchLines.RESET;
       PurchLines.SETRANGE(PurchLines."Document Type","Document Type");
       PurchLines.SETRANGE(PurchLines."Document No.","No.");
       PurchLines.SETRANGE(PurchLines.Committed,TRUE);
        IF PurchLines.FIND('-') THEN
           Exists:=TRUE;
      END ELSE
          Exists:=FALSE;
    END;

    PROCEDURE UpdateControls@1102755002();
    BEGIN
      IF Status=Status::Open THEN
      StatusEditable:=TRUE
      ELSE
      StatusEditable:=FALSE;
    END;

    PROCEDURE CurrPageUpdate@1102755000();
    BEGIN
      xRec:=Rec;
      UpdateControls;
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

