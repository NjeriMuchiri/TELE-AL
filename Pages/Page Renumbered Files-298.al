OBJECT page 17489 Mpesa Applications
{
  OBJECT-PROPERTIES
  {
    Date=04/14/16;
    Time=10:25:14 AM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516330;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnAfterGetCurrRecord=BEGIN
                             UpdateControl();
                         END;

    ActionList=ACTIONS
    {
      { 1000000004;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000003;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1000000002;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"MSacco Applications";
                                 ApprovalEntries.Setfilters(DATABASE::"MPESA Applications",DocumentType,No);
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1000000001;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                 IF Status<>Status::Open THEN
                                 //Created,Open,Canceled,Rejected,Approved
                                 ERROR(text001);

                                 TESTFIELD("Document Serial No");
                                 TESTFIELD("Document Date");
                                 TESTFIELD("Customer ID No");
                                 TESTFIELD("Customer Name");
                                 //TESTFIELD("MPESA Mobile No");

                                 IF "Application Type"<> "Application Type"::Change THEN BEGIN
                                 TESTFIELD("MPESA Mobile No");
                                 END;

                                 TESTFIELD("Withdrawal Limit Code");
                                 TESTFIELD("Withdrawal Limit Amount");
                                 //TESTFIELD("Responsibility Center");

                                 StrTel:=COPYSTR("MPESA Mobile No",1,4);

                                 IF "Application Type"<> "Application Type"::Change THEN BEGIN

                                 IF StrTel<>'+254' THEN BEGIN
                                 ERROR('The MPESA Mobile Phone No. should be in the format +254XXXYYYZZZ.');
                                 END;


                                 IF STRLEN("MPESA Mobile No")<>13 THEN BEGIN
                                 ERROR('Invalid MPESA mobile phone number. Please enter the correct mobile phone number.');
                                 END;

                                 MPESAAppDetails.RESET;
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                 IF MPESAAppDetails.FIND('-') THEN BEGIN
                                 //Exists
                                 END
                                 ELSE BEGIN
                                 ERROR('The MPESA application must have atleast one FOSA or BOSA Account.');
                                 END;

                                 END;
                                 Status:=Status::Approved;
                                 MODIFY;
                                 MESSAGE('Application Approved Succesfuly');
                                 //End allocate batch number
                                 //IF ApprovalMgt.SendMsaccoAppApprovalRequest(Rec) THEN;
                               END;
                                }
      { 1000000000;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel A&pproval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                   IF Status<>Status::Pending THEN
                                       ERROR(text002);

                                   //End allocate batch number
                                   //IF ApprovalMgt.CancelMsaccoAppApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1000000005;2 ;Action    ;
                      Name=Create S-SACCO Application;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Status<>Status::Approved THEN
                                 ERROR('This application has not yet been approved');


                                 IF CONFIRM('Are you sure you would like to Create the application?') = TRUE THEN BEGIN
                                 //FOSA
                                 MPESAAppDetails.RESET;
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Vendor);
                                 IF MPESAAppDetails.FIND('-') THEN BEGIN
                                 REPEAT
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.",MPESAAppDetails."Account No.");
                                 IF Vend.FIND('-') THEN BEGIN
                                 IF "Application Type"<> "Application Type"::Initial THEN BEGIN
                                 IF Vend."MPESA Mobile No"<>'' THEN BEGIN
                                 ERROR('The FOSA Account No. ' + Vend."No." + ' has already been registered for M-SACCO.');
                                 EXIT;
                                 END;
                                 END;
                                 Vend."MPESA Mobile No":="MPESA Mobile No";
                                 Vend.MODIFY;
                                 END;
                                 UNTIL MPESAAppDetails.NEXT=0;
                                 END;

                                 //BOSA

                                 MPESAAppDetails.RESET;
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Customer);
                                 IF MPESAAppDetails.FIND('-') THEN BEGIN
                                 REPEAT
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.",MPESAAppDetails."Account No.");
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF "Application Type"<> "Application Type"::Initial THEN BEGIN
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


                                 "App Status":="App Status"::Approved;
                                 "Date Approved":=TODAY;
                                 "Time Approved":=TIME;
                                 "Approved By":=USERID;
                                 MODIFY;

                                 MESSAGE('M-SACCO activated for Customer ' + "Customer Name" + '. The Customer will receive a confirmation SMS shortly.');

                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755015;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755014;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1000000007;2;Field  ;
                SourceExpr="Application Type" }

    { 1000000008;2;Field  ;
                SourceExpr="Application No" }

    { 1102755013;2;Field  ;
                SourceExpr="Document Serial No";
                Editable=DocSNo }

    { 1102755012;2;Field  ;
                SourceExpr="Document Date";
                Editable=DocDate }

    { 1102755011;2;Field  ;
                SourceExpr="Customer ID No";
                Editable=CustID }

    { 1102755010;2;Field  ;
                SourceExpr="Customer Name";
                Editable=CustName;
                OnValidate=BEGIN

                                    MPESAApplications.RESET;
                                    MPESAApplications.SETRANGE(MPESAApplications."Customer ID No","Customer ID No");
                                    MPESAApplications.SETRANGE(MPESAApplications.Status,MPESAApplications.Status::Approved);
                                    IF MPESAApplications.FINDFIRST THEN BEGIN
                                    ERROR('ID Number is used');
                                    END;
                           END;
                            }

    { 1102755009;2;Field  ;
                SourceExpr="MPESA Mobile No";
                Editable=MpesaNo }

    { 1000000009;2;Field  ;
                SourceExpr="Old Telephone No" }

    { 1102755008;2;Field  ;
                SourceExpr=Comments;
                Editable=Comms }

    { 1102755007;2;Field  ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Time Entered";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Entered By";
                Editable=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102755003;2;Field  ;
                SourceExpr="Withdrawal Limit Code";
                Editable=WithLimit }

    { 1102755002;2;Field  ;
                SourceExpr="Withdrawal Limit Amount";
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr="Responsibility Center" }

    { 1102755018;1;Part   ;
                SubPageLink=Application No=FIELD(No);
                PagePartID=Page51516352;
                Editable=MpesaPagePart;
                PartType=Page }

  }
  CODE
  {
    VAR
      StrTel@1102755002 : Text[30];
      text001@1000000000 : TextConst 'ENU=This application must be open';
      ApprovalEntries@1000000002 : Page 658;
      DocumentType@1000000001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTransport Request,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft,ImprestSurrender,MSacco Applications';
      Vend@1000000026 : Record 23;
      Cust@1000000025 : Record 51516223;
      MPESAAppDetails@1000000024 : Record 51516332;
      GenJournalLine@1000000023 : Record 81;
      LineNo@1000000022 : Integer;
      Acct@1000000021 : Record 23;
      ATMCharges@1000000020 : Decimal;
      BankCharges@1000000019 : Decimal;
      GenBatches@1000000018 : Record 232;
      GLPosting@1000000017 : Codeunit 12;
      BankCode@1000000016 : Code[20];
      PDate@1000000015 : Date;
      RevFromDate@1000000014 : Date;
      MPESATRANS@1000000013 : Record 51516334;
      GenLedgerSetup@1000000012 : Record 98;
      MPesaAccount@1000000011 : Code[50];
      MPesaCharges@1000000010 : Decimal;
      MPesaChargesAccount@1000000009 : Code[50];
      MPesaLiabilityAccount@1000000008 : Code[50];
      TotalCharges@1000000007 : Decimal;
      TariffHeader@1000000006 : Record 51516272;
      TariffDetails@1000000005 : Record 51516273;
      Charges@1000000004 : Record 51516297;
      TariffCharges@1000000003 : Decimal;
      DocSNo@1000000027 : Boolean;
      DocDate@1000000028 : Boolean;
      CustID@1000000029 : Boolean;
      CustName@1000000030 : Boolean;
      MpesaNo@1000000031 : Boolean;
      Comms@1000000032 : Boolean;
      WithLimit@1000000033 : Boolean;
      MpesaPagePart@1000000034 : Boolean;
      text002@1000000036 : TextConst 'ENU=Application must be pending approval';
      MPESAApplications@1000000035 : Record 51516330;

    PROCEDURE UpdateControl@1000000000();
    BEGIN

      IF Status=Status::Open THEN BEGIN
      DocSNo:=TRUE;
      DocDate:=TRUE;
      CustID:=TRUE;
      CustName:=TRUE;
      MpesaNo:=TRUE;
      Comms:=TRUE;
      WithLimit:=TRUE;
      MpesaPagePart:=TRUE;
      END;

      IF Status=Status::Pending THEN BEGIN
      DocSNo:=FALSE;
      DocDate:=FALSE;
      CustID:=FALSE;
      CustName:=FALSE;
      MpesaNo:=FALSE;
      Comms:=FALSE;
      WithLimit:=FALSE;
      MpesaPagePart:=FALSE;
      END;

      IF Status=Status::Rejected THEN BEGIN
      DocSNo:=FALSE;
      DocDate:=FALSE;
      CustID:=FALSE;
      CustName:=FALSE;
      MpesaNo:=FALSE;
      Comms:=FALSE;
      WithLimit:=FALSE;
      MpesaPagePart:=FALSE;
      END;

      IF Status=Status::Approved THEN BEGIN
      DocSNo:=FALSE;
      DocDate:=FALSE;
      CustID:=FALSE;
      CustName:=FALSE;
      MpesaNo:=FALSE;
      Comms:=FALSE;
      WithLimit:=FALSE;
      MpesaPagePart:=FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

