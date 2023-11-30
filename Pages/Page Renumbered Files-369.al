OBJECT page 50060 Teller & Treasury Trans Card2
{
  OBJECT-PROPERTIES
  {
    Date=02/10/22;
    Time=[ 4:29:38 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516301;
    SourceTableView=WHERE(requested=FILTER(No));
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
      { 7       ;1   ;Action    ;
                      Name=Request;
                      Promoted=Yes;
                      Image=Receive;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF requested=TRUE THEN
                                 ERROR('You have already requested for this funds');

                                 IF "Amount to request"=0 THEN
                                 ERROR('You cannot request a zero amount');

                                 Coinage.RESET;
                                 Coinage.SETRANGE(Coinage.No,No);
                                 IF Coinage.FIND('-') THEN BEGIN

                                   CALCFIELDS("Total Cash on Treasury Coinage");
                                 IF "Amount to request"<>"Total Cash on Treasury Coinage" THEN BEGIN
                                  // MESSAGE('amount is %1 and treasury is %2 and %3',"Amount to request",Coinage."Total Amount","Total Cash on Treasury Coinage");
                                   ERROR('Amount must be equal before performing this operation');
                                   END;
                                   END;
                                 //IF CONFIRM('Are you sure to request fot this funds',TRUE)=FALSE THEN
                                  // EXIT;
                                 requested:=TRUE;
                                 Requester:=USERID;
                                 "Requested Date":=TODAY;
                                 "Requested Time":=TIME;
                                 MODIFY
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
                Editable=false }

    { 8   ;2   ;Field     ;
                Name=Teller;
                CaptionML=ENU=Teller;
                SourceExpr="To Account" }

    { 1   ;2   ;Field     ;
                CaptionML=ENU=Amount to Request;
                SourceExpr="Amount to request" }

    { 3   ;2   ;Field     ;
                Name=Date Requested;
                CaptionML=ENU=Date Requested;
                SourceExpr="Requested Date";
                Editable=false }

    { 4   ;2   ;Field     ;
                Name=Time Requested;
                CaptionML=ENU=Time Requested;
                SourceExpr="Requested Time";
                Editable=false }

    { 1120054000;2;Field  ;
                SourceExpr="Transaction Date" }

    { 6   ;2   ;Field     ;
                Name=Requested;
                CaptionML=ENU=Requested;
                SourceExpr=requested;
                Enabled=false;
                Editable=false }

    { 5   ;1   ;Part      ;
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

