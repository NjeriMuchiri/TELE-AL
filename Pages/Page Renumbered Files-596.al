OBJECT page 172191 Debt Colectors Loans Change
{
  OBJECT-PROPERTIES
  {
    Date=09/23/22;
    Time=12:34:28 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516924;
    PageType=ListPart;
    ActionList=ACTIONS
    {
      { 1120054012;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 1120054005;1 ;ActionGroup }
      { 1120054004;1 ;Action    ;
                      Name=Tranfer Loans;
                      RunObject=Report 50074 }
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
                SourceExpr="Loan Number" }

    { 1120054007;2;Field  ;
                SourceExpr="Client Code" }

    { 1120054008;2;Field  ;
                SourceExpr="CLient Name" }

    { 1120054003;2;Field  ;
                SourceExpr="Debt Collector" }

    { 1120054009;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054010;2;Field  ;
                SourceExpr="Outstanding Interest" }

    { 1120054006;2;Field  ;
                SourceExpr=Selected }

  }
  CODE
  {

    BEGIN
    END.
  }
}

