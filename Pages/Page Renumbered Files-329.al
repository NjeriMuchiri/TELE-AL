OBJECT page 50020 Appeal batches Card
{
  OBJECT-PROPERTIES
  {
    Date=05/24/16;
    Time=11:16:05 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516236;
    ActionList=ACTIONS
    {
      { 1000000030;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000029;1 ;ActionGroup;
                      Name=LoansB;
                      CaptionML=ENU=Batch }
      { 1000000028;2 ;Action    ;
                      Name=Loans Schedule;
                      CaptionML=ENU=Loans Schedule;
                      Image=SuggestPayment;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LoansBatch.RESET;
                                 LoansBatch.SETRANGE(LoansBatch."Batch No.","Batch No.");
                                 IF LoansBatch.FIND('-') THEN BEGIN
                                 //IF LoansBatch."Mode Of Disbursement"=LoansBatch."Mode Of Disbursement"::"M-Pesa" THEN
                                 //REPORT.RUN(39004266,TRUE,FALSE,LoansBatch)
                                 //ELSE
                                 REPORT.RUN(39004265,TRUE,FALSE,LoansBatch);
                                 END;
                               END;
                                }
      { 1000000027;2 ;Action    ;
                      Name=Export EFT;
                      CaptionML=ENU=Export EFT;
                      Image=SuggestPayment;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Batch No.","Batch No.");
                                 IF LoanApp.FIND('-') THEN BEGIN

                                 XMLPORT.RUN(39004244,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 1000000026;2 ;Separator  }
      { 1000000025;2 ;Action    ;
                      Name=Member Card;
                      CaptionML=ENU=Member Card;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 LoanApp.RESET;
                                 LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.GetLoanNo);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",LoanApp."Client Code");
                                 IF Cust.FIND('-') THEN
                                 PAGE.RUNMODAL(39004251,Cust);
                                 END;
                                 }
                               END;
                                }
      { 1000000024;2 ;Action    ;
                      Name=Loan Application;
                      CaptionML=ENU=Loan Application Card;
                      Image=Loaners;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 LoanApp.RESET;
                                 //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
                                 IF LoanApp.FIND('-') THEN
                                 PAGE.RUNMODAL(39004254,LoanApp);
                               END;
                                }
      { 1000000023;2 ;Action    ;
                      Name=Loan Appraisal;
                      CaptionML=ENU=Loan Appraisal;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 LoanApp.RESET;
                                 //LoanApp.SETRANGE(LoanApp."Loan  No.",CurrPage.LoansSubForm.PAGE.GetLoanNo);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 IF COPYSTR(LoanApp."Loan Product Type",1,2) = 'PL' THEN
                                 REPORT.RUN(39004319,TRUE,FALSE,LoanApp)
                                 ELSE
                                 REPORT.RUN(39004319,TRUE,FALSE,LoanApp);
                                 END;
                               END;
                                }
      { 1000000022;2 ;Separator  }
      { 1000000021;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::Batches;
                                 ApprovalEntries.Setfilters(DATABASE::"Loan Disburesment-Batching",DocumentType,"Batch No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1000000020;2 ;Action    ;
                      Name=Send A&pproval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                                 Text001@1102755001 : TextConst 'ENU=This Batch is already pending approval';
                               BEGIN
                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Appeal Batch No.","Batch No.");
                                 IF LoanApps.FIND('-')=FALSE THEN
                                 ERROR('You cannot send an empty batch for approval')
                                 ELSE BEGIN
                                     REPEAT
                                           TotalChequeAmount:=0;
                                           PayingBank.RESET;
                                           PayingBank.SETRANGE(PayingBank."Loan Number",LoanApps."Loan  No.");
                                           PayingBank.SETRANGE(PayingBank.Posted,FALSE);
                                           PayingBank.SETRANGE(PayingBank.Appeal,TRUE);
                                           IF PayingBank.FIND('-')=TRUE  THEN BEGIN

                                               REPEAT
                                               TotalChequeAmount+=PayingBank."Cheque Amount";
                                               UNTIL PayingBank.NEXT=0;
                                           END;
                                              //MESSAGE(FORMAT(TotalChequeAmount)+'/'+FORMAT(LoanApps."Appeal Amount"));
                                           IF TotalChequeAmount > LoanApps."Appeal Amount" THEN
                                               ERROR('Cheque Amount Must not be Greater than Appeal Amount in Loan No %1',LoanApps."Loan  No.");
                                     UNTIL LoanApps.NEXT=0;
                                 END;



                                 TESTFIELD("Description/Remarks");




                                 LBatches.RESET;
                                 LBatches.SETRANGE(LBatches."Batch No.","Batch No.");
                                 IF LBatches.FIND('-') THEN BEGIN
                                    IF LBatches.Status<>LBatches.Status::Open THEN
                                       ERROR(Text001);
                                 END;


                                 IF ("Mode Of Disbursement"<>"Mode Of Disbursement"::"Individual Cheques") AND ("Batch Type"="Batch Type"::"Appeal Loans") THEN
                                     ERROR('Mode of Disbursement must be Individual Cheques.');


                                 IF ("Mode Of Disbursement"="Mode Of Disbursement"::Cheque) AND ("Cheque No."='') THEN
                                     ERROR('Cheque No. MUST have a value.');


                                 //IF ("Mode Of Disbursement"="Mode Of Disbursement"::"Individual Cheques") THEN
                                   //  ERROR('Option not active %1',"Mode Of Disbursement");


                                 IF (LoanApps.Source = LoanApps.Source::FOSA) AND ("Mode Of Disbursement" <> "Mode Of Disbursement"::"FOSA Loans") THEN
                                     ERROR('Mode of disbursement must be FOSA Loans for FOSA Loans.');

                                 IF ((LoanApps.Source = LoanApps.Source::BOSA) OR (LoanApps.Source = LoanApps.Source::MICRO)) AND ("Mode Of Disbursement" = "Mode Of Disbursement"::"FOSA Loans") THEN
                                     ERROR('Mode of disbursement MUST NOT be FOSA Loans.');








                                 //End allocate batch number
                                 //ApprovalMgt.SendBatchApprRequest(LBatches);
                               END;
                                }
      { 1000000019;2 ;Action    ;
                      Name=Canel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN
                                 //IF ApprovalMgt.CancelBatchAppr(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1000000018;2 ;Separator  }
      { 1000000017;2 ;Action    ;
                      Name=[Post ];
                      CaptionML=ENU=Post;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=The Batch need to be approved.';
                               BEGIN
                                 IF Posted = TRUE THEN
                                 ERROR('Batch already posted.');

                                 {
                                 IF GenSetUp."CheckOff Source"=GenSetUp."CheckOff Source"::"General Set-Up" THEN BEGIN
                                     CheckDate:=CALCDATE(GenSetUp."Days for Checkoff",CALCDATE('-CM',TODAY));
                                 END
                                 ELSE IF GenSetUp."CheckOff Source"=GenSetUp."CheckOff Source"::Employer THEN BEGIN
                                     CustomerRecord.GET(LoanApps."Client Code");
                                     Employer.GET(CustomerRecord."Employer Code");
                                     CheckDate:=CALCDATE(Employer."Days for Checkoff",CALCDATE('-CM',TODAY));
                                 END;
                                 }


                                 IF Status<>Status::Approved THEN
                                 ERROR(FORMAT(Text001));

                                 CALCFIELDS(Location);


                                 IF ("Mode Of Disbursement" = "Mode Of Disbursement"::Cheque) THEN BEGIN
                                 TESTFIELD("BOSA Bank Account");
                                 TESTFIELD("Cheque No.");
                                 TESTFIELD("Document No.");
                                 TESTFIELD("Posting Date");
                                 TESTFIELD("Description/Remarks");
                                 END
                                 ELSE IF ("Mode Of Disbursement" = "Mode Of Disbursement"::RTGS)  THEN BEGIN
                                 TESTFIELD("BOSA Bank Account");
                                 TESTFIELD("Document No.");
                                 TESTFIELD("Posting Date");
                                 TESTFIELD("Description/Remarks");
                                 END
                                 ELSE IF "Mode Of Disbursement"="Mode Of Disbursement"::"Individual Cheques" THEN BEGIN
                                 TESTFIELD("Description/Remarks");
                                 TESTFIELD("Document No.");
                                 END
                                 ELSE BEGIN
                                 TESTFIELD("Document No.");
                                 TESTFIELD("Posting Date");
                                 TESTFIELD("Description/Remarks");
                                 END;

                                 //For branch loans - only individual cheques
                                 IF "Batch Type" = "Batch Type"::"Branch Loans" THEN BEGIN
                                     IF "Mode Of Disbursement"<>"Mode Of Disbursement"::"Individual Cheques" THEN
                                         ERROR('Mode of disbursement must be Individual Cheques for branch loans.');
                                 END;


                                 IF CONFIRM('Are you sure you want to post this batch?',TRUE) = FALSE THEN
                                 EXIT;













                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 GenJournalLine.DELETEALL;


                                 GenSetUp.GET();

                                 DActivity:='';
                                 DBranch:='';

                                 LoanApps.RESET;
                                 LoanApps.SETRANGE(LoanApps."Appeal Batch No.","Batch No.");
                                 LoanApps.SETRANGE(LoanApps."System Created",FALSE);
                                 //LoanApps.SETRANGE(LoanApps.Source,LoanApps.Source::BOSA);
                                 LoanApps.SETFILTER(LoanApps."Loan Status",'<>Rejected');
                                 IF LoanApps.FIND('-') THEN BEGIN
                                     REPEAT       //yyy
                                         Deduction:=0;


                                        IF ("Mode Of Disbursement" = "Mode Of Disbursement"::"Individual Cheques") THEN BEGIN

                                           PayingBank.RESET;
                                           PayingBank.SETRANGE(PayingBank."Loan Number",LoanApps."Loan  No.");
                                           IF PayingBank.FIND('-')=TRUE  THEN BEGIN
                                               REPEAT
                                                  PayingBank.TESTFIELD(PayingBank."Cheque Number");
                                                  PayingBank.TESTFIELD(PayingBank."Cheque Amount");
                                                  PayingBank.TESTFIELD(PayingBank."Bank Account");
                                                  PayingBank.TESTFIELD(PayingBank."Posting Date");

                                                  "Posting Date":=PayingBank."Posting Date";
                                               UNTIL PayingBank.NEXT=0;
                                           END
                                           ELSE
                                               ERROR('Enter Cheque Details in Posted Loans Card');




                                           PayingBank.RESET;
                                           PayingBank.SETRANGE(PayingBank."Loan Number",LoanApps."Loan  No.");
                                           PayingBank.SETRANGE(PayingBank.Posted,FALSE);
                                           PayingBank.SETRANGE(PayingBank.Appeal,TRUE);
                                           IF PayingBank.FIND('-')=TRUE  THEN BEGIN

                                               REPEAT

                                                 LineNo:=LineNo+10000;

                                                 GenJournalLine.INIT;
                                                 GenJournalLine."Journal Template Name":='GENERAL';
                                                 GenJournalLine."Journal Batch Name":='LOANS';
                                                 GenJournalLine."Line No.":=LineNo;
                                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                                 GenJournalLine."Account No.":=LoanApps."Client Code";
                                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                 GenJournalLine."Document No.":="Document No.";
                                                 GenJournalLine."Posting Date":=PayingBank."Posting Date";
                                                 GenJournalLine."External Document No.":=PayingBank."Cheque Number";
                                                 GenJournalLine.Description:='Principal Amount';
                                                 GenJournalLine.Amount:=PayingBank."Cheque Amount";
                                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                                 GenJournalLine."Loan No":=LoanApps."Loan  No.";
                                                 GenJournalLine."Group Code":=LoanApps."Group Code";
                                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                                 IF GenJournalLine.Amount<>0 THEN
                                                 GenJournalLine.INSERT;

                                                 //Trans2:=Trans2+1;
                                                 LineNo:=LineNo+10000;
                                                 GenJournalLine.INIT;
                                                 GenJournalLine."Journal Template Name":='GENERAL';
                                                 GenJournalLine."Journal Batch Name":='LOANS';
                                                 GenJournalLine."Line No.":=LineNo;
                                                 GenJournalLine."Document No.":="Document No.";
                                                 GenJournalLine."Posting Date":=PayingBank."Posting Date";
                                                 GenJournalLine."External Document No.":=PayingBank."Cheque Number";
                                                 GenJournalLine."Account Type":=PayingBank."Account Type";
                                                 GenJournalLine."Account No.":=PayingBank."Bank Account";
                                                 IF PayingBank."Dedact From" THEN
                                                 GenJournalLine.Amount:=(PayingBank."Cheque Amount"-Deduction)*-1
                                                 ELSE
                                                 GenJournalLine.Amount:=(PayingBank."Cheque Amount")*-1;
                                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                 GenJournalLine.Description:=PayingBank.Description+' '+LoanApps."Client Code";
                                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                 GenJournalLine."Shortcut Dimension 1 Code":=DBranch;
                                                // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                                 //GenJournalLine."Transaction ID":=FORMAT(Trans2);
                                                 IF GenJournalLine.Amount<>0 THEN
                                                 GenJournalLine.INSERT;

                                                 LoanApps."Loan Disbursement Date":=PayingBank."Posting Date";
                                                 PayingBank.Posted:=TRUE;
                                                 PayingBank.MODIFY;

                                               UNTIL PayingBank.NEXT = 0;
                                           END;

                                        END;


                                 LoanApps."Approved Amount"+=LoanApps."Appeal Amount";
                                 LoanApps.VALIDATE(LoanApps."Approved Amount");
                                 LoanApps."Appeal Posted":=TRUE;
                                 LoanApps.MODIFY;


                                 UNTIL LoanApps.NEXT = 0;
                                 END;











                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                                 END;
                                 //Post New
                                 Posted:=TRUE;
                                 "Posted By":=USERID;
                                 MODIFY;




                                 MESSAGE('Batch posted successfully.');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000016;0;Container;
                ContainerType=ContentArea }

    { 1000000015;1;Group  ;
                GroupType=Group }

    { 1000000014;2;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr=Source;
                Editable=SourceEditable }

    { 1000000012;2;Field  ;
                SourceExpr="Batch Type";
                Editable=true }

    { 1000000011;2;Field  ;
                SourceExpr="Description/Remarks";
                Editable=DescriptionEditable }

    { 1000000010;2;Field  ;
                SourceExpr="No of Appeal Loans";
                Editable=false }

    { 1000000009;2;Field  ;
                SourceExpr=Status;
                Editable=false }

    { 1000000008;2;Field  ;
                SourceExpr="Mode Of Disbursement";
                Editable=ModeofDisburementEditable }

    { 1000000007;2;Field  ;
                SourceExpr="Document No.";
                Editable=DocumentNoEditable;
                OnValidate=BEGIN
                             {IF STRLEN("Document No.") > 6 THEN
                               ERROR('Document No. cannot contain More than 6 Characters.');
                               }
                           END;
                            }

    { 1000000006;2;Field  ;
                SourceExpr="Total Appeal Amount" }

    { 1000000005;2;Field  ;
                CaptionML=ENU=Posting Date;
                SourceExpr="Posting Date";
                Editable=false }

    { 1000000004;2;Field  ;
                SourceExpr="Cheque No.";
                Editable=false }

    { 1000000003;2;Field  ;
                SourceExpr="BOSA Bank Account";
                Enabled=false;
                Editable=PayingAccountEditable }

    { 1000000001;2;Field  ;
                CaptionML=ENU=Current Location;
                SourceExpr=Location }

    { 1000000000;1;Part   ;
                Name=LoansSubForm;
                SubPageLink=Appeal Batch No.=FIELD(Batch No.),
                            System Created=CONST(No);
                PagePartID=Page51516250 }

  }
  CODE
  {
    VAR
      ApprovalsSetup@1000000158 : Record 452;
      MovementTracker@1000000157 : Record 51516253;
      FileMovementTracker@1000000156 : Record 51516254;
      NextStage@1000000155 : Integer;
      EntryNo@1000000154 : Integer;
      NextLocation@1000000153 : Text[100];
      LoansBatch@1000000152 : Record 51516236;
      i@1000000151 : Integer;
      LoanType@1000000150 : Record 51516240;
      PeriodDueDate@1000000149 : Date;
      ScheduleRep@1000000148 : Record 51516234;
      RunningDate@1000000147 : Date;
      G@1000000146 : Integer;
      IssuedDate@1000000145 : Date;
      GracePeiodEndDate@1000000144 : Date;
      InstalmentEnddate@1000000143 : Date;
      GracePerodDays@1000000142 : Integer;
      InstalmentDays@1000000141 : Integer;
      NoOfGracePeriod@1000000140 : Integer;
      NewSchedule@1000000139 : Record 51516234;
      RSchedule@1000000138 : Record 51516234;
      GP@1000000137 : Text[30];
      ScheduleCode@1000000136 : Code[20];
      PreviewShedule@1000000135 : Record 51516234;
      PeriodInterval@1000000134 : Code[10];
      CustomerRecord@1000000133 : Record 51516223;
      Gnljnline@1000000132 : Record 81;
      Jnlinepost@1000000131 : Codeunit 12;
      CumInterest@1000000130 : Decimal;
      NewPrincipal@1000000129 : Decimal;
      PeriodPrRepayment@1000000128 : Decimal;
      GenBatch@1000000127 : Record 232;
      LineNo@1000000126 : Integer;
      GnljnlineCopy@1000000125 : Record 81;
      NewLNApplicNo@1000000124 : Code[10];
      Cust@1000000123 : Record 51516223;
      LoanApp@1000000122 : Record 51516230;
      TestAmt@1000000121 : Decimal;
      CustRec@1000000120 : Record 51516223;
      CustPostingGroup@1000000119 : Record 92;
      GenSetUp@1000000118 : Record 51516257;
      PCharges@1000000117 : Record 51516242;
      TCharges@1000000116 : Decimal;
      LAppCharges@1000000115 : Record 51516244;
      Loans@1000000114 : Record 51516230;
      LoanAmount@1000000113 : Decimal;
      InterestRate@1000000112 : Decimal;
      RepayPeriod@1000000111 : Integer;
      LBalance@1000000110 : Decimal;
      RunDate@1000000109 : Date;
      InstalNo@1000000108 : Decimal;
      RepayInterval@1000000107 : DateFormula;
      TotalMRepay@1000000106 : Decimal;
      LInterest@1000000105 : Decimal;
      LPrincipal@1000000104 : Decimal;
      RepayCode@1000000103 : Code[40];
      GrPrinciple@1000000102 : Integer;
      GrInterest@1000000101 : Integer;
      QPrinciple@1000000100 : Decimal;
      QCounter@1000000099 : Integer;
      InPeriod@1000000098 : DateFormula;
      InitialInstal@1000000097 : Integer;
      InitialGraceInt@1000000096 : Integer;
      GenJournalLine@1000000095 : Record 81;
      FOSAComm@1000000094 : Decimal;
      BOSAComm@1000000093 : Decimal;
      GLPosting@1000000092 : Codeunit 12;
      LoanTopUp@1000000091 : Record 51516235;
      Vend@1000000090 : Record 23;
      BOSAInt@1000000089 : Decimal;
      TopUpComm@1000000088 : Decimal;
      DActivity@1000000087 : Code[20];
      DBranch@1000000086 : Code[20];
      UsersID@1000000085 : Record 2000000120;
      TotalTopupComm@1000000084 : Decimal;
      Notification@1000000083 : Codeunit 397;
      CustE@1000000082 : Record 51516223;
      DocN@1000000081 : Text[50];
      DocM@1000000080 : Text[100];
      DNar@1000000079 : Text[250];
      DocF@1000000078 : Text[50];
      MailBody@1000000077 : Text[250];
      ccEmail@1000000076 : Text[250];
      LoanG@1000000075 : Record 51516231;
      SpecialComm@1000000074 : Decimal;
      LoanApps@1000000073 : Record 51516230;
      Banks@1000000072 : Record 270;
      BatchTopUpAmount@1000000071 : Decimal;
      BatchTopUpComm@1000000070 : Decimal;
      TotalSpecialLoan@1000000069 : Decimal;
      SpecialLoanCl@1000000068 : Record 51516276;
      Loans2@1000000067 : Record 51516230;
      DActivityBOSA@1000000066 : Code[20];
      DBranchBOSA@1000000065 : Code[20];
      Refunds@1000000064 : Record 51516269;
      TotalRefunds@1000000063 : Decimal;
      WithdrawalFee@1000000062 : Decimal;
      NetPayable@1000000061 : Decimal;
      NetRefund@1000000060 : Decimal;
      FWithdrawal@1000000059 : Decimal;
      OutstandingInt@1000000058 : Decimal;
      TSC@1000000057 : Decimal;
      LoanDisbAmount@1000000056 : Decimal;
      NegFee@1000000055 : Decimal;
      DValue@1000000054 : Record 349;
      ChBank@1000000053 : Code[20];
      Trans@1000000052 : Record 51516299;
      TransactionCharges@1000000051 : Record 51516300;
      BChequeRegister@1000000050 : Record 51516313;
      OtherCommitments@1000000049 : Record 51516262;
      BoostingComm@1000000048 : Decimal;
      BoostingCommTotal@1000000047 : Decimal;
      BridgedLoans@1000000046 : Record 51516276;
      InterestDue@1000000045 : Decimal;
      ContractualShares@1000000044 : Decimal;
      BridgingChanged@1000000043 : Boolean;
      BankersChqNo@1000000042 : Code[20];
      LastPayee@1000000041 : Text[100];
      RunningAmount@1000000040 : Decimal;
      BankersChqNo2@1000000039 : Code[20];
      BankersChqNo3@1000000038 : Code[20];
      EndMonth@1000000037 : Date;
      RemainingDays@1000000036 : Integer;
      PrincipalRepay@1000000035 : Decimal;
      InterestRepay@1000000034 : Decimal;
      TMonthDays@1000000033 : Integer;
      iEntryNo@1000000032 : Integer;
      Temp@1000000031 : Record 51516031;
      Jtemplate@1000000030 : Code[30];
      JBatch@1000000029 : Code[30];
      LBatches@1000000028 : Record 51516236;
      DocumentType@1000000027 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      DescriptionEditable@1000000026 : Boolean;
      ModeofDisburementEditable@1000000025 : Boolean;
      DocumentNoEditable@1000000024 : Boolean;
      PostingDateEditable@1000000023 : Boolean;
      PayingAccountEditable@1000000022 : Boolean;
      SourceEditable@1000000021 : Boolean;
      ResponsibilityCenter@1000000020 : Boolean;
      BoostingShares@1000000019 : Record 51516277;
      Partial@1000000018 : Record 51516279;
      CheckDate@1000000017 : Date;
      TotalChequeAmount@1000000016 : Decimal;
      CustID@1000000015 : Code[10];
      MsaccoMembers@1000000014 : Record 51516330;
      "MPESAno."@1000000013 : Text;
      tarrifHeader@1000000012 : Record 51516272;
      mpesa@1000000011 : Record 51516334;
      SpeedCharge@1000000010 : Decimal;
      Employer@1000000009 : Record 51516260;
      CompInfo@1000000008 : Record 79;
      SMSMessage@1000000007 : Record 51516329;
      smsMsg@1000000006 : Text[250];
      PayingBank@1000000005 : Record 51516285;
      Deduction@1000000004 : Decimal;
      Tariffs@1000000003 : Record 51516272;
      Charges@1000000002 : Decimal;
      MpesaTotal@1000000001 : Decimal;
      MpesaCharges@1000000000 : Decimal;
      Text001@1000000159 : TextConst 'ENU=Status must be open';

    PROCEDURE UpdateControl@1102755002();
    BEGIN
      IF Status=Status::Open THEN BEGIN
      DescriptionEditable:=TRUE;
      ModeofDisburementEditable:=TRUE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=TRUE;
      PayingAccountEditable:=TRUE;
      ResponsibilityCenter:=TRUE;

      END;

      IF Status=Status::"Pending Approval" THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=FALSE;
      PayingAccountEditable:=FALSE;
      ResponsibilityCenter:=FALSE;
      END;

      IF Status=Status::Rejected THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=FALSE;
      PostingDateEditable:=FALSE;
      SourceEditable:=FALSE;
      PayingAccountEditable:=FALSE;
      ResponsibilityCenter:=FALSE;
      END;

      IF Status=Status::Approved THEN BEGIN
      DescriptionEditable:=FALSE;
      ModeofDisburementEditable:=FALSE;
      DocumentNoEditable:=TRUE;
      SourceEditable:=FALSE;
      PostingDateEditable:=TRUE;
      PayingAccountEditable:=TRUE;//FALSE;
      ResponsibilityCenter:=FALSE;
      END;
    END;

    PROCEDURE SendSMS@1000000000(VAR LoanApp@1000 : Record 51516230);
    VAR
    ;
    BEGIN

      GenSetUp.GET;
      CompInfo.GET;

      IF GenSetUp."Send SMS Notifications"=TRUE THEN BEGIN

      smsMsg:='';

      IF LoanApp."Mode of Disbursement"=LoanApp."Mode of Disbursement"::"Individual Cheques" THEN BEGIN
          smsMsg:='Your Cheque of KSHs. '+FORMAT(LoanApp."Approved Amount")+' is ready';
      END
      ELSE IF LoanApp."Mode of Disbursement"=LoanApp."Mode of Disbursement"::Cheque THEN BEGIN

         IF Cust.GET(LoanApp."Client Code") THEN
            smsMsg:='Your loan of KES. '+FORMAT(LoanApp."Approved Amount")+
                  ' has been sent to your Bank Acc. No. '+Cust."Bank Account No."+' at Shirika SACCO LTD.';
      END
      ELSE IF (LoanApp."Mode of Disbursement"=LoanApp."Mode of Disbursement"::"Transfer to FOSA")
           OR (LoanApp."Mode of Disbursement"=LoanApp."Mode of Disbursement"::"FOSA Loans") THEN BEGIN

         IF Cust.GET(LoanApp."Client Code") THEN
            smsMsg:='Your loan of KES. '+FORMAT(LoanApp."Approved Amount")+
                  ' has been sent to your FOSA Acc. No. '+Cust."FOSA Account"+' at Shirika SACCO LTD.';
      END;




      //SMS MESSAGE
      SMSMessage.RESET;
      IF SMSMessage.FIND('+') THEN BEGIN
      iEntryNo:=SMSMessage."Entry No";
      iEntryNo:=iEntryNo+1;
      END
      ELSE BEGIN
      iEntryNo:=1;
      END;


      SMSMessage.INIT;
      SMSMessage."Entry No":=iEntryNo;
      SMSMessage."Batch No":="Batch No.";
      SMSMessage."Document No":='';
      SMSMessage."Account No":=LoanApp."Account No";
      SMSMessage."Date Entered":=TODAY;
      SMSMessage."Time Entered":=TIME;
      SMSMessage.Source:='LOAN ISSUE';
      SMSMessage."Entered By":=USERID;
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      SMSMessage."SMS Message":=smsMsg;
      IF Cust.GET(LoanApp."Client Code") THEN
      SMSMessage."Telephone No":=Cust."Mobile Phone No";
      IF Cust."Mobile Phone No"<>'' THEN
      SMSMessage.INSERT;

      END;
    END;

    BEGIN
    END.
  }
}

