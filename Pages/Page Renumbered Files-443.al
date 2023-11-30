OBJECT page 172038 SurePESA Appplications List
{
  OBJECT-PROPERTIES
  {
    Date=12/13/19;
    Time=[ 9:19:52 AM];
    Modified=Yes;
    Version List=SurePESA;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516521;
    PageType=List;
    CardPageID=SurePESA Applications Card;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="No." }

    { 1120054001;2;Field  ;
                SourceExpr="Staff No" }

    { 1000000003;2;Field  ;
                SourceExpr="Account No" }

    { 1000000004;2;Field  ;
                SourceExpr="Account Name" }

    { 1000000005;2;Field  ;
                SourceExpr=Telephone }

    { 1000000006;2;Field  ;
                SourceExpr="ID No" }

    { 1000000007;2;Field  ;
                SourceExpr=Status }

    { 1000000008;2;Field  ;
                SourceExpr="Date Applied" }

    { 1000000009;2;Field  ;
                SourceExpr="Time Applied" }

    { 1000000010;2;Field  ;
                SourceExpr="Created By" }

    { 1120054000;2;Field  ;
                SourceExpr=SentToServer }

    { 1000000012;2;Field  ;
                SourceExpr="No. Series" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

