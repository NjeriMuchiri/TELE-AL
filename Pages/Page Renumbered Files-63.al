OBJECT page 20427 CloudPESA PIN Reset Card
{
  OBJECT-PROPERTIES
  {
    Date=08/25/20;
    Time=[ 3:02:23 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=Yes;
    SourceTable=Table51516521;
    PageType=Card;
    OnOpenPage=BEGIN
                 //ERROR('under maintenance');
               END;

    ActionList=ACTIONS
    {
      { 1120054000;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054001;1 ;Action    ;
                      Name=Reset Pin;
                      ShortCutKey=F5;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Answers;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF SentToServer=FALSE THEN BEGIN
                                   ERROR('Pin reset has already been Requested');
                                 END ELSE BEGIN

                                   "Last PIN Reset" := TODAY;
                                   "Reset By" :=USERID;
                                    SentToServer:=FALSE;

                                 pinResetLogs.RESET;
                                 pinResetLogs.INIT;
                                 pinResetLogs."Account Name":="Account Name";
                                 pinResetLogs.No:="No.";
                                 pinResetLogs."ID No":="ID No";
                                 pinResetLogs."Account No":="Account No";
                                 pinResetLogs.Telephone:=Telephone;
                                 pinResetLogs.Date:=CURRENTDATETIME;
                                 pinResetLogs."Last PIN Reset":=CURRENTDATETIME;
                                 pinResetLogs."Reset By":=USERID;

                                 IF pinResetLogs.INSERT=TRUE THEN
                                   MESSAGE('Pin reset has been successfully been sent');

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Pin Reset',0,'CLOUDPESA',TODAY,TIME,'',"Account Name","No.",'');
                                 //End Create Audit Entry
                                   END;
                               END;
                                }
      { 1120054002;1 ;Action    ;
                      Name=PIN Reset Entries;
                      RunObject=page 20426;
                      RunPageOnRec=No;
                      RunPageView=SORTING(Entry No)
                                  ORDER(Descending);
                      RunPageLink=No=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CampaignEntries;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000002;2;Field  ;
                SourceExpr="No.";
                Editable=false }

    { 1000000003;2;Field  ;
                SourceExpr="Account No";
                Editable=false }

    { 1000000004;2;Field  ;
                SourceExpr="Account Name";
                Editable=false }

    { 1000000005;2;Field  ;
                SourceExpr=Telephone;
                Editable=false }

    { 1000000006;2;Field  ;
                SourceExpr="ID No";
                Editable=false }

    { 1000000007;2;Field  ;
                SourceExpr=Status;
                Editable=false }

    { 1000000008;2;Field  ;
                SourceExpr="Date Applied";
                Editable=false }

    { 1000000009;2;Field  ;
                SourceExpr="Time Applied";
                Editable=false }

    { 1000000010;2;Field  ;
                SourceExpr="Created By";
                Editable=false }

    { 1000000012;2;Field  ;
                SourceExpr="Last PIN Reset";
                Editable=false }

    { 1000000013;2;Field  ;
                SourceExpr="Reset By";
                Editable=false }

    { 1120054003;2;Field  ;
                SourceExpr=SentToServer;
                Enabled=false }

  }
  CODE
  {
    VAR
      cloudpesaapp@1000000000 : Record 51516521;
      pinResetLogs@1120054000 : Record 51516569;
      AuditTrail@1120054003 : Codeunit 51516107;
      Trail@1120054002 : Record 51516655;
      EntryNo@1120054001 : Integer;

    BEGIN
    END.
  }
}

