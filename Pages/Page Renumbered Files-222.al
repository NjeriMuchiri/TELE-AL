OBJECT page 17413 Loan Products Setup Card
{
  OBJECT-PROPERTIES
  {
    Date=08/29/23;
    Time=[ 3:33:39 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516240;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000027;1 ;ActionGroup;
                      CaptionML=ENU=Product }
      { 1102755016;2 ;Action    ;
                      CaptionML=ENU=Product Charges;
                      RunObject=page 17419;
                      RunPageLink=Product Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Setup;
                      PromotedCategory=Process }
      { 1120054026;2 ;Action    ;
                      Name=Insider lending;
                      RunObject=Page 50001;
                      RunPageLink=Product Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Setup;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=General }

    { 1000000015;2;Field  ;
                SourceExpr=Code }

    { 1000000017;2;Field  ;
                SourceExpr="Product Description" }

    { 1000000005;2;Field  ;
                SourceExpr=Source }

    { 1120054001;2;Field  ;
                SourceExpr=ExemptInt }

    { 1000000021;2;Field  ;
                SourceExpr="Interest rate" }

    { 1120054025;2;Field  ;
                SourceExpr="Minimum Monthly Contribution" }

    { 1000000003;2;Field  ;
                CaptionML=ENU=Interest Rate-Total Outstanding above 1.5 M;
                SourceExpr="Interest Rate-Outstanding >1.5" }

    { 1000000007;2;Field  ;
                SourceExpr="Repayment Method" }

    { 1102760000;2;Field  ;
                SourceExpr="Grace Period - Principle (M)" }

    { 1102760002;2;Field  ;
                SourceExpr="Grace Period - Interest (M)" }

    { 1000000031;2;Field  ;
                SourceExpr="Use Cycles" }

    { 1000000002;2;Field  ;
                SourceExpr="Instalment Period" }

    { 1000000001;2;Field  ;
                SourceExpr="No of Installment" }

    { 1102760028;2;Field  ;
                SourceExpr="Default Installements" }

    { 1120054002;2;Field  ;
                SourceExpr="Staff Loan" }

    { 1000000009;2;Field  ;
                SourceExpr="Penalty Calculation Days" }

    { 1000000011;2;Field  ;
                SourceExpr="Penalty Percentage" }

    { 1120054012;2;Field  ;
                SourceExpr="Recovery Mode" }

    { 1102760024;2;Field  ;
                SourceExpr="Recovery Priority" }

    { 1120054009;2;Field  ;
                SourceExpr="salary Earner" }

    { 1102756004;2;Field  ;
                SourceExpr="Min No. Of Guarantors" }

    { 1102756006;2;Field  ;
                SourceExpr="Min Re-application Period" }

    { 1102755000;2;Field  ;
                CaptionML=ENU=BOSA Deposits Multiplier;
                SourceExpr="Shares Multiplier" }

    { 1000000013;2;Field  ;
                SourceExpr="Penalty Calculation Method" }

    { 1102755019;2;Field  ;
                SourceExpr="Self guaranteed Multiplier" }

    { 1102755005;2;Field  ;
                SourceExpr="Loan Product Expiry Date" }

    { 1000000025;2;Field  ;
                SourceExpr="Penalty Paid Account" }

    { 1102755002;2;Field  ;
                SourceExpr="Penalty Charged Account" }

    { 1102760004;2;Field  ;
                SourceExpr="Min. Loan Amount" }

    { 1000000036;2;Field  ;
                SourceExpr="Max. Loan Amount" }

    { 1120054011;2;Field  ;
                SourceExpr="Salaried Max Loan Amount" }

    { 1102755021;2;Field  ;
                SourceExpr="Check Off Recovery" }

    { 1102760010;2;Field  ;
                SourceExpr="Loan Account" }

    { 1102760012;2;Field  ;
                SourceExpr="Loan Interest Account" }

    { 1102760014;2;Field  ;
                SourceExpr="Receivable Interest Account" }

    { 1102755025;2;Field  ;
                SourceExpr="Receivable Insurance Accounts" }

    { 1102760020;2;Field  ;
                CaptionML=ENU=Levy on Bridging Loans Account;
                SourceExpr="Top Up Commision Account" }

    { 1102760022;2;Field  ;
                CaptionML=ENU=Bridging Levy %;
                SourceExpr="Top Up Commision" }

    { 1102755017;2;Field  ;
                SourceExpr="Repayment Frequency" }

    { 1102755022;2;Field  ;
                SourceExpr="Deposits Multiplier" }

    { 1102755023;2;Field  ;
                SourceExpr="Dont Recover Repayment" }

    { 1000000004;2;Field  ;
                SourceExpr="Post to Deposits" }

    { 1120054003;2;Field  ;
                SourceExpr="Deposit Boost %" }

    { 1000000006;2;Field  ;
                SourceExpr="Share Cap %" }

    { 1000000008;2;Field  ;
                SourceExpr="Max Share Cap" }

    { 1000000010;2;Field  ;
                SourceExpr="Bank Comm %" }

    { 1000000012;2;Field  ;
                SourceExpr="Bank Comm A/c" }

    { 1120054000;2;Field  ;
                SourceExpr="No Qlf  Per Deposits" }

    { 1120054013;2;Field  ;
                SourceExpr="Expected Threshhold Duration" }

    { 1903880701;1;Group  ;
                CaptionML=ENU=Qualification Criteria;
                GroupType=Group }

    { 1120054010;2;Field  ;
                SourceExpr="Appraise By School Fee Shares" }

    { 1102755004;2;Field  ;
                CaptionML=ENU=Deposits;
                SourceExpr="Appraise Deposits" }

    { 1102755006;2;Field  ;
                CaptionML=ENU=Shares;
                SourceExpr="Appraise Shares" }

    { 1102755010;2;Field  ;
                CaptionML=ENU=Salary;
                SourceExpr="Appraise Salary" }

    { 1102755003;2;Field  ;
                SourceExpr="Appraise Guarantors" }

    { 1102755001;2;Field  ;
                SourceExpr="Appraise Business" }

    { 1102755020;2;Field  ;
                SourceExpr="Appraise Dividend" }

    { 1120054004;1;Group  ;
                Name=SKy Mbanking;
                GroupType=Group }

    { 1120054005;2;Field  ;
                SourceExpr="USSD Product Name" }

    { 1120054006;2;Field  ;
                SourceExpr=AvailableOnMobile }

    { 1120054007;2;Field  ;
                SourceExpr="Interest Charged Upfront" }

    { 1120054008;2;Field  ;
                SourceExpr="Interest Recovered Upfront" }

    { 1120054015;2;Field  ;
                SourceExpr="Mobile Loan Req. Guar." }

    { 1120054016;2;Field  ;
                SourceExpr="Requires Purpose" }

    { 1120054017;2;Field  ;
                SourceExpr="Requires Branch" }

    { 1120054018;2;Field  ;
                SourceExpr="Mobile Min. Guarantors" }

    { 1120054019;2;Field  ;
                SourceExpr="Min. Mobile Installments" }

    { 1120054020;2;Field  ;
                SourceExpr="Max. Mobile Installments" }

    { 1120054021;2;Field  ;
                SourceExpr="Mobile Max. Guarantors" }

    { 1120054023;2;Field  ;
                SourceExpr="Min LoanGuatantor Amount" }

    { 1120054024;2;Field  ;
                SourceExpr="Max LoanGuatantor Amount" }

    { 1120054014;2;Field  ;
                SourceExpr=KeyWord }

    { 1120054022;2;Field  ;
                SourceExpr="Requires TnC" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

