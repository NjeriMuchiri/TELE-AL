OBJECT page 172180 DIvidends Progression History
{
  OBJECT-PROPERTIES
  {
    Date=01/20/23;
    Time=[ 3:47:24 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516921;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054012;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054011;1 ;ActionGroup;
                      CaptionML=ENU=Reset;
                      Image=Quote }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Member No" }

    { 1120054003;2;Field  ;
                SourceExpr=Date }

    { 1120054004;2;Field  ;
                SourceExpr="Gross Dividends" }

    { 1120054005;2;Field  ;
                SourceExpr="Witholding Tax" }

    { 1120054006;2;Field  ;
                SourceExpr="Net Dividends" }

    { 1120054007;2;Field  ;
                SourceExpr="Qualifying Shares" }

    { 1120054008;2;Field  ;
                SourceExpr=Shares }

    { 1120054009;2;Field  ;
                SourceExpr=Posted }

    { 1120054010;2;Field  ;
                SourceExpr="Deposit Type" }

  }
  CODE
  {
    VAR
      DividendsProgression@1120054000 : Record 51516252;
      Memb@1120054001 : Record 51516223;
      History@1120054002 : Record 51516728;
      EntryNo@1120054003 : Integer;
      DivHistory@1120054004 : Record 51516921;
      DividendsX@1120054005 : Record 51516252;

    BEGIN
    END.
  }
}

