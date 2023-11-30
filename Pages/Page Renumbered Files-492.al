OBJECT page 172087 Mobile Loans Analysis
{
  OBJECT-PROPERTIES
  {
    Date=05/25/21;
    Time=[ 8:07:58 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516718;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054023;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054024;1 ;Action    ;
                      Name=Mobile Loans Report;
                      RunObject=Report 51516700;
                      Promoted=Yes;
                      Image=AvailableToPromise;
                      PromotedCategory=Report }
      { 1120054030;1 ;Action    ;
                      Name=Mark Deposit Refunded;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to Mark Deposit Refunded. This will allow this Member to access other SACCO loans') THEN BEGIN
                                     "Deposits Refunded" := TRUE;
                                     "Dep. Refund. Updated By" := USERID;
                                     MODIFY;
                                     CustomerRecord.GET("Member No");
                                     CustomerRecord."Loan Defaulter":=FALSE;
                                     CustomerRecord.MODIFY;
                                     MESSAGE('Updated');
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
                SourceExpr="Loan No." }

    { 1120054003;2;Field  ;
                SourceExpr="Document Date" }

    { 1120054004;2;Field  ;
                SourceExpr="Loan Amount" }

    { 1120054005;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054006;2;Field  ;
                SourceExpr="Time Entered" }

    { 1120054007;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054008;2;Field  ;
                SourceExpr="Account No" }

    { 1120054009;2;Field  ;
                SourceExpr="Member No" }

    { 1120054031;2;Field  ;
                SourceExpr="Staff No." }

    { 1120054010;2;Field  ;
                SourceExpr="Telephone No" }

    { 1120054011;2;Field  ;
                SourceExpr="Customer Name" }

    { 1120054012;2;Field  ;
                SourceExpr=Comments }

    { 1120054013;2;Field  ;
                SourceExpr="Entry No" }

    { 1120054014;2;Field  ;
                SourceExpr="Next Loan Application Date" }

    { 1120054015;2;Field  ;
                SourceExpr=Penalized }

    { 1120054016;2;Field  ;
                SourceExpr="Penalty Date" }

    { 1120054017;2;Field  ;
                SourceExpr="Last Notification" }

    { 1120054018;2;Field  ;
                SourceExpr="Next Notification" }

    { 1120054019;2;Field  ;
                SourceExpr="Loan Product Type" }

    { 1120054020;2;Field  ;
                SourceExpr="New Rate" }

    { 1120054021;2;Field  ;
                SourceExpr="Loan Limit" }

    { 1120054022;2;Field  ;
                SourceExpr="Amount Recovered From BOSA" }

    { 1120054026;2;Field  ;
                SourceExpr="Deposits Recovered" }

    { 1120054025;2;Field  ;
                SourceExpr="Amount  Recovered From FOSA" }

    { 1120054027;2;Field  ;
                SourceExpr="FOSA Balance" }

    { 1120054028;2;Field  ;
                SourceExpr="Deposits Refunded";
                Editable=false }

    { 1120054029;2;Field  ;
                SourceExpr="Dep. Refund. Updated By";
                Editable=false }

  }
  CODE
  {
    VAR
      CustomerRecord@1120054000 : Record 51516223;

    BEGIN
    END.
  }
}

