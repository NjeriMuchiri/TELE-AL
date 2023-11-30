OBJECT page 17492 Mpesa Applications Approval
{
  OBJECT-PROPERTIES
  {
    Date=04/05/16;
    Time=[ 1:26:30 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516330;
    SourceTableView=WHERE(Status=CONST(Pending));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755022;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755023;1 ;ActionGroup;
                      CaptionML=ENU=Mpesa Applications }
      { 1102755024;2 ;Action    ;
                      Name=Approve;
                      Promoted=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you would like to approve the application?') = TRUE THEN BEGIN

                                   //FOSA
                                   {
                                   MPESAAppDetails.RESET;
                                   MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                   MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Vendor);
                                   IF MPESAAppDetails.FIND('-') THEN BEGIN
                                     REPEAT
                                       Vend.RESET;
                                       Vend.SETRANGE(Vend."No.",MPESAAppDetails."Account No.");
                                       IF Vend.FIND('-') THEN BEGIN
                                         IF "Application Type"<>"Application Type"::Initial THEN BEGIN
                                           IF Vend."MPESA Mobile No"<>'' THEN BEGIN
                                            // ERROR('The FOSA Account No. ' + Vend."No." + ' has already been registered for M-SACCO.');
                                             EXIT;
                                           END;
                                         END;
                                         Vend."MPESA Mobile No":='';
                                         Vend.MODIFY;
                                       END;
                                     UNTIL MPESAAppDetails.NEXT=0;
                                   END;
                                 }


                                 MPESAAppDetails.RESET;
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Vendor);
                                 IF MPESAAppDetails.FIND('-') THEN BEGIN
                                 REPEAT
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.",MPESAAppDetails."Account No.");
                                 IF Vend.FIND('-') THEN BEGIN
                                     {
                                      IF Vend."MPESA Mobile No"<>'' THEN BEGIN
                                        ERROR('The FOSA Account No. ' + Vend."No." + ' has already been registered for M-SACCO.');
                                        EXIT;
                                     END;
                                     }
                                 Vend."MPESA Mobile No":="MPESA Mobile No";
                                 Vend.MODIFY;
                                 END;
                                 UNTIL MPESAAppDetails.NEXT=0;
                                 END;




                                 //BOSA
                                 {
                                 MPESAAppDetails.RESET;
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Customer);
                                 IF MPESAAppDetails.FIND('-') THEN BEGIN
                                   REPEAT
                                     Cust.RESET;
                                     Cust.SETRANGE(Cust."No.",MPESAAppDetails."Account No.");
                                     IF Cust.FIND('-') THEN BEGIN
                                       IF "Application Type"="Application Type"::Initial THEN BEGIN
                                         IF Cust."MPESA Mobile No"<>'' THEN BEGIN
                                           ERROR('The BOSA Account No. ' + Cust."No." + ' has already been registered for M-SACCO.');
                                           EXIT;
                                         END;
                                       END;
                                       Cust."MPESA Mobile No":="MPESA Mobile No";
                                       Cust.MODIFY;
                                     END;
                                   UNTIL MPESAAppDetails.NEXT=0;
                                 END;
                                 }

                                 MPesaCharges:=0;
                                 MPesaChargesAccount:='';

                                 //CHARGES
                                 GenLedgerSetup.RESET;
                                 GenLedgerSetup.GET;
                                 GenLedgerSetup.TESTFIELD(GenLedgerSetup."M-SACCO Registration Charge");
                                 Charges.RESET;
                                 Charges.SETRANGE(Charges.Code,GenLedgerSetup."M-SACCO Registration Charge");
                                 IF Charges.FIND('-') THEN BEGIN
                                 //Charges.TESTFIELD(Charges."Charge Amount");
                                 Charges.TESTFIELD(Charges."GL Account");
                                 MPesaCharges:=Charges."Charge Amount";
                                 MPesaChargesAccount:=Charges."GL Account";
                                 END;


                                 MPESAAppDetails.RESET;
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Vendor);
                                 IF MPESAAppDetails.FIND('-') THEN BEGIN
                                 //DELETE
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'MPESA');
                                 GenJournalLine.DELETEALL;
                                 //end of deletion

                                 GenBatches.RESET;
                                 GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                                 GenBatches.SETRANGE(GenBatches.Name,'MPESA');
                                 IF GenBatches.FIND('-') = FALSE THEN BEGIN
                                 GenBatches.INIT;
                                 GenBatches."Journal Template Name":='GENERAL';
                                 GenBatches.Name:='MPESA';
                                 GenBatches.Description:='M-SACCO Registration';
                                 GenBatches.VALIDATE(GenBatches."Journal Template Name");
                                 GenBatches.VALIDATE(GenBatches.Name);
                                 GenBatches.INSERT;
                                 END;


                                 REPEAT
                                 Acct.RESET;
                                 Acct.SETRANGE(Acct."No.",MPESAAppDetails."Account No.");
                                 IF Acct.FIND('-') THEN BEGIN

                                 //POST CHARGES

                                        //DR Member - total Charges
                                     LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='MPESA';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                     GenJournalLine."Account No.":=MPESAAppDetails."Account No.";
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":=No;
                                     GenJournalLine."Posting Date":="Date Entered";
                                     GenJournalLine.Description:='M-SACCO Registration Charges';
                                     GenJournalLine.Amount:=MPesaCharges;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
                                     GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");

                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;

                                 //CR Revenue

                                 LineNo:=LineNo+10000;

                                     GenJournalLine.INIT;
                                     GenJournalLine."Journal Template Name":='GENERAL';
                                     GenJournalLine."Journal Batch Name":='MPESA';
                                     GenJournalLine."Line No.":=LineNo;
                                     GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                     GenJournalLine."Account No.":=MPesaChargesAccount;
                                     GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                     GenJournalLine."Document No.":=No;
                                     GenJournalLine."Posting Date":="Date Entered";
                                     GenJournalLine.Description:='M-SACCO Registration Charges';
                                     GenJournalLine.Amount:=MPesaCharges*-1;
                                     GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                     GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
                                     GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                     GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                     IF GenJournalLine.Amount<>0 THEN
                                     GenJournalLine.INSERT;
                                 END;
                                 UNTIL MPESAAppDetails.NEXT=0;
                                 END;


                                 //Post
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'MPESA');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 REPEAT
                                 GLPosting.RUN(GenJournalLine);
                                 UNTIL GenJournalLine.NEXT = 0;
                                 END;


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'MPESA');
                                 GenJournalLine.DELETEALL;
                                 //Post


                                 Status:=Status::Approved;//Status:=Status::"1st Approval";
                                 "Date Approved":=TODAY;
                                 "Time Approved":=TIME;
                                 "Approved By":=USERID;
                                 MODIFY;

                                 MESSAGE('M-SACCO activated for Customer ' + "Customer Name" + '. The Customer will receive a confirmation SMS shortly.');

                                 END;
                               END;
                                }
      { 1102755025;2 ;Action    ;
                      Name=Reject;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you would like to reject the application?') = TRUE THEN BEGIN
                                 TESTFIELD("Rejection Reason");
                                 Status:=Status::Rejected;
                                 "Date Rejected":=TODAY;
                                 "Time Rejected":=TIME;
                                 "Rejected By":=USERID;
                                 MODIFY;
                                 MESSAGE('Application for ' + "Customer Name" +' has been rejected. The Customer will be notified via SMS of the rejection reason.'
                                 );
                                 END;
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
                SourceExpr="Document Serial No";
                Editable=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Customer ID No";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Customer Name";
                Editable=FALSE }

    { 1   ;2   ;Field     ;
                SourceExpr="Old Telephone No";
                Editable=FALSE }

    { 1102755007;2;Field  ;
                SourceExpr="MPESA Mobile No";
                Editable=FALSE }

    { 1102755008;2;Field  ;
                SourceExpr=Comments;
                Editable=FALSE }

    { 1102755009;2;Field  ;
                SourceExpr="Rejection Reason" }

    { 1102755010;2;Field  ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 1102755011;2;Field  ;
                SourceExpr="Time Entered";
                Editable=FALSE }

    { 1102755012;2;Field  ;
                SourceExpr="Entered By";
                Editable=FALSE }

    { 1102755013;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102755014;2;Field  ;
                SourceExpr="Sent To Server";
                Editable=FALSE }

    { 1102755015;2;Field  ;
                SourceExpr="Date Approved";
                Editable=FALSE }

    { 1102755016;2;Field  ;
                SourceExpr="Time Approved";
                Editable=FALSE }

    { 1102755017;2;Field  ;
                SourceExpr="Approved By";
                Editable=FALSE }

    { 1102755018;2;Field  ;
                SourceExpr="Date Rejected";
                Editable=FALSE }

    { 1102755019;2;Field  ;
                SourceExpr="Time Rejected";
                Editable=FALSE }

    { 1102755020;2;Field  ;
                SourceExpr="Rejected By";
                Editable=FALSE }

    { 1102755021;2;Field  ;
                SourceExpr="Withdrawal Limit Amount";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      Vend@1102755023 : Record 23;
      Cust@1102755022 : Record 18;
      MPESAAppDetails@1102755021 : Record 51516332;
      GenJournalLine@1102755020 : Record 81;
      LineNo@1102755019 : Integer;
      Acct@1102755018 : Record 23;
      ATMCharges@1102755017 : Decimal;
      BankCharges@1102755016 : Decimal;
      GenBatches@1102755015 : Record 232;
      GLPosting@1102755014 : Codeunit 12;
      BankCode@1102755013 : Code[20];
      PDate@1102755012 : Date;
      RevFromDate@1102755011 : Date;
      MPESATRANS@1102755010 : Record 51516334;
      GenLedgerSetup@1102755009 : Record 98;
      MPesaAccount@1102755008 : Code[50];
      MPesaCharges@1102755007 : Decimal;
      MPesaChargesAccount@1102755006 : Code[50];
      MPesaLiabilityAccount@1102755005 : Code[50];
      TotalCharges@1102755004 : Decimal;
      TariffHeader@1102755003 : Record 51516272;
      TariffDetails@1102755002 : Record 51516273;
      Charges@1102755001 : Record 51516297;
      TariffCharges@1102755000 : Decimal;

    BEGIN
    END.
  }
}

