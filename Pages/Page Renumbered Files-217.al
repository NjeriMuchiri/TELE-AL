OBJECT page 17408 Loan Products Setup List
{
  OBJECT-PROPERTIES
  {
    Date=10/21/22;
    Time=11:11:00 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516240;
    PageType=List;
    CardPageID=Loan Products Setup Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ShowFilter=Yes;
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
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=General;
                GroupType=Repeater }

    { 1000000015;2;Field  ;
                SourceExpr=Code }

    { 1000000017;2;Field  ;
                SourceExpr="Product Description" }

    { 1000000005;2;Field  ;
                SourceExpr=Source }

    { 1120054000;2;Field  ;
                SourceExpr=ExemptInt }

    { 1000000021;2;Field  ;
                SourceExpr="Interest rate" }

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
                SourceExpr="No of Installment";
                OnValidate=BEGIN
                             IF "No of Installment"<="Default Installements"THEN BEGIN
                               "No of Installment":="Default Installements"
                               END;
                           END;
                            }

    { 1102760028;2;Field  ;
                SourceExpr="Default Installements";
                OnValidate=BEGIN
                             IF "No of Installment"<="Default Installements"THEN BEGIN
                               "No of Installment":="Default Installements"
                               END;
                           END;
                            }

    { 1000000009;2;Field  ;
                SourceExpr="Penalty Calculation Days" }

    { 1000000011;2;Field  ;
                SourceExpr="Penalty Percentage" }

    { 1102760024;2;Field  ;
                SourceExpr="Recovery Priority" }

    { 1102756004;2;Field  ;
                SourceExpr="Min No. Of Guarantors" }

    { 1102756006;2;Field  ;
                SourceExpr="Min Re-application Period" }

    { 1102755000;2;Field  ;
                SourceExpr="Shares Multiplier" }

    { 1000000013;2;Field  ;
                SourceExpr="Penalty Calculation Method" }

    { 1000000025;2;Field  ;
                SourceExpr="Penalty Paid Account" }

    { 1102760004;2;Field  ;
                SourceExpr="Min. Loan Amount" }

    { 1000000036;2;Field  ;
                SourceExpr="Max. Loan Amount" }

    { 1102760010;2;Field  ;
                SourceExpr="Loan Account" }

    { 1102760012;2;Field  ;
                SourceExpr="Loan Interest Account" }

    { 1102760014;2;Field  ;
                SourceExpr="Receivable Interest Account" }

    { 1102760008;2;Field  ;
                SourceExpr=Action }

    { 1102760006;2;Field  ;
                SourceExpr="BOSA Account" }

    { 1102760018;2;Field  ;
                SourceExpr="BOSA Personal Loan Account" }

    { 1102760020;2;Field  ;
                SourceExpr="Top Up Commision Account" }

    { 1102760022;2;Field  ;
                SourceExpr="Top Up Commision" }

    { 1102756000;2;Field  ;
                SourceExpr="Check Off Loan No." }

    { 1102755017;2;Field  ;
                SourceExpr="Repayment Frequency" }

    { 1120054001;2;Field  ;
                SourceExpr="Min LoanGuatantor Amount" }

    { 1120054002;2;Field  ;
                SourceExpr="Max LoanGuatantor Amount" }

  }
  CODE
  {
    VAR
      "No of Installment"@1120054000 : Record 51516240;
      "Default Installments"@1120054001 : Record 51516240;
      Installments@1120054002 : Record 51516230;

    BEGIN
    END.
  }
}

