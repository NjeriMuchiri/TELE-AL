OBJECT page 17379 Receipts list-BOSA
{
  OBJECT-PROPERTIES
  {
    Date=03/02/16;
    Time=[ 9:28:37 AM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516247;
    SourceTableView=WHERE(Posted=CONST(No));
    PageType=List;
    CardPageID=Receipts Header-BOSA;
    OnOpenPage=BEGIN
                  SETRANGE("User ID",USERID);
               END;

  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755011;2;Field  ;
                SourceExpr="Transaction No." }

    { 1102755002;2;Field  ;
                SourceExpr="Account No." }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755004;2;Field  ;
                SourceExpr="Cheque No." }

    { 1102755005;2;Field  ;
                SourceExpr="Employer No." }

    { 1102755006;2;Field  ;
                SourceExpr="User ID" }

    { 1102755007;2;Field  ;
                SourceExpr=Amount }

    { 1102755008;2;Field  ;
                SourceExpr=Posted }

    { 1102755009;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1102755010;2;Field  ;
                SourceExpr="Mode of Payment" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

