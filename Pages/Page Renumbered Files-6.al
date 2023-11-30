OBJECT page 20370 Job Exit Interview Card
{
  OBJECT-PROPERTIES
  {
    Date=07/15/22;
    Time=[ 3:29:09 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table50691;
    PageType=Card;
    OnOpenPage=BEGIN
                 IF "Leaving could have prevented"=TRUE THEN
                 PreventiveMeasureDescriptionEnabled:=TRUE
                 ELSE
                   PreventiveMeasureDescriptionEnabled:=FALSE;
               END;

    ActionList=ACTIONS
    {
      { 23      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 24      ;1   ;Action    ;
                      CaptionML=ENU=Send Mail;
                      Promoted=Yes;
                      Image=SendMail;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to send notification to your supervisor?')=TRUE THEN
                                   BEGIN
                                   HumanResourcesSetupRec.GET;
                                   TESTFIELD("Termination Date");
                                   TESTFIELD("Reason for Leaving");

                                   //Get Hod's email
                                   SupervisorEmail:='';
                                   UserSetupCopy.RESET;
                                   UserSetupCopy.SETRANGE(UserSetupCopy."Employee No.","Employee No.");
                                   IF UserSetupCopy.FINDFIRST THEN
                                      IF UserSetupRec.GET(UserSetupCopy."Immediate Supervisor") THEN
                                        SupervisorEmail:=UserSetupRec."E-Mail";

                                   //Get Hr hod email
                                   IF UserSetupCopy.GET(HumanResourcesSetupRec."HR HOD") THEN
                                    HRHoDEmail:=UserSetupCopy."E-Mail";

                                   CompanyInformationRec.GET;
                                   CompanyInformationRec.TESTFIELD("Administrator Email");
                                   SenderAddress:=CompanyInformationRec."Administrator Email";
                                     IF SenderAddress<>'' THEN
                                       BEGIN
                                         SenderName:=COMPANYNAME;
                                         Body:=STRSUBSTNO('Hello,<br>This is to bring to you attention my exit interview %1  for your action<br><br>Kind Regardsbr<br>');
                                         Body:=STRSUBSTNO(Body,Code);
                                         Subject := STRSUBSTNO('REF:Exit Interview');
                                         SMTPSetup.CreateMessage(SenderName,SenderAddress,SupervisorEmail,Subject,Body,TRUE);
                                         SMTPSetup.AddCC(HRHoDEmail);
                                         SMTPSetup.Send;
                                         MODIFY;
                                       END;
                                       CurrPage.CLOSE();
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr=Code }

    { 18  ;2   ;Field     ;
                SourceExpr="Document Date" }

    { 4   ;2   ;Field     ;
                SourceExpr="Employee No." }

    { 5   ;2   ;Field     ;
                SourceExpr="Employee Name";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr=Supervisor;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="Date of Join";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                SourceExpr="Termination Date" }

    { 9   ;2   ;Field     ;
                SourceExpr="Reason for Leaving" }

    { 10  ;2   ;Field     ;
                SourceExpr="Job Satisfying areas";
                MultiLine=Yes }

    { 11  ;2   ;Field     ;
                SourceExpr="Job Frustrating Areas";
                MultiLine=Yes }

    { 12  ;2   ;Field     ;
                CaptionML=ENU=Complicated Company Policies/Procedures;
                SourceExpr="Complicated Company Policies";
                MultiLine=Yes }

    { 13  ;2   ;Field     ;
                SourceExpr="Future Re-Employment" }

    { 14  ;2   ;Field     ;
                CaptionML=ENU=Would you recommend KenTrade to Others?;
                SourceExpr="Recommend To Others" }

    { 15  ;2   ;Field     ;
                SourceExpr="Leaving could have prevented";
                OnValidate=BEGIN
                             IF "Leaving could have prevented"=TRUE THEN
                             PreventiveMeasureDescriptionEnabled:=TRUE
                             ELSE
                               PreventiveMeasureDescriptionEnabled:=FALSE;
                           END;
                            }

    { 25  ;2   ;Group     ;
                Visible=PreventiveMeasureDescriptionEnabled;
                GroupType=Group }

    { 16  ;3   ;Field     ;
                SourceExpr="Preventive Measure Description";
                MultiLine=Yes }

    { 20  ;1   ;Group     ;
                CaptionML=ENU=Employment Experience Rating;
                GroupType=Group }

    { 19  ;1   ;Part      ;
                SubPageLink=Exit Interview Code=FIELD(Code);
                PagePartID=Page52108;
                PartType=Page }

    { 21  ;1   ;Group     ;
                CaptionML=ENU=Supervisor Rating;
                GroupType=Group }

    { 22  ;1   ;Part      ;
                CaptionML=ENU=Employee-Supervisor Experience Rating;
                SubPageLink=Exit Interview Code=FIELD(Code);
                PagePartID=Page52109;
                PartType=Page }

    { 17  ;1   ;Field     ;
                SourceExpr="Other Helpful  Information";
                MultiLine=Yes }

  }
  CODE
  {
    VAR
      CompanyInformationRec@1012 : Record 79;
      SMTPSetup@1011 : Codeunit 400;
      UserSetup@1010 : Record 91;
      SenderAddress@1009 : Text[80];
      Recipients@1008 : Text[80];
      SenderName@1007 : Text[50];
      Body@1006 : Text[250];
      Subject@1005 : Text[80];
      HumanResourcesSetupRec@1004 : Record 5218;
      userchoice@1003 : Integer;
      UserSetupCopy@1002 : Record 91;
      UserSetupRec@1001 : Record 91;
      SupervisorEmail@1000 : Text;
      HRHoDEmail@1013 : Text;
      PreventiveMeasureDescriptionEnabled@1014 : Boolean;

    BEGIN
    END.
  }
}

