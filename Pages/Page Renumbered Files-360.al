OBJECT page 50051 HR Employee Attachments SF
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=11:00:32 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    CaptionML=ENU=HR Employee Attachments;
    DeleteAllowed=No;
    SourceTable=Table51516211;
    PageType=List;
    PromotedActionCategoriesML=ENU=New,Process,Report,Attachments;
    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      CaptionML=ENU=Attachments;
                      ActionContainerType=ActionItems }
      { 1102755003;1 ;Action    ;
                      CaptionML=ENU=Open;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Open;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("Employee No","Document Description") THEN

                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code","Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN
                                 //IF InteractTemplLanguage.GET(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") THEN
                                   InteractTemplLanguage.OpenAttachment;
                                 END;
                               END;
                                }
      { 1102755004;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Create;
                      Promoted=Yes;
                      Image=Create_Movement;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("Employee No","Document Description") THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code","Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF NOT InteractTemplLanguage.FINDFIRST THEN
                                 //iF NOT InteractTemplLanguage.GET(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") THEN
                                 BEGIN
                                   InteractTemplLanguage.INIT;
                                   InteractTemplLanguage."Interaction Template Code" := "Employee No";
                                   InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                                   InteractTemplLanguage.Description := "Document Description";
                                 END;
                                 InteractTemplLanguage.CreateAttachment;
                                 CurrPage.UPDATE;
                                 DocLink.Attachment:=DocLink.Attachment::Yes;
                                 DocLink.MODIFY;
                                 END;
                               END;
                                }
      { 1102755005;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Copy & From;
                      Promoted=Yes;
                      Image=Copy;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("Employee No","Document Description") THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code","Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN
                                 //IF InteractTemplLanguage.GET(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") THEN

                                 InteractTemplLanguage.CopyFromAttachment;
                                 CurrPage.UPDATE;
                                 DocLink.Attachment:=DocLink.Attachment::Yes;
                                 DocLink.MODIFY;
                                 END;
                               END;
                                }
      { 1102755006;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Import;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("Employee No","Document Description") THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code","Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF NOT InteractTemplLanguage.FINDFIRST THEN
                                 //IF NOT InteractTemplLanguage.GET(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") THEN
                                 BEGIN
                                   InteractTemplLanguage.INIT;
                                   InteractTemplLanguage."Interaction Template Code" := "Employee No";
                                   InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                                   InteractTemplLanguage.Description := DocLink."Document Description";
                                   InteractTemplLanguage.INSERT;
                                 END;
                                 InteractTemplLanguage.ImportAttachment;
                                 CurrPage.UPDATE;
                                 DocLink.Attachment:=DocLink.Attachment::Yes;
                                 DocLink.MODIFY;
                                 END;
                               END;
                                }
      { 1102755007;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=E&xport;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("Employee No","Document Description") THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code","Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN
                                 //iF InteractTemplLanguage.GET(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") THEN
                                   InteractTemplLanguage.ExportAttachment;
                                 END;
                               END;
                                }
      { 1102755008;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Remove;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=RemoveContacts;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InteractTemplLanguage@1001 : Record 5103;
                               BEGIN
                                 IF DocLink.GET("Employee No","Document Description") THEN
                                 BEGIN
                                 InteractTemplLanguage.RESET;
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Interaction Template Code","Employee No");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage."Language Code",DocLink."Language Code (Default)");
                                 InteractTemplLanguage.SETRANGE(InteractTemplLanguage.Description,DocLink."Document Description");
                                 IF InteractTemplLanguage.FINDFIRST THEN BEGIN
                                 //IF InteractTemplLanguage.GET(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") THEN BEGIN
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

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1000000001;2;Field  ;
                SourceExpr="Document Description" }

    { 1000000003;2;Field  ;
                CaptionML=ENU=Attachment Imported;
                SourceExpr=Attachment }

  }
  CODE
  {
    VAR
      InteractTemplLanguage@1102755001 : Record 5103;
      DocLink@1102755000 : Record 51516211;

    PROCEDURE GetDocument@1000000000() Document : Text[200];
    BEGIN
      Document:="Document Description";
    END;

    BEGIN
    END.
  }
}

