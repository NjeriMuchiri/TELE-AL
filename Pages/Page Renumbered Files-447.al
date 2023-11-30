OBJECT page 172042 Loans Guarantee DetailsN
{
  OBJECT-PROPERTIES
  {
    Date=09/08/20;
    Time=12:55:37 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516231;
    PageType=ListPart;
    RefreshOnActivate=No;
    OnOpenPage=BEGIN
                 {//**Prevent modification of approved entries
                 LoanApps.RESET;
                 LoanApps.SETRANGE(LoanApps."Loan  No.","Loan No");
                 IF LoanApps.FIND('-') THEN BEGIN
                  IF LoanApps."Loan Status"=LoanApps."Loan Status"::Approved THEN BEGIN
                   CurrPage.EDITABLE:=FALSE;
                  END ELSE
                   CurrPage.EDITABLE:=TRUE;
                 END;
                 }
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102755003;2;Field  ;
                SourceExpr="Loan No" }

    { 1102755008;2;Field  ;
                SourceExpr="ID No." }

    { 1102760001;2;Field  ;
                SourceExpr="Member No";
                OnValidate=BEGIN
                             //check withdrawal case
                             IF Cust.GET("Member No") THEN BEGIN
                             IF Cust.Status=Cust.Status::"Awaiting Withdrawal" THEN
                             ERROR('Member %1 is awaiting withdrawal and therefore not eligible to guarantee a loan',"Member No");
                             END;
                             //end check withdrawal case
                           END;
                            }

    { 1102760003;2;Field  ;
                SourceExpr=Name }

    { 1000000002;2;Field  ;
                SourceExpr="No Of Loans Guaranteed" }

    { 1102760013;2;Field  ;
                CaptionML=ENU=Status;
                SourceExpr=CStatus;
                Editable=FALSE }

    { 1102755006;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1102760005;2;Field  ;
                SourceExpr="Loan Balance";
                Visible=TRUE }

    { 1102760007;2;Field  ;
                SourceExpr=Shares;
                Visible=true }

    { 1102755002;2;Field  ;
                SourceExpr="Self Guarantee" }

    { 1102760009;2;Field  ;
                SourceExpr=Substituted;
                OnValidate=BEGIN
                             {IF Substituted=TRUE THEN BEGIN
                             ERROR('You Can no Unsubstitute a Substituted Guarantor');
                             END;
                             IF Substituted=FALSE THEN BEGIN
                             Date:=TODAY;
                             TESTFIELD("Substituted Guarantor");
                             END;  }
                             {
                             StatusPermissions.RESET;
                             StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
                             StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::);
                             IF StatusPermissions.FIND('-') = FALSE THEN
                             ERROR('You do not have permissions to Reschedule Loans.');
                                }
                           END;
                            }

    { 1102756000;2;Field  ;
                SourceExpr=Date;
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr="Amont Guaranteed" }

    { 1102755000;2;Field  ;
                SourceExpr="Employer Code" }

    { 1102755001;2;Field  ;
                SourceExpr="Employer Name" }

    { 1102755004;2;Field  ;
                SourceExpr="Substituted Guarantor" }

    { 1102755005;2;Field  ;
                SourceExpr="Loanees  No" }

    { 1102755007;2;Field  ;
                SourceExpr="Loanees  Name" }

  }
  CODE
  {
    VAR
      Cust@1102760000 : Record 51516223;
      EmployeeCode@1102760002 : Code[20];
      CStatus@1102760001 : 'Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,New (Pending Confirmation),Defaulter Recovery';
      LoanApps@1102755000 : Record 51516230;
      StatusPermissions@1102755001 : Record 51516310;

    BEGIN
    END.
  }
}

