OBJECT page 17350 Member Account Card
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=[ 4:16:57 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    CaptionML=ENU=Member Card;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516223;
    DelayedInsert=No;
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
                 {
                 IF NOT MapMgt.TestSetup THEN
                   CurrForm.MapPoint.VISIBLE(FALSE);
                 }

                 {
                 StatusPermissions.RESET;
                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
                 IF StatusPermissions.FIND('-') = FALSE THEN
                 ERROR('You do not have permissions to edit member information.');}
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
      { 1120054032;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054031;1 ;ActionGroup;
                      CaptionML=ENU=&Member }
      { 1120054030;2 ;Action    ;
                      Name=Member Ledger Entries;
                      CaptionML=ENU=Member Ledger Entries;
                      RunObject=page 17367;
                      RunPageView=SORTING(Customer No.);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=CustomerLedger }
      { 1120054029;2 ;Action    ;
                      Name=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=No.=FIELD(No.);
                      Image=Dimensions }
      { 1120054028;2 ;Action    ;
                      Name=Bank Account;
                      RunObject=Page 423;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=Card }
      { 1120054027;2 ;Action    ;
                      Name=Contacts;
                      Image=ContactPerson;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 1120054026;1 ;ActionGroup }
      { 1120054025;2 ;Action    ;
                      Name=Member Card;
                      Promoted=Yes;
                      Image=Card;
                      OnAction=BEGIN
                                  Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                  IF Cust.FINDFIRST THEN BEGIN
                                   REPORT.RUN(REPORT::"members card",TRUE,FALSE,Cust);
                                  END;
                               END;
                                }
      { 1120054024;2 ;Action    ;
                      Name=Account Page;
                      RunObject=page 17434;
                      RunPageLink=No.=FIELD(FOSA Account);
                      Promoted=Yes;
                      Image=Planning;
                      PromotedCategory=Process }
      { 1120054023;2 ;Action    ;
                      Name=Members Kin Details List;
                      CaptionML=ENU=Members Kin Details List;
                      RunObject=page 17368;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1120054022;2 ;Action    ;
                      CaptionML=ENU=SPouse & Children;
                      RunObject=page 50021;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=relationship;
                      PromotedCategory=Process }
      { 1120054021;2 ;Action    ;
                      Name=Account Signatories;
                      CaptionML=ENU=Signatories Details;
                      RunObject=page 17369;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      PromotedCategory=Process }
      { 1120054020;2 ;Action    ;
                      Name=Members Statistics;
                      RunObject=page 17366;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1120054019;2 ;Action    ;
                      Name=Member is  a Guarantor;
                      CaptionML=ENU=Member is  a Guarantor;
                      Image=Report;
                      OnAction=BEGIN

                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516226,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054018;2 ;Action    ;
                      Name=Member is  Guaranteed;
                      CaptionML=ENU=Member is  Guaranteed;
                      Image=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516225,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054017;2 ;Action    ;
                      Name=Monthly Contributions;
                      RunObject=page 50017;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Setup;
                      PromotedCategory=Process }
      { 1120054016;2 ;ActionGroup }
      { 1120054015;2 ;Action    ;
                      Name=Detailed Statement;
                      CaptionML=ENU=Detailed Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516223,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054014;2 ;Action    ;
                      Name=Detailed Statemet_Shares;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516438,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054013;2 ;Action    ;
                      Name=Detailed Interest Statement;
                      CaptionML=ENU=Detailed Interest Statement;
                      Image=Report;
                      OnAction=BEGIN
                                 {Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,Cust);
                                 }
                               END;
                                }
      { 1120054012;2 ;Action    ;
                      Name=Loan Statement;
                      CaptionML=ENU=Loan Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516594,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054011;2 ;Action    ;
                      Name=Account Closure Slip;
                      CaptionML=ENU=Account Closure Slip;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516250,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054010;2 ;Action    ;
                      Name=Recover Loans from Gurantors;
                      CaptionML=ENU=Recover Loans from Gurantors;
                      Image=Report;
                      OnAction=BEGIN

                                 IF ("Current Shares" * -1) > 0 THEN
                                 ERROR('Please recover the loans from the members shares before recovering from gurantors.');

                                 IF CONFIRM('Are you absolutely sure you want to recover the loans from the guarantors as loans?') = FALSE THEN
                                 EXIT;

                                 RoundingDiff:=0;

                                 //delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'LOANS');
                                 Gnljnline.DELETEALL;
                                 //end of deletion

                                 TotalRecovered:=0;

                                 DActivity:="Global Dimension 1 Code";
                                 DBranch:="Global Dimension 2 Code";

                                 CALCFIELDS("Outstanding Balance","Accrued Interest","Insurance Fund","Current Shares");


                                 IF "Closing Deposit Balance" = 0 THEN
                                 "Closing Deposit Balance":="Current Shares"*-1;
                                 IF "Closing Loan Balance" = 0 THEN
                                 "Closing Loan Balance":="Outstanding Balance"+"FOSA Outstanding Balance";
                                 IF "Closing Insurance Balance" = 0 THEN
                                 "Closing Insurance Balance":="Insurance Fund"*-1;
                                 "Withdrawal Posted":=TRUE;
                                 MODIFY;


                                 CALCFIELDS("Outstanding Balance","Accrued Interest","Current Shares");



                                 LoansR.RESET;
                                 LoansR.SETRANGE(LoansR."Client Code","No.");
                                 LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                                 IF LoansR.FIND('-') THEN BEGIN
                                 REPEAT

                                 LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."No. Of Guarantors");

                                 //No Shares recovery
                                 IF LoansR."Recovered Balance" = 0 THEN BEGIN
                                 LoansR."Recovered Balance":=LoansR."Outstanding Balance";
                                 END;
                                 LoansR."Recovered From Guarantor":=TRUE;
                                 LoansR."Guarantor Amount":=LoansR."Outstanding Balance";
                                 LoansR.MODIFY;

                                 IF ((LoansR."Outstanding Balance" + LoansR."Oustanding Interest") > 0) AND (LoansR."No. Of Guarantors" > 0) THEN BEGIN

                                 LoanAllocation:=ROUND((LoansR."Outstanding Balance")/LoansR."No. Of Guarantors",0.01)+
                                                 ROUND((LoansR."Oustanding Interest")/LoansR."No. Of Guarantors",0.01);


                                 LGurantors.RESET;
                                 LGurantors.SETRANGE(LGurantors."Loan No",LoansR."Loan  No.");
                                 LGurantors.SETRANGE(LGurantors.Substituted,FALSE);
                                 IF LGurantors.FIND('-') THEN BEGIN
                                 REPEAT


                                 Loans.RESET;
                                 Loans.SETRANGE(Loans."Client Code",LGurantors."Member No");
                                 Loans.SETRANGE(Loans."Loan Product Type",'L07');
                                 Loans.SETRANGE(Loans.Posted,FALSE);
                                 IF Loans.FIND('-') THEN
                                 Loans.DELETEALL;


                                 Loans.INIT;
                                 Loans."Loan  No.":='';
                                 Loans.Source:=Loans.Source::BOSA;
                                 Loans."Client Code":=LGurantors."Member No";
                                 Loans."Loan Product Type":='L07';
                                 Loans.VALIDATE(Loans."Client Code");
                                 Loans."Application Date":=TODAY;
                                 Loans.VALIDATE(Loans."Loan Product Type");
                                 IF (LoansR."Approved Amount" > 0) AND (LoansR.Installments > 0) THEN
                                 Loans.Installments:=ROUND((LoansR."Outstanding Balance")
                                                           /(LoansR."Approved Amount"/LoansR.Installments),1,'>');
                                 Loans."Requested Amount":=LoanAllocation;
                                 Loans."Approved Amount":=LoanAllocation;
                                 Loans.VALIDATE(Loans."Approved Amount");
                                 Loans."Loan Status":=Loans."Loan Status"::Approved;
                                 Loans."Issued Date":=TODAY;
                                 Loans."Loan Disbursement Date":=TODAY;
                                 Loans."Repayment Start Date":=TODAY;
                                 Loans."Batch No.":="Batch No.";
                                 Loans."BOSA No":=LGurantors."Member No";
                                 Loans."Recovered Loan":=LoansR."Loan  No.";
                                 Loans.INSERT(TRUE);

                                 Loans.RESET;
                                 Loans.SETRANGE(Loans."Client Code",LGurantors."Member No");
                                 Loans.SETRANGE(Loans."Loan Product Type",'L07');
                                 Loans.SETRANGE(Loans.Posted,FALSE);
                                 IF Loans.FIND('-') THEN BEGIN

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":='GL-'+LoansR."Client Code";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=LoansR."Loan  No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":=LGurantors."Member No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Principle Amount';
                                 GenJournalLine.Amount:=LoanAllocation;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                                 GenJournalLine."Loan No":=Loans."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;


                                 Loans.Posted:=TRUE;
                                 Loans.MODIFY;


                                 //Off Set BOSA Loans

                                 //Principle
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":='GL-'+LoansR."Client Code";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=Loans."Loan  No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":=LoansR."Client Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Cleared by Guarantor loan: ' + Loans."Loan  No.";
                                 GenJournalLine.Amount:=-ROUND(LoansR."Outstanding Balance"/LoansR."No. Of Guarantors",0.01);
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;



                                 //Interest
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='LOANS';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":='GL-'+LoansR."Client Code";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":=Loans."Loan  No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":=LoansR."Client Code";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Cleared by Guarantor loan: ' + Loans."Loan  No.";
                                 GenJournalLine.Amount:=-ROUND(LoansR."Oustanding Interest"/LoansR."No. Of Guarantors",0.01);
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                                 GenJournalLine."Loan No":=LoansR."Loan  No.";
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;



                                 LoansR.Advice:=TRUE;
                                 LoansR.MODIFY;

                                 END;

                                 UNTIL LGurantors.NEXT = 0;
                                 END;
                                 END;

                                 UNTIL LoansR.NEXT = 0;
                                 END;


                                 "Defaulted Loans Recovered":=TRUE;
                                 MODIFY;


                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'LOANS');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;



                                 MESSAGE('Loan recovery from guarantors posted successfully.');
                               END;
                                }
      { 1120054009;2 ;Action    ;
                      Name=View FOSA Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","FOSA Account");
                                 IF Vend.FINDFIRST THEN
                                   BEGIN
                                     CatchStaff();
                                     REPORT.RUN(51516201,TRUE,FALSE,Vend);
                                   END;

                               END;
                                }
      { 1120054008;2 ;Action    ;
                      Name=Recover Loans from Deposit;
                      CaptionML=ENU=Recover Loans from Deposit;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you absolutely sure you want to recover the loans from member deposit') = FALSE THEN
                                 EXIT;

                                 //"Withdrawal Fee":=1000;

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
                                  {
                                 // END OF GETTING WITHDRWAL FEE
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='Recoveries';
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Document No.":="No.";
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine."External Document No.":="No.";
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 }

                                 "Closing Deposit Balance":=("Current Shares");


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
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 "Closing Deposit Balance":=("Current Shares"-TotalInsuarance);

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
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
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
                                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='Defaulted Loans Against Deposits';
                                 GenJournalLine.Amount:=(TotalRecovered-TotalInsuarance)*-1;
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


                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Recoveries');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;



                                 MESSAGE('Loan recovery from Deposits posted successfully.');
                               END;
                                }
      { 1120054007;2 ;Action    ;
                      Name=FOSA Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","FOSA Account");
                                 IF Vend.FINDFIRST THEN
                                   BEGIN
                                     CatchStaff();
                                     REPORT.RUN(51516248,TRUE,FALSE,Vend);
                                   END;
                               END;
                                }
      { 1120054006;2 ;ActionGroup;
                      CaptionML=ENU=Issued Documents;
                      Visible=FALSE }
      { 1120054005;2 ;Action    ;
                      Name=Dispatch Physical File;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN


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
                               END;
                                }
      { 1120054004;2 ;Action    ;
                      Name=Receive Physical File;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF Status <> Status::Active THEN
                                 ERROR('You cannot receive an inactive file, kindly contact the administrator');


                                   Approvals.RESET;
                                   Approvals.SETRANGE(Approvals.Stage,"Move to");
                                   IF Approvals.FIND('-') THEN BEGIN
                                  Description:=Approvals.Description;
                                  Station:=Approvals.Station;

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
                                 FileMovementTracker.Station:=Station;
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
                               END;
                                }
      { 1120054053;2 ;Action    ;
                      Name=Unmark As Defaulter;
                      OnAction=BEGIN
                                 IF (USERID='TELEPOST\GOMINDE') OR (USERID='TELEPOST\ADMINISTRATOR') OR (USERID='TELEPOST\KGACHIHI')THEN BEGIN
                                 "Loan Defaulter":=FALSE;
                                 "Loan Status":="Loan Status"::Performing;
                                   Rec.Status:=Rec.Status::Active;
                                 MODIFY;
                                 END;
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
                Editable=FALSE }

    { 1102760006;2;Field  ;
                SourceExpr="Payroll/Staff No";
                Editable=FALSE }

    { 1102760059;2;Field  ;
                SourceExpr="FOSA Account";
                Editable=FALSE;
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
                Editable=FALSE }

    { 1102756020;2;Field  ;
                SourceExpr="Account Category";
                Editable=FALSE;
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

    { 1120054065;2;Field  ;
                SourceExpr="Insider Classification" }

    { 1000000000;2;Field  ;
                SourceExpr="Old Account No.";
                Editable=FALSE }

    { 1102756015;2;Field  ;
                CaptionML=ENU=ID Number;
                SourceExpr="ID No.";
                Editable=FALSE }

    { 1102760067;2;Field  ;
                SourceExpr="Passport No.";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr=Address;
                Editable=FALSE }

    { 90  ;2   ;Field     ;
                CaptionML=ENU=Post Code/City;
                SourceExpr="Post Code";
                Editable=FALSE }

    { 1120054035;2;Field  ;
                SourceExpr="Last Payment Date";
                Editable=FALSE }

    { 1102755012;2;Field  ;
                SourceExpr=Gender;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                SourceExpr=City;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                CaptionML=ENU=Mobile No.;
                SourceExpr="Phone No.";
                Editable=FALSE }

    { 1000000004;2;Field  ;
                Name=PIN;
                CaptionML=ENU=PIN;
                SourceExpr=Pin;
                Editable=FALSE }

    { 1120054036;2;Field  ;
                Name=Section;
                CaptionML=ENU=Section;
                SourceExpr=Section;
                Editable=FALSE }

    { 1120054033;2;Field  ;
                SourceExpr="Monthly Contribution";
                Editable=FALSE }

    { 1102760077;2;Field  ;
                SourceExpr="Registration Date";
                Editable=FALSE }

    { 1102755014;2;Field  ;
                SourceExpr="Village/Residence";
                Editable=FALSE }

    { 1102760010;2;Field  ;
                Name=txtMarital;
                CaptionML=ENU=Marital Status;
                SourceExpr="Marital Status";
                Visible=txtMaritalVisible;
                Editable=FALSE }

    { 1102756012;2;Field  ;
                SourceExpr="Date of Birth";
                Editable=FALSE }

    { 1120054034;2;Field  ;
                SourceExpr="Date Of Retirement";
                Editable=FALSE }

    { 1120054002;2;Field  ;
                SourceExpr=Picture;
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr=Signature;
                Editable=FALSE }

    { 1120054003;2;Field  ;
                SourceExpr="Front Side ID";
                Editable=FALSE }

    { 1120054001;2;Field  ;
                SourceExpr="Back Side ID";
                Editable=FALSE }

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
                CaptionML=ENU=Account Status;
                SourceExpr=Status;
                Editable=FALSE;
                OnValidate=BEGIN
                             StatusPermissions.RESET;
                             StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                             StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
                             IF StatusPermissions.FIND('-') = FALSE THEN
                             ERROR('You do not have permissions to change the account status.');
                           END;
                            }

    { 1120054066;2;Field  ;
                SourceExpr="Membership Status" }

    { 1120054054;2;Field  ;
                SourceExpr="Loans Defaulter Status";
                Editable=FALSE }

    { 1120054045;2;Field  ;
                SourceExpr="Loan Defaulter";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                SourceExpr=Blocked;
                Editable=FALSE }

    { 1120054043;2;Field  ;
                SourceExpr="ESS Monthly Contribution";
                Editable=FALSE }

    { 1120054044;2;Field  ;
                SourceExpr="ESS Last Contribution Date";
                Editable=FALSE }

    { 1120054055;2;Field  ;
                SourceExpr="Last Deposit Date Sch";
                Editable=FALSE }

    { 1120054056;2;Field  ;
                SourceExpr="Last Deposit Date Deposit";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                SourceExpr="Last Date Modified";
                Editable=FALSE }

    { 1120054052;1;Group  ;
                CaptionML=ENU=Employment Information;
                Editable=FALSE;
                GroupType=Group }

    { 1120054051;2;Field  ;
                SourceExpr="Employment Type" }

    { 1120054050;2;Field  ;
                SourceExpr="Employer Code";
                ShowMandatory=True }

    { 1120054049;2;Field  ;
                SourceExpr="Employer Name";
                Editable=FALSE }

    { 1120054048;2;Field  ;
                SourceExpr=Designation;
                ShowMandatory=True }

    { 1120054047;2;Field  ;
                SourceExpr=County }

    { 1120054046;2;Field  ;
                SourceExpr="Sub-County" }

    { 1120054042;2;Field  ;
                Name=*****Self Employed********* }

    { 1120054041;2;Field  ;
                SourceExpr="Nature of Business" }

    { 1120054040;2;Field  ;
                SourceExpr="Name of Business" }

    { 1120054039;2;Field  ;
                SourceExpr="Office Telephone No." }

    { 1905652901;1;Group  ;
                CaptionML=ENU=Other Details;
                Editable=FALSE }

    { 1120054037;2;Field  ;
                SourceExpr=Station }

    { 1120054038;2;Field  ;
                SourceExpr=Region }

    { 1102755019;2;Field  ;
                SourceExpr="Contact Person" }

    { 1102755030;2;Field  ;
                SourceExpr="Contact Person Phone" }

    { 107 ;2   ;Field     ;
                SourceExpr="E-Mail" }

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

    { 1120054059;2;Field  ;
                SourceExpr="Checkoff Member" }

    { 1120054060;2;Field  ;
                SourceExpr="Salary Member" }

    { 1120054061;2;Field  ;
                SourceExpr="Last Checkoff Date" }

    { 1120054062;2;Field  ;
                SourceExpr="Last Salary Date" }

    { 1120054063;2;Field  ;
                SourceExpr="Last Salary Amount" }

    { 1120054064;2;Field  ;
                SourceExpr="Last Checkoff Amount" }

    { 1120054057;1;Group  ;
                CaptionML=ENU=Staff Details;
                GroupType=Group }

    { 1120054058;2;Field  ;
                SourceExpr="Staff UserID" }

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
      AccountViewing@1120054002 : Record 51516648;
      EntryNos@1120054001 : Integer;
      AccountViewings@1120054000 : Record 51516648;

    PROCEDURE ActivateFields@3();
    BEGIN
    END;

    LOCAL PROCEDURE OnAfterGetCurrRecord@19077479();
    BEGIN
      xRec := Rec;
      ActivateFields;
    END;

    PROCEDURE CatchStaff@1000000003();
    BEGIN
      IF Vend."Company Code"='STAFF' THEN
        BEGIN
          IF "Staff UserID"<>USERID THEN
           MESSAGE('You cannot view a statement belonging to another member of staff!');
        END;
    END;

    BEGIN
    END.
  }
}

