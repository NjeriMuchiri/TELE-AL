OBJECT page 20419 RFQ Subform
{
  OBJECT-PROPERTIES
  {
    Date=04/13/18;
    Time=10:01:46 AM;
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    SourceTable=Table51516055;
    PageType=ListPart;
    ActionList=ACTIONS
    {
      { 1102755011;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755012;1 ;Action    ;
                      CaptionML=ENU=Purchase Quote Params;
                      OnAction=VAR
                                 PParams@1102755000 : Record 51516065;
                               BEGIN

                                 {PParams.RESET;
                                 PParams.SETRANGE(PParams."Document Type","Document Type");
                                 PParams.SETRANGE(PParams."Document No.","Line No.");
                                 PParams.SETRANGE(PParams."Line No.",Amount);
                                 PAGE.RUN(51516064,PParams);}
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000000;2;Field  ;
                SourceExpr=Type }

    { 1000000001;2;Field  ;
                SourceExpr="Expense Code" }

    { 1000000002;2;Field  ;
                SourceExpr="No." }

    { 1000000003;2;Field  ;
                SourceExpr=Description }

    { 1000000004;2;Field  ;
                SourceExpr="Unit of Measure" }

    { 1000000005;2;Field  ;
                SourceExpr=Quantity }

    { 1000000006;2;Field  ;
                SourceExpr="Direct Unit Cost" }

    { 1000000007;2;Field  ;
                SourceExpr=Amount }

    { 1000000008;2;Field  ;
                SourceExpr="PRF No" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

