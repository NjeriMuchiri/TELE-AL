OBJECT page 17438 Cashier Trans Authorisations
{
  OBJECT-PROPERTIES
  {
    Date=05/31/16;
    Time=[ 4:09:10 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516299;
    SourceTableView=WHERE(Supervisor Checked=CONST(No),
                          Needs Approval=CONST(Yes),
                          Post Attempted=CONST(Yes));
    PageType=List;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Transacting Branch",UsersID.Branch);
                 END; }
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760028;1 ;ActionGroup;
                      CaptionML=ENU=View }
      { 1102760029;2 ;Action    ;
                      CaptionML=ENU=Account Card;
                      RunObject=page 20497;
                      RunPageLink=No=FIELD(Account No) }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760030;1 ;Action    ;
                      CaptionML=ENU=Send Mail;
                      Promoted=Yes;
                      Visible=false;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                  MailContent:='Transaction of Kshs.' + ' '+FORMAT(Amount)+' ' +'for'+' '+"Account Name"+
                                  ' '+'has been authorized.';


                                   SENDMAIL;
                               END;
                                }
      { 1102760024;1 ;Action    ;
                      CaptionML=ENU=Process;
                      Promoted=Yes;
                      Image=PutawayLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to process the selected transactions?',FALSE) = TRUE THEN BEGIN

                                 Transactions.RESET;
                                 Transactions.SETRANGE(Transactions.Select,TRUE);
                                 Transactions.SETRANGE(Transactions."Supervisor Checked",FALSE);
                                 Transactions.SETRANGE(Transactions."Needs Approval",Transactions."Needs Approval"::Yes);
                                 IF Transactions.FIND('-') THEN
                                 REPEAT

                                  Transactions.Authorised:=Transactions.Authorised::Yes;
                                 //Check authorisation limits
                                 IF Transactions.Authorised<>Transactions.Authorised::No THEN BEGIN
                                 SupervisorApprovals.RESET;
                                 SupervisorApprovals.SETRANGE(SupervisorApprovals.SupervisorID,UPPERCASE(USERID));
                                 IF Transactions."Transaction Type" = 'Cash Deposit' THEN
                                 SupervisorApprovals.SETRANGE(SupervisorApprovals."Transaction Type",SupervisorApprovals."Transaction Type"::"Cash Deposits");
                                 IF Transactions."Transaction Type" = 'Cheque Deposit' THEN
                                 SupervisorApprovals.SETRANGE(SupervisorApprovals."Transaction Type",SupervisorApprovals."Transaction Type"::"Cheque Deposits");
                                 IF Transactions."Transaction Type" = 'Withdrawal' THEN
                                 SupervisorApprovals.SETRANGE(SupervisorApprovals."Transaction Type",SupervisorApprovals."Transaction Type"::Withdrawals);
                                 IF SupervisorApprovals.FIND('-') THEN BEGIN
                                 IF Transactions.Amount > SupervisorApprovals."Maximum Approval Amount" THEN
                                 ERROR('You cannot approve the deposit because it is above your approval limit.');
                                 END ELSE BEGIN
                                 ERROR('You are not authorised to approve the selected deposits.');
                                 END;
                                 Transactions."Supervisor Checked":=TRUE;
                                 Transactions."Status Date":=TODAY;
                                 Transactions."Status Time":=TIME;
                                 Transactions."Checked By":=USERID;
                                 Transactions.MODIFY;

                                 IF Transactions."Authorisation Requirement" = 'Withdrawal Freq.' THEN
                                 Transactions."Withdrawal FrequencyAuthorised":=Transactions."Withdrawal FrequencyAuthorised"::Yes;
                                 Transactions."Supervisor Checked":=TRUE;
                                 Transactions."Status Date":=TODAY;
                                 Transactions."Status Time":=TIME;
                                 Transactions."Checked By":=USERID;
                                 Transactions.MODIFY;
                                 END;

                                 UNTIL Transactions.NEXT = 0;

                                 SENDMAIL;
                                 MESSAGE('The selected transactions have been processed.');

                                 END;
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

    { 1102760001;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1102760003;2;Field  ;
                SourceExpr="Account No";
                Editable=FALSE }

    { 1102760005;2;Field  ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 1102760007;2;Field  ;
                SourceExpr="Account Type";
                Editable=FALSE }

    { 1102760023;2;Field  ;
                CaptionML=ENU=Transaction;
                SourceExpr="Transaction Description";
                Editable=FALSE }

    { 1102760009;2;Field  ;
                SourceExpr=Amount;
                Editable=FALSE }

    { 1102760011;2;Field  ;
                SourceExpr=Cashier;
                Editable=FALSE }

    { 1102760013;2;Field  ;
                CaptionML=ENU=Date;
                SourceExpr="Transaction Date";
                Editable=FALSE }

    { 1102760015;2;Field  ;
                CaptionML=ENU=Time;
                SourceExpr="Transaction Time";
                Editable=FALSE }

    { 1102760026;2;Field  ;
                CaptionML=ENU=Authorisation Req.;
                SourceExpr="Authorisation Requirement";
                Editable=FALSE }

    { 1102760017;2;Field  ;
                SourceExpr=Authorised }

    { 1102760019;2;Field  ;
                SourceExpr=Select }

  }
  CODE
  {
    VAR
      Transactions@1102760000 : Record 51516299;
      SupervisorApprovals@1102760001 : Record 51516309;
      UsersID@1102760002 : Record 2000000120;
      "Gen-Setup"@1102760003 : Record 51516257;
      SendToAddress@1102760005 : Text[30];
      BankAccount@1102760006 : Record 270;
      MailContent@1102760007 : Text[150];

    PROCEDURE SENDMAIL@1102760000();
    BEGIN
      //sent mail on authorisation
      {
      BankAccount.RESET;
      BankAccount.SETRANGE(BankAccount."Cashier ID",Cashier);
      IF BankAccount.FIND('-') THEN BEGIN
      REPEAT
      MailContent:='Transaction' + ' '+'TR. No.'+' '+No+' ' + 'of Kshs'+ ' '+ FORMAT(Amount) + ' '+ 'for'
      +' ' +"Account Name"+' '+'has been authorized';

      "Gen-Setup".GET();
      SMTPMAIL.NewMessage("Gen-Setup"."Sender Address",'AUTHORISED TRANSACTION'+''+'');
      SMTPMAIL.SetWorkMode();
      SMTPMAIL.ClearAttachments();
      SMTPMAIL.ClearAllRecipients();
      SMTPMAIL.SetDebugMode();
      SMTPMAIL.SetFromAdress("Gen-Setup"."Sender Address");
      SMTPMAIL.SetHost("Gen-Setup"."Outgoing Mail Server");
      SMTPMAIL.SetUserID("Gen-Setup"."Sender User ID");
      SMTPMAIL.AddLine(MailContent);
      SendToAddress:=BankAccount."E-Mail";
      SMTPMAIL.SetToAdress(SendToAddress);
      SMTPMAIL.Send;
      UNTIL BankAccount.NEXT=0;
      END;
      }
    END;

    BEGIN
    END.
  }
}

