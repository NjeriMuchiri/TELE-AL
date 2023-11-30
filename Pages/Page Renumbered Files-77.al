OBJECT page 20418 RFQ Header
{
  OBJECT-PROPERTIES
  {
    Date=01/30/19;
    Time=[ 1:37:35 PM];
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
    SourceTable=Table51516054;
    PageType=Document;
    OnNewRecord=BEGIN
                  Location.RESET;
                  Location.SETRANGE(Location.Code,'NAIROBI');
                  IF Location.FINDFIRST THEN BEGIN
                    "Ship-to Code":= Location.Code;
                    VALIDATE("Ship-to Code");
                  END;
                  //"Ship-to Code":='NAIROBI';
                  "Location Code":='NAIROBI';
                  "Shortcut Dimension 1 Code":='BOSA';
                  "Shortcut Dimension 2 Code":='NAIROBI';
                END;

    ActionList=ACTIONS
    {
      { 1102755016;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755017;1 ;ActionGroup }
      { 1000000000;2 ;Action    ;
                      CaptionML=ENU=Get Document Lines;
                      Promoted=Yes;
                      Image=GetLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 InsertRFQLines;
                               END;
                                }
      { 1102755018;2 ;Action    ;
                      CaptionML=ENU=Assign Vendor(s);
                      Promoted=Yes;
                      Image=Vendor;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Vends@1102755000 : Record 51516036;
                               BEGIN

                                 Vends.RESET;
                                 Vends.SETRANGE(Vends."Document Type","Document Type");
                                 Vends.SETRANGE(Vends."Requisition Document No.","No.");

                                 PAGE.RUN(PAGE::"Quotation Request Vendors",Vends);
                               END;
                                }
      { 1102755027;2 ;Action    ;
                      CaptionML=ENU=Print/Preview;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 Vend@1000 : Record 51516105;
                                 repvend@1001 : Report 51516105;
                               BEGIN
                                 IF Status=Status::Open THEN
                                    ERROR('RFQ Must be Released. Current Status is Open');

                                 PQH.SETRECFILTER;
                                 PQH.SETFILTER(PQH."Document Type",'%1',"Document Type");
                                 PQH.SETFILTER("No.","No.");
                                 IF PQH.FIND ('-') THEN
                                 REPORT.RUN(REPORT::"RFQ Report",TRUE,TRUE,PQH);
                                 //repvend.SETTABLEVIEW(PQH);
                                 //repvend.NEWPAGEPERRECORD(TRUE);
                                 //repvend.RUN;
                                 {
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."Requisition Document No.","No.");
                                 IF Vend.FINDSET THEN BEGIN
                                 // REPEAT
                                   //MESSAGE(Vend."Vendor Name");
                                   REPORT.RUN(REPORT::"RFQ Report",TRUE,TRUE,Vend);
                                  //UNTIL Vend.NEXT=0;
                                 END;
                                 }
                               END;
                                }
      { 1102755014;2 ;Action    ;
                      Name=Create Quotes;
                      CaptionML=ENU=Create Vendor Quotes;
                      Promoted=Yes;
                      Visible=false;
                      Image=VendorPayment;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 RFQLines@1102755001 : Record 51516055;
                                 PurchaseHeader@1102755003 : Record 38;
                                 PurchaseLines@1102755004 : Record 39;
                                 Vends@1102755005 : Record 51516036;
                               BEGIN
                                 Vends.SETRANGE(Vends."Requisition Document No.","No.");
                                 IF Vends.FINDSET THEN
                                 REPEAT
                                 //create header
                                   PurchaseHeader.INIT;
                                   PurchaseHeader."Document Type":=PurchaseHeader."Document Type"::Quote;
                                   PurchaseHeader.DocApprovalType:=PurchaseHeader.DocApprovalType::Quote;
                                   PurchaseHeader."No.":='';
                                   PurchaseHeader."Responsibility Center":="Responsibility Center";
                                   PurchaseHeader."Shortcut Dimension 1 Code":="Shortcut Dimension 1 Code";
                                   PurchaseHeader."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                                   PurchaseHeader.INSERT(TRUE);
                                   PurchaseHeader.VALIDATE("Buy-from Vendor No.",Vends."Vendor No.");
                                   PurchaseHeader."Responsibility Center":="Responsibility Center";
                                   PurchaseHeader."Shortcut Dimension 1 Code":="Shortcut Dimension 1 Code";
                                   PurchaseHeader."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                                 //  PurchaseHeader.validate("RFQ No.","No.");
                                   PurchaseHeader.MODIFY;
                                   PurchaseHeader.INSERT(TRUE);

                                 //create lines

                                   RFQLines.SETRANGE(RFQLines."Document No.","No.");
                                   IF RFQLines.FINDSET THEN
                                   REPEAT
                                     PurchaseLines.INIT;
                                     PurchaseLines.TRANSFERFIELDS(RFQLines);
                                     PurchaseLines."Document Type":=PurchaseLines."Document Type"::Quote;
                                     PurchaseLines."Document No.":="No.";
                                     PurchaseLines.INSERT;
                                   {
                                     ReqLines.VALIDATE(ReqLines."No.");
                                     ReqLines.VALIDATE(ReqLines.Quantity);
                                     ReqLines.VALIDATE(ReqLines."Direct Unit Cost");
                                     ReqLines.MODIFY;
                                   }
                                   UNTIL RFQLines.NEXT=0;
                                 UNTIL Vends.NEXT=0;
                               END;
                                }
      { 1102755020;2 ;Action    ;
                      Name=Bid Analysis;
                      CaptionML=ENU=Bid Analysis;
                      RunObject=Page 51516127;
                      Promoted=Yes;
                      Image=Worksheet;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PurchaseHeader@1102755004 : Record 38;
                                 PurchaseLines@1102755003 : Record 39;
                                 ItemNoFilter@1102755002 : Text[250];
                                 RFQNoFilter@1102755001 : Text[250];
                                 InsertCount@1102755000 : Integer;
                                 BidAnalysis@1102755005 : Record 51516104;
                               BEGIN
                                 //deletebidanalysis for this vendor
                                 BidAnalysis.SETRANGE(BidAnalysis."RFQ No.","No.");
                                 BidAnalysis.DELETEALL;


                                 //insert the quotes from vendors

                                 PurchaseHeader.SETRANGE(PurchaseHeader."No.","No.");
                                 PurchaseHeader.FINDSET;
                                 REPEAT
                                   PurchaseLines.RESET;
                                   PurchaseLines.SETRANGE("Document No.",PurchaseHeader."No.");
                                   IF PurchaseLines.FINDSET THEN
                                   REPEAT
                                     BidAnalysis.INIT;
                                     BidAnalysis."RFQ No.":="No.";
                                     BidAnalysis."RFQ Line No.":=PurchaseLines."Line No.";
                                     BidAnalysis."Quote No.":=PurchaseLines."Document No.";
                                     BidAnalysis."Vendor No.":=PurchaseHeader."Buy-from Vendor No.";
                                     BidAnalysis."Item No.":=PurchaseLines."No.";
                                     BidAnalysis.Description:=PurchaseLines.Description;
                                     BidAnalysis.Quantity:=PurchaseLines.Quantity;
                                     BidAnalysis."Unit Of Measure":=PurchaseLines."Unit of Measure";
                                     BidAnalysis.Amount:=PurchaseLines."Direct Unit Cost";
                                     BidAnalysis."Line Amount":=BidAnalysis.Quantity*BidAnalysis. Amount;
                                     BidAnalysis.INSERT(TRUE);
                                     InsertCount+=1;
                                    UNTIL PurchaseLines.NEXT=0;
                                 UNTIL PurchaseHeader.NEXT=0;
                                 //MESSAGE('%1 records have been inserted to the bid analysis',InsertCount);
                               END;
                                }
      { 1102755019;1 ;ActionGroup;
                      CaptionML=ENU=Status }
      { 1102755021;2 ;Action    ;
                      CaptionML=ENU=Cancel;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 //check if the quotation for request number has already been used
                                 {
                                 PurchHeader.RESET;
                                 PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                                 PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                                 IF PurchHeader.FINDFIRST THEN
                                   BEGIN
                                     ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                                   END;
                                 }
                                 IF CONFIRM('Cancel Document?',FALSE)=FALSE THEN BEGIN EXIT END;
                                 Status:=Status::Cancelled;
                                 MODIFY;
                               END;
                                }
      { 1102755023;2 ;Action    ;
                      CaptionML=ENU=Stop;
                      Promoted=Yes;
                      Image=Stop;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 //check if the quotation for request number has already been used
                                 {
                                 PurchHeader.RESET;
                                 PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                                 PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                                 IF PurchHeader.FINDFIRST THEN
                                   BEGIN
                                     ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                                   END;
                                 }
                                 IF CONFIRM('Close Document?',FALSE)=FALSE THEN BEGIN EXIT END;
                                 Status:=Status::Closed;
                                 MODIFY;
                               END;
                                }
      { 1102755024;2 ;Action    ;
                      CaptionML=ENU=Close;
                      Promoted=Yes;
                      Image=Close;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 //check if the quotation for request number has already been used
                                 {
                                 PurchHeader.RESET;
                                 PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                                 PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                                 IF PurchHeader.FINDFIRST THEN
                                   BEGIN
                                     ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                                   END;
                                 }
                                 IF CONFIRM('Close Document?',FALSE)=FALSE THEN BEGIN EXIT END;
                                 Status:=Status::Closed;
                                 MODIFY;
                               END;
                                }
      { 1102755025;2 ;Action    ;
                      CaptionML=ENU=Release;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 IF CONFIRM('Release document?',FALSE)=FALSE THEN BEGIN EXIT END;
                                 //check if the document has any lines
                                 Lines.RESET;
                                 Lines.SETRANGE(Lines."Document Type","Document Type");
                                 Lines.SETRANGE(Lines."Document No.","No.");
                                 IF Lines.FINDFIRST THEN
                                   BEGIN
                                     REPEAT
                                       Lines.TESTFIELD(Lines.Quantity);
                                       //Lines.TESTFIELD(Lines."Direct Unit Cost");
                                       Lines.TESTFIELD("No.");
                                     UNTIL Lines.NEXT=0;
                                   END
                                 ELSE
                                   BEGIN
                                     ERROR('Document has no lines');
                                   END;
                                 Status:=Status::Released;
                                 "Released By":=USERID;
                                 "Release Date":=TODAY;
                                 MODIFY;
                               END;
                                }
      { 1102755026;2 ;Action    ;
                      CaptionML=ENU=Reopen;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 //check if the quotation for request number has already been used
                                 PurchHeader.RESET;
                                 PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                                 //PurchHeader.SETRANGE(purchheader."request for quote no","No.");
                                 IF PurchHeader.FINDFIRST THEN
                                   BEGIN
                                     ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                                   END;

                                 IF CONFIRM('Reopen Document?',FALSE)=FALSE THEN BEGIN EXIT END;
                                 Status:=Status::Open;
                                 MODIFY;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr="Posting Description" }

    { 1102755004;2;Field  ;
                SourceExpr="Ship-to Code";
                Visible=True;
                Editable=True }

    { 1102755005;2;Field  ;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 1102755007;2;Field  ;
                SourceExpr="Expected Opening Date" }

    { 1102755008;2;Field  ;
                SourceExpr="Expected Closing Date" }

    { 1102755009;2;Field  ;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 1102755010;2;Field  ;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 1102755012;2;Field  ;
                SourceExpr=Status }

    { 1102755013;2;Field  ;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102755015;1;Part   ;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page51516061;
                PartType=Page }

  }
  CODE
  {
    VAR
      PurchHeader@1102755004 : Record 38;
      PParams@1102755003 : Record 51516065;
      Lines@1102755002 : Record 51516055;
      PQH@1102755001 : Record 51516054;
      Location@1000000000 : Record 14;

    PROCEDURE InsertRFQLines@1102755004();
    VAR
      Counter@1003 : Integer;
      Collection@1102755000 : Record 39;
      CollectionList@1102755001 : page 20429;
    BEGIN
      CollectionList.LOOKUPMODE(TRUE);
      IF CollectionList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        CollectionList.SetSelection(Collection);
        Counter := Collection.COUNT;
        IF Counter > 0 THEN BEGIN
          IF Collection.FINDSET THEN
            REPEAT
              Lines.INIT;
              Lines.TRANSFERFIELDS(Collection);
              Lines."Document Type":="Document Type";
              Lines."Document No.":="No.";
              Lines."Line No.":=0;
              Lines."PRF No":=Collection."Document No.";
              Lines."PRF Line No.":=Collection."Line No.";
              Lines.INSERT(TRUE);
              //Collection.Copied:=TRUE;
              //Collection.MODIFY;
           UNTIL Collection.NEXT = 0;
        END;
      END;
    END;

    BEGIN
    END.
  }
}

