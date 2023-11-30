OBJECT page 17452 Banking Schedule Cheques
{
  OBJECT-PROPERTIES
  {
    Date=06/20/17;
    Time=[ 2:49:37 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516299;
    SourceTableView=WHERE(Type=CONST(Cheque Deposit),
                          Posted=CONST(Yes),
                          Banking Posted=CONST(No));
    PageType=List;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 //Filter based on branch
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Transacting Branch",UsersID.Branch);
                 END;  }
                 //Filter based on branch
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760027;1 ;ActionGroup;
                      CaptionML=ENU=Banking }
      { 1102760028;2 ;Action    ;
                      CaptionML=ENU=Banking Schedule;
                      Promoted=Yes;
                      Visible=true }
      { 1102760029;2 ;Separator  }
      { 1102760030;2 ;Action    ;
                      CaptionML=ENU=Process Banking;
                      Promoted=Yes;
                      Image=PutawayLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 TESTFIELD("Bank Name");
                                 TESTFIELD("Cheque Drawer");

                                 IF CONFIRM('Are you sure you want to Bank the selected cheques?',FALSE) = TRUE THEN BEGIN

                                 Transactions.RESET;
                                 Transactions.SETRANGE(Type,'Cheque Deposit');
                                 Transactions.SETRANGE(Transactions.Select,TRUE);
                                 Transactions.SETRANGE("Banking Posted",FALSE);
                                 IF Transactions.FIND('-') THEN BEGIN
                                 REPEAT

                                 Transactions."Banked By":=USERID;
                                 Transactions."Date Banked":=TODAY;
                                 Transactions."Time Banked":=TIME;
                                 Transactions."Banking Posted":=TRUE;
                                 Transactions.MODIFY;
                                 UNTIL Transactions.NEXT = 0;

                                 MESSAGE('The selected cheque deposits banked successfully.');

                                 END;
                                 END;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760031;1 ;Action    ;
                      CaptionML=ENU=Mail;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                  GenSetup.GET(0);

                                  {SMTPMAIL.NewMessage(GenSetup."Sender Address",GenSetup."Email Subject"+''+'');
                                  SMTPMAIL.SetWorkMode();
                                  SMTPMAIL.ClearAttachments();
                                  SMTPMAIL.ClearAllRecipients();
                                  SMTPMAIL.SetDebugMode();
                                  SMTPMAIL.SetFromAdress('info@stima-sacco.com');
                                  SMTPMAIL.SetHost(GenSetup."Outgoing Mail Server");
                                  SMTPMAIL.SetUserID(GenSetup."Sender User ID");
                                  SMTPMAIL.AddLine(Text1);
                                  SMTPMAIL.SetToAdress('razaaki@gmail.com');
                                  SMTPMAIL.Send;
                                  MESSAGE('the mail server %1',GenSetup."Outgoing Mail Server");   }
                                    //MESSAGE('the e-mail %1',text2);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1000000016;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1000000015;2;Field  ;
                SourceExpr="Account No";
                Editable=FALSE }

    { 1000000014;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr="Account Type";
                Editable=FALSE }

    { 1000000017;2;Field  ;
                SourceExpr="Cheque Drawer" }

    { 1000000012;2;Field  ;
                CaptionML=ENU=Transaction;
                SourceExpr="Transaction Description";
                Editable=FALSE }

    { 1000000011;2;Field  ;
                SourceExpr="Cheque No";
                Editable=FALSE }

    { 1000000010;2;Field  ;
                SourceExpr="Cheque Date";
                Editable=FALSE }

    { 1000000009;2;Field  ;
                SourceExpr="Bank Name";
                Editable=FALSE }

    { 1000000008;2;Field  ;
                SourceExpr="Transaction Date";
                Editable=FALSE }

    { 1000000007;2;Field  ;
                SourceExpr=Amount;
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr="BIH No" }

    { 1000000005;2;Field  ;
                SourceExpr=Select }

    { 1000000004;2;Field  ;
                SourceExpr="Banking Posted" }

    { 1000000002;2;Field  ;
                SourceExpr="Cheque Processed";
                Editable=false }

    { 1000000003;2;Field  ;
                SourceExpr="Dont Clear";
                Editable=FALSE }

    { 1000000001;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr="Expected Maturity Date";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      Transactions@1102760000 : Record 51516299;
      SupervisorApprovals@1102760001 : Record 51516309;
      UsersID@1102760002 : Record 2000000120;
      GenSetup@1102760003 : Record 51516257;
      Text1@1102760005 : TextConst 'ENU=We are sending this mail to test the mail server';
      text2@1102760006 : TextConst 'ENU=kisemy@yahoo.com';

    BEGIN
    END.
  }
}

