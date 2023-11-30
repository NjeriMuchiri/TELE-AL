OBJECT page 50026 Teller Requested list
{
  OBJECT-PROPERTIES
  {
    Date=11/14/18;
    Time=[ 1:20:08 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516016;
    SourceTableView=WHERE(Cashier=FILTER(Yes),
                          Field12=FILTER(No));
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054014;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054011;1 ;ActionGroup;
                      CaptionML=ENU=Loan;
                      Image=AnalysisView }
      { 1120054012;2 ;Action    ;
                      Name=Mark as issued;
                      CaptionML=ENU=Mark as isssued;
                      Promoted=Yes;
                      Enabled=true;
                      Image=Aging;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                  TellerTill.RESET;
                                  TellerTill.SETRANGE(TellerTill."Account Type",TellerTill."Account Type"::Cashier);
                                  //TellerTill.SETRANGE(TellerTill."Cashier ID",USERID);
                                  IF TellerTill.FIND('-') THEN BEGIN
                                    issued:=TRUE;
                                   "Issued  by":=USERID;
                                   "Issued Date":=TODAY;
                                   "Issued Time":=TIME;
                                   MODIFY;
                                   END;


                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054001;0;Container;
                ContainerType=ContentArea }

    { 1120054000;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="No.";
                Editable=false }

    { 1120054003;2;Field  ;
                SourceExpr=Date;
                Editable=false }

    { 1120054004;2;Field  ;
                CaptionML=ENU=<Amount requested>;
                SourceExpr="Currency Factor";
                Editable=false }

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
                CaptionML=ENU=<Amount to issue>;
                SourceExpr=Payee;
                Editable=true }

  }
  CODE
  {
    VAR
      TellerTill@1120054000 : Record 270;

    BEGIN
    END.
  }
}

