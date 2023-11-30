OBJECT page 17353 Transaction charges fosa
{
  OBJECT-PROPERTIES
  {
    Date=08/17/20;
    Time=10:54:53 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516300;
    PageType=List;
    CardPageID=transaction charges;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054003;2;Field  ;
                SourceExpr="Charge Code" }

    { 1120054004;2;Field  ;
                SourceExpr=Description }

    { 1120054005;2;Field  ;
                SourceExpr="Charge Amount" }

    { 1120054006;2;Field  ;
                SourceExpr="Percentage of Amount" }

    { 1120054007;2;Field  ;
                SourceExpr="Use Percentage" }

    { 1120054008;2;Field  ;
                SourceExpr="G/L Account" }

    { 1120054009;2;Field  ;
                SourceExpr="Charge Type" }

    { 1120054010;2;Field  ;
                SourceExpr="Between 100 and 5000" }

    { 1120054011;2;Field  ;
                SourceExpr="Between 5001 - 10000" }

    { 1120054012;2;Field  ;
                SourceExpr="Between 10001 - 30001" }

    { 1120054013;2;Field  ;
                SourceExpr="Between 30001 - 50000" }

    { 1120054014;2;Field  ;
                SourceExpr="Between 50001 - 100000" }

    { 1120054015;2;Field  ;
                SourceExpr="Between 100001 - 200000" }

    { 1120054016;2;Field  ;
                SourceExpr="Between 200001 - 500000" }

    { 1120054017;2;Field  ;
                SourceExpr="Between 500001 Above" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

