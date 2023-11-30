OBJECT page 17474 Customer Care Role
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=10:55:25 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1102755003;  ;ActionContainer;
                      Name=Bosa;
                      ActionContainerType=ActionItems }
      { 1102755004;1 ;Action    ;
                      Name=Loans Calculator;
                      RunObject=Page 50026;
                      Image=AdjustEntries }
      { 1102755005;1 ;Action    ;
                      Name=Membership Applications;
                      RunObject=page 20458;
                      Image=Add }
      { 1102755002;1 ;Action    ;
                      Name=Members  List;
                      RunObject=page 20464;
                      Image=AllLines }
      { 1102755001;1 ;Action    ;
                      Name=Bosa Loans;
                      RunObject=page 20473;
                      Image=Aging }
      { 1102755000;  ;ActionContainer;
                      Name=Fosa;
                      ActionContainerType=NewDocumentItems }
      { 1102755007;1 ;Action    ;
                      Name=Fosa Loans;
                      RunObject=page 17368;
                      Image=View }
      { 1102755006;1 ;Action    ;
                      Name=Fosa Accounts;
                      RunObject=page 20496;
                      Image=AllLines }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=RoleCenterArea }

    { 1000000004;1;Group  ;
                GroupType=Group }

    { 1000000003;2;Part   ;
                Name=Credit Processor;
                PagePartID=Page51516249;
                PartType=Page }

    { 1000000002;2;Part   ;
                PartType=System;
                SystemPartID=Outlook }

    { 1000000001;2;Part   ;
                PartType=System;
                SystemPartID=MyNotes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

