OBJECT page 17418 Posted Paybill Processing_H
{
  OBJECT-PROPERTIES
  {
    Date=10/25/15;
    Time=12:34:22 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516270;
    SourceTableView=WHERE(Posted=CONST(Yes));
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
                      CaptionML=ENU=Import Paybill Transactions;
                      RunObject=XMLport 50000 }
      { 1102755021;1 ;ActionGroup }
      { 1102755020;1 ;Action    ;
                      Name=Validate Paybill;
                      CaptionML=ENU=Validate Paybill;
                      RunObject=Report 50074 }
      { 1102755019;1 ;ActionGroup }
      { 1102755022;1 ;Action    ;
                      Name=Post check off;
                      CaptionML=ENU=Post Paybill Transaction;
                      OnAction=BEGIN

                                 genstup.GET();
                                 IF Posted=TRUE THEN
                                 ERROR('This Paybill Batch has already been posted');
                                 IF "Account No" = '' THEN
                                 ERROR('You must specify the Account No.');
                                 IF "Document No" = '' THEN
                                 ERROR('You must specify the Document No.');
                                 IF "Posting date" = 0D THEN
                                 ERROR('You must specify the Posting date.');
                                 Datefilter:='..'+FORMAT("Loan CutOff Date");



                                 PDate:="Posting date";
                                 DocNo:="Document No";
                                 GenBatches.RESET;
                                 GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                                 GenBatches.SETRANGE(GenBatches.Name,No);
                                 IF GenBatches.FIND('-') = FALSE THEN BEGIN
                                 GenBatches.INIT;
                                 GenBatches."Journal Template Name":='GENERAL';
                                 GenBatches.Name:=No;
                                 GenBatches.Description:='PAYBILL PROCESS';
                                 GenBatches.VALIDATE(GenBatches."Journal Template Name");
                                 GenBatches.VALIDATE(GenBatches.Name);
                                 GenBatches.INSERT;
                                 END;



                                 //Delete journal
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",No);
                                 Gnljnline.DELETEALL;
                                 //End of deletion





                                 RunBal:=0;
                                  CALCFIELDS("Scheduled Amount");
                                  {
                                 IF "Scheduled Amount" <>   Amount THEN BEGIN
                                 ERROR('Scheduled Amount Is Not Equal To Cheque Amount');
                                 END;
                                 }

                                 genstup.GET();
                                 // MWMBER NOT FOUND
                                 RcptBufLines.RESET;
                                 RcptBufLines.SETRANGE(RcptBufLines."Receipt Header No",No);
                                 RcptBufLines.SETRANGE(RcptBufLines.Posted,FALSE);
                                 IF RcptBufLines.FIND('-') THEN BEGIN
                                 REPEAT


                                 RunBal:=RcptBufLines.Amount;

                                 IF RunBal > 0 THEN BEGIN

                                 Cust.RESET;
                                 //Cust.SETRANGE(Cust."No.",RcptBufLines."Member No");
                                 //Cust.SETRANGE(Cust."Payroll/Staff No",RcptBufLines."Staff/Payroll No");
                                 //Cust.SETRANGE(Cust."Employer Code",RcptBufLines."Employer Code");
                                 Cust.SETRANGE(Cust."No.",RcptBufLines."Member No");
                                 IF Cust.FIND('-') THEN BEGIN
                                 REPEAT
                                 Cust.CALCFIELDS(Cust."Registration Fee Paid");
                                 IF Cust."Registration Fee Paid"=0 THEN BEGIN
                                 IF Cust."Registration Date" <>0D THEN BEGIN


                                 LineN:=LineN+10000;
                                 Gnljnline.INIT;
                                 Gnljnline."Journal Template Name":='GENERAL';
                                 Gnljnline."Journal Batch Name":=No;
                                 Gnljnline."Line No.":=LineN;
                                 Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                                 Gnljnline."Account No.":=RcptBufLines."Member No";
                                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                                 Gnljnline."Document No.":="Document No";
                                 Gnljnline."Posting Date":="Posting date";
                                 Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;
                                 Gnljnline.Amount:=500*-1;
                                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Registration Fee";
                                 Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                                 Gnljnline."Shortcut Dimension 2 Code":='Nairobi';
                                 Gnljnline.VALIDATE(Gnljnline.Amount);
                                 IF Gnljnline.Amount<>0 THEN
                                 Gnljnline.INSERT;
                                 RunBal:=RunBal+(Gnljnline.Amount);

                                 END;
                                 END;
                                 UNTIL Cust.NEXT=0;
                                 END;
                                 END;

                                 //++++++++++++++Recover Insurance+++++++++++++++++++//
                                 LoanType.RESET;
                                 LoanType.SETCURRENTKEY(LoanType."Recovery Priority");
                                 LoanType.SETRANGE(LoanType."Check Off Recovery",TRUE);
                                 IF LoanType.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoanApp.RESET;
                                 LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code");
                                 LoanApp.SETRANGE(LoanApp."Loan Product Type",LoanType.Code);
                                 LoanApp.SETRANGE(LoanApp."Client Code",RcptBufLines."Member No");
                                 LoanApp.SETFILTER(LoanApp."Issued Date",Datefilter);
                                 IF LoanApp.FIND('-') THEN BEGIN

                                 REPEAT
                                 IF RunBal > 0 THEN BEGIN
                                 LoanApp.CALCFIELDS(LoanApp."Outstanding Balance",LoanApp."Loans Insurance");
                                 IF LoanApp."Outstanding Balance">0 THEN BEGIN

                                     IF LoanApp."Issued Date" <= PDate THEN BEGIN
                                     IF LoanApp."Approved Amount"> 100000 THEN BEGIN
                                     LineN:=LineN+10000;

                                     Gnljnline.INIT;
                                     Gnljnline."Journal Template Name":='GENERAL';
                                     Gnljnline."Journal Batch Name":=No;
                                     Gnljnline."Line No.":=LineN;
                                     Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                                     Gnljnline."Account No.":=LoanApp."Client Code";
                                     Gnljnline.VALIDATE(Gnljnline."Account No.");
                                     Gnljnline."Document No.":="Document No";
                                     Gnljnline."Posting Date":="Posting date";
                                     Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;
                                     //Gnljnline.Amount:=-ROUND(LoanApp."Outstanding Balance"*0.00016667,1,'>');
                                      Gnljnline.Amount:=-ROUND(LoanApp."Loans Insurance",1,'>');
                                    // INSURANCE:=ROUND(LoanApp."Outstanding Balance"*0.00016667,1,'>');
                                     //MESSAGE('INSURANCE%1',ROUND(LoanApp."Outstanding Balance"*0.00016667,1,'>'));
                                     Gnljnline.VALIDATE(Gnljnline.Amount);
                                     Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Paid";
                                     Gnljnline."Loan No":=LoanApp."Loan  No.";
                                     IF Gnljnline.Amount<>0 THEN
                                     Gnljnline.INSERT;
                                     RunBal:=RunBal+(Gnljnline.Amount);
                                     END;
                                 END;
                                 END;
                                 END;
                                 UNTIL LoanApp.NEXT = 0;
                                 END;
                                 UNTIL LoanType.NEXT = 0;
                                 END;

                                 //++++++++++++++bbf+++++++++++++++++++//
                                 //Cust.RESET;
                                 //Cust.SETRANGE(Cust."No.",RcptBufLines."Member No");
                                 //Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",RcptBufLines."Member No");
                                 //Cust.SETRANGE(Cust."Payroll/Staff No",RcptBufLines."Staff/Payroll No");
                                 Cust.SETRANGE(Cust."Employer Code",RcptBufLines."Employer Code");

                                 IF Cust.FIND('-') THEN BEGIN
                                 //++++++++++Recover Shares Deposits++++++++++++++++++//
                                 IF (Cust.Status = Cust.Status::Active) OR
                                    (Cust.Status = Cust.Status::Dormant) OR
                                    (Cust.Status = Cust.Status::"Re-instated") THEN BEGIN

                                 IF RunBal > 0 THEN BEGIN

                                 LineN:=LineN+10000;

                                 Gnljnline.INIT;
                                 Gnljnline."Journal Template Name":='GENERAL';
                                 Gnljnline."Journal Batch Name":=No;
                                 Gnljnline."Line No.":=LineN;
                                 Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                                 Gnljnline."Account No.":=RcptBufLines."Member No";
                                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                                 Gnljnline."Document No.":="Document No";
                                 Gnljnline."Posting Date":="Posting date";
                                 Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;
                                 Gnljnline.Amount:=genstup."Funeral Expenses Amount"*-1;
                                 Gnljnline.VALIDATE(Gnljnline.Amount);
                                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Benevolent Fund";
                                 IF Gnljnline.Amount<>0 THEN
                                 Gnljnline.INSERT;
                                 RunBal:=RunBal+(Gnljnline.Amount);
                                 END;
                                 END;
                                 END;

                                 //++++++++++++++Recover Interest+++++++++++++++++++//
                                 LoanType.RESET;
                                 LoanType.SETCURRENTKEY(LoanType."Recovery Priority");
                                 LoanType.SETRANGE(LoanType."Check Off Recovery",TRUE);
                                 IF LoanType.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoanApp.RESET;
                                 LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
                                 LoanApp.SETRANGE(LoanApp."Loan Product Type",LoanType.Code);
                                 LoanApp.SETRANGE(LoanApp."Client Code",RcptBufLines."Member No");
                                 //LoanApp.SETRANGE(LoanApp."Staff No",RcptBufLines."Staff/Payroll No");
                                 //LoanApp.SETRANGE(LoanApp."Employer Code",RcptBufLines."Employer Code");
                                 LoanApp.SETFILTER(LoanApp."Issued Date",Datefilter);
                                 IF LoanApp.FIND('-') THEN BEGIN

                                 REPEAT
                                 LoanApp.CALCFIELDS(LoanApp."Oustanding Interest");

                                 IF LoanApp."Oustanding Interest">0 THEN BEGIN

                                 IF  RunBal > 0 THEN BEGIN

                                     Interest:=0;
                                     Interest:=LoanApp."Oustanding Interest";

                                     IF Interest > 0 THEN BEGIN
                                     //IF LoanApp."Issued Date" <= PDate THEN BEGIN>NIC

                                      IF LoanApp."Issued Date"< "Loan CutOff Date" THEN BEGIN

                                     LineN:=LineN+10000;
                                     Gnljnline.INIT;
                                     Gnljnline."Journal Template Name":='GENERAL';
                                     Gnljnline."Journal Batch Name":=No;
                                     Gnljnline."Line No.":=LineN;
                                     Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                                     Gnljnline."Account No.":=LoanApp."Client Code";
                                     Gnljnline.VALIDATE(Gnljnline."Account No.");
                                     Gnljnline."Document No.":="Document No";
                                     Gnljnline."Posting Date":="Posting date";
                                     Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;
                                     IF RunBal > Interest THEN
                                     Gnljnline.Amount:=-1*Interest
                                     ELSE
                                     Gnljnline.Amount:=-1*RunBal;
                                     Gnljnline.VALIDATE(Gnljnline.Amount);
                                     Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
                                     Gnljnline."Loan No":=LoanApp."Loan  No.";
                                     IF Gnljnline.Amount<>0 THEN
                                     Gnljnline.INSERT;
                                     RunBal:=RunBal+(Gnljnline.Amount);
                                     END;

                                 END;
                                 END;
                                 END;
                                 UNTIL LoanApp.NEXT = 0;
                                 END;
                                 UNTIL LoanType.NEXT = 0;
                                 END;




                                 //++++++++++++++Recover Repayment++++++++++++++++++++//
                                 TotalRepay:=0;
                                 LoanType.RESET;
                                 LoanType.SETCURRENTKEY(LoanType."Recovery Priority");
                                 LoanType.SETRANGE(LoanType."Check Off Recovery",TRUE);
                                 IF LoanType.FIND('-') THEN BEGIN
                                 REPEAT
                                 MultipleLoan:=0;

                                 //+++++++++++++++Check if Multiple Loan++++++++++++++++++++++++++++++++++++//
                                 LoanApp.RESET;
                                 LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
                                 LoanApp.SETRANGE(LoanApp."Loan Product Type",LoanType.Code);
                                 LoanApp.SETRANGE(LoanApp."Client Code",RcptBufLines."Member No");
                                 //LoanApp.SETRANGE(LoanApp."Staff No",RcptBufLines."Staff/Payroll No");
                                 //LoanApp.SETRANGE(LoanApp."Employer Code",RcptBufLines."Employer Code");
                                 LoanApp.SETFILTER(LoanApp."Issued Date",Datefilter);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
                                 IF LoanApp."Outstanding Balance" > 0 THEN BEGIN
                                 MultipleLoan:=MultipleLoan+1;
                                 END;
                                 UNTIL LoanApp.NEXT = 0;
                                 END;

                                 //+++++++++++++++++++++Check if Multiple Loan+++++++++++++++++++++++++++++++//

                                 LoanApp.RESET;
                                 LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
                                 LoanApp.SETRANGE(LoanApp."Loan Product Type",LoanType.Code);
                                 LoanApp.SETRANGE(LoanApp."Client Code",RcptBufLines."Member No");
                                 //LoanApp.SETRANGE(LoanApp."Staff No",RcptBufLines."Staff/Payroll No");
                                 //LoanApp.SETRANGE(LoanApp."Employer Code",RcptBufLines."Employer Code");
                                 LoanApp.SETFILTER(LoanApp."Issued Date",Datefilter);
                                 IF LoanApp.FIND('-') THEN BEGIN
                                 REPEAT

                                 IF  RunBal > 0 THEN BEGIN

                                 LoanApp.CALCFIELDS(LoanApp."Outstanding Balance",LoanApp."Oustanding Interest");

                                 IF LoanApp."Outstanding Balance" > 0 THEN BEGIN

                                     IF LoanApp."Approved Amount"> 100000 THEN BEGIN
                                     INSURANCE:=0;
                                     INSURANCE:=ROUND(LoanApp."Outstanding Balance"*0.00016667,1,'>');
                                     END;



                                     LType:=LoanApp."Loan Product Type";
                                     LRepayment:=0;
                                     IF LoanApp."Oustanding Interest">0 THEN
                                     LRepayment:=(LoanApp.Repayment-LoanApp."Oustanding Interest"-INSURANCE)
                                     ELSE
                                     LRepayment:=LoanApp.Repayment-INSURANCE;

                                     IF LRepayment > LoanApp."Outstanding Balance" THEN
                                     LRepayment:=LoanApp."Outstanding Balance";
                                     IF LRepayment = 0 THEN BEGIN
                                     RcptBufLines."No Repayment":=TRUE;
                                     RcptBufLines.MODIFY;
                                     END;

                                     //IF LoanApp."Issued Date"<= PDate THEN BEGIN>NIC
                                     IF LoanApp."Issued Date"< "Loan CutOff Date" THEN BEGIN
                                     IF  LRepayment > 0 THEN BEGIN
                                     LineN:=LineN+10000;
                                     Gnljnline.INIT;
                                     Gnljnline."Journal Template Name":='GENERAL';
                                     Gnljnline."Journal Batch Name":=No;
                                     Gnljnline."Line No.":=LineN;
                                     Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                                     Gnljnline."Account No.":=LoanApp."Client Code";
                                     Gnljnline.VALIDATE(Gnljnline."Account No.");
                                     Gnljnline."Document No.":="Document No";
                                     Gnljnline."Posting Date":="Posting date";
                                     Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;

                                     IF RunBal > 0 THEN BEGIN

                                     IF RunBal > LRepayment THEN
                                     Gnljnline.Amount:=LRepayment*-1
                                     ELSE
                                     Gnljnline.Amount:=RunBal*-1;
                                     END;

                                     Gnljnline.VALIDATE(Gnljnline.Amount);
                                     Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Repayment;
                                     Gnljnline."Loan No":=LoanApp."Loan  No.";
                                     IF Gnljnline.Amount<>0 THEN
                                     Gnljnline.INSERT;

                                     RunBal:=RunBal+(Gnljnline.Amount);
                                     END;
                                     END;
                                     END;
                                     END;

                                 UNTIL LoanApp.NEXT = 0;
                                 END;
                                 UNTIL LoanType.NEXT = 0;
                                 END;

                                 {
                                 //++++++++++Recover Shares SHARE CAPIAL++++++++++++++++++//
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",RcptBufLines."Member No");
                                 //Cust.SETRANGE(Cust."Payroll/Staff No",RcptBufLines."Staff/Payroll No");
                                 //Cust.SETRANGE(Cust."Employer Code",RcptBufLines."Employer Code");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 Cust.CALCFIELDS (Cust."Shares Retained");
                                 IF  Cust."Shares Retained" < 5000 THEN BEGIN

                                 SHARESCAP:=5000;


                                 DIFF:=SHARESCAP-Cust."Shares Retained";
                                 IF  DIFF > 250 THEN BEGIN
                                 DIFF:=250;
                                 END ELSE BEGIN
                                 DIFF:= SHARESCAP-Cust."Shares Retained";
                                 END;
                                 IF (Cust.Status = Cust.Status::Active) OR
                                    (Cust.Status = Cust.Status::Dormant) OR
                                    (Cust.Status = Cust.Status::"Re-instated") THEN BEGIN

                                 IF RunBal > 0 THEN BEGIN
                                 ShRec:=Cust."Monthly Contribution";

                                 IF RunBal > ShRec THEN
                                 ShRec:=ShRec
                                 ELSE
                                 ShRec:=RunBal;

                                 LineN:=LineN+10000;

                                 Gnljnline.INIT;
                                 Gnljnline."Journal Template Name":='GENERAL';
                                 Gnljnline."Journal Batch Name":=No;
                                 Gnljnline."Line No.":=LineN;
                                 Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                                 Gnljnline."Account No.":=RcptBufLines."Member No";
                                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                                 Gnljnline."Document No.":="Document No";
                                 Gnljnline."Posting Date":="Posting date";
                                 Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;
                                 IF RunBal > DIFF THEN  BEGIN
                                 Gnljnline.Amount:=DIFF*-1;
                                 END ELSE BEGIN
                                 Gnljnline.Amount:=RunBal*-1;
                                 END;
                                 Gnljnline.VALIDATE(Gnljnline.Amount);
                                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Shares Capital";
                                 IF Gnljnline.Amount<>0 THEN
                                 Gnljnline.INSERT;
                                 RunBal:=RunBal+(Gnljnline.Amount);
                                 END;
                                 END;
                                 END;
                                 END;
                                 }



                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",RcptBufLines."Member No");
                                 //Cust.SETRANGE(Cust."Payroll/Staff No",RcptBufLines."Staff/Payroll No");
                                 //Cust.SETRANGE(Cust."Employer Code",RcptBufLines."Employer Code");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN


                                 //++++++++++Recover Shares Deposits++++++++++++++++++//
                                 IF (Cust.Status = Cust.Status::Active) OR
                                    (Cust.Status = Cust.Status::Dormant) OR
                                    (Cust.Status = Cust.Status::"Re-instated") THEN BEGIN

                                 IF RunBal > 0 THEN BEGIN
                                 ShRec:=Cust."Monthly Contribution";

                                 IF RunBal > ShRec THEN
                                 ShRec:=ShRec
                                 ELSE
                                 ShRec:=RunBal;

                                 LineN:=LineN+10000;

                                 Gnljnline.INIT;
                                 Gnljnline."Journal Template Name":='GENERAL';
                                 Gnljnline."Journal Batch Name":=No;
                                 Gnljnline."Line No.":=LineN;
                                 Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                                 Gnljnline."Account No.":=RcptBufLines."Member No";
                                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                                 Gnljnline."Document No.":="Document No";
                                 Gnljnline."Posting Date":="Posting date";
                                 Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;
                                 IF RunBal > ShRec THEN  BEGIN
                                 Gnljnline.Amount:=ShRec*-1;
                                 END ELSE BEGIN
                                 Gnljnline.Amount:=RunBal*-1;
                                 END;
                                 Gnljnline.VALIDATE(Gnljnline.Amount);
                                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
                                 IF Gnljnline.Amount<>0 THEN
                                 Gnljnline.INSERT;
                                 RunBal:=RunBal+(Gnljnline.Amount);
                                 END;
                                 END;
                                 END;


                                 //++++++++++++Excess to Deposit Contribution++++++++++++++++//
                                 IF RunBal > 0 THEN BEGIN
                                 LineN:=LineN+10000;

                                 Gnljnline.INIT;
                                 Gnljnline."Journal Template Name":='GENERAL';
                                 Gnljnline."Journal Batch Name":=No;
                                 Gnljnline."Line No.":=LineN;
                                 Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
                                 Gnljnline."Account No.":=RcptBufLines."Member No";
                                 Gnljnline.VALIDATE(Gnljnline."Account No.");
                                 Gnljnline."Document No.":="Document No";
                                 Gnljnline."Posting Date":="Posting date";
                                 Gnljnline.Description:=RcptBufLines."Transaction No"+'-'+Remarks;
                                 Gnljnline.Amount:=RunBal*-1;
                                 Gnljnline.VALIDATE(Gnljnline.Amount);
                                 Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
                                 IF Gnljnline.Amount<>0 THEN
                                 Gnljnline.INSERT;
                                 RunBal:=RunBal-(Gnljnline.Amount*-1);
                                 END;
                                 UNTIL RcptBufLines.NEXT=0;
                                 END;


                                 //
                                 CALCFIELDS("Scheduled Amount");
                                 // END OF MEMBER NOT FOUND
                                 //++++++++++++++++++Balance With Bank Entry+++++++++++++++++++++++//
                                  LineN:=LineN+100;
                                  Gnljnline.INIT;
                                  Gnljnline."Journal Template Name":='GENERAL';
                                  Gnljnline."Journal Batch Name":=No;
                                  Gnljnline."Line No.":=LineN;
                                  Gnljnline."Account Type":=Gnljnline."Account Type"::"Bank Account";
                                  Gnljnline."Account No.":="Account No";
                                  Gnljnline.VALIDATE(Gnljnline."Account No.");
                                  Gnljnline."Document No.":="Document No";
                                  Gnljnline."Posting Date":="Posting date";
                                  Gnljnline.Description:=Remarks;
                                  //Gnljnline.Amount:=Amount;
                                  Gnljnline.Amount:="Scheduled Amount";
                                  Gnljnline.VALIDATE(Gnljnline.Amount);
                                  Gnljnline."Shortcut Dimension 1 Code":='BOSA';
                                  IF Gnljnline.Amount<>0 THEN
                                  Gnljnline.INSERT;


                                 //Post New
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",No);
                                 IF Gnljnline.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::Codeunit50013,Gnljnline);
                                 END;
                                 //Posted:=TRUE;
                                 "Posted By":=No;
                                 MODIFY;

                                 MESSAGE('Paybill Successfully Generated');
                                 {
                                 Posted:=True;
                                 MODIFY;
                                  }
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1102755003;2;Field  ;
                SourceExpr="Entered By";
                Enabled=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Posting date";
                Editable=true }

    { 1102755023;2;Field  ;
                SourceExpr="Loan CutOff Date" }

    { 1102755006;2;Field  ;
                SourceExpr=Remarks }

    { 1102755007;2;Field  ;
                SourceExpr="Total Count" }

    { 1102755008;2;Field  ;
                SourceExpr="Posted By" }

    { 1102755009;2;Field  ;
                SourceExpr="Account Type" }

    { 1102755010;2;Field  ;
                SourceExpr="Account No" }

    { 1102755015;2;Field  ;
                SourceExpr="Employer Code" }

    { 1102755011;2;Field  ;
                SourceExpr="Document No" }

    { 1102755012;2;Field  ;
                SourceExpr=Posted;
                Editable=true }

    { 1102755013;2;Field  ;
                SourceExpr=Amount }

    { 1102755014;2;Field  ;
                SourceExpr="Scheduled Amount" }

    { 1102755016;1;Part   ;
                Name=Bosa receipt lines;
                CaptionML=ENU=Paybill Transactions Details;
                SubPageLink=Receipt Header No=FIELD(No);
                PagePartID=Page51516278;
                PartType=Page }

  }
  CODE
  {
    VAR
      Gnljnline@1102755005 : Record 81;
      PDate@1102755004 : Date;
      DocNo@1102755003 : Code[20];
      RunBal@1102755002 : Decimal;
      ReceiptsProcessingLines@1102755001 : Record 51516271;
      LineNo@1102755000 : Integer;
      LBatches@1000000000 : Record 51516236;
      Jtemplate@1000000001 : Code[30];
      JBatch@1000000002 : Code[30];
      "Cheque No."@1000000003 : Code[20];
      DActivityBOSA@1000000005 : Code[20];
      DBranchBOSA@1000000004 : Code[20];
      ReptProcHeader@1000000006 : Record 51516270;
      Cust@1000000007 : Record 51516223;
      MembPostGroup@1000000008 : Record 92;
      Loantable@1102755006 : Record 51516230;
      LRepayment@1102755007 : Decimal;
      RcptBufLines@1102755008 : Record 51516271;
      LoanType@1102755009 : Record 51516240;
      LoanApp@1102755010 : Record 51516230;
      Interest@1102755011 : Decimal;
      LineN@1102755012 : Integer;
      TotalRepay@1102755013 : Decimal;
      MultipleLoan@1102755014 : Integer;
      LType@1102755015 : Text;
      MonthlyAmount@1102755016 : Decimal;
      ShRec@1102755017 : Decimal;
      SHARESCAP@1102755018 : Decimal;
      DIFF@1102755019 : Decimal;
      DIFFPAID@1102755020 : Decimal;
      genstup@1102755021 : Record 51516257;
      Memb@1102755022 : Record 51516223;
      INSURANCE@1102755023 : Decimal;
      GenBatches@1102755024 : Record 232;
      Datefilter@1102755025 : Text[50];
      ReceiptLine@1102755026 : Record 51516271;

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
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post B",Gnljnline);
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

