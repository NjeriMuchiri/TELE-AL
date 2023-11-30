OBJECT page 17358 Membership Application List
{
  OBJECT-PROPERTIES
  {
    Date=06/10/22;
    Time=11:25:05 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516220;
    SourceTableView=WHERE(Incomplete Application=FILTER(No),
                          Converted=FILTER(No),
                          Status=FILTER(<>Approved));
    PageType=List;
    CardPageID=Membership Application Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755022;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755020;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1102755018;2 ;Action    ;
                      Name=Next of Kin;
                      CaptionML=ENU=Next of Kin;
                      RunObject=page 17362;
                      RunPageLink=Name=CONST(name);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1102755016;2 ;Action    ;
                      Name=[Account Signatories ];
                      CaptionML=ENU=Signatories;
                      RunObject=page 17361;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Group;
                      PromotedCategory=Process }
      { 1102755012;2 ;Separator ;
                      CaptionML=ENU=- }
      { 1102755010;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"Account Opening";
                                 ApprovalEntries.Setfilters(DATABASE::"Membership Applications",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755008;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 Approvalmgt@1102755001 : Codeunit 439;
                               BEGIN
                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                    ERROR('Member has already been created');
                                 END;
                                 END;

                                 TESTFIELD("No. Series");
                                 TESTFIELD("Employer Code");
                                 TESTFIELD("ID No.");
                                 TESTFIELD("Mobile Phone No");
                                 //TESTFIELD("E-Mail (Personal)");
                                 TESTFIELD("Customer Posting Group");
                                 TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                  {
                                 PictureExists:=Picture.HASVALUE;
                                 SignatureExists:=Signature.HASVALUE;

                                 IF (PictureExists = FALSE) OR (SignatureExists=FALSE) THEN
                                 ERROR('Kindly upload a picture & signature');
                                    }

                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);

                                 Doc_Type:=Doc_Type::"Account Opening";
                                 Table_id:=DATABASE::"Membership Applications";
                                 IF Approvalmgt.SendApproval(Table_id,"No.",Doc_Type,Status)THEN;
                                 //End allocate batch number
                               END;
                                }
      { 1102755006;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 439;
                               BEGIN

                                 //IF Approvalmgt.CancelAccOpeninApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755004;2 ;Separator ;
                      CaptionML=ENU="       -" }
      { 1102755002;2 ;Action    ;
                      Name=Create Account;
                      CaptionML=ENU=Create Account;
                      Promoted=Yes;
                      Visible=false;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you want to approve account application?',FALSE)=TRUE THEN BEGIN

                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                    ERROR('Member has already been created');
                                 END;
                                 END;

                                 IF Status<>Status::Approved THEN
                                 ERROR('This application has not been approved');


                                 //IF UPPERCASE("Sent for Approval By")=UPPERCASE(USERID) THEN
                                 //.ERROR('Operation denied');

                                 //Create BOSA account
                                 Cust."No.":='';
                                 Cust.Name:=Name;
                                 Cust.Address:=Address;
                                 Cust."Post Code":="Postal Code";
                                 Cust.County:=City;
                                 Cust."Phone No.":="Phone No.";
                                 Cust."Global Dimension 1 Code":="Global Dimension 1 Code" ;
                                 Cust."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Cust."Customer Posting Group":="Customer Posting Group";
                                 Cust."Registration Date":="Registration Date";
                                 Cust.Status:=Cust.Status::Active;
                                 Cust."Employer Code":="Employer Code";
                                 Cust."Date of Birth":="Date of Birth";
                                 Cust."Station/Department":="Station/Department";
                                 Cust."E-Mail":="E-Mail (Personal)";
                                 Cust.Location:=Location;
                                 Cust."Sub-Location":="Sub-Location";
                                 Cust.District:=District;
                                 Cust."Payroll/Staff No":="Payroll/Staff No";
                                 Cust."ID No.":="ID No.";
                                 Cust."Mobile Phone No":="Mobile Phone No";
                                 Cust."Marital Status":="Marital Status";
                                 Cust."Customer Type":=Cust."Customer Type"::Member;
                                 Cust.Gender:=Gender;
                                 Cust.Picture:=Picture;
                                 Cust.Signature:=Signature;
                                 Cust."Monthly Contribution":="Monthly Contribution";
                                 Cust."Contact Person":="Contact Person";
                                 Cust."Contact Person Phone":="Contact Person Phone";
                                 Cust."ContactPerson Relation":="ContactPerson Relation";
                                 Cust."Recruited By":="Recruited By";
                                 Cust."ContactPerson Occupation":="ContactPerson Occupation";
                                 Cust."Village/Residence":="Village/Residence";
                                 Cust.INSERT(TRUE);
                                 //Cust.VALIDATE(Cust."ID No.");

                                 //CLEAR(Picture);
                                 //CLEAR(Signature);
                                 //MODIFY;

                                 BOSAACC:=Cust."No.";

                                 {
                                 AcctNo:='001208'+BOSAACC;
                                 //Create FOSA account
                                 Accounts.INIT;
                                 Accounts."No.":=AcctNo;
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts.Name:=Name;
                                 Accounts."Creditor Type":=Accounts."Creditor Type"::Account;
                                 Accounts."Staff No":="Payroll/Staff No";
                                 Accounts."ID No.":="ID No.";
                                 Accounts."Mobile Phone No":="Mobile Phone No";
                                 Accounts."Registration Date":="Registration Date";
                                 Accounts."Post Code":="Post Code";
                                 Accounts.County:=City;
                                 Accounts."BOSA Account No":=Cust."No.";
                                 Accounts.Picture:=Picture;
                                 Accounts.Signature:=Signature;
                                 Accounts."Passport No.":="Passport No.";
                                 Accounts."Company Code":="Employer Code";
                                 Accounts.Status:=Accounts.Status::New;
                                 Accounts."Account Type":='SAVINGS';
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts."Global Dimension 1 Code":='FOSA';
                                 Accounts."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Accounts.Address:=Address;
                                 Accounts."Address 2":="Address 2";
                                 Accounts."Phone No.":="Phone No.";
                                 Accounts."Registration Date":=TODAY;
                                 Accounts.Status:=Accounts.Status::Active;
                                 Accounts.Section:=Section;
                                 Accounts."Home Address":="Home Address";
                                 Accounts.District:=District;
                                 Accounts.Location:=Location;
                                 Accounts."Sub-Location":="Sub-Location";
                                 Accounts."Registration Date":=TODAY;
                                 Accounts."Monthly Contribution" := "Monthly Contribution";
                                 Accounts."E-Mail":="E-Mail (Personal)";
                                 //Accounts."Home Page":="Home Page";
                                 //Accounts."Savings Account No.":="Savings Account No.";
                                 //Accounts."Signing Instructions":="Signing Instructions";
                                 //Accounts."Fixed Deposit Type":="Fixed Deposit Type";
                                 //Accounts."FD Maturity Date":="FD Maturity Date";
                                 //Accounts."Electrol Zone Code":="Electrol Zone Code";
                                 //Accounts."Departments Code":="Departments Code";
                                 //Accounts."Sections Code":="Sections Code";
                                 Accounts.INSERT;


                                 Accounts.RESET;
                                 IF Accounts.GET(AcctNo) THEN BEGIN
                                 Accounts.VALIDATE(Accounts.Name);
                                 Accounts.VALIDATE(Accounts."Account Type");
                                 Accounts.VALIDATE(Accounts."Global Dimension 1 Code");
                                 Accounts.VALIDATE(Accounts."Global Dimension 2 Code");
                                 Accounts.MODIFY;

                                 //Update BOSA with FOSA Account
                                 IF Cust.GET(BOSAACC) THEN BEGIN
                                 Cust."FOSA Account":=AcctNo;
                                 Cust.MODIFY;
                                 END;
                                 END;
                                 }

                                 NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-') THEN BEGIN
                                  REPEAT
                                   NextOfKin.INIT;
                                   NextOfKin."Account No":=BOSAACC;
                                   NextOfKin.Name:=NextOfKinApp.Name;
                                   NextOfKin.Relationship:=NextOfKinApp.Relationship;
                                   NextOfKin.Beneficiary:=NextOfKinApp.Beneficiary;
                                   NextOfKin."Date of Birth":=NextOfKinApp."Date of Birth";
                                   NextOfKin.Address:=NextOfKinApp.Address;
                                   NextOfKin.Telephone:=NextOfKinApp.Telephone;
                                   //NextOfKin.Fax:=NextOfKinApp.Fax;
                                   NextOfKin.Email:=NextOfKinApp.Email;
                                   NextOfKin."ID No.":=NextOfKinApp."ID No.";
                                   NextOfKin."%Allocation":=NextOfKinApp."%Allocation";
                                   NextOfKin.INSERT;
                                  UNTIL NextOfKinApp.NEXT = 0;
                                 END;

                                 AccountSignApp.RESET;
                                 AccountSignApp.SETRANGE(AccountSignApp."Account No","No.");
                                 IF AccountSignApp.FIND('-') THEN BEGIN
                                  REPEAT
                                   AccountSign.INIT;
                                   AccountSign."Account No":=AcctNo;
                                   AccountSign.Names:=AccountSignApp.Names;
                                   AccountSign."Date Of Birth":=AccountSignApp."Date Of Birth";
                                   AccountSign."Staff/Payroll":=AccountSignApp."Staff/Payroll";
                                   AccountSign."ID No.":=AccountSignApp."ID No.";
                                   AccountSign.Signatory:=AccountSignApp.Signatory;
                                   AccountSign."Must Sign":=AccountSignApp."Must Sign";
                                   AccountSign."Must be Present":=AccountSignApp."Must be Present";
                                   AccountSign.Picture:=AccountSignApp.Picture;
                                   AccountSign.Signature:=AccountSignApp.Signature;
                                   AccountSign."Expiry Date":=AccountSignApp."Expiry Date";
                                   //AccountSign."Mobile No.":=AccountSignApp."Mobile No.";
                                   AccountSign.INSERT;
                                  UNTIL AccountSignApp.NEXT = 0;
                                 END;

                                 Cust.RESET;
                                 IF Cust.GET(BOSAACC) THEN BEGIN
                                 Cust.VALIDATE(Cust.Name);
                                 //Cust.VALIDATE(Accounts."Account Type");
                                 Cust.VALIDATE(Cust."Global Dimension 1 Code");
                                 Cust.VALIDATE(Cust."Global Dimension 2 Code");
                                 Cust.MODIFY;
                                 END;


                                 {
                                 GenSetUp.GET();
                                  Notification.CreateMessage('Dynamics NAV',GenSetUp."Sender Address","E-Mail (Personal)",'Member Acceptance Notification',
                                                 'Member application '+ "No." + ' has been approved'
                                                + ' (Dynamics NAV ERP)',FALSE);
                                  Notification.Send;
                                 }

                                 //"Converted By":=USERID;
                                 MESSAGE('Account created successfully.');
                                 //END;
                                 Status:=Status::Approved;
                                 "Approved By":=USERID;
                                 MODIFY;
                                 END ELSE
                                 ERROR('Not approved');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755005;2;Field  ;
                SourceExpr="Search Name" }

    { 1   ;2   ;Field     ;
                SourceExpr=Status }

    { 2   ;2   ;Field     ;
                SourceExpr="Assigned No." }

    { 1102755111;2;Field  ;
                SourceExpr="Responsibility Centre" }

    { 3   ;2   ;Field     ;
                SourceExpr="Payroll/Staff No" }

    { 4   ;2   ;Field     ;
                SourceExpr="ID No." }

    { 5   ;2   ;Field     ;
                SourceExpr="Mobile Phone No" }

    { 6   ;2   ;Field     ;
                Name=Account Type;
                SourceExpr="Account Category" }

  }
  CODE
  {
    VAR
      StatusPermissions@1102755027 : Record 51516310;
      Cust@1102755026 : Record 51516223;
      Accounts@1102755025 : Record 23;
      AcctNo@1102755024 : Code[20];
      NextOfKinApp@1102755023 : Record 51516221;
      NextofKinFOSA@1102755022 : Record 51516225;
      AccountSign@1102755021 : Record 51516226;
      AccountSignApp@1102755020 : Record 51516222;
      Acc@1102755019 : Record 23;
      UsersID@1102755018 : Record 2000000120;
      Nok@1102755017 : Record 51516221;
      NOKBOSA@1102755016 : Record 51516225;
      BOSAACC@1102755015 : Code[20];
      NextOfKin@1102755014 : Record 51516225;
      PictureExists@1102755013 : Boolean;
      UserMgt@1102755012 : Codeunit 5700;
      Notification@1102755011 : Codeunit 400;
      NotificationE@1102755010 : Codeunit 397;
      MailBody@1102755009 : Text[250];
      ccEmail@1102755008 : Text[1000];
      toEmail@1102755007 : Text[1000];
      GenSetUp@1102755006 : Record 51516257;
      ClearingAcctNo@1102755005 : Code[20];
      AdvrAcctNo@1102755004 : Code[20];
      DocumentType@1102755003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      AccountTypes@1102755002 : Record 51516295;
      DivAcctNo@1102755001 : Code[20];
      SignatureExists@1102755000 : Boolean;
      Table_id@1002 : Integer;
      Doc_No@1001 : Code[20];
      Doc_Type@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening';

    BEGIN
    END.
  }
}

