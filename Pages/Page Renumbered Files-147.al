OBJECT page 20488 HR Leave Jnl. Template List
{
  OBJECT-PROPERTIES
  {
    Date=11/06/20;
    Time=[ 3:52:28 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=ENU=Leave Jnl. Template List;
    SourceTable=Table51516195;
    PageType=List;
    PromotedActionCategoriesML=ENU=New,Process,Report,Template;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755000;1 ;ActionGroup;
                      CaptionML=ENU=Template }
      { 1102755001;2 ;Action    ;
                      CaptionML=ENU=&Batches;
                      RunObject=page 172137;
                      RunPageLink=Journal Template Name=FIELD(Name);
                      Promoted=Yes;
                      Image=ChangeBatch;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                SourceExpr=Description }

    { 1102755004;2;Field  ;
                SourceExpr="Source Code" }

    { 16  ;2   ;Field     ;
                SourceExpr="Reason Code";
                Visible=TRUE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

