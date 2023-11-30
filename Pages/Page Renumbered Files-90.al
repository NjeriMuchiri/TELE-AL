OBJECT page 20431 Store Requisitions (Pending)
{
  OBJECT-PROPERTIES
  {
    Date=08/19/16;
    Time=10:35:29 AM;
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    SourceTable=Table51516063;
    SourceTableView=WHERE(Status=FILTER(Pending Approval));
    PageType=List;
    CardPageID=Store Requisition Header;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN

                 {IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
                   FILTERGROUP(0);
                 END;}
                 {
                 HREmp.RESET;
                 HREmp.SETRANGE(HREmp."User ID",USERID);
                 IF HREmp.GET THEN
                 SETRANGE("User ID",HREmp."User ID")
                 ELSE
                 //user id may not be the creator of the doc
                 SETRANGE("User ID",USERID);
                 }
                 {
                 IF UserMgt.GetSetDimensions(USERID,2) <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Shortcut Dimension 2 Code",UserMgt.GetSetDimensions(USERID,2));
                   FILTERGROUP(0);
                 END;
                 }
               END;

    ActionList=ACTIONS
    {
      { 1102755021;  ;ActionContainer;
                      Name=<Action1900000004>;
                      ActionContainerType=ActionItems }
      { 1102755020;1 ;ActionGroup;
                      Name=<Action1102755026>;
                      CaptionML=ENU=&Functions }
      { 1102755019;2 ;Action    ;
                      Name=<Action1102755028>;
                      CaptionML=ENU=Post Store Requisition;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF NOT LinesExists THEN
                                    ERROR('There are no Lines created for this Document');

                                    IF Status=Status::Posted THEN
                                       ERROR('The Document Has Already been Posted');

                                    IF Status<>Status::Released    THEN
                                       ERROR('The Document Has not yet been Approved');


                                     TESTFIELD("Issuing Store");
                                     ReqLine.RESET;
                                     ReqLine.SETRANGE(ReqLine."Requistion No","No.");
                                     TESTFIELD("Issuing Store");
                                     IF ReqLine.FIND('-') THEN BEGIN
                                     REPEAT
                                     //Issue
                                       IF InventorySetup.GET THEN BEGIN
                                              InventorySetup.TESTFIELD(InventorySetup."Item Jnl Template");
                                              InventorySetup.TESTFIELD(InventorySetup."Item Jnl Batch");
                                              GenJnline.RESET;
                                              GenJnline.SETRANGE(GenJnline."Journal Template Name",InventorySetup."Item Jnl Template");
                                              GenJnline.SETRANGE(GenJnline."Journal Batch Name",InventorySetup."Item Jnl Batch");
                                              IF GenJnline.FIND('-') THEN GenJnline.DELETEALL;
                                              LineNo:=LineNo+1000;
                                              GenJnline.INIT;
                                              GenJnline."Journal Template Name":=InventorySetup."Item Jnl Template";
                                              GenJnline."Journal Batch Name":=InventorySetup."Item Jnl Batch";
                                              GenJnline."Line No.":=LineNo;
                                              GenJnline."Entry Type":=GenJnline."Entry Type"::"Negative Adjmt.";
                                              GenJnline."Document No.":="No.";
                                              GenJnline."Item No.":=ReqLine."No.";
                                              GenJnline.VALIDATE("Item No.");
                                              GenJnline."Location Code":="Issuing Store";
                                              GenJnline.VALIDATE("Location Code");
                                              GenJnline."Posting Date":="Request date";
                                              GenJnline.Description:=ReqLine.Description;
                                              GenJnline.Quantity:=ReqLine.Quantity;
                                              GenJnline."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                                              GenJnline.VALIDATE("Shortcut Dimension 1 Code");
                                              GenJnline."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                                              GenJnline.VALIDATE("Shortcut Dimension 2 Code");
                                              GenJnline.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                                              GenJnline.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                              GenJnline.VALIDATE(Quantity);
                                              GenJnline.VALIDATE("Unit Amount");
                                              GenJnline."Reason Code":='221';
                                              GenJnline.VALIDATE("Reason Code");
                                              GenJnline.INSERT(TRUE);

                                              ReqLine."Request Status":=ReqLine."Request Status"::Closed;

                                           END;
                                    UNTIL ReqLine. NEXT=0;
                                             //Post Entries
                                             GenJnline.RESET;
                                             GenJnline.SETRANGE(GenJnline."Journal Template Name",InventorySetup."Item Jnl Template");
                                             GenJnline.SETRANGE(GenJnline."Journal Batch Name",InventorySetup."Item Jnl Batch");
                                             CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",GenJnline);
                                             //End Post entries

                                           //Modify All
                                           Post:=FALSE;
                                           Post:=JournlPosted.PostedSuccessfully();
                                           IF Post THEN
                                                 ReqLine.MODIFYALL(ReqLine."Request Status",ReqLine."Request Status"::Closed);
                                    END;
                               END;
                                }
      { 1102755018;2 ;Separator  }
      { 1102755017;2 ;Action    ;
                      Name=<Action1102755032>;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::Requisition;
                                 ApprovalEntries.Setfilters(DATABASE::"Store Requistion Header",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755016;2 ;Action    ;
                      Name=<Action1102755030>;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF NOT LinesExists THEN
                                    ERROR('There are no Lines created for this Document');
                               END;
                                }
      { 1102755015;2 ;Action    ;
                      Name=<Action1102755031>;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Promoted=Yes;
                      Image=Reject;
                      PromotedCategory=Category4 }
      { 1102755014;2 ;Separator  }
      { 1102755013;2 ;Action    ;
                      Name=<Action1102755036>;
                      CaptionML=ENU=Print/Preview;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                    IF Status<>Status::Posted THEN
                                     ERROR('You can only print a Purchase Order after it Fully Approved And Posted');

                                 RESET;
                                 SETFILTER("No.","No.");
                                 REPORT.RUN(51516216,TRUE,TRUE,Rec);
                                 RESET;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr="Request date" }

    { 1102755004;2;Field  ;
                SourceExpr="Request Description" }

    { 1102755005;2;Field  ;
                SourceExpr="Requester ID" }

    { 1102755006;2;Field  ;
                SourceExpr=Status }

    { 1102755007;2;Field  ;
                SourceExpr=TotalAmount }

    { 1   ;2   ;Field     ;
                SourceExpr="User ID" }

    { 1102755008;2;Field  ;
                SourceExpr="Issuing Store" }

    { 2   ;2   ;Field     ;
                SourceExpr="Function Name" }

    { 3   ;2   ;Field     ;
                SourceExpr="Budget Center Name" }

    { 1102755009;0;Container;
                ContainerType=FactBoxArea }

    { 1102755010;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

    { 1102755011;1;Part   ;
                PartType=System;
                SystemPartID=MyNotes }

    { 1102755012;1;Part   ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      UserMgt@1102755011 : Codeunit 418;
      ApprovalMgt@1102755010 : Codeunit 439;
      ReqLine@1102755009 : Record 51516064;
      InventorySetup@1102755008 : Record 313;
      GenJnline@1102755007 : Record 83;
      LineNo@1102755006 : Integer;
      Post@1102755005 : Boolean;
      JournlPosted@1102755004 : Codeunit 51516156;
      DocumentType@1102755002 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition';
      HasLines@1102755001 : Boolean;
      AllKeyFieldsEntered@1102755000 : Boolean;
      HREmp@1000 : Record 51516160;

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

    BEGIN
    END.
  }
}

