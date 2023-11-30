OBJECT page 20449 HR Employees Factbox
{
  OBJECT-PROPERTIES
  {
    Date=02/09/21;
    Time=12:06:56 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516160;
    PageType=CardPart;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755012;1;Field  ;
                SourceExpr=PersonalDetails;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755002;1;Field  ;
                SourceExpr="No." }

    { 1102755003;1;Field  ;
                SourceExpr="First Name" }

    { 1102755004;1;Field  ;
                SourceExpr="Middle Name" }

    { 1102755005;1;Field  ;
                SourceExpr="Last Name" }

    { 1102755008;1;Field  ;
                SourceExpr="E-Mail" }

    { 1000000000;1;Field  ;
                SourceExpr="Company E-Mail" }

    { 1102755011;1;Field  ;
                SourceExpr=Status }

    { 1102755017;1;Field  ;
                SourceExpr=JobDetails;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755018;1;Field  ;
                SourceExpr="Job Title" }

    { 1102755021;1;Field  ;
                SourceExpr=Grade }

    { 1102755020;1;Field  ;
                SourceExpr=LeaveDetails;
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 7   ;1   ;Field     ;
                SourceExpr="Annual Leave Account" }

    { 6   ;1   ;Field     ;
                SourceExpr="Compassionate Leave Acc." }

    { 5   ;1   ;Field     ;
                SourceExpr="Maternity Leave Acc." }

    { 4   ;1   ;Field     ;
                SourceExpr="Paternity Leave Acc." }

    { 3   ;1   ;Field     ;
                SourceExpr="Sick Leave Acc." }

    { 2   ;1   ;Field     ;
                SourceExpr="Study Leave Acc" }

  }
  CODE
  {
    VAR
      PersonalDetails@1102755000 : TextConst 'ENU=Personal Details';
      BankDetails@1102755001 : TextConst 'ENU=Bank Details';
      JobDetails@1102755002 : TextConst 'ENU=Job Details';
      LeaveDetails@1102755003 : TextConst 'ENU=Leave Details';

    BEGIN
    END.
  }
}

