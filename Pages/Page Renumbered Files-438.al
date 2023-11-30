OBJECT page 172033 CloudPESA Paybill Tran Card
{
  OBJECT-PROPERTIES
  {
    Date=11/28/19;
    Time=[ 1:27:55 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516098;
    PageType=Card;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000002;2;Field  ;
                SourceExpr="Document No";
                Editable=False }

    { 1000000003;2;Field  ;
                SourceExpr="Transaction Date";
                Editable=false }

    { 1000000004;2;Field  ;
                SourceExpr="Account No" }

    { 1000000005;2;Field  ;
                SourceExpr=Description;
                Editable=false }

    { 1000000006;2;Field  ;
                SourceExpr=Amount;
                Editable=false }

    { 1000000007;2;Field  ;
                SourceExpr=Posted;
                Editable=false }

    { 1000000008;2;Field  ;
                SourceExpr="Key Word" }

    { 1000000009;2;Field  ;
                SourceExpr=Telephone;
                Editable=false }

    { 1000000010;2;Field  ;
                SourceExpr="Account Name";
                Editable=false }

    { 1000000011;2;Field  ;
                SourceExpr="Needs Manual Posting" }

    { 1000000012;2;Field  ;
                SourceExpr="Document Date";
                Editable=false }

  }
  CODE
  {

    BEGIN
    END.
  }
}

