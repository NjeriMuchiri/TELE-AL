OBJECT page 50044 Member WithBatch Card Posted
{
  OBJECT-PROPERTIES
  {
    Date=09/06/19;
    Time=[ 1:11:25 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516353;
    SourceTableView=WHERE(Posted=CONST(Yes));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnAfterGetCurrRecord=BEGIN
                           UpdateControl();
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760025;1 ;ActionGroup;
                      Name=LoansB;
                      CaptionML=ENU=Batch }
      { 1102760034;2 ;Separator  }
      { 1       ;2   ;Action    ;
                      Name=Export EFT;
                      CaptionML=ENU=Export EFT;
                      Image=SuggestPayment;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Batch No.","Batch No.");
                                 IF LoanApp.FIND('-') THEN BEGIN

                                 XMLPORT.RUN(51516012,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760005;1;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1102755006;1;Field  ;
                SourceExpr=Source;
                Editable=SourceEditable }

    { 1102760032;1;Field  ;
                SourceExpr="Batch Type";
                Editable=FALSE }

    { 1102760003;1;Field  ;
                SourceExpr="Description/Remarks";
                Editable=FALSE }

    { 1102755000;1;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102760019;1;Field  ;
                SourceExpr="Total Net Refund Amount" }

    { 1102760029;1;Field  ;
                SourceExpr="No of Withdrawals" }

    { 1102760011;1;Field  ;
                SourceExpr="Mode Of Disbursement";
                Editable=false;
                OnValidate=BEGIN
                             {IF "Mode Of Disbursement"="Mode Of Disbursement"::EFT THEN
                             "Cheque No.":="Batch No.";
                             MODIFY;  }
                             IF "Mode Of Disbursement"<>"Mode Of Disbursement"::"2" THEN
                             "Cheque No.":="Batch No.";
                             MODIFY;
                           END;
                            }

    { 1102760013;1;Field  ;
                SourceExpr="Document No.";
                Editable=False;
                OnValidate=BEGIN
                             {IF STRLEN("Document No.") > 6 THEN
                               ERROR('Document No. cannot contain More than 6 Characters.');
                               }
                           END;
                            }

    { 1102760009;1;Field  ;
                SourceExpr="Posting Date";
                Editable=false }

    { 1102760015;1;Field  ;
                CaptionML=ENU=Paying Bank;
                SourceExpr="BOSA Bank Account";
                Editable=false }

    { 1000000001;1;Field  ;
                SourceExpr="Prepared By" }

    { 1102755001;1;Part   ;
                Name=`;
                SubPageLink=Batch No.=FIELD(Batch No.);
                PagePartID=Page51516409;
                Editable=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      Text001@1102755004 : TextConst 'ENU=Status must be open';
      MovementTracker@1132 : Record 51516254;
      FileMovementTracker@1131 : Record 51516254;
      NextStage@1130 : Integer;
      EntryNo@1129 : Integer;
      NextLocation@1128 : Text[100];
      LoansBatch@1127 : Record 51516236;
      i@1126 : Integer;
      LoanType@1125 : Record 51516240;
      PeriodDueDate@1124 : Date;
      ScheduleRep@1123 : Record 51516234;
      RunningDate@1122 : Date;
      G@1121 : Integer;
      IssuedDate@1120 : Date;
      GracePeiodEndDate@1119 : Date;
      InstalmentEnddate@1118 : Date;
      GracePerodDays@1117 : Integer;
      InstalmentDays@1116 : Integer;
      NoOfGracePeriod@1115 : Integer;
      NewSchedule@1114 : Record 51516234;
      RSchedule@1113 : Record 51516234;
      GP@1112 : Text[30];
      ScheduleCode@1111 : Code[20];
      PreviewShedule@1110 : Record 51516234;
      PeriodInterval@1109 : Code[10];
      CustomerRecord@1108 : Record 51516223;
      Gnljnline@1107 : Record 81;
      Jnlinepost@1106 : Codeunit 12;
      CumInterest@1105 : Decimal;
      NewPrincipal@1104 : Decimal;
      PeriodPrRepayment@1103 : Decimal;
      GenBatch@1102 : Record 232;
      LineNo@1101 : Integer;
      GnljnlineCopy@1100 : Record 81;
      NewLNApplicNo@1099 : Code[10];
      Cust@1098 : Record 51516223;
      LoanApp@1097 : Record 51516230;
      TestAmt@1096 : Decimal;
      CustRec@1095 : Record 51516223;
      CustPostingGroup@1094 : Record 92;
      GenSetUp@1093 : Record 51516257;
      PCharges@1092 : Record 51516242;
      TCharges@1091 : Decimal;
      LAppCharges@1090 : Record 51516244;
      Loans@1089 : Record 51516230;
      LoanAmount@1088 : Decimal;
      InterestRate@1087 : Decimal;
      RepayPeriod@1086 : Integer;
      LBalance@1085 : Decimal;
      RunDate@1084 : Date;
      InstalNo@1083 : Decimal;
      RepayInterval@1082 : DateFormula;
      TotalMRepay@1081 : Decimal;
      LInterest@1080 : Decimal;
      LPrincipal@1079 : Decimal;
      RepayCode@1078 : Code[40];
      GrPrinciple@1077 : Integer;
      GrInterest@1076 : Integer;
      QPrinciple@1075 : Decimal;
      QCounter@1074 : Integer;
      InPeriod@1073 : DateFormula;
      InitialInstal@1072 : Integer;
      InitialGraceInt@1071 : Integer;
      GenJournalLine@1070 : Record 81;
      FOSAComm@1069 : Decimal;
      BOSAComm@1068 : Decimal;
      GLPosting@1067 : Codeunit 12;
      LoanTopUp@1066 : Record 51516235;
      Vend@1065 : Record 23;
      BOSAInt@1064 : Decimal;
      TopUpComm@1063 : Decimal;
      DActivity@1062 : Code[20];
      DBranch@1061 : Code[20];
      UsersID@1060 : Record 2000000120;
      TotalTopupComm@1059 : Decimal;
      Notification@1058 : Codeunit 397;
      CustE@1057 : Record 51516223;
      DocN@1056 : Text[50];
      DocM@1055 : Text[100];
      DNar@1054 : Text[250];
      DocF@1053 : Text[50];
      MailBody@1052 : Text[250];
      ccEmail@1051 : Text[250];
      LoanG@1050 : Record 51516231;
      SpecialComm@1049 : Decimal;
      LoanApps@1048 : Record 51516230;
      Banks@1047 : Record 270;
      BatchTopUpAmount@1046 : Decimal;
      BatchTopUpComm@1045 : Decimal;
      TotalSpecialLoan@1044 : Decimal;
      SpecialLoanCl@1043 : Record 51516238;
      Loans2@1042 : Record 51516230;
      DActivityBOSA@1041 : Code[20];
      DBranchBOSA@1040 : Code[20];
      Refunds@1039 : Record 51516240;
      TotalRefunds@1038 : Decimal;
      WithdrawalFee@1037 : Decimal;
      NetPayable@1036 : Decimal;
      NetRefund@1035 : Decimal;
      FWithdrawal@1034 : Decimal;
      OutstandingInt@1033 : Decimal;
      TSC@1032 : Decimal;
      LoanDisbAmount@1031 : Decimal;
      NegFee@1030 : Decimal;
      DValue@1029 : Record 349;
      ChBank@1028 : Code[20];
      Trans@1027 : Record 51516299;
      TransactionCharges@1026 : Record 51516300;
      BChequeRegister@1025 : Record 51516313;
      OtherCommitments@1024 : Record 51516262;
      BoostingComm@1023 : Decimal;
      BoostingCommTotal@1022 : Decimal;
      BridgedLoans@1021 : Record 51516238;
      InterestDue@1020 : Decimal;
      ContractualShares@1019 : Decimal;
      BridgingChanged@1018 : Boolean;
      BankersChqNo@1017 : Code[20];
      LastPayee@1016 : Text[100];
      RunningAmount@1015 : Decimal;
      BankersChqNo2@1014 : Code[20];
      BankersChqNo3@1013 : Code[20];
      EndMonth@1012 : Date;
      RemainingDays@1011 : Integer;
      PrincipalRepay@1010 : Decimal;
      InterestRepay@1009 : Decimal;
      TMonthDays@1008 : Integer;
      SMSMessage@1007 : Record 51516232;
      iEntryNo@1006 : Integer;
      Temp@1005 : Record 18;
      Jtemplate@1004 : Code[30];
      JBatch@1003 : Code[30];
      LBatches@1002 : Record 51516236;
      ApprovalMgt@1001 : Codeunit 439;
      DocumentType@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      DescriptionEditable@1134 : Boolean;
      ModeofDisburementEditable@1135 : Boolean;
      DocumentNoEditable@1136 : Boolean;
      PostingDateEditable@1137 : Boolean;
      SourceEditable@1138 : Boolean;
      PayingAccountEditable@1139 : Boolean;
      ChequeNoEditable@1140 : Boolean;
      ChequeNameEditable@1141 : Boolean;
      upfronts@1142 : Decimal;
      EmergencyInt@1143 : Decimal;
      Table_id@1146 : Integer;
      Doc_No@1145 : Code[20];
      Doc_Type@1144 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening,Member Closure,Loan,Loan Batch';
      Deductions@1000000000 : Decimal;
      BatchBoostingCom@1000000001 : Decimal;
      HisaRepayment@1000000002 : Decimal;
      HisaLoan@1000000003 : Record 51516230;
      BatchHisaRepayment@1000000004 : Decimal;
      BatchFosaHisaComm@1000000005 : Decimal;
      BatchHisaShareBoostComm@1000000006 : Decimal;
      BatchShareCap@1000000007 : Decimal;
      BatchIntinArr@1000000008 : Decimal;
      Loaninsurance@1000000009 : Decimal;
      TLoaninsurance@1000000010 : Decimal;
      ProductCharges@1000000011 : Record 51516242;
      InsuranceAcc@1000000012 : Code[20];
      PTEN@1000000013 : Code[20];
      LoanTypes@1000000014 : Record 51516240;
      Customer@1000000015 : Record 51516223;
      DataSheet@1000000016 : Record 51516341;
      TotBoost@1000000017 : Decimal;
      ShareAmount@1000000018 : Decimal;
      Commitm@1000000019 : Decimal;
      Scharge@1000000020 : Decimal;
      EftAmount@1000000021 : Decimal;
      EFTDeduc@1000000022 : Decimal;
      linecharges@1000000023 : Decimal;
      ApprovalsMgmt@1000000024 : Codeunit 1535;
      interestDays@1120054000 : Integer;
      Chargeinterest@1120054001 : Boolean;

    PROCEDURE UpdateControl@1102755002();
    BEGIN
      IF Status=Status::Open THEN BEGIN
      DescriptionEditable:=TRUE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=TRUE;
      PayingAccountEditable:=TRUE;
      ChequeNoEditable:=FALSE;
      ChequeNameEditable:=FALSE;
      END;

      IF Status=Status::"Pending Approval" THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=FALSE;
      PayingAccountEditable:=FALSE;
      ChequeNoEditable:=FALSE;
      ChequeNameEditable:=FALSE;

      END;

      IF Status=Status::Rejected THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=FALSE;
      PayingAccountEditable:=FALSE;
      ChequeNoEditable:=FALSE;
      ChequeNameEditable:=FALSE;
      END;

      IF Status=Status::Approved THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=TRUE;
      DocumentNoEditable:=TRUE;
      SourceEditable:=FALSE;
      PostingDateEditable:=TRUE;
      PayingAccountEditable:=TRUE;//FALSE;
      ChequeNoEditable:=TRUE;
      ChequeNameEditable:=TRUE;

      END;
    END;

    BEGIN
    END.
  }
}

