OBJECT page 172149 HR Job Requirement Lines
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=10:24:56 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516101;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="Qualification Type";
                Importance=Promoted }

    { 1102755003;2;Field  ;
                SourceExpr="Qualification Code";
                Importance=Promoted }

    { 1102755005;2;Field  ;
                SourceExpr="Qualification Description";
                Importance=Promoted;
                Editable=false }

    { 1102755009;2;Field  ;
                SourceExpr=Priority }

    { 1102755013;2;Field  ;
                SourceExpr="Desired Score" }

    { 1102755015;2;Field  ;
                SourceExpr="Total (Stage)Desired Score";
                Visible=false }

    { 1102755017;2;Field  ;
                SourceExpr=Mandatory }

  }
  CODE
  {

    BEGIN
    END.
  }
}

