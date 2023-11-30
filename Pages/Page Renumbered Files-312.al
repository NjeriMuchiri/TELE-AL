OBJECT page 50003 Other Commitment Clearance
{
  OBJECT-PROPERTIES
  {
    Date=05/11/16;
    Time=[ 3:53:21 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516262;
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
                SourceExpr=Payee }

    { 1000000003;2;Field  ;
                SourceExpr="Bankers Cheque No" }

    { 1000000004;2;Field  ;
                SourceExpr=Description }

    { 1000000005;2;Field  ;
                SourceExpr=Amount }

  }
  CODE
  {

    BEGIN
    END.
  }
}

