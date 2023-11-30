OBJECT page 172142 HR Leave Applicaitons Factbox
{
  OBJECT-PROPERTIES
  {
    Date=11/20/17;
    Time=[ 9:13:05 AM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516160;
    PageType=CardPart;
  }
  CONTROLS
  {
    { 1102755015;;Container;
                ContainerType=ContentArea }

    { 1102755011;1;Field  ;
                CaptionClass=Text1;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755004;1;Field  ;
                SourceExpr=City }

    { 1102755002;1;Field  ;
                SourceExpr=County }

    { 1102755003;1;Field  ;
                SourceExpr="Home Phone Number" }

    { 1000000000;1;Field  ;
                SourceExpr="Post Code" }

    { 1000000001;1;Field  ;
                SourceExpr="Cellular Phone Number" }

    { 1102755000;1;Field  ;
                SourceExpr="Job T" }

    { 1102755013;1;Field  ;
                SourceExpr=stat }

    { 1102755006;1;Field  ;
                SourceExpr="Company E-Mail" }

  }
  CODE
  {
    VAR
      Text1@1102755000 : TextConst 'ENU=Employee Details';
      Text2@1102755001 : TextConst 'ENU=Employeee Leave Details';
      Text3@1102755002 : TextConst;

    BEGIN
    END.
  }
}

