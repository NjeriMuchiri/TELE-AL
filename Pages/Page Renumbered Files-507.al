OBJECT page 172102 Group Application Card
{
  OBJECT-PROPERTIES
  {
    Date=08/30/16;
    Time=11:16:21 AM;
    Modified=Yes;
    Version List=Micro FinanceV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516220;
    SourceTableView=WHERE(Account Category=CONST(Group));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnInit=BEGIN

             "Group Account":=TRUE;
             "Account Category":="Account Category"::Group;
             "Account Type":="Account Type"::Group;
           END;

    OnOpenPage=BEGIN
                 "Group Account":=TRUE;
                 "Account Category":="Account Category"::Group;
                 "Customer Posting Group":='MICRO';
                 "Global Dimension 1 Code":='MICRO';
                 VALIDATE("Global Dimension 1 Code");
                 "Account Type":="Account Type"::Group;



                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Centre",UserMgt.GetSalesFilter);
                   FILTERGROUP(0);
                 END;
               END;

    OnNewRecord=BEGIN

                  "Customer Type":="Customer Type"::MicroFinance;
                  "Group Account":=TRUE;
                  "Account Category":="Account Category"::Group;
                  "Account Type":="Account Type"::Group;
                  //Source:=Source::Micro;
                  "Customer Posting Group":='Micro';
                END;

    OnInsertRecord=BEGIN


                     "Responsibility Centre" := UserMgt.GetSalesFilter;
                     {
                     IF MemApp.COUNT >0 THEN BEGIN
                     ERROR(Text005);
                     END;
                     }
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
      { 1       ;2   ;Action    ;
                      Name=Next of Kin BOSA;
                      CaptionML=ENU=Nominee;
                      RunObject=page 17369;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1000000003;2 ;Action    ;
                      Name=Next of Kin Benevolent;
                      RunObject=Page 39003931;
                      RunPageLink=Field1=FIELD(No.);
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 2       ;2   ;Action    ;
                      Name=[Account Signatories ];
                      CaptionML=ENU=Signatories;
                      RunObject=page 17436;
                      RunPageOnRec=No;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Group;
                      PromotedCategory=Process }
      { 4       ;2   ;ActionGroup;
                      Name=Approvals;
                      CaptionML=ENU=- }
      { 3       ;2   ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 {DocumentType:=DocumentType::"Account Opening";
                                 ApprovalEntries.Setfilters(DATABASE::"Member Application",DocumentType,"No.");
                                 ApprovalEntries.RUN;}
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 Approvalmgt@1102755001 : Codeunit 439;
                               BEGIN
                                 IF Status=Status::Rejected THEN
                                  ERROR(Text001);

                                 GetSeUp.GET();
                                 IF "Account Type"<>"Account Type"::Group THEN
                                 ERROR('Business Account Type must Group');

                                 IF "FOSA Account Type"<>"FOSA Account Type" THEN
                                 ERROR('FOSA Account Type must be Group');

                                 IF "Group Account"=FALSE THEN
                                 ERROR('Group Account must be True');



                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                    ERROR('This Member has Already been Created');
                                 END;
                                 END;


                                 IF "Account Category"<>"Account Category"::Single THEN BEGIN
                                 AccountSignApp.RESET;
                                 AccountSignApp.SETRANGE(AccountSignApp."Account No","No.");
                                 IF AccountSignApp.FIND('-') THEN
                                 SignCount:=AccountSignApp.COUNT;
                                 END;
                                 {IF SignCount<> GetSeUp."Max. No. of Signatories" THEN
                                 ERROR(text003,GetSeUp."Max. No. of Signatories");}



                                 TESTFIELD("E-Mail (Personal)");
                                 TESTFIELD("Customer Posting Group");
                                 TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("Mobile Phone No");

                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);

                                 IF "Group Account"=FALSE THEN BEGIN
                                 NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-')=FALSE THEN
                                 ERROR(text002);
                                 END;

                                 IF "Group Account"=FALSE THEN BEGIN
                                 {IF "Insert Benevolent Next of Kin"=TRUE THEN BEGIN
                                 NextOfKinBenvApp.RESET;
                                 NextOfKinBenvApp.SETRANGE(NextOfKinBenvApp."Account No","No.");
                                 IF NextOfKinBenvApp.FIND('-')=FALSE THEN
                                 ERROR(Text004);
                                 END;}
                                 END;

                                 //End allocate batch number
                                 //IF Approvalmgt.SendAccOpeningRequest(Rec) THEN;
                                 Status:=Status::Approved;
                                 MODIFY;
                                 MESSAGE('Approved Successfully');
                               END;
                                }
      { 6       ;2   ;Action    ;
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
      { 7       ;2   ;Separator ;
                      CaptionML=ENU="       -" }
      { 1102755053;2 ;Action    ;
                      Name=Create Account;
                      CaptionML=ENU=Create Account;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Process;
                      OnAction=BEGIN


                                 IF Status<>Status::Approved THEN
                                 ERROR('This application has not been approved');


                                 IF CONFIRM('Are you sure you want to Create Account Application?',FALSE)=TRUE THEN BEGIN

                                 GenSetUp.GET;


                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                    ERROR('This Member Account has Already been Created');
                                 END;
                                 END;

                                 //****
                                 Dimen.RESET;
                                 Dimen.SETRANGE(Dimen.Code,"Global Dimension 2 Code");
                                 IF Dimen.FIND('-') THEN BEGIN
                                 IF "No." = '' THEN BEGIN
                                   Dimen.TESTFIELD(Dimen."No. Series");
                                   NoSeriesMgt.InitSeries(Dimen."No. Series",xRec."No. Series",0D,"No.","No. Series");

                                 END;
                                 END;

                                 //Create BOSA account
                                 Cust."No.":='';
                                 //Cust."Application Source":=Source;
                                 //Cust."Recruited By":="Salesperson Code";
                                 //Cust."Benevolent Fund No.":='';
                                 Cust.Name:=UPPERCASE(Name);
                                 Cust.Address:=Address;
                                 //Cust."Post Code":="Post Code";
                                 Cust.City:=City;
                                 Cust.County:=City;
                                 Cust."Country/Region Code":="Country/Region Code";
                                 //Cust."Force No.":="Force No.";
                                 Cust."Phone No.":="Phone No.";
                                 Cust."Global Dimension 1 Code":="Global Dimension 1 Code" ;
                                 Cust."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Cust."Customer Posting Group":="Customer Posting Group";
                                 Cust."Registration Date":=TODAY;//Registration date must be the day the application is converted to a member and not day of capture.
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
                                 //Cust."Bank Branch Code":="Bank Name";
                                 Cust."Bank Account No.":="Bank Account No";
                                 //**
                                 Cust."Sub-Location":="Sub-Location";
                                 Cust.District:=District;
                                 Cust."Payroll/Staff No":="Payroll/Staff No";
                                 Cust."ID No.":="ID No.";
                                 Cust."Passport No.":="Passport No.";
                                 //Cust."Business Loan Officer":="Salesperson Code";
                                 Cust."Mobile Phone No":="Mobile Phone No";
                                 Cust."Marital Status":="Marital Status";
                                 Cust."Customer Type":=Cust."Customer Type"::Member;
                                 Cust.Gender:=Gender;

                                 CALCFIELDS(Signature,Picture);

                                 Cust."Monthly Contribution":="Monthly Contribution";
                                 Cust."Account Category":="Account Category";
                                 Cust."Contact Person":="Contact Person";
                                 Cust."Contact Person Phone":="Contact Person Phone";
                                 Cust."ContactPerson Relation":="ContactPerson Relation";
                                 Cust."Recruited By":="Recruited By";
                                 //Cust."Business Loan Officer":="Salesperson Code";
                                 Cust."ContactPerson Occupation":="ContactPerson Occupation";
                                 Cust."Village/Residence":="Village/Residence";
                                 Cust."Group Account":="Group Account";
                                 Cust."Group Account No":=Cust."No.";
                                 Cust."Group Account Name":=Cust.Name;
                                 "Account Type":=Cust."Account Type";
                                 Cust."Recruited By":="Recruited By";
                                 //Cust."Loan Officer Name":="Recruited By Name";
                                 //Cust.//"Loan Officer Name":="Salesperson Name";
                                 //Cust.INSERT(TRUE);
                                 Cust.INSERT(TRUE);

                                 BOSAACC:=Cust."No.";

                                 Cust.RESET;
                                 IF Cust.GET(BOSAACC) THEN BEGIN
                                 Cust.VALIDATE(Cust.Name);
                                 Cust.VALIDATE(Cust."Global Dimension 1 Code");
                                 Cust.VALIDATE(Cust."Global Dimension 2 Code");
                                 Cust."Group Account No":=Cust."No.";
                                 Cust.MODIFY;
                                 END;


                                 AccountSignApp.RESET;
                                 AccountSignApp.SETRANGE(AccountSignApp."Account No","No.");
                                 IF AccountSignApp.FIND('-') THEN BEGIN

                                 REPEAT

                                 AccSignatories.INIT;

                                 AccSignatories."Account No":=BOSAACC;
                                 AccSignatories."BOSA No.":=AccountSignApp."BOSA No.";
                                 AccSignatories.Names:=AccountSignApp.Names;
                                 AccSignatories."Date Of Birth":=AccountSignApp."Date Of Birth";
                                 AccSignatories."Staff/Payroll":=AccountSignApp."Staff/Payroll";
                                 AccSignatories."ID No.":=AccountSignApp."ID No.";
                                 AccSignatories.Signatory:=AccountSignApp.Signatory;
                                 AccSignatories."Must Sign":=AccountSignApp."Must Sign";
                                 AccSignatories."Must be Present":=AccountSignApp."Must be Present";
                                 AccSignatories.Picture:=AccountSignApp.Picture;
                                 AccSignatories.Signature:=AccountSignApp.Signature;
                                 AccSignatories."Expiry Date":=AccountSignApp."Expiry Date";
                                 AccSignatories."Mobile Phone No.":=AccountSignApp."Mobile Phone No.";

                                 AccSignatories.INSERT;
                                 UNTIL AccountSignApp.NEXT=0;
                                 END;



                                   AccountSignatoriesApp.RESET;
                                   AccountSignatoriesApp.SETRANGE(AccountSignatoriesApp."Account No","No.");
                                   IF AccountSignatoriesApp.FIND('-') THEN BEGIN

                                   AccountSignatoriesApp.RESET;
                                   AccountSignatoriesApp.SETRANGE(AccountSignatoriesApp."Account No","No.");
                                   AccountSignatoriesApp.SETRANGE(AccountSignatoriesApp."Send SMS",FALSE);
                                   IF AccountSignatoriesApp.FIND('-') THEN BEGIN
                                    REPEAT

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
                                     SMSMessage."SMS Message":=Name+' has been succesfuly created. 0709898000. MWALIMU SACCO';
                                     SMSMessage."Telephone No":=AccountSignatoriesApp."Mobile Phone No.";
                                     SMSMessage.INSERT;

                                     AccountSignatoriesApp."Send SMS":=TRUE;
                                     AccountSignatoriesApp.MODIFY;

                                 UNTIL AccountSignatoriesApp.NEXT=0;
                                 END;
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

                                 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                 //END;
                                 Status:=Status::Approved;
                                 "Created By":=USERID;
                                 MODIFY;
                                 END ELSE
                                 ERROR('Application Not approved');
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

    { 1102755003;2;Field  ;
                SourceExpr=Name;
                Editable=NameEditable }

    { 1102755006;2;Field  ;
                CaptionML=ENU=FOSA Account Category;
                SourceExpr="Account Category";
                Enabled=TRUE;
                Editable=False;
                OnValidate=BEGIN

                             BosaAccNoVisible:=TRUE;
                             FosaAccNoVisible:=TRUE;
                             MemCatVisible:=TRUE;
                             PayrollVisible:=TRUE;
                             IDNoVisible:=TRUE;
                             PassVisible:=TRUE;
                             MaritalVisible:=TRUE;
                             GenderVisible:=TRUE;
                             DoBVisible:=TRUE;
                             BenvVisible:=TRUE;
                             WstationVisible:=TRUE;
                             DeptVisible:=TRUE;
                             SecVisible:=TRUE;
                             OccpVisible:=TRUE;
                           END;
                            }

    { 1000000014;2;Field  ;
                CaptionML=ENU=Business Account Type;
                SourceExpr="Account Type";
                Editable=False }

    { 1000000015;2;Field  ;
                SourceExpr="Group Account";
                Editable=GroupAccEditable;
                OnValidate=BEGIN
                             TESTFIELD("Account Category","Account Category"::Group);
                           END;
                            }

    { 1000000018;2;Field  ;
                SourceExpr="BOSA Account No.";
                Visible=BosaAccNoVisible }

    { 1000000019;2;Field  ;
                SourceExpr="FOSA Account No.";
                Visible=FosaAccNoVisible;
                Enabled=FALSE }

    { 1102755017;2;Field  ;
                SourceExpr="Payroll/Staff No";
                Visible=PayrollVisible;
                Editable=StaffNoEditable }

    { 1102755019;2;Field  ;
                CaptionML=ENU=Certificate No.;
                SourceExpr="ID No.";
                Visible=TRUE;
                Editable=IDNoEditable }

    { 1000000005;2;Field  ;
                SourceExpr="Passport No.";
                Visible=PassVisible;
                Editable=PassEditable }

    { 1102755005;2;Field  ;
                SourceExpr=Address;
                Editable=AddressEditable }

    { 10  ;2   ;Field     ;
                SourceExpr=Cust."Post Code";
                Importance=Promoted;
                Editable=PostCodeEditable }

    { 11  ;2   ;Field     ;
                CaptionML=ENU=City;
                SourceExpr=City;
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr="Country/Region Code";
                Editable=CountryEditable }

    { 1102755009;2;Field  ;
                SourceExpr="Phone No.";
                Editable=PhoneEditable }

    { 1102755021;2;Field  ;
                SourceExpr="Mobile Phone No";
                Editable=PhoneEditable }

    { 1102755023;2;Field  ;
                SourceExpr="Marital Status";
                Visible=MaritalVisible;
                Editable=MaritalstatusEditable }

    { 1102755025;2;Field  ;
                SourceExpr=Gender;
                Visible=GenderVisible;
                Editable=GenderEditable }

    { 1102755039;2;Field  ;
                SourceExpr="Date of Birth";
                Visible=DoBVisible;
                Editable=DOBEditable }

    { 1102755041;2;Field  ;
                SourceExpr="E-Mail (Personal)";
                Editable=EmailEdiatble }

    { 1102755002;2;Field  ;
                SourceExpr="Village/Residence";
                Editable=VillageResidence }

    { 1102755015;2;Field  ;
                SourceExpr="Registration Date";
                Visible=FALSE;
                Editable=RegistrationDateEdit }

    { 1906634201;1;Group  ;
                CaptionML=ENU=Other Information }

    { 1000000007;2;Field  ;
                SourceExpr="Employer Code";
                Visible=false;
                Editable=EmployerEditable }

    { 1000000010;2;Field  ;
                SourceExpr="Bank Code";
                Visible=FALSE;
                Editable=BankAEditable;
                HideValue=TRUE }

    { 1000000011;2;Field  ;
                SourceExpr="Bank Name";
                Visible=FALSE }

    { 1000000012;2;Field  ;
                SourceExpr="Bank Account No";
                Visible=FALSE;
                Editable=BankNEditable }

    { 1102755027;2;Field  ;
                CaptionML=ENU=Work Station;
                SourceExpr="Office Branch";
                Visible=WstationVisible;
                Editable=OfficeBranchEditable }

    { 1102755029;2;Field  ;
                SourceExpr=Department;
                Visible=DeptVisible;
                Editable=DeptEditable }

    { 1102755031;2;Field  ;
                SourceExpr=Section;
                Visible=SecVisible;
                Editable=SectionEditable }

    { 1102755033;2;Field  ;
                SourceExpr=Occupation;
                Visible=OccpVisible;
                Editable=OccupationEditable }

    { 1102755049;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102755073;2;Field  ;
                SourceExpr="Customer Posting Group";
                Editable=FALSE }

    { 1102755043;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=TRUE }

    { 1102755004;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Editable=GlobalDim2Editable }

    { 1000000020;2;Field  ;
                CaptionML=ENU=Group Code;
                SourceExpr="Micro Group Code";
                Visible=false;
                Editable=FALSE }

    { 1000000002;2;Field  ;
                SourceExpr="FOSA Account Type";
                Visible=FALSE;
                Editable=true }

  }
  CODE
  {
    VAR
      StatusPermissions@1102755000 : Record 51516310;
      Cust@1102755001 : Record 51516223;
      Accounts@1102755002 : Record 23;
      AcctNo@1102755003 : Code[20];
      NextOfKinApp@1102755004 : Record 51516221;
      NextofKinFOSA@1102755005 : Record 51516293;
      AccountSign@1102755012 : Record 51516294;
      AccSignatories@1000000050 : Record 51516294;
      AccountSignApp@1102755011 : Record 51516292;
      GetSeUp@1000000047 : Record 51516257;
      Acc@1102755010 : Record 23;
      UsersID@1102755009 : Record 2000000120;
      Nok@1102755008 : Record 51516225;
      SignCount@1000000046 : Integer;
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
      ForceNo@1000000003 : Boolean;
      ContPhone@1000000004 : Boolean;
      ContRelation@1000000005 : Boolean;
      ContOcuppation@1000000006 : Boolean;
      Recruitedby@1000000007 : Boolean;
      PassEditable@1000000008 : Boolean;
      EmployerEditable@1000000009 : Boolean;
      CountryEditable@1000000010 : Boolean;
      SalesEditable@1000000011 : Boolean;
      text002@1102755043 : TextConst 'ENU=Kindly specify the next of kin';
      AccountCategory@1102755045 : Boolean;
      text003@1102755046 : TextConst 'ENU=No of Signatories cannot be less/More than %1';
      GetAccountType@1000000012 : Record 51516295;
      Text004@1000000014 : TextConst 'ENU=You MUST specify the next of kin Benevolent';
      CustMember@1000000016 : Record 51516223;
      "BenvNo."@1000000017 : Code[10];
      BankAEditable@1000000018 : Boolean;
      MemEditable@1000000019 : Boolean;
      BenvEditable@1000000020 : Boolean;
      BankNEditable@1000000021 : Boolean;
      InserFEditable@1000000022 : Boolean;
      FosAEditable@1000000023 : Boolean;
      Memb@1000000024 : Record 51516223;
      BosaAccNoVisible@1000000025 : Boolean;
      FosaAccNoVisible@1000000026 : Boolean;
      MemCatVisible@1000000027 : Boolean;
      PayrollVisible@1000000028 : Boolean;
      IDNoVisible@1000000029 : Boolean;
      PassVisible@1000000030 : Boolean;
      MaritalVisible@1000000031 : Boolean;
      GenderVisible@1000000032 : Boolean;
      DoBVisible@1000000033 : Boolean;
      BenvVisible@1000000034 : Boolean;
      WstationVisible@1000000035 : Boolean;
      DeptVisible@1000000036 : Boolean;
      SecVisible@1000000037 : Boolean;
      OccpVisible@1000000038 : Boolean;
      MembCust@1000000039 : Record 51516223;
      GroupAccEditable@1000000040 : Boolean;
      AccTypeEditable@1000000041 : Boolean;
      AccountSignatoriesApp@1000000042 : Record 51516292;
      SMSMessage@1000000043 : Record 51516329;
      iEntryNo@1000000044 : Integer;
      MessageFailed@1000000045 : Boolean;
      MemApp@1000000048 : Record 51516220;
      Text005@1000000049 : TextConst 'ENU=There are still some incomplete Applications. Please utilise them first';
      Dimen@1000000052 : Record 349;
      NoSeriesMgt@1000000054 : Codeunit 396;

    PROCEDURE UpdateControls@1102755003();
    BEGIN

           IF Status=Status::Approved THEN BEGIN
           NameEditable:=FALSE;
           GroupAccEditable:=FALSE;
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
           ForceNo:=FALSE;
           ContPhone:=FALSE;
           ContRelation:=FALSE;
           ContOcuppation:=FALSE;
           Recruitedby:=FALSE;
           PassEditable:=FALSE;
           EmployerEditable:=FALSE;
           CountryEditable:=FALSE;
           SalesEditable:=FALSE;
           AccountCategory:=FALSE;
           BankAEditable:=FALSE;
           MemEditable:=FALSE;
           BenvEditable:=FALSE;
           BankNEditable:=FALSE;
           AccTypeEditable:=FALSE;
           END;

           IF Status=Status::Open THEN BEGIN
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
           CityEditable:=FALSE;
           WitnessEditable:=TRUE;
           BankCodeEditable:=TRUE;
           BranchCodeEditable:=TRUE;
           BankAccountNoEditable:=TRUE;
           VillageResidence:=TRUE;
           ForceNo:=TRUE;
           ContPhone:=TRUE;
           ContRelation:=TRUE;
           ContOcuppation:=TRUE;
           Recruitedby:=TRUE;
           PassEditable:=TRUE;
           EmployerEditable:=TRUE;
           CountryEditable:=TRUE;
           SalesEditable:=TRUE;
           AccountCategory:=TRUE;
           BankAEditable:=TRUE;
           MemEditable:=TRUE;
           BenvEditable:=TRUE;
           BankNEditable:=TRUE;
           GroupAccEditable:=TRUE;
           AccTypeEditable:=TRUE;
           END
    END;

    BEGIN
    {
      //Cust.VALIDATE(Cust."ID No.");
      //CLEAR(Picture);
      //CLEAR(Signature);
      //MODIFY;
    }
    END.
  }
}

