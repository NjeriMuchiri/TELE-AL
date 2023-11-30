OBJECT page 172046 Postal Corp List
{
  OBJECT-PROPERTIES
  {
    Date=08/01/23;
    Time=[ 3:22:22 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516457;
    DelayedInsert=No;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054009;  ;ActionContainer;
                      CaptionML=ENU=Action;
                      ActionContainerType=NewDocumentItems }
      { 1120054010;1 ;Action    ;
                      Name=Import Postal Corp;
                      RunObject=XMLport 50009;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=import;
                      PromotedCategory=Process }
      { 1120054011;1 ;Action    ;
                      Name=Clear List;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Clear;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to clear the list?')= FALSE THEN EXIT;
                                 POSTALCORP.RESET;
                                 IF POSTALCORP.FIND('-') THEN BEGIN
                                   POSTALCORP.DELETEALL;
                                   END;
                               END;
                                }
      { 1120054012;1 ;Action    ;
                      Name=Validate List;
                      RunObject=Report 50061;
                      Promoted=Yes;
                      PromotedIsBig=No;
                      Image=UpdateDescription;
                      PromotedCategory=Process }
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
                SourceExpr="Employer Code" }

    { 1120054003;2;Field  ;
                SourceExpr="Employer Name" }

    { 1120054004;2;Field  ;
                SourceExpr=County }

    { 1120054005;2;Field  ;
                SourceExpr="Payroll No" }

    { 1120054006;2;Field  ;
                SourceExpr="Account No" }

    { 1120054007;2;Field  ;
                SourceExpr=Grade }

    { 1120054008;2;Field  ;
                SourceExpr="Salary Amount" }

  }
  CODE
  {
    VAR
      POSTALCORP@1120054000 : Record 51516457;

    BEGIN
    END.
  }
}

