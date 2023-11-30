OBJECT page 20457 HR Next Of Kin
{
  OBJECT-PROPERTIES
  {
    Date=10/27/20;
    Time=10:53:51 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516024;
    PageType=ListPart;
    AutoSplitKey=Yes;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr=Name }

    { 1120054003;2;Field  ;
                SourceExpr=Contact }

    { 1120054004;2;Field  ;
                SourceExpr=Residence }

    { 1120054005;2;Field  ;
                SourceExpr=Address }

  }
  CODE
  {

    BEGIN
    END.
  }
}

