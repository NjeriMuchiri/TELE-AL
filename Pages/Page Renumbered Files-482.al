OBJECT page 172077 Sky Withdrawals Buffer Page
{
  OBJECT-PROPERTIES
  {
    Date=09/24/21;
    Time=11:04:18 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516714;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054033;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=NewDocumentItems }
      { 1120054034;1 ;Action    ;
                      Name=Reverse;
                      Promoted=Yes;
                      Image=ReverseRegister;
                      OnAction=BEGIN
                                 TESTFIELD(Posted,FALSE);
                                 TESTFIELD(Reversed,FALSE);
                                 SkyPermissions.RESET;
                                 SkyPermissions.SETRANGE(SkyPermissions."User ID",USERID);
                                 SkyPermissions.SETRANGE(SkyPermissions."Reverse M Bank Transfer",TRUE);
                                 IF NOT SkyPermissions.FINDFIRST THEN ERROR('You do not have permission Reverse MBank transfer in Mbanking Permissions Table');
                                 SkyMbanking.ReverseWithdrawalRequest("Trace ID");
                                 MESSAGE('Reversed Succesifully');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="Trace ID" }

    { 1120054003;2;Field  ;
                SourceExpr="Posting Date" }

    { 1120054004;2;Field  ;
                SourceExpr="Account No" }

    { 1120054005;2;Field  ;
                SourceExpr=Description }

    { 1120054006;2;Field  ;
                SourceExpr=Amount }

    { 1120054007;2;Field  ;
                SourceExpr="Posting S" }

    { 1120054008;2;Field  ;
                SourceExpr=Posted }

    { 1120054009;2;Field  ;
                SourceExpr="Unit ID" }

    { 1120054010;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054011;2;Field  ;
                SourceExpr="Trans Time" }

    { 1120054012;2;Field  ;
                SourceExpr="Transaction Time" }

    { 1120054013;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1120054014;2;Field  ;
                SourceExpr=Source }

    { 1120054015;2;Field  ;
                SourceExpr=Reversed }

    { 1120054016;2;Field  ;
                SourceExpr="Reversed Posted" }

    { 1120054017;2;Field  ;
                SourceExpr="Reversal Trace ID" }

    { 1120054018;2;Field  ;
                SourceExpr="Transaction Description" }

    { 1120054019;2;Field  ;
                SourceExpr="Withdrawal Location" }

    { 1120054020;2;Field  ;
                SourceExpr="Entry No" }

    { 1120054021;2;Field  ;
                SourceExpr="Transaction Type Charges" }

    { 1120054022;2;Field  ;
                SourceExpr="Card Acceptor Terminal ID" }

    { 1120054023;2;Field  ;
                SourceExpr="ATM Card No" }

    { 1120054024;2;Field  ;
                SourceExpr="Customer Names" }

    { 1120054025;2;Field  ;
                SourceExpr="Process Code" }

    { 1120054026;2;Field  ;
                SourceExpr="Is Coop Bank" }

    { 1120054027;2;Field  ;
                SourceExpr="POS Vendor" }

    { 1120054028;2;Field  ;
                SourceExpr="Session ID" }

    { 1120054029;2;Field  ;
                SourceExpr=Comments }

    { 1120054030;2;Field  ;
                SourceExpr="Date Reversed" }

    { 1120054031;2;Field  ;
                SourceExpr="Reversed By" }

    { 1120054032;2;Field  ;
                SourceExpr="Withdrawal Type" }

  }
  CODE
  {
    VAR
      SkyMbanking@1120054000 : Codeunit 51516701;
      SkyPermissions@1120054001 : Record 51516702;

    BEGIN
    END.
  }
}

