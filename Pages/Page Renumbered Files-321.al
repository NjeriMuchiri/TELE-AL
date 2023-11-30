OBJECT page 50012 BOSA Transfer List
{
  OBJECT-PROPERTIES
  {
    Date=02/03/23;
    Time=12:34:07 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516264;
    SourceTableView=WHERE(Posted=CONST(No));
    PageType=List;
    CardPageID=BOSA Transfer;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr=No }

    { 1000000003;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1000000004;2;Field  ;
                SourceExpr="Schedule Total" }

    { 1000000006;2;Field  ;
                SourceExpr="Approved By" }

    { 1000000010;2;Field  ;
                SourceExpr=Remarks }

  }
  CODE
  {

    BEGIN
    END.
  }
}

