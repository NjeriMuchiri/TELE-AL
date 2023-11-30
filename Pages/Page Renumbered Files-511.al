OBJECT page 172106 Profitability Analysis
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=10:45:50 PM;
    Modified=Yes;
    Version List=Micro FinanceV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516432;
    PageType=List;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr=Code }

    { 1000000006;2;Field  ;
                SourceExpr=Amount }

    { 1000000003;2;Field  ;
                SourceExpr=Description }

    { 1000000004;2;Field  ;
                SourceExpr="Code Type" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

