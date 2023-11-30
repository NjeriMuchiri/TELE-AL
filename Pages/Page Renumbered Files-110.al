OBJECT page 20451 Pr Salary Card ListXX
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=10:47:46 AM;
    Modified=Yes;
    Version List=Sacco ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516160;
    PageType=List;
    CardPageID=prHeader Salary CardXX;
    PromotedActionCategoriesML=ENU=New,Process,Report,Employee;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755018;1 ;ActionGroup;
                      CaptionML=ENU=Employee }
      { 1102755019;2 ;Action    ;
                      CaptionML=ENU=Card;
                      RunObject=Page 39003994;
                      RunPageLink=Field1=FIELD(No.);
                      Promoted=Yes;
                      Image=Card;
                      PromotedCategory=Category4 }
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
                SourceExpr="No.";
                Style=StrongAccent;
                StyleExpr=TRUE }

    { 1102755005;2;Field  ;
                SourceExpr="First Name";
                Enabled=false }

    { 1102755007;2;Field  ;
                SourceExpr="Middle Name";
                Enabled=false }

    { 1102755022;2;Field  ;
                SourceExpr="Last Name";
                Enabled=false }

    { 1102755042;2;Field  ;
                SourceExpr="Job Title";
                Enabled=false }

    { 1102755034;2;Field  ;
                SourceExpr="Contract Type";
                Enabled=false }

    { 1102755046;2;Field  ;
                SourceExpr="User ID";
                Enabled=false }

    { 1102755030;2;Field  ;
                SourceExpr="Company E-Mail";
                Enabled=false }

    { 1102755004;;Container;
                ContainerType=FactBoxArea }

    { 1102755002;1;Part   ;
                SubPageLink=Field1=FIELD(No.);
                SystemPartID=Outlook }

    { 1102755003;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      HREmp@1102755000 : Record 51516160;
      EmployeeFullName@1000000000 : Text;

    BEGIN
    END.
  }
}

