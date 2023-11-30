OBJECT page 172031 Salary Processing Card(Posted)
{
  OBJECT-PROPERTIES
  {
    Date=01/20/23;
    Time=[ 2:10:36 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516459;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054037;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 1120054036;1 ;ActionGroup }
      { 1120054035;2 ;Action    ;
                      Name=Clear Lines;
                      Promoted=Yes;
                      Enabled=NOT ActionEnabled;
                      Image=CheckList;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('This Action will clear all the Lines for the current Salary Document. Do you want to Continue')=FALSE THEN
                                   EXIT;
                                 salarybuffer.RESET;
                                 salarybuffer.SETRANGE(salarybuffer."Salary No",No);
                                 salarybuffer.DELETEALL;

                                 BATCH_TEMPLATE:='GENERAL';
                                 BATCH_NAME:='CHECKOFF';
                                 DOCUMENT_NO:=Remarks;
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
                                 GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
                                 GenJournalLine.DELETEALL;
                               END;
                                }
      { 1120054034;2 ;Action    ;
                      Name=Import Salaries;
                      RunObject=XMLport 51516009;
                      Promoted=Yes;
                      Enabled=NOT ActionEnabled;
                      Image=Import;
                      PromotedCategory=Process }
      { 1120054033;2 ;Action    ;
                      Name=Validate Data;
                      Promoted=Yes;
                      Enabled=NOT ActionEnabled;
                      Image=ViewCheck;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD(No);
                                 TESTFIELD("Document No");
                                 salarybuffer.RESET;
                                 salarybuffer.SETRANGE("Salary No",No);
                                 IF salarybuffer.FIND('-') THEN BEGIN
                                   REPEAT
                                     salarybuffer."Account Name":='';
                                     salarybuffer.MODIFY;
                                   UNTIL salarybuffer.NEXT=0;
                                   END;
                                 salarybuffer.RESET;
                                 salarybuffer.SETRANGE("Salary No",No);
                                 IF salarybuffer.FIND('-') THEN BEGIN
                                   REPEAT
                                     ObjVendor.RESET;
                                     ObjVendor.SETRANGE("No.",salarybuffer."Account No.");
                                     IF ObjVendor.FIND('-') THEN
                                     salarybuffer."Account Name":=ObjVendor.Name;
                                     salarybuffer."Mobile Phone Number":=ObjVendor."Phone No.";
                                     salarybuffer.MODIFY;
                                   UNTIL salarybuffer.NEXT=0;
                                   END;
                                 MESSAGE('Validation completed successfully.');
                               END;
                                }
      { 1120054032;2 ;Action    ;
                      Name=Process Salaries;
                      Promoted=Yes;
                      Enabled=NOT ActionEnabled;
                      Image=Apply;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to Transfer this Salary to Journals ?')=FALSE THEN
                                   EXIT;
                                 TESTFIELD("Document No");
                                 TESTFIELD(Amount);
                                 Datefilter:='..'+FORMAT("Posting date");
                                 IF Amount<>"Scheduled Amount" THEN
                                   ERROR('Scheduled Amount must be equal to the Cheque Amount');
                                 CheckoffMessages.DELETEALL;
                                 BATCH_TEMPLATE:='GENERAL';
                                 BATCH_NAME:='SALARIES';
                                 DOCUMENT_NO:="Document No";
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
                                 GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
                                 GenJournalLine.DELETEALL;
                                 ObjGenSetup.GET();
                                 salarybuffer.RESET;
                                 salarybuffer.SETRANGE("Salary No",No);
                                 IF salarybuffer.FIND('-') THEN BEGIN
                                   Window.OPEN('Processing Salary: @1@@@@@@@@@@@@@@@'+'Record:#2###############');
                                   TotalCount:=salarybuffer.COUNT;
                                   REPEAT
                                     MessageC:='';
                                     Percentage:=(ROUND(Counter/TotalCount*10000,1));
                                     Counter:=Counter+1;
                                     Window.UPDATE(1,Percentage);
                                     Window.UPDATE(2,Counter);
                                     RunBal:=salarybuffer.Amount;
                                     RunBal:=FnPostSalaryToFosa(salarybuffer,RunBal);
                                     RunBal:=FnRecoverStatutories(salarybuffer,RunBal);
                                     RunBal:=FnRecoverMobileLoanInterest(salarybuffer,RunBal);
                                     RunBal:=FnRunInterest(salarybuffer,RunBal);
                                     RunBal:=FnRecoverMobileLoanPrincipal(salarybuffer,RunBal);
                                     RunBal:=FnRunPrinciple(salarybuffer,RunBal);
                                             FnRunStandingOrders(salarybuffer,RunBal);
                                           MemberRegister3.RESET;
                                           MemberRegister3.SETRANGE(MemberRegister3."Payroll/Staff No",salarybuffer."Staff No.");
                                           IF MemberRegister3.FINDFIRST THEN BEGIN
                                                  IF CheckoffMessages.FINDLAST THEN
                                                   SerialNo:=SerialNo+CheckoffMessages.No
                                                   ELSE
                                                   SerialNo:=1;

                                                  CheckoffMessages.INIT;
                                                  CheckoffMessages.No:=SerialNo;
                                                  CheckoffMessages."Client Code":=MemberRegister3."No.";
                                                  CheckoffMessages.Message:=MessageC;
                                                 // MessageC:=MessageC+' '+'Ess Contribution Ksh:'+FORMAT(Ess);
                                                  CheckoffMessages.INSERT
                                             END;
                                   UNTIL salarybuffer.NEXT=0;
                                 END;
                                 //Balancing Journal Entry
                                 LineNo:=LineNo+10000;
                                 SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                                 "Account Type","Account No","Posting date",Amount,'FOSA',"Document No",DOCUMENT_NO,'');
                                 MESSAGE('Salary journals Successfully Generated. BATCH NO=SALARIES.');
                                 Window.CLOSE;

                                 SalHeader.RESET;
                                 SalHeader.SETRANGE(SalHeader.No,salarybuffer."Document No.");
                                 SalHeader.SETFILTER(SalHeader."Transaction Type",'%1',SalHeader."Transaction Type"::Salary);
                                 IF SalHeader.FINDSET THEN BEGIN
                                   ObjVendor.RESET;
                                   ObjVendor.SETRANGE(ObjVendor."No.",salarybuffer."Account No.");
                                   IF ObjVendor.FIND THEN BEGIN
                                     ObjVendor."Salary earner":=TRUE
                                     END ELSE
                                     ObjVendor."Salary earner":=FALSE;
                                     ObjVendor.MODIFY;
                                   END;
                               END;
                                }
      { 1120054031;2 ;Action    ;
                      Name=Mark as Posted;
                      Promoted=Yes;
                      Enabled=false;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to mark this process as Complete ?')=FALSE THEN
                                   EXIT;
                                 TESTFIELD("Document No");
                                 TESTFIELD(Amount);
                                 salarybuffer.RESET;
                                 salarybuffer.SETRANGE("Salary No",No);
                                 IF salarybuffer.FIND('-') THEN BEGIN
                                   Window.OPEN('Processing Salary: @1@@@@@@@@@@@@@@@'+'Record:#2###############');
                                   TotalCount:=salarybuffer.COUNT;
                                   REPEAT
                                     salarybuffer.CALCFIELDS(salarybuffer."Mobile Phone Number");
                                     Percentage:=(ROUND(Counter/TotalCount*10000,1));
                                     Counter:=Counter+1;
                                     Window.UPDATE(1,Percentage);
                                     Window.UPDATE(2,Counter);
                                   SFactory.FnSendSMS('SALARIES','Your Salary has been processed at CHUNA Sacco. Dial *850#',salarybuffer."Account No.",salarybuffer."Mobile Phone Number");
                                     IF ObjVendor.GET(salarybuffer."Account No.") THEN BEGIN
                                       IF ObjVendor."Salary Processing"=FALSE THEN BEGIN
                                         ObjVendor."Salary Processing":=TRUE;
                                         ObjVendor.MODIFY;
                                       END
                                       END
                                   UNTIL salarybuffer.NEXT=0;
                                 END;
                                 Posted:=TRUE;
                                 "Posted By":=USERID;
                                 MESSAGE('Process Completed Successfully. Account Holders will receive Salary processing notification via SMS');
                                 Window.CLOSE;
                               END;
                                }
      { 1120054030;2 ;Action    ;
                      Name=Journals;
                      CaptionML=ENU=General Journal;
                      RunObject=Page 39;
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Category5 }
      { 1120054029;2 ;Action    ;
                      Name=sendemails;
                      CaptionML=ENU=Send Emails;
                      Promoted=Yes;
                      Image=Email;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 // IF CONFIRM('Are you sure you want to send the payslips on email') THEN BEGIN
                                 //   salarybuffer.RESET;
                                 //   salarybuffer.SETRANGE("Salary No",No);
                                 //   salarybuffer.SETRANGE("Email Sent",FALSE);
                                 //   salarybuffer.SETFILTER(Amount,'<>%1',0);
                                 //   IF salarybuffer.FINDSET THEN BEGIN
                                 //     REPEAT
                                 //
                                 //     SMTPSetup.GET();
                                 //     Filename:='';
                                 //     Filename:= SMTPSetup."Path to Save Report"+'Payslip.pdf';
                                 //
                                 //     Vendor.RESET;
                                 //     Vendor.SETRANGE("No.",salarybuffer."Account No.");
                                 //     IF Vendor.FINDFIRST THEN BEGIN
                                 //       IF Vendor."E-Mail"<>'' THEN BEGIN
                                 //     REPORT.SAVEASPDF(REPORT::"Salary Slip2",Filename,Vendor);
                                 //
                                 //     SMTPMail.CreateMessage(SMTPSetup."Email Sender Name",SMTPSetup."Email Sender Address",Vendor."E-Mail",'Payslip - '+"Document No",'',TRUE);
                                 //     //SMTPMail.AppendBody('************DO NOT REPLY*************');
                                 //     //SMTPMail.AppendBody('<br><br>');
                                 //
                                 //     DearStament:='Dear '+Vendor.Name;
                                 //
                                 //     SMTPMail.AppendBody(DearStament);
                                 //     SMTPMail.AppendBody('<br><br>');
                                 //     SMTPMail.AppendBody('Attached kindly find your Payslip');// for the month of January 2014');
                                 //     SMTPMail.AppendBody('<br><br>');
                                 //     SMTPMail.AppendBody('<br><br>');
                                 //     SMTPMail.AppendBody('Regards');
                                 //     //SMTPMail.AppendBody('CHUNA SACCO');
                                 //     SMTPMail.AppendBody('<br><br>');
                                 //     SMTPMail.AppendBody(SMTPSetup."Email Sender Name");
                                 //     SMTPMail.AppendBody('<br><br>');
                                 //     SMTPMail.AppendBody('CHUNA SACCO');
                                 //     //SMTPMail.AppendBody('blaaaPlease find attached your payslip');
                                 //     //SMTPMail.AppendBody('<br><br>');
                                 //     //SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this email ID.');
                                 //     SMTPMail.AddAttachment(Filename,Attachment);
                                 //     SMTPMail.Send;
                                 //      salarybuffer."Email Sent":=TRUE;
                                 //          salarybuffer.MODIFY;
                                 //          COMMIT;
                                 //     END;
                                 //        END;
                                 //     UNTIL salarybuffer.NEXT=0;
                                 //
                                 //     END;
                                 //     MESSAGE('Emails sent successfully');
                                 //   END;
                               END;
                                }
      { 1120054038;2 ;Action    ;
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
                                            TempString:='';
                                           MyString:=Members.Name;
                                           TempString := CONVERTSTR(MyString,' ',',');
                                           TempString := CONVERTSTR(MyString,' ',',');
                                           IF TempString<>'' THEN
                                           String1 := SELECTSTR(1,TempString);
                                           Name:=SplitNames(TempString);
                                           //MESSAGE('%1',Name);
                                         Members.CALCFIELDS(Members."Current Savings");
                                         Salutation:='';
                                         Salutation:='Dear '+Name+' your deductions are as follows: '+CheckoffMessages.Message+' total deposits Ksh'+FORMAT(Members."Current Savings");
                                         SkyMbanking.SendSms(Source::SALARYDEDUCTIONS,'+254721642818',Salutation,'','',TRUE,200,TRUE);
                                         END;
                                         UNTIL CheckoffMessages.NEXT=0;
                                         END;
                                         END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr=No }

    { 1120054003;2;Field  ;
                SourceExpr="No. Series" }

    { 1120054004;2;Field  ;
                SourceExpr=Posted }

    { 1120054005;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054006;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054007;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054008;2;Field  ;
                SourceExpr=Remarks }

    { 1120054009;2;Field  ;
                SourceExpr="Date Filter" }

    { 1120054010;2;Field  ;
                SourceExpr="Time Entered" }

    { 1120054011;2;Field  ;
                SourceExpr="Posting date" }

    { 1120054012;2;Field  ;
                SourceExpr="Account Type" }

    { 1120054013;2;Field  ;
                SourceExpr="Account No" }

    { 1120054014;2;Field  ;
                SourceExpr="Document No" }

    { 1120054015;2;Field  ;
                SourceExpr=Amount }

    { 1120054016;2;Field  ;
                SourceExpr="Scheduled Amount" }

    { 1120054017;2;Field  ;
                SourceExpr="Total Count" }

    { 1120054018;2;Field  ;
                SourceExpr="Account Name" }

    { 1120054019;2;Field  ;
                SourceExpr="Employer Code" }

    { 1120054020;2;Field  ;
                SourceExpr="Cheque No." }

    { 1120054021;2;Field  ;
                SourceExpr=Pension }

    { 1120054022;2;Field  ;
                SourceExpr=Discard }

    { 1120054023;2;Field  ;
                SourceExpr="Exempt Loan Repayment" }

    { 1120054024;2;Field  ;
                SourceExpr="Pre-Post Blocked Status Update" }

    { 1120054025;2;Field  ;
                SourceExpr="Post-Post Blocked Statu Update" }

    { 1120054026;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054027;2;Field  ;
                SourceExpr="Exempt Processing Fee" }

    { 1120054028;1;Part   ;
                Name=50000;
                CaptionML=ENU=Salary Processing Lines;
                SubPageLink=Salary No=FIELD(No);
                PagePartID=Page51516501;
                PartType=Page }

  }
  CODE
  {
    VAR
      Gnljnline@1120054043 : Record 81;
      PDate@1120054042 : Date;
      DocNo@1120054041 : Code[20];
      RunBal@1120054040 : Decimal;
      ReceiptsProcessingLines@1120054039 : Record 51516282;
      Name@1120054056 : Text;
      String1@1120054055 : Text;
      MyString@1120054054 : Text;
      TempString@1120054053 : Text;
      LineNo@1120054038 : Integer;
      LBatches@1120054037 : Record 51516236;
      Jtemplate@1120054036 : Code[30];
      JBatch@1120054035 : Code[30];
      "Cheque No."@1120054034 : Code[20];
      DActivityBOSA@1120054033 : Code[20];
      DBranchBOSA@1120054032 : Code[20];
      ReptProcHeader@1120054031 : Record 51516281;
      Cust@1120054030 : Record 51516223;
      salarybuffer@1120054029 : Record 51516317;
      SalHeader@1120054028 : Record 51516459;
      Sto@1120054027 : Record 51516307;
      ObjVendor@1120054026 : Record 23;
      MembLedg@1120054025 : Record 51516224;
      SFactory@1120054024 : Codeunit 51516007;
      BATCH_NAME@1120054023 : Code[50];
      BATCH_TEMPLATE@1120054022 : Code[50];
      DOCUMENT_NO@1120054021 : Code[40];
      GenJournalLine@1120054020 : Record 81;
      ActionEnabled@1120054019 : Boolean;
      ObjVendorLedger@1120054018 : Record 25;
      ObjGenSetup@1120054017 : Record 51516257;
      Charges@1120054016 : Record 51516439;
      SalProcessingFee@1120054015 : Decimal;
      LoanApp@1120054014 : Record 51516230;
      Datefilter@1120054013 : Text;
      DedStatus@1120054012 : 'Successfull,Partial Deduction,Failed';
      ObjSTORegister@1120054011 : Record 51516308;
      ObjLoanProducts@1120054010 : Record 51516240;
      Window@1120054009 : Dialog;
      TotalCount@1120054008 : Integer;
      Counter@1120054007 : Integer;
      Percentage@1120054006 : Integer;
      EXTERNAL_DOC_NO@1120054005 : Code[40];
      SMSCODE@1120054004 : Code[30];
      enddate@1120054003 : Date;
      MemberRegister3@1120054002 : Record 51516223;
      Stoint@1120054001 : Decimal;
      Stopr@1120054000 : Decimal;
      CheckoffMessages@1120054051 : Record 50699;
      SerialNo@1120054050 : Integer;
      MessageC@1120054049 : Text[200];
      SMSMessage@1120054048 : Record 51516329;
      iEntryNo@1120054047 : Integer;
      SkyMbanking@1120054046 : Codeunit 51516701;
      Source@1120054045 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,CHECKOFFDEDUCTIONS,SALARYDEDUCTIONS';
      Salutation@1120054044 : Text;
      Members@1120054052 : Record 51516223;

    LOCAL PROCEDURE FnPostSalaryToFosa@1000000020(ObjSalaryLines@1000000000 : Record 51516317;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
    BEGIN
      LineNo:=LineNo+10000;
      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
      GenJournalLine."Account Type"::Vendor,ObjSalaryLines."Account No.","Posting date",ObjSalaryLines.Amount*-1,'FOSA',EXTERNAL_DOC_NO,FORMAT("Transaction Type"),'');
      EXIT(RunningBalance);
    END;

    LOCAL PROCEDURE FnRecoverStatutories@1000000005(ObjSalaryLines@1000000000 : Record 51516317;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
    BEGIN
      ObjGenSetup.GET();
      IF Charges.GET('SALARYP') THEN
      BEGIN
        IF "Transaction Type" = "Transaction Type"::" " THEN BEGIN
          //---------EARN-------------------------
          LineNo:=LineNo+10000;
          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
          GenJournalLine."Account Type"::"G/L Account",Charges."GL Account","Posting date",Charges."Charge Amount"*-1,'FOSA',EXTERNAL_DOC_NO,
          FORMAT("Transaction Type")+' Fee','');
          //-----------RECOVER--------------------
          LineNo:=LineNo+10000;
          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
          GenJournalLine."Account Type"::Vendor,ObjSalaryLines."Account No.","Posting date",Charges."Charge Amount",'FOSA',EXTERNAL_DOC_NO,
          'Processing Fee','');

          SalProcessingFee:=Charges."Charge Amount";
          RunningBalance:=RunningBalance-SalProcessingFee;
          LineNo:=LineNo+10000;
          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
          GenJournalLine."Account Type"::"G/L Account",ObjGenSetup."Excise Duty Account","Posting date",Charges."Charge Amount"*-0.2,'FOSA',EXTERNAL_DOC_NO,
          FORMAT("Transaction Type"),'');
          //--------------RECOVER------------------
          LineNo:=LineNo+10000;
          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
          GenJournalLine."Account Type"::Vendor,ObjSalaryLines."Account No.","Posting date",Charges."Charge Amount"*0.2,'FOSA',EXTERNAL_DOC_NO,
          '20% Excise Duty on '+FORMAT("Transaction Type"),'');
          RunningBalance:=RunningBalance-SalProcessingFee*0.2;
      END;
      END;

      IF Charges.GET(SMSCODE) THEN
      BEGIN
        IF "Transaction Type" = "Transaction Type"::" " THEN BEGIN
        //--------------EARN----------------------
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
        GenJournalLine."Account Type"::"G/L Account",Charges."GL Account","Posting date",Charges."Charge Amount"*-1,'FOSA',EXTERNAL_DOC_NO,
        FORMAT("Transaction Type"),'');
        //--------------RECOVER------------------
        LineNo:=LineNo+10000;
        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
        GenJournalLine."Account Type"::Vendor,ObjSalaryLines."Account No.","Posting date",Charges."Charge Amount",'FOSA',EXTERNAL_DOC_NO,
        Charges.Description,'');
        RunningBalance:=RunningBalance-Charges."Charge Amount";
      END;
      END;
      EXIT(RunningBalance);
    END;

    LOCAL PROCEDURE FnRecoverMobileLoanInterest@1000000014(ObjRcptBuffer@1000000000 : Record 51516317;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Client Code",ObjRcptBuffer."Account No.");
      LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      LoanApp.SETFILTER(Source,FORMAT(LoanApp.Source::FOSA));
      LoanApp.SETFILTER("Loan Product Type",'MSADV');
      LoanApp.SETFILTER(Posted,'Yes');
      IF LoanApp.FIND('-') THEN
        BEGIN
          REPEAT
          LoanApp.CALCFIELDS(LoanApp."Oustanding Interest");
          LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
         // IF (SFactory.FnGetInterestDueFiltered(LoanApp,Datefilter)-ABS(LoanApp."Oustanding Interest"))>0 THEN
         IF LoanApp."Outstanding Balance" > 0 THEN
            BEGIN
                  IF  RunningBalance > 0 THEN
                    BEGIN
                      AmountToDeduct:=0;
                      AmountToDeduct:=LoanApp."Loan Interest Repayment";//SFactory.FnGetInterestDueFiltered(LoanApp,Datefilter)-ABS(LoanApp."Oustanding Interest");
                      IF RunningBalance <= AmountToDeduct THEN
                      AmountToDeduct:=RunningBalance;
                      //-------------PAY----------------------------
                      LineNo:=LineNo+10000;
                      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                      GenJournalLine."Account Type"::Customer,ObjRcptBuffer."Account No.","Posting date",AmountToDeduct*-1,'FOSA',EXTERNAL_DOC_NO,
                      FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),LoanApp."Loan  No.");
                      //-------------RECOVER------------------------
                      LineNo:=LineNo+10000;
                      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                      GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Account No.","Posting date",AmountToDeduct,'FOSA',LoanApp."Loan  No.",
                      FORMAT(GenJournalLine."Transaction Type"::"Interest Paid")+'-'+LoanApp."Loan Product Type",LoanApp."Loan  No.");
                      MessageC:=MessageC+' '+LoanApp."Loan Product Type Name"+' Ksh:'+FORMAT(AmountToDeduct);
                      RunningBalance:=RunningBalance-AmountToDeduct;
                  END;
                END;
        UNTIL LoanApp.NEXT = 0;
        END;
        EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnRecoverMobileLoanPrincipal@1000000012(ObjRcptBuffer@1000000000 : Record 51516317;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      varLRepayment@1000000003 : Decimal;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Client Code",ObjRcptBuffer."Account No.");
      LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      LoanApp.SETFILTER(Source,FORMAT(LoanApp.Source::FOSA));
      LoanApp.SETFILTER("Loan Product Type",'MSADV');
      LoanApp.SETFILTER(Posted,'Yes');
      IF LoanApp.FIND('-') THEN  BEGIN
        REPEAT
          IF  RunningBalance > 0 THEN
            BEGIN
              LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
              IF LoanApp."Outstanding Balance" > 0 THEN
                BEGIN
                  varLRepayment:=0;
                  varLRepayment:=LoanApp."Loan Principle Repayment";
                  IF LoanApp."Loan Product Type"='GUR' THEN
                    varLRepayment:=LoanApp.Repayment;
                  IF varLRepayment >0 THEN
                    BEGIN
                      IF varLRepayment>LoanApp."Outstanding Balance" THEN
                         varLRepayment:=LoanApp."Outstanding Balance";

                      IF RunningBalance > 0 THEN
                        BEGIN
                          IF RunningBalance > varLRepayment THEN
                            BEGIN
                                AmountToDeduct:=varLRepayment;
                              END
                          ELSE
                               AmountToDeduct:=RunningBalance;
                          END;
                    //---------------------PAY-------------------------------
                    LineNo:=LineNo+10000;
                    SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                    GenJournalLine."Account Type"::Customer,ObjRcptBuffer."Account No.","Posting date",AmountToDeduct*-1,'FOSA',EXTERNAL_DOC_NO,
                    FORMAT(GenJournalLine."Transaction Type"::Repayment),LoanApp."Loan  No.");
                    //--------------------RECOVER-----------------------------
                    LineNo:=LineNo+10000;
                    SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Account No.","Posting date",AmountToDeduct,'FOSA',LoanApp."Loan  No.",
                    FORMAT(GenJournalLine."Transaction Type"::Repayment)+'-'+LoanApp."Loan Product Type",LoanApp."Loan  No.");
                    RunningBalance:=RunningBalance-AmountToDeduct;

                    MessageC:=MessageC+' '+LoanApp."Loan Product Type Name"+' Ksh:'+FORMAT(AmountToDeduct);
                    END;
               END;
      END;
      UNTIL LoanApp.NEXT = 0;
      END;
        EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnRunInterest@1000000000(ObjRcptBuffer@1000000000 : Record 51516317;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjReceiptTransactions@1000000003 : Record 51516246;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Client Code",ObjRcptBuffer."Account No.");
      LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      LoanApp.SETFILTER(Source,FORMAT(LoanApp.Source::FOSA));
      IF LoanApp.FIND('-') THEN
        BEGIN
          REPEAT
           IF ObjLoanProducts.GET(LoanApp."Loan Product Type") THEN
            BEGIN
              IF ObjLoanProducts."Recovery Mode"=ObjLoanProducts."Recovery Mode"::Salary THEN
                 BEGIN
                  LoanApp.CALCFIELDS(LoanApp."Oustanding Interest");
                   LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
                  //IF (SFactory.FnGetInterestDueFiltered(LoanApp,Datefilter)-ABS(LoanApp."Oustanding Interest"))>0 THEN
                    IF LoanApp."Outstanding Balance" > 0 THEN
                    BEGIN
                          IF  RunningBalance > 0 THEN
                            BEGIN
                              AmountToDeduct:=0;
                              AmountToDeduct:=LoanApp."Loan Interest Repayment";//SFactory.FnGetInterestDueFiltered(LoanApp,Datefilter)-ABS(LoanApp."Oustanding Interest");
                              IF RunningBalance <= AmountToDeduct THEN
                              AmountToDeduct:=RunningBalance;
                              LineNo:=LineNo+10000;
                              SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                              GenJournalLine."Account Type"::Customer,ObjRcptBuffer."Account No.","Posting date",AmountToDeduct*-1,FORMAT(LoanApp.Source),EXTERNAL_DOC_NO,
                              FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),LoanApp."Loan  No.");

                              LineNo:=LineNo+10000;
                              SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                              GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Account No.","Posting date",AmountToDeduct,FORMAT(LoanApp.Source),LoanApp."Loan  No.",
                              FORMAT(GenJournalLine."Transaction Type"::"Interest Paid")+'-'+LoanApp."Loan Product Type",LoanApp."Loan  No.");
                              RunningBalance:=RunningBalance-AmountToDeduct;
                              MessageC:=MessageC+' '+LoanApp."Loan Product Type Name"+' Ksh:'+FORMAT(AmountToDeduct);
                          END;
                        END;
                      END;
                    END;
        UNTIL LoanApp.NEXT = 0;
        END;
        EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnRunPrinciple@1000000001(ObjRcptBuffer@1000000000 : Record 51516317;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjReceiptTransactions@1000000003 : Record 51516246;
      varTotalRepay@1000000004 : Decimal;
      varMultipleLoan@1000000005 : Decimal;
      varLRepayment@1000000006 : Decimal;
      PRpayment@1000000007 : Decimal;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      varTotalRepay:=0;
      varMultipleLoan:=0;
      LoanApp.RESET;
      LoanApp.SETCURRENTKEY(Source,"Issued Date","Loan Product Type","Client Code","Staff No","Employer Code");
      LoanApp.SETRANGE(LoanApp."Account No",ObjRcptBuffer."Account No.");//Account No for FOSA Loans

      //LoanApp.SETFILTER(LoanApp."Date filter",Datefilter);
      LoanApp.SETFILTER(Source,FORMAT(LoanApp.Source::FOSA));

      IF LoanApp.FIND('-') THEN BEGIN
        REPEAT
         // MESSAGE('am here');
          IF ObjLoanProducts.GET(LoanApp."Loan Product Type") THEN
            BEGIN
              IF ObjLoanProducts."Recovery Mode"=ObjLoanProducts."Recovery Mode"::Salary THEN
                BEGIN
                  //MESSAGE('run balance is %1',RunningBalance);
                  IF  RunningBalance > 0 THEN
                    BEGIN
                      LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
                      IF LoanApp."Outstanding Balance" > 0 THEN
                        BEGIN
                          varLRepayment:=0;
                          PRpayment:=0;
                          varLRepayment:=LoanApp."Loan Principle Repayment";
                          IF LoanApp."Loan Product Type"='GUR' THEN
                            varLRepayment:=LoanApp.Repayment;
                          IF varLRepayment >0 THEN
                            BEGIN
                              IF varLRepayment>LoanApp."Outstanding Balance" THEN
                                 varLRepayment:=LoanApp."Outstanding Balance";

                              IF RunningBalance > 0 THEN
                                BEGIN
                                  IF RunningBalance > varLRepayment THEN
                                    BEGIN
                                        AmountToDeduct:=varLRepayment;
                                      END
                                  ELSE
                                       AmountToDeduct:=RunningBalance;
                                  END;

                                     // MESSAGE('loan no is %1',LoanApp."Loan  No.");
                            //-------------PAY------------------
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                            GenJournalLine."Account Type"::Member,LoanApp."Client Code","Posting date",AmountToDeduct*-1,FORMAT(LoanApp.Source),EXTERNAL_DOC_NO,
                            FORMAT(GenJournalLine."Transaction Type"::Repayment),LoanApp."Loan  No.");
                            //-------------RECOVER---------------
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                            GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Account No.","Posting date",AmountToDeduct,FORMAT(LoanApp.Source),LoanApp."Loan  No.",
                            FORMAT(GenJournalLine."Transaction Type"::Repayment)+'-'+LoanApp."Loan Product Type",LoanApp."Loan  No.");
                            RunningBalance:=RunningBalance-AmountToDeduct;
                            MessageC:=MessageC+' '+LoanApp."Loan Product Type Name"+' Ksh:'+FORMAT(AmountToDeduct);
                            END;
                       END;
                    END;
                 END;
      END;
      UNTIL LoanApp.NEXT = 0;
      END;
      EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnRunStandingOrders@1000000004(ObjRcptBuffer@1000000000 : Record 51516317;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjReceiptTransactions@1000000003 : Record 51516246;
      varTotalRepay@1000000004 : Decimal;
      varMultipleLoan@1000000005 : Decimal;
      varLRepayment@1000000006 : Decimal;
      PRpayment@1000000007 : Decimal;
      ObjStandingOrders@1000000008 : Record 51516307;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
      varTotalRepay:=0;
      varMultipleLoan:=0;
      ObjStandingOrders.RESET;
      ObjStandingOrders.SETCURRENTKEY("No.","Source Account No.");
      ObjStandingOrders.SETRANGE("Source Account No.",ObjRcptBuffer."Account No.");
      ObjStandingOrders.SETRANGE(Status,ObjStandingOrders.Status::Approved);
      ObjStandingOrders.SETRANGE("Is Active",TRUE);
      ObjStandingOrders.SETRANGE(Retired,FALSE);
      ObjStandingOrders.SETRANGE("Standing Order Type",ObjStandingOrders."Standing Order Type"::Salary);
      IF ObjStandingOrders.FIND('-') THEN BEGIN
         enddate:=CALCDATE('+1M',ObjStandingOrders."End Date");
         IF enddate>=TODAY THEN BEGIN
        REPEAT
          IF  RunningBalance > 0 THEN
            BEGIN
                    IF ObjStandingOrders."Next Run Date" = 0D THEN
                    ObjStandingOrders."Next Run Date":=ObjStandingOrders."Effective/Start Date";

                     //ObjStandingOrders.CALCFIELDS("Allocated Amount");
                    IF RunningBalance >=ObjStandingOrders.Amount THEN
                      BEGIN
                          AmountToDeduct:=ObjStandingOrders.Amount;
                          DedStatus:=DedStatus::Successfull;
                          IF AmountToDeduct >= ObjStandingOrders.Balance THEN
                            BEGIN
                              AmountToDeduct:=ObjStandingOrders.Balance;
                              ObjStandingOrders.Balance:=0;
                              ObjStandingOrders."Next Run Date":=CALCDATE(ObjStandingOrders.Frequency,ObjStandingOrders."Next Run Date");
                              ObjStandingOrders.Unsuccessfull:=FALSE;
                              MessageC:=MessageC+' '+'Standing Order Ksh:'+FORMAT(AmountToDeduct);
                            END
                          ELSE
                            BEGIN
                              ObjStandingOrders.Balance:=ObjStandingOrders.Balance-AmountToDeduct;
                              ObjStandingOrders.Unsuccessfull:=TRUE;
                           END;
                      END
                    ELSE
                      BEGIN
                        IF ObjStandingOrders."Don't Allow Partial Deduction" = TRUE THEN
                          BEGIN
                            AmountToDeduct:=0;
                            DedStatus:=DedStatus::Failed;
                            ObjStandingOrders.Balance:=ObjStandingOrders.Amount;
                            ObjStandingOrders.Unsuccessfull:=TRUE;
                           END
                        ELSE
                          BEGIN
                          DedStatus:=DedStatus::"Partial Deduction";
                          ObjStandingOrders.Balance:=ObjStandingOrders.Amount-AmountToDeduct;
                          ObjStandingOrders.Unsuccessfull:=TRUE;
                        END;
                      END;



                    IF ObjStandingOrders."Destination Account Type"<>ObjStandingOrders."Destination Account Type"::BOSA THEN
                    RunningBalance:=FnNonBosaStandingOrderTransaction(ObjStandingOrders,RunningBalance)
                    ELSE BEGIN
                    RunningBalance:=FnBosaStandingOrderTransaction(ObjStandingOrders,RunningBalance)
                    END;


                    ObjStandingOrders.Effected:=TRUE;
                    ObjStandingOrders."Date Reset":=TODAY;
                    ObjStandingOrders."Next Run Date":=CALCDATE('-1D',CALCDATE('1M',DMY2DATE(1,DATE2DMY(CALCDATE(ObjStandingOrders.Frequency,TODAY),2),DATE2DMY(CALCDATE(ObjStandingOrders.Frequency,TODAY),3))));
                    ObjStandingOrders.MODIFY;

                    FnRegisterProcessedStandingOrder(ObjStandingOrders,AmountToDeduct);
            END;
      UNTIL ObjStandingOrders.NEXT = 0;
      END;
      END;
      EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnCheckIfStandingOrderIsRunnable@1000000009(ObjStandingOrders@1000000000 : Record 51516307) DontEffect : Boolean;
    BEGIN
      DontEffect:=FALSE;

      IF ObjStandingOrders."Effective/Start Date" <> 0D THEN BEGIN
      IF ObjStandingOrders."Effective/Start Date" > TODAY THEN BEGIN
      IF DATE2DMY(TODAY,2) <> DATE2DMY(ObjStandingOrders."Effective/Start Date",2) THEN
      DontEffect:=TRUE;
      END;
      END;
      EXIT(DontEffect);
    END;

    LOCAL PROCEDURE FnNonBosaStandingOrderTransaction@1000000015(ObjRcptBuffer@1000000000 : Record 51516307;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjReceiptTransactions@1000000003 : Record 51516246;
      varTotalRepay@1000000004 : Decimal;
      varMultipleLoan@1000000005 : Decimal;
      varLRepayment@1000000006 : Decimal;
      PRpayment@1000000007 : Decimal;
      ObjStandingOrders@1000000008 : Record 51516307;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
          //-------------RECOVER-----------------------------------------------------------------------------------------------------------------------
         IF ObjVendor.GET(ObjRcptBuffer."Destination Account No.") THEN BEGIN
          LineNo:=LineNo+10000;
          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
          GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Source Account No.","Posting date",ObjRcptBuffer.Amount,'FOSA',ObjRcptBuffer."No.",
          'Standing Order to '+ObjVendor.Name,'');
          END;
          //-------------PAY----------------------------------------------------------------------------------------------------------------------------
          IF ObjVendor.GET(ObjRcptBuffer."Source Account No.") THEN BEGIN
          LineNo:=LineNo+10000;
          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
          GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Destination Account No.","Posting date",ObjRcptBuffer.Amount*-1,'FOSA',ObjRcptBuffer."No.",
          'Standing Order From '+ObjVendor.Name,'');
          RunningBalance:=RunningBalance-ObjRcptBuffer.Amount;
          END;

      EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnBosaStandingOrderTransaction@1000000021(ObjRcptBuffer@1000000000 : Record 51516307;RunningBalance@1000000001 : Decimal) : Decimal;
    VAR
      AmountToDeduct@1000000002 : Decimal;
      ObjReceiptTransactions@1000000003 : Record 51516246;
      varTotalRepay@1000000004 : Decimal;
      varMultipleLoan@1000000005 : Decimal;
      varLRepayment@1000000006 : Decimal;
      PRpayment@1000000007 : Decimal;
      ObjStandingOrders@1000000008 : Record 51516307;
    BEGIN
      IF RunningBalance > 0 THEN BEGIN
        ObjReceiptTransactions.RESET;
        ObjReceiptTransactions.SETRANGE("Document No",ObjRcptBuffer."No.");
        IF ObjReceiptTransactions.FIND('-') THEN BEGIN
          //ObjReceiptTransactions.CALCFIELDS("Interest Amount");
          REPEAT
            Stoint:=0;
            Stopr:=0;
            IF ObjReceiptTransactions."Transaction Type"=ObjReceiptTransactions."Transaction Type"::Repayment  THEN BEGIN
                //-------------RECOVER principal-----------------------
               IF LoanApp.GET(ObjReceiptTransactions."Loan No.") THEN BEGIN
                LineNo:=LineNo+10000;
                 LoanApp.CALCFIELDS("Outstanding Balance","Oustanding Interest");

                 IF LoanApp."Outstanding Balance" >0 THEN
                   BEGIN

                     IF LoanApp."Oustanding Interest"<=RunningBalance THEN BEGIN
                       Stoint:=LoanApp."Oustanding Interest";
                     END
                     ELSE BEGIN
                        Stoint:=RunningBalance;
                         END;

                      //check if interest should be disregarded
                      IF (LoanApp."Loan Product Type"='ADVANCE1B') OR (LoanApp."Loan Product Type"='EMERGENCY 20') THEN
                        Stoint:=0;
                      //end of check
                     //-------------RECOVER Interest-----------------------
                      LineNo:=LineNo+10000;
                      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                      GenJournalLine."Account Type"::Member,LoanApp."Client Code","Posting date",Stoint*-1,
                      'FOSA',ObjRcptBuffer."No.",FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),ObjReceiptTransactions."Loan No.");

                      //-------------PAY Interest----------------------------
                      LineNo:=LineNo+10000;
                      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                      GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Source Account No.","Posting date",
                      Stoint,'FOSA',ObjRcptBuffer."No.",
                      FORMAT(GenJournalLine."Transaction Type"::"Interest Paid")+'-'+LoanApp."Loan Product Type",ObjReceiptTransactions."Loan No.");

                      RunningBalance:=RunningBalance-Stoint;

                      //-------------RECOVER Principal-----------------------

                      IF ObjReceiptTransactions.Amount<=RunningBalance THEN BEGIN
                       Stopr:=ObjReceiptTransactions.Amount;
                     END
                     ELSE BEGIN
                        Stopr:=RunningBalance;
                         END;

                      LineNo:=LineNo+10000;
                      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                      GenJournalLine."Account Type"::Member,LoanApp."Client Code","Posting date",(Stopr)*-1,
                      'FOSA',ObjRcptBuffer."No.",FORMAT(GenJournalLine."Transaction Type"::Repayment),ObjReceiptTransactions."Loan No.");

                      //-------------PAY Principal----------------------------
                      LineNo:=LineNo+10000;
                      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                      GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Source Account No.","Posting date",
                      Stopr,'FOSA',ObjRcptBuffer."No.",
                      FORMAT(GenJournalLine."Transaction Type"::Repayment)+'-'+LoanApp."Loan Product Type",ObjReceiptTransactions."Loan No.");

                      RunningBalance:=RunningBalance-(Stopr);


                   END;
                END;

              END
             ELSE BEGIN

                IF ObjReceiptTransactions.Amount<=RunningBalance THEN BEGIN
                       Stopr:=ObjReceiptTransactions.Amount;
                     END
                     ELSE BEGIN
                        Stopr:=RunningBalance;
                         END;

                //-------------RECOVER BOSA NONLoan Transactions-----------------------
                LineNo:=LineNo+10000;
                SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,ObjReceiptTransactions."Transaction Type",
                GenJournalLine."Account Type"::Member,ObjRcptBuffer."BOSA Account No.","Posting date",Stopr*-1,
                'FOSA',ObjRcptBuffer."No.",FORMAT(ObjReceiptTransactions."Transaction Type"),'');

                //-------------PAY BOSA NONLoan Transaction----------------------------
                LineNo:=LineNo+10000;
                SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,ObjReceiptTransactions."Transaction Type"::Prepayment,
                GenJournalLine."Account Type"::Vendor,ObjRcptBuffer."Source Account No.","Posting date",Stopr,
                'FOSA',ObjRcptBuffer."No.",FORMAT(ObjReceiptTransactions."Transaction Type"),'');

                RunningBalance:=RunningBalance-Stopr;

              END

          UNTIL ObjReceiptTransactions.NEXT=0;
          END;

      EXIT(RunningBalance);
      END;
    END;

    LOCAL PROCEDURE FnRegisterProcessedStandingOrder@1000000006(ObjStandingOrders@1000000000 : Record 51516307;AmountToDeduct@1000000001 : Decimal);
    BEGIN
      ObjSTORegister.RESET;
      ObjSTORegister.SETRANGE("Document No.",No);
      IF ObjSTORegister.FIND('-') THEN
        ObjSTORegister.DELETEALL;

      ObjSTORegister.INIT;
      ObjSTORegister."Register No.":='';
      ObjSTORegister.VALIDATE(ObjSTORegister."Register No.");
      ObjSTORegister."Standing Order No.":=ObjStandingOrders."No.";
      ObjSTORegister."Source Account No.":=ObjStandingOrders."Source Account No.";
      ObjSTORegister."Staff/Payroll No.":=ObjStandingOrders."Staff/Payroll No.";
      ObjSTORegister.Date:=TODAY;
      ObjSTORegister."Account Name":=ObjStandingOrders."Account Name";
      ObjSTORegister."Destination Account Type":=ObjStandingOrders."Destination Account Type";
      ObjSTORegister."Destination Account No.":=ObjStandingOrders."Destination Account No.";
      ObjSTORegister."Destination Account Name":=ObjStandingOrders."Destination Account Name";
      ObjSTORegister."BOSA Account No.":=ObjStandingOrders."BOSA Account No.";
      ObjSTORegister."Effective/Start Date":=ObjStandingOrders."Effective/Start Date";
      ObjSTORegister."End Date":=ObjStandingOrders."End Date";
      ObjSTORegister.Duration:=ObjStandingOrders.Duration;
      ObjSTORegister.Frequency:=ObjStandingOrders.Frequency;
      ObjSTORegister."Don't Allow Partial Deduction":=ObjStandingOrders."Don't Allow Partial Deduction";
      ObjSTORegister."Deduction Status":=DedStatus;
      ObjSTORegister.Remarks:=ObjStandingOrders."Standing Order Description";
      ObjSTORegister.Amount:=ObjStandingOrders.Amount;
      ObjSTORegister."Amount Deducted":=AmountToDeduct;
      IF ObjStandingOrders."Destination Account Type" = ObjStandingOrders."Destination Account Type"::External THEN
      ObjSTORegister.EFT:=TRUE;
      ObjSTORegister."Document No.":=No;
      ObjSTORegister.INSERT(TRUE);
    END;

    LOCAL PROCEDURE FnSalaryProcessing@1000000002();
    BEGIN
      BATCH_TEMPLATE:='GENERAL';
      BATCH_NAME:='SALARIES';
      DOCUMENT_NO:="Document No";
      EXTERNAL_DOC_NO:="Cheque No.";
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
      GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
      GenJournalLine.DELETEALL;
      ObjGenSetup.GET();
      salarybuffer.RESET;
      salarybuffer.SETRANGE("Salary No",No);

      IF salarybuffer.FIND('-') THEN BEGIN
         Window.OPEN(FORMAT("Transaction Type")+': @1@@@@@@@@@@@@@@@'+'Record:#2###############');
        TotalCount:=salarybuffer.COUNT;
        REPEAT
          Percentage:=(ROUND(Counter/TotalCount*10000,1));
          Counter:=Counter+1;
          Window.UPDATE(1,Percentage);
          Window.UPDATE(2,Counter);
          SalHeader.GET(salarybuffer."Salary No");
          RunBal:=salarybuffer.Amount;
          RunBal:=FnPostSalaryToFosa(salarybuffer,RunBal);
          IF SalHeader."Exempt Processing Fee"=FALSE THEN BEGIN
          RunBal:=FnRecoverStatutories(salarybuffer,RunBal);
            END;
         // RunBal:=FnRecoverMobileLoanInterest(salarybuffer,RunBal);   //commented because of sto
         // RunBal:=FnRunInterest(salarybuffer,RunBal);  //commented because of sto
          //RunBal:=FnRecoverMobileLoanPrincipal(salarybuffer,RunBal);
         // RunBal:=FnRunPrinciple(salarybuffer,RunBal);  //commented because of sto
          RunBal:=FnRunStandingOrders(salarybuffer,RunBal);

        UNTIL salarybuffer.NEXT=0;
      END;
      //Balancing Journal Entry
      LineNo:=LineNo+10000;
      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
      "Account Type","Account No","Posting date",Amount,'FOSA',EXTERNAL_DOC_NO,DOCUMENT_NO,'');
      MESSAGE('Salary journals Successfully Generated. BATCH NO=SALARIES.');
      Window.CLOSE;
    END;

    LOCAL PROCEDURE FnNISProcessing@1000000003();
    BEGIN
      BATCH_TEMPLATE:='GENERAL';
      BATCH_NAME:='SALARIES';
      DOCUMENT_NO:="Document No";
      EXTERNAL_DOC_NO:="Cheque No.";
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
      GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
      GenJournalLine.DELETEALL;
      ObjGenSetup.GET();
      salarybuffer.RESET;
      salarybuffer.SETRANGE("Salary No",No);
      //salarybuffer.SETRANGE("Account No.",'2747-01616-06');
      IF salarybuffer.FIND('-') THEN BEGIN
        Window.OPEN(FORMAT("Transaction Type")+': @1@@@@@@@@@@@@@@@'+'Record:#2###############');
        TotalCount:=salarybuffer.COUNT;
        REPEAT
          Percentage:=(ROUND(Counter/TotalCount*10000,1));
          Counter:=Counter+1;
          Window.UPDATE(1,Percentage);
          Window.UPDATE(2,Counter);

          RunBal:=salarybuffer.Amount;
          RunBal:=FnPostSalaryToFosa(salarybuffer,RunBal);
          RunBal:=FnRecoverStatutories(salarybuffer,RunBal);
        UNTIL salarybuffer.NEXT=0;
      END;
      //Balancing Journal Entry
      LineNo:=LineNo+10000;
      SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
      "Account Type","Account No","Posting date",Amount,'FOSA',EXTERNAL_DOC_NO,DOCUMENT_NO,'');
      MESSAGE('NIS journals Successfully Generated. BATCH NO=SALARIES.');
      Window.CLOSE;
    END;

    LOCAL PROCEDURE SplitNames@1120054005(Name@1120054000 : Text[250]) Token : Text[250];
    VAR
      Pos@1120054002 : Integer;
      Surname@1120054001 : Text;
    BEGIN
       Pos:=STRPOS(Name,',');
      IF Pos<>0 THEN
        BEGIN
          Surname:=COPYSTR(Name, 1 , Pos-1);
          Token:=Surname;
          EXIT(Token);
      //      "Other Names":=COPYSTR(Names,Pos +1);
      //      lngPos2:=STRPOS("Other Names",',');
      //      IF lngPos2<>0 THEN
      //   BEGIN
      //     "First Names":=COPYSTR("Other Names",1,lngPos2-1);
      //     "Last Names":=COPYSTR("Other Names",lngPos2+1);
      //     END
      //     ELSE
      //     EXIT;
        END;
    END;

    BEGIN
    END.
  }
}

