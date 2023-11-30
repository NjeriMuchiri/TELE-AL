OBJECT page 20373 Member Ledger Entries.
{
  OBJECT-PROPERTIES
  {
    Date=03/03/23;
    Time=[ 1:33:47 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516224;
    SourceTableView=SORTING(Entry No.)
                    ORDER(Descending);
    PageType=List;
    OnAfterGetRecord=BEGIN
                       Rec.SETRANGE("Posting Date",TODAY);
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
                SourceExpr="Entry No." }

    { 1120054003;2;Field  ;
                SourceExpr="Customer No." }

    { 1120054004;2;Field  ;
                SourceExpr="Posting Date" }

    { 1120054005;2;Field  ;
                SourceExpr="Document Type" }

    { 1120054006;2;Field  ;
                SourceExpr="Document No." }

    { 1120054007;2;Field  ;
                SourceExpr=Description }

    { 1120054008;2;Field  ;
                SourceExpr="Currency Code" }

    { 1120054009;2;Field  ;
                SourceExpr=Amount }

    { 1120054010;2;Field  ;
                SourceExpr="Remaining Amount" }

    { 1120054011;2;Field  ;
                SourceExpr="Original Amt. (LCY)" }

    { 1120054012;2;Field  ;
                SourceExpr="Remaining Amt. (LCY)" }

    { 1120054013;2;Field  ;
                SourceExpr="Amount (LCY)" }

    { 1120054014;2;Field  ;
                SourceExpr="Sales (LCY)" }

    { 1120054015;2;Field  ;
                SourceExpr="Profit (LCY)" }

    { 1120054016;2;Field  ;
                SourceExpr="Inv. Discount (LCY)" }

    { 1120054017;2;Field  ;
                SourceExpr="Sell-to Customer No." }

    { 1120054018;2;Field  ;
                SourceExpr="Customer Posting Group" }

    { 1120054019;2;Field  ;
                SourceExpr="Global Dimension 1 Code" }

    { 1120054020;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1120054021;2;Field  ;
                SourceExpr="Salesperson Code" }

    { 1120054022;2;Field  ;
                SourceExpr="User ID" }

    { 1120054023;2;Field  ;
                SourceExpr="Source Code" }

    { 1120054024;2;Field  ;
                SourceExpr="On Hold" }

    { 1120054025;2;Field  ;
                SourceExpr="Applies-to Doc. Type" }

    { 1120054026;2;Field  ;
                SourceExpr="Applies-to Doc. No." }

    { 1120054027;2;Field  ;
                SourceExpr=Open }

    { 1120054028;2;Field  ;
                SourceExpr="Due Date" }

    { 1120054029;2;Field  ;
                SourceExpr="Pmt. Discount Date" }

    { 1120054030;2;Field  ;
                SourceExpr="Original Pmt. Disc. Possible" }

    { 1120054031;2;Field  ;
                SourceExpr="Pmt. Disc. Given (LCY)" }

    { 1120054032;2;Field  ;
                SourceExpr=Positive }

    { 1120054033;2;Field  ;
                SourceExpr="Closed by Entry No." }

    { 1120054034;2;Field  ;
                SourceExpr="Closed at Date" }

    { 1120054035;2;Field  ;
                SourceExpr="Closed by Amount" }

    { 1120054036;2;Field  ;
                SourceExpr="Applies-to ID" }

    { 1120054037;2;Field  ;
                SourceExpr="Journal Batch Name" }

    { 1120054038;2;Field  ;
                SourceExpr="Reason Code" }

    { 1120054039;2;Field  ;
                SourceExpr="Bal. Account Type" }

    { 1120054040;2;Field  ;
                SourceExpr="Bal. Account No." }

    { 1120054041;2;Field  ;
                SourceExpr="Transaction No." }

    { 1120054042;2;Field  ;
                SourceExpr="Closed by Amount (LCY)" }

    { 1120054043;2;Field  ;
                SourceExpr="Debit Amount" }

    { 1120054044;2;Field  ;
                SourceExpr="Credit Amount" }

    { 1120054045;2;Field  ;
                SourceExpr="Debit Amount (LCY)" }

    { 1120054046;2;Field  ;
                SourceExpr="Credit Amount (LCY)" }

    { 1120054047;2;Field  ;
                SourceExpr="Document Date" }

    { 1120054048;2;Field  ;
                SourceExpr="External Document No." }

    { 1120054049;2;Field  ;
                SourceExpr="Calculate Interest" }

    { 1120054050;2;Field  ;
                SourceExpr="Closing Interest Calculated" }

    { 1120054051;2;Field  ;
                SourceExpr="No. Series" }

    { 1120054052;2;Field  ;
                SourceExpr="Closed by Currency Code" }

    { 1120054053;2;Field  ;
                SourceExpr="Closed by Currency Amount" }

    { 1120054054;2;Field  ;
                SourceExpr="Adjusted Currency Factor" }

    { 1120054055;2;Field  ;
                SourceExpr="Original Currency Factor" }

    { 1120054056;2;Field  ;
                SourceExpr="Original Amount" }

    { 1120054057;2;Field  ;
                SourceExpr="Date Filter" }

    { 1120054058;2;Field  ;
                SourceExpr="Remaining Pmt. Disc. Possible" }

    { 1120054059;2;Field  ;
                SourceExpr="Pmt. Disc. Tolerance Date" }

    { 1120054060;2;Field  ;
                SourceExpr="Max. Payment Tolerance" }

    { 1120054061;2;Field  ;
                SourceExpr="Last Issued Reminder Level" }

    { 1120054062;2;Field  ;
                SourceExpr="Accepted Payment Tolerance" }

    { 1120054063;2;Field  ;
                SourceExpr="Accepted Pmt. Disc. Tolerance" }

    { 1120054064;2;Field  ;
                SourceExpr="Pmt. Tolerance (LCY)" }

    { 1120054065;2;Field  ;
                SourceExpr="Amount to Apply" }

    { 1120054066;2;Field  ;
                SourceExpr="IC Partner Code" }

    { 1120054067;2;Field  ;
                SourceExpr="Applying Entry" }

    { 1120054068;2;Field  ;
                SourceExpr=Reversed }

    { 1120054069;2;Field  ;
                SourceExpr="Reversed by Entry No." }

    { 1120054070;2;Field  ;
                SourceExpr="Reversed Entry No." }

    { 1120054071;2;Field  ;
                SourceExpr=Prepayment }

    { 1120054072;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054073;2;Field  ;
                SourceExpr="Loan No" }

    { 1120054074;2;Field  ;
                SourceExpr="Group Code" }

    { 1120054075;2;Field  ;
                SourceExpr=Type }

    { 1120054076;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054077;2;Field  ;
                SourceExpr="Loan Type" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

