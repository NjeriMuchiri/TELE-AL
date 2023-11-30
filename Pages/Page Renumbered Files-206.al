OBJECT page 17397 BOSA Receipts List
{
  OBJECT-PROPERTIES
  {
    Date=11/02/15;
    Time=11:56:45 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516247;
    SourceTableView=WHERE(Posted=FILTER(No));
    PageType=List;
    CardPageID=BOSA Receipt Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755008;2;Field  ;
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

    { 1102755009;2;Field  ;
                SourceExpr=Posted }

  }
  CODE
  {

    BEGIN
    END.
  }
}

