OBJECT page 17443 Teller & Treasury Trans Card
{
  OBJECT-PROPERTIES
  {
    Date=02/10/22;
    Time=[ 4:36:34 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516301;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Transacting Branch",UsersID.Branch);
                 END;
                 }

                 {
                 IF Posted= TRUE THEN
                 CurrPage.EDITABLE:=FALSE
                 }
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000023;1 ;Action    ;
                      CaptionML=ENU=Issue/Return;
                      Promoted=Yes;
                      Image=Interaction;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //TESTFIELD(Amount);
                                 TESTFIELD("From Account");
                                 TESTFIELD("To Account");
                                 Coinage.RESET;
                                 Coinage.SETRANGE(Coinage.No,No);
                                 IF Coinage.FIND('-') THEN BEGIN
                                 CALCFIELDS("Total Cash on Treasury Coinage");
                                 IF Amount<>"Total Cash on Treasury Coinage" THEN
                                 ERROR('Amount must be equal before performing this operation');
                                 //Amount:="Total Cash on Treasury Coinage";
                                 //MODIFY;
                                 END;

                                 IF ("Transaction Type" ="Transaction Type"::"Issue To Teller") OR
                                 ("Transaction Type"="Transaction Type"::"Issue To Teller") OR
                                 ("Transaction Type"="Transaction Type"::"Return To Treasury") OR
                                 ("Transaction Type"="Transaction Type"::"Inter Teller Transfers") OR
                                 ("Transaction Type"="Transaction Type"::"Branch Treasury Transactions")
                                  THEN BEGIN
                                 {IF requested=FALSE THEN
                                 ERROR('You can not issue what has not been requested');}

                                 IF Issued=Issued::Yes THEN
                                 ERROR('The money has already been issued.');

                                 TellerTill.RESET;
                                 TellerTill.SETRANGE(TellerTill."No.","From Account");
                                 IF TellerTill.FIND('-') THEN BEGIN
                                 IF UPPERCASE(USERID) <> TellerTill.CashierID THEN
                                 ERROR('You do not have permission to transact on this teller till/Account.');
                                 END;


                                 Banks.RESET;
                                 Banks.SETRANGE(Banks."No.","From Account");
                                 IF Banks.FIND('-') THEN BEGIN
                                 Banks.CALCFIELDS(Banks."Balance (LCY)");
                                 BankBal:=Banks."Balance (LCY)";
                                 IF Amount>BankBal THEN BEGIN
                                 ERROR('You cannot issue more than the account balance.')
                                 END;
                                 END;

                                 IF CONFIRM('Are you sure you want to make this issue?',FALSE) = TRUE THEN BEGIN
                                 Issued:=Issued::Yes;
                                 "Date Issued":=TODAY;
                                 "Time Issued":=TIME;
                                 "Issued By":=UPPERCASE(USERID);
                                 MODIFY;
                                  SENDMAIL;
                                 END;
                                  //SENDMAIL;

                                 IF ("Transaction Type"="Transaction Type"::"Issue To Teller") OR ("Transaction Type"="Transaction Type"::"Issue From Bank")
                                 OR ("Transaction Type"="Transaction Type"::"Issue To Teller") OR ("Transaction Type"="Transaction Type"::"Inter Teller Transfers") THEN
                                 MESSAGE('Money successfully issued.')
                                 ELSE
                                 MESSAGE('Money successfully Returned.')
                                 END ELSE BEGIN
                                 IF "Transaction Type" = "Transaction Type"::"Return To Bank" THEN BEGIN
                                 TESTFIELD(Amount);
                                 TESTFIELD("From Account");
                                 TESTFIELD("To Account");


                                 Banks.RESET;
                                 Banks.SETRANGE(Banks."No.","From Account");
                                 IF Banks.FIND('-') THEN BEGIN
                                 Banks.CALCFIELDS("Balance (LCY)");
                                 IF Amount > Banks."Balance (LCY)" THEN
                                 ERROR('You cannot receive more than balance in ' + "From Account")
                                 END;

                                 IF CONFIRM('Are you sure you want to make this return?',FALSE) = FALSE THEN
                                 EXIT;

                                 //Delete any items present
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 IF DefaultBatch.GET('GENERAL','FTRANS') = FALSE THEN BEGIN
                                 DefaultBatch.INIT;
                                 DefaultBatch."Journal Template Name":='GENERAL';
                                 DefaultBatch.Name:='FTRANS';
                                 DefaultBatch.INSERT;
                                 END;


                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Line No.":=10000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="From Account";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:=Description;
                                 GenJournalLine."Currency Code":="Currency Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Bal. Account No.":="To Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine.Amount <> 0 THEN
                                 GenJournalLine.INSERT;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);



                                 //GenJournalLine.RESET;
                                 //GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'GENERAL');
                                 //GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 //IF GenJournalLine.FIND('-') = FALSE THEN BEGIN
                                 Posted:=TRUE;
                                 "Date Posted":=TODAY;
                                 "Time Posted":=TIME;
                                 "Posted By":=UPPERCASE(USERID);

                                 Received:=Received::Yes;
                                 "Date Received":=TODAY;
                                 "Time Received":=TIME;
                                 MODIFY;


                                 //END;


                                 END ELSE
                                 MESSAGE('Only applicable for teller, treasury & Bank Issues/Returns.');

                                 END;
                               END;
                                }
      { 1000000022;1 ;Action    ;
                      CaptionML=ENU=Receive;
                      Promoted=Yes;
                      Image=ReceiveLoaner;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD(Amount);
                                 TESTFIELD("From Account");
                                 TESTFIELD("To Account");
                                 IF "Transaction Type"<>"Transaction Type"::"Issue From Bank" THEN BEGIN
                                 TESTFIELD("Issued By");
                                   END;
                                 IF "Issued By"=USERID THEN
                                   ERROR('You cannot issue and receive funds at the same time');

                                 Approved:=TRUE;
                                 GenSetup.GET;

                                 IF "Transaction Type"="Transaction Type"::"Issue From Bank" THEN
                                 TESTFIELD("Cheque No.");

                                 CurrentTellerAmount:=0;
                                 IF Posted=TRUE THEN
                                 ERROR('The transaction has already been received and posted.');

                                 IF "Transaction Type" = "Transaction Type"::"Inter Teller Transfers" THEN BEGIN
                                 IF Approved = FALSE THEN
                                 ERROR('Inter Teller Transfers must be approved.');
                                 END;

                                 //IF ("Transaction Type"="Transaction Type"::"Return To Treasury") THEN
                                 //ERROR('The issue has not yet been made and therefore you cannot continue with this transaction.');

                                 IF ("Transaction Type"="Transaction Type"::"Issue To Teller") OR
                                 ("Transaction Type"="Transaction Type"::"Branch Treasury Transactions") OR
                                 ("Transaction Type"="Transaction Type"::"Inter Teller Transfers") THEN BEGIN
                                 IF Issued=Issued::No THEN
                                 ERROR('The issue has not yet been made and therefore you cannot continue with this transaction.');

                                 TellerTill.RESET;
                                 //TellerTill.SETRANGE(TellerTill."Account Type",TellerTill."Account Type"::Cashier);
                                 TellerTill.SETRANGE(TellerTill."No.","To Account");
                                 IF TellerTill.FIND('-') THEN BEGIN
                                 IF UPPERCASE(USERID) <> TellerTill.CashierID THEN
                                 ERROR('You do not have permission to transact on this teller till/Account.');

                                 TellerTill.CALCFIELDS(TellerTill.Balance);
                                 CurrentTellerAmount:=TellerTill.Balance;
                                 IF CurrentTellerAmount+Amount>TellerTill."Maximum Teller Withholding" THEN
                                 ERROR('The transaction will result in the teller having a balance more than the maximum allowable therefor terminated.');

                                 END;
                                 END;

                                 {//POLICE
                                 Banks.RESET;
                                 Banks.SETRANGE(Banks."No.","From Account");
                                 IF Banks.FIND('-') THEN BEGIN
                                 Banks.CALCFIELDS("Balance (LCY)");
                                 IF Amount > Banks."Balance (LCY)" THEN
                                 ERROR('You cannot receive more than balance in ' + "From Account")
                                 END;
                                 }//POLICE

                                 IF CONFIRM('Are you sure you want to make this receipt?',FALSE) = FALSE THEN
                                 EXIT;

                                 //Delete any items present
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 IF DefaultBatch.GET('GENERAL','FTRANS') = FALSE THEN BEGIN
                                 DefaultBatch.INIT;
                                 DefaultBatch."Journal Template Name":='GENERAL';
                                 DefaultBatch.Name:='FTRANS';
                                 DefaultBatch.INSERT;
                                 END;

                                 lines:=lines+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."Line No.":=lines;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="From Account";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:=Description;
                                 GenJournalLine."Currency Code":="Currency Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Bal. Account No.":="To Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine.Amount <> 0 THEN
                                 GenJournalLine.INSERT;
                                  {
                                 lines:=lines+10000;
                                 //Post shortages/Excess
                                 IF "Excess/Shortage Amount"<>0 THEN BEGIN
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."Line No.":=lines;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="From Account";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Excess/Shortages';
                                 GenJournalLine."Currency Code":="Currency Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:="Excess/Shortage Amount";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 IF "Excess/Shortage Amount">0 THEN
                                 GenJournalLine."Bal. Account No.":=GenSetup."Teller Shortage Account"
                                 ELSE GenJournalLine."Bal. Account No.":=GenSetup."Teller Excess Account";
                                 //GenJournalLine."Bal. Account No.":="To Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine.Amount <> 0 THEN
                                 GenJournalLine.INSERT;
                                 END;
                                 //Post shortages/Excess
                                   }

                                 //Post
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 GLPosting.RUN(GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;
                                 //Post

                                 //GenJournalLine.RESET;
                                 //GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'GENERAL');
                                 //GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 //IF GenJournalLine.FIND('-') = FALSE THEN BEGIN
                                 Posted:=TRUE;
                                 "Date Posted":=TODAY;
                                 "Time Posted":=TIME;
                                 "Posted By":=UPPERCASE(USERID);

                                 Received:=Received::Yes;
                                 "Date Received":=TODAY;
                                 "Time Received":=TIME;
                                 "Received By":=UPPERCASE(USERID);
                                 MODIFY;

                                 //END;
                               END;
                                }
      { 1000000021;1 ;Action    ;
                      CaptionML=ENU=EOD Report;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Trans.RESET;
                                 Trans.SETRANGE(Trans.No,No);
                                 //Trans.SETRANGE(Trans."Date Posted","Date Posted");
                                 IF Trans.FIND('-') THEN
                                 REPORT.RUN(51516430,TRUE,TRUE,Trans)
                               END;
                                }
      { 1000000020;1 ;Action    ;
                      CaptionML=ENU=SENDMAIL;
                      Promoted=Yes;
                      Visible=False;
                      PromotedCategory=Process;
                      OnAction=BEGIN


                                   SENDMAIL;
                               END;
                                }
      { 1000000019;1 ;Action    ;
                      Name=Approve;
                      CaptionML=ENU=Approve;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD("From Account");
                                 TESTFIELD("To Account");
                                 TESTFIELD(Amount);

                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Inter Teller Approval");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to approve inter teller transactions.');

                                 Approved:=TRUE;
                                 MODIFY;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000018;0;Container;
                ContainerType=ContentArea }

    { 1000000017;1;Group  ;
                CaptionML=ENU=General }

    { 1000000016;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1000000015;2;Field  ;
                SourceExpr="Transaction Type";
                Editable=TRUE }

    { 1000000014;2;Field  ;
                CaptionML=ENU=From;
                SourceExpr="From Account" }

    { 1000000013;2;Field  ;
                CaptionML=ENU=To;
                SourceExpr="To Account" }

    { 1000000012;2;Field  ;
                SourceExpr=Description;
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr=Naration }

    { 1   ;2   ;Field     ;
                CaptionML=ENU=Amount Requested;
                SourceExpr="Amount to request";
                Editable=false;
                OnValidate=BEGIN
                             IF "Amount to request"<1 THEN
                               ERROR('AMOUNT REQUESTED MUST BE GREATER THAN 1');
                           END;
                            }

    { 1000000011;2;Field  ;
                CaptionML=ENU=Amount to issue;
                SourceExpr=Amount }

    { 1000000010;2;Field  ;
                CaptionML=ENU=Cheque/Document No.;
                SourceExpr="Cheque No." }

    { 1000000009;2;Field  ;
                SourceExpr=Issued;
                Editable=FALSE }

    { 1000000008;2;Field  ;
                SourceExpr="Date Issued";
                Editable=FALSE }

    { 1000000007;2;Field  ;
                SourceExpr="Time Issued";
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr="Issued By";
                Editable=FALSE }

    { 1000000005;2;Field  ;
                SourceExpr=Received;
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr="Date Received" }

    { 1000000003;2;Field  ;
                SourceExpr="Time Received" }

    { 1000000002;2;Field  ;
                SourceExpr="Received By" }

    { 1000000001;2;Field  ;
                SourceExpr=Approved;
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1000000024;1;Part   ;
                SubPageLink=No=FIELD(No);
                PagePartID=Page51516485;
                PartType=Page }

  }
  CODE
  {
    VAR
      GenJournalLine@1000000003 : Record 81;
      DefaultBatch@1000000002 : Record 232;
      GLPosting@1000000001 : Codeunit 12;
      window@1000000000 : Dialog;
      CurrentTellerAmount@1000000007 : Decimal;
      TellerTill@1000000008 : Record 270;
      Banks@1000000009 : Record 270;
      BankBal@1000000010 : Decimal;
      TotalBal@1000000013 : Decimal;
      DenominationsRec@1000000012 : Record 51516303;
      TillNo@1102760000 : Code[20];
      Trans@1102760001 : Record 51516301;
      UsersID@1102760002 : Record 2000000120;
      StatusPermissions@1102760003 : Record 51516310;
      "Gen-Setup"@1102760008 : Record 51516257;
      SendToAddress@1102760006 : Text[30];
      BankAccount@1102760005 : Record 270;
      MailContent@1102760004 : Text[150];
      SenderName@1102760009 : Code[20];
      TreauryTrans@1102755000 : Record 51516301;
      Coinage@1102755001 : Record 51516302;
      GenSetup@1000000014 : Record 51516257;
      lines@1000000011 : Integer;
      MaxWithholding@1000000006 : Decimal;
      FrmAcc@1000000005 : Boolean;
      SMTPMAIL@1000000004 : Record 409;

    PROCEDURE SENDMAIL@1102760000();
    BEGIN
      //sent mail on authorisation
      {
      BankAccount.RESET;
      BankAccount.SETRANGE(BankAccount."No.","From Account");
      IF BankAccount.FIND('-') THEN BEGIN
      SenderName:=BankAccount.Name;
      END;

      BankAccount.RESET;
      BankAccount.SETRANGE(BankAccount."No.","To Account");
      IF BankAccount.FIND('-') THEN BEGIN
       MailContent:='You have received Kshs.'+' '+FORMAT(Amount)+' '+'from'+ ' '+SenderName+
       ' '+ 'the transaction type is' + ', '+ FORMAT("Transaction Type")+ ', ' +'TR.No' +' '+No+
       ' '+ 'Date'+ ' '+FORMAT("Transaction Date")+'.';

      REPEAT
      "Gen-Setup".GET();
      SMTPMAIL.NewMessage("Gen-Setup"."Sender Address",'TELLER & TEASURY TRANSACTIONS'+''+'');
      SMTPMAIL.SetWorkMode();
      SMTPMAIL.ClearAttachments();
      SMTPMAIL.ClearAllRecipients();
      SMTPMAIL.SetDebugMode();
      SMTPMAIL.SetFromAdress("Gen-Setup"."Sender Address");
      SMTPMAIL.SetHost("Gen-Setup"."Outgoing Mail Server");
      SMTPMAIL.SetUserID("Gen-Setup"."Sender User ID");
      SMTPMAIL.AddLine(MailContent);
      SendToAddress:=BankAccount."E-Mail";
      SMTPMAIL.SetToAdress(SendToAddress);
      SMTPMAIL.Send;
      UNTIL BankAccount.NEXT=0;
      END;
      }
    END;

    BEGIN
    END.
  }
}

