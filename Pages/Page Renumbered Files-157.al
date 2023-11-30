OBJECT page 20498 HR Training Needs Card
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=11:13:52 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516207;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Functions;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755001;2;Field  ;
                SourceExpr=Code }

    { 1102755003;2;Field  ;
                SourceExpr=Description }

    { 1   ;2   ;Field     ;
                SourceExpr="Start Date" }

    { 1102755011;2;Field  ;
                SourceExpr=Duration }

    { 1102755009;2;Field  ;
                SourceExpr="Duration Units" }

    { 1102755013;2;Field  ;
                SourceExpr="Cost Of Training" }

    { 1102755015;2;Field  ;
                SourceExpr=Location }

    { 1102755023;2;Field  ;
                SourceExpr=Provider }

    { 1102755002;2;Field  ;
                SourceExpr="Provider Name";
                Editable=false }

    { 2   ;2   ;Field     ;
                SourceExpr="End Date" }

    { 1102755025;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1102755027;2;Field  ;
                SourceExpr=Posted }

    { 1102755029;2;Field  ;
                SourceExpr=Closed }

    { 3   ;2   ;Field     ;
                SourceExpr="Job id" }

  }
  CODE
  {
    VAR
      D@1102755001 : Date;

    BEGIN
    END.
  }
}

