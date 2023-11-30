OBJECT page 172190 Debt Change Card
{
  OBJECT-PROPERTIES
  {
    Date=10/03/22;
    Time=[ 4:54:35 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516925;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054010;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 1120054009;1 ;ActionGroup }
      { 1120054008;2 ;Action    ;
                      Name=Tranfer Loans;
                      RunObject=Report 50074;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to transfer this loans?',TRUE,FALSE)=TRUE THEN BEGIN
                                 Collectors.RESET;
                                 Collectors.SETRANGE(Collectors."Change No","Change No");
                                 Collectors.SETRANGE(Collectors.Selected,TRUE);
                                 IF Collectors.FINDFIRST THEN BEGIN
                                 REPEAT
                                 LoanRegister.RESET;
                                 LoanRegister.SETRANGE(LoanRegister."Loan  No.",Collectors."Loan Number");
                                 IF LoanRegister.FINDFIRST THEN BEGIN
                                 LoanRegister."Debt Collectors Name":="Change No";
                                 LoanRegister.MODIFY;
                                 END;
                                 UNTIL Collectors.NEXT=0;
                                 END;
                                 Posted:=TRUE;
                                 MODIFY;
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
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="Change No" }

    { 1120054003;2;Field  ;
                SourceExpr="Collector Code" }

    { 1120054004;2;Field  ;
                SourceExpr="Collector Name" }

    { 1120054005;2;Field  ;
                SourceExpr="New Collector Code" }

    { 1120054006;2;Field  ;
                SourceExpr="New Colllector Name" }

    { 1120054007;1;Part   ;
                Name=Collector Loans;
                SubPageLink=Change No=FIELD(Change No),
                            Debt Collector=FIELD(Collector Name);
                PagePartID=Page51516929;
                PartType=Page }

  }
  CODE
  {
    VAR
      LoanRegister@1120054003 : Record 51516230;
      Collectors@1120054002 : Record 51516924;
      EntryNo@1120054001 : Integer;
      DebtCollectors@1120054000 : Record 51516918;

    BEGIN
    END.
  }
}

