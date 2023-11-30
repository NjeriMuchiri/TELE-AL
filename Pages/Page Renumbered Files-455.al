OBJECT page 172050 Mobile Loans
{
  OBJECT-PROPERTIES
  {
    Date=07/17/20;
    Time=[ 1:15:46 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516094;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054027;  ;ActionContainer;
                      CaptionML=ENU=new;
                      ActionContainerType=NewDocumentItems }
      { 1120054028;1 ;Action    ;
                      Name=Disbursment Report;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PaymentHistory;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ObjMobileLoans.RESET;
                                 ObjMobileLoans.SETRANGE(ObjMobileLoans.Status,ObjMobileLoans.Status::Completed);
                                 IF ObjMobileLoans.FIND('-') THEN BEGIN
                                   REPORT.RUN(51516848,TRUE,FALSE,ObjMobileLoans)
                                   //REPORT.RUN(
                                 END;
                               END;
                                }
      { 1120054029;1 ;Action    ;
                      Name=Loan Recovered From Deposits;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PeriodEntries;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ObjMobileLoans.RESET;
                                 ObjMobileLoans.SETRANGE(ObjMobileLoans.Penalized,TRUE);
                                 IF ObjMobileLoans.FIND('-') THEN BEGIN
                                   REPORT.RUN(51516848,TRUE,FALSE,ObjMobileLoans)
                                   //REPORT.RUN(
                                 END;
                               END;
                                }
      { 1120054030;1 ;Action    ;
                      Name=Penalized Members;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Error;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ObjMobileLoans.RESET;
                                 ObjMobileLoans.SETRANGE(ObjMobileLoans.Penalized,TRUE);
                                 IF ObjMobileLoans.FIND('-') THEN BEGIN
                                   REPORT.RUN(51516848,TRUE,FALSE,ObjMobileLoans)
                                   //REPORT.RUN(
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
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Document No" }

    { 1120054003;2;Field  ;
                SourceExpr="Document Date" }

    { 1120054004;2;Field  ;
                SourceExpr="Loan Amount" }

    { 1120054005;2;Field  ;
                SourceExpr="Batch No" }

    { 1120054006;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054007;2;Field  ;
                SourceExpr="Time Entered" }

    { 1120054008;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054009;2;Field  ;
                SourceExpr="Sent To Server" }

    { 1120054010;2;Field  ;
                SourceExpr="Date Sent To Server" }

    { 1120054011;2;Field  ;
                SourceExpr="Time Sent To Server" }

    { 1120054012;2;Field  ;
                SourceExpr="Account No" }

    { 1120054013;2;Field  ;
                SourceExpr="Member No" }

    { 1120054014;2;Field  ;
                SourceExpr="Telephone No" }

    { 1120054015;2;Field  ;
                SourceExpr="Corporate No" }

    { 1120054016;2;Field  ;
                SourceExpr="Delivery Center" }

    { 1120054017;2;Field  ;
                SourceExpr="Customer Name" }

    { 1120054018;2;Field  ;
                SourceExpr=Purpose }

    { 1120054019;2;Field  ;
                SourceExpr="MPESA Doc No." }

    { 1120054020;2;Field  ;
                SourceExpr=Comments }

    { 1120054021;2;Field  ;
                SourceExpr=Status }

    { 1120054022;2;Field  ;
                SourceExpr="Entry No" }

    { 1120054023;2;Field  ;
                SourceExpr="Ist Notification" }

    { 1120054024;2;Field  ;
                SourceExpr="2nd Notification" }

    { 1120054025;2;Field  ;
                SourceExpr="3rd Notification" }

    { 1120054026;2;Field  ;
                SourceExpr="Penalty Date" }

  }
  CODE
  {
    VAR
      ObjMobileLoans@1120054000 : Record 51516094;

    BEGIN
    END.
  }
}

