OBJECT page 172177 Defaulter Msg Dialog
{
  OBJECT-PROPERTIES
  {
    Date=10/30/20;
    Time=[ 3:02:19 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    PageType=StandardDialog;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                GroupType=Group }

    { 1120054002;2;Field  ;
                Name=Message To Send;
                SourceExpr="Message To Send" }

  }
  CODE
  {
    VAR
      "Message To Send"@1120054000 : Text;

    PROCEDURE TheMessageToBeSent@1120054000() : Text;
    BEGIN
      MESSAGE("Message To Send");
      EXIT("Message To Send");
    END;

    BEGIN
    END.
  }
}

