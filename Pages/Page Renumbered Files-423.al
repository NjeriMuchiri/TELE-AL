OBJECT page 172018 Salary Processing List
{
  OBJECT-PROPERTIES
  {
    Date=12/22/22;
    Time=[ 1:48:42 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516459;
    SourceTableView=WHERE(Posted=CONST(No));
    PageType=List;
    CardPageID=Salary Processing Header;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr=No }

    { 1120054003;2;Field  ;
                SourceExpr="No. Series" }

    { 1120054004;2;Field  ;
                SourceExpr=Posted }

    { 1120054005;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054028;2;Field  ;
                SourceExpr=Status }

    { 1120054006;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054007;2;Field  ;
                SourceExpr="Entered By" }

    { 1120054008;2;Field  ;
                SourceExpr=Remarks }

    { 1120054009;2;Field  ;
                SourceExpr="Date Filter" }

    { 1120054010;2;Field  ;
                SourceExpr="Time Entered" }

    { 1120054011;2;Field  ;
                SourceExpr="Posting date" }

    { 1120054012;2;Field  ;
                SourceExpr="Account Type" }

    { 1120054013;2;Field  ;
                SourceExpr="Account No" }

    { 1120054014;2;Field  ;
                SourceExpr="Document No" }

    { 1120054015;2;Field  ;
                SourceExpr=Amount }

    { 1120054016;2;Field  ;
                SourceExpr="Scheduled Amount" }

    { 1120054017;2;Field  ;
                SourceExpr="Total Count" }

    { 1120054018;2;Field  ;
                SourceExpr="Account Name" }

    { 1120054019;2;Field  ;
                SourceExpr="Employer Code" }

    { 1120054020;2;Field  ;
                SourceExpr="Cheque No." }

    { 1120054021;2;Field  ;
                SourceExpr=Pension }

    { 1120054022;2;Field  ;
                SourceExpr=Discard }

    { 1120054023;2;Field  ;
                SourceExpr="Exempt Loan Repayment" }

    { 1120054024;2;Field  ;
                SourceExpr="Pre-Post Blocked Status Update" }

    { 1120054025;2;Field  ;
                SourceExpr="Post-Post Blocked Statu Update" }

    { 1120054026;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054027;2;Field  ;
                SourceExpr="Exempt Processing Fee" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

