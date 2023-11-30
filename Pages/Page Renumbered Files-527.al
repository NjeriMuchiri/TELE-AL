OBJECT page 172122 HR Employee List1
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=12:07:39 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516160;
    PageType=List;
    CardPageID=HR Employee Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Employee;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755018;1 ;ActionGroup;
                      CaptionML=ENU=Employee }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr=City;
                StyleExpr=TRUE }

    { 1102755005;2;Field  ;
                SourceExpr=County;
                Enabled=false }

    { 1102755007;2;Field  ;
                SourceExpr="Home Phone Number";
                Enabled=false }

    { 1102755022;2;Field  ;
                SourceExpr="Post Code";
                Enabled=false }

    { 1102755042;2;Field  ;
                SourceExpr="Job T";
                Enabled=false }

    { 1000000000;2;Field  ;
                SourceExpr=EmployeeUSERID }

    { 1000000002;2;Field  ;
                SourceExpr="Company E-Mail" }

    { 1102755004;;Container;
                ContainerType=FactBoxArea }

    { 1102755003;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      HREmp@1102755000 : Record 51516160;
      EmployeeFullName@1000000000 : Text;
      PayrollEmp@1000000001 : Record 51516180;

    BEGIN
    END.
  }
}

