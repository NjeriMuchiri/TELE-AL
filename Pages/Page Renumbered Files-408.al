OBJECT page 172003 Shares Transfer List
{
  OBJECT-PROPERTIES
  {
    Date=11/30/20;
    Time=[ 3:50:06 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516169;
    SourceTableView=WHERE(Status=FILTER(Open|Pending|Approved));
    PageType=List;
    CardPageID=Shares Transfer Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr=Code }

    { 1120054003;2;Field  ;
                SourceExpr=Type }

    { 1120054004;2;Field  ;
                SourceExpr="Member No." }

    { 1120054005;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054006;2;Field  ;
                SourceExpr="Staff No" }

    { 1120054007;2;Field  ;
                SourceExpr="Employer code" }

    { 1120054008;2;Field  ;
                SourceExpr="Trade To Member No" }

    { 1120054009;2;Field  ;
                SourceExpr="Trade To Member Name" }

    { 1120054010;2;Field  ;
                SourceExpr="Trade To Staff No" }

    { 1120054011;2;Field  ;
                SourceExpr="Trade To Employer Code" }

    { 1120054012;2;Field  ;
                SourceExpr="Created On" }

    { 1120054013;2;Field  ;
                SourceExpr=Status }

  }
  CODE
  {

    BEGIN
    END.
  }
}

