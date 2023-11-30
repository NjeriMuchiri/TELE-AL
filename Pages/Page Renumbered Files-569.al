OBJECT page 172164 Cheque Clearance
{
  OBJECT-PROPERTIES
  {
    Date=02/10/22;
    Time=[ 2:08:41 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516299;
    SourceTableView=WHERE(Posted=CONST(Yes),
                          Expected Maturity Date=FILTER(<>''),
                          Status=FILTER(Pending|Honoured),
                          Dont Clear=CONST(No),
                          Cheque Processed=CONST(No),
                          Cheque No=FILTER(<>''));
    PageType=List;
    OnOpenPage=BEGIN
                 //SETRANGE("Transaction Date",TODAY);
                 //SETRANGE(Cashier,USERID);
               END;

    ActionList=ACTIONS
    {
      { 1120054004;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054003;1 ;ActionGroup;
                      CaptionML=ENU=Banker Cheque }
      { 1120054002;2 ;Action    ;
                      CaptionML=ENU=Process Cheque;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PutawayLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CTrans@1120054000 : Record 51516299;
                                 Accounts@1120054001 : Record 23;
                               BEGIN
                                 {IF CONFIRM('Are you sure you want to Bank the selected cheques?',FALSE) = TRUE THEN BEGIN

                                 Transactions.RESET;
                                 Transactions.SETRANGE(Type,'Bankers Cheque');
                                 Transactions.SETRANGE(Transactions.Select,TRUE);
                                 //Transactions.SETRANGE(Transactions."Cheque Processed",Transactions."Cheque Processed"::"0");
                                 IF Transactions.FIND('-') THEN BEGIN
                                 REPEAT

                                 Transactions."Banked By":=USERID;
                                 Transactions."Date Banked":=TODAY;
                                 Transactions."Time Banked":=TIME;
                                 Transactions."Banking Posted":=TRUE;
                                 Transactions."Cheque Processed":=Transactions."Cheque Processed"::"1";
                                 Transactions.MODIFY;
                                 UNTIL Transactions.NEXT = 0;

                                 MESSAGE('The selected bankers cheques banked successfully.');

                                 END;
                                 END;}
                                 TESTFIELD("Reason For Approving/Bouncing");
                                 IF NOT CONFIRM('Are you sure that you have verified the cheque and are ready to clear them?',FALSE) THEN
                                   EXIT;

                                 CTrans.RESET;
                                 CTrans.SETFILTER("Expected Maturity Date",'<=%1',TODAY);
                                 CTrans.SETRANGE(Select,TRUE);
                                 CTrans.SETFILTER(Status,'%1|%2',CTrans.Status::Honoured,CTrans.Status::Pending);
                                 CTrans.SETRANGE("Cheque Processed",FALSE);
                                 //CTrans.SETRANGE(No,Rec.No);
                                 IF CTrans.FINDSET THEN BEGIN
                                      REPEAT

                                        WITH CTrans DO BEGIN

                                         GenJournalLine.RESET;
                                         GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                         GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                         GenJournalLine.DELETEALL;

                                         //Charges
                                         ChequeType.RESET;
                                         ChequeType.SETRANGE(ChequeType.Code,CTrans."Cheque Type");
                                         IF ChequeType.FIND('-') THEN BEGIN

                                             IF ChequeType."Use %" = TRUE THEN
                                             ChargeAmount:=((ChequeType."% Of Amount"*0.01)*CTrans.Amount)
                                             ELSE
                                             ChargeAmount:=ChequeType."Clearing Charges";


                                         //ChargeAmount:=Transactions.Amount*0.001;//0.01;


                                         {IF ChargeAmount < 100 THEN
                                         ChargeAmount:=100;}

                                         {IF ChargeAmount > 500 THEN
                                         ChargeAmount:=500;}
                                         //MESSAGE('Amount %1',ChargeAmount);
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
                                             GenJournalLine."Posting Date":="Expected Maturity Date";
                                             GenJournalLine.Description:='Cheque Clearing Charges';
                                             GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                             GenJournalLine.Amount:=ChargeAmount;
                                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                             GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                             GenJournalLine."Bal. Account No.":=ChequeType."Clearing Charges GL Account";
                                             GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                             GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                             GenJournalLine."Shortcut Dimension 2 Code":=CTrans."Transacting Branch";
                                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                             IF GenJournalLine.Amount<>0 THEN
                                             GenJournalLine.INSERT;

                                         //END;
                                         END;

                                         //Charges

                                           //RecoverDiscounting();

                                           GenJournalLine.RESET;
                                           GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                           GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                           IF GenJournalLine.FIND('-') THEN BEGIN
                                           REPEAT
                                           GLPosting.RUN(GenJournalLine);
                                           UNTIL GenJournalLine.NEXT = 0;
                                           END;


                                           GenJournalLine.RESET;
                                           GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                           GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                           GenJournalLine.DELETEALL;




                                         //END;
                                         CTrans."Cheque Processed":=TRUE;
                                         CTrans."Date Cleared":=TODAY;
                                         CTrans.Status:=CTrans.Status::Honoured;
                                         CTrans."Cheque Status.":=CTrans."Cheque Status."::Matured;
                                         CTrans.MODIFY;
                                         END;

                                         Vend.RESET;
                                         Vend.SETRANGE(Vend."No.","Account No");
                                         IF Vend.FINDFIRST THEN BEGIN
                                         MaturedMessage:='';
                                         MaturedMessage:='Dear '+Vend.Name+' your cheque no '+"Cheque No"+'of Ksh '+FORMAT(Amount)+'deposited on '+FORMAT("Transaction Date")+' has matured.Telepost Sacco.';
                                         SendSMS.FnSendMessageCD(Vend."BOSA Account No",MaturedMessage);
                                         END;
                                   UNTIL CTrans.NEXT = 0;
                                   MESSAGE('Cheques successfully processed');
                                 END ELSE
                                    MESSAGE('You have not selected');
                               END;
                                }
      { 1120054005;2 ;Action    ;
                      CaptionML=ENU=Reject Cheque;
                      Promoted=Yes;
                      PromotedIsBig=No;
                      Image=ReturnCustomerBill;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CTrans@1120054000 : Record 51516299;
                                 Acc@1120054001 : Record 23;
                               BEGIN
                                 TESTFIELD("Reason For Approving/Bouncing");
                                 IF NOT CONFIRM('Are you sure that you have verified the cheques and are ready to reject them?',FALSE) THEN
                                   EXIT;



                                 CTrans.RESET;
                                 CTrans.SETFILTER("Expected Maturity Date",'<=%1',TODAY);
                                 CTrans.SETRANGE(Select,TRUE);
                                 CTrans.SETFILTER(Status,'%1|%2',CTrans.Status::Honoured,CTrans.Status::Pending);
                                 CTrans.SETRANGE("Cheque Processed",FALSE);
                                 IF CTrans.FINDSET THEN BEGIN
                                      REPEAT
                                                WITH CTrans DO BEGIN
                                                     //ERROR('Branch not set.');
                                                       ChBank:=CTrans."Bank Code";
                                                 MESSAGE('bank account is %1',ChBank);

                                                 //IF ChequeType.GET("Cheque Type") THEN BEGIN


                                                       GenJournalLine.RESET;
                                                       GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                                       GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                                       GenJournalLine.DELETEALL;

                                                       LineNo:=LineNo+10000;

                                                       GenJournalLine.INIT;
                                                       GenJournalLine."Journal Template Name":='PURCHASES';
                                                       GenJournalLine."Journal Batch Name":='FTRANS';
                                                       GenJournalLine."Document No.":=CTrans.No;
                                                       GenJournalLine."External Document No.":=CTrans."Cheque No";
                                                       GenJournalLine."Line No.":=LineNo;
                                                       GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                                       GenJournalLine."Account No.":=CTrans."Account No";

                                                       GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                                       GenJournalLine."Posting Date":=CTrans."Expected Maturity Date";
                                                       IF "Branch Transaction" = TRUE THEN
                                                       GenJournalLine.Description:=PADSTR('Bounced Cheque: ' + "Transaction Type" + '-' + "Branch Refference",50)
                                                       ELSE
                                                       GenJournalLine.Description:=PADSTR('Bounced Cheque: ' +"Transaction Description" +'-'+ Description,50);
                                                       //Project Accounts
                                                       IF Acc.GET("Account No") THEN BEGIN
                                                       IF Acc."Account Category" = Acc."Account Category"::Project THEN
                                                       GenJournalLine.Description:=PADSTR('Bounced Cheque:- '+"Transaction Type" + '-' + "Branch Refference",50);
                                                       END;
                                                       //Project Accounts
                                                       GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                                       GenJournalLine.Amount:=CTrans.Amount;
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
                                                       GenJournalLine."Posting Date":="Expected Maturity Date";
                                                       GenJournalLine.Description:=PADSTR('Bounced Cheque: '+"Account Name",50);
                                                       GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                                       GenJournalLine.Amount:=-CTrans.Amount;
                                                       GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                                       GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                                       GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                                       GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                                       GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                                       IF GenJournalLine.Amount<>0 THEN
                                                       GenJournalLine.INSERT;


                                                       GenJournalLine.RESET;
                                                       GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                                       GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                                       IF GenJournalLine.FIND('-') THEN BEGIN
                                                       REPEAT
                                                       GLPosting.RUN(GenJournalLine);
                                                       UNTIL GenJournalLine.NEXT = 0;
                                                       END;


                                                       GenJournalLine.RESET;
                                                       GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                                       GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                                       GenJournalLine.DELETEALL;

                                                       CTrans."Dont Clear":=TRUE;
                                                       CTrans.Status:=CTrans.Status::Bounced;
                                                       CTrans."Cheque Processed":=TRUE;
                                                       CTrans.MODIFY;

                                                 END;
                                           // END;
                                           Vend.RESET;
                                         Vend.SETRANGE(Vend."No.","Account No");
                                         IF Vend.FINDFIRST THEN BEGIN
                                         MaturedMessage:='';
                                         MaturedMessage:='Dear '+Vend.Name+' your cheque no '+"Cheque No"+'of Ksh '+FORMAT(Amount)+'deposited on '+FORMAT("Transaction Date")+' has bounced.Telepost Sacco.';
                                         SendSMS.FnSendMessageCD(Vend."BOSA Account No",MaturedMessage);
                                         END;

                                        UNTIL CTrans.NEXT = 0;

                                        MESSAGE('Operation successful');

                                        END ELSE
                                            MESSAGE('No cheque has been selected');
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
                SourceExpr=No;
                Editable=FALSE }

    { 1102760003;2;Field  ;
                SourceExpr="Account No";
                Enabled=FALSE }

    { 1102760005;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1102760007;2;Field  ;
                SourceExpr="Transaction Type";
                Editable=FALSE }

    { 1102760009;2;Field  ;
                SourceExpr=Amount;
                Editable=FALSE }

    { 1102760020;2;Field  ;
                SourceExpr="Expected Maturity Date";
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Reason For Approving/Bouncing" }

    { 1102760011;2;Field  ;
                SourceExpr=Cashier }

    { 1102760013;2;Field  ;
                SourceExpr="Transaction Date";
                Editable=FALSE }

    { 1102760019;2;Field  ;
                SourceExpr="Amount Discounted";
                Editable=FALSE }

    { 1120054007;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102760015;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1120054006;2;Field  ;
                SourceExpr=Select }

  }
  CODE
  {
    VAR
      GenJournalLine@1102760007 : Record 81;
      GLPosting@1102760006 : Codeunit 12;
      Account@1102760005 : Record 23;
      AccountType@1102760004 : Record 51516295;
      LineNo@1102760003 : Integer;
      ChequeType@1102760002 : Record 51516304;
      DimensionV@1102760001 : Record 349;
      ChargeAmount@1102760000 : Decimal;
      DiscountingAmount@1102760008 : Decimal;
      Loans@1102760009 : Record 51516230;
      DActivity@1102760012 : Code[20];
      DBranch@1102760011 : Code[20];
      UsersID@1102760010 : Record 2000000120;
      Vend@1102760013 : Record 23;
      LoanType@1102760014 : Record 51516240;
      BOSABank@1102760015 : Code[20];
      ReceiptAllocations@1102760016 : Record 51516246;
      StatusPermissions@1102760017 : Record 51516310;
      ChBank@1120054000 : Code[10];
      SendSMS@1120054001 : Codeunit 51516022;
      MaturityTxt@1120054002 : TextConst 'ENU=Dear %1,your cheque no %2 of Ksh %3  deposited on %4 has matured.Telepost Sacco.';
      BouncedTxt@1120054003 : TextConst 'ENU=Dear %1,your cheque no %2 of Ksh %3  deposited on %4 has bounced.Telepost Sacco.';
      MaturedMessage@1120054004 : Text[250];

    PROCEDURE PostBOSAEntries@1102760002();
    VAR
      ReceiptAllocation@1102760000 : Record 51516246;
    BEGIN
      //BOSA Cash Book Entry
      IF "Account No" = '502-00-000300-00' THEN
      BOSABank:='13865'
      ELSE IF "Account No" = '502-00-000303-00' THEN
      BOSABank:='070006';


      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=BOSABank;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine.Description:=Payee;
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=-Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      ReceiptAllocations.RESET;
      ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No",No);
      IF ReceiptAllocations.FIND('-') THEN BEGIN
      REPEAT

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Posting Date":="Transaction Date";
      IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment THEN BEGIN
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      IF "Account No" = '502-00-000303-00' THEN
      GenJournalLine."Account No.":='080023'
      ELSE
      GenJournalLine."Account No.":='045003';
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:=Payee;
      END ELSE BEGIN
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Customer;
      GenJournalLine."Account No.":=ReceiptAllocations."Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:=FORMAT(ReceiptAllocations."Transaction Type");
      END;
      GenJournalLine.Amount:=ReceiptAllocations.Amount;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Interest Due" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Benevolent Fund"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Loan THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Benevolent Fund" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Unallocated Funds"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Registration Fee" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Withdrawal THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Registration Fee";
      GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      IF (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Registration Fee") AND
         (ReceiptAllocations."Interest Amount" > 0) THEN BEGIN
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='PURCHASES';
      GenJournalLine."Journal Batch Name":='FTRANS';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=No;
      GenJournalLine."External Document No.":="Cheque No";
      GenJournalLine."Posting Date":="Transaction Date";
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Customer;
      GenJournalLine."Account No.":=ReceiptAllocations."Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Interest Paid';
      GenJournalLine.Amount:=ReceiptAllocations."Interest Amount";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
      GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      END;

      UNTIL ReceiptAllocations.NEXT = 0;
      END;
    END;

    BEGIN
    END.
  }
}

