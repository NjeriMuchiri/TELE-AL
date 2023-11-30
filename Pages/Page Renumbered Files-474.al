OBJECT page 172069 Mbanking Applications Details
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:46:22 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516715;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="Account Type" }

    { 1102755003;2;Field  ;
                SourceExpr="Account No.";
                Editable=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr=Description;
                Editable=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

