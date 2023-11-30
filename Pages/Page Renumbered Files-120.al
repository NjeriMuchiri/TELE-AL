OBJECT page 20461 Open HR Meeting Rooms
{
  OBJECT-PROPERTIES
  {
    Date=10/28/20;
    Time=[ 3:00:39 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516165;
    SourceTableView=WHERE(Status=CONST(Open));
    PageType=List;
    CardPageID=HR Meeting Rooms Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr=No }

    { 1120054003;2;Field  ;
                SourceExpr=Room }

    { 1120054004;2;Field  ;
                SourceExpr="Meeting Description" }

    { 1120054005;2;Field  ;
                SourceExpr="Start Date" }

    { 1120054006;2;Field  ;
                SourceExpr="End Date" }

    { 1120054007;2;Field  ;
                SourceExpr="Start Time" }

    { 1120054008;2;Field  ;
                SourceExpr="End Time" }

    { 1120054009;2;Field  ;
                SourceExpr=Status }

  }
  CODE
  {

    BEGIN
    END.
  }
}

