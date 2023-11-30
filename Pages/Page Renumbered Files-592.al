OBJECT page 172187 Pending Leave Card
{
  OBJECT-PROPERTIES
  {
    Date=09/08/22;
    Time=[ 3:01:08 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516191;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Functions,Comments;
    OnInit=BEGIN
             NumberofPreviousAttemptsEditab := TRUE;
             "Date of ExamEditable" := TRUE;
             "Details of ExaminationEditable" := TRUE;
             "Cell Phone NumberEditable" := TRUE;
             SupervisorEditable := TRUE;
             RequestLeaveAllowanceEditable := TRUE;
             RelieverEditable := TRUE;
             "Leave Allowance AmountEditable" := TRUE;
             "Start DateEditable" := TRUE;
             "Responsibility CenterEditable" := TRUE;
             "Days AppliedEditable" := TRUE;
             "Leave TypeEditable" := TRUE;
             "Application CodeEditable" := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                                                  EmpDept:='';
                                                  //PASS VALUES TO VARIABLES ON THE FORM
                                                  FillVariables;
                                                  //GET LEAVE STATS FOR THIS EMPLOYEE FROM THE EMPLOYEE TABLE
                                                  GetLeaveStats("Leave Type");
                                                  //TO PREVENT USER FROM SEEING OTHER PEOPLES LEAVE APPLICATIONS
                                                 SETFILTER("User ID",USERID);

                                                  Updatecontrols;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center":='FINANCE'
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755013;1 ;ActionGroup;
                      CaptionML=ENU=&Show }
      { 1102755012;2 ;Action    ;
                      CaptionML=ENU=Attachments;
                      Promoted=Yes;
                      Image=Attachments;
                      PromotedCategory=Category6 }
      { 1102755067;1 ;ActionGroup;
                      CaptionML=ENU=F&unctions }
      { 1000000018;2 ;Action    ;
                      CaptionML=ENU=&Approvals;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 //DocumentType:=DocumentType::"Leave Application";
                                 ApprovalEntries.Setfilters(DATABASE::"HR Leave Application",DocumentType,"Application Code");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755071;2 ;Action    ;
                      CaptionML=ENU=Re-Open;
                      Promoted=Yes;
                      Image=ReopenCancelled;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                                          Status:=Status::New;
                                                          MODIFY;
                               END;
                                }
      { 1102755019;2 ;Action    ;
                      CaptionML=ENU=Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PrintForm;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HRLeaveApp.RESET;
                                 HRLeaveApp.SETRANGE(HRLeaveApp."Application Code","Application Code");
                                 IF HRLeaveApp.FIND('-') THEN
                                 REPORT.RUN(51516610,TRUE,TRUE,HRLeaveApp);
                               END;
                                }
      { 1000000004;2 ;Action    ;
                      CaptionML=ENU=&Post Leave Application;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 UserSetup.RESET;
                                 UserSetup.SETRANGE(UserSetup."User ID",USERID);
                                 IF UserSetup.FIND('-') THEN
                                   {IF UserSetup."Post Leave Applications"=FALSE THEN
                                     ERROR('You are not allowed to post Leave Applications! Contact Administrator for further Guidance!');}

                                 IF Posted=TRUE THEN ERROR('This Leave application has already been posted');
                                 IF Status<>Status::Approved THEN
                                 ERROR('The Leave Status must be Approved');

                                 HRLeaveApp.RESET;
                                 HRLeaveApp.SETRANGE(HRLeaveApp."Application Code","Application Code");
                                 IF HRLeaveApp.FIND('-')THEN BEGIN
                                 HRLeaveApp.CreateLeaveLedgerEntries;

                                 END;

                                 //Posted:=TRUE;
                                 //MODIFY;

                                      //To notify leave applicant
                                 // IF CONFIRM('Do you wish to notify the employee')=TRUE THEN BEGIN
                                 // HREmp.GET("Employee No");
                                 // HREmp.TESTFIELD(HREmp."Email Address");
                                 // SMTPSetup.GET();
                                 // CompInfo.GET();
                                 //   SMTPMail.CreateMessage(SMTPSetup."Email Sender Name",SMTPSetup."Email Sender Address",HREmp."Email Address",'Leave Application','',TRUE);
                                 //   SMTPMail.AppendBody(STRSUBSTNO('Your leave application is sucessful',HREmp."Full Name","Leave Type","Approved days","Start Date","End Date",USERID));
                                 //   SMTPMail.AppendBody(SMTPSetup."Email Sender Name");
                                 //   SMTPMail.AppendBody('<br><br>');
                                 //   SMTPMail.AddAttachment(Filename,Attachment);
                                 //   SMTPMail.Send;
                                 // END;
                                 //  MESSAGE('Leave applicant has been notified successfully');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755006;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755001;2;Field  ;
                CaptionML=ENU=Application No;
                SourceExpr="Application Code";
                Importance=Promoted;
                Editable=false;
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 1000000001;2;Field  ;
                SourceExpr="Responsibility Center" }

    { 1102755008;2;Field  ;
                SourceExpr="Leave Type";
                Importance=Promoted;
                Editable="Leave TypeEditable";
                OnValidate=BEGIN
                             {GetLeaveStats("Leave Type");
                             //  CurrPage.UPDATE;

                             HREmp.GET("Employee No");
                             IF "Leave Type"='ANNUAL' THEN BEGIN
                               IF "Days Applied">Rec.dleft THEN
                                ERROR('Days applied cannot exceed leave balance for this leave');
                             END ELSE BEGIN
                              HRLeaveTypes.RESET;
                              HRLeaveTypes.SETRANGE(HRLeaveTypes.Code,"Leave Type");
                              IF HRLeaveTypes.FIND('-') THEN BEGIN
                               IF "Days Applied">HRLeaveTypes.Days THEN
                                ERROR('Days applied cannot exceed leave balance for this leave');

                              END;
                             END;}
                             {
                             IF HREmp.GET("Employee No") THEN BEGIN
                             IF HREmp."Working Sunday"=TRUE THEN
                             SETRANGE("Leave Type",'ANNUAL_W');
                             END;
                             }
                           END;
                            }

    { 1102755007;2;Field  ;
                SourceExpr="Days Applied";
                Importance=Promoted;
                Editable="Days AppliedEditable";
                OnValidate=BEGIN
                             {MESSAGE('%1',HRLeaveTypes.Days);
                             HREmp.GET("Employee No");
                             IF "Leave Type"='ANNUAL' THEN BEGIN
                               IF "Days Applied">dLeft THEN
                                ERROR('Days applied cannot exceed leave balance for this leave');
                             END ELSE BEGIN
                              HRLeaveTypes.RESET;
                              HRLeaveTypes.SETRANGE(HRLeaveTypes.Code,"Leave Type");
                              IF HRLeaveTypes.FIND('-') THEN BEGIN
                               IF "Days Applied">HRLeaveTypes.Days THEN
                                ERROR('Days applied cannot exceed leave balance for this leave');
                              END;

                             END;
                             }
                           END;
                            }

    { 1102755005;2;Field  ;
                SourceExpr="Start Date";
                Importance=Promoted;
                Editable="Start DateEditable" }

    { 1102755003;2;Field  ;
                SourceExpr="Return Date";
                Editable=false }

    { 1000000007;2;Field  ;
                SourceExpr="Request Leave Allowance" }

    { 1000000019;2;Field  ;
                SourceExpr="Leave Allowance Amount" }

    { 1102755010;2;Field  ;
                CaptionML=ENU=Employee Details;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755009;2;Field  ;
                CaptionML=ENU=Employee No.;
                SourceExpr="Employee No";
                Importance=Promoted;
                Enabled=false;
                Editable=FALSE }

    { 1102755048;2;Field  ;
                CaptionML=ENU=Applicant Name;
                SourceExpr="Employee Name";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE }

    { 1102755045;2;Field  ;
                CaptionML=ENU=Job Title;
                SourceExpr="Job Tittle";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE }

    { 1   ;2   ;Field     ;
                SourceExpr=Gender }

    { 1102755049;2;Field  ;
                CaptionML=ENU=Job Description;
                SourceExpr=EmpJobDesc;
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE }

    { 1102755069;2;Field  ;
                CaptionML=ENU=Department;
                SourceExpr=EmpDept;
                Enabled=FALSE;
                Editable=FALSE }

    { 1102755046;2;Field  ;
                SourceExpr=Supervisor;
                Editable=SupervisorEditable;
                OnValidate=BEGIN
                                                         //GET THE APPROVER NAMES
                                                         HREmp.RESET;
                                                         HREmp.SETRANGE(HREmp."User ID",Supervisor);
                                                         IF HREmp.FIND('-') THEN
                                                         BEGIN
                                                         SupervisorName:=HREmp.County + ' ' + HREmp."Home Phone Number" + ' ' + HREmp."Post Code";
                                                         END ELSE BEGIN
                                                         SupervisorName:='';
                                                         END;
                           END;
                            }

    { 1102755051;2;Field  ;
                CaptionML=ENU=Supervisor Name;
                SourceExpr=SupervisorName;
                Editable=FALSE }

    { 1102755050;2;Field  ;
                CaptionML=ENU=Supervisor Email;
                SourceExpr="Supervisor Email";
                Editable=FALSE }

    { 1120054001;2;Field  ;
                SourceExpr="Reccommended Days" }

    { 1000000005;2;Field  ;
                SourceExpr="Approved days" }

    { 1102755082;2;Field  ;
                CaptionClass=Text19010232;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1120054000;2;Field  ;
                SourceExpr="Leave Balance";
                Editable=false }

    { 1102755053;2;Field  ;
                SourceExpr="Application Date";
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755031;2;Field  ;
                CaptionML=ENU=Reliever Code;
                SourceExpr=Reliever;
                Editable=RelieverEditable }

    { 1102755033;2;Field  ;
                SourceExpr="Reliever Name";
                Editable=FALSE }

    { 1000000002;2;Field  ;
                CaptionML=ENU=Reliever (2);
                SourceExpr=Reliever2 }

    { 1000000006;2;Field  ;
                CaptionML=ENU=Reliever (2) Name;
                SourceExpr="Reliever Name2" }

    { 1102755016;2;Field  ;
                SourceExpr=Attachments }

    { 1102755021;2;Field  ;
                SourceExpr=Status;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1904823801;1;Group  ;
                CaptionML=ENU=More Leave Details }

    { 1102755011;2;Field  ;
                SourceExpr="Cell Phone Number";
                Importance=Promoted;
                Editable="Cell Phone NumberEditable" }

    { 1102755054;2;Field  ;
                SourceExpr="E-mail Address";
                Importance=Promoted;
                Editable=true }

    { 1102755058;2;Field  ;
                SourceExpr="Details of Examination";
                Importance=Promoted;
                Visible=false;
                Editable="Details of ExaminationEditable" }

    { 1102755060;2;Field  ;
                SourceExpr="Date of Exam";
                Importance=Promoted;
                Visible=false;
                Editable="Date of ExamEditable" }

    { 1102755062;2;Field  ;
                SourceExpr="Number of Previous Attempts";
                Importance=Promoted;
                Visible=false;
                Editable=NumberofPreviousAttemptsEditab }

    { 1000000008;1;Group  ;
                CaptionML=ENU=Exam Dates;
                GroupType=Group }

    { 1000000009;2;Field  ;
                SourceExpr="Date Of Exam 1" }

    { 1000000010;2;Field  ;
                SourceExpr="Date Of Exam 2" }

    { 1000000011;2;Field  ;
                SourceExpr="Date Of Exam 3" }

    { 1000000012;2;Field  ;
                SourceExpr="Date Of Exam 4" }

    { 1000000013;2;Field  ;
                SourceExpr="Date Of Exam 5" }

    { 1000000014;2;Field  ;
                SourceExpr="Date Of Exam 6" }

    { 1000000015;2;Field  ;
                SourceExpr="Date Of Exam 7" }

    { 1102755002;;Container;
                ContainerType=FactBoxArea }

    { 1000000003;1;Part   ;
                SubPageLink=City=FIELD(Employee No);
                PagePartID=Page51516880;
                PartType=Page }

    { 1102755004;1;Part   ;
                Name=s;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      HREmp@1102755013 : Record 51516160;
      EmpJobDesc@1102755012 : Text[50];
      HRJobs@1102755011 : Record 51516100;
      SupervisorName@1102755010 : Text[60];
      SMTP@1102755009 : Codeunit 400;
      URL@1102755008 : Text[500];
      dAlloc@1102755007 : Decimal;
      dEarnd@1102755006 : Decimal;
      dTaken@1102755005 : Decimal;
      dLeft@1102755004 : Decimal;
      cReimbsd@1102755003 : Decimal;
      cPerDay@1102755002 : Decimal;
      cbf@1102755001 : Decimal;
      HRSetup@1102755000 : Record 51516192;
      EmpDept@1102755015 : Text[30];
      ApprovalMgt@1102755016 : Codeunit 1535;
      HRLeaveApp@1102755017 : Record 51516191;
      DocumentType@1102755018 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Store Requisition,Employee Requisition,Leave Application,Transport Requisition,Training Requisition,Job Approval';
      ApprovalEntries@1102755019 : Page 658;
      HRLeaveLedgerEntries@1102755020 : Record 51516201;
      EmpName@1102755022 : Text[70];
      ApprovalComments@1102755021 : Page 660;
      "Application CodeEditable"@19071942 : Boolean INDATASET;
      "Leave TypeEditable"@19034848 : Boolean INDATASET;
      "Days AppliedEditable"@19049127 : Boolean INDATASET;
      "Responsibility CenterEditable"@19002769 : Boolean INDATASET;
      "Start DateEditable"@19035501 : Boolean INDATASET;
      "Leave Allowance AmountEditable"@19061547 : Boolean INDATASET;
      RelieverEditable@19028817 : Boolean INDATASET;
      RequestLeaveAllowanceEditable@19054687 : Boolean INDATASET;
      SupervisorEditable@19043455 : Boolean INDATASET;
      "Cell Phone NumberEditable"@19033212 : Boolean INDATASET;
      "Details of ExaminationEditable"@19007386 : Boolean INDATASET;
      "Date of ExamEditable"@19050857 : Boolean INDATASET;
      NumberofPreviousAttemptsEditab@19002178 : Boolean INDATASET;
      Text19010232@19005685 : TextConst 'ENU=Leave Statistics';
      Text1@1000000000 : TextConst 'ENU=Reliver Details';
      NoSeriesMgt@1000000019 : Codeunit 396;
      UserSetup@1000000018 : Record 91;
      varDaysApplied@1000000016 : Integer;
      HRLeaveTypes@1000000015 : Record 51516193;
      BaseCalendarChange@1000000014 : Record 7601;
      ReturnDateLoop@1000000013 : Boolean;
      mSubject@1000000012 : Text[250];
      ApplicantsEmail@1000000011 : Text[30];
      LeaveGjline@1000000009 : Record 51516197;
      "LineNo."@1000000008 : Integer;
      sDate@1000000005 : Record 2000000007;
      Customized@1000000004 : Record 51516202;
      HREmailParameters@1000000003 : Record 51516202;
      HRLeavePeriods@1000000002 : Record 51516198;
      HRJournalBatch@1000000001 : Record 51516196;
      SMTPSetup@1000000006 : Record 409;
      CompInfo@1000000007 : Record 79;
      SMTPMail@1000000010 : Codeunit 400;
      Filename@1000000017 : Text;
      Selectedfilter@1000000020 : Date;
      Attachment@1000000021 : Text;

    PROCEDURE FillVariables@1102755000();
    BEGIN
                                  //GET THE APPLICANT DETAILS

                                  HREmp.RESET;
                                  IF HREmp.GET("Employee No") THEN
                                  BEGIN
                                  EmpName:=HREmp.County+''+HREmp."Home Phone Number"+''+HREmp."Post Code";
                                  EmpDept:=HREmp."Fax Number";
                                  END ELSE BEGIN
                                  EmpDept:='';
                                  END;

                                  //GET THE JOB DESCRIPTION FRON THE HR JOBS TABLE AND PASS IT TO THE VARIABLE
                                  HRJobs.RESET;
                                  IF HRJobs.GET("Job Tittle") THEN
                                  BEGIN
                                  EmpJobDesc:=HRJobs."Job Description";
                                  END ELSE BEGIN
                                  EmpJobDesc:='';
                                  END;

                                  //GET THE APPROVER NAMES
                                  HREmp.RESET;
                                  HREmp.SETRANGE(HREmp."User ID",Supervisor);
                                  IF HREmp.FIND('-') THEN
                                  BEGIN
                                  SupervisorName:=HREmp.County + ' ' + HREmp."Home Phone Number" + ' ' + HREmp."Post Code";
                                  END ELSE BEGIN
                                  SupervisorName:='';
                                  END;
    END;

    PROCEDURE GetLeaveStats@1102755001(LeaveType@1102755000 : Text[50]);
    BEGIN
                                  dAlloc := 0;
                                  dEarnd := 0;
                                  dTaken := 0;
                                  dLeft := 0;
                                  cReimbsd := 0;
                                  cPerDay := 0;
                                  cbf:=0;
                                  IF HREmp.GET("Employee No") THEN BEGIN
                                  HREmp.SETFILTER(HREmp."Leave Type Filter",LeaveType);
                                  HREmp.CALCFIELDS(HREmp."Allocated Leave Days");
                                  dAlloc := HREmp."Allocated Leave Days";
                                  HREmp.VALIDATE(HREmp."Allocated Leave Days");
                                  dEarnd := HREmp."Total (Leave Days)";
                                  HREmp.CALCFIELDS(HREmp."Total Leave Taken");
                                  dTaken := HREmp."Total Leave Taken";
                                  dLeft :=  HREmp."Leave Balance";
                                  cReimbsd :=HREmp."Cash - Leave Earned";
                                  cPerDay := HREmp."Emmergency Leave Total" ; //mutinda
                                  HREmp.CALCFIELDS(HREmp."Reimbursed Leave Days");
                                  cbf:=HREmp."Reimbursed Leave Days";
                                  END;

    END;

    PROCEDURE TESTFIELDS@1102755002();
    BEGIN
                                      TESTFIELD("Leave Type");
                                      TESTFIELD("Days Applied");
                                      TESTFIELD("Start Date");
                                      TESTFIELD(Reliever);
                                      TESTFIELD(Supervisor);
    END;

    PROCEDURE Updatecontrols@1102755003();
    BEGIN

      IF Status=Status::New THEN BEGIN
      "Application CodeEditable" :=TRUE;
      "Leave TypeEditable" :=TRUE;
      "Days AppliedEditable" :=TRUE;
      "Responsibility CenterEditable" :=TRUE;
      "Start DateEditable" :=TRUE;
      "Leave Allowance AmountEditable" :=TRUE;
      RelieverEditable :=TRUE;
      RequestLeaveAllowanceEditable :=TRUE;
      SupervisorEditable :=TRUE;
      "Cell Phone NumberEditable" :=TRUE;
      //CurrForm."E-mail Address".EDITABLE:=TRUE;
      "Details of ExaminationEditable" :=TRUE;
      "Date of ExamEditable" :=TRUE;
      NumberofPreviousAttemptsEditab :=TRUE;
      END ELSE BEGIN
      "Application CodeEditable" :=FALSE;
      "Leave TypeEditable" :=FALSE;
      "Days AppliedEditable" :=FALSE;
      "Responsibility CenterEditable" :=FALSE;
      "Start DateEditable" :=FALSE;
      "Leave Allowance AmountEditable" :=FALSE;
      RelieverEditable :=FALSE;
      RequestLeaveAllowanceEditable :=FALSE;
      SupervisorEditable :=FALSE;
      "Cell Phone NumberEditable" :=FALSE;
      //CurrForm."E-mail Address".EDITABLE:=FALSE;
      "Details of ExaminationEditable" :=FALSE;
      "Date of ExamEditable" :=FALSE;
      NumberofPreviousAttemptsEditab :=FALSE;
      END;
    END;

    PROCEDURE TestLeaveFamily@1102755004();
    VAR
      Employees@1102755002 : Record 51516160;
    BEGIN
      {LeaveFamilyEmployees.SETRANGE(LeaveFamilyEmployees."Employee No","Employee No");
      IF LeaveFamilyEmployees.FINDSET THEN //find the leave family employee is associated with
      REPEAT
        LeaveFamily.SETRANGE(LeaveFamily.Code,LeaveFamilyEmployees.Family);
        LeaveFamily.SETFILTER(LeaveFamily."Max Employees On Leave",'>0');
        IF LeaveFamily.FINDSET THEN //find the status other employees on the same leave family
          BEGIN
            Employees.SETRANGE(Employees."No.",LeaveFamilyEmployees."Employee No");
            Employees.SETRANGE(Employees."Leave Status",Employees."Leave Status"::" ");
            IF Employees.COUNT>LeaveFamily."Max Employees On Leave" THEN
            ERROR('The Maximum number of employees on leave for this family has been exceeded, Contact th HR manager for more information');
          END
      UNTIL LeaveFamilyEmployees.NEXT = 0;
      }
    END;

    PROCEDURE DetermineLeaveReturnDate@1102760002(VAR fBeginDate@1102760000 : Date;VAR fDays@1102760001 : Decimal) fReturnDate : Date;
    BEGIN
      {varDaysApplied := fDays;
      fReturnDate := fBeginDate;
      REPEAT
        IF DetermineIfIncludesNonWorking("Leave Type") =FALSE THEN BEGIN
          fReturnDate := CALCDATE('1D', fReturnDate);
          IF DetermineIfIsNonWorking(fReturnDate) THEN
            varDaysApplied := varDaysApplied + 1
          ELSE
            varDaysApplied := varDaysApplied;
          varDaysApplied := varDaysApplied - 1
        END
        ELSE BEGIN
          fReturnDate := CALCDATE('1D', fReturnDate);
          varDaysApplied := varDaysApplied - 1;
        END;
      UNTIL varDaysApplied = 0;
      EXIT(fReturnDate);
             }
    END;

    PROCEDURE DetermineIfIncludesNonWorking@1102760001(VAR fLeaveCode@1102760000 : Code[10]) : Boolean;
    BEGIN
      IF HRLeaveTypes.GET(fLeaveCode) THEN BEGIN
      IF HRLeaveTypes."Inclusive of Non Working Days" = TRUE THEN
      EXIT(TRUE);
      END;
    END;

    PROCEDURE DetermineIfIsNonWorking@1102760000(VAR bcDate@1102760000 : Date) Isnonworking : Boolean;
    BEGIN

      HRSetup.FIND('-');
      HRSetup.TESTFIELD(HRSetup."Base Calendar");
      BaseCalendarChange.SETFILTER(BaseCalendarChange."Base Calendar Code",HRSetup."Base Calendar");
      BaseCalendarChange.SETRANGE(BaseCalendarChange.Date,bcDate);

      IF BaseCalendarChange.FIND('-') THEN BEGIN
      IF BaseCalendarChange.Nonworking = FALSE THEN
      ERROR('Start date can only be a Working Day Date');
      EXIT(TRUE);
      END;

      {
      Customized.RESET;
      Customized.SETRANGE(Customized.Date,bcDate);
      IF Customized.FIND('-') THEN BEGIN
          IF Customized."Non Working" = TRUE THEN
          EXIT(TRUE)
          ELSE
          EXIT(FALSE);
      END;
       }
    END;

    PROCEDURE DeterminethisLeaveEndDate@1102760025(VAR fDate@1102760000 : Date) fEndDate : Date;
    BEGIN
      {ReturnDateLoop := TRUE;
      fEndDate := fDate;
      IF fEndDate <> 0D THEN BEGIN
        fEndDate := CALCDATE('-1D', fEndDate);
        WHILE (ReturnDateLoop) DO BEGIN
        IF DetermineIfIsNonWorking(fEndDate) THEN
          fEndDate := CALCDATE('-1D', fEndDate)
         ELSE
          ReturnDateLoop := FALSE;
        END
        END;
      EXIT(fEndDate);
       }
    END;

    PROCEDURE CreateLeaveLedgerEntries@1000000007();
    BEGIN
      {TESTFIELD("Approved days");
      HRSetup.RESET;
      IF HRSetup.FIND('-') THEN BEGIN

      LeaveGjline.RESET;
      LeaveGjline.SETRANGE("Employee No.",HRSetup."Leave Template");
      LeaveGjline.SETRANGE(,HRSetup."Leave Batch");
      LeaveGjline.DELETEALL;
        //Dave
      //HRSetup.TESTFIELD(HRSetup."Leave Template");
      //HRSetup.TESTFIELD(HRSetup."Leave Batch");

      HREmp.GET("Employee No");
      HREmp.TESTFIELD(HREmp."Statistics Group Code");

      //POPULATE JOURNAL LINES

      "LineNo.":=10000;
      LeaveGjline.INIT;
      LeaveGjline."Employee No.":=HRSetup."Leave Template";
      LeaveGjline."Line No.":=HRSetup."Leave Batch";
      LeaveGjline."Line No.":="LineNo.";
      LeaveGjline."From Date":='2017';
      LeaveGjline."Employee Status":="Application Code";
      LeaveGjline.Type:="Employee No";
      LeaveGjline.VALIDATE(LeaveGjline.Type);
      LeaveGjline."Institution/Company":=TODAY;
      LeaveGjline.Cost:=LeaveGjline.Cost::"1";
      LeaveGjline."Course Grade":=TODAY;
      LeaveGjline."Qualification Type":='Leave Taken';
      LeaveGjline."Leave Type":="Leave Type";
      //------------------------------------------------------------
      //HRSetup.RESET;
      //HRSetup.FIND('-');
      HRSetup.TESTFIELD(HRSetup."Leave Posting Period[FROM]");
      HRSetup.TESTFIELD(HRSetup."Leave Posting Period[TO]");
      //------------------------------------------------------------
      LeaveGjline."Leave Period Start Date":=HRSetup."Leave Posting Period[FROM]";
      LeaveGjline."Leave Period End Date":=HRSetup."Leave Posting Period[TO]";
      LeaveGjline."Expiration Date":="Approved days";
      IF LeaveGjline."Expiration Date"<>0 THEN
      LeaveGjline.INSERT(TRUE);

      //Post Journal
      LeaveGjline.RESET;
      LeaveGjline.SETRANGE("Employee No.",HRSetup."Leave Template");
      LeaveGjline.SETRANGE("Line No.",HRSetup."Leave Batch");
      IF LeaveGjline.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::Codeunit55560,LeaveGjline);
      END;
      Status:=Status::Posted;
      MODIFY;

      {END ELSE BEGIN
      ERROR('You must specify no of days');
      END;
      END;}
      //NotifyApplicant;
      END;
      }
    END;

    PROCEDURE NotifyApplicant@1000000006();
    BEGIN
      {HREmp.GET("Employee No");
      HREmp.TESTFIELD(HREmp."Statistics Group Code");

      //GET E-MAIL PARAMETERS FOR GENERAL E-MAILS
      HREmailParameters.RESET;
      HREmailParameters.SETRANGE(HREmailParameters."Associate With",HREmailParameters."Associate With"::"Interview Invitations");
      IF HREmailParameters.FIND('-') THEN
      BEGIN


           HREmp.TESTFIELD(HREmp."Statistics Group Code");
           SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."Statistics Group Code",//"Company E-Mail",
           HREmailParameters.Subject,'Dear'+' '+ HREmp.County +' '+
           HREmailParameters.Body+' '+"Application Code"+' '+ HREmailParameters."Body 2",TRUE);
           SMTP.Send();


      MESSAGE('Leave applicant has been notified successfully');
      END;
      }
    END;

    BEGIN
    END.
  }
}

