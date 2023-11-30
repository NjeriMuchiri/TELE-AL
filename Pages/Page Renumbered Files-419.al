OBJECT page 172014 Treasury Denominations
{
  OBJECT-PROPERTIES
  {
    Date=05/11/16;
    Time=[ 5:41:31 PM];
    Modified=Yes;
    Version List=CBS;
  }
  PROPERTIES
  {
    Editable=Yes;
    SourceTable=Table51516302;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       {Overdue := Overdue::" ";
                       IF FormatField(Rec) THEN
                         Overdue := Overdue::Yes;}
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1000000001;2;Field  ;
                SourceExpr=No;
                Enabled=FALSE;
                Editable=FALSE }

    { 1102756013;2;Field  ;
                SourceExpr=Code;
                Enabled=TRUE;
                Editable=TRUE }

    { 1000000025;2;Field  ;
                SourceExpr=Description;
                Enabled=TRUE;
                Editable=FALSE }

    { 1000000011;2;Field  ;
                SourceExpr=Type;
                Enabled=true }

    { 1102755000;2;Field  ;
                SourceExpr=Value;
                Enabled=true }

    { 1102755002;2;Field  ;
                SourceExpr=Quantity }

    { 1102755004;2;Field  ;
                SourceExpr="Total Amount";
                Enabled=FALSE }

  }
  CODE
  {

    PROCEDURE GetVariables@1000000000(VAR LoanNo@1000000000 : Code[20];VAR LoanProductType@1000000001 : Code[20]);
    BEGIN
      {LoanNo:="Loan  No.";
      LoanProductType:="Loan Product Type"; }
    END;

    BEGIN
    END.
  }
}

