OBJECT page 172057 Mbanking Application Card
{
  OBJECT-PROPERTIES
  {
    Date=01/21/21;
    Time=[ 9:58:32 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516703;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnModifyRecord=BEGIN
                     IF USERID <> "Entered By" THEN
                       ERROR('You cannot modify document initiated by %1',"Entered By");
                   END;

    OnAfterGetCurrRecord=BEGIN
                            SetControlAppearance();
                            UpdateControl();
                            "Document Date":=TODAY;
                         END;

    ActionList=ACTIONS
    {
      { 1000000004;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000003;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1000000005;2 ;Action    ;
                      Name=Create MBanking Account;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Status = Status::Created THEN
                                     ERROR('Already created');
                                 ValidateMember;
                                 IF Status<>Status::Approved THEN
                                 ERROR('This application has not yet been approved');


                                 IF CONFIRM('Are you sure you would like to Create the application?') = TRUE THEN BEGIN
                                 //FOSA


                                 IF (STRLEN("MPESA Mobile No")<> 13) OR (COPYSTR("MPESA Mobile No",1,4)<>'+254') THEN
                                   ERROR('Invalid MPESA Mobile No.');

                                 Account.RESET;
                                 Account.SETRANGE("Transactional Mobile No","MPESA Mobile No");
                                 IF Account.FIND('-') THEN BEGIN
                                     ERROR('Transactional Phone No. %1 already exists under Account No. %2',"MPESA Mobile No",Account."No.");
                                 END;


                                 MPESAAppDetails.RESET;
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                 MPESAAppDetails.SETRANGE(MPESAAppDetails."Account Type",MPESAAppDetails."Account Type"::Creditor);
                                 IF MPESAAppDetails.FIND('-') THEN BEGIN
                                 REPEAT
                                         Account.RESET;
                                         Account.SETRANGE(Account."No.",MPESAAppDetails."Account No.");
                                         IF Account.FIND('-') THEN BEGIN


                                             IF SkyMbanking.CheckBlackList("MPESA Mobile No",Account."No.",Account.Name) THEN
                                                 ERROR('This Member has been blacklisted');


                                              IF "Application Type"= "Application Type"::Initial THEN BEGIN //Application Type Initial

                                                  IF Account."Transactional Mobile No"<>"MPESA Mobile No" THEN BEGIN

                                                       IF Account."Transactional Mobile No"<>'' THEN BEGIN
                                                         ERROR('The FOSA Account No. ' + Account."No." + ' has already been registered for M-Banking.');
                                                         EXIT;
                                                       END ELSE BEGIN
                                                          Account."Transactional Mobile No":="MPESA Mobile No";
                                                          Account.MODIFY;

                                                           IF NOT Auth.GET(Account."Transactional Mobile No") THEN BEGIN
                                                               Auth.INIT;
                                                               Auth."Mobile No." := Account."Transactional Mobile No";
                                                               Auth."Account No." := Account."No.";
                                                               Auth."User Status" := Auth."User Status"::" ";
                                                               Auth.INSERT;
                                                           END;

                                                           Auth.RESET;
                                                           Auth.SETRANGE("Account No.",Account."No.");
                                                           IF Auth.FINDFIRST THEN BEGIN
                                                               Auth.DELETEALL;
                                                           END;

                                                           Auth.RESET;
                                                           Auth.SETRANGE("Account No.",Account."No.");
                                                           Auth.SETRANGE("Mobile No.",Account."Transactional Mobile No");
                                                           IF Auth.FINDFIRST THEN BEGIN
                                                               SkyMbanking.GenerateNewPin(COPYSTR(Account."Transactional Mobile No",2,12));
                                                           END
                                                           ELSE BEGIN
                                                               Auth.INIT;
                                                               Auth."Mobile No." := Account."Transactional Mobile No";
                                                               Auth."Account No." := Account."No.";
                                                               Auth."User Status" := Auth."User Status"::Active;
                                                               Auth.INSERT;
                                                               SkyMbanking.GenerateNewPin(COPYSTR(Account."Transactional Mobile No",2,12));
                                                           END;


                                                          MESSAGE('M-Banking activated for Customer ' + Account.Name + '. The Customer will receive a confirmation SMS shortly.');
                                                          Status := Status::Created;
                                                          MODIFY;


                                                       END;
                                                   END ELSE BEGIN

                                                      ERROR('This telephone no already exists in the account');

                                                   END;

                                               END ELSE BEGIN // Application Type is change

                                                  Account."Transactional Mobile No":="MPESA Mobile No";
                                                  Account.MODIFY;



                                                           IF NOT Auth.GET(Account."Transactional Mobile No") THEN BEGIN
                                                               Auth.INIT;
                                                               Auth."Mobile No." := Account."Transactional Mobile No";
                                                               Auth."Account No." := Account."No.";
                                                               Auth."User Status" := Auth."User Status"::Active;
                                                               Auth.INSERT;
                                                           END;

                                                           Auth.RESET;
                                                           Auth.SETRANGE("Account No.",Account."No.");
                                                           IF Auth.FINDFIRST THEN BEGIN
                                                               Auth.DELETEALL;
                                                           END;

                                                           Auth.RESET;
                                                           Auth.SETRANGE("Account No.",Account."No.");
                                                           Auth.SETRANGE("Mobile No.",Account."Transactional Mobile No");
                                                           IF Auth.FINDFIRST THEN BEGIN
                                                               SkyMbanking.GenerateNewPin(COPYSTR(Account."Transactional Mobile No",2,12));
                                                           END
                                                           ELSE BEGIN
                                                               Auth.INIT;
                                                               Auth."Mobile No." := Account."Transactional Mobile No";
                                                               Auth."Account No." := Account."No.";
                                                               Auth."User Status" := Auth."User Status"::Active;
                                                               Auth.INSERT;
                                                               SkyMbanking.GenerateNewPin(COPYSTR(Account."Transactional Mobile No",2,12));
                                                           END;


                                                           MESSAGE('M-Banking transactional Mobile No changed for Customer ' + Account.Name + '.');
                                                           Status := Status::Created;
                                                          MODIFY;

                                              END;

                                         END;
                                 UNTIL MPESAAppDetails.NEXT=0;
                                 END;

                                 {"App Status":="App Status"::Approved;
                                 "Date Approved":=TODAY;
                                 "Time Approved":=TIME;
                                 "Approved By":=USERID;
                                 MODIFY;}

                                 //MESSAGE('M-Banking activated for Customer ' + "Customer Name" + '. The Customer will receive a confirmation SMS shortly.');

                                 END;
                               END;
                                }
      { 9       ;1   ;ActionGroup;
                      CaptionML=ENU=Approval }
      { 8       ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=ENU=Approve;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 RestrictAccess(USERID);

                                 IF (STRLEN("MPESA Mobile No")<> 13) OR (COPYSTR("MPESA Mobile No",1,4)<>'+254') THEN
                                   ERROR('Invalid MPESA Mobile No.');

                                 Account.RESET;
                                 Account.SETRANGE("Transactional Mobile No","MPESA Mobile No");
                                 IF Account.FIND('-') THEN BEGIN
                                     ERROR('Transactional Phone No. %1 already exists under Account No. %2',"MPESA Mobile No",Account."No.");
                                 END;

                                 Status := Status::Approved;
                                 MODIFY;
                                 MESSAGE('Approved');

                                 //ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=ENU=Reject;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 RestrictAccess(USERID);


                                 Status := Status::Rejected;
                                 MODIFY;
                                 MESSAGE('Rejected');
                                 //ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 6       ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=ENU=Delegate;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=ENU=Comments;
                      RunObject=Page 660;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category4 }
      { 4       ;1   ;ActionGroup;
                      CaptionML=ENU=Request Approval }
      { 3       ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 ValidateMember;

                                 IF (STRLEN("MPESA Mobile No")<> 13) OR (COPYSTR("MPESA Mobile No",1,4)<>'+254') THEN
                                   ERROR('Invalid MPESA Mobile No.');

                                 Account.RESET;
                                 Account.SETRANGE("Transactional Mobile No","MPESA Mobile No");
                                 IF Account.FIND('-') THEN BEGIN
                                     ERROR('Transactional Phone No. %1 already exists under Account No. %2',"MPESA Mobile No",Account."No.");
                                 END;


                                  IF Status<>Status::Open THEN
                                       ERROR(DocMustbeOpen);


                                 //TESTFIELD("Document Serial No");
                                 TESTFIELD("Document Date");
                                 TESTFIELD("Customer ID No");
                                 TESTFIELD("Customer Name");
                                 //TESTFIELD("Responsibility Center");

                                 IF "Application Type"="Application Type"::Initial THEN BEGIN

                                     TESTFIELD("MPESA Mobile No");
                                 //    TESTFIELD("Withdrawal Limit Code");
                                   //  TESTFIELD("Withdrawal Limit Amount");


                                     StrTel:=COPYSTR("MPESA Mobile No",1,4);

                                     IF StrTel<>'+254' THEN BEGIN
                                     ERROR('The MPESA Mobile Phone No. should be in the format +254XXXYYYZZZ.');
                                     END;

                                     IF STRLEN("MPESA Mobile No")<>13 THEN BEGIN
                                     ERROR('Invalid MPESA mobile phone number. Please enter the correct mobile phone number.');
                                     END;

                                     MPESAAppDetails.RESET;
                                     MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                     IF MPESAAppDetails.FIND('-') THEN BEGIN
                                       //Check if Id number exists in this account
                                         Account.RESET;
                                         Account.SETRANGE(Account."ID No.","Customer ID No");
                                         Account.SETRANGE(Account."No.",MPESAAppDetails."Account No.");
                                         IF Account.FIND('-') THEN BEGIN

                                           //Check if Id number exists in this account
                                           //Check if mpesa telephone number exist in this account

                                               Account.RESET;
                                               Account.SETRANGE(Account."Transactional Mobile No","MPESA Mobile No");
                                               Account.SETRANGE(Account."No.",MPESAAppDetails."Account No.");
                                               IF Account.FIND('-') THEN BEGIN
                                                 ERROR('Phone No '+"MPESA Mobile No"+ ' already linked to account no '+MPESAAppDetails."Account No.");
                                               END
                                               ELSE
                                               BEGIN


                                                 {
                                                 VarVariant := Rec;
                                                 IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant)
                                                   THEN
                                                   CustomApprovals.OnSendDocForApproval(VarVariant);
                                                   }
                                                 END;


                                         END
                                         ELSE
                                         BEGIN

                                             ERROR('Id number '+"Customer ID No"+ ' does not exist to account no '+MPESAAppDetails."Account No.");

                                         END;

                                     END ELSE BEGIN

                                        ERROR('Please select the account to link with the telepnone No.');
                                     END;

                                 END
                                 ELSE
                                 BEGIN //Transaction Type Change
                                 {
                                     VarVariant := Rec;
                                     IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant)
                                       THEN
                                         CustomApprovals.OnSendDocForApproval(VarVariant);
                                         }



                                  END;

                                 Status := Status::Pending;
                                 MODIFY;

                                 MESSAGE('Sent For Approval');
                               END;
                                }
      { 2       ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Promoted=Yes;
                      Enabled=OpenApprovalEntriesExist;
                      Image=Cancel;
                      PromotedCategory=Category9;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN

                                   IF Status<>Status::Approved THEN
                                       ERROR(DocMustbePending);

                                 VarVariant := Rec;
                                 //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                                 Status := Status::Open;
                                 MODIFY;
                               END;
                                }
      { 1       ;2   ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalEntries@1001 : Page 658;
                                 approvalsMgmt@1000 : Codeunit 1535;
                               BEGIN

                                 approvalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 1120054002;2 ;Action    ;
                      Name=Re-Open Document;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to Re-Open this document') THEN BEGIN
                                     Status := Status::Open;
                                     MODIFY;
                                     MESSAGE('Updated');
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

    { 1102755012;2;Field  ;
                SourceExpr="Document Date";
                Enabled=false;
                Editable=DocDate }

    { 10  ;2   ;Field     ;
                SourceExpr="Account No" }

    { 1102755011;2;Field  ;
                SourceExpr="Customer ID No";
                Editable=FALSE }

    { 1102755010;2;Field  ;
                SourceExpr="Customer Name";
                Editable=FALSE }

    { 1102755009;2;Field  ;
                SourceExpr="MPESA Mobile No";
                Editable=TRUE;
                OnValidate=BEGIN
                             IF SkyMbanking.CheckBlackList("MPESA Mobile No",'','') THEN
                                 ERROR('This Member has been blacklisted');
                           END;
                            }

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
                Editable=False }

    { 1102755018;1;Part   ;
                SubPageLink=Application No=FIELD(No);
                PagePartID=Page51516713;
                PartType=Page }

    { 1120054000;0;Container;
                ContainerType=FactBoxArea }

    { 1120054001;1;Part   ;
                SubPageLink=No.=FIELD(Member No.);
                PagePartID=Page51516735;
                PartType=Page }

  }
  CODE
  {
    VAR
      StrTel@1102755002 : Text[30];
      DocMustbeOpen@1000000000 : TextConst 'ENU=This application must be open';
      ApprovalEntries@1000000002 : Page 658;
      DocumentType@1000000001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTransport Request,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft,ImprestSurrender,MSacco Applications';
      Account@1000000026 : Record 23;
      Cust@1000000025 : Record 51516223;
      MPESAAppDetails@1000000024 : Record 51516715;
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
      GenLedgerSetup@1000000012 : Record 98;
      MPesaAccount@1000000011 : Code[50];
      MPesaCharges@1000000010 : Decimal;
      MPesaChargesAccount@1000000009 : Code[50];
      MPesaLiabilityAccount@1000000008 : Code[50];
      TotalCharges@1000000007 : Decimal;
      TariffCharges@1000000003 : Decimal;
      DocSNo@1000000027 : Boolean;
      DocDate@1000000028 : Boolean;
      CustID@1000000029 : Boolean;
      CustName@1000000030 : Boolean;
      MpesaNo@1000000031 : Boolean;
      Comms@1000000032 : Boolean;
      WithLimit@1000000033 : Boolean;
      MpesaPagePart@1000000034 : Boolean;
      DocMustbePending@1000000036 : TextConst 'ENU=Application must be pending approval';
      OpenApprovalEntriesExistForCurrUser@1003 : Boolean;
      OpenApprovalEntriesExist@1002 : Boolean;
      VarVariant@1001 : Variant;
      Auth@1004 : Record 51516709;
      SkyMbanking@1005 : Codeunit 51516701;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
    BEGIN

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    END;

    PROCEDURE UpdateControl@1102755000();
    BEGIN


      IF Status=Status::Open THEN BEGIN

        DocSNo := TRUE;
        DocDate := TRUE;
        CustID := TRUE;
        CustName :=TRUE;
        MpesaNo := TRUE;
        Comms := TRUE;
        WithLimit:=TRUE;

      END;


      IF Status=Status::Pending THEN
         BEGIN

           DocSNo := FALSE;
           DocDate := FALSE;
           CustID := FALSE;
           CustName := FALSE;
           MpesaNo := FALSE;
           Comms := TRUE;
           WithLimit := FALSE;
      END;


      IF Status=Status::Rejected THEN BEGIN
           DocSNo := FALSE;
           DocDate := FALSE;
           CustID := FALSE;
           CustName := FALSE;
           MpesaNo := FALSE;
           Comms := TRUE;
           WithLimit := FALSE;
      END;

      IF Status=Status::Approved THEN BEGIN
           DocSNo := FALSE;
           DocDate := FALSE;
           CustID := FALSE;
           CustName := FALSE;
           MpesaNo := FALSE;
           Comms := TRUE;
           WithLimit := FALSE;

      END;
    END;

    PROCEDURE RestrictAccess@2(UserNo@1000 : Code[100]);
    VAR
      SaccoPermissions@1001 : Record 51516702;
      ErrorOnRestrictViewTxt@1002 : TextConst 'ENU=You do not have permissions to EDIT this Page. Contact your system administrator for further details';
    BEGIN
      SaccoPermissions.RESET;
      SaccoPermissions.SETRANGE("User ID",UserNo);
      SaccoPermissions.SETRANGE("Sky Mobile Setups",TRUE);
      IF NOT SaccoPermissions.FIND('-') THEN BEGIN
          ERROR('You do not have Setup Permissions');
      END;
    END;

    BEGIN
    END.
  }
}

