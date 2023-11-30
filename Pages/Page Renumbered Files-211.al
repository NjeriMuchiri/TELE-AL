OBJECT page 17402 Bosa Receipts H Card-Checkoff
{
  OBJECT-PROPERTIES
  {
    Date=04/06/23;
    Time=[ 4:01:05 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516248;
    SourceTableView=WHERE(Posted=CONST(No));
    PageType=Card;
    OnInsertRecord=BEGIN
                        "Posting date":=TODAY;
                        "Date Entered":=TODAY;
                   END;

    ActionList=ACTIONS
    {
      { 1102755017;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 1102755018;1 ;Action    ;
                      Name=<XMLport Import receipts>;
                      CaptionML=ENU=Import Receipts;
                      RunObject=XMLport 51516002;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process }
      { 1000000001;1 ;Action    ;
                      Name=Validate Receipts;
                      CaptionML=ENU=Validate Receipts;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ValidateEmailLoggingSetup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 RcptBufLines.RESET;
                                 RcptBufLines.SETRANGE(RcptBufLines."Receipt Header No",No);
                                  IF RcptBufLines.FIND('-')THEN BEGIN
                                 REPEAT
                                 //MESSAGE('Message%1Payroll%2',RcptBufLines."Receipt Header No",RcptBufLines."Staff/Payroll No");
                                 Memb.RESET;
                                 Memb.SETRANGE(Memb."Payroll/Staff No",RcptBufLines."Staff/Payroll No");
                                 IF Memb.FIND('-') THEN BEGIN
                                 RcptBufLines."Member No":=Memb."No.";
                                 RcptBufLines.Name:=Memb.Name;
                                 RcptBufLines."ID No.":=Memb."ID No.";
                                 //RcptBufLines."Trans Type":=RcptBufLines."Trans Type"::sLoan;
                                 RcptBufLines."Member Found":=TRUE;
                                 RcptBufLines.MODIFY;
                                 END;
                                 UNTIL RcptBufLines.NEXT=0;
                                 END;
                                 MESSAGE('Successfull validated');
                               END;
                                }
      { 1120054000;1 ;Action    ;
                      Name=Post Block Checkoff;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Category9;
                      OnAction=VAR
                                 RSchedule@1120054000 : Record 51516234;
                                 Prod@1120054001 : Record 51516240;
                                 ExpectedPrincipalRepayment@1120054002 : Decimal;
                                 ExpectedTotalRepayment@1120054003 : Decimal;
                               BEGIN
                                 IF CONFIRM('Are You Sure You Want To Create Journal Lines?',TRUE,FALSE)=TRUE THEN BEGIN

                                 TESTFIELD("Posting date");
                                 TESTFIELD("Loan CutOff Date");

                                 JournalBatchName:='CHECKOFF';
                                 //Delete journal
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",JournalBatchName);
                                 IF Gnljnline.FIND('-') THEN
                                    Gnljnline.DELETEALL;

                                 CheckoffMessages.DELETEALL;
                                 SerialNo:=0;
                                 RcptBufLines.RESET;
                                 RcptBufLines.SETRANGE(RcptBufLines."Receipt Header No",No);
                                 RcptBufLines.SETFILTER(RcptBufLines."Member Found",'%1',TRUE);
                                  IF RcptBufLines.FIND('-')THEN BEGIN
                                 WindowDialoag.OPEN('Processing Checkoff For Member No. #1#######');
                                 REPEAT
                                         SLEEP(1000);
                                         WindowDialoag.UPDATE(1,RcptBufLines."Member No"+':'+RcptBufLines.Name);
                                         RunningBalance:=0;
                                         RunningBalance:=RcptBufLines.Amount;

                                         IF RunningBalance>0 THEN
                                                     MessageC:='';
                                         //Deduct Benovelent Fund
                                         Members.RESET;
                                         Members.SETRANGE(Members."No.",RcptBufLines."Member No");
                                         IF Members.FINDFIRST THEN
                                         BEGIN

                                               IF Members."Pays Benevolent"=TRUE THEN BEGIN
                                               Benevolent:=0;
                                               IF RunningBalance>=300 THEN
                                               Benevolent:=300
                                               ELSE
                                               Benevolent:=RunningBalance;

                                               LineN:=LineN+10000;
                                               Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"Benevolent Fund",AccountTypes::Member,RcptBufLines."Member No","Posting date",-Benevolent,
                                               'BOSA','Benevolent Contribution','');

                                 //                 IF CheckoffMessages.FINDLAST THEN
                                 //                SerialNo:=SerialNo+CheckoffMessages.No
                                 //                 ELSE
                                 //                 SerialNo:=1;
                                 //
                                 //                  CheckoffMessages.INIT;
                                 //                  CheckoffMessages.No:=SerialNo;
                                 //                  CheckoffMessages."Client Code":=RcptBufLines."Member No";
                                 //                  CheckoffMessages.Message:='Benevolent Contribution Ksh:'+FORMAT(Benevolent);
                                                  //MessageC:='Benevolent Contribution Ksh:'+FORMAT(Benevolent);
                                                  //CheckoffMessages.INSERT;
                                               {LineN:=LineN+10000;
                                               Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"Benevolent Fund","Account Type","Account No","Posting date",Benevolent,
                                               'BOSA','Benevolent Contribution','');}
                                               RunningBalance:=RunningBalance-Benevolent;

                                               END;
                                         //End Deduct Benovelent Fund


                                               IF RunningBalance>0 THEN
                                                 //Deduct Monthly Cntribution
                                                 IF Members."Monthly Contribution">0 THEN BEGIN
                                                       MonthlyContrib:=0;
                                                       IF RunningBalance>=Members."Monthly Contribution" THEN
                                                       MonthlyContrib:=Members."Monthly Contribution"
                                                       ELSE
                                                       MonthlyContrib:=RunningBalance;
                                                       LineN:=LineN+10000;
                                                       Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"Deposit Contribution",AccountTypes::Member,RcptBufLines."Member No","Posting date",-MonthlyContrib,
                                                       'BOSA','Shares Contribution','');


                                 //                   IF CheckoffMessages.FINDLAST THEN
                                 //                   SerialNo:=SerialNo+CheckoffMessages.No
                                 //                   ELSE
                                 //                   SerialNo:=1;
                                 //
                                 //                  CheckoffMessages.INIT;
                                 //                  CheckoffMessages.No:=SerialNo;
                                 //                  CheckoffMessages."Client Code":=RcptBufLines."Member No";
                                 //                  CheckoffMessages.Message:='Deposit Contribution Ksh:'+FORMAT(MonthlyContrib);
                                                  MessageC:=MessageC+' '+'Deposit Contribution Ksh:'+FORMAT(MonthlyContrib);
                                  //                CheckoffMessages.INSERT;
                                                       {LineN:=LineN+10000;
                                                       Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"Deposit Contribution","Account Type","Account No","Posting date",MonthlyContrib,
                                                       'BOSA','Shares Contribution','');}
                                                       RunningBalance:=RunningBalance-MonthlyContrib;
                                                       //End Monthly Contribution
                                                 END;
                                         END;

                                         IF RunningBalance>0 THEN BEGIN
                                             //Ess Deposits
                                             //Deduct Benovelent Fund
                                             Membersx.RESET;
                                             Membersx.SETRANGE(Membersx."No.",RcptBufLines."Member No");
                                             IF Membersx.FINDFIRST THEN BEGIN
                                                   IF Membersx."Monthly Sch.Fees Cont.">0 THEN BEGIN
                                                         Ess:=0;
                                                         IF RunningBalance>=Membersx."Monthly Sch.Fees Cont." THEN
                                                         Ess:=Membersx."Monthly Sch.Fees Cont."
                                                         ELSE
                                                         Ess:=RunningBalance;

                                                         LineN:=LineN+10000;
                                                         Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"SchFee Shares",AccountTypes::Member,RcptBufLines."Member No","Posting date",-Ess,
                                                         'BOSA','Ess Contribution','');
                                 //                    IF CheckoffMessages.FINDLAST THEN
                                 //                   SerialNo:=SerialNo+CheckoffMessages.No
                                 //                   ELSE
                                 //                   SerialNo:=1;
                                 //
                                 //                  CheckoffMessages.INIT;
                                 //                  CheckoffMessages.No:=SerialNo;
                                 //                  CheckoffMessages."Client Code":=RcptBufLines."Member No";
                                 //                  CheckoffMessages.Message:='Ess Contribution Ksh:'+FORMAT(Ess);
                                                  MessageC:=MessageC+' '+'Ess Contribution Ksh:'+FORMAT(Ess);
                                 //                 CheckoffMessages.INSERT;
                                                         {LineN:=LineN+10000;
                                                         Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"SchFee Shares","Account Type","Account No","Posting date",Ess,
                                                         'BOSA','Ess Contribution','');}
                                                         RunningBalance:=RunningBalance-Ess;

                                                   END;
                                             END;

                                         END;

                                         //Begin Loans
                                         LoansR.RESET;
                                         LoansR.SETRANGE(LoansR."Client Code",RcptBufLines."Member No");
                                         LoansR.SETFILTER(LoansR.Posted,'%1',TRUE);
                                         LoansR.SETFILTER("Outstanding Balance",'>0');
                                         LoansR.SETRANGE(LoansR."Recovery Mode",LoansR."Recovery Mode"::Checkoff);
                                         LoansR.SETRANGE(LoansR."Issued Date",0D,"Loan CutOff Date");
                                         LoansR.SETRANGE(LoansR."Date filter",0D,"Posting date");
                                         LoansR.SETAUTOCALCFIELDS("Outstanding Balance","Oustanding Interest");
                                         IF LoansR.FINDSET THEN BEGIN
                                               REPEAT

                                                      // LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");
                                                        IF LoansR."Oustanding Interest"<>LoansR.InterestBalanceAsAt("Posting date") THEN
                                                           LoansR."Oustanding Interest":=LoansR.InterestBalanceAsAt("Posting date");

                                                       InterestBal:=0;
                                                       //Interest Payment
                                                       IF LoansR."Oustanding Interest">0 THEN BEGIN

                                                       IF RunningBalance>=LoansR."Oustanding Interest" THEN
                                                       InterestBal:=LoansR."Oustanding Interest"
                                                       ELSE
                                                       InterestBal:=RunningBalance;
                                                       //MESSAGE('RunningBalInt%1Dedi%2LoanInt%3',RunningBalance,InterestBal,LoansR."Oustanding Interest");
                                                       LineN:=LineN+10000;
                                                       Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"Interest Paid",AccountTypes::Member,RcptBufLines."Member No","Posting date",-InterestBal,
                                                       'BOSA','Interest Paid',LoansR."Loan  No.");

                                                      { LineN:=LineN+10000;
                                                       Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::" ","Account Type","Account No","Posting date",InterestBal,
                                                       'BOSA','Interest Paid','');}
                                                       IF InterestBal>0 THEN BEGIN
                                 //                        IF CheckoffMessages.FINDLAST THEN
                                 //                       SerialNo:=SerialNo+CheckoffMessages.No
                                 //                        ELSE
                                 //                       SerialNo:=1;
                                 //
                                 //                      CheckoffMessages.INIT;
                                 //                      CheckoffMessages.No:=SerialNo;
                                 //                      CheckoffMessages."Client Code":=RcptBufLines."Member No";
                                 //                      CheckoffMessages.Message:='Interest Repayment Ksh:'+LoansR."Loan Product Type Name"+FORMAT(InterestBal);
                                                      MessageC:=MessageC+' '+'Interest Repayment '+LoansR."Loan Product Type Name"+' Ksh:'+FORMAT(InterestBal);
                                 //                     CheckoffMessages.INSERT;
                                                       RunningBalance:=RunningBalance-InterestBal;
                                                       END;
                                                       END;
                                                       //End Interest Payment

                                                       //Loan Payment
                                                       IF LoansR."Outstanding Balance">0 THEN BEGIN
                                                           IF Prod.GET(LoansR."Loan Product Type") THEN
                                                              IF Prod."Interest rate"<>0 THEN
                                                                 Sfactory.FnGenerateLoanSchedule(LoansR."Loan  No.");
                                                           FnGetLoanArrears(LoansR."Loan  No.");
                                                           LoanBal:=0;

                                                           ExpectedTotalRepayment:=LoansR.GetLoanExpectedRepayment(0,"Posting date");
                                                           ExpectedPrincipalRepayment:=ExpectedTotalRepayment-InterestBal;
                                                           IF ExpectedPrincipalRepayment<0 THEN ExpectedPrincipalRepayment:=0;

                                                           IF Arrear<ExpectedPrincipalRepayment THEN
                                                              Arrear:=ExpectedPrincipalRepayment;

                                                           IF RunningBalance>=Arrear THEN
                                                           LoanBal:=Arrear
                                                           ELSE
                                                           LoanBal:=RunningBalance;
                                                           //MESSAGE('Loans%1Arrear%2Loanbal%3Outbal%4',LoansR."Loan  No.",Arrear,LoanBal);

                                                           IF LoanBal>LoansR."Outstanding Balance" THEN
                                                           LoanBal:=LoansR."Outstanding Balance";

                                                           LineN:=LineN+10000;
                                                           Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::Repayment,AccountTypes::Member,RcptBufLines."Member No","Posting date",-LoanBal,
                                                           'BOSA','Loan Repayment',LoansR."Loan  No.");

                                                            IF LoanBal>0 THEN BEGIN
                                 //                            IF CheckoffMessages.FINDLAST THEN
                                 //                            SerialNo:=SerialNo+CheckoffMessages.No
                                 //                            ELSE
                                 //                           SerialNo:=1;
                                 //
                                 //                           CheckoffMessages.INIT;
                                 //                           CheckoffMessages.No:=SerialNo;
                                 //                           CheckoffMessages."Client Code":=RcptBufLines."Member No";
                                 //                         CheckoffMessages.Message:='Loan Repayment Ksh:'+LoansR."Loan Product Type Name"+FORMAT(LoanBal);
                                                          MessageC:=MessageC+' '+'Loan Repayment '+LoansR."Loan Product Type Name"+' Ksh:'+FORMAT(LoanBal);
                                  //                         CheckoffMessages.INSERT;
                                                           END;

                                                           RunningBalance:=RunningBalance-LoanBal;

                                                     END;

                                               //End Loan Payment
                                               UNTIL LoansR.NEXT=0;


                                         END;


                                                   SerialNo:=SerialNo+1;


                                                  CheckoffMessages.INIT;
                                                  CheckoffMessages.No:=SerialNo;
                                                  CheckoffMessages."Client Code":=RcptBufLines."Member No";
                                                  MessageC:=PADSTR(MessageC,200);
                                                  //Len1:=STRLEN(MessageC);
                                                  CheckoffMessages.Message:=MessageC;
                                                  //MESSAGE('Length%1',Len1);
                                                 // MessageC:=MessageC+' '+'Ess Contribution Ksh:'+FORMAT(Ess);
                                                  CheckoffMessages.INSERT;


                                         //End Deduct Benovelent Fund



                                         //End ESS Deposits

                                         //Balance to deposits
                                         IF RunningBalance>0 THEN BEGIN
                                               LineN:=LineN+10000;
                                               Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"Deposit Contribution",AccountTypes::Member,RcptBufLines."Member No","Posting date",-RunningBalance,
                                               'BOSA','Shares Contribution : Excess','');

                                               {LineN:=LineN+10000;
                                               Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::"Deposit Contribution","Account Type","Account No","Posting date",RunningBalance,
                                               'BOSA','Shares Contribution','');}
                                         END;
                                 Membersx.RESET;
                                 Membersx.SETRANGE(Membersx."No.",RcptBufLines."Member No");
                                 IF Membersx.FINDFIRST THEN BEGIN
                                 Membersx."Checkoff Member":=TRUE;
                                 Membersx."Last Checkoff Date":="Posting date";
                                 Membersx."Last Checkoff Amount":=MonthlyContrib;
                                 Membersx.MODIFY;
                                 END;
                                 UNTIL RcptBufLines.NEXT=0;
                                 CALCFIELDS("Scheduled Amount");
                                 LineN:=LineN+10000;
                                 Sfactory.FnCreateGnlJournalLine('GENERAL',JournalBatchName,"Document No",LineN,TransactionTypes::" ","Account Type","Account No","Posting date","Scheduled Amount",
                                 'BOSA','Balancing account','');
                                 WindowDialoag.CLOSE;
                                 END;
                                 END;
                               END;
                                }
      { 1102755019;1 ;ActionGroup }
      { 1000000000;1 ;Action    ;
                      Name=Post check off Deposits;
                      CaptionML=ENU=Post Deposits/ESS;
                      Promoted=Yes;
                      Visible=False;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 genstup.GET();
                                 IF Posted=TRUE THEN
                                 ERROR('This Check Off has already been posted');
                                 IF "Account No" = '' THEN
                                 ERROR('You must specify the Account No.');
                                 IF "Document No" = '' THEN
                                 ERROR('You must specify the Document No.');
                                 IF "Posting date" = 0D THEN
                                 ERROR('You must specify the Posting date.');
                                 IF "Posting date" = 0D THEN
                                 ERROR('You must specify the Posting date.');
                                 {IF "Loan CutOff Date" = 0D THEN
                                 ERROR('You must specify the Loan CutOff Date.');
                                 Datefilter:='..'+FORMAT("Loan CutOff Date");
                                 IssueDate:="Loan CutOff Date";
                                 startDate:=010100D;}

                                 //Delete journal
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",JournalBatchName);
                                 IF Gnljnline.FIND('-') THEN
                                 Gnljnline.DELETEALL;

                                 RunBal:=0;
                                 TotalWelfareAmount:=0;
                                 CALCFIELDS("Scheduled Amount");
                                 IF "Scheduled Amount" <>   Amount THEN BEGIN
                                 ERROR('Scheduled Amount Is Not Equal To Cheque Amount');
                                 END;

                                 RcptBufLines.RESET;
                                 RcptBufLines.SETRANGE(RcptBufLines."Receipt Header No",No);
                                 RcptBufLines.SETRANGE(RcptBufLines.Posted,FALSE);
                                 IF RcptBufLines.FIND('-') THEN BEGIN

                                   REPEAT
                                     RunBal:=0;
                                     RunBal:=RcptBufLines.Amount;
                                     {RunBal:=FnRunInterest(RcptBufLines,RunBal);
                                     RunBal:=FnRecoverWelfare(RcptBufLines,RunBal);
                                     RunBal:=FnRunPrinciple(RcptBufLines,RunBal);
                                     RunBal:=FnRunEntranceFee(RcptBufLines,RunBal);
                                     RunBal:=FnRunShareCapital(RcptBufLines,RunBal); }
                                     RunBal:=FnRunDepositContribution(RcptBufLines,RunBal);
                                     {RunBal:=FnRunXmasContribution(RcptBufLines,RunBal);
                                     RunBal:=FnRecoverPrincipleFromExcess(RcptBufLines,RunBal);}
                                     FnTransferExcessToUnallocatedFunds(RcptBufLines,RunBal);
                                   UNTIL RcptBufLines.NEXT=0;
                                 END;
                                 {
                                 //CREDIT WELFARE VENDOR ACCOUNT
                                 LineN:=LineN+10000;
                                 Gnljnline.INIT;
                                 Gnljnline."Journal Template Name":='GENERAL';
                                 Gnljnline."Journal Batch Name":=JournalBatchName;
                                 Gnljnline."Line No.":=LineN;
                                 Gnljnline."Account Type":=Gnljnline."Account Type"::Vendor;
                                 Gnljnline."Account No.":='L25001000001';  //Insert Welfare Control account here
                                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                                 Gnljnline."Document No.":="Document No";
                                 Gnljnline."Posting Date":="Posting date";
                                 Gnljnline.Description:='Welfare Contributions';
                                 Gnljnline.Amount:=TotalWelfareAmount*-1;
                                 Gnljnline.VALIDATE(Gnljnline.Amount);
                                 Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                                 Gnljnline."Shortcut Dimension 2 Code":='001';
                                 Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                                 Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                                 IF Gnljnline.Amount<>0 THEN
                                 Gnljnline.INSERT;
                                 }
                                 //DEBIT TOTAL CHECK OFF
                                 CALCFIELDS("Scheduled Amount");
                                  LineN:=LineN+10000;
                                  Gnljnline.INIT;
                                  Gnljnline."Journal Template Name":='GENERAL';
                                  Gnljnline."Journal Batch Name":=JournalBatchName;
                                  Gnljnline."Line No.":=LineN;
                                  Gnljnline."Account Type":="Account Type";
                                  Gnljnline."Account No.":="Account No";
                                  Gnljnline.VALIDATE(Gnljnline."Account No.");
                                  Gnljnline."Document No.":="Document No";
                                  Gnljnline."Posting Date":="Posting date";
                                  Gnljnline.Description:='CHECKOFF '+Remarks;
                                  Gnljnline.Amount:="Scheduled Amount";
                                  Gnljnline.VALIDATE(Gnljnline.Amount);
                                  Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                                  Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
                                  Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                                  Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                                  IF Gnljnline.Amount<>0 THEN
                                  Gnljnline.INSERT;

                                 //Post New  //To be Uncommented after thorough tests
                                 {Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",JournalBatchName);
                                 IF Gnljnline.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",Gnljnline);
                                 END;
                                 Posted:=True;
                                 MODIFY;}
                                 MESSAGE('CheckOff Successfully Generated');
                                 }
                               END;
                                }
      { 1000000002;1 ;Action    ;
                      Name=Post check off Loans;
                      CaptionML=ENU=Post check off Loans;
                      Promoted=Yes;
                      Visible=False;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 genstup.GET();
                                 IF Posted=TRUE THEN
                                 ERROR('This Check Off has already been posted');
                                 IF "Account No" = '' THEN
                                 ERROR('You must specify the Account No.');
                                 IF "Document No" = '' THEN
                                 ERROR('You must specify the Document No.');
                                 IF "Posting date" = 0D THEN
                                 ERROR('You must specify the Posting date.');
                                 IF "Posting date" = 0D THEN
                                 ERROR('You must specify the Posting date.');
                                 IF "Loan CutOff Date" = 0D THEN
                                 ERROR('You must specify the Loan CutOff Date.');
                                 Datefilter:='..'+FORMAT("Loan CutOff Date");
                                 IssueDate:="Loan CutOff Date";
                                 startDate:=010100D;

                                 //Delete journal
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",JournalBatchName);
                                 IF Gnljnline.FIND('-') THEN
                                 Gnljnline.DELETEALL;

                                 RunBal:=0;
                                 TotalWelfareAmount:=0;
                                 CALCFIELDS("Scheduled Amount");
                                 IF "Scheduled Amount" <>   Amount THEN BEGIN
                                 ERROR('Scheduled Amount Is Not Equal To Cheque Amount');
                                 END;

                                 RcptBufLines.RESET;
                                 RcptBufLines.SETRANGE(RcptBufLines."Receipt Header No",No);
                                 RcptBufLines.SETRANGE(RcptBufLines.Posted,FALSE);
                                 IF RcptBufLines.FIND('-') THEN BEGIN

                                   REPEAT
                                     RunBal:=0;
                                     RunBal:=RcptBufLines.Amount;
                                     RunBal:=FnRunInterest(RcptBufLines,RunBal);
                                    // RunBal:=FnRecoverWelfare(RcptBufLines,RunBal);
                                     RunBal:=FnRunPrinciple(RcptBufLines,RunBal);
                                    // RunBal:=FnRunEntranceFee(RcptBufLines,RunBal);
                                    // RunBal:=FnRunShareCapital(RcptBufLines,RunBal);
                                    // RunBal:=FnRunDepositContribution(RcptBufLines,RunBal);
                                    // RunBal:=FnRunXmasContribution(RcptBufLines,RunBal);
                                     RunBal:=FnRecoverPrincipleFromExcess(RcptBufLines,RunBal);
                                             FnTransferExcessToUnallocatedFunds(RcptBufLines,RunBal);
                                   UNTIL RcptBufLines.NEXT=0;
                                 END;

                                 {//CREDIT WELFARE VENDOR ACCOUNT
                                 LineN:=LineN+10000;
                                 Gnljnline.INIT;
                                 Gnljnline."Journal Template Name":='GENERAL';
                                 Gnljnline."Journal Batch Name":=JournalBatchName;
                                 Gnljnline."Line No.":=LineN;
                                 Gnljnline."Account Type":=Gnljnline."Account Type"::Vendor;
                                 Gnljnline."Account No.":='L25001000001';  //Insert Welfare Control account here
                                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                                 Gnljnline."Document No.":="Document No";
                                 Gnljnline."Posting Date":="Posting date";
                                 Gnljnline.Description:='Welfare Contributions';
                                 Gnljnline.Amount:=TotalWelfareAmount*-1;
                                 Gnljnline.VALIDATE(Gnljnline.Amount);
                                 Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                                 Gnljnline."Shortcut Dimension 2 Code":='001';
                                 Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                                 Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                                 IF Gnljnline.Amount<>0 THEN
                                 Gnljnline.INSERT;}

                                 //DEBIT TOTAL CHECK OFF
                                 CALCFIELDS("Scheduled Amount");
                                  LineN:=LineN+10000;
                                  Gnljnline.INIT;
                                  Gnljnline."Journal Template Name":='GENERAL';
                                  Gnljnline."Journal Batch Name":=JournalBatchName;
                                  Gnljnline."Line No.":=LineN;
                                  Gnljnline."Account Type":="Account Type";
                                  Gnljnline."Account No.":="Account No";
                                  Gnljnline.VALIDATE(Gnljnline."Account No.");
                                  Gnljnline."Document No.":="Document No";
                                  Gnljnline."Posting Date":="Posting date";
                                  Gnljnline.Description:='CHECKOFF '+Remarks;
                                  Gnljnline.Amount:="Scheduled Amount";
                                  Gnljnline.VALIDATE(Gnljnline.Amount);
                                  Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                                  Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
                                  Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                                  Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                                  IF Gnljnline.Amount<>0 THEN
                                  Gnljnline.INSERT;

                                 //Post New  //To be Uncommented after thorough tests
                                 {Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",JournalBatchName);
                                 IF Gnljnline.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",Gnljnline);
                                 END;
                                 Posted:=True;
                                 MODIFY;}
                                 MESSAGE('CheckOff Successfully Generated');}
                               END;
                                }
      { 1120054001;1 ;Action    ;
                      Name=Send SMS;
                      Promoted=Yes;
                      Image=report;
                      OnAction=VAR
                                 ReceiptsProcessing_LCheckoff@1120054000 : Record 51516249;
                               BEGIN
                                         IF CONFIRM('Are you sure you want to send SMS?',TRUE,FALSE)=TRUE THEN BEGIN
                                         IF CheckoffMessages.FINDFIRST THEN BEGIN
                                         REPEAT
                                         Members.RESET;
                                         Members.SETRANGE(Members."No.",CheckoffMessages."Client Code");
                                         IF Members.FINDFIRST THEN BEGIN
                                         Members.CALCFIELDS(Members."Current Savings");
                                         Salutation:='';
                                         Salutation:='Dear '+Members.Name+' your checkoff deductions are as follows: '+' '+CheckoffMessages.Message+' Your total deposits is Ksh'+FORMAT(Members."Current Savings");
                                         SkyMbanking.SendSms(Source::CHECKOFFDEDUCTIONS,Members."Mobile Phone No",Salutation,'','',TRUE,200,TRUE);
                                         END;
                                         UNTIL CheckoffMessages.NEXT=0;
                                         END;
                                         END;
                               END;
                                }
      { 1120054002;1 ;Action    ;
                      Name=Mark As Posted;
                      Promoted=Yes;
                      Image=Action;
                      OnAction=VAR
                                 ReceiptsProcessing_LCheckoff@1120054000 : Record 51516249;
                               BEGIN
                                         IF CONFIRM('Are you sure you want to mark this checkoff as posted?',TRUE,FALSE)=TRUE THEN BEGIN
                                           Posted:=TRUE;
                                           "Posted By":=USERID;
                                           "Posting date":=TODAY;
                                           MODIFY;
                                         END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 16  ;2   ;Field     ;
                SourceExpr=No;
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                SourceExpr="Entered By";
                Enabled=FALSE }

    { 14  ;2   ;Field     ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                SourceExpr="Posting date";
                Editable=true }

    { 12  ;2   ;Field     ;
                SourceExpr="Loan CutOff Date" }

    { 11  ;2   ;Field     ;
                SourceExpr=Remarks }

    { 10  ;2   ;Field     ;
                SourceExpr="Total Count" }

    { 9   ;2   ;Field     ;
                SourceExpr="Posted By" }

    { 8   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 7   ;2   ;Field     ;
                SourceExpr="Account No" }

    { 6   ;2   ;Field     ;
                SourceExpr="Employer Code" }

    { 5   ;2   ;Field     ;
                SourceExpr="Document No" }

    { 4   ;2   ;Field     ;
                SourceExpr=Posted;
                Editable=true }

    { 3   ;2   ;Field     ;
                SourceExpr=Amount }

    { 2   ;2   ;Field     ;
                SourceExpr="Scheduled Amount" }

    { 1   ;1   ;Part      ;
                Name=Bosa receipt lines;
                SubPageLink=Receipt Header No=FIELD(No);
                PagePartID=Page51516265;
                PartType=Page }

  }
  CODE
  {
    VAR
      RcptBufLinesTwo@1000000015 : Record 51516249;
      LoansR@1120054000 : Record 51516230;
      LoansRegister@1120054001 : Record 51516230;
      Sfactory@1120054002 : Codeunit 51516022;
      TransactionTypes@1120054003 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      AccountTypes@1120054004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      RunningBalance@1120054005 : Decimal;
      InterestBal@1120054006 : Decimal;
      LoanBal@1120054007 : Decimal;
      LSchedule@1120054008 : Record 51516234;
      Arrear@1120054009 : Decimal;
      Members@1120054010 : Record 51516223;
      MonthlyContrib@1120054011 : Decimal;
      Benevolent@1120054012 : Decimal;
      WindowDialoag@1120054013 : Dialog;
      GenJournalLine@1120054014 : Record 81;
      RcptBufLines@1120054015 : Record 51516249;
      Memb@1120054016 : Record 51516223;
      Gnljnline@1120054017 : Record 81;
      LineN@1120054018 : Integer;
      Ess@1120054019 : Decimal;
      Membersx@1120054020 : Record 51516223;
      JournalBatchName@1120054021 : Code[20];
      CheckoffMessages@1120054024 : Record 50699;
      SerialNo@1120054023 : Integer;
      LoanTypes@1120054022 : Code[30];
      MemberName@1120054025 : Text;
      MessageC@1120054026 : Text[1000];
      SMSMessage@1120054027 : Record 51516329;
      iEntryNo@1120054028 : Integer;
      SkyMbanking@1120054029 : Codeunit 51516701;
      Source@1120054030 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,CHECKOFFDEDUCTIONS';
      Salutation@1120054031 : Text;
      Len1@1120054032 : Integer;
      MessageX@1120054033 : Text[1000];

    LOCAL PROCEDURE FnRunInterest@1000000013(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      InterestToRecover@1000000003 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN BEGIN
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Client Code",ObjRcptBuffer."Member No");
      LoanApp.SETRANGE(LoanApp."Loan Product Type",ObjRcptBuffer."Loan Product Type");
      LoanApp.SETRANGE(LoanApp."Recovery Mode",LoanApp."Recovery Mode"::Checkoff);
      //LoanApp.SETFILTER(LoanApp."Date filter",Datefilter); Deduct all interest outstanding regardless of date
      IF LoanApp.FIND('-') THEN
        BEGIN
          REPEAT
          LoanApp.CALCFIELDS(LoanApp."Oustanding Interest");
          IF LoanApp."Oustanding Interest">0 THEN
            BEGIN
                  IF  RunningBalance > 0 THEN //300
                    BEGIN
                      AmountToDeduct:=0;
                      InterestToRecover:=ROUND(LoanApp."Oustanding Interest",0.05,'>');//100
                      IF RunningBalance >= InterestToRecover THEN
                      AmountToDeduct:=InterestToRecover
                      ELSE
                      AmountToDeduct:=RunningBalance;

                      LineN:=LineN+10000;
                      Gnljnline.INIT;
                      Gnljnline."Journal Template Name":='GENERAL';
                      Gnljnline."Journal Batch Name":=JournalBatchName;
                      Gnljnline."Line No.":=LineN;
                      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                      Gnljnline."Account No.":=LoanApp."Client Code";
                      Gnljnline.VALIDATE(Gnljnline."Account No.");
                      Gnljnline."Document No.":="Document No";
                      Gnljnline."Posting Date":="Posting date";
                      Gnljnline.Description:=LoanApp."Loan Product Type"+'-Loan Interest Paid ';
                      Gnljnline.Amount:=-1*AmountToDeduct;
                      Gnljnline.VALIDATE(Gnljnline.Amount);
                      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
                      Gnljnline."Loan No":=LoanApp."Loan  No.";

                      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                      Gnljnline."Shortcut Dimension 2 Code":=FnGetMemberBranch(LoanApp."Client Code");
                      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                      IF Gnljnline.Amount<>0 THEN
                      Gnljnline.INSERT;
                      RunningBalance:=RunningBalance-ABS(Gnljnline.Amount);
                  END;
                END;
        UNTIL LoanApp.NEXT = 0;
        END;
        EXIT(RunningBalance);
      END; }
    END;

    LOCAL PROCEDURE FnRunPrinciple@1000000021(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
      AmountToDeduct@1000000005 : Decimal;
      NewOutstandingBal@1000000006 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN BEGIN
      varTotalRepay:=0;
      varMultipleLoan:=0;

      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Client Code",ObjRcptBuffer."Member No");
      LoanApp.SETRANGE(LoanApp."Recovery Mode",LoanApp."Recovery Mode"::Checkoff);
      LoanApp.SETRANGE(LoanApp."Issued Date",startDate,IssueDate);
      IF LoanApp.FIND('-') THEN BEGIN
        REPEAT
          IF  RunningBalance > 0 THEN
            BEGIN
              LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
              IF LoanApp."Outstanding Balance" > 0 THEN
                BEGIN
                  AmountToDeduct:=RunningBalance;
                  NewOutstandingBal:=LoanApp."Outstanding Balance"-RunningBalance;

                  IF AmountToDeduct >= LoanApp."Loan Principle Repayment" THEN
                    BEGIN
                      AmountToDeduct:=LoanApp."Loan Principle Repayment";
                      NewOutstandingBal:=LoanApp."Outstanding Balance"-AmountToDeduct;
                    END;
                  IF AmountToDeduct >=LoanApp."Outstanding Balance" THEN
                    BEGIN
                      AmountToDeduct:=LoanApp."Outstanding Balance";
                      NewOutstandingBal:=LoanApp."Outstanding Balance"-AmountToDeduct;
                    END;

                    IF NewOutstandingBal >0 THEN
                      FnSaveTempLoanAmount(LoanApp,NewOutstandingBal);

                      LineN:=LineN+10000;
                      Gnljnline.INIT;
                      Gnljnline."Journal Template Name":='GENERAL';
                      Gnljnline."Journal Batch Name":=JournalBatchName;
                      Gnljnline."Line No.":=LineN;
                      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                      Gnljnline."Account No.":=LoanApp."Client Code";
                      Gnljnline.VALIDATE(Gnljnline."Account No.");
                      Gnljnline."Document No.":="Document No";
                      Gnljnline."Posting Date":="Posting date";
                      Gnljnline.Description:=LoanApp."Loan Product Type"+'-Loan Repayment ';
                      Gnljnline.Amount:=AmountToDeduct*-1;
                      Gnljnline.VALIDATE(Gnljnline.Amount);
                      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Repayment;
                      Gnljnline."Loan No":=LoanApp."Loan  No.";
                      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                      Gnljnline."Shortcut Dimension 2 Code":=FnGetMemberBranch(LoanApp."Client Code");
                      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                      IF Gnljnline.Amount<>0 THEN
                      Gnljnline.INSERT;
                      RunningBalance:=RunningBalance-ABS(Gnljnline.Amount);
                    END;
               END;
          UNTIL LoanApp.NEXT = 0;
      END;
      EXIT(RunningBalance);
      END; }
    END;

    LOCAL PROCEDURE FnRunEntranceFee@1000000027(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
      ObjMember@1000000005 : Record 51516223;
      AmountToDeduct@1000000006 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN
        BEGIN
          ObjMember.RESET;
          ObjMember.SETRANGE(ObjMember."No.",ObjRcptBuffer."Member No");
          ObjMember.SETRANGE(ObjMember."Payroll/Staff No",ObjRcptBuffer."Staff/Payroll No");
          ObjMember.SETRANGE(ObjMember."Employer Code",ObjRcptBuffer."Employer Code");
          ObjMember.SETFILTER(ObjMember."Registration Date",'>%1',011116D); //To Ensure deduction is for New Members Only
          IF ObjMember.FIND('-') THEN
            BEGIN
                REPEAT
                    ObjMember.CALCFIELDS(ObjMember."Registration Fee Paid");
                    IF ABS(ObjMember."Registration Fee Paid")<500 THEN
                      BEGIN
                         IF ObjMember."Registration Date" <>0D THEN
                            BEGIN

                                AmountToDeduct:=0;
                                AmountToDeduct:=genstup."Registration Fee"-ABS(ObjMember."Registration Fee Paid");
                                IF RunningBalance <= AmountToDeduct THEN
                                AmountToDeduct:=RunningBalance;

                                LineN:=LineN+10000;
                                Gnljnline.INIT;
                                Gnljnline."Journal Template Name":='GENERAL';
                                Gnljnline."Journal Batch Name":=JournalBatchName;
                                Gnljnline."Line No.":=LineN;
                                Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                                Gnljnline."Account No.":=RcptBufLines."Member No";
                                Gnljnline.VALIDATE(Gnljnline."Account No.");
                                Gnljnline."Document No.":="Document No";
                                Gnljnline."Posting Date":="Posting date";
                                Gnljnline.Description:='Registration Fee '+Remarks;
                                Gnljnline.Amount:=AmountToDeduct*-1;
                                Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Registration Fee";
                                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                                Gnljnline."Shortcut Dimension 2 Code":=ObjMember."Global Dimension 2 Code";
                                Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                                Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                                Gnljnline.VALIDATE(Gnljnline.Amount);
                                IF Gnljnline.Amount<>0 THEN
                                Gnljnline.INSERT;
                                RunningBalance:=RunningBalance-ABS(Gnljnline.Amount);
                            END;
                      END;
                UNTIL Cust.NEXT=0;
             END;
      EXIT(RunningBalance);
      END;
      }
    END;

    LOCAL PROCEDURE FnRunShareCapital@1000000033(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
      ObjMember@1000000005 : Record 51516223;
      AmountToDeduct@1000000006 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN
        BEGIN
          ObjMember.RESET;
          ObjMember.SETRANGE(ObjMember."No.",ObjRcptBuffer."Member No");
          ObjMember.SETRANGE(ObjMember."Employer Code",ObjRcptBuffer."Employer Code");
          ObjMember.SETRANGE(ObjMember."Customer Type",ObjMember."Customer Type"::Member);
          IF ObjMember.FIND('-') THEN
             BEGIN
                //REPEAT Deducted once unless otherwise advised
                  ObjMember.CALCFIELDS (ObjMember."Shares Retained");
                  IF  ObjMember."Shares Retained" < genstup."Retained Shares" THEN
                  BEGIN
                    SHARESCAP:=genstup."Retained Shares";
                    DIFF:=SHARESCAP-ObjMember."Shares Retained";

                    IF  DIFF > 1 THEN
                        BEGIN
                        IF RunningBalance > 0 THEN
                          BEGIN
                           AmountToDeduct:=0;
                                AmountToDeduct:=DIFF;
                                IF DIFF > 500 THEN
                                  AmountToDeduct:=500;
                           IF RunningBalance <= AmountToDeduct THEN
                           AmountToDeduct:=RunningBalance;

                            LineN:=LineN+10000;
                            Gnljnline.INIT;
                            Gnljnline."Journal Template Name":='GENERAL';
                            Gnljnline."Journal Batch Name":=JournalBatchName;
                            Gnljnline."Line No.":=LineN;
                            Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                            Gnljnline."Account No.":=ObjRcptBuffer."Member No";
                            Gnljnline.VALIDATE(Gnljnline."Account No.");
                            Gnljnline."Document No.":="Document No";
                            Gnljnline."Posting Date":="Posting date";
                            Gnljnline.Description:='Share Capital';
                            Gnljnline.Amount:=AmountToDeduct*-1;
                            Gnljnline.VALIDATE(Gnljnline.Amount);
                            Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Shares Capital";
                            Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                            Gnljnline."Shortcut Dimension 2 Code":=ObjMember."Global Dimension 2 Code";
                            Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                            Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                            IF Gnljnline.Amount<>0 THEN
                            Gnljnline.INSERT;
                            RunningBalance:=RunningBalance-ABS(Gnljnline.Amount);
                        END;
                      END;
                  END;
              //UNTIL RcptBufLines.NEXT=0;
          END;

      EXIT(RunningBalance);
      END; }
    END;

    LOCAL PROCEDURE FnRunDepositContribution@1000000039(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
      ObjMember@1000000005 : Record 51516223;
      AmountToDeduct@1000000006 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN
        BEGIN
          ObjMember.RESET;
          ObjMember.SETRANGE(ObjMember."No.",ObjRcptBuffer."Member No");
          //ObjMember.SETRANGE(ObjMember."Employer Code",ObjRcptBuffer."Employer Code");
          ObjMember.SETRANGE(ObjMember."Customer Type",ObjMember."Customer Type"::Member);
          IF ObjMember.FIND('-') THEN
             BEGIN
                AmountToDeduct:=0;
                AmountToDeduct:=ObjRcptBuffer.Amount;
                IF RunningBalance <= AmountToDeduct THEN
                AmountToDeduct:=RunningBalance;

                LineN:=LineN+10000;
                Gnljnline.INIT;
                Gnljnline."Journal Template Name":='GENERAL';
                Gnljnline."Journal Batch Name":=JournalBatchName;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                Gnljnline."Account No.":=ObjRcptBuffer."Member No";
                Gnljnline.VALIDATE(Gnljnline."Account No.");
                Gnljnline."Document No.":="Document No";
                Gnljnline."Posting Date":="Posting date";
                Gnljnline.Amount:=AmountToDeduct*-1;
                Gnljnline.VALIDATE(Gnljnline.Amount);
                IF ObjRcptBuffer."Transaction Type"=ObjRcptBuffer."Transaction Type"::Deposits THEN BEGIN
                Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
                 Gnljnline.Description:='Deposit Contribution';
                END ELSE IF  ObjRcptBuffer."Transaction Type"=ObjRcptBuffer."Transaction Type"::ESS THEN BEGIN
                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"SchFee Shares";
                   Gnljnline.Description:='School Fees Deposits';
                END;

                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                Gnljnline."Shortcut Dimension 2 Code":=ObjMember."Global Dimension 2 Code";
                Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                IF Gnljnline.Amount<>0 THEN
                Gnljnline.INSERT;
                RunningBalance:=RunningBalance-ABS(Gnljnline.Amount*-1);
          END;

      EXIT(RunningBalance);
      END;
      }
    END;

    LOCAL PROCEDURE FnRunXmasContribution@1000000047(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
      ObjMember@1000000005 : Record 51516223;
      AmountToDeduct@1000000006 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN
        BEGIN
              AmountToDeduct:=0;
              AmountToDeduct:=ROUND(ObjRcptBuffer."Xmas Contribution",0.05,'>');;
              IF RunningBalance <=AmountToDeduct THEN
              AmountToDeduct:=RunningBalance;

              LineN:=LineN+10000;

              Gnljnline.INIT;
              Gnljnline."Journal Template Name":='GENERAL';
              Gnljnline."Journal Batch Name":=JournalBatchName;
              Gnljnline."Line No.":=LineN;
              Gnljnline."Account Type":=Gnljnline."Account Type"::Vendor;
              Gnljnline."Account No.":=RcptBufLines."Xmas Account";
              Gnljnline.VALIDATE(Gnljnline."Account No.");
              Gnljnline."Document No.":="Document No";
              Gnljnline."Posting Date":="Posting date";
              Gnljnline.Description:='Xmas Contribution';
              Gnljnline.Amount:=AmountToDeduct*-1;
              Gnljnline.VALIDATE(Gnljnline.Amount);
              Gnljnline."Shortcut Dimension 1 Code":='BOSA';
              Gnljnline."Shortcut Dimension 2 Code":=FnGetMemberBranch(ObjRcptBuffer."Member No");
              Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
              Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
              IF Gnljnline.Amount<>0 THEN
              Gnljnline.INSERT;
              RunningBalance:=RunningBalance-ABS(Gnljnline.Amount);
      EXIT(RunningBalance);
      END; }
    END;

    LOCAL PROCEDURE FnRecoverPrincipleFromExcess@1000000061(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
      ObjTempLoans@1000000005 : Record 51516891;
      AmountToDeduct@1000000006 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN BEGIN
      varTotalRepay:=0;
      varMultipleLoan:=0;

      ObjTempLoans.RESET;
      ObjTempLoans.SETRANGE(ObjTempLoans."Member No",ObjRcptBuffer."Member No");
      IF ObjTempLoans.FIND('-') THEN BEGIN
        REPEAT
          IF  RunningBalance > 0 THEN
            BEGIN
              IF ObjTempLoans."Outstanding Balance" > 0 THEN
                BEGIN
                      AmountToDeduct:=RunningBalance;
                      IF AmountToDeduct >=ObjTempLoans."Outstanding Balance" THEN
                      AmountToDeduct:=ObjTempLoans."Outstanding Balance";
                      LineN:=LineN+10000;
                      Gnljnline.INIT;
                      Gnljnline."Journal Template Name":='GENERAL';
                      Gnljnline."Journal Batch Name":=JournalBatchName;
                      Gnljnline."Line No.":=LineN;
                      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                      Gnljnline."Account No.":=LoanApp."Client Code";
                      Gnljnline.VALIDATE(Gnljnline."Account No.");
                      Gnljnline."Document No.":="Document No";
                      Gnljnline."Posting Date":="Posting date";
                      Gnljnline.Description:=LoanApp."Loan Product Type"+'-Repayment Excess from checkoff'; //TODO Change the Narrative after testing
                      Gnljnline.Amount:=AmountToDeduct*-1;
                      Gnljnline.VALIDATE(Gnljnline.Amount);
                      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Repayment;
                      Gnljnline."Loan No":=LoanApp."Loan  No.";
                      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                      Gnljnline."Shortcut Dimension 2 Code":=FnGetMemberBranch(ObjTempLoans."Member No");
                      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                      IF Gnljnline.Amount<>0 THEN
                      Gnljnline.INSERT;
                      RunningBalance:=RunningBalance-ABS(Gnljnline.Amount);
                    END;
               END;
          UNTIL  ObjTempLoans.NEXT = 0;
      END;
      EXIT(RunningBalance);
      END;
      }
    END;

    LOCAL PROCEDURE FnSaveTempLoanAmount@1000000000(ObjLoansRegister@1000000000 : Record 51516230;TempBalance@1000000002 : Decimal);
    VAR
      ObjTempLoans@1000000001 : Record 51516891;
    BEGIN
      ObjTempLoans.RESET;
      ObjTempLoans.SETRANGE(ObjTempLoans."Member No",ObjLoansRegister."Client Code");
      ObjTempLoans.SETRANGE(ObjTempLoans."Loan No",ObjLoansRegister."Loan  No.");
      IF ObjTempLoans.FIND('-') THEN
        ObjTempLoans.DELETEALL;

      ObjTempLoans.INIT;
      ObjTempLoans."Member No":=ObjLoansRegister."Client Code";
      ObjTempLoans."Loan No":=ObjLoansRegister."Loan  No.";
      ObjTempLoans."Outstanding Balance":=TempBalance;
      ObjTempLoans.INSERT;
    END;

    LOCAL PROCEDURE FnGetMemberBranch@1000000015(MemberNo@1000000000 : Code[50]) : Code[100];
    VAR
      MemberBranch@1000000001 : Code[100];
    BEGIN
      {Cust.RESET;
      Cust.SETRANGE(Cust."No.",MemberNo);
      IF Cust.FIND('-') THEN BEGIN
        MemberBranch:=Cust."Global Dimension 2 Code";
        END;
      EXIT(MemberBranch);}
    END;

    LOCAL PROCEDURE FnTransferExcessToUnallocatedFunds@1000000007(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal);
    VAR
      varTotalRepay@1000000002 : Decimal;
      varMultipleLoan@1000000003 : Decimal;
      varLRepayment@1000000004 : Decimal;
      ObjMember@1000000005 : Record 51516223;
      AmountToDeduct@1000000006 : Decimal;
      AmountToTransfer@1000000007 : Decimal;
    BEGIN
      {IF RunningBalance > 0 THEN
        BEGIN
          ObjMember.RESET;
          ObjMember.SETRANGE(ObjMember."No.",ObjRcptBuffer."Member No");
          //ObjMember.SETRANGE(ObjMember."Employer Code",ObjRcptBuffer."Employer Code");
          ObjMember.SETRANGE(ObjMember."Customer Type",ObjMember."Customer Type"::Member);
          IF ObjMember.FIND('-') THEN
             BEGIN
                AmountToTransfer:=0;
                AmountToTransfer:=RunningBalance;

                LineN:=LineN+10000;
                Gnljnline.INIT;
                Gnljnline."Journal Template Name":='GENERAL';
                Gnljnline."Journal Batch Name":=JournalBatchName;
                Gnljnline."Line No.":=LineN;
                Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                Gnljnline."Account No.":=ObjRcptBuffer."Member No";
                Gnljnline.VALIDATE(Gnljnline."Account No.");
                Gnljnline."Document No.":="Document No";
                Gnljnline."Posting Date":="Posting date";
                Gnljnline.Description:='Excess Deposits';
                Gnljnline.Amount:=AmountToTransfer*-1;
                Gnljnline.VALIDATE(Gnljnline.Amount);
                Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
                Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                Gnljnline."Shortcut Dimension 2 Code":=ObjMember."Global Dimension 2 Code";
                Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
                Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
                IF Gnljnline.Amount<>0 THEN
                Gnljnline.INSERT;
          END;
      END; }
    END;

    LOCAL PROCEDURE FnRecoverWelfare@1000000041(ObjRcptBuffer@1000000000 : Record 51516249;RunningBalance@1000000001 : Decimal) NewRunningBalance : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjVendor@1000000003 : Record 23;
    BEGIN
      {ObjVendor.RESET;
      ObjVendor.SETRANGE(ObjVendor."BOSA Account No",ObjRcptBuffer."Member No");
      ObjVendor.SETRANGE(ObjVendor."Company Code",'MMHSACCO');
      ObjVendor.SETRANGE(ObjVendor."Account Type",'ORDINARY');
      IF ObjVendor.FIND('-') THEN BEGIN
      IF RunningBalance > 0 THEN
        BEGIN
          AmountToDeduct:=RunningBalance;
          IF RunningBalance >=200 THEN
          AmountToDeduct:=200;
          TotalWelfareAmount:=TotalWelfareAmount+AmountToDeduct;
          RunningBalance:=RunningBalance-ABS(Gnljnline.Amount);
      EXIT(RunningBalance);
      END;
      END;}
      {IF RunningBalance > 0 THEN BEGIN
       IF "Employer Code"='MMHSACCO' THEN BEGIN
          AmountToDeduct:=RunningBalance;
          IF RunningBalance >=200 THEN
          AmountToDeduct:=200;
          TotalWelfareAmount:=TotalWelfareAmount+AmountToDeduct;
          //MESSAGE('EMPLLOYER CODE IS %1',RcptBufLines."Employer Code");
           // MESSAGE('staff name is %1',AmountToDeduct);
          RunningBalance:=RunningBalance-ABS(AmountToDeduct);
          END;
      EXIT(RunningBalance);
      END;}
    END;

    PROCEDURE FnGetLoanArrears@1120054002(LoanNumber@1120054003 : Code[50]);
    VAR
      LoansRe@1120054002 : Record 51516230;
      Lschedule@1120054001 : Record 51516234;
      ExpectedAmount@1120054004 : Decimal;
      PaidAmount@1120054005 : Decimal;
    BEGIN
      ExpectedAmount:=0;
      Lschedule.RESET;
      Lschedule.SETRANGE(Lschedule."Loan No.",LoanNumber);
      Lschedule.SETFILTER(Lschedule."Repayment Date",'<=%1',"Posting date");
      IF Lschedule.FINDSET THEN
      BEGIN
      Lschedule.CALCSUMS(Lschedule."Principal Repayment");
      ExpectedAmount:=Lschedule."Principal Repayment";
      END;

      PaidAmount:=0;
      LoansRe.RESET;
      LoansRe.SETRANGE(LoansRe."Loan  No.",LoanNumber);
      IF LoansRe.FINDFIRST THEN BEGIN
      LoansRe.CALCFIELDS(LoansRe."Outstanding Balance");
      PaidAmount:=LoansRe."Approved Amount"-LoansRe."Outstanding Balance";
      END;

      Arrear:=0;
      Arrear:=ExpectedAmount-PaidAmount;
      IF Arrear>0 THEN
      Arrear:=Arrear
      ELSE
      Arrear:=0;
      //MESSAGE('LoansR%1Expected%2PaidAmount%3Arrears%4',LoanNumber,ExpectedAmount,PaidAmount,Arrear);
    END;

    BEGIN
    {
      IF Posted=TRUE THEN
      ERROR('This Check Off has already been posted');


      IF "Account No" = '' THEN
      ERROR('You must specify the Account No.');

      IF "Document No" = '' THEN
      ERROR('You must specify the Document No.');


      IF "Posting date" = 0D THEN
      ERROR('You must specify the Posting date.');

      IF Amount = 0 THEN
      ERROR('You must specify the Amount.');

      IF "Employer Code"='' THEN
      ERROR('You must specify Employer Code');


      PDate:="Posting date";
      DocNo:="Document No";


      "Scheduled Amount":= ROUND("Scheduled Amount");


      IF "Scheduled Amount"<>Amount THEN
      ERROR('The Amount must be equal to the Scheduled Amount');


      //delete journal line
      Gnljnline.RESET;
      Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
      Gnljnline.SETRANGE("Journal Batch Name",No);
      Gnljnline.DELETEALL;
      //end of deletion
      //delete journal line
      Gnljnline.RESET;
      Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
      Gnljnline.SETRANGE("Journal Batch Name",No);
      Gnljnline.INSERT;
      //end of deletion

      RunBal:=0;

      IF DocNo='' THEN
      ERROR('Kindly specify the document no.');

      ReceiptsProcessingLines.RESET;
      ReceiptsProcessingLines.SETRANGE(ReceiptsProcessingLines."Receipt Header No",No);
      ReceiptsProcessingLines.SETRANGE(ReceiptsProcessingLines.Posted,FALSE);
      IF ReceiptsProcessingLines.FIND('-') THEN BEGIN
      REPEAT


      ReceiptsProcessingLines.TESTFIELD(ReceiptsProcessingLines."Member No");
      ReceiptsProcessingLines.TESTFIELD(ReceiptsProcessingLines."Trans Type");
      {
      IF (ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sLoan) OR
      (ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInterest) OR
      (ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInsurance) THEN

      ReceiptsProcessingLines.TESTFIELD(ReceiptsProcessingLines."Loan No");
      }

      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInterest THEN BEGIN

          LineNo:=LineNo+500;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
          Gnljnline.VALIDATE(Gnljnline."Account No.");
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Interest Paid';
          Gnljnline.Amount:=ROUND(-1*ReceiptsProcessingLines.Amount);
          Gnljnline.VALIDATE(Gnljnline.Amount);
          Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;

          LineNo:=LineNo+1000;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
          //Gnljnline.VALIDATE(Gnljnline."Account No.");
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Interest Paid'+' '+ReceiptsProcessingLines."Loan No"+' '+ReceiptsProcessingLines."Staff/Payroll No";
          Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount);
          Gnljnline.VALIDATE(Gnljnline.Amount);
          //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;

          END;

      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sLoan THEN BEGIN

          LineNo:=LineNo+500;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
          Gnljnline.VALIDATE(Gnljnline."Account No.");
          //Gnljnline."Document No.":=DocNo;
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Loan Repayment';
          Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
          Gnljnline.VALIDATE(Gnljnline.Amount);
          Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Repayment;
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;



          LineNo:=LineNo+1000;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
          //Gnljnline.VALIDATE(Gnljnline."Account No.");
          //Gnljnline."Document No.":=DocNo;
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Loan Repayment'+' '+ReceiptsProcessingLines."Loan No";
          Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
         // Gnljnline.VALIDATE(Gnljnline.Amount);
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";

          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;

           END;

      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sDeposits THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
      Gnljnline.VALIDATE(Gnljnline."Account Type");
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      //Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Deposit Contribution';
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      //Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::Customer;
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account Type");
      //Gnljnline."Bal. Account No.":="ReceiptsProcessingLines"."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      Gnljnline.VALIDATE(Gnljnline."Account Type");
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Deposit Contribution'+ '-'+ReceiptsProcessingLines."Member No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      //Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::Customer;
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account Type");
      //Gnljnline."Bal. Account No.":="ReceiptsProcessingLines"."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;



      //Benevolent Fund
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sBenevolent THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Benevolent Fund';
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Benevolent Fund";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;


      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      //Gnljnline."Account Type":=Gnljnline."Account Type"::"G/L Account";
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Benevolent Fund'+ReceiptsProcessingLines."Member No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      //Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Benevolent Fund";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;

      //Loan Insurance
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInsurance THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Loan Insurance 0.02%'+' '+ReceiptsProcessingLines."Loan No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;


      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Loan Insurance 0.02%'+' '+ReceiptsProcessingLines."Loan No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;


      //Share Capital
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sShare THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      //Gnljnline."Posting Date":=ReceiptsProcessingLines."Transaction Date";
      Gnljnline.Description:='Shares Contribution';
      Gnljnline.Amount:=ReceiptsProcessingLines.Amount*-1;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Shares Capital";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Posting Date":=ReceiptsProcessingLines."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Shares Contribution'+' '+ReceiptsProcessingLines."Staff/Payroll No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;
       {
      //UAP
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::"9" THEN BEGIN

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline.Description:='UAP Premium';
      Gnljnline.Amount:=ReceiptsProcessingLines.Amount*-1;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"UAP Premiums";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;



      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInsurance THEN BEGIN

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Administration fee paid';
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Administration Fee Paid";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;
      }
      UNTIL ReceiptsProcessingLines.NEXT=0;
      END;
       {
      //Bank Entry

      //BOSA Bank Entry
      //IF ("Mode Of Disbursement"="Mode Of Disbursement"::Cheque) THEN BEGIN
      IF(LBatches."Mode Of Disbursement"=LBatches."Mode Of Disbursement"::Cheque) THEN BEGIN
           //("Mode Of Disbursement"="Mode Of Disbursement"::"Transfer to FOSA") THEN BEGIN
      LineNo:=LineNo+10000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":=Jtemplate;
      Gnljnline."Journal Batch Name":=JBatch;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Document No.":=DocNo;;
      Gnljnline."Posting Date":="Posting date";
      Gnljnline."External Document No.":=LBatches."Document No.";
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::"Bank Account";
      Gnljnline."Account No.":=LBatches."BOSA Bank Account";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline.Description:=ReceiptsProcessingLines.Name;
      Gnljnline.Amount:=ReceiptsProcessingLines.Amount*-1;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Shortcut Dimension 1 Code":=DActivityBOSA;
      Gnljnline."Shortcut Dimension 2 Code":=DBranchBOSA;
      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;
      }
      {
      LineN:=LineN+100;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Document No.":=DocNo;
      Gnljnline."External Document No.":=DocNo;
      Gnljnline."Line No.":=LineN;
      Gnljnline."Account Type":="Account Type";
      Gnljnline."Account No.":="Account No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Check Off transfer';
      Gnljnline.Amount:=Amount;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;
      }

      //Post New
      Gnljnline.RESET;
      Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
      Gnljnline.SETRANGE("Journal Batch Name",No);
      IF Gnljnline.FIND('-') THEN BEGIN
      //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post B",Gnljnline);
      END;

      //Post New
      Posted:=TRUE;
      "Posted By":= UPPERCASE(No);
      MODIFY;

      {
      "ReceiptsProcessingLines".RESET;
      "ReceiptsProcessingLines".SETRANGE("ReceiptsProcessingLines"."Receipt Header No",No);
       IF "ReceiptsProcessingLines".FIND('-') THEN BEGIN
       REPEAT
      "ReceiptsProcessingLines".Posted:=TRUE;
      "ReceiptsProcessingLines".MODIFY;
      UNTIL "ReceiptsProcessingLines".NEXT=0;
      END;
      MODIFY;
      }
    }
    END.
  }
}

