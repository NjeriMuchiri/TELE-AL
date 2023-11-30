OBJECT page 50024 Teller Fund requests
{
  OBJECT-PROPERTIES
  {
    Date=11/14/18;
    Time=[ 3:54:08 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516301;
    SourceTableView=WHERE(requested=FILTER(Yes));
    PageType=List;
    CardPageID=Teller & Treasury Trans Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=No }

    { 1102755003;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1102755004;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1102755005;2;Field  ;
                SourceExpr="From Account" }

    { 1102755006;2;Field  ;
                SourceExpr="To Account" }

    { 1102755007;2;Field  ;
                SourceExpr=Amount }

    { 1102755008;2;Field  ;
                SourceExpr=Posted }

    { 1102755009;2;Field  ;
                SourceExpr=Description }

  }
  CODE
  {

    BEGIN
    END.
  }
}

