OBJECT page 20470 HR Employee Kin
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=[ 2:22:36 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516160;
    PageType=Card;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=Employee Details;
                GroupType=Group }

    { 1102755001;2;Field  ;
                SourceExpr="No.";
                Importance=Promoted;
                Enabled=false;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755018;2;Field  ;
                CaptionML=ENU=Name;
                SourceExpr=FullName;
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755003;2;Field  ;
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

    { 1102755007;2;Field  ;
                SourceExpr=Gender;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755009;2;Field  ;
                SourceExpr="Post Code";
                Visible=false;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755011;2;Field  ;
                SourceExpr="Cell Phone Number";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755013;2;Field  ;
                SourceExpr="E-Mail";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755015;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755008;1;Part   ;
                PagePartID=Page51516179;
                PartType=Page }

    { 1102755006;;Container;
                ContainerType=FactBoxArea }

    { 1102755004;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516137;
                PartType=Page;
                SystemPartID=Outlook }

    { 1102755002;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      D@1102756000 : Date;
      EmpNames@1102755000 : Text[30];
      HREmp@1102755001 : Record 51516160;
      Text19032351@19067413 : TextConst 'ENU=Next Of Kin/Beneficiaries';

    BEGIN
    END.
  }
}

