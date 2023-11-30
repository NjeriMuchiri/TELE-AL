OBJECT CodeUnit 20398 Leave Year-Close
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=11:53:36 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    TableNo=51516198;
    OnRun=BEGIN
            AccountingPeriod.COPY(Rec);
            Code;
            Rec := AccountingPeriod;
          END;

  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'ENU=You must create a new fiscal year before you can close the old year.';
      Text002@1001 : TextConst 'ENU="This function closes the fiscal year from %1 to %2. "';
      Text003@1002 : TextConst 'ENU=Once the fiscal year is closed it cannot be opened again, and the periods in the fiscal year cannot be changed.\\';
      Text004@1003 : TextConst 'ENU=Do you want to close the fiscal year?';
      AccountingPeriod@1004 : Record 51516198;
      AccountingPeriod2@1005 : Record 51516198;
      AccountingPeriod3@1006 : Record 51516198;
      FiscalYearStartDate@1007 : Date;
      FiscalYearEndDate@1008 : Date;

    LOCAL PROCEDURE Code@1();
    BEGIN
      WITH AccountingPeriod DO BEGIN
        AccountingPeriod2.SETRANGE(Closed,FALSE);
        AccountingPeriod2.FIND('-');

        FiscalYearStartDate := AccountingPeriod2."Starting Date";
        AccountingPeriod := AccountingPeriod2;
        TESTFIELD("New Fiscal Year",TRUE);

        AccountingPeriod2.SETRANGE("New Fiscal Year",TRUE);
        IF AccountingPeriod2.FIND('>') THEN BEGIN
          FiscalYearEndDate := CALCDATE('<-1D>',AccountingPeriod2."Starting Date");

          AccountingPeriod3 := AccountingPeriod2;
          AccountingPeriod2.SETRANGE("New Fiscal Year");
          AccountingPeriod2.FIND('<');
        END ELSE
          ERROR(Text001);

        IF NOT
           CONFIRM(
             Text002 +
             Text003 +
             Text004,FALSE,
             FiscalYearStartDate,FiscalYearEndDate)
        THEN
          EXIT;

        RESET;

        SETRANGE("Starting Date",FiscalYearStartDate,AccountingPeriod2."Starting Date");
        MODIFYALL(Closed,TRUE);

        SETRANGE("Starting Date",FiscalYearStartDate,AccountingPeriod3."Starting Date");
        MODIFYALL("Date Locked",TRUE);

        RESET;
      END;
    END;

    PROCEDURE fnLeavebalance@1102755000(lvApplicationcode@1102755000 : Code[10];lvLeavetype@1102755001 : Code[10];lvStaffno@1102755002 : Code[10];lvBalance@1102755004 : Decimal);
    VAR
      lvLeavebalance@1102755003 : Record 51516160;
      HRLeaveTypes@1102755005 : Record 51516193;
    BEGIN
      {IF Balance = 0 THEN EXIT;
      WITH fnLeavebalance DO BEGIN
          INIT;
          "No.":= Staffno;
          "Transaction Code" := TCode;
          "Group Text" := TGroup;
          "Transaction Name" := Description;
          INSERT;
         //Update the prEmployee Transactions  with the Amount
         fnLeavebalance( "No.","Transaction Code",Amount,"Period Month","Period Year","Payroll Period");
      END;
       }

      lvLeavebalance.RESET;
       lvLeavebalance.SETRANGE(lvLeavebalance."No.",lvStaffno);
       lvLeavebalance.SETRANGE(lvLeavebalance."Leave Type Filter",lvLeavetype);
       IF lvLeavebalance.FIND('-') THEN BEGIN
      IF lvLeavebalance."Leave Balance" >=  HRLeaveTypes."Max Carry Forward Days" THEN BEGIN
      lvLeavebalance."Reimbursed Leave Days":=HRLeaveTypes."Max Carry Forward Days";
      END ELSE IF
      lvLeavebalance."Leave Balance" < HRLeaveTypes."Max Carry Forward Days" THEN
      lvLeavebalance."Reimbursed Leave Days":=lvLeavebalance."Leave Balance";
      lvLeavebalance.MODIFY;


      {SETFILTER("Leave Type Filter","HR Employees".GETFILTER("HR Employees"."Leave Type Filter"));

      HRLeaveTypes.GET("HR Employees".GETFILTER("Leave Type Filter"));

      VALIDATE("Allocated Leave Days");

      IF "HR Employees"."Leave Balance" >=  HRLeaveTypes."Max Carry Forward Days" THEN BEGIN
      "HR Employees"."Reimbursed Leave Days":=HRLeaveTypes."Max Carry Forward Days";
      END ELSE IF
      "HR Employees"."Leave Balance" < HRLeaveTypes."Max Carry Forward Days" THEN
      "HR Employees"."Reimbursed Leave Days":="HR Employees"."Leave Balance";
      "HR Employees".MODIFY;
        }
      END;
    END;

    BEGIN
    END.
  }
}

