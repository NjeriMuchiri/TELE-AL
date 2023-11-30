OBJECT page 17375 Member Account Card - Editable
{
  OBJECT-PROPERTIES
  {
    Date=04/27/20;
    Time=[ 2:41:46 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=ENU=Member Card;
    InsertAllowed=Yes;
    DeleteAllowed=No;
    SourceTable=Table51516223;
    SourceTableView=SORTING(Employer Code)
                    WHERE(Customer Type=CONST(Member));
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnInit=BEGIN
             txtMaritalVisible := TRUE;
             lblMaritalVisible := TRUE;
             txtGenderVisible := TRUE;
             lblGenderVisible := TRUE;
             lblRegDateVisible := TRUE;
             lblRegNoVisible := TRUE;
             lblDOBVisible := TRUE;
             lblIDVisible := TRUE;
           END;

    OnOpenPage=VAR
                 MapMgt@1000 : Codeunit 802;
               BEGIN
                 ActivateFields;
                 // {
                 // IF NOT MapMgt.TestSetup THEN
                 //   CurrForm.MapPoint.VISIBLE(FALSE);
                 // }


                 StatusPermissions.RESET;
                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
                 IF StatusPermissions.FIND('-') = FALSE THEN
                 ERROR('You do not have permissions to edit member information.');
               END;

    OnFindRecord=VAR
                   RecordFound@1000 : Boolean;
                 BEGIN
                   RecordFound := FIND(Which);
                   CurrPage.EDITABLE := RecordFound OR (GETFILTER("No.") = '');
                   EXIT(RecordFound);
                 END;

    OnAfterGetRecord=BEGIN
                       FosaName:='';

                       IF "FOSA Account" <> '' THEN BEGIN
                       IF Vend.GET("FOSA Account") THEN BEGIN
                       FosaName:=Vend.Name;
                       END;
                       END;

                       lblIDVisible := TRUE;
                       lblDOBVisible := TRUE;
                       lblRegNoVisible := FALSE;
                       lblRegDateVisible := FALSE;
                       lblGenderVisible := TRUE;
                       txtGenderVisible := TRUE;
                       lblMaritalVisible := TRUE;
                       txtMaritalVisible := TRUE;

                       IF "Account Category" <> "Account Category"::Single THEN BEGIN
                       lblIDVisible := FALSE;
                       lblDOBVisible := FALSE;
                       lblRegNoVisible := TRUE;
                       lblRegDateVisible := TRUE;
                       lblGenderVisible := FALSE;
                       txtGenderVisible := FALSE;
                       lblMaritalVisible := FALSE;
                       txtMaritalVisible := FALSE;

                       END;
                       OnAfterGetCurrRecord;
                     END;

    OnNewRecord=BEGIN
                  "Customer Type":="Customer Type"::Member;
                  Status:=Status::Active;
                  "Customer Posting Group":='BOSA';
                  "Registration Date":=TODAY;
                  Advice:=TRUE;
                  "Advice Type":="Advice Type"::"New Member";
                  IF GeneralSetup.GET(0) THEN BEGIN
                  "Insurance Contribution":=GeneralSetup."Welfare Contribution";
                  "Registration Fee":=GeneralSetup."Registration Fee";

                  END;
                  OnAfterGetCurrRecord;
                END;

    ActionList=ACTIONS
    {
      { 30      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=ENU=&Member }
      { 27      ;2   ;Action    ;
                      Name=Member Ledger Entries;
                      CaptionML=ENU=Member Ledger Entries;
                      RunObject=Page 51516160;
                      RunPageView=SORTING(Field3);
                      RunPageLink=Field3=FIELD(No.);
                      Image=CustomerLedger }
      { 25      ;2   ;Action    ;
                      Name=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=No.=FIELD(No.);
                      Image=Dimensions }
      { 24      ;2   ;Action    ;
                      Name=Bank Account;
                      RunObject=Page 423;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=Card }
      { 23      ;2   ;Action    ;
                      Name=Contacts;
                      Image=ContactPerson;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 22      ;1   ;ActionGroup }
      { 1000000006;2 ;Action    ;
                      Name=Members Kin Details List;
                      CaptionML=ENU=Members Kin Details List;
                      RunObject=page 17368;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=SPouse & Children;
                      RunObject=page 50021;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=relationship;
                      PromotedCategory=Process }
      { 20      ;2   ;Action    ;
                      Name=Account Signatories;
                      CaptionML=ENU=Signatories Details;
                      RunObject=page 17369;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      PromotedCategory=Process }
      { 19      ;2   ;Action    ;
                      Name=Members Statistics;
                      RunObject=page 17366;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 18      ;2   ;ActionGroup }
      { 17      ;2   ;Action    ;
                      Name=Detailed Statement;
                      CaptionML=ENU=Detailed Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516151,TRUE,FALSE,Cust);
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=Detailed Interest Statement;
                      CaptionML=ENU=Detailed Interest Statement;
                      Image=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516151,TRUE,FALSE,Cust);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Name=Account Closure Slip;
                      CaptionML=ENU=Account Closure Slip;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(50033,TRUE,FALSE,Cust);
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=Recover Loans from Gurantors;
                      CaptionML=ENU=Recover Loans from Gurantors;
                      Image=Report;
                      OnAction=BEGIN
                                 {IF ("Current Shares" * -1) > 0 THEN
                                 ERROR('Please recover the loans from the members shares before recovering from gurantors.');

                                 IF CONFIRM('Are you absolutely sure you want to recover the loans from the guarantors as loans?') = FALSE THEN
                                 EXIT;

                                 RoundingDiff:=0;

                                 //delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'Recoveries');
                                 Gnljnline.DELETEALL;
                                 //end of deletion

                                 TotalRecovered:=0;

                                 DActivity:="Global Dimension 1 Code";
                                 DBranch:="Global Dimension 2 Code";

                                 CALCFIELDS("Outstanding Balance","FOSA Outstanding Balance","Accrued Interest","Insurance Fund","Current Shares");



                                 CALCFIELDS("Outstanding Balance","Accrued Interest","Current Shares");



                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."No. Of Guarantors");

                                 IF ((LoansR."Outstanding Balance" ) > 0) AND (LoansR."No. Of Guarantors" > 0) THEN BEGIN

                                 LoanAllocation:=ROUND((LoansR."Outstanding Balance")/LoansR."No. Of Guarantors",0.01)+
                                                 ROUND((LoansR."Oustanding Interest")/LoansR."No. Of Guarantors",0.01);


                                 LGurantors.RESET;
                                 LGurantors.SETRANGE(LGurantors."Loan No",LoansR."Loan  No.");
                                 LGurantors.SETRANGE(LGurantors.Substituted,FALSE);
                                 IF LGurantors.FIND('-') THEN BEGIN
                                 REPEAT



                                 IF Cust.GET(LGurantors."Member No") THEN BEGIN
                                 Cust.CALCFIELDS(Cust."Current Shares");
                                 "Remaining Amount":=Cust."Current Shares";
                                 END;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":='GL-'+LoansR."Client Code";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=LoansR."Loan  No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":=LGurantors."Member No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Loan Default: ' + LGurantors."Loanees  No";
                                 IF LoanAllocation >"Remaining Amount" THEN BEGIN
                                 GenJournalLine.Amount:="Remaining Amount";
                                 END ELSE BEGIN
                                 GenJournalLine.Amount:=LoanAllocation ;
                                 END;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;



                                 //Off Set BOSA Loans

                                 //Principle
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":='GL-'+LoansR."Client Code";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=Loans."Loan  No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":=LoansR."Client Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Cleared by Guarantor Deposits: ' + LGurantors."Member No";
                                 IF LoanAllocation >"Remaining Amount" THEN BEGIN
                                 GenJournalLine.Amount:=-"Remaining Amount";
                                 END ELSE BEGIN
                                 GenJournalLine.Amount:=-LoanAllocation ;
                                 END;

                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 UNTIL LGurantors.NEXT = 0;
                                 END;
                                 END;
                                 UNTIL LoansR.NEXT = 0;
                                 END;


                                 "Defaulted Loans Recovered":=TRUE;
                                 MODIFY;

                                 {
                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Recoveries');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;

                                  }

                                 MESSAGE('Loan recovery from guarantors posted successfully.');
                                 }
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Recover Loans from Deposit;
                      CaptionML=ENU=Recover Loans from Deposit;
                      OnAction=BEGIN
                                 {IF CONFIRM('Are you absolutely sure you want to recover the loans from member deposit') = FALSE THEN
                                 EXIT;

                                 "Withdrawal Fee":=1000;

                                 //delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'Recoveries');
                                 Gnljnline.DELETEALL;
                                 //end of deletion

                                 TotalRecovered:=0;
                                 TotalInsuarance:=0;

                                 DActivity:="Global Dimension 1 Code";
                                 DBranch:="Global Dimension 2 Code";
                                 CALCFIELDS("Outstanding Balance","Accrued Interest","Current Shares");

                                 CALCFIELDS("Outstanding Balance","Outstanding Interest","FOSA Outstanding Balance","Accrued Interest","Insurance Fund","Current Shares");
                                 TotalOustanding:="Outstanding Balance"+"Outstanding Interest";
                                    // GETTING WITHDRAWAL FEE
                                  IF (0.15*("Current Shares")) > 1000 THEN BEGIN
                                  "Withdrawal Fee":=1000;
                                  END ELSE BEGIN
                                   "Withdrawal Fee":=0.15*("Current Shares");
                                  END;
                                 // END OF GETTING WITHDRWAL FEE
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='WITHDRAWAL FEE';
                                 GenJournalLine.Amount:="Withdrawal Fee";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Bal. Account No." :='103102';
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;


                                 TotalRecovered:=TotalRecovered+GenJournalLine.Amount;


                                 "Closing Deposit Balance":=("Current Shares"-"Withdrawal Fee");


                                 IF "Closing Deposit Balance" > 0 THEN BEGIN
                                  "Remaining Amount":="Closing Deposit Balance";

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 //"AMOUNTTO BE RECOVERED":=0;
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
                                 TotalInsuarance:=TotalInsuarance+LoansR."Loans Insurance";
                                 UNTIL LoansR.NEXT=0;
                                 END;

                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT
                                 "AMOUNTTO BE RECOVERED":=0;
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");



                                 //Loan Insurance
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Cleared by deposits: ' + "No.";
                                 GenJournalLine.Amount:=-ROUND(LoansR."Loans Insurance");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Insurance Paid";
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 {
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Cleared by deposits: ' + "No.";
                                 GenJournalLine.Amount:=ROUND(LoansR."Loans Insurance");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;}



                                 {LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 //REPEAT
                                 "AMOUNTTO BE RECOVERED":=0;
                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");}


                                 //Off Set BOSA Loans
                                 //Interest
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Interest Capitalized: ' + "No.";
                                 GenJournalLine.Amount:=-ROUND(LoansR."Oustanding Interest");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;


                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Interest Capitalized: ' + "No.";
                                 GenJournalLine.Amount:=ROUND(LoansR."Oustanding Interest");
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 PrincipInt:=0;
                                 TotalLoansOut:=0;
                                 "Closing Deposit Balance":=("Current Shares"-"Withdrawal Fee"-TotalInsuarance);

                                 IF "Remaining Amount" > 0 THEN BEGIN
                                 PrincipInt:=(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
                                 TotalLoansOut:=("Outstanding Balance"+"Outstanding Interest");

                                 //Principle
                                 LineNo:=LineNo+10000;
                                 //"AMOUNTTO BE RECOVERED":=ROUND(((LoansR."Outstanding Balance"+LoansR."Oustanding Interest")/("Outstanding Balance"+"Outstanding Interest")))*"Closing Deposit Balance";
                                 "AMOUNTTO BE RECOVERED":=ROUND((PrincipInt/TotalLoansOut)*"Closing Deposit Balance",0.01,'=');
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Loan Against Deposits: ' + "No.";
                                 IF "AMOUNTTO BE RECOVERED" > (LoansR."Outstanding Balance"+LoansR."Oustanding Interest") THEN BEGIN
                                 IF "Remaining Amount" > (LoansR."Outstanding Balance"+LoansR."Oustanding Interest") THEN BEGIN
                                 GenJournalLine.Amount:=-ROUND(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
                                 END ELSE BEGIN
                                 GenJournalLine.Amount:=-"Remaining Amount";

                                 END;

                                 END ELSE BEGIN
                                 IF "Remaining Amount" > "AMOUNTTO BE RECOVERED" THEN BEGIN
                                 GenJournalLine.Amount:=-"AMOUNTTO BE RECOVERED";
                                 END ELSE BEGIN
                                 GenJournalLine.Amount:=-"Remaining Amount";
                                 END;
                                 END;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 "Remaining Amount":="Remaining Amount"+GenJournalLine.Amount;

                                 TotalRecovered:=TotalRecovered+((GenJournalLine.Amount));

                                 END;




                                 UNTIL LoansR.NEXT = 0;
                                 END;
                                 END;
                                 //Deposit
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Defaulted Loans Against Deposits';
                                 GenJournalLine.Amount:=(TotalRecovered-"Withdrawal Fee"-TotalInsuarance)*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;



                                 "Defaulted Loans Recovered":=TRUE;
                                 MODIFY;

                                 {
                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Recoveries');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;
                                 }


                                 MESSAGE('Loan recovery from Deposits posted successfully.');
                                  }
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=FOSA Statement;
                      Promoted=Yes;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {Vend.RESET;
                                 Vend.SETRANGE(Vend."BOSA Account No","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,Vend);
                                 }
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Member is  a Guarantor;
                      CaptionML=ENU=Member is  a Guarantor;
                      Image=Report;
                      OnAction=BEGIN

                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(50032,TRUE,FALSE,Cust);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Member is  Guaranteed;
                      CaptionML=ENU=Member is  Guaranteed;
                      Image=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(50035,TRUE,FALSE,Cust);
                               END;
                                }
      { 5       ;2   ;ActionGroup;
                      CaptionML=ENU=Issued Documents;
                      Visible=FALSE }
      { 3       ;2   ;Action    ;
                      Name=Dispatch Physical File;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                  {

                                 IF Status <> Status::Active THEN
                                 ERROR('you cannot dispatch an inactive file, kindly contact the administrator');

                                 IF "File Movement Remarks"='' THEN

                                 "File Movement Remarks":=FORMAT("File Movement Remarks1");
                                 //TESTFIELD("File Movement Remarks");
                                 User:=USERID;
                                 TESTFIELD(User);
                                 //TESTFIELD("Folio Number");
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF "Bank Code"='' THEN BEGIN
                                 //Cust."Current file location":='REGISTRY';
                                 //"Bank Code":='REGISTRY';
                                 MODIFY;


                                 END;
                                 IF (Cust."File MVT Time"<>0T) AND (Cust."file Received"<>TRUE) THEN
                                 ERROR('Please inform this user to receive this file before use %1',Cust.User);

                                 IF Cust."Current file location"='' THEN
                                 Cust."Current file location":='REGISTRY';
                                 //IF "File Received by"<>USERID THEN ERROR('You do not have permissions to MOVE the file.');

                                   ApprovalUsers.RESET;
                                   ApprovalUsers.SETRANGE(ApprovalUsers."User ID",USERID);
                                   IF ApprovalUsers.FIND('-') THEN BEGIN
                                   REPEAT
                                    //IF ApprovalUsers."User ID"<>"File Received by" THEN
                                    //ERROR('You do not have permissions to MOVE the file.');
                                   IF CONFIRM('Are You sure you want to move the phisical file to the selected location?')=FALSE THEN
                                    EXIT;


                                 {MOVESTATUS.RESET;
                                 MOVESTATUS.SETRANGE(MOVESTATUS."User ID",USERID);
                                 IF MOVESTATUS.FIND('-') THEN BEGIN
                                 REPEAT
                                 IF MOVESTATUS."User ID"<>"File Received by" THEN
                                 ERROR('You do not have permissions to MOVE the file.');
                                 IF CONFIRM('Are You sure you want to move the phisical file to the selected location?')=FALSE THEN
                                 EXIT;}
                                   {
                                 FileMovementTracker.RESET;
                                 FileMovementTracker.SETRANGE(FileMovementTracker."Member No.","No.");
                                 IF FileMovementTracker.FIND('+') THEN BEGIN
                                 IF FileMovementTracker.Stage = "Move to" THEN
                                 ERROR('File already in %1',FileMovementTracker.Station);
                                  }
                                 "File MVT User ID":=USERID;
                                 User:=USERID;
                                 "File MVT Time":=TIME;
                                 "File MVT Date":=TODAY;
                                 "File Previous Location":=FORMAT(Filelocc);
                                 "Current file location":=Cust."Move to description";
                                 "file Received":=FALSE;
                                 "File Received by":='';
                                 "file received date":=0D;
                                 "File received Time":=0T;
                                 MODIFY;
                                 //"Current file location":="Move to";
                                 //MODIFY;


                                 ApprovalsSetup.RESET;
                                 ApprovalsSetup.SETRANGE(ApprovalsSetup."Approval Type",ApprovalsSetup."Approval Type"::"File Movement");
                                 ApprovalsSetup.SETRANGE(ApprovalsSetup.Stage,Cust."Move to");
                                 IF ApprovalsSetup.FIND('-') THEN BEGIN





                                 FileMovementTracker.RESET;
                                 IF FileMovementTracker.FIND('+') THEN BEGIN
                                 FileMovementTracker."Current Location":=FALSE;
                                 EntryNo:=FileMovementTracker."Entry No.";
                                 END;
                                 FileMovementTracker.INIT;
                                 FileMovementTracker."Entry No.":=EntryNo+1;
                                 FileMovementTracker."Member No.":="No.";
                                 FileMovementTracker."Approval Type":=ApprovalsSetup."Approval Type";
                                 FileMovementTracker.Stage:=ApprovalsSetup.Stage;
                                 FileMovementTracker."Current Location":=TRUE;
                                 FileMovementTracker.Description:=ApprovalsSetup.Description;
                                 FileMovementTracker.Station:=ApprovalsSetup.Station;
                                 FileMovementTracker."Date/Time In":=CREATEDATETIME(TODAY,TIME);
                                 //FileMovementTracker."Date/Time Out":= CREATEDATETIME(TODAY,TIME);
                                 FileMovementTracker."USER ID":=USERID;
                                 FileMovementTracker.Remarks:=Cust."File Movement Remarks";
                                 FileMovementTracker.INSERT(TRUE);

                                 //END;
                                 END;

                                 UNTIL ApprovalUsers.NEXT=0;
                                 END;
                                 END;

                                 {

                                                Cust."File MVT User ID":=USERID;
                                                Cust."File MVT Time":=TIME;
                                                Cust."File MVT Date":=TODAY;
                                                Cust."File Previous Location":=Cust."Current file location";
                                                Cust."Current file location":=Cust."Move to description";
                                                Cust.MODIFY;
                                 MESSAGE('done');



                                  MOVESTATUS.RESET;
                                   MOVESTATUS.SETRANGE(MOVESTATUS."User ID",USERID);
                                    //MOVESTATUS.SETRANGE(MOVESTATUS.Description,"Current file location");
                                   IF MOVESTATUS.FIND('-') THEN  BEGIN
                                   REPEAT
                                  //IF MOVESTATUS.Description<>"Current file location" THEN
                                   //ERROR('You do not have permissions to MOVE the file.');



                                 IF CONFIRM('Are you sure you want to move the physical file to the selected location?') = FALSE THEN
                                 EXIT;



                                 FileMovementTracker.RESET;
                                 FileMovementTracker.SETRANGE(FileMovementTracker."Member No.","No.");
                                 IF FileMovementTracker.FIND('+') THEN BEGIN
                                 IF FileMovementTracker.Stage = "Move to" THEN
                                 ERROR('File already in %1',FileMovementTracker.Station);
                                 END;


                                 "File MVT User ID":=USERID;
                                 "File MVT Date":=TODAY;
                                 "File MVT Time":=TIME;
                                 "File Previous Location":="Current file location";
                                 "file Received":=FALSE;
                                 "file received date":=0D;
                                 "File received Time":=0T;
                                 "File Received by":='';
                                 MODIFY;


                                 ApprovalsSetup.RESET;
                                 ApprovalsSetup.SETRANGE(ApprovalsSetup."Approval Type",ApprovalsSetup."Approval Type"::"File Movement");
                                 ApprovalsSetup.SETRANGE(ApprovalsSetup.Stage,"Move to");
                                 IF ApprovalsSetup.FIND('-') THEN BEGIN
                                 FileMovementTracker.RESET;
                                 IF FileMovementTracker.FIND('+') THEN
                                 EntryNo:=FileMovementTracker."Entry No.";


                                 FileMovementTracker.INIT;
                                 FileMovementTracker."Entry No.":=EntryNo+1;
                                 FileMovementTracker."Member No.":="No.";
                                 FileMovementTracker."Approval Type":=ApprovalsSetup."Approval Type";
                                 FileMovementTracker.Stage:=ApprovalsSetup.Stage;
                                 FileMovementTracker."Current Location":=TRUE;
                                 FileMovementTracker.Description:=ApprovalsSetup.Description;
                                 FileMovementTracker.Station:=ApprovalsSetup.Station;
                                 FileMovementTracker."Date/Time In":=CREATEDATETIME(TODAY,TIME);
                                 FileMovementTracker."Date/Time Out":=CREATEDATETIME(TODAY,TIME);
                                 FileMovementTracker."USER ID":=USERID;
                                 FileMovementTracker.Remarks2:="File Movement Remarks";
                                 FileMovementTracker.INSERT(TRUE);

                                 //END;
                                 END ELSE
                                   ERROR('SORRY YOU ARE NOT AUTHORISED TO MOVE THIS FILE');

                                 UNTIL MOVESTATUS.NEXT=0;
                                          END;

                                 }
                                  }
                               END;
                                }
      { 2       ;2   ;Action    ;
                      Name=Receive Physical File;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 IF Status <> Status::Active THEN
                                 ERROR('You cannot receive an inactive file, kindly contact the administrator');


                                   Approvals.RESET;
                                   Approvals.SETRANGE(Approvals.Stage,"Move to");
                                   IF Approvals.FIND('-') THEN BEGIN
                                  Description:=Approvals.Description;
                                  station:=Approvals.Station;

                                   END;

                                   ApprovalUsers.RESET;
                                   ApprovalUsers.SETRANGE(ApprovalUsers."User ID",USERID);

                                   IF NOT ApprovalUsers.FIND('-') THEN BEGIN
                                   REPEAT
                                  IF ApprovalUsers."User ID" <> USERID THEN
                                  ERROR ('You do not have permission to receive a file');

                                  UNTIL ApprovalUsers.NEXT=0;
                                   END;


                                   ApprovalUsers.RESET;
                                   ApprovalUsers.SETRANGE(ApprovalUsers."User ID",USERID);
                                   ApprovalUsers.SETRANGE(ApprovalUsers."Approval Type",ApprovalUsers."Approval Type"::"File Movement");
                                   IF ApprovalUsers.FIND('-') THEN BEGIN

                                   REPEAT

                                   IF ApprovalUsers.Stage<>"Move to" THEN
                                  ERROR('You do not have permissions to Receive this file.');
                                 FileMovementTracker.RESET;

                                 IF FileMovementTracker.FIND('+') THEN BEGIN
                                 FileMovementTracker."Current Location":=FALSE;
                                 EntryNo:=FileMovementTracker."Entry No.";
                                 END;
                                 FileMovementTracker.INIT;
                                 FileMovementTracker."Entry No.":=EntryNo+1;
                                 FileMovementTracker."Member No.":="No.";
                                 //FileMovementTracker."Approval Type":=ApprovalsSetup."Approval Type";
                                 FileMovementTracker."Approval Type":=ApprovalUsers."Approval Type";
                                 FileMovementTracker.Stage:=ApprovalUsers.Stage;
                                 FileMovementTracker."Current Location":=TRUE;
                                 FileMovementTracker.Description:=Description;
                                 FileMovementTracker.Station:=station;
                                 FileMovementTracker."Date/Time In":=CREATEDATETIME(TODAY,TIME);
                                 FileMovementTracker."USER ID":=USERID;
                                 FileMovementTracker.Remarks:=Cust."File Movement Remarks";
                                 FileMovementTracker.INSERT(TRUE);



                                  {MOVESTATUS.RESET;
                                   MOVESTATUS.SETRANGE(MOVESTATUS."User ID",USERID);
                                    //MOVESTATUS.SETRANGE(MOVESTATUS.Description,"Current file location");
                                   IF MOVESTATUS.FIND('-') THEN  BEGIN
                                   REPEAT
                                   IF MOVESTATUS.Description<>"Current file location" THEN
                                   //ERROR('You do not have permissions to Receive this file.');


                                 MESSAGE('THE FILE HAS BEEN SUCCESSFULLY RECEIVED');
                                 UNTIL MOVESTATUS.NEXT=0;
                                 END;
                                 }


                                 IF ("file Received"=TRUE) THEN
                                 ERROR('THE FILE HAS  BEEN RECIEVED')
                                 ELSE
                                 IF CONFIRM('HAVE YOU RECEIVED THE PHISICAL FILE',FALSE)=FALSE THEN
                                 EXIT;
                                 IF "file Received"=TRUE THEN
                                 ERROR('THE FILE HAS  BEEN RECIEVED')
                                 ELSE
                                 "file Received":=TRUE;
                                 "File Received by":=USERID;
                                 "file received date":=TODAY;
                                 "File received Time":=TIME;
                                 "file Received":=TRUE;
                                 MODIFY;
                                 MODIFY;
                                  UNTIL ApprovalUsers.NEXT=0;
                                   END;
                                  }
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=ENU=General;
                Editable=TRUE }

    { 1102755000;2;Field  ;
                SourceExpr="No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr=Name;
                Editable=TRUE }

    { 1102760006;2;Field  ;
                SourceExpr="Payroll/Staff No";
                Editable=TRUE }

    { 1102760059;2;Field  ;
                SourceExpr="FOSA Account";
                Editable=TRUE;
                OnValidate=BEGIN
                             FosaName:='';

                             IF "FOSA Account" <> '' THEN BEGIN
                             IF Vend.GET("FOSA Account") THEN BEGIN
                             FosaName:=Vend.Name;
                             END;
                             END;
                           END;
                            }

    { 1102760106;2;Field  ;
                CaptionML=ENU=FOSA Account Name;
                SourceExpr=FosaName;
                Editable=TRUE }

    { 1102756020;2;Field  ;
                SourceExpr="Account Category";
                Editable=TRUE;
                OnValidate=BEGIN
                             lblIDVisible := TRUE;
                             lblDOBVisible := TRUE;
                             lblRegNoVisible := FALSE;
                             lblRegDateVisible := FALSE;
                             lblGenderVisible := TRUE;
                             txtGenderVisible := TRUE;
                             lblMaritalVisible := TRUE;
                             txtMaritalVisible := TRUE;
                             IF "Account Category" <> "Account Category"::Single THEN BEGIN
                             lblIDVisible := FALSE;
                             lblDOBVisible := FALSE;
                             lblRegNoVisible := TRUE;
                             lblRegDateVisible := TRUE;
                             lblGenderVisible := FALSE;
                             txtGenderVisible := FALSE;
                             lblMaritalVisible := FALSE;
                             txtMaritalVisible := FALSE;

                             END;
                           END;
                            }

    { 1000000000;2;Field  ;
                SourceExpr="Old Account No." }

    { 1102756015;2;Field  ;
                CaptionML=ENU=ID Number;
                SourceExpr="ID No.";
                Editable=TRUE }

    { 1102760067;2;Field  ;
                SourceExpr="Passport No.";
                Editable=TRUE }

    { 6   ;2   ;Field     ;
                SourceExpr=Address;
                Editable=TRUE }

    { 90  ;2   ;Field     ;
                CaptionML=ENU=Post Code/City;
                SourceExpr="Post Code";
                Editable=TRUE }

    { 1102755012;2;Field  ;
                SourceExpr=Gender }

    { 10  ;2   ;Field     ;
                SourceExpr=City }

    { 91  ;2   ;Field     ;
                SourceExpr=StatusPermissions."User Id";
                Editable=TRUE }

    { 12  ;2   ;Field     ;
                CaptionML=ENU=Mobile No.;
                SourceExpr="Phone No.";
                Editable=TRUE }

    { 1102760000;2;Field  ;
                CaptionML=ENU=Employer;
                SourceExpr="Employer Code";
                Editable=TRUE }

    { 1000000007;2;Field  ;
                SourceExpr="Staff UserID" }

    { 1000000001;2;Field  ;
                Name=Job Title;
                CaptionML=ENU=Job Title;
                SourceExpr="Job title";
                Editable=TRUE }

    { 1000000004;2;Field  ;
                Name=PIN;
                CaptionML=ENU=PIN;
                SourceExpr=Pin;
                Editable=TRUE }

    { 1102760077;2;Field  ;
                SourceExpr="Registration Date";
                Editable=true }

    { 1102760010;2;Field  ;
                Name=txtMarital;
                CaptionML=ENU=Marital Status;
                SourceExpr="Marital Status";
                Visible=txtMaritalVisible }

    { 1102756012;2;Field  ;
                CaptionML=ENU=Company Registration Date;
                SourceExpr="Date of Birth";
                Editable=TRUE }

    { 31  ;2   ;Field     ;
                SourceExpr=Picture }

    { 1000000002;2;Field  ;
                SourceExpr=Signature }

    { 1102756023;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=FALSE }

    { 1102755026;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                SourceExpr="Customer Posting Group";
                Editable=FALSE }

    { 1102760002;2;Field  ;
                SourceExpr=Status;
                Editable=TRUE;
                OnValidate=BEGIN
                             StatusPermissions.RESET;
                             StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                             StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
                             IF StatusPermissions.FIND('-') = FALSE THEN
                             ERROR('You do not have permissions to change the account status.');
                           END;
                            }

    { 26  ;2   ;Field     ;
                SourceExpr=Blocked }

    { 28  ;2   ;Field     ;
                SourceExpr="Last Date Modified";
                Editable=FALSE }

    { 1905652901;1;Group  ;
                CaptionML=ENU=Other Details;
                Editable=TRUE }

    { 1102755019;2;Field  ;
                SourceExpr="Contact Person" }

    { 1102755030;2;Field  ;
                SourceExpr="Contact Person Phone" }

    { 107 ;2   ;Field     ;
                SourceExpr="E-Mail" }

    { 1102755014;2;Field  ;
                SourceExpr="Village/Residence" }

    { 109 ;2   ;Field     ;
                SourceExpr="Home Page" }

    { 8   ;2   ;Field     ;
                CaptionML=ENU=Physical Address;
                SourceExpr="Address 2" }

    { 1102760042;2;Field  ;
                SourceExpr="Withdrawal Application Date" }

    { 1102760036;2;Field  ;
                SourceExpr="Withdrawal Date" }

    { 1102760038;2;Field  ;
                SourceExpr="Withdrawal Fee" }

    { 1102755004;2;Field  ;
                SourceExpr="Status - Withdrawal App." }

    { 1102755006;2;Field  ;
                SourceExpr="Mode of Dividend Payment" }

    { 1102755031;2;Field  ;
                SourceExpr="Recruited By" }

    { 1000000003;2;Field  ;
                SourceExpr="Sms Notification" }

  }
  CODE
  {
    VAR
      Text001@1003 : TextConst 'ENU=Do you want to allow payment tolerance for entries that are currently open?';
      Text002@1006 : TextConst 'ENU=Do you want to remove payment tolerance from entries that are currently open?';
      CustomizedCalEntry@1067 : Record 7603;
      CustomizedCalendar@1066 : Record 7602;
      CalendarMgmt@1065 : Codeunit 7600;
      PaymentToleranceMgt@1064 : Codeunit 426;
      PictureExists@1063 : Boolean;
      GenJournalLine@1062 : Record 81;
      GLPosting@1061 : Codeunit 12;
      StatusPermissions@1060 : Record 51516310;
      Charges@1059 : Record 51516297;
      Vend@1058 : Record 23;
      Cust@1057 : Record 51516223;
      LineNo@1056 : Integer;
      UsersID@1055 : Record 2000000120;
      GeneralSetup@1054 : Record 51516257;
      Loans@1053 : Record 51516230;
      AvailableShares@1052 : Decimal;
      Gnljnline@1051 : Record 81;
      Interest@1050 : Decimal;
      LineN@1049 : Integer;
      LRepayment@1048 : Decimal;
      TotalRecovered@1047 : Decimal;
      LoanAllocation@1046 : Decimal;
      LGurantors@1045 : Record 51516231;
      LoansR@1044 : Record 51516230;
      DActivity@1043 : Code[20];
      DBranch@1042 : Code[20];
      Accounts@1041 : Record 23;
      FosaName@1040 : Text[50];
      lblIDVisible@1039 : Boolean INDATASET;
      lblDOBVisible@1038 : Boolean INDATASET;
      lblRegNoVisible@1037 : Boolean INDATASET;
      lblRegDateVisible@1036 : Boolean INDATASET;
      lblGenderVisible@1035 : Boolean INDATASET;
      txtGenderVisible@1034 : Boolean INDATASET;
      lblMaritalVisible@1033 : Boolean INDATASET;
      txtMaritalVisible@1032 : Boolean INDATASET;
      AccNo@1031 : Code[20];
      Vendor@1030 : Record 23;
      TotalAvailable@1029 : Decimal;
      TotalFOSALoan@1028 : Decimal;
      TotalOustanding@1027 : Decimal;
      TotalDefaulterR@1026 : Decimal;
      value2@1025 : Decimal;
      Value1@1024 : Decimal;
      RoundingDiff@1023 : Decimal;
      Statuschange@1022 : Record 51516310;
      "WITHDRAWAL FEE"@1021 : Decimal;
      "AMOUNTTO BE RECOVERED"@1020 : Decimal;
      "Remaining Amount"@1019 : Decimal;
      TotalInsuarance@1018 : Decimal;
      PrincipInt@1017 : Decimal;
      TotalLoansOut@1016 : Decimal;
      FileMovementTracker@1015 : Record 51516254;
      EntryNo@1014 : Integer;
      ApprovalsSetup@1013 : Record 51516268;
      MovementTracker@1012 : Record 51516253;
      ApprovalUsers@1011 : Record 51516256;
      "Change Log"@1010 : Integer;
      openf@1009 : File;
      FMTRACK@1008 : Record 51516254;
      CurrLocation@1007 : Code[30];
      "Number of days"@1005 : Integer;
      Approvals@1004 : Record 51516268;
      Description@1002 : Text[30];
      Section@1001 : Code[10];
      station@1000 : Code[10];

    PROCEDURE ActivateFields@3();
    BEGIN
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

