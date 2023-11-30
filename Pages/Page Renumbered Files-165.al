OBJECT page 17356 HR Employee Attachments
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=[ 3:49:50 PM];
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
    PromotedActionCategoriesML=ENU=New,Process,Report,Attachments;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755033;1 ;ActionGroup;
                      CaptionML=ENU=Attachment;
                      Visible=false }
      { 1102755037;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Import;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=No;
                      Image=Import;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("No.",CurrPage.Attachments.PAGE.GetDocument) THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code",DocLink."Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF NOT InteractTemplLanguage.FINDFIRST THEN
                                 BEGIN
                                   InteractTemplLanguage.INIT;
                                   InteractTemplLanguage."Interaction Template Code" := "No.";
                                   InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                                   InteractTemplLanguage.Description := DocLink."Document Description";
                                   InteractTemplLanguage.INSERT;
                                 END;
                                 InteractTemplLanguage.ImportAttachment;
                                 CurrPage.UPDATE;

                                 DocLink.MODIFY;
                                 END;
                               END;
                                }
      { 1102755038;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=E&xport;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=No;
                      Image=Export;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("No.",CurrPage.Attachments.PAGE.GetDocument) THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code",DocLink."Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN BEGIN
                                   InteractTemplLanguage.ExportAttachment;
                                 END;
                                 END
                               END;
                                }
      { 1102755034;2 ;Action    ;
                      CaptionML=ENU=Open;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=No;
                      Image=Open;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("No.",CurrPage.Attachments.PAGE.GetDocument) THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code",DocLink."Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN BEGIN
                                   InteractTemplLanguage.OpenAttachment;
                                 END;
                                 END
                               END;
                                }
      { 1102755035;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Create;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=No;
                      Image=Create_Movement;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("No.",CurrPage.Attachments.PAGE.GetDocument) THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code",DocLink."Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN BEGIN

                                   InteractTemplLanguage.INIT;
                                   InteractTemplLanguage."Interaction Template Code" := "No.";
                                   InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                                   InteractTemplLanguage.Description := CurrPage.Attachments.PAGE.GetDocument;

                                 END;
                                 InteractTemplLanguage.CreateAttachment;
                                 CurrPage.UPDATE;
                                 DocLink.Attachment:=DocLink.Attachment::Yes;
                                 DocLink.MODIFY;
                                 END;
                               END;
                                }
      { 1102755036;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Copy &from;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=No;
                      Image=Copy;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("No.",CurrPage.Attachments.PAGE.GetDocument) THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code",DocLink."Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN BEGIN
                                 InteractTemplLanguage.CopyFromAttachment;
                                 CurrPage.UPDATE;
                                 DocLink.Attachment:=DocLink.Attachment::Yes;
                                 DocLink.MODIFY;
                                 END;
                                 END
                               END;
                                }
      { 1102755039;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Remove;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=No;
                      Image=RemoveContacts;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("No.",CurrPage.Attachments.PAGE.GetDocument) THEN
                                 BEGIN
                                 ERROR('%1',DocLink."Document Description");
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code",DocLink."Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN BEGIN

                                   InteractTemplLanguage.RemoveAttachment(TRUE);
                                   DocLink.Attachment:=DocLink.Attachment::No;
                                   DocLink.MODIFY;
                                 END;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=Employee Details;
                GroupType=Group }

    { 1102755017;2;Field  ;
                SourceExpr="No.";
                Importance=Promoted;
                Enabled=false;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755016;2;Field  ;
                CaptionML=ENU=Name;
                SourceExpr=FullName;
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755014;2;Field  ;
                SourceExpr="Job Title";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755012;2;Field  ;
                SourceExpr="Postal Address";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755010;2;Field  ;
                SourceExpr=Gender;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755008;2;Field  ;
                SourceExpr="Post Code";
                Visible=false;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755006;2;Field  ;
                SourceExpr="Cell Phone Number";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755004;2;Field  ;
                SourceExpr="E-Mail";
                Importance=Promoted;
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755002;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Enabled=FALSE;
                Editable=FALSE;
                StyleExpr=TRUE }

    { 1102755032;1;Part   ;
                Name=Attachments;
                CaptionML=ENU=Employee Attachments;
                SubPageLink=Employee No=FIELD(No.);
                PagePartID=Page51516414;
                PartType=Page }

    { 1102755003;;Container;
                ContainerType=FactBoxArea }

    { 1102755005;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516137;
                PartType=Page;
                SystemPartID=Outlook }

    { 1102755001;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      InteractTemplLanguage@1102755001 : Record 5103;
      DocLink@1102755000 : Record 51516211;
      EmpNames@1102755002 : Text[30];

    BEGIN
    END.
  }
}

