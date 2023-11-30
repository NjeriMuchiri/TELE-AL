OBJECT page 172173 Member Defaulter Notification
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=[ 4:08:39 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516355;
    PageType=Card;
    OnOpenPage=BEGIN
                 MarkActive:=FALSE;
                 StopActive:=FALSE;
                 RemarkActive:=FALSE;

                 IF NOT Marked THEN MarkActive:=TRUE;
                 IF (NOT Stopped AND Marked) THEN StopActive:=TRUE;
                 IF (Marked AND Stopped) THEN RemarkActive:=TRUE;

                 CurrPage.EDITABLE := NOT Marked;
               END;

    OnAfterGetRecord=BEGIN
                       CurrPage.EDITABLE := NOT Marked;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CurrPage.EDITABLE := NOT Marked;
                         END;

    ActionList=ACTIONS
    {
      { 1120054019;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054020;1 ;Action    ;
                      Name=Mark For Notification;
                      Promoted=Yes;
                      Visible=MarkActive;
                      PromotedIsBig=Yes;
                      Image=Check;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MarkForNotification
                               END;
                                }
      { 1120054021;1 ;Action    ;
                      Name=Stop Notification;
                      Promoted=Yes;
                      Visible=StopActive;
                      PromotedIsBig=Yes;
                      Image=DeactivateDiscounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StopNotification;
                               END;
                                }
      { 1120054022;1 ;Action    ;
                      Name=Remark For Notification;
                      Promoted=Yes;
                      Visible=RemarkActive;
                      PromotedIsBig=Yes;
                      Image=ResetStatus;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StopNotification;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="Member No" }

    { 1120054003;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054023;2;Field  ;
                SourceExpr="Payroll No" }

    { 1120054004;2;Field  ;
                SourceExpr="ID No" }

    { 1120054005;2;Field  ;
                SourceExpr="Phone No" }

    { 1120054006;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054007;2;Field  ;
                SourceExpr=Remarks }

    { 1120054025;2;Field  ;
                SourceExpr="Defaulter Grouping" }

    { 1120054008;1;Group  ;
                Name=Logs;
                GroupType=Group }

    { 1120054009;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054010;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054011;2;Field  ;
                SourceExpr="Marked By" }

    { 1120054012;2;Field  ;
                SourceExpr="Date Marked" }

    { 1120054013;2;Field  ;
                SourceExpr=Marked }

    { 1120054014;2;Field  ;
                SourceExpr=Stopped }

    { 1120054015;2;Field  ;
                SourceExpr="Date Stopped" }

    { 1120054016;2;Field  ;
                SourceExpr="Stopped By" }

    { 1120054017;2;Field  ;
                SourceExpr="Date Remarked" }

    { 1120054018;2;Field  ;
                SourceExpr="Remarked By" }

    { 1120054024;1;Part   ;
                SubPageLink=Client Code=FIELD(Member No),
                            Outstanding Balance=FILTER(>0);
                PagePartID=Page51516250;
                PartType=Page }

  }
  CODE
  {
    VAR
      MarkActive@1120054000 : Boolean INDATASET;
      StopActive@1120054001 : Boolean INDATASET;
      RemarkActive@1120054002 : Boolean INDATASET;

    BEGIN
    END.
  }
}

