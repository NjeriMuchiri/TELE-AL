OBJECT page 50046 Withdrawal Sub-Page List
{
  OBJECT-PROPERTIES
  {
    Date=08/26/21;
    Time=[ 2:00:30 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516259;
    PageType=ListPart;
    OnClosePage=BEGIN
                  cust.RESET;
                  cust.SETRANGE(cust."No.","Member No.");
                  IF cust.FINDSET THEN  BEGIN
                  REPEAT
                  cust.CALCFIELDS(cust."Current Savings",cust."School Fees Shares",cust."Outstanding Balance",cust."Outstanding Interest");
                    "Member Deposits":=cust."Current Savings";
                    "Total Loan":=cust."Outstanding Balance";
                    "Total Interest":=cust."Outstanding Interest";
                     "Net Refund":=("Member Deposits")-("Total Loan"+0);
                   MODIFY;
                   //MESSAGE('MODIFIED');
                     UNTIL cust.NEXT=0;
                     END;
                END;

    OnAfterGetRecord=BEGIN
                       cust.RESET;
                       cust.SETRANGE(cust."No.","Member No.");
                       IF cust.FINDSET THEN  BEGIN
                       REPEAT
                       cust.CALCFIELDS(cust."Current Savings",cust."School Fees Shares",cust."Outstanding Balance",cust."Outstanding Interest");
                         "Member Deposits":=cust."Current Savings";
                         "Total Loan":=cust."Outstanding Balance";
                         "Total Interest":=cust."Outstanding Interest";
                          "Net Refund":=("Member Deposits")-("Total Loan"+0);
                         //MODIFY;
                          UNTIL cust.NEXT=0;
                          END;

                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1120054000;2;Field  ;
                SourceExpr="No." }

    { 1120054001;2;Field  ;
                SourceExpr="Member No." }

    { 1120054002;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054003;2;Field  ;
                SourceExpr="Closing Date" }

    { 1120054004;2;Field  ;
                SourceExpr=Status }

    { 1120054005;2;Field  ;
                SourceExpr=Posted }

    { 1120054006;2;Field  ;
                SourceExpr="Total Loan" }

    { 1120054007;2;Field  ;
                SourceExpr="Total Interest" }

    { 1120054008;2;Field  ;
                SourceExpr="Member Deposits";
                OnValidate=BEGIN
                             cust.RESET;
                             cust.SETRANGE(cust."No.","Member No.");
                             IF cust.FINDSET THEN  BEGIN
                             REPEAT
                             cust.CALCFIELDS(cust."Current Savings",cust."School Fees Shares",cust."Outstanding Balance",cust."Outstanding Interest");
                               "Member Deposits":=cust."Current Savings";
                               "Total Loan":=cust."Outstanding Balance";
                               "Total Interest":=cust."Outstanding Interest";
                                "Net Refund":=("Member Deposits")-("Total Loan");
                               memwith.MODIFY;
                                UNTIL cust.NEXT=0;
                                END;
                           END;
                            }

    { 1120054009;2;Field  ;
                SourceExpr="No. Series" }

    { 1120054010;2;Field  ;
                SourceExpr="Closure Type" }

    { 1120054011;2;Field  ;
                SourceExpr="Mode Of Disbursement" }

    { 1120054012;2;Field  ;
                SourceExpr="Paying Bank" }

    { 1120054013;2;Field  ;
                SourceExpr="Cheque No." }

    { 1120054014;2;Field  ;
                SourceExpr="FOSA Account No." }

    { 1120054015;2;Field  ;
                SourceExpr=Payee }

    { 1120054016;2;Field  ;
                SourceExpr="Net Pay" }

    { 1120054017;2;Field  ;
                SourceExpr="BBF Amount" }

    { 1120054018;2;Field  ;
                SourceExpr="Amount to withhold" }

    { 1120054019;2;Field  ;
                SourceExpr="Effective Date" }

    { 1120054020;2;Field  ;
                SourceExpr="Service Charge" }

    { 1120054021;2;Field  ;
                SourceExpr="Withdrawable savings Scheme" }

    { 1120054022;2;Field  ;
                SourceExpr="Approved By" }

    { 1120054023;2;Field  ;
                SourceExpr="Captured By" }

    { 1120054024;2;Field  ;
                SourceExpr="Notice Date" }

    { 1120054025;2;Field  ;
                SourceExpr="Due Date" }

    { 1120054026;2;Field  ;
                SourceExpr="Payroll/Staff No" }

    { 1120054027;2;Field  ;
                SourceExpr="ID No." }

    { 1120054028;2;Field  ;
                SourceExpr="ID No.2" }

    { 1120054029;2;Field  ;
                SourceExpr="Payroll/Staff No2" }

    { 1120054030;2;Field  ;
                SourceExpr="Date Filter2" }

    { 1120054031;2;Field  ;
                SourceExpr="Date Filter" }

    { 1120054032;2;Field  ;
                SourceExpr="Guarantorship Check" }

    { 1120054033;2;Field  ;
                SourceExpr="Current Shares" }

    { 1120054034;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1120054035;2;Field  ;
                SourceExpr="Outstanding Interest" }

    { 1120054036;2;Field  ;
                SourceExpr="Principle Balance" }

    { 1120054042;2;Field  ;
                Name=ESS Deposits;
                CaptionML=ENU=ESS Deposits;
                SourceExpr="ESS Deposits"."School Fees Shares" }

    { 1120054037;2;Field  ;
                SourceExpr="Withdrawal Status" }

    { 1120054038;2;Field  ;
                SourceExpr=Registered }

    { 1120054039;2;Field  ;
                SourceExpr="Date Registered" }

    { 1120054040;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054041;2;Field  ;
                SourceExpr="Net Refund" }

  }
  CODE
  {
    VAR
      LoanType@1000000000 : Record 51516240;
      NoSeriesMgt@1000000001 : Codeunit 396;
      "ESS Deposits"@1120054000 : Record 51516223;
      cust@1120054001 : Record 51516223;
      memwith@1120054002 : Record 51516259;

    PROCEDURE GetVariables@1000000000(VAR LoanNo@1000000000 : Code[20];VAR MemberNo@1102760000 : Code[20]);
    BEGIN
      LoanNo:="No.";
      //LoanProductType:="Loan Product Type";
      MemberNo:="Member No.";
    END;

    BEGIN
    END.
  }
}

