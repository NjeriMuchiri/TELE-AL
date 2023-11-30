OBJECT page 172048 SMS Charges
{
  OBJECT-PROPERTIES
  {
    Date=08/17/21;
    Time=12:39:14 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516554;
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
                SourceExpr="Charge Code" }

    { 1000000003;2;Field  ;
                SourceExpr=Source }

    { 1000000004;2;Field  ;
                SourceExpr=Amount }

    { 1000000005;2;Field  ;
                SourceExpr="Charge Account" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

