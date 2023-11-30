OBJECT page 20447 HR Medical Schemes Card
{
  OBJECT-PROPERTIES
  {
    Date=02/26/18;
    Time=[ 3:39:06 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516109;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 3       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=ENU=&Functions }
      { 1       ;2   ;Action    ;
                      CaptionML=ENU=Medical Scheme Members;
                      RunObject=page 17426;
                      Promoted=Yes;
                      Image=PersonInCharge;
                      PromotedCategory=Category4 }
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
                SourceExpr="Scheme No" }

    { 1102755003;2;Field  ;
                SourceExpr="Medical Insurer" }

    { 1102755004;2;Field  ;
                SourceExpr="Scheme Name" }

    { 1102755005;2;Field  ;
                SourceExpr="In-patient limit";
                Visible=false }

    { 1102755006;2;Field  ;
                SourceExpr="Out-patient limit";
                Visible=false }

    { 1102755007;2;Field  ;
                SourceExpr="Area Covered";
                Visible=false }

    { 1102755008;2;Field  ;
                SourceExpr="Dependants Included" }

    { 1102755009;2;Field  ;
                SourceExpr=Comments }

  }
  CODE
  {

    BEGIN
    END.
  }
}

