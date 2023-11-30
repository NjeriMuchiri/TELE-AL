OBJECT page 172182 Defaulted Loans List
{
  OBJECT-PROPERTIES
  {
    Date=07/12/23;
    Time=10:00:53 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516230;
    PageType=List;
    CardPageID=Defauter Card;
    OnAfterGetRecord=BEGIN
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

    ActionList=ACTIONS
    {
      { 1120054021;  ;ActionContainer;
                      Name=Action;
                      ActionContainerType=NewDocumentItems }
      { 1120054019;1 ;Action    ;
                      CaptionML=ENU=Send 1st Defaulter Notice;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Alerts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Register.RESET;
                                 Register.SETRANGE(Register."Loan  No.","Loan  No.");
                                 IF Register.FINDFIRST THEN BEGIN
                                 REPORT.RUN(51516235,TRUE,FALSE,Register);
                                 END;
                               END;
                                }
      { 1120054018;1 ;Action    ;
                      CaptionML=ENU=Send 2nd Defaulter Notice;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Alerts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Register.RESET;
                                 Register.SETRANGE(Register."Loan  No.","Loan  No.");
                                 IF Register.FINDFIRST THEN BEGIN
                                 REPORT.RUN(51516236,TRUE,FALSE,Register);
                                 END;
                               END;
                                }
      { 1120054004;1 ;Action    ;
                      CaptionML=ENU=Send 3rd Defaulter Notice;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Alerts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Register.RESET;
                                 Register.SETRANGE(Register."Loan  No.","Loan  No.");
                                 IF Register.FINDFIRST THEN BEGIN
                                 REPORT.RUN(51516237,TRUE,FALSE,Register);
                                 END;
                               END;
                                }
      { 1120054024;1 ;Action    ;
                      Name=Statement2;
                      CaptionML=ENU=Detailed Statement;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","BOSA No");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516884,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054012;1 ;Action    ;
                      Name=FOSA Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","BOSA No");
                                 IF Cust.FIND('-') THEN BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.",Cust."FOSA Account");
                                 IF Vend.FINDFIRST THEN
                                   BEGIN
                                     CatchStaff();
                                     REPORT.RUN(50230,TRUE,FALSE,Vend);;
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
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Loan  No." }

    { 1120054003;2;Field  ;
                SourceExpr="Application Date" }

    { 1120054017;2;Field  ;
                SourceExpr="Loan Product Type Name" }

    { 1120054011;2;Field  ;
                SourceExpr="Staff No" }

    { 1120054005;2;Field  ;
                SourceExpr="Client Code" }

    { 1120054014;2;Field  ;
                SourceExpr="Client Name" }

    { 1120054025;2;Field  ;
                SourceExpr="Phone No." }

    { 1120054015;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054016;2;Field  ;
                SourceExpr="Oustanding Interest" }

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

    { 1120054013;2;Field  ;
                SourceExpr="Debtor Collection Status" }

    { 1120054020;2;Field  ;
                SourceExpr="1st Notice" }

    { 1120054022;2;Field  ;
                SourceExpr="2nd Notice" }

    { 1120054023;2;Field  ;
                SourceExpr="Final Notice" }

  }
  CODE
  {
    VAR
      DebtCollectorsDetails@1120054000 : Record 51516918;
      UserSetup@1120054001 : Record 91;
      Register@1120054002 : Record 51516230;
      Cust@1120054004 : Record 51516223;
      Vend@1120054003 : Record 23;

    PROCEDURE CatchStaff@1000000003();
    BEGIN
    END;

    BEGIN
    END.
  }
}

