OBJECT CodeUnit 20407 Journal Post Successful
{
  OBJECT-PROPERTIES
  {
    Date=01/25/16;
    Time=11:27:19 AM;
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

    PROCEDURE PostedSuccessfully@1102755000() Posted : Boolean;
    BEGIN

        Posted:=FALSE;
       {ValPost.SETRANGE(ValPost.UserID,USERID);
       ValPost.SETRANGE(ValPost."Value Posting",1);
       IF ValPost.FIND('-') THEN
          Posted:=TRUE;}
    END;

    BEGIN
    END.
  }
}

