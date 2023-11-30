OBJECT page 50016 Tracker History sub_page
{
  OBJECT-PROPERTIES
  {
    Date=05/12/16;
    Time=[ 4:50:38 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516282;
    SourceTableView=SORTING(Staff/Payroll No)
                    ORDER(Ascending)
                    WHERE(Multiple Receipts=CONST(2));
    PageType=List;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000003;2;Field  ;
                SourceExpr="Employer Code" }

    { 1000000007;2;Field  ;
                SourceExpr=Name }

    { 1000000009;2;Field  ;
                SourceExpr=Amount }

    { 1000000008;2;Field  ;
                SourceExpr="No Repayment" }

    { 1000000004;2;Field  ;
                SourceExpr="Receipt Header No" }

    { 1000000005;2;Field  ;
                SourceExpr=GPersonalNo }

    { 1000000006;2;Field  ;
                SourceExpr="Payment No" }

    { 1000000002;2;Field  ;
                SourceExpr="Multiple Receipts" }

    { 1000000010;2;Field  ;
                SourceExpr="Early Remitances" }

    { 1000000011;2;Field  ;
                SourceExpr="Early Remitance Amount" }

    { 1000000012;2;Field  ;
                SourceExpr="Member No." }

    { 1000000014;2;Field  ;
                SourceExpr="Loans Not found" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

