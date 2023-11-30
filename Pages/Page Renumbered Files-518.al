OBJECT page 172113 CloudPesa Change Request
{
  OBJECT-PROPERTIES
  {
    Date=07/26/23;
    Time=12:11:23 PM;
    Modified=Yes;
    Version List=Change RequestV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516350;
    PageType=Card;
    OnOpenPage=BEGIN
                 AccountVisible:=FALSE;
                 MobileVisible:=FALSE;
                 AtmVisible:=FALSE;
                 nxkinvisible:=FALSE;
                 PicturesVisible:=FALSE;
                 IF Type=Type::"Mobile Change" THEN BEGIN
                   MobileVisible:=TRUE;
                 END;

                 IF Type=Type::"Atm Change" THEN BEGIN
                   AtmVisible:=TRUE;
                 END;
                 IF Type=Type::"Backoffice Change" THEN BEGIN
                   AccountVisible:=TRUE;
                   nxkinvisible:=TRUE;
                 END;

                 IF Type=Type::"Agile Change" THEN BEGIN
                   AccountVisible:=TRUE;
                   nxkinvisible:=TRUE;
                 END;

                 IF Type=Type::"Picture Change" THEN BEGIN
                 PicturesVisible:=TRUE;
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       AccountVisible:=FALSE;
                       MobileVisible:=FALSE;
                       AtmVisible:=FALSE;
                       nxkinvisible:=FALSE;
                       PicturesVisible:=FALSE;
                       IF Type=Type::"Mobile Change" THEN BEGIN
                         MobileVisible:=TRUE;
                       END;

                       IF Type=Type::"Atm Change" THEN BEGIN
                         AtmVisible:=TRUE;

                       END;

                       IF Type=Type::"Backoffice Change" THEN BEGIN
                         AccountVisible:=TRUE;
                         nxkinvisible:=TRUE;
                       END;

                       IF Type=Type::"Agile Change" THEN BEGIN
                         AccountVisible:=TRUE;
                         nxkinvisible:=TRUE;
                       END;

                       IF Type=Type::"Picture Change" THEN BEGIN
                       PicturesVisible:=TRUE;
                       END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           DetailsEditable:=TRUE;
                           IF Status<>Status::Open THEN
                           DetailsEditable:=FALSE;
                         END;

    ActionList=ACTIONS
    {
      { 1000000043;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000060;1 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 //DocumentType:=DocumentType::"Account Opening";
                                 //ApprovalEntries.Setfilters(DATABASE::"51516350",DocumentType,"No.");
                                 //ApprovalEntries.RUN;
                               END;
                                }
      { 1000000059;1 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text001@1102755000 : TextConst 'ENU=This request is already pending approval';
                                 ApprovalsMgmt@1000000000 : Codeunit 1535;
                               BEGIN
                                 // IF UsersetUp.GET(USERID) THEN BEGIN
                                 //   IF NOT UsersetUp."Edit Atm Changes" THEN
                                 //    ERROR('you are not allowed to make this change kindly contact system admin');
                                 //   END ELSE BEGIN
                                 //     ERROR(UserNotFound,USERID);
                                 //     END;
                                 IF Type=Type::"Agile Change" THEN BEGIN
                                    TESTFIELD("Member No");
                                    TESTFIELD("Reason for change");
                                    TESTFIELD("ID No");
                                    TESTFIELD("KRA Pin");
                                    TESTFIELD("Date Of Birth");
                                   END;
                                 IF Type=Type::"Backoffice Change" THEN  BEGIN
                                    TESTFIELD("Date Of Birth");
                                    TESTFIELD("Reason for change");
                                    TESTFIELD("ID No");
                                    TESTFIELD("KRA Pin");
                                   END;

                                 IF Type=Type::"Mobile Change" THEN  BEGIN
                                    TESTFIELD("Reason For Change Moble");
                                   END;
                                 IF Status<>Status::Open THEN
                                 ERROR(Text001);



                                 IF ApprovalsMgmt.CheckChangeRequestApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendChangeRequestForApproval(Rec);

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Change Request Sent For Approval',0,'CHANGEREQUEST',TODAY,TIME,'',No,"Account No",'');
                                 //End Create Audit Entry
                               END;
                                }
      { 1000000057;1 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Approvalmgt@1102755000 : Codeunit 1535;
                               BEGIN
                                 IF Approvalmgt.CheckChangeRequestApprovalsWorkflowEnabled(Rec) THEN
                                   Approvalmgt.OnCancelChangeRequestApprovalRequest(Rec);

                               END;
                                }
      { 1000000047;1 ;Separator  }
      { 1000000054;1 ;Action    ;
                      CaptionML=ENU=Populate;
                      Promoted=Yes;
                      Image=GetLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                   IF (Type=Type::"Mobile Change") OR (Type=Type::"Atm Change") THEN BEGIN
                                    ERROR('Only Backoffice change or Agile Change allows you to Populate Next of Kin');
                                   END;
                                   IF (Type=Type::"Backoffice Change") THEN BEGIN

                                   END;

                                 IF (Type=Type::"Agile Change") THEN BEGIN
                                   ProductNxK.RESET;
                                   ProductNxK.SETRANGE(ProductNxK."Account No","Account No");
                                   IF ProductNxK.FIND('-') THEN
                                     MESSAGE(FORMAT("Account No"));
                                     REPEAT;
                                       Kinchangedetails.INIT;
                                       Kinchangedetails."Account No":="Account No";
                                       Kinchangedetails.Name:=ProductNxK.Name;
                                       Kinchangedetails.Relationship:=ProductNxK.Relationship;
                                       Kinchangedetails.Beneficiary:=ProductNxK.Beneficiary;
                                       Kinchangedetails."Date of Birth":=ProductNxK."Date of Birth";
                                       Kinchangedetails.Address:=ProductNxK.Address;
                                       Kinchangedetails.Telephone:=ProductNxK.Telephone;
                                       Kinchangedetails.Fax:=ProductNxK.Fax;
                                       Kinchangedetails.Email:=ProductNxK.Email;
                                       Kinchangedetails."ID No.":=ProductNxK."ID No.";
                                       Kinchangedetails."%Allocation":=ProductNxK."%Allocation";
                                       Kinchangedetails.INSERT;

                                     UNTIL ProductNxK.NEXT=0;
                                     MESSAGE('Next of Kin Details Populated Successfully');
                                   END;
                               END;
                                }
      { 1000000055;1 ;Separator  }
      { 1000000056;1 ;Action    ;
                      CaptionML=ENU=Next of Kin;
                      RunObject=20373;
                      RunPageLink=No.=FIELD(Account No);
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Process }
      { 1000000058;1 ;Action    ;
                      CaptionML=ENU=Update Changes;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UpdateShipment;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF (Status<>Status::Approved) THEN BEGIN
                                 ERROR('Change Request Must be Approved First');
                                 END;

                                 IF ((Type=Type::"Mobile Change")) THEN BEGIN
                                        //TESTFIELD(ne);ne
                                        vend.RESET;
                                        vend.SETRANGE(vend."No.","Account No");
                                       IF vend.FIND('-') THEN BEGIN
                                          vend."Mobile Phone No":= "S-Mobile No";
                                          vend. "MPESA Mobile No":="S-Mobile No";
                                          vend."Phone No.":="S-Mobile No";

                                          vend.MODIFY;

                                    Memb.RESET;
                                       Memb.SETRANGE(Memb."No.",vend."BOSA Account No");
                                     IF Memb.FIND('-') THEN BEGIN
                                       Memb."Mobile Phone No":= "S-Mobile No";
                                         Memb."Phone No.":="S-Mobile No";
                                         Memb.MODIFY;
                                     END;
                                       END;

                                 END;
                                 IF  ((Type=Type::"Atm Change")) THEN BEGIN
                                        vend.RESET;
                                        vend.SETRANGE(vend."No.","Account No");
                                       IF vend.FIND('-') THEN  BEGIN
                                          vend."Card Expiry Date":= "Card Expiry Date";
                                          vend."Card No.":="ATM No.(New)";
                                         IF  "ATM No.(New)"<>'' THEN
                                          vend."ATM No.":="ATM No.(New)";
                                          vend."Card Valid From":="Card Valid From";
                                          vend."Card Valid To":="Card Valid To";
                                          vend.MODIFY;
                                       END;
                                  END;

                                 IF  ((Type=Type::"Agile Change")) THEN BEGIN
                                 TESTFIELD(Designation);
                                 TESTFIELD("KRA Pin");
                                 TESTFIELD("Mobile No");
                                 TESTFIELD("Monthly Contributions");
                                 IF "Workstation New"='' THEN
                                 TESTFIELD(workstation);
                                        vend.RESET;
                                        vend.SETRANGE(vend."No.","Account No");
                                       IF vend.FIND('-') THEN
                                          CALCFIELDS(Picture,signinature,"Back Side ID","Front Side ID");
                                          vend.Name:=Name;
                                          vend."Global Dimension 2 Code":= Branch;
                                          vend.Address:=Address;
                                          vend."E-Mail":=Email;
                                          vend."Mobile Phone No":= "Mobile No";
                                          vend. "MPESA Mobile No":="S-Mobile No";
                                          vend."Phone No.":="Mobile No";
                                          vend."ID No.":="ID No";
                                          vend."Staff No":="Personal No";
                                          vend."BOSA Account No":="Member No";
                                          vend."Account Type":="Account Type";
                                          vend.City:=City;
                                          vend."Insider Classification":="Insider Classification(New)";
                                          vend.Gender:=Gender;
                                          vend.Section:=Section;
                                          vend."Marital Status":="Marital Status";
                                          vend.Gender:=Gender;
                                          vend."Responsibility Center":="Responsibility Centers";
                                          vend."Company Code":="Employer Code";
                                          vend."Fixed Deposit Status":="Fixed Deposit Status";
                                          vend.Status:="Agile Account Status(New)";
                                          vend."Company Code":=Memb."Employer Code";
                                          vend."Work Station":="Workstation New";
                                          vend.Designation:="Designation new";
                                          vend."Terms of Service":="Terms of Service";
                                          vend.MODIFY;

                                        { Memb.RESET;
                                         Memb.SETRANGE(Memb."No.",vend."BOSA Account No");
                                         IF Memb.FINDFIRST THEN BEGIN
                                         //Memb.CALCFIELDS(Memb.Picture,Memb.Signature,Memb."Front Side ID",Memb."Back Side ID");
                                         Memb."Front Side ID":="Front Side ID";
                                         Memb.Picture:=Picture;
                                         Memb.Signature:=signinature;
                                         Memb."Back Side ID":="Back Side ID";
                                         Memb.MODIFY;
                                         END;}

                                           IF (Type=Type::"Agile Change") THEN BEGIN
                                              ProductNxK.RESET;
                                              ProductNxK.SETRANGE(ProductNxK."Account No","Account No");
                                              IF ProductNxK.FIND('-') THEN

                                               REPEAT;
                                 {
                                                ProductNxK.Description:= Kinchangedetails.Name;
                                                ProductNxK.Amount:=Kinchangedetails.Relationship;
                                                ProductNxK.Type:=Kinchangedetails.Beneficiary;
                                                ProductNxK."Code Type":=Kinchangedetails."Date of Birth";
                                                ProductNxK.Address:=Kinchangedetails.Address;
                                                ProductNxK.Telephone:=Kinchangedetails.Telephone;
                                                ProductNxK.Fax:=Kinchangedetails.Fax;
                                                ProductNxK.Email:=Kinchangedetails.Email;
                                                ProductNxK."ID No.":=Kinchangedetails."ID No.";
                                                ProductNxK."%Allocation":=Kinchangedetails."%Allocation";
                                                ProductNxK.MODIFY;
                                                }
                                                ProductNxK.Name:= Kinchangedetails.Name;
                                                ProductNxK.Relationship:=Kinchangedetails.Relationship;
                                                ProductNxK.Beneficiary:=Kinchangedetails.Beneficiary;
                                                ProductNxK."Date of Birth":=Kinchangedetails."Date of Birth";
                                                ProductNxK.Address:=Kinchangedetails.Address;
                                                ProductNxK.Telephone:=Kinchangedetails.Telephone;
                                                ProductNxK.Fax:=Kinchangedetails.Fax;
                                                ProductNxK.Email:=Kinchangedetails.Email;
                                                ProductNxK."ID No.":=Kinchangedetails."ID No.";
                                                ProductNxK."%Allocation":=Kinchangedetails."%Allocation";
                                                ProductNxK.MODIFY;

                                               UNTIL ProductNxK.NEXT=0;

                                               END

                                          END;


                                 IF Type=Type::"Backoffice Change" THEN BEGIN
                                 TESTFIELD(Designation);
                                 TESTFIELD("KRA Pin");
                                 TESTFIELD("Mobile No");
                                 TESTFIELD("Monthly Contributions");
                                 IF "Workstation New"='' THEN
                                 TESTFIELD(workstation);

                                     Memb.RESET;
                                     Memb.SETRANGE(Memb."No.","Account No");
                                   IF Memb.FIND('-') THEN BEGIN

                                        vend.RESET;
                                        vend.SETRANGE(vend."No.",Memb."FOSA Account");
                                        IF vend.FIND('-') THEN BEGIN
                                          IF "Date Of Birth"<>0D THEN
                                          vend."Date of Birth":="Date Of Birth";
                                          vend.MODIFY;
                                        END;
                                         CALCFIELDS(Picture,signinature,"Back Side ID","Front Side ID");
                                         Memb.Name:=Name;
                                         Memb."Global Dimension 2 Code":= Branch;
                                         Memb.Address:=Address;
                                         Memb."E-Mail":=Email;
                                         Memb."Mobile Phone No":= "Mobile No";
                                         Memb."Phone No.":="Mobile No";
                                         Memb."ID No.":="ID No";
                                         Memb."FOSA Account":="FOSA Account(New)";
                                         Memb."Membership Status":="Membership Status(New)";
                                         Memb.Pin:="KRA Pin";
                                         Memb."Payroll/Staff No":="Personal No";
                                         Memb.City:=City;
                                         Memb.Section:=Section;
                                         Memb.Gender:=Gender;
                                         Memb."Insider Classification":="Insider Classification(New)";
                                         Memb."Employer Code":="Employer Code";
                                         IF "Application Date"<>0D THEN
                                         Memb."Registration Date":="Application Date";
                                         Memb."Marital Status":="Marital Status";
                                         Memb."Responsibility Center":="Responsibility Centers";
                                         Memb.Status:="Member Account Status(New)";
                                         Memb."Registration Date":="Application Date";
                                        Memb."Pays Benevolent":="Pays Benevolent(New)";
                                        Memb."Loan Defaulter":="Loan Defaulter(New)";
                                        Memb."Date of Birth":="Date Of Birth";
                                        Memb.Station:="Workstation New";
                                        IF "Monthly Contributions" <>0 THEN
                                        Memb."Monthly Contribution":="Monthly Contributions";
                                        IF "Designation new"<>'' THEN
                                        Memb.Designation:="Designation new";
                                        Memb."Terms of Service":="Terms of Service";

                                         Memb.MODIFY;


                                       vend.RESET;
                                       vend.SETRANGE(vend."BOSA Account No",Memb."No.");
                                       IF vend.FIND('-') THEN BEGIN
                                       vend.Status:="Member Account Status(New)";
                                       vend."Monthly Contribution":="Monthly Contributions";
                                       IF "Application Date"<>0D THEN BEGIN
                                       vend."Registration Date":="Application Date"
                                       END;
                                       vend."E-Mail":=Email;
                                       vend."E-Mail (Personal)":=Email;
                                       vend."Marital Status":="Marital Status";
                                       vend."Date of Birth":="Date Of Birth";
                                       vend.Address:=Address;
                                       vend."Insider Classification":="Insider Classification(New)";
                                       vend."ID No.":="ID No";
                                       vend."Phone No.":="Mobile No";
                                       vend.City:=City;
                                       vend.Gender:=Gender;
                                       vend.Section:=Section;
                                       vend."Staff No":="Personal No";
                                       vend."Marital Status":="Marital Status";
                                       vend."Home Address":="Home Address";
                                       vend.Name:=Name;
                                       vend."BOSA Account No":=Memb."No.";
                                       vend.MODIFY;
                                     END;
                                     END;
                                     END;


                                 IF Type=Type::"Picture Change" THEN BEGIN

                                     Memb.RESET;
                                     Memb.SETRANGE(Memb."No.","Account No");
                                   IF Memb.FIND('-') THEN BEGIN

                                         CALCFIELDS(Picture,signinature,"Back Side ID","Front Side ID");
                                         Memb.Picture:=Picture;
                                         Memb.Signature:=signinature;
                                         Memb."Back Side ID":="Back Side ID";
                                         Memb."Front Side ID":="Front Side ID";
                                         Memb.MODIFY;


                                       vend.RESET;
                                       vend.SETRANGE(vend."BOSA Account No",Memb."No.");
                                       IF vend.FIND('-') THEN BEGIN
                                       vend.Picture:=Picture;
                                       vend.Signature:=signinature;
                                       vend."Front Side ID":="Front Side ID";
                                       vend."Back Side ID":="Back Side ID";
                                       vend.MODIFY;
                                     END;
                                     END;
                                     END;





                                 "Updated By":=USERID;
                                 "Date Changed":=TODAY;
                                 Changed:=TRUE;
                                 MODIFY;

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Change Request Record Update',0,'CHANGEREQUEST',TODAY,TIME,'',No,"Account No",'');
                                 //End Create Audit Entry
                                 MESSAGE('Changes have been updated Successfully');
                               END;
                                }
      { 1000000019;1 ;Action    ;
                      Name=Next Of Kin;
                      RunObject=Page 50085;
                      RunPageLink=Account No=FIELD(Account No);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Change;
                      PromotedCategory=Process }
      { 1120054006;1 ;Action    ;
                      Name=Update Image/Signature;
                      CaptionML=ENU=Update Image/Signature;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=ChangeDimensions;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF (Status<>Status::Approved) THEN BEGIN
                                 ERROR('Change Request Must be Approved First');
                                 END;


                                 IF  ((Type=Type::"Atm Change") OR (Type=Type::"Agile Change")) THEN BEGIN
                                        vend.RESET;
                                        vend.SETRANGE(vend."No.","Account No");
                                       IF vend.FIND('-') THEN
                                          vend.CALCFIELDS(vend.Picture,vend.Signature,vend."Front Side ID",vend."Back Side ID");
                                          vend.Picture:=Picture;
                                          vend.Signature:=signinature;
                                          vend."Front Side ID":="Front Side ID";
                                          vend."Back Side ID":="Back Side ID";
                                          vend.MODIFY;

                                          END;


                                 IF Type=Type::"Backoffice Change" THEN BEGIN
                                     CALCFIELDS(Picture,signinature,"Front Side ID","Back Side ID");

                                     Memb.RESET;
                                     Memb.SETRANGE(Memb."No.","Account No");
                                   IF Memb.FIND('-') THEN BEGIN
                                         Memb.CALCFIELDS(Memb.Picture,Memb.Signature,Memb."Front Side ID",Memb."Back Side ID");
                                         IF Rec.Picture.HASVALUE THEN
                                           Memb.Picture:=Picture;
                                         IF Rec.signinature.HASVALUE THEN
                                           Memb.Signature:=signinature;
                                         IF Rec."Front Side ID".HASVALUE THEN
                                           Memb."Front Side ID":="Front Side ID";
                                         IF Rec."Back Side ID".HASVALUE THEN
                                           Memb."Back Side ID":="Back Side ID";
                                         Memb.MODIFY;

                                 //mercy
                                        vend.RESET;
                                        vend.SETRANGE(vend."No.",Memb."FOSA Account");
                                       IF vend.FIND('-') THEN
                                          vend.CALCFIELDS(vend.Picture,vend.Signature,vend."Front Side ID",vend."Back Side ID");
                                          IF Rec.Picture.HASVALUE THEN
                                             vend.Picture:=Picture;
                                          IF Rec.signinature.HASVALUE THEN
                                             vend.Signature:=signinature;
                                          IF Rec."Front Side ID".HASVALUE THEN
                                             vend."Front Side ID":="Front Side ID";
                                          IF Rec."Back Side ID".HASVALUE THEN
                                             vend."Back Side ID":="Back Side ID";
                                          vend.MODIFY;
                                 //end mercy

                                     END;

                                     END;

                                 Changed:=TRUE;
                                 MODIFY;
                                 MESSAGE('Changes have been updated Successfully');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000003;2;Field  ;
                SourceExpr=No }

    { 1000000002;2;Field  ;
                SourceExpr=Type;
                Editable=DetailsEditable;
                OnValidate=BEGIN
                             //IF (Type=Type::"Atm Change" ) THEN
                               //ERROR('You dont have this right');
                             AccountVisible:=FALSE;
                             MobileVisible:=FALSE;
                             AtmVisible:=FALSE;
                             nxkinvisible:=FALSE;
                             PicturesVisible:=FALSE;

                             IF Type=Type::"Mobile Change" THEN BEGIN
                               MobileVisible:=TRUE;
                             END;

                             IF Type=Type::"Atm Change" THEN BEGIN
                               AtmVisible:=TRUE;

                             END;


                             IF Type=Type::"Backoffice Change" THEN BEGIN
                               AccountVisible:=TRUE;
                               nxkinvisible:=TRUE;
                             END;

                             IF Type=Type::"Agile Change" THEN BEGIN
                               AccountVisible:=TRUE;
                               nxkinvisible:=TRUE;
                             END;

                             IF Type=Type::"Picture Change" THEN BEGIN
                             PicturesVisible:=TRUE;
                             END;
                           END;
                            }

    { 1000000049;2;Field  ;
                SourceExpr="Captured by" }

    { 1000000004;2;Field  ;
                SourceExpr="Account No";
                Editable=DetailsEditable }

    { 1000000050;2;Field  ;
                SourceExpr="Capture Date" }

    { 1000000051;2;Field  ;
                SourceExpr="Approved by" }

    { 1000000052;2;Field  ;
                SourceExpr="Approval Date" }

    { 1000000017;2;Field  ;
                SourceExpr=Status;
                Editable=false }

    { 1120054002;2;Field  ;
                SourceExpr=Changed }

    { 1000000041;1;Group  ;
                Name=Mobile;
                CaptionML=ENU=Mobile;
                Visible=Mobilevisible;
                Editable=DetailsEditable;
                GroupType=Group }

    { 1000000029;2;Field  ;
                CaptionML=ENU=New Mobile Phone;
                SourceExpr="S-Mobile No" }

    { 1120054027;2;Field  ;
                SourceExpr="Reason For Change Moble" }

    { 1000000042;1;Group  ;
                Name=Atm Details;
                Visible=Atmvisible;
                Editable=DetailsEditable;
                GroupType=Group }

    { 1000000030;2;Field  ;
                SourceExpr="ATM Approve" }

    { 1000000031;2;Field  ;
                SourceExpr="Card Expiry Date" }

    { 1000000032;2;Field  ;
                SourceExpr="Card Valid From" }

    { 1000000033;2;Field  ;
                SourceExpr="Card Valid To" }

    { 1000000034;2;Field  ;
                SourceExpr="Date ATM Linked" }

    { 1000000035;2;Field  ;
                SourceExpr="ATM No.";
                Editable=false }

    { 1120054009;2;Field  ;
                SourceExpr="ATM No.(New)" }

    { 1000000036;2;Field  ;
                SourceExpr="ATM Issued" }

    { 1000000037;2;Field  ;
                SourceExpr="ATM Self Picked" }

    { 1000000038;2;Field  ;
                SourceExpr="ATM Collector Name" }

    { 1000000039;2;Field  ;
                SourceExpr="ATM Collectors ID" }

    { 1000000040;2;Field  ;
                SourceExpr="Atm Collectors Moile" }

    { 1000000048;2;Field  ;
                SourceExpr="Responsibility Centers" }

    { 1000000008;1;Group  ;
                Name=Account Info;
                Visible=Accountvisible;
                Editable=DetailsEditable;
                GroupType=Group }

    { 1120054033;2;Field  ;
                Name=ID Front;
                CaptionML=ENU=ID Front;
                SourceExpr="Front Side ID";
                Editable=false }

    { 1000000006;2;Field  ;
                SourceExpr=Name }

    { 1000000018;2;Field  ;
                SourceExpr="Payroll Number" }

    { 1000000007;2;Field  ;
                SourceExpr=Address }

    { 1000000011;2;Field  ;
                SourceExpr=City }

    { 1000000013;2;Field  ;
                CaptionML=ENU=Staff Number;
                SourceExpr="Personal No" }

    { 1000000021;2;Field  ;
                SourceExpr="Mobile No" }

    { 1120054005;2;Field  ;
                SourceExpr="Application Date" }

    { 1120054001;2;Field  ;
                SourceExpr="Application Date(old)";
                Visible=false }

    { 1120054019;2;Field  ;
                SourceExpr="Member No" }

    { 1120054020;2;Field  ;
                SourceExpr="Date Of Birth" }

    { 1000000014;2;Field  ;
                SourceExpr="ID No" }

    { 1120054018;2;Field  ;
                SourceExpr="KRA Pin" }

    { 1120054000;2;Field  ;
                SourceExpr=Gender }

    { 1000000012;2;Field  ;
                SourceExpr="Employer Code" }

    { 1000000015;2;Field  ;
                SourceExpr="Marital Status" }

    { 1000000020;2;Field  ;
                SourceExpr=Email }

    { 1120054021;2;Field  ;
                SourceExpr=Section }

    { 1000000023;2;Field  ;
                SourceExpr="Home Address" }

    { 1000000027;2;Field  ;
                SourceExpr="Reason for change" }

    { 1000000028;2;Field  ;
                SourceExpr="Signing Instructions" }

    { 1000000053;2;Field  ;
                SourceExpr="Monthly Contributions" }

    { 1120054034;2;Field  ;
                SourceExpr="FOSA Account" }

    { 1120054035;2;Field  ;
                SourceExpr="FOSA Account(New)" }

    { 1000000016;2;Field  ;
                SourceExpr="Fixed Deposit Status" }

    { 1120054022;2;Field  ;
                SourceExpr=workstation }

    { 1120054023;2;Field  ;
                SourceExpr="Workstation New" }

    { 1120054012;2;Field  ;
                SourceExpr="Insider Classification" }

    { 1120054013;2;Field  ;
                SourceExpr="Insider Classification(New)" }

    { 1120054003;2;Field  ;
                SourceExpr="Member Account Status";
                Editable=false }

    { 1120054004;2;Field  ;
                SourceExpr="Member Account Status(New)" }

    { 1120054036;2;Field  ;
                SourceExpr="Membership Status" }

    { 1120054037;2;Field  ;
                SourceExpr="Membership Status(New)" }

    { 1120054025;2;Field  ;
                SourceExpr="Designation new" }

    { 1120054024;2;Field  ;
                SourceExpr=Designation }

    { 1120054026;2;Field  ;
                SourceExpr="Terms of Service" }

    { 1120054007;2;Field  ;
                SourceExpr="Agile Account Status";
                Editable=false }

    { 1120054008;2;Field  ;
                SourceExpr="Agile Account Status(New)" }

    { 1120054010;2;Field  ;
                SourceExpr="Registration Date";
                Editable=false }

    { 1120054011;2;Field  ;
                SourceExpr="Registration Date New" }

    { 1120054014;2;Field  ;
                SourceExpr="Pays Benevolent";
                Enabled=False }

    { 1120054016;2;Field  ;
                SourceExpr="Pays Benevolent(New)" }

    { 1120054015;2;Field  ;
                SourceExpr="Loan Defaulter";
                Editable=False }

    { 1120054017;2;Field  ;
                SourceExpr="Loan Defaulter(New)" }

    { 1120054028;1;Group  ;
                Name=Member Pictures;
                Visible=PicturesVisible;
                Editable=DetailsEditable;
                GroupType=Group }

    { 1120054032;2;Field  ;
                SourceExpr=Picture }

    { 1120054031;2;Field  ;
                SourceExpr=signinature }

    { 1120054030;2;Field  ;
                SourceExpr="Front Side ID" }

    { 1120054029;2;Field  ;
                SourceExpr="Back Side ID" }

  }
  CODE
  {
    VAR
      vend@1000000000 : Record 23;
      Memb@1000000001 : Record 51516223;
      MobileVisible@1000000002 : Boolean;
      AtmVisible@1000000003 : Boolean;
      AccountVisible@1000000004 : Boolean;
      ProductNxK@1000000007 : Record 51516352;
      MembNxK@1000000006 : Record 51516225;
      cloudRequest@1000000005 : Record 51516350;
      nxkinvisible@1000000008 : Boolean;
      Kinchangedetails@1000000009 : Record 51516293;
      DocumentType@1000000010 : Option;
      MemberNxK@1000000011 : Record 51516225;
      UsersetUp@1120054000 : Record 91;
      UserNotFound@1120054001 : TextConst 'ENU=User Setup %1 not found.';
      AuditTrail@1120054004 : Codeunit 51516107;
      Trail@1120054003 : Record 51516655;
      EntryNo@1120054002 : Integer;
      DetailsEditable@1120054005 : Boolean;
      PicturesVisible@1120054006 : Boolean;
      PicturesEditable@1120054007 : Boolean;

    BEGIN
    END.
  }
}

