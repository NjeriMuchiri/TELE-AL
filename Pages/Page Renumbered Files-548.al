OBJECT page 172143 HR Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/28/20;
    Time=[ 3:05:56 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516192;
    PageType=Card;
    RefreshOnActivate=No;
    OnOpenPage=BEGIN

                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755025;2;Field  ;
                SourceExpr="Leave Posting Period[FROM]" }

    { 1102755027;2;Field  ;
                SourceExpr="Leave Posting Period[TO]" }

    { 1000000005;2;Field  ;
                SourceExpr="Leave Template" }

    { 1000000006;2;Field  ;
                SourceExpr="Leave Batch" }

    { 1000000000;2;Field  ;
                SourceExpr="Default Leave Posting Template" }

    { 1000000001;2;Field  ;
                SourceExpr="Positive Leave Posting Batch" }

    { 7   ;2   ;Field     ;
                SourceExpr="Negative Leave Posting Batch" }

    { 1000000003;2;Field  ;
                SourceExpr="Max Appraisal Rating" }

    { 1000000004;2;Field  ;
                SourceExpr="Current Leave Period" }

    { 1904569201;1;Group  ;
                CaptionML=ENU=Numbering }

    { 1   ;2   ;Field     ;
                SourceExpr="Base Calendar" }

    { 1102755001;2;Field  ;
                SourceExpr="Employee Nos." }

    { 1102755002;2;Field  ;
                SourceExpr="Training Application Nos." }

    { 1102755003;2;Field  ;
                SourceExpr="Leave Application Nos." }

    { 1102755004;2;Field  ;
                SourceExpr="Disciplinary Cases Nos." }

    { 1102755006;2;Field  ;
                SourceExpr="Employee Requisition Nos." }

    { 1102755007;2;Field  ;
                SourceExpr="Job Application Nos" }

    { 1102755008;2;Field  ;
                SourceExpr="Exit Interview Nos" }

    { 1102755009;2;Field  ;
                SourceExpr="Appraisal Nos" }

    { 1102755022;2;Field  ;
                SourceExpr="Company Activities" }

    { 11  ;2   ;Field     ;
                SourceExpr="Job Nos" }

    { 1102755010;2;Field  ;
                SourceExpr="Job Interview Nos" }

    { 1102755013;2;Field  ;
                SourceExpr="Notice Board Nos." }

    { 1102755011;2;Field  ;
                SourceExpr="Company Documents" }

    { 8   ;2   ;Field     ;
                SourceExpr="Transport Req Nos" }

    { 1102755012;2;Field  ;
                SourceExpr="HR Policies" }

    { 2   ;2   ;Field     ;
                SourceExpr="Leave Reimbursment Nos." }

    { 3   ;2   ;Field     ;
                SourceExpr="Leave Carry Over App Nos." }

    { 4   ;2   ;Field     ;
                SourceExpr="Pay-change No." }

    { 9   ;2   ;Field     ;
                SourceExpr="Employee Transfer Nos." }

    { 10  ;2   ;Field     ;
                SourceExpr="Leave Planner Nos." }

    { 12  ;2   ;Field     ;
                CaptionML=ENU=Deployed Employee No;
                SourceExpr="Deployed Nos" }

    { 13  ;2   ;Field     ;
                CaptionML=ENU=Full Time Employee Nos;
                SourceExpr="Full Time Nos" }

    { 14  ;2   ;Field     ;
                CaptionML=ENU=Board Members Nos;
                SourceExpr="Board Nos" }

    { 15  ;2   ;Field     ;
                Name=Medical Claims Nos;
                CaptionML=ENU=Medical Claims Nos;
                SourceExpr="Medical Claims Nos" }

    { 1120054000;2;Field  ;
                SourceExpr="Staff Movement Nos" }

    { 1120054001;2;Field  ;
                SourceExpr="HR Meeting Nos" }

    { 5   ;1   ;Group     ;
                CaptionML=ENU=Leave;
                GroupType=Group }

    { 6   ;2   ;Field     ;
                SourceExpr="Min. Leave App. Months" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

