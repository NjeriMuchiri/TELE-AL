OBJECT page 17381 Receipt Allocation-BOSA
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=[ 3:22:24 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516246;
    PageType=Card;
    OnOpenPage=BEGIN
                   sto.RESET;
                   sto.SETRANGE(sto."No.","Document No");
                   IF sto.FIND('-') THEN BEGIN
                   IF sto.Status=sto.Status::Approved THEN BEGIN
                   CurrPage.EDITABLE:=FALSE;
                   END ELSE
                   CurrPage.EDITABLE:=TRUE;
                   END;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102755003;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1102760003;2;Field  ;
                SourceExpr="Loan No." }

    { 1102760005;2;Field  ;
                SourceExpr=Amount }

    { 1102760007;2;Field  ;
                SourceExpr="Interest Amount" }

    { 1102760009;2;Field  ;
                SourceExpr="Total Amount" }

    { 1102760014;2;Field  ;
                SourceExpr="Amount Balance";
                Editable=TRUE }

    { 1102760016;2;Field  ;
                SourceExpr="Interest Balance";
                Editable=FALSE }

    { 1102755000;2;Field  ;
                SourceExpr="Prepayment Date" }

    { 1000000000;2;Field  ;
                SourceExpr="Loan Insurance" }

    { 1102755001;2;Field  ;
                SourceExpr="Global Dimension 1 Code" }

    { 1102755002;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

  }
  CODE
  {
    VAR
      sto@1102755000 : Record 51516307;
      Loan@1000000000 : Record 51516230;
      ReceiptAllocation@1102755001 : Record 51516246;

    BEGIN
    END.
  }
}

