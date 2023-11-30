OBJECT page 172162 Messages List
{
  OBJECT-PROPERTIES
  {
    Date=10/06/20;
    Time=10:58:10 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516893;
    SourceTableView=WHERE(Sent=CONST(No));
    PageType=List;
    CardPageID=Messages Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054006;2;Field  ;
                SourceExpr="Entry No" }

    { 1120054007;2;Field  ;
                SourceExpr="Inserted By" }

    { 1120054008;2;Field  ;
                SourceExpr="Inserted On" }

    { 1120054003;2;Field  ;
                SourceExpr="Individual Member No" }

    { 1120054004;2;Field  ;
                SourceExpr=Employer }

    { 1120054002;2;Field  ;
                SourceExpr="SMS Message" }

    { 1120054005;2;Field  ;
                SourceExpr=Sent;
                Editable=false }

  }
  CODE
  {

    BEGIN
    END.
  }
}

