OBJECT page 20376 Coop ATM Transactions
{
  OBJECT-PROPERTIES
  {
    Date=09/07/21;
    Time=10:15:41 AM;
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table170041;
    PageType=List;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Transaction ID" }

    { 1120054008;2;Field  ;
                SourceExpr="Document No." }

    { 1120054003;2;Field  ;
                SourceExpr="Service Name" }

    { 1120054004;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1120054005;2;Field  ;
                SourceExpr="Transaction Time" }

    { 1120054009;2;Field  ;
                SourceExpr="Member Account" }

    { 1120054010;2;Field  ;
                SourceExpr=Name }

    { 1120054011;2;Field  ;
                SourceExpr="PF No." }

    { 1120054012;2;Field  ;
                SourceExpr="ATM No." }

    { 1120054013;2;Field  ;
                SourceExpr=Location }

    { 1120054016;2;Field  ;
                SourceExpr="Description 1" }

    { 1120054006;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054007;2;Field  ;
                SourceExpr="Transaction Name" }

    { 1120054017;2;Field  ;
                SourceExpr=Activity }

    { 1120054018;2;Field  ;
                SourceExpr=Amount }

    { 1120054019;2;Field  ;
                SourceExpr=Posted }

    { 1120054020;2;Field  ;
                SourceExpr="Date Posted" }

    { 1120054021;2;Field  ;
                SourceExpr="Time Posted" }

    { 1120054022;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054023;2;Field  ;
                SourceExpr=Reversed }

    { 1120054024;2;Field  ;
                SourceExpr="Date Reversed" }

    { 1120054025;2;Field  ;
                SourceExpr="Time Reversed" }

    { 1120054026;2;Field  ;
                SourceExpr="Reversed By" }

    { 1120054027;2;Field  ;
                SourceExpr="Reversal ID" }

    { 1120054030;2;Field  ;
                SourceExpr="Description 2" }

    { 1120054031;2;Field  ;
                SourceExpr="Original Transaction ID" }

    { 1120054035;2;Field  ;
                SourceExpr="Channel Code" }

    { 1120054036;2;Field  ;
                SourceExpr="Terminal Code" }

    { 1120054037;2;Field  ;
                SourceExpr="Total Account Debit" }

    { 1120054038;2;Field  ;
                SourceExpr="Total Charges" }

    { 1120054039;2;Field  ;
                SourceExpr="Coop Fee" }

    { 1120054040;2;Field  ;
                SourceExpr="Sacco Fee" }

    { 1120054041;2;Field  ;
                SourceExpr="Sacco Excise Duty" }

    { 1120054042;2;Field  ;
                SourceExpr=Skipped }

    { 1120054043;2;Field  ;
                SourceExpr=Remarks }

    { 1120054014;2;Field  ;
                Name=Account Balance;
                SourceExpr=CoopProcessing.GetAccountBalance("Member Account",TODAY) }

  }
  CODE
  {
    VAR
      CoopProcessing@1120054000 : Codeunit 2000008;

    BEGIN
    END.
  }
}

