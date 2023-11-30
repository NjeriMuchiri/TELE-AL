OBJECT page 20484 Payroll General Setup
{
  OBJECT-PROPERTIES
  {
    Date=02/25/22;
    Time=12:38:22 PM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516219;
    PageType=Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Relief;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="Tax Relief" }

    { 4   ;2   ;Field     ;
                SourceExpr="Insurance Relief" }

    { 5   ;2   ;Field     ;
                SourceExpr="Max Relief" }

    { 6   ;2   ;Field     ;
                SourceExpr="Mortgage Relief" }

    { 1120054000;2;Field  ;
                SourceExpr="NHIF Relief" }

    { 7   ;1   ;Group     ;
                Name=NHIF;
                GroupType=Group }

    { 8   ;2   ;Field     ;
                SourceExpr="NHIF Based on" }

    { 9   ;1   ;Group     ;
                Name=NSSF;
                GroupType=Group }

    { 10  ;2   ;Field     ;
                SourceExpr="NSSF Employee" }

    { 11  ;2   ;Field     ;
                SourceExpr="NSSF Employer Factor" }

    { 12  ;2   ;Field     ;
                SourceExpr="NSSF Based on" }

    { 13  ;1   ;Group     ;
                Name=Pension;
                GroupType=Group }

    { 14  ;2   ;Field     ;
                SourceExpr="Max Pension Contribution" }

    { 15  ;2   ;Field     ;
                SourceExpr="Tax On Excess Pension" }

    { 16  ;1   ;Group     ;
                Name=Staff Loan;
                GroupType=Group }

    { 17  ;2   ;Field     ;
                SourceExpr="Loan Market Rate" }

    { 18  ;2   ;Field     ;
                SourceExpr="Loan Corporate Rate" }

    { 19  ;1   ;Group     ;
                Name=Mortgage;
                GroupType=Group }

    { 20  ;1   ;Group     ;
                Name=Owner Occupier Interest;
                GroupType=Group }

    { 21  ;2   ;Field     ;
                SourceExpr="OOI Deduction" }

    { 22  ;2   ;Field     ;
                SourceExpr="OOI December" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

