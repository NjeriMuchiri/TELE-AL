OBJECT page 172185 Defauter Notification Card
{
  OBJECT-PROPERTIES
  {
    Date=11/10/22;
    Time=10:44:43 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516230;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054017;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1120054018;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054016;1 ;Action    ;
                      Name=Send Message;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendMail;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to send SMS?',TRUE,FALSE) THEN BEGIN
                                 IF SMS.FINDLAST THEN
                                 IEntryNo:=SMS."Entry No"+1
                                 ELSE
                                 IEntryNo:=1;

                                 SMS.INIT;
                                 SMS."Entry No":=IEntryNo;
                                 SMS.Source:='DEFAULTER';
                                 SMS."Telephone No":="Phone No.";
                                 SMS."Account No":="Account No";
                                 SMS."Document No":="Loan  No.";
                                 SMS."Sent To Server":=SMS."Sent To Server"::No;
                                 SMS."Date Entered":=TODAY;
                                 SMS."SMS Message":='Dear, '+"Client Name"+' Kindly clear your Telepost debt of amount Ksh'+FORMAT("Agreed Amount")+' as promised earlier.Call 020-5029204.';
                                 SMS."Time Entered":=TIME;
                                 SMS."Entered By":=USERID;
                                 SMS.INSERT(TRUE);
                                 MESSAGE('Message Sent.');
                                 END;
                               END;
                                }
      { 1120054022;1 ;Action    ;
                      CaptionML=ENU=Recovery Notes;
                      RunObject=page 20374;
                      RunPageLink=Loan No=FIELD(Loan  No.);
                      Promoted=Yes;
                      Image=AddAction;
                      PromotedCategory=Process }
      { 1120054025;1 ;ActionGroup }
      { 1120054024;2 ;Action    ;
                      Name=Statement;
                      CaptionML=ENU=Member Statement;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","BOSA No");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516223,TRUE,FALSE,Cust);
                               END;
                                }
      { 1120054023;2 ;Action    ;
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
                SourceExpr="Loan  No.";
                Editable=false }

    { 1120054003;2;Field  ;
                SourceExpr="Application Date";
                Editable=false }

    { 1120054005;2;Field  ;
                SourceExpr="Client Code";
                Editable=false }

    { 1120054030;2;Field  ;
                SourceExpr="Client Name" }

    { 1120054026;2;Field  ;
                SourceExpr="Staff No";
                Editable=false }

    { 1120054027;2;Field  ;
                SourceExpr="Phone No.";
                Editable=False }

    { 1120054004;2;Field  ;
                SourceExpr="Loan Product Type";
                Editable=false }

    { 1120054031;2;Field  ;
                SourceExpr="Loan Product Type Name" }

    { 1120054006;2;Field  ;
                SourceExpr="Approved Amount";
                Editable=false }

    { 1120054029;2;Field  ;
                SourceExpr="Oustanding Interest" }

    { 1120054028;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054007;2;Field  ;
                SourceExpr="Loans Category";
                Editable=false }

    { 1120054008;2;Field  ;
                SourceExpr="Loans Category-SASRA";
                Editable=false }

    { 1120054009;2;Field  ;
                SourceExpr="Issued Date";
                Editable=false }

    { 1120054012;2;Field  ;
                SourceExpr="Defaulted Balance";
                Editable=false }

    { 1120054011;2;Field  ;
                SourceExpr="Debtor Collection Status" }

    { 1120054010;2;Field  ;
                SourceExpr="Debt Collectors Name" }

    { 1120054019;2;Field  ;
                SourceExpr="Debt Collector Commission";
                Editable=False }

    { 1120054020;2;Field  ;
                SourceExpr="VAT on Commission";
                Editable=False }

    { 1120054021;2;Field  ;
                SourceExpr="Total Collection Amount";
                Editable=False }

    { 1120054013;2;Field  ;
                SourceExpr="Agreed Instalments" }

    { 1120054015;2;Field  ;
                CaptionML=ENU=Agreed Payment Start Date;
                SourceExpr="Payment Date" }

    { 1120054014;2;Field  ;
                SourceExpr="Agreed Amount" }

  }
  CODE
  {
    VAR
      SMS@1120054000 : Record 51516329;
      IEntryNo@1120054001 : Integer;
      Cust@1120054002 : Record 51516223;

    BEGIN
    END.
  }
}

