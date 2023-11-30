OBJECT CodeUnit 20415 Activate/Deactivate accounts
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=[ 4:37:43 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            FnMarkAccountAsActive();
            FnMarkAccountAsDormant();
            FnMarkMemberAsActive();
            FnMarkMemberAsDormant();
          END;

  }
  CODE
  {
    VAR
      GenSetup@1120054000 : Record 51516257;
      ProgressWindow@1120054001 : Dialog;
      Checkoff@1120054002 : Record 50699;
      LineNo@1120054003 : Integer;
      MonthOne@1120054004 : Boolean;
      MonthTwo@1120054005 : Boolean;
      MonthThree@1120054006 : Boolean;
      MemberLedger@1120054007 : Record 51516224;
      MonthOneM@1120054010 : Date;
      MonthTwoM@1120054009 : Date;
      MonthThreeM@1120054008 : Date;

    PROCEDURE FnMarkMemberAsDormant@1120054002();
    VAR
      Members@1120054000 : Record 51516223;
      MemberLedgerEntry@1120054001 : Record 51516224;
      MinDate@1120054002 : Date;
      DormancyPeriod@1120054003 : DateFormula;
    BEGIN
      GenSetup.GET();
      MinDate:=0D;

      MinDate:=CALCDATE('<-3M>',TODAY);
      Members.RESET;
      Members.SETRANGE(Members.Status,Members.Status::Active);
      IF Members.FINDFIRST THEN BEGIN
      ProgressWindow.OPEN('Mark Member Account as Dormant #1#######');
      REPEAT
      SLEEP(100);
      Members.CALCFIELDS(Members."Last Deposit Date Deposit");
      IF Members."Last Deposit Date Deposit"<MinDate THEN BEGIN
      Members.Status:=Members.Status::Dormant;
      Members.MODIFY;
      END;
      ProgressWindow.UPDATE(1,Members."No."+':'+Members.Name);
      UNTIL Members.NEXT=0;
      ProgressWindow.CLOSE;
      END;
    END;

    PROCEDURE FnMarkMemberAsActive@1120054004();
    VAR
      Members@1120054000 : Record 51516223;
      MemberLedgerEntry@1120054001 : Record 51516224;
      MinDate@1120054002 : Date;
      DormancyPeriod@1120054003 : DateFormula;
    BEGIN
      GenSetup.GET();
      MinDate:=0D;
      MinDate:=CALCDATE('<-3M>',TODAY);
      Members.RESET;
      //Members.SETRANGE(Members."No.",'000351');
      IF Members.FINDFIRST THEN BEGIN
      ProgressWindow.OPEN('Mark Member Account as Active #1#######');
      REPEAT
      SLEEP(100);
      MonthOne:=FALSE;
      MonthTwo:=FALSE;
      MonthThree:=FALSE;
      MonthOneM:=CALCDATE('CM',CALCDATE('-1M',TODAY));
      MonthTwoM:=CALCDATE('CM',CALCDATE('-1M',MonthOneM));
      MonthThreeM:=CALCDATE('CM',CALCDATE('-2M',MonthOneM));
      //MESSAGE('Month1%1Month%2Month%3',MonthOneM,MonthTwoM,MonthThreeM);
      MemberLedger.RESET;
      MemberLedger.SETRANGE(MemberLedger."Customer No.",Members."No.");
      MemberLedger.SETFILTER(MemberLedger."Transaction Type",'%1',MemberLedger."Transaction Type"::"Deposit Contribution");
      MemberLedger.SETFILTER(MemberLedger."Posting Date",'%1..%2',CALCDATE('-CM',MonthOneM),MonthOneM);
      MemberLedger.SETRANGE(MemberLedger.Reversed,FALSE);
      MemberLedger.SETFILTER(MemberLedger.Amount,'<%1',0);
      IF MemberLedger.FINDFIRST THEN BEGIN
      MonthOne:=TRUE;
      END;

      MemberLedger.RESET;
      MemberLedger.SETRANGE(MemberLedger."Customer No.",Members."No.");
      MemberLedger.SETFILTER(MemberLedger."Transaction Type",'%1',MemberLedger."Transaction Type"::"Deposit Contribution");
      MemberLedger.SETFILTER(MemberLedger."Posting Date",'%1..%2',CALCDATE('-CM',MonthTwoM),MonthTwoM);
      MemberLedger.SETRANGE(MemberLedger.Reversed,FALSE);
      MemberLedger.SETFILTER(MemberLedger.Amount,'<%1',0);
      IF MemberLedger.FINDFIRST THEN BEGIN
      MonthTwo:=TRUE;
      END;


      MemberLedger.RESET;
      MemberLedger.SETRANGE(MemberLedger."Customer No.",Members."No.");
      MemberLedger.SETFILTER(MemberLedger."Transaction Type",'%1',MemberLedger."Transaction Type"::"Deposit Contribution");
      MemberLedger.SETFILTER(MemberLedger."Posting Date",'%1..%2',CALCDATE('-CM',MonthThreeM),MonthThreeM);
      MemberLedger.SETRANGE(MemberLedger.Reversed,FALSE);
      MemberLedger.SETFILTER(MemberLedger.Amount,'<%1',0);
      IF MemberLedger.FINDFIRST THEN BEGIN
      //MESSAGE('Month3');
      MonthThree:=TRUE;
      END;
      //MESSAGE('Month1%1Month%2Month%3',MonthOne,MonthTwo,MonthThree);
      IF MonthOne=TRUE AND MonthTwo=TRUE AND MonthThree=TRUE THEN
      Members.Status:=Members.Status::Active
      ELSE
      Members.Status:=Members.Status::Dormant;
      Members.MODIFY;
      ProgressWindow.UPDATE(1,Members."No."+':'+Members.Name);
      UNTIL Members.NEXT=0;
      ProgressWindow.CLOSE;
      END;
    END;

    PROCEDURE FnMarkAccountAsDormant@1120054005();
    VAR
      Vendor@1120054000 : Record 23;
      VendorLedgerEntry@1120054001 : Record 25;
      MinDate@1120054002 : Date;
      DormancyPeriod@1120054003 : DateFormula;
    BEGIN
      GenSetup.GET();
      MinDate:=0D;

      MinDate:=CALCDATE('<-6M>',TODAY);
      Vendor.RESET;
      Vendor.SETRANGE(Vendor.Status,Vendor.Status::Active);
      Vendor.SETRANGE(Vendor."Account Type",'ORDINARY');
      IF Vendor.FINDFIRST THEN BEGIN
      ProgressWindow.OPEN('Mark FOSA Account as Dormant #1#######');
      REPEAT
      SLEEP(100);
      VendorLedgerEntry.RESET;
      VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Vendor No.",Vendor."No.");
      //Vendor.SETRANGE(Vendor."No.",'0502-009-26668');
      IF VendorLedgerEntry.FINDLAST THEN BEGIN
      IF VendorLedgerEntry."Posting Date"<MinDate THEN BEGIN
      Vendor.Status:=Vendor.Status::Dormant;
      Vendor.MODIFY;
      END;
      END ELSE BEGIN
      Vendor.Status:=Vendor.Status::Dormant;
      Vendor.MODIFY;
      END;
      ProgressWindow.UPDATE(1,Vendor."No."+':'+Vendor.Name);
      UNTIL Vendor.NEXT=0;
      ProgressWindow.CLOSE;
      END;
    END;

    PROCEDURE FnMarkAccountAsActive@1120054003();
    VAR
      Vendor@1120054000 : Record 23;
      VendorLedgerEntry@1120054001 : Record 25;
      MinDate@1120054002 : Date;
      DormancyPeriod@1120054003 : DateFormula;
    BEGIN
      GenSetup.GET();
      MinDate:=0D;
      MinDate:=CALCDATE('<-6M>',TODAY);
      Vendor.RESET;
      Vendor.SETRANGE(Vendor.Status,Vendor.Status::Dormant);
      Vendor.SETRANGE(Vendor."Account Type",'ORDINARY');
      //Vendor.SETRANGE(Vendor."No.",'0502-009-26668');
      IF Vendor.FINDFIRST THEN BEGIN
      ProgressWindow.OPEN('Mark FOSA Account as Active #1#######');
      REPEAT
      SLEEP(100);
      VendorLedgerEntry.RESET;
      VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Vendor No.",Vendor."No.");
      IF VendorLedgerEntry.FINDLAST THEN BEGIN
      IF VendorLedgerEntry."Posting Date">=MinDate THEN BEGIN
      Vendor.Status:=Vendor.Status::Active;
      Vendor.MODIFY;
      END;
      END ELSE BEGIN
      Vendor.Status:=Vendor.Status::Dormant;
      Vendor.MODIFY;
      END;
      ProgressWindow.UPDATE(1,Vendor."No."+':'+Vendor.Name);
      UNTIL Vendor.NEXT=0;
      ProgressWindow.CLOSE;
      END;
    END;

    PROCEDURE FnInsertCheckoffSMS@1120054000("Client Code"@1120054000 : Code[40];Deduction@1120054002 : Text[40];Amount@1120054003 : Decimal);
    BEGIN
      IF Checkoff.FINDLAST THEN
      LineNo:=Checkoff.No+1
      ELSE
      LineNo:=1;
    END;

    PROCEDURE FnMarkAccountAsDefaulter@1120054001();
    VAR
      Loans@1120054005 : Record 51516230;
      Members@1120054004 : Record 51516223;
      Defaulter@1120054003 : Boolean;
    BEGIN
      IF Members.FINDFIRST THEN BEGIN
      Defaulter:=FALSE;
      REPEAT
      Loans.SETRANGE(Loans."Client Code",Members."No.");
      Loans.SETAUTOCALCFIELDS(Loans."Outstanding Balance");
      Loans.SETFILTER(Loans."Outstanding Balance",'>%1',0);
      Loans.SETFILTER(Loans."Loans Category-SASRA",'%1|%2|%3',Loans."Loans Category-SASRA"::Loss,Loans."Loans Category-SASRA"::Loss,Loans."Loans Category-SASRA"::Substandard);
      IF Loans.FINDFIRST THEN BEGIN
      REPEAT
      Defaulter:=TRUE;
      UNTIL Loans.NEXT=0;
      END;
      IF Defaulter=TRUE THEN
      Members."Loan Status":=Members."Loan Status"::Defaulter
      ELSE
      Members."Loan Status":=Members."Loan Status"::Performing;
      Members.MODIFY;
      UNTIL Members.NEXT=0;
      END;
    END;

    BEGIN
    END.
  }
}

