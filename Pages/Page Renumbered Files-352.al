OBJECT page 50043 Member WithBatch List posted
{
  OBJECT-PROPERTIES
  {
    Date=09/06/19;
    Time=10:44:38 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516353;
    SourceTableView=WHERE(Posted=FILTER(Yes));
    PageType=List;
    CardPageID=Member WithBatch Card Posted;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755011;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755010;1 ;ActionGroup;
                      Name=LoansB;
                      CaptionML=ENU=Batch }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1102760020;2;Field  ;
                SourceExpr=Source;
                Editable=false }

    { 1102760003;2;Field  ;
                SourceExpr="Description/Remarks";
                Editable=false }

    { 1000000000;2;Field  ;
                SourceExpr="Posting Date";
                Editable=false }

    { 1102760018;2;Field  ;
                SourceExpr="No of Withdrawals";
                Editable=FALSE }

    { 1102760016;2;Field  ;
                SourceExpr="Mode Of Disbursement";
                Editable=false }

    { 1000000001;2;Field  ;
                SourceExpr="Prepared By" }

    { 1000000002;2;Field  ;
                SourceExpr="Approved By" }

  }
  CODE
  {
    VAR
      ApprovalsSetup@1102755133 : Record 452;
      MovementTracker@1102755132 : Record 51516254;
      FileMovementTracker@1102755131 : Record 51516254;
      NextStage@1102755130 : Integer;
      EntryNo@1102755129 : Integer;
      NextLocation@1102755128 : Text[100];
      LoansBatch@1102755127 : Record 51516236;
      i@1102755126 : Integer;
      LoanType@1102755125 : Record 51516240;
      PeriodDueDate@1102755124 : Date;
      ScheduleRep@1102755123 : Record 51516234;
      RunningDate@1102755122 : Date;
      G@1102755121 : Integer;
      IssuedDate@1102755120 : Date;
      GracePeiodEndDate@1102755119 : Date;
      InstalmentEnddate@1102755118 : Date;
      GracePerodDays@1102755117 : Integer;
      InstalmentDays@1102755116 : Integer;
      NoOfGracePeriod@1102755115 : Integer;
      NewSchedule@1102755114 : Record 51516234;
      RSchedule@1102755113 : Record 51516234;
      GP@1102755112 : Text[30];
      ScheduleCode@1102755111 : Code[20];
      PreviewShedule@1102755110 : Record 51516234;
      PeriodInterval@1102755109 : Code[10];
      CustomerRecord@1102755108 : Record 51516223;
      Gnljnline@1102755107 : Record 81;
      Jnlinepost@1102755106 : Codeunit 12;
      CumInterest@1102755105 : Decimal;
      NewPrincipal@1102755104 : Decimal;
      PeriodPrRepayment@1102755103 : Decimal;
      GenBatch@1102755102 : Record 232;
      LineNo@1102755101 : Integer;
      GnljnlineCopy@1102755100 : Record 81;
      NewLNApplicNo@1102755099 : Code[10];
      Cust@1102755098 : Record 51516223;
      LoanApp@1102755097 : Record 51516230;
      TestAmt@1102755096 : Decimal;
      CustRec@1102755095 : Record 51516223;
      CustPostingGroup@1102755094 : Record 92;
      GenSetUp@1102755093 : Record 51516257;
      PCharges@1102755092 : Record 51516242;
      TCharges@1102755091 : Decimal;
      LAppCharges@1102755090 : Record 51516244;
      Loans@1102755089 : Record 51516230;
      LoanAmount@1102755088 : Decimal;
      InterestRate@1102755087 : Decimal;
      RepayPeriod@1102755086 : Integer;
      LBalance@1102755085 : Decimal;
      RunDate@1102755084 : Date;
      InstalNo@1102755083 : Decimal;
      RepayInterval@1102755082 : DateFormula;
      TotalMRepay@1102755081 : Decimal;
      LInterest@1102755080 : Decimal;
      LPrincipal@1102755079 : Decimal;
      RepayCode@1102755078 : Code[40];
      GrPrinciple@1102755077 : Integer;
      GrInterest@1102755076 : Integer;
      QPrinciple@1102755075 : Decimal;
      QCounter@1102755074 : Integer;
      InPeriod@1102755073 : DateFormula;
      InitialInstal@1102755072 : Integer;
      InitialGraceInt@1102755071 : Integer;
      GenJournalLine@1102755070 : Record 81;
      FOSAComm@1102755069 : Decimal;
      BOSAComm@1102755068 : Decimal;
      GLPosting@1102755067 : Codeunit 12;
      LoanTopUp@1102755066 : Record 51516235;
      Vend@1102755065 : Record 23;
      BOSAInt@1102755064 : Decimal;
      TopUpComm@1102755063 : Decimal;
      DActivity@1102755062 : Code[20];
      DBranch@1102755061 : Code[20];
      UsersID@1102755060 : Record 2000000120;
      TotalTopupComm@1102755059 : Decimal;
      Notification@1102755058 : Codeunit 397;
      CustE@1102755057 : Record 51516223;
      DocN@1102755056 : Text[50];
      DocM@1102755055 : Text[100];
      DNar@1102755054 : Text[250];
      DocF@1102755053 : Text[50];
      MailBody@1102755052 : Text[250];
      ccEmail@1102755051 : Text[250];
      LoanG@1102755050 : Record 51516231;
      SpecialComm@1102755049 : Decimal;
      LoanApps@1102755048 : Record 51516230;
      Banks@1102755047 : Record 270;
      BatchTopUpAmount@1102755046 : Decimal;
      BatchTopUpComm@1102755045 : Decimal;
      TotalSpecialLoan@1102755044 : Decimal;
      SpecialLoanCl@1102755043 : Record 51516238;
      Loans2@1102755042 : Record 51516230;
      DActivityBOSA@1102755041 : Code[20];
      DBranchBOSA@1102755040 : Code[20];
      Refunds@1102755039 : Record 51516240;
      TotalRefunds@1102755038 : Decimal;
      WithdrawalFee@1102755037 : Decimal;
      NetPayable@1102755036 : Decimal;
      NetRefund@1102755035 : Decimal;
      FWithdrawal@1102755034 : Decimal;
      OutstandingInt@1102755033 : Decimal;
      TSC@1102755032 : Decimal;
      LoanDisbAmount@1102755031 : Decimal;
      NegFee@1102755030 : Decimal;
      DValue@1102755029 : Record 349;
      ChBank@1102755028 : Code[20];
      Trans@1102755027 : Record 51516299;
      TransactionCharges@1102755026 : Record 51516300;
      BChequeRegister@1102755025 : Record 51516313;
      OtherCommitments@1102755024 : Record 51516262;
      BoostingComm@1102755023 : Decimal;
      BoostingCommTotal@1102755022 : Decimal;
      BridgedLoans@1102755021 : Record 51516238;
      InterestDue@1102755020 : Decimal;
      ContractualShares@1102755019 : Decimal;
      BridgingChanged@1102755018 : Boolean;
      BankersChqNo@1102755017 : Code[20];
      LastPayee@1102755016 : Text[100];
      RunningAmount@1102755015 : Decimal;
      BankersChqNo2@1102755014 : Code[20];
      BankersChqNo3@1102755013 : Code[20];
      EndMonth@1102755012 : Date;
      RemainingDays@1102755011 : Integer;
      PrincipalRepay@1102755010 : Decimal;
      InterestRepay@1102755009 : Decimal;
      TMonthDays@1102755008 : Integer;
      SMSMessage@1102755007 : Record 51516232;
      iEntryNo@1102755006 : Integer;
      Temp@1102755005 : Record 18;
      Jtemplate@1102755004 : Code[30];
      JBatch@1102755003 : Code[30];
      LBatches@1102755002 : Record 51516236;
      ApprovalMgt@1102755001 : Codeunit 439;
      DocumentType@1102755000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';

    BEGIN
    END.
  }
}

