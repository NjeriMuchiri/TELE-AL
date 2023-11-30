OBJECT page 172175 Marked Def Notification List
{
  OBJECT-PROPERTIES
  {
    Date=10/06/21;
    Time=[ 2:59:08 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=Yes;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516355;
    SourceTableView=WHERE(Marked=CONST(Yes),
                          Stopped=CONST(No));
    PageType=List;
    CardPageID=Member Defaulter Notification;
    ActionList=ACTIONS
    {
      { 1120054010;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054011;1 ;ActionGroup }
      { 1120054012;2 ;Action    ;
                      Name=Send Notification;
                      RunObject=Report 51516014;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DefNot@1120054000 : Record 51516355;
                                 MembReg@1120054001 : Record 51516223;
                                 CnfmNotification@1120054002 : TextConst 'ENU=Send a notification to %1 defaulters?';
                                 SMSMessage@1120054003 : Record 51516329;
                                 iEntryNo@1120054004 : Integer;
                                 Err_NoOne@1120054005 : TextConst 'ENU=No member has been marked for sending! Please mark before proceeding.';
                                 DefaulterMsgDialog@1120054006 : page 172177;
                                 TextBeingSent@1120054007 : Text;
                               BEGIN
                                 {DefNot.RESET;
                                 DefNot.SETRANGE(Marked,TRUE);
                                 DefNot.SETRANGE(Stopped,FALSE);


                                 //IF NOT CONFIRM(CnfmNotification,FALSE,DefNot.COUNT) THEN
                                 // EXIT;

                                 //IF DefNot.COUNT<=0 THEN BEGIN MESSAGE(Err_NoOne); EXIT; END;

                                 DefaulterMsgDialog.LOOKUPMODE(TRUE);
                                 IF DefaulterMsgDialog.RUNMODAL = ACTION::Yes THEN
                                    TextBeingSent := DefaulterMsgDialog.TheMessageToBeSent;
                                 MESSAGE(TextBeingSent);

                                 IF DefNot.FINDSET THEN
                                   REPEAT
                                       MembReg.GET(DefNot."Member No");
                                       MembReg.CALCFIELDS("Outstanding Balance");
                                       IF (MembReg."Outstanding Balance">0) AND (MembReg."Phone No."<>'') THEN BEGIN
                                         SkyMbanking.SendSms(Source::LOAN_DEFAULTED,MembReg."Mobile Phone No",TextBeingSent,'','',TRUE,200,TRUE);

                                 //
                                 //         SMSMessage.RESET;
                                 //         IF SMSMessage.FIND('+') THEN BEGIN
                                 //         iEntryNo:=SMSMessage."Entry No";
                                 //         iEntryNo:=iEntryNo+1;
                                 //         END
                                 //         ELSE BEGIN
                                 //         iEntryNo:=1;
                                 //         END;
                                 //
                                 //         SMSMessage.INIT;
                                 //         SMSMessage."Entry No":=iEntryNo;
                                 //         SMSMessage."Account No":=MembReg."No.";
                                 //         SMSMessage."Date Entered":=TODAY;
                                 //         SMSMessage."Time Entered":=TIME;
                                 //         SMSMessage.Source:='DEFAULTER';
                                 //         SMSMessage."Entered By":=USERID;
                                 //         SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
                                         //SMSMessage."SMS Message":="SMS Message"+' '+"SMS MessageTwo"+'  From Telepost Sacco';
                                 //         SMSMessage."Telephone No":=MembReg."Phone No.";
                                 //         IF MembReg."Phone No."='' THEN
                                 //           SMSMessage."Telephone No":=MembReg."Mobile Phone No";
                                         //SMSMessage.INSERT;

                                        END;
                                     UNTIL DefNot.NEXT = 0;
                                     }
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Member No" }

    { 1120054003;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054004;2;Field  ;
                SourceExpr="ID No" }

    { 1120054005;2;Field  ;
                SourceExpr="Phone No" }

    { 1120054006;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054007;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054008;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054009;2;Field  ;
                SourceExpr=Remarks }

    { 1120054013;2;Field  ;
                SourceExpr=SendMessage }

  }
  CODE
  {
    VAR
      Source@1120054000 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN';
      SkyMbanking@1120054001 : Codeunit 51516701;

    BEGIN
    END.
  }
}

