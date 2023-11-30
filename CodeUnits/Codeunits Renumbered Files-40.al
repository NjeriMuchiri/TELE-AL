OBJECT CodeUnit 20404 G/L Reg.-Cust.Ledger-Member
{
  OBJECT-PROPERTIES
  {
    Date=09/24/15;
    Time=10:50:33 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    TableNo=45;
    OnRun=BEGIN
            CustLedgEntry.SETRANGE("Entry No.","From Entry No.","To Entry No.");
            PAGE.RUN(PAGE::Page51516160,CustLedgEntry);
          END;

  }
  CODE
  {
    VAR
      CustLedgEntry@1000 : Record 51516155;

    BEGIN
    END.
  }
}

