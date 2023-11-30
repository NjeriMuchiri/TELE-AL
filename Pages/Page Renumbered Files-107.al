OBJECT page 20448 HR Employment History
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=10:11:41 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516160;
    PageType=Card;
    OnAfterGetRecord=BEGIN
                                                   HREmp.RESET;
                                                   IF HREmp.GET("No.") THEN
                                                   BEGIN
                                                   EmpNames:=HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                                                   END ELSE BEGIN
                                                   EmpNames:='';
                                                   END;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=Employmee Details;
                Editable=FALSE;
                GroupType=Group }

    { 1102755008;2;Field  ;
                SourceExpr="No.";
                Importance=Promoted;
                Enabled=false;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755007;2;Field  ;
                CaptionML=ENU=Name;
                SourceExpr=FullName;
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755006;2;Field  ;
                SourceExpr="Job Title";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755005;2;Field  ;
                SourceExpr="Postal Address";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755004;2;Field  ;
                SourceExpr=Gender;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755003;2;Field  ;
                SourceExpr="Post Code";
                Visible=false;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755002;2;Field  ;
                SourceExpr="Cell Phone Number";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755001;2;Field  ;
                SourceExpr="E-Mail";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755000;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1120054003;1;Part   ;
                CaptionML=ENU=Employment History Details;
                SubPageLink=Employee No.=FIELD(No.);
                PagePartID=Page51516138;
                PartType=Page }

    { 1120054002;;Container;
                ContainerType=FactBoxArea }

    { 1120054001;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516137;
                PartType=Page;
                SystemPartID=Outlook }

    { 1120054000;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      EmpNames@1102755000 : Text[30];
      HREmp@1102755001 : Record 51516160;
      Text19034996@19036451 : TextConst 'ENU=Employment History';

    BEGIN
    END.
  }
}

