OBJECT page 172111 MC Individual Application List
{
  OBJECT-PROPERTIES
  {
    Date=08/02/16;
    Time=[ 1:00:22 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516220;
    SourceTableView=WHERE(Account Category=FILTER(<>Group),
                          Group Account=FILTER(No),
                          Customer Posting Group=FILTER(MICRO),
                          Source=CONST(Micro));
    PageType=List;
    CardPageID=MC Individual Application Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755022;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755020;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1102755010;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN

                                 {DocumentType:=DocumentType::"Account Opening";
                                 ApprovalEntries.Setfilters(DATABASE::"Member Application",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                                 }
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
                                 {IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                    ERROR('Member has already been created');
                                 END;
                                 END;}


                                 TESTFIELD(Picture);
                                 TESTFIELD(Signature);
                                 TESTFIELD("No. Series");
                                 //TESTFIELD("Employer Code");
                                 TESTFIELD("ID No.");
                                 TESTFIELD("Phone No.");
                                 TESTFIELD("Mobile Phone No");
                                 TESTFIELD("Payroll/Staff No");
                                 //TESTFIELD("E-Mail (Personal)");
                                 TESTFIELD("Customer Posting Group");
                                 TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");


                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);


                                 {NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-')=FALSE THEN
                                 ERROR(text002);
                                 }

                                 //End allocate batch number
                                 //IF Approvalmgt.SendAccOpeningRequest(Rec) THEN;
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
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {IF Status<>Status::Approved THEN
                                 ERROR('This application has not been approved');


                                 IF CONFIRM('Are you sure you want to create account application?',FALSE)=TRUE THEN BEGIN

                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                    ERROR('Member has already been created');
                                 END;
                                 END;

                                 //Create BOSA account
                                 Cust."No.":='';
                                 Cust.Name:=UPPERCASE(Name);
                                 Cust.Address:=Address;
                                 Cust."Post Code":="Post Code";
                                 Cust.City:=City;
                                 Cust.County:=City;
                                 Cust."Country/Region Code":="Country/Region Code";
                                 Cust."Force No.":="Force No.";
                                 Cust."Phone No.":="Phone No.";
                                 Cust."Global Dimension 1 Code":="Global Dimension 1 Code" ;
                                 Cust."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Cust."Customer Posting Group":="Customer Posting Group";
                                 Cust."Registration Date":=TODAY;//"Registration Date"; Registration date must be the day the application is converted to a member and not day of capture*****cyrus
                                 Cust.Status:=Cust.Status::Active;
                                 Cust."Employer Code":="Employer Code";
                                 Cust."Date of Birth":="Date of Birth";
                                 Cust."Station/Department":="Station/Department";
                                 Cust."E-Mail":="E-Mail (Personal)";
                                 Cust.Location:=Location;
                                 //**
                                 Cust."Office Branch":="Office Branch";
                                 Cust.Department:=Department;
                                 Cust.Occupation:=Occupation;
                                 Cust.Designation:=Designation;
                                 Cust."Bank Code":="Bank Code";
                                 Cust."Bank Branch Code":="Bank Name";
                                 Cust."Bank Account No.":="Bank Account No";
                                 //**
                                 Cust."Sub-Location":="Sub-Location";
                                 Cust.District:=District;
                                 Cust."Payroll/Staff No":="Payroll/Staff No";
                                 Cust."ID No.":="ID No.";
                                 Cust."Passport No.":="Passport No.";
                                 Cust."Business Loan Officer":="Salesperson Code";
                                 Cust."Mobile Phone No":="Mobile Phone No";
                                 Cust."Marital Status":="Marital Status";
                                 Cust."Customer Type":=Cust."Customer Type"::Member;
                                 Cust.Gender:=Gender;

                                 //CALCFIELDS(Signature,Picture);

                                 Cust."Monthly Contribution":="Monthly Contribution";
                                 Cust."Contact Person":="Contact Person";
                                 Cust."Contact Person Phone":="Contact Person Phone";
                                 Cust."ContactPerson Relation":="ContactPerson Relation";
                                 Cust."Recruited By":="Recruited By";
                                 Cust."Business Loan Officer":="Salesperson Code";
                                 Cust."ContactPerson Occupation":="ContactPerson Occupation";
                                 Cust."Village/Residence":="Village/Residence";
                                 Cust.INSERT(TRUE);
                                 //Cust.VALIDATE(Cust."ID No.");

                                 //CLEAR(Picture);
                                 //CLEAR(Signature);
                                 //MODIFY;


                                 ImageData."ID NO":="ID No.";
                                 ImageData.Picture:=Picture;
                                 ImageData.Signature:=Signature;
                                 ImageData.INSERT(TRUE);

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
                                   NextOfKin.Fax:=NextOfKinApp.Fax;
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
                                 "Created By":=USERID;
                                 MODIFY;

                                 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Send SMS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


                                    //ERROR('Sms Message');
                                    //SMS MESSAGE
                                   AccountSignatoriesApp.RESET;
                                   AccountSignatoriesApp.SETRANGE(AccountSignatoriesApp."Account No","No.");
                                   IF AccountSignatoriesApp.FIND('-') THEN BEGIN

                                   AccountSignatoriesApp.RESET;
                                   AccountSignatoriesApp.SETRANGE(AccountSignatoriesApp."Account No","No.");
                                   AccountSignatoriesApp.SETRANGE(AccountSignatoriesApp."Send SMS",FALSE);
                                   IF AccountSignatoriesApp.FIND('-') THEN BEGIN
                                    REPEAT

                                      //MESSAGE('Send sms to '+AccountSignatoriesApp."Account No");

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
                                     SMSMessage."Account No":="Payroll/Staff No";
                                     SMSMessage."Date Entered":=TODAY;
                                     SMSMessage."Time Entered":=TIME;
                                     SMSMessage.Source:='MEMBERACCOUNT';
                                     SMSMessage."Entered By":=USERID;
                                     SMSMessage."System Created Entry":=TRUE;
                                     SMSMessage."Document No":="No.";
                                     SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                     SMSMessage."SMS Message":=Name+' has been succesfuly created. MWALIMU SACCCO';
                                     SMSMessage."Telephone No":=AccountSignatoriesApp."Mobile Phone No.";
                                     SMSMessage.INSERT;

                                     AccountSignatoriesApp."Send SMS":=TRUE;
                                     AccountSignatoriesApp.MODIFY;

                                      UNTIL AccountSignatoriesApp.NEXT=0;
                                     END;
                                  END;



                                 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                 // SEND SMS




                                 END ELSE
                                 ERROR('Not approved');
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
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755005;2;Field  ;
                SourceExpr="Search Name" }

    { 1102755111;2;Field  ;
                SourceExpr="Responsibility Centre" }

    { 1000000000;2;Field  ;
                SourceExpr="Customer Type" }

    { 1000000001;2;Field  ;
                SourceExpr=Gender }

    { 1000000002;2;Field  ;
                SourceExpr=Category }

    { 1000000003;2;Field  ;
                SourceExpr="Bank Account No" }

    { 1000000004;2;Field  ;
                SourceExpr="Bank Name" }

    { 1000000005;2;Field  ;
                SourceExpr="Bank Code" }

    { 1000000017;2;Field  ;
                SourceExpr="BOSA Account No." }

    { 1000000006;2;Field  ;
                SourceExpr="Recruited By" }

    { 1000000007;2;Field  ;
                SourceExpr="Account Category" }

    { 1000000009;2;Field  ;
                SourceExpr="ID No." }

    { 1000000010;2;Field  ;
                SourceExpr="Mobile Phone No" }

    { 1000000011;2;Field  ;
                SourceExpr="Marital Status" }

    { 1000000012;2;Field  ;
                SourceExpr="Monthly Contribution" }

    { 1000000013;2;Field  ;
                SourceExpr="Employer Code" }

    { 1000000014;2;Field  ;
                SourceExpr="Date of Birth" }

    { 1000000015;2;Field  ;
                SourceExpr="E-Mail (Personal)" }

    { 1000000016;2;Field  ;
                SourceExpr=Source }

  }
  CODE
  {
    VAR
      text002@1102755028 : TextConst 'ENU=Kinldy specify the next of kin';

    BEGIN
    END.
  }
}

