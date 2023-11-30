OBJECT page 17364 Member List
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=[ 3:55:52 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Member List;
    SourceTable=Table51516223;
    SourceTableView=SORTING(No.)
                    ORDER(Ascending)
                    WHERE(Customer Type=FILTER(Member|MicroFinance));
    PageType=List;
    CardPageID=Member Account Card;
    ActionList=ACTIONS
    {
      { 1102755000;  ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1102755024;1 ;ActionGroup }
      { 1102755023;2 ;Action    ;
                      Name=Member Ledger Entries;
                      CaptionML=ENU=Member Ledger Entries;
                      RunObject=page 17367;
                      RunPageView=SORTING(Customer No.);
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Image=CustomerLedger;
                      PromotedCategory=Process }
      { 1102755022;2 ;Action    ;
                      Name=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process }
      { 1102755021;2 ;Action    ;
                      Name=Bank Account;
                      RunObject=Page 423;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Image=BankAccount;
                      PromotedCategory=Process }
      { 1120054011;2 ;Action    ;
                      Name=Classiffy Members;
                      Promoted=Yes;
                      Image=CalculateCost;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Activate.FnMarkMemberAsActive();
                               END;
                                }
      { 1120054022;2 ;Action    ;
                      Name=Classiffy Loan Accounts;
                      Promoted=Yes;
                      Visible=false;
                      Image=CalculateCost;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Activate.FnMarkAccountAsDefaulter();
                               END;
                                }
      { 1120054014;2 ;Action    ;
                      Name=View Div Slip;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 DividendsProgression.RESET;
                                 DividendsProgression.SETRANGE(DividendsProgression."No.","No.");
                                 IF DividendsProgression.FIND('-') THEN
                                 REPORT.RUN(50017,TRUE,FALSE,DividendsProgression);
                               END;
                                }
      { 1120054012;2 ;Action    ;
                      Name=Send Birthday Messages;
                      Promoted=Yes;
                      Image=CalculateCost;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you ant to send birthday SMS?',TRUE,FALSE)=TRUE THEN BEGIN
                                 Factory.FnSendMemberBirthdayMessage();
                                 END;
                               END;
                                }
      { 1102755020;1 ;ActionGroup;
                      CaptionML=ENU=Issued Documents;
                      Visible=FALSE }
      { 1102755019;2 ;Action    ;
                      Name=Loans Guaranteed;
                      CaptionML=ENU=Loans Guarantors;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,Cust);
                                 }
                               END;
                                }
      { 1120054003;2 ;Action    ;
                      Name=Member is  a Guarantor;
                      CaptionML=ENU=Member is  a Guarantor;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516226,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054002;2 ;Action    ;
                      Name=Member is Guarantor2;
                      Promoted=Yes;
                      Visible=false;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516440,TRUE,FALSE,Cust);
                               END;
                                }
      { 1102755018;2 ;Action    ;
                      Name=Loans Guarantors;
                      CaptionML=ENU=Loans Guaranteed;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,Cust);
                                 }
                               END;
                                }
      { 1102755013;1 ;ActionGroup }
      { 1102755012;2 ;Action    ;
                      CaptionML=ENU=Next Of Kin;
                      RunObject=page 17368;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1102755010;2 ;Action    ;
                      Name=Members Statistics;
                      RunObject=page 17366;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1102755028;2 ;Action    ;
                      Name=Members Guaranteed;
                      RunObject=page 17385;
                      RunPageLink=Name=FIELD(Name);
                      Promoted=Yes;
                      PromotedCategory=Process;
                      RunPageMode=View;
                      OnAction=BEGIN
                                 LGurantors.RESET;
                                 LGurantors.SETRANGE(LGurantors."Loan No","No.");
                                 IF LGurantors.FIND('-') THEN
                               END;
                                }
      { 1102755008;2 ;Separator  }
      { 1102755007;1 ;ActionGroup }
      { 1102755006;2 ;Action    ;
                      Name=Statement;
                      CaptionML=ENU=Member Statement;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516223,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054001;2 ;Action    ;
                      Name=Statement2;
                      CaptionML=ENU=Detailed Statement;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516884,TRUE,FALSE,Cust);
                               END;
                                }
      { 1000000005;2 ;Action    ;
                      Name=FOSA Statement;
                      Promoted=Yes;
                      Visible=false;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","FOSA Account");
                                 IF Vend.FINDFIRST THEN
                                   BEGIN
                                     CatchStaff();
                                     REPORT.RUN(51516248,TRUE,FALSE,Vend);
                                   END;
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=View Statement;
                      Promoted=Yes;
                      Image=report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 IF CONFIRM('Do you want to print the members statement?',TRUE,FALSE)=TRUE THEN BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","FOSA Account");
                                 IF Vend.FINDFIRST THEN
                                   BEGIN
                                     CatchStaff();
                                     REPORT.RUN(50060,TRUE,FALSE,Vend);
                                   END;

                                 END ELSE BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","FOSA Account");
                                 IF Vend.FINDFIRST THEN
                                   BEGIN
                                     CatchStaff();
                                     REPORT.RUN(51516201,TRUE,FALSE,Vend);
                                   END;
                                 END;
                               END;
                                }
      { 1102755003;2 ;Action    ;
                      Name=Account Closure Slip;
                      CaptionML=ENU=Account Closure Slip;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN

                                 REPORT.RUN(51516250,TRUE,FALSE,Cust);
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=update;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust.Status,Cust.Status::Active);
                                 IF Cust.FINDSET THEN BEGIN
                                 REPEAT
                                 IF Cust."Customer Posting Group"=''THEN BEGIN
                                    Cust."Customer Posting Group":='MEMBER';
                                    Cust.MODIFY;
                                 END;
                                 UNTIL Cust.NEXT=0;
                                 END;
                               END;
                                }
      { 1120054016;2 ;Action    ;
                      Name=FOSA Statement(Test);
                      CaptionML=ENU=FOSA Statement.;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","FOSA Account");
                                 IF Vend.FINDFIRST THEN
                                   BEGIN
                                     CatchStaff();
                                     REPORT.RUN(50230,TRUE,FALSE,Vend);
                                   END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                SourceExpr="No." }

    { 1120054009;2;Field  ;
                SourceExpr=Station }

    { 1000000003;2;Field  ;
                SourceExpr="Old Account No." }

    { 1120054010;2;Field  ;
                SourceExpr="Name 2" }

    { 1120054013;2;Field  ;
                SourceExpr="Customer Posting Group" }

    { 4   ;2   ;Field     ;
                SourceExpr=Name }

    { 1000000000;2;Field  ;
                SourceExpr="Payroll/Staff No" }

    { 1102755026;2;Field  ;
                SourceExpr="ID No." }

    { 1120054008;2;Field  ;
                SourceExpr="Loan Defaulter" }

    { 3   ;2   ;Field     ;
                SourceExpr="Registration Date" }

    { 1120054018;2;Field  ;
                SourceExpr="Registration Fee Paid" }

    { 1120054021;2;Field  ;
                SourceExpr="Open Bal Deposits" }

    { 1120054019;2;Field  ;
                SourceExpr="Benevolent Fund" }

    { 5   ;2   ;Field     ;
                SourceExpr="Phone No." }

    { 9   ;2   ;Field     ;
                SourceExpr="E-Mail" }

    { 6   ;2   ;Field     ;
                SourceExpr="E-Mail (Personal)" }

    { 8   ;2   ;Field     ;
                SourceExpr="FOSA Account" }

    { 7   ;2   ;Field     ;
                SourceExpr="Employer Code" }

    { 1102755030;2;Field  ;
                SourceExpr="Date Filter" }

    { 1000000004;2;Field  ;
                CaptionML=ENU=Account Status;
                SourceExpr=Status }

    { 1120054020;2;Field  ;
                SourceExpr="Membership Status" }

    { 1120054023;2;Field  ;
                SourceExpr="Loan Status" }

    { 1120054007;2;Field  ;
                CaptionML=ENU=Share Capital;
                SourceExpr="Shares Retained" }

    { 1120054005;2;Field  ;
                CaptionML=ENU=Deposits;
                SourceExpr="Current Shares" }

    { 1000000006;2;Field  ;
                SourceExpr="Last Payment Date" }

    { 1120054006;2;Field  ;
                SourceExpr="Village/Residence" }

    { 1120054004;2;Field  ;
                SourceExpr="Pays Benevolent" }

    { 1120054015;2;Field  ;
                SourceExpr="Staff UserID" }

    { 1120054017;2;Field  ;
                SourceExpr="Recruited By" }

    { 1000000002;0;Container;
                ContainerType=FactBoxArea }

    { 1000000001;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516371;
                Visible=TRUE;
                PartType=Page }

  }
  CODE
  {
    VAR
      Cust@1102755000 : Record 51516223;
      GeneralSetup@1102755001 : Record 51516257;
      Gnljnline@1102755002 : Record 81;
      TotalRecovered@1102755003 : Decimal;
      TotalAvailable@1102755004 : Integer;
      Loans@1102755005 : Record 51516230;
      TotalFOSALoan@1102755006 : Decimal;
      TotalOustanding@1102755007 : Decimal;
      Vend@1102755008 : Record 23;
      TotalDefaulterR@1102755009 : Decimal;
      Value2@1102755010 : Decimal;
      AvailableShares@1102755011 : Decimal;
      Value1@1102755012 : Decimal;
      Interest@1102755013 : Decimal;
      LineN@1102755014 : Integer;
      LRepayment@1102755015 : Decimal;
      RoundingDiff@1102755016 : Decimal;
      DActivity@1102755017 : Code[20];
      DBranch@1102755018 : Code[20];
      LoansR@1102755019 : Record 51516230;
      LoanAllocation@1102755020 : Decimal;
      LGurantors@1102755021 : Record 51516231;
      Activate@1120054000 : Codeunit 51516164;
      Factory@1120054001 : Codeunit 51516022;
      DividendsProgression@1120054002 : Record 51516223;

    PROCEDURE GetSelectionFilter@2() : Code[80];
    VAR
      Cust@1000 : Record 51516223;
      FirstCust@1001 : Code[30];
      LastCust@1002 : Code[30];
      SelectionFilter@1003 : Code[250];
      CustCount@1004 : Integer;
      More@1005 : Boolean;
    BEGIN
      {CurrPage.SETSELECTIONFILTER(Cust);
      CustCount := Cust.COUNT;
      IF CustCount > 0 THEN BEGIN
        Cust.FIND('-');
        WHILE CustCount > 0 DO BEGIN
          CustCount := CustCount - 1;
          Cust.MARKEDONLY(FALSE);
          FirstCust := Cust."No.";
          LastCust := FirstCust;
          More := (CustCount > 0);
          WHILE More DO
            IF Cust.NEXT = 0 THEN
              More := FALSE
            ELSE
              IF NOT Cust.MARK THEN
                More := FALSE
              ELSE BEGIN
                LastCust := Cust."No.";
                CustCount := CustCount - 1;
                IF CustCount = 0 THEN
                  More := FALSE;
              END;
          IF SelectionFilter <> '' THEN
            SelectionFilter := SelectionFilter + '|';
          IF FirstCust = LastCust THEN
            SelectionFilter := SelectionFilter + FirstCust
          ELSE
            SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
          IF CustCount > 0 THEN BEGIN
            Cust.MARKEDONLY(TRUE);
            Cust.NEXT;
          END;
        END;
      END;
      EXIT(SelectionFilter);
      }
    END;

    PROCEDURE SetSelection@1(VAR Cust@1000 : Record 51516223);
    BEGIN
      //CurrPage.SETSELECTIONFILTER(Cust);
    END;

    PROCEDURE CatchStaff@1000000003();
    BEGIN
      IF Vend."Company Code"='STAFF' THEN
        BEGIN
          IF "Staff UserID"<>USERID THEN
            ERROR('You cannot view a statement belonging to another member of staff!');
        END;
    END;

    BEGIN
    END.
  }
}

