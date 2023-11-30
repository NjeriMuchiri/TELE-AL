OBJECT page 172034 Mobile PIN Reset
{
  OBJECT-PROPERTIES
  {
    Date=05/20/19;
    Time=12:00:55 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
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

    { 1120054000;2;Field  ;
                SourceExpr="No." }

    { 1000000002;2;Field  ;
                SourceExpr="Account No";
                Enabled=FALSE;
                Editable=FALSE }

    { 1000000003;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr=Telephone;
                Editable=FALSE }

    { 1120054001;2;Field  ;
                SourceExpr="Date Applied" }

    { 1000000005;2;Field  ;
                CaptionML=ENU=Reset PIN;
                SourceExpr=SentToServer }

  }
  CODE
  {

    BEGIN
    END.
  }
}

