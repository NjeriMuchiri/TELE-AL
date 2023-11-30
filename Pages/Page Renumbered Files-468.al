OBJECT page 172063 Sky Mobile Withdrawal Buffer
{
  OBJECT-PROPERTIES
  {
    Date=09/24/21;
    Time=10:58:20 AM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516714;
    PageType=List;
    CardPageID=Sky Withdrawals Buffer Page;
    ActionList=ACTIONS
    {
      { 1000000000;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000001;1 ;Action    ;
                      Name=Reverse Transaction;
                      OnAction=BEGIN
                                 StatusPermissions.RESET;
                                 StatusPermissions.SETRANGE("Reverse Sky Transactions",TRUE);
                                 StatusPermissions.SETRANGE("User ID",USERID);
                                 IF NOT StatusPermissions.FINDFIRST THEN
                                   ERROR('You do not have the following permission: "Reverse Sky Transactions"');

                                 TESTFIELD(Posted,FALSE);
                                 TESTFIELD(Reversed,FALSE);

                                 IF SkyMbanking.ReverseWithdrawalRequest("Trace ID") THEN
                                   MESSAGE('Reversed Successfully')
                                 ELSE
                                   MESSAGE('Not Reversed');
                               END;
                                }
      { 12      ;1   ;Action    ;
                      Name=Insert MPESA Withdrawal;
                      OnAction=BEGIN
                                 {
                                 Withdrawals.RESET;
                                 Withdrawals.SETRANGE("Trace ID","Trace ID");
                                 IF Withdrawals.FINDFIRST THEN
                                   REPORT.RUN(50060,TRUE,FALSE,Withdrawals);
                                   }
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
                SourceExpr="Trace ID" }

    { 5   ;2   ;Field     ;
                SourceExpr="Account No" }

    { 6   ;2   ;Field     ;
                SourceExpr=Description }

    { 7   ;2   ;Field     ;
                SourceExpr=Amount }

    { 1120054000;2;Field  ;
                SourceExpr="Withdrawal Type" }

    { 9   ;2   ;Field     ;
                SourceExpr="Transaction Date" }

    { 10  ;2   ;Field     ;
                SourceExpr="Transaction Time" }

    { 11  ;2   ;Field     ;
                SourceExpr=Reversed }

    { 14  ;2   ;Field     ;
                SourceExpr="Date Reversed" }

    { 15  ;2   ;Field     ;
                SourceExpr="Reversed By" }

    { 8   ;2   ;Field     ;
                SourceExpr=Posted }

    { 4   ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 13  ;2   ;Field     ;
                SourceExpr="Session ID" }

  }
  CODE
  {
    VAR
      SkyMbanking@1000000000 : Codeunit 51516701;
      StatusPermissions@1000000001 : Record 51516702;
      Withdrawals@1000 : Record 51516714;

    BEGIN
    END.
  }
}

