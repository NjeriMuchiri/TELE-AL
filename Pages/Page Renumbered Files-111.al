OBJECT page 20452 prHeader Salary CardXX
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=10:55:11 AM;
    Modified=Yes;
    Version List=Sacco ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    InsertAllowed=Yes;
    DeleteAllowed=No;
    SourceTable=Table51516160;
    PageType=Document;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Transactions,Payslip,Other Info;
    OnInit=BEGIN

             objPeriod.RESET;
             objPeriod.SETRANGE(objPeriod.Closed,FALSE);
             IF objPeriod.FIND('-') THEN
             BEGIN
                 SelectedPeriod:=objPeriod."Date Opened";
                 PeriodName:=objPeriod."Period Name";
                 PeriodMonth:=objPeriod."Period Month";
                 PeriodYear:=objPeriod."Period Year";
             END;
           END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102756006;1 ;ActionGroup;
                      CaptionML=ENU=Transactions }
      { 1102756008;2 ;Action    ;
                      CaptionML=ENU=Assign Transaction;
                      RunObject=page 17470;
                      RunPageLink=Employee Code=FIELD(No.);
                      Promoted=Yes;
                      Image=Setup;
                      PromotedCategory=Category4 }
      { 1102756010;2 ;Action    ;
                      CaptionML=ENU=View Trans Codes;
                      RunObject=Page 39004004;
                      Promoted=Yes;
                      Image=Apply;
                      PromotedCategory=Category4 }
      { 1102756012;2 ;Action    ;
                      CaptionML=ENU=Insurance Policies;
                      RunObject=Page 39004017;
                      RunPageLink=Field1=FIELD(No.);
                      Promoted=Yes;
                      Image=Insurance;
                      PromotedCategory=Category4 }
      { 1102756001;2 ;Action    ;
                      CaptionML=ENU=Staff Loans;
                      RunObject=Page 39004017;
                      Promoted=Yes;
                      Visible=false;
                      Image=CashFlow;
                      PromotedCategory=Category4 }
      { 1102756014;2 ;Action    ;
                      CaptionML=ENU=Basic Salary Arrears;
                      RunObject=page 20492;
                      RunPageView=SORTING(Application No,Cost Of Training,Location);
                      RunPageLink=Application No=FIELD(No.);
                      Promoted=Yes;
                      Image=TransferFunds;
                      PromotedCategory=Category4 }
      { 1102755001;2 ;Action    ;
                      Name=BOSA Statement;
                      Promoted=Yes;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(39004260,TRUE,FALSE,Cust);
                               END;
                                }
      { 1000000008;  ;ActionContainer;
                      CaptionML=ENU=Payslip;
                      ActionContainerType=ActionItems }
      { 1102755000;1 ;Action    ;
                      Name=Individual Payslip;
                      Image=View;
                      OnAction=BEGIN
                                 objPeriod.RESET;
                                 objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                                 IF objPeriod.FIND('-') THEN;
                                 SelectedPeriod:=objPeriod."Date Opened";


                                 //Display payslip report
                                 SalCard.SETRANGE("Employee Code","No.");
                                 SalCard.SETRANGE(SalCard."Period Filter",SelectedPeriod);
                                 REPORT.RUN(51516029,TRUE,FALSE,SalCard);
                               END;
                                }
      { 1000000007;1 ;Action    ;
                      Name=View 1 Page Payslip;
                      CaptionML=ENU=View 1 Page Payslip;
                      Promoted=Yes;
                      Visible=false;
                      Image=Report;
                      PromotedCategory=Category5;
                      OnAction=BEGIN

                                 objPeriod.RESET;
                                 objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                                 IF objPeriod.FIND('-') THEN;
                                 SelectedPeriod:=objPeriod."Date Opened";

                                 //CLEAR(objOcx);
                                 //objOcx.fnMandatoryProcesses;

                                 //Display payslip report
                                 SalCard.SETRANGE("Employee Code","No.");
                                 SalCard.SETRANGE(SalCard."Period Filter",SelectedPeriod);
                                 REPORT.RUN(51516029,TRUE,FALSE,SalCard);
                               END;
                                }
      { 1000000006;1 ;Action    ;
                      Name=View 2 Pages Payslip;
                      CaptionML=ENU=View 2 Pages Payslip;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Category5;
                      OnAction=BEGIN

                                 objPeriod.RESET;
                                 objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                                 IF objPeriod.FIND('-') THEN;
                                 SelectedPeriod:=objPeriod."Date Opened";

                                 //CLEAR(objOcx);
                                 //objOcx.fnMandatoryProcesses;

                                 //Display payslip report
                                 SalCard.SETRANGE("Employee Code","No.");
                                 SalCard.SETRANGE(SalCard."Period Filter",SelectedPeriod);
                                 REPORT.RUN(51516029,TRUE,FALSE,SalCard);
                               END;
                                }
      { 1000000005;1 ;Action    ;
                      Name=View3 Pages Payslip;
                      CaptionML=ENU=View3 Pages Payslip;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Category5;
                      OnAction=BEGIN

                                 objPeriod.RESET;
                                 objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                                 IF objPeriod.FIND('-') THEN;
                                 SelectedPeriod:=objPeriod."Date Opened";

                                 //CLEAR(objOcx);
                                 //objOcx.fnMandatoryProcesses;

                                 //Display payslip report
                                 SalCard.SETRANGE("Employee Code","No.");
                                 SalCard.SETRANGE(SalCard."Period Filter",SelectedPeriod);
                                 REPORT.RUN(51516029,TRUE,FALSE,SalCard);
                               END;
                                }
      { 1000000000;1 ;Action    ;
                      Name=Process Payslip;
                      CaptionML=ENU=Process Payslip;
                      Promoted=Yes;
                      Image=PostApplication;
                      PromotedCategory=Category5;
                      OnAction=BEGIN

                                 ContrInfo.GET;

                                 objPeriod.RESET;
                                 objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                                 IF objPeriod.FIND('-') THEN;
                                 SelectedPeriod:=objPeriod."Date Opened";
                                 SalCard.GET("No.");
                                 //IF SalCard."Employee Code"='5481' THEN BEGIN
                                 //For Multiple Payroll
                                 IF ContrInfo."Multiple Payroll" THEN BEGIN
                                 PayrollDefined:='';
                                 PayrollType.RESET;
                                 PayrollType.SETCURRENTKEY(EntryNo);
                                 IF PayrollType.FINDFIRST THEN BEGIN
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
                                         END;
                                 END;


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
                                     //HrEmployee.SETRANGE(HrEmployee."No.",'KPSS003');
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
                                   ProcessPayroll.fnProcesspayroll(HrEmployee."No.",HrEmployee."Date Of Joining the Company",SalCard."Basic Pay",SalCard."Pays PAYE"
                                       ,SalCard."Pays NSSF",SalCard."Pays NHIF",SelectedPeriod,SelectedPeriod,'','',
                                       HrEmployee."Date Of Leaving the Company",TRUE,HrEmployee."Department Code");
                                  END;
                                  UNTIL  HrEmployee.NEXT=0;
                                  ////Progress Window
                                  ProgressWindow.CLOSE;
                                  END;
                                 //CODEUNIT


                                 SalCard.RESET;
                                 SalCard.SETRANGE("Employee Code","No.");
                                 SalCard.SETRANGE(SalCard."Period Filter",SelectedPeriod);
                                 //REPORT.RUN(39005514,TRUE,FALSE,SalCard);
                                 //END;
                               END;
                                }
      { 1102756007;1 ;ActionGroup;
                      CaptionML=ENU=Other Info }
      { 1102756015;2 ;Action    ;
                      CaptionML=ENU=Cost Centers;
                      RunObject=Page 39004010;
                      RunPageLink=Field1=FIELD(No.);
                      Promoted=Yes;
                      Image=CostCenter;
                      PromotedCategory=Category6 }
      { 1102756017;2 ;Action    ;
                      CaptionML=ENU=Banking Details;
                      RunObject=Page 39004009;
                      RunPageLink=Field1=FIELD(No.);
                      Promoted=Yes;
                      Image=ElectronicBanking;
                      PromotedCategory=Category6 }
      { 1102756060;2 ;Action    ;
                      CaptionML=ENU=Pension Details;
                      RunObject=Page 39005527;
                      RunPageLink=Field1=FIELD(No.);
                      Promoted=Yes;
                      Visible=FALSE;
                      Enabled=FALSE;
                      PromotedCategory=Category6 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102756018;1;Group  ;
                CaptionML=ENU=Employee Details;
                Editable=true }

    { 1102756035;2;Field  ;
                SourceExpr="No.";
                Importance=Promoted }

    { 1102756019;2;Field  ;
                SourceExpr="Last Name";
                Importance=Promoted;
                Enabled=TRUE }

    { 1102756037;2;Field  ;
                SourceExpr="First Name";
                Importance=Promoted }

    { 1102756039;2;Field  ;
                SourceExpr="Middle Name";
                Importance=Promoted }

    { 1102756045;2;Field  ;
                SourceExpr="Date Of Birth";
                Importance=Promoted }

    { 1102756021;2;Field  ;
                SourceExpr="Department Code";
                Importance=Promoted }

    { 1102756067;2;Field  ;
                SourceExpr="Payment Mode";
                Importance=Promoted }

    { 1102756023;2;Field  ;
                SourceExpr="Date Of Joining the Company" }

    { 1102756025;2;Field  ;
                SourceExpr=Status }

    { 1102756005;2;Field  ;
                SourceExpr="Full / Part Time";
                Enabled=TRUE }

    { 1102756043;2;Field  ;
                SourceExpr="Contract End Date" }

    { 1102756065;2;Field  ;
                SourceExpr="Payroll Code" }

    { 1102756027;2;Field  ;
                SourceExpr="ID Number" }

    { 1102756029;2;Field  ;
                SourceExpr="NSSF No." }

    { 1102756031;2;Field  ;
                SourceExpr="NHIF No." }

    { 1000000012;2;Field  ;
                SourceExpr="PIN No." }

    { 1102756051;2;Field  ;
                SourceExpr="Main Bank";
                Importance=Promoted }

    { 1102756055;2;Field  ;
                SourceExpr="Branch Bank";
                Importance=Promoted }

    { 1102756057;2;Field  ;
                SourceExpr="Bank Account Number";
                Importance=Promoted }

    { 1904784501;1;Group  ;
                CaptionML=ENU=Posting Details;
                GroupType=Group }

    { 1000000004;2;Field  ;
                SourceExpr="Posting Group";
                Importance=Promoted;
                Editable=TRUE }

    { 1000000003;2;Field  ;
                Name=Main Bank1;
                CaptionML=ENU=Main Bank;
                SourceExpr="Main Bank";
                Importance=Promoted }

    { 1000000002;2;Field  ;
                Name=Branch Bank1;
                CaptionML=ENU=Branch Bank;
                SourceExpr="Branch Bank";
                Importance=Promoted }

    { 1000000001;2;Field  ;
                Name=Bank Account Number1;
                CaptionML=ENU=Bank Account Number;
                SourceExpr="Bank Account Number";
                Importance=Promoted }

    { 1000000009;2;Field  ;
                CaptionML=ENU=Paying Bank Code;
                SourceExpr="Sacco Paying Bank Code" }

    { 1000000010;2;Field  ;
                CaptionML=ENU=Paying Bank Name;
                SourceExpr="Sacco Paying Bank Name" }

    { 1000000011;2;Field  ;
                SourceExpr="Cheque No" }

    { 1102756041;1;Part   ;
                CaptionML=ENU=Salary Details;
                SubPageLink=Employee Code=FIELD(No.);
                PagePartID=Page51516331;
                PartType=Page }

  }
  CODE
  {
    VAR
      objEmp@1102755000 : Record 51516160;
      SalCard@1102755001 : Record 51516061;
      objPeriod@1102755008 : Record 51516112;
      SelectedPeriod@1102755011 : Date;
      PeriodName@1102755012 : Text[30];
      PeriodMonth@1102755013 : Integer;
      PeriodYear@1102755014 : Integer;
      ProcessPayroll@1102756000 : Codeunit 51516061;
      HrEmployee@1102756001 : Record 51516160;
      ProgressWindow@1102756002 : Dialog;
      prPeriodTransactions@1102756003 : Record 51516061;
      prEmployerDeductions@1102756004 : Record 51516061;
      PayrollType@1102756010 : Record 51516460;
      Selection@1102756009 : Integer;
      PayrollDefined@1102756008 : Text[30];
      PayrollCode@1102756007 : Code[10];
      NoofRecords@1102756006 : Integer;
      i@1102756005 : Integer;
      ContrInfo@1102756011 : Record 51516212;
      Cust@1102755002 : Record 51516223;

    BEGIN
    {
      strempcode,dtDOE,curbasicpay,blnpaye,blnnssf,blnnhif,selectedperio,dtopenperio,
      membership,referenceno,dttermination,blngetspayereleif
    }
    END.
  }
}

