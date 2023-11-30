OBJECT CodeUnit 20408 SendSms2
{
  OBJECT-PROPERTIES
  {
    Date=09/08/22;
    Time=[ 4:03:14 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Sms@1102755000 : Record 51516329;

    PROCEDURE SendSms@1102755000(VAR Source@1102755000 : Code[20];VAR Telephone@1102755001 : Text[200];VAR Textsms@1102755002 : Text[200];VAR DocumentNo@1102755003 : Text[100]);
    VAR
      EntryNo@1120054000 : Integer;
    BEGIN

      Sms.RESET;
      IF Sms.FIND('+') THEN
      EntryNo:=Sms."Entry No"
      ELSE
      EntryNo:=1;


      Sms.INIT;
      Sms."Entry No":=EntryNo;
      Sms.Source:=Source;
      Sms."Telephone No":=Replacestring(Telephone,'-','');
      Sms."Date Entered":=TODAY;
      Sms."Time Entered":=TIME;
      Sms."Entered By":=USERID;
      Sms."SMS Message":=Textsms;
      Sms."Document No":=DocumentNo;
      Sms."Sent To Server":=Sms."Sent To Server"::No;
      Sms.INSERT;

    END;

    PROCEDURE Replacestring@1102755001(string@1102755000 : Text[200];findwhat@1102755001 : Text[30];replacewith@1102755002 : Text[200]) Newstring : Text[200];
    BEGIN
      {WHILE STRPOS(string,findwhat) > 0 DO
      string := DELSTR(string,STRPOS(string,findwhat)) + replacewith + COPYSTR(string,STRPOS(string,findwhat) + STRLEN(findwhat));
      Newstring := string;}
    END;

    BEGIN
    END.
  }
}

