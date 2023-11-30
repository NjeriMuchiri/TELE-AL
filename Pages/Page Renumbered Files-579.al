OBJECT page 172174 Defaulter Notifications List
{
  OBJECT-PROPERTIES
  {
    Date=10/30/20;
    Time=10:55:46 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516355;
    SourceTableView=WHERE(Marked=CONST(No));
    PageType=List;
    CardPageID=Member Defaulter Notification;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Member No" }

    { 1120054003;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054004;2;Field  ;
                SourceExpr="ID No" }

    { 1120054005;2;Field  ;
                SourceExpr="Phone No" }

    { 1120054006;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054007;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054008;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054009;2;Field  ;
                SourceExpr=Remarks }

  }
  CODE
  {

    BEGIN
    END.
  }
}

