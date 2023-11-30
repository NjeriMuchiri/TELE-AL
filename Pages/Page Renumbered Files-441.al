OBJECT page 172036 CloudPESA Paybill Trans
{
  OBJECT-PROPERTIES
  {
    Date=11/28/19;
    Time=[ 1:27:23 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516098;
    PageType=List;
    CardPageID=CloudPESA Paybill Tran Card;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="Document No" }

    { 1000000003;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1000000004;2;Field  ;
                SourceExpr="Account No" }

    { 1000000005;2;Field  ;
                SourceExpr=Description }

    { 1000000006;2;Field  ;
                SourceExpr=Amount }

    { 1000000007;2;Field  ;
                SourceExpr=Posted }

    { 1000000008;2;Field  ;
                SourceExpr="Transaction Time" }

    { 1000000009;2;Field  ;
                SourceExpr="Paybill Acc Balance" }

    { 1000000010;2;Field  ;
                SourceExpr="Document Date" }

    { 1000000011;2;Field  ;
                SourceExpr="Date Posted" }

    { 1000000012;2;Field  ;
                SourceExpr="Time Posted" }

    { 1000000013;2;Field  ;
                SourceExpr="Approved By" }

    { 1000000014;2;Field  ;
                SourceExpr="Key Word" }

    { 1000000015;2;Field  ;
                SourceExpr=Telephone }

    { 1000000016;2;Field  ;
                SourceExpr="Account Name" }

    { 1000000017;2;Field  ;
                SourceExpr="Needs Manual Posting" }

    { 1120054001;2;Field  ;
                SourceExpr="Imported On" }

    { 1120054000;2;Field  ;
                SourceExpr="Imported By" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

