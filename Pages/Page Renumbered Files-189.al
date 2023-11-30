OBJECT page 17380 Receipts Header-BOSA
{
  OBJECT-PROPERTIES
  {
    Date=03/07/22;
    Time=11:12:38 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    DeleteAllowed=No;
    SourceTable=Table51516247;
    PageType=Card;
    OnInsertRecord=BEGIN
                      {Rcpt.RESET;
                       Rcpt.SETRANGE(Rcpt.Posted,FALSE);
                       Rcpt.SETRANGE(Rcpt."User ID",USERID);

                       IF Rcpt.COUNT >0 THEN BEGIN
                               ERROR('You have an Unposted Receipt. Please utilise it first');
                         END;
                          }
                     //IF "Phone No."='' THEN
                     //ERROR('Please update Phone No.');
                     //IF "ID NO."='' THEN
                     //ERROR('Please update ID No.');
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760028;1 ;ActionGroup;
                      CaptionML=ENU=Suggest }
      { 1102760029;2 ;Action    ;
                      Name=;
                      CaptionML=ENU=Cash/Cheque Clearance;
                      OnAction=BEGIN
                                 Cheque := FALSE;
                                 //SuggestBOSAEntries();
                               END;
                                }
      { 1102760032;2 ;Separator  }
      { 1102760033;2 ;Action    ;
                      Name=Suggest Payments;
                      CaptionML=ENU=Suggest Monthy Repayments;
                      OnAction=BEGIN

                                 TESTFIELD(Posted,FALSE);
                                 TESTFIELD("Account No.");
                                 TESTFIELD(Amount);
                                 //Cust.CALCFIELDS(Cust."Registration Fee Paid");

                                 ReceiptAllocations.RESET;
                                 ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No","Transaction No.");
                                 ReceiptAllocations.DELETEALL;


                                 IF "Account Type"="Account Type"::Member THEN  BEGIN

                                 BosaSetUp.GET();
                                 RunBal:=Amount;

                                 IF RunBal>0 THEN BEGIN

                                 IF Cust.GET("Account No.") THEN BEGIN
                                 Cust.CALCFIELDS(Cust."Registration Fee Paid");
                                 IF Cust."Registration Fee Paid"=0 THEN BEGIN
                                 //IF Cust."Registration Date" >030114D THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Registration Fee";
                                 ReceiptAllocations."Loan No.":='';
                                 ReceiptAllocations.Amount:=BosaSetUp."Registration Fee";
                                 //ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 RunBal:=RunBal-ReceiptAllocations.Amount;
                                 //END;
                                 END;
                                 END;
                                 //********** Mpesa Charges
                                 IF "Mode of Payment"= "Mode of Payment"::Mpesa THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"M Pesa Charge ";
                                 ReceiptAllocations."Loan No.":='';

                                  // M Pesa Tarriff

                                 IF Amount<= 2499 THEN
                                 ReceiptAllocations."Total Amount":=55
                                 ELSE IF Amount <= 4999 THEN
                                 ReceiptAllocations."Total Amount":=75
                                 ELSE IF Amount <= 9999 THEN
                                 ReceiptAllocations."Total Amount":=105
                                 ELSE IF Amount <= 19999 THEN
                                 ReceiptAllocations."Total Amount":=130
                                 ELSE IF Amount <= 34999 THEN
                                 ReceiptAllocations."Total Amount":=185
                                 ELSE IF Amount <= 49999 THEN
                                 ReceiptAllocations."Total Amount":=220
                                 ELSE IF Amount <= 70000 THEN
                                 ReceiptAllocations."Total Amount":=240
                                 ELSE IF Amount > 70000 THEN
                                 ERROR ('Sorry the Maximum M - Pesa transaction Amount is Ksha. 70,000');


                                 ReceiptAllocations.Amount:=ReceiptAllocations."Total Amount";
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 END;
                                 //********** END Mpesa Charges

                                 IF RunBal >0 THEN BEGIN
                                 //Loan Repayments
                                 Loans.RESET;
                                 Loans.SETCURRENTKEY(Loans.Source,Loans."Client Code");
                                 Loans.SETRANGE(Loans."Client Code","Account No.");
                                 Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                 IF Loans.FIND('-') THEN BEGIN
                                 REPEAT

                                 //Insurance Charge
                                 Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due",Loans."Loans Insurance",Loans."Oustanding Interest");
                                 IF (Loans."Outstanding Balance" > 0 ) AND  (Loans."Approved Amount" > 100000) AND
                                 (Loans."Loans Insurance">0) THEN BEGIN



                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Insurance Paid";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations."Loan ID":=Loans."Loan Product Type";
                                 ReceiptAllocations.Amount:=Loans."Loans Insurance";
                                 //MESSAGE('ReceiptAllocations.Amount is %1',ReceiptAllocations.Amount);
                                 ReceiptAllocations."Amount Balance":=Loans."Outstanding Balance";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 END;


                                 IF (Loans."Outstanding Balance") > 0 THEN BEGIN
                                 LOustanding:=0;
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::Repayment;
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations."Loan ID":=Loans."Loan Product Type";
                                 //ReceiptAllocations.Amount:=Loans.Repayment-Loans."Loans Insurance"-Loans."Oustanding Interest";
                                 ReceiptAllocations.Amount:=Loans."Loan Principle Repayment";
                                 ReceiptAllocations."Amount Balance":=Loans."Outstanding Balance";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 END;

                                 IF (Loans."Oustanding Interest" > 0 )THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Interest Paid";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=Loans."Oustanding Interest";
                                 //ReceiptAllocations.Amount:=Loans."Loan Interest Repayment";
                                 //ReceiptAllocations.Amount:=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 END;

                                 RunBal:=RunBal-ReceiptAllocations.Amount;
                                 MESSAGE('RunBal is %1',RunBal);

                                 UNTIL Loans.NEXT = 0;
                                 END;
                                 END;
                                 END;
                                 BosaSetUp.GET();
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Benevolent Fund";
                                 ReceiptAllocations."Loan No.":=' ';
                                 ReceiptAllocations.Amount:=BosaSetUp."Welfare Contribution";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;

                                 //Deposits Contribution
                                 IF Cust.GET("Account No.") THEN BEGIN
                                 IF Cust."Monthly Contribution">0 THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Deposit Contribution";
                                 ReceiptAllocations."Loan No.":='';
                                 ReceiptAllocations.Amount:=ROUND(Cust."Monthly Contribution",0.01);;
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 END;
                                 END;

                                 //Shares Contribution
                                 IF Cust.GET("Account No.") THEN BEGIN
                                 Cust.CALCFIELDS(Cust."Shares Retained");

                                 IF Cust."Shares Retained"<10000  THEN BEGIN
                                 BosaSetUp.GET();
                                 IF BosaSetUp."Monthly Share Contributions">0 THEN BEGIN
                                 //IF CONFIRM('This member has reached a maximum share contribution of Kshs. 5,000/=. Do you want to post this transaction as shares contribution?',TRUE)=TRUE THEN
                                 //IF CONFIRM(Text001,TRUE) THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Shares Capital";
                                 ReceiptAllocations."Loan No.":='';
                                 ReceiptAllocations.Amount:=ROUND(BosaSetUp."Monthly Share Contributions",0.01);
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 END;
                                 END;
                                 END;
                                 END;

                                 IF "Account Type"="Account Type"::Vendor THEN  BEGIN
                                 IF "Mode of Payment"= "Mode of Payment"::Mpesa THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";

                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"M Pesa Charge ";
                                 ReceiptAllocations."Total Amount":= Amount ;
                                 ReceiptAllocations."Loan No.":='';


                                  // M Pesa Tarriff
                                 MpesaCharge:=0;
                                 IF Amount<= 2499 THEN
                                 ReceiptAllocations."Total Amount":=55
                                 ELSE IF Amount <= 4999 THEN
                                 ReceiptAllocations."Total Amount":=75
                                 ELSE IF Amount <= 9999 THEN
                                 ReceiptAllocations."Total Amount":=105
                                 ELSE IF Amount <= 19999 THEN
                                 ReceiptAllocations."Total Amount":=130
                                 ELSE IF Amount <= 34999 THEN
                                 ReceiptAllocations."Total Amount":=185
                                 ELSE IF Amount <= 49999 THEN
                                 ReceiptAllocations."Total Amount":=220
                                 ELSE IF Amount <= 70000 THEN
                                 ReceiptAllocations."Total Amount":=240
                                 ELSE IF Amount > 70000 THEN
                                 ERROR ('Sorry the Maximum M - Pesa transaction Amount is Ksha. 70,000');
                                 MpesaCharge:=ReceiptAllocations."Total Amount";
                                 ReceiptAllocations.Amount:=ReceiptAllocations."Total Amount";

                                 //ReceiptAllocations."Total Amount":=Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.INSERT;
                                 END;

                                 //********** END Mpesa Charges


                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Cheque No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"FOSA Account";
                                 //GenJournalLine.Description:= 'BT'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No.";
                                 ReceiptAllocations."Loan No.":=' ';
                                 ReceiptAllocations."Total Amount":=Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 ReceiptAllocations."Global Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 ReceiptAllocations.Amount:= ReceiptAllocations."Total Amount";
                                 ReceiptAllocations.INSERT;



                                 END;
                                 //VALIDATE("Allocated Amount");
                                 CALCFIELDS("Allocated Amount");
                                 "Un allocated Amount":=(Amount-"Allocated Amount");
                                 MODIFY;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760025;1 ;Action    ;
                      Name=Post;
                      CaptionML=ENU=Post (F11);
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //-----------Check to Avoid Double Posting-------------------------
                                 MemberLedg.RESET;
                                 MemberLedg.SETRANGE(MemberLedg."Document No.","Transaction No.");
                                   IF MemberLedg.FIND('-')  THEN BEGIN
                                     IF Posted=FALSE THEN BEGIN
                                       Posted:=TRUE;
                                       MODIFY;
                                      ERROR('This Receipt has been Posted to the Members Account');
                                     END;
                                     EXIT
                                     END;


                                 //-----------Check to Avoid Double Posting-------------------------



                                 {
                                 IF (USERID<>'NAOMI MURIITHI') THEN
                                   IF ("Mode of Payment"="Mode of Payment"::Cash)AND ("Transaction Date"<> TODAY) THEN
                                       ERROR('You cannot post cash transactions with a date not today');
                                 }
                                 IF FundsUser.GET(USERID) THEN BEGIN
                                   FundsUser.TESTFIELD(FundsUser."Receipt Journal Template");
                                   FundsUser.TESTFIELD(FundsUser."Receipt Journal Batch");
                                   JournalTemplate:=FundsUser."Receipt Journal Template";
                                   JournalBatch:=FundsUser."Receipt Journal Batch";
                                 END ELSE BEGIN
                                   ERROR('User Account Not Setup for Posting');
                                 END;
                                 {
                                 IF ("Mode of Payment"="Mode of Payment"::Cash)AND ("Transaction Date"<> TODAY) THEN
                                 ERROR('You cannot post cash transactions with a date not today');
                                 }
                                 IF Posted THEN
                                 ERROR('This receipt is already posted');

                                 TESTFIELD("Account No.");
                                 TESTFIELD(Amount);
                                 TESTFIELD("Employer No.");
                                 //TESTFIELD("Cheque No.");
                                 //TESTFIELD("Cheque Date");

                                 //--------START: M-Loan Advance Penalty payment checks-------//
                                 IF Type = Type::"5" THEN BEGIN
                                   TESTFIELD(Rec."Loan Number");

                                   //Prevent paying for the penalty before clearing the loan
                                   Loans.GET("Loan Number");
                                   Loans.CALCFIELDS(Loans."Oustanding Interest",Loans."Outstanding Balance");
                                   IF Loans."Oustanding Interest"+Loans."Outstanding Balance">0 THEN ERROR('Kindly clear the loan first');

                                   //Find total penalty amount
                                   GLEntry.RESET;
                                   GLEntry.SETRANGE(GLEntry."G/L Account No.",'300-000-068');
                                   GLEntry.SETRANGE(GLEntry."Document No.","Loan Number");
                                   IF GLEntry.FINDFIRST THEN BEGIN
                                     GLEntry.CALCSUMS(GLEntry.Amount);
                                     PenaltyAmount := GLEntry.Amount*-1;
                                   END;

                                   //compare penalty amount if tally
                                   ReceiptAllocations.RESET;
                                   ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No","Transaction No.");
                                   ReceiptAllocations.SETRANGE(ReceiptAllocations."Transaction Type",ReceiptAllocations."Transaction Type"::"Deposit Contribution");
                                   IF ReceiptAllocations.FIND('-') THEN BEGIN
                                     IF ReceiptAllocations.Amount<PenaltyAmount THEN ERROR('The total penalty amount of '+FORMAT(PenaltyAmount)+', should tally with the amount allocated on '+FORMAT(ReceiptAllocations."Transaction Type"::"Deposit Contribution"));
                                   END;
                                 END;
                                 //--------END: M-Loan Advance Penalty payment checks-------//

                                 IF ("Account Type" = "Account Type"::"G/L Account") OR
                                    ("Account Type" = "Account Type"::Debtor) THEN
                                 TransType := 'Withdrawal'
                                 ELSE
                                 TransType := 'Deposit';

                                 BOSABank:="Employer No.";
                                 IF ("Account Type" = "Account Type"::Member) OR ("Account Type" = "Account Type"::"FOSA Loan") THEN BEGIN

                                 IF Amount <> "Allocated Amount" THEN
                                 ERROR('Receipt amount must be equal to the allocated amount.');
                                 END;
                                 ReceiptAllocations.RESET;
                                 ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No","Transaction No.");
                                 IF ReceiptAllocations.FIND('-') THEN BEGIN

                                 Branch:= ReceiptAllocations."Global Dimension 2 Code";
                                 Activity:=ReceiptAllocations."Global Dimension 1 Code";

                                    END;
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",JournalTemplate);
                                 GenJournalLine.SETRANGE("Journal Batch Name",JournalBatch);
                                 GenJournalLine.DELETEALL;


                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":=JournalTemplate;
                                 GenJournalLine."Journal Batch Name":=JournalBatch;
                                 IF "Mode of Payment"="Mode of Payment"::Cheque THEN
                                 GenJournalLine."Document No.":="Cheque No."
                                 ELSE
                                 GenJournalLine."Document No.":="Transaction No."+"Account No.";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="Employer No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Source No.":="Old receipt No";
                                 //GenJournalLine."Posting Date":="Cheque Date";
                                 IF "Mode of Payment"="Mode of Payment"::Cash THEN
                                 GenJournalLine."Posting Date":=TODAY
                                 ELSE
                                 GenJournalLine."Posting Date":="Transaction Date";
                                 GenJournalLine.Description:='BT-'+"Account No."+'-'+Remarks;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine."Shortcut Dimension 1 Code":=Activity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=Branch;

                                 IF TransType = 'Withdrawal' THEN
                                 GenJournalLine.Amount:=-Amount
                                 ELSE
                                 GenJournalLine.Amount:=Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 IF ("Account Type" <> "Account Type"::Member) AND ("Account Type" <> "Account Type"::"FOSA Loan") AND ("Account Type" <> "Account Type"::Vendor) THEN BEGIN
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":=JournalTemplate;
                                 GenJournalLine."Journal Batch Name":=JournalBatch;
                                 IF "Mode of Payment"="Mode of Payment"::Cheque THEN
                                 GenJournalLine."Document No.":="Cheque No."
                                 ELSE
                                 GenJournalLine."Document No.":="Transaction No."+"Account No.";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Line No.":=LineNo;
                                 IF "Account Type" = "Account Type"::"G/L Account" THEN
                                 GenJournalLine."Account Type":="Account Type"
                                 ELSE IF "Account Type" = "Account Type"::Debtor THEN
                                 GenJournalLine."Account Type":="Account Type"
                                 ELSE IF "Account Type" = "Account Type"::Vendor THEN
                                 GenJournalLine."Account Type":="Account Type"
                                 ELSE IF "Account Type" = "Account Type"::Member THEN
                                 GenJournalLine."Account Type":="Account Type";
                                 GenJournalLine."Account No.":="Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 //GenJournalLine."Posting Date":="Cheque Date";
                                 IF "Mode of Payment"="Mode of Payment"::Cash THEN
                                 GenJournalLine."Posting Date":=TODAY
                                 ELSE
                                 GenJournalLine."Posting Date":="Transaction Date";
                                 GenJournalLine.Description:='BT-'+Name+'-'+"Account No."+'-'+Remarks;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF TransType = 'Withdrawal' THEN
                                 GenJournalLine.Amount:=Amount
                                 ELSE
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;

                                 GenSetup.GET();

                                 IF ("Account Type" = "Account Type"::Member) OR ("Account Type" = "Account Type"::"FOSA Loan") OR ("Account Type" = "Account Type"::Vendor)  THEN BEGIN

                                 ReceiptAllocations.RESET;
                                 ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No","Transaction No.");
                                 IF ReceiptAllocations.FIND('-') THEN BEGIN
                                 REPEAT

                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":=JournalTemplate;
                                 GenJournalLine."Journal Batch Name":=JournalBatch;
                                 GenJournalLine."Line No.":=LineNo;
                                 IF "Mode of Payment"="Mode of Payment"::Cheque THEN
                                 GenJournalLine."Document No.":="Cheque No."
                                 ELSE
                                 GenJournalLine."Document No.":="Transaction No."+"Account No.";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 //GenJournalLine."Posting Date":="Cheque Date";
                                 IF "Mode of Payment"="Mode of Payment"::Cash THEN
                                 GenJournalLine."Posting Date":=TODAY
                                 ELSE
                                 GenJournalLine."Posting Date":="Transaction Date";
                                 IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"FOSA Account" THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;

                                 IF Cust.GET("Account No.") THEN
                                 GenJournalLine."Account No.":=Cust."FOSA Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='BT-'+Name+'-'+"Account No."+'-'+Remarks;
                                 GenJournalLine."Shortcut Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 GenJournalLine."Shortcut Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");

                                 END ELSE BEGIN
                                 IF  "Account Type"="Account Type"::Vendor THEN BEGIN
                                 IF "Mode of Payment"="Mode of Payment"::Cash THEN
                                 GenJournalLine."Posting Date":=TODAY
                                 ELSE
                                 GenJournalLine."Posting Date":="Transaction Date";
                                 GenJournalLine."Shortcut Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 GenJournalLine."Shortcut Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 //GenJournalLine.Description:=FORMAT(ReceiptAllocations."Transaction Type")+'-'+Remarks;
                                 //GenJournalLine.Description:='BT-'+Name+'-'+"Account No."+'-'+Remarks;
                                 //GenJournalLine.Description:='BT'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No.";

                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=ReceiptAllocations."Member No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");

                                 IF ("Mode of Payment"="Mode of Payment"::Mpesa) AND (ReceiptAllocations."Transaction Type"=ReceiptAllocations."Transaction Type":: "M Pesa Charge ") THEN  BEGIN
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=GenSetup."FOSA MPESA COmm A/C";
                                 GenJournalLine.Description:=FORMAT(ReceiptAllocations."Transaction Type")+'-'+Remarks;
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 GenJournalLine."Bal. Account No.":="Account No.";

                                 END;
                                 END;

                                 IF"Account Type"="Account Type"::Member THEN BEGIN
                                 IF "Mode of Payment"="Mode of Payment"::Cash THEN
                                 GenJournalLine."Posting Date":=TODAY
                                 ELSE
                                 GenJournalLine."Posting Date":="Transaction Date";
                                 GenJournalLine."Shortcut Dimension 1 Code":=GenJournalLine."Shortcut Dimension 1 Code";
                                 GenJournalLine."Shortcut Dimension 2 Code":=GenJournalLine."Shortcut Dimension 2 Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No." :=ReceiptAllocations."Member No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 IF ("Mode of Payment"="Mode of Payment"::Mpesa) AND (ReceiptAllocations."Transaction Type"=ReceiptAllocations."Transaction Type":: "M Pesa Charge ") THEN BEGIN
                                 GenJournalLine.Amount:=-Amount;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=GenSetup."FOSA MPESA COmm A/C";
                                 GenJournalLine.Description:=FORMAT(ReceiptAllocations."Transaction Type")+'-'+Remarks;
                                 END;
                                 END;
                                 END;
                                 //GenJournalLine."Prepayment date":=ReceiptAllocations."Prepayment Date";
                                 //IF ("Mode of Payment"="Mode of Payment"::Mpesa) AND (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Administration Fee") THEN
                                 //GenJournalLine.Amount:=-ReceiptAllocations.Amount
                                 //ELSE
                                 GenJournalLine.Amount:=-ReceiptAllocations.Amount;
                                 GenJournalLine."Shortcut Dimension 1 Code":=ReceiptAllocations."Global Dimension 1 Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine."Shortcut Dimension 2 Code":=ReceiptAllocations."Global Dimension 2 Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 //description
                                 IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Interest Paid" THEN
                                 GenJournalLine.Description:='Interest'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Insurance Paid" THEN
                                 GenJournalLine.Description:='L-Insurance'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Benevolent Fund" THEN
                                 GenJournalLine.Description:='Insurance'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Registration Fee" THEN
                                 GenJournalLine.Description:='Registration'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment THEN
                                 GenJournalLine.Description:='Repayment'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Unallocated Funds" THEN
                                 GenJournalLine.Description:='Unallocated'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Gpange THEN
                                 GenJournalLine.Description:='Lukenya'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Juja THEN
                                 GenJournalLine.Description:='juja'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Junior THEN
                                 GenJournalLine.Description:='Konza'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Housing Title" THEN
                                 GenJournalLine.Description:='Title'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Housing Water" THEN
                                 GenJournalLine.Description:='Water'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Deposit Contribution" THEN
                                 GenJournalLine.Description:='Deposit'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Shares Capital" THEN
                                 GenJournalLine.Description:='Share'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Benevolent Fund" THEN
                                 GenJournalLine.Description:='Benevolent'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Benevolent Fund" THEN
                                 GenJournalLine.Description:='Benevolent'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."
                                 ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"SchFees Shares" THEN
                                 GenJournalLine.Description:='School Fees Shares'+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No."

                                 ELSE GenJournalLine.Description:='BT'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No.";


                                 //description
                                 GenJournalLine."Transaction Type":=ReceiptAllocations."Transaction Type";
                                 GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
                                 IF (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"SchFees Shares")
                                 THEN GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"SchFee Shares";
                                 //MESSAGE('%1',ReceiptAllocations."Transaction Type");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                   {
                                 IF (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Withdrawal) AND
                                    (ReceiptAllocations."Interest Amount" > 0) THEN BEGIN
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":=JournalTemplate;
                                 GenJournalLine."Journal Batch Name":=JournalBatch;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="Transaction No.";
                                 GenJournalLine."External Document No.":="Cheque No.";
                                 GenJournalLine."Posting Date":="Cheque Date";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Account No.":=ReceiptAllocations."Member No";
                                 //GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Interest Paid'+'-'+Remarks;
                                 GenJournalLine.Amount:=-ReceiptAllocations."Interest Amount";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                 GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;
                                  }
                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,FORMAT(ReceiptAllocations."Transaction Type"),ReceiptAllocations.Amount,
                                 'CASHIER TRANS',TODAY,TIME,ReceiptAllocations."Loan No.","Transaction No.","Account No.",'');
                                 //End Create Audit Entry

                                 UNTIL ReceiptAllocations.NEXT = 0;
                                 END;


                                 END;

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",JournalTemplate);
                                 GenJournalLine.SETRANGE("Journal Batch Name",JournalBatch);
                                 IF GenJournalLine.FIND('-') THEN BEGIN


                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                                 END;
                                 //Post New

                                 Posted:=TRUE;
                                 MODIFY;
                                 COMMIT;

                                 IF Type = Type::"5" THEN BEGIN
                                   PenaltyCounter.GET("Loan Number");
                                   PenaltyCounter."Date Penalty Paid" := TODAY;
                                   PenaltyCounter.MODIFY;
                                 END;

                                 BOSARcpt.RESET;
                                 BOSARcpt.SETRANGE(BOSARcpt."Transaction No.","Transaction No.");
                                 IF BOSARcpt.FIND('-') THEN
                                  //IF{ ("Mode of Payment"<>"Mode of Payment"::"Standing order") AND }
                                     //("Mode of Payment"<>"Mode of Payment"::"Direct Debit") AND
                                    // ("Mode of Payment"<>"Mode of Payment"::Mpesa) THEN BEGIN

                                 BOSARcpt.RESET;
                                 BOSARcpt.SETRANGE(BOSARcpt."Transaction No.","Transaction No.");
                                 IF BOSARcpt.FIND('-') THEN
                                 REPORT.RUN(51516836,TRUE,FALSE,BOSARcpt);
                                 {
                                 //Change Member status from dormant to active
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","Account No.");
                                 IF Cust.FIND('-') THEN BEGIN
                                 Cust.Status:=Cust.Status::Active;
                                 Cust.MODIFY;
                                 END;
                                 }

                                 //END;
                                 CurrPage.CLOSE;
                               END;
                                }
      { 1102760026;1 ;Action    ;
                      Name=Reprint recipts;
                      CaptionML=ENU=Reprint Receipt;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD(Posted);

                                 BOSARcpt.RESET;
                                 BOSARcpt.SETRANGE(BOSARcpt."Transaction No.","Transaction No.");
                                 IF BOSARcpt.FIND('-') THEN
                                 REPORT.RUN(51516836,TRUE,FALSE,BOSARcpt)
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                Description=ContentArea;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                CaptionML=ENU=Transaction }

    { 1102760001;2;Field  ;
                SourceExpr="Transaction No.";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Account Type" }

    { 1102755002;2;Field  ;
                SourceExpr=Source }

    { 1102760003;2;Field  ;
                SourceExpr="Account No." }

    { 1102760005;2;Field  ;
                SourceExpr=Name;
                Editable=TRUE }

    { 1120054000;2;Field  ;
                SourceExpr="Phone No." }

    { 1120054002;2;Field  ;
                SourceExpr="ID NO." }

    { 1102760007;2;Field  ;
                SourceExpr=Amount }

    { 1102755004;2;Field  ;
                SourceExpr="Mode of Payment" }

    { 1102755003;2;Field  ;
                SourceExpr=Remarks }

    { 1102760019;2;Field  ;
                SourceExpr="Allocated Amount" }

    { 1102755001;2;Field  ;
                SourceExpr="Un allocated Amount" }

    { 1102755000;2;Field  ;
                CaptionML=ENU=Teller Till / Bank  No.;
                SourceExpr="Employer No." }

    { 1102760011;2;Field  ;
                CaptionML=ENU=Cheque / Slip  Date;
                SourceExpr="Cheque Date" }

    { 1102760009;2;Field  ;
                CaptionML=ENU=Cheque / Slip  No.;
                SourceExpr="Cheque No." }

    { 1102760013;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1102760017;2;Field  ;
                SourceExpr="User ID" }

    { 1102760021;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1102760023;2;Field  ;
                SourceExpr="Transaction Time" }

    { 1000000000;2;Field  ;
                Name=Insurance;
                SourceExpr=Insuarance }

    { 1   ;2   ;Field     ;
                SourceExpr="Old receipt No" }

    { 1120054001;1;Group  ;
                CaptionML=ENU=Sky M-Loan Penalty;
                GroupType=Group }

    { 1120054003;2;Field  ;
                SourceExpr=Type }

    { 1120054004;2;Field  ;
                SourceExpr="Loan Number" }

  }
  CODE
  {
    VAR
      GenJournalLine@1102760004 : Record 81;
      InterestPaid@1102760003 : Decimal;
      PaymentAmount@1102760002 : Decimal;
      RunBal@1102760001 : Decimal;
      Recover@1102760000 : Boolean;
      Cheque@1102760005 : Boolean;
      ReceiptAllocations@1102760006 : Record 51516246;
      Loans@1102760007 : Record 51516230;
      Commision@1102760008 : Decimal;
      LOustanding@1102760009 : Decimal;
      TotalCommision@1102760010 : Decimal;
      TotalOustanding@1102760011 : Decimal;
      Cust@1102760012 : Record 51516223;
      BOSABank@1102760013 : Code[20];
      LineNo@1102760014 : Integer;
      BOSARcpt@1102760015 : Record 51516247;
      TellerTill@1102760016 : Record 270;
      CurrentTellerAmount@1102760017 : Decimal;
      TransType@1102760018 : Text[30];
      RCPintdue@1102755000 : Decimal;
      Text001@1102755001 : TextConst 'ENU="This member has reached a maximum share contribution of Kshs. 5,000/=. Do you want to post this transaction as shares contribution?"';
      BosaSetUp@1102755002 : Record 51516257;
      MpesaCharge@1102755003 : Decimal;
      CustPostingGrp@1102755004 : Record 92;
      MpesaAc@1102755005 : Code[30];
      GenSetup@1102755006 : Record 51516257;
      JournalTemplate@1000 : Code[20];
      JournalBatch@1001 : Code[20];
      FundsUser@1002 : Record 51516031;
      Branch@1004 : Text;
      Activity@1003 : Text;
      Rcpt@1005 : Record 51516247;
      MemberLedg@1006 : Record 51516224;
      AuditTrail@1120054002 : Codeunit 51516107;
      Trail@1120054001 : Record 51516655;
      EntryNo@1120054000 : Integer;
      GLEntry@1120054003 : Record 17;
      PenaltyAmount@1120054004 : Decimal;
      PenaltyCounter@1120054005 : Record 51516443;

    LOCAL PROCEDURE AllocatedAmountOnDeactivate@19031695();
    BEGIN
      CurrPage.UPDATE:=TRUE;
    END;

    BEGIN
    END.
  }
}

