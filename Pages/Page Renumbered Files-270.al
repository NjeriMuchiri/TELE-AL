OBJECT page 17461 ATM Applications Card
{
  OBJECT-PROPERTIES
  {
    Date=11/10/21;
    Time=[ 2:39:14 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    DeleteAllowed=Yes;
    SourceTable=Table51516321;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1102755002;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755010;1 ;ActionGroup;
                      CaptionML=ENU=Pesa Point ATM Card }
      { 1102755009;2 ;Action    ;
                      CaptionML=ENU=Approve Application;
                      Promoted=Yes;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to approve this application?',TRUE)=TRUE THEN BEGIN
                                 IF "Application Approved"=TRUE THEN
                                 ERROR('This application is already approved');
                                 //TESTFIELD("No.");
                                 TESTFIELD("Account Type");
                                 //TESTFIELD("Customer ID");
                                 //TESTFIELD("Request Type C");
                                 //TESTFIELD("Phone No.");
                                 //TESTFIELD("Card Type");

                                 "Approval Date":=TODAY;
                                 "Application Approved":=TRUE;
                                 MODIFY;
                                 END ELSE
                                 ERROR('Operation cancelled');
                               END;
                                }
      { 1102755008;2 ;Action    ;
                      CaptionML=ENU=Received from bank;
                      Promoted=Yes;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 IF Collected=TRUE THEN
                                 ERROR('The ATM Card has already been collected');

                                 IF CONFIRM('Are you sure you have received this ATM card from Bank?',TRUE) = TRUE THEN  BEGIN

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Ftrans');
                                 GenJournalLine.DELETEALL;



                                 //generalSetup.GET();

                                 generalSetup.GET;

                                 LineNo:=LineNo+10000;


                                  //Vendor Entry
                                 //IF AccountTypes.FIND('-') THEN  BEGIN
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='Ftrans';
                                 GenJournalLine."Document No.":='ATM charge' ;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;

                                 //::
                                 {IF "Request Type"="Request Type":: THEN
                                 GenJournalLine.Description:='ATM charge-Replacement'
                                 ELSE
                                 IF "Card Type"="Card Type"::"0" THEN
                                 GenJournalLine.Description:='ATM charge-New'
                                 ELSE
                                 IF "Card Type"="Card Type"::"2" THEN
                                 GenJournalLine.Description:='ATM charge-Renewal';

                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF "Card Type"="Card Type"::"1" THEN
                                 GenJournalLine.Amount:=generalSetup."ATM Card Fee-Replacement"
                                 ELSE
                                 IF "Card Type"="Card Type"::"0" THEN
                                 GenJournalLine.Amount:=generalSetup."ATM Card Fee-New Coop"
                                 ELSE
                                 IF "Card Type"="Card Type"::"2" THEN
                                 GenJournalLine.Amount:=generalSetup."ATM Card Fee-Renewal";
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 //GenJournalLine."Bal. Account No.":=generalSetup."ATM Card Fee Co-op Bank";
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';
                                 //END;
                                 }
                                 {
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';
                                 }

                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;






                                 //Bank Account Entry

                                 LineNo:=LineNo+10000;

                                 //IF AccountTypes.FIND('-') THEN  BEGIN
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='Ftrans';
                                 GenJournalLine."Document No.":='ATM charge' ;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":=generalSetup."ATM Card Fee Co-op Bank";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 {IF "Card Type"="Card Type"::"1" THEN
                                 GenJournalLine.Description:='ATM charge-Replacement'
                                 ELSE
                                 IF "Card Type"="Card Type"::"0" THEN
                                 GenJournalLine.Description:='ATM charge-New'
                                 ELSE
                                 IF "Card Type"="Card Type"::"2" THEN
                                 GenJournalLine.Description:='ATM charge-Renewal';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF "Card Type"="Card Type"::"1" THEN
                                 GenJournalLine.Amount:=-generalSetup."ATM Card Co-op Bank Amount"
                                 ELSE
                                 IF "Card Type"="Card Type"::"0" THEN
                                 GenJournalLine.Amount:=-generalSetup."ATM Card Co-op Bank Amount"
                                 ELSE
                                 IF "Card Type"="Card Type"::"2" THEN
                                 GenJournalLine.Amount:=-generalSetup."ATM Card Co-op Bank Amount";
                                 }
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 //GenJournalLine."Bal. Account No.":=generalSetup."ATM Card Fee-Account";
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';


                                 //END;


                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';


                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;




                                 //Commission Entry

                                 LineNo:=LineNo+10000;

                                 //IF AccountTypes.FIND('-') THEN  BEGIN
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='Ftrans';
                                 GenJournalLine."Document No.":='ATM charge' ;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=generalSetup."ATM Card Fee-Account";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;{
                                 IF "Card Type"="Card Type"::"1" THEN
                                 GenJournalLine.Description:='ATM charge-Commission'
                                 ELSE
                                 IF "Card Type"="Card Type"::"0" THEN
                                 GenJournalLine.Description:='ATM charge-Commission'
                                 ELSE
                                 IF "Card Type"="Card Type"::"2" THEN
                                 GenJournalLine.Description:='ATM charge-Commission';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF "Card Type"="Card Type"::"1" THEN
                                 GenJournalLine.Amount:=-generalSetup."ATM Card Fee-New Sacco"
                                 ELSE
                                 IF "Card Type"="Card Type"::"0" THEN
                                 GenJournalLine.Amount:=-generalSetup."ATM Card Fee-New Sacco"
                                 ELSE
                                 IF "Card Type"="Card Type"::"2" THEN
                                 GenJournalLine.Amount:=-generalSetup."ATM Card Fee-New Sacco";
                                 }
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 //GenJournalLine."Bal. Account No.":=generalSetup."ATM Card Fee-Account";
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';


                                 //END;


                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';


                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;


                                 //Excise Duty

                                 LineNo:=LineNo+10000;

                                 //IF AccountTypes.FIND('-') THEN  BEGIN
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='Ftrans';
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=generalSetup."Excise Duty Account";
                                 GenJournalLine."Document No.":='ATM charge' ;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Amount:=-(generalSetup."ATM Card Fee-New Sacco"*generalSetup."Excise Duty(%)")/100;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 //GenJournalLine."Bal. Account No.":=generalSetup."Excise Duty Account";
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';
                                 //END;


                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';


                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;



                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Ftrans');
                                 IF GenJournalLine.FIND('-') THEN BEGIN

                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);

                                 //window.OPEN('Posting:,#1######################');
                                 END;
                                 //Post New
                                 Collected:=TRUE;
                                 "Date Collected":=TODAY;
                                 "Card Issued By":=USERID;
                                 //Status:=TRUE;
                                 //"Entry No":=TODAY;
                                 MODIFY;

                                 END;



                                 Vend.GET("No.");
                                 Vend."ATM No.":='';
                                 Vend."Atm card ready":=TRUE;
                                 Vend.MODIFY;

                                 generalSetup.GET();
                                 "ATM Expiry Date":=CALCDATE(generalSetup."ATM Expiry Duration",TODAY);


                                 {GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Ftrans');
                                 GenJournalLine.DELETEALL;}
                               END;
                                }
      { 1000000003;2 ;Action    ;
                      Name=Replace Card;
                      Promoted=Yes;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Vend.GET("No.");
                                 IF CONFIRM('Are you sure you want to replace the ATM card Number?',TRUE)=TRUE    THEN
                                 Vend."ATM No.":='';
                                 Vend."Last Date Modified":=TODAY;
                                 Vend.MODIFY;

                                  Atm.RESET;
                                  Atm.SETRANGE(Atm."No.","No.");
                                  IF Atm.FIND('-') THEN BEGIN
                                 {IF Atm."Application Date"=Atm."ATM Card Fee Charged By" THEN
                                 ERROR('Please insert the new ATM card Number')
                                 ELSE
                                 "ATM Card Fee Charged By":=Atm."Application Date";
                                 //"Card No":=Atm."New ATM Number";
                                 MODIFY;
                                 }
                                 END;
                               END;
                                }
      { 1102755012;2 ;Action    ;
                      Name=Disable ATM Card;
                      CaptionML=ENU=Disable ATM Card;
                      Promoted=Yes;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Vend.GET("No.");
                                 IF CONFIRM('Are you sure you want to disable this account from ATM transactions  ?',TRUE)=TRUE    THEN
                                 Vend."ATM No.":='';
                                 Vend."Disabled By":=USERID;
                                 Vend."Last Date Modified":=TODAY;
                                 //Vend.Blocked:=Vend.Blocked::Payment;
                                 //Vend."Account Frozen":=TRUE;
                                 Vend.MODIFY;
                               END;
                                }
      { 1102755031;2 ;Action    ;
                      Name=Enable ATM Card;
                      Promoted=Yes;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Vend.GET("No.");
                                 IF CONFIRM('Are you sure you want to Enable ATM no. for this account  ?',TRUE)=TRUE    THEN
                                 Vend."ATM No.":='';//"Application Date";
                                 //Vend.Blocked:=Vend.Blocked::Payment;
                                 //Vend."Account Frozen":=TRUE;
                                 Vend.MODIFY;

                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND()
                                 THEN BEGIN
                                 //Clear journal
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 LineNo:=LineNo+10000;
                                 Vend.CALCFIELDS(Vend.Balance);

                                 IF Vend.Balance>605 THEN
                                 //Insert ATM Charge
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='ATM';
                                 GenJournalLine."Document No.":='ATM CHARGE'+''+"No.";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 IF "No."='00-0000000000' THEN
                                 GenJournalLine."External Document No.":=Vend."ID No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Atm card cost';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=500;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Bal. Account No.":='BNK00008';
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Insert Excise Duty on ATM Charge
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='ATM';
                                 GenJournalLine."Document No.":='ATM CHARGE'+''+"No.";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 IF "No."='00-0000000000' THEN
                                 GenJournalLine."External Document No.":=Vend."ID No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Excise duty on ATM Charge';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=50;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                                 GenJournalLine."Bal. Account No.":='BNK00008';
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Insert Sacco Income
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='ATM';
                                 GenJournalLine."Document No.":='ATM CHARGE'+''+"No.";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 IF "No."='00-0000000000' THEN
                                 GenJournalLine."External Document No.":=Vend."ID No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='ATM Sacco income';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=50;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":='300-000-404';
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Generate Excise Duty on Sacco income
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='ATM';
                                 GenJournalLine."Document No.":='ATM CHARGE'+''+"No.";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="No.";
                                 IF "No."='00-0000000000' THEN
                                 GenJournalLine."External Document No.":=Vend."ID No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Ex-duty ATM Sacco income';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=5;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 generalSetup.GET();
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=generalSetup."Excise Duty Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":='NAIROBI';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 //Send SMS
                                 FnSendSMS("No.");

                                 //Post
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'ATM');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::Codeunit50013,GenJournalLine);
                                 END;
                                 END


                               END;
                                }
      { 1102755030;2 ;Action    ;
                      Name=Confirm Card Collection;
                      Promoted=Yes;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                  IF ModeOfCollection=ModeOfCollection::"Card Sent" THEN BEGIN
                                 TESTFIELD("Issued to");
                                 END;

                                  IF CONFIRM('Are you sure you want to issue this Card?',TRUE)=TRUE THEN
                                  Collected:=TRUE;
                                  MODIFY;

                                 Vend.GET("No.");
                                 Vend."ATM No.":='';//"Application Date";
                               END;
                                }
      { 1120054001;2 ;Action    ;
                      Name=Send A&pproval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755001 : TextConst 'ENU=This Batch is already pending approval';
                                 ApprovalsMgmt@1000000000 : Codeunit 1535;
                               BEGIN

                                 IF ApprovalsMgmt.CheckCloudATMApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendCloudATMForApproval(Rec);
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1120054000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckCloudATMApprovalsWorkflowEnabled(Rec)  THEN
                                   ApprovalsMgmt.OnCancelCloudATMApprovalRequest(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 34  ;0   ;Container ;
                ContainerType=ContentArea }

    { 33  ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="Account No";
                Editable=False }

    { 32  ;2   ;Field     ;
                SourceExpr="No.";
                Editable=true }

    { 31  ;2   ;Field     ;
                SourceExpr="Branch Code" }

    { 30  ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 28  ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 27  ;2   ;Field     ;
                SourceExpr=Address }

    { 26  ;2   ;Field     ;
                SourceExpr="Address 5" }

    { 25  ;2   ;Field     ;
                SourceExpr="Relation Indicator" }

    { 24  ;2   ;Field     ;
                SourceExpr="Card Type" }

    { 23  ;2   ;Field     ;
                SourceExpr="Request Type" }

    { 22  ;2   ;Field     ;
                ExtendedDatatype=None;
                SourceExpr="Application Date";
                OnValidate=BEGIN


                              //IF STRLEN("Application Date") <> 16 THEN
                              // ERROR('ATM No. cannot contain More or less than 16 Characters.');
                           END;
                            }

    { 1000000002;2;Field  ;
                SourceExpr="ATM Card Fee Charged By";
                Editable=False }

    { 21  ;2   ;Field     ;
                SourceExpr="Card No" }

    { 20  ;2   ;Field     ;
                SourceExpr="Date Issued" }

    { 19  ;2   ;Field     ;
                SourceExpr=Limit }

    { 18  ;2   ;Field     ;
                SourceExpr="Terms Read and Understood";
                Editable=false }

    { 17  ;2   ;Field     ;
                SourceExpr="Card Issued" }

    { 16  ;2   ;Field     ;
                SourceExpr="Form No" }

    { 15  ;2   ;Field     ;
                SourceExpr="Sent To External File" }

    { 1120054003;2;Field  ;
                SourceExpr="Time Captured";
                Editable=False }

    { 14  ;2   ;Field     ;
                SourceExpr="Card Status" }

    { 13  ;2   ;Field     ;
                SourceExpr="Date Activated" }

    { 12  ;2   ;Field     ;
                SourceExpr="Has Other Accounts" }

    { 11  ;2   ;Field     ;
                SourceExpr="Account Type C" }

    { 10  ;2   ;Field     ;
                SourceExpr="Phone No." }

    { 8   ;2   ;Field     ;
                SourceExpr=Collected;
                Editable=false }

    { 7   ;2   ;Field     ;
                SourceExpr="Application Approved";
                Editable=false }

    { 6   ;2   ;Field     ;
                SourceExpr="Date Collected";
                Editable=TRUE }

    { 5   ;2   ;Field     ;
                SourceExpr="Card Issued By";
                Editable=false }

    { 4   ;2   ;Field     ;
                SourceExpr="Approval Date";
                Editable=TRUE }

    { 3   ;2   ;Field     ;
                SourceExpr="ATM Expiry Date";
                Editable=TRUE }

    { 2   ;2   ;Field     ;
                SourceExpr=ModeOfCollection;
                Editable=true }

    { 1   ;2   ;Field     ;
                SourceExpr="Issued to" }

    { 1000000000;2;Field  ;
                SourceExpr="ATM Card Fee Charged";
                Editable=False }

    { 1120054004;2;Field  ;
                SourceExpr="ATM Card Linked" }

    { 1120054006;0;Container;
                ContainerType=FactBoxArea }

    { 1120054005;1;Part   ;
                SubPageLink=No.=FIELD(Member No.);
                PagePartID=Page51516735;
                PartType=Page }

  }
  CODE
  {
    VAR
      GenJournalLine@1102755025 : Record 81;
      DefaultBatch@1102755024 : Record 232;
      LineNo@1102755023 : Integer;
      AccountHolders@1102755022 : Record 23;
      window@1102755021 : Dialog;
      PostingCode@1102755020 : Codeunit 12;
      CalendarMgmt@1102755019 : Codeunit 7600;
      PaymentToleranceMgt@1102755018 : Codeunit 426;
      CustomizedCalEntry@1102755017 : Record 51516266;
      PictureExists@1102755015 : Boolean;
      AccountTypes@1102755014 : Record 51516295;
      GLPosting@1102755013 : Codeunit 12;
      StatusPermissions@1102755012 : Record 51516310;
      Charges@1102755011 : Record 51516297;
      ForfeitInterest@1102755010 : Boolean;
      InterestBuffer@1102755009 : Record 51516324;
      FDType@1102755008 : Record 51516305;
      Vend@1102755007 : Record 23;
      Cust@1102755006 : Record 18;
      UsersID@1102755005 : Record 2000000120;
      Bal@1102755004 : Decimal;
      AtmTrans@1102755003 : Decimal;
      UnCheques@1102755002 : Decimal;
      AvBal@1102755001 : Decimal;
      Minbal@1102755000 : Decimal;
      generalSetup@1102755026 : Record 51516257;
      Atm@1000000000 : Record 51516321;
      No@1120054000 : Text;

    LOCAL PROCEDURE FnSendSMS@1120054004(PhoneNumber@1120054001 : Code[50]);
    VAR
      SMSMessage@1120054002 : Record 51516329;
      iEntryNo@1120054003 : Integer;
    BEGIN
            SMSMessage.RESET;
            IF SMSMessage.FIND('+') THEN BEGIN
            iEntryNo:=SMSMessage."Entry No";
            iEntryNo:=iEntryNo+1;
            END
            ELSE BEGIN
            iEntryNo:=1;
            END;
            SMSMessage.LOCKTABLE;
            SMSMessage.RESET;
            SMSMessage.INIT;
            SMSMessage."Entry No":=iEntryNo;
            SMSMessage."Account No":='';
            SMSMessage."Date Entered":=TODAY;
            SMSMessage."Time Entered":=TIME;
            SMSMessage.Source:='ATM ACTIVATION';
            SMSMessage."Entered By":=USERID;
            SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
            SMSMessage."SMS Message":='Dear member, your atm card is ready for collection at telepost sacco head office. For Inquiries call +254727438688';


            SMSMessage."Telephone No":=PhoneNumber;
            SMSMessage.INSERT;
    END;

    BEGIN
    END.
  }
}

