OBJECT page 172030 Salary Processing Lines
{
  OBJECT-PROPERTIES
  {
    Date=04/05/23;
    Time=[ 8:40:20 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516317;
    DelayedInsert=No;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054029;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 1120054028;1 ;ActionGroup }
      { 1120054027;2 ;Action    ;
                      Name=Resendsms;
                      CaptionML=ENU=Resend sms;
                      Promoted=Yes;
                      Image=CheckList;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 "Email Sent":=FALSE;
                                 MODIFY;
                                 COMMIT;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="No.";
                Visible=false }

    { 1120054003;2;Field  ;
                SourceExpr="Account No." }

    { 1120054004;2;Field  ;
                SourceExpr="Staff No." }

    { 1120054011;2;Field  ;
                SourceExpr="Account Name" }

    { 1120054023;2;Field  ;
                SourceExpr="Client Code";
                Visible=false }

    { 1120054006;2;Field  ;
                SourceExpr=Amount }

    { 1120054007;2;Field  ;
                SourceExpr="Account Not Found" }

    { 1120054008;2;Field  ;
                SourceExpr="Date Filter";
                Visible=false }

    { 1120054009;2;Field  ;
                SourceExpr=Processed }

    { 1120054026;2;Field  ;
                CaptionML=ENU=Blocked Accounts;
                SourceExpr="Blocked Accounts 0" }

    { 1120054013;2;Field  ;
                SourceExpr="Original Account No.";
                Visible=false }

    { 1120054014;2;Field  ;
                SourceExpr="Multiple Salary" }

    { 1120054015;2;Field  ;
                SourceExpr=Reversed;
                Visible=false }

    { 1120054010;2;Field  ;
                SourceExpr=Type }

    { 1120054021;2;Field  ;
                SourceExpr=USER }

    { 1120054005;2;Field  ;
                SourceExpr="Delegates Allowance" }

    { 1120054012;2;Field  ;
                SourceExpr="Salary No" }

    { 1120054016;2;Field  ;
                SourceExpr="Document No." }

  }
  CODE
  {
    VAR
      CoveragePercentStyle@1120054000 : Text;

    LOCAL PROCEDURE SetStyles@5();
    BEGIN
      CoveragePercentStyle:='Strong';
      IF "Account Name" ='' THEN
         CoveragePercentStyle := 'Unfavorable';
      IF "Account Name" <>'' THEN
          CoveragePercentStyle := 'Favorable';
    END;

    BEGIN
    END.
  }
}

