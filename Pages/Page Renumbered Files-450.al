OBJECT page 172045 Membership Card Approved
{
  OBJECT-PROPERTIES
  {
    Date=10/13/22;
    Time=11:41:57 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516220;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 {"Customer Posting Group":='MEMBER';
                 "Global Dimension 1 Code":='BOSA';
                 MODIFY;}
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Centre",UserMgt.GetSalesFilter);
                   FILTERGROUP(0);
                 END;
                 Jooint:=FALSE;
               END;

    OnInsertRecord=BEGIN
                     "Responsibility Centre" := UserMgt.GetSalesFilter;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateControls();
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755051;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 9       ;2   ;Action    ;
                      Name=Next of Kin;
                      CaptionML=ENU=Next of Kin;
                      RunObject=page 17362;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 7       ;2   ;Action    ;
                      Name=[Account Signatories ];
                      CaptionML=ENU=Signatories;
                      RunObject=page 17361;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Group;
                      PromotedCategory=Process }
      { 6       ;2   ;Separator ;
                      CaptionML=ENU=- }
      { 5       ;2   ;Action    ;
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
      { 4       ;2   ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 Approvalmgt@1102755001 : Codeunit 439;
                               BEGIN
                                 TESTFIELD("Monthly Contribution");


                                 {
                                 IF "Created By"<> USERID THEN
                                   ERROR('You cannot send a document created by another user for approval.');
                                   }
                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF (Cust."No." <> "No.") AND (Cust."Account Category"=Cust."Account Category"::Single) THEN
                                    ERROR('Member has already been created');
                                 END;
                                 END;


                                 IF ("Account Category"="Account Category"::Single) THEN BEGIN
                                 TESTFIELD(Name);
                                 TESTFIELD("ID No.");
                                 TESTFIELD("Mobile Phone No");
                                 TESTFIELD("E-Mail (Personal)");
                                 TESTFIELD("Employer Code");
                                 TESTFIELD("Received 1 Copy Of ID");
                                 //TESTFIELD("Copy of Current Payslip");
                                 //TESTFIELD("Member Registration Fee Receiv");
                                 TESTFIELD("Copy of KRA Pin");
                                 TESTFIELD("Customer Posting Group");
                                 TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("KRA Pin");
                                 TESTFIELD("Date of Birth");
                                 TESTFIELD("Work Station");
                                 TESTFIELD(Designation);
                                 END;

                                 IF ("Account Category"="Account Category"::Group) OR ("Account Category"="Account Category"::Corporate)THEN BEGIN
                                 TESTFIELD(Name);
                                 TESTFIELD("Registration No");
                                 TESTFIELD("Copy of KRA Pin");
                                 TESTFIELD("Member Registration Fee Receiv");
                                 ///TESTFIELD("Account Category");
                                 TESTFIELD("Customer Posting Group");
                                 TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 //TESTFIELD("Copy of constitution");

                                 END;

                                 IF ("Account Category"="Account Category"::Single)OR ("Account Category"="Account Category"::Junior)OR ("Account Category"="Account Category"::Joint)  THEN BEGIN
                                 NOkApp.RESET;
                                 NOkApp.SETRANGE(NOkApp."Account No","No.");
                                 IF NOkApp.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please Insert Next 0f kin Information');
                                 END;
                                 END;
                                 {
                                 IF ("Account Category"="Account Category"::Group) OR ("Account Category"="Account Category"::Corporate)THEN BEGIN
                                 AccountSignApp.RESET;
                                 AccountSignApp.SETRANGE( AccountSignApp."Account No","No.");
                                 IF AccountSignApp.FIND('-')=FALSE THEN BEGIN
                                 ERROR('Please insert Account Signatories');
                                 END;
                                 END;
                                 }

                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);

                                 //End allocate batch number
                                 Doc_Type:=Doc_Type::"Account Opening";
                                 Table_id:=DATABASE::"Membership Applications";


                                 IF ApprovalsMgmt.CheckMembAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendMembAppDocForApproval(Rec);

                                  { Status:=Status::Approved;
                                   MODIFY;
                                 MESSAGE('Approved Successfully.');
                                 }
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 439;
                               BEGIN
                                 IF Status<>Status::Pending THEN
                                 ERROR('Status must be pending');

                                 IF ApprovalsMgmt.CheckMembAppApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnCancelMembAppApprovalRequest(Rec);
                               END;
                                }
      { 2       ;2   ;Separator ;
                      CaptionML=ENU="       -" }
      { 1       ;2   ;Action    ;
                      Name=Create Account;
                      CaptionML=ENU=Create Account;
                      Promoted=Yes;
                      Visible=true;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 FosaAccount@1120054000 : Code[20];
                               BEGIN
                                 UserSetup.GET(USERID);
                                 IF UserSetup."Create Account"=FALSE THEN
                                 ERROR('You dont have permission to create account.');
                                 IF Status<>Status::Approved THEN
                                 ERROR('This application has not been approved');

                                 IF CONFIRM('Are you sure you want to create account application?',FALSE)=TRUE THEN BEGIN
                                 "Created By":=USERID;
                                   MODIFY;
                                 IF Cust."Customer Posting Group"<> 'PLAZA' THEN

                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF (Cust."No." <> "No.") AND (Cust."Account Category"=Cust."Account Category"::Single) THEN
                                    ERROR('Member has already been created');
                                 END;
                                 END;

                                 IF "Account Category"="Account Category"::Single THEN
                                 BEGIN
                                 TESTFIELD("ID No.");
                                 TESTFIELD(Name);
                                 TESTFIELD("Date of Birth");
                                 TESTFIELD(County);
                                 TESTFIELD("Sub-County");
                                 TESTFIELD("Mobile Phone No");
                                 TESTFIELD("E-Mail (Personal)");
                                 TESTFIELD("Postal Code");
                                 TESTFIELD("Terms of Employment");
                                 IF "Passport No."<>'' THEN BEGIN
                                 TESTFIELD("Expiry Date(Passport)");
                                 END;
                                 END;
                                 Saccosetup.GET();
                                 NewMembNo:=Saccosetup.BosaNumber;
                                 //IF UPPERCASE("Sent for Approval By")=UPPERCASE(USERID) THEN
                                 //.ERROR('Operation denied');



                                 //Create BOSA account
                                 Cust."No.":=FORMAT(NewMembNo);
                                 Cust.Name:=Name;
                                 Cust.Address:=Address;
                                 Cust."Post Code":="Postal Code";
                                 Cust.Pin:="KRA Pin";
                                 Cust.County:=City;
                                 Cust."Phone No.":="Phone No.";
                                 Cust."Global Dimension 1 Code":="Global Dimension 1 Code" ;
                                 Cust."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Cust."Customer Posting Group":="Customer Posting Group";
                                 Cust."Registration Date":=TODAY;
                                 Cust."Mobile Phone No":="Mobile Phone No";
                                 Cust.Status:=Cust.Status::Dormant;
                                 Cust."Employer Code":="Employer Code";
                                 Cust."Date of Birth":="Date of Birth";
                                 Cust."Date Of Retirement":="Date Of Retirement";
                                 Cust."Station/Department":="Station/Department";
                                 Cust."E-Mail":="E-Mail (Personal)";
                                 Cust.Location:=Location;
                                 Cust.Title:=Title;
                                 Cust."Home Address":="Home Address";
                                 Cust."Home Postal Code":="Home Postal Code";
                                 Cust."Home Town":="Home Town";
                                 Cust."Recruited By":="Recruited By";
                                 Cust."Contact Person":="Contact Person";
                                 Cust."ContactPerson Relation":="ContactPerson Relation";
                                 Cust."ContactPerson Occupation":="ContactPerson Occupation";
                                 Cust."Account Category":="Account Category";
                                 Cust."Registration Fee Paid.":="Registration Fee Paid";
                                 //**
                                 Cust."Office Branch":="Office Branch";
                                 Cust.Department:=Department;
                                 Cust.Occupation:=Occupation;
                                 Cust.Designation:=Designation;
                                 Cust."Bank Code":="Bank Code";
                                 Cust."Bank Branch":="Bank Name";
                                 Cust."Bank Account No.":="Bank Account No";
                                 //**
                                 Cust."Sub-Location":="Sub-Location";
                                 Cust.District:=District;
                                 Cust."Payroll/Staff No":="Payroll/Staff No";
                                 Cust."ID No.":="ID No.";
                                 Cust."Mobile Phone No":="Mobile Phone No";
                                 Cust."Marital Status":="Marital Status";
                                 Cust."Customer Type":=Cust."Customer Type"::Member;
                                 Cust.Gender:=Gender;
                                 Cust."Expiry Date(Passport)":="Expiry Date(Passport)";
                                 Cust."Nature of Business":="Nature of Business";
                                 Cust."Sub-County":="Sub-County";
                                 Cust.County:=County;
                                 Cust."Employment Type":="Employment Type";
                                 Cust."Name of Business":="Name of Business";
                                 Cust."Nature of Business":="Nature of Business";
                                 Cust."Terms And Conditions":="Terms And Conditions";
                                 Cust."Sms Notification":="Sms Notification";
                                 Cust."Created By":="Created By";

                                 CALCFIELDS(Signature,Picture);
                                 PictureExists:=Picture.HASVALUE;
                                 SignatureExists:=Signature.HASVALUE;
                                 IF (PictureExists=TRUE) AND (SignatureExists=TRUE) THEN BEGIN
                                 Cust.Picture:=Picture;
                                 Cust.Signature:=Signature;
                                 END ELSE
                                 ERROR('Kindly upload a Picture and signature');


                                 Cust."Monthly Contribution":="Monthly Contribution";
                                 Cust."Contact Person":="Contact Person";
                                 Cust."Contact Person Phone":="Contact Person Phone";
                                 Cust."ContactPerson Relation":="ContactPerson Relation";
                                 Cust."Recruited By":="Recruited By";
                                 Cust."ContactPerson Occupation":="ContactPerson Occupation";
                                 //Cust."Village/Residence":="Village/Residence";
                                 Cust.Station:="Work Station";
                                 Cust."Front Side ID":="Front Side ID";
                                 Cust."Back Side ID":="Back Side ID";
                                 Cust.INSERT(TRUE);
                                 //Cust.VALIDATE(Cust."ID No.");

                                 CLEAR(Picture);
                                 CLEAR(Signature);
                                 //MODIFY;
                                 Saccosetup.BosaNumber:=INCSTR(NewMembNo);
                                 Saccosetup.MODIFY;
                                 BOSAACC:=Cust."No.";

                                 BOSAACC:=Cust."No.";

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Member Account Creation',0,'MEMBERSHIPAPPLICATION',TODAY,TIME,'',"No.",BOSAACC,'');
                                 //End Create Audit Entry

                                 GenSetUp.GET;
                                 IF GenSetUp."Auto Open FOSA Savings Acc."=TRUE THEN BEGIN

                                 //BranchC:='';
                                 IncrementNo:='';


                                 IF AccoutTypes.GET(GenSetUp."FOSA Account Type") THEN BEGIN
                                 IF DimensionValue.GET('BRANCH',"Global Dimension 2 Code") THEN BEGIN


                                 END;
                                 END;
                                 IF "Fosa Account No" ='' THEN BEGIN
                                 IF AccoutTypes.GET(GenSetUp."FOSA Account Type") THEN BEGIN
                                 Saccosetup.GET();
                                 //MESSAGE('fOSA ACC%1',AccountTypes."Ending Series");
                                 "Fosa Account No":='';
                                 //"Fosa Account No":=INCSTR(AccountTypes."Ending Series");
                                 //MESSAGE('fOSA ACC%1',"Fosa Account No");
                                 AcctNo:=AccoutTypes."Account No Prefix"+BOSAACC;//AccoutTypes."Ending Series";
                                 END;
                                 //AcctNo:='001208'+BOSAACC;
                                 //Create FOSA account
                                 Accounts.INIT;
                                 Accounts."No.":=AcctNo;
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts.Name:=UPPERCASE(Name);
                                 Accounts."Creditor Type":=Accounts."Creditor Type"::Account;
                                 Accounts."Staff No":="Payroll/Staff No";
                                 Accounts."ID No.":="ID No.";
                                 Accounts."Mobile Phone No":="Mobile Phone No";
                                 Accounts."Registration Date":="Registration Date";
                                 Accounts."Post Code":="Postal Code";
                                 Accounts.County:=City;
                                 Accounts."BOSA Account No":=Cust."No.";
                                 //Accounts."Force No.":="Force No.";
                                 Accounts."Marital Status":="Marital Status";
                                 Accounts.Picture:=Picture;
                                 Accounts.Signature:=Signature;
                                 Accounts."Passport No.":="Passport No.";
                                 Accounts."Company Code":="Employer Code";
                                 Accounts.Status:=Accounts.Status::Dormant;
                                 Accounts."Account Type":=GenSetUp."FOSA Account Type";
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
                                 Accounts."Vendor Posting Group":='ORDINARY';
                                 Accounts."Created By":="Created By";
                                 Accounts."Expiry Date(Passport)":=Cust."Expiry Date(Passport)";
                                 Accounts."Sub-County":=Cust."Sub-County";
                                 Accounts."Contract Expiry Date":=Cust."Contract Expiry Date";
                                 Accounts."Employment Type":=Cust."Employment Type";
                                 Accounts."Name of Business":=Cust."Name of Business";
                                 Accounts."Nature of Business":=Cust."Nature of Business";
                                 Accounts."Terms And Conditions":=Cust."Terms And Conditions";
                                 Accounts.INSERT;

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'FOSA Account Creation',0,'MEMBERSHIPAPPLICATION',TODAY,TIME,'',"No.",AcctNo,'');
                                 //End Create Audit Entry

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

                                 AccoutTypes.RESET;
                                 AccoutTypes.SETRANGE(AccoutTypes.Code,GenSetUp."FOSA Account Type");
                                 IF AccoutTypes.FIND('-') THEN BEGIN
                                  AccoutTypes."Ending Series":=INCSTR(AccoutTypes."Ending Series");
                                 AccoutTypes.MODIFY;
                                 END;
                                 NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-') THEN BEGIN
                                  REPEAT
                                   NextofKinFOSA.INIT;
                                   NextofKinFOSA."Account No":=AcctNo;
                                   NextofKinFOSA.Name:=NextOfKinApp.Name;
                                   NextofKinFOSA.Relationship:=NextOfKinApp.Relationship;
                                   NextofKinFOSA.Beneficiary:=NextOfKinApp.Beneficiary;
                                   NextofKinFOSA."Date of Birth":=NextOfKinApp."Date of Birth";
                                   NextofKinFOSA.Address:=NextOfKinApp.Address;
                                   NextofKinFOSA.Telephone:=NextOfKinApp.Telephone;
                                   NextofKinFOSA.Fax:=NextOfKinApp.Fax;
                                   NextofKinFOSA.Email:=NextOfKinApp.Email;
                                   NextofKinFOSA."ID No.":=NextOfKinApp."ID No.";
                                   NextofKinFOSA."%Allocation":=NextOfKinApp."%Allocation";
                                   NextofKinFOSA.Type:=NextOfKin.Type;
                                   NextofKinFOSA.INSERT;
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

                                 IF GenSetUp."Auto Fill ATM Application"=TRUE THEN BEGIN

                                 //AutoFill ATM Card Application
                                 ATMApp.INIT;
                                 ATMApp."Account No":='';
                                 ATMApp."No.":=AcctNo;
                                 ATMApp."Account No":="Global Dimension 2 Code";
                                 ATMApp."Branch Code":=ATMApp."Branch Code";
                                 //ATMApp."Account Type":="Name";
                                 ATMApp."Account Name":=Address;
                                 ATMApp.Address:="Address 2";
                                 ATMApp."Address 5":="ID No.";
                                 ATMApp."Card Type":=ATMApp."Card Type";
                                 ATMApp."Phone No.":="Mobile Phone No";
                                 //ATMApp."Request Type":=TODAY;
                                 ATMApp."Application Approved":=TRUE;
                                 ATMApp.INSERT(TRUE);
                                 //AutoFill ATM Card Application
                                 END;

                                 //Mpesa Applications
                                 {IF GenSetUp."Auto Fill Msacco Application"=TRUE THEN BEGIN
                                 MpesaAppH.INIT;
                                 MpesaAppH.No:='';
                                 MpesaAppH."Date Entered":=TODAY;
                                 MpesaAppH."Time Entered":=TIME;
                                 MpesaAppH."Entered By":=USERID;
                                 MpesaAppH."Document Serial No":="ID No.";
                                 MpesaAppH."Document Date":=TODAY;
                                 MpesaAppH."Customer ID No":="ID No.";
                                 MpesaAppH."Customer Name":=Name;
                                 MpesaAppH."MPESA Mobile No":="Phone No.";
                                 //MpesaAppH."MPESA Corporate No":="MPESA Corporate No";
                                 MpesaAppH."App Status":=MpesaAppH."App Status"::Pending;
                                 MpesaAppH.INSERT(TRUE);

                                 MpesaAppNo:=MpesaAppH.No;
                                 MpesaAppD.INIT;
                                 MpesaAppD."Application No":= MpesaAppNo;
                                 MpesaAppD."Account Type":=MpesaAppD."Account Type"::Vendor;
                                 MpesaAppD."Account No.":=AcctNo;
                                 MpesaAppD.Description:=Name;
                                 MpesaAppD.INSERT;
                                 END;}
                                 //Mpesa Applications


                                 END;
                                 END;

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
                                   NextOfKin.Fax:=NextOfKinApp.Fax;
                                   NextOfKin.Email:=NextOfKinApp.Email;
                                   NextOfKin."ID No.":=NextOfKinApp."ID No.";
                                   NextOfKin."%Allocation":=NextOfKinApp."%Allocation";
                                   NextOfKin.Type:=NextOfKinApp.Type;
                                   NextOfKin.INSERT;
                                  UNTIL NextOfKinApp.NEXT = 0;
                                 END;

                                 AccountSignApp.RESET;
                                 AccountSignApp.SETRANGE(AccountSignApp."Account No","No.");
                                 IF AccountSignApp.FIND('-') THEN BEGIN
                                  REPEAT
                                   AccountSign.INIT;
                                   AccountSign."Account No":=BOSAACC;
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



                                 //SendMail;


                                 //"Converted By":=USERID;
                                 MESSAGE('Account created successfully.');
                                 MESSAGE('The Member Sacco no is %1.The FOSA Account is %2',Cust."No.",AcctNo);
                                 //END;
                                 Converted:=TRUE;
                                 Status:=Status::Approved;
                                 "Approved By":=USERID;
                                 MODIFY;
                                 END ELSE
                                 ERROR('Not approved');

                                 //IF Converted=TRUE THEN BEGIN
                                 //SendSMS;
                                 //END;

                                 ///send sms

                                 GenSetUp.GET;
                                 CompInfo.GET;

                                 IF GenSetUp."Send SMS Notifications"=TRUE THEN BEGIN
                                 //SMS MESSAGE
                                 SMSMessage.RESET;
                                 IF SMSMessage.FIND('+') THEN BEGIN
                                 iEntryNo:=SMSMessage."Entry No";
                                 iEntryNo:=iEntryNo+1;
                                 END
                                 ELSE BEGIN
                                 iEntryNo:=1;
                                 END;

                                 SMSMessage.LOCKTABLE();
                                 SMSMessage.INIT;
                                 SMSMessage."Entry No":=iEntryNo;
                                 SMSMessage."Batch No":="No.";
                                 SMSMessage."Document No":='';
                                 SMSMessage."Account No":="Phone No.";
                                 SMSMessage."Date Entered":=TODAY;
                                 SMSMessage."Time Entered":=TIME;
                                 SMSMessage.Source:='MEMBAPP';
                                 SMSMessage."Entered By":=USERID;
                                 SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                 SMSMessage."SMS Message":='Dear Member you have been registered successfully, your Membership No is '
                                 + BOSAACC+' and your FOSA account is '+AcctNo+ ' Name '+Name+' ' +CompInfo.Name+' '+GenSetUp."Customer Care No";
                                 SMSMessage."Telephone No":="Phone No.";
                                 IF "Phone No."<>'' THEN
                                 SMSMessage.INSERT;
                                 COMMIT();
                                 END;


                                 CurrPage.CLOSE;
                                 {
                                 GenSetUp.GET();
                                  Notification.CreateMessage('Dynamics NAV',GenSetUp."Sender Address","E-Mail (Personal)",'Member Acceptance Notification',
                                                 'Member application '+ "No." + ' has been approved'
                                                + ' (Dynamics NAV ERP)',FALSE);
                                  Notification.Send;
                                  }
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755001;2;Field  ;
                SourceExpr="No.";
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr="Fosa Account No" }

    { 1102755016;2;Field  ;
                SourceExpr=Title;
                Editable=TitleEditable;
                ShowMandatory=true }

    { 18  ;2   ;Field     ;
                Name=Account Type;
                CaptionML=ENU=Account Type;
                SourceExpr="Account Category";
                Enabled=membertypeEditable;
                OnValidate=BEGIN
                             IF "Account Category"="Account Category"::Joint THEN
                               Jooint:=TRUE;
                           END;

                ShowMandatory=True }

    { 1102755003;2;Field  ;
                SourceExpr=Name;
                Editable=NameEditable;
                ShowMandatory=True }

    { 1102755005;2;Field  ;
                SourceExpr=Address;
                Editable=AddressEditable;
                ShowMandatory=True }

    { 1102755021;2;Field  ;
                SourceExpr="Postal Code";
                Importance=Promoted;
                Editable=PostalCodeEditable }

    { 1102755026;2;Field  ;
                CaptionML=ENU=Town;
                SourceExpr=Town;
                Editable=CityEditable;
                ShowMandatory=True }

    { 1102755011;2;Field  ;
                SourceExpr="Mobile Phone No";
                Editable=PhoneEditable;
                OnValidate=BEGIN
                              {IF STRLEN("Mobile Phone No") <> 10 THEN
                               ERROR('Mobile No. Can not be more or less than 10 Characters');}
                           END;

                ShowMandatory=True }

    { 1102755013;2;Field  ;
                Name=Mobile Phone No 2;
                SourceExpr="Mobile No. 2";
                Editable=PhoneEditable;
                OnValidate=BEGIN
                              {IF STRLEN("Mobile No. 2") <> 15 THEN
                               ERROR('Mobile No. Can not be more or less than 15 Characters');}
                           END;
                            }

    { 1102755015;2;Field  ;
                SourceExpr="Registration Date";
                Editable=RegistrationDateEdit }

    { 1102755019;2;Field  ;
                SourceExpr="ID No.";
                Editable=IDNoEditable;
                ShowMandatory=True }

    { 1120054014;2;Field  ;
                SourceExpr="Passport No." }

    { 1120054015;2;Field  ;
                SourceExpr="Expiry Date(Passport)" }

    { 32  ;2   ;Field     ;
                SourceExpr="KRA Pin";
                ShowMandatory=True }

    { 19  ;2   ;Field     ;
                SourceExpr="Registration No";
                Enabled=registrationeditable;
                ShowMandatory=true }

    { 1000000001;2;Field  ;
                SourceExpr="Payroll/Staff No";
                ShowMandatory=True }

    { 1102755023;2;Field  ;
                SourceExpr="Marital Status";
                Editable=MaritalstatusEditable;
                ShowMandatory=True }

    { 1102755025;2;Field  ;
                SourceExpr=Gender;
                Editable=GenderEditable;
                ShowMandatory=True }

    { 1102755039;2;Field  ;
                SourceExpr="Date of Birth";
                Enabled=DOBEditable;
                OnValidate=BEGIN
                             DAge:=Dates.DetermineAge("Date of Birth",TODAY);
                           END;

                ShowMandatory=True }

    { 1120054002;2;Field  ;
                SourceExpr="Date Of Retirement" }

    { 30  ;2   ;Field     ;
                Name=Age;
                SourceExpr=DAge;
                Editable=ageEditable;
                ShowMandatory=True }

    { 1102755041;2;Field  ;
                SourceExpr="E-Mail (Personal)";
                Editable=EmailEdiatble;
                ShowMandatory=true }

    { 1000000003;2;Field  ;
                SourceExpr="Recruited By";
                Editable=RecruitedEditable;
                ShowMandatory=True }

    { 1000000005;2;Field  ;
                SourceExpr="Recruiter Name";
                ShowMandatory=True }

    { 1102755010;2;Field  ;
                SourceExpr="Contact Person";
                Editable=ContactPEditable;
                ShowMandatory=True }

    { 1102755008;2;Field  ;
                SourceExpr="Contact Person Phone";
                Editable=ContactPPhoneEditable;
                ShowMandatory=True }

    { 1102755007;2;Field  ;
                SourceExpr="ContactPerson Relation";
                Editable=ContactPRelationEditable;
                ShowMandatory=True }

    { 1102755006;2;Field  ;
                SourceExpr="ContactPerson Occupation";
                Editable=ContactPOccupationEditable;
                ShowMandatory=True }

    { 1000000002;2;Field  ;
                SourceExpr=Picture;
                ShowMandatory=True }

    { 1000000004;2;Field  ;
                SourceExpr=Signature;
                ShowMandatory=True }

    { 1120054000;2;Field  ;
                SourceExpr="Front Side ID";
                ShowMandatory=True }

    { 1120054001;2;Field  ;
                SourceExpr="Back Side ID";
                ShowMandatory=True }

    { 1102755017;2;Field  ;
                SourceExpr="Received 1 Copy Of ID";
                Editable=CopyOFIDEditable;
                ShowMandatory=True }

    { 1000000007;2;Field  ;
                CaptionML=ENU=Received Member Registration Fee;
                SourceExpr="Member Registration Fee Receiv";
                Editable=RegistrationFeeEditable;
                ShowMandatory=True }

    { 10  ;2   ;Field     ;
                SourceExpr="Copy of KRA Pin";
                Editable=CopyofKRAPinEditable;
                ShowMandatory=True }

    { 1000000008;2;Field  ;
                SourceExpr="Created By" }

    { 1120054003;2;Field  ;
                SourceExpr="Approved By";
                Editable=FALSE }

    { 17  ;1   ;Group     ;
                CaptionML=ENU=Member Two Details;
                Visible=Jooint;
                GroupType=Group }

    { 16  ;2   ;Field     ;
                Name=Member Title;
                CaptionML=ENU=Title;
                SourceExpr=Title2;
                Editable=title2Editable;
                ShowMandatory=TRUE }

    { 15  ;2   ;Field     ;
                Name=Member Name;
                CaptionML=ENU=Name;
                SourceExpr="First member name";
                Editable=FistnameEditable;
                ShowMandatory=TRUE }

    { 14  ;2   ;Field     ;
                Name=ID/Passport No;
                SourceExpr="ID NO/Passport 2";
                Editable=passpoetEditable;
                ShowMandatory=TRUE }

    { 13  ;2   ;Field     ;
                Name=Member Gender;
                CaptionML=ENU=Gender;
                SourceExpr=Gender2;
                Editable=gender2editable;
                ShowMandatory=TRUE }

    { 21  ;2   ;Field     ;
                CaptionML=ENU=Marital Status;
                SourceExpr="Marital Status2";
                Editable=MaritalstatusEditable;
                ShowMandatory=true }

    { 20  ;2   ;Field     ;
                CaptionML=ENU=Date of Birth;
                SourceExpr="Date of Birth2";
                Editable=dateofbirth2;
                ShowMandatory=True }

    { 22  ;2   ;Field     ;
                CaptionML=ENU=Mobile No.;
                SourceExpr="Mobile No. 3";
                Editable=mobile3editable;
                ShowMandatory=true }

    { 23  ;2   ;Field     ;
                CaptionML=ENU=E-Mail Adress;
                SourceExpr="E-Mail (Personal2)";
                Editable=emailaddresEditable }

    { 24  ;2   ;Field     ;
                CaptionML=ENU=Physical Address;
                SourceExpr=Address3;
                Editable=address3Editable }

    { 25  ;2   ;Field     ;
                CaptionML=ENU=" Postal Code";
                SourceExpr="Home Postal Code2";
                Editable=HomePostalCode2Editable }

    { 26  ;2   ;Field     ;
                CaptionML=ENU=Town;
                SourceExpr="Home Town2";
                Editable=town2Editable }

    { 27  ;2   ;Field     ;
                CaptionML=ENU=Payroll/Staff No;
                SourceExpr="Payroll/Staff No2";
                Editable=payrollno2editable }

    { 28  ;2   ;Field     ;
                CaptionML=ENU=Employer Code;
                SourceExpr="Employer Code2" }

    { 29  ;2   ;Field     ;
                CaptionML=ENU=Employer Name;
                SourceExpr="Employer Name2";
                Editable=Employername2Editable }

    { 12  ;2   ;Field     ;
                Name=Image;
                CaptionML=ENU=Picture;
                SourceExpr="Picture 2";
                Editable=Picture2Editable;
                ShowMandatory=true }

    { 11  ;2   ;Field     ;
                Name=Valid Signature;
                CaptionML=ENU=Signature;
                SourceExpr="Signature  2";
                Editable=Signature2Editable;
                ShowMandatory=true }

    { 1120054004;1;Group  ;
                CaptionML=ENU=Employment Information;
                GroupType=Group }

    { 1120054005;2;Field  ;
                SourceExpr="Employment Type" }

    { 8   ;2   ;Field     ;
                SourceExpr="Employer Code";
                Editable=EmployerCodeEditable;
                ShowMandatory=True }

    { 1102755014;2;Field  ;
                SourceExpr="Employer Name" }

    { 1102755045;2;Field  ;
                SourceExpr=Designation;
                ShowMandatory=True }

    { 1120054006;2;Field  ;
                SourceExpr=County }

    { 1120054007;2;Field  ;
                SourceExpr="Sub-County" }

    { 31  ;2   ;Field     ;
                SourceExpr="Work Station";
                Editable=WorkstationEditable;
                ShowMandatory=True }

    { 1120054008;2;Field  ;
                SourceExpr="Terms of Employment" }

    { 1120054009;2;Field  ;
                SourceExpr="Contract Expiry Date" }

    { 1120054013;2;Field  ;
                Name=*****Self Employed********* }

    { 1120054012;2;Field  ;
                SourceExpr="Nature of Business" }

    { 1120054011;2;Field  ;
                SourceExpr="Name of Business" }

    { 1120054010;2;Field  ;
                SourceExpr="Office Telephone No." }

    { 1906634201;1;Group  ;
                CaptionML=ENU=Other Information }

    { 1120054016;2;Field  ;
                SourceExpr="Registration Fee Paid" }

    { 1102755012;2;Field  ;
                SourceExpr="Monthly Contribution";
                Editable=MonthlyContributionEdit;
                ShowMandatory=True }

    { 1102755029;2;Field  ;
                SourceExpr=Department;
                Editable=DeptEditable;
                ShowMandatory=True }

    { 1102755049;2;Field  ;
                SourceExpr=Status;
                Editable=StatusEditable;
                OnValidate=BEGIN
                                           UpdateControls();
                           END;

                ShowMandatory=True }

    { 1102755073;2;Field  ;
                SourceExpr="Customer Posting Group";
                Editable=CustPostingGroupEdit }

    { 1102755043;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=GlobalDim1Editable }

    { 1102755004;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Editable=GlobalDim2Editable }

    { 1000000006;2;Field  ;
                SourceExpr="Sms Notification" }

  }
  CODE
  {
    VAR
      StatusPermissions@1102755000 : Record 51516310;
      Cust@1102755001 : Record 51516223;
      Accounts@1102755002 : Record 23;
      AcctNo@1102755003 : Code[20];
      NextOfKinApp@1102755004 : Record 51516221;
      NextofKinFOSA@1102755005 : Record 51516225;
      AccountSign@1102755012 : Record 51516226;
      AccountSignApp@1102755011 : Record 51516222;
      Acc@1102755010 : Record 23;
      UsersID@1102755009 : Record 2000000120;
      Nok@1102755008 : Record 51516221;
      NOKBOSA@1102755006 : Record 51516225;
      BOSAACC@1102755007 : Code[20];
      NextOfKin@1102755013 : Record 51516225;
      PictureExists@1102755014 : Boolean;
      text001@1102755016 : TextConst 'ENU=Status must be open';
      UserMgt@1012 : Codeunit 5700;
      Notification@1011 : Codeunit 400;
      NotificationE@1010 : Codeunit 397;
      MailBody@1009 : Text[250];
      ccEmail@1008 : Text[1000];
      toEmail@1007 : Text[1000];
      GenSetUp@1006 : Record 51516257;
      ClearingAcctNo@1005 : Code[20];
      AdvrAcctNo@1004 : Code[20];
      DocumentType@1102755017 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      AccountTypes@1001 : Record 51516295;
      DivAcctNo@1000 : Code[20];
      NameEditable@1102755015 : Boolean;
      AddressEditable@1102755018 : Boolean;
      NoEditable@1102755045 : Boolean;
      DioceseEditable@1102755046 : Boolean;
      HomeAdressEditable@1102755047 : Boolean;
      GlobalDim1Editable@1102755019 : Boolean;
      GlobalDim2Editable@1102755020 : Boolean;
      CustPostingGroupEdit@1102755021 : Boolean;
      PhoneEditable@1102755022 : Boolean;
      MaritalstatusEditable@1102755023 : Boolean;
      IDNoEditable@1102755024 : Boolean;
      RegistrationDateEdit@1102755025 : Boolean;
      OfficeBranchEditable@1102755026 : Boolean;
      DeptEditable@1102755027 : Boolean;
      SectionEditable@1102755028 : Boolean;
      OccupationEditable@1102755029 : Boolean;
      DesignationEdiatble@1102755030 : Boolean;
      EmployerCodeEditable@1102755031 : Boolean;
      DOBEditable@1102755032 : Boolean;
      EmailEdiatble@1102755033 : Boolean;
      StaffNoEditable@1102755034 : Boolean;
      GenderEditable@1102755035 : Boolean;
      MonthlyContributionEdit@1102755036 : Boolean;
      PostCodeEditable@1102755037 : Boolean;
      CityEditable@1102755038 : Boolean;
      WitnessEditable@1102755039 : Boolean;
      StatusEditable@1102755040 : Boolean;
      BankCodeEditable@1000000002 : Boolean;
      BranchCodeEditable@1000000001 : Boolean;
      BankAccountNoEditable@1000000000 : Boolean;
      VillageResidence@1102755041 : Boolean;
      SignatureExists@1102755042 : Boolean;
      NewMembNo@1102755043 : Code[30];
      Saccosetup@1102755044 : Record 51516258;
      NOkApp@1102755048 : Record 51516221;
      TitleEditable@1000000003 : Boolean;
      PostalCodeEditable@1000000004 : Boolean;
      HomeAddressPostalCodeEditable@1000000006 : Boolean;
      HomeTownEditable@1000000007 : Boolean;
      RecruitedEditable@1000000008 : Boolean;
      ContactPEditable@1000000009 : Boolean;
      ContactPRelationEditable@1000000010 : Boolean;
      ContactPOccupationEditable@1000000011 : Boolean;
      CopyOFIDEditable@1000000012 : Boolean;
      CopyofPassportEditable@1000000013 : Boolean;
      SpecimenEditable@1000000014 : Boolean;
      ContactPPhoneEditable@1000000005 : Boolean;
      PictureEditable@1000000015 : Boolean;
      SignatureEditable@1000000016 : Boolean;
      PayslipEditable@1000000017 : Boolean;
      RegistrationFeeEditable@1000000018 : Boolean;
      CopyofKRAPinEditable@1021 : Boolean;
      membertypeEditable@1020 : Boolean;
      FistnameEditable@1019 : Boolean;
      dateofbirth2@1016 : Boolean;
      registrationeditable@1015 : Boolean;
      EstablishdateEditable@1014 : Boolean;
      RegistrationofficeEditable@1013 : Boolean;
      Signature2Editable@1003 : Boolean;
      Picture2Editable@1002 : Boolean;
      MembApp@1022 : Record 51516220;
      title2Editable@1032 : Boolean;
      mobile3editable@1030 : Boolean;
      emailaddresEditable@1029 : Boolean;
      gender2editable@1028 : Boolean;
      postal2Editable@1027 : Boolean;
      town2Editable@1026 : Boolean;
      passpoetEditable@1025 : Boolean;
      maritalstatus2Editable@1024 : Boolean;
      payrollno2editable@1023 : Boolean;
      Employercode2Editable@1031 : Boolean;
      address3Editable@1017 : Boolean;
      HomePostalCode2Editable@1018 : Boolean;
      Employername2Editable@1033 : Boolean;
      ageEditable@1034 : Boolean;
      CopyofconstitutionEditable@1035 : Boolean;
      Table_id@1038 : Integer;
      Doc_No@1037 : Code[20];
      Doc_Type@1036 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,Account Opening';
      ApprovalsMgmt@1000000019 : Codeunit 1535;
      IncrementNo@1000000032 : Code[20];
      MpesaAppH@1000000031 : Record 51516330;
      MpesaAppD@1000000030 : Record 51516332;
      MpesaAppNo@1000000029 : Code[20];
      ATMApp@1000000028 : Record 51516321;
      MpesaMob@1000000027 : Boolean;
      MpesaCop@1000000026 : Boolean;
      CompInfo@1000000025 : Record 79;
      SMSMessage@1000000024 : Record 51516329;
      iEntryNo@1000000023 : Integer;
      SourceOfFunds@1000000022 : Boolean;
      RespCenter@1000000021 : Boolean;
      ShareCapContr@1000000020 : Boolean;
      AccoutTypes@1000000035 : Record 51516295;
      Mtype@1000000034 : Boolean;
      TaxExemp@1000000033 : Boolean;
      AccountCategory@1000000037 : Boolean;
      DimensionValue@1000000036 : Record 349;
      Dates@1000000038 : Codeunit 51516005;
      DAge@1000000039 : Text[100];
      Jooint@1000000040 : Boolean;
      WorkstationEditable@1000000041 : Boolean;
      AuditTrail@1120054002 : Codeunit 51516107;
      Trail@1120054001 : Record 51516655;
      EntryNo@1120054000 : Integer;
      UserSetup@1120054003 : Record 91;

    PROCEDURE UpdateControls@1102755003();
    BEGIN


           //Account types.
           IF "Account Category"="Account Category"::Single THEN BEGIN
           NameEditable:=TRUE;
           AddressEditable:=TRUE;
           GlobalDim1Editable:=FALSE;
           GlobalDim2Editable:=TRUE;
           CustPostingGroupEdit:=FALSE;
           PhoneEditable:=TRUE;
           MaritalstatusEditable:=TRUE;
           IDNoEditable:=TRUE;
           PhoneEditable:=TRUE;
           RegistrationDateEdit:=TRUE;
           OfficeBranchEditable:=TRUE;
           DeptEditable:=TRUE;
           SectionEditable:=TRUE;
           OccupationEditable:=TRUE;
           DesignationEdiatble:=TRUE;
           EmployerCodeEditable:=TRUE;
           DOBEditable:=TRUE;
           EmailEdiatble:=TRUE;
           StaffNoEditable:=TRUE;
           GenderEditable:=TRUE;
           MonthlyContributionEdit:=TRUE;
           PostCodeEditable:=TRUE;
           CityEditable:=TRUE;
           WitnessEditable:=TRUE;
           BankCodeEditable:=TRUE;
           BranchCodeEditable:=TRUE;
           BankAccountNoEditable:=TRUE;
           VillageResidence:=TRUE;
           TitleEditable:=TRUE;
           PostalCodeEditable:=TRUE;
           HomeAddressPostalCodeEditable:=TRUE;
           HomeTownEditable:=TRUE;
           RecruitedEditable:=TRUE;
           ContactPEditable:=TRUE;
           ContactPRelationEditable:=TRUE;
           ContactPOccupationEditable:=TRUE;
           CopyOFIDEditable:=TRUE;
           CopyofPassportEditable:=TRUE;
           SpecimenEditable:=TRUE;
           ContactPPhoneEditable:=TRUE;
           HomeAdressEditable:=TRUE;
           PictureEditable:=TRUE;
           SignatureEditable:=TRUE;
           PayslipEditable:=TRUE;
           RegistrationFeeEditable:=TRUE;
           CopyofKRAPinEditable:=TRUE;
            membertypeEditable:=TRUE;
            WorkstationEditable:=TRUE;
           FistnameEditable:=FALSE;
           registrationeditable:=FALSE;
           EstablishdateEditable:=FALSE;
           RegistrationofficeEditable:=FALSE;
           Picture2Editable:=TRUE;
           Signature2Editable:=FALSE;
           title2Editable:=FALSE;
           emailaddresEditable:=FALSE;
          gender2editable:=FALSE;
           HomePostalCode2Editable:=FALSE;
          town2Editable:=FALSE;
          passpoetEditable:=FALSE;
         maritalstatus2Editable:=FALSE;
          payrollno2editable:=FALSE;
          Employercode2Editable:=FALSE;
          address3Editable:=FALSE;
          Employername2Editable:=FALSE;
          ageEditable:=FALSE;
          CopyofconstitutionEditable:=FALSE;



      END;
           IF "Account Category"="Account Category"::Group THEN BEGIN
           NameEditable:=TRUE;
           AddressEditable:=TRUE;
           GlobalDim1Editable:=FALSE;
           GlobalDim2Editable:=TRUE;
           CustPostingGroupEdit:=FALSE;
           PhoneEditable:=TRUE;
           MaritalstatusEditable:=FALSE;
           IDNoEditable:=FALSE;
           PhoneEditable:=TRUE;
           RegistrationDateEdit:=TRUE;
           OfficeBranchEditable:=TRUE;
           DeptEditable:=FALSE;
           SectionEditable:=FALSE;
           OccupationEditable:=FALSE;
           DesignationEdiatble:=FALSE;
           EmployerCodeEditable:=FALSE;
           DOBEditable:=FALSE;
           EmailEdiatble:=TRUE;
           WorkstationEditable:=TRUE;
           StaffNoEditable:=FALSE;
           GenderEditable:=FALSE;
           MonthlyContributionEdit:=TRUE;
           PostCodeEditable:=TRUE;
           CityEditable:=TRUE;
           WitnessEditable:=TRUE;
           BankCodeEditable:=TRUE;
           BranchCodeEditable:=TRUE;
           BankAccountNoEditable:=TRUE;
           VillageResidence:=TRUE;
           TitleEditable:=FALSE;
           PostalCodeEditable:=TRUE;
           HomeAddressPostalCodeEditable:=TRUE;
           HomeTownEditable:=TRUE;
           RecruitedEditable:=TRUE;
           ContactPEditable:=TRUE;
           ContactPRelationEditable:=TRUE;
           ContactPOccupationEditable:=TRUE;
           CopyOFIDEditable:=TRUE;
           CopyofPassportEditable:=TRUE;
           SpecimenEditable:=TRUE;
           ContactPPhoneEditable:=TRUE;
           HomeAdressEditable:=TRUE;
           PictureEditable:=TRUE;
           SignatureEditable:=FALSE;
           PayslipEditable:=FALSE;
           RegistrationFeeEditable:=TRUE;
           CopyofKRAPinEditable:=TRUE;
            membertypeEditable:=TRUE;
           registrationeditable:=TRUE;
           EstablishdateEditable:=TRUE;
           RegistrationofficeEditable:=TRUE;
           Picture2Editable:=FALSE;
           Signature2Editable:=FALSE;
           FistnameEditable:=FALSE;
           registrationeditable:=TRUE;
           EstablishdateEditable:=TRUE;
           RegistrationofficeEditable:=TRUE;
           Picture2Editable:=TRUE;
           Signature2Editable:=FALSE;
           title2Editable:=FALSE;
           emailaddresEditable:=FALSE;
          gender2editable:=FALSE;
           HomePostalCode2Editable:=FALSE;
          town2Editable:=FALSE;
          passpoetEditable:=FALSE;
         maritalstatus2Editable:=FALSE;
          payrollno2editable:=FALSE;
          Employercode2Editable:=FALSE;
          address3Editable:=FALSE;
          Employername2Editable:=FALSE;
          CopyofconstitutionEditable:=TRUE;



           END ;
           //Account types.
           IF "Account Category"="Account Category"::Joint THEN BEGIN
           NameEditable:=TRUE;
           AddressEditable:=TRUE;
           GlobalDim1Editable:=FALSE;
           GlobalDim2Editable:=TRUE;
           CustPostingGroupEdit:=FALSE;
           PhoneEditable:=TRUE;
           MaritalstatusEditable:=TRUE;
           IDNoEditable:=TRUE;
           PhoneEditable:=TRUE;
           RegistrationDateEdit:=TRUE;
           OfficeBranchEditable:=TRUE;
           DeptEditable:=TRUE;
           SectionEditable:=TRUE;
           WorkstationEditable:=TRUE;
           OccupationEditable:=TRUE;
           DesignationEdiatble:=TRUE;
           EmployerCodeEditable:=TRUE;
           DOBEditable:=TRUE;
           EmailEdiatble:=TRUE;
           StaffNoEditable:=TRUE;
           GenderEditable:=TRUE;
           MonthlyContributionEdit:=TRUE;
           PostCodeEditable:=TRUE;
           CityEditable:=TRUE;
           WitnessEditable:=TRUE;
           BankCodeEditable:=TRUE;
           BranchCodeEditable:=TRUE;
           BankAccountNoEditable:=TRUE;
           VillageResidence:=TRUE;
           TitleEditable:=FALSE;
           PostalCodeEditable:=TRUE;
           HomeAddressPostalCodeEditable:=TRUE;
           HomeTownEditable:=TRUE;
           RecruitedEditable:=TRUE;
           ContactPEditable:=TRUE;
           ContactPRelationEditable:=TRUE;
           ContactPOccupationEditable:=TRUE;
           CopyOFIDEditable:=TRUE;
           CopyofPassportEditable:=TRUE;
           SpecimenEditable:=TRUE;
           ContactPPhoneEditable:=TRUE;
           HomeAdressEditable:=TRUE;
           PictureEditable:=TRUE;
           SignatureEditable:=TRUE;
           PayslipEditable:=TRUE;
           RegistrationFeeEditable:=TRUE;
           CopyofKRAPinEditable:=TRUE;
           membertypeEditable:=TRUE;
           FistnameEditable:=TRUE;
           registrationeditable:=TRUE;
           EstablishdateEditable:=TRUE;
           RegistrationofficeEditable:=TRUE;
           Picture2Editable:=TRUE;
           Signature2Editable:=TRUE;
           registrationeditable:=TRUE;
           EstablishdateEditable:=TRUE;
           RegistrationofficeEditable:=TRUE;
           Picture2Editable:=TRUE;
           Signature2Editable:=TRUE;
           title2Editable:=TRUE;
           emailaddresEditable:=TRUE;
          gender2editable:=TRUE;
           HomePostalCode2Editable:=TRUE;
          town2Editable:=TRUE;
          passpoetEditable:=TRUE;
         maritalstatus2Editable:=TRUE;
          payrollno2editable:=TRUE;
          Employercode2Editable:=TRUE;
          address3Editable:=TRUE;
          Employername2Editable:=TRUE;
           mobile3editable:=TRUE;
          CopyofconstitutionEditable:=TRUE;
          IDNoEditable:=TRUE;
          dateofbirth2:=TRUE


              END;
      //corporate account.
           IF "Account Category"="Account Category"::Corporate THEN BEGIN
           NameEditable:=TRUE;
           AddressEditable:=TRUE;
           GlobalDim1Editable:=TRUE;
           GlobalDim2Editable:=TRUE;
           CustPostingGroupEdit:=FALSE;
           PhoneEditable:=TRUE;
           MaritalstatusEditable:=FALSE;
           IDNoEditable:=FALSE;
           PhoneEditable:=TRUE;
           RegistrationDateEdit:=TRUE;
           OfficeBranchEditable:=TRUE;
           DeptEditable:=FALSE;
           SectionEditable:=FALSE;
           OccupationEditable:=FALSE;
           DesignationEdiatble:=FALSE;
           EmployerCodeEditable:=FALSE;
           WorkstationEditable:=TRUE;
           DOBEditable:=FALSE;
           EmailEdiatble:=TRUE;
           StaffNoEditable:=FALSE;
           GenderEditable:=FALSE;
           MonthlyContributionEdit:=TRUE;
           PostCodeEditable:=TRUE;
           CityEditable:=TRUE;
           WitnessEditable:=TRUE;
           BankCodeEditable:=TRUE;
           BranchCodeEditable:=TRUE;
           BankAccountNoEditable:=TRUE;
           VillageResidence:=TRUE;
           TitleEditable:=FALSE;
           PostalCodeEditable:=TRUE;
           HomeAddressPostalCodeEditable:=TRUE;
           HomeTownEditable:=TRUE;
           RecruitedEditable:=TRUE;
           ContactPEditable:=TRUE;
           ContactPRelationEditable:=TRUE;
           ContactPOccupationEditable:=TRUE;
           CopyOFIDEditable:=TRUE;
           CopyofPassportEditable:=TRUE;
           SpecimenEditable:=TRUE;
           ContactPPhoneEditable:=TRUE;
           HomeAdressEditable:=TRUE;
           PictureEditable:=TRUE;
           SignatureEditable:=FALSE;
           PayslipEditable:=FALSE;
           RegistrationFeeEditable:=TRUE;
           CopyofKRAPinEditable:=TRUE;
            membertypeEditable:=TRUE;
           FistnameEditable:=FALSE;
           registrationeditable:=TRUE;
           EstablishdateEditable:=TRUE;
           RegistrationofficeEditable:=TRUE;
           Picture2Editable:=FALSE;
           Signature2Editable:=FALSE;
           title2Editable:=FALSE;
           emailaddresEditable:=FALSE;
          gender2editable:=FALSE;
           HomePostalCode2Editable:=FALSE;
          town2Editable:=FALSE;
          passpoetEditable:=FALSE;
         maritalstatus2Editable:=FALSE;
          payrollno2editable:=FALSE;
          Employercode2Editable:=FALSE;
          address3Editable:=FALSE;
          Employername2Editable:=FALSE;
          CopyofconstitutionEditable:=TRUE;




           END ;

      IF Status=Status::Approved THEN BEGIN
           NameEditable:=FALSE;
           NoEditable:=FALSE;
           AddressEditable:=FALSE;
           GlobalDim1Editable:=FALSE;
           GlobalDim2Editable:=FALSE;
           CustPostingGroupEdit:=FALSE;
           PhoneEditable:=FALSE;
           MaritalstatusEditable:=FALSE;
           IDNoEditable:=FALSE;
           PhoneEditable:=FALSE;
           RegistrationDateEdit:=FALSE;
           OfficeBranchEditable:=FALSE;
           DeptEditable:=FALSE;
           SectionEditable:=FALSE;
           WorkstationEditable:=FALSE;
           OccupationEditable:=FALSE;
           DesignationEdiatble:=FALSE;
           EmployerCodeEditable:=FALSE;
           DOBEditable:=FALSE;
           EmailEdiatble:=FALSE;
           StaffNoEditable:=FALSE;
           GenderEditable:=FALSE;
           MonthlyContributionEdit:=FALSE;
           PostCodeEditable:=FALSE;
           CityEditable:=FALSE;
           WitnessEditable:=FALSE;
           BankCodeEditable:=FALSE;
           BranchCodeEditable:=FALSE;
           BankAccountNoEditable:=FALSE;
           VillageResidence:=FALSE;
           TitleEditable:=FALSE;
           PostalCodeEditable:=FALSE;
           HomeAddressPostalCodeEditable:=FALSE;
           HomeTownEditable:=FALSE;
           RecruitedEditable:=FALSE;
           ContactPEditable:=FALSE;
           ContactPRelationEditable:=FALSE;
           ContactPOccupationEditable:=FALSE;
           CopyOFIDEditable:=FALSE;
           CopyofPassportEditable:=FALSE;
           SpecimenEditable:=FALSE;
           ContactPPhoneEditable:=FALSE;
           HomeAdressEditable:=FALSE;
           PictureEditable:=FALSE;
           SignatureEditable:=FALSE;
           PayslipEditable:=FALSE;
           RegistrationFeeEditable:=FALSE;
           title2Editable:=FALSE;
           emailaddresEditable:=FALSE;
          gender2editable:=FALSE;
           HomePostalCode2Editable:=FALSE;
          town2Editable:=FALSE;
          passpoetEditable:=FALSE;
         maritalstatus2Editable:=FALSE;
          payrollno2editable:=FALSE;
          Employercode2Editable:=FALSE;
          address3Editable:=FALSE;
          Employername2Editable:=FALSE;
          ageEditable:=FALSE;
          CopyofconstitutionEditable:=FALSE;

           END;
           IF Status=Status::Pending THEN BEGIN
           NameEditable:=FALSE;
           NoEditable:=FALSE;
           AddressEditable:=FALSE;
           GlobalDim1Editable:=FALSE;
           GlobalDim2Editable:=FALSE;
           CustPostingGroupEdit:=FALSE;
           PhoneEditable:=FALSE;
           WorkstationEditable:=FALSE;
           MaritalstatusEditable:=FALSE;
           IDNoEditable:=FALSE;
           PhoneEditable:=FALSE;
           RegistrationDateEdit:=FALSE;
           OfficeBranchEditable:=FALSE;
           DeptEditable:=FALSE;
           SectionEditable:=FALSE;
           OccupationEditable:=FALSE;
           DesignationEdiatble:=FALSE;
           EmployerCodeEditable:=FALSE;
           DOBEditable:=FALSE;
           EmailEdiatble:=FALSE;
           StaffNoEditable:=FALSE;
           GenderEditable:=FALSE;
           MonthlyContributionEdit:=FALSE;
           PostCodeEditable:=FALSE;
           CityEditable:=FALSE;
           WitnessEditable:=FALSE;
           BankCodeEditable:=FALSE;
           BranchCodeEditable:=FALSE;
           BankAccountNoEditable:=FALSE;
           VillageResidence:=FALSE;
           TitleEditable:=FALSE;
           PostalCodeEditable:=FALSE;
           HomeAddressPostalCodeEditable:=FALSE;
           HomeTownEditable:=FALSE;
           RecruitedEditable:=FALSE;
           ContactPEditable:=FALSE;
           ContactPRelationEditable:=FALSE;
           ContactPOccupationEditable:=FALSE;
           CopyOFIDEditable:=FALSE;
           CopyofPassportEditable:=FALSE;
           SpecimenEditable:=FALSE;
           ContactPPhoneEditable:=FALSE;
           HomeAdressEditable:=FALSE;
           PictureEditable:=FALSE;
           SignatureEditable:=FALSE;
           PayslipEditable:=FALSE;
           RegistrationFeeEditable:=FALSE;
           title2Editable:=FALSE;
           emailaddresEditable:=FALSE;
          gender2editable:=FALSE;
           HomePostalCode2Editable:=FALSE;
          town2Editable:=FALSE;
          passpoetEditable:=FALSE;
         maritalstatus2Editable:=FALSE;
          payrollno2editable:=FALSE;
          Employercode2Editable:=FALSE;
          address3Editable:=FALSE;
          Employername2Editable:=FALSE;
          ageEditable:=FALSE;
          CopyofconstitutionEditable:=FALSE;



           END;


           IF Status=Status::Open THEN BEGIN
           NameEditable:=TRUE;
           AddressEditable:=TRUE;
           GlobalDim1Editable:=FALSE;
           GlobalDim2Editable:=TRUE;
           CustPostingGroupEdit:=FALSE;
           PhoneEditable:=TRUE;
           WorkstationEditable:=TRUE;
           MaritalstatusEditable:=TRUE;
           IDNoEditable:=TRUE;
           PhoneEditable:=TRUE;
           RegistrationDateEdit:=TRUE;
           OfficeBranchEditable:=TRUE;
           DeptEditable:=TRUE;
           SectionEditable:=TRUE;
           OccupationEditable:=TRUE;
           DesignationEdiatble:=TRUE;
           EmployerCodeEditable:=TRUE;
           DOBEditable:=TRUE;
           EmailEdiatble:=TRUE;
           StaffNoEditable:=TRUE;
           GenderEditable:=TRUE;
           MonthlyContributionEdit:=TRUE;
           PostCodeEditable:=TRUE;
           CityEditable:=TRUE;
           WitnessEditable:=TRUE;
           BankCodeEditable:=TRUE;
           BranchCodeEditable:=TRUE;
           BankAccountNoEditable:=TRUE;
           VillageResidence:=TRUE;
           TitleEditable:=TRUE;
           PostalCodeEditable:=TRUE;
           HomeAddressPostalCodeEditable:=TRUE;
           HomeTownEditable:=TRUE;
           RecruitedEditable:=TRUE;
           ContactPEditable:=TRUE;
           ContactPRelationEditable:=TRUE;
           ContactPOccupationEditable:=TRUE;
           CopyOFIDEditable:=TRUE;
           CopyofPassportEditable:=TRUE;
           SpecimenEditable:=TRUE;
           ContactPPhoneEditable:=TRUE;
           HomeAdressEditable:=TRUE;
           PictureEditable:=TRUE;
           SignatureEditable:=TRUE;
           PayslipEditable:=TRUE;
           RegistrationFeeEditable:=TRUE;
           title2Editable:=TRUE;
           emailaddresEditable:=TRUE;
          gender2editable:=TRUE;
           HomePostalCode2Editable:=TRUE;
          town2Editable:=TRUE;
          passpoetEditable:=TRUE;
         maritalstatus2Editable:=TRUE;
          payrollno2editable:=TRUE;
          Employercode2Editable:=TRUE;
          address3Editable:=TRUE;
          Employername2Editable:=TRUE;
          ageEditable:=FALSE;
          mobile3editable:=TRUE;
          CopyofconstitutionEditable:=TRUE;

           END;
    END;

    PROCEDURE SendSMS@1000000000();
    VAR
    ;
    BEGIN

      GenSetUp.GET;
      CompInfo.GET;

      IF GenSetUp."Send SMS Notifications"=TRUE THEN BEGIN


      //SMS MESSAGE
      SMSMessage.RESET;
      IF SMSMessage.FIND('+') THEN BEGIN
      iEntryNo:=SMSMessage."Entry No";
      iEntryNo:=iEntryNo+1;
      END
      ELSE BEGIN
      iEntryNo:=1;
      END;


      SMSMessage.INIT;
      SMSMessage."Entry No":=iEntryNo;
      SMSMessage."Batch No":="No.";
      SMSMessage."Document No":='';
      SMSMessage."Account No":="Phone No.";
      SMSMessage."Date Entered":=TODAY;
      SMSMessage."Time Entered":=TIME;
      SMSMessage.Source:='MEMBAPP';
      SMSMessage."Entered By":=USERID;
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      SMSMessage."SMS Message":='Dear Member you have been registered successfully, your Membership No is '
      + BOSAACC+' Name '+Name+' ' +CompInfo.Name+' '+GenSetUp."Customer Care No";
      SMSMessage."Telephone No":="Phone No.";
      IF "Phone No."<>'' THEN
      SMSMessage.INSERT;

      END;
      COMMIT();
    END;

    PROCEDURE SendMail@1000000001();
    BEGIN

      GenSetUp.GET;

      IF GenSetUp."Send Email Notifications" = TRUE THEN BEGIN

      Notification.CreateMessage('Dynamics NAV',GenSetUp."Sender Address","E-Mail (Personal)",'Member Acceptance Notification',
                      'Member application '+ BOSAACC + ' has been approved'
                     + ' (Dynamics NAV ERP)',FALSE);

      Notification.Send;

      END;
    END;

    BEGIN
    END.
  }
}

