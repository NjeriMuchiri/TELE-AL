OBJECT page 17482 Charges - FOSA
{
  OBJECT-PROPERTIES
  {
    Date=08/17/20;
    Time=10:53:56 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516297;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr=Code }

    { 1102760003;2;Field  ;
                SourceExpr=Description }

    { 1102760005;2;Field  ;
                SourceExpr="Charge Amount" }

    { 1102760017;2;Field  ;
                SourceExpr="Charge Type" }

    { 1102760009;2;Field  ;
                SourceExpr="Use Percentage" }

    { 1102760007;2;Field  ;
                SourceExpr="Percentage of Amount" }

    { 1102760013;2;Field  ;
                SourceExpr=Minimum }

    { 1102760015;2;Field  ;
                SourceExpr=Maximum }

    { 1102760011;2;Field  ;
                SourceExpr="GL Account" }

    { 1120054000;2;Field  ;
                SourceExpr="Between 100 and 5000" }

    { 1120054001;2;Field  ;
                SourceExpr="Between 5001 - 10000" }

    { 1120054002;2;Field  ;
                SourceExpr="Between 10001 - 30000" }

    { 1120054003;2;Field  ;
                SourceExpr="Between 30001 - 50000" }

    { 1120054004;2;Field  ;
                SourceExpr="Between 50001 - 100000" }

    { 1120054005;2;Field  ;
                SourceExpr="Between 100001 - 200000" }

    { 1120054006;2;Field  ;
                SourceExpr="Between 200001 - 500000" }

    { 1120054007;2;Field  ;
                SourceExpr="Between 500001 Above" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

