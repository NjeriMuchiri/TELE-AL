OBJECT page 17403 Bosa Receipt line-Checkoff
{
  OBJECT-PROPERTIES
  {
    Date=04/05/23;
    Time=[ 9:17:46 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516249;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 14  ;0   ;Container ;
                ContainerType=ContentArea }

    { 13  ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 12  ;2   ;Field     ;
                SourceExpr="Receipt Line No" }

    { 11  ;2   ;Field     ;
                SourceExpr="Trans Type" }

    { 10  ;2   ;Field     ;
                SourceExpr="Member No" }

    { 9   ;2   ;Field     ;
                SourceExpr="Staff/Payroll No" }

    { 8   ;2   ;Field     ;
                SourceExpr=Name }

    { 7   ;2   ;Field     ;
                SourceExpr="Employer Code" }

    { 6   ;2   ;Field     ;
                SourceExpr="ID No." }

    { 1120054000;2;Field  ;
                SourceExpr="Receipt Header No" }

    { 5   ;2   ;Field     ;
                SourceExpr="Loan No" }

    { 4   ;2   ;Field     ;
                SourceExpr=Amount }

    { 3   ;2   ;Field     ;
                SourceExpr="Staff Not Found" }

    { 2   ;2   ;Field     ;
                SourceExpr="Member Found" }

    { 1   ;2   ;Field     ;
                SourceExpr="Search Index" }

    { 1000000000;2;Field  ;
                SourceExpr="Transaction Type";
                Editable=FALSE }

    { 1000000002;2;Field  ;
                SourceExpr="Loan Code" }

    { 1000000003;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1000000004;2;Field  ;
                SourceExpr="Loan type Code" }

    { 1120054001;2;Field  ;
                SourceExpr="Posting Date" }

    { 1120054002;2;Field  ;
                SourceExpr="Deposit Amount" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

