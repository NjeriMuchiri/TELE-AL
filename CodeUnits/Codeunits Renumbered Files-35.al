OBJECT CodeUnit 20399 Audit Management
{
  OBJECT-PROPERTIES
  {
    Date=08/24/23;
    Time=11:25:35 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ComputerName@1120054000 : Text[250];
      Lentry@1120054001 : Integer;
      ActiveSession@1120054005 : Record 2000000110;
      Dns@1120054004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.Dns";
      IPAddresses@1120054003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.List`1";
      i@1120054002 : Integer;
      IPAddress@1120054006 : Code[200];

    PROCEDURE FnInsertAuditRecords@1120054000(EntryNos@1120054001 : Integer;UserIDS@1120054002 : Code[80];TransactionType@1120054003 : Text[150];Amount@1120054004 : Decimal;Source@1120054005 : Code[80];Date@1120054006 : Date;Time@1120054007 : Time;LoanNumber@1120054008 : Code[80];DocumentNo@1120054009 : Code[80];AccountNo@1120054010 : Code[80];ATMNo@1120054011 : Code[80]);
    VAR
      AuditT@1120054000 : Record 51516655;
    BEGIN
      //Kitui Trail
      ActiveSession.GET(SERVICEINSTANCEID, SESSIONID);
      IPAddresses:= IPAddresses.List;
      IPAddresses.AddRange(Dns.GetHostAddresses(ActiveSession."Client Computer Name"));
      FOR i := 0 TO IPAddresses.Count - 1 DO BEGIN
        IPAddress:=IPAddresses.Item(i);
        ActiveSession.MODIFY;
      END;

      AuditT.LOCKTABLE(TRUE);
      AuditT.INIT;
      AuditT."User Id":=UserIDS;
      AuditT."User Name":=UserIDS;
      AuditT."Transaction Type":=TransactionType;
      AuditT.Amount:=Amount;
      AuditT.Source:=Source;
      AuditT.Date:=Date;
      AuditT.Time:=Time;
      AuditT."Loan Number":=LoanNumber;
      AuditT."Document Number":=DocumentNo;
      AuditT."Account Number":=AccountNo;
      AuditT."ATM Card":=ATMNo;
      AuditT."Computer Name":=ComputerName;
      AuditT."IP Address":=IPAddress;
      AuditT.INSERT;
      COMMIT;
    END;

    PROCEDURE FnGetComputerName@1120054002();
    VAR
      Sessions@1120054000 : Record 2000000111;
    BEGIN
      Sessions.RESET;
      Sessions.SETRANGE(Sessions."User ID",USERID);
      Sessions.SETRANGE(Sessions."Session ID",SESSIONID);
      IF Sessions.FINDFIRST THEN BEGIN
      ComputerName:=Sessions."Client Computer Name";
      END;
    END;

    PROCEDURE FnGetLastEntry@1120054003();
    VAR
      AuditEntry@1120054000 : Record 51516655;
    BEGIN
      IF AuditEntry.FIND('+') THEN
      BEGIN
      Lentry:=1+AuditEntry."Entry No";
      END ELSE BEGIN
      Lentry:=1;
      END;
    END;

    BEGIN
    END.
  }
}

