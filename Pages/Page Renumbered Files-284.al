OBJECT page 17475 Credit Processor Role
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=10:55:47 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    CaptionML=ENU=Activities;
    SourceTable=Table51516236;
    PageType=CardPart;
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;

                 SETRANGE("FOSA Bank Account",0D,WORKDATE - 1);
                 SETFILTER("No of Loans",'>=%1',WORKDATE);
               END;

    ActionList=ACTIONS
    {
      { 1102755002;  ;ActionContainer;
                      Name=Bosa;
                      ActionContainerType=ActionItems }
      { 1102755003;1 ;Action    ;
                      Name=Loans Calculator;
                      RunObject=Page 50026 }
      { 1102755004;1 ;Action    ;
                      Name=Members  List;
                      RunObject=page 20464 }
      { 1102755012;1 ;Action    ;
                      Name=Bosa Loans;
                      RunObject=page 20473 }
      { 1102755014;  ;ActionGroup;
                      Name=[Fosa ];
                      ActionContainerType=RelatedInformation }
      { 1102755013;1 ;Action    ;
                      Name=Fosa Loans;
                      RunObject=page 17368 }
      { 1102755016;1 ;Action    ;
                      Name=Fosa Accounts;
                      RunObject=page 20496 }
    }
  }
  CONTROLS
  {
    { 1102755015;0;Container;
                ContainerType=ContentArea }

    { 1102755011;1;Group  ;
                CaptionML=ENU=Loan Activities;
                GroupType=CueGroup }

    { 1102755010;2;Field  ;
                SourceExpr="Description/Remarks";
                DrillDownPageID=Page50038 }

    { 1102755009;2;Field  ;
                SourceExpr=Posted }

    { 1102755008;2;Field  ;
                SourceExpr=Status }

    { 1102755007;2;Field  ;
                SourceExpr="Date Created" }

    { 1102755006;2;Field  ;
                SourceExpr="Prepared By" }

    { 1102755005;2;Field  ;
                SourceExpr=Date }

    { 1102755000;2;Field  ;
                SourceExpr="Post to Loan Control" }

    { 1102755001;2;Field  ;
                SourceExpr="Total Appeal Amount" }

    { 1102755017;2;Field  ;
                SourceExpr=Source }

  }
  CODE
  {

    BEGIN
    END.
  }
}

