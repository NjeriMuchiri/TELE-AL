OBJECT page 20471 HR Employee Kin SF
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=[ 2:58:07 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    CaptionML=ENU=HR Employee Kin & Beneficiaries;
    SourceTable=Table51516110;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755002;1 ;ActionGroup;
                      CaptionML=ENU=&Next of Kin }
      { 1102755003;2 ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 5222;
                      RunPageLink=Table Name=CONST(Employee Relative),
                                  No.=FIELD(Employee Code),
                                  Table Line No.=FIELD(Line No.) }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1102755000;2;Field  ;
                SourceExpr=Type }

    { 1000000001;2;Field  ;
                SourceExpr=Relationship }

    { 1000000003;2;Field  ;
                SourceExpr=SurName }

    { 1000000005;2;Field  ;
                SourceExpr="Other Names" }

    { 1000000007;2;Field  ;
                SourceExpr="ID No/Passport No" }

    { 1   ;2   ;Field     ;
                SourceExpr="Date Of Birth" }

    { 1000000011;2;Field  ;
                SourceExpr=Occupation }

    { 1000000013;2;Field  ;
                SourceExpr=Address }

    { 1000000002;2;Field  ;
                SourceExpr="E-mail" }

    { 1000000015;2;Field  ;
                SourceExpr="Office Tel No" }

    { 1000000017;2;Field  ;
                SourceExpr="Home Tel No" }

    { 1000000019;2;Field  ;
                SourceExpr=Comment }

  }
  CODE
  {
    VAR
      D@1102756001 : Date;

    BEGIN
    END.
  }
}

