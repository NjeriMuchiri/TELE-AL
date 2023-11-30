OBJECT page 20486 Payroll Employee Assignments
{
  OBJECT-PROPERTIES
  {
    Date=10/26/15;
    Time=[ 9:48:42 AM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516180;
    PageType=Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr=Surname;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr=Firstname;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr=Lastname;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="Pays PAYE" }

    { 8   ;2   ;Field     ;
                SourceExpr="Pays NSSF" }

    { 9   ;2   ;Field     ;
                SourceExpr="Pays NHIF" }

    { 13  ;2   ;Field     ;
                SourceExpr=Secondary }

    { 15  ;1   ;Group     ;
                Name=Numbers;
                GroupType=Group }

    { 21  ;2   ;Field     ;
                SourceExpr="National ID No" }

    { 16  ;2   ;Field     ;
                SourceExpr="PIN No" }

    { 17  ;2   ;Field     ;
                SourceExpr="NHIF No" }

    { 18  ;2   ;Field     ;
                SourceExpr="NSSF No" }

    { 10  ;1   ;Group     ;
                Name=PAYE Relief and Benefit;
                GroupType=Group }

    { 11  ;2   ;Field     ;
                SourceExpr=GetsPayeRelief }

    { 12  ;2   ;Field     ;
                SourceExpr=GetsPayeBenefit }

    { 14  ;2   ;Field     ;
                SourceExpr=PayeBenefitPercent }

    { 19  ;1   ;Group     ;
                Name=Employee Company;
                GroupType=Group }

    { 20  ;2   ;Field     ;
                SourceExpr=Company }

  }
  CODE
  {

    BEGIN
    END.
  }
}

