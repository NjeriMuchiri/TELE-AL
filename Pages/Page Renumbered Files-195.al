OBJECT page 17386 Loan Collateral Security
{
  OBJECT-PROPERTIES
  {
    Date=01/06/16;
    Time=[ 1:51:11 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516233;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102756000;1;Group  ;
                GroupType=Repeater }

    { 1102755000;2;Field  ;
                SourceExpr=Code }

    { 1102756001;2;Field  ;
                SourceExpr=Type }

    { 1102756003;2;Field  ;
                SourceExpr="Security Details" }

    { 1102756009;2;Field  ;
                SourceExpr=Value }

    { 1102755009;2;Field  ;
                SourceExpr="Account No" }

    { 1102755002;2;Field  ;
                SourceExpr=Category }

    { 1102756007;2;Field  ;
                SourceExpr="Guarantee Value" }

    { 1102755006;2;Field  ;
                SourceExpr="View Document";
                Editable=FALSE }

    { 1102756005;2;Field  ;
                SourceExpr=Remarks }

    { 1102755004;2;Field  ;
                SourceExpr="Collateral Multiplier" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

