OBJECT page 20425 Purchase Requisition List
{
  OBJECT-PROPERTIES
  {
    Date=04/07/16;
    Time=12:40:24 PM;
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Purchase Requisitions;
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=CONST(Quote),
                          PR=FILTER(Yes),
                          Status=CONST(Open));
    PageType=List;
    CardPageID=Purchase Requisition Card;
    OnOpenPage=BEGIN
                 //SetSecurityFilterOnRespCenter;

                 {HREmp.RESET;
                 HREmp.SETRANGE(HREmp."User ID",USERID);
                 IF HREmp.GET THEN
                 SETRANGE("User ID",HREmp."User ID")
                 ELSE}
                 //user id may not be the creator of the doc
                 //SETRANGE("Assigned User ID",USERID);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601018;1 ;ActionGroup;
                      CaptionML=ENU=&Quote;
                      Image=Quote }
      { 1102601020;2 ;Action    ;
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
      { 1102601022;2 ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 1102601023;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601024;2 ;Action    ;
                      CaptionML=ENU=Approvals;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalEntries@1001 : Page 658;
                               BEGIN
                                 ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 50      ;1   ;Action    ;
                      CaptionML=ENU=Make &Order;
                      Promoted=Yes;
                      Visible=false;
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
      { 51      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=&Print;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF LinesCommitted THEN
                                    ERROR('All Lines should be committed');
                                   RESET;
                                   SETRANGE("No.","No.");
                                   REPORT.RUN(51516358,TRUE,TRUE,Rec);
                                   RESET;
                                 //DocPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=ENU=Release;
                      Image=ReleaseDoc }
      { 1102601013;2 ;Separator  }
      { 1102601014;2 ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=ENU=Re&lease;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601015;2 ;Action    ;
                      CaptionML=ENU=Re&open;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=ENU=F&unctions;
                      Image=Action }
      { 1102601011;2 ;Action    ;
                      CaptionML=ENU=Send A&pproval Request;
                      Image=SendApprovalRequest;
                      OnAction=VAR
                                 ApprovalMgt@1001 : Codeunit 439;
                               BEGIN
                                 IF ApprovalMgt.SendPurchaseApprovalRequest(Rec) THEN;
                               END;
                                }
      { 1102601012;2 ;Action    ;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Image=Cancel;
                      OnAction=VAR
                                 ApprovalMgt@1001 : Codeunit 439;
                               BEGIN
                                 IF ApprovalMgt.CancelPurchaseApprovalRequest(Rec,TRUE,TRUE) THEN;
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

    { 13  ;2   ;Field     ;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr="Buy-from Vendor Name";
                Visible=false }

    { 1000000000;2;Field  ;
                SourceExpr="Posting Description" }

    { 15  ;2   ;Field     ;
                SourceExpr="Vendor Authorization No.";
                Visible=false }

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

    { 5   ;2   ;Field     ;
                CaptionML=ENU=Procurement Officer;
                SourceExpr="Responsible Officer";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102601001;2;Field  ;
                SourceExpr="Document Date" }

    { 1102601003;2;Field  ;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                SourceExpr=Status;
                Visible=true }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1901138007;1;Part   ;
                SubPageLink=No.=FIELD(Buy-from Vendor No.),
                            Date Filter=FIELD(Date Filter);
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
      DocPrint@1102601000 : Codeunit 229;
      BCSetup@1102755000 : Record 51516061;
      HREmp@1001 : Record 51516160;

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

    BEGIN
    END.
  }
}

