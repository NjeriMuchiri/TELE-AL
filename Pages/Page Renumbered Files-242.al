OBJECT page 17433 Account Details Master
{
  OBJECT-PROPERTIES
  {
    Date=09/27/23;
    Time=[ 1:53:56 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table23;
    DelayedInsert=No;
    SourceTableView=WHERE(Global Dimension 1 Code=CONST(FOSA),
                          Account Type=FILTER(<>FIXED),
                          Status=FILTER(<>Closed));
    PageType=List;
    CardPageID=Account Card;
    OnAfterGetRecord=BEGIN
                       SalaryAmount:=0;
                       POSTALCORP.RESET;
                       POSTALCORP.SETRANGE(POSTALCORP."Payroll No","Staff No");
                       IF POSTALCORP.FIND('-') THEN BEGIN
                         SalaryAmount:=POSTALCORP."Salary Amount";
                         END;
                     END;

    ActionList=ACTIONS
    {
      { 1102755233;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755232;1 ;ActionGroup;
                      Name=Account;
                      CaptionML=ENU=Account }
      { 1102755231;2 ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=Ledger E&ntries;
                      RunObject=20375;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=VendorLedger }
      { 1102755230;2 ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Vendor),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102755229;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(23),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 1102755228;2 ;Separator  }
      { 1102755226;2 ;Separator  }
      { 1102755225;2 ;Separator  }
      { 1102755224;2 ;Action    ;
                      CaptionML=ENU=Member Page;
                      RunObject=page 17365;
                      RunPageLink=Field1=FIELD(BOSA Account No);
                      Promoted=Yes;
                      Image=Planning;
                      PromotedCategory=Process }
      { 1102755223;2 ;Action    ;
                      Name=<Action11027600800>;
                      CaptionML=ENU=Loans Statements;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,Cust)
                                 }
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","BOSA Account No");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516223,TRUE,FALSE,Cust);
                               END;
                                }
      { 1102755222;2 ;Separator  }
      { 1102755220;1 ;ActionGroup }
      { 1102755217;2 ;Separator  }
      { 1102755216;2 ;Action    ;
                      Name=Page Vendor Statement;
                      CaptionML=ENU=Statement;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                   IF Vend."Company Code"='STAFF' THEN BEGIN
                                     IF "Staff UserID"<>USERID THEN
                                       ERROR('You Cannot view your Colleague statement for confidentiality purposes')
                                     ELSE
                                    REPORT.RUN(51516248,TRUE,FALSE,Vend);
                                    END;
                                 {
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,Vend)
                                 }
                                 {Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516248,TRUE,FALSE,Vend)
                                 }
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=view Statement;
                      CaptionML=ENU=view Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN BEGIN
                                 IF Vend."Company Code"<>'STAFF' THEN BEGIN
                                   REPORT.RUN(51516201,TRUE,FALSE,Vend)
                                     END;
                                 END;
                                  UserSetup.RESET;
                                  UserSetup.SETRANGE(UserSetup."User ID",HREmployees."User ID");
                                  IF UserSetup.FIND('-')  THEN  BEGIN
                                    IF UserSetup."View staff account" = TRUE THEN BEGIN

                                       Vend.RESET;
                                       Vend.SETRANGE(Vend."No.","No.");
                                       IF Vend.FIND('-') THEN
                                       REPORT.RUN(51516201,TRUE,FALSE,Vend)

                                       END;
                                     END ELSE

                                 HREmployees.RESET;
                                 HREmployees.SETRANGE(HREmployees."No.","Staff No");
                                 //HREmployees.SETRANGE(HREmployees."User ID",USERID);
                                 IF HREmployees.FIND('-')  THEN BEGIN
                                   IF HREmployees."User ID"<> USERID THEN BEGIN

                                  UserSetup.RESET;
                                  UserSetup.SETRANGE(UserSetup."User ID",USERID);
                                  IF UserSetup.FIND('-')  THEN
                                   // MESSAGE('rr %1- oo  s%2 - status',HREmployees."User ID",USERID,UserSetup."View staff account");
                                  IF UserSetup."View staff account" = FALSE THEN BEGIN
                                       ERROR('you should contact admin for staff statement')
                                    END;
                                  END   ELSE
                                  Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516201,TRUE,FALSE,Vend)

                                 END;


                                 //END;
                               END;
                                }
      { 1000000007;2 ;Action    ;
                      Name=Page Vendor Statement New;
                      CaptionML=ENU=Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                   IF Vend."Company Code"<>'STAFF' THEN BEGIN
                                     REPORT.RUN(51516248,TRUE,FALSE,Vend)
                                     END;
                                 HREmployees.RESET;
                                 HREmployees.SETRANGE(HREmployees."No.","Staff No");
                                 //HREmployees.SETRANGE(HREmployees."User ID",USERID);
                                 IF HREmployees.FIND('-')  THEN BEGIN
                                   IF HREmployees."User ID"<> USERID THEN BEGIN

                                  UserSetup.RESET;
                                  UserSetup.SETRANGE(UserSetup."User ID",USERID);
                                  IF UserSetup.FIND('-')  THEN
                                   // MESSAGE('rr %1- oo  s%2 - status',HREmployees."User ID",USERID,UserSetup."View staff account");
                                  IF UserSetup."View staff account" = FALSE THEN BEGIN
                                       ERROR('you should contact admin for staff statement')
                                    END;
                                  END   ELSE
                                  Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516248,TRUE,FALSE,Vend)

                                 END;
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      Name=Page Vendor Statistics;
                      ShortCutKey=F7;
                      CaptionML=ENU=Statistics;
                      RunObject=Page 152;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Report }
      { 1000000004;2 ;Separator  }
      { 1000000003;2 ;Action    ;
                      Name=Next Of Kin;
                      CaptionML=ENU=Next Of Kin;
                      RunObject=page 17435;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1000000005;2 ;Action    ;
                      Name=FOSA Loans;
                      RunObject=page 17391;
                      RunPageLink=Account No=FIELD(No.),
                                  Source=FILTER(FOSA);
                      Promoted=Yes }
      { 1120054003;2 ;Action    ;
                      Name=Update Net Pay;
                      CaptionML=ENU=Update Net Pay;
                      RunObject=Report 51516334;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1120054012;2 ;Action    ;
                      Name=Update Salary Earners;
                      Promoted=Yes;
                      Image=Production;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //Accounts.SETRANGE(Accounts."No.",'0502-001-06490');
                                 Accounts.SETAUTOCALCFIELDS(Accounts."Salary Processed Day");
                                 Accounts.SETFILTER(Accounts."Salary Processed Day",'<%1|%2',CALCDATE('<-2M>',TODAY),0D);
                                 IF Accounts.FINDFIRST THEN BEGIN
                                 ProgressWindow.OPEN('Updating Earners #1#######');
                                 REPEAT
                                 SLEEP(100);
                                 Accounts."Salary earner":=FALSE;
                                 Accounts."Salary Processing":=FALSE;
                                 Accounts.MODIFY;
                                 ProgressWindow.UPDATE(1,Accounts."No."+':'+Accounts.Name);
                                 UNTIL Accounts.NEXT=0;
                                 ProgressWindow.CLOSE;
                                 END;

                                 Accounts.SETRANGE(Accounts."Salary Processing",TRUE);
                                 IF Accounts.FINDFIRST THEN BEGIN
                                 ProgressWindow.OPEN('Updating Earners #1#######');
                                 REPEAT
                                 SLEEP(100);
                                 Accounts."Salary earner":=TRUE;
                                 Accounts.MODIFY;
                                 ProgressWindow.UPDATE(1,Accounts."No."+':'+Accounts.Name);
                                 UNTIL Accounts.NEXT=0;
                                 ProgressWindow.CLOSE;
                                 END;

                                 Accounts.RESET;
                                 Accounts.SETRANGE(Accounts."Company Code",'STAFF');
                                 Accounts.SETRANGE(Accounts.Status,Accounts.Status::Active);
                                 IF Accounts.FINDFIRST THEN BEGIN
                                 ProgressWindow.OPEN('Updating Earners #1#######');
                                 REPEAT
                                 SLEEP(100);
                                 Accounts."Salary earner":=TRUE;
                                 Accounts."Salary Processing":=TRUE;
                                 Accounts.MODIFY;
                                 UNTIL Accounts.NEXT=0;
                                 ProgressWindow.CLOSE;
                                 END;
                               END;
                                }
      { 1120054013;2 ;Action    ;
                      Name=Classify FOSA Members;
                      Promoted=Yes;
                      Image=CalculateCost;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Activate.FnMarkAccountAsActive();
                                 Activate.FnMarkAccountAsDormant();
                               END;
                                }
      { 1120054019;2 ;Action    ;
                      Name=Get Saalry Amount;
                      Promoted=Yes;
                      Image=Calculate;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 MESSAGE(GetSalaryLoanQualifiedAmount("No."));
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="No." }

    { 1000000000;2;Field  ;
                SourceExpr="Staff No" }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1120054011;2;Field  ;
                SourceExpr=Status }

    { 1120054010;2;Field  ;
                SourceExpr=Blocked }

    { 1102755004;2;Field  ;
                SourceExpr="Search Name" }

    { 1102755137;2;Field  ;
                SourceExpr="Account Type" }

    { 1120054005;2;Field  ;
                SourceExpr="EFT Transactions" }

    { 1120054006;2;Field  ;
                SourceExpr="Uncleared Cheques" }

    { 1120054007;2;Field  ;
                SourceExpr="Mpesa Withdrawals" }

    { 1120054008;2;Field  ;
                SourceExpr="Coop Transaction" }

    { 1120054009;2;Field  ;
                SourceExpr="ATM Transactions" }

    { 1102755166;2;Field  ;
                SourceExpr="Salary Processing" }

    { 1102755005;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1102755006;2;Field  ;
                Name=ATM No.";
                CaptionML=ENU=ATM No.;
                SourceExpr="ATM No." }

    { 1102755007;2;Field  ;
                CaptionML=ENU=Member No.;
                SourceExpr="BOSA Account No" }

    { 1102755008;2;Field  ;
                SourceExpr="ID No." }

    { 1102755009;2;Field  ;
                SourceExpr=Balance }

    { 1102755010;2;Field  ;
                SourceExpr="Company Code" }

    { 1120054002;2;Field  ;
                SourceExpr="Transactional Mobile No" }

    { 1102755011;2;Field  ;
                SourceExpr="Mobile Phone No" }

    { 1102755012;2;Field  ;
                SourceExpr="Phone No." }

    { 1000000001;2;Field  ;
                Name=AvailableBal;
                SourceExpr=SFactory.FnGetAccountAvailableBalance("No.");
                Editable=FALSE }

    { 1120054001;2;Field  ;
                SourceExpr="Salary earner" }

    { 1120054004;2;Field  ;
                SourceExpr="Vendor Posting Group" }

    { 1120054014;2;Field  ;
                SourceExpr="Last Transaction Date" }

    { 1120054015;2;Field  ;
                SourceExpr="Staff UserID" }

    { 1120054016;2;Field  ;
                SourceExpr="Deposit Contribution" }

    { 1120054017;2;Field  ;
                SourceExpr="Shares Capital" }

    { 1120054018;2;Field  ;
                CaptionML=ENU=Expected salary Amount;
                SourceExpr=SalaryAmount }

  }
  CODE
  {
    VAR
      CalendarMgmt@1000000041 : Codeunit 7600;
      PaymentToleranceMgt@1000000040 : Codeunit 426;
      CustomizedCalEntry@1000000039 : Record 7603;
      CustomizedCalendar@1000000038 : Record 7602;
      SalaryAmount@1120054006 : Decimal;
      PictureExists@1000000037 : Boolean;
      POSTALCORP@1120054007 : Record 51516457;
      AccountTypes@1000000036 : Record 51516295;
      GenJournalLine@1000000035 : Record 81;
      GLPosting@1000000034 : Codeunit 12;
      StatusPermissions@1000000033 : Record 51516310;
      Charges@1000000032 : Record 51516297;
      ForfeitInterest@1000000031 : Boolean;
      InterestBuffer@1000000030 : Record 51516324;
      FDType@1000000029 : Record 51516305;
      Vend@1000000028 : Record 23;
      Cust@1000000027 : Record 51516223;
      LineNo@1000000026 : Integer;
      UsersID@1000000025 : Record 2000000120;
      DActivity@1000000024 : Code[20];
      DBranch@1000000023 : Code[20];
      MinBalance@1000000022 : Decimal;
      OBalance@1000000021 : Decimal;
      OInterest@1000000020 : Decimal;
      Gnljnline@1000000019 : Record 81;
      TotalRecovered@1000000018 : Decimal;
      LoansR@1000000017 : Record 51516230;
      LoanAllocation@1000000016 : Decimal;
      LGurantors@1000000015 : Record 51516319;
      Loans@1000000014 : Record 51516230;
      DefaulterType@1000000013 : Code[20];
      LastWithdrawalDate@1000000012 : Date;
      AccountType@1000000011 : Record 51516295;
      ReplCharge@1000000010 : Decimal;
      Acc@1000000009 : Record 23;
      SearchAcc@1000000008 : Code[10];
      Searchfee@1000000007 : Decimal;
      Statuschange@1000000006 : Record 51516310;
      UnclearedLoan@1000000005 : Decimal;
      LineN@1000000004 : Integer;
      OBal@1000000003 : Decimal;
      RunBal@1000000002 : Decimal;
      AvailableBal@1000000001 : Decimal;
      GenSetup@1000000000 : Record 51516257;
      SFactory@1120054000 : Codeunit 51516022;
      Accounts@1120054001 : Record 23;
      ProgressWindow@1120054002 : Dialog;
      Activate@1120054003 : Codeunit 51516164;
      HREmployees@1120054004 : Record 51516160;
      UserSetup@1120054005 : Record 91;

    PROCEDURE GetSalaryLoanQualifiedAmount@1120054028(AccountNo@1000 : Code[20]) : Text;
    VAR
      LoanBalance@1001 : Decimal;
      MaxLoanAmount@1002 : Decimal;
      saccoAccount@1003 : Record 23;
      LoanType@1005 : Record 51516240;
      LoanRep@1006 : Decimal;
      nDays@1007 : Decimal;
      DepAmt@1008 : Decimal;
      Loans@1120054000 : Record 51516230;
      SaccoSetup@1120054001 : Record 51516700;
      RatingLoanLimit@1120054002 : Decimal;
      PenaltyCounter@1120054009 : Record 51516443;
      LoansRegister@1120054008 : Record 51516230;
      MemberLedgerEntry@1120054007 : Record 51516224;
      NumberOfMonths@1120054006 : Integer;
      DayLoanPaid@1120054005 : Date;
      Continue@1120054004 : Boolean;
      SalaryProcessingLines@1120054010 : Record 51516317;
      PayrollMonthlyTransactions@1120054011 : Record 51516183;
      MaxLoanAmtPossible@1120054012 : Decimal;
      SalBuffer@1120054013 : Record 51516317;
      StandingOrders@1120054014 : Record 51516307;
      DepAcc@1120054015 : Record 51516223;
      Salary1@1120054016 : Decimal;
      Salary2@1120054017 : Decimal;
      Salary3@1120054018 : Decimal;
      SalEnd@1120054019 : ARRAY [5] OF Date;
      SalStart@1120054020 : ARRAY [5] OF Date;
      NetSal@1120054024 : Decimal;
      IntAmt@1120054025 : Decimal;
      ProdFac@1120054026 : Record 51516240;
      GrossSalaryAmount@1120054027 : Decimal;
      NetSalaryAmount@1120054028 : Decimal;
      SalaryLoans@1120054029 : Record 51516230;
      STO@1120054030 : Record 51516307;
      LoanRepayments@1120054031 : Decimal;
      STODeductions@1120054032 : Decimal;
      SameLoanRepayments@1120054033 : Decimal;
      SameLoanOutstandingBal@1120054034 : Decimal;
      CoopSetup@1120054035 : Record 51516704;
      TotalCharge@1120054036 : Decimal;
      SaccoFee@1120054037 : Decimal;
      VendorCommission@1120054038 : Decimal;
      SMSCharge@1120054039 : Decimal;
      Members@1120054040 : Record 51516223;
      SaccoAcc@1120054042 : Record 23;
      i@1120054021 : Integer;
      SalaryAmount@1120054022 : ARRAY [5] OF Decimal;
      EmployerCode@1120054023 : Code[30];
      LoanRepaymentRecFromSal@1120054043 : Decimal;
      Remark@1120054003 : Text;
      LoanLimit@1120054041 : Decimal;
    BEGIN

      GrossSalaryAmount :=0;
      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN

          Members.GET(saccoAccount."BOSA Account No");
          IF Members.Status<>Members.Status::Active THEN BEGIN
            LoanLimit:=0;
            Remark := 'Your Member Account is not active';
            EXIT(Remark);
          END;

          IF Members."Loan Defaulter" = TRUE THEN BEGIN
            LoanLimit:=0;
            Remark := 'You are not eligible for this product because you are listed as a defaulter';
            EXIT(Remark);
          END;

          SaccoAcc.RESET;
          SaccoAcc.SETRANGE("No.",AccountNo);
          IF SaccoAcc.FINDFIRST THEN BEGIN
            IF SaccoAcc.Status <> SaccoAcc.Status::Active THEN BEGIN
              LoanLimit :=0;
              Remark := 'Your depopsit contribution is inactive';
              EXIT(Remark);
            END;
          END;


          SalStart[5] :=CALCDATE('-5M-CM',TODAY);
          SalEnd[5]:=CALCDATE('CM',SalStart[5]);

          SalStart[4] :=CALCDATE('-4M-CM',TODAY);
          SalEnd[4]:=CALCDATE('CM',SalStart[4]);

          SalStart[3] :=CALCDATE('-3M-CM',TODAY);
          SalEnd[3]:=CALCDATE('CM',SalStart[3]);

          SalStart[2] :=CALCDATE('-2M-CM',TODAY);
          SalEnd[2]:=CALCDATE('CM',SalStart[2]);

          SalStart[1] :=CALCDATE('-1M-CM',TODAY);
          SalEnd[1]:=CALCDATE('CM',SalStart[1]);

          SalaryAmount[1] :=0;
          SalaryAmount[2] :=0;
          SalaryAmount[3] :=0;
          SalaryAmount[4] :=0;
          SalaryAmount[5] :=0;
          MaxLoanAmount := 0;

          EmployerCode:=Members."Employer Code";

          FOR i := 5 DOWNTO 1 DO BEGIN
            SalaryProcessingLines.RESET;
            SalaryProcessingLines.SETRANGE(SalaryProcessingLines.Date,SalStart[i],SalEnd[i]);
            SalaryProcessingLines.SETRANGE(SalaryProcessingLines."Account No.",AccountNo);
            SalaryProcessingLines.SETFILTER(SalaryProcessingLines.Type,'%1|%2',SalaryProcessingLines.Type::Salary,SalaryProcessingLines.Type::Pension);
            IF SalaryProcessingLines.FINDFIRST THEN BEGIN
                SalaryAmount[i] := SalaryProcessingLines.Amount;

            END ELSE BEGIN
              PayrollMonthlyTransactions.RESET;
              PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."No.",saccoAccount."Staff No");
              PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."Payroll Period",SalStart[i],SalEnd[i]);
              PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."Transaction Code",'NPAY');
              IF PayrollMonthlyTransactions.FINDFIRST THEN
                  SalaryAmount[i] := PayrollMonthlyTransactions.Amount;
            END;
          END;

          IF Members."Employer Code" <> 'POSTAL CORP' THEN BEGIN
              IF (SalaryAmount[1] = 0) OR (SalaryAmount[2] = 0) OR (SalaryAmount[3] = 0) THEN BEGIN
                MaxLoanAmount := 0;
                Remark:= 'You do not qualify for this product';
                EXIT(Remark);
              END;

              IF SalaryAmount[1] <= SalaryAmount[2] THEN BEGIN
                MaxLoanAmount := SalaryAmount[1];
                END ELSE
              IF SalaryAmount[1] <= SalaryAmount[3] THEN BEGIN
              MaxLoanAmount := SalaryAmount[1];
                END ELSE
              IF SalaryAmount[2] <= SalaryAmount[1] THEN BEGIN
              MaxLoanAmount := SalaryAmount[2];
                END ELSE
              IF SalaryAmount[2] <= SalaryAmount[3] THEN BEGIN
              MaxLoanAmount := SalaryAmount[2];
                END ELSE
              IF SalaryAmount[1] >= SalaryAmount[3] THEN BEGIN
              MaxLoanAmount := SalaryAmount[3];
                END ELSE
              IF SalaryAmount[3] <= SalaryAmount[2] THEN BEGIN
              MaxLoanAmount := SalaryAmount[3];
                END;
          END ELSE IF Members."Employer Code" ='POSTAL CORP' THEN BEGIN
            IF (SalaryAmount[5] > 0) AND (SalaryAmount[4] > 0) AND (SalaryAmount[3] > 0) AND (SalaryAmount[2] > 0) AND (SalaryAmount[1] > 0) THEN BEGIN
                IF SalaryAmount[1] >= SalaryAmount[2] THEN
                  MaxLoanAmount := SalaryAmount[2];

                IF SalaryAmount[1] <= SalaryAmount[2] THEN
                  MaxLoanAmount := SalaryAmount[2]
                END ELSE BEGIN
                IF (SalaryAmount[5] > 0) AND (SalaryAmount[4] > 0) AND (SalaryAmount[3] > 0) AND (SalaryAmount[2] > 0) THEN BEGIN
                  IF SalaryAmount[2] >= SalaryAmount[3] THEN
                  MaxLoanAmount := SalaryAmount[3];

                IF SalaryAmount[2] <= SalaryAmount[3] THEN
                  MaxLoanAmount := SalaryAmount[2];
                END ELSE BEGIN
                  IF (SalaryAmount[5] > 0) AND (SalaryAmount[4] > 0) AND (SalaryAmount[3] > 0) THEN BEGIN
                  IF SalaryAmount[3] >= SalaryAmount[4] THEN
                  MaxLoanAmount := SalaryAmount[4];

                IF SalaryAmount[3] <= SalaryAmount[4] THEN
                  MaxLoanAmount := SalaryAmount[3];
                END ELSE BEGIN
                  IF (SalaryAmount[5] > 0) AND (SalaryAmount[4] > 0) THEN BEGIN
                  IF SalaryAmount[4] >= SalaryAmount[5] THEN
                  MaxLoanAmount := SalaryAmount[5];

                IF SalaryAmount[4] <= SalaryAmount[5] THEN
                  MaxLoanAmount := SalaryAmount[4];
                END ELSE
                  IF SalaryAmount[5] > 0 THEN
                    MaxLoanAmount := SalaryAmount[5];

                IF SalaryAmount[4] > 0 THEN
                  MaxLoanAmount := SalaryAmount[4];

                IF SalaryAmount[3] > 0 THEN
                  MaxLoanAmount := SalaryAmount[3];

                IF SalaryAmount[2] > 0 THEN
                  MaxLoanAmount := SalaryAmount[2];

                  IF SalaryAmount[1] > 0 THEN
                    MaxLoanAmount := SalaryAmount[1];
                  END;

              END;
            END;
          END;


          LoanLimit := 0;
          LoanRepaymentRecFromSal:=0;
          SalaryLoans.RESET;
          SalaryLoans.SETRANGE(SalaryLoans."Client Code",saccoAccount."BOSA Account No");
          SalaryLoans.SETRANGE(SalaryLoans."Recovery Mode",SalaryLoans."Recovery Mode"::Salary);
          SalaryLoans.SETFILTER(SalaryLoans."Outstanding Balance",'>0');
          IF SalaryLoans.FINDFIRST THEN  BEGIN
            REPEAT
              SalaryLoans.CALCFIELDS(SalaryLoans."Outstanding Balance");
              LoanRepaymentRecFromSal += SalaryLoans.Repayment;
              IF SalaryLoans."Loan Product Type" = LoanType.Code  THEN BEGIN
                SameLoanRepayments += SalaryLoans.Repayment;
                SameLoanOutstandingBal += SalaryLoans."Outstanding Balance";
              END;
            UNTIL SalaryLoans.NEXT = 0;
          END;

          STO.RESET;
          STO.SETRANGE(STO."Source Account No.",saccoAccount."No.");
          STO.SETRANGE(STO.Status,STO.Status::Approved);
          IF STO.FINDFIRST THEN BEGIN
            REPEAT
              STO.CALCFIELDS(STO."Allocated Amount");
              STODeductions += STO."Allocated Amount";
            UNTIL STO.NEXT = 0;
          END;

          NetSalaryAmount := ((MaxLoanAmount*0.72)-((LoanRepayments)+(STODeductions)));


      END;
      EXIT('Net Salay:'+FORMAT(MaxLoanAmount) +'\STOs :'+FORMAT(STODeductions)+'\NB: Loan repayments have not been factored in');
    END;

    BEGIN
    END.
  }
}

