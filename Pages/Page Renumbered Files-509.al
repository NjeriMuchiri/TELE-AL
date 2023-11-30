OBJECT page 172104 Loans List-MICRO
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=[ 9:51:53 PM];
    Modified=Yes;
    Version List=Micro FinanceV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516230;
    SourceTableView=WHERE(Posted=FILTER(No),
                          Source=CONST(MICRO));
    PageType=List;
    CardPageID=Loan Application Card - MICRO;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnAfterGetRecord=BEGIN
                       Overdue := Overdue::" ";
                       IF FormatField(Rec) THEN
                         Overdue := Overdue::Yes;
                     END;

    ActionList=ACTIONS
    {
      { 1102755024;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755023;1 ;ActionGroup;
                      CaptionML=ENU=Loan;
                      Image=AnalysisView }
      { 1102755007;1 ;ActionGroup;
                      CaptionML=ENU=Approvals;
                      ActionContainerType=NewDocumentItems }
      { 1102755005;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 {
                                 LBatches.RESET;
                                 LBatches.SETRANGE(LBatches."Loan  No.","Loan  No.");
                                 IF LBatches.FIND('-') THEN BEGIN
                                     ApprovalEntries.Setfilters(DATABASE::Loans,17,LBatches."Loan  No.");
                                       ApprovalEntries.RUN;
                                 END;
                                 }
                                 {
                                 DocumentType:=DocumentType::Loan;
                                 ApprovalEntries.Setfilters(DATABASE::Loans,DocumentType,"Loan  No.");
                                 ApprovalEntries.RUN;
                                 }
                               END;
                                }
      { 1102755003;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This transaction is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN

                                 TESTFIELD("Account No");


                                  {
                                 SalDetails.RESET;
                                 SalDetails.SETRANGE(SalDetails."Loan No","Loan  No.");
                                 IF SalDetails.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Salary Information');
                                 END;
                                    }

                                 LGuarantors.RESET;
                                 LGuarantors.SETRANGE(LGuarantors."Loan No","Loan  No.");
                                 IF LGuarantors.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Loan Applicant Guarantor Information');
                                 END;

                                 TESTFIELD("Approved Amount");
                                 TESTFIELD("Loan Product Type");

                                 IF "Mode of Disbursement"<> "Mode of Disbursement"::"Transfer to FOSA" THEN
                                 ERROR('Mode of disbursement must be Bank Transfer');

                                 {
                                 LBatches.RESET;
                                 LBatches.SETRANGE(LBatches."Loan  No.","Loan  No.");
                                 IF LBatches.FIND('-') THEN BEGIN
                                    IF LBatches."Approval Status"<>LBatches."Approval Status"::Open THEN
                                       ERROR(Text001);
                                 END;
                                 }
                                 //End allocate batch number
                                 //ApprovalMgt.SendLoanApprRequest(LBatches);
                                 //ApprovalMgt.SendLoanApprRequest(Rec);
                               END;
                                }
      { 1102755001;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN
                                 // ApprovalMgt.SendLoanApprRequest(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1102755004;2;Field  ;
                CaptionML=ENU=OverDue;
                ToolTipML=ENU=OverDue Entry;
                OptionCaptionML=ENU=Yes;
                SourceExpr=Overdue;
                Editable=False }

    { 1000000001;2;Field  ;
                SourceExpr="Loan  No.";
                Editable=FALSE }

    { 1102756013;2;Field  ;
                SourceExpr="Old Account No.";
                Editable=FALSE }

    { 1000000003;2;Field  ;
                SourceExpr="Group Code" }

    { 1000000025;2;Field  ;
                SourceExpr="Loan Product Type";
                Editable=FALSE }

    { 1000000011;2;Field  ;
                SourceExpr="Advice Type" }

    { 1102755006;2;Field  ;
                SourceExpr="Expected Date of Completion" }

    { 1102760020;2;Field  ;
                SourceExpr="Application Date";
                Editable=FALSE }

    { 1000000007;2;Field  ;
                SourceExpr="Client Code";
                Editable=FALSE }

    { 1102755002;2;Field  ;
                SourceExpr="BOSA No" }

    { 1102756011;2;Field  ;
                SourceExpr="Issued Date";
                Editable=FALSE }

    { 1000000033;2;Field  ;
                SourceExpr="Client Name";
                Editable=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1102755000;2;Field  ;
                SourceExpr="Account No" }

    { 1102756004;2;Field  ;
                SourceExpr=Remarks;
                Visible=FALSE;
                Editable=FALSE }

    { 1000000002;2;Field  ;
                SourceExpr="Approval Status" }

  }
  CODE
  {
    VAR
      LoanType@1000000000 : Record 51516240;
      NoSeriesMgt@1000000001 : Codeunit 396;
      LoanApp@1102760002 : Record 51516230;
      DiscountingAmount@1102760001 : Decimal;
      StatusPermissions@1102760000 : Record 51516310;
      SpecialComm@1102760003 : Decimal;
      GenJournalLine@1102760004 : Record 81;
      LoansR@1102760005 : Record 51516230;
      DActivity@1102760006 : Code[20];
      DBranch@1102760007 : Code[20];
      Vend@1102760008 : Record 23;
      LineNo@1102760009 : Integer;
      DoubleComm@1102760010 : Boolean;
      AvailableBal@1102760011 : Decimal;
      Account@1102760012 : Record 23;
      RunBal@1102760013 : Decimal;
      TotalRecovered@1102760014 : Decimal;
      OInterest@1102760015 : Decimal;
      OBal@1102760016 : Decimal;
      ReffNo@1102760017 : Code[20];
      DiscountCommission@1102760018 : Decimal;
      BridgedLoans@1102760019 : Record 51516238;
      LoanAdj@1102756000 : Decimal;
      LoanAdjInt@1102756001 : Decimal;
      AdjustRemarks@1102755000 : Text[30];
      Princip@1102755001 : Decimal;
      Overdue@1102755002 : 'Yes, ';
      i@1102755101 : Integer;
      PeriodDueDate@1102755099 : Date;
      ScheduleRep@1102755098 : Record 51516234;
      RunningDate@1102755097 : Date;
      G@1102755096 : Integer;
      IssuedDate@1102755095 : Date;
      GracePeiodEndDate@1102755094 : Date;
      InstalmentEnddate@1102755093 : Date;
      GracePerodDays@1102755092 : Integer;
      InstalmentDays@1102755091 : Integer;
      NoOfGracePeriod@1102755090 : Integer;
      NewSchedule@1102755089 : Record 51516234;
      RSchedule@1102755088 : Record 51516234;
      GP@1102755087 : Text[30];
      ScheduleCode@1102755086 : Code[20];
      PreviewShedule@1102755085 : Record 51516234;
      PeriodInterval@1102755084 : Code[10];
      CustomerRecord@1102755083 : Record 51516223;
      Gnljnline@1102755082 : Record 81;
      Jnlinepost@1102755081 : Codeunit 12;
      CumInterest@1102755080 : Decimal;
      NewPrincipal@1102755079 : Decimal;
      PeriodPrRepayment@1102755078 : Decimal;
      GenBatch@1102755077 : Record 232;
      GnljnlineCopy@1102755075 : Record 81;
      NewLNApplicNo@1102755074 : Code[10];
      Cust@1102755073 : Record 51516223;
      TestAmt@1102755071 : Decimal;
      CustRec@1102755070 : Record 51516223;
      CustPostingGroup@1102755069 : Record 92;
      GenSetUp@1102755068 : Record 311;
      PCharges@1102755067 : Record 51516241;
      TCharges@1102755066 : Decimal;
      LAppCharges@1102755065 : Record 51516244;
      LoanAmount@1102755063 : Decimal;
      InterestRate@1102755062 : Decimal;
      RepayPeriod@1102755061 : Integer;
      LBalance@1102755060 : Decimal;
      RunDate@1102755059 : Date;
      InstalNo@1102755058 : Decimal;
      RepayInterval@1102755057 : DateFormula;
      TotalMRepay@1102755056 : Decimal;
      LInterest@1102755055 : Decimal;
      LPrincipal@1102755054 : Decimal;
      RepayCode@1102755053 : Code[40];
      GrPrinciple@1102755052 : Integer;
      GrInterest@1102755051 : Integer;
      QPrinciple@1102755050 : Decimal;
      QCounter@1102755049 : Integer;
      InPeriod@1102755048 : DateFormula;
      InitialInstal@1102755047 : Integer;
      InitialGraceInt@1102755046 : Integer;
      FOSAComm@1102755044 : Decimal;
      BOSAComm@1102755043 : Decimal;
      GLPosting@1102755042 : Codeunit 12;
      LoanTopUp@1102755041 : Record 51516235;
      BOSAInt@1102755039 : Decimal;
      TopUpComm@1102755038 : Decimal;
      TotalTopupComm@1102755035 : Decimal;
      Notification@1102755034 : Codeunit 397;
      CustE@1102755033 : Record 51516223;
      DocN@1102755032 : Text[50];
      DocM@1102755031 : Text[100];
      DNar@1102755030 : Text[250];
      DocF@1102755029 : Text[50];
      MailBody@1102755028 : Text[250];
      ccEmail@1102755027 : Text[250];
      LoanG@1102755026 : Record 51516231;
      FOSAName@1102755024 : Text[150];
      IDNo@1102755023 : Code[50];
      MovementTracker@1102755022 : Record 51516253;
      SMSMessage@1102755018 : Record 51516223;
      InstallNo2@1102755017 : Integer;
      currency@1102755016 : Record 330;
      CURRENCYFACTOR@1102755015 : Decimal;
      LoanApps@1102755014 : Record 51516230;
      LoanDisbAmount@1102755013 : Decimal;
      BatchTopUpAmount@1102755012 : Decimal;
      BatchTopUpComm@1102755011 : Decimal;
      Disbursement@1102755010 : Record 51516279;
      SchDate@1102755009 : Date;
      DisbDate@1102755008 : Date;
      WhichDay@1102755007 : Integer;
      LBatches@1102755006 : Record 51516230;
      SalDetails@1102755005 : Record 51516232;
      LGuarantors@1102755004 : Record 51516231;
      DocumentType@1102755003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';

    PROCEDURE GetVariables@1000000000(VAR LoanNo@1000000000 : Code[20];VAR LoanProductType@1000000001 : Code[20]);
    BEGIN
      LoanNo:="Loan  No.";
      LoanProductType:="Loan Product Type";
    END;

    PROCEDURE FormatField@2(Rec@1000 : Record 51516230) OK : Boolean;
    BEGIN
      IF "Outstanding Balance">0 THEN BEGIN
        IF (Rec."Expected Date of Completion" < TODAY) THEN
          EXIT(TRUE)
        ELSE
          EXIT(FALSE);
      END;
    END;

    PROCEDURE CalledFrom@3();
    BEGIN
      Overdue := Overdue::" ";
    END;

    BEGIN
    END.
  }
}

