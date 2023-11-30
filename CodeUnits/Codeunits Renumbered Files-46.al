OBJECT CodeUnit 20410 Loan Aging Classification
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=[ 2:29:28 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            FnClassifyLoans();
            //CODEUNIT.RUN(51516164,TRUE)
          END;

  }
  CODE
  {
    VAR
      Loans@1120054000 : Record 51516230;
      RSchedule@1120054001 : Record 51516234;
      TotalExpectedAmount@1120054002 : Decimal;
      TotalPaidAMount@1120054003 : Decimal;
      MonthlyRepayments@1120054004 : Decimal;
      NumberOfMonths@1120054005 : Decimal;
      NumberOfDays@1120054006 : Decimal;
      Arrears@1120054007 : Decimal;
      Generate@1120054008 : CodeUnit 20412;
      TotalInterestPaid@1120054009 : Decimal;
      GenSetup@1120054010 : Record 51516257;
      ProgressWindow@1120054011 : Dialog;
      Loanss@1120054012 : Record 51516230;

    PROCEDURE FnClassifyLoans@1120054005();
    BEGIN
      Loans.RESET;
      Loans.SETRANGE(Loans.Posted,TRUE);
      Loans.SETAUTOCALCFIELDS(Loans."Outstanding Balance");
      Loans.SETFILTER(Loans."Outstanding Balance",'>%1',0);
      //Loans.SETRANGE(Loans."Client Code",'013483');
      IF Loans.FINDFIRST THEN
      BEGIN
      ProgressWindow.OPEN('Classifying loans #1#######');
      REPEAT
      SLEEP(100);
      Loans.CALCFIELDS(Loans."Outstanding Balance");
      IF Loans."Outstanding Balance">0 THEN BEGIN
      TotalExpectedAmount:=0;
      TotalPaidAMount:=0;
      MonthlyRepayments:=0;
      NumberOfMonths:=0;
      NumberOfDays:=0;
      Arrears:=0;
      TotalInterestPaid:=0;

      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",Loans."Loan  No.");
      IF NOT RSchedule.FINDFIRST THEN BEGIN
      Loans.VALIDATE(Loans."Loan Disbursement Date");
      Generate.Autogenerateschedule(Loans."Loan  No.");
      END;
      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",Loans."Loan  No.");
      RSchedule.SETFILTER(RSchedule."Repayment Date",'<=%1',TODAY);
      IF RSchedule.FINDSET THEN
      BEGIN
      RSchedule.CALCSUMS(RSchedule."Monthly Repayment");
      TotalExpectedAmount:=RSchedule."Monthly Repayment";
      END;

      Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Current Interest Paid");
      TotalPaidAMount:=Loans."Approved Amount"-Loans."Outstanding Balance";
      TotalInterestPaid:=Loans."Current Interest Paid"*-1;
      TotalPaidAMount:=TotalPaidAMount+TotalInterestPaid;
      Arrears:=TotalExpectedAmount-TotalPaidAMount;
      Loans."Loan Arrears":=Arrears;

      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",Loans."Loan  No.");
      IF RSchedule.FINDFIRST THEN BEGIN
      MonthlyRepayments:=RSchedule."Monthly Repayment"
      END;
      IF MonthlyRepayments>0 THEN BEGIN
      NumberOfMonths:=ROUND((Arrears/MonthlyRepayments),1,'=');
      NumberOfDays:=NumberOfMonths*30;
      Loans."Days In Arrears.":=NumberOfDays;
      // END ELSE BEGIN
      //Generate.Autogenerateschedule(Loans."Loan  No.");
      // NumberOfMonths:=ROUND((Arrears/MonthlyRepayments),1,'=');
      // NumberOfDays:=NumberOfMonths*30;
      END;
      //MESSAGE('Expected%1 Pid%2 Arrears%3NoOfdays%4 Repayment%5',TotalExpectedAmount,TotalPaidAMount,Arrears,NumberOfDays,MonthlyRepayments);
      IF Loans."Expected Date of Completion">=TODAY THEN BEGIN
      IF NumberOfDays<=30 THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Perfoming;
      Loans."Loans Category":=Loans."Loans Category"::Perfoming;
      END ELSE IF(NumberOfDays>30) AND (NumberOfDays<=60) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Watch;
      Loans."Loans Category":=Loans."Loans Category"::Watch;
      END ELSE IF(NumberOfDays>60) AND (NumberOfDays<=180) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Substandard;
      Loans."Loans Category":=Loans."Loans Category"::Substandard;
      END ELSE IF(NumberOfDays>180) AND (NumberOfDays<=360) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Doubtful;
      Loans."Loans Category":=Loans."Loans Category"::Doubtful;
      END ELSE IF(NumberOfDays>360)  THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;
      END ELSE BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;
      IF Loans."Loans Category"=Loans."Loans Category"::Loss THEN BEGIN
      FunctionMarkAsDefaulter(Loans."Staff No");
      END;
      END;
      Loans.CALCFIELDS(Loans."Oustanding Interest");

      FnFindLoansWithInterest(Loans."Loan  No.");
      IF (Loans."Outstanding Balance"=0) AND (Loans."Oustanding Interest"=0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Perfoming;
      Loans."Loans Category":=Loans."Loans Category"::Perfoming;
      END;
      Loans.CALCFIELDS(Loans."Oustanding Penalty");
      IF (Loans."Outstanding Balance"<0) OR (Loans."Oustanding Interest"<0){ OR (Loans."Oustanding Penalty"<0)} THEN BEGIN
      //MESSAGE('hERE');
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;

      //MESSAGE('hERE2');
      IF (Loans."Expected Date of Completion"<TODAY) AND (Loans."Oustanding Interest">0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;

      IF (Loans."Outstanding Balance"<=0) AND (Loans."Oustanding Interest">0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;

      IF (Loans."Expected Date of Completion"<TODAY) AND (Loans."Oustanding Penalty">0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;
      //MESSAGE('Here%1',Loans."Loan  No.");
      //IF (Loans."Loans Category"=Loans."Loans Category"::Substandard) OR (Loans."Loans Category"=Loans."Loans Category"::Doubtful) OR (Loans."Loans Category"=Loans."Loans Category"::Loss) THEN BEGIN
      FnMarkMemberAsDefaulter(Loans."Loan  No.");

      //END;
      Loanss.RESET;
      Loanss.SETRANGE(Loanss."Loan  No.",Loans."Loan  No.");
      IF Loanss.FINDFIRST THEN BEGIN
      Loanss."Loans Category-SASRA":=Loans."Loans Category-SASRA";
      Loanss."Loans Category":=Loans."Loans Category";
      Loanss.MODIFY;
      END;
      //Loans.MODIFY;
      ProgressWindow.UPDATE(1,Loans."Loan  No."+':'+Loans."Client Name");
      UNTIL Loans.NEXT=0;
      FnUnmarkAsDefaulter();
      ProgressWindow.CLOSE;
      END;
    END;

    LOCAL PROCEDURE FnSendDefaultEmails@1120054000();
    BEGIN
    END;

    PROCEDURE FunctionMarkAsDefaulter@1120054001(PFnumber@1120054000 : Code[20]);
    VAR
      Members@1120054001 : Record 51516223;
    BEGIN
      Members.RESET;
      Members.SETRANGE(Members."Payroll/Staff No",PFnumber);
      IF Members.FINDFIRST THEN BEGIN
      Members."Loan Defaulter":=TRUE;
      Members.MODIFY;
      END;
    END;

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
      REPEAT
      // MemberLedgerEntry.RESET;
      // MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
      // MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");
      // IF MemberLedgerEntry.FINDLAST THEN BEGIN
      IF Members."Last Payment Date"<MinDate THEN BEGIN
      Members.Status:=Members.Status::Dormant;
      Members.MODIFY;
      END;
      UNTIL Members.NEXT=0;
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
      Members.SETRANGE(Members.Status,Members.Status::Dormant);
      IF Members.FINDFIRST THEN BEGIN
      REPEAT
      // MemberLedgerEntry.RESET;
      // MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Customer No.",Members."No.");
      // MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");
      // IF MemberLedgerEntry.FINDLAST THEN BEGIN
      IF Members."Last Payment Date">=MinDate THEN BEGIN
      Members.Status:=Members.Status::Active;
      Members.MODIFY;
      END;
      UNTIL Members.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE FnFindLoansWithInterest@1120054025(Loans@1120054000 : Code[40]);
    VAR
      LoansR@1120054001 : Record 51516230;
    BEGIN
      LoansR.RESET;
      LoansR.SETRANGE(LoansR."Loan  No.",Loans);
      IF LoansR.FINDFIRST THEN BEGIN
      LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");
      IF (LoansR."Outstanding Balance"=0) AND (LoansR."Oustanding Interest">0) THEN BEGIN
      LoansR."Loans Category-SASRA":=LoansR."Loans Category-SASRA"::Doubtful;
      LoansR."Loans Category":=LoansR."Loans Category"::Doubtful;
      LoansR.MODIFY;
      END;
      END;
    END;

    PROCEDURE FnClassifyLoansIndividual@1120054003(LoanNo@1120054000 : Code[20]) : Decimal;
    BEGIN
      Loans.RESET;
      Loans.SETRANGE(Loans.Posted,TRUE);
      Loans.SETRANGE(Loans."Loan  No.",LoanNo);
      IF Loans.FINDFIRST THEN
      BEGIN
      Loans.CALCFIELDS(Loans."Outstanding Balance");
      IF Loans."Outstanding Balance">0 THEN BEGIN
      TotalExpectedAmount:=0;
      TotalPaidAMount:=0;
      MonthlyRepayments:=0;
      NumberOfMonths:=0;
      NumberOfDays:=0;
      Arrears:=0;
      TotalInterestPaid:=0;

      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",Loans."Loan  No.");
      IF NOT RSchedule.FINDFIRST THEN BEGIN
      Loans.VALIDATE(Loans."Loan Disbursement Date");
      Generate.Autogenerateschedule(Loans."Loan  No.");
      END;
      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",Loans."Loan  No.");
      RSchedule.SETFILTER(RSchedule."Repayment Date",'<=%1',TODAY);
      IF RSchedule.FINDSET THEN
      BEGIN
      RSchedule.CALCSUMS(RSchedule."Monthly Repayment");
      TotalExpectedAmount:=RSchedule."Monthly Repayment";
      END;

      Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Current Interest Paid");
      TotalPaidAMount:=Loans."Approved Amount"-Loans."Outstanding Balance";
      TotalInterestPaid:=Loans."Current Interest Paid"*-1;
      TotalPaidAMount:=TotalPaidAMount+TotalInterestPaid;
      Arrears:=TotalExpectedAmount-TotalPaidAMount;
      Loans."Loan Arrears":=Arrears;


      RSchedule.RESET;
      RSchedule.SETRANGE(RSchedule."Loan No.",Loans."Loan  No.");
      IF RSchedule.FINDFIRST THEN BEGIN
      MonthlyRepayments:=RSchedule."Monthly Repayment"
      END;
       //MESSAGE('Arrears%1Repayment%2 The%3',Arrears,MonthlyRepayments,TotalPaidAMount);
      IF MonthlyRepayments>0 THEN BEGIN
      NumberOfMonths:=ROUND((Arrears/MonthlyRepayments),1,'=');
      NumberOfDays:=NumberOfMonths*30;
      Loans."Days In Arrears.":=NumberOfDays;
      // END ELSE BEGIN
      //Generate.Autogenerateschedule(Loans."Loan  No.");
      // NumberOfMonths:=ROUND((Arrears/MonthlyRepayments),1,'=');
      // NumberOfDays:=NumberOfMonths*30;
      END;
      //MESSAGE('Expected%1 Pid%2 Arrears%3NoOfdays%4 Repayment%5',TotalExpectedAmount,TotalPaidAMount,Arrears,NumberOfDays,MonthlyRepayments);
      IF Loans."Expected Date of Completion">=TODAY THEN BEGIN
      IF NumberOfDays<=30 THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Perfoming;
      Loans."Loans Category":=Loans."Loans Category"::Perfoming;
      END ELSE IF(NumberOfDays>30) AND (NumberOfDays<=60) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Watch;
      Loans."Loans Category":=Loans."Loans Category"::Watch;
      END ELSE IF(NumberOfDays>60) AND (NumberOfDays<=180) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Substandard;
      Loans."Loans Category":=Loans."Loans Category"::Substandard;
      END ELSE IF(NumberOfDays>180) AND (NumberOfDays<=360) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Doubtful;
      Loans."Loans Category":=Loans."Loans Category"::Doubtful;
      END ELSE IF(NumberOfDays>360)  THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;
      END ELSE BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;
      IF Loans."Loans Category"=Loans."Loans Category"::Loss THEN BEGIN
      //FunctionMarkAsDefaulter(Loans."Staff No");
      END;
      END;
      Loans.CALCFIELDS(Loans."Oustanding Interest");

      FnFindLoansWithInterest(Loans."Loan  No.");
      IF (Loans."Outstanding Balance"=0) AND (Loans."Oustanding Interest"=0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Perfoming;
      Loans."Loans Category":=Loans."Loans Category"::Perfoming;
      END;
      Loans.CALCFIELDS(Loans."Oustanding Penalty",Loans."Outstanding Balance");
      IF (Loans."Outstanding Balance"<0) {OR (Loans."Oustanding Interest"<0) OR (Loans."Oustanding Penalty"<0)} THEN BEGIN
      //MESSAGE('hERE');
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Perfoming;
      Loans."Loans Category":=Loans."Loans Category"::Perfoming;

      END;

      IF (Loans."Expected Date of Completion"<TODAY) AND (Loans."Oustanding Interest">0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      //MESSAGE('LoansCategory%1Cat%2',Loans."Loans Category-SASRA",Loans."Loans Category");
      END;

      IF (Loans."Outstanding Balance"<=0) AND (Loans."Oustanding Interest">0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;

      IF (Loans."Expected Date of Completion"<TODAY) AND (Loans."Oustanding Penalty">0) THEN BEGIN
      Loans."Loans Category-SASRA":=Loans."Loans Category-SASRA"::Loss;
      Loans."Loans Category":=Loans."Loans Category"::Loss;
      END;

      Loanss.RESET;
      Loanss.SETRANGE(Loanss."Loan  No.",Loans."Loan  No.");
      IF Loanss.FINDFIRST THEN BEGIN
      Loanss."Loans Category-SASRA":=Loans."Loans Category-SASRA";
      Loanss."Loans Category":=Loans."Loans Category";
      Loanss.MODIFY;
      END;
      //Loans.MODIFY();


      //COMMIT;
      //IF (Loans."Loans Category"=Loans."Loans Category"::Substandard) OR (Loans."Loans Category"=Loans."Loans Category"::Doubtful) OR (Loans."Loans Category"=Loans."Loans Category"::Loss) THEN BEGIN
      FnMarkMemberAsDefaulter(Loans."Loan  No.");
      //END;
      //FnUnmarkAsDefaulter(Loans."BOSA No");

      MESSAGE('Classification Done.');
      END;
    END;

    PROCEDURE FnMarkMemberAsDefaulter@1120054006(ClientCode@1120054004 : Code[20]);
    VAR
      Members@1120054000 : Record 51516223;
      MemberLedgerEntry@1120054001 : Record 51516224;
      MinDate@1120054002 : Date;
      DormancyPeriod@1120054003 : DateFormula;
      MembersR@1120054005 : Record 51516223;
      LoansX@1120054006 : Record 51516230;
    BEGIN
      LoansX.RESET;
      LoansX.SETRANGE(LoansX."Loan  No.",ClientCode);
      IF LoansX.FINDFIRST THEN BEGIN
      LoansX.CALCFIELDS("No Of Defaulted Loans");
      IF LoansX."No Of Defaulted Loans">0 THEN BEGIN
      MembersR.RESET;
      MembersR.SETRANGE(MembersR."No.",LoansX."BOSA No");
      IF MembersR.FINDFIRST THEN
      MembersR."Loan Defaulter":=TRUE;
      MembersR."Loan Status":=MembersR."Loan Status"::Defaulter;
      MembersR.MODIFY;
      END;

      IF LoansX."No Of Defaulted Loans"=0 THEN BEGIN
      MembersR.RESET;
      MembersR.SETRANGE(MembersR."No.",Loans."BOSA No");
      IF MembersR.FINDFIRST THEN
      MembersR."Loan Status":=MembersR."Loan Status"::Performing;
      MembersR."Loan Defaulter":=FALSE;
      MembersR.MODIFY;
      END;

      END;
    END;

    PROCEDURE FnUnmarkAsDefaulter@1120054007();
    VAR
      LoansR@1120054001 : Record 51516230;
      MembersR@1120054002 : Record 51516223;
    BEGIN

      IF MembersR.FINDFIRST THEN BEGIN
      REPEAT
      LoansR.RESET;
      LoansR.SETRANGE(LoansR."BOSA No",MembersR."No.");
      LoansR.SETRANGE(LoansR.Posted,TRUE);
      IF NOT LoansR.FINDFIRST THEN BEGIN
      MembersR."Loan Defaulter":=FALSE;
      MembersR."Loan Status":=MembersR."Loan Status"::Performing;
      MembersR.MODIFY;
      END;
      UNTIL MembersR.NEXT=0;
      END;
    END;

    BEGIN
    END.
  }
}

