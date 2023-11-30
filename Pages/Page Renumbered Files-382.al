OBJECT page 50073 BOSA Transfer Posted
{
  OBJECT-PROPERTIES
  {
    Date=10/27/16;
    Time=[ 5:05:15 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516264;
    SourceTableView=WHERE(Posted=CONST(Yes));
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

    { 1000000005;2;Field  ;
                SourceExpr=Approved }

    { 1000000006;2;Field  ;
                SourceExpr="Approved By" }

    { 1000000007;2;Field  ;
                SourceExpr=Posted }

    { 1000000008;2;Field  ;
                SourceExpr="No. Series" }

    { 1000000009;2;Field  ;
                SourceExpr="Responsibility Center" }

    { 1000000010;2;Field  ;
                SourceExpr=Remarks }

  }
  CODE
  {

    BEGIN
    END.
  }
}

