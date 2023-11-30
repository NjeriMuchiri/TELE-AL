OBJECT page 20490 Payroll Calender
{
  OBJECT-PROPERTIES
  {
    Date=07/21/17;
    Time=10:12:40 AM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516185;
    PageType=List;
    ActionList=ACTIONS
    {
      { 14      ;    ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 1000000000;1 ;Action    ;
                      Name=Close Period;
                      CaptionML=ENU=Close Period;
                      Promoted=Yes;
                      Image=ClosePeriod;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {
                                 Warn user about the consequence of closure - operation is not reversible.
                                 Ask if he is sure about the closure.
                                 }

                                 fnGetOpenPeriod;

                                 Question := 'Once a period has been closed it can NOT be opened.\It is assumed that you have PAID out salaries.\'
                                 + 'Do still want to close ['+ strPeriodName +']';

                                 //For Multiple Payroll

                                 {ContrInfo.GET();
                                 IF ContrInfo."Multiple Payroll" THEN BEGIN
                                 PayrollDefined:='';
                                 PayrollType.SETCURRENTKEY(EntryNo);
                                 IF PayrollType.FINDFIRST THEN BEGIN
                                     NoofRecords:=PayrollType.COUNT;
                                     REPEAT
                                       i+= 1;
                                       PayrollDefined:=PayrollDefined+'&'+PayrollType."Payroll Code";
                                       IF i<NoofRecords THEN
                                          PayrollDefined:=PayrollDefined+','
                                     UNTIL PayrollType.NEXT=0;
                                 END;


                                         Selection := STRMENU(PayrollDefined,3);
                                         PayrollType.RESET;
                                         PayrollType.SETRANGE(PayrollType.EntryNo,Selection);
                                         IF PayrollType.FIND('-') THEN BEGIN
                                             PayrollCode:=PayrollType."Payroll Code";
                                         END;
                                 END;
                                 //End Multiple Payroll
                                 }


                                 Answer := DIALOG.CONFIRM(Question, FALSE);
                                 IF Answer=TRUE THEN
                                 BEGIN
                                   CLEAR(objOcx);
                                   objOcx.fnClosePayrollPeriod(dtOpenPeriod,PayrollCode);
                                   MESSAGE ('Process Complete');
                                 END ELSE BEGIN
                                    MESSAGE('You have selected NOT to Close the period');
                                 END
                               END;
                                }
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
                SourceExpr="Date Opened" }

    { 4   ;2   ;Field     ;
                SourceExpr="Period Name" }

    { 5   ;2   ;Field     ;
                SourceExpr="Period Month" }

    { 6   ;2   ;Field     ;
                SourceExpr="Period Year" }

    { 7   ;2   ;Field     ;
                SourceExpr=Closed }

    { 8   ;2   ;Field     ;
                SourceExpr="Date Closed" }

    { 9   ;2   ;Field     ;
                SourceExpr="Tax Paid" }

    { 10  ;2   ;Field     ;
                SourceExpr="Tax Paid(LCY)" }

    { 11  ;2   ;Field     ;
                SourceExpr="Basic Pay Paid" }

    { 12  ;2   ;Field     ;
                SourceExpr="Basic Pay Paid(LCY)" }

    { 13  ;2   ;Field     ;
                SourceExpr="Payroll Code" }

  }
  CODE
  {
    VAR
      PayPeriod@1000000012 : Record 51516185;
      strPeriodName@1000000011 : Text[30];
      Question@1000000010 : Text[250];
      Answer@1000000009 : Boolean;
      objOcx@1000000008 : Codeunit 51516002;
      dtOpenPeriod@1000000007 : Date;
      Selection@1000000005 : Integer;
      PayrollDefined@1000000004 : Text[30];
      PayrollCode@1000000003 : Code[10];
      NoofRecords@1000000002 : Integer;
      i@1000000001 : Integer;
      ContrInfo@1000000000 : Record 51516212;
      Text000@1000000014 : TextConst 'ENU=''Leave without saving changes?''';
      Text001@1000000013 : TextConst 'ENU=''You selected %1.''';

    PROCEDURE fnGetOpenPeriod@1102755004();
    BEGIN

      //Get the open/current period
      PayPeriod.SETRANGE(PayPeriod.Closed,FALSE);
      IF PayPeriod.FIND('-') THEN BEGIN
         strPeriodName:=PayPeriod."Period Name";
         dtOpenPeriod:=PayPeriod."Date Opened";
      END;
    END;

    BEGIN
    END.
  }
}

