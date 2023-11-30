OBJECT page 172163 Messages Card
{
  OBJECT-PROPERTIES
  {
    Date=06/08/23;
    Time=[ 5:05:02 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516893;
    PageType=Card;
    OnOpenPage=BEGIN
                 PageControls;
               END;

    OnAfterGetRecord=BEGIN
                       PageControls;
                     END;

    OnNewRecord=BEGIN
                  "Message Date":=TODAY;
                END;

    OnAfterGetCurrRecord=BEGIN
                           PageControls;
                         END;

    ActionList=ACTIONS
    {
      { 1120054008;  ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1120054007;1 ;ActionGroup;
                      CaptionML=[ENU=Send;
                                 ESM=&C. trabajo;
                                 FRC=Ate&lier;
                                 ENC=Wor&k Ctr.];
                      Image=WorkCenter }
      { 1120054006;2 ;Action    ;
                      Name=Sendsms;
                      CaptionML=ENU=Send Message;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      OnAction=VAR
                                 ThisDialog@1120054000 : Dialog;
                                 SmsLines@1120054001 : Record 51516421;
                               BEGIN
                                    IF NOT CONFIRM('Are you sure you want to send the sms') THEN EXIT;
                                    SmsLines.RESET;
                                    SmsLines.SETRANGE("Entry No",Rec."Entry No");
                                    SmsLines.SETFILTER(SmsLines."Mobile No",'<>%1','');
                                    SmsLines.SETFILTER(SmsLines."Message To Send",'<>%1','');
                                    IF NOT SmsLines.FINDFIRST THEN
                                      TESTFIELD("SMS Message");
                                    TESTFIELD(Sent,FALSE);

                                    ThisDialog.OPEN('#Sending message to : ####1###################################');

                                   IF NOT Imported THEN BEGIN

                                        MembersRegister.RESET;
                                        MembersRegister.SETFILTER(MembersRegister.Status,'%1|%2',MembersRegister.Status::Active,MembersRegister.Status::Dormant);
                                        MembersRegister.SETFILTER(MembersRegister."Phone No.",'<>%1','');
                                        IF NOT "Send to All members" THEN BEGIN
                                             IF Rec."Individual Member No"<>'' THEN
                                               MembersRegister.SETRANGE("No.","Individual Member No")
                                             ELSE
                                               MembersRegister.SETRANGE("Employer Code",Rec.Employer);
                                        END;
                                        IF MembersRegister.FINDSET THEN
                                          REPEAT

                                                 ThisDialog.UPDATE(1,MembersRegister."No."+' '+MembersRegister.Name);

                                                 SMSMessage.RESET;
                                                 IF SMSMessage.FIND('+') THEN BEGIN
                                                 iEntryNo:=SMSMessage."Entry No";
                                                 iEntryNo:=iEntryNo+1;
                                                 END
                                                 ELSE BEGIN
                                                 iEntryNo:=1;
                                                 END;

                                                 SMSMessage.INIT;
                                                 SMSMessage."Entry No":=iEntryNo;
                                                 SMSMessage."Account No":=MembersRegister."Phone No.";
                                                 SMSMessage."Date Entered":=TODAY;
                                                 SMSMessage."Time Entered":=TIME;
                                                 SMSMessage.Source:='BULK';
                                                 SMSMessage."Entered By":=USERID;
                                                 SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                                 SMSMessage."SMS Message":="SMS Message"+' '+"SMS MessageTwo"; //+'  From Telepost Sacco';
                                                 SMSMessage."Telephone No":=MembersRegister."Phone No.";
                                                 IF MembersRegister."Phone No."='' THEN
                                                   SMSMessage."Telephone No":=MembersRegister."Mobile Phone No";
                                                 SMSMessage.INSERT;

                                            UNTIL MembersRegister.NEXT = 0;


                                       END ELSE BEGIN

                                              SmsLines.RESET;
                                              SmsLines.SETRANGE("Entry No",Rec."Entry No");
                                              SmsLines.SETFILTER(SmsLines."Mobile No",'<>%1','');
                                              IF SmsLines.FINDFIRST THEN REPEAT

                                                 ThisDialog.UPDATE(1,SmsLines."Mobile No");

                                                 SMSMessage.RESET;
                                                 IF SMSMessage.FIND('+') THEN BEGIN
                                                 iEntryNo:=SMSMessage."Entry No";
                                                 iEntryNo:=iEntryNo+1;
                                                 END
                                                 ELSE BEGIN
                                                 iEntryNo:=1;
                                                 END;

                                                 SMSMessage.INIT;
                                                 SMSMessage."Entry No":=iEntryNo;
                                                 SMSMessage."Account No":=SmsLines."Mobile No";
                                                 SMSMessage."Date Entered":=TODAY;
                                                 SMSMessage."Time Entered":=TIME;
                                                 SMSMessage.Source:='BULK';
                                                 SMSMessage."Entered By":=USERID;
                                                 SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                                 IF SmsLines."Message To Send"<>'' THEN
                                                   SMSMessage."SMS Message":=SmsLines."Message To Send" //+'  From Telepost Sacco'
                                                 ELSE
                                                   SMSMessage."SMS Message":="SMS Message"+' '+"SMS MessageTwo" ;//+'  From Telepost Sacco';
                                                 SMSMessage."Telephone No":=SmsLines."Mobile No";
                                                 IF SmsLines."Mobile No" = '' THEN
                                                   SMSMessage."Telephone No":=SmsLines."Mobile No";
                                                 IF SMSMessage."SMS Message"<>'' THEN
                                                 SMSMessage.INSERT;

                                               UNTIL SmsLines.NEXT = 0;

                                          END;

                                    Sent:=TRUE;
                                    "Sent By":=USERID;
                                    "Sent On":=CURRENTDATETIME;
                                     MODIFY;

                                     ThisDialog.CLOSE;
                                     MESSAGE('Messages have been inserted to the buffer.');
                                     CurrPage.CLOSE;


                                   {   IF "Send to All members"=FALSE THEN BEGIN
                                     IF "Member Category"='STAFF' THEN BEGIN
                                        MembersRegister.RESET;
                                        MembersRegister.SETRANGE(MembersRegister."Employer Code",'STAFF');
                                        IF MembersRegister.FINDFIRST THEN
                                        BEGIN
                                        REPEAT
                                              SMSMessage.RESET;
                                             IF SMSMessage.FIND('+') THEN BEGIN
                                             iEntryNo:=SMSMessage."Entry No";
                                             iEntryNo:=iEntryNo+1;
                                             END
                                             ELSE BEGIN
                                             iEntryNo:=1;
                                             END;

                                             SMSMessage.RESET;
                                             SMSMessage.INIT;
                                             SMSMessage."Entry No":=iEntryNo;
                                             SMSMessage."Account No":=MembersRegister."Mobile Phone No";
                                             SMSMessage."Date Entered":=TODAY;
                                             SMSMessage."Time Entered":=TIME;
                                             SMSMessage.Source:='NAV SMS';
                                             SMSMessage."Entered By":=USERID;
                                             SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                             SMSMessage."SMS Message":=Message+' '+MessageTwo+'  From Telepost Sacco';
                                             SMSMessage."Telephone No":=MembersRegister."Phone No.";
                                             IF MembersRegister."Phone No."='' THEN
                                               SMSMessage."Telephone No":=MembersRegister."Mobile Phone No";
                                             SMSMessage.INSERT;
                                       UNTIL MembersRegister.NEXT=0;
                                       END;
                                       END;
                                       END;



                                    IF "Member Category"='DELEGATE' THEN BEGIN
                                    SMSGroups.RESET;
                                    SMSGroups.SETRANGE(SMSGroups.Delegate,TRUE);
                                    IF SMSGroups.FINDFIRST THEN BEGIN
                                       REPEAT
                                        SMSMessage.RESET;
                                       IF SMSMessage.FIND('+') THEN BEGIN
                                       iEntryNo:=SMSMessage."Entry No";
                                       iEntryNo:=iEntryNo+1;
                                       END
                                       ELSE BEGIN
                                       iEntryNo:=1;
                                       END;

                                       SMSMessage.RESET;
                                       SMSMessage.INIT;
                                       SMSMessage."Entry No":=iEntryNo;
                                       SMSMessage."Account No":=SMSGroups."Phone Number";
                                       SMSMessage."Date Entered":=TODAY;
                                       SMSMessage."Time Entered":=TIME;
                                       SMSMessage.Source:='NAV SMS';
                                       SMSMessage."Entered By":=USERID;
                                       SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                       SMSMessage."SMS Message":=Message+' '+MessageTwo+'  From Telepost Sacco';;
                                       SMSMessage."Telephone No":=MembersRegister."Phone No.";
                                       IF MembersRegister."Phone No."='' THEN
                                         SMSMessage."Telephone No":=SMSGroups."Phone Number";
                                       SMSMessage.INSERT;
                                       UNTIL SMSGroups.NEXT=0;
                                       END;
                                       END;

                                       IF "Member Category"='BOARD' THEN BEGIN
                                    SMSGroups.RESET;
                                    SMSGroups.SETRANGE(SMSGroups.Delegate,TRUE);
                                    IF SMSGroups.FINDFIRST THEN BEGIN
                                       REPEAT
                                        SMSMessage.RESET;
                                       IF SMSMessage.FIND('+') THEN BEGIN
                                       iEntryNo:=SMSMessage."Entry No";
                                       iEntryNo:=iEntryNo+1;
                                       END
                                       ELSE BEGIN
                                       iEntryNo:=1;
                                       END;

                                       SMSMessage.RESET;
                                       SMSMessage.INIT;
                                       SMSMessage."Entry No":=iEntryNo;
                                       SMSMessage."Account No":=SMSGroups."Phone Number";
                                       SMSMessage."Date Entered":=TODAY;
                                       SMSMessage."Time Entered":=TIME;
                                       SMSMessage.Source:='NAV SMS';
                                       SMSMessage."Entered By":=USERID;
                                       SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                       SMSMessage."SMS Message":=Message+' '+MessageTwo+'  From Telepost Sacco';;
                                       SMSMessage."Telephone No":=SMSGroups."Phone Number";
                                       SMSMessage.INSERT;
                                       UNTIL SMSGroups.NEXT=0;
                                       END;
                                       END;
                                       END;


                                      IF "Send to All members"=TRUE THEN BEGIN
                                     MembersRegister.RESET;
                                     //MembersRegister.SETRANGE(MembersRegister.Status,MembersRegister.sts);
                                     IF MembersRegister.FINDSET THEN BEGIN
                                       REPEAT
                                        SMSMessage.RESET;
                                       IF SMSMessage.FIND('+') THEN BEGIN
                                       iEntryNo:=SMSMessage."Entry No";
                                       iEntryNo:=iEntryNo+1;
                                       END
                                       ELSE BEGIN
                                       iEntryNo:=1;
                                       END;

                                       SMSMessage.RESET;
                                       SMSMessage.INIT;
                                       SMSMessage."Entry No":=iEntryNo;
                                       SMSMessage."Account No":="Individual Phone No";
                                       SMSMessage."Date Entered":=TODAY;
                                       SMSMessage."Time Entered":=TIME;
                                       SMSMessage.Source:='NAV SMS';
                                       SMSMessage."Entered By":=USERID;
                                       SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                       SMSMessage."SMS Message":=Message+' '+MessageTwo+'  From Telepost Sacco';;
                                       SMSMessage."Telephone No":=MembersRegister."Phone No.";
                                       IF MembersRegister."Phone No."='' THEN
                                         SMSMessage."Telephone No":=MembersRegister."Mobile Phone No";
                                       SMSMessage.INSERT;
                                       UNTIL MembersRegister.NEXT=0;
                                       END;
                                       END;}
                                       Sent:=TRUE;
                                       MODIFY;
                                       //Message('Sent successfully');
                                       CurrPage.CLOSE;


                               END;
                                }
      { 1120054018;2 ;Action    ;
                      Name=Import Sms Lines;
                      ToolTipML=ENU=CSV Format: Field1: Entry No, Field2: Phone Number;
                      Promoted=Yes;
                      Image=Import;
                      OnAction=VAR
                                 SmsLines@1120054000 : Record 51516421;
                               BEGIN
                                 SmsLines.RESET;
                                 SmsLines.SETRANGE("Entry No",Rec."Entry No");
                                 IF SmsLines.FINDFIRST THEN
                                   SmsLines.DELETEALL;

                                 COMMIT;

                                 XMLPORT.RUN(50000,TRUE,TRUE);

                                 Imported := TRUE;
                                 MODIFY;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=To;
                GroupType=Group }

    { 1120054019;2;Field  ;
                SourceExpr="Entry No" }

    { 1120054010;2;Field  ;
                SourceExpr="Send to All members";
                OnValidate=BEGIN
                             IF "Send to All members"=TRUE THEN BEGIN
                               "Individual Member No":='';
                               Employer:='';
                               MODIFY;
                               END;
                           END;
                            }

    { 1120054002;2;Field  ;
                SourceExpr="Individual Member No" }

    { 1120054003;2;Field  ;
                SourceExpr=Employer }

    { 1120054009;2;Field  ;
                SourceExpr="Message Date";
                Editable=false }

    { 1120054014;2;Field  ;
                SourceExpr="Inserted By" }

    { 1120054015;2;Field  ;
                SourceExpr="Inserted On" }

    { 1120054012;2;Field  ;
                SourceExpr="Sent By" }

    { 1120054017;2;Field  ;
                SourceExpr=Imported }

    { 1120054013;2;Field  ;
                SourceExpr="Sent On" }

    { 1120054005;1;Group  ;
                Name=SMS;
                GroupType=Group }

    { 1120054004;2;Field  ;
                SourceExpr="SMS Message";
                MultiLine=Yes }

    { 1120054011;2;Field  ;
                SourceExpr="SMS MessageTwo";
                MultiLine=Yes }

    { 1120054016;1;Part   ;
                SubPageLink=Entry No=FIELD(Entry No);
                PagePartID=Page51516908;
                Visible=Imported;
                Editable=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      SMSMessage@1120054000 : Record 51516329;
      MembersRegister@1120054001 : Record 51516223;
      iEntryNo@1120054002 : Integer;
      SMSGroups@1120054003 : Record 51516870;

    LOCAL PROCEDURE PageControls@1120054000();
    BEGIN
      CurrPage.EDITABLE:=TRUE;
      IF Sent THEN
        CurrPage.EDITABLE:=FALSE;
    END;

    BEGIN
    END.
  }
}

