OBJECT page 17468 ATM Charges
{
  OBJECT-PROPERTIES
  {
    Date=05/08/16;
    Time=[ 4:03:32 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516327;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102756000;1;Group  ;
                GroupType=Repeater }

    { 1102756001;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1102756003;2;Field  ;
                SourceExpr="Total Amount" }

    { 1102756005;2;Field  ;
                SourceExpr="Sacco Amount" }

    { 1000000000;2;Field  ;
                SourceExpr="Atm Bank Settlement A/C" }

    { 1000000001;2;Field  ;
                SourceExpr="Atm Income A/c" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

