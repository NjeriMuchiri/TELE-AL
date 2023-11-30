OBJECT page 50052 HR Job Applications List
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 1:08:36 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516209;
    SourceTableView=WHERE(Qualification Status=FILTER(' '));
    PageType=List;
    CardPageID=HR Job Applications Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Applicant,Functions,Print;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755002;1 ;ActionGroup;
                      CaptionML=ENU=Applicant }
      { 1102755003;2 ;Action    ;
                      Name=<Page HR Job Applications Card>;
                      CaptionML=ENU=Card;
                      RunObject=page 50047;
                      RunPageLink=Application No=FIELD(Application No);
                      Promoted=Yes;
                      Image=Card;
                      PromotedCategory=Category4 }
      { 1102755008;2 ;Action    ;
                      CaptionML=ENU=&Upload to Employee Card;
                      Promoted=Yes;
                      Image=Export;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(Text001,FALSE) THEN EXIT;
                                   IF "Employee No" = '' THEN BEGIN
                                   //IF NOT CONFIRM('Are you sure you want to Upload Applications Information to the Employee Card',FALSE) THEN EXIT;
                                   HRJobApplications.SETFILTER(HRJobApplications."Application No","Application No");
                                   REPORT.RUN(55600,TRUE,FALSE,HRJobApplications);
                                   END ELSE BEGIN
                                   MESSAGE('This applicants information already exists in the employee card');
                                   END;
                               END;
                                }
      { 1102755006;2 ;Action    ;
                      Name=Send Interview Invitation;
                      CaptionML=ENU=Send Interview Invitation;
                      Promoted=Yes;
                      Image=SendMail;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(Text002,FALSE) THEN EXIT;

                                 HRJobApplications.RESET;
                                 HRJobApplications.SETFILTER(HRJobApplications."Application No","Application No");
                                 HRJobApplications.SETRANGE(HRJobApplications.Qualified,TRUE);
                                 //REPORT.RUN(53940,TRUE,FALSE,HRJobApplications);
                                 IF HRJobApplications.FIND('-') THEN
                                 BEGIN
                                  REPEAT


                                   MESSAGE('Invitation Email sent to '+FORMAT(HRJobApplications."Application No"));
                                  UNTIL HRJobApplications.NEXT=0;
                                 END;
                               END;
                                }
      { 1000000011;2 ;Action    ;
                      Name=<Page HR Applicant Qualification;
                      CaptionML=ENU=Qualifications;
                      RunObject=page 50048;
                      RunPageLink=Application No=FIELD(Application No);
                      Promoted=Yes;
                      Image=QualificationOverview;
                      PromotedCategory=Category5 }
      { 1000000010;2 ;Action    ;
                      Name=<Page HR Applicant Referees>;
                      CaptionML=ENU=Referees;
                      RunObject=page 50049;
                      RunPageLink=Job Application No=FIELD(Application No);
                      Promoted=Yes;
                      Image=ContactReference;
                      PromotedCategory=Category5 }
      { 1000000009;2 ;Action    ;
                      Name=<Page HR Applicant Hobbies>;
                      CaptionML=ENU=Hobbies;
                      RunObject=page 50050;
                      RunPageLink=Job Application No=FIELD(Application No);
                      Promoted=Yes;
                      Image=Holiday;
                      PromotedCategory=Category5 }
      { 1000000008;2 ;Action    ;
                      CaptionML=ENU=Attachments;
                      Promoted=Yes;
                      Visible=false;
                      Image=Attachments;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 HRJobApplications.RESET;
                                 HRJobApplications.SETRANGE(HRJobApplications."Application No","Application No");
                                 IF HRJobApplications.FIND('-') THEN
                                 REPORT.RUN(53925,TRUE,TRUE,HRJobApplications);
                               END;
                                }
      { 1102755015;2 ;Action    ;
                      CaptionML=ENU=Generate Offer Letter;
                      RunObject=Report 55606;
                      Promoted=Yes }
      { 1102755014;2 ;Action    ;
                      Name=<Page HR Employee Attachments SF;
                      CaptionML=ENU=Upload Attachments;
                      RunObject=page 50051;
                      RunPageLink=Employee No=FIELD(Application No);
                      Promoted=Yes;
                      Image=Attachments;
                      PromotedCategory=Category6 }
      { 1000000006;1 ;ActionGroup;
                      CaptionML=ENU=Print }
      { 1000000001;2 ;Action    ;
                      CaptionML=ENU=&Print;
                      Promoted=Yes;
                      Image=PrintReport;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 HRJobApplications.RESET;
                                 HRJobApplications.SETRANGE(HRJobApplications."Application No","Application No");
                                 IF HRJobApplications.FIND('-') THEN
                                 REPORT.RUN(53925,TRUE,TRUE,HRJobApplications);
                               END;
                                }
      { 1102755011;  ;ActionContainer;
                      ActionContainerType=Reports }
      { 1102755012;1 ;Action    ;
                      CaptionML=ENU=Job Applications;
                      RunObject=Report 55592;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1102755013;1 ;Action    ;
                      CaptionML=ENU=Shortlisted Candidates;
                      RunObject=Report 55593;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1102755000;2;Field  ;
                SourceExpr="Application No";
                Importance=Promoted;
                StyleExpr=TRUE }

    { 1102755005;2;Field  ;
                SourceExpr="Date Applied";
                StyleExpr=TRUE }

    { 1102755004;2;Field  ;
                SourceExpr="Job Applied For" }

    { 1000000003;2;Field  ;
                SourceExpr="First Name";
                Importance=Promoted }

    { 1000000005;2;Field  ;
                SourceExpr="Middle Name";
                Importance=Promoted }

    { 1000000007;2;Field  ;
                SourceExpr="Last Name";
                Importance=Promoted }

    { 1000000019;2;Field  ;
                SourceExpr=Qualified }

    { 1102755001;2;Field  ;
                SourceExpr="Interview Invitation Sent" }

    { 1102755010;2;Field  ;
                SourceExpr=Status }

    { 2   ;2   ;Field     ;
                SourceExpr="Qualification Status" }

    { 1102755007;;Container;
                ContainerType=FactBoxArea }

    { 1102755009;1;Part   ;
                SubPageLink=Application No=FIELD(Application No);
                PagePartID=Page51516175;
                PartType=Page }

    { 1   ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      HRJobApplications@1102755000 : Record 51516209;
      Text001@1000000000 : TextConst 'ENU=Are you sure you want to Upload Applicants Details to the Employee Card?';
      Text002@1000000001 : TextConst 'ENU=Are you sure you want to Send an Interview Application?';

    BEGIN
    END.
  }
}

