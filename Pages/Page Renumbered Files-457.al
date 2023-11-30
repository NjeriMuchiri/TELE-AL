OBJECT page 172052 Fixed Deposit Cards
{
  OBJECT-PROPERTIES
  {
    Date=05/31/18;
    Time=[ 4:02:00 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=ENU=Account Card;
    InsertAllowed=Yes;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table23;
    SourceTableView=WHERE(Creditor Type=CONST(Account), Debtor Type=CONST(FOSA Account));
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 ActivateFields;
                 {
                 IF NOT MapMgt.TestSetup THEN
                   CurrForm.MapPoint.VISIBLE(FALSE);
                 }

                 AccountTypes.RESET;
                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                 IF AccountTypes.FIND('-') THEN
                 MinBalance:="Balance (LCY)"-AccountTypes."Minimum Balance";

                 //Filter based on branch
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Global Dimension 2 Code",UsersID.Branch);
                 END;}
                 //Filter based on branch

                 IF "Account Category"<>"Account Category"::Joint THEN BEGIN
                 Joint2DetailsVisible:=FALSE;
                 Joint3DetailsVisible:=FALSE;
                 END ELSE
                 Joint2DetailsVisible:=TRUE;
                 Joint3DetailsVisible:=TRUE;

                 CueMgnt.GetVisitFrequency(ObjCueControl.Activity::FOSA,"No.");
                 //GetAccountViewFrequency;
               END;

    OnFindRecord=VAR
                   RecordFound@1000 : Boolean;
                 BEGIN
                   RecordFound := FIND(Which);
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
                       CurrForm.BookBal.VISIBLE:=FALSE;
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

                       Statuschange.RESET;
                       Statuschange.SETRANGE(Statuschange."User ID",USERID);
                       Statuschange.SETRANGE(Statuschange."Function",Statuschange."Function"::"Account Status");
                       IF NOT Statuschange.FIND('-')THEN
                       CurrPage.EDITABLE:=FALSE
                       ELSE
                       CurrPage.EDITABLE:=TRUE;

                       CALCFIELDS(NetDis);
                       UnclearedLoan:=NetDis;
                       //MESSAGE('Uncleared loan is %1',UnclearedLoan);
                       IF "Account Category"<>"Account Category"::Joint THEN BEGIN
                       Joint2DetailsVisible:=FALSE;
                       Joint3DetailsVisible:=FALSE;
                       END ELSE
                       Joint2DetailsVisible:=TRUE;
                       Joint3DetailsVisible:=TRUE;
                     END;

    OnNewRecord=BEGIN
                  OnAfterGetCurrRecord;
                END;

    OnInsertRecord=BEGIN
                     "Creditor Type":="Creditor Type"::Account;
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
                      RunPageLink=Table Name=CONST(Vendor), No.=FIELD(No.);
                      Image=ViewComments }
      { 184     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(23), No.=FIELD(No.);
                      Image=Dimensions }
      { 108     ;2   ;Separator  }
      { 1102760069;2 ;Action    ;
                      Name=Re-new Fixed Deposit;
                      CaptionML=ENU=Re-new Fixed Deposit;
                      Visible=FALSE;
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
                                 GenJournalLine."Journal Batch Name":='TERM';
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
                      RunObject=page 50005;
                      RunPageLink=No.=FIELD(BOSA Account No);
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
                                 REPORT.RUN(51516360,TRUE,TRUE,Cust);
                               END;
                                }
      { 1102755031;2 ;Action    ;
                      Name=FOSA Loans;
                      RunObject=page 50027;
                      RunPageLink=Account No=FIELD(No.), Source=FILTER(FOSA);
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

                                 {
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,Vend)
                                 }
                               END;
                                }
      { 1000000058;2 ;Action    ;
                      Name=[Account Signatories ];
                      CaptionML=ENU=Signatories;
                      RunObject=Page 51516539;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Group;
                      PromotedCategory=Process }
      { 1000000059;2 ;Action    ;
                      Name=Account Agent Details;
                      RunObject=Page 51516547;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      PromotedCategory=Process }
      { 1102755009;1 ;ActionGroup }
      { 1102755008;2 ;Action    ;
                      Name=[ Account Nominee Details];
                      CaptionML=ENU=" Account Nominee Details";
                      RunObject=page 50072;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1102755005;2 ;Separator  }
      { 1102755022;2 ;Action    ;
                      Name=Transfer Term Amnt from Current;
                      OnAction=BEGIN

                                 //Transfer Balance if Fixed Deposit

                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN
                                 //IF AccountTypes."Fixed Deposit" <> TRUE THEN BEGIN
                                 IF Vend.GET("Savings Account No.") THEN BEGIN
                                 IF CONFIRM('Are you sure you want to effect the transfer from the Current account',FALSE) = FALSE THEN
                                 EXIT ELSE

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'TERM');
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
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Savings Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Term Balance Tranfers';
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
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Term Balance Tranfers';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 //GenJournalLine.Amount:=-"Fixed Deposit Amount";
                                 GenJournalLine.Amount:=-"Amount to Transfer";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //END;
                                 END;
                                 END;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'TERM');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;



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
                      Name=Transfer Term Amount to Current;
                      OnAction=BEGIN

                                 //Transfer Balance if Fixed Deposit

                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN
                                 IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF Vend.GET("No.") THEN BEGIN
                                 IF CONFIRM('Are you sure you want to effect the transfer from the Fixed Deposit account',FALSE) = TRUE THEN


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'TERM');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 Vend.CALCFIELDS(Vend."Balance (LCY)");
                                 IF (Vend."Balance (LCY)") < "Transfer Amount to Savings" THEN
                                 ERROR('Fixed Deposit account does not have enough money to facilate the requested trasfer.');

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Term Balance Tranfers';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:="Transfer Amount to Savings";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Savings Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Term Balance Tranfers';
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
                                 GenJournalLine.SETRANGE("Journal Batch Name",'TERM');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;

                                 {
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;
                                 }
                                 MESSAGE('Amount transfered successfully.');
                               END;
                                }
      { 1102755021;2 ;Action    ;
                      Name=Renew Term deposit;
                      OnAction=BEGIN

                                 IF AccountTypes.GET("Account Type") THEN BEGIN
                                 IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF CONFIRM('Are you sure you want to renew the fixed deposit.',FALSE) = FALSE THEN
                                 EXIT;




                                 "Prevous Fixed Deposit Type":="Fixed Deposit Type";
                                 "Prevous FD Deposit Status Type":="FDR Deposit Status Type";
                                 "Prevous FD Maturity Date":="FD Maturity Date";
                                 "Prevous FD Start Date":="Fixed Deposit Start Date";
                                 "Prevous Fixed Duration":="Fixed Duration";
                                 "Prevous Interest Rate FD":="Interest rate";
                                 "Prevous Expected Int On FD":="Expected Interest On Term Dep";
                                 "Date Renewed":=TODAY;


                                 "Fixed Deposit Type":='';
                                 "FDR Deposit Status Type":="FDR Deposit Status Type"::New;
                                 "FD Maturity Date":=0D;
                                 "Fixed Deposit Start Date":=0D;
                                 "Expected Interest On Term Dep":=0;
                                 "Interest rate":=0;
                                 "Amount to Transfer":=0;
                                 "Transfer Amount to Savings":=0;
                                 "Fixed Deposit Status":="Fixed Deposit Status"::" ";
                                 //"FDR Deposit Status Type":="FDR Deposit Status Type"::"";

                                 InterestBuffer.RESET;
                                 InterestBuffer.SETRANGE(InterestBuffer."Account No","No.");
                                 IF InterestBuffer.FIND('-') THEN BEGIN
                                 InterestBuffer.DELETEALL;
                                 END;



                                 "FDR Deposit Status Type":="FDR Deposit Status Type"::New;
                                 MODIFY;

                                 MESSAGE('Fixed deposit renewed successfully');
                                 END;
                                 END;
                                 //END;
                               END;
                                }
      { 1102755030;2 ;Action    ;
                      Name=Terminate Term Deposit;
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
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'TERM');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;
                                 GenSetup.GET();
                                 IF CALCDATE(GenSetup."Min. Member Age","Date of Birth") > TODAY THEN
                                 Vend.CALCFIELDS(Vend."Balance (LCY)","Interest Earned");
                                 IF (Vend."Balance (LCY)") < "Transfer Amount to Savings" THEN
                                 ERROR('Fixed Deposit account does not have enough money to facilate the requested trasfer.');

                                 //Transfer Interest from The Payable Account
                                 IF AccountType.GET("Account Type") THEN
                                 LineNo:=LineNo+10000;
                                 CALCFIELDS("Interest Earned");
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 IF CALCDATE(AccountType."Minimum Interest Period (M)","Fixed Deposit Start Date") < TODAY THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=AccountType."Interest Forfeited Account"
                                 END ELSE
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Termination Tranfer';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=("Interest Earned")*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=AccountType."Interest Payable Account";
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 LineNo:=LineNo+10000;
                                 CALCFIELDS("Interest Earned");
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Termination Tranfer';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF CALCDATE(AccountType."Minimum Interest Period (M)","Fixed Deposit Start Date") < TODAY THEN BEGIN
                                 GenJournalLine.Amount:="Balance (LCY)"
                                 END ELSE
                                 GenJournalLine.Amount:=("Balance (LCY)"+("Interest Earned"-("Interest Earned"*(AccountType."Term terminatination fee"/100))-("Interest Earned"*(GenSetup."Withholding Tax (%)"/100))));
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 CALCFIELDS("Interest Earned");
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Savings Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Termination Tranfer';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF CALCDATE(AccountType."Minimum Interest Period (M)","Fixed Deposit Start Date") < TODAY THEN BEGIN
                                 GenJournalLine.Amount:="Balance (LCY)"*-1
                                 END ELSE
                                 GenJournalLine.Amount:=("Balance (LCY)"+("Interest Earned"-("Interest Earned"*(AccountType."Term terminatination fee"/100))-("Interest Earned"*(GenSetup."Withholding Tax (%)"/100))))*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 LineNo:=LineNo+10000;

                                 IF AccountType.GET("Account Type") THEN BEGIN
                                 IF CALCDATE(AccountType."Minimum Interest Period (M)","Fixed Deposit Start Date") > TODAY THEN BEGIN
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=AccountType."Term Termination Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Termination Charge';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=("Interest Earned"-("Interest Earned"*(AccountType."Term terminatination fee"/100)));
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 GenJournalLine."Bal. Account No.":="No.";
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;


                                 IF CALCDATE(AccountType."Minimum Interest Period (M)","Fixed Deposit Start Date") > TODAY THEN BEGIN
                                 LineNo:=LineNo+10000;
                                 //Withholding Tax
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=GenSetup."WithHolding Tax Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='FD Termination Charge';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=("Interest Earned"*(GenSetup."Withholding Tax (%)"/100));
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                 GenJournalLine."Bal. Account No.":="No.";
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;
                                 END;
                                 END;
                                 END;
                                 END;

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'TERM');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;

                                 {
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'TERM');
                                 GenJournalLine.DELETEALL;
                                 }
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
      { 1000000086;2 ;Action    ;
                      Name=Break Call;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516465,TRUE,FALSE,Vend)
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
                                 REPORT.RUN(51516476,TRUE,FALSE,Vend)
                               END;
                                }
      { 1102755011;2 ;Action    ;
                      Name=Page Vendor Statistics;
                      ShortCutKey=F7;
                      CaptionML=ENU=Statistics;
                      RunObject=Page 152;
                      RunPageLink=No.=FIELD(No.), Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter), Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Report }
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
                                 GenJournalLine."Journal Batch Name":='TERM';
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
      { 1000000001;2 ;Action    ;
                      Name=Recover Class B Shares;
                      Promoted=No;
                      Visible=false;
                      Enabled=false;
                      Image=PostApplication;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF "Account Type"='SPECIAL' THEN
                                 ERROR('You cannot recover Class B Shares from this account');

                                 IF "Shares Recovered"=TRUE THEN
                                 ERROR('Class B shares already recovered');

                                 IF CONFIRM('Are you sure you want to recover Class B shares? This will recover Class B shares.',FALSE) = FALSE THEN
                                 EXIT;


                                 AccountTypes.RESET;
                                 AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                                 IF AccountTypes.FIND('-') THEN  BEGIN

                                 // charges
                                 Charges.RESET;
                                 Charges.SETRANGE(Charges.Code,AccountTypes."FOSA Shares");
                                 IF Charges.FIND('-') THEN BEGIN
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 CALCFIELDS("Balance (LCY)","ATM Transactions");
                                 IF ("Balance (LCY)"-"ATM Transactions") <= Charges."Charge Amount" THEN
                                 ERROR('This Account does not have sufficient funds');

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Document No.":="No."+'-FSH';
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

                                 "Shares Recovered":=TRUE;
                                 "ClassB Shares":= -Charges."Charge Amount";
                                 MODIFY;
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      Name=Charge ATM Card Placement;
                      Promoted=No;
                      Enabled=false;
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
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges: '+ "Card No.";
                                 GenJournalLine.Amount:=550;
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 IF GenJournalLine.Amount <>0 THEN
                                 GenJournalLine.INSERT;


                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":='BNK000001';
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
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='4-11-000310';
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."Document No.":="Card No.";
                                 GenJournalLine.Description:='Sacco Link Card Charges' + 'No.'+ "Card No.";
                                 GenJournalLine.Amount:=-50;
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
                                 END;
                                 //Post New
                               END;
                                }
      { 1000000003;2 ;Action    ;
                      Name=Charge ATM Card Replacement;
                      Promoted=No;
                      Enabled=false;
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
                                 GenJournalLine."Journal Batch Name":='TERM';
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
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":='BNK000001';
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
                                 GenJournalLine."Journal Batch Name":='TERM';
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+1000;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":='4-11-000310';
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
                                 GenJournalLine."Journal Batch Name":='TERM';
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
      { 1102755027;2 ;Action    ;
                      Name=Account Signatories;
                      RunObject=Page 51516539;
                      RunPageLink=Account No=FIELD(No.) }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Name=AccountTab;
                CaptionML=ENU=General Info;
                Editable=False;
                GroupType=Group }

    { 2   ;2   ;Field     ;
                CaptionML=[ENU=Account No.;
                           ESM=N§;
                           FRC=Nø;
                           ENC=No.];
                SourceExpr="No.";
                Editable=True;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 1000000061;2;Field  ;
                CaptionML=ENU=Old No.;
                SourceExpr="Old No Format";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr=Name;
                Editable=false }

    { 1102760013;2;Field  ;
                SourceExpr="Account Type";
                Editable=true }

    { 1102760040;2;Field  ;
                SourceExpr="Account Category";
                Editable=FALSE }

    { 1000000011;2;Field  ;
                SourceExpr="Passport No.";
                Editable=FALSE }

    { 1102760011;2;Field  ;
                SourceExpr="Personal No.";
                Editable=FALSE }

    { 1000000012;2;Field  ;
                CaptionML=ENU=Member No.;
                SourceExpr="BOSA Account No";
                Editable=FALSE }

    { 1000000020;2;Field  ;
                SourceExpr="Mobile Phone No";
                Editable=FALSE }

    { 1102760025;2;Field  ;
                SourceExpr="Employer Code";
                Editable=FALSE }

    { 1102760073;2;Field  ;
                SourceExpr="Station/Sections";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                SourceExpr="Phone No.";
                Editable=FALSE }

    { 1102760140;2;Field  ;
                CaptionML=ENU=Date of Birth;
                SourceExpr="Date of Birth";
                Editable=FALSE }

    { 1000000016;2;Field  ;
                Name=txtGender;
                CaptionML=ENU=Gender;
                SourceExpr=Gender;
                Editable=FALSE }

    { 1000000015;2;Field  ;
                SourceExpr="Marital Status";
                Editable=FALSE }

    { 1000000014;2;Field  ;
                SourceExpr="Registration Date";
                Editable=FALSE }

    { 1000000109;2;Field  ;
                SourceExpr="Uncleared Payments" }

    { 1102755004;2;Field  ;
                SourceExpr="Uncleared Cheques";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                CaptionML=[ENU=Book Balance;
                           ESM=Saldo ($);
                           FRC=Solde ($);
                           ENC=Balance ($)];
                SourceExpr="Balance (LCY)";
                Visible=false;
                Enabled=false;
                OnValidate=BEGIN
                             AccountTypes.RESET;
                             AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
                             IF AccountTypes.FIND('-') THEN
                             MinBalance:="Balance (LCY)"-AccountTypes."Minimum Balance";
                           END;
                            }

    { 1102755002;2;Field  ;
                Name=AvailableBal;
                CaptionML=ENU=Withdrawable Balance;
                SourceExpr="Balance (LCY)"-("Uncleared Cheques"+"ATM Transactions"+"EFT Transactions"+MinBalance+"Mobile Transactions"-"Cheque Discounted"+"Uncleared Payments");
                Editable=FALSE }

    { 1000000088;2;Field  ;
                SourceExpr="Cheque Discounted";
                Editable=FALSE }

    { 1000000092;2;Field  ;
                SourceExpr="Comission On Cheque Discount";
                Editable=FALSE }

    { 1102755001;2;Field  ;
                SourceExpr="Vendor Posting Group";
                Editable=FALSE }

    { 1102760114;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=FALSE }

    { 1102756013;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Editable=FALSE }

    { 1102755019;2;Field  ;
                SourceExpr="Reason For Blocking Account";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                SourceExpr=Blocked;
                Editable=FALSE;
                OnValidate=BEGIN
                             //TESTFIELD("Resons for Status Change");
                           END;
                            }

    { 1102755025;2;Field  ;
                SourceExpr="Account Frozen";
                Editable=FALSE }

    { 1102755018;2;Field  ;
                SourceExpr="ATM No.";
                Editable=FALSE }

    { 1000000036;2;Field  ;
                SourceExpr="Cheque Acc. No" }

    { 26  ;2   ;Field     ;
                SourceExpr="Last Date Modified";
                Editable=FALSE }

    { 1000000009;2;Field  ;
                SourceExpr=Picture;
                Editable=TRUE }

    { 1000000010;2;Field  ;
                SourceExpr=Signature;
                Editable=TRUE }

    { 1000000021;2;Field  ;
                SourceExpr=Status;
                Editable=True;
                Style=Standard;
                StyleExpr=TRUE;
                OnValidate=BEGIN
                             {TESTFIELD("Resons for Status Change");

                             StatusPermissions.RESET;
                             StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
                             StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Account Status");
                             IF StatusPermissions.FIND('-') = FALSE THEN
                             ERROR('You do not have permissions to change the account status.');}

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
                             {
                             //Post New
                             GenJournalLine.RESET;
                             GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                             GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                             IF GenJournalLine.FIND('-') THEN BEGIN
                             CODEUNIT.RUN(CODEUNIT::Codeunit,GenJournalLine);
                             END;
                             //Post New
                             }

                             MESSAGE('Funds transfered successfully to main account and account closed.');




                             END;
                             END;


                             //Account Closure
                           END;
                            }

    { 1000000090;2;Field  ;
                SourceExpr="Staff Account";
                Editable=FALSE }

    { 1000000023;2;Field  ;
                SourceExpr="Closure Notice Date";
                Editable=FALSE }

    { 1000000022;2;Field  ;
                SourceExpr="Resons for Status Change";
                Editable=True }

    { 1000000013;2;Field  ;
                SourceExpr="Signing Instructions";
                Editable=FALSE;
                MultiLine=Yes }

    { 1000000024;2;Field  ;
                SourceExpr="Interest Earned";
                Editable=FALSE }

    { 1000000087;2;Field  ;
                SourceExpr="Allowable Cheque Discounting %";
                Editable=FALSE }

    { 1000000089;2;Field  ;
                SourceExpr="S-Mobile No";
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr="Salary Processing";
                Editable=FALSE }

    { 1905652901;1;Group  ;
                Name=AccountTab1;
                CaptionML=ENU=Communication Info;
                Editable=False;
                GroupType=Group }

    { 1000000019;2;Field  ;
                SourceExpr=Address }

    { 1000000018;2;Field  ;
                CaptionML=ENU=Post Code/City;
                SourceExpr="Post Code" }

    { 1000000017;2;Field  ;
                SourceExpr=City }

    { 8   ;2   ;Field     ;
                SourceExpr="Address 2" }

    { 48  ;2   ;Field     ;
                SourceExpr="E-Mail" }

    { 86  ;2   ;Field     ;
                SourceExpr="Home Page" }

    { 1000000008;2;Field  ;
                SourceExpr=Contact;
                Editable=False }

    { 1000000007;2;Field  ;
                SourceExpr="ContacPerson Phone" }

    { 1000000006;2;Field  ;
                SourceExpr="ContactPerson Occupation" }

    { 1000000005;2;Field  ;
                SourceExpr=CodeDelete }

    { 1102760044;2;Field  ;
                SourceExpr="Home Address" }

    { 1000000063;1;Group  ;
                CaptionML=ENU=Tea Employer Nos;
                GroupType=Group }

    { 1000000057;1;Group  ;
                Name=Joint2Details;
                CaptionML=ENU=Joint2Details;
                Visible=Joint2DetailsVisible;
                Editable=False;
                GroupType=Group }

    { 1000000056;2;Field  ;
                CaptionML=ENU=Name;
                SourceExpr="Name 2";
                Editable=FALSE }

    { 1000000055;2;Field  ;
                CaptionML=ENU=Payroll No;
                SourceExpr="Payroll/Staff No2";
                Editable=FALSE }

    { 1000000054;2;Field  ;
                CaptionML=ENU=Address;
                SourceExpr="Address3-Joint";
                Editable=FALSE }

    { 1000000053;2;Field  ;
                CaptionML=ENU=Postal Code;
                SourceExpr="Postal Code 2";
                Editable=FALSE }

    { 1000000052;2;Field  ;
                CaptionML=ENU=Town;
                SourceExpr="Town 2";
                Editable=FALSE }

    { 1000000051;2;Field  ;
                CaptionML=ENU=Mobile No.;
                SourceExpr="Mobile No. 3";
                Editable=FALSE }

    { 1000000050;2;Field  ;
                CaptionML=ENU=Date of Birth;
                SourceExpr="Date of Birth2";
                Editable=FALSE }

    { 1000000049;2;Field  ;
                CaptionML=ENU=ID No.;
                SourceExpr="ID No.2";
                Editable=FALSE }

    { 1000000048;2;Field  ;
                CaptionML=ENU=Passport No.;
                SourceExpr="Passport 2";
                Editable=FALSE }

    { 1000000047;2;Field  ;
                CaptionML=ENU=Member Parish;
                SourceExpr="Member Parish 2";
                Editable=FALSE }

    { 1000000046;2;Field  ;
                CaptionML=ENU=Member Parish Name;
                SourceExpr="Member Parish Name 2";
                Editable=FALSE }

    { 1000000045;2;Field  ;
                CaptionML=ENU=Gender;
                SourceExpr=Gender2;
                Editable=FALSE }

    { 1000000044;2;Field  ;
                CaptionML=ENU=Marital Status;
                SourceExpr="Marital Status2";
                Editable=FALSE }

    { 1000000043;2;Field  ;
                CaptionML=ENU=Home Postal Code;
                SourceExpr="Home Postal Code2";
                Editable=FALSE }

    { 1000000042;2;Field  ;
                CaptionML=ENU=Home Town;
                SourceExpr="Home Town2";
                Editable=FALSE }

    { 1000000041;2;Field  ;
                CaptionML=ENU=Employer Code;
                SourceExpr="Employer Code2";
                Editable=FALSE }

    { 1000000040;2;Field  ;
                CaptionML=ENU=Employer Name;
                SourceExpr="Employer Name2";
                Editable=FALSE }

    { 1000000039;2;Field  ;
                CaptionML=ENU=E-Mail (Personal);
                SourceExpr="E-Mail (Personal2)";
                Editable=FALSE }

    { 1000000038;2;Field  ;
                CaptionML=ENU=Picture;
                SourceExpr="Picture 2";
                Editable=FALSE }

    { 1000000037;2;Field  ;
                CaptionML=ENU=Signature;
                SourceExpr="Signature  2";
                Editable=FALSE }

    { 1000000083;1;Group  ;
                Name=Joint3Details;
                Visible=Joint3DetailsVisible;
                Editable=False;
                GroupType=Group }

    { 1000000082;2;Field  ;
                CaptionML=ENU=Name;
                SourceExpr="Name 3";
                Editable=FALSE }

    { 1000000081;2;Field  ;
                CaptionML=ENU=Payroll/Staff No;
                SourceExpr="Payroll/Staff No3";
                Editable=FALSE }

    { 1000000080;2;Field  ;
                CaptionML=ENU=Address;
                SourceExpr=Address4;
                Editable=FALSE }

    { 1000000079;2;Field  ;
                CaptionML=ENU=Postal Code;
                SourceExpr="Postal Code 3";
                Editable=FALSE }

    { 1000000078;2;Field  ;
                CaptionML=ENU=Town;
                SourceExpr="Town 3";
                Editable=FALSE }

    { 1000000077;2;Field  ;
                CaptionML=ENU=Mobile No.;
                SourceExpr="Mobile No. 4";
                Editable=FALSE;
                ShowMandatory=TRUE }

    { 1000000076;2;Field  ;
                CaptionML=ENU=Date of Birth;
                SourceExpr="Date of Birth3";
                Editable=FALSE;
                ShowMandatory=TRUE }

    { 1000000075;2;Field  ;
                CaptionML=ENU=ID No.;
                SourceExpr="ID No.3";
                Editable=FALSE;
                ShowMandatory=TRUE }

    { 1000000074;2;Field  ;
                CaptionML=ENU=Passport No.;
                SourceExpr="Passport 3";
                Editable=FALSE }

    { 1000000073;2;Field  ;
                CaptionML=ENU=Member Parish;
                SourceExpr="Member Parish 3";
                Editable=FALSE;
                ShowMandatory=TRUE }

    { 1000000072;2;Field  ;
                CaptionML=ENU=Member Parish Name;
                SourceExpr="Member Parish Name 3";
                Editable=FALSE }

    { 1000000071;2;Field  ;
                CaptionML=ENU=Gender;
                SourceExpr=Gender3;
                Editable=FALSE }

    { 1000000070;2;Field  ;
                CaptionML=ENU=Marital Status;
                SourceExpr="Marital Status3";
                Editable=FALSE }

    { 1000000069;2;Field  ;
                CaptionML=ENU=Home Postal Code;
                SourceExpr="Home Postal Code3";
                Editable=FALSE }

    { 1000000068;2;Field  ;
                CaptionML=ENU=Home Town;
                SourceExpr="Home Town3";
                Editable=FALSE }

    { 1000000067;2;Field  ;
                CaptionML=ENU=Employer Code;
                SourceExpr="Employer Code3";
                Editable=FALSE }

    { 1000000066;2;Field  ;
                CaptionML=ENU=Employer Name;
                SourceExpr="Employer Name3";
                Editable=FALSE }

    { 1000000065;2;Field  ;
                SourceExpr="E-Mail (Personal3)";
                Editable=FALSE }

    { 1000000064;2;Field  ;
                CaptionML=ENU=Picture;
                SourceExpr="Picture 3";
                Editable=FALSE }

    { 1000000062;2;Field  ;
                CaptionML=ENU=Signature;
                SourceExpr="Signature  3";
                Editable=FALSE }

    { 1102755000;1;Group  ;
                CaptionML=ENU=Term Deposit Details;
                Visible=False;
                GroupType=Group }

    { 1000000085;2;Field  ;
                CaptionML=ENU=Expected Interest Earned;
                SourceExpr="Expected Interest On Term Dep";
                Editable=FALSE }

    { 1102760019;2;Field  ;
                CaptionML=ENU=Term Deposit Status;
                SourceExpr="Fixed Deposit Status" }

    { 1102755029;2;Field  ;
                CaptionML=ENU=Term Deposit Status Type;
                SourceExpr="FDR Deposit Status Type";
                Editable=TRUE }

    { 1000000060;2;Field  ;
                SourceExpr="On Term Deposit Maturity" }

    { 1102755026;2;Field  ;
                SourceExpr="Interest rate";
                Editable=FALSE }

    { 1102760066;2;Field  ;
                CaptionML=ENU=Current Account No.;
                SourceExpr="Savings Account No.";
                Editable=FALSE }

    { 1102755024;2;Field  ;
                CaptionML=ENU=Transfer Amount to Current;
                SourceExpr="Transfer Amount to Savings" }

    { 3   ;2   ;Field     ;
                SourceExpr="Last Interest Earned Date";
                Editable=FALSE }

    { 1000000106;1;Group  ;
                Name=Fixed Deposit Details;
                CaptionML=ENU=Fixed Deposit Details;
                GroupType=Group }

    { 1000000094;2;Field  ;
                Name=Kensa Account No;
                CaptionML=ENU=Kensa Account No;
                SourceExpr="Savings Account No." }

    { 1102760060;2;Field  ;
                CaptionML=ENU=Fixed Deposit Type;
                SourceExpr="Fixed Deposit Type";
                Visible=TRUE;
                Editable=TRUE }

    { 1000000103;2;Field  ;
                SourceExpr="Fixed Deposit Start Date";
                Editable=True }

    { 1000000091;2;Field  ;
                CaptionML=ENU=Fixed Duration;
                SourceExpr="Fixed Duration" }

    { 1102760064;2;Field  ;
                CaptionML=ENU=Maturity Date;
                SourceExpr="FD Maturity Date";
                Editable=true }

    { 1000000107;2;Field  ;
                SourceExpr="Neg. Interest Rate" }

    { 1000000108;2;Field  ;
                SourceExpr="FD Maturity Instructions" }

    { 1000000104;2;Field  ;
                SourceExpr="Amount to Transfer" }

    { 1000000093;1;Group  ;
                CaptionML=ENU=Previous Term Deposit Details;
                Visible=False;
                GroupType=Group }

    { 1000000095;2;Field  ;
                CaptionML=ENU=Fixed Deposit Type;
                SourceExpr="Prevous Fixed Deposit Type";
                Editable=FALSE }

    { 1000000096;2;Field  ;
                CaptionML=ENU=Fixed Deposit Start Date;
                SourceExpr="Prevous FD Start Date";
                Editable=True }

    { 1000000097;2;Field  ;
                CaptionML=ENU=Fixed Deposit Duration;
                SourceExpr="Prevous Fixed Duration";
                Editable=FALSE }

    { 1000000098;2;Field  ;
                CaptionML=ENU=Expected Int On Fixed Deposit;
                SourceExpr="Prevous Expected Int On FD";
                Editable=FALSE }

    { 1000000099;2;Field  ;
                CaptionML=ENU=Fixed Maturity Date;
                SourceExpr="Prevous FD Maturity Date";
                Editable=FALSE }

    { 1000000100;2;Field  ;
                CaptionML=ENU=Fixed Deposit Status Type;
                SourceExpr="Prevous FD Deposit Status Type";
                Editable=FALSE }

    { 1000000101;2;Field  ;
                CaptionML=ENU=Interest Rate Fixed Deposit;
                SourceExpr="Prevous Interest Rate FD";
                Editable=FALSE }

    { 1000000102;2;Field  ;
                SourceExpr="Date Renewed" }

    { 1000000025;1;Group  ;
                CaptionML=[ENU=ATM Details;
                           ENC=ATM Details];
                Editable=False;
                GroupType=Group }

    { 1000000026;2;Field  ;
                Name=ATM No.B;
                SourceExpr="ATM No.";
                Editable=false }

    { 1000000033;2;Field  ;
                SourceExpr="ATM Transactions" }

    { 1000000027;2;Field  ;
                CaptionML=ENU=ATM Card Ready For Collection;
                SourceExpr="Atm card ready" }

    { 1000000028;2;Field  ;
                Name="FDR Deposit Status Type";
                SourceExpr="ATM Issued" }

    { 1000000029;2;Field  ;
                SourceExpr="ATM Self Picked" }

    { 1000000030;2;Field  ;
                SourceExpr="ATM Collector Name" }

    { 1000000031;2;Field  ;
                SourceExpr="ATM Collector's ID" }

    { 1000000032;2;Field  ;
                SourceExpr="ATM Collector's Mobile" }

    { 1000000035;;Container;
                CaptionML=ENU=Account Fact Box;
                ContainerType=FactBoxArea }

    { 1000000034;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516502;
                PartType=Page }

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
      AccountTypes@1102760001 : Record 51516436;
      GenJournalLine@1102760002 : Record 81;
      GLPosting@1102760003 : Codeunit 12;
      StatusPermissions@1102760004 : Record 51516452;
      Charges@1102760005 : Record 51516439;
      ForfeitInterest@1102760006 : Boolean;
      InterestBuffer@1102760007 : Record 51516467;
      FDType@1102760008 : Record 51516447;
      Vend@1102760009 : Record 23;
      Cust@1102760010 : Record 51516364;
      LineNo@1102760011 : Integer;
      UsersID@1102760012 : Record 2000000120;
      DActivity@1102760015 : Code[20];
      DBranch@1102760014 : Code[20];
      MinBalance@1102760013 : Decimal;
      OBalance@1102760016 : Decimal;
      OInterest@1102760017 : Decimal;
      Gnljnline@1102760018 : Record 81;
      TotalRecovered@1102760019 : Decimal;
      LoansR@1102760020 : Record 51516371;
      LoanAllocation@1102760021 : Decimal;
      LGurantors@1102760022 : Record 51516462;
      Loans@1102760023 : Record 51516371;
      DefaulterType@1102760024 : Code[20];
      LastWithdrawalDate@1102760025 : Date;
      AccountType@1102756000 : Record 51516436;
      ReplCharge@1102756001 : Decimal;
      Acc@1102755000 : Record 23;
      SearchAcc@1102755001 : Code[10];
      Searchfee@1102755002 : Decimal;
      Statuschange@1102755003 : Record 51516452;
      UnclearedLoan@1102755004 : Decimal;
      LineN@1102755005 : Integer;
      Joint2DetailsVisible@1000000000 : Boolean;
      Joint3DetailsVisible@1000000001 : Boolean;
      GenSetup@1000000002 : Record 51516398;
      CueMgnt@1000000003 : Codeunit 51516160;
      ObjCueControl@1000000004 : Record 51516556;

    PROCEDURE ActivateFields@3();
    BEGIN
      //CurrForm.Contact.EDITABLE("Primary Contact No." = '');
    END;

    LOCAL PROCEDURE OnAfterGetCurrRecord@19077479();
    BEGIN
      xRec := Rec;
      ActivateFields;
    END;

    BEGIN
    END.
  }
}

