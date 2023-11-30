OBJECT page 50025 Teller request card
{
  OBJECT-PROPERTIES
  {
    Date=11/14/18;
    Time=[ 2:58:11 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516016;
    SourceTableView=WHERE(Cashier=FILTER(No),
                          Field12=FILTER(No));
    ActionList=ACTIONS
    {
      { 1120054013;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054012;1 ;ActionGroup;
                      CaptionML=ENU=Loan;
                      Image=AnalysisView }
      { 1120054011;2 ;Action    ;
                      Name=Request;
                      CaptionML=ENU=Request;
                      Promoted=Yes;
                      Enabled=true;
                      Image=Aging;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MESSAGE('Successfully requested');
                                 IF Cashier=TRUE THEN
                                   ERROR('You have already requested');
                                   Cashier:=TRUE;
                                   MODIFY;



                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054001;0;Container;
                ContainerType=ContentArea }

    { 1120054000;1;Group  ;
                CaptionML=ENU=General }

    { 1120054002;2;Field  ;
                SourceExpr="No.";
                Editable=false }

    { 1120054003;2;Field  ;
                SourceExpr=Date;
                Editable=false }

    { 1120054004;2;Field  ;
                SourceExpr="Currency Factor" }

    { 1120054005;2;Field  ;
                SourceExpr="Currency Code";
                Editable=false }

    { 1120054006;2;Field  ;
                SourceExpr="Requested Time";
                Editable=false }

    { 1120054007;2;Field  ;
                SourceExpr="Issued  by";
                Editable=false }

    { 1120054008;2;Field  ;
                SourceExpr="Issued Date";
                Editable=false }

    { 1120054009;2;Field  ;
                SourceExpr="Issued Time";
                Editable=false }

    { 1120054010;2;Field  ;
                SourceExpr=Payee;
                Editable=false }

  }
  CODE
  {
    VAR
      TellerTill@1120054000 : Record 270;

    BEGIN
    END.
  }
}

