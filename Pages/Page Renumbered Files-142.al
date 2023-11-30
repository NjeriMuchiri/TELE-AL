OBJECT page 20483 Payroll Posting Group
{
  OBJECT-PROPERTIES
  {
    Date=08/24/23;
    Time=10:41:18 AM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516187;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Posting Code" }

    { 4   ;2   ;Field     ;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                SourceExpr="Salary Account" }

    { 6   ;2   ;Field     ;
                SourceExpr="Income Tax Account" }

    { 7   ;2   ;Field     ;
                SourceExpr="SSF Employer Account" }

    { 8   ;2   ;Field     ;
                SourceExpr="SSF Employee Account" }

    { 1120054000;2;Field  ;
                SourceExpr="Housing Levy Employer Acc" }

    { 1120054001;2;Field  ;
                SourceExpr="Housing Levy Employee Acc" }

    { 9   ;2   ;Field     ;
                SourceExpr="Net Salary Payable" }

    { 10  ;2   ;Field     ;
                SourceExpr="Operating Overtime" }

    { 11  ;2   ;Field     ;
                SourceExpr="Tax Relief" }

    { 12  ;2   ;Field     ;
                SourceExpr="Employee Provident Fund Acc." }

    { 13  ;2   ;Field     ;
                SourceExpr="Pay Period Filter" }

    { 14  ;2   ;Field     ;
                SourceExpr="Pension Employer Acc" }

    { 15  ;2   ;Field     ;
                SourceExpr="Pension Employee Acc" }

    { 16  ;2   ;Field     ;
                SourceExpr="Earnings and deductions" }

    { 17  ;2   ;Field     ;
                SourceExpr="Staff Benevolent" }

    { 18  ;2   ;Field     ;
                SourceExpr=SalaryExpenseAC }

    { 19  ;2   ;Field     ;
                SourceExpr="Directors Fee GL" }

    { 20  ;2   ;Field     ;
                SourceExpr="Staff Gratuity" }

    { 21  ;2   ;Field     ;
                SourceExpr="NHIF Employee Account" }

    { 22  ;2   ;Field     ;
                SourceExpr="Payroll Code" }

    { 23  ;2   ;Field     ;
                SourceExpr="Upload to Payroll" }

    { 24  ;2   ;Field     ;
                SourceExpr="PAYE Benefit A/C" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

