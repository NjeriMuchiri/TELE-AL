OBJECT page 17481 ATM Transactions
{
  OBJECT-PROPERTIES
  {
    Date=11/28/19;
    Time=[ 1:16:44 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516323;
    PageType=List;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="Trace ID" }

    { 1000000003;2;Field  ;
                SourceExpr="Posting Date" }

    { 1000000024;2;Field  ;
                SourceExpr="Customer Names" }

    { 1000000004;2;Field  ;
                SourceExpr="Account No" }

    { 1000000005;2;Field  ;
                SourceExpr=Description }

    { 1000000006;2;Field  ;
                SourceExpr=Amount }

    { 1000000007;2;Field  ;
                SourceExpr="Posting S" }

    { 1000000008;2;Field  ;
                SourceExpr=Posted }

    { 1000000009;2;Field  ;
                SourceExpr="Unit ID" }

    { 1000000010;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1000000011;2;Field  ;
                SourceExpr="Trans Time" }

    { 1000000012;2;Field  ;
                SourceExpr="Transaction Time" }

    { 1000000013;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1000000014;2;Field  ;
                SourceExpr=Source }

    { 1000000015;2;Field  ;
                SourceExpr=Reversed }

    { 1000000016;2;Field  ;
                SourceExpr="Reversed Posted" }

    { 1000000017;2;Field  ;
                SourceExpr="Reversal Trace ID" }

    { 1000000018;2;Field  ;
                SourceExpr="Transaction Description" }

    { 1000000019;2;Field  ;
                SourceExpr="Withdrawal Location" }

    { 1000000020;2;Field  ;
                SourceExpr="Entry No" }

    { 1000000021;2;Field  ;
                SourceExpr="Transaction Type Charges" }

    { 1000000022;2;Field  ;
                SourceExpr="Card Acceptor Terminal ID" }

    { 1000000023;2;Field  ;
                SourceExpr="ATM Card No" }

    { 1000000025;2;Field  ;
                SourceExpr="Process Code" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

