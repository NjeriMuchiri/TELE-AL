OBJECT page 50067 Imprest Details
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=[ 7:50:30 AM];
    Modified=Yes;
    Version List=FUNDS.;
  }
  PROPERTIES
  {
    SourceTable=Table51516007;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="Document Type" }

    { 1102755003;2;Field  ;
                SourceExpr="Document No";
                Visible=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr="Account No" }

    { 1102755005;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Based on Rates";
                Visible=false }

    { 1102755007;2;Field  ;
                SourceExpr="Destination Code";
                Visible=false }

    { 1102755008;2;Field  ;
                SourceExpr="No. of Days";
                Visible=false }

    { 1102755009;2;Field  ;
                SourceExpr="Daily Rate(Amount)";
                Visible=false }

    { 1102755010;2;Field  ;
                SourceExpr=Amount }

    { 1102755011;2;Field  ;
                SourceExpr="Imprest Holder" }

    { 1102755012;2;Field  ;
                SourceExpr="Due Date" }

    { 1102755013;2;Field  ;
                SourceExpr=Purpose }

  }
  CODE
  {

    BEGIN
    END.
  }
}

