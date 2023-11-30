OBJECT page 17365 HR Shortlisting Card
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=12:05:12 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516103;
    SourceTableView=WHERE(Status=CONST(Approved),
                          Closed=CONST(No));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Shortlist;
    OnInit=BEGIN
             "Required PositionsEditable" := TRUE;
             PriorityEditable := TRUE;
             ShortlistedEditable := TRUE;
             "Requisition DateEditable" := TRUE;
             "Job IDEditable" := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       OnAfterGetCurrRecord;
                     END;

    OnNewRecord=BEGIN
                  OnAfterGetCurrRecord;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1000000022;1 ;ActionGroup;
                      CaptionML=ENU=Applicants }
      { 1102755014;2 ;Action    ;
                      CaptionML=ENU=&ShortList Applicants;
                      Promoted=Yes;
                      Image=SelectField;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HRJobRequirements.RESET;
                                 HRJobRequirements.SETRANGE(HRJobRequirements."Job Id","Job ID");
                                 IF HRJobRequirements.COUNT=0 THEN BEGIN
                                 MESSAGE('Job Requirements for the job '+ "Job ID" +' have not been setup');
                                 EXIT;
                                 END ELSE BEGIN

                                 //GET JOB REQUIREMENTS
                                 HRJobRequirements.RESET;
                                 HRJobRequirements.SETRANGE(HRJobRequirements."Job Id","Job ID");

                                 //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                                 HRShortlistedApplicants.RESET;
                                 HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Employee Requisition No","Requisition No.");
                                 HRShortlistedApplicants.DELETEALL;

                                 //GET JOB APPLICANTS
                                 HRJobApplications.RESET;
                                 HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No","Requisition No.");
                                 IF HRJobApplications.FIND('-') THEN BEGIN
                                 REPEAT
                                       Qualified:= TRUE;
                                       IF HRJobRequirements.FIND('-') THEN BEGIN
                                       StageScore:=0;
                                       Score:=0;
                                       REPEAT
                                       //GET THE APPLICANTS QUALIFICATIONS AND COMPARE THEM WITH THE JOB REQUIREMENTS
                                       AppQualifications.RESET;
                                       AppQualifications.SETRANGE(AppQualifications."Application No",HRJobApplications."Application No");
                                       AppQualifications.SETRANGE(AppQualifications."Qualification Code",HRJobRequirements."Qualification Code");
                                       IF AppQualifications.FIND('-') THEN BEGIN
                                         Score:=Score + AppQualifications."Score ID";
                                         IF AppQualifications."Score ID" < HRJobRequirements."Desired Score" THEN
                                             Qualified:= FALSE;
                                       END ELSE BEGIN
                                         Qualified:= FALSE;
                                       END;

                                       UNTIL HRJobRequirements.NEXT = 0;
                                 END;

                                 HRShortlistedApplicants."Employee Requisition No":="Requisition No.";
                                 HRShortlistedApplicants."Job Application No":=HRJobApplications."Application No";
                                 HRShortlistedApplicants."Stage Score":=Score;
                                 HRShortlistedApplicants.Qualified:=Qualified;
                                 HRShortlistedApplicants."First Name":=HRJobApplications."First Name";
                                 HRShortlistedApplicants."Middle Name":=HRJobApplications."Middle Name";
                                 HRShortlistedApplicants."Last Name":=HRJobApplications."Last Name";
                                 HRShortlistedApplicants."ID No":=HRJobApplications."ID Number";
                                 HRShortlistedApplicants.Gender:=HRJobApplications.Gender;
                                 HRShortlistedApplicants."Marital Status":=HRJobApplications."Marital Status";
                                 HRShortlistedApplicants.INSERT;

                                 UNTIL HRJobApplications.NEXT = 0;
                                 END;
                                 //MARK QUALIFIED APPLICANTS AS QUALIFIED
                                 HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants.Qualified,TRUE);
                                 IF HRShortlistedApplicants.FIND('-') THEN
                                 REPEAT
                                   HRJobApplications.GET(HRShortlistedApplicants."Job Application No");
                                   HRJobApplications.Qualified:=TRUE;
                                   HRJobApplications."Qualification Status":=HRJobApplications."Qualification Status"::Qualified;
                                   HRJobApplications.MODIFY;
                                 UNTIL HRShortlistedApplicants.NEXT=0;
                                 {
                                 RecCount:= 0;
                                 MyCount:=0;
                                 StageShortlist.RESET;
                                 StageShortlist.SETRANGE(StageShortlist."Need Code","Need Code");
                                 StageShortlist.SETRANGE(StageShortlist."Stage Code","Stage Code");

                                 IF StageShortlist.FIND('-') THEN BEGIN
                                 RecCount:=StageShortlist.COUNT ;
                                 StageShortlist.SETCURRENTKEY(StageShortlist."Stage Score");
                                 StageShortlist.ASCENDING;
                                 REPEAT
                                 MyCount:=MyCount + 1;
                                 StageShortlist.Position:=RecCount - MyCount;
                                 StageShortlist.MODIFY;
                                 UNTIL StageShortlist.NEXT = 0;
                                 END;
                                 }
                                 MESSAGE('%1','Shortlisting Competed Successfully.');

                                 END;
                                 //END ELSE
                                 //MESSAGE('%1','You must select the stage you would like to shortlist.');
                               END;
                                }
      { 1102755016;2 ;Action    ;
                      CaptionML=ENU=&Print;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HREmpReq.RESET;
                                 HREmpReq.SETRANGE(HREmpReq."Requisition No.","Requisition No.");
                                 IF HREmpReq.FIND('-') THEN
                                 REPORT.RUN(51516176,TRUE,TRUE,HREmpReq);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=Job Details;
                Editable=TRUE }

    { 1102755000;2;Field  ;
                SourceExpr="Job ID";
                Importance=Promoted;
                Enabled=false;
                Editable=false;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755012;2;Field  ;
                SourceExpr="Job Description";
                Importance=Promoted;
                Enabled=false }

    { 1102755002;2;Field  ;
                SourceExpr="Requisition Date";
                Importance=Promoted;
                Enabled=false;
                Editable="Requisition DateEditable" }

    { 1102755004;2;Field  ;
                SourceExpr=Priority;
                Importance=Promoted;
                Enabled=false;
                Editable=PriorityEditable }

    { 1102755017;2;Field  ;
                SourceExpr="Vacant Positions";
                Importance=Promoted;
                Enabled=false }

    { 1102755010;2;Field  ;
                SourceExpr="Required Positions";
                Importance=Promoted;
                Enabled=false;
                Editable="Required PositionsEditable" }

    { 1102755008;2;Field  ;
                SourceExpr=Status;
                Importance=Promoted;
                Enabled=false;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1000000011;1;Part   ;
                Name=Shortlisted;
                SubPageLink=Employee Requisition No=FIELD(Requisition No.);
                PagePartID=Page51516209;
                Editable=ShortlistedEditable }

    { 1102755005;;Container;
                ContainerType=FactBoxArea }

    { 1102755003;1;Part   ;
                SubPageLink=Job ID=FIELD(Job ID);
                PagePartID=Page51516884;
                PartType=Page }

    { 1102755001;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      HRJobRequirements@1000000000 : Record 51516101;
      AppQualifications@1000000001 : Record 51516105;
      HRJobApplications@1000000002 : Record 51516209;
      Qualified@1000000003 : Boolean;
      StageScore@1000000004 : Decimal;
      HRShortlistedApplicants@1000000005 : Record 51516208;
      MyCount@1000000006 : Integer;
      RecCount@1000000007 : Integer;
      HREmpReq@1102755000 : Record 51516103;
      "Job IDEditable"@19026165 : Boolean INDATASET;
      "Requisition DateEditable"@19016415 : Boolean INDATASET;
      ShortlistedEditable@19027874 : Boolean INDATASET;
      PriorityEditable@19032936 : Boolean INDATASET;
      "Required PositionsEditable"@19065160 : Boolean INDATASET;
      Text19057439@19071730 : TextConst 'ENU=Short Listed Candidates';

    PROCEDURE UpdateControls@1102755001();
    BEGIN

      // IF Status=Status::New THEN BEGIN
      // "Job IDEditable" :=TRUE;
      // "Requisition DateEditable" :=TRUE;
      // ShortlistedEditable :=TRUE;
      // PriorityEditable :=TRUE;
      // "Required PositionsEditable" :=TRUE;
      // END ELSE BEGIN
      // "Job IDEditable" :=FALSE;
      // "Requisition DateEditable" :=FALSE;
      // ShortlistedEditable :=FALSE;
      // PriorityEditable :=FALSE;
      // "Required PositionsEditable" :=FALSE;
      // END;
    END;

    LOCAL PROCEDURE OnAfterGetCurrRecord@19077479();
    BEGIN
      xRec := Rec;

      UpdateControls;
    END;

    BEGIN
    END.
  }
}

