OBJECT CodeUnit 20373 RunCodeunit
{
  OBJECT-PROPERTIES
  {
    Date=05/26/16;
    Time=12:27:35 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            Runn;
          END;

  }
  CODE
  {
    VAR
      PostAtm@1000000000 : CodeUnit 20372;

    PROCEDURE Runn@1000000000();
    BEGIN
      PostAtm.RUN;
      //PostGomobile.RUN;
      //CODEUNIT.RUN(51516003)
    END;

    BEGIN
    END.
  }
}

