OBJECT page 172160 Credited Fixed deposit list
{
  OBJECT-PROPERTIES
  {
    Date=06/03/22;
    Time=10:10:53 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516015;
    SourceTableView=WHERE(Posted=FILTER(No),
                          Fixed=FILTER(Yes));
    PageType=List;
    CardPageID=Fixed Deposit Application;
    OnAfterGetRecord=BEGIN
                       Rec.SETFILTER(MaturityDate,'>%1',TODAY);
                     END;

  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="FD No";
                Editable=false }

    { 1120054003;2;Field  ;
                SourceExpr="Account No";
                Editable=false }

    { 1120054004;2;Field  ;
                SourceExpr="Account Name";
                Editable=false }

    { 1120054005;2;Field  ;
                SourceExpr="Fd Duration";
                Editable=false }

    { 1120054007;2;Field  ;
                SourceExpr=Amount;
                Editable=false }

    { 1120054008;2;Field  ;
                SourceExpr=InterestRate;
                Editable=false }

    { 1120054006;2;Field  ;
                SourceExpr="ID NO";
                Editable=false }

    { 1120054009;2;Field  ;
                SourceExpr="Creted by";
                Editable=false }

    { 1120054010;2;Field  ;
                CaptionML=ENU=<interest Less Tax>;
                SourceExpr=interestLessTax;
                Editable=false }

    { 1120054011;2;Field  ;
                SourceExpr="Amount After maturity";
                Editable=false }

    { 1120054012;2;Field  ;
                SourceExpr=Date;
                Editable=false }

    { 1120054013;2;Field  ;
                SourceExpr=MaturityDate;
                Editable=false }

    { 1120054014;2;Field  ;
                SourceExpr=Posted;
                Enabled=false }

  }
  CODE
  {
    VAR
      LoanBalance@1120054102 : Decimal;
      AvailableBalance@1120054101 : Decimal;
      UnClearedBalance@1120054100 : Decimal;
      LoanSecurity@1120054099 : Decimal;
      LoanGuaranteed@1120054098 : Decimal;
      GenJournalLine@1120054097 : Record 81;
      DefaultBatch@1120054096 : Record 232;
      GLPosting@1120054095 : Codeunit 12;
      window@1120054094 : Dialog;
      Account@1120054093 : Record 23;
      TransactionTypes@1120054092 : Record 51516298;
      TransactionCharges@1120054091 : Record 51516300;
      TCharges@1120054090 : Decimal;
      LineNo@1120054089 : Integer;
      AccountTypes@1120054088 : Record 51516295;
      GenLedgerSetup@1120054087 : Record 98;
      MinAccBal@1120054086 : Decimal;
      FeeBelowMinBal@1120054085 : Decimal;
      AccountNo@1120054084 : Code[30];
      NewAccount@1120054083 : Boolean;
      CurrentTellerAmount@1120054082 : Decimal;
      TellerTill@1120054081 : Record 270;
      IntervalPenalty@1120054080 : Decimal;
      StandingOrders@1120054079 : Record 51516307;
      AccountAmount@1120054078 : Decimal;
      STODeduction@1120054077 : Decimal;
      Charges@1120054076 : Record 51516297;
      "Total Deductions"@1120054075 : Decimal;
      STODeductedAmount@1120054074 : Decimal;
      NoticeAmount@1120054073 : Decimal;
      AccountNotices@1120054072 : Record 51516296;
      Cust@1120054071 : Record 51516223;
      AccountHolders@1120054070 : Record 23;
      ChargesOnFD@1120054069 : Decimal;
      TotalGuaranted@1120054068 : Decimal;
      VarAmtHolder@1120054067 : Decimal;
      chqtransactions@1120054066 : Record 51516299;
      Trans@1120054065 : Record 51516299;
      TotalUnprocessed@1120054064 : Decimal;
      CustAcc@1120054063 : Record 51516223;
      AmtAfterWithdrawal@1120054062 : Decimal;
      TransactionsRec@1120054061 : Record 51516299;
      LoansTotal@1120054060 : Decimal;
      Interest@1120054059 : Decimal;
      InterestRate@1120054058 : Decimal;
      OBal@1120054057 : Decimal;
      Principal@1120054056 : Decimal;
      ATMTrans@1120054055 : Decimal;
      ATMBalance@1120054054 : Decimal;
      TotalBal@1120054053 : Decimal;
      DenominationsRec@1120054052 : Record 51516303;
      TillNo@1120054051 : Code[20];
      FOSASetup@1120054050 : Record 312;
      Acc@1120054049 : Record 23;
      ChequeTypes@1120054048 : Record 51516304;
      ChargeAmount@1120054047 : Decimal;
      TChargeAmount@1120054046 : Decimal;
      DActivity@1120054045 : Code[20];
      DBranch@1120054044 : Code[20];
      UsersID@1120054043 : Record 2000000120;
      ChBank@1120054042 : Code[20];
      DValue@1120054041 : Record 349;
      ReceiptAllocations@1120054040 : Record 51516246;
      Loans@1120054039 : Record 51516230;
      Commision@1120054038 : Decimal;
      Cheque@1120054037 : Boolean;
      LOustanding@1120054036 : Decimal;
      TotalCommision@1120054035 : Decimal;
      TotalOustanding@1120054034 : Decimal;
      BOSABank@1120054033 : Code[20];
      InterestPaid@1120054032 : Decimal;
      PaymentAmount@1120054031 : Decimal;
      RunBal@1120054030 : Decimal;
      Recover@1120054029 : Boolean;
      genSetup@1120054028 : Record 51516257;
      MailContent@1120054027 : Text[150];
      supervisor@1120054026 : Record 51516309;
      AccP@1120054025 : Record 23;
      LoansR@1120054024 : Record 51516230;
      ClearingCharge@1120054023 : Decimal;
      ClearingRate@1120054022 : Decimal;
      FChequeVisible@1120054021 : Boolean INDATASET;
      BChequeVisible@1120054020 : Boolean INDATASET;
      BReceiptVisible@1120054019 : Boolean INDATASET;
      BOSAReceiptChequeVisible@1120054018 : Boolean INDATASET;
      "Branch RefferenceVisible"@1120054017 : Boolean INDATASET;
      LRefVisible@1120054016 : Boolean INDATASET;
      "Transaction DateEditable"@1120054015 : Boolean INDATASET;
      Excise@1120054014 : Decimal;
      Echarge@1120054013 : Decimal;
      BankLedger@1120054012 : Record 271;
      SMSMessage@1120054011 : Record 51516329;
      iEntryNo@1120054010 : Integer;
      Vend1@1120054009 : Record 23;
      TransDesc@1120054008 : Text;
      TransTypes@1120054007 : Record 51516298;
      ObjTransactionCharges@1120054006 : Record 51516300;
      AccountBalance@1120054005 : Decimal;
      MinimumBalance@1120054004 : Decimal;
      TransactionAmount@1120054003 : Decimal;
      WithCharges@1120054002 : Decimal;
      fixedno@1120054001 : Code[30];
      fixeddeposit@1120054000 : Record 51516015;

    BEGIN
    END.
  }
}

