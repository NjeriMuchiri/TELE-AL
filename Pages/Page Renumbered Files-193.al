OBJECT page 17384 Loan Appraisal Salary Details
{
  OBJECT-PROPERTIES
  {
    Date=09/09/20;
    Time=[ 1:55:09 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516232;
    PageType=ListPart;
    OnOpenPage=BEGIN
                 //**Prevent modification of approved entries
                 LoanApps.RESET;
                 LoanApps.SETRANGE(LoanApps."Loan  No.","Loan No");
                 IF LoanApps.FIND('-') THEN BEGIN
                  IF LoanApps."Approval Status"=LoanApps."Approval Status"::Approved THEN BEGIN
                   CurrPage.EDITABLE:=FALSE;
                  END ELSE
                   CurrPage.EDITABLE:=TRUE;
                 END;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1000000001;2;Field  ;
                SourceExpr="Appraisal Type" }

    { 1102755002;2;Field  ;
                SourceExpr=Code }

    { 1102755004;2;Field  ;
                SourceExpr=Description }

    { 1102755006;2;Field  ;
                SourceExpr=Type }

    { 1102755008;2;Field  ;
                SourceExpr=Amount }

    { 1000000000;2;Field  ;
                SourceExpr=Basic }

  }
  CODE
  {
    VAR
      LoanApps@1102755000 : Record 51516230;

    BEGIN
    END.
  }
}

