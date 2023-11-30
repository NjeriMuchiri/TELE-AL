OBJECT page 50041 Member Withdrawal Batch List
{
  OBJECT-PROPERTIES
  {
    Date=09/11/19;
    Time=[ 4:38:40 PM];
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
    SourceTableView=WHERE(Posted=FILTER(No));
    PageType=List;
    CardPageID=Member Withdrawal Batch Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755011;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755010;1 ;ActionGroup;
                      Name=LoansB;
                      CaptionML=ENU=Batch }
      { 1102755009;2 ;Action    ;
                      CaptionML=ENU=Loans Schedule;
                      Image=SuggestPayment;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {LoansBatch.RESET;
                                 LoansBatch.SETRANGE(LoansBatch."Batch No.","Batch No.");
                                 IF LoansBatch.FIND('-') THEN BEGIN
                                 REPORT.RUN(,TRUE,FALSE,LoansBatch);
                                 END;
                                 }
                               END;
                                }
      { 1102755008;2 ;Separator  }
      { 1102755004;2 ;Separator  }
      { 1102755003;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"Withdrawal Batch";
                                 ApprovalEntries.Setfilters(DATABASE::"Approvals Users Set Up",DocumentType,"Batch No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755002;2 ;Action    ;
                      Name=Send A&pproval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                                 Text001@1102755001 : TextConst 'ENU=This Batch is already pending approval';
                               BEGIN
                                 {MembWith.RESET;
                                 MembWith.SETRANGE(MembWith."Batch No.","Batch No.");
                                 IF MembWith.FIND('-')=FALSE THEN
                                 ERROR('You cannot send an empty batch for approval');

                                 Doc_Type:=Doc_Type::"Withdrawal Batch";
                                 Table_id:=DATABASE::"Membership Withdrawal-Batching";


                                 IF ApprovalsMgmt.CheckWBatcApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendWBatchDocForApproval(Rec);
                                 }
                                 IF Status=Status::Open THEN
                                 Status:=Status::Approved;
                                 MODIFY;
                               END;
                                }
      { 1102755001;2 ;Action    ;
                      Name=Canel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 {
                                 //IF ApprovalMgt.CancelBatchAppr(Rec,TRUE,TRUE) THEN;
                                 IF ApprovalsMgmt.CheckWBatcApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelWBatcApprovalRequest(Rec);
                                 }
                                 IF Status=Status::Approved THEN
                                 Status:=Status::Open;
                                 MODIFY;
                               END;
                                }
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
                SourceExpr=Source }

    { 1102760003;2;Field  ;
                SourceExpr="Description/Remarks" }

    { 1000000000;2;Field  ;
                SourceExpr="Posting Date" }

    { 1102760018;2;Field  ;
                SourceExpr="No of Withdrawals";
                Editable=FALSE }

    { 1102760016;2;Field  ;
                SourceExpr="Mode Of Disbursement";
                Editable=TRUE }

    { 1000000001;2;Field  ;
                SourceExpr="Prepared By" }

    { 1000000002;2;Field  ;
                SourceExpr="Approved By" }

  }
  CODE
  {
    VAR
      Generalsetup@1120054188 : Record 51516257;
      UserSetup@1120054187 : Record 91;
      LoansR@1120054186 : Record 51516230;
      "AMOUNTTO BE RECOVERED"@1120054185 : Decimal;
      Interestrecovery@1120054184 : Decimal;
      TotalLoansOut@1120054183 : Decimal;
      "Remaining Amount"@1120054182 : Decimal;
      Totalrecovered@1120054181 : Decimal;
      TotalInsuarance@1120054180 : Decimal;
      Lprinciple@1120054179 : Decimal;
      RunBal@1120054178 : Decimal;
      runbal1@1120054177 : Decimal;
      TotalAmount@1120054176 : Decimal;
      TotalOustanding@1120054175 : Decimal;
      TotalAdd@1120054174 : Decimal;
      MovementTracker@1120054173 : Record 51516254;
      FileMovementTracker@1120054172 : Record 51516254;
      NextStage@1120054171 : Integer;
      EntryNo@1120054170 : Integer;
      NextLocation@1120054169 : Text[100];
      LoansBatch@1120054168 : Record 51516236;
      MembWith@1120054167 : Record 51516259;
      i@1120054166 : Integer;
      LoanType@1120054165 : Record 51516240;
      PeriodDueDate@1120054164 : Date;
      ScheduleRep@1120054163 : Record 51516234;
      RunningDate@1120054162 : Date;
      G@1120054161 : Integer;
      IssuedDate@1120054160 : Date;
      GracePeiodEndDate@1120054159 : Date;
      InstalmentEnddate@1120054158 : Date;
      GracePerodDays@1120054157 : Integer;
      InstalmentDays@1120054156 : Integer;
      NoOfGracePeriod@1120054155 : Integer;
      NewSchedule@1120054154 : Record 51516234;
      RSchedule@1120054153 : Record 51516234;
      GP@1120054152 : Text[30];
      ScheduleCode@1120054151 : Code[20];
      PreviewShedule@1120054150 : Record 51516234;
      PeriodInterval@1120054149 : Code[10];
      CustomerRecord@1120054148 : Record 51516223;
      Gnljnline@1120054147 : Record 81;
      Jnlinepost@1120054146 : Codeunit 12;
      CumInterest@1120054145 : Decimal;
      NewPrincipal@1120054144 : Decimal;
      PeriodPrRepayment@1120054143 : Decimal;
      GenBatch@1120054142 : Record 232;
      LineNo@1120054141 : Integer;
      GnljnlineCopy@1120054140 : Record 81;
      NewLNApplicNo@1120054139 : Code[10];
      Cust@1120054138 : Record 51516223;
      LoanApp@1120054137 : Record 51516230;
      TestAmt@1120054136 : Decimal;
      CustRec@1120054135 : Record 51516223;
      CustPostingGroup@1120054134 : Record 92;
      GenSetUp@1120054133 : Record 51516257;
      PCharges@1120054132 : Record 51516242;
      TCharges@1120054131 : Decimal;
      LAppCharges@1120054130 : Record 51516244;
      Loans@1120054129 : Record 51516230;
      LoanAmount@1120054128 : Decimal;
      InterestRate@1120054127 : Decimal;
      RepayPeriod@1120054126 : Integer;
      LBalance@1120054125 : Decimal;
      RunDate@1120054124 : Date;
      InstalNo@1120054123 : Decimal;
      RepayInterval@1120054122 : DateFormula;
      TotalMRepay@1120054121 : Decimal;
      LInterest@1120054120 : Decimal;
      LPrincipal@1120054119 : Decimal;
      RepayCode@1120054118 : Code[40];
      GrPrinciple@1120054117 : Integer;
      GrInterest@1120054116 : Integer;
      QPrinciple@1120054115 : Decimal;
      QCounter@1120054114 : Integer;
      InPeriod@1120054113 : DateFormula;
      InitialInstal@1120054112 : Integer;
      InitialGraceInt@1120054111 : Integer;
      GenJournalLine@1120054110 : Record 81;
      FOSAComm@1120054109 : Decimal;
      BOSAComm@1120054108 : Decimal;
      GLPosting@1120054107 : Codeunit 12;
      LoanTopUp@1120054106 : Record 51516235;
      Vend@1120054105 : Record 23;
      BOSAInt@1120054104 : Decimal;
      TopUpComm@1120054103 : Decimal;
      DActivity@1120054102 : Code[20];
      DBranch@1120054101 : Code[20];
      UsersID@1120054100 : Record 2000000120;
      TotalTopupComm@1120054099 : Decimal;
      Notification@1120054098 : Codeunit 397;
      CustE@1120054097 : Record 51516223;
      DocN@1120054096 : Text[50];
      DocM@1120054095 : Text[100];
      DNar@1120054094 : Text[250];
      DocF@1120054093 : Text[50];
      MailBody@1120054092 : Text[250];
      ccEmail@1120054091 : Text[250];
      LoanG@1120054090 : Record 51516231;
      SpecialComm@1120054089 : Decimal;
      LoanApps@1120054088 : Record 51516230;
      Banks@1120054087 : Record 270;
      BatchTopUpAmount@1120054086 : Decimal;
      BatchTopUpComm@1120054085 : Decimal;
      TotalSpecialLoan@1120054084 : Decimal;
      SpecialLoanCl@1120054083 : Record 51516238;
      Loans2@1120054082 : Record 51516230;
      DActivityBOSA@1120054081 : Code[20];
      DBranchBOSA@1120054080 : Code[20];
      Refunds@1120054079 : Record 51516240;
      TotalRefunds@1120054078 : Decimal;
      WithdrawalFee@1120054077 : Decimal;
      NetPayable@1120054076 : Decimal;
      NetRefund@1120054075 : Decimal;
      FWithdrawal@1120054074 : Decimal;
      OutstandingInt@1120054073 : Decimal;
      TSC@1120054072 : Decimal;
      LoanDisbAmount@1120054071 : Decimal;
      NegFee@1120054070 : Decimal;
      DValue@1120054069 : Record 349;
      ChBank@1120054068 : Code[20];
      Trans@1120054067 : Record 51516299;
      TransactionCharges@1120054066 : Record 51516300;
      BChequeRegister@1120054065 : Record 51516313;
      OtherCommitments@1120054064 : Record 51516262;
      BoostingComm@1120054063 : Decimal;
      BoostingCommTotal@1120054062 : Decimal;
      BridgedLoans@1120054061 : Record 51516238;
      InterestDue@1120054060 : Decimal;
      ContractualShares@1120054059 : Decimal;
      BridgingChanged@1120054058 : Boolean;
      BankersChqNo@1120054057 : Code[20];
      LastPayee@1120054056 : Text[100];
      RunningAmount@1120054055 : Decimal;
      BankersChqNo2@1120054054 : Code[20];
      BankersChqNo3@1120054053 : Code[20];
      EndMonth@1120054052 : Date;
      RemainingDays@1120054051 : Integer;
      PrincipalRepay@1120054050 : Decimal;
      InterestRepay@1120054049 : Decimal;
      TMonthDays@1120054048 : Integer;
      SMSMessage@1120054047 : Record 51516232;
      iEntryNo@1120054046 : Integer;
      Temp@1120054045 : Record 18;
      Jtemplate@1120054044 : Code[30];
      JBatch@1120054043 : Code[30];
      LBatches@1120054042 : Record 51516236;
      ApprovalMgt@1120054041 : Codeunit 439;
      DocumentType@1120054040 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank,Withdrawal Batch';
      DescriptionEditable@1120054039 : Boolean;
      ModeofDisburementEditable@1120054038 : Boolean;
      DocumentNoEditable@1120054037 : Boolean;
      PostingDateEditable@1120054036 : Boolean;
      SourceEditable@1120054035 : Boolean;
      PayingAccountEditable@1120054034 : Boolean;
      ChequeNoEditable@1120054033 : Boolean;
      ChequeNameEditable@1120054032 : Boolean;
      upfronts@1120054031 : Decimal;
      EmergencyInt@1120054030 : Decimal;
      Table_id@1120054029 : Integer;
      Doc_No@1120054028 : Code[20];
      Doc_Type@1120054027 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening,Member Closure,Loan,Loan Batch,Withdrawal Batch';
      Deductions@1120054026 : Decimal;
      BatchBoostingCom@1120054025 : Decimal;
      HisaRepayment@1120054024 : Decimal;
      HisaLoan@1120054023 : Record 51516230;
      BatchHisaRepayment@1120054022 : Decimal;
      BatchFosaHisaComm@1120054021 : Decimal;
      BatchHisaShareBoostComm@1120054020 : Decimal;
      BatchShareCap@1120054019 : Decimal;
      BatchIntinArr@1120054018 : Decimal;
      Loaninsurance@1120054017 : Decimal;
      TLoaninsurance@1120054016 : Decimal;
      ProductCharges@1120054015 : Record 51516242;
      InsuranceAcc@1120054014 : Code[20];
      PTEN@1120054013 : Code[20];
      LoanTypes@1120054012 : Record 51516240;
      Customer@1120054011 : Record 51516223;
      DataSheet@1120054010 : Record 51516341;
      TotBoost@1120054009 : Decimal;
      ShareAmount@1120054008 : Decimal;
      Commitm@1120054007 : Decimal;
      Scharge@1120054006 : Decimal;
      EftAmount@1120054005 : Decimal;
      EFTDeduc@1120054004 : Decimal;
      linecharges@1120054003 : Decimal;
      ApprovalsMgmt@1120054002 : Codeunit 1535;
      interestDays@1120054001 : Integer;
      Chargeinterest@1120054000 : Boolean;

    BEGIN
    END.
  }
}

