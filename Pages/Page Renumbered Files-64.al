OBJECT page 20428 CloudPESA PIN RESET
{
  OBJECT-PROPERTIES
  {
    Date=11/28/19;
    Time=[ 1:09:17 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516521;
    PageType=List;
    CardPageID=CloudPESA PIN Reset Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="No." }

    { 1120054003;2;Field  ;
                SourceExpr="Account No" }

    { 1120054004;2;Field  ;
                SourceExpr="Account Name" }

    { 1120054005;2;Field  ;
                SourceExpr=Telephone }

    { 1120054006;2;Field  ;
                SourceExpr="ID No" }

    { 1120054007;2;Field  ;
                SourceExpr=Status }

    { 1120054008;2;Field  ;
                SourceExpr="Created By" }

    { 1120054009;2;Field  ;
                SourceExpr=SentToServer }

    { 1120054011;2;Field  ;
                SourceExpr="Reset By" }

    { 1120054012;2;Field  ;
                SourceExpr="Last PIN Reset" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

