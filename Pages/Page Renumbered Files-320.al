OBJECT page 50011 Account Card-editable
{
  OBJECT-PROPERTIES
  {
    Date=12/18/20;
    Time=[ 9:55:12 AM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=ENU=Account Card;
    DeleteAllowed=No;
    SourceTable=Table23;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 ActivateFields;
                 {
                 IF NOT MapMgt.TestSetup THEN
                   CurrForm.MapPoint.VISIBLE(FALSE);
                 }


                 //Filter based on branch
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Global Dimension 2 Code",UsersID.Branch);
                 END;}
                 //Filter based on branch
                 {
                 StatusPermissions.RESET;
                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
                 IF StatusPermissions.FIND('-') = FALSE THEN
                 ERROR('You do not have permissions to edit account information.');
                 }
                 IF UserSetup.GET(USERID) THEN
                 BEGIN
                 IF UserSetup."View staff account"=FALSE THEN BEGIN
                 IF "Company Code"='STAFF' THEN BEGIN
                   IF "Staff UserID"<>USERID THEN
                     ERROR('You do not have permissions to view another Staff account detail.');
                     CurrPage.CLOSE;
                     END;
                   END;
                   END;

               END;

    OnFindRecord=VAR
                   RecordFound@1000 : Boolean;
                 BEGIN

                   RecordFound := FIND(Which);
                   CurrPage.EDITABLE:=TRUE;
                   CurrPage.EDITABLE := RecordFound OR (GETFILTER("No.") = '');
                   EXIT(RecordFound);
                 END;

    OnAfterGetRecord=BEGIN

                       //Hide balances for hidden accounts
                       {IF CurrForm.UnclearedCh.VISIBLE=FALSE THEN BEGIN
                       CurrForm.BookBal.VISIBLE:=TRUE;
                       CurrForm.UnclearedCh.VISIBLE:=TRUE;
                       CurrForm.AvalBal.VISIBLE:=TRUE;
                       CurrForm.Statement.VISIBLE:=TRUE;
                       CurrForm.Account.VISIBLE:=TRUE;
                       END;


                       IF Hide = TRUE THEN BEGIN
                       IF UsersID.GET(USERID) THEN BEGIN
                       IF UsersID."Show Hiden" = FALSE THEN BEGIN
                       currpage.BookBal.VISIBLE:=FALSE;
                       CurrForm.UnclearedCh.VISIBLE:=FALSE;
                       CurrForm.AvalBal.VISIBLE:=FALSE;
                       CurrForm.Statement.VISIBLE:=FALSE;
                       CurrForm.Account.VISIBLE:=FALSE;
                       END;
                       END;
                       END;
                       //Hide balances for hidden accounts
                         }
                       MinBalance:=0;
                       IF AccountType.GET("Account Type") THEN
                       MinBalance:=AccountType."Minimum Balance";

                       {CurrForm.lblID.VISIBLE := TRUE;
                       CurrForm.lblDOB.VISIBLE := TRUE;
                       CurrForm.lblRegNo.VISIBLE := FALSE;
                       CurrForm.lblRegDate.VISIBLE := FALSE;
                       CurrForm.lblGender.VISIBLE := TRUE;
                       CurrForm.txtGender.VISIBLE := TRUE;
                       IF "Account Category" <> "Account Category"::Single THEN BEGIN
                       CurrForm.lblID.VISIBLE := FALSE;
                       CurrForm.lblDOB.VISIBLE := FALSE;
                       CurrForm.lblRegNo.VISIBLE := TRUE;
                       CurrForm.lblRegDate.VISIBLE := TRUE;
                       CurrForm.lblGender.VISIBLE := FALSE;
                       CurrForm.txtGender.VISIBLE := FALSE;
                       END;}
                       OnAfterGetCurrRecord;
                       {
                       Statuschange.RESET;
                       Statuschange.SETRANGE(Statuschange."User ID",USERID);
                       Statuschange.SETRANGE(Statuschange."Function",Statuschange."Function"::"Account Status");
                       IF NOT Statuschange.FIND('-')THEN
                       CurrPage.EDITABLE:=FALSE
                       ELSE
                       CurrPage.EDITABLE:=TRUE;
                       }
                       CALCFIELDS(NetDis);
                       UnclearedLoan:=NetDis;
                       //MESSAGE('Uncleared loan is %1',UnclearedLoan);
                     END;

    OnNewRecord=BEGIN
                  OnAfterGetCurrRecord;
                END;

    OnInsertRecord=BEGIN
                     "Creditor Type":="Creditor Type"::Account;
                   END;

    OnModifyRecord=BEGIN
                     IF Rec."ATM No."<>xRec."ATM No." THEN
                       ERROR('ATM No. cannot be modified directly');
                     IF Rec."Card No."<>xRec."Card No." THEN
                       ERROR('Card No. cannot be modified directly');
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 64      ;1   ;ActionGroup;
                      Name=Account;
                      CaptionML=ENU=Account }
      { 70      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=Ledger E&ntries;
                      RunObject=20375;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=VendorLedger }
      { 68      ;2   ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Vendor),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 184     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(23),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 108     ;2   ;Separator  }
      { 1102760069;2 ;Action    ;
                      Name=Re-new Fixed Deposit;
                      CaptionML=ENU=Re-new Fixed Deposit;
                      Image=Report;
                      OnAction=BEGIN

                                 IF AccountTypes.GET("Account Type") THEN BEGIN
                                 IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF "Call Deposit" = FALSE THEN BEGIN
                                 TESTFIELD("Fixed Duration");
                                 TESTFIELD("FD Maturity Date");
                                 IF "FD Maturity Date" > TODAY THEN
                                 ERROR('Fixed deposit has not matured.');

                                 END;

                                 IF "Don't Transfer to Savings" = FALSE THEN
                                 TESTFIELD("Savings Account No.");

                                 CALCFIELDS("Last Interest Date");

                                 IF "Call Deposit" = TRUE THEN BEGIN
                                 IF "Last Interest Date" < TODAY THEN
                                 ERROR('Fixed deposit interest not UPDATED. Please update interest.');
                                 END ELSE BEGIN
                                 IF "Last Interest Date" < "FD Maturity Date" THEN
                                 ERROR('Fixed deposit interest not UPDATED. Please update interest.');
                                 END;




                                 IF CONFIRM('Are you sure you want to renew this Fixed deposit. Interest will be transfered accordingly?') = FALSE THEN
                                 EXIT;


                                 CALCFIELDS("Untranfered Interest");

                                 IF "Call Deposit" = FALSE THEN BEGIN
                                 "Date Renewed":="FD Maturity Date";
                                 END ELSE
                                 "Date Renewed":=TODAY;
                                 VALIDATE("Date Renewed");
                                 MODIFY;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;



                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-RN';
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 IF "Don't Transfer to Savings" = FALSE THEN
                                 GenJournalLine."Account No.":="Savings Account No."
                                 ELSE
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Interest Earned';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-"Untranfered Interest";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=AccountTypes."Interest Payable Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 InterestBuffer.RESET;
                                 InterestBuffer.SETRANGE(InterestBuffer."Account No","No.");
                                 IF InterestBuffer.FIND('-') THEN
                                 InterestBuffer.MODIFYALL(InterestBuffer.Transferred,TRUE);


                                 //Post
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                                 END;




                                 MESSAGE('Fixed deposit renewed successfully');
                                 END;
                                 END;
                               END;
                                }
      { 1102760068;2 ;Separator  }
      { 1102760082;2 ;Separator  }
      { 1102760126;2 ;Action    ;
                      Name=<Page Member Page - BOSA>;
                      CaptionML=ENU=Member Page;
                      RunObject=page 17365;
                      RunPageLink=Field1=FIELD(BOSA Account No);
                      Image=Planning;
                      PromotedCategory=New }
      { 1102760080;2 ;Action    ;
                      Name=<Action11027600800>;
                      CaptionML=ENU=Loans Statements;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,Cust)
                                 }
                               END;
                                }
      { 1102755033;2 ;Action    ;
                      Name=BOSA Statement;
                      Promoted=Yes;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","BOSA Account No");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516223,TRUE,FALSE,Cust);
                               END;
                                }
      { 1102755031;2 ;Action    ;
                      Name=FOSA Loans;
                      RunObject=page 17391;
                      RunPageLink=Account No=FIELD(No.),
                                  Source=FILTER(FOSA);
                      Promoted=Yes }
      { 1102755034;2 ;Action    ;
                      Name=Close Account;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                  IF CONFIRM('Are you sure you want to Close this Account?',FALSE)=TRUE THEN BEGIN
                                  IF "Balance (LCY)"-("Uncleared Cheques"+"ATM Transactions"+"EFT Transactions"+MinBalance+UnclearedLoan)<0 THEN
                                  ERROR('This Member does not enough Savings to recover Withdrawal Fee')
                                 ELSE
                                     LineN:=LineN+10000;
                                     Gnljnline.INIT;
                                     Gnljnline."Journal Template Name":='GENERAL';
                                     Gnljnline."Journal Batch Name":='ACC CLOSED';
                                     Gnljnline."Line No.":=LineN;
                                     Gnljnline."Account Type":=Gnljnline."Account Type"::Vendor;
                                     Gnljnline."Account No.":="No.";
                                     Gnljnline.VALIDATE(Gnljnline."Account No.");
                                     Gnljnline."Document No.":='LR-'+"No.";
                                     Gnljnline."Posting Date":=TODAY;
                                     Gnljnline.Amount:=500;
                                     Gnljnline.Description:='Account Closure Fee';
                                     Gnljnline.VALIDATE(Gnljnline.Amount);
                                     IF Gnljnline.Amount<>0 THEN
                                     Gnljnline.INSERT;

                                     LineN:=LineN+10000;
                                     Gnljnline.INIT;
                                     Gnljnline."Journal Template Name":='GENERAL';
                                     Gnljnline."Journal Batch Name":='ACC CLOSED';
                                     Gnljnline."Line No.":=LineN;
                                     Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::"G/L Account";
                                     Gnljnline."Bal. Account No.":='105113';
                                     Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                                     Gnljnline."Document No.":='LR-'+"No.";
                                     Gnljnline."Posting Date":=TODAY;
                                     Gnljnline.Amount:=-500;
                                     Gnljnline.Description:='Account Closure Fee';
                                     Gnljnline.VALIDATE(Gnljnline.Amount);
                                     IF Gnljnline.Amount<>0 THEN
                                     Gnljnline.INSERT;


                                 END;
                               END;
                                }
      { 1102760142;2 ;Separator  }
      { 1102760133;2 ;Action    ;
                      Name=<Action110276013300>;
                      CaptionML=ENU=Update FDR Interest;
                      Image=Report;
                      OnAction=BEGIN
                                 IF "Account Type" <> 'FIXED' THEN
                                 ERROR('Only applicable for Fixed Deposit accounts.');

                                 CALCFIELDS("Last Interest Date");

                                 IF "Last Interest Date" >= TODAY THEN
                                 ERROR('Interest Up to date.');

                                 //IF CONFIRM('Are you sure you want to update the Fixed deposit interest.?') = FALSE THEN
                                 //EXIT;


                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516275,TRUE,TRUE,Vend)
                               END;
                                }
      { 1102755009;1 ;ActionGroup }
      { 1102755008;2 ;Action    ;
                      Name=Next Of Kin;
                      CaptionML=ENU=Next Of Kin;
                      RunObject=page 17435;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1102755005;2 ;Separator  }
      { 1102755022;2 ;Action    ;
                      Name=Transfer FD Amnt from Savings;
                      OnAction=BEGIN

                                 //Transfer Balance if Fixed Deposit

                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN
                                 //IF AccountTypes."Fixed Deposit" <> TRUE THEN BEGIN
                                 IF Vend.GET("Savings Account No.") THEN BEGIN
                                 IF CONFIRM('Are you sure you want to effect the transfer from the savings account',FALSE) = FALSE THEN
                                 EXIT ELSE

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 Vend.RESET;
                                 IF Vend.FIND('-') THEN
                                 Vend.CALCFIELDS(Vend."Balance (LCY)");
                                 //IF (Vend."Balance (LCY)" - 500) < "Fixed Deposit Amount" THEN
                                 //ERROR('Savings account does not have enough money to facilate the requested trasfer.');
                                 //MESSAGE('Katabaka ene!');
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-OP';
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Savings Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Balance Tranfers';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 //GenJournalLine.Amount:="Fixed Deposit Amount";
                                 GenJournalLine.Amount:="Amount to Transfer";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                  //MESSAGE('The FDR amount is %1 ',"Fixed Deposit Amount");
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-OP';
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Balance Tranfers';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 //GenJournalLine.Amount:=-"Fixed Deposit Amount";
                                 GenJournalLine.Amount:=-"Amount to Transfer";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //END;
                                 END;
                                 END;
                                 {
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post B",GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;
                                 }


                                 {//Post New

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                 END;

                                 //Post New
                                 }

                                 {
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                    }
                                 //Transfer Balance if Fixed Deposit
                               END;
                                }
      { 1102755023;2 ;Action    ;
                      Name=Transfer FD Amount to Savings;
                      OnAction=BEGIN

                                 //Transfer Balance if Fixed Deposit

                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN
                                 IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF Vend.GET("No.") THEN BEGIN
                                 IF CONFIRM('Are you sure you want to effect the transfer from the Fixed Deposit account',FALSE) = FALSE THEN
                                 EXIT;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 Vend.CALCFIELDS(Vend."Balance (LCY)");
                                 IF (Vend."Balance (LCY)") < "Transfer Amount to Savings" THEN
                                 ERROR('Fixed Deposit account does not have enough money to facilate the requested trasfer.');

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-OP';
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Balance Tranfers';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:="Transfer Amount to Savings";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-OP';
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Savings Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Balance Tranfers';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-"Transfer Amount to Savings";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;
                                 END;
                                 END;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 MESSAGE('Amount transfered successfully.');
                               END;
                                }
      { 1102755021;2 ;Action    ;
                      Name=Renew Fixed deposit;
                      OnAction=BEGIN

                                 IF AccountTypes.GET("Account Type") THEN BEGIN
                                 IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF CONFIRM('Are you sure you want to renew the fixed deposit.',FALSE) = FALSE THEN
                                 EXIT;

                                 TESTFIELD("FD Maturity Date");
                                 IF FDType.GET("Fixed Deposit Type") THEN BEGIN
                                 "FD Maturity Date":=CALCDATE(FDType.Duration,"FD Maturity Date");
                                 "Date Renewed":=TODAY;
                                 "FDR Deposit Status Type":="FDR Deposit Status Type"::Renewed;
                                 MODIFY;

                                 MESSAGE('Fixed deposit renewed successfully');
                                 END;
                                 END;
                                 END;
                               END;
                                }
      { 1102755030;2 ;Action    ;
                      Name=Terminate Fixed Deposit;
                      OnAction=BEGIN

                                 //Transfer Balance if Fixed Deposit

                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN
                                 IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF Vend.GET("No.") THEN BEGIN
                                 IF CONFIRM('Are you sure you want to Terminate this Fixed Deposit Contract?',FALSE) = FALSE THEN
                                 EXIT;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 Vend.CALCFIELDS(Vend."Balance (LCY)");
                                 IF (Vend."Balance (LCY)") < "Transfer Amount to Savings" THEN
                                 ERROR('Fixed Deposit account does not have enough money to facilate the requested trasfer.');

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-OP';
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Termination Tranfer';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:="Balance (LCY)";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-OP';
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Savings Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Termination Tranfer';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-"Balance (LCY)";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;
                                 END;
                                 END;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 MESSAGE('Amount transfered successfully back to the savings Account.');
                                 "FDR Deposit Status Type":="FDR Deposit Status Type"::Terminated;

                                  {
                                 //Renew Fixed deposit - OnAction()

                                 IF AccountTypes.GET("Account Type") THEN BEGIN
                                 IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF CONFIRM('Are you sure you want to renew the fixed deposit.',FALSE) = FALSE THEN
                                 EXIT;

                                 TESTFIELD("FD Maturity Date");
                                 IF FDType.GET("Fixed Deposit Type") THEN BEGIN
                                 "FD Maturity Date":=CALCDATE(FDType.Duration,"FD Maturity Date");
                                 "Date Renewed":=TODAY;
                                 "FDR Deposit Status Type":="FDR Deposit Status Type"::Renewed;
                                 MODIFY;

                                 MESSAGE('Fixed deposit renewed successfully');
                                 END;
                                 END;
                                 END;
                                   }
                               END;
                                }
      { 1102755012;2 ;Action    ;
                      Name=Page Vendor Statement;
                      CaptionML=ENU=Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516248,TRUE,FALSE,Vend)
                               END;
                                }
      { 1000000000;2 ;Action    ;
                      Name=Charge Fosa Statement;
                      Promoted=Yes;
                      Image=PostApplication;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you want to charge statement fee? This will recover statement fee.',FALSE) = FALSE THEN
                                 EXIT;

                                 CALCFIELDS("Balance (LCY)","ATM Transactions");
                                 IF ("Balance (LCY)"-"ATM Transactions")<=0 THEN
                                 ERROR('This Account does not have sufficient funds');


                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN

                                 //Closure charges
                                 Charges.RESET;
                                 Charges.SETRANGE(Charges.Code,AccountTypes."Statement Charge");
                                 IF Charges.FIND('-') THEN BEGIN
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-STM';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:=Charges.Description;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=Charges."Charge Amount";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=Charges."GL Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;


                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                 END;

                                 //Post New


                                 END;
                                 //Closure charges

                                 END;
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      Name=Charge ATM Card Placement;
                      Promoted=No;
                      Image=PostApplication;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you want to post the ATM Charges fee?')=FALSE THEN
                                 EXIT;


                                 CALCFIELDS("Balance (LCY)","ATM Transactions");
                                 IF ("Balance (LCY)"-"ATM Transactions")<=0 THEN
                                 ERROR('This Account does not have sufficient funds');


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges: '+ "Card No.";
                                 GenJournalLine.Amount:=605;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;


                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":='BNK00008';
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges: No.'+ "Card No.";
                                 GenJournalLine.Amount:=-550;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;

                                 //Comms to Commissions account
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='300-000-404';
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges' + 'No.'+ "Card No.";
                                 GenJournalLine.Amount:=-50;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;

                                 //******excise duty


                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='200-000-168';
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Excise Duty' + 'No.'+ "Card No.";
                                 GenJournalLine.Amount:=-5;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;



                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                   CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                   msg:='Dear Member, Your Saccolink ATM Card is ready for collection at TELEPOST SACCO Offices';
                                   //SMSMessage("Card No.","No.","Mobile Phone No",msg);


                                   SkyMbanking.SendSms(SMSSource::ATM_COLLECTION,"Mobile Phone No",msg,"Card No.","No.",TRUE,0,TRUE);






                                 END;
                                 //Post New
                               END;
                                }
      { 1000000003;2 ;Action    ;
                      Name=Charge ATM Card Replacement;
                      Promoted=No;
                      Image=PostApplication;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to post the ATM Charges fee?')=FALSE THEN
                                 EXIT;


                                 CALCFIELDS("Balance (LCY)","ATM Transactions");
                                 IF ("Balance (LCY)"-"ATM Transactions")<=0 THEN
                                 ERROR('This Account does not have sufficient funds');


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges: '+ "Card No.";
                                 GenJournalLine.Amount:=600;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;


                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":='BNK00010';
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges: No.'+ "Card No.";
                                 GenJournalLine.Amount:=-500;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;

                                 //Comms to Commissions account
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='300-000-3016';
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges' + 'No.'+ "Card No.";
                                 GenJournalLine.Amount:=-100;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;



                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                   CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);

                                 END;
                                 //Post New
                               END;
                                }
      { 1102755017;2 ;Action    ;
                      Name=Charge Pass Book;
                      Promoted=Yes;
                      Enabled=false;
                      Image=PostApplication;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you want to charge Pass book fee? This will recover passbook fee.',FALSE) = FALSE THEN
                                 EXIT;

                                 CALCFIELDS("Balance (LCY)","ATM Transactions");
                                 IF ("Balance (LCY)"-"ATM Transactions")<=0 THEN
                                 ERROR('This Account does not have sufficient funds');


                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN

                                 //Closure charges
                                 Charges.RESET;
                                 Charges.SETRANGE(Charges.Code,AccountTypes."Statement Charge");
                                 IF Charges.FIND('-') THEN BEGIN
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":="No."+'-STM';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:=Charges.Description;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=Charges."Charge Amount";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=Charges."GL Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;


                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 //CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                                 END;

                                 //Post New


                                 END;
                                 //Closure charges

                                 END;
                               END;
                                }
      { 1000000011;2 ;Action    ;
                      Name=Disable ATM Card;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Disable ATM");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to disable ATM cards');

                                 IF CONFIRM('Are you sure you want to disable the ATM card?')=FALSE THEN
                                 EXIT;

                                 IF "Reason For Disabling ATM Card"='' THEN
                                 ERROR('You must specify reason for disabling this ATM Card');

                                 IF "Card No."=''THEN
                                 ERROR('You cannot disable a blank ATM Card');


                                 "Disable ATM Card":=TRUE;
                                 "Disabled ATM Card No":="Card No.";
                                 "Card No.":='';
                                 "ATM Prov. No":='';
                                 "Atm card ready" := FALSE;
                                 "Disabled By":=USERID;
                                 MODIFY;
                               END;
                                }
      { 1000000068;2 ;Action    ;
                      Name=Enable ATM Card;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Disable ATM");
                                 IF StatusPermissions.FIND('-') = FALSE THEN
                                 ERROR('You do not have permissions to Disable ATM cards');

                                 IF CONFIRM('Are you sure you want to enable the ATM card?')=FALSE THEN
                                 EXIT;



                                 IF "Card No."<>''THEN
                                 ERROR('You cannot Enable an active ATM Card');

                                 IF "Reason for Enabling ATM Card"='' THEN
                                 ERROR('You must specify reason for Re-enabling this atm');

                                 "Disable ATM Card":=FALSE;
                                 "Card No.":="Disabled ATM Card No";
                                 "Disabled ATM Card No":='';
                                 "Enabled By":=USERID;
                                 "Date Enabled":=TODAY;
                                 MODIFY;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000061;1;Group  ;
                Name=AccountTab;
                CaptionML=ENU=General Information;
                GroupType=Group }

    { 1000000060;2;Field  ;
                CaptionML=ENU=Account No;
                SourceExpr="No.";
                Editable=false;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 1000000059;2;Field  ;
                CaptionML=ENU=Account Name;
                SourceExpr=Name }

    { 1000000058;2;Field  ;
                CaptionML=ENU=ID No.;
                SourceExpr="ID No." }

    { 1000000057;2;Field  ;
                SourceExpr="Passport No.";
                Editable=FALSE }

    { 1000000056;2;Field  ;
                SourceExpr="Staff No" }

    { 1000000055;2;Field  ;
                SourceExpr="Force No.";
                Editable=FALSE }

    { 1000000054;2;Field  ;
                SourceExpr="Company Code";
                Editable=FALSE }

    { 1000000016;2;Field  ;
                SourceExpr="Staff UserID" }

    { 1000000053;2;Field  ;
                SourceExpr="Station/Sections";
                Editable=FALSE }

    { 1000000052;2;Field  ;
                Name=txtGender;
                CaptionML=ENU=Gender;
                SourceExpr=Gender;
                Editable=FALSE }

    { 1000000051;2;Field  ;
                SourceExpr="Marital Status";
                Editable=FALSE }

    { 1000000050;2;Field  ;
                CaptionML=ENU=Date of Birth;
                SourceExpr="Date of Birth";
                Editable=FALSE }

    { 1000000009;2;Field  ;
                SourceExpr="Phone No.";
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr="MPESA Mobile No";
                Editable=FALSE }

    { 1000000067;2;Field  ;
                SourceExpr="Sms Notification" }

    { 1000000010;2;Field  ;
                SourceExpr=Signature;
                Editable=false }

    { 1000000062;2;Field  ;
                SourceExpr=Picture;
                Editable=false }

    { 1905652901;1;Group  ;
                Name=AccountTab1;
                CaptionML=ENU=Communication Details;
                GroupType=Group }

    { 6   ;2   ;Field     ;
                SourceExpr=Address }

    { 79  ;2   ;Field     ;
                CaptionML=ENU=Post Code/City;
                SourceExpr="Post Code" }

    { 8   ;2   ;Field     ;
                SourceExpr="Address 2" }

    { 10  ;2   ;Field     ;
                SourceExpr=City }

    { 1102760103;2;Field  ;
                SourceExpr="Mobile Phone No" }

    { 48  ;2   ;Field     ;
                SourceExpr="E-Mail" }

    { 86  ;2   ;Field     ;
                SourceExpr="Home Page" }

    { 1000000008;2;Field  ;
                SourceExpr=Contact }

    { 1000000007;2;Field  ;
                SourceExpr="ContacPerson Phone" }

    { 1000000006;2;Field  ;
                SourceExpr="ContactPerson Occupation" }

    { 1000000005;2;Field  ;
                SourceExpr="ContactPerson Relation" }

    { 1102760044;2;Field  ;
                SourceExpr="Home Address" }

    { 1000000049;1;Group  ;
                Name=AccountInfo;
                CaptionML=ENU=Account Information;
                GroupType=Group }

    { 1000000048;2;Field  ;
                SourceExpr="Account Type";
                Editable=FALSE }

    { 1000000047;2;Field  ;
                SourceExpr="Account Category";
                Editable=FALSE }

    { 1000000046;2;Field  ;
                SourceExpr="BOSA Account No";
                Editable=TRUE }

    { 1000000045;2;Field  ;
                SourceExpr="Uncleared Cheques";
                Editable=false }

    { 1000000044;2;Field  ;
                SourceExpr="Authorised Over Draft";
                Editable=FALSE }

    { 1000000043;2;Field  ;
                SourceExpr="Balance (LCY)";
                Editable=FALSE }

    { 1000000042;2;Field  ;
                Name=AvailableBal;
                SourceExpr=("Balance (LCY)"+"Authorised Over Draft")-("Uncleared Cheques"+"ATM Transactions"+"EFT Transactions"+MinBalance);
                Editable=FALSE }

    { 1000000041;2;Field  ;
                SourceExpr="ATM Transactions" }

    { 1000000040;2;Field  ;
                SourceExpr="Registration Date";
                Editable=TRUE }

    { 1000000039;2;Field  ;
                SourceExpr=Status;
                Style=Standard;
                StyleExpr=TRUE;
                OnValidate=BEGIN
                             TESTFIELD("Resons for Status Change");

                             StatusPermissions.RESET;
                             StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                             StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Account Status");
                             IF StatusPermissions.FIND('-') = FALSE THEN
                             ERROR('You do not have permissions to change the account status.');

                             IF "Account Type" = 'FIXED' THEN BEGIN
                             IF "Balance (LCY)" > 0 THEN BEGIN
                             CALCFIELDS("Last Interest Date");

                             IF "Call Deposit" = TRUE THEN BEGIN
                             IF Status = Status::Closed THEN BEGIN
                             IF "Last Interest Date" < TODAY THEN
                             ERROR('Fixed deposit interest not UPDATED. Please update interest.');
                             END ELSE BEGIN
                             IF "Last Interest Date" < "FD Maturity Date" THEN
                             ERROR('Fixed deposit interest not UPDATED. Please update interest.');
                             END;
                             END;
                             END;
                             END;

                             IF Status = Status::Active THEN BEGIN
                             IF CONFIRM('Are you sure you want to re-activate this account? This will recover re-activation fee.',FALSE) = FALSE THEN BEGIN
                             ERROR('Re-activation terminated.');
                             END;

                             Blocked:=Blocked::" ";
                             MODIFY;





                             END;


                             //Account Closure
                             IF Status = Status::Closed THEN BEGIN
                             TESTFIELD("Closure Notice Date");
                             IF CONFIRM('Are you sure you want to close this account? This will recover closure fee and any '
                             + 'interest earned before maturity will be forfeited.',FALSE) = FALSE THEN BEGIN
                             ERROR('Closure terminated.');
                             END;


                             GenJournalLine.RESET;
                             GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                             GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                             IF GenJournalLine.FIND('-') THEN
                             GenJournalLine.DELETEALL;



                             AccountTypes.RESET;
                             AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                             IF AccountTypes.FIND('-') THEN  BEGIN
                             "Date Closed":=TODAY;

                             //Closure charges
                             {Charges.RESET;
                             IF CALCDATE(AccountTypes."Closure Notice Period","Closure Notice Date") > TODAY THEN
                             Charges.SETRANGE(Charges.Code,AccountTypes."Closing Prior Notice Charge") }

                             Charges.RESET;
                             IF CALCDATE(AccountTypes."Closure Notice Period","Closure Notice Date") > TODAY THEN
                             Charges.SETRANGE(Charges.Code,AccountType."Closing Charge")

                             ELSE
                             Charges.SETRANGE(Charges.Code,AccountTypes."Closing Charge");
                             IF Charges.FIND('-') THEN BEGIN
                             LineNo:=LineNo+10000;

                             GenJournalLine.INIT;
                             GenJournalLine."Journal Template Name":='PURCHASES';
                             GenJournalLine."Journal Batch Name":='FTRANS';
                             GenJournalLine."Document No.":="No."+'-CL';
                             GenJournalLine."Line No.":=LineNo;
                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                             GenJournalLine."Account No.":="No.";
                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                             GenJournalLine."Posting Date":=TODAY;
                             GenJournalLine.Description:=Charges.Description;
                             GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                             GenJournalLine.Amount:=Charges."Charge Amount";
                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                             GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                             GenJournalLine."Bal. Account No.":=Charges."GL Account";
                             GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                             IF GenJournalLine.Amount<>0 THEN
                             GenJournalLine.INSERT;

                             END;
                             //Closure charges


                             //Interest forfeited/Earned on maturity
                             CALCFIELDS("Untranfered Interest");
                             IF "Untranfered Interest" > 0 THEN BEGIN
                             ForfeitInterest:=TRUE;
                             //If FD - Check if matured
                             IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                             IF "FD Maturity Date" <= TODAY THEN
                             ForfeitInterest:=FALSE;
                             IF "Call Deposit" = TRUE THEN
                             ForfeitInterest:=FALSE;

                             END;

                             //PKK INGORE MATURITY
                             ForfeitInterest:=FALSE;
                             //If FD - Check if matured

                             IF ForfeitInterest = TRUE THEN BEGIN
                             LineNo:=LineNo+10000;

                             GenJournalLine.INIT;
                             GenJournalLine."Journal Template Name":='PURCHASES';
                             GenJournalLine."Line No.":=LineNo;
                             GenJournalLine."Journal Batch Name":='FTRANS';
                             GenJournalLine."Document No.":="No."+'-CL';
                             GenJournalLine."External Document No.":="No.";
                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                             GenJournalLine."Account No.":=AccountTypes."Interest Forfeited Account";
                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                             GenJournalLine."Posting Date":=TODAY;
                             GenJournalLine.Description:='Interest Forfeited';
                             GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                             GenJournalLine.Amount:=-"Untranfered Interest";
                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                             GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                             GenJournalLine."Bal. Account No.":=AccountTypes."Interest Payable Account";
                             GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                             GenJournalLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                             GenJournalLine."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                             IF GenJournalLine.Amount<>0 THEN
                             GenJournalLine.INSERT;

                             InterestBuffer.RESET;
                             InterestBuffer.SETRANGE(InterestBuffer."Account No","No.");
                             IF InterestBuffer.FIND('-') THEN
                             InterestBuffer.MODIFYALL(InterestBuffer.Transferred,TRUE);

                             END ELSE BEGIN
                             LineNo:=LineNo+10000;

                             GenJournalLine.INIT;
                             GenJournalLine."Journal Template Name":='PURCHASES';
                             GenJournalLine."Line No.":=LineNo;
                             GenJournalLine."Journal Batch Name":='FTRANS';
                             GenJournalLine."Document No.":="No."+'-CL';
                             GenJournalLine."External Document No.":="No.";
                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                             IF AccountTypes."Fixed Deposit" = TRUE THEN
                             GenJournalLine."Account No.":="Savings Account No."
                             ELSE
                             GenJournalLine."Account No.":="No.";
                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                             GenJournalLine."Posting Date":=TODAY;
                             GenJournalLine.Description:='Interest Earned';
                             GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                             GenJournalLine.Amount:=-"Untranfered Interest";
                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                             GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                             GenJournalLine."Bal. Account No.":=AccountTypes."Interest Payable Account";
                             GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                             IF GenJournalLine.Amount<>0 THEN
                             GenJournalLine.INSERT;

                             InterestBuffer.RESET;
                             InterestBuffer.SETRANGE(InterestBuffer."Account No","No.");
                             IF InterestBuffer.FIND('-') THEN
                             InterestBuffer.MODIFYALL(InterestBuffer.Transferred,TRUE);


                             END;


                             //Transfer Balance if Fixed Deposit
                             IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                             CALCFIELDS("Balance (LCY)");

                             TESTFIELD("Savings Account No.");

                             LineNo:=LineNo+10000;

                             GenJournalLine.INIT;
                             GenJournalLine."Journal Template Name":='PURCHASES';
                             GenJournalLine."Line No.":=LineNo;
                             GenJournalLine."Journal Batch Name":='FTRANS';
                             GenJournalLine."Document No.":="No."+'-CL';
                             GenJournalLine."External Document No.":="No.";
                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                             GenJournalLine."Account No.":="Savings Account No.";
                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                             GenJournalLine."Posting Date":=TODAY;
                             GenJournalLine.Description:='FD Balance Tranfers';
                             GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                             IF "Amount to Transfer" <> 0 THEN
                             GenJournalLine.Amount:=-"Amount to Transfer"
                             ELSE
                             GenJournalLine.Amount:=-"Balance (LCY)";
                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                             IF GenJournalLine.Amount<>0 THEN
                             GenJournalLine.INSERT;

                             LineNo:=LineNo+10000;

                             GenJournalLine.INIT;
                             GenJournalLine."Journal Template Name":='PURCHASES';
                             GenJournalLine."Line No.":=LineNo;
                             GenJournalLine."Journal Batch Name":='FTRANS';
                             GenJournalLine."Document No.":="No."+'-CL';
                             GenJournalLine."External Document No.":="No.";
                             GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                             GenJournalLine."Account No.":="No.";
                             GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                             GenJournalLine."Posting Date":=TODAY;
                             GenJournalLine.Description:='FD Balance Tranfers';
                             GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                             IF "Amount to Transfer" <> 0 THEN
                             GenJournalLine.Amount:="Amount to Transfer"
                             ELSE
                             GenJournalLine.Amount:="Balance (LCY)";
                             GenJournalLine.VALIDATE(GenJournalLine.Amount);
                             IF GenJournalLine.Amount<>0 THEN
                             GenJournalLine.INSERT;


                             END;

                             //Transfer Balance if Fixed Deposit


                             END;

                             //Interest forfeited/Earned on maturity

                             //Post New
                             GenJournalLine.RESET;
                             GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                             GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                             IF GenJournalLine.FIND('-') THEN BEGIN
                             CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                             END;
                             //Post New


                             MESSAGE('Funds transfered successfully to main account and account closed.');




                             END;
                             END;


                             //Account Closure
                           END;
                            }

    { 1000000038;2;Field  ;
                SourceExpr=Blocked;
                Editable=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Resons for Status Change");
                           END;
                            }

    { 1000000037;2;Field  ;
                SourceExpr="ATM No." }

    { 1000000001;2;Field  ;
                SourceExpr="Card No." }

    { 1000000036;2;Field  ;
                SourceExpr="Disable ATM Card" }

    { 1000000035;2;Field  ;
                SourceExpr="Reason For Disabling ATM Card" }

    { 1000000034;2;Field  ;
                SourceExpr="Disabled By" }

    { 1000000033;2;Field  ;
                SourceExpr="Last Date Modified";
                Editable=FALSE }

    { 1000000032;2;Field  ;
                SourceExpr="Monthly Contribution";
                Editable=FALSE }

    { 1000000031;2;Field  ;
                SourceExpr="Closure Notice Date" }

    { 1000000030;2;Field  ;
                SourceExpr="Resons for Status Change" }

    { 1000000029;2;Field  ;
                SourceExpr="Bankers Cheque Amount" }

    { 1000000028;2;Field  ;
                SourceExpr="Signing Instructions";
                Editable=FALSE;
                MultiLine=Yes }

    { 1000000027;2;Field  ;
                SourceExpr="Salary Processing";
                Editable=FALSE }

    { 1000000026;2;Field  ;
                SourceExpr="Net Salary" }

    { 1000000066;1;Group  ;
                Name=Fixed;
                CaptionML=ENU=Fixed Deposit;
                GroupType=Group }

    { 1000000065;2;Field  ;
                Name=Regdate;
                CaptionML=ENU=Fixed Deposit Start Date;
                SourceExpr="Registration Date";
                Editable=TRUE }

    { 1000000064;2;Field  ;
                SourceExpr="Fixed Deposit Type" }

    { 1000000063;2;Field  ;
                SourceExpr="FD Duration" }

    { 1000000025;2;Field  ;
                CaptionML=ENU=Maturity Date;
                SourceExpr="FD Maturity Date" }

    { 1000000024;2;Field  ;
                SourceExpr="Neg. Interest Rate" }

    { 1000000023;2;Field  ;
                SourceExpr="Fixed Deposit Status" }

    { 1000000022;2;Field  ;
                SourceExpr="Call Deposit";
                Editable=FALSE }

    { 1000000021;2;Field  ;
                CaptionML=ENU=Amount to Transfer;
                SourceExpr="Amount to Transfer" }

    { 1000000020;2;Field  ;
                CaptionML=ENU=Account to transfer to;
                SourceExpr="Savings Account No.";
                Editable=TRUE }

    { 1000000019;2;Field  ;
                SourceExpr="Interest Earned";
                Editable=FALSE }

    { 1000000018;2;Field  ;
                SourceExpr="FD Maturity Instructions" }

    { 1000000017;2;Field  ;
                SourceExpr="Date Renewed" }

    { 1000000014;1;Group  ;
                CaptionML=ENU=Loans Recovery;
                Visible=false;
                GroupType=Group }

    { 1000000015;2;Field  ;
                SourceExpr="Loan No" }

    { 1000000013;2;Field  ;
                SourceExpr="Principle Amount" }

    { 1000000012;2;Field  ;
                SourceExpr="Interest Amount" }

  }
  CODE
  {
    VAR
      CalendarMgmt@1000 : Codeunit 7600;
      PaymentToleranceMgt@1002 : Codeunit 426;
      CustomizedCalEntry@1001 : Record 7603;
      CustomizedCalendar@1003 : Record 7602;
      Text001@1005 : TextConst 'ENU=Do you want to allow payment tolerance for entries that are currently open?';
      Text002@1004 : TextConst 'ENU=Do you want to remove payment tolerance from entries that are currently open?';
      PictureExists@1102760000 : Boolean;
      AccountTypes@1102760001 : Record 51516295;
      GenJournalLine@1102760002 : Record 81;
      GLPosting@1102760003 : Codeunit 12;
      StatusPermissions@1102760004 : Record 51516310;
      Charges@1102760005 : Record 51516297;
      ForfeitInterest@1102760006 : Boolean;
      InterestBuffer@1102760007 : Record 51516324;
      FDType@1102760008 : Record 51516305;
      Vend@1102760009 : Record 23;
      Cust@1102760010 : Record 51516223;
      LineNo@1102760011 : Integer;
      UsersID@1102760012 : Record 2000000120;
      DActivity@1102760015 : Code[20];
      DBranch@1102760014 : Code[20];
      MinBalance@1102760013 : Decimal;
      OBalance@1102760016 : Decimal;
      OInterest@1102760017 : Decimal;
      Gnljnline@1102760018 : Record 81;
      TotalRecovered@1102760019 : Decimal;
      LoansR@1102760020 : Record 51516230;
      LoanAllocation@1102760021 : Decimal;
      LGurantors@1102760022 : Record 51516319;
      Loans@1102760023 : Record 51516230;
      DefaulterType@1102760024 : Code[20];
      LastWithdrawalDate@1102760025 : Date;
      AccountType@1102756000 : Record 51516295;
      ReplCharge@1102756001 : Decimal;
      Acc@1102755000 : Record 23;
      SearchAcc@1102755001 : Code[10];
      Searchfee@1102755002 : Decimal;
      Statuschange@1102755003 : Record 51516310;
      UnclearedLoan@1102755004 : Decimal;
      LineN@1102755005 : Integer;
      OBal@1000000000 : Decimal;
      RunBal@1000000001 : Decimal;
      AvailableBal@1000000002 : Decimal;
      UserSetup@1000000003 : Record 91;
      msg@1120054000 : Text;
      SkyMbanking@1120054003 : Codeunit 51516701;
      SMSSource@1120054002 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,WITHDRAWAL';

    PROCEDURE ActivateFields@3();
    BEGIN
      //CurrForm.Contact.EDITABLE("Primary Contact No." = '');
    END;

    LOCAL PROCEDURE OnAfterGetCurrRecord@19077479();
    BEGIN
      {xRec := Rec;
      ActivateFields;}
    END;

    PROCEDURE SMSMessage@1000000051(documentNo@1000000000 : Text[30];accfrom@1000000001 : Text[30];phone@1000000002 : Text[20];message@1000000003 : Text[250]);
    VAR
      SMSMessages@1120054000 : Record 51516329;
      iEntryNo@1120054001 : Integer;
    BEGIN

          SMSMessages.RESET;
          IF SMSMessages.FIND('+') THEN BEGIN
          iEntryNo:=SMSMessages."Entry No";
          iEntryNo:=iEntryNo+1;
          END
          ELSE BEGIN
          iEntryNo:=1;
          END;
          SMSMessages.INIT;
          SMSMessages."Entry No":=iEntryNo;
          SMSMessages."Batch No":=documentNo;
          SMSMessages."Document No":=documentNo;
          SMSMessages."Account No":=accfrom;
          SMSMessages."Date Entered":=TODAY;
          SMSMessages."Time Entered":=TIME;
          SMSMessages.Source:='ATMLINKING';
          SMSMessages."Entered By":=USERID;
          SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
          SMSMessages."SMS Message":=message;
          SMSMessages."Telephone No":=phone;
          IF SMSMessages."Telephone No"<>'' THEN
          SMSMessages.INSERT;
    END;

    BEGIN
    END.
  }
}

