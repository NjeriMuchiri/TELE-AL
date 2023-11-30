OBJECT page 172035 SurePESA Applications
{
  OBJECT-PROPERTIES
  {
    Date=05/30/19;
    Time=[ 5:51:36 PM];
    Modified=Yes;
    Version List=SurePESA;
  }
  PROPERTIES
  {
    Editable=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516521;
    PageType=List;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="Account No" }

    { 1000000003;2;Field  ;
                SourceExpr="Account Name" }

    { 1000000004;2;Field  ;
                SourceExpr=Telephone }

    { 1000000005;2;Field  ;
                SourceExpr="ID No" }

    { 1000000007;2;Field  ;
                SourceExpr=Status }

    { 1120054000;2;Field  ;
                SourceExpr=SentToServer }

  }
  CODE
  {

    BEGIN
    END.
  }
}

