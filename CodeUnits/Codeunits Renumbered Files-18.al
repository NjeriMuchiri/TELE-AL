OBJECT CodeUnit 20382 Posting Check
{
  OBJECT-PROPERTIES
  {
    Date=08/30/16;
    Time=[ 5:11:41 PM];
    Modified=Yes;
    Version List=FUNDS;
  }
  PROPERTIES
  {
    SingleInstance=Yes;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Post@1102755000 : Boolean;
      blnState@1102755002 : Boolean;
      blnJrnlState@1102755001 : Boolean;
      FromNo@1102755003 : Code[20];
      ToNo@1102755004 : Code[20];

    PROCEDURE SetCheck@1102755000(VAR blnPost@1102755000 : Boolean);
    BEGIN
      Post:=blnPost;
    END;

    PROCEDURE GetCheck@1102755001() blnPost : Boolean;
    BEGIN
      blnPost:=Post;
    END;

    PROCEDURE ResetState@1000000005();
    BEGIN
      blnState:=FALSE;
      FromNo:='';
      ToNo:='';
    END;

    PROCEDURE SetState@1000000006(Post@1000000000 : Boolean);
    BEGIN
      blnState:=Post;
    END;

    PROCEDURE GetState@1000000007() ActState : Boolean;
    BEGIN
      ActState:=blnState;
      EXIT(ActState);
    END;

    PROCEDURE FromEntryNo@1102755002(VAR FromNoReg@1102755000 : Code[20]);
    BEGIN
      FromNo:=FromNoReg;
    END;

    PROCEDURE ToEntryNo@1102755003(VAR ToNoReg@1102755000 : Code[20]);
    BEGIN
      ToNo:=ToNoReg;
    END;

    PROCEDURE GetFromRegNo@1102755004() FromRegisterNo : Code[20];
    BEGIN
      FromRegisterNo:=FromNo;
    END;

    PROCEDURE GetToRegNo@1102755005() ToRegisterNo : Code[20];
    BEGIN
      ToRegisterNo:=ToNo;
    END;

    BEGIN
    END.
  }
}

