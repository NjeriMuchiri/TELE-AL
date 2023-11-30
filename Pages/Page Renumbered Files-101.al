OBJECT page 20442 Bid Analysis Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 1:22:46 PM];
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516104;
    PageType=Worksheet;
    OnAfterGetRecord=BEGIN
                       Vendor.GET("Vendor No.");
                       VendorName:=Vendor.Name;
                       CalcTotals;
                     END;

    ActionList=ACTIONS
    {
      { 1102755002;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755014;1 ;Action    ;
                      CaptionML=ENU=Get Vendor Quotations;
                      Promoted=Yes;
                      Visible=false;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 GetVendorQuotes;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755012;1;Group  ;
                GroupType=Group }

    { 1102755013;2;Field  ;
                Name=SalesCodeFilterCtrl;
                CaptionML=ENU=Vendor Code Filter;
                SourceExpr=SalesCodeFilter;
                OnValidate=BEGIN
                             SalesCodeFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           VendList@1005 : 20374;
                         BEGIN
                            BEGIN
                              VendList.LOOKUPMODE := TRUE;
                              IF VendList.RUNMODAL = ACTION::LookupOK THEN
                                Text := VendList.GetSelectionFilter
                              ELSE
                               EXIT(FALSE);
                           END;

                           EXIT(TRUE);
                         END;
                          }

    { 1102755016;2;Field  ;
                CaptionML=ENU=Item No.;
                SourceExpr=ItemNoFilter;
                OnValidate=BEGIN
                             ItemNoFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           ItemList@1102755001 : 20377;
                         BEGIN
                           ItemList.LOOKUPMODE := TRUE;
                           IF ItemList.RUNMODAL = ACTION::LookupOK THEN
                             Text := ItemList.GetSelectionFilter
                            ELSE
                             EXIT(FALSE);

                           EXIT(TRUE);
                         END;
                          }

    { 1102755018;2;Field  ;
                Name=Total;
                SourceExpr=Total;
                Editable=false }

    { 1102755001;1;Group  ;
                Name=Group;
                Editable=false;
                GroupType=Repeater }

    { 1102755015;2;Field  ;
                SourceExpr="RFQ No.";
                Visible=false }

    { 1102755003;2;Field  ;
                SourceExpr="RFQ Line No.";
                Visible=false }

    { 1102755004;2;Field  ;
                SourceExpr="Quote No." }

    { 1102755005;2;Field  ;
                SourceExpr="Vendor No." }

    { 1102755017;2;Field  ;
                Name=VendorName;
                CaptionML=ENU=Vendor Name;
                SourceExpr=VendorName }

    { 1102755006;2;Field  ;
                SourceExpr="Item No." }

    { 1102755007;2;Field  ;
                SourceExpr=Description }

    { 1102755008;2;Field  ;
                SourceExpr=Quantity }

    { 1102755009;2;Field  ;
                SourceExpr="Unit Of Measure" }

    { 1102755010;2;Field  ;
                SourceExpr=Amount }

    { 1102755011;2;Field  ;
                SourceExpr="Line Amount" }

  }
  CODE
  {
    VAR
      PurchHeader@1102755000 : Record 38;
      PurchLines@1102755001 : Record 39;
      ItemNoFilter@1102755002 : Text[250];
      RFQNoFilter@1102755003 : Text[250];
      InsertCount@1102755004 : Integer;
      SalesCodeFilter@1102755005 : Text[250];
      VendorName@1102755006 : Text;
      Vendor@1102755007 : Record 23;
      Total@1102755008 : Decimal;

    PROCEDURE SetRecFilters@1();
    BEGIN
      IF SalesCodeFilter <> '' THEN
        SETFILTER("Vendor No.",SalesCodeFilter)
      ELSE
        SETRANGE("Vendor No.");

      IF ItemNoFilter <> '' THEN BEGIN
        SETFILTER("Item No.",ItemNoFilter);
      END ELSE
        SETRANGE("Item No.");

      CalcTotals;

      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ItemNoFilterOnAfterValidate@19009808();
    BEGIN
      CurrPage.SAVERECORD;
      SetRecFilters;
    END;

    PROCEDURE GetVendorQuotes@1102755000();
    BEGIN
      //insert the quotes from vendors
      IF RFQNoFilter = '' THEN ERROR('Specify the RFQ No.');

      PurchHeader.SETRANGE(PurchHeader."No.",RFQNoFilter);
      PurchHeader.FINDSET;
      REPEAT
        PurchLines.RESET;
        PurchLines.SETRANGE("Document No.",PurchHeader."No.");
        IF PurchLines.FINDSET THEN
        REPEAT
          INIT;
          "RFQ No.":=PurchHeader."No.";
          "RFQ Line No.":=PurchLines."Line No.";
          "Quote No.":=PurchLines."Document No.";
          "Vendor No.":=PurchLines."Buy-from Vendor No.";
          "Item No.":=PurchLines."No.";
          Description:=PurchLines.Description;
          Quantity:=PurchLines.Quantity;
          "Unit Of Measure":=PurchLines."Unit of Measure";
          Amount:=PurchLines."Direct Unit Cost";
          "Line Amount":=Quantity*Amount;
          INSERT(TRUE);
          InsertCount:=+1;
         UNTIL PurchLines.NEXT=0;
      UNTIL PurchHeader.NEXT=0;
      MESSAGE('%1 records have been inserted to the bid analysis');
    END;

    LOCAL PROCEDURE SalesCodeFilterOnAfterValidate@19067727();
    BEGIN
      CurrPage.SAVERECORD;
      SetRecFilters;
    END;

    PROCEDURE CalcTotals@1102755001();
    VAR
      BidAnalysisRec@1102755000 : Record 51516104;
    BEGIN
      BidAnalysisRec.SETRANGE("RFQ No.","RFQ No.");
      IF SalesCodeFilter <>'' THEN
      BidAnalysisRec.SETRANGE("Vendor No.",SalesCodeFilter);
      IF ItemNoFilter <> '' THEN
      BidAnalysisRec.SETRANGE("Item No.",ItemNoFilter);
      BidAnalysisRec.FINDSET;
      BidAnalysisRec.CALCSUMS("Line Amount");
      Total:=BidAnalysisRec."Line Amount";
    END;

    BEGIN
    END.
  }
}

