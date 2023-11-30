OBJECT page 17416 Paybill Processing Line
{
  OBJECT-PROPERTIES
  {
    Date=10/25/15;
    Time=12:24:59 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516271;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755028;2;Field  ;
                SourceExpr="Receipt Line No" }

    { 1102755015;2;Field  ;
                SourceExpr="Trans Type" }

    { 1102755025;2;Field  ;
                SourceExpr="Member No" }

    { 1102755012;2;Field  ;
                SourceExpr=Name }

    { 1000000002;2;Field  ;
                SourceExpr="Mobile No" }

    { 1102755026;2;Field  ;
                SourceExpr="ID No." }

    { 1102755020;2;Field  ;
                SourceExpr="Loan No" }

    { 1000000003;2;Field  ;
                SourceExpr="Transaction No" }

    { 1102755003;2;Field  ;
                SourceExpr=Amount }

    { 1000000000;2;Field  ;
                SourceExpr="Staff Not Found" }

    { 1000000001;2;Field  ;
                SourceExpr="Member Found" }

    { 1102755004;2;Field  ;
                SourceExpr="Search Index" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

