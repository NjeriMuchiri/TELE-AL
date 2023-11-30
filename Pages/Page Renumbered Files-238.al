OBJECT page 17429 Account Application Card
{
  OBJECT-PROPERTIES
  {
    Date=08/24/23;
    Time=[ 1:43:27 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    CaptionML=ENU=Account Applications;
    SourceTable=Table51516290;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=VAR
                 MapMgt@1000 : Codeunit 802;
               BEGIN
                 UpdateControls;
                 ActivateFields;
                 Controls;
                 //Filter based on branch
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Global Dimension 2 Code",UsersID.Branch);
                 END;}
                 //Filter based on branch

                 IF Status=Status::Approved THEN
                 CurrPage.EDITABLE:=FALSE;
               END;

    OnFindRecord=VAR
                   RecordFound@1000 : Boolean;
                 BEGIN
                   RecordFound := FIND(Which);
                   CurrPage.EDITABLE := RecordFound OR (GETFILTER("No.") = '');
                   EXIT(RecordFound);
                 END;

    OnAfterGetRecord=BEGIN
                       OnAfterGetCurrRecord;
                       UpdateControls;
                       Controls;
                     END;

    OnNewRecord=BEGIN
                  OnAfterGetCurrRecord;
                END;

    OnInsertRecord=BEGIN
                     //"Debtor Type":="Debtor Type"::Account;
                     "Application Date":=TODAY;
                   END;

    ActionList=ACTIONS
    {
      { 1000000065;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000064;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1000000063;2 ;Action    ;
                      Name=Next of Kin;
                      CaptionML=ENU=Next of Kin;
                      RunObject=page 17430;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1000000062;2 ;Action    ;
                      Name=[Account Signatories ];
                      CaptionML=ENU=Signatories;
                      RunObject=page 17431;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Group;
                      PromotedCategory=Process }
      { 1000000060;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000059;1 ;Action    ;
                      CaptionML=ENU=Approve;
                      Promoted=Yes;
                      Visible=False;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //TESTFIELD("Employer Code");
                                 TESTFIELD("Account Type");
                                 TESTFIELD("ID No.");
                                 TESTFIELD("Staff No");
                                 //TESTFIELD("BOSA Account No");
                                 TESTFIELD("Date of Birth");
                                 //TESTFIELD("Global Dimension 2 Code");
                                 {
                                 IF ("Micro Group"=FALSE) OR ("Micro Single"=FALSE) THEN
                                 IF "BOSA Account No"='' THEN
                                 ERROR('Please specify the Bosa Account.');
                                 //TESTFIELD("BOSA Account No");
                                 //TESTFIELD("Employer Code");
                                 }

                                 {IF "Global Dimension 2 Code" = '' THEN
                                 ERROR('Please specify the branch.');
                                  }
                                 {IF "Application Status" = "Application Status"::Converted THEN
                                 ERROR('Application has already been converted.');

                                 IF ("Account Type" = 'SAVINGS') THEN BEGIN
                                 Nok.RESET;
                                 Nok.SETRANGE(Nok."Account No","No.");
                                 {IF Nok.FIND('-') = FALSE THEN BEGIN
                                 ERROR('Next of Kin have not been specified.');
                                 END;}

                                 END;


                                 IF CONFIRM('Are you sure you want to approve & create this account',TRUE) = FALSE THEN
                                 EXIT;


                                 "Application Status" := "Application Status"::Converted;
                                 MODIFY;



                                 BranchC:='';
                                 IncrementNo:='';
                                 {
                                 DimensionValue.RESET;
                                 DimensionValue.SETRANGE(DimensionValue.Code,"Global Dimension 2 Code");
                                 IF DimensionValue.FIND('-') THEN
                                 BranchC:=DimensionValue."Account Code";
                                 IncrementNo:=INCSTR(DimensionValue."No. Series");

                                 DimensionValue."No. Series":=IncrementNo;
                                 DimensionValue.MODIFY;
                                 }

                                 IF AccoutTypes.GET("Account Type") THEN BEGIN
                                 IF AccoutTypes."Fixed Deposit" = TRUE THEN BEGIN
                                   //TESTFIELD("Savings Account No.");
                                   //TESTFIELD("Maturity Type");
                                   //TESTFIELD("Fixed Deposit Type");
                                 END;



                                 //Based on BOSA
                                 {
                                 IF (AccoutTypes.Code = 'CHILDREN') OR (AccoutTypes.Code = 'FIXED') THEN BEGIN
                                 IF  "Kin No" = '' THEN
                                   AcctNo:=AccoutTypes."Account No Prefix" + '-' + BranchC + '-' + PADSTR("BOSA Account No",6,'0') + '-' + AccoutTypes."Ending Series
                                 "
                                 ELSE
                                 AcctNo:=AccoutTypes."Account No Prefix" + '-' + BranchC + '-' + PADSTR("BOSA Account No",6,'0') + '-' + "Kin No";
                                 END ELSE BEGIN
                                   AcctNo:=AccoutTypes."Account No Prefix" + '-' + BranchC + '-' + PADSTR("BOSA Account No",6,'0') + '-' + AccoutTypes."Ending Series
                                 ";
                                 END;
                                 }
                                 //Based on BOSA
                                 ///////
                                 IF "Parent Account No." = '' THEN BEGIN
                                 IF DimensionValue.GET('BRANCH',"Global Dimension 2 Code") THEN BEGIN
                                 //DimensionValue.TESTFIELD(DimensionValue."Account Code");
                                 //AcctNo:=AccoutTypes."Account No Prefix" + '-' + DimensionValue."Account Code" + '-' + DimensionValue."No. Series"
                                 // + '-' + AccoutTypes."Ending Series";
                                 {AcctNo:=AccoutTypes."Account No Prefix" + '-' + INCSTR(DimensionValue."No. Series")
                                  + '-' + DimensionValue."Account Code";//AccoutTypes."Ending Series";}
                                     //fosa account number

                                 //AcctNo:=AccoutTypes."Account No Prefix" + '-001-' +  ("BOSA Account No");




                                 IF (AccoutTypes."Use Savings Account Number" = TRUE)  THEN BEGIN
                                 //TESTFIELD("Savings Account No.");
                                 //AcctNo:=AccoutTypes."Account No Prefix" + COPYSTR("Savings Account No.",4)
                                 END ELSE
                                 DimensionValue."No. Series":=INCSTR(DimensionValue."No. Series");
                                 DimensionValue.MODIFY;
                                 END;

                                 END ELSE BEGIN
                                 TESTFIELD("Kin No");
                                 // AcctNo:=COPYSTR("Parent Account No.",1,14) + "Kin No";
                                 END;
                                 IF AccoutTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 // IF "Kin No" <> '' THEN
                                 // AcctNo:=COPYSTR(AcctNo,1,14) + "Kin No";
                                 END;
                                 ///////
                                 //Account:=AccoutTypes."Account No Prefix" + '-001-' +  ("BOSA Account No");

                                 Accounts.INIT;
                                 Accounts."No.":=AccoutTypes."Account No Prefix" + '-001-' +  ("BOSA Account No");
                                 //Accounts."No.":="No.";
                                 //AcctNo:="No.";
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts.Name:=Name;
                                 Accounts."Creditor Type":=Accounts."Creditor Type"::Account;
                                 Accounts."Debtor Type":="Debtor Type";
                                 IF "Micro Single" = TRUE THEN
                                 Accounts."Group Account":=FALSE
                                 ELSE IF "Micro Group" = TRUE THEN
                                 Accounts."Group Account":=FALSE;
                                 Accounts."Staff No":="Staff No";
                                 Accounts."ID No.":="ID No.";
                                 Accounts."Mobile Phone No":="Mobile Phone No";
                                 Accounts."Registration Date":="Registration Date";
                                 //Accounts."Marital Status":="Marital Status";
                                 Accounts."BOSA Account No":="BOSA Account No";
                                 Accounts.Picture:=Picture;
                                 Accounts.Signature:=Signature;
                                 Accounts."Passport No.":="Passport No.";
                                 Accounts."Company Code":="Employer Code";
                                 Accounts.Status:=Accounts.Status::New;
                                 Accounts."Account Type":="Account Type";
                                 Accounts."Account Category":="Account Category";
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts."Global Dimension 1 Code":='FOSA';
                                 Accounts."Global Dimension 2 Code":='NAIROBI';
                                 Accounts.Address:=Address;
                                 Accounts."Address 2":="Address 2";
                                 Accounts.City:=City;
                                 Accounts."Phone No.":="Phone No.";
                                 Accounts."Telex No.":="Telex No.";
                                 Accounts."Post Code":="Post Code";
                                 Accounts.County:=County;
                                 Accounts."E-Mail":="E-Mail";
                                 Accounts."Home Page":="Home Page";
                                 Accounts."Registration Date":=TODAY;
                                 //Accounts.Status:=Status::New;
                                 Accounts.Status:=Status::Open;
                                 Accounts.Section:=Section;
                                 Accounts."Home Address":="Home Address";
                                 Accounts.District:=District;
                                 Accounts.Location:=Location;
                                 Accounts."Sub-Location":="Sub-Location";
                                 Accounts."Savings Account No.":="Savings Account No.";
                                 Accounts."Signing Instructions":="Signing Instructions";
                                 Accounts."Fixed Deposit Type":="Fixed Deposit Type";
                                 Accounts."FD Maturity Date":="FD Maturity Date";
                                 Accounts."Registration Date":=TODAY;
                                 Accounts."Monthly Contribution" := "Monthly Contribution";
                                 Accounts."Formation/Province":="Formation/Province";
                                 Accounts."Division/Department":="Division/Department";
                                 Accounts."Station/Sections":="Station/Sections";
                                 Accounts."Force No.":="Force No.";
                                 Accounts."Vendor Posting Group":="Account Type";
                                 Accounts.INSERT;

                                 END;


                                 Accounts.RESET;
                                 IF Accounts.GET(AcctNo) THEN BEGIN
                                 Accounts.VALIDATE(Accounts.Name);
                                 Accounts.VALIDATE(Accounts."Account Type");
                                 Accounts.VALIDATE(Accounts."Global Dimension 1 Code");
                                 Accounts.VALIDATE(Accounts."Global Dimension 2 Code");
                                 Accounts.MODIFY;

                                 //Update BOSA with FOSA Account
                                 IF ("Account Type" = 'SAV') THEN BEGIN
                                 IF Cust.GET("BOSA Account No") THEN BEGIN
                                 Cust."FOSA Account":=AcctNo;
                                 //Cust."FOSA Account":="No.";
                                 Cust.MODIFY;
                                 END;
                                 END;

                                 END;

                                 NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-') THEN BEGIN
                                 REPEAT
                                 NextOfKin.INIT;
                                 //NextOfKin."Account No":=AcctNo;
                                 NextOfKin."Account No":="No.";

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
                                 AccountSign.INSERT;

                                 UNTIL AccountSignApp.NEXT = 0;
                                 END;
                                 }

                                 MESSAGE('Account approved & created successfully.');
                               END;
                                }
      { 1000000018;1 ;Action    ;
                      CaptionML=ENU=Reject;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Reject;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF "Application Status" = "Application Status"::Converted THEN
                                 ERROR('Application has already been converted.');

                                 IF CONFIRM('Are you sure you want to reject this application',TRUE) = TRUE THEN BEGIN
                                 "Application Status" := "Application Status"::Rejected;
                                 MODIFY;
                                 END;
                               END;
                                }
      { 1000000061;1 ;Action    ;
                      Name=Create;
                      CaptionML=ENU=Create;
                      Promoted=Yes;
                      Image=CreateMovement;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 UserSetup.GET(USERID);
                                 IF UserSetup."Create Account"=FALSE THEN
                                 ERROR('You dont have permission to create account.');
                                 //TESTFIELD("Employer Code");
                                 //SaccoSetup.GET;

                                 //IF ("Account Type"<>'CHILDREN') OR ("Account Type"<>'CORPORATE') OR ("Account Type"<>'FIXED') THEN BEGIN
                                 IF "Account Type"<>'MDOSI JUNIOR' THEN BEGIN
                                 IF ("Fixed Deposit"<> TRUE) AND ("Allow Multiple Accounts"<>TRUE) THEN BEGIN
                                 IF "ID No."<>'' THEN BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."ID No.","ID No.");
                                 Vend.SETRANGE(Vend."Account Type","Account Type");
                                 IF Vend.FIND('-') THEN BEGIN

                                 ERROR('Account type already exists');

                                 END;
                                 END;
                                 END;
                                 END;


                                 IF Status<>Status::Approved THEN
                                 ERROR('Account application not approved');

                                 IF ("Account Type"<>'JUNIOR') THEN BEGIN
                                 IF "Micro Group"<> TRUE THEN BEGIN
                                 TESTFIELD("Account Type");
                                 TESTFIELD("ID No.");
                                 TESTFIELD("Staff No");
                                 TESTFIELD("Phone No.");
                                 //TESTFIELD("BOSA Account No");
                                 TESTFIELD("Phone No.");
                                 TESTFIELD("E-Mail");
                                 TESTFIELD("Date of Birth");
                                 TESTFIELD("Global Dimension 2 Code");
                                 END;
                                 END;

                                 IF "Micro Single"=TRUE THEN BEGIN
                                 TESTFIELD("Group Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 END;

                                 //IF ("Micro Single"<>TRUE) AND ("Micro Group"<>TRUE) THEN
                                 //TESTFIELD("BOSA Account No");\
                                 IF ("Account Type"<>'JUNIOR') THEN BEGIN
                                 IF ("Micro Single"<>TRUE) AND ("Micro Group"<>TRUE) THEN
                                 IF "Account Type"='SAVINGS' THEN BEGIN
                                 TESTFIELD("BOSA Account No");
                                 END;
                                 END;

                                 {
                                 IF ("Micro Group"=FALSE) OR ("Micro Single"=FALSE) THEN
                                 IF "BOSA Account No"='' THEN
                                 ERROR('Please specify the Bosa Account.');
                                 //TESTFIELD("BOSA Account No");
                                 //TESTFIELD("Employer Code");
                                 }

                                 {IF "Global Dimension 2 Code" = '' THEN
                                 ERROR('Please specify the branch.');
                                  }


                                 IF "Application Status" = "Application Status"::Converted THEN
                                 ERROR('Application has already been converted.');

                                 IF ("Account Type" = 'ORDINARY') THEN BEGIN
                                 Nok.RESET;
                                 Nok.SETRANGE(Nok."Account No","No.");
                                 {IF Nok.FIND('-') = FALSE THEN BEGIN
                                 ERROR('Next of Kin have not been specified.');
                                 END;}

                                 END;


                                 IF CONFIRM('Are you sure you want to approve & create this account',TRUE) = FALSE THEN
                                 EXIT;


                                 //"Application Status" := "Application Status"::Converted;
                                 //MODIFY;



                                 BranchC:='';
                                 IncrementNo:='';


                                 IF AccoutTypes.GET("Account Type") THEN BEGIN
                                 IF AccoutTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 END;
                                 //END;





                                  //
                                 IF "Micro Single"<>TRUE THEN BEGIN
                                 IF DimensionValue.GET('BRANCH',"Global Dimension 2 Code") THEN BEGIN
                                 IF "Account Type"<>'MDOSI JUNIOR' THEN BEGIN
                                 AcctNo:=AccoutTypes."Account No Prefix"+"BOSA Account No";//;//AccoutTypes."Ending Series";//
                                 END ELSE BEGIN

                                 AcctNo:=AccoutTypes."Account No Prefix"+AccoutTypes."Ending Series";
                                 AccoutTypes."Ending Series":=INCSTR(AccoutTypes."Ending Series");
                                 AccoutTypes.MODIFY;
                                 END;
                                 END;
                                 END;


                                 IF "Micro Single"=TRUE THEN BEGIN
                                 IF DimensionValue.GET('BRANCH',"Global Dimension 2 Code") THEN BEGIN
                                 DimensionValue.TESTFIELD(DimensionValue."Account Code");
                                 //AcctNo:=AccoutTypes."Account No Prefix" + '-' + DimensionValue."Account Code" + '-' + DimensionValue."No. Series"
                                 // + '-' + AccoutTypes."Ending Series";
                                 AcctNo:="Group Code"+AccoutTypes."Ending Series";
                                 AccoutTypes."Ending Series":=INCSTR(AccoutTypes."Ending Series");
                                 AccoutTypes.MODIFY;
                                 END;
                                 END;



                                 IF AccoutTypes.GET("Account Type") THEN BEGIN
                                 IF "Parent Account No." = '' THEN BEGIN

                                 IF (AccoutTypes."Use Savings Account Number" = TRUE)  THEN BEGIN
                                 //sTESTFIELD("Savings Account No.");
                                 AcctNo:=AccoutTypes."Account No Prefix"+"BOSA Account No";
                                 END ELSE BEGIN
                                 DimensionValue."No. Series":=INCSTR(DimensionValue."No. Series");
                                 DimensionValue.MODIFY;
                                 END;

                                 END ELSE BEGIN
                                 //TESTFIELD("Kin No");
                                 //AcctNo:=COPYSTR("Parent Account No.",1,14) + "Kin No";
                                 AcctNo:=AccoutTypes."Account No Prefix"+"Kin No";
                                 IF Acc.GET(AcctNo) THEN BEGIN
                                 //AcctNo:=AccoutTypes."Account No Prefix"+AccoutTypes."Ending Series";//"BOSA Account No";
                                 AccoutTypes."Ending Series":=INCSTR(AccoutTypes."Ending Series");
                                 //AccoutTypes.MODIFY;
                                 AcctNo:=(AccoutTypes.Branch+'-'+AccoutTypes."Ending Series"+'-')+"Kin No";
                                 END;
                                 END;
                                 IF AccoutTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF "Kin No" <> '' THEN
                                 AcctNo:=AccoutTypes."Account No Prefix"+"BOSA Account No";
                                 END;
                                 ///////
                                 END;
                                  //END;

                                 //MESSAGE('Acc%1',AcctNo);
                                 //ERROR('FFF');
                                 IF "Micro Group"=TRUE THEN BEGIN
                                 SaccoSetup.RESET;
                                 SaccoSetup.GET;
                                 Accounts.INIT;
                                 Accounts."No.":=SaccoSetup."Micro Group Nos.";
                                 //MESSAGE('The Group no is %1',Accounts."No.");
                                 //AcctNo:="No.";
                                 Accounts.Name:=Name;
                                 Accounts."Creditor Type":=Accounts."Creditor Type"::Account;
                                 Accounts."Debtor Type":=Accounts."Debtor Type"::"FOSA Account";
                                 Accounts."Global Dimension 1 Code":='MICRO';
                                 Accounts."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Accounts."Group Account":=TRUE;
                                 Accounts."Parent Account":="BOSA Account No";
                                 Accounts."Childs Date Of Birth":="Childs Date Of Birth";
                                 Accounts."Childs Birth Certificate No":="Childs Birth Certificate No";
                                 Accounts."Registration Date":=TODAY;
                                 Accounts."Purchaser Code":="Purchaser Code";
                                 //Accounts.VALIDATE(Accounts.Name);
                                 //Accounts.VALIDATE(Accounts."Global Dimension 1 Code");
                                 //Accounts.VALIDATE(Accounts."Global Dimension 2 Code");
                                 Accounts.INSERT;
                                 SaccoSetup."Micro Group Nos.":=INCSTR(SaccoSetup."Micro Group Nos.");
                                 SaccoSetup.MODIFY;

                                 //micro savin
                                 Accounts."No.":=AcctNo;//"No.";
                                 //AcctNo:="No.";
                                 Accounts.Name:=Name;
                                 Accounts."Creditor Type":=Accounts."Creditor Type"::Account;
                                 Accounts."Debtor Type":=Accounts."Debtor Type"::" ";
                                 Accounts."Mobile Phone No":="Mobile Phone No";
                                 Accounts."Registration Date":="Registration Date";
                                 Accounts.Status:=Accounts.Status::New;
                                 Accounts."Childs Name":="Child Name";
                                 Accounts."Account Type":="Account Type";
                                 Accounts."Purchaser Code":="Purchaser Code";
                                 //Accounts."Group Code":="Group Code";
                                 Accounts."Account Category":="Account Category";
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts."Global Dimension 1 Code":="Global Dimension 1 Code";
                                 Accounts."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Accounts.Address:=Address;
                                 Accounts."Address 2":="Address 2";
                                 Accounts.City:=City;
                                 Accounts."Phone No.":="Phone No.";
                                 Accounts."Telex No.":="Telex No.";
                                 Accounts."Post Code":="Post Code";
                                 Accounts.County:=County;
                                 Accounts."E-Mail":="E-Mail";
                                 Accounts."Home Page":="Home Page";
                                 Accounts."Registration Date":=TODAY;
                                 //Accounts.Status:=Status::New;
                                 Accounts.Status:=Status::Open;
                                 Accounts.Section:=Section;
                                 Accounts."Home Address":="Home Address";
                                 Accounts.District:=District;
                                 Accounts.Location:=Location;
                                 Accounts."Sub-Location":="Sub-Location";
                                 Accounts."Savings Account No.":="Savings Account No.";
                                 Accounts."Signing Instructions":="Signing Instructions";
                                 Accounts."Fixed Deposit Type":="Fixed Deposit Type";
                                 Accounts."FD Maturity Date":="FD Maturity Date";
                                 Accounts."Fixed Deposit Status":=Accounts."Fixed Deposit Status"::Active;
                                 Accounts."Registration Date":=TODAY;
                                 Accounts."Monthly Contribution" := "Monthly Contribution";
                                 Accounts."Formation/Province":="Formation/Province";
                                 Accounts."Division/Department":="Division/Department";
                                 Accounts."Station/Sections":="Station/Sections";
                                 Accounts."Force No.":="Force No.";
                                 Accounts."Sms Notification":="Sms Notification";
                                 Accounts."Vendor Posting Group":=AccoutTypes."Posting Group";
                                 MESSAGE('The Group Savings Account no is %1',AcctNo);

                                 Accounts.INSERT;

                                 //micro savin

                                 END;
                                 //END;

                                 IF "Micro Group"=FALSE THEN BEGIN
                                 Accounts.INIT;
                                 Accounts."No.":=AcctNo;
                                 //Accounts."No.":="No.";
                                 //AcctNo:="No.";
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts.Name:=Name;
                                 Accounts."Creditor Type":=Accounts."Creditor Type"::Account;
                                 Accounts."Debtor Type":="Debtor Type";
                                 Accounts."Debtor Type":=Accounts."Debtor Type"::" ";
                                 IF "Micro Single" = TRUE THEN BEGIN
                                 Accounts."Group Account":=FALSE;
                                 Accounts."Debtor Type":=Accounts."Debtor Type"::"FOSA Account";
                                 END;
                                 Accounts."Staff No":="Staff No";
                                 Accounts."Purchaser Code":="Purchaser Code";
                                 Accounts."ID No.":="ID No.";
                                 Accounts."Mobile Phone No":="Mobile Phone No";
                                 Accounts."Phone No.":="Phone No.";
                                 Accounts."Registration Date":="Registration Date";
                                 Accounts."Marital Status":="Marital Status";
                                 Accounts."BOSA Account No":="BOSA Account No";
                                 Accounts.Picture:=Picture;
                                 Accounts.Signature:=Signature;
                                 Accounts."Passport No.":="Passport No.";
                                 Accounts."Company Code":="Employer Code";
                                 Accounts.Status:=Accounts.Status::New;
                                 Accounts."Account Type":="Account Type";
                                 Accounts."Group Code":="Group Code";
                                 Accounts."Account Category":="Account Category";
                                 Accounts."Date of Birth":="Date of Birth";
                                 Accounts."Global Dimension 1 Code":="Global Dimension 1 Code";
                                 Accounts."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Accounts.Address:=Address;
                                 Accounts."Address 2":="Address 2";
                                 Accounts.City:=City;
                                 Accounts."Phone No.":="Phone No.";
                                 Accounts."Telex No.":="Telex No.";
                                 Accounts."Post Code":="Post Code";
                                 Accounts.County:=County;
                                 Accounts."E-Mail":="E-Mail";
                                 Accounts."Home Page":="Home Page";
                                 Accounts."Registration Date":=TODAY;
                                 //Accounts.Status:=Status::New;
                                 Accounts.Status:=Status::Open;
                                 Accounts."Created By":="Created By";
                                 Accounts.Section:=Section;
                                 Accounts."Home Address":="Home Address";
                                 Accounts.District:=District;
                                 Accounts.Location:=Location;

                                 Accounts."Sub-Location":="Sub-Location";
                                 Accounts."Savings Account No.":="Savings Account No.";
                                 Accounts."Signing Instructions":="Signing Instructions";
                                 Accounts."Fixed Deposit Type":="Fixed Deposit Type";
                                 Accounts."FD Maturity Date":="FD Maturity Date";
                                 Accounts."Neg. Interest Rate":="Neg. Interest Rate";
                                 Accounts."FD Duration":="FD Duration";
                                 Accounts."Registration Date":=TODAY;
                                 Accounts."ContactPerson Relation":="ContactPerson Relation";
                                 Accounts."ContactPerson Occupation":="ContacPerson Occupation";
                                 Accounts."Recruited By":="Recruited By";
                                 Accounts."ContacPerson Phone":="ContacPerson Phone";
                                 Accounts."Monthly Contribution" := "Monthly Contribution";
                                 Accounts."Formation/Province":="Formation/Province";
                                 Accounts."Division/Department":="Division/Department";
                                 Accounts."Station/Sections":="Station/Sections";
                                 Accounts."Force No.":="Force No.";
                                 //Accounts."Vendor Posting Group":="Account Type";
                                 Accounts."Vendor Posting Group":=AccoutTypes."Posting Group";

                                 Accounts."FD Maturity Instructions":="FD Maturity Instructions";
                                 IF "Fixed Deposit"=TRUE THEN
                                 Accounts."Fixed Deposit Status":=Accounts."Fixed Deposit Status"::Active;
                                 Accounts.INSERT;
                                 END;
                                 //AccoutTypes."Ending Series":=INCSTR(AccoutTypes."Ending Series");
                                 //AccoutTypes.MODIFY;

                                 //END;

                                 {
                                 ImageData.RESET;
                                 ImageData.SETRANGE(ImageData."ID NO","ID No.");
                                 IF ImageData.FIND('-')=FALSE THEN BEGIN
                                 ImageData."ID NO":="ID No.";
                                 ImageData.Picture:=Picture;
                                 ImageData.Signature:=Signature;
                                 ImageData.INSERT(TRUE);
                                 END;
                                 }
                                 Accounts.RESET;
                                 IF Accounts.GET(AcctNo) THEN BEGIN
                                 Accounts.VALIDATE(Accounts.Name);
                                 Accounts.VALIDATE(Accounts."Account Type");
                                 Accounts.VALIDATE(Accounts."Global Dimension 1 Code");
                                 Accounts.VALIDATE(Accounts."Global Dimension 2 Code");
                                 Accounts.MODIFY;

                                 //Update BOSA with FOSA Account
                                 IF ("Account Type" = 'ORDINARY') THEN BEGIN
                                 IF Cust.GET("BOSA Account No") THEN BEGIN
                                 Cust."FOSA Account":=AcctNo;
                                 //Cust."FOSA Account":="No.";
                                 Cust.MODIFY;
                                 END;
                                 END;

                                 END;

                                 NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-') THEN BEGIN
                                 REPEAT
                                 NextOfKin.INIT;
                                 //NextOfKin."Account No":=AcctNo;
                                 NextOfKin."Account No":="No.";

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
                                 AccountSign.INSERT;

                                 UNTIL AccountSignApp.NEXT = 0;
                                 END;

                                 IF "Micro Single"=TRUE THEN BEGIN
                                 //MICRO FINANCE ACTIVITY
                                 //Create BOSA account
                                 Cust."No.":=AcctNo;
                                 Cust.Name:=Name;
                                 Cust.Address:=Address;
                                 Cust."Post Code":="Post Code";
                                 Cust.County:=City;
                                 Cust."Phone No.":="Phone No.";
                                 Cust."Global Dimension 1 Code":="Global Dimension 1 Code" ;
                                 Cust."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Cust."Customer Posting Group":='MICRO';
                                 Cust."Registration Date":="Registration Date";
                                 Cust.Status:=Cust.Status::Active;
                                 Cust."Employer Code":="Employer Code";
                                 Cust."Date of Birth":="Date of Birth";
                                 Cust."E-Mail":="E-Mail (Personal)";
                                 Cust.Location:=Location;
                                 //**
                                 Cust."ID No.":="ID No.";
                                 Cust."Group Code":="Group Code";
                                 Cust."Mobile Phone No":="Mobile Phone No";
                                 Cust."Marital Status":="Marital Status";
                                 Cust."Customer Type":=Cust."Customer Type"::MicroFinance;
                                 MESSAGE('The Micro Account No is %1',Cust."No.");
                                 MESSAGE('The Micro Member No is %1',Cust."No.");
                                 Cust.INSERT(TRUE);
                                 //END OF MICRO
                                 END;
                                  END;
                                 "Application Status" := "Application Status"::Converted;
                                 MODIFY;

                                 //Send SMS

                                 SendSMS;

                                 //MESSAGE('Account approved & created successfully.');
                                 //MESSAGE('Account approved & created successfully. Assign No. is - %1',AcctNo);
                                 MESSAGE('Account approved & created successfully. Assign No. is - %1',AcctNo);
                               END;
                                }
      { 1000000017;1 ;ActionGroup;
                      Name=Approvals }
      { 1000000016;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"FOSA Account Opening";
                                 ApprovalEntries.Setfilters(DATABASE::"Accounts Applications Details",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1000000015;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 Approvalmgt@1102755001 : Codeunit 439;
                               BEGIN

                                 IF "Account Type"='CORPORATE' THEN BEGIN
                                 IF "Account Category"="Account Category"::Single THEN BEGIN

                                 ERROR('Account category must not be single');
                                 END;
                                 END;

                                 IF AccountTypesSavingProducts.GET("Account Type") THEN BEGIN
                                 IF AccountTypesSavingProducts."Child Account"=TRUE THEN BEGIN
                                 IF "Childs Date Of Birth"=0D THEN
                                 ERROR('Childs Date Of Birth must have a value.');
                                 END;
                                 //IF ("Account Type"<>'CHILDREN') AND ("Account Type"<>'CORPORATE') AND ("Account Type"<>'FIXED') THEN BEGIN
                                 IF ("Fixed Deposit"<> TRUE) AND ("Allow Multiple Accounts"<>TRUE) THEN BEGIN
                                 IF "ID No."<>'' THEN BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."ID No.","ID No.");
                                 Vend.SETRANGE(Vend."Account Type","Account Type");
                                 IF Vend.FIND('-') THEN BEGIN
                                 ERROR('Account type already exists');
                                 END;
                                 END;
                                 END;
                                 //END;


                                 IF "Account Type"<>'JUNIOR' THEN BEGIN
                                 IF "Micro Group"<> TRUE THEN BEGIN
                                 TESTFIELD("Account Type");
                                 TESTFIELD("ID No.");
                                 TESTFIELD("Staff No");
                                 //TESTFIELD("BOSA Account No");
                                 TESTFIELD("Date of Birth");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("BOSA Account No");
                                 //TESTFIELD("Marital Status");
                                 TESTFIELD("Phone No.");
                                 TESTFIELD("Monthly Contribution");
                                 TESTFIELD("Recruited By");
                                 TESTFIELD("E-Mail");
                                 TESTFIELD("Employer Code");
                                 TESTFIELD(Address);
                                 //TESTFIELD(Gender);
                                 //TESTFIELD(Signature);
                                 //TESTFIELD(Picture);
                                 END;
                                 END;
                                 IF ("Micro Single"=TRUE) THEN BEGIN
                                 TESTFIELD("Group Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("Account Type");
                                 TESTFIELD(Signature);
                                 TESTFIELD(Picture);

                                 END;
                                 IF "Account Type"<>'JUNIOR' THEN BEGIN
                                 IF ("Micro Single"<>TRUE) AND ("Micro Group"<>TRUE) THEN
                                 IF "Account Type"='SAVINGS' THEN BEGIN
                                 TESTFIELD("BOSA Account No");
                                 END;
                                 END;

                                 IF "Micro Group"=TRUE THEN BEGIN
                                 IF "Account Type"='' THEN
                                 ERROR('Group accounts must have a Savings account kindly specify the account type ');
                                 //TESTFIELD("Account Type");
                                 TESTFIELD("Global Dimension 2 Code");
                                 END;


                                 IF "Fixed Deposit"=TRUE THEN BEGIN
                                 TESTFIELD("Savings Account No.");
                                 //TESTFIELD("Fixed Deposit Type");
                                 //TESTFIELD("FD Maturity Instructions");
                                 //IF "FD Duration"=0 THEN
                                 //ERROR('Kindly Specify the FD Duration');

                                 END;

                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);


                                 NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-')=FALSE THEN BEGIN
                                 ERROR(Text003);
                                 END;

                                 NextOfKinApp.RESET;
                                 NextOfKinApp.SETRANGE(NextOfKinApp."Account No","No.");
                                 IF NextOfKinApp.FIND('-') THEN BEGIN
                                 NextOfKinApp.TESTFIELD(Name);
                                 NextOfKinApp.TESTFIELD(Relationship);
                                 NextOfKinApp.TESTFIELD("Date of Birth");
                                 NextOfKinApp.TESTFIELD(Address);
                                 //NextOfKinApp.TESTFIELD("ID No.");
                                 NextOfKinApp.TESTFIELD(Telephone);
                                 END;

                                 IF "Account Category"<>"Account Category"::Single THEN BEGIN

                                 AccountSignApp.RESET;
                                 AccountSignApp.SETRANGE(AccountSignApp."Account No","No.");
                                 IF AccountSignApp.FIND('-')=FALSE THEN BEGIN
                                 ERROR(Text004);
                                 END;
                                 END;

                                 IF Status=Status::Open THEN BEGIN

                                 IF ApprovalMgmt.CheckSproductApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalMgmt.OnSendSProductDocForApproval(Rec);

                                 //   Status:=Status::Approved;
                                 // "Application Status":="Application Status"::Approved;
                                 // MODIFY;
                                 END;
                                 //MESSAGE('Account application approved succesful');

                                 //End allocate batch number
                                 //IF Approvalmgt.SendFOSA(Rec) THEN;


                                 {
                                 ///send sms
                                 GenSetUp.GET;
                                 CompInfo.GET;

                                 IF GenSetUp."Send SMS Notifications"=TRUE THEN BEGIN
                                 IF Vend."Sms Notification"=TRUE THEN BEGIN

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
                                 SMSMessage.Source:='FOSA';
                                 SMSMessage."Entered By":=USERID;
                                 SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                 SMSMessage."SMS Message":='Dear Client you have been registered successfully, your Fosa No is '
                                 + "No."+' Name '+Name+' ' +CompInfo.Name+' '+GenSetUp."Customer Care No";
                                 SMSMessage."Telephone No":="Phone No.";
                                 IF "Phone No."<>'' THEN
                                 SMSMessage.INSERT;

                                 END;
                                 END;
                                 }
                                 END;
                               END;
                                }
      { 1000000013;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 439;
                               BEGIN

                                 //IF Approvalmgt.CancelFOSAAApprovalRequest(Rec,TRUE,TRUE) THEN;
                                 IF ApprovalMgmt.CheckSproductApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalMgmt.OnCancelSProductApprovalRequest(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000049;0;Container;
                ContainerType=ContentArea }

    { 1000000048;1;Group  ;
                CaptionML=ENU=General }

    { 1000000047;2;Field  ;
                SourceExpr="No." }

    { 1000000046;2;Field  ;
                SourceExpr="Micro Single";
                Visible=FALSE;
                Editable=TRUE }

    { 1000000045;2;Field  ;
                SourceExpr="Micro Group";
                Visible=FALSE;
                Editable=TRUE }

    { 1000000044;2;Field  ;
                SourceExpr="Group Code";
                Visible=FALSE;
                Editable=TRUE }

    { 1000000043;2;Field  ;
                SourceExpr="BOSA Account No";
                Editable=TRUE }

    { 1000000042;2;Field  ;
                SourceExpr="Account Type";
                OnValidate=BEGIN
                             Controls;
                           END;
                            }

    { 1000000012;2;Group  ;
                Name=parent;
                Visible=Parent;
                GroupType=Group }

    { 1000000020;3;Field  ;
                SourceExpr="Parent Account No." }

    { 1000000041;2;Field  ;
                SourceExpr=Name }

    { 1000000040;2;Field  ;
                SourceExpr=Address }

    { 1000000039;2;Field  ;
                SourceExpr="Address 2" }

    { 1120054002;2;Field  ;
                SourceExpr="Child Name" }

    { 1120054003;2;Field  ;
                SourceExpr="Childs Date Of Birth" }

    { 1120054004;2;Field  ;
                SourceExpr="Childs Birth Certificate No" }

    { 1000000038;2;Field  ;
                CaptionML=ENU=Post Code/City;
                SourceExpr="Post Code" }

    { 1000000037;2;Field  ;
                SourceExpr="Country/Region Code" }

    { 1000000036;2;Field  ;
                SourceExpr="Phone No.";
                ShowMandatory=TRUE }

    { 1000000035;2;Field  ;
                SourceExpr="E-Mail" }

    { 1120054000;2;Field  ;
                SourceExpr=Gender }

    { 1000000034;2;Field  ;
                SourceExpr="ID No.";
                OnValidate=BEGIN
                             Acc.RESET;
                             Acc.SETRANGE(Acc."ID No.","ID No.");
                             Acc.SETRANGE(Acc."Account Type","Account Type");
                             Acc.SETRANGE(Acc.Status,Acc.Status::Active);
                             IF Acc.FIND('-') THEN
                             ERROR('Account already created.');
                           END;
                            }

    { 1000000033;2;Field  ;
                SourceExpr="Passport No." }

    { 1000000032;2;Field  ;
                SourceExpr="Staff No" }

    { 1000000051;2;Field  ;
                SourceExpr=Signature }

    { 1000000050;2;Field  ;
                SourceExpr=Picture }

    { 1000000031;2;Field  ;
                SourceExpr="Marital Status" }

    { 1000000030;2;Field  ;
                SourceExpr="Employer Code" }

    { 1000000029;2;Field  ;
                SourceExpr="Date of Birth" }

    { 1000000028;2;Field  ;
                SourceExpr="Signing Instructions" }

    { 1000000027;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1000000026;2;Field  ;
                SourceExpr=City;
                Editable=FALSE }

    { 1000000025;2;Field  ;
                SourceExpr=Status;
                Editable=false }

    { 1000000067;2;Field  ;
                SourceExpr="Created By" }

    { 1000000024;2;Field  ;
                SourceExpr="Application Status";
                Editable=FALSE }

    { 1000000023;2;Field  ;
                SourceExpr="Monthly Contribution" }

    { 1000000022;2;Field  ;
                SourceExpr="Recruited By" }

    { 1000000021;2;Field  ;
                SourceExpr="Account Category" }

    { 1000000019;2;Field  ;
                SourceExpr="Application Date" }

    { 1000000014;2;Field  ;
                SourceExpr="Kin No";
                Visible=TRUE }

    { 1000000011;2;Field  ;
                SourceExpr="Purchaser Code" }

    { 1000000052;1;Group  ;
                CaptionML=ENU=FIXED DEPOSIT;
                GroupType=Group }

    { 1000000058;2;Field  ;
                SourceExpr="Fixed Deposit Type";
                Visible=true }

    { 1000000057;2;Field  ;
                SourceExpr="FD Duration" }

    { 1000000056;2;Field  ;
                SourceExpr="FD Maturity Date";
                Visible=true;
                Editable=FALSE }

    { 1000000055;2;Field  ;
                SourceExpr="Savings Account No.";
                Visible=TRUE }

    { 1000000054;2;Field  ;
                SourceExpr="Neg. Interest Rate" }

    { 1000000053;2;Field  ;
                SourceExpr="FD Maturity Instructions" }

    { 1000000010;1;Group  ;
                CaptionML=ENU=Communication }

    { 1000000009;2;Field  ;
                SourceExpr="Fax No." }

    { 1000000008;2;Field  ;
                SourceExpr="E-Mail (Personal)" }

    { 1000000007;2;Field  ;
                SourceExpr="Home Page" }

    { 1000000006;2;Field  ;
                SourceExpr="IC Partner Code";
                OnValidate=BEGIN
                             ICPartnerCodeOnAfterValidate;
                           END;
                            }

    { 1000000005;2;Field  ;
                SourceExpr="Home Address" }

    { 1000000004;2;Field  ;
                SourceExpr=District }

    { 1000000003;2;Field  ;
                SourceExpr=Location }

    { 1000000002;2;Field  ;
                SourceExpr="Sub-Location" }

    { 1000000066;2;Field  ;
                SourceExpr="Sms Notification" }

    { 1000000001;1;Group  ;
                CaptionML=ENU=Foreign Trade }

    { 1000000000;2;Field  ;
                SourceExpr="Currency Code" }

  }
  CODE
  {
    VAR
      CalendarMgmt@1000 : Codeunit 7600;
      PaymentToleranceMgt@1002 : Codeunit 426;
      CustomizedCalEntry@1001 : Record 7603;
      CustomizedCalendar@1003 : Record 7602;
      Text001@1005 : TextConst 'ENU=Do you want to allow payment tolerance for entries that are currently open?';
      Text002@1004 : TextConst 'ENU=Do you want to remove payment tolerance from entries that are currently open?';
      PictureExists@1102760000 : Boolean;
      AccoutTypes@1102760001 : Record 51516295;
      Accounts@1102760002 : Record 23;
      AcctNo@1102760003 : Code[50];
      DimensionValue@1102760004 : Record 349;
      NextOfKin@1102760005 : Record 51516293;
      NextOfKinApp@1102760006 : Record 51516291;
      AccountSign@1102760007 : Record 51516294;
      AccountSignApp@1102760008 : Record 51516292;
      Acc@1102760009 : Record 23;
      UsersID@1102760010 : Record 2000000120;
      Nok@1102760011 : Record 51516291;
      Cust@1102760012 : Record 51516223;
      NOKBOSA@1102760013 : Record 51516293;
      BranchC@1102756000 : Code[20];
      DimensionV@1102756001 : Record 349;
      IncrementNo@1102756002 : Code[20];
      MicSingle@1102755000 : Boolean;
      MicGroup@1102755001 : Boolean;
      BosaAcnt@1102755002 : Boolean;
      EmailEdiatble@1000000012 : Boolean;
      DocumentType@1102755003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,STO';
      SaccoSetup@1102755004 : Record 51516258;
      MicroGroupCode@1102755005 : Boolean;
      Vendor@1102755006 : Record 23;
      NameEditable@1000000000 : Boolean;
      NoEditable@1000000001 : Boolean;
      AddressEditable@1000000002 : Boolean;
      GlobalDim1Editable@1000000003 : Boolean;
      GlobalDim2Editable@1000000004 : Boolean;
      VendorPostingGroupEdit@1000000005 : Boolean;
      PhoneEditable@1000000006 : Boolean;
      MaritalstatusEditable@1000000007 : Boolean;
      IDNoEditable@1000000008 : Boolean;
      RegistrationDateEdit@1000000009 : Boolean;
      EmployerCodeEditable@1000000010 : Boolean;
      DOBEditable@1000000011 : Boolean;
      StaffNoEditable@1000000013 : Boolean;
      GenderEditable@1000000014 : Boolean;
      MonthlyContributionEdit@1000000015 : Boolean;
      PostCodeEditable@1000000016 : Boolean;
      CityEditable@1000000017 : Boolean;
      RecruitedEditable@1000000018 : Boolean;
      ContactPEditable@1000000019 : Boolean;
      ContactPRelationEditable@1000000020 : Boolean;
      ContactPOccupationEditable@1000000021 : Boolean;
      ContactPPhoneEditable@1000000022 : Boolean;
      Accountype@1000000023 : Boolean;
      Vend@1000000028 : Record 23;
      GenSetUp@1000000027 : Record 51516257;
      CompInfo@1000000026 : Record 79;
      SMSMessage@1000000025 : Record 51516329;
      iEntryNo@1000000024 : Integer;
      Text003@1000000030 : TextConst 'ENU=Kindly specify the next of kin';
      Text004@1000000029 : TextConst 'ENU=Kindly Specify the Signatories';
      parent@1000000031 : Boolean;
      ApprovalMgmt@1000000032 : Codeunit 1535;
      Account@1000000033 : Code[10];
      UserSetup@1120054000 : Record 91;
      AccountTypesSavingProducts@1120054001 : Record 51516295;

    PROCEDURE ActivateFields@3();
    BEGIN
    END;

    LOCAL PROCEDURE ContactOnAfterValidate@19013243();
    BEGIN
      ActivateFields;
    END;

    LOCAL PROCEDURE ICPartnerCodeOnAfterValidate@19032922();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE OnAfterGetCurrRecord@19077479();
    BEGIN
      xRec := Rec;
      ActivateFields;

      Controls();
    END;

    PROCEDURE Controls@1102755002();
    BEGIN
      //IF (MicSingle = TRUE) OR (MicGroup=TRUE) THEN
      //BosaAcnt:=FALSE

      IF "Micro Single" = TRUE THEN
      MicroGroupCode:=TRUE;
      IF "Account Type"='JUNIOR' THEN
        parent:=TRUE;
    END;

    PROCEDURE UpdateControls@1102755003();
    BEGIN

           IF Status=Status::Approved THEN BEGIN
           NameEditable:=FALSE;
           NoEditable:=FALSE;
           AddressEditable:=FALSE;
           GlobalDim1Editable:=FALSE;
           GlobalDim2Editable:=FALSE;
           VendorPostingGroupEdit:=FALSE;
           PhoneEditable:=FALSE;
           MaritalstatusEditable:=FALSE;
           IDNoEditable:=FALSE;
           PhoneEditable:=FALSE;
           RegistrationDateEdit:=FALSE;
           //OfficeBranchEditable:=FALSE;
           //DeptEditable:=FALSE;
           //SectionEditable:=FALSE;
           //OccupationEditable:=FALSE;
           //DesignationEdiatble:=FALSE;
           EmployerCodeEditable:=FALSE;
           DOBEditable:=FALSE;
           EmailEdiatble:=FALSE;
           StaffNoEditable:=FALSE;
           GenderEditable:=FALSE;
           MonthlyContributionEdit:=FALSE;
           PostCodeEditable:=FALSE;
           CityEditable:=FALSE;
           //WitnessEditable:=FALSE;
           //BankCodeEditable:=FALSE;
           //BranchCodeEditable:=FALSE;
           //BankAccountNoEditable:=FALSE;
           //VillageResidence:=FALSE;
           //TitleEditable:=FALSE;
           //PostalCodeEditable:=FALSE;
           //HomeAddressPostalCodeEditable:=FALSE;
           //HomeTownEditable:=FALSE;
           RecruitedEditable:=FALSE;
           ContactPEditable:=FALSE;
           ContactPRelationEditable:=FALSE;
           ContactPOccupationEditable:=FALSE;
           //CopyOFIDEditable:=FALSE;
           //CopyofPassportEditable:=FALSE;
           //SpecimenEditable:=FALSE;
           ContactPPhoneEditable:=FALSE;
           //HomeAdressEditable:=FALSE;
           //PictureEditable:=FALSE;
           //SignatureEditable:=FALSE;
           Accountype:=TRUE;

           END;


           IF Status=Status::Open THEN BEGIN
           NameEditable:=TRUE;
           NoEditable:=TRUE;
           AddressEditable:=TRUE;
           GlobalDim1Editable:=TRUE;
           GlobalDim2Editable:=TRUE;
           VendorPostingGroupEdit:=TRUE;
           PhoneEditable:=TRUE;
           MaritalstatusEditable:=TRUE;
           IDNoEditable:=TRUE;
           PhoneEditable:=TRUE;
           RegistrationDateEdit:=TRUE;
           //OfficeBranchEditable:=FALSE;
           //DeptEditable:=FALSE;
           //SectionEditable:=FALSE;
           //OccupationEditable:=FALSE;
           //DesignationEdiatble:=FALSE;
           EmployerCodeEditable:=TRUE;
           DOBEditable:=TRUE;
           EmailEdiatble:=TRUE;
           StaffNoEditable:=TRUE;
           GenderEditable:=TRUE;
           MonthlyContributionEdit:=TRUE;
           PostCodeEditable:=TRUE;
           CityEditable:=TRUE;
           Accountype:=TRUE;
           //WitnessEditable:=FALSE;
           //BankCodeEditable:=FALSE;
           //BranchCodeEditable:=FALSE;
           //BankAccountNoEditable:=FALSE;
           //VillageResidence:=FALSE;
           //TitleEditable:=FALSE;
           //PostalCodeEditable:=FALSE;
           //HomeAddressPostalCodeEditable:=FALSE;
           //HomeTownEditable:=FALSE;
           RecruitedEditable:=TRUE;
           ContactPEditable:=TRUE;
           ContactPRelationEditable:=TRUE;
           ContactPOccupationEditable:=TRUE;
           //CopyOFIDEditable:=FALSE;
           //CopyofPassportEditable:=FALSE;
           //SpecimenEditable:=FALSE;
           ContactPPhoneEditable:=TRUE;
           //HomeAdressEditable:=FALSE;
           //PictureEditable:=FALSE;
           //SignatureEditable:=FALSE;

           END;
    END;

    PROCEDURE SendSMS@1000000000();
    BEGIN
      GenSetUp.GET;
      CompInfo.GET;


      IF GenSetUp."Send SMS Notifications"=TRUE THEN BEGIN

      //SMS FOSA MESSAGE
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
      SMSMessage.Source:='FOSAACC';
      SMSMessage."SMS Message":='Your FOSA Account No. '+ AcctNo +' of type '+"Account Type"+' has been opened successfully.' +CompInfo.Name;
      SMSMessage."Entered By":=USERID;
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      SMSMessage."Telephone No":="Phone No.";
      IF "Phone No."<>'' THEN
      SMSMessage.INSERT;

      //MESSAGE('TESTING SMS==>'+"Phone No.");

      END;
    END;

    BEGIN
    END.
  }
}

