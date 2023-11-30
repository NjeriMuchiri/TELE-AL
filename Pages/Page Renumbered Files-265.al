OBJECT page 17456 Bankers Cheque Schedule
{
  OBJECT-PROPERTIES
  {
    Date=08/15/16;
    Time=[ 3:40:36 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516299;
    SourceTableView=WHERE(Type=CONST(Bankers Cheque),
                          Posted=CONST(Yes),
                          Banking Posted=CONST(No));
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnOpenPage=BEGIN
                 //Filter based on branch
                 {IF UsersID.GET(USERID) THEN BEGIN
                 IF UsersID.Branch <> '' THEN
                 SETRANGE("Transacting Branch",UsersID.Branch);
                 END;}
                 //Filter based on branch
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760027;1 ;ActionGroup;
                      CaptionML=ENU=Banker Cheque }
      { 1102760028;2 ;Action    ;
                      CaptionML=ENU=Bankers Cheque Schedule;
                      Visible=FALSE }
      { 1102760029;2 ;Separator  }
      { 1102760030;2 ;Action    ;
                      CaptionML=ENU=Process Banking;
                      Promoted=Yes;
                      Image=PutawayLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to Bank the selected cheques?',FALSE) = TRUE THEN BEGIN

                                 Transactions.RESET;
                                 Transactions.SETRANGE(Type,'Bankers Cheque');
                                 Transactions.SETRANGE(Transactions.Select,TRUE);
                                 //Transactions.SETRANGE(Transactions."Cheque Processed",Transactions."Cheque Processed"::"0");
                                 IF Transactions.FIND('-') THEN BEGIN
                                 REPEAT

                                 Transactions."Banked By":=USERID;
                                 Transactions."Date Banked":=TODAY;
                                 Transactions."Time Banked":=TIME;
                                 Transactions."Banking Posted":=TRUE;
                                 Transactions."Cheque Processed":=Transactions."Cheque Processed"::"1";
                                 Transactions.MODIFY;
                                 UNTIL Transactions.NEXT = 0;

                                 MESSAGE('The selected bankers cheques banked successfully.');

                                 END;
                                 END;
                               END;
                                }
      { 1102760038;2 ;Separator  }
      { 1102760039;2 ;Action    ;
                      CaptionML=ENU=Commitement Cheque Schedule;
                      Visible=false }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102756000;1 ;Action    ;
                      CaptionML=ENU=Select All;
                      Promoted=Yes;
                      Image=SelectEntries;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Transactions.RESET;
                                 Transactions.SETRANGE(Type,'Bankers Cheque');
                                 Transactions.SETRANGE(Transactions.Select,FALSE);
                                 IF Transactions.FIND('-') THEN BEGIN
                                 REPEAT

                                 Transactions.Select:=TRUE;
                                 Transactions.MODIFY;
                                 UNTIL Transactions.NEXT = 0;

                                 MESSAGE('Bankers cheques selected successfully.');

                                 END;
                               END;
                                }
      { 1000000000;1 ;Action    ;
                      Name=Bankers Cheque;
                      RunObject=Report 51516434;
                      Promoted=Yes;
                      Image=report;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                GroupType=Repeater }

    { 16  ;2   ;Field     ;
                SourceExpr=No;
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                SourceExpr="Account No";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                CaptionML=ENU=Staff No;
                SourceExpr="Staff/Payroll No";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                SourceExpr=Payee;
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                SourceExpr="Account Type";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                CaptionML=ENU=Transaction;
                SourceExpr="Transaction Description";
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                SourceExpr="Bankers Cheque No" }

    { 8   ;2   ;Field     ;
                SourceExpr="Other Bankers No." }

    { 7   ;2   ;Field     ;
                SourceExpr="Cheque Date";
                Editable=TRUE }

    { 6   ;2   ;Field     ;
                SourceExpr=Amount;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="Reference No";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr=Remarks;
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                SourceExpr="Transaction Date";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                SourceExpr="BIH No" }

    { 1   ;2   ;Field     ;
                SourceExpr=Select;
                Editable=TRUE }

  }
  CODE
  {
    VAR
      Transactions@1102760000 : Record 51516299;
      SupervisorApprovals@1102760001 : Record 51516309;
      UsersID@1102760002 : Record 2000000120;

    BEGIN
    END.
  }
}

