OBJECT page 17464 Front Office Charges
{
  OBJECT-PROPERTIES
  {
    Date=03/29/16;
    Time=11:09:48 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516300;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1000000014;0;Container;
                ContainerType=ContentArea }

    { 1000000013;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000012;2;Field  ;
                SourceExpr="Charge Code" }

    { 1000000011;2;Field  ;
                SourceExpr=Description }

    { 1000000010;2;Field  ;
                SourceExpr="Charge Amount" }

    { 1000000009;2;Field  ;
                SourceExpr="Percentage of Amount" }

    { 1000000008;2;Field  ;
                SourceExpr="Use Percentage" }

    { 1000000007;2;Field  ;
                SourceExpr="G/L Account" }

    { 1000000006;2;Field  ;
                SourceExpr="Minimum Amount" }

    { 1000000005;2;Field  ;
                SourceExpr="Maximum Amount" }

    { 1000000004;2;Field  ;
                SourceExpr="Due Amount" }

    { 1000000003;2;Field  ;
                SourceExpr="Due to Account" }

    { 1000000002;2;Field  ;
                SourceExpr="Charge Type" }

    { 1000000001;2;Field  ;
                SourceExpr="Staggered Charge Code" }

    { 1000000000;2;Field  ;
                SourceExpr="Stamp Duty" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

