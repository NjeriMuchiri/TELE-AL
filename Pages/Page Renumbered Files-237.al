OBJECT page 17428 Account Applications Master
{
  OBJECT-PROPERTIES
  {
    Date=02/15/22;
    Time=[ 9:49:20 AM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516290;
    SourceTableView=WHERE(Application Status=FILTER(<>Converted));
    PageType=List;
    CardPageID=Account Application Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1102755022;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755021;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1102755020;2 ;Action    ;
                      Name=Next of Kin;
                      CaptionML=ENU=Next of Kin;
                      RunObject=page 17430;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1102755019;2 ;Action    ;
                      Name=[Account Signatories ];
                      CaptionML=ENU=Signatories;
                      RunObject=page 17431;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Group;
                      PromotedCategory=Process }
      { 1102755017;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755016;1 ;Action    ;
                      CaptionML=ENU=Approve;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //TESTFIELD("Employer Code");
                                 TESTFIELD("Account Type");
                                 TESTFIELD("ID No.");
                                 TESTFIELD("Staff No");
                                 //TESTFIELD("BOSA Account No");
                                 TESTFIELD("Date of Birth");
                                 TESTFIELD("Global Dimension 2 Code");
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
                                   TESTFIELD("Savings Account No.");
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
                                 DimensionValue.TESTFIELD(DimensionValue."Account Code");
                                 //AcctNo:=AccoutTypes."Account No Prefix" + '-' + DimensionValue."Account Code" + '-' + DimensionValue."No. Series"
                                 // + '-' + AccoutTypes."Ending Series";
                                 AcctNo:=AccoutTypes."Account No Prefix" + '-' + INCSTR(DimensionValue."No. Series")
                                  + '-' + AccoutTypes."Ending Series";


                                 IF (AccoutTypes."Use Savings Account Number" = TRUE)  THEN BEGIN
                                 TESTFIELD("Savings Account No.");
                                 AcctNo:=AccoutTypes."Account No Prefix" + COPYSTR("Savings Account No.",4)
                                 END ELSE
                                 DimensionValue."No. Series":=INCSTR(DimensionValue."No. Series");
                                 DimensionValue.MODIFY;
                                 END;

                                 END ELSE BEGIN
                                 TESTFIELD("Kin No");
                                 AcctNo:=COPYSTR("Parent Account No.",1,14) + "Kin No";
                                 END;
                                 IF AccoutTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF "Kin No" <> '' THEN
                                 AcctNo:=COPYSTR(AcctNo,1,14) + "Kin No";
                                 END;
                                 ///////


                                 Accounts.INIT;
                                 //Accounts."No.":=AcctNo;
                                 Accounts."No.":="No.";
                                 AcctNo:="No.";
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
                                 {NextOfKin.Fax:=NextOfKinApp.Fax;
                                 NextOfKin.Email:=NextOfKinApp.Email;
                                 NextOfKin."ID No.":=NextOfKinApp."ID No.";
                                 NextOfKin."%Allocation":=NextOfKinApp."%Allocation";
                                 NextOfKin.INSERT;}

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


                                 MESSAGE('Account approved & created successfully.');
                               END;
                                }
      { 1102755015;1 ;Action    ;
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
      { 1102755014;1 ;ActionGroup;
                      Name=Approvals }
      { 1102755013;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"FOSA Account Opening";
                                 ApprovalEntries.Setfilters(DATABASE::Table50062,DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755012;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 Approvalmgt@1102755001 : Codeunit 439;
                               BEGIN
                                 IF "Micro Group"<> TRUE THEN BEGIN
                                 TESTFIELD("Account Type");
                                 TESTFIELD("ID No.");
                                 //TESTFIELD("Staff No");
                                 //TESTFIELD("BOSA Account No");
                                 TESTFIELD("Date of Birth");
                                 TESTFIELD("Global Dimension 2 Code");
                                 END;

                                 IF ("Micro Single"=TRUE) THEN BEGIN
                                 TESTFIELD("Group Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("Account Type");
                                 END;

                                 IF ("Micro Single"<>TRUE) AND ("Micro Group"<>TRUE) THEN
                                 IF "Account Type"='SAVINGS' THEN BEGIN
                                 TESTFIELD("BOSA Account No");
                                 END;

                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);

                                 //End allocate batch number
                                 //IF Approvalmgt.SendFOSAAApprovalRequest(Rec) THEN;
                               END;
                                }
      { 1102755011;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 439;
                               BEGIN

                                 //IF Approvalmgt.CancelFOSAAApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755010;2 ;Action    ;
                      Name=Create;
                      CaptionML=ENU=Create;
                      Promoted=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //TESTFIELD("Employer Code");
                                 //SaccoSetup.GET;

                                 IF Status<>Status::Approved THEN
                                 ERROR('Account application not approved');

                                 IF "Micro Group"<> TRUE THEN BEGIN
                                 TESTFIELD("Account Type");
                                 TESTFIELD("ID No.");
                                 //TESTFIELD("Staff No");
                                 //TESTFIELD("BOSA Account No");
                                 TESTFIELD("Date of Birth");
                                 TESTFIELD("Global Dimension 2 Code");
                                 TESTFIELD("BOSA Account No");
                                 END;

                                 IF "Micro Single"=TRUE THEN BEGIN
                                 TESTFIELD("Group Code");
                                 TESTFIELD("Global Dimension 2 Code");
                                 END;

                                 //IF ("Micro Single"<>TRUE) AND ("Micro Group"<>TRUE) THEN
                                 //TESTFIELD("BOSA Account No");
                                 IF ("Micro Single"<>TRUE) AND ("Micro Group"<>TRUE) THEN
                                 IF "Account Type"='SAVINGS' THEN BEGIN
                                 TESTFIELD("BOSA Account No");
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

                                 IF ("Account Type" = 'SAVINGS') THEN BEGIN
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
                                 //END;


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



                                  //cyrus times u secific
                                 IF "Micro Single"<>TRUE THEN BEGIN
                                 IF DimensionValue.GET('BRANCH',"Global Dimension 2 Code") THEN BEGIN
                                 DimensionValue.TESTFIELD(DimensionValue."Account Code");
                                 //AcctNo:=AccoutTypes."Account No Prefix" + '-' + DimensionValue."Account Code" + '-' + DimensionValue."No. Series"
                                 // + '-' + AccoutTypes."Ending Series";
                                 //AcctNo:='6864'+DimensionValue."Account Code"+ AccoutTypes."Account No Prefix"+"BOSA Account No";//AccoutTypes."Ending Series";
                                 //AccoutTypes."Ending Series":=INCSTR(AccoutTypes."Ending Series");
                                 //AccoutTypes.MODIFY;
                                 AcctNo:=AccoutTypes."Account No Prefix"+"BOSA Account No";
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

                                 END;

                                 {
                                 IF "Parent Account No." = '' THEN BEGIN

                                 IF (AccoutTypes."Use Savings Account Number" = TRUE)  THEN BEGIN
                                 TESTFIELD("Savings Account No.");
                                 AcctNo:=AccoutTypes."Account No Prefix" + COPYSTR("Savings Account No.",4)
                                 END ELSE
                                 DimensionValue."No. Series":=INCSTR(DimensionValue."No. Series");
                                 DimensionValue.MODIFY;
                                 END;

                                 END ELSE BEGIN
                                 TESTFIELD("Kin No");
                                 AcctNo:=COPYSTR("Parent Account No.",1,14) + "Kin No";
                                 END;
                                 IF AccoutTypes."Fixed Deposit" = TRUE THEN BEGIN
                                 IF "Kin No" <> '' THEN
                                 AcctNo:=COPYSTR(AcctNo,1,14) + "Kin No";
                                 END;
                                 ///////
                                 END;
                                  }


                                 IF "Micro Group"=TRUE THEN BEGIN
                                 SaccoSetup.RESET;
                                 SaccoSetup.GET;
                                 Accounts.INIT;
                                 Accounts."No.":=SaccoSetup."Micro Group Nos.";
                                 MESSAGE('The Group no is %1',Accounts."No.");
                                 //AcctNo:="No.";
                                 Accounts.Name:=Name;
                                 Accounts."Creditor Type":=Accounts."Creditor Type"::Account;
                                 Accounts."Debtor Type":=Accounts."Debtor Type"::"FOSA Account";
                                 Accounts."Global Dimension 1 Code":='MICRO';
                                 Accounts."Global Dimension 2 Code":="Global Dimension 2 Code";
                                 Accounts."Group Account":=TRUE;
                                 Accounts."Registration Date":=TODAY;
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
                                 Accounts."Account Type":="Account Type";
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
                                 Accounts."Registration Date":=TODAY;
                                 Accounts."Monthly Contribution" := "Monthly Contribution";
                                 Accounts."Formation/Province":="Formation/Province";
                                 Accounts."Division/Department":="Division/Department";
                                 Accounts."Station/Sections":="Station/Sections";
                                 Accounts."Force No.":="Force No.";
                                 Accounts."Vendor Posting Group":="Account Type";
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
                                 Accounts."ContactPerson Relation":="ContactPerson Relation";
                                 Accounts."ContactPerson Occupation":="ContacPerson Occupation";
                                 Accounts."Recruited By":="Recruited By";
                                 Accounts."ContacPerson Phone":="ContacPerson Phone";
                                 Accounts."Monthly Contribution" := "Monthly Contribution";
                                 Accounts."Formation/Province":="Formation/Province";
                                 Accounts."Division/Department":="Division/Department";
                                 Accounts."Station/Sections":="Station/Sections";
                                 Accounts."Force No.":="Force No.";
                                 Accounts."Vendor Posting Group":="Account Type";
                                 Accounts.INSERT;
                                 END;
                                 //AccoutTypes."Ending Series":=INCSTR(AccoutTypes."Ending Series");
                                 //AccoutTypes.MODIFY;

                                 //END;


                                 Accounts.RESET;
                                 IF Accounts.GET(AcctNo) THEN BEGIN
                                 Accounts.VALIDATE(Accounts.Name);
                                 Accounts.VALIDATE(Accounts."Account Type");
                                 Accounts.VALIDATE(Accounts."Global Dimension 1 Code");
                                 Accounts.VALIDATE(Accounts."Global Dimension 2 Code");
                                 Accounts.MODIFY;

                                 //Update BOSA with FOSA Account
                                 IF ("Account Type" = 'SAVINGS') THEN BEGIN
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
                                 {
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
                                 NextOfKin.INSERT; }

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
                                 //Cyrus for micro
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
                                 MESSAGE('The Micro BOSA No is %1',Cust."No.");
                                 Cust.INSERT(TRUE);
                                 //cyrus for micro
                                 END;

                                 "Application Status" := "Application Status"::Converted;
                                 MODIFY;


                                 //MESSAGE('Account approved & created successfully.');
                                 MESSAGE('Account approved & created successfully. Assign No. is - %1',AcctNo);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755023;2;Field  ;
                SourceExpr=Status }

    { 1   ;2   ;Field     ;
                SourceExpr="Staff No" }

    { 2   ;2   ;Field     ;
                SourceExpr="ID No." }

    { 3   ;2   ;Field     ;
                SourceExpr="Mobile Phone No" }

    { 4   ;2   ;Field     ;
                SourceExpr="BOSA Account No" }

    { 1000000000;2;Field  ;
                SourceExpr="Created By" }

  }
  CODE
  {
    VAR
      CalendarMgmt@1102755024 : Codeunit 7600;
      PaymentToleranceMgt@1102755023 : Codeunit 426;
      CustomizedCalEntry@1102755022 : Record 7603;
      CustomizedCalendar@1102755021 : Record 7602;
      PictureExists@1102755020 : Boolean;
      AccoutTypes@1102755019 : Record 51516295;
      Accounts@1102755018 : Record 23;
      AcctNo@1102755017 : Code[50];
      DimensionValue@1102755016 : Record 349;
      NextOfKin@1102755015 : Record 51516225;
      NextOfKinApp@1102755014 : Record 51516291;
      AccountSign@1102755013 : Record 51516294;
      AccountSignApp@1102755012 : Record 51516292;
      Acc@1102755011 : Record 23;
      UsersID@1102755010 : Record 2000000120;
      Nok@1102755009 : Record 51516291;
      Cust@1102755008 : Record 51516223;
      NOKBOSA@1102755007 : Record 51516225;
      BranchC@1102755006 : Code[20];
      DimensionV@1102755005 : Record 349;
      IncrementNo@1102755004 : Code[20];
      MicSingle@1102755003 : Boolean;
      MicGroup@1102755002 : Boolean;
      BosaAcnt@1102755001 : Boolean;
      DocumentType@1102755000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,STO';
      SaccoSetup@1000000000 : Record 51516258;

    BEGIN
    END.
  }
}

