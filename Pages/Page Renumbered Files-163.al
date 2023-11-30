OBJECT page 17354 HR Employee Qualifications
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=[ 2:26:56 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516160;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Qualification;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755020;1 ;ActionGroup;
                      CaptionML=ENU=Q&ualification }
      { 1102755023;2 ;Action    ;
                      CaptionML=ENU=Q&ualification Overview;
                      RunObject=Page 5230;
                      Promoted=Yes;
                      Image=TaskQualityMeasure;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=Employee Details;
                GroupType=Group }

    { 1102755009;2;Field  ;
                SourceExpr="No.";
                Importance=Promoted;
                Enabled=false;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755008;2;Field  ;
                CaptionML=ENU=Name;
                SourceExpr=FullName;
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755007;2;Field  ;
                SourceExpr="Job Title";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755006;2;Field  ;
                SourceExpr="Postal Address";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755005;2;Field  ;
                SourceExpr=Gender;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755004;2;Field  ;
                SourceExpr="Post Code";
                Visible=false;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755003;2;Field  ;
                SourceExpr="Cell Phone Number";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755002;2;Field  ;
                SourceExpr="E-Mail";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755001;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755019;1;Part   ;
                CaptionML=ENU=Employee Qualifications;
                SubPageLink=Employee No.=FIELD(No.);
                PagePartID=Page51516216;
                PartType=Page }

    { 1102755011;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

    { 1102755013;;Container;
                ContainerType=FactBoxArea }

    { 1102755012;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516137;
                PartType=Page;
                SystemPartID=Outlook }

    { 1102755010;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {

    BEGIN
    END.
  }
}

