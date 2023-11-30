OBJECT page 20473 Payroll Employee Card
{
  OBJECT-PROPERTIES
  {
    Date=05/26/22;
    Time=[ 3:22:19 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516180;
    PageType=Card;
    OnInit=BEGIN
              IF UserSetup.GET(USERID) THEN BEGIN
               IF NOT UserSetup."Payroll User" THEN
                 ERROR(PemissionDenied);
              END ELSE BEGIN
               ERROR(UserNotFound,USERID);
              END;
           END;

    ActionList=ACTIONS
    {
      { 69      ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 1000000007;1 ;Action    ;
                      Name=Process Payroll;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Allocations;
                      OnAction=BEGIN

                                    {PayrollCalender.RESET;
                                    PayrollCalender.SETRANGE(PayrollCalender.Closed,FALSE);
                                    IF PayrollCalender.FINDFIRST THEN BEGIN
                                      "Payroll Period":=PayrollCalender."Date Opened";
                                    END;
                                    IF "Payroll Period"=0D THEN
                                     ERROR('No Open Payroll Period');

                                    PayrollEmp.RESET;
                                    PayrollEmp.SETRANGE(PayrollEmp.Status,PayrollEmp.Status::Active);
                                    PayrollEmp.SETRANGE(PayrollEmp."Suspend Pay",FALSE);
                                    IF PayrollEmp.FINDSET(TRUE,FALSE) THEN BEGIN
                                     ProgressWindow.OPEN('Processing Salary for Employee No. #1#######');
                                     REPEAT
                                       PayrollEmp.TESTFIELD(PayrollEmp."Posting Group");
                                       PayrollEmp.TESTFIELD(PayrollEmp."Joining Date");
                                       PayrollEmp.TESTFIELD(PayrollEmp."Basic Pay");
                                       //PayrollEmp.TESTFIELD(PayrollEmp."PIN No");
                                       //PayrollEmp.TESTFIELD(PayrollEmp."NHIF No");
                                       //PayrollEmp.TESTFIELD(PayrollEmp."NSSF No");

                                       //First Remove Any transactions for this Month
                                       RemoveTrans(PayrollEmp."No.","Payroll Period");
                                       //End Remove Transactions
                                       IF PayrollEmp."Joining Date"<>0D THEN BEGIN
                                       PayrollManager.fnProcesspayroll(PayrollEmp."No.","Payroll Period",FORMAT(PayrollEmp."Posting Group"),PayrollEmp."Basic Pay",PayrollEmp."Basic Pay(LCY)",
                                                                     PayrollEmp."Currency Code",PayrollEmp."Currency Factor",PayrollEmp."Joining Date",PayrollEmp."Date of Leaving",
                                                                     FALSE,PayrollEmp."Global Dimension 1",PayrollEmp."Global Dimension 2",'',PayrollEmp."Pays PAYE",PayrollEmp."Pays NHIF",
                                                                     PayrollEmp."Pays NSSF",PayrollEmp.GetsPayeRelief,PayrollEmp.GetsPayeBenefit,PayrollEmp.Secondary,PayrollEmp.PayeBenefitPercent);
                                       ProgressWindow.UPDATE(1,PayrollEmp."No."+':'+PayrollEmp."Full Name");
                                       PayrollEmp."Period Filter":="Payroll Period";
                                       PayrollEmp.MODIFY;
                                       END;
                                     UNTIL PayrollEmp.NEXT=0;
                                    END;
                                    ProgressWindow.CLOSE;
                                    MESSAGE('Payroll processing completed successfully.');
                                    }
                                    ContrInfo.GET;

                                 objPeriod.RESET;
                                 objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                                 IF objPeriod.FIND('-') THEN;
                                 SelectedPeriod:=objPeriod."Date Opened";
                                 SalCard.GET("No.");

                                 //For Multiple Payroll
                                 IF ContrInfo."Multiple Payroll" THEN BEGIN
                                 {PayrollDefined:='';
                                 //PayrollType.RESET;
                                 //PayrollType.SETCURRENTKEY(EntryNo);
                                 //IF PayrollType.FINDFIRST THEN BEGIN
                                     NoofRecords:=PayrollType.COUNT;
                                     i:=0;
                                     REPEAT
                                       i+= 1;
                                       PayrollDefined:=PayrollDefined+'&'+PayrollType."Payroll Code";
                                       IF i<NoofRecords THEN
                                          PayrollDefined:=PayrollDefined+','
                                     UNTIL PayrollType.NEXT=0;
                                 END;


                                         Selection := STRMENU(PayrollDefined,NoofRecords);
                                         PayrollType.RESET;
                                         PayrollType.SETRANGE(PayrollType.EntryNo,Selection);
                                         IF PayrollType.FIND('-') THEN BEGIN
                                             PayrollCode:=PayrollType."Payroll Code";
                                         END;}
                                 END;
                                 //End Multiple Payroll

                                   TESTFIELD("Basic Pay");
                                    {TESTFIELD("PIN No");
                                    TESTFIELD("NHIF No");
                                    TESTFIELD("NSSF No");}

                                    PayrollCalender.RESET;
                                    PayrollCalender.SETRANGE(PayrollCalender.Closed,FALSE);
                                    IF PayrollCalender.FINDFIRST THEN BEGIN
                                      "Payroll Period":=PayrollCalender."Date Opened";
                                    END;
                                    IF "Payroll Period"=0D THEN
                                     ERROR('No Open Payroll Period');
                                   { IF "Date Of Birth"= 0D THEN
                                     ERROR('Kindly fill in the Date of Birth of member %1' ,"No.");}

                                    PayrollEmp.RESET;
                                    PayrollEmp.SETRANGE(PayrollEmp.Status,PayrollEmp.Status::Active);
                                    //PayrollEmp.SETRANGE(PayrollEmp."No.","No.");
                                    PayrollEmp.SETRANGE(PayrollEmp."Suspend Pay" ,FALSE);
                                    IF PayrollEmp.FINDFIRST THEN BEGIN
                                     ProgressWindow.OPEN('Processing Salary for Employee No. #1#######');
                                     //First Remove Any transactions for this Month
                                     RemoveTrans(PayrollEmp."No.","Payroll Period");
                                     //End Remove Transactions

                                 //Delete all Records from the prPeriod Transactions for Reprocessing
                                 prPeriodTransactions.RESET;
                                 //prPeriodTransactions.SETRANGE(prPeriodTransactions."Employee Code",strEmpCode);
                                 IF ContrInfo."Multiple Payroll" THEN
                                   prPeriodTransactions.SETRANGE(prPeriodTransactions."Payroll Code",PayrollCode);
                                 prPeriodTransactions.SETRANGE(prPeriodTransactions."Payroll Period",SelectedPeriod);
                                 IF prPeriodTransactions.FIND('-') THEN
                                    prPeriodTransactions.DELETEALL;

                                 //Delete all Records from prEmployer Deductions
                                 prEmployerDeductions.RESET;
                                 //prEmployerDeductions.SETRANGE(prEmployerDeductions."Employee Code",strEmpCode);
                                 IF ContrInfo."Multiple Payroll" THEN
                                   prEmployerDeductions.SETRANGE(prEmployerDeductions."Payroll Code",PayrollCode);

                                 prEmployerDeductions.SETRANGE(prEmployerDeductions."Payroll Period",SelectedPeriod);
                                 IF prEmployerDeductions.FIND('-') THEN
                                    prEmployerDeductions.DELETEALL;

                                 //Use CODEUNIT
                                  HrEmployee.RESET;
                                  HrEmployee.SETRANGE(HrEmployee.Status,HrEmployee.Status::Active);
                                  IF ContrInfo."Multiple Payroll" THEN
                                    //HrEmployee.SETRANGE(HrEmployee."Payroll Code",PayrollCode);
                                    HrEmployee.SETRANGE(HrEmployee."No.",'STAFF001');
                                  IF HrEmployee.FIND('-') THEN BEGIN
                                    //Progress Window
                                    ProgressWindow.OPEN('Processing Salary for Employee No. #1#######');
                                   REPEAT
                                   //Progress Window
                                    SLEEP(100);
                                   //Progress Window
                                   //Suspended
                                   IF NOT SalCard."Suspend Pay" THEN BEGIN
                                    ProgressWindow.UPDATE(1,HrEmployee."No."+':'+HrEmployee."First Name"+' '+HrEmployee."Middle Name"+' '+HrEmployee."Last Name");
                                   IF SalCard.GET(HrEmployee."No.") THEN
                                   ProcessPayroll.fnProcesspayroll(HrEmployee."No.",HrEmployee."Date Of Join",SalCard."Basic Pay",SalCard."Pays PAYE"
                                       ,SalCard."Pays NSSF",SalCard."Pays NHIF",SelectedPeriod,SelectedPeriod,'','',
                                       HrEmployee."Date Of Leaving",TRUE,HrEmployee."Department Code",PayrollCode);
                                   END;
                                  UNTIL  HrEmployee.NEXT=0;
                                  ////Progress Window
                                  ProgressWindow.CLOSE;
                                  END;
                                 //CODEUNIT


                                 SalCard.RESET;
                                 SalCard.SETRANGE("No.","No.");
                                 SalCard.SETRANGE(SalCard."Period Filter",SelectedPeriod);
                                 //REPORT.RUN(39005514,TRUE,FALSE,SalCard);
                                 END;
                               END;
                                }
      { 1000000008;1 ;Action    ;
                      Name=Employee Earnings;
                      RunObject=page 20474;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AllLines;
                      PromotedCategory=Process }
      { 73      ;1   ;Action    ;
                      Name=Employee Deductions;
                      RunObject=page 20475;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EntriesList;
                      PromotedCategory=Process }
      { 74      ;1   ;Action    ;
                      Name=Employee Assignments;
                      RunObject=page 20486;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Apply;
                      PromotedCategory=Category4 }
      { 75      ;1   ;Action    ;
                      Name=Employee Cummulatives;
                      RunObject=page 20487;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=History;
                      PromotedCategory=Category4 }
      { 28      ;1   ;Action    ;
                      Name=View PaySlip 2;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=PaymentHistory;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                  PayrollEmp.RESET;
                                  PayrollEmp.SETRANGE(PayrollEmp."No.","No.");
                                  IF PayrollEmp.FINDFIRST THEN BEGIN
                                     REPORT.RUN(REPORT::"Payroll Payslip",TRUE,FALSE,PayrollEmp);
                                  END;
                               END;
                                }
      { 1000000000;1 ;Action    ;
                      Name=[View PaySlip ];
                      CaptionML=ENU="View PaySlip ";
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PaymentHistory;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 PayCalender.RESET;
                                 PayCalender.SETRANGE(PayCalender.Closed,FALSE);
                                 IF PayCalender.FIND('-') THEN
                                 Period:=PayCalender."Date Opened";
                                 //MESSAGE(FORMAT(Period));

                                  PayrollEmp.RESET;
                                  PayrollEmp.SETRANGE(PayrollEmp."No.","No.");
                                  PayrollEmp.SETRANGE(PayrollEmp."Period Filter",Period);
                                  IF "Date Of Birth"= 0D THEN
                                     ERROR('Kindly fill in the Date of Birth of member %1 to view payslip.',"No.")
                                  ELSE
                                  REPORT.RUN(51516482,TRUE,FALSE,PayrollEmp);
                                  //IF PayrollEmp.FIND('-') THEN BEGIN
                                     //REPORT.RUN(51516482,TRUE,FALSE,PayrollEmp);
                                  //END;

                               END;
                                }
    }
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
                SourceExpr=Surname }

    { 5   ;2   ;Field     ;
                SourceExpr=Firstname }

    { 6   ;2   ;Field     ;
                SourceExpr=Lastname }

    { 29  ;2   ;Field     ;
                SourceExpr=Photo }

    { 1120054000;2;Field  ;
                SourceExpr="Employee Email" }

    { 7   ;2   ;Field     ;
                SourceExpr="Joining Date" }

    { 8   ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 9   ;2   ;Field     ;
                SourceExpr="Global Dimension 1" }

    { 10  ;2   ;Field     ;
                SourceExpr="Global Dimension 2" }

    { 11  ;2   ;Field     ;
                SourceExpr="Posting Group" }

    { 12  ;2   ;Field     ;
                SourceExpr="Payment Mode" }

    { 71  ;2   ;Field     ;
                SourceExpr=Status }

    { 1000000001;2;Field  ;
                SourceExpr="NSSF No" }

    { 1000000002;2;Field  ;
                SourceExpr="NHIF No" }

    { 1000000003;2;Field  ;
                SourceExpr="PIN No" }

    { 1000000010;2;Field  ;
                SourceExpr="Date Of Birth" }

    { 1000000009;2;Field  ;
                SourceExpr="Period Filter" }

    { 30  ;2   ;Field     ;
                SourceExpr=Company }

    { 13  ;1   ;Group     ;
                Name=Pay Details;
                GroupType=Group }

    { 14  ;2   ;Field     ;
                SourceExpr="Basic Pay" }

    { 15  ;2   ;Field     ;
                SourceExpr="Basic Pay(LCY)" }

    { 16  ;2   ;Field     ;
                SourceExpr="Non Taxable" }

    { 17  ;2   ;Field     ;
                SourceExpr="Non Taxable(LCY)" }

    { 18  ;2   ;Field     ;
                SourceExpr="Suspend Pay" }

    { 19  ;2   ;Field     ;
                SourceExpr="Suspend Date" }

    { 20  ;2   ;Field     ;
                SourceExpr="Suspend Reason" }

    { 1000000004;2;Field  ;
                SourceExpr="Pays PAYE" }

    { 1000000005;2;Field  ;
                SourceExpr="Pays NSSF" }

    { 1000000006;2;Field  ;
                SourceExpr="Pays NHIF" }

    { 21  ;2   ;Field     ;
                SourceExpr="Hourly Rate" }

    { 22  ;2   ;Field     ;
                SourceExpr=Gratuity }

    { 23  ;2   ;Field     ;
                SourceExpr="Gratuity Percentage" }

    { 24  ;2   ;Field     ;
                SourceExpr="Gratuity Provision" }

    { 25  ;2   ;Field     ;
                SourceExpr="Gratuity Provision(LCY)" }

    { 26  ;2   ;Field     ;
                SourceExpr="Days Absent" }

    { 27  ;2   ;Field     ;
                SourceExpr="Paid per Hour" }

    { 32  ;1   ;Group     ;
                Name=Bank Details;
                GroupType=Group }

    { 33  ;2   ;Field     ;
                SourceExpr="Bank Code" }

    { 34  ;2   ;Field     ;
                SourceExpr="Bank Name" }

    { 35  ;2   ;Field     ;
                SourceExpr="Branch Code" }

    { 36  ;2   ;Field     ;
                SourceExpr="Branch Name" }

    { 37  ;2   ;Field     ;
                SourceExpr="Bank Account No" }

    { 65  ;1   ;Group     ;
                Name=Other Details;
                GroupType=Group }

    { 66  ;2   ;Field     ;
                SourceExpr="Payslip Message" }

  }
  CODE
  {
    VAR
      PayrollEmp@1000 : Record 51516180;
      ProgressWindow@1001 : Dialog;
      PayrollManager@1002 : Codeunit 51516002;
      "Payroll Period"@1003 : Date;
      PayrollMonthlyTrans@1005 : Record 51516183;
      PayrollEmployeeDed@1006 : Record 51516189;
      PayrollEmployerDed@1007 : Record 51516190;
      UserSetup@1008 : Record 91;
      UserNotFound@1010 : TextConst 'ENU=User Setup %1 not found.';
      PemissionDenied@1009 : TextConst 'ENU=User Account is not Setup for Payroll Use. Contact System Administrator.';
      PayCalender@1000000000 : Record 51516185;
      ContrInfo@1000000002 : Record 51516212;
      Period@1000000020 : Date;
      objEmp@1000000019 : Record 51516160;
      SalCard@1000000018 : Record 51516180;
      objPeriod@1000000017 : Record 51516185;
      SelectedPeriod@1000000016 : Date;
      PeriodName@1000000015 : Text[30];
      PeriodMonth@1000000014 : Integer;
      PeriodYear@1000000013 : Integer;
      ProcessPayroll@1000000012 : Codeunit 51516002;
      HrEmployee@1000000011 : Record 51516160;
      prPeriodTransactions@1000000010 : Record 51516183;
      prEmployerDeductions@1000000009 : Record 51516190;
      Selection@1000000008 : Integer;
      PayrollDefined@1000000007 : Text[30];
      PayrollCode@1000000006 : Code[10];
      NoofRecords@1000000005 : Integer;
      i@1000000004 : Integer;
      PayrollCalender@1000000001 : Record 51516185;

    LOCAL PROCEDURE RemoveTrans@2(EmpNo@1000 : Code[20];PayrollPeriod@1001 : Date);
    BEGIN
        //Remove Monthly Transactions
        PayrollMonthlyTrans.RESET;
        PayrollMonthlyTrans.SETRANGE(PayrollMonthlyTrans."No.",EmpNo);
        PayrollMonthlyTrans.SETRANGE(PayrollMonthlyTrans."Period Month",DATE2DMY(PayrollPeriod,2));
        PayrollMonthlyTrans.SETRANGE(PayrollMonthlyTrans."Period Year",DATE2DMY(PayrollPeriod,3));
        IF PayrollMonthlyTrans.FINDSET THEN
          PayrollMonthlyTrans.DELETEALL;

        //Remove Employee Deductions
        //Remove Employer Deductions
    END;

    BEGIN
    END.
  }
}

