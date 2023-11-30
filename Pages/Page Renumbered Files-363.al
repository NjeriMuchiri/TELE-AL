OBJECT page 50054 HR Applicants Qualified Card
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 3:10:24 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516209;
    SourceTableView=WHERE(Qualification Status=CONST(Qualified));
    PageType=Card;
    ActionList=ACTIONS
    {
      { 16      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=ENU=Applicant }
      { 14      ;2   ;Action    ;
                      Name=Send Interview Invitation;
                      CaptionML=ENU=Send Interview Invitation;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendMail;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 //IF CONFIRM('Send this Requisition for Approval?',TRUE)=FALSE THEN EXIT;
                                 IF NOT CONFIRM(Text002,FALSE) THEN EXIT;

                                 TESTFIELD(Qualified,Qualified::"1");
                                 HRJobApplications.SETRANGE(HRJobApplications."Application No","Application No");
                                 CurrPage.SETSELECTIONFILTER(HRJobApplications);
                                 IF HRJobApplications.FIND('-') THEN
                                 //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                                 HREmailParameters.RESET;
                                 HREmailParameters.SETRANGE(HREmailParameters."Associate With",HREmailParameters."Associate With"::"Interview Invitations");
                                 IF HREmailParameters.FIND('-') THEN
                                 BEGIN
                                      REPEAT
                                      HRJobApplications.TESTFIELD(HRJobApplications."E-Mail");
                                      SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HRJobApplications."E-Mail",
                                      HREmailParameters.Subject,'Dear'+' '+HRJobApplications."First Name"+' '+HREmailParameters.Body+' '+HRJobApplications."Job Applied for Description"+' '+'applied on'+FORMAT("Date Applied")+' '+HREmailParameters."Body 2"+//,TRUE);
                                      FORMAT(HRJobApplications."Date of Interview")+' '+'Starting '+' '+FORMAT(HRJobApplications."From Time")+' '+'to'+FORMAT(HRJobApplications."To Time")+' '+'at'+HRJobApplications.Venue+'.',TRUE);
                                      //HREmailParameters.Body,TRUE);
                                      SMTP.Send();
                                      UNTIL HRJobApplications.NEXT=0;

                                 IF CONFIRM('Do you want to send this invitation alert?',FALSE) = TRUE THEN BEGIN
                                 "Interview Invitation Sent":=TRUE;
                                 MODIFY;
                                 MESSAGE('All Qualified shortlisted candidates have been invited for the interview ')
                                 END;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 13  ;0   ;Container ;
                ContainerType=ContentArea }

    { 12  ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 11  ;2   ;Field     ;
                SourceExpr="Application No" }

    { 10  ;2   ;Field     ;
                SourceExpr="First Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Middle Name" }

    { 8   ;2   ;Field     ;
                SourceExpr="Last Name" }

    { 7   ;2   ;Field     ;
                SourceExpr="Job Applied For" }

    { 6   ;2   ;Field     ;
                SourceExpr=Qualified }

    { 5   ;2   ;Field     ;
                SourceExpr="Date of Interview" }

    { 4   ;2   ;Field     ;
                SourceExpr="From Time" }

    { 3   ;2   ;Field     ;
                SourceExpr="To Time" }

    { 2   ;2   ;Field     ;
                SourceExpr=Venue }

    { 1   ;2   ;Field     ;
                SourceExpr="Interview Type" }

  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'ENU=Are you sure you want to Upload Applicants Details to the Employee Card?';
      Text002@1000 : TextConst 'ENU=Are you sure you want to Send this Interview invitation?';
      HRJobApplications@1002 : Record 51516209;
      HREmailParameters@1003 : Record 51516202;
      SMTP@1004 : Codeunit 400;

    BEGIN
    END.
  }
}

