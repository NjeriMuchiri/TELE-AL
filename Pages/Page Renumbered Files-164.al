OBJECT page 17355 HR Employee Qualification Line
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=10:19:11 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    CaptionML=ENU=Employee Qualification Lines;
    SourceTable=Table51516197;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755009;1 ;ActionGroup;
                      CaptionML=ENU=Q&ualification }
      { 1102755010;2 ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 5222;
                      RunPageLink=Table Name=CONST(Employee Qualification),
                                  No.=FIELD(Employee No.),
                                  Table Line No.=FIELD(Line No.) }
      { 1102755021;2 ;Separator  }
      { 1102755022;2 ;Action    ;
                      CaptionML=ENU=Q&ualification Overview;
                      RunObject=Page 5230 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="Qualification Type" }

    { 1102755017;2;Field  ;
                SourceExpr="Qualification Code" }

    { 1102755019;2;Field  ;
                SourceExpr="Qualification Description" }

    { 1102755002;2;Field  ;
                SourceExpr="Course of Study" }

    { 1102755003;2;Field  ;
                SourceExpr="From Date" }

    { 1102755005;2;Field  ;
                SourceExpr="To Date" }

    { 1102755007;2;Field  ;
                SourceExpr=Type }

    { 1102755011;2;Field  ;
                SourceExpr="Institution/Company" }

    { 1102755013;2;Field  ;
                SourceExpr="Course Grade" }

    { 1102755015;2;Field  ;
                SourceExpr=Comment }

  }
  CODE
  {

    BEGIN
    END.
  }
}

