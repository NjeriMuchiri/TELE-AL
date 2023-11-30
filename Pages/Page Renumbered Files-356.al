OBJECT page 50047 HR Job Applications Card
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 1:10:36 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516209;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Functions,Other Details;
    ActionList=ACTIONS
    {
      { 1120054023;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054022;1 ;ActionGroup;
                      CaptionML=ENU=Other Details }
      { 1120054021;2 ;Action    ;
                      Name=<Page HR Applicant Qualification;
                      CaptionML=ENU=Qualifications;
                      RunObject=page 50048;
                      RunPageLink=Application No=FIELD(Application No);
                      Promoted=Yes;
                      Image=QualificationOverview;
                      PromotedCategory=Category5 }
      { 1120054020;2 ;Action    ;
                      Name=Page HR Training Needs Card;
                      CaptionML=ENU=Training Need;
                      RunObject=page 20498;
                      Promoted=Yes;
                      PromotedCategory=Category5 }
      { 1120054019;2 ;Action    ;
                      Name=<Page HR Applicant Referees>;
                      CaptionML=ENU=Referees;
                      RunObject=page 50049;
                      RunPageLink=Job Application No=FIELD(Application No);
                      Promoted=Yes;
                      Image=ContactReference;
                      PromotedCategory=Category5 }
      { 1120054018;2 ;Action    ;
                      Name=<Page HR Applicant Hobbies>;
                      CaptionML=ENU=Hobbies;
                      RunObject=page 50050;
                      RunPageLink=Job Application No=FIELD(Application No);
                      Promoted=Yes;
                      Image=Holiday;
                      PromotedCategory=Category5 }
      { 1120054017;2 ;Action    ;
                      Name=<Report HR Employement Letter>;
                      CaptionML=ENU=Generate Offer Letter;
                      RunObject=Report 51516189;
                      Promoted=Yes }
      { 1120054016;2 ;Action    ;
                      Name=<Page HR Employee Attachments SF;
                      CaptionML=ENU=Upload Attachments;
                      RunObject=page 50051;
                      RunPageLink=Employee No=FIELD(Application No);
                      Promoted=Yes;
                      Visible=false;
                      Image=Attachments;
                      PromotedCategory=Category6 }
      { 1120054015;1 ;ActionGroup;
                      CaptionML=ENU=&Functions }
      { 1120054014;2 ;Action    ;
                      CaptionML=ENU=&Send Interview Invitation;
                      Promoted=Yes;
                      Image=SendMail;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 TESTFIELD(Qualified);


                                 HRJobApplications.SETFILTER(HRJobApplications."Application No","Application No");
                                 REPORT.RUN(53940,FALSE,FALSE,HRJobApplications);
                               END;
                                }
      { 1120054013;2 ;Action    ;
                      CaptionML=ENU=&Upload to Employee Card;
                      Promoted=Yes;
                      Image=ImportDatabase;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF "Employee No" = '' THEN BEGIN
                                 //IF NOT CONFIRM('Are you sure you want to Upload Applicants information to the Employee Card',FALSE) THEN EXIT;
                                 HRJobApplications.SETFILTER(HRJobApplications."Application No","Application No");
                                 REPORT.RUN(55600,TRUE,FALSE,HRJobApplications);
                                 END ELSE BEGIN
                                 MESSAGE('This applicants information already exists in the employee card');
                                 END;
                               END;
                                }
      { 1120054012;2 ;Action    ;
                      CaptionML=ENU=&Print;
                      Promoted=Yes;
                      Visible=false;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HRJobApplications.RESET;
                                 HRJobApplications.SETRANGE(HRJobApplications."Application No","Application No");
                                 IF HRJobApplications.FIND('-') THEN
                                 REPORT.RUN(55523,TRUE,TRUE,HRJobApplications);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755003;2;Field  ;
                SourceExpr="Application No";
                Importance=Promoted;
                Editable=False }

    { 1102755001;2;Field  ;
                SourceExpr="Date Applied";
                Importance=Promoted;
                Editable=false }

    { 1000000003;2;Field  ;
                SourceExpr="First Name";
                Importance=Promoted }

    { 1000000005;2;Field  ;
                SourceExpr="Middle Name";
                Importance=Promoted }

    { 1000000007;2;Field  ;
                SourceExpr="Last Name";
                Importance=Promoted }

    { 1000000009;2;Field  ;
                SourceExpr=Initials }

    { 1000000068;2;Field  ;
                CaptionML=ENU=1st Language (R/W/S);
                SourceExpr="First Language (R/W/S)";
                Importance=Promoted }

    { 1000000074;2;Field  ;
                CaptionML=ENU=1st Language Read;
                SourceExpr="First Language Read" }

    { 1000000076;2;Field  ;
                CaptionML=ENU=1st Language Write;
                SourceExpr="First Language Write" }

    { 1000000078;2;Field  ;
                CaptionML=ENU=1st Language Speak;
                SourceExpr="First Language Speak" }

    { 1000000070;2;Field  ;
                CaptionML=ENU=2nd Language (R/W/S);
                SourceExpr="Second Language (R/W/S)";
                Importance=Promoted }

    { 1000000080;2;Field  ;
                SourceExpr="Second Language Read" }

    { 1000000082;2;Field  ;
                SourceExpr="Second Language Write" }

    { 1000000084;2;Field  ;
                SourceExpr="Second Language Speak" }

    { 1000000072;2;Field  ;
                SourceExpr="Additional Language" }

    { 1000000091;2;Field  ;
                SourceExpr="Applicant Type";
                Enabled=True;
                Editable=True;
                Style=Strong;
                StyleExpr=TRUE }

    { 1000000088;2;Field  ;
                CaptionML=ENU=Internal;
                SourceExpr="Employee No";
                Editable=TRUE }

    { 1000000015;2;Field  ;
                SourceExpr="ID Number" }

    { 1000000017;2;Field  ;
                SourceExpr=Gender;
                Importance=Promoted }

    { 1000000086;2;Field  ;
                SourceExpr=Citizenship }

    { 1102755010;2;Field  ;
                Name=Country Details;
                SourceExpr="Citizenship Details";
                Editable=false }

    { 1000000027;2;Field  ;
                CaptionML=ENU=Application Reff No.;
                SourceExpr="Employee Requisition No";
                Importance=Promoted }

    { 1000000011;2;Field  ;
                CaptionML=ENU=Position Applied For;
                SourceExpr="Job Applied For";
                Importance=Promoted;
                Enabled=True;
                Editable=True }

    { 1   ;2   ;Field     ;
                SourceExpr=Expatriate }

    { 1102755012;2;Field  ;
                SourceExpr="Interview Invitation Sent";
                Editable=false;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 4   ;2   ;Field     ;
                SourceExpr="Qualification Status" }

    { 1901160401;1;Group  ;
                CaptionML=ENU=Personal }

    { 1000000021;2;Field  ;
                SourceExpr=Status;
                Importance=Promoted }

    { 1000000023;2;Field  ;
                SourceExpr="Marital Status";
                Importance=Promoted }

    { 1000000025;2;Field  ;
                SourceExpr="Ethnic Origin" }

    { 1000000029;2;Field  ;
                SourceExpr=Disabled }

    { 1000000031;2;Field  ;
                SourceExpr="Health Assesment?" }

    { 1000000033;2;Field  ;
                SourceExpr="Health Assesment Date" }

    { 1000000035;2;Field  ;
                SourceExpr="Date Of Birth";
                OnValidate=BEGIN

                             IF "Date Of Birth" >= TODAY THEN BEGIN
                               ERROR('Invalid Entry');
                             END;
                             DAge:= Dates.DetermineAge("Date Of Birth",TODAY);
                              Age:=DAge;
                           END;
                            }

    { 1000000037;2;Field  ;
                SourceExpr=Age;
                Importance=Promoted;
                Editable=false }

    { 1902768601;1;Group  ;
                CaptionML=ENU=Communication }

    { 1000000039;2;Field  ;
                SourceExpr="Home Phone Number";
                Importance=Promoted }

    { 1000000041;2;Field  ;
                SourceExpr="Postal Address";
                Importance=Promoted }

    { 1000000043;2;Field  ;
                CaptionML=ENU=Postal Address 2;
                SourceExpr="Postal Address2" }

    { 1000000045;2;Field  ;
                CaptionML=ENU=Postal Address 3;
                SourceExpr="Postal Address3" }

    { 1000000047;2;Field  ;
                SourceExpr="Post Code" }

    { 1000000049;2;Field  ;
                SourceExpr="Residential Address" }

    { 1000000051;2;Field  ;
                SourceExpr="Residential Address2" }

    { 1000000053;2;Field  ;
                SourceExpr="Residential Address3" }

    { 1000000055;2;Field  ;
                CaptionML=ENU=Post Code 2;
                SourceExpr="Post Code2" }

    { 1000000059;2;Field  ;
                SourceExpr="Cell Phone Number";
                Importance=Promoted }

    { 1000000061;2;Field  ;
                SourceExpr="Work Phone Number" }

    { 1000000063;2;Field  ;
                SourceExpr="Ext." }

    { 1000000065;2;Field  ;
                SourceExpr="E-Mail";
                Importance=Promoted }

    { 1000000013;2;Field  ;
                SourceExpr="Fax Number" }

    { 1102755004;;Container;
                ContainerType=FactBoxArea }

    { 1102755009;1;Part   ;
                SubPageLink=Application No=FIELD(Application No);
                PagePartID=Page51516175;
                PartType=Page }

    { 1102755008;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

    { 3   ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      HRJobApplications@1102755000 : Record 51516209;
      SMTP@1102755001 : Codeunit 400;
      HREmailParameters@1102755002 : Record 51516202;
      Employee@1102755003 : Record 51516160;
      Text19064672@19030789 : TextConst 'ENU=Shortlisting Summary';
      Dates@1001 : Codeunit 51516100;
      DAge@1000 : Text[100];

    BEGIN
    END.
  }
}

