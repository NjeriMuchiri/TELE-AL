OBJECT CodeUnit 20413 Defaulter Notification
{
  OBJECT-PROPERTIES
  {
    Date=03/08/22;
    Time=[ 5:06:17 PM];
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
      SMSMessages@1120054001 : Record 51516329;
      iEntryNo@1120054000 : Integer;
      Loans@1120054002 : Record 51516230;
      Guarantors@1120054003 : Record 51516231;

    PROCEDURE FnSendWatchDemand@1120054000(PFNumber@1120054000 : Code[20]);
    VAR
      Members@1120054001 : Record 51516223;
    BEGIN
      SMSMessages.RESET;
      IF SMSMessages.FIND('+') THEN
      iEntryNo:=SMSMessages."Entry No"+1
      ELSE
      iEntryNo:=1;


      SMSMessages.RESET;
      SMSMessages.INIT;
      SMSMessages."Entry No":=iEntryNo;
      SMSMessages."Account No":=Members."No.";
      SMSMessages."Date Entered":=TODAY;
      SMSMessages."Time Entered":=TIME;
      SMSMessages.Source:='GUARANTOR RECOVERY NOTICE';
      SMSMessages."Entered By":=USERID;
      SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
      SMSMessages."SMS Message":='Dear Member, this is to inform you that you have defaulted a loan of amount..at telepost sacco.If not settled in ';
      SMSMessages."Telephone No":=Members."Phone No.";
      SMSMessages.INSERT;
    END;

    PROCEDURE FnSendDoubtfulDemand@1120054001(PFNumber@1120054000 : Code[20]);
    VAR
      Members@1120054001 : Record 51516223;
    BEGIN

      SMSMessages.RESET;
      IF SMSMessages.FIND('+') THEN
      iEntryNo:=SMSMessages."Entry No"+1
      ELSE
      iEntryNo:=1;

      SMSMessages.RESET;
      SMSMessages.INIT;
      SMSMessages."Entry No":=iEntryNo;
      SMSMessages."Account No":=Members."No.";
      SMSMessages."Date Entered":=TODAY;
      SMSMessages."Time Entered":=TIME;
      SMSMessages.Source:='DEFAULTERS';
      SMSMessages."Entered By":=USERID;
      SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
      SMSMessages."SMS Message":='Dear Member, this is to inform you that you have defaulted a loan of amount..at telepost sacco.If not settled in ';
      SMSMessages."Telephone No":=Members."Phone No.";
      SMSMessages.INSERT;
    END;

    PROCEDURE FnSendLossDemand@1120054002(PFNumber@1120054000 : Code[20]);
    VAR
      Members@1120054001 : Record 51516223;
    BEGIN
      Loans.RESET;
      Loans.SETRANGE(Loans.Posted,TRUE);
      Loans.SETRANGE(Loans."Loans Category",Loans."Loans Category"::Loss);
      IF Loans.FINDFIRST THEN BEGIN
      REPEAT
      Loans.CALCFIELDS(Loans."Outstanding Balance");
      IF Loans."Outstanding Balance">0 THEN BEGIN
      Guarantors.RESET;
      Guarantors.SETRANGE();Guarantors."Loanees  No",
      SMSMessages.RESET;
      IF SMSMessages.FIND('+') THEN
      iEntryNo:=SMSMessages."Entry No"+1
      ELSE
      iEntryNo:=1;

      SMSMessages.RESET;
      SMSMessages.INIT;
      SMSMessages."Entry No":=iEntryNo;
      SMSMessages."Account No":=Members."No.";
      SMSMessages."Date Entered":=TODAY;
      SMSMessages."Time Entered":=TIME;
      SMSMessages.Source:='GUARANTOR RECOVERY NOTICE';
      SMSMessages."Entered By":=USERID;
      SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
      SMSMessages."SMS Message":='Kindly note that this letter serves as a final notice for the defaulted Normal loan of ' +l+ which was guaranteed by yourself. A total of Kshs. 30,608 will be recovered'
      'from your deposits by 10 th January 2022 if the loan remains unpaid. The Sacco will continue'
      'to pursue the defaulter and restore your deposits once the outstanding balance is cleared.';
      SMSMessages."Telephone No":=Members."Phone No.";
      SMSMessages.INSERT;
      END;
      UNTIL Loans.NEXT=0;
      END;
    END;

    BEGIN
    END.
  }
}

