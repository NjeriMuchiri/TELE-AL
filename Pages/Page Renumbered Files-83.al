OBJECT page 20424 DIvidends Progression
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=[ 1:46:41 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516252;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054012;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054011;1 ;ActionGroup;
                      CaptionML=ENU=Reset;
                      Image=Quote }
      { 1120054010;2 ;Action    ;
                      Name=Reset;
                      ShortCutKey=F7;
                      CaptionML=ENU=Clear Entries;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DividendsProgression.RESET;
                                 IF DividendsProgression.FINDSET THEN BEGIN
                                     DividendsProgression.DELETEALL;
                                 END;

                                 MESSAGE('Done');
                               END;
                                }
      { 1120054014;2 ;Action    ;
                      Name=Mark Dividends As Posted;
                      ShortCutKey=F7;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //DividendsX.SETRANGE(Date,CALCDATE('-CY-1Y',TODAY),CALCDATE('-CY-1D',TODAY));
                                 IF DividendsX.FINDFIRST THEN
                                 BEGIN
                                 REPEAT
                                 DivHistory.INIT;
                                 DivHistory."Member No":=DividendsX."Member No";
                                 DivHistory.Date:=DividendsX.Date;
                                 DivHistory."Gross Dividends":=DividendsX."Gross Dividends";
                                 DivHistory."Witholding Tax":=DividendsX."Witholding Tax";
                                 DivHistory."Net Dividends":=DividendsX."Net Dividends";
                                 DivHistory."Qualifying Shares":=DividendsX."Qualifying Shares";
                                 DivHistory.Shares:=DividendsX.Shares;
                                 DivHistory.Posted:=DividendsX.Posted;
                                 DivHistory."Deposit Type":=DividendsX."Deposit Type";
                                 DivHistory.Year:=DividendsX.Year;
                                 DivHistory.INSERT(TRUE);

                                 UNTIL DividendsX.NEXT=0;
                                 MESSAGE('History tranffered.');
                                 END;
                               END;
                                }
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

    { 1120054013;2;Field  ;
                SourceExpr="Deposit Type" }

    { 1120054015;2;Field  ;
                SourceExpr="Total Net Dividends" }

    { 1120054016;2;Field  ;
                SourceExpr="Interest Capitalizing Amount" }

    { 1120054017;2;Field  ;
                SourceExpr="Total Int Capitalizing Amount" }

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

