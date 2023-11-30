OBJECT CodeUnit 20411 Import Images1
{
  OBJECT-PROPERTIES
  {
    Date=11/04/16;
    Time=[ 6:02:49 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            GetImages();
          END;

  }
  CODE
  {
    VAR
      objMembers@1000000000 : Record 23;
      InStream1@1000000003 : InStream;
      InputFile@1000000002 : File;
      OutStream1@1000000001 : OutStream;

    PROCEDURE GetImages@1000000001();
    VAR
      filename@1000000000 : Text[100];
    BEGIN
      objMembers.RESET;
      IF objMembers.FINDSET(TRUE,FALSE) THEN BEGIN
        REPEAT
        filename:='D:\Account Holders Pictures\'+objMembers."No."+'.jpg';
      IF objMembers.Picture.HASVALUE THEN
      CLEAR(objMembers.Picture);
      IF FILE.EXISTS(filename) THEN BEGIN
        CLEAR(objMembers.Picture);
      InputFile.OPEN(filename);
      InputFile.CREATEINSTREAM(InStream1);
      objMembers.Picture.CREATEOUTSTREAM(OutStream1);
      COPYSTREAM(OutStream1,InStream1);
      objMembers.MODIFY;
      InputFile.CLOSE;
      END;
      UNTIL objMembers.NEXT=0;
      MESSAGE('Pictures uploaded succesfully.');
      END;
    END;

    BEGIN
    END.
  }
}

