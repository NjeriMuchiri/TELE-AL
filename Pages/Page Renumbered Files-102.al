OBJECT page 20443 HR Employee List
{
  OBJECT-PROPERTIES
  {
    Date=02/09/21;
    Time=12:06:22 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516160;
    SourceTableView=WHERE(IsCommette=CONST(No),
                          IsBoard=CONST(No));
    PageType=List;
    CardPageID=HR Employee Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Employee;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755018;1 ;ActionGroup;
                      CaptionML=ENU=Employee }
      { 1102755019;2 ;Action    ;
                      CaptionML=ENU=Card;
                      RunObject=page 20444;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Card;
                      PromotedCategory=Category4 }
      { 1102755020;2 ;Action    ;
                      CaptionML=ENU=Kin/Beneficiaries;
                      RunObject=page 20470;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Relatives;
                      PromotedCategory=Category4 }
      { 1102755021;2 ;Action    ;
                      CaptionML=ENU=Employee Attachments;
                      RunObject=page 17356;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=Attach;
                      PromotedCategory=Category4 }
      { 1102755023;2 ;Action    ;
                      CaptionML=ENU=Employement History;
                      RunObject=page 20448;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=History;
                      PromotedCategory=Category4 }
      { 1102755024;2 ;Action    ;
                      CaptionML=ENU=Employee Qualifications;
                      RunObject=page 17354;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=QualificationOverview;
                      PromotedCategory=Category4 }
      { 1000000001;2 ;Action    ;
                      Name=Assigned Assets;
                      CaptionML=ENU=Assigned Assets;
                      RunObject=Page 5601;
                      RunPageLink=Responsible Employee=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ResourceJournal;
                      PromotedCategory=Category4 }
      { 1       ;2   ;Action    ;
                      Name=Leave Summary;
                      RunObject=page 20449;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=PreviewChecks;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {HREmp.RESET;
                                 HREmp.SETRANGE(HREmp."No.","No.");
                                 IF HREmp.FIND('-') THEN
                                   BEGIN
                                     REPORT.RUN(51516160,TRUE,FALSE,HREmp);
                                   END;}
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Transfer To Payroll;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ServiceLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PayrollEmployee@1120054000 : Record 51516180;
                                 HREmployee@1120054001 : Record 51516160;
                               BEGIN
                                 PayrollEmployee.RESET;
                                 PayrollEmployee.SETRANGE(PayrollEmployee."No.","No.");
                                 IF NOT PayrollEmployee.FIND('-') THEN BEGIN
                                  REPEAT
                                   IF HREmployee.GET("No.") THEN BEGIN
                                           PayrollEmployee.INIT;
                                           PayrollEmployee."No.":=HREmployee."No.";
                                           PayrollEmployee.Surname:=HREmployee."Last Name";
                                           PayrollEmployee.Firstname:=HREmployee."First Name";
                                           PayrollEmployee.Lastname:=HREmployee."Middle Name";
                                           PayrollEmployee."Full Name":=HREmployee.FullName;
                                           PayrollEmployee."NHIF No":=HREmployee."NHIF No.";
                                           PayrollEmployee."NSSF No":=HREmployee."NHIF No.";
                                           PayrollEmployee."PIN No":=HREmployee."PIN No.";
                                           PayrollEmployee."Joining Date":=HREmployee."Date Of Join";
                                           PayrollEmployee.INSERT;
                                         END;
                                       UNTIL HREmployee.NEXT=0;
                                        MESSAGE('Employees Uploaded Successfully');
                                 END ELSE
                                      MESSAGE('No employee to update!');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="No.";
                StyleExpr=TRUE }

    { 1102755005;2;Field  ;
                SourceExpr="First Name";
                Enabled=false }

    { 1102755007;2;Field  ;
                SourceExpr="Middle Name";
                Enabled=false }

    { 1102755022;2;Field  ;
                SourceExpr="Last Name";
                Enabled=false }

    { 1102755042;2;Field  ;
                SourceExpr="Job Title";
                Enabled=false }

    { 1102755046;2;Field  ;
                SourceExpr="User ID" }

    { 1102755030;2;Field  ;
                SourceExpr="Company E-Mail";
                Enabled=false }

    { 1000000000;2;Field  ;
                SourceExpr="Cellular Phone Number" }

    { 2   ;2   ;Field     ;
                SourceExpr=Status }

    { 1102755004;;Container;
                ContainerType=FactBoxArea }

    { 1102755002;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516137;
                PartType=Page;
                SystemPartID=Outlook }

    { 1102755003;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      HREmp@1102755000 : Record 51516160;
      EmployeeFullName@1000000000 : Text;

    BEGIN
    END.
  }
}

