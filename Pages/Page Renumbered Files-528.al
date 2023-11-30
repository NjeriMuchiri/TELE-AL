OBJECT page 172123 HR Job Qualifications
{
  OBJECT-PROPERTIES
  {
    Date=02/01/19;
    Time=10:45:04 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516162;
    PageType=List;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Qualifications;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 11      ;1   ;ActionGroup;
                      CaptionML=ENU=Qualification }
      { 12      ;2   ;Action    ;
                      CaptionML=ENU=Q&ualification Overview;
                      RunObject=Page 5230;
                      Promoted=Yes;
                      Image=QualificationOverview;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 1102755000;2;Field  ;
                SourceExpr="Qualification Type" }

    { 1102755002;2;Field  ;
                SourceExpr=Code }

    { 1102755004;2;Field  ;
                SourceExpr=Description }

  }
  CODE
  {

    BEGIN
    END.
  }
}

