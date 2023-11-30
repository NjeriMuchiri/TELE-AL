OBJECT page 17351 File Movement SetUp
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=[ 3:43:56 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516402;
    PageType=List;
    CardPageID=File Location SetUp Card;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr=Location }

    { 1000000003;2;Field  ;
                SourceExpr=Description }

    { 1000000004;2;Field  ;
                SourceExpr="Custodian Code" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

