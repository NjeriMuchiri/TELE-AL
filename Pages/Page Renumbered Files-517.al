OBJECT page 172112 MC Individual Application Card
{
  OBJECT-PROPERTIES
  {
    Date=08/30/16;
    Time=10:30:21 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516220;
    SourceTableView=WHERE(Account Category=FILTER(<>Group),
                          Group Account=FILTER(No),
                          Customer Posting Group=FILTER(MICRO),
                          Source=CONST(Micro));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN

                 IF Status=Status::Approved THEN
                 CurrPage.EDITABLE:=FALSE;
               END;

    OnNewRecord=BEGIN

                  "Customer Type":="Customer Type"::MicroFinance;
                  "Global Dimension 1 Code":='MICRO';
                  "Customer Posting Group":='MICRO';
                  Source:=Source::Micro;
                  "Account Type":="Account Type"::Single;
                  "Account Category":="Account Category"::Single;
                  "Group Account":=FALSE;
                END;

    OnInsertRecord=BEGIN
                     //"Responsibility Centre" := UserMgt.GetSalesFilter;
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
      { 1000000003;2 ;Action    ;
                      Name=Next of Kin;
                      CaptionML=ENU=Next of Kin;
                      RunObject=page 17362;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1000000000;2 ;Action    ;
                      Name=[Account Signatories ];
                      CaptionML=ENU=Signatories;
                      RunObject=page 17361;
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


                                 //TESTFIELD("Business Loan Appl Type");

                                 IF "Customer Posting Group"<>'MICRO' THEN BEGIN
                                 ERROR('Customer Posting Group Must be MICRO')
                                 END;

                                 IF "Global Dimension 1 Code"<>'MICRO' THEN BEGIN
                                 ERROR('Acivity Code Must be MICRO')
                                 END;

                                 IF "ID No."<>'' THEN BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."ID No.","ID No.");
                                 Cust.SETRANGE(Cust."Customer Posting Group",'Micro');
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                    ERROR('This Member has Already been Created');
                                 END;
                                 END;

                                 IF "Account Category"<>"Account Category"::Single THEN BEGIN
                                 AccountSignApp.RESET;
                                 AccountSignApp.SETRANGE(AccountSignApp."Account No","No.");
                                 IF AccountSignApp.FIND('-')=FALSE THEN
                                 ERROR(text003);
                                 END;

                                 //TESTFIELD(Picture);
                                 //TESTFIELD(Signature);
                                 TESTFIELD("E-Mail (Personal)");
                                 TESTFIELD("Customer Posting Group");
                                 TESTFIELD("Global Dimension 1 Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("Monthly Contribution");
                                 TESTFIELD("Mobile Phone No");


                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);

                                 //**individual aapplication do not require next of kin
                                 {
                                 NextOfKinAppr.RESET;
                                 NextOfKinAppr.SETRANGE(NextOfKinAppr."Account No","BOSA Account No.");
                                 IF NextOfKinAppr.FIND('-')=FALSE THEN
                                 ERROR(text002);
                                 }


                                 //End allocate batch number
                                 //IF Approvalmgt.SendAccOpeningRequest(Rec) THEN;
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
                                 Cust.SETRANGE(Cust."Customer Posting Group",'MICRO');
                                 IF Cust.FIND('-') THEN BEGIN
                                 IF Cust."No." <> "No." THEN
                                 ERROR('This Member Account has Already been Created');
                                 END;
                                 END;

                                 //Create Micro Account
                                 GenSetUp.TESTFIELD(GenSetUp."Business Loans A/c Format");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("BOSA Account No.");
                                 Cust."No.":="Global Dimension 2 Code"+''+"BOSA Account No."+''+GenSetUp."Business Loans A/c Format";
                                 Cust."BOSA Account No.":="BOSA Account No.";
                                 Cust.Name:=UPPERCASE(Name);
                                 Cust.Address:=Address;
                                 Cust."Post Code":="Postal Code";
                                 Cust.City:=City;
                                 Cust.County:=City;
                                 Cust."Country/Region Code":="Country/Region Code";
                                 Cust."Phone No.":="Phone No.";
                                 Cust."Global Dimension 1 Code":="Global Dimension 1 Code" ;
                                 Cust."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Cust."Customer Posting Group":="Customer Posting Group";
                                 Cust."Registration Date":=TODAY;//Registration date must be the day the application is converted to a member and not day of capture
                                 Cust.Status:=Cust.Status::"Non-Active";
                                 Cust."Employer Code":="Employer Code";
                                 Cust."Date of Birth":="Date of Birth";
                                 Cust."Station/Department":="Station/Department";
                                 Cust."E-Mail":="E-Mail (Personal)";
                                 Cust.Location:=Location;
                                 Cust."Group Account Name":="Group Account Name";


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
                                 Cust."Customer Type":=Cust."Customer Type"::MicroFinance;
                                 Cust.Gender:=Gender;

                                 CALCFIELDS(Signature,Picture);

                                 Cust."Monthly Contribution":="Monthly Contribution";
                                 Cust."Account Category":="Account Category";
                                 Cust."Contact Person":="Contact Person";
                                 Cust."Contact Person Phone":="Contact Person Phone";
                                 Cust."ContactPerson Relation":="ContactPerson Relation";
                                 Cust."Recruited By":="Recruited By";
                                 Cust."Business Loan Officer":="Salesperson Name";
                                 Cust."ContactPerson Occupation":="ContactPerson Occupation";
                                 Cust."Village/Residence":="Village/Residence";
                                 Cust."Group Account":="Group Account";
                                 Cust."Group Account No":="Group Account No";
                                 Cust."Group Account Name":="Group Account Name";
                                 Cust."FOSA Account":="FOSA Account No.";
                                 Cust.INSERT(TRUE);

                                 //BOSAACC:=Cust."No.";
                                 Cust.RESET;
                                 IF Cust.GET(BOSAACC) THEN BEGIN
                                 Cust.VALIDATE(Cust.Name);
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
                                 MESSAGE('Account created successfully.');
                                 Status:=Status::Approved;
                                 "Created By":=USERID;



                                 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Send SMS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
                SourceExpr=Name }

    { 1102755006;2;Field  ;
                CaptionML=ENU=FOSA Account Category;
                SourceExpr="Account Category";
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

    { 1000000015;2;Field  ;
                SourceExpr="Group Account";
                Visible=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Account Category","Account Category"::Group);
                           END;
                            }

    { 1000000023;2;Field  ;
                OptionCaptionML=ENU=" ,,,,,Micro";
                SourceExpr="Customer Type";
                Visible=FALSE }

    { 1102755019;2;Field  ;
                CaptionML=ENU=ID No.;
                SourceExpr="ID No.";
                Visible=TRUE;
                OnValidate=BEGIN

                             Cust.RESET;
                             Cust.SETRANGE(Cust."ID No.","ID No.");
                             Cust.SETFILTER(Cust."Account Category",'<>%1',Cust."Account Category"::Group);
                             Cust.SETFILTER(Cust."Group Account",'%1',FALSE);
                             Cust.SETRANGE(Cust."Customer Posting Group",'MICRO');
                             IF Cust.FIND('-') THEN BEGIN
                               ERROR(Text005,Cust."Group Account Name");
                             END;

                             CustMember.RESET;
                             CustMember.SETRANGE(CustMember."ID No.","ID No.");
                             CustMember.SETRANGE(CustMember."Customer Type",CustMember."Customer Type"::Member);
                             IF CustMember.FIND('-') THEN
                              REPEAT
                              VALIDATE("BOSA Account No.",CustMember."No.");
                              UNTIL CustMember.NEXT=0;
                           END;
                            }

    { 1000000018;2;Field  ;
                SourceExpr="BOSA Account No.";
                Visible=TRUE;
                OnValidate=BEGIN

                             CustMember.RESET;
                             CustMember.SETRANGE(CustMember."No.","BOSA Account No.");
                             IF CustMember.FIND('-') THEN BEGIN
                             IF CustMember."FOSA Account"='' THEN
                             ERROR('The Member Does not have FOSA Account');
                             END;
                           END;
                            }

    { 1000000019;2;Field  ;
                SourceExpr="FOSA Account No.";
                Visible=TRUE;
                Enabled=FALSE;
                Editable=false }

    { 1102755017;2;Field  ;
                SourceExpr="Payroll/Staff No";
                Visible=TRUE;
                Editable=FALSE }

    { 1000000005;2;Field  ;
                SourceExpr="Passport No.";
                Visible=TRUE;
                Editable=PassEditable }

    { 1102755005;2;Field  ;
                SourceExpr=Address;
                Editable=AddressEditable }

    { 10  ;2   ;Field     ;
                SourceExpr="Postal Code";
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
                Editable=FALSE }

    { 1102755021;2;Field  ;
                SourceExpr="Mobile Phone No";
                Editable=true }

    { 1102755023;2;Field  ;
                SourceExpr="Marital Status";
                Visible=TRUE;
                Editable=FALSE }

    { 1102755025;2;Field  ;
                SourceExpr=Gender;
                Visible=TRUE;
                Editable=FALSE }

    { 1102755039;2;Field  ;
                SourceExpr="Date of Birth";
                Visible=TRUE;
                Editable=FALSE }

    { 1102755041;2;Field  ;
                SourceExpr="E-Mail (Personal)";
                Editable=true }

    { 1102755002;2;Field  ;
                SourceExpr="Village/Residence";
                Editable=VillageResidence }

    { 1102755015;2;Field  ;
                SourceExpr="Registration Date";
                Visible=FALSE;
                Editable=RegistrationDateEdit }

    { 1000000014;1;Group  ;
                CaptionML=ENU=Group Information;
                GroupType=Group }

    { 1000000016;2;Field  ;
                SourceExpr="Group Account No" }

    { 1000000017;2;Field  ;
                SourceExpr="Group Account Name";
                Editable=FALSE }

    { 1000000020;2;Field  ;
                SourceExpr="Recruited By" }

    { 1000000025;2;Field  ;
                SourceExpr="Salesperson Name" }

    { 1000000022;2;Field  ;
                SourceExpr=Source }

    { 1906634201;1;Group  ;
                CaptionML=ENU=Other Information }

    { 1102755012;2;Field  ;
                SourceExpr="Monthly Contribution";
                Editable=MonthlyContributionEdit }

    { 1000000007;2;Field  ;
                SourceExpr="Employer Code";
                Visible=TRUE;
                Editable=FALSE }

    { 1000000010;2;Field  ;
                SourceExpr="Bank Code";
                Visible=FALSE;
                Editable=BankAEditable }

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
                Visible=FALSE;
                Editable=OfficeBranchEditable }

    { 1102755029;2;Field  ;
                SourceExpr=Department;
                Visible=FALSE;
                Editable=DeptEditable }

    { 1102755031;2;Field  ;
                SourceExpr=Section;
                Visible=FALSE;
                Editable=SectionEditable }

    { 1102755033;2;Field  ;
                SourceExpr=Occupation;
                Visible=FALSE;
                Editable=OccupationEditable }

    { 1102755049;2;Field  ;
                SourceExpr=Status }

    { 1102755043;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=FALSE }

    { 1102755004;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Editable=GlobalDim2Editable }

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
      NextOfKinApp@1000000051 : Record 51516221;
      NextofKinFOSA@1000000050 : Record 51516293;
      AccountSign@1000000049 : Record 51516294;
      AccSignatories@1000000048 : Record 51516294;
      AccountSignApp@1000000047 : Record 51516292;
      GetSeUp@1000000040 : Record 51516257;
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
      text003@1102755046 : TextConst 'ENU=You must specify Signatories for this type of membership';
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
      Memb@1000000024 : Record 51516220;
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
      AccountSignatoriesApp@1000000041 : Record 51516292;
      SMSMessage@1000000042 : Record 51516329;
      iEntryNo@1000000043 : Integer;
      AccoutTypes@1000000044 : Record 51516295;
      Text005@1000000045 : TextConst 'ENU=Member already belongs to group %1.';
      MembrCount@1000000046 : Integer;

    PROCEDURE UpdateControls@1102755003();
    BEGIN

           IF Status=Status::Approved THEN BEGIN
           NameEditable:=FALSE;
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

           END
    END;

    BEGIN
    END.
  }
}

