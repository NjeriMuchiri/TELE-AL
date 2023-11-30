OBJECT page 17360 Membership Application Image
{
  OBJECT-PROPERTIES
  {
    Date=01/06/16;
    Time=[ 1:47:44 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516220;
    PageType=Card;
    OnOpenPage=BEGIN
                 {MemberApp.RESET;
                 MemberApp.SETRANGE(MemberApp."No.","No.");
                 IF MemberApp.FIND('-') THEN BEGIN
                  IF MemberApp.Status=MemberApp.Status::Approved THEN BEGIN
                   CurrPage.EDITABLE:=FALSE;
                  END ELSE
                   CurrPage.EDITABLE:=TRUE;
                 END;
                  }
               END;

  }
  CONTROLS
  {
    { 1102755006;0;Container;
                ContainerType=ContentArea }

    { 1102755004;1;Field  ;
                SourceExpr=Picture }

    { 1102755002;1;Field  ;
                SourceExpr=Signature }

  }
  CODE
  {
    VAR
      MemberApp@1102755000 : Record 51516220;

    BEGIN
    END.
  }
}

