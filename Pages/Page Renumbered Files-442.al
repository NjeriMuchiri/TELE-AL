OBJECT page 172037 Medical Claim Entries
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 3:14:07 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516416;
    PageType=List;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="Entry No" }

    { 1000000003;2;Field  ;
                SourceExpr="Document No." }

    { 1000000004;2;Field  ;
                SourceExpr="Employee No" }

    { 1000000005;2;Field  ;
                SourceExpr="Employee Name" }

    { 1000000006;2;Field  ;
                SourceExpr="Claim Date" }

    { 1000000007;2;Field  ;
                SourceExpr="Hospital Visit Date" }

    { 1000000008;2;Field  ;
                SourceExpr="Claim Limit" }

    { 1000000009;2;Field  ;
                SourceExpr="Balance Claim Amount" }

    { 1000000010;2;Field  ;
                SourceExpr="Amount Claimed" }

    { 1000000011;2;Field  ;
                SourceExpr="Amount Charged" }

    { 1000000012;2;Field  ;
                SourceExpr=Comments }

    { 1000000013;2;Field  ;
                SourceExpr="USER ID" }

    { 1000000014;2;Field  ;
                SourceExpr="Claim No" }

    { 1000000015;2;Field  ;
                SourceExpr="Date Posted" }

    { 1000000016;2;Field  ;
                SourceExpr="Time Posted" }

    { 1000000017;2;Field  ;
                SourceExpr=Posted }

  }
  CODE
  {

    BEGIN
    END.
  }
}

