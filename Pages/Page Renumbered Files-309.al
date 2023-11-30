OBJECT page 50000 Bulk SMS Header
{
  OBJECT-PROPERTIES
  {
    Date=11/01/16;
    Time=[ 5:50:45 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516337;
    OnAfterGetCurrRecord=BEGIN
                           UpdateControl();
                         END;

    ActionList=ACTIONS
    {
      { 1000000013;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000014;1 ;Action    ;
                      Name=Send;
                      Promoted=Yes;
                      Image=PutawayLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF "SMS Status"<>"SMS Status"::Pending THEN
                                 ERROR('This sms has already been sent');
                                 IF CONFIRM('Are you sure you would like to send the SMS(ES)?',FALSE)=TRUE THEN BEGIN
                                 IF "SMS Type" <> "SMS Type"::Telephone THEN BEGIN
                                 TESTFIELD(Message);
                                 END;

                                 IF "SMS Type" = "SMS Type"::Telephone THEN BEGIN
                                 IF "Use Line Message"   = TRUE THEN BEGIN
                                 TESTFIELD(Message);
                                 END;
                                 END;


                                 BulkHeader.RESET;
                                 BulkHeader.SETRANGE(BulkHeader.No,No);
                                 IF BulkHeader.FIND('-') THEN BEGIN

                                 //ALL
                                 IF BulkHeader."SMS Type"=BulkHeader."SMS Type"::Everyone THEN BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."Creditor Type",Vend."Creditor Type"::Account);
                                 Vend.SETRANGE(Vend."Vendor Posting Group",'ORDINARY');
                                 IF Vend.FIND('-') THEN BEGIN
                                 REPEAT
                                 //SMS MESSAGE
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
                                 SMSMessage."Batch No":=No;
                                 SMSMessage."Document No":='';
                                 SMSMessage."Account No":=Vend."No.";
                                 SMSMessage."Date Entered":=TODAY;
                                 SMSMessage."Time Entered":=TIME;
                                 SMSMessage.Source:='BULK';
                                 SMSMessage."Entered By":=USERID;
                                 SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                 SMSMessage."SMS Message":=Message;

                                       IF  Vend."Phone No."<>'' THEN BEGIN
                                         SMSMessage."Telephone No":= Vend."Phone No.";
                                       END ELSE IF Vend."Mobile Phone No"<>'' THEN BEGIN
                                         SMSMessage."Telephone No":=Vend."Mobile Phone No";
                                       END ELSE BEGIN
                                         SMSMessage."Telephone No":=Vend."MPESA Mobile No";
                                       END;

                                 IF SMSMessage."Telephone No"<>'' THEN
                                   SMSMessage.INSERT;

                                 //IF Vend."MPESA Mobile No"<>'' THEN
                                 //SMSMessage.INSERT;

                                 UNTIL Vend.NEXT=0
                                 END;
                                 END;

                                 {
                                 //DIMENSION
                                 IF BulkHeader."SMS Type"=BulkHeader."SMS Type"::Dimension THEN BEGIN
                                 BulkLines.RESET;
                                 BulkLines.SETRANGE(BulkLines.No,No);
                                 IF BulkLines.FIND('-') THEN BEGIN
                                 REPEAT

                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."Creditor Type",Vend."Creditor Type"::Account);
                                 Vend.SETRANGE(Vend."Vendor Posting Group",'SAVINGS');
                                 Vend.SETRANGE(Vend."Global Dimension 1 Code",BulkLines.Code);
                                 IF Vend.FIND('-') THEN BEGIN
                                 REPEAT
                                 //SMS MESSAGE
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
                                 SMSMessage."Batch No":=No;
                                 SMSMessage."Document No":='';
                                 SMSMessage."Account No":=Vend."No.";
                                 SMSMessage."Date Entered":=TODAY;
                                 SMSMessage."Time Entered":=TIME;
                                 SMSMessage.Source:='BULK';
                                 SMSMessage."Entered By":=USERID;
                                 SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                 SMSMessage."SMS Message":=Message;
                                 SMSMessage."Telephone No":=Vend."MPESA Mobile No";
                                 IF Vend."MPESA Mobile No"<>'' THEN
                                 SMSMessage.INSERT;

                                 UNTIL Vend.NEXT=0
                                 END;

                                 UNTIL BulkLines.NEXT=0
                                 END;
                                 END;
                                 }

                                 //Telephone
                                 IF BulkHeader."SMS Type"=BulkHeader."SMS Type"::Telephone THEN BEGIN
                                 BulkLines.RESET;
                                 BulkLines.SETRANGE(BulkLines.No,No);
                                 IF BulkLines.FIND('-') THEN BEGIN
                                 REPEAT

                                 //SMS MESSAGE
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
                                 SMSMessage."Batch No":=No;
                                 SMSMessage."Document No":='';
                                 SMSMessage."Account No":=BulkLines.Code;
                                 SMSMessage."Date Entered":=TODAY;
                                 SMSMessage."Time Entered":=TIME;
                                 SMSMessage.Source:='BULK';
                                 SMSMessage."Entered By":=USERID;
                                 SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                 IF "Use Line Message" = TRUE THEN BEGIN
                                 SMSMessage."SMS Message":=Message;
                                 END
                                 ELSE BEGIN
                                 //SMSMessage."SMS Message":=BulkLines.Description;

                                 SMSMessage."SMS Message":=Message;
                                 END;

                                 SMSMessage."Telephone No":=BulkLines.Code;
                                 IF BulkLines.Code<>'' THEN
                                 SMSMessage.INSERT;



                                 UNTIL BulkLines.NEXT=0
                                 END;
                                 END;


                                 END;

                                 "SMS Status" := "SMS Status"::Sent;
                                 "Status Date" := TODAY;
                                 "Status Time" := TIME;
                                 "Status By" := USERID;
                                 MODIFY;

                                 END;
                               END;
                                }
      { 1000000015;1 ;Action    ;
                      Name=Import Telephone Nos;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF "SMS Type"<>"SMS Type"::Telephone THEN BEGIN
                                 ERROR('SMS Type must be Telephone.');
                                 END;

                                 BulkHeader.RESET;
                                 BulkHeader.SETRANGE(BulkHeader.No,No);
                                 IF BulkHeader.FIND('-') THEN BEGIN
                                 BulkLines.RESET;
                                 BulkLines.SETRANGE(BulkLines.No,BulkHeader.No);
                                 XMLPORT.RUN(51516015);
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1000000002;1;Field  ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 1000000003;1;Field  ;
                SourceExpr="Time Entered";
                Editable=FALSE }

    { 1000000004;1;Field  ;
                SourceExpr="Entered By";
                Editable=FALSE }

    { 1000000005;1;Field  ;
                SourceExpr="SMS Type" }

    { 1000000007;1;Field  ;
                SourceExpr="SMS Status";
                Editable=FALSE }

    { 1000000008;1;Field  ;
                SourceExpr="Status Date";
                Editable=FALSE }

    { 1000000009;1;Field  ;
                SourceExpr="Status Time";
                Editable=FALSE }

    { 1000000010;1;Field  ;
                SourceExpr="Status By";
                Editable=FALSE }

    { 1000000006;1;Field  ;
                SourceExpr=Message;
                Editable=Mssage }

    { 1000000012;1;Part   ;
                CaptionML=ENU=<Bulk SMS Lines>;
                SubPageLink=No=FIELD(No);
                PagePartID=Page51516363;
                Editable=BulkSMSLines;
                PartType=Page }

  }
  CODE
  {
    VAR
      BulkHeader@1000000005 : Record 51516337;
      BulkLines@1000000004 : Record 51516338;
      Vend@1000000003 : Record 23;
      SMSMessage@1000000002 : Record 51516329;
      iEntryNo@1000000001 : Integer;
      StatusPermissions@1000000000 : Record 51516310;
      ApprovalEntries@1000000007 : Page 658;
      DocumentType@1000000006 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTransport Request,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft,ImprestSurrender,MSacco Applications,MSacco PinChange,MSacco PhoneChange,MSacco TransChange,BulkSMS';
      text001@1000000008 : TextConst 'ENU=Status must be Open';
      text002@1000000009 : TextConst 'ENU=Status must be Pending';
      Mssage@1000000010 : Boolean;
      UseHeader@1000000011 : Boolean;
      BulkSMSLines@1000000012 : Boolean;

    PROCEDURE UpdateControl@1000000011();
    BEGIN
      IF Status=Status::Open THEN BEGIN
      Mssage:=TRUE;
      UseHeader:=TRUE;
      BulkSMSLines:=TRUE;
      END;

      IF Status=Status::Pending THEN BEGIN
      Mssage:=FALSE;
      UseHeader:=FALSE;
      BulkSMSLines:=FALSE;
      END;

      IF Status=Status::Rejected THEN BEGIN
      Mssage:=FALSE;
      UseHeader:=FALSE;
      BulkSMSLines:=FALSE;
      END;


      IF Status=Status::Approved THEN BEGIN
      Mssage:=FALSE;
      UseHeader:=FALSE;
      BulkSMSLines:=FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

