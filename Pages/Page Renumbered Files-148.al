OBJECT page 20489 HR Leave Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=11/06/20;
    Time=10:03:19 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Leave Ledger Entries;
    SourceTable=Table51516201;
    DataCaptionFields=Leave Period;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 38      ;1   ;ActionGroup;
                      CaptionML=ENU=Ent&ry }
      { 39      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      RunObject=Page 544 }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 35      ;1   ;Action    ;
                      CaptionML=ENU=&Navigate;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
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
                SourceExpr="Posting Date" }

    { 1102755000;2;Field  ;
                SourceExpr="Leave Period" }

    { 1102755002;2;Field  ;
                SourceExpr="Staff No." }

    { 1102755006;2;Field  ;
                SourceExpr="Staff Name" }

    { 1102755014;2;Field  ;
                SourceExpr="Leave Type" }

    { 1102755004;2;Field  ;
                SourceExpr="Leave Entry Type" }

    { 1102755010;2;Field  ;
                SourceExpr="No. of days" }

    { 1102755008;2;Field  ;
                SourceExpr="Leave Posting Description" }

  }
  CODE
  {
    VAR
      Navigate@1000 : Page 344;

    BEGIN
    END.
  }
}

