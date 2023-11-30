OBJECT page 50063 HR Applicants UnQualified List
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=[ 2:01:36 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516209;
    SourceTableView=WHERE(Qualification Status=FILTER(UnQualified));
    PageType=List;
    CardPageID=HR Applicants UnQualified Card;
    ActionList=ACTIONS
    {
      { 16      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=ENU=Applicant }
      { 14      ;2   ;Action    ;
                      Name=Send Regret Alert;
                      CaptionML=ENU=Send Regret Alert;
                      Promoted=Yes;
                      Image=SendMail;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 //IF CONFIRM('Send this Requisition for Approval?',TRUE)=FALSE THEN EXIT;
                                 IF NOT CONFIRM(Text002,FALSE) THEN EXIT;

                                 TESTFIELD(Qualified,Qualified::"0");
                                 HRJobApplications.SETRANGE(HRJobApplications."Application No","Application No");
                                 CurrPage.SETSELECTIONFILTER(HRJobApplications);
                                 IF HRJobApplications.FIND('-') THEN
                                 //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                                 HREmailParameters.RESET;
                                 HREmailParameters.SETRANGE(HREmailParameters."Associate With",HREmailParameters."Associate With"::"Regret Notification");
                                 IF HREmailParameters.FIND('-') THEN
                                 BEGIN
                                      REPEAT
                                      HRJobApplications.TESTFIELD(HRJobApplications."E-Mail");
                                      SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HRJobApplications."E-Mail",
                                      HREmailParameters.Subject,'Dear'+' '+HRJobApplications."First Name"+' '+HREmailParameters.Body+' '+HRJobApplications."Job Applied for Description"+' '+'applied on'+' '+FORMAT("Date Applied")+' '+HREmailParameters."Body 2",TRUE);
                                      //HREmailParameters."Body 2"+' '+ FORMAT("Date Applied")+'. '+
                                     // HREmailParameters.Body,TRUE);
                                      SMTP.Send();
                                      UNTIL HRJobApplications.NEXT=0;

                                 MESSAGE('All Unqualified  candidates have been sent regret alerts');
                                 END;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=<Page HR Job Applications Card>;
                      CaptionML=ENU=Card;
                      RunObject=page 50047;
                      RunPageLink=Application No=FIELD(Application No);
                      Promoted=No;
                      Image=Card;
                      PromotedCategory=Report }
      { 12      ;2   ;Action    ;
                      Name=<Page HR Applicant Qualification;
                      CaptionML=ENU=Qualifications;
                      RunObject=page 50048;
                      RunPageLink=Application No=FIELD(Application No);
                      Promoted=No;
                      Image=QualificationOverview;
                      PromotedCategory=Report }
      { 11      ;2   ;Action    ;
                      Name=<Page HR Applicant Referees>;
                      CaptionML=ENU=Referees;
                      RunObject=page 50049;
                      RunPageLink=Job Application No=FIELD(Application No);
                      Promoted=No;
                      Image=ContactReference;
                      PromotedCategory=Report }
      { 10      ;2   ;Action    ;
                      Name=<Page HR Applicant Hobbies>;
                      CaptionML=ENU=Hobbies;
                      RunObject=page 50050;
                      RunPageLink=Job Application No=FIELD(Application No);
                      Promoted=No;
                      Image=Holiday;
                      PromotedCategory=Report }
      { 9       ;1   ;ActionGroup;
                      CaptionML=ENU=Print }
      { 8       ;2   ;Action    ;
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
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Application No" }

    { 4   ;2   ;Field     ;
                SourceExpr="First Name" }

    { 5   ;2   ;Field     ;
                SourceExpr="Middle Name" }

    { 6   ;2   ;Field     ;
                SourceExpr="Last Name" }

    { 78  ;2   ;Field     ;
                SourceExpr="Job Applied for Description" }

    { 79  ;2   ;Field     ;
                SourceExpr="Regret Notice Sent" }

    { 80  ;2   ;Field     ;
                SourceExpr="Interview Type" }

    { 7   ;2   ;Field     ;
                SourceExpr="Job Applied For" }

  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'ENU=Are you sure you want to Upload Applicants Details to the Employee Card?';
      Text002@1000 : TextConst 'ENU=Are you sure you want to Send this Interview invitation?';
      HRJobApplications@1006 : Record 51516209;
      SMTP@1004 : Codeunit 400;
      CTEXTURL@1003 : Text[30];
      HREmailParameters@1002 : Record 51516202;

    BEGIN
    END.
  }
}

