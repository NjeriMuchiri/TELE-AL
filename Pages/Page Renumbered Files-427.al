OBJECT page 172022 Posted Guar Recovery List
{
  OBJECT-PROPERTIES
  {
    Date=06/13/18;
    Time=[ 3:20:34 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516390;
    SourceTableView=WHERE(Posted=FILTER(Yes));
    PageType=List;
    CardPageID=Posted Guar Recovery Header;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="Document No" }

    { 1000000003;2;Field  ;
                SourceExpr="Member No" }

    { 1000000004;2;Field  ;
                SourceExpr="Member Name" }

    { 1000000005;2;Field  ;
                SourceExpr="Application Date" }

    { 1000000008;2;Field  ;
                SourceExpr="Created By" }

    { 1000000009;2;Field  ;
                SourceExpr="Personal No" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

