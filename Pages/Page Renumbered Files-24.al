OBJECT page 20388 Payment Line
{
  OBJECT-PROPERTIES
  {
    Date=12/11/19;
    Time=10:24:50 AM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516001;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Payment Type";
                TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Payment)) }

    { 4   ;2   ;Field     ;
                Name=<BOSA Transaction Type>;
                CaptionML=ENU=BOSA Transaction Type;
                SourceExpr="Transaction Type" }

    { 5   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="Account No.";
                OnValidate=BEGIN
                             IF ("Account Type"="Account Type"::Member) THEN BEGIN
                             TESTFIELD("Transaction Type");
                             END;
                           END;
                            }

    { 7   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Loan No." }

    { 8   ;2   ;Field     ;
                SourceExpr="Payment Description" }

    { 11  ;2   ;Field     ;
                SourceExpr=Amount }

    { 12  ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 13  ;2   ;Field     ;
                SourceExpr="VAT Code" }

    { 14  ;2   ;Field     ;
                SourceExpr="VAT Amount" }

    { 15  ;2   ;Field     ;
                SourceExpr="VAT Amount(LCY)" }

    { 16  ;2   ;Field     ;
                SourceExpr="W/TAX Code" }

    { 17  ;2   ;Field     ;
                SourceExpr="W/TAX Amount" }

    { 18  ;2   ;Field     ;
                SourceExpr="W/TAX Amount(LCY)" }

    { 22  ;2   ;Field     ;
                SourceExpr="Net Amount" }

    { 23  ;2   ;Field     ;
                SourceExpr="Net Amount(LCY)" }

    { 30  ;2   ;Field     ;
                SourceExpr="Applies-to Doc. Type" }

    { 31  ;2   ;Field     ;
                SourceExpr="Applies-to Doc. No." }

    { 32  ;2   ;Field     ;
                SourceExpr="Applies-to ID" }

  }
  CODE
  {
    VAR
      FundsTypes@1011 : Record 51516032;
      PHeader@1010 : Record 51516000;
      "G/L Account"@1009 : Record 15;
      Customer@1008 : Record 18;
      Vendor@1007 : Record 23;
      Investor@1006 : Record 51516433;
      FundsTaxCodes@1005 : Record 51516033;
      CurrExchRate@1004 : Record 330;
      Loans@1003 : Record 51516230;
      Cust@1002 : Record 51516223;
      InvestorAmounts@1001 : Record 51516440;
      InterestCodes@1000 : Record 51516439;

    BEGIN
    END.
  }
}

