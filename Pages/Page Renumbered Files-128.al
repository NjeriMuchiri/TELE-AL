OBJECT page 20469 HR Job Applications Factbox
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 1:09:04 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516209;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755006;1;Field  ;
                SourceExpr=GeneralInfo;
                Style=Strong;
                StyleExpr=TRUE }

    { 1102755002;1;Field  ;
                SourceExpr="Application No" }

    { 1102755005;1;Field  ;
                SourceExpr="Date Applied" }

    { 1102755003;1;Field  ;
                SourceExpr="First Name" }

    { 1102755004;1;Field  ;
                SourceExpr="Middle Name" }

    { 1102755001;1;Field  ;
                SourceExpr="Last Name" }

    { 1102755007;1;Field  ;
                SourceExpr=Qualified }

    { 1102755008;1;Field  ;
                SourceExpr="Interview Invitation Sent" }

    { 1102755010;1;Field  ;
                SourceExpr="ID Number" }

    { 1102755011;1;Field  ;
                SourceExpr=PersonalInfo;
                Style=Strong;
                StyleExpr=TRUE }

    { 1102755012;1;Field  ;
                SourceExpr=Status }

    { 1102755015;1;Field  ;
                SourceExpr=Age }

    { 1102755013;1;Field  ;
                SourceExpr="Marital Status" }

    { 1102755016;1;Field  ;
                SourceExpr=CommunicationInfo;
                Style=Strong;
                StyleExpr=TRUE }

    { 1102755018;1;Field  ;
                ExtendedDatatype=Phone No.;
                SourceExpr="Cell Phone Number" }

    { 1102755020;1;Field  ;
                ExtendedDatatype=E-Mail;
                SourceExpr="E-Mail" }

    { 1102755019;1;Field  ;
                ExtendedDatatype=Phone No.;
                SourceExpr="Work Phone Number" }

  }
  CODE
  {
    VAR
      GeneralInfo@1102755000 : TextConst 'ENU=General Applicant Information';
      PersonalInfo@1102755001 : TextConst 'ENU=Personal Infomation';
      CommunicationInfo@1102755002 : TextConst 'ENU=Communication Information';

    BEGIN
    END.
  }
}

