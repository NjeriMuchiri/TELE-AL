OBJECT page 20499 HR Shortlisting Lines
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=12:02:59 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Shorlisted Candidates;
    SourceTable=Table51516208;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1000000019;2;Field  ;
                CaptionML=ENU=Qualified;
                SourceExpr=Qualified;
                OnValidate=BEGIN
                             "Manual Change":=TRUE;
                             MODIFY;
                           END;
                            }

    { 1102755002;2;Field  ;
                SourceExpr="Job Application No" }

    { 1000000003;2;Field  ;
                SourceExpr="First Name" }

    { 1000000005;2;Field  ;
                SourceExpr="Middle Name" }

    { 1000000007;2;Field  ;
                SourceExpr="Last Name" }

    { 1000000009;2;Field  ;
                SourceExpr="ID No" }

    { 1000000015;2;Field  ;
                SourceExpr="Stage Score" }

    { 1000000023;2;Field  ;
                SourceExpr=Position }

    { 1000000021;2;Field  ;
                CaptionML=ENU=Employed;
                SourceExpr=Employ }

    { 1000000025;2;Field  ;
                SourceExpr="Reporting Date" }

    { 1000000017;2;Field  ;
                CaptionML=ENU=Manual Change;
                SourceExpr="Manual Change" }

  }
  CODE
  {
    VAR
      MyCount@1000000000 : Integer;

    PROCEDURE GetApplicantNo@1000000000() AppicantNo : Code[20];
    BEGIN
      //AppicantNo:=Applicant;
    END;

    BEGIN
    END.
  }
}

