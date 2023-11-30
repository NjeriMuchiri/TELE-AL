OBJECT page 20472 Payroll Employee List
{
  OBJECT-PROPERTIES
  {
    Date=05/19/23;
    Time=[ 3:41:07 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516180;
    PageType=List;
    CardPageID=Payroll Employee Card;
    OnInit=BEGIN
              IF UserSetup.GET(USERID) THEN BEGIN
               IF NOT UserSetup."Payroll User" THEN
                 ERROR(PemissionDenied);
              END ELSE BEGIN
               ERROR(UserNotFound,USERID);
              END;
           END;

    OnOpenPage=BEGIN
                 IF UserSetup.GET(USERID) THEN
                 BEGIN
                 IF (UserSetup."Accounts Department"<>TRUE) AND (UserSetup."ICT Department"<>TRUE) AND (UserSetup."HR Department"<>TRUE) THEN
                 ERROR('You Dont Have Permission To View This Module.Kindly Contact the Sytem Administrator.');
                 END;
               END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 1120054000;1 ;Action    ;
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
                                    {IF "Date Of Birth"= 0D THEN
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
                                    HrEmployee.SETRANGE(HrEmployee."Payroll Code",PayrollCode);
                                     //HrEmployee.SETRANGE(HrEmployee.City,'STAFF001');
                                  IF HrEmployee.FIND('-') THEN BEGIN
                                    //Progress Window
                                    ProgressWindow.OPEN('Processing Salary for Employee No. #1#######');
                                   REPEAT
                                   //Progress Window
                                    SLEEP(100);
                                   //Progress Window
                                   //Suspended
                                   SalCard.RESET;
                                   SalCard.SETRANGE(SalCard."No.",HrEmployee."No.");
                                   SalCard.SETRANGE(SalCard."Period Filter",SelectedPeriod);
                                   SalCard.SETRANGE(SalCard."Suspend Pay",FALSE);
                                   IF SalCard.FINDFIRST THEN BEGIN
                                   //MESSAGE('hRE%1',SalCard.Firstname);
                                    ProgressWindow.UPDATE(1,HrEmployee."No."+':'+HrEmployee."First Name"+' '+HrEmployee."Middle Name"+' '+HrEmployee."Last Name");
                                   ProcessPayroll.fnProcesspayroll(HrEmployee."No.",HrEmployee."Date Of Join",SalCard."Basic Pay",SalCard."Pays PAYE"
                                       ,SalCard."Pays NSSF",SalCard."Pays NHIF",SelectedPeriod,SelectedPeriod,'','',
                                       HrEmployee."Date Of Leaving",TRUE,HrEmployee."Department Code",PayrollCode);
                                   END;
                                  UNTIL  HrEmployee.NEXT=0;
                                  ////Progress Windowf
                                  ProgressWindow.CLOSE;
                                  END;
                                 //CODEUNIT



                                 //REPORT.RUN(39005514,TRUE,FALSE,SalCard);
                                 END;
                               END;
                                }
      { 1120054001;1 ;Action    ;
                      CaptionML=ENU=Send Payslips;
                      RunObject=Report 50021;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Alerts;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr="Full Name" }

    { 7   ;2   ;Field     ;
                SourceExpr="Joining Date" }

    { 5   ;2   ;Field     ;
                Name=<Employee Status>;
                CaptionML=ENU=Employee Status;
                SourceExpr=Status }

    { 8   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 9   ;1   ;Part      ;
                PartType=System;
                SystemPartID=Outlook }

    { 10  ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

    { 11  ;1   ;Part      ;
                PartType=System;
                SystemPartID=MyNotes }

    { 12  ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      Employee@1000 : Record 51516180;
      UserSetup@1001 : Record 91;
      UserNotFound@1002 : TextConst 'ENU=User Setup %1 not found.';
      PemissionDenied@1003 : TextConst 'ENU=User Account is not Setup for Payroll Use. Contact System Administrator.';
      PayrollEmp@1012 : Record 51516180;
      ProgressWindow@1011 : Dialog;
      PayrollManager@1010 : Codeunit 51516002;
      "Payroll Period"@1009 : Date;
      PayrollMonthlyTrans@1007 : Record 51516183;
      PayrollEmployeeDed@1006 : Record 51516189;
      PayrollEmployerDed@1005 : Record 51516190;
      PayCalender@1120054019 : Record 51516185;
      ContrInfo@1120054018 : Record 51516212;
      Period@1120054017 : Date;
      objEmp@1120054016 : Record 51516160;
      SalCard@1120054015 : Record 51516180;
      objPeriod@1120054014 : Record 51516185;
      SelectedPeriod@1120054013 : Date;
      PeriodName@1120054012 : Text[30];
      PeriodMonth@1120054011 : Integer;
      PeriodYear@1120054010 : Integer;
      ProcessPayroll@1120054009 : Codeunit 51516002;
      HrEmployee@1120054008 : Record 51516160;
      prPeriodTransactions@1120054007 : Record 51516183;
      prEmployerDeductions@1120054006 : Record 51516190;
      Selection@1120054005 : Integer;
      PayrollDefined@1120054004 : Text[30];
      PayrollCode@1120054003 : Code[10];
      NoofRecords@1120054002 : Integer;
      i@1120054001 : Integer;
      PayrollCalender@1120054000 : Record 51516185;
      UserSet@1120054020 : Record 91;

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

