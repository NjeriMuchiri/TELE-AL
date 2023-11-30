OBJECT CodeUnit 20417 Get Local IP
{
  OBJECT-PROPERTIES
  {
    Date=06/23/22;
    Time=12:48:28 PM;
    Modified=Yes;
    Version List=NAB;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            {ActiveSession.GET(SERVICEINSTANCEID, SESSIONID);
            IPAddresses:= IPAddresses.List;
            IPAddresses.AddRange(Dns.GetHostAddresses(ActiveSession."Client Computer Name"));
            FOR i := 0 TO IPAddresses.Count - 1 DO BEGIN
            //  MESSAGE('%1', IPAddresses.Item(i));
              ActiveSession."IP Address":=IPAddresses.Item(i);
              ActiveSession.MODIFY;
            END;}
          END;

  }
  CODE
  {
    VAR
      ActiveSession@1000 : Record 2000000110;
      Dns@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.Dns";
      IPAddresses@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.List`1";
      i@1003 : Integer;

    BEGIN
    {
      You may want to visit my blog too http://navnab.wordpress.com/
    }
    END.
  }
}

