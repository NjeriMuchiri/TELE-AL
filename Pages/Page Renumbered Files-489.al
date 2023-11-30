OBJECT page 172084 Paybill Reconcilliation Card
{
  OBJECT-PROPERTIES
  {
    Date=12/15/20;
    Time=[ 5:40:51 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516724;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054007;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054008;1 ;Action    ;
                      Name=Import Paybll Statement;
                      RunObject=XMLport 51516016;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=DeactivateDiscounts }
      { 1120054010;1 ;Action    ;
                      Name=Reconcile Lines;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=DisableAllBreakpoints;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to Reconcile all entries?') THEN BEGIN


                                     MpesaRecLines.RESET;
                                     MpesaRecLines.SETRANGE(MpesaRecLines."Entry No.","Entry No.");
                                     MpesaRecLines.SETRANGE(MpesaRecLines.Date,"Start Date","End Date");
                                     IF MpesaRecLines.FINDFIRST THEN BEGIN
                                         REPEAT
                                             MpesaRecLines.Reconciled := FALSE;
                                             MpesaRecLines.Found := FALSE;
                                             MpesaRecLines.MODIFY;
                                         UNTIL MpesaRecLines.NEXT=0;
                                     END;


                                     SkyTransactions.RESET;
                                     SkyTransactions.SETRANGE(SkyTransactions."Transaction Date","Start Date","End Date");
                                     SkyTransactions.SETFILTER(SkyTransactions."Transaction Type",'%1|%2|%3',
                                     SkyTransactions."Transaction Type"::Paybill,SkyTransactions."Transaction Type"::"Loan Repayment",SkyTransactions."Transaction Type"::Withdrawal);
                                     IF SkyTransactions.FINDFIRST THEN BEGIN
                                         REPEAT
                                             SkyTransactions.Reconcilled := FALSE;
                                             SkyTransactions.Found := FALSE;
                                             SkyTransactions.MODIFY;
                                         UNTIL SkyTransactions.NEXT=0;
                                     END;


                                     j := 0;
                                     MpesaRecLines.RESET;
                                     MpesaRecLines.SETRANGE(MpesaRecLines."Entry No.","Entry No.");
                                     MpesaRecLines.SETRANGE(MpesaRecLines.Date,"Start Date","End Date");
                                     MpesaRecLines.SETRANGE(Reconciled,FALSE);
                                     IF MpesaRecLines.FINDFIRST THEN BEGIN
                                         REPEAT
                                             SkyTransactions.RESET;
                                             SkyTransactions.SETRANGE(SkyTransactions."Transaction ID",MpesaRecLines."Receipt No.");
                                             SkyTransactions.SETRANGE(SkyTransactions.Amount,MpesaRecLines.Amount);
                                             SkyTransactions.SETRANGE(SkyTransactions."Transaction Date","Start Date","End Date");
                                             SkyTransactions.SETRANGE(SkyTransactions.Reconcilled,FALSE);
                                             SkyTransactions.SETFILTER(SkyTransactions."Transaction Type",
                                             '%1|%2|%3',SkyTransactions."Transaction Type"::Paybill,SkyTransactions."Transaction Type"::"Loan Repayment",SkyTransactions."Transaction Type"::Withdrawal);
                                             IF SkyTransactions.FINDFIRST THEN BEGIN
                                                 SkyTransactions.Found := TRUE;
                                                 SkyTransactions.MODIFY;

                                                 MpesaRecLines.Found := TRUE;
                                                 MpesaRecLines.MODIFY;
                                                 j+=1;
                                             END;
                                         UNTIL MpesaRecLines.NEXT=0;
                                     END;
                                     MESSAGE('%1 Lines Found',j);
                                 END;
                               END;
                                }
      { 1120054009;1 ;Action    ;
                      Name=Post Reconcilliation;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MaintenanceRegistrations;
                      OnAction=BEGIN

                                 IF CONFIRM('Are you sure you want to Post Reconciled entries?') THEN BEGIN

                                     MpesaRecLines.RESET;
                                     MpesaRecLines.SETRANGE(MpesaRecLines."Entry No.","Entry No.");
                                     MpesaRecLines.SETRANGE(MpesaRecLines.Date,"Start Date","End Date");
                                     MpesaRecLines.SETRANGE(Reconciled,FALSE);
                                     IF MpesaRecLines.FINDFIRST THEN BEGIN

                                         RecLines.RESET;
                                         RecLines.SETRANGE(RecLines."Entry No.","Entry No.");
                                         RecLines.SETRANGE(RecLines.Date,"Start Date","End Date");
                                         RecLines.SETRANGE(Found,FALSE);
                                         IF RecLines.FINDFIRST THEN
                                             ERROR('Unreconcilled Entries Found');

                                         REPEAT
                                             SkyTransactions.RESET;
                                             SkyTransactions.SETRANGE(SkyTransactions."Transaction ID",MpesaRecLines."Receipt No.");
                                             SkyTransactions.SETRANGE(SkyTransactions.Amount,MpesaRecLines.Amount);
                                             SkyTransactions.SETRANGE(SkyTransactions."Transaction Date","Start Date","End Date");
                                             SkyTransactions.SETRANGE(SkyTransactions.Reconcilled,FALSE);
                                             SkyTransactions.SETFILTER(SkyTransactions."Transaction Type",'%1|%2|%3',
                                             SkyTransactions."Transaction Type"::Paybill,SkyTransactions."Transaction Type"::"Loan Repayment",SkyTransactions."Transaction Type"::Withdrawal);
                                             IF SkyTransactions.FINDFIRST THEN BEGIN

                                                 IF NOT SkyTransactions.Posted THEN
                                                     ERROR('You cannot reconcile unposted transactions');

                                                 SkyTransactions.Found := TRUE;
                                                 SkyTransactions.Reconcilled := TRUE;
                                                 SkyTransactions.MODIFY;

                                                 MpesaRecLines.Found := TRUE;
                                                 MpesaRecLines.Reconciled := TRUE;
                                                 MpesaRecLines.MODIFY;
                                             END;
                                         UNTIL MpesaRecLines.NEXT=0;

                                         Reconciled := TRUE;
                                         "Reconciled By" := USERID;
                                         MODIFY;
                                     END;

                                     MESSAGE('Process Completed');
                                 END;
                               END;
                                }
      { 1120054015;1 ;Action    ;
                      Name=Clear MPESA Lines;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=DisableAllBreakpoints;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to Clear all entries?') THEN BEGIN


                                     MpesaRecLines.RESET;
                                     MpesaRecLines.SETRANGE(MpesaRecLines."Entry No.","Entry No.");
                                     MpesaRecLines.SETRANGE(MpesaRecLines.Date,"Start Date","End Date");
                                     IF MpesaRecLines.FINDFIRST THEN BEGIN
                                         REPEAT
                                             MpesaRecLines.DELETE;
                                         UNTIL MpesaRecLines.NEXT=0;
                                     END;

                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="Entry No." }

    { 1120054003;2;Field  ;
                SourceExpr="Start Date" }

    { 1120054006;2;Field  ;
                SourceExpr="End Date" }

    { 1120054004;2;Field  ;
                SourceExpr=Reconciled }

    { 1120054005;2;Field  ;
                SourceExpr="Reconciled By" }

    { 1120054011;1;Group  ;
                GroupType=Group }

    { 1120054012;2;Part   ;
                SubPageLink=Entry No.=FIELD(Entry No.);
                PagePartID=Page51516730;
                PartType=Page }

    { 1120054013;2;Part   ;
                PagePartID=Page51516731;
                PartType=Page }

  }
  CODE
  {
    VAR
      SkyTransactions@1120054000 : Record 51516712;
      MpesaRecLines@1120054001 : Record 51516725;
      RecLines@1120054002 : Record 51516725;
      j@1120054003 : Integer;
      k@1120054004 : Integer;

    BEGIN
    END.
  }
}

