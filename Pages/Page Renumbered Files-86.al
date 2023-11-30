OBJECT page 20427 Store Requisition Header
{
  OBJECT-PROPERTIES
  {
    Date=04/05/17;
    Time=10:14:24 AM;
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516063;
    PageType=Document;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 IF Status=Status::"Pending Approval" THEN
                 CurrPage.EDITABLE:=FALSE;

                 IF Status=Status::Open THEN BEGIN
                 PageActionsVisible:=FALSE;
                 END ELSE IF Status<>Status::Open THEN BEGIN
                 PageActionsVisible:=TRUE;
                 END;
                 "Responsibility Center":='FINANCE';

                 {
                 IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
                   FILTERGROUP(0);
                 END;
                 }
                   //SETRANGE("User ID",USERID);
               END;

    OnNextRecord=BEGIN
                   UpdateControls;
                 END;

    OnAfterGetRecord=BEGIN
                       CurrPageUpdate;
                     END;

    OnNewRecord=BEGIN
                  {"Responsibility Center" := UserMgt.GetPurchasesFilter();
                   //Add dimensions if set by default here
                   "Global Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
                   VALIDATE("Global Dimension 1 Code");
                   "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
                   VALIDATE("Shortcut Dimension 2 Code");
                   "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(USERID,3);
                   VALIDATE("Shortcut Dimension 3 Code");
                   "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(USERID,4);
                   VALIDATE("Shortcut Dimension 4 Code");
                   }
                  UpdateControls;
                END;

    OnInsertRecord=BEGIN

                      SHeader.RESET;
                      SHeader.SETRANGE("User ID",USERID);
                      SHeader.SETRANGE(SHeader.Status,SHeader.Status::Open);
                     // SHeader.SETRANGE(SHeader."Request date",TODAY);
                      IF SHeader.COUNT>1 THEN
                        ERROR('You have unused requisition records under your account,please utilize/release them for approval'+
                          ' before creating a new record');
                   END;

    OnDeleteRecord=BEGIN
                      ERROR('Not Allowed!');
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755026;1 ;ActionGroup;
                      CaptionML=ENU=&Functions }
      { 1102755028;2 ;Action    ;
                      CaptionML=ENU=Post Store Requisition;
                      Promoted=Yes;
                      Visible=True;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ItemLedger@1102755000 : Record 32;
                               BEGIN
                                 IF NOT LinesExists THEN
                                    ERROR('There are no Lines created for this Document');

                                    IF Status=Status::Posted THEN
                                       ERROR('The Document Has Already been Posted');

                                    IF Status<>Status::Released    THEN
                                       ERROR('The Document Has not yet been Approved');
                                  IF InventorySetup.GET THEN BEGIN
                                     InventorySetup.TESTFIELD(InventorySetup."Item Jnl Template");
                                     InventorySetup.TESTFIELD(InventorySetup."Item Jnl Batch");
                                     GenJnline.RESET;
                                     GenJnline.SETRANGE(GenJnline."Journal Template Name",InventorySetup."Item Jnl Template");
                                     GenJnline.SETRANGE(GenJnline."Journal Batch Name",InventorySetup."Item Jnl Batch");
                                     IF GenJnline.FIND('-') THEN GenJnline.DELETEALL;

                                     {ReqLine.RESET;
                                     ReqLine.SETRANGE(ReqLine."Requistion No","No.");
                                     IF ReqLine.FIND ('-') THEN BEGIN
                                     Item.RESET;
                                     Item.SETRANGE(Item."No.",ReqLine."No.");
                                     IF Item.FIND ('-') THEN BEGIN
                                     IssStore:=Item."Location Code";
                                     END;
                                     END;}


                                     ReqLine.RESET;
                                     ReqLine.SETRANGE(ReqLine."Requistion No","No.");
                                     IF ReqLine.FIND('-') THEN BEGIN
                                     REPEAT
                                     Item.RESET;
                                     Item.SETRANGE(Item."No.",ReqLine."No.");
                                     IF Item.FIND ('-') THEN BEGIN
                                     IssStore:=Item."Location Code";
                                     END;

                                     //Issue

                                              LineNo:=LineNo+1000;
                                              GenJnline.INIT;
                                              GenJnline."Journal Template Name":=InventorySetup."Item Jnl Template";
                                              GenJnline."Journal Batch Name":=InventorySetup."Item Jnl Batch";
                                              GenJnline."Line No.":=LineNo;
                                              GenJnline."Entry Type":=GenJnline."Entry Type"::"Negative Adjmt.";
                                              GenJnline."Document No.":="No.";
                                              GenJnline."Item No.":=ReqLine."No.";
                                              GenJnline.VALIDATE("Item No.");
                                              GenJnline."Location Code":= IssStore;
                                              //GenJnline."Bin Code":=ReqLine."Bin Code";
                                              GenJnline.VALIDATE("Location Code");
                                              GenJnline."Posting Date":="Request date";
                                              GenJnline.Description:=ReqLine.Description;
                                                 ItemLedger.RESET;
                                                 ItemLedger.SETRANGE(ItemLedger."Item No.",ReqLine."No.");
                                                 ItemLedger.SETRANGE(ItemLedger."Location Code",ReqLine."Issuing Store");
                                                 ItemLedger.CALCSUMS(Quantity);
                                                //IF ItemLedger.Quantity<=0 THEN ERROR('Item %1 is out of stock in store %2',ReqLine.Description,ReqLine."Issuing Store");
                                              GenJnline.Quantity:=ReqLine.Quantity;
                                              GenJnline."Shortcut Dimension 1 Code":=ReqLine."Shortcut Dimension 1 Code";
                                              GenJnline.VALIDATE("Shortcut Dimension 1 Code");
                                              GenJnline."Shortcut Dimension 2 Code":=ReqLine."Shortcut Dimension 2 Code";
                                              GenJnline.VALIDATE("Shortcut Dimension 2 Code");
                                              //GenJnline."Lot No.":=ReqLine."Lot No.";
                                              GenJnline.ValidateShortcutDimCode(3,ReqLine."Shortcut Dimension 3 Code");
                                              GenJnline.ValidateShortcutDimCode(4,ReqLine."Shortcut Dimension 4 Code");
                                              GenJnline.VALIDATE(Quantity);
                                              GenJnline.VALIDATE("Unit Amount");
                                              //GenJnline."Reason Code":='ITEMJNL';
                                              GenJnline.VALIDATE("Reason Code");
                                              //GenJnline."Gen. Prod. Posting Group":=ReqLine."Gen. Prod. Posting Group";
                                              //GenJnline."Gen. Bus. Posting Group":=ReqLine."Gen. Bus. Posting Group";
                                              //Get the inventory posting Group
                                              Item.RESET;
                                              Item.SETRANGE(Item."No.",ReqLine."No.");
                                              IF Item.FINDLAST THEN BEGIN
                                                 GenJnline."Inventory Posting Group":=Item."Inventory Posting Group";
                                              END;
                                              GenJnline.INSERT(TRUE);

                                              ReqLine."Request Status":=ReqLine."Request Status"::Closed;

                                     //Denno Added to take care of lot numbers-----------------
                                              //If Lot No field  Exist then insert reservation line
                                            {  ResEntry.RESET;
                                              ResEntry.SETRANGE(ResEntry."Entry No.");
                                              IF ResEntry.FIND('+') THEN LastResNo:=ResEntry."Entry No.";

                                              LastResNo:=LastResNo+1;

                                              IF ReqLine."Lot No."<>'' THEN BEGIN
                                               ResEntry.INIT;
                                               ResEntry."Entry No.":=LastResNo;   //ResEntry."Entry No."
                                               ResEntry."Item No.":=ReqLine."No.";
                                               ResEntry."Location Code":=ReqLine."Issuing Store";
                                               ResEntry."Quantity (Base)":=-ReqLine.Quantity;
                                               ResEntry.VALIDATE("Quantity (Base)");
                                               ResEntry.Quantity:=-ReqLine.Quantity;
                                               ResEntry."Qty. to Handle (Base)":=-ReqLine.Quantity;
                                               ResEntry.VALIDATE("Qty. to Handle (Base)");
                                               ResEntry."Reservation Status":=ResEntry."Reservation Status"::Prospect;
                                               ResEntry."Creation Date":="Request date";
                                               ResEntry."Source Type":=83;
                                               ResEntry."Source Subtype":=3;
                                               ResEntry."Source ID":='ITEM';
                                               ResEntry."Source Batch Name":='DEFAULT';
                                               ResEntry."Source Ref. No.":=  LineNo;
                                               ResEntry."Lot No.":= ReqLine."Lot No.";
                                               ResEntry."Item Tracking":=ResEntry."Item Tracking"::"Lot No.";
                                               ResEntry.INSERT;

                                              END;  }
                                   //End Denno Added to take care of lot numbers-----------------

                                    UNTIL ReqLine. NEXT=0;

                                         //Post Entries
                                             GenJnline.RESET;
                                             GenJnline.SETRANGE(GenJnline."Journal Template Name",InventorySetup."Item Jnl Template");
                                             GenJnline.SETRANGE(GenJnline."Journal Batch Name",InventorySetup."Item Jnl Batch");
                                             CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",GenJnline);
                                             //End Post entries
                                 Status:=Status::Posted;
                                 MODIFY;


                                     ReqLine.RESET;
                                     ReqLine.SETRANGE(ReqLine."Requistion No","No.");
                                     IF ReqLine.FIND('-') THEN BEGIN
                                     REPEAT
                                     ReqLine."Request Status":=ReqLine."Request Status"::Closed;
                                     ReqLine."Posting Date":="Request date";
                                     ReqLine.MODIFY;

                                     UNTIL ReqLine. NEXT=0;
                                      END;


                                          // Modify All
                                           Post:=FALSE;
                                           Post:=JournlPosted.PostedSuccessfully();
                                           IF Post THEN BEGIN
                                                ReqLine.MODIFYALL(ReqLine."Request Status",ReqLine."Request Status"::Closed);
                                               Status:=Status::Posted;
                                                 MODIFY;
                                            END
                                           END;
                                 END;

                                 Status:=Status::Posted;
                                 MODIFY;
                               END;
                                }
      { 1102755029;2 ;Separator  }
      { 1102755032;2 ;Action    ;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 DocumentType:=DocumentType::Requisition;
                                 ApprovalEntries.Setfilters(DATABASE::"Store Requistion Header",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755030;2 ;Action    ;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      OnAction=BEGIN
                                 //IF NOT LinesExists THEN
                                    //ERROR('There are no Lines created for this Document');

                                 TESTFIELD(Status,Status::Open);
                                 TESTFIELD( "Global Dimension 1 Code");
                                 TESTFIELD("Shortcut Dimension 2 Code");
                                 CALCFIELDS(TotalAmount);

                                 IF TotalAmount=0 THEN ERROR('No amounts in the lines!');

                                 IF CONFIRM('Are you sure you want to send this requisition for approval?')=TRUE THEN
                                   BEGIN
                                     Status:=Status::Released;
                                     MODIFY;
                                   END;

                                 {IF ApprovalsMgmt.CheckLoanAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendStoresDocForApproval(Rec);}
                               END;
                                }
      { 1102755031;2 ;Action    ;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Promoted=Yes;
                      Image=Reject;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                  //IF ApprovalMgt.CancelSRRequestApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755035;2 ;Separator  }
      { 1102755036;2 ;Action    ;
                      CaptionML=ENU=Print/Preview;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN


                                 //IF Status<>Status::Posted THEN
                                   // ERROR('You can only print a Material Requisiton after it Fully Approved And Posted');

                                 RESET;
                                 SETFILTER("No.","No.");
                                 REPORT.RUN(51516007,TRUE,TRUE,Rec);
                                 RESET;
                               END;
                                }
      { 3       ;2   ;Action    ;
                      CaptionML=ENU=Cancel Document;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      OnAction=BEGIN
                                  {IF Usersetup.GET (USERID) THEN BEGIN
                                  IF Usersetup."Cancel Requisition"=TRUE THEN BEGIN
                                  Status:=Status::Cancelled;
                                  Cancelled:=TRUE;
                                  "Cancelled By":=USERID;
                                  MODIFY;
                                  MESSAGE('Document Cancelled!');
                                  END ELSE
                                  ERROR('You have no rights to cancel the document!');
                                  END;
                                  }
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755001;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr="Request date" }

    { 1102755005;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=statuseditable }

    { 1102755014;2;Field  ;
                CaptionML=ENU=Description;
                SourceExpr="Function Name";
                Editable=FALSE }

    { 1102755007;2;Field  ;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=statuseditable }

    { 1102755019;2;Field  ;
                CaptionML=ENU=Description;
                SourceExpr="Budget Center Name";
                Editable=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr="Request Description";
                Editable=statuseditable }

    { 1102755009;2;Field  ;
                SourceExpr="Required Date";
                Editable=statuseditable }

    { 2   ;2   ;Field     ;
                SourceExpr="Issuing Store";
                Visible=TRUE }

    { 1102755024;2;Field  ;
                SourceExpr=Status }

    { 1102756000;2;Field  ;
                SourceExpr="Responsibility Center";
                Editable=FALSE }

    { 1   ;2   ;Field     ;
                SourceExpr="User ID";
                Editable=false }

    { 1102755002;2;Field  ;
                SourceExpr="Job No";
                Visible=FALSE;
                Editable=true }

    { 4   ;2   ;Field     ;
                SourceExpr=Cancelled }

    { 5   ;2   ;Field     ;
                SourceExpr="Cancelled By" }

    { 1102755015;1;Part   ;
                SubPageLink=Requistion No=FIELD(No.);
                PagePartID=Page51516076;
                Editable=true }

  }
  CODE
  {
    VAR
      UserMgt@1102755000 : Codeunit 51516155;
      ApprovalsMgmt@1102755001 : Codeunit 1535;
      ReqLine@1102755002 : Record 51516064;
      InventorySetup@1102755003 : Record 313;
      GenJnline@1102755004 : Record 83;
      LineNo@1102755005 : Integer;
      Post@1102755006 : Boolean;
      JournlPosted@1102755007 : Codeunit 51516156;
      DocumentType@1102755008 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition';
      HasLines@1102756001 : Boolean;
      AllKeyFieldsEntered@1102756000 : Boolean;
      ApprovalEntries@1000 : Page 658;
      StatusEditable@1102755009 : Boolean;
      PageActionsVisible@1001 : Boolean;
      Text046@1000000000 : TextConst 'ENU=The %1 does not match the quantity defined in item tracking.';
      ResEntry@1000000001 : Record 337;
      LastResNo@1000000002 : Integer;
      InventoryPostingSetup@1002 : Record 5813;
      Item@1003 : Record 27;
      SHeader@1004 : Record 51516063;
      IssStore@1005 : Code[20];
      Usersetup@1006 : Record 91;

    PROCEDURE LinesExists@1102756000() : Boolean;
    VAR
      PayLines@1102756000 : Record 51516064;
    BEGIN
       HasLines:=FALSE;
       PayLines.RESET;
       PayLines.SETRANGE(PayLines."Requistion No","No.");
        IF PayLines.FIND('-') THEN BEGIN
           HasLines:=TRUE;
           EXIT(HasLines);
        END;
    END;

    PROCEDURE UpdateControls@1102755000();
    BEGIN
      IF Status=Status::Open THEN
      StatusEditable:=TRUE
      ELSE
      StatusEditable:=FALSE;
    END;

    PROCEDURE CurrPageUpdate@1102755001();
    BEGIN
      xRec:=Rec;
      UpdateControls;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE CheckTrackingSpecification@46(VAR PurchLine@1019 : Record 51516064);
    VAR
      PurchLineToCheck@1000 : Record 51516064;
      ReservationEntry@1001 : Record 337;
      Item@1016 : Record 27;
      ItemTrackingCode@1009 : Record 6502;
      CreateReservEntry@1004 : Codeunit 99000830;
      ItemTrackingManagement@1015 : Codeunit 6500;
      ErrorFieldCaption@1018 : Text[250];
      SignFactor@1005 : Integer;
      PurchLineQtyHandled@1022 : Decimal;
      PurchLineQtyToHandle@1023 : Decimal;
      TrackingQtyHandled@1021 : Decimal;
      TrackingQtyToHandle@1003 : Decimal;
      Inbound@1010 : Boolean;
      SNRequired@1011 : Boolean;
      LotRequired@1012 : Boolean;
      SNInfoRequired@1013 : Boolean;
      LotInfoReguired@1014 : Boolean;
      CheckPurchLine@1008 : Boolean;
    BEGIN
      // if a PurchaseLine is posted with ItemTracking then the whole quantity of
      // the regarding PurchaseLine has to be post with Item-Tracking

      {TrackingQtyToHandle := 0;
      TrackingQtyHandled := 0;

      PurchLineToCheck.COPY(PurchLine);
      PurchLineToCheck.SETRANGE(Type,PurchLineToCheck.Type::Item);
      //IF PurchHeader.Receive THEN BEGIN ---- Denno
      //  PurchLineToCheck.SETFILTER("Quantity Received",'<>%1',0);
      //  ErrorFieldCaption := PurchLineToCheck.FIELDCAPTION("Qty. to Receive");
      //END ELSE BEGIN
        PurchLineToCheck.SETFILTER(Quantity,'<>%1',0);
        ErrorFieldCaption := PurchLineToCheck.FIELDCAPTION(Quantity);
      //END;

      IF PurchLineToCheck.FINDSET THEN BEGIN
        ReservationEntry."Source Type" := DATABASE::"Store Requistion Lines";
        ReservationEntry."Source Subtype" :=0 ;//PurchHeader."Document Type";
        SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
        REPEAT
          // Only Item where no SerialNo or LotNo is required
          Item.GET(PurchLineToCheck."No.");
          IF Item."Item Tracking Code" <> '' THEN BEGIN
            Inbound := (PurchLineToCheck.Quantity * SignFactor) > 0;
            ItemTrackingCode.Code := Item."Item Tracking Code";
            ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
              GenJnline."Entry Type"::"Negative Adjmt.",
              Inbound,
              SNRequired,
              LotRequired,
              SNInfoRequired,
              LotInfoReguired);
            CheckPurchLine := (SNRequired = FALSE) AND (LotRequired = FALSE);
            IF CheckPurchLine THEN
              CheckPurchLine := GetTrackingQuantities(PurchLineToCheck,0,TrackingQtyToHandle,TrackingQtyHandled);
          END ELSE
            CheckPurchLine := FALSE;

          TrackingQtyToHandle := 0;
          TrackingQtyHandled := 0;

          IF CheckPurchLine THEN BEGIN
            GetTrackingQuantities(PurchLineToCheck,1,TrackingQtyToHandle,TrackingQtyHandled);
            TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
            TrackingQtyHandled := TrackingQtyHandled * SignFactor;
      {      IF PurchHeader.Receive THEN BEGIN
              PurchLineQtyToHandle := PurchLineToCheck."Qty. to Receive (Base)";
              PurchLineQtyHandled := PurchLineToCheck."Qty. Received (Base)";
            END ELSE }
            BEGIN
              PurchLineQtyToHandle := PurchLineToCheck.Quantity;
              PurchLineQtyHandled := PurchLineToCheck.Quantity;
            END;
            IF ((TrackingQtyHandled + TrackingQtyToHandle) <> (PurchLineQtyHandled + PurchLineQtyToHandle)) OR
               (TrackingQtyToHandle <> PurchLineQtyToHandle)
            THEN
              ERROR(STRSUBSTNO(Text046,ErrorFieldCaption));
          END;
        UNTIL PurchLineToCheck.NEXT = 0;
      END;
      }
    END;

    LOCAL PROCEDURE GetTrackingQuantities@47(PurchLine@1000 : Record 51516442;FunctionType@1002 : 'CheckTrackingExists,GetQty';VAR TrackingQtyToHandle@1003 : Decimal;VAR TrackingQtyHandled@1005 : Decimal) : Boolean;
    VAR
      TrackingSpecification@1004 : Record 336;
      ReservEntry@1001 : Record 337;
    BEGIN
      WITH TrackingSpecification DO BEGIN
        SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.");
        SETRANGE("Source Type",DATABASE::"Store Requistion-Lines");
        SETRANGE("Source Subtype",0);
        ///SETRANGE("Source ID",PurchLine."Requistion No");
        SETRANGE("Source Batch Name",'');
        SETRANGE("Source Prod. Order Line",0);
        //SETRANGE("Source Ref. No.",PurchLine."Line No.");
      END;
      WITH ReservEntry DO BEGIN
        SETCURRENTKEY(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line");
        //SETRANGE("Source ID",PurchLine."Requistion No");
        //SETRANGE("Source Ref. No.",PurchLine."Line No.");
        SETRANGE("Source Type",DATABASE::"Store Requistion-Lines");
        SETRANGE("Source Subtype",0);
        SETRANGE("Source Batch Name",'');
        SETRANGE("Source Prod. Order Line",0);
      END;

      CASE FunctionType OF
        FunctionType::CheckTrackingExists:
          BEGIN
            TrackingSpecification.SETRANGE(Correction,FALSE);
            IF NOT TrackingSpecification.ISEMPTY THEN
              EXIT(TRUE);
            ReservEntry.SETFILTER("Serial No.",'<>%1','');
            IF NOT ReservEntry.ISEMPTY THEN
              EXIT(TRUE);
            ReservEntry.SETRANGE("Serial No.");
            ReservEntry.SETFILTER("Lot No.",'<>%1','');
            IF NOT ReservEntry.ISEMPTY THEN
              EXIT(TRUE);
          END;
        FunctionType::GetQty:
          BEGIN
            TrackingSpecification.CALCSUMS("Quantity Handled (Base)");
            TrackingQtyHandled := TrackingSpecification."Quantity Handled (Base)";
            IF ReservEntry.FINDSET THEN
              REPEAT
                IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN
                  TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
              UNTIL ReservEntry.NEXT = 0;
          END;
      END;
    END;

    BEGIN
    END.
  }
}

