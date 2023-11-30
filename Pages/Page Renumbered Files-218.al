OBJECT page 17409 Sacco General Set-Up
{
  OBJECT-PROPERTIES
  {
    Date=03/29/23;
    Time=12:51:40 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516257;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760007;1 ;ActionGroup;
                      CaptionML=ENU=Shares Bands }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760010;1 ;Action    ;
                      CaptionML=ENU=Reset Data Sheet;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN
                                 Cust.MODIFYALL(Cust.Advice,FALSE);


                                 Loans.RESET;
                                 Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                 IF Loans.FIND('-') THEN
                                 Loans.MODIFYALL(Loans.Advice,FALSE);


                                 MESSAGE('Reset Completed successfully.');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                Name=General;
                CaptionML=ENU=General }

    { 1000000003;2;Field  ;
                SourceExpr="Max. Non Contribution Periods" }

    { 1000000005;2;Field  ;
                SourceExpr="Min. Contribution" }

    { 1120054027;2;Field  ;
                SourceExpr="UFAA Duration" }

    { 1102755020;2;Field  ;
                SourceExpr="Min. Member Age" }

    { 1102755019;2;Field  ;
                SourceExpr="Retirement Age" }

    { 1120054024;2;Field  ;
                SourceExpr="Dormancy Period" }

    { 1000000002;2;Field  ;
                SourceExpr="Maximum No of Loans Guaranteed" }

    { 1102755022;2;Field  ;
                SourceExpr="Min. Guarantors" }

    { 1102755021;2;Field  ;
                SourceExpr="Max. Guarantors" }

    { 1120054026;2;Field  ;
                SourceExpr="Guarantors Multiplier" }

    { 1102755024;2;Field  ;
                SourceExpr="Min. Loan Application Period" }

    { 1120054030;2;Field  ;
                SourceExpr="Max SMS Charge Dividend Amount" }

    { 1102755014;2;Field  ;
                SourceExpr="Dividend (%)" }

    { 1120054018;2;Field  ;
                SourceExpr="Dividends Bal Account" }

    { 1120054019;2;Field  ;
                SourceExpr="Dividends Processing Fee" }

    { 1120054033;2;Field  ;
                SourceExpr="Interest Capitalizing %" }

    { 1120054035;2;Field  ;
                SourceExpr="Int Deduction Max Amount" }

    { 1120054034;2;Field  ;
                SourceExpr="Int Capitalizing Min Amount" }

    { 1120054017;2;Field  ;
                SourceExpr="Deposits Interest%" }

    { 1120054020;2;Field  ;
                SourceExpr="Deposits Int  Bal Account" }

    { 1120054021;2;Field  ;
                SourceExpr="Deposits int Processing Fee" }

    { 1120054016;2;Field  ;
                SourceExpr="ESS Interest%" }

    { 1120054022;2;Field  ;
                SourceExpr="ESS Int  Bal Account" }

    { 1120054023;2;Field  ;
                SourceExpr="ESS int Processing Fee" }

    { 1120054028;2;Field  ;
                SourceExpr="Savings Interest%" }

    { 1120054029;2;Field  ;
                SourceExpr="Savings Bal Account" }

    { 1000000007;2;Field  ;
                SourceExpr="Min. Dividend Proc. Period" }

    { 1000000017;2;Field  ;
                SourceExpr="Member Can Guarantee Own Loan" }

    { 1102755012;2;Field  ;
                SourceExpr="Days for Checkoff" }

    { 1000000022;2;Field  ;
                SourceExpr="Contactual Shares (%)" }

    { 1102760004;2;Field  ;
                SourceExpr="Use Bands" }

    { 1102755038;2;Field  ;
                SourceExpr="Maximum No of Guarantees" }

    { 1000000052;2;Field  ;
                SourceExpr="Max. Contactual Shares" }

    { 1000000024;2;Field  ;
                SourceExpr="Commision (%)" }

    { 1000000072;2;Field  ;
                SourceExpr="Withholding Tax (%)" }

    { 1000000029;2;Field  ;
                SourceExpr="Statement Fee" }

    { 1102760000;2;Field  ;
                SourceExpr="Withdrawal Fee" }

    { 1000000023;2;Field  ;
                SourceExpr="Withdrawal Commision" }

    { 1   ;2   ;Field     ;
                SourceExpr="Withdrawal Fee Account" }

    { 1102760002;2;Field  ;
                SourceExpr="Retained Shares" }

    { 1102756010;2;Field  ;
                SourceExpr="Interest on Deposits (%)" }

    { 1000000026;2;Field  ;
                CaptionML=ENU=Membership Fee;
                SourceExpr="Registration Fee" }

    { 1000000001;2;Field  ;
                SourceExpr="Rejoining Fee" }

    { 1000000028;2;Field  ;
                CaptionML=ENU=Insurance Contribution;
                SourceExpr="Welfare Contribution" }

    { 1000000056;2;Field  ;
                SourceExpr="Boosting Shares %" }

    { 1102755005;2;Field  ;
                SourceExpr="Excise Duty(%)" }

    { 1120054015;2;Field  ;
                SourceExpr="Express Loan Charge" }

    { 1000000058;2;Field  ;
                SourceExpr="Boosting Shares Maturity (M)" }

    { 1000000044;2;Field  ;
                SourceExpr="Approved Loans Letter" }

    { 1102755009;2;Field  ;
                SourceExpr="ATM Expiry Duration" }

    { 1000000050;2;Field  ;
                SourceExpr="Rejected Loans Letter" }

    { 1102755037;2;Field  ;
                SourceExpr="Monthly Share Contributions" }

    { 1000000004;2;Field  ;
                CaptionML=ENU=Auto Open Agile Savings Acc.;
                SourceExpr="Auto Open FOSA Savings Acc." }

    { 1000000011;2;Field  ;
                SourceExpr="FOSA Account Type" }

    { 1000000025;2;Field  ;
                SourceExpr="Customer Care No" }

    { 1000000006;2;Field  ;
                SourceExpr="Send SMS Notifications" }

    { 1000000008;2;Field  ;
                SourceExpr="Send Email Notifications" }

    { 1000000009;2;Field  ;
                CaptionML=ENU=Auto Fill S-Pesa Application;
                SourceExpr="Auto Fill Msacco Application" }

    { 1000000010;2;Field  ;
                SourceExpr="Auto Fill ATM Application" }

    { 1120054002;2;Field  ;
                SourceExpr="Checkoff Cutoff Days" }

    { 1120054003;2;Field  ;
                SourceExpr="Salary Cutoff Days" }

    { 1120054004;2;Field  ;
                SourceExpr="Price Per Share" }

    { 1120054005;2;Field  ;
                SourceExpr="Co-op Shares Charge G/L" }

    { 1120054006;2;Field  ;
                SourceExpr="Co-op Share Transfer Charge" }

    { 1120054007;2;Field  ;
                SourceExpr="Co-op Shares Control Acc" }

    { 1120054025;2;Field  ;
                SourceExpr="Coop-Shares Processing Fee" }

    { 1120054010;2;Field  ;
                SourceExpr="Co-op Shares Dividend %" }

    { 1120054012;2;Field  ;
                SourceExpr="WithHolding Tax G/L" }

    { 1120054011;2;Field  ;
                SourceExpr="Co-op Shares Dividend Payable" }

    { 1120054008;2;Field  ;
                SourceExpr="Minimum Purchasable Shares" }

    { 1120054009;2;Field  ;
                SourceExpr="Maximum Purchasable Shares" }

    { 1120054013;2;Field  ;
                SourceExpr="Members Cutoff Period" }

    { 1120054014;2;Field  ;
                SourceExpr="Minimum Share Capital" }

    { 1102755001;1;Group  ;
                CaptionML=ENU=Mail Setup;
                GroupType=Group }

    { 1102755010;2;Field  ;
                SourceExpr="Incoming Mail Server" }

    { 1102755008;2;Field  ;
                SourceExpr="Outgoing Mail Server" }

    { 1102755006;2;Field  ;
                SourceExpr="Email Text" }

    { 1102755004;2;Field  ;
                SourceExpr="Sender User ID" }

    { 1102755002;2;Field  ;
                SourceExpr="Sender Address" }

    { 1102755000;2;Field  ;
                SourceExpr="Email Subject" }

    { 1102755028;2;Field  ;
                SourceExpr="Statement Message #1" }

    { 1102755027;2;Field  ;
                SourceExpr="Statement Message #2" }

    { 1102755026;2;Field  ;
                SourceExpr="Statement Message #3" }

    { 1102755025;2;Field  ;
                SourceExpr="Statement Message #4" }

    { 1102755013;1;Group  ;
                CaptionML=ENU=Numbering;
                GroupType=Group }

    { 1120054001;2;Field  ;
                SourceExpr="Overdrafft%" }

    { 1000000012;2;Field  ;
                SourceExpr="Overdraft App Nos." }

    { 1120054031;2;Field  ;
                SourceExpr=BusinessGNos }

    { 1120054032;2;Field  ;
                SourceExpr=ReatNos }

    { 1102755023;1;Group  ;
                CaptionML=ENU=Others;
                GroupType=Group }

    { 1102755031;2;Field  ;
                SourceExpr="Insurance Retension Account" }

    { 1000000030;2;Field  ;
                SourceExpr="Statement Fee Account" }

    { 1102755030;2;Field  ;
                SourceExpr="Shares Retension Account" }

    { 1102755029;2;Field  ;
                SourceExpr="Loan Transfer Fees Account" }

    { 1102755018;2;Field  ;
                SourceExpr="Boosting Fees Account" }

    { 1102755017;2;Field  ;
                SourceExpr="Bridging Commision Account" }

    { 1102755016;2;Field  ;
                SourceExpr="Funeral Expenses Amount" }

    { 1102755015;2;Field  ;
                SourceExpr="Funeral Expenses Account" }

    { 1102755007;2;Field  ;
                SourceExpr="Excise Duty Account" }

    { 1000000027;2;Field  ;
                SourceExpr="Commission on FOSA Overdraft" }

    { 1000000013;1;Group  ;
                Name=ATM;
                GroupType=Group }

    { 1000000014;2;Field  ;
                SourceExpr="ATM Card Fee-New Coop" }

    { 1000000020;2;Field  ;
                SourceExpr="ATM Card Fee-New Sacco" }

    { 1000000015;2;Field  ;
                SourceExpr="ATM Card Fee-Replacement" }

    { 1000000016;2;Field  ;
                SourceExpr="ATM Card Fee-Renewal" }

    { 1000000018;2;Field  ;
                SourceExpr="ATM Card Fee-Account" }

    { 1000000019;2;Field  ;
                SourceExpr="ATM Card Fee Co-op Bank" }

    { 1000000021;2;Field  ;
                SourceExpr="ATM Card Co-op Bank Amount" }

    { 1120054000;2;Field  ;
                SourceExpr="ATM Withdrawal Limit Amount" }

  }
  CODE
  {
    VAR
      Cust@1102760000 : Record 51516223;
      Loans@1102760001 : Record 51516230;

    BEGIN
    END.
  }
}

