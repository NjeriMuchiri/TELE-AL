OBJECT page 50094 ATM Applications Card New
{
  OBJECT-PROPERTIES
  {
    Date=10/11/22;
    Time=12:09:01 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516321;
    PageType=Card;
    OnOpenPage=BEGIN
                 FnAddRecRestriction();
               END;

    OnAfterGetCurrRecord=BEGIN

                           IF Userss.GET(USERID) THEN BEGIN
                           IF Userss."Link/Delink Atm"=FALSE THEN
                           ERROR('You Dont Have Rights To Disable ATM.Kindly Contact System Administrator');
                           END;
                           FnAddRecRestriction();
                         END;

    ActionList=ACTIONS
    {
      { 1102755002;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755010;1 ;ActionGroup;
                      CaptionML=ENU=Pesa Point ATM Card }
      { 1102755008;2 ;Action    ;
                      Name=Link ATM Card;
                      CaptionML=ENU=Link ATM Card;
                      Promoted=Yes;
                      Visible=false;
                      Image=Link;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Userss.GET(USERID) THEN BEGIN
                                     IF Userss."Link/Delink Atm"=FALSE THEN
                                     ERROR('You Dont Have Rights To Link ATM.Kindly Contact System Administrator');
                                 END;

                                 TESTFIELD(Status,Rec.Status::Approved);
                                 TESTFIELD("ATM Card Fee Charged",TRUE);
                                 TESTFIELD("ATM Card Linked",FALSE);
                                 TESTFIELD("Card No");

                                 //Linking Details*******************************************************************************
                                 IF CONFIRM('Are you sure you want to link ATM CARD: ' +"Card No"+' to the A/C: '+"Account Name",FALSE)=TRUE THEN BEGIN
                                     IF ObjAccount.GET("Account No") THEN BEGIN
                                         ObjAccount."ATM No.":="Card No";
                                         ObjAccount.MODIFY;
                                     END;

                                     "ATM Card Linked":=TRUE;
                                     "ATM Card Linked By":=USERID;
                                     "ATM Card Linked On":=TODAY;
                                     MODIFY;

                                     msg:='Dear '+"Account Name"+', Your Telepost Sacco link Card has is ready for collection at the Sacco head office';
                                     CloudPESA.SMSMessage('ATMAPP',"Account No","Phone No.",msg);
                                     MESSAGE('ATM Card linked to Succesfuly to Account No %1',"Account No");
                                 //End Linking Details****************************************************************************

                                 //Collection Details***********************************
                                 //Collected:=TRUE;
                                 //"Date Collected":=TODAY;
                                     "Card Issued By":=USERID;
                                     "Card Status" := "Card Status"::Active;
                                     "ATM Card Linked":=TRUE;
                                     "ATM Card Linked By":=USERID;
                                     "ATM Card Linked On":=TODAY;
                                     MODIFY;
                                 //End Collection Details******************************

                                 //Create Audit Entry
                                     IF Trail.FINDLAST THEN
                                     AuditTrail.FnGetLastEntry();
                                     AuditTrail.FnGetComputerName();
                                     AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'ATM Linking',0,'ATM',TODAY,TIME,'',"Account No","No.","Card No");
                                 //End Create Audit Entry

                                     Vend.GET("Account No");
                                     Vend."ATM No.":="Card No";
                                     Vend."Atm card ready":=TRUE;
                                     Vend.MODIFY;

                                     GeneralSetup.GET();
                                     "ATM Expiry Date":=CALCDATE(GeneralSetup."ATM Expiry Duration",TODAY);
                                 END;
                               END;
                                }
      { 1102755012;2 ;Action    ;
                      Name=Disable ATM Card;
                      CaptionML=ENU=Disable ATM Card;
                      Promoted=Yes;
                      Visible=false;
                      Image=DisableAllBreakpoints;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Userss.GET(USERID) THEN BEGIN
                                 IF Userss."Link/Delink Atm"=FALSE THEN
                                 ERROR('You Dont Have Rights To Disable ATM.Kindly Contact System Administrator');
                                 END;
                                 IF Status<>Status::Approved THEN
                                 ERROR('This ATM Card application has not been approved');
                                 IF "Reason for Account blocking"='' THEN
                                 ERROR('Please Give reason For disabling ATM');

                                 IF "Card Status" <> "Card Status"::Active THEN
                                   ERROR('Card is not active');
                                 // IF "Reason for Account blocking":='' THEN
                                 //  ERROR('Give Reason for Blocking The Atm );
                                 Vend.GET("Account No");
                                 IF CONFIRM('Are you sure you want to disable this account from ATM transactions  ?',FALSE)=TRUE    THEN
                                 Vend."ATM No.":='';
                                 //Vend.Blocked:=Vend.Blocked::Payment;
                                 //Vend."Account Frozen":=TRUE;
                                 Vend.MODIFY;
                                 "Card Status":="Card Status"::Disabled;
                                 "Disable On":=TODAY;
                                 "Dasabled By":=USERID;
                                 MODIFY;

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'ATM Disabled',0,'ATM',TODAY,TIME,'',"Account No","No.","Card No");
                                 //End Create Audit Entry

                                 msg:='Dear '+"Account Name"+', Your Telepost Sacco link Card has been disabled';
                                 CloudPESA.SMSMessage('ATMAPP',"Account No","Phone No.",msg);
                                 MESSAGE ('This ATM Card has been disable');
                               END;
                                }
      { 1102755031;2 ;Action    ;
                      Name=Enable ATM Card;
                      Promoted=Yes;
                      Visible=false;
                      Image=EnableAllBreakpoints;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Status<>Status::Approved THEN
                                 ERROR('This ATM Card application has not been approved');

                                 IF "Card Status" <> "Card Status"::Disabled THEN
                                   ERROR('Card is not Disabled');
                                 IF Userss.GET(USERID) THEN BEGIN
                                 IF Userss."Link/Delink Atm"=FALSE THEN
                                 ERROR('You Dont Have Rights To Enable ATM.Kindly Contact System Administrator');
                                 END;

                                 IF "Reason for Account blocking"='' THEN
                                 ERROR('Please Give reason For Enabling ATM');
                                 Vend.GET("Account No");
                                 IF CONFIRM('Are you sure you want to Enable ATM no. for this account  ?',TRUE)=TRUE    THEN
                                 Vend."ATM No.":="Card No";
                                 //Vend.Blocked:=Vend.Blocked::Payment;
                                 //Vend."Account Frozen":=TRUE;
                                 Vend.MODIFY;

                                 "Card Status":="Card Status"::Active;
                                 "Enabled By":=USERID;
                                 "Enabled On":=TODAY;
                                 MODIFY;

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Enable ATM Card',0,'ATM',TODAY,TIME,'',"Account No","No.","Card No");
                                 //End Create Audit Entry

                                 msg:='Dear '+"Account Name"+', Your Telepost Sacco link Card has been Enabled';
                                 CloudPESA.SMSMessage('ATMAPP',"Account No","Phone No.",msg);
                                 MESSAGE ('This ATM Card has been enable');
                               END;
                                }
      { 1120054004;2 ;Action    ;
                      Name=Receive From Bank;
                      CaptionML=ENU=Received from bank;
                      Promoted=Yes;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 IF "Card No"<>"Confirm Card No" THEN
                                   ERROR('Card No.  Mismatch');
                                 //TESTFIELD("Card Received",FALSE);
                                 TESTFIELD("Card No");
                                 TESTFIELD("Confirm Card No");
                                 TESTFIELD(Status,Rec.Status::Approved);
                                 IF CONFIRM('Are you sure you have received this ATM card from Bank?',TRUE) = TRUE THEN  BEGIN
                                     "Received By":=USERID;
                                     "Received On":=TODAY;
                                     "Card Received":=TRUE;
                                     MODIFY;
                                 END;
                                 Vend.GET("Account No");
                                 Vend."ATM No.":='';
                                 Vend."Atm card ready":=TRUE;
                                 Vend.MODIFY;
                               END;
                                }
      { 1120054003;2 ;Action    ;
                      Name=Confirm Card Collection;
                      Promoted=Yes;
                      Visible=false;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF Userss.GET(USERID) THEN BEGIN
                                     IF Userss."Link/Delink Atm"=FALSE THEN
                                     ERROR('You Dont Have Rights To Disable ATM.Kindly Contact System Administrator');
                                 END;

                                 IF  "ATM Card Linked"=TRUE THEN BEGIN
                                     IF ModeOfCollection=ModeOfCollection::"Card Sent" THEN BEGIN
                                     TESTFIELD("Issued to");

                                     END;
                                     IF CONFIRM('Are you sure you want to issue this Card?',TRUE)=TRUE THEN
                                     Collected:=TRUE;
                                     "Date Collected":=TODAY;
                                     MODIFY;
                                 END ELSE
                                 ERROR('ATM has no been linked');

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Card Collection Confirmed.',0,'ATM',TODAY,TIME,'',"Account No","No.","Card No");
                                 //End Create Audit Entry
                               END;
                                }
      { 1       ;2   ;Action    ;
                      Name=Charge ATM Card Fee;
                      Promoted=Yes;
                      Visible=false;
                      Image=PostDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Userss.GET(USERID) THEN BEGIN
                                 IF Userss."Link/Delink Atm"=FALSE THEN
                                 ERROR('You Dont Have Rights To Disable ATM.Kindly Contact System Administrator');
                                 END;
                                 IF Status<>Status::Approved THEN
                                 ERROR('This ATM Card application has not been approved');

                                 IF "ATM Card Fee Charged"=TRUE THEN
                                 ERROR('The ATM Card has already been charged');

                                 IF CONFIRM('Are you sure you want to charge this ATM Card Application?',TRUE) = TRUE THEN  BEGIN

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
                                 GenJournalLine.DELETEALL;

                                 //Customer Deduction***************************************************
                                 GeneralSetup.GET;

                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":='ATMFEE' ;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":="Account No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 IF "Request Type"="Request Type"::Replacement THEN
                                 GenJournalLine.Description:='ATM Card Fee-Replacement_'+FORMAT("Account No")
                                 ELSE
                                 IF "Request Type"="Request Type"::New THEN
                                 GenJournalLine.Description:='ATM Card Fee-New_'+FORMAT("Account No")
                                 ELSE
                                 IF "Request Type"="Request Type"::Renewal THEN
                                 GenJournalLine.Description:='ATM Card Fee-Renewal_'+FORMAT("Account No");

                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF "Request Type"="Request Type"::Replacement THEN
                                 GenJournalLine.Amount:=(GeneralSetup."ATM Card Fee-Replacement")+GeneralSetup."ATM Card Fee-New Sacco"+(GeneralSetup."ATM Card Fee-New Sacco"*GeneralSetup."Excise Duty(%)"/100)
                                 ELSE
                                 IF "Request Type"="Request Type"::New THEN
                                 GenJournalLine.Amount:=GeneralSetup."ATM Card Fee-New Coop"+GeneralSetup."ATM Card Fee-New Sacco"+(GeneralSetup."ATM Card Fee-New Sacco"*GeneralSetup."Excise Duty(%)"/100)
                                 ELSE
                                 IF "Request Type"="Request Type"::Renewal THEN
                                 GenJournalLine.Amount:=GeneralSetup."ATM Card Fee-Replacement"+GeneralSetup."ATM Card Fee-New Sacco"+(GeneralSetup."ATM Card Fee-New Sacco"*GeneralSetup."Excise Duty(%)"/100);
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":=FnGetUserBranch();
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Bank Charge**********************************************************
                                 GeneralSetup.GET;

                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":='ATMFEE' ;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":=GeneralSetup."ATM Card Fee Co-op Bank";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 IF "Request Type"="Request Type"::Replacement THEN
                                 GenJournalLine.Description:='ATM Card Fee-Replacement_'+FORMAT("Account No")
                                 ELSE
                                 IF "Request Type"="Request Type"::New THEN
                                 GenJournalLine.Description:='ATM Card Fee-New_'+FORMAT("Account No")
                                 ELSE
                                 IF "Request Type"="Request Type"::Renewal THEN
                                 GenJournalLine.Description:='ATM Card Fee-Renewal_'+FORMAT("Account No");

                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 IF "Request Type"="Request Type"::Replacement THEN
                                 GenJournalLine.Amount:=GeneralSetup."ATM Card Fee-Replacement"*-1
                                 ELSE
                                 IF "Request Type"="Request Type"::New THEN
                                 GenJournalLine.Amount:=GeneralSetup."ATM Card Fee-New Coop"*-1
                                 ELSE
                                 IF "Request Type"="Request Type"::Renewal THEN
                                 GenJournalLine.Amount:=GeneralSetup."ATM Card Fee-Renewal"*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":=FnGetUserBranch();
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //SACCO Charge*************************************************
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":='ATMFEE' ;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=GeneralSetup."ATM Card Fee-Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Amount:=GeneralSetup."ATM Card Fee-New Sacco"*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":=FnGetUserBranch();
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Excise Duty on SACCO Comission**************************
                                 LineNo:=LineNo+10000;
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='FTRANS';
                                 GenJournalLine."Document No.":='ATMFEE' ;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=GeneralSetup."Excise Duty Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Excise Duty on ATM Card Fee_'+FORMAT("Account No");
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=(GeneralSetup."ATM Card Fee-New Sacco"*GeneralSetup."Excise Duty(%)"/100)*-1;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine."Shortcut Dimension 2 Code":=FnGetUserBranch();
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Post New
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'Ftrans');
                                 IF GenJournalLine.FIND('-') THEN BEGIN

                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);

                                 //window.OPEN('Posting:,#1######################');

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'ATM Card Fee Charged.',GeneralSetup."ATM Card Fee-Replacement",'ATM',TODAY,TIME,'',"Account No","No.","Card No");
                                 //End Create Audit Entry


                                 "ATM Card Fee Charged":=TRUE;
                                 "ATM Card Fee Charged By":=USERID;
                                 "ATM Card Fee Charged On":=TODAY;
                                 MESSAGE('ATM Card Charge Posted Succesfully');
                                 END;
                                 END;
                               END;
                                }
      { 1000000004;1 ;ActionGroup;
                      Name=Approvals }
      { 1000000003;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"ATM Cloud";
                                 ApprovalEntries.Setfilters(DATABASE::"ATM Card Applications",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 ApprovalsMgmt@1102755001 : Codeunit 1535;
                                 Vendor@1120054000 : Record 23;
                                 MembersRegister@1120054001 : Record 51516223;
                               BEGIN
                                 TESTFIELD("Account No");Vend.GET("Account No");
                                 MembersRegister.GET(Vend."BOSA Account No");

                                 IF "Member No." = '' THEN BEGIN
                                     "Member No." := MembersRegister."No.";
                                       MODIFY;
                                 END;
                                 MembersRegister.CALCFIELDS(Picture,Signature);
                                 MembersRegister.CALCFIELDS("Front Side ID");
                                 MembersRegister.CALCFIELDS("Back Side ID");
                                 IF NOT MembersRegister.Picture.HASVALUE THEN
                                       ERROR('Member Picture MUST have a value');
                                 IF NOT MembersRegister.Signature.HASVALUE THEN
                                       ERROR('Member Signature MUST have a value');
                                 IF NOT MembersRegister."Back Side ID".HASVALUE THEN
                                       ERROR('Member "ID Back" MUST have a value');
                                 IF NOT MembersRegister."Front Side ID".HASVALUE THEN
                                       ERROR('Member "ID Front" MUST have a value');


                                 IF Status<>Status::Approved THEN BEGIN
                                 IF ApprovalsMgmt.CheckCloudATMApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendCloudATMForApproval(Rec);
                                 msg:='Dear '+"Account Name"+', Your Telepost Sacco link Card application has been received and is being processed';
                                 CloudPESA.SMSMessage('ATMAPP',"Account No","Phone No.",msg);
                                 END ELSE BEGIN
                                   ERROR('The ATM Card has already been approved');
                                 END;
                               END;
                                }
      { 1000000001;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 1535;
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN

                                 IF ApprovalsMgmt.CheckCloudATMApprovalsWorkflowEnabled(Rec) THEN
                                    ApprovalsMgmt.OnCancelCloudATMApprovalRequest(Rec);
                               END;
                                }
      { 1120054010;2 ;Action    ;
                      Name=Sent To CoopBank;
                      CaptionML=ENU=Sent To CoopBank;
                      OnAction=BEGIN
                                 TESTFIELD("Card Status",Rec."Card Status"::Pending);
                                 //TESTFIELD("ATM Card Fee Charged",TRUE);
                                 TESTFIELD("Sent to CoopBank",FALSE);

                                 IF CONFIRM('Are you sure you want sent to Coop Bank?',TRUE)=TRUE THEN
                                     "Sent to CoopBank":=TRUE;
                                     "Date sent to coopBank":=TODAY;
                                     MODIFY;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000034;0;Container;
                ContainerType=ContentArea }

    { 1000000033;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000032;2;Field  ;
                SourceExpr="No.";
                Editable=FALSE }

    { 1000000023;2;Field  ;
                SourceExpr="Request Type";
                Editable=RequestTypeEditable }

    { 1000000031;2;Field  ;
                SourceExpr="Account No";
                Editable=[ AccountNoEditable] }

    { 1000000029;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1000000028;2;Field  ;
                SourceExpr="Phone No.";
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Staff No" }

    { 19  ;2   ;Field     ;
                SourceExpr="ID No";
                Editable=FALSE }

    { 1000000025;2;Field  ;
                SourceExpr="Card No";
                Editable=CardNoEditable;
                OnValidate=BEGIN


                              IF STRLEN("Card No") <> 16 THEN
                               ERROR('ATM No. cannot contain More or less than 16 Characters.');
                           END;
                            }

    { 1120054006;2;Field  ;
                NotBlank=No;
                SourceExpr="Confirm Card No";
                OnValidate=BEGIN
                             IF STRLEN("Confirm Card No") <> 16 THEN
                               ERROR('ATM No. cannot contain More or less than 16 Characters.');


                           END;
                            }

    { 1000000022;2;Field  ;
                SourceExpr="Application Date";
                Editable=FALSE }

    { 1000000021;2;Field  ;
                SourceExpr="ATM Expiry Date";
                Editable=FALSE }

    { 1000000020;2;Field  ;
                SourceExpr=Limit;
                Editable=false }

    { 1000000019;2;Field  ;
                SourceExpr="Terms Read and Understood" }

    { 1000000018;2;Field  ;
                SourceExpr=Status;
                Editable=false;
                OnValidate=BEGIN
                             FnAddRecRestriction;
                           END;
                            }

    { 1120054007;2;Field  ;
                Name=[Reason ];
                CaptionML=ENU=Reason;
                SourceExpr="Reason for Account blocking" }

    { 1120054001;2;Field  ;
                SourceExpr="Branch Code" }

    { 1120054002;2;Field  ;
                SourceExpr=Branch }

    { 1120054005;2;Field  ;
                SourceExpr=Sacco_Name }

    { 1000000017;1;Group  ;
                CaptionML=ENU=Other Details;
                GroupType=Group }

    { 9   ;2   ;Field     ;
                CaptionML=ENU=Order;
                SourceExpr="Order ATM Card";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                SourceExpr="Ordered By";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                SourceExpr="Ordered On";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                SourceExpr="Card Received";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                CaptionML=ENU=Received;
                SourceExpr="Received By";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                SourceExpr="Received On";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                SourceExpr=Collected;
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                SourceExpr="Date Collected";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                SourceExpr="Card Issued By";
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                SourceExpr="Issued to";
                Editable=IssuedtoEditable }

    { 14  ;2   ;Field     ;
                SourceExpr=ModeOfCollection;
                Editable=true }

    { 1000000014;2;Field  ;
                SourceExpr="Card Status";
                Editable=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr="Date Activated";
                Editable=FALSE }

    { 1000000012;2;Field  ;
                SourceExpr="Date Frozen";
                Editable=FALSE }

    { 1000000010;2;Field  ;
                SourceExpr="Has Other Accounts" }

    { 1000000011;2;Field  ;
                CaptionML=ENU=<Replaced Card No>;
                SourceExpr="Replacement For Card No";
                Editable=false }

    { 1000000006;2;Field  ;
                SourceExpr="Approval Date";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                SourceExpr="ATM Card Fee Charged";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                SourceExpr="ATM Card Fee Charged On";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr="ATM Card Fee Charged By";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="ATM Card Linked";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr="ATM Card Linked By";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="ATM Card Linked On";
                Editable=FALSE }

    { 1120054009;0;Container;
                ContainerType=FactBoxArea }

    { 1120054008;1;Part   ;
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
      PictureExists@1102755015 : Boolean;
      AccountTypes@1102755014 : Record 51516436;
      GLPosting@1102755013 : Codeunit 12;
      Charges@1102755011 : Record 51516439;
      ForfeitInterest@1102755010 : Boolean;
      Vend@1102755007 : Record 23;
      Cust@1102755006 : Record 18;
      UsersID@1102755005 : Record 2000000120;
      Bal@1102755004 : Decimal;
      AtmTrans@1102755003 : Decimal;
      UnCheques@1102755002 : Decimal;
      AvBal@1102755001 : Decimal;
      Minbal@1102755000 : Decimal;
      GeneralSetup@1102755026 : Record 51516257;
      DocumentType@1000000000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTransport Request,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft ,BLA,Member Editable,Change Req,ATM Application,ATM Cloud,Withdrawal Batch';
      AccountNoEditable@1000000001 : Boolean;
      CardNoEditable@1000000002 : Boolean;
      CardTypeEditable@1000000003 : Boolean;
      RequestTypeEditable@1000000004 : Boolean;
      ReplacementCardNoEditable@1000000005 : Boolean;
      IssuedtoEditable@1000000006 : Boolean;
      ObjAccount@1000 : Record 23;
      CloudPESA@1120054000 : Codeunit 51516019;
      msg@1120054001 : Text;
      EXpiryeditable@1120054002 : Boolean;
      Userss@1120054003 : Record 91;
      AuditTrail@1120054006 : Codeunit 51516107;
      Trail@1120054005 : Record 51516655;
      EntryNo@1120054004 : Integer;
      ATMCardApplications@1120054007 : Record 51516321;

    LOCAL PROCEDURE FnGetUserBranch@1000000004() branchCode : Code[50];
    VAR
      UserSetup@1000000000 : Record 2000000120;
    BEGIN
      UserSetup.RESET;
      UserSetup.SETRANGE(UserSetup."User Name",USERID);
      IF UserSetup.FIND('-') THEN BEGIN
        branchCode:=UserSetup.Branch;
        END;
        EXIT(branchCode);
    END;

    LOCAL PROCEDURE FnAddRecRestriction@1000000000();
    BEGIN

      IF Status=Status::Open THEN BEGIN
          AccountNoEditable:=TRUE;
          CardNoEditable:=FALSE;
          CardTypeEditable:=TRUE;
          ReplacementCardNoEditable:=TRUE;
          IssuedtoEditable:=FALSE;
          RequestTypeEditable:=TRUE;
      //    EXpiryeditable:=TRUE;
        END ELSE
        IF Status=Status::Pending THEN BEGIN
          AccountNoEditable:=FALSE;
          CardNoEditable:=FALSE;
          CardTypeEditable:=FALSE;
          ReplacementCardNoEditable:=FALSE;
           RequestTypeEditable:=FALSE;
           EXpiryeditable:=FALSE;
          IssuedtoEditable:=FALSE
          END ELSE
        IF Status=Status::Approved THEN BEGIN
          AccountNoEditable:=FALSE;
          CardNoEditable:=TRUE;
          CardTypeEditable:=FALSE;
          ReplacementCardNoEditable:=TRUE;
           RequestTypeEditable:=FALSE;
          IssuedtoEditable:=TRUE;
          EXpiryeditable:=FALSE;
          END;
    END;

    BEGIN
    END.
  }
}

