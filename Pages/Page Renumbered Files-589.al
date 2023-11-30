OBJECT page 172184 Defaulter SMS Notification
{
  OBJECT-PROPERTIES
  {
    Date=02/02/23;
    Time=[ 2:49:10 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516230;
    SourceTableView=WHERE(Loans Category=FILTER(Substandard|Doubtful|Loss));
    PageType=List;
    CardPageID=Defauter Notification Card;
    OnAfterGetRecord=BEGIN
                       //Rec.SETFILTER("Notification Date",'>=%1',TODAY);
                       UserSetup.GET(USERID);
                       IF UserSetup."Loan Porfolio Manager"=FALSE THEN BEGIN
                       DebtCollectorsDetails.SETRANGE(DebtCollectorsDetails.UserID,USERID);
                       IF DebtCollectorsDetails.FINDFIRST THEN BEGIN
                       Rec.SETFILTER(Rec."Debt Collectors Name",DebtCollectorsDetails."Collectors Name");
                       END ELSE BEGIN
                       ERROR('You do not have permmission to vie this list.');
                       END;
                       END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           // Rec.SETFILTER("Notification Date",'>=%1',TODAY);
                           UserSetup.GET(USERID);
                           IF UserSetup."Loan Porfolio Manager"=FALSE THEN BEGIN
                           DebtCollectorsDetails.SETRANGE(DebtCollectorsDetails.UserID,USERID);
                           IF DebtCollectorsDetails.FINDFIRST THEN BEGIN
                           Rec.SETFILTER(Rec."Debt Collectors Name",DebtCollectorsDetails."Collectors Name");
                           END ELSE BEGIN
                           ERROR('You do not have permmission to vie this list.');
                           END;
                           END;
                         END;

  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Loan  No." }

    { 1120054003;2;Field  ;
                SourceExpr="Application Date" }

    { 1120054004;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1120054005;2;Field  ;
                SourceExpr="Client Code" }

    { 1120054006;2;Field  ;
                SourceExpr="Requested Amount" }

    { 1120054007;2;Field  ;
                SourceExpr="Approved Amount" }

    { 1120054008;2;Field  ;
                SourceExpr="Issued Date" }

    { 1120054009;2;Field  ;
                SourceExpr="Loans Category" }

    { 1120054010;2;Field  ;
                SourceExpr="Debt Collectors Name" }

    { 1120054011;2;Field  ;
                SourceExpr="Debtor Collection Status" }

  }
  CODE
  {
    VAR
      PeriodDate@1120054000 : Date;
      DateFilter@1120054001 : Text;
      DebtCollectorsDetails@1120054003 : Record 51516918;
      UserSetup@1120054002 : Record 91;

    BEGIN
    END.
  }
}

