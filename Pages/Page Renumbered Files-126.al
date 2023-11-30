OBJECT page 20467 Finalized Staff Movement List
{
  OBJECT-PROPERTIES
  {
    Date=10/27/20;
    Time=12:28:22 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516164;
    SourceTableView=WHERE(Finalized=CONST(Yes));
    PageType=List;
    CardPageID=HR Staff Movement Card;
    OnOpenPage=BEGIN
                 SETRANGE("Captured By",USERID)
               END;

  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr=No }

    { 1120054003;2;Field  ;
                SourceExpr="Staff No" }

    { 1120054004;2;Field  ;
                SourceExpr="Staff Name" }

    { 1120054005;2;Field  ;
                SourceExpr=Category }

    { 1120054006;2;Field  ;
                SourceExpr=Purpose }

    { 1120054007;2;Field  ;
                SourceExpr=Location }

    { 1120054008;2;Field  ;
                SourceExpr="Start Date" }

    { 1120054009;2;Field  ;
                SourceExpr="End date" }

    { 1120054010;2;Field  ;
                SourceExpr="Start Time" }

    { 1120054011;2;Field  ;
                SourceExpr="End Time" }

    { 1120054012;2;Field  ;
                SourceExpr="Back in Office On" }

    { 1120054013;2;Field  ;
                SourceExpr="Captured By" }

    { 1120054014;2;Field  ;
                SourceExpr="Datime Captured" }

    { 1120054015;2;Field  ;
                SourceExpr="Last DateTime Updated" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

