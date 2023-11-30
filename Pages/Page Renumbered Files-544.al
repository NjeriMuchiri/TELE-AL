OBJECT page 172139 HR Leave Period List
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 2:09:53 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516198;
    PageType=List;
    ActionList=ACTIONS
    {
      { 3       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;Action    ;
                      Name=<Report 51516233>;
                      Ellipsis=Yes;
                      CaptionML=ENU=&Create Year;
                      RunObject=Report 51516016;
                      Promoted=Yes;
                      Visible=false;
                      Image=CreateYear;
                      PromotedCategory=Process }
      { 1       ;1   ;Action    ;
                      CaptionML=ENU=C&lose Year;
                      RunObject=Codeunit 51516106;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=CloseYear;
                      PromotedCategory=Process }
      { 1120054000;1 ;Action    ;
                      Name=Close Year;
                      Ellipsis=Yes;
                      CaptionML=ENU=&Close Year;
                      Promoted=Yes;
                      Image=CreateYear;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF NOT CONFIRM('Sure to close old year and create a new one?',FALSE) THEN EXIT;

                                 HRLeavePeriods.RESET;
                                 HRLeavePeriods.SETRANGE(Closed,FALSE);
                                 IF HRLeavePeriods.FINDFIRST THEN
                                    BEGIN
                                         HRLeavePeriods.Closed:=TRUE;
                                         HRLeavePeriods."Closed By":=USERID;
                                         HRLeavePeriods."Date Closed":=CURRENTDATETIME;
                                         HRLeavePeriods.MODIFY;
                                      END;


                                 HRLeavePeriods.RESET;
                                 HRLeavePeriods.SETRANGE("Starting Date",CALCDATE('-CY',TODAY));
                                 IF NOT HRLeavePeriods.FINDFIRST THEN BEGIN

                                   HRLeavePeriods.INIT;
                                   HRLeavePeriods.Name:=FORMAT(DATE2DMY(TODAY,3));
                                   HRLeavePeriods."Starting Date":=CALCDATE('-CY',TODAY);
                                   HRLeavePeriods."End Date":=CALCDATE('CY',TODAY);
                                   HRLeavePeriods."Period Code":=FORMAT(DATE2DMY(TODAY,3));
                                   HRLeavePeriods."Period Description":=FORMAT(DATE2DMY(TODAY,3)) +' - Leave Period';
                                   HRLeavePeriods."Opened By":=USERID;
                                   HRLeavePeriods."Date Opened":=CURRENTDATETIME;
                                   HRLeavePeriods.INSERT;

                                 END ELSE
                                     MESSAGE('The leave period for this year has already been created!');
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

    { 4   ;2   ;Field     ;
                SourceExpr="Period Code" }

    { 5   ;2   ;Field     ;
                SourceExpr="Period Description" }

    { 1102755002;2;Field  ;
                SourceExpr="Starting Date" }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755004;2;Field  ;
                SourceExpr="New Fiscal Year";
                Editable=FALSE }

    { 1120054001;2;Field  ;
                SourceExpr="End Date" }

    { 1120054002;2;Field  ;
                SourceExpr="Date Opened" }

    { 1120054003;2;Field  ;
                SourceExpr="Opened By" }

    { 1120054004;2;Field  ;
                SourceExpr="Date Closed" }

    { 1120054005;2;Field  ;
                SourceExpr="Closed By" }

    { 1102755005;2;Field  ;
                SourceExpr=Closed;
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Date Locked" }

    { 1102755007;0;Container;
                ContainerType=FactBoxArea }

    { 1102755008;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

    { 1102755009;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      HRLeavePeriods@1120054000 : Record 51516198;

    BEGIN
    END.
  }
}

