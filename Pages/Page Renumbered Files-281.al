OBJECT page 17472 Fixed Deposit Interest Rates
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=10:52:52 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516306;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760003;2;Field  ;
                SourceExpr="Minimum Amount" }

    { 1102760001;2;Field  ;
                SourceExpr="Maximum Amount" }

    { 1102760005;2;Field  ;
                SourceExpr="Interest Rate" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

