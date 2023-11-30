OBJECT page 17437 Cashier Transactions Card
{
  OBJECT-PROPERTIES
  {
    Date=08/10/23;
    Time=12:02:44 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516299;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnInit=BEGIN
             "Transaction DateEditable" := TRUE;
           END;

    OnOpenPage=BEGIN
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Transacting Branch",UsersID.Branch);
                 END;}


                 IF Posted = TRUE THEN
                 CurrPage.EDITABLE:=FALSE
               END;

    OnAfterGetRecord=BEGIN
                       {CalcAvailableBal;
                       CLEAR(AccP.Picture);
                       CLEAR(AccP.Signature);
                       IF AccP.GET("Account No") THEN BEGIN
                       AccP.CALCFIELDS(AccP.Picture);
                       AccP.CALCFIELDS(AccP.Signature);
                       END;
                        }
                       FChequeVisible :=FALSE;
                       BChequeVisible :=FALSE;
                       BReceiptVisible :=FALSE;
                       BOSAReceiptChequeVisible :=FALSE;

                       IF Type = 'Cheque Deposit' THEN BEGIN
                       FChequeVisible :=TRUE;
                       IF ("Account No" = '502-00-000300-00') OR ("Account No" = '502-00-000303-00') THEN
                       BOSAReceiptChequeVisible :=TRUE;

                       END;

                       "Branch RefferenceVisible" :=FALSE;
                       LRefVisible :=FALSE;


                       IF Type = 'Bankers Cheque' THEN
                       BChequeVisible :=TRUE;

                       IF Type = 'Encashment' THEN
                       BReceiptVisible :=TRUE;


                       IF "Transaction Type" = 'BOSA' THEN
                       BReceiptVisible :=TRUE;

                       IF "Branch Transaction" = TRUE THEN BEGIN
                       "Branch RefferenceVisible" :=TRUE;
                       LRefVisible :=TRUE;
                       END;

                       IF Acc.GET("Account No") THEN BEGIN
                       IF Acc."Account Category" = Acc."Account Category"::Project THEN BEGIN
                       "Branch RefferenceVisible" :=TRUE;
                       LRefVisible :=TRUE;
                       END;
                       END;


                       "Transaction DateEditable" := FALSE;
                       IF "Post Dated" = TRUE THEN
                       "Transaction DateEditable" := TRUE;
                     END;

    OnInsertRecord=BEGIN
                     CLEAR(Acc.Picture);
                     CLEAR(Acc.Signature);

                     "Needs Approval":="Needs Approval"::No;
                     FChequeVisible :=FALSE;
                   END;

    OnModifyRecord=BEGIN
                     IF xRec.Posted = TRUE THEN BEGIN
                     IF Posted = TRUE THEN
                     ERROR('You cannot modify an already posted record.');
                     END;
                   END;

    OnDeleteRecord=BEGIN
                     IF Posted = TRUE THEN
                     ERROR('You cannot delete an already posted record.');
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760070;1 ;ActionGroup;
                      CaptionML=ENU=Suggest }
      { 1102760071;2 ;Action    ;
                      CaptionML=ENU=Cash Clearance;
                      Visible=FALSE;
                      OnAction=BEGIN
                                 Cheque := FALSE;
                                 SuggestBOSAEntries();
                               END;
                                }
      { 1102760074;2 ;Separator  }
      { 1102760076;2 ;Action    ;
                      CaptionML=ENU=Cheque Clearance;
                      Visible=false;
                      Enabled=FALSE;
                      OnAction=BEGIN
                                 Cheque := TRUE;
                                 SuggestBOSAEntries();
                               END;
                                }
      { 1102760081;2 ;Separator  }
      { 1102760082;2 ;Action    ;
                      CaptionML=ENU=Monthy Repayments;
                      Visible=false;
                      Enabled=FALSE;
                      OnAction=BEGIN
                                 TESTFIELD(Posted,FALSE);
                                 TESTFIELD("BOSA Account No");

                                 ReceiptAllocations.RESET;
                                 ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No",No);
                                 ReceiptAllocations.DELETEALL;

                                 IF Cust.GET("BOSA Account No") THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Interest Due";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Cust."Insurance Contribution",0.01);
                                 ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;

                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::Loan;
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Cust."Monthly Contribution",0.01);
                                 ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;

                                 IF Cust."Investment Monthly Cont" > 0 THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Interest Paid";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Cust."Investment Monthly Cont",0.01);
                                 ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;
                                 END;



                                 Loans.RESET;
                                 Loans.SETCURRENTKEY(Loans.Source,Loans."Client Code");
                                 Loans.SETRANGE(Loans."Client Code","BOSA Account No");
                                 Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                 IF Loans.FIND('-') THEN BEGIN
                                 REPEAT
                                 Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due");

                                 IF (Loans."Outstanding Balance") > 0 THEN BEGIN
                                 LOustanding:=0;


                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Registration Fee";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Loans."Loan Principle Repayment",0.01);
                                 ReceiptAllocations."Interest Amount":=ROUND(Loans."Loan Interest Repayment",0.01);
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;


                                 END;
                                 UNTIL Loans.NEXT = 0;
                                 END;
                                 END;
                               END;
                                }
      { 1102760115;1 ;ActionGroup;
                      CaptionML=ENU=Suggest }
      { 1102760116;2 ;Action    ;
                      CaptionML=ENU=Cash Clearance;
                      Visible=false;
                      OnAction=BEGIN
                                 Cheque := FALSE;
                                 SuggestBOSAEntries();
                               END;
                                }
      { 1102760117;2 ;Separator  }
      { 1102760118;2 ;Action    ;
                      CaptionML=ENU=Cheque Clearance;
                      Visible=false;
                      OnAction=BEGIN
                                 Cheque := TRUE;
                                 SuggestBOSAEntries();
                               END;
                                }
      { 1102760119;2 ;Separator  }
      { 1102760120;2 ;Action    ;
                      CaptionML=ENU=Monthy Repayments;
                      Visible=false;
                      OnAction=BEGIN
                                 TESTFIELD(Posted,FALSE);
                                 TESTFIELD("BOSA Account No");

                                 ReceiptAllocations.RESET;
                                 ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No",No);
                                 ReceiptAllocations.DELETEALL;

                                 IF Cust.GET("BOSA Account No") THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Interest Due";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Cust."Insurance Contribution",0.01);
                                 ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;

                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::Loan;
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Cust."Monthly Contribution",0.01);
                                 ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;

                                 IF Cust."Investment Monthly Cont" > 0 THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Interest Paid";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Cust."Investment Monthly Cont",0.01);
                                 ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;
                                 END;



                                 Loans.RESET;
                                 Loans.SETCURRENTKEY(Loans.Source,Loans."Client Code");
                                 Loans.SETRANGE(Loans."Client Code","BOSA Account No");
                                 Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                 IF Loans.FIND('-') THEN BEGIN
                                 REPEAT
                                 Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due");

                                 IF (Loans."Outstanding Balance") > 0 THEN BEGIN
                                 LOustanding:=0;


                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":=No;
                                 ReceiptAllocations."Member No":="BOSA Account No";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Registration Fee";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=ROUND(Loans."Loan Principle Repayment",0.01);
                                 ReceiptAllocations."Interest Amount":=ROUND(Loans."Loan Interest Repayment",0.01);
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations.INSERT;


                                 END;
                                 UNTIL Loans.NEXT = 0;
                                 END;
                                 END;
                               END;
                                }
      { 1102760029;1 ;ActionGroup;
                      CaptionML=ENU=Transaction }
      { 1102760030;2 ;Action    ;
                      CaptionML=ENU=Account Card;
                      RunObject=page 17434;
                      RunPageLink=No.=FIELD(Account No);
                      Promoted=Yes;
                      Image=Vendor }
      { 1102760031;2 ;Separator  }
      { 1120054004;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 Approvalmgt@1102755001 : Codeunit 439;
                               BEGIN

                                 IF "Cheque No"<>'' THEN BEGIN
                                   Trans.RESET;
                                   Trans.SETRANGE(Trans."Cheque No","Cheque No");
                                   Trans.SETRANGE(Trans."Transaction Mode",Trans."Transaction Mode"::Cheque);
                                   IF Trans.FIND('-') THEN BEGIN
                                     IF (Trans."Cheque No"<>"Cheque No") AND (Trans."Transaction Mode"=Trans."Transaction Mode"::Cheque)THEN
                                       ERROR('CHEQUE NO IS USED');
                                     END;
                                   END;
                                   IF ("Transaction Mode"="Transaction Mode"::Cheque) THEN BEGIN
                                     TESTFIELD("Cheque No");
                                     END;
                                 IF Status<>Status::Pending THEN
                                   ERROR(Text001);
                                 DocType:=DocType::"Payment Voucher";
                                 //Table_id:=DATABASE::c;
                                 //IF ApprovalsMgmt.CheckChangeRequestApprovalsWorkflowEnabled(Rec)THEN
                                  // Approvalmgt.OnSendPettyCashForApproval(Rec);
                                 Status:=Status::Honoured;
                                 MODIFY;
                                 MESSAGE('Honoured Successfully');
                               END;
                                }
      { 1102760078;2 ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=ENU=Post;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {IF UsersID.GET(USERID) THEN BEGIN
                                 UsersID.TESTFIELD(UsersID.Branch);
                                 DActivity:='FOSA';
                                 DBranch:=UsersID.Branch;
                                 END;}

                                 IF "Transaction Date" <> TODAY THEN BEGIN
                                 "Transaction Date":=TODAY;
                                 MODIFY;
                                 END;



                                 IF Posted=TRUE THEN
                                 ERROR('The transaction has already been posted.');

                                 VarAmtHolder:=0;

                                 IF Amount <= 0 THEN
                                 ERROR('Please specify an amount greater than zero.');

                                 IF "Transaction Type"='' THEN
                                 ERROR('Please select the transaction type.');

                                 //BOSA Entries
                                 IF ("Account No" = '502-00-000300-00') OR ("Account No" = '502-00-000303-00') THEN BEGIN
                                 TESTFIELD("BOSA Account No");
                                 IF Amount <> "Allocated Amount" THEN
                                 ERROR('Allocated amount must be equall to the transaction amount.');

                                 END;


                                 IF "Branch Transaction" = TRUE THEN BEGIN
                                 IF "Branch Refference" = '' THEN
                                 ERROR('You must specify the refference details for branch transactions.');
                                 END;

                                 //Project Accounts
                                 IF Acc.GET("Account No") THEN BEGIN
                                 IF Acc."Account Category" = Acc."Account Category"::Project THEN BEGIN
                                 IF "Branch Refference" = '' THEN
                                 ERROR('You must specify the refference details for Project transactions.');
                                 END;
                                 END;
                                 //Project Accounts


                                 "Post Attempted":=TRUE;
                                 MODIFY;

                                 IF Type = 'Cheque Deposit' THEN BEGIN
                                 TESTFIELD("Cheque Type");
                                 TESTFIELD("Cheque No");
                                 TESTFIELD("Cheque Date");

                                 PostChequeDep;

                                 EXIT;
                                 END;

                                 IF Type = 'Bankers Cheque' THEN BEGIN

                                 PostBankersCheq;

                                 EXIT;
                                 END;

                                 IF Type = 'Encashment' THEN BEGIN
                                 PostEncashment;

                                 EXIT;
                                 END;

                                 //NON CUST
                                 {
                                 IF "Account No" = '507-10000-00' THEN BEGIN
                                 PostEncashment;

                                 EXIT;

                                 END;
                                 }
                                 //NON CUST

                                 //ADDED
                                 PostCashDepWith;


                                 EXIT;
                                 //ADDED
                               END;
                                }
      { 1102760079;2 ;Separator  }
      { 1102760080;2 ;Action    ;
                      CaptionML=ENU=Stop Cheque;
                      Promoted=Yes;
                      Image=Stop;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to stop the cheque?',FALSE) = TRUE THEN BEGIN
                                 Status:=Status::Stopped;
                                 "Cheque Processed":=TRUE;
                                 MODIFY;
                                 END;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760026;1 ;Action    ;
                      Name=Post;
                      ShortCutKey=F11;
                      CaptionML=ENU=Post (F11);
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF NOT CONFIRM('Are you sure you want to post this transansaction?',FALSE) THEN
                                    EXIT;
                                 TESTFIELD("Transaction Description");

                                 IF "ID No"='' THEN
                                 ERROR('Please fill Member ID No.');

                                 IF Cashier <> UPPERCASE(USERID) THEN
                                 //ERROR('Cannot post a Transaction being processed by %1',Cashier);

                                 BankLedger.RESET;
                                 BankLedger.SETRANGE(BankLedger."Posting Date",TODAY);
                                 BankLedger.SETRANGE(BankLedger."User ID","Posted By");
                                 BankLedger.SETRANGE(BankLedger.Description,'END OF DAY RETURN TO TREASURY');
                                 IF BankLedger.FIND('-')=TRUE THEN BEGIN
                                 ERROR('You cannot post any transactions after perfoming end of day');
                                 END;




                                 UsersID.RESET;
                                 UsersID.SETRANGE(UsersID."User Name",UPPERCASE(USERID));
                                 IF UsersID.FIND('-') THEN BEGIN
                                 DBranch:=UsersID.Branch;
                                 DActivity:='FOSA';
                                 //MESSAGE('%1,%2',Branch,Activity);
                                 END;


                                 IF "Transaction Date" <> TODAY THEN BEGIN
                                 "Transaction Date":=TODAY;
                                 MODIFY;
                                 END;



                                 IF Posted=TRUE THEN
                                 ERROR('The transaction has already been posted.');

                                 VarAmtHolder:=0;

                                 IF Amount <= 0 THEN
                                 ERROR('Please specify an amount greater than zero.');

                                 IF "Transaction Type"='' THEN
                                 ERROR('Please select the transaction type.');

                                 //BOSA Entries
                                 IF ("Account No" = '502-00-000300-00') OR ("Account No" = '502-00-000303-00') THEN BEGIN
                                 TESTFIELD("BOSA Account No");
                                 IF Amount <> "Allocated Amount" THEN
                                 ERROR('Allocated amount must be equal to the transaction amount.');

                                 END;


                                 IF "Branch Transaction" = TRUE THEN BEGIN
                                 IF "Branch Refference" = '' THEN
                                 ERROR('You must specify the refference details for branch transactions.');
                                 END;

                                 //Project Accounts
                                 IF Acc.GET("Account No") THEN BEGIN
                                 IF Acc."Account Category" = Acc."Account Category"::Project THEN BEGIN
                                 IF "Branch Refference" = '' THEN
                                 ERROR('You must specify the refference details for Project transactions.');
                                 END;
                                 END;
                                 //Project Accounts


                                 "Post Attempted":=TRUE;
                                 MODIFY;

                                 IF Type = 'Cheque Deposit' THEN BEGIN
                                 TESTFIELD("Cheque Type");
                                 TESTFIELD("Cheque No");
                                 TESTFIELD("Cheque Date");
                                 TESTFIELD("Bank Code");
                                 TESTFIELD("Customer Bank");
                                 TESTFIELD("Drawer Name");
                                 TESTFIELD("Bank Branch");

                                 PostChequeDep;

                                 EXIT;
                                 END;

                                 IF Type = 'Bankers Cheque' THEN BEGIN

                                 PostBankersCheq;

                                 EXIT;
                                 END;
                                 IF Type='BOSA Receipt' THEN BEGIN
                                   PostBOSAEntries;
                                   EXIT;
                                   END;

                                 IF Type = 'Encashment' THEN BEGIN
                                 PostEncashment;

                                 EXIT;
                                 END;

                                 IF Type='M-pesa' THEN BEGIN
                                  // MESSAGE('am here');
                                   PostMpesaEntries;
                                   EXIT;
                                   END;
                                 //NON CUST
                                 {
                                 IF "Account No" = '507-10000-00' THEN BEGIN
                                 PostEncashment;

                                 EXIT;

                                 END;
                                 }
                                 //NON CUST

                                 //ADDED
                                 PostCashDepWith;


                                 EXIT;
                                 //END;
                                 //ADDED
                               END;
                                }
      { 1102760033;1 ;Action    ;
                      Name=Reprint Slip;
                      CaptionML=ENU=Reprint Slip;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD(Posted);

                                 Trans.RESET;
                                 Trans.SETRANGE(Trans.No,No);
                                 IF Trans.FIND('-') THEN BEGIN
                                 IF (Type = 'Cash Deposit')  THEN
                                 REPORT.RUN(51516281,TRUE,TRUE,Trans)
                                 ELSE IF Type='Withdrawal' THEN
                                  REPORT.RUN(51516282,TRUE,TRUE,Trans)
                                 ELSE IF Type='encashment' THEN

                                 REPORT.RUN(51516281,TRUE,TRUE,Trans)
                                 ELSE
                                 IF Type = 'Cheque Deposit' THEN
                                 REPORT.RUN(51516433,TRUE,TRUE,Trans)
                                 ELSE
                                 IF (Type = 'M-pesa')  THEN
                                 REPORT.RUN(51516282,TRUE,TRUE,Trans)
                                 END;
                               END;
                                }
      { 1000000000;1 ;Action    ;
                      Name=Post1;
                      CaptionML=ENU=CC;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {IF UsersID.GET(USERID) THEN BEGIN
                                 UsersID.TESTFIELD(UsersID.Branch);
                                 DActivity:='FOSA';
                                 DBranch:=UsersID.Branch;
                                 END;   }


                                 //IF Posted=TRUE THEN
                                 //ERROR('The transaction has already been posted.');

                                 VarAmtHolder:=0;

                                 IF Amount <= 0 THEN
                                 ERROR('Please specify an amount greater than zero.');

                                 IF "Transaction Type"='' THEN
                                 ERROR('Please select the transaction type.');

                                 //BOSA Entries
                                 IF ("Account No" = '502-00-000300-00') OR ("Account No" = '502-00-000303-00') THEN BEGIN
                                 TESTFIELD("BOSA Account No");
                                 IF Amount <> "Allocated Amount" THEN
                                 ERROR('Allocated amount must be equall to the transaction amount.');

                                 END;


                                 IF "Branch Transaction" = TRUE THEN BEGIN
                                 IF "Branch Refference" = '' THEN
                                 ERROR('You must specify the refference detailes for branch transactions.');
                                 END;

                                 "Post Attempted":=TRUE;
                                 MODIFY;

                                 IF Type = 'Cheque Deposit' THEN BEGIN
                                 TESTFIELD("Cheque Type");
                                 TESTFIELD("Cheque No");
                                 TESTFIELD("Cheque Date");

                                 PostChequeDep;

                                 EXIT;
                                 END;

                                 IF Type = 'Bankers Cheque' THEN BEGIN

                                 PostBankersCheq;

                                 EXIT;
                                 END;

                                 IF Type = 'Encashment' THEN BEGIN
                                 PostEncashment;

                                 EXIT;
                                 END;

                                 //ADDED
                                 PostCashDepWith;


                                 EXIT;
                                 //ADDED
                               END;
                                }
      { 1102760083;1 ;Action    ;
                      CaptionML=ENU=SendMail;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MailContent:='Bankers cheque transaction' + ' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
                                 +' ' +"Account Name"+' '+'needs your approval';


                                    SendEmail;
                               END;
                                }
      { 1000000009;1 ;Action    ;
                      Name=Print Cheque;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                CaptionML=ENU=Transactions }

    { 1102760001;2;Field  ;
                SourceExpr=No;
                Editable=false }

    { 1102760003;2;Field  ;
                SourceExpr="Account No";
                OnValidate=BEGIN
                             IF Posted = TRUE THEN
                             ERROR('You cannot modify an already posted record.');

                             CalcAvailableBal;

                             CLEAR(AccP.Picture);
                             CLEAR(AccP.Signature);
                             IF AccP.GET("Account No") THEN BEGIN
                             {//Hide Accounts
                             IF AccP.Hide = TRUE THEN BEGIN
                             IF UsersID.GET(USERID) THEN BEGIN
                             IF UsersID."Show Hiden" = FALSE THEN
                             ERROR('You do not have permission to transact on this account.');
                             END;
                             END; }
                             //Hide Accounts
                             AccP.CALCFIELDS(AccP.Picture,AccP.Signature);
                             END;

                             CALCFIELDS("Uncleared Cheques");
                             IF AccP.GET("Account No") THEN BEGIN
                             AccP.CALCFIELDS(AccP.Picture,AccP.Signature);
                             Picture:=AccP.Picture;
                             Signature:=Acc.Signature;
                             MODIFY;


                             END;
                           END;
                            }

    { 1102760007;2;Field  ;
                SourceExpr="Transaction Type";
                OnValidate=BEGIN
                             IF Posted = TRUE THEN
                             ERROR('You cannot modify an already posted record.');

                             FChequeVisible :=FALSE;
                             BChequeVisible :=FALSE;
                             BReceiptVisible :=FALSE;
                             BOSAReceiptChequeVisible :=FALSE;
                             "Branch RefferenceVisible" :=FALSE;
                             LRefVisible :=FALSE;


                             IF TransactionTypes.GET("Transaction Type") THEN BEGIN
                             IF TransactionTypes.Type = TransactionTypes.Type::"Cheque Deposit" THEN BEGIN
                             FChequeVisible :=TRUE;
                             IF ("Account No" = '502-00-000300-00') OR ("Account No" = '502-00-000303-00') THEN
                             BOSAReceiptChequeVisible :=TRUE;
                             END;
                             IF TransactionTypes.Type = TransactionTypes.Type::"Bankers Cheque" THEN
                             BChequeVisible :=TRUE;

                             IF "Transaction Type" = 'BOSA' THEN
                             BReceiptVisible :=TRUE;

                             IF TransactionTypes.Type = TransactionTypes.Type::Encashment THEN
                             BReceiptVisible :=TRUE;



                             END;

                             IF TransactionTypes.GET("Transaction Type") THEN BEGIN
                             IF TransactionTypes.Type = TransactionTypes.Type::"M-pesa" THEN BEGIN
                             FChequeVisible :=TRUE;
                               END;
                               END;
                             IF "Branch Transaction" = TRUE THEN BEGIN
                             "Branch RefferenceVisible" :=TRUE;
                             LRefVisible :=TRUE;
                             END;

                             IF Acc.GET("Account No") THEN BEGIN
                             IF Acc."Account Category" = Acc."Account Category"::Project THEN BEGIN
                             "Branch RefferenceVisible" :=TRUE;
                             LRefVisible :=TRUE;
                             END;
                             END;



                             CalcAvailableBal;
                           END;
                            }

    { 1120054000;2;Field  ;
                SourceExpr=ChargeTransfer;
                OnValidate=BEGIN
                              //ChargeTransfer:=FALSE;
                             Trans.RESET;
                             Trans.SETRANGE(Trans.No,No);
                             IF Trans.FIND('-') THEN

                               IF ChargeTransfer=TRUE THEN BEGIN
                               Trans.ChargeTransfer:=TRUE;
                               Trans.MODIFY;
                              END;
                               IF ChargeTransfer=FALSE THEN BEGIN
                               Trans.ChargeTransfer:=FALSE;
                               //Trans.MODIFY;
                              //Trans.MODIFY;
                              END;
                           END;
                            }

    { 1000000006;2;Field  ;
                SourceExpr="Account Type";
                Editable=FALSE }

    { 1102760009;2;Field  ;
                SourceExpr=Amount;
                OnValidate=BEGIN
                             ChargeAmount:=0;
                             IF Type = 'Withdrawal' THEN BEGIN
                             //IF ChargeTransfer=TRUE THEN



                             Charges.RESET;
                             Charges.SETRANGE(Charges.Description,'Cash Withdrawal Charges');
                             IF Charges.FIND('-') THEN BEGIN
                             IF (Amount>=100)  AND (Amount<=5000) THEN
                             ChargeAmount:=Charges."Between 100 and 5000";
                              IF  (Amount>=5001) AND (Amount<=10000) THEN
                             ChargeAmount:=Charges."Between 5001 - 10000";

                             IF (Amount>=10001) AND (Amount<=30000) THEN
                               ChargeAmount:=Charges."Between 10001 - 30000";

                             IF (Amount>=30001) AND (Amount<=50000) THEN
                             ChargeAmount:=Charges."Between 30001 - 50000";

                              IF (Amount>=50001) AND (Amount<=100000) THEN
                             ChargeAmount:=Charges."Between 50001 - 100000";

                              IF (Amount>=100001) AND (Amount<=200000) THEN
                                ChargeAmount:=Charges."Between 100001 - 200000";

                             IF (Amount>=200001) AND (Amount<=500000) THEN
                              ChargeAmount:=Charges."Between 200001 - 500000";

                             IF (Amount>=500001) AND (Amount<=100000000.0) THEN
                               ChargeAmount:=Charges."Between 500001 Above";
                             END;
                             END;
                             CalcAvailableBal();



                             FOSAAccount.GET("Account No");
                             FOSAAccount.CALCFIELDS(FOSAAccount."Authorised Over Draft");
                             IF Type='Withdrawal' THEN BEGIN
                             IF "Book Balance"<0 THEN BEGIN
                             BAmount:="Book Balance"*-1;
                             //IF Amount>BAmount+FOSAAccount."Authorised Over Draft" THEN
                             //ERROR('Amount exceeds the book balance.');
                             END;
                             END;


                             //BandAmount:=ChargeAmount;



                           END;
                            }

    { 1120054002;2;Field  ;
                SourceExpr="Reference No" }

    { 1102755002;2;Field  ;
                Name=Description;
                SourceExpr=Description }

    { 1102760034;2;Group  ;
                Name=BCheque;
                CaptionML=ENU=.;
                Visible=BChequeVisible }

    { 1102760043;3;Field  ;
                SourceExpr="Bankers Cheque No" }

    { 1000000007;3;Field  ;
                SourceExpr="Bank Code" }

    { 1102760041;3;Field  ;
                SourceExpr=Payee }

    { 1102760037;3;Field  ;
                SourceExpr="Post Dated";
                OnValidate=BEGIN
                             "Transaction DateEditable" := FALSE;
                             IF "Post Dated" = TRUE THEN
                             "Transaction DateEditable" := TRUE
                             ELSE
                             "Transaction Date":=TODAY;
                           END;
                            }

    { 1102760036;2;Group  ;
                Name=BReceipt;
                CaptionML=ENU=.;
                Visible=BReceiptVisible }

    { 1102760064;3;Field  ;
                SourceExpr="BOSA Account No" }

    { 1102760066;3;Field  ;
                SourceExpr="Allocated Amount" }

    { 1102760035;2;Group  ;
                Name=FCheque;
                CaptionML=ENU=.;
                Visible=FChequeVisible }

    { 1102760045;3;Field  ;
                SourceExpr="Cheque Type" }

    { 1102760047;3;Field  ;
                SourceExpr="Cheque No";
                OnValidate=BEGIN
                              IF STRLEN("Cheque No") <> 6 THEN
                               ERROR('Cheque No. cannot contain More or less than 6 Characters.');
                           END;
                            }

    { 1120054006;3;Field  ;
                SourceExpr="Customer Bank" }

    { 1120054007;3;Field  ;
                SourceExpr="Bank Branch" }

    { 1120054008;3;Field  ;
                SourceExpr="Drawer Name" }

    { 1102760060;3;Field  ;
                Name=bank;
                CaptionML=ENU=Bank;
                SourceExpr="Bank Code" }

    { 1000000008;3;Field  ;
                SourceExpr="Bank Name" }

    { 1102760054;3;Field  ;
                SourceExpr="Expected Maturity Date" }

    { 1102760056;3;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102760058;3;Field  ;
                Name=50048;
                CaptionML=ENU=Banked;
                SourceExpr="Banking Posted";
                Editable=FALSE }

    { 1000000003;3;Field  ;
                SourceExpr="Bank Account";
                Visible=FALSE }

    { 1000000001;3;Field  ;
                SourceExpr="Cheque Date" }

    { 1102755004;3;Field  ;
                SourceExpr="Cheque Deposit Remarks" }

    { 1102760108;3;Group  ;
                Name=BOSAReceiptCheque;
                CaptionML=ENU=.;
                Visible=BOSAReceiptChequeVisible }

    { 1102760005;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1102760024;2;Field  ;
                SourceExpr="Transaction Description";
                Editable=true }

    { 1102760069;2;Field  ;
                CaptionML=ENU=REF;
                SourceExpr="Branch Refference";
                Visible="Branch RefferenceVisible" }

    { 1102760019;2;Field  ;
                SourceExpr="Book Balance" }

    { 1102760072;2;Field  ;
                SourceExpr="Uncleared Cheques" }

    { 1102760022;2;Field  ;
                CaptionML=ENU=Available Balance;
                SourceExpr=AvailableBalance;
                Editable=FALSE }

    { 1120054005;2;Field  ;
                SourceExpr="Amount Plus Charges" }

    { 1000000002;2;Field  ;
                SourceExpr="N.A.H Balance";
                Editable=FALSE }

    { 1102760051;2;Field  ;
                SourceExpr="ID No";
                Editable=FALSE;
                OnValidate=BEGIN
                             IF "ID No"='' THEN
                             ERROR('Please fill the ID No.');
                           END;
                            }

    { 1102760011;2;Field  ;
                SourceExpr=Cashier }

    { 1102760013;2;Field  ;
                Name=Transaction Date;
                SourceExpr="Transaction Date";
                Editable="Transaction DateEditable" }

    { 1102760015;2;Field  ;
                SourceExpr="Transaction Time" }

    { 1102760006;2;Field  ;
                SourceExpr=Authorised;
                Editable=FALSE }

    { 1102760017;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1000000005;2;Field  ;
                SourceExpr=Picture }

    { 1000000004;2;Field  ;
                SourceExpr=Signature;
                Visible=false }

    { 1120054001;2;Field  ;
                SourceExpr="Signature 2" }

    { 1120054003;2;Field  ;
                SourceExpr="Back Side ID" }

    { 1120054009;2;Field  ;
                CaptionML=ENU=Front Side ID;
                SourceExpr="Front ID" }

  }
  CODE
  {
    VAR
      LoanBalance@1102760066 : Decimal;
      AvailableBalance@1102760065 : Decimal;
      UnClearedBalance@1102760064 : Decimal;
      LoanSecurity@1102760063 : Decimal;
      LoanGuaranteed@1102760062 : Decimal;
      GenJournalLine@1102760061 : Record 81;
      DefaultBatch@1102760060 : Record 232;
      GLPosting@1102760059 : Codeunit 12;
      window@1102760058 : Dialog;
      Account@1102760055 : Record 23;
      TransactionTypes@1102760054 : Record 51516298;
      TransactionCharges@1102760053 : Record 51516300;
      TCharges@1102760052 : Decimal;
      LineNo@1102760051 : Integer;
      AccountTypes@1102760050 : Record 51516295;
      GenLedgerSetup@1102760049 : Record 98;
      MinAccBal@1102760048 : Decimal;
      FeeBelowMinBal@1102760047 : Decimal;
      AccountNo@1102760046 : Code[30];
      NewAccount@1102760044 : Boolean;
      CurrentTellerAmount@1102760042 : Decimal;
      TellerTill@1102760041 : Record 270;
      IntervalPenalty@1102760039 : Decimal;
      StandingOrders@1102760038 : Record 51516307;
      AccountAmount@1102760036 : Decimal;
      STODeduction@1102760035 : Decimal;
      Charges@1102760034 : Record 51516297;
      "Total Deductions"@1102760033 : Decimal;
      STODeductedAmount@1102760032 : Decimal;
      NoticeAmount@1102760029 : Decimal;
      AccountNotices@1102760027 : Record 51516296;
      Cust@1102760026 : Record 51516223;
      AccountHolders@1102760025 : Record 23;
      ChargesOnFD@1102760024 : Decimal;
      TotalGuaranted@1102760021 : Decimal;
      VarAmtHolder@1102760020 : Decimal;
      chqtransactions@1102760019 : Record 51516299;
      Trans@1102760070 : Record 51516299;
      TotalUnprocessed@1102760018 : Decimal;
      CustAcc@1102760017 : Record 51516223;
      AmtAfterWithdrawal@1102760016 : Decimal;
      TransactionsRec@1102760015 : Record 51516299;
      LoansTotal@1102760013 : Decimal;
      Interest@1102760012 : Decimal;
      InterestRate@1102760009 : Decimal;
      OBal@1102760008 : Decimal;
      Principal@1102760007 : Decimal;
      ATMTrans@1102760005 : Decimal;
      ATMBalance@1102760004 : Decimal;
      TotalBal@1102760002 : Decimal;
      DenominationsRec@1102760001 : Record 51516303;
      TillNo@1102760067 : Code[20];
      FOSASetup@1102760068 : Record 312;
      Acc@1102760069 : Record 23;
      ChequeTypes@1102760071 : Record 51516304;
      ChargeAmount@1102760000 : Decimal;
      TChargeAmount@1102760003 : Decimal;
      DActivity@1102760006 : Code[20];
      DBranch@1102760010 : Code[20];
      UsersID@1102760011 : Record 2000000120;
      ChBank@1102760014 : Code[20];
      DValue@1102760022 : Record 349;
      ReceiptAllocations@1102760023 : Record 51516246;
      Loans@1102760028 : Record 51516230;
      Commision@1102760030 : Decimal;
      Cheque@1102760031 : Boolean;
      LOustanding@1102760037 : Decimal;
      TotalCommision@1102760040 : Decimal;
      TotalOustanding@1102760043 : Decimal;
      BOSABank@1102760045 : Code[20];
      InterestPaid@1102760056 : Decimal;
      PaymentAmount@1102760057 : Decimal;
      RunBal@1102760072 : Decimal;
      Recover@1102760073 : Boolean;
      genSetup@1102760074 : Record 51516257;
      MailContent@1102760076 : Text[150];
      supervisor@1102760077 : Record 51516309;
      TEXT1@1102760078 : TextConst 'ENU=YOU HAVE A TRANSACTION AWAITING APPROVAL';
      AccP@1102756000 : Record 23;
      LoansR@1102756001 : Record 51516230;
      ClearingCharge@1102756002 : Decimal;
      ClearingRate@1102756003 : Decimal;
      FChequeVisible@19071923 : Boolean INDATASET;
      BChequeVisible@19061919 : Boolean INDATASET;
      BReceiptVisible@19012582 : Boolean INDATASET;
      BOSAReceiptChequeVisible@19000755 : Boolean INDATASET;
      "Branch RefferenceVisible"@19001338 : Boolean INDATASET;
      LRefVisible@19003480 : Boolean INDATASET;
      "Transaction DateEditable"@19063264 : Boolean INDATASET;
      Excise@1102755000 : Decimal;
      Echarge@1102755001 : Decimal;
      BankLedger@1102755002 : Record 271;
      SMSMessage@1000000000 : Record 51516329;
      iEntryNo@1000000001 : Integer;
      Vend1@1000000002 : Record 23;
      TransDesc@1000000003 : Text;
      TransTypes@1000000004 : Record 51516298;
      ObjTransactionCharges@1000000005 : Record 51516300;
      AccountBalance@1000000006 : Decimal;
      MinimumBalance@1000000007 : Decimal;
      TransactionAmount@1000000008 : Decimal;
      WithCharges@1000000009 : Decimal;
      counter@1120054000 : Integer;
      FundsUser@1120054009 : Record 51516031;
      FundsManager@1120054008 : Codeunit 51516000;
      JTemplate@1120054007 : Code[20];
      JBatch@1120054006 : Code[20];
      DocType@1120054005 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Staff Advance,Staff Advance Accounting';
      TableIDs@1120054004 : Integer;
      ApprovalMgt@1120054003 : Codeunit 439;
      PHeader@1120054002 : Record 51516000;
      ApprovalsMgmt@1120054001 : Codeunit 1535;
      Table_id@1120054010 : Integer;
      SMSFee@1120054011 : Decimal;
      AuditTrail@1120054014 : Codeunit 51516107;
      Trail@1120054013 : Record 51516655;
      EntryNo@1120054012 : Integer;
      ExciseD@1120054015 : Decimal;
      SkyMbanking@1120054016 : Codeunit 51516701;
      Source@1120054017 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN';
      BandAmount@1120054018 : Decimal;
      BAmount@1120054019 : Decimal;
      Vendor@1120054020 : Record 23;
      AccTypes@1120054021 : Record 51516295;
      MinimumBal@1120054022 : Decimal;
      OD@1120054023 : Decimal;
      OverDraftAuthorisation@1120054024 : Record 51516328;
      FOSAAccount@1120054025 : Record 23;

    PROCEDURE CalcAvailableBal@1102760000();
    BEGIN
      ATMBalance:=0;

      TCharges:=0;
      AvailableBalance:=0;
      MinAccBal:=0;
      TotalUnprocessed:=0;
      IntervalPenalty:=0;


      IF Account.GET("Account No") THEN BEGIN
      Account.CALCFIELDS(Account.Balance,Account."Uncleared Cheques",Account."ATM Transactions",Account."Authorised Over Draft",Account."Coop Transaction");

      AccountTypes.RESET;
      AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      IF AccountTypes.FIND('-') THEN BEGIN
      MinAccBal:=AccountTypes."Minimum Balance";
      FeeBelowMinBal:=AccountTypes."Fee Below Minimum Balance";


      //Check Withdrawal Interval
      IF Account.Status <> Account.Status::New THEN BEGIN
      IF Type='Withdrawal' THEN BEGIN
      AccountTypes.RESET;
      AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      IF Account."Last Withdrawal Date"<>0D THEN BEGIN
      IF CALCDATE(AccountTypes."Withdrawal Interval",Account."Last Withdrawal Date") > TODAY THEN
      IntervalPenalty:=AccountTypes."Withdrawal Penalty";
      END;
      END;
      //Check Withdrawal Interval

      //Fixed Deposit
      ChargesOnFD:=0;
      IF AccountTypes."Fixed Deposit"=TRUE THEN BEGIN
      IF  Account."Expected Maturity Date" > TODAY THEN
      ChargesOnFD:=AccountTypes."Charge Closure Before Maturity";
      END;
      //Fixed Deposit


      //Current Charges
      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      REPEAT
      IF TransactionCharges."Use Percentage"=TRUE THEN BEGIN
      TransactionCharges.TESTFIELD("Percentage of Amount");
      TCharges:=TCharges+(TransactionCharges."Percentage of Amount"/100)*"Book Balance";
      END ELSE BEGIN
      TCharges:=TCharges+TransactionCharges."Charge Amount";
      END;
      UNTIL TransactionCharges.NEXT=0;
      END;


      TotalUnprocessed:=Account."Uncleared Cheques";
      ATMBalance:=Account."ATM Transactions"+Account."Coop Transaction";

      //FD
      IF AccountTypes."Fixed Deposit"=FALSE THEN BEGIN
      IF Account.Balance < MinAccBal THEN
      AvailableBalance:=(Account.Balance+Account."Authorised Over Draft") - FeeBelowMinBal - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance -
                        Account."EFT Transactions"-Account."Mpesa Withdrawals"
      ELSE
      AvailableBalance:=(Account.Balance+Account."Authorised Over Draft") - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance -
                        Account."EFT Transactions"-Account."Mpesa Withdrawals";
      END ELSE BEGIN
      AvailableBalance:=(Account.Balance+Account."Authorised Over Draft") - TCharges - ChargesOnFD - Account."ATM Transactions"-Account."Coop Transaction"-Account."Mpesa Withdrawals";
      END;
      END;
      //FD
      IF Withdarawal=TRUE THEN  BEGIN
      AvailableBalance:=(Account.Balance + Account."Authorised Over Draft") - FeeBelowMinBal - TCharges - IntervalPenalty  - TotalUnprocessed - ATMBalance -
                        Account."EFT Transactions";

                        END;

      END;
      END;

      IF "N.A.H Balance"<>0 THEN
      AvailableBalance:="N.A.H Balance";
      //AvailableBalance:=AvailableBalance-12;
      // IF "Book Balance"<0 THEN
      // AvailableBalance:="Book Balance"
      // ELSE
      // AvailableBalance:="Book Balance"-1000;
      //MESSAGE('Available%1 ',Amount);
    END;

    PROCEDURE PostChequeDep@1102760001();
    BEGIN
      DValue.RESET;
      DValue.SETRANGE(DValue."Global Dimension No.",2);
      DValue.SETRANGE(DValue.Code,DBranch);


      {IF DValue.FIND('-') THEN BEGIN
      DValue.TESTFIELD(DValue."Clearing Bank Account");
      ChBank:='BNK00002';  //DValue."Clearing Bank Account";
      END ELSE}

      //ERROR('Branch not set.');
      ChBank:="Bank Code";

      //MESSAGE('bank account is %1',ChBank);

      IF ChequeTypes.GET("Cheque Type") THEN BEGIN
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      GenJournalLine.DELETEALL;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      IF "Branch Transaction" = TRUE THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      ELSE
      GenJournalLine.Description:="Transaction Description" +'-'+ Description ;
      //Project Accounts
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc."Account Category" = Acc."Account Category"::Project THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      END;
      //Project Accounts
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=ChBank;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:="Account Name";
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      //Post Charges
      ChargeAmount:=0;

      LineNo:=LineNo+10000;
      ClearingCharge:=0;

      ObjTransactionCharges.RESET;
      ObjTransactionCharges.SETRANGE(ObjTransactionCharges."Transaction Type","Transaction Type");
      IF ObjTransactionCharges.FINDSET THEN BEGIN
        ///REPEAT
        IF(ObjTransactionCharges."Charge Code"<>'EXCISE') THEN BEGIN
          IF(ObjTransactionCharges."Use Percentage"=TRUE) THEN BEGIN
            LineNo:=LineNo+10000;
            ClearingCharge:=ClearingCharge+ObjTransactionCharges."Percentage of Amount"/100*Amount;
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name":='PURCHASES';
            GenJournalLine."Journal Batch Name":='FTRANS';
            GenJournalLine."Document No.":=No;
            GenJournalLine."Line No.":=LineNo;
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
            GenJournalLine."Account No.":="Account No";
            GenJournalLine."External Document No.":="ID No";
            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
            GenJournalLine."Posting Date":="Transaction Date";
            GenJournalLine.Description:=ObjTransactionCharges.Description;
            GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
            GenJournalLine.Amount:=ObjTransactionCharges."Percentage of Amount"/100*Amount;
            GenJournalLine.VALIDATE(GenJournalLine.Amount);
            GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine."Bal. Account No.":=ObjTransactionCharges."G/L Account";
            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
            GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
            GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
            GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
            IF GenJournalLine.Amount<>0 THEN
            GenJournalLine.INSERT;
            END
            ELSE
            BEGIN
             LineNo:=LineNo+10000;
            ClearingCharge:=ClearingCharge+ObjTransactionCharges."Charge Amount";
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name":='PURCHASES';
            GenJournalLine."Journal Batch Name":='FTRANS';
            GenJournalLine."Document No.":=No;
            GenJournalLine."Line No.":=LineNo;
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
            GenJournalLine."Account No.":="Account No";
            GenJournalLine."External Document No.":="ID No";
            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
            GenJournalLine."Posting Date":="Transaction Date";
            GenJournalLine.Description:=ObjTransactionCharges.Description;
            GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
            GenJournalLine.Amount:=ObjTransactionCharges."Charge Amount";
            GenJournalLine.VALIDATE(GenJournalLine.Amount);
            GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine."Bal. Account No.":=ObjTransactionCharges."G/L Account";
            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
            GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
            GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
            GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
            IF GenJournalLine.Amount<>0 THEN
            GenJournalLine.INSERT;
              END
        END;
        //UNTIL ObjTransactionCharges.NEXT=0;
        END;

      genSetup.GET(0);

      IF Type = 'Withdrawal' THEN BEGIN
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;


      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Excise Duty';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //MESSAGE('AsDFG');
      GenJournalLine.Amount:=10;//(ClearingCharge*genSetup."Excise Duty(%)")/100;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=genSetup."Excise Duty Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      END;



      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
      END;

      //Post New


      Posted:=TRUE;
      Authorised:=Authorised::Yes;
      "Supervisor Checked":=TRUE;
      "Needs Approval":="Needs Approval"::No;
      "Frequency Needs Approval":="Frequency Needs Approval"::No;
      "Date Posted":=TODAY;
      "Time Posted":=TIME;
      "Posted By":=USERID;
      IF ChequeTypes."Clearing  Days" = 0 THEN BEGIN
      Status:=Status::Honoured;
      "Cheque Processed":="Cheque Processed"::"1";
      "Date Cleared":=TODAY;
      END;

      MODIFY;

      //SMS
          Vend1.RESET;
          Vend1.SETRANGE(Vend1."No.","Account No");
          IF Vend1.FIND('-') THEN BEGIN
            TransDesc := '';
            TransTypes.RESET;
            TransTypes.SETRANGE(TransTypes.Code,"Transaction Type");
            IF TransTypes.FIND('-') THEN BEGIN
             TransDesc := TransTypes.Description;
            END;
            //SMS MESSAGE
            SMSMessage.RESET;
              IF SMSMessage.FIND('+') THEN BEGIN
              iEntryNo:=SMSMessage."Entry No";
              iEntryNo:=iEntryNo+1;
            END ELSE BEGIN
              iEntryNo:=1;
            END;
            SMSMessage.RESET;
            SMSMessage.INIT;
            SMSMessage."Entry No":=iEntryNo;
            SMSMessage."Account No":=Vend1."No.";
            SMSMessage."Date Entered":=TODAY;
            SMSMessage."Time Entered":=TIME;
            SMSMessage.Source:='OTC SMS';
            SMSMessage."Entered By":=USERID;
            SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
            IF Amount<>0 THEN BEGIN
              SMSMessage."SMS Message":='Dear '  +FORMAT(Vend1.Name)+'  You have Deposited a Cheque of KSHS. '+
              FORMAT(Amount)+' on '+FORMAT(TODAY) + ' ' +FORMAT(TIME)+' at TELEPOST SACCO Tel. 0205029200. REF:'+No;
            END;
            IF Vend1."MPESA Mobile No" <> '' THEN BEGIN
               //SMSMessage."Telephone No":=Vend1."MPESA Mobile No";
            END ELSE BEGIN
               SMSMessage."Telephone No":=Vend1."Phone No.";
            END;
            IF SMSMessage."Telephone No"<>'' THEN
            SMSMessage.INSERT;
          END;



      MESSAGE('Cheque deposited successfully.');
      //***********be printing after posting,users requested
      {Trans.RESET;
      Trans.SETRANGE(Trans.No,No);
      IF Trans.FIND('-') THEN
      REPORT.RUN(51516433,FALSE,TRUE,Trans);}


      END;
    END;

    PROCEDURE PostBankersCheq@1102760003();
    BEGIN
      //Block Payments
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc.Blocked = Acc.Blocked::Payment THEN
      ERROR('This account has been blocked from receiving payments.');
      END;

      {
      DValue.RESET;
      DValue.SETRANGE(DValue."Global Dimension No.",2);
      DValue.SETRANGE(DValue.Code,DBranch);
      IF DValue.FIND('-') THEN BEGIN
      //DValue.TESTFIELD(DValue."Banker Cheque Account");
      ChBank:=DValue."Banker Cheque Account";
      END ELSE
      ERROR('Branch not set.');
      }

      TESTFIELD("Bank Code");

      ChBank:="Bank Code";

      CalcAvailableBal;

      //Check withdrawal limits
      IF Type = 'Bankers Cheque' THEN BEGIN
      IF AvailableBalance < Amount THEN BEGIN
      IF Authorised=Authorised::Yes THEN BEGIN
      Overdraft:=TRUE;
      MODIFY;
      END;

      IF Authorised=Authorised::No THEN BEGIN
      IF "Branch Transaction" = FALSE THEN BEGIN
      "Authorisation Requirement":='Bankers Cheque - Over draft';
      MODIFY;
      MESSAGE('You cannot issue a Bankers cheque more than the available balance unless authorised.');
      SendEmail;
      EXIT;
      END;
      END;
      IF Authorised = Authorised::Rejected THEN
      ERROR('Bankers cheque transaction has been rejected and therefore cannot proceed.');
      //SendEmail;
      END;
      END;
      //Check withdrawal limits


      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      GenJournalLine.DELETEALL;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Bankers Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");

      GenJournalLine."Posting Date":="Transaction Date";
      IF "Branch Transaction" = TRUE THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      ELSE
      GenJournalLine.Description:="Transaction Description"+'-'+Description ;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Bankers Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=ChBank;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;//"Account Name";
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Charges
      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      REPEAT
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Bankers Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=TransactionCharges.Description;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=TransactionCharges."Charge Amount";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      IF TransactionCharges."Due Amount" > 0 THEN BEGIN
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Bankers Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No.":=TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=TransactionCharges.Description;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=TransactionCharges."Due Amount";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
      GenJournalLine."Bal. Account No.":=ChBank;
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      END;

      UNTIL TransactionCharges.NEXT = 0;
      END;

      //Charges

      //Excise Duty
      genSetup.GET(0);

      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Excise Duty';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=5;//(TransactionCharges."Charge Amount"*genSetup."Excise Duty(%)")/100;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=genSetup."Excise Duty Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;



      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
      END;

      //Post New


      "Transaction Available Balance":=AvailableBalance;
      Posted:=TRUE;
      Authorised:=Authorised::Yes;
      "Supervisor Checked":=TRUE;
      "Needs Approval":="Needs Approval"::No;
      "Frequency Needs Approval":="Frequency Needs Approval"::No;
      "Date Posted":=TODAY;
      "Time Posted":=TIME;
      "Posted By":=USERID;
      MODIFY;
      {IF CONFIRM('Are you sure you want to print this bankers cheque?',TRUE)=TRUE THEN BEGIN
      REPORT.RUN(,TRUE,TRUE,Trans)
      END;}


      MESSAGE('Bankers cheque posted successfully.');
      //SMS
          Vend1.RESET;
          Vend1.SETRANGE(Vend1."No.","Account No");
          IF Vend1.FIND('-') THEN BEGIN
            TransDesc := '';
            TransTypes.RESET;
            TransTypes.SETRANGE(TransTypes.Code,"Transaction Type");
            IF TransTypes.FIND('-') THEN BEGIN
             TransDesc := TransTypes.Description;
            END;
            //SMS MESSAGE

            SMSMessage.RESET;
              IF SMSMessage.FIND('+') THEN BEGIN
              iEntryNo:=SMSMessage."Entry No";
              iEntryNo:=iEntryNo+1;
            END ELSE BEGIN
              iEntryNo:=1;
            END;
            SMSMessage.RESET;
            SMSMessage.INIT;
            SMSMessage."Entry No":=iEntryNo;
            SMSMessage."Account No":=Vend1."No.";
            SMSMessage."Date Entered":=TODAY;
            SMSMessage."Time Entered":=TIME;
            SMSMessage.Source:='OTC SMS';
            SMSMessage."Entered By":=USERID;
            SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
            IF Amount<>0 THEN BEGIN
              SMSMessage."SMS Message":='Dear ' +FORMAT(Vend1.Name)+ '  You have deposited Cheque of KSHS. '+
              FORMAT(Amount)+' on '+FORMAT(TODAY) + ' ' +FORMAT(TIME)+' at TELEPOST SACCO Tel. 0205029200';
            END;
            IF Vend1."MPESA Mobile No" <> '' THEN BEGIN
              // SMSMessage."Telephone No":=Vend1."MPESA Mobile No";
            END ELSE BEGIN
               SMSMessage."Telephone No":=Vend1."Phone No.";
            END;
            IF SMSMessage."Telephone No"<>'' THEN
            SMSMessage.INSERT;


          END;
    END;

    PROCEDURE PostEncashment@1102760005();
    BEGIN
      //Block Payments
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc.Blocked = Acc.Blocked::Payment THEN
      ERROR('This account has been blocked from receiving payments.');
      END;


      CalcAvailableBal;

      //Check withdrawal limits
      IF Type = 'Encashment' THEN BEGIN
      IF AvailableBalance < Amount THEN BEGIN
      IF Authorised=Authorised::Yes THEN BEGIN
      Overdraft:=TRUE;
      MODIFY;
      END;

      IF Authorised=Authorised::No THEN BEGIN
      "Authorisation Requirement":='Encashment - Over draft';
      MODIFY;
      MESSAGE('You cannot issue an encashment more than the available balance unless authorised.');
      MailContent:='Withdrawal transaction' + 'TR. No.'+' '+No+' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'needs your authorization';
      SendEmail;

      //SendEmail;
      EXIT;
      END;
      IF Authorised = Authorised::Rejected THEN BEGIN
      MailContent:='Bankers cheque transaction' + ' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'needs your approval';
      SendEmail;
      ERROR('Transaction has been rejected and therefore cannot proceed.');

      END;
      END;
      END;
      //Check withdrawal limits



      //Check Teller Balances
      //ADDED DActivity:='';
      //ADDED DBranch:='';

      TillNo:='';
      TellerTill.RESET;
      TellerTill.SETRANGE(TellerTill."Account Type",TellerTill."Account Type"::Cashier);
      TellerTill.SETRANGE(TellerTill."Cashier ID",USERID);
      IF TellerTill.FIND('-') THEN BEGIN
      //ADDED DActivity:=TellerTill."Global Dimension 1 Code";
      //ADDED DBranch:=TellerTill."Global Dimension 2 Code";
      TillNo:=TellerTill."No.";
      TellerTill.CALCFIELDS(TellerTill.Balance);

      CurrentTellerAmount:=TellerTill.Balance;

      IF CurrentTellerAmount-Amount<=TellerTill."Min. Balance" THEN
      MESSAGE('You need to add more money from the treasury since your balance has gone below the teller replenishing level.');

      IF ("Transaction Type" = 'Withdrawal') OR ("Transaction Type" = 'Encashment') THEN BEGIN
      IF (CurrentTellerAmount - Amount) < 0 THEN
      ERROR('You do not have enough money to carry out this transaction.');

      END;

      IF ("Transaction Type" = 'Withdrawal') OR ("Transaction Type" = 'Encashment') THEN BEGIN
      IF CurrentTellerAmount - Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');

      END ELSE BEGIN
      IF CurrentTellerAmount + Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');
      END;


      END;

      IF TillNo = '' THEN
      ERROR('Teller account not set-up.');

      //Check Teller Balances




      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      GenJournalLine.DELETEALL;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF ("Account No"='00-0000003000') OR  ("Account No"='00-0200003000') THEN
      GenJournalLine."External Document No.":="ID No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Charges
      TCharges:=0;
      //ADDED
      TChargeAmount:=0;


      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      REPEAT
      LineNo:=LineNo+10000;

      ChargeAmount:=0;
      IF TransactionCharges."Use Percentage" = TRUE THEN
      ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      ELSE
      ChargeAmount:=TransactionCharges."Charge Amount";

      IF (TransactionCharges."Minimum Amount" <> 0) AND (ChargeAmount < TransactionCharges."Minimum Amount") THEN
      ChargeAmount := TransactionCharges."Minimum Amount";

      IF (TransactionCharges."Maximum Amount" <> 0) AND (ChargeAmount > TransactionCharges."Maximum Amount") THEN
      ChargeAmount := TransactionCharges."Maximum Amount";



      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No.":=TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;

      UNTIL TransactionCharges.NEXT = 0;
      END;

      //Charges


      //Teller Entry
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=TillNo;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-(Amount-TChargeAmount);
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::Codeunit50013,GenJournalLine);
      END;

      //Post New


      "Transaction Available Balance":=AvailableBalance;
      Posted:=TRUE;
      Authorised:=Authorised::Yes;
      "Supervisor Checked":=TRUE;
      "Needs Approval":="Needs Approval"::No;
      "Frequency Needs Approval":="Frequency Needs Approval"::No;
      "Date Posted":=TODAY;
      "Time Posted":=TIME;
      "Posted By":=USERID;
      MODIFY;
      //Create Audit Entry
      IF Trail.FINDLAST THEN
      BEGIN
      EntryNo:=Trail."Entry No"+1;
      END ELSE BEGIN
      EntryNo:=1;
      END;
      AuditTrail.FnInsertAuditRecords(EntryNo,USERID,"Transaction Type",Amount,
      'CASHIER TRANS',TODAY,TIME,'',No,"Account No",'');
      //End Create Audit Entry
    END;

    PROCEDURE PostBOSAEntries@1102760002();
    VAR
      ReceiptAllocation@1102760000 : Record 51516246;
    BEGIN
      //Block Payments
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc.Blocked = Acc.Blocked::Payment THEN
      ERROR('This account has been blocked from receiving payments.');
      END;


      CalcAvailableBal;

      //Check withdrawal limits
      IF Type = 'Encashment' THEN BEGIN
      IF AvailableBalance < Amount THEN BEGIN
      IF Authorised=Authorised::Yes THEN BEGIN
      Overdraft:=TRUE;
      MODIFY;
      END;

      IF Authorised=Authorised::No THEN BEGIN
      "Authorisation Requirement":='Encashment - Over draft';
      MODIFY;
      MESSAGE('You cannot issue an encashment more than the available balance unless authorised.');
      MailContent:='Withdrawal transaction' + 'TR. No.'+' '+No+' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'needs your authorization';
      SendEmail;

      //SendEmail;
      EXIT;
      END;
      IF Authorised = Authorised::Rejected THEN BEGIN
      MailContent:='Bankers cheque transaction' + ' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'needs your approval';
      SendEmail;
      ERROR('Transaction has been rejected and therefore cannot proceed.');

      END;
      END;
      END;
      //Check withdrawal limits



      //Check Teller Balances
      //ADDED DActivity:='';
      //ADDED DBranch:='';

      TillNo:='';
      TellerTill.RESET;
      TellerTill.SETRANGE(TellerTill."Account Type",TellerTill."Account Type"::Cashier);
      TellerTill.SETRANGE(TellerTill."Cashier ID",USERID);
      IF TellerTill.FIND('-') THEN BEGIN
      //ADDED DActivity:=TellerTill."Global Dimension 1 Code";
      //ADDED DBranch:=TellerTill."Global Dimension 2 Code";
      TillNo:=TellerTill."No.";
      TellerTill.CALCFIELDS(TellerTill.Balance);

      CurrentTellerAmount:=TellerTill.Balance;

      IF CurrentTellerAmount-Amount<=TellerTill."Min. Balance" THEN
      MESSAGE('You need to add more money from the treasury since your balance has gone below the teller replenishing level.');

      IF ("Transaction Type" = 'Withdrawal') OR ("Transaction Type" = 'Encashment') THEN BEGIN
      IF (CurrentTellerAmount - Amount) < 0 THEN
      ERROR('You do not have enough money to carry out this transaction.');

      END;

      IF ("Transaction Type" = 'Withdrawal') OR ("Transaction Type" = 'Encashment') THEN BEGIN
      IF CurrentTellerAmount - Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');

      END ELSE BEGIN
      IF CurrentTellerAmount + Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');
      END;


      END;

      //IF TillNo = '' THEN
      //ERROR('Teller account not set-up.');

      //Check Teller Balances




      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      GenJournalLine.DELETEALL;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF ("Account No"='00-0000003000') OR  ("Account No"='00-0200003000') THEN
      GenJournalLine."External Document No.":="ID No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Charges
      TCharges:=0;
      //ADDED
      TChargeAmount:=0;


      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      REPEAT
      LineNo:=LineNo+10000;

      ChargeAmount:=0;
      IF TransactionCharges."Use Percentage" = TRUE THEN
      ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      ELSE
      ChargeAmount:=TransactionCharges."Charge Amount";

      IF (TransactionCharges."Minimum Amount" <> 0) AND (ChargeAmount < TransactionCharges."Minimum Amount") THEN
      ChargeAmount := TransactionCharges."Minimum Amount";

      IF (TransactionCharges."Maximum Amount" <> 0) AND (ChargeAmount > TransactionCharges."Maximum Amount") THEN
      ChargeAmount := TransactionCharges."Maximum Amount";



      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No.":=TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;

      UNTIL TransactionCharges.NEXT = 0;
      END;

      //Charges


      //Teller Entry
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=TillNo;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-(Amount-TChargeAmount);
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      //CODEUNIT.RUN(CODEUNIT::Codeunit50013,GenJournalLine);
      END;

      //Post New


      "Transaction Available Balance":=AvailableBalance;
      Posted:=TRUE;
      Authorised:=Authorised::Yes;
      "Supervisor Checked":=TRUE;
      "Needs Approval":="Needs Approval"::No;
      "Frequency Needs Approval":="Frequency Needs Approval"::No;
      "Date Posted":=TODAY;
      "Time Posted":=TIME;
      "Posted By":=USERID;
      MODIFY;
    END;

    PROCEDURE SuggestBOSAEntries@1102760004();
    BEGIN
      TESTFIELD(Posted,FALSE);
      TESTFIELD("BOSA Account No");

      ReceiptAllocations.RESET;
      ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No",No);
      ReceiptAllocations.DELETEALL;

      PaymentAmount:=Amount;
      RunBal:=PaymentAmount;

      Loans.RESET;
      Loans.SETCURRENTKEY(Loans.Source,Loans."Client Code");
      Loans.SETRANGE(Loans."Client Code","BOSA Account No");
      Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
      IF Loans.FIND('-') THEN BEGIN
      REPEAT
      Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due");
      Recover := TRUE;

      IF (Loans."Outstanding Balance") > 0 THEN BEGIN
      IF ((Loans."Outstanding Balance"-Loans."Loan Principle Repayment") <= 0) AND (Cheque = FALSE)  THEN
      Recover:=FALSE;

      IF Recover = TRUE THEN BEGIN

      Commision:=0;
      IF Cheque = TRUE THEN BEGIN
      Commision:=(Loans."Outstanding Balance")*0.1;
      LOustanding:=Loans."Outstanding Balance";
      IF Loans."Interest Due" > 0 THEN
      InterestPaid:=Loans."Interest Due";
      END ELSE BEGIN
      LOustanding:=(Loans."Outstanding Balance"-Loans."Loan Principle Repayment");
      IF LOustanding < 0 THEN
      LOustanding:=0;
      IF Loans."Interest Due" > 0 THEN
      InterestPaid:=Loans."Interest Due";
      IF (Loans."Outstanding Balance"-Loans."Loan Principle Repayment") > 0 THEN BEGIN
      IF (Loans."Outstanding Balance"-Loans."Loan Principle Repayment") > (Loans."Approved Amount"*1/3) THEN
      Commision:=LOustanding*0.1;
      END;
      END;

      IF PaymentAmount > 0 THEN BEGIN
      IF RunBal < (LOustanding+Commision+InterestPaid) THEN BEGIN
      IF RunBal < InterestPaid THEN
      InterestPaid:=RunBal;
      //Commision:=(RunBal-InterestPaid)*0.1;
      Commision:=(RunBal-InterestPaid)-((RunBal-InterestPaid)/1.1);
      LOustanding:=(RunBal-InterestPaid)-Commision;

      END;
      END;


      TotalCommision:=TotalCommision+Commision;
      TotalOustanding:=TotalOustanding+LOustanding+InterestPaid+Commision;

      RunBal:=RunBal-(LOustanding+InterestPaid+Commision);

      IF (LOustanding + InterestPaid) > 0 THEN BEGIN
      ReceiptAllocations.INIT;
      ReceiptAllocations."Document No":=No;
      ReceiptAllocations."Member No":="BOSA Account No";
      ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Registration Fee";
      ReceiptAllocations."Loan No.":=Loans."Loan  No.";
      ReceiptAllocations.Amount:=ROUND(LOustanding,0.01);
      ReceiptAllocations."Interest Amount":=ROUND(InterestPaid,0.01);
      ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
      ReceiptAllocations.INSERT;
      END;

      IF Commision > 0 THEN BEGIN
      ReceiptAllocations.INIT;
      ReceiptAllocations."Document No":=No;
      ReceiptAllocations."Member No":="BOSA Account No";
      ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::Repayment;
      ReceiptAllocations."Loan No.":=Loans."Loan  No.";
      ReceiptAllocations.Amount:=ROUND(Commision,0.01);
      ReceiptAllocations."Interest Amount":=0;
      ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
      ReceiptAllocations.INSERT;
      END;

      END;
      END;

      UNTIL Loans.NEXT = 0;
      END;

      IF RunBal > 0 THEN BEGIN
      ReceiptAllocations.INIT;
      ReceiptAllocations."Document No":=No;
      ReceiptAllocations."Member No":="BOSA Account No";
      ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Benevolent Fund";
      ReceiptAllocations."Loan No.":='';
      ReceiptAllocations.Amount:=RunBal;
      ReceiptAllocations."Interest Amount":=0;
      ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
      ReceiptAllocations.INSERT;

      END;
    END;

    PROCEDURE SendEmail@1102760006();
    BEGIN
      {
      //send e-mail to supervisor
      supervisor.RESET;
      supervisor.SETFILTER(supervisor."Transaction Type",'withdrawal');
      IF supervisor.FIND('-') THEN BEGIN
       // MailContent:=TEXT1;
      REPEAT

       genSetup.GET(0);
       SMTPMAIL.NewMessage(genSetup."Sender Address",'Transactions' +''+'');
       SMTPMAIL.SetWorkMode();
       SMTPMAIL.ClearAttachments();
       SMTPMAIL.ClearAllRecipients();
       SMTPMAIL.SetDebugMode();
       SMTPMAIL.SetFromAdress(genSetup."Sender Address");
       SMTPMAIL.SetHost(genSetup."Outgoing Mail Server");
       SMTPMAIL.SetUserID(genSetup."Sender User ID");
       SMTPMAIL.AddLine(MailContent);
       SMTPMAIL.SetToAdress(supervisor."E-mail Address");
       SMTPMAIL.Send;
       UNTIL supervisor.NEXT=0;
      END;
      }
    END;

    PROCEDURE PostCashDepWith@1102760016();
    VAR
      msg@1120054000 : Text;
      PhoneNumber@1120054001 : Text;
    BEGIN
      CalcAvailableBal;
      MESSAGE( 'Are you sure, You want to post this Transaction');
      //Check withdrawal limits - Available Bal
      IF Type = 'Withdrawal' THEN BEGIN
      //Block Payments
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc.Blocked = Acc.Blocked::Payment THEN
      ERROR('This account has been blocked from receiving payments.');
      END;

      IF AvailableBalance < Amount THEN BEGIN
        IF Authorised=Authorised::Yes THEN BEGIN
            Overdraft:=TRUE;
            MODIFY;
        END;

      IF Authorised=Authorised::No THEN BEGIN
        IF "Branch Transaction" = FALSE THEN BEGIN
          "Authorisation Requirement":='Over draft';
          MODIFY;
          MailContent:='Withdrawal transaction' + 'TR. No.'+' '+No+' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
          +' ' +"Account Name"+' '+'needs your approval';
            SendEmail;
          MESSAGE('You cannot withdraw more than the available balance unless authorised.');

          EXIT;
        END;
      IF Authorised = Authorised::Rejected THEN
      ERROR('Transaction has been rejected and therefore cannot proceed.');

      END;
      END;
      END;
      //Check withdrawal limits - Available Bal



      //Check Teller Balances
      //ADDED DActivity:='';
      //ADDED DBranch:='';

      TillNo:='';
      TellerTill.RESET;
      TellerTill.SETRANGE(TellerTill."Account Type",TellerTill."Account Type"::Cashier);
      TellerTill.SETRANGE(TellerTill.CashierID,USERID);
      IF TellerTill.FIND('-') THEN BEGIN
      TillNo:=TellerTill."No.";
      TellerTill.CALCFIELDS(TellerTill.Balance);

      CurrentTellerAmount:=TellerTill.Balance;

      IF CurrentTellerAmount-Amount<=TellerTill."Min. Balance" THEN
      MESSAGE('You need to add more money from the treasury since your balance has gone below the teller replenishing level.');

      IF ("Transaction Type"='Withdrawal') OR ("Transaction Type"='Encashment') THEN BEGIN
      IF (CurrentTellerAmount - Amount) < 0 THEN
      ERROR('You do not have enough money to carry out this transaction.');
      EXIT;
      END;
      MESSAGE('CurrentTellerAmount %1',CurrentTellerAmount);
      IF (TransactionTypes.Type=TransactionTypes.Type::Withdrawal) OR (TransactionTypes.Type=TransactionTypes.Type::Encashment) THEN BEGIN
      IF CurrentTellerAmount - Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');

      END ELSE BEGIN
      IF CurrentTellerAmount + Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');
      END;

      //Check teller transaction limits
      IF Type = 'Withdrawal' THEN BEGIN
      IF Amount > TellerTill."Max Withdrawal Limit" THEN BEGIN
      IF Authorised=Authorised::No THEN BEGIN
      "Authorisation Requirement":='Withdrawal Above teller Limit';
      MODIFY;

      MailContent:='The' + ' ' + 'Cashier'+' '+Cashier+ ' '+
      'cannot withdraw more than allowed ,limit, Maximum limit is'+ ''+FORMAT(TellerTill."Max Withdrawal Limit")+
      'you need to authorise';
        SendEmail;
      MESSAGE('You cannot withdraw more than your allowed limit of %1 unless authorised.',TellerTill."Max Withdrawal Limit");

      EXIT;
      END;
      IF Authorised = Authorised::Rejected THEN
      ERROR('Transaction has been rejected and therefore cannot proceed.');

      END;
      END;


      //Prevent teller from Overdrawing Till

      IF Type = 'Withdrawal' THEN BEGIN
      TellerTill.CALCFIELDS(TellerTill.Balance);
      IF Amount > TellerTill.Balance THEN BEGIN
      ERROR('you cannot transact below your Till balance.');
      END;
      END;

      //Prevent teller from Overdrawing Till



      IF Type = 'Cash Deposit' THEN BEGIN
      IF Amount > TellerTill."Max Deposit Limit" THEN BEGIN
      IF Authorised=Authorised::No THEN BEGIN
      "Authorisation Requirement":='Deposit above teller Limit';
      MODIFY;
      MailContent:='The' + ' ' + 'Cashier'+' '+Cashier+ ' '+
      'cannot deposit more than allowed limit, Maximum limit is'+ ''+FORMAT(TellerTill."Max Deposit Limit")+ 'you need to authorise';
       SendEmail;
      MESSAGE('You cannot deposit more than your allowed limit of %1 unless authorised.',TellerTill."Max Deposit Limit");
      EXIT;
      END;
      IF Authorised = Authorised::Rejected THEN
       //SendEmail;
      ERROR('Transaction has been rejected therefore you cannot proceed.');

      END;
      END;

      //Check teller transaction limits
      END;



      //IF TillNo = '' THEN
      //ERROR('Teller account not set-up.');

      //Check Teller Balances


      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FINDFIRST THEN
      GenJournalLine.DELETEALL;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=No;
      IF ("Transaction Type" = 'BOSA') OR ("Transaction Type" = 'Encashment') THEN
      GenJournalLine."External Document No.":="BOSA Account No";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      IF ("Transaction Type" = 'BOSA') OR ("Transaction Type" = 'Encashment') THEN
      GenJournalLine.Description:=Payee
      ELSE BEGIN
      IF "Branch Transaction" = TRUE THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      ELSE
      GenJournalLine.Description:=Type + '-' + Description;
      END;
      //Project Accounts
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc."Account Category" = Acc."Account Category"::Project THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      END;
      //Project Accounts

      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      IF (Type='Cash Deposit') OR (Type='BOSA Receipt') THEN
      GenJournalLine.Amount:=-Amount
      ELSE
      GenJournalLine.Amount:=Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
      GenJournalLine."Bal. Account No.":=TillNo;
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      //END;

      IF (Acc."Mobile Phone No"<>'') THEN BEGIN

       END;

      TCharges:=0;


      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      IF TransactionCharges."Charge Code"<>'009' THEN
      REPEAT

      LineNo:=LineNo+10000;

      ChargeAmount:=0;
      IF TransactionCharges."Use Percentage" = TRUE THEN
      ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      ELSE  ChargeAmount:=TransactionCharges."Charge Amount";
      IF "Account Type"='DIVIDEND' THEN BEGIN
      IF (Amount>=300)  AND (Amount<1000) THEN
      ChargeAmount:=160
      ELSE IF  (Amount>=1001) AND (Amount<2500) THEN
      ChargeAmount:=200
      ELSE IF (Amount>=2501) AND (Amount<50001) THEN
      ChargeAmount:=250
      ELSE IF (Amount>=50001) AND (Amount<100001) THEN
      ChargeAmount:=300
      ELSE IF (Amount>=10001) AND (Amount<200000) THEN
      ChargeAmount:=350
      ELSE IF Amount>200000 THEN
      ChargeAmount:=400
      END; //ELSE
      Echarge:=ChargeAmount;

      //if TransactionCharges.Description<>'Cash Withdrawal Charges' THEN
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=TransactionCharges.Description;//'Excise duty';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //IF (TransactionCharges."Charge Code",'<>SD') AND (Amount > 20000)  THEN
      //ChargeAmount:=200 ELSE
      GenJournalLine.Amount:=ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=TransactionCharges."G/L Account";//'200-000-168';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      //GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;

      //END;
      //END
      UNTIL TransactionCharges.NEXT = 0
      END;
      //Echarge:=2;



      //credit bank





      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      TransactionCharges.SETRANGE(TransactionCharges."Charge Code",'EXCISE');
      IF TransactionCharges.FIND('-') THEN BEGIN
      //IF TransactionCharges."Charge Code"='0001' THEN

      //Charges
       Excise:=0;
      //Excise Duty
      genSetup.GET(0);
      Excise:=TransactionCharges."Charge Amount";

      //Charges


      //excise duty
      IF Type = 'Withdrawal' THEN BEGIN
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Excise Duty ';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=0;//(Excise*(20/100));
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=genSetup."Excise Duty Account";//'200-000-168';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      END;
      END;
      //end exciseduty
      TCharges:=0;

        IF Type = 'Withdrawal' THEN BEGIN
      LineNo:=LineNo+10000;

      ChargeAmount:=2;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Stamp Duty';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='200-000-168';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      //GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;
      END;


      IF Authorised=Authorised::Yes THEN
        BEGIN
         //IF Type = 'Withdrawal' THEN BEGIN
      IF Account.GET("Account No") THEN BEGIN
      Account.CALCFIELDS(Account.Balance,Account."Uncleared Cheques",Account."ATM Transactions",Account."Coop Transaction");
      AccountBalance:=Account.Balance;
      AccountTypes.RESET;
      AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      IF AccountTypes.FIND('-') THEN BEGIN
      MinAccBal:=AccountTypes."Minimum Balance";
      FeeBelowMinBal:=AccountTypes."Fee Below Minimum Balance";
      END;
      END;

      TransactionAmount:=AccountBalance-(FeeBelowMinBal+Amount);
      IF (TransactionAmount<=0) THEN BEGIN
          genSetup.GET(0);

       IF Type = 'Withdrawal' THEN BEGIN
          LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='PURCHASES';
          GenJournalLine."Journal Batch Name":='FTRANS';
          GenJournalLine."Document No.":=No;
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
          GenJournalLine."Account No.":="Account No";
          IF "Account No"='00-0000000000' THEN
          GenJournalLine."External Document No.":="ID No";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Posting Date":="Transaction Date";
          GenJournalLine.Description:='Commission on FOSA overdraft';
          GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
          GenJournalLine.Amount:=((Amount*7)/100);
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
          GenJournalLine."Bal. Account No.":=genSetup."Commission on FOSA Overdraft";
          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
          GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
          GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;
          END;
        END;
      END;

      //end credit bank
      ChargeAmount:=0;
      //post Bank Transfers
      IF ChargeTransfer=TRUE THEN

      Charges.RESET;
      Charges.SETRANGE(Charges.Description,'bank transfer');
      IF Charges.FIND('-') THEN BEGIN
      IF (Amount>=10000)  AND (Amount<50000) THEN
      ChargeAmount:=Charges."between 10000 and 50000";
      //MESSAGE('szsdfsd');
       IF  (Amount>=50001) AND (Amount<=100000) THEN
      ChargeAmount:=Charges."between 50001 and 100000";
      //MESSAGE('szsdfsd');
       IF (Amount>=100001) AND (Amount<=200000) THEN
      ChargeAmount:=Charges."between 100001 and 200000";
      //MESSAGE('szsdfsd');
      IF (Amount>=200001) AND (Amount<=500000) THEN
      ChargeAmount:=Charges."between 200001 and  500000";
      //MESSAGE('szsdfsd');
       IF (Amount>=500001) AND (Amount<=1000000000000.0) THEN
      ChargeAmount:=Charges."greater than 500001";

      Echarge:=ChargeAmount;
      LineNo:=LineNo+1000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Bank Deposit charges';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='300-000-418';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      //IF Type='Cash Deposit' THEN
      IF "Transaction Type"='CW_WITH' THEN
      IF ChargeTransfer=TRUE THEN
      GenJournalLine.INSERT;

      END;
      //End post Bank Transfers

      //Charges
      TCharges:=0;

      //IF Amount < 20000 THEN BEGIN

      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      IF TransactionCharges."Charge Code"<>'009' THEN
      REPEAT

      LineNo:=LineNo+10000;

      ChargeAmount:=0;
      IF TransactionCharges."Use Percentage" = TRUE THEN
      ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      ELSE  ChargeAmount:=TransactionCharges."Charge Amount";
      IF "Account Type"='DIVIDEND' THEN BEGIN
      IF (Amount>=300)  AND (Amount<1000) THEN
      ChargeAmount:=160
      ELSE IF  (Amount>=1001) AND (Amount<2500) THEN
      ChargeAmount:=200
      ELSE IF (Amount>=2501) AND (Amount<5000) THEN
      ChargeAmount:=250
      ELSE IF (Amount>=50001) AND (Amount<100000) THEN
      ChargeAmount:=300
      ELSE IF (Amount>=10001) AND (Amount<200000) THEN
      ChargeAmount:=350
      ELSE IF Amount>200000 THEN
      ChargeAmount:=400
      END; //ELSE
      Echarge:=ChargeAmount;

      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=TransactionCharges.Description;//'Excise duty';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=TransactionCharges."G/L Account";//'200-000-168';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;

      UNTIL TransactionCharges.NEXT = 0
      END;
      counter:=0;

      //.................surestep
      // ChargeAmount:=0;
      // IF TransactionCharges."Use Percentage" = TRUE THEN
      // ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      // ELSE  ChargeAmount:=TransactionCharges."Charge Amount";
      // IF  "Transaction Type"='CW_WITH' THEN BEGIN



      ChargeAmount:=0;
      IF Type = 'Withdrawal' THEN BEGIN
      //IF ChargeTransfer=TRUE THEN

      Charges.RESET;
      Charges.SETRANGE(Charges.Description,'Cash Withdrawal Charges');
      IF Charges.FIND('-') THEN BEGIN
      IF (Amount>=100)  AND (Amount<=5000) THEN
      ChargeAmount:=Charges."Between 100 and 5000";

       IF  (Amount>=5001) AND (Amount<=10000) THEN
      ChargeAmount:=Charges."Between 5001 - 10000";

      IF (Amount>=10001) AND (Amount<=30000) THEN
        ChargeAmount:=Charges."Between 10001 - 30000";

      IF (Amount>=30001) AND (Amount<=50000) THEN
      ChargeAmount:=Charges."Between 30001 - 50000";

       IF (Amount>=50001) AND (Amount<=100000) THEN
      ChargeAmount:=Charges."Between 50001 - 100000";

       IF (Amount>=100001) AND (Amount<=200000) THEN
         ChargeAmount:=Charges."Between 100001 - 200000";

      IF (Amount>=200001) AND (Amount<=500000) THEN
       ChargeAmount:=Charges."Between 200001 - 500000";

      IF (Amount>=500001) AND (Amount<=100000000.0) THEN
        ChargeAmount:=Charges."Between 500001 Above";

      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Cash withdrawal charges ';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=ChargeAmount;//TransactionCharges."Charge Amount";

      MESSAGE('Your amount is %1 withdrawal charge is %2',Amount,ChargeAmount);

      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='300-000-405';//TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;

      //excise duty
      IF ChargeAmount>0 THEN BEGIN
      ExciseD:=0;
      ExciseD:=(ChargeAmount*(20/100));
      genSetup.GET();
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Excise Duty ';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=ExciseD;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=genSetup."Excise Duty Account";//'200-000-168';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ExciseD;
      END;
      //end exciseduty
      END;
      END;
      //Charge SMS Fee

      {IF Charges.GET('SMS') THEN BEGIN
      SMSFee:=0;
      SMSFee:=Charges."Charge Amount";
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='SMS Charge CW';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=SMSFee;

      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='300-000-055';//TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+SMSFee;
      END;}
      //End Charge SMS Fee

      // IF Type = 'Withdrawal' THEN BEGIN
      // LineNo:=LineNo+10000;
      // GenJournalLine.INIT;
      // GenJournalLine."Journal Template Name":='PURCHASES';
      // GenJournalLine."Journal Batch Name":='FTRANS';
      // GenJournalLine."Document No.":=No;
      // GenJournalLine."Line No.":=LineNo;
      // GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      // GenJournalLine."Account No.":="Account No";
      // IF "Account No"='00-0000000000' THEN
      // GenJournalLine."External Document No.":="ID No";
      // GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      // GenJournalLine."Posting Date":="Transaction Date";
      // GenJournalLine.Description:='Cash withdrawal charges ';
      // GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      // GenJournalLine.Amount:=0;//TransactionCharges."Charge Amount";
      // //MESSAGE('Your amount is %1',TransactionCharges."Charge Amount");
      // GenJournalLine.VALIDATE(GenJournalLine.Amount);
      // GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      // GenJournalLine."Bal. Account No.":='300-000-405';//TransactionCharges."G/L Account";
      // GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      // GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      // GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      // GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      // IF GenJournalLine.Amount<>0 THEN
      // GenJournalLine.INSERT;
      //
      // TChargeAmount:=TChargeAmount+ChargeAmount;
      // END;

      //END;

      //credit bank


      //credit bank

      //Charge withdrawal Freq
      IF Type = 'Withdrawal' THEN BEGIN
      IF Account.GET("Account No") THEN BEGIN
      IF AccountTypes.GET(Account."Account Type") THEN BEGIN
      IF Account."Last Withdrawal Date" = 0D THEN BEGIN
      Account."Last Withdrawal Date":=TODAY;
      Account.MODIFY;
      END ELSE BEGIN
      IF CALCDATE(AccountTypes."Withdrawal Interval",Account."Last Withdrawal Date") > TODAY THEN BEGIN
      //IF CALCDATE(AccountTypes."Withdrawal Interval",Account."Last Withdrawal Date") <= CALCDATE('1D',TODAY) THEN BEGIN

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Commision on Withdrawal Freq.';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=AccountTypes."Withdrawal Penalty";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=AccountTypes."Withdrawal Interval Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      END;
      Account."Last Withdrawal Date":=TODAY;
      Account.MODIFY;

      END;
      END;
      END;

      //NON-CUSTOMER CHARGE
      IF "Account No" = '507-10000-00' THEN;
      //NON-CUSTOMER CHARGE

      END;
      //Charge withdrawal Freq


      //Charge 2% commisio
      IF Overdraft = TRUE THEN BEGIN
      IF "Transacting Branch" = 'MBSA' THEN BEGIN

      IF Type = 'Withdrawal' THEN BEGIN
      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Commision on Overdraft';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=Amount*0.07;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='100005';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      END;

      END;
      END;

      //BOSA Entries
      //IF Type = 'Cash Deposit' THEN BEGIN
      IF ("Account No" = '502-00-000300-00') OR ("Account No" = '502-00-000303-00') THEN
      PostBOSAEntries();
      //END;


      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
      END;
      //Post New


      "Transaction Available Balance":=AvailableBalance;

      Posted:=TRUE;
      Authorised:=Authorised::Yes;
      "Supervisor Checked":=TRUE;
      "Needs Approval":="Needs Approval"::No;
      "Frequency Needs Approval":="Frequency Needs Approval"::No;
      "Date Posted":=TODAY;
      "Time Posted":=TIME;
      "Posted By":=USERID;
      MODIFY;

      //Create Audit Entry
      IF Trail.FINDLAST THEN
      BEGIN
      EntryNo:=Trail."Entry No"+1;
      END ELSE BEGIN
      EntryNo:=1;
      END;
      AuditTrail.FnInsertAuditRecords(EntryNo,USERID,"Transaction Type",Amount,
      'CASHIER TRANS',TODAY,TIME,'',No,"Account No",'');
      //End Create Audit Entry
      //SMS MESSAGE
            SMSMessage.RESET;
            IF SMSMessage.FIND('+') THEN BEGIN
            iEntryNo:=SMSMessage."Entry No";
            iEntryNo:=iEntryNo+1;
            END
            ELSE BEGIN
            iEntryNo:=1;
            END;

      //SMS
      Vend1.RESET;
      Vend1.SETRANGE(Vend1."No.","Account No");
      IF Vend1.FIND('-') THEN BEGIN
          TransDesc := '';
          TransTypes.RESET;
          TransTypes.SETRANGE(TransTypes.Code,"Transaction Type");
          IF TransTypes.FIND('-') THEN BEGIN
            TransDesc := TransTypes.Description;
          END;
          //SMS MESSAGE//here
          IF  Vend1."Phone No."<>'' THEN BEGIN
            PhoneNumber:= Vend1."Phone No.";
          END ELSE BEGIN
            PhoneNumber:=Vend1."MPESA Mobile No";
          END;

          IF TransDesc='Cash Deposit' THEN BEGIN
              msg:='Dear '   +FORMAT(Vend1.Name)+ '  You have Deposited Cash of KSHS. '+FORMAT(Amount)+' on '+FORMAT(TODAY) +' '
              +FORMAT(TIME)+' at TELEPOST SACCO. Tel. 0205029200. REF:'+No;

              SkyMbanking.SendSms(Source::TELLER_CASH_DEPOSIT,PhoneNumber,msg,Vend1."No.",'',TRUE,205,TRUE);
          END ELSE BEGIN
              msg:='Dear  ' +FORMAT(Vend1.Name)+' You have done a Cash Withdrawal of KSHS. '+FORMAT(Amount)+' on '+FORMAT(TODAY) +' '
              +FORMAT(TIME)+' at TELEPOST SACCO. Tel. 0205029200. REF:'+No;

              SkyMbanking.SendSms(Source::TELLER_CASH_WITHDRAWAL,PhoneNumber,msg,Vend1."No.",'',TRUE,205,TRUE);
          END;

      //       SMSMessage.RESET;
      //       SMSMessage.INIT;
      //       SMSMessage."Entry No":=iEntryNo;
      //       IF  Vend1."Phone No."<>'' THEN BEGIN
      //       SMSMessage."Telephone No":= Vend1."Phone No.";
      //       END ELSE BEGIN
      //        SMSMessage."Telephone No":=Vend1."MPESA Mobile No";
      //       END;
      //       SMSMessage."Account No":=Vend1."No.";
      //       SMSMessage."Date Entered":=TODAY;
      //       SMSMessage."Time Entered":=TIME;
      //       SMSMessage.Source:='OTC SMS';
      //       SMSMessage."Entered By":=USERID;
      //       SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      //       IF Amount<>0 THEN BEGIN
      //        IF TransDesc='Cash Deposit' THEN BEGIN
      //       SMSMessage."SMS Message":='Dear '   +FORMAT(Vend1.Name)+ '  You have Deposited Cash of KSHS. '+FORMAT(Amount)+
      //                                 ' on '+FORMAT(TODAY) + ' ' +FORMAT(TIME)+' at TELEPOST SACCO SOCIETY Head office.Tel. 0205029200. REF:'+No;
      //         END ELSE BEGIN
      //       SMSMessage."SMS Message":='Dear  ' +FORMAT(Vend1.Name)+' You have done a Cash Withdrawal of KSHS. '+FORMAT(Amount)+
      //                                 ' on '+FORMAT(TODAY) + ' ' +FORMAT(TIME)+' at TELEPOST SACCO SOCIETY Head office. Tel. 0205029200. REF:'+No;
      //         END;
      //       END;
      //       SMSMessage.INSERT;
      //END;
      END;
    END;

    LOCAL PROCEDURE PostMpesaEntries@1120054008();
    BEGIN
      CalcAvailableBal;




      IF AvailableBalance < Amount THEN BEGIN
      IF Authorised=Authorised::Yes THEN BEGIN
      Overdraft:=TRUE;
      MODIFY;
      END;

      IF Authorised=Authorised::No THEN BEGIN
      IF "Branch Transaction" = FALSE THEN BEGIN
      "Authorisation Requirement":='Over draft';
      MODIFY;
      MailContent:='Withdrawal transaction' + 'TR. No.'+' '+No+' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'needs your approval';
       SendEmail;
      MESSAGE('You cannot withdraw more than the available balance unless authorised.');

      EXIT;
      END;
      IF Authorised = Authorised::Rejected THEN
      ERROR('Transaction has been rejected and therefore cannot proceed.');

      END;
      END;

      TillNo:='';
      TellerTill.RESET;
      TellerTill.SETRANGE(TellerTill."Account Type",TellerTill."Account Type"::Cashier);
      TellerTill.SETRANGE(TellerTill.CashierID,USERID);
      IF TellerTill.FIND('-') THEN BEGIN
      TillNo:=TellerTill."No.";
      TellerTill.CALCFIELDS(TellerTill.Balance);

      IF Authorised = Authorised::Rejected THEN
       //SendEmail;
      ERROR('Transaction has been rejected therefore you cannot proceed.');




      IF TillNo = '' THEN

      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      GenJournalLine.DELETEALL;
      //Debit vendor
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=No;
      IF ("Transaction Type" = 'BOSA') OR ("Transaction Type" = 'Encashment') THEN
      GenJournalLine."External Document No.":="BOSA Account No";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      IF ("Transaction Type" = 'BOSA') OR ("Transaction Type" = 'Encashment') THEN
      GenJournalLine.Description:=Payee
      ELSE BEGIN
      IF "Branch Transaction" = TRUE THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      ELSE
      GenJournalLine.Description:=Type + '-' + Description;
      END;
      //Project Accounts
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc."Account Category" = Acc."Account Category"::Project THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      END;
      //Project Accounts

      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      IF (Type='Cash Deposit') OR (Type='BOSA Receipt') THEN
      GenJournalLine.Amount:=-Amount
      ELSE
      GenJournalLine.Amount:=Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
      GenJournalLine."Bal. Account No.":=TillNo;
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      //end Debit vendor



      //credit bank
      LineNo:=LineNo+10000;
      "Bank Account":='BNK00013';
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=No;
      //IF ("Transaction Type" = 'BOSA') OR ("Transaction Type" = 'Encashment') THEN
      //GenJournalLine."External Document No.":="BOSA Account No";
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":="Bank Account";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      IF ("Transaction Type" = 'BOSA') OR ("Transaction Type" = 'Encashment') THEN
      GenJournalLine.Description:='Bank'

      ELSE BEGIN
      IF "Branch Transaction" = TRUE THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      ELSE
      GenJournalLine.Description:='Mpesa Bulk payment';//Type + '-' + Description;
      END;
      //Project Accounts
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc."Account Category" = Acc."Account Category"::Project THEN
      GenJournalLine.Description:="Transaction Type" + '-' + "Branch Refference"
      END;
      //Project Accounts

      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      IF (Type='Cash Deposit') OR (Type='BOSA Receipt') THEN
      GenJournalLine.Amount:=-Amount
      ELSE
      GenJournalLine.Amount:=-Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
      GenJournalLine."Bal. Account No.":=TillNo;
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      //credit bank
      IF (Acc."Mobile Phone No"<>'') THEN BEGIN
          //Sms.SendSms('Withrawal',Acc."Mobile Phone No",'You have made a cash withdrawal of '+FORMAT(Amount) +'. TELEPOST SACCO',Acc."No.");

      END;

      //Charges
      TCharges:=0;

      //IF Amount < 20000 THEN BEGIN
      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      IF TransactionCharges."Charge Code"<>'009' THEN
      REPEAT

      LineNo:=LineNo+10000;
      ChargeAmount:=0;
      IF TransactionCharges."Use Percentage" = TRUE THEN
      ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      ELSE  ChargeAmount:=TransactionCharges."Charge Amount";
      IF  "Transaction Type"='MPESA' THEN BEGIN
      IF (Amount>=1)  AND (Amount<1000) THEN
      ChargeAmount:=50
      ELSE IF  (Amount>=1000) AND (Amount<=2500) THEN
      ChargeAmount:=70
      ELSE IF (Amount>=2501) AND (Amount<7500) THEN
      ChargeAmount:=100
      ELSE IF (Amount>=7501) AND (Amount<=10000) THEN
      ChargeAmount:=120
      ELSE IF (Amount>=10001) AND (Amount<=25000) THEN
      ChargeAmount:=150
      ELSE IF (Amount>=25001) AND (Amount<=50000) THEN
      ChargeAmount:=200
      // ELSE IF (Amount>=50001) AND (Amount<=70000) THEN
      // ChargeAmount:=250
      ELSE IF Amount>50000 THEN
      ChargeAmount:=250
      END; //ELSE

      Echarge:=ChargeAmount;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Bulk payment Commission';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //IF (TransactionCharges."Charge Code",'<>SD') AND (Amount > 20000)  THEN
      //ChargeAmount:=200 ELSE
      GenJournalLine.Amount:=ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='';//TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;
      //END;
      //END
      UNTIL TransactionCharges.NEXT = 0;

      //END;


      //credit gl account
      LineNo:=LineNo+1000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No.":='300-000-416';
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Bulk payment Commission';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //IF (TransactionCharges."Charge Code",'<>SD') AND (Amount > 20000)  THEN
      //ChargeAmount:=200 ELSE
      GenJournalLine.Amount:=-ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='';//TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;
      //end credit gl account;
      //END;

      //mpesa Cba charges
      LineNo:=LineNo+10000;

      ChargeAmount:=0;
      IF TransactionCharges."Use Percentage" = TRUE THEN
      ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      ELSE  ChargeAmount:=TransactionCharges."Charge Amount";
      IF  "Transaction Type"='MPESA' THEN BEGIN
      IF (Amount>=1)  AND (Amount<1000) THEN
      ChargeAmount:=16
      ELSE IF  (Amount>=1000) AND (Amount<=2500) THEN
      ChargeAmount:=23
      ELSE IF (Amount>=2501) AND (Amount<=7500) THEN
      ChargeAmount:=23
      ELSE IF (Amount>=7501) AND (Amount<=10000) THEN
      ChargeAmount:=23
      ELSE IF (Amount>=10001) AND (Amount<=15000) THEN
      ChargeAmount:=23
      ELSE IF (Amount>=15001) AND (Amount<=20000) THEN
      ChargeAmount:=23
      ELSE IF (Amount>=20001) AND (Amount<=70000) THEN
      ChargeAmount:=23
      ELSE IF Amount>70000 THEN
      ChargeAmount:=23;


      LineNo:=LineNo+1000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Bulk payment charges';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //IF (TransactionCharges."Charge Code",'<>SD') AND (Amount > 20000)  THEN
      //ChargeAmount:=200 ELSE
      GenJournalLine.Amount:=ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Member;
      GenJournalLine."Bal. Account No.":='';//TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      //end debit member

      //credit bank
      LineNo:=LineNo+1000;
      //"Account No":='BNK00013';
      Echarge:=ChargeAmount;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":='BNK00013';
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Bulk payment charges';//TransactionCharges.Description;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //IF (TransactionCharges."Charge Code",'<>SD') AND (Amount > 20000)  THEN
      //ChargeAmount:=200 ELSE
      GenJournalLine.Amount:=-ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='';//TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;
      //END;
      //END;
      //UNTIL TransactionCharges.NEXT = 0;
      END;
      // end mpesa Cba charges




      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      TransactionCharges.SETRANGE(TransactionCharges."Charge Code",'EXCISE');
      IF TransactionCharges.FIND('-') THEN BEGIN
      //IF TransactionCharges."Charge Code"='0001' THEN

      //Charges
       Excise:=0;
      //Excise Duty
      //genSetup.GET(0);
      Excise:=TransactionCharges."Charge Amount";
      //MESSAGE('Excise is %1',Echarge);
      {IF Account.GET("Account No") THEN BEGIN
      IF Account."Staff Account"=TRUE THEN BEGIN}

      LineNo:=LineNo+10000;
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Excise Duty2';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=(Excise*(genSetup."Excise Duty(%)"/100));
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=genSetup."Excise Duty Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;
      END;

      //END;
      //END;
      //ABOVE 20K
      //Charges
      TCharges:=0;
      //IF Amount > 20000 THEN BEGIN

      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      TransactionCharges.SETRANGE(TransactionCharges."Charge Code",'CD');
      IF TransactionCharges.FIND('-') THEN BEGIN
      //REPEAT
      LineNo:=LineNo+10000;

      LineNo:=LineNo+10000;

      ChargeAmount:=2;

      {IF Account.GET("Account No") THEN BEGIN
      IF Account."Staff Account"= FALSE THEN BEGIN}
      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Stamp Duty';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='2-10-000193';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      //GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;

      //UNTIL TransactionCharges.NEXT = 0;
      //END;
      //END;
      //Charges
      END;

      //Commission on FOSA overdraft
      IF Authorised=Authorised::Yes THEN
        BEGIN

      IF Account.GET("Account No") THEN BEGIN
      Account.CALCFIELDS(Account.Balance,Account."Uncleared Cheques",Account."ATM Transactions",Account."Coop Transaction");
      AccountBalance:=Account.Balance;
      AccountTypes.RESET;
      AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      IF AccountTypes.FIND('-') THEN BEGIN
      MinAccBal:=AccountTypes."Minimum Balance";
      FeeBelowMinBal:=AccountTypes."Fee Below Minimum Balance";
      END;
      END;

      TransactionAmount:=AccountBalance-(FeeBelowMinBal+Amount);
      IF (TransactionAmount<=0) THEN BEGIN
          genSetup.GET(0);
          LineNo:=LineNo+10000;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='PURCHASES';
          GenJournalLine."Journal Batch Name":='FTRANS';
          GenJournalLine."Document No.":=No;
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
          GenJournalLine."Account No.":="Account No";
          IF "Account No"='00-0000000000' THEN
          GenJournalLine."External Document No.":="ID No";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Posting Date":="Transaction Date";
          GenJournalLine.Description:='Commission on FOSA overdraft';
          GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
          GenJournalLine.Amount:=((Amount*7)/100);
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
          GenJournalLine."Bal. Account No.":=genSetup."Commission on FOSA Overdraft";
          GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
          GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
          GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;
        END;
      END;


      //ABOVE 20K
      //Charge withdrawal Freq
      IF Type = 'Withdrawal' THEN BEGIN
      IF Account.GET("Account No") THEN BEGIN
      IF AccountTypes.GET(Account."Account Type") THEN BEGIN
      IF Account."Last Withdrawal Date" = 0D THEN BEGIN
      Account."Last Withdrawal Date":=TODAY;
      Account.MODIFY;
      END ELSE BEGIN
      IF CALCDATE(AccountTypes."Withdrawal Interval",Account."Last Withdrawal Date") > TODAY THEN BEGIN
      //IF CALCDATE(AccountTypes."Withdrawal Interval",Account."Last Withdrawal Date") <= CALCDATE('1D',TODAY) THEN BEGIN
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Commision on Withdrawal Freq.';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=AccountTypes."Withdrawal Penalty";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=AccountTypes."Withdrawal Interval Account";
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      END;
      Account."Last Withdrawal Date":=TODAY;
      Account.MODIFY;

      END;
      END;
      END;

      //NON-CUSTOMER CHARGE
      IF "Account No" = '507-10000-00' THEN;
      //NON-CUSTOMER CHARGE

      END;
      //Charge withdrawal Freq


      //Charge 2% commisio
      IF Overdraft = TRUE THEN BEGIN
      IF "Transacting Branch" = 'MBSA' THEN BEGIN
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF "Account No"='00-0000000000' THEN
      GenJournalLine."External Document No.":="ID No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:='Commision on Overdraft';
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=Amount*0.07;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":='100005';
      GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      END;
      END;
      END;
      //BOSA Entries
      //IF Type = 'Cash Deposit' THEN BEGIN
      IF ("Account No" = '502-00-000300-00') OR ("Account No" = '502-00-000303-00') THEN
      PostBOSAEntries();
      //END;


      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
      END;
      //Post New
      END;

      "Transaction Available Balance":=AvailableBalance;
      Posted:=TRUE;
      Authorised:=Authorised::Yes;
      "Supervisor Checked":=TRUE;
      "Needs Approval":="Needs Approval"::No;
      "Frequency Needs Approval":="Frequency Needs Approval"::No;
      "Date Posted":=TODAY;
      "Time Posted":=TIME;
      "Posted By":=USERID;
      MODIFY;
    END;

    LOCAL PROCEDURE CheckRequiredItems@2();
    BEGIN
    END;

    PROCEDURE PostEncashmentOthers@1120054000();
    BEGIN
      //Block Payments
      IF Acc.GET("Account No") THEN BEGIN
      IF Acc.Blocked = Acc.Blocked::Payment THEN
      ERROR('This account has been blocked from receiving payments.');
      END;


      CalcAvailableBal;

      //Check withdrawal limits
      IF Type = 'Encashment' THEN BEGIN
      IF AvailableBalance < Amount THEN BEGIN
      IF Authorised=Authorised::Yes THEN BEGIN
      Overdraft:=TRUE;
      MODIFY;
      END;

      IF Authorised=Authorised::No THEN BEGIN
      "Authorisation Requirement":='Encashment - Over draft';
      MODIFY;
      MESSAGE('You cannot issue an encashment more than the available balance unless authorised.');
      MailContent:='Withdrawal transaction' + 'TR. No.'+' '+No+' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'needs your authorization';
      SendEmail;

      //SendEmail;
      EXIT;
      END;
      IF Authorised = Authorised::Rejected THEN BEGIN
      MailContent:='Bankers cheque transaction' + ' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'needs your approval';
      SendEmail;
      ERROR('Transaction has been rejected and therefore cannot proceed.');

      END;
      END;
      END;
      //Check withdrawal limits



      //Check Teller Balances
      //ADDED DActivity:='';
      //ADDED DBranch:='';

      TillNo:='';
      TellerTill.RESET;
      TellerTill.SETRANGE(TellerTill."Account Type",TellerTill."Account Type"::Cashier);
      TellerTill.SETRANGE(TellerTill."Cashier ID",USERID);
      IF TellerTill.FIND('-') THEN BEGIN
      //ADDED DActivity:=TellerTill."Global Dimension 1 Code";
      //ADDED DBranch:=TellerTill."Global Dimension 2 Code";
      TillNo:=TellerTill."No.";
      TellerTill.CALCFIELDS(TellerTill.Balance);

      CurrentTellerAmount:=TellerTill.Balance;

      IF CurrentTellerAmount-Amount<=TellerTill."Min. Balance" THEN
      MESSAGE('You need to add more money from the treasury since your balance has gone below the teller replenishing level.');

      IF ("Transaction Type" = 'Withdrawal') OR ("Transaction Type" = 'Encashment') THEN BEGIN
      IF (CurrentTellerAmount - Amount) < 0 THEN
      ERROR('You do not have enough money to carry out this transaction.');

      END;

      IF ("Transaction Type" = 'Withdrawal') OR ("Transaction Type" = 'Encashment') THEN BEGIN
      IF CurrentTellerAmount - Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');

      END ELSE BEGIN
      IF CurrentTellerAmount + Amount>=TellerTill."Maximum Teller Withholding" THEN
      MESSAGE('You need to transfer money back to the treasury since your balance has gone above the teller maximum withholding.');
      END;


      END;

      IF TillNo = '' THEN
      ERROR('Teller account not set-up.');

      //Check Teller Balances




      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      GenJournalLine.DELETEALL;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      GenJournalLine."Account No.":="Account No";
      IF ("Account No"='00-0000003000') OR  ("Account No"='00-0200003000') THEN
      GenJournalLine."External Document No.":="ID No";

      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Charges
      TCharges:=0;
      //ADDED
      TChargeAmount:=0;


      TransactionCharges.RESET;
      TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
      IF TransactionCharges.FIND('-') THEN BEGIN
      REPEAT
      LineNo:=LineNo+10000;

      ChargeAmount:=0;
      IF TransactionCharges."Use Percentage" = TRUE THEN
      ChargeAmount:=(Amount*TransactionCharges."Percentage of Amount")*0.01
      ELSE
      ChargeAmount:=TransactionCharges."Charge Amount";

      IF (TransactionCharges."Minimum Amount" <> 0) AND (ChargeAmount < TransactionCharges."Minimum Amount") THEN
      ChargeAmount := TransactionCharges."Minimum Amount";

      IF (TransactionCharges."Maximum Amount" <> 0) AND (ChargeAmount > TransactionCharges."Maximum Amount") THEN
      ChargeAmount := TransactionCharges."Maximum Amount";



      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
      GenJournalLine."Account No.":=TransactionCharges."G/L Account";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-ChargeAmount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      TChargeAmount:=TChargeAmount+ChargeAmount;

      UNTIL TransactionCharges.NEXT = 0;
      END;

      //Charges


      //Teller Entry
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="ID No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=TillNo;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-(Amount-TChargeAmount);
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::Codeunit50013,GenJournalLine);
      END;

      //Post New


      "Transaction Available Balance":=AvailableBalance;
      Posted:=TRUE;
      Authorised:=Authorised::Yes;
      "Supervisor Checked":=TRUE;
      "Needs Approval":="Needs Approval"::No;
      "Frequency Needs Approval":="Frequency Needs Approval"::No;
      "Date Posted":=TODAY;
      "Time Posted":=TIME;
      "Posted By":=USERID;
      MODIFY;
      //Create Audit Entry
      IF Trail.FINDLAST THEN
      BEGIN
      EntryNo:=Trail."Entry No"+1;
      END ELSE BEGIN
      EntryNo:=1;
      END;
      AuditTrail.FnInsertAuditRecords(EntryNo,USERID,"Transaction Type",Amount,
      'CASHIER TRANS',TODAY,TIME,'',No,"Account No",'');
      //End Create Audit Entry
    END;

    BEGIN
    END.
  }
}

