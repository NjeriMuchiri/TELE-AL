OBJECT page 172039 SurePESA Applications Card
{
  OBJECT-PROPERTIES
  {
    Date=09/18/19;
    Time=[ 5:36:50 PM];
    Modified=Yes;
    Version List=SurePESA;
  }
  PROPERTIES
  {
    SourceTable=Table51516521;
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
                SourceExpr="No.";
                Editable=FALSE }

    { 1000000003;2;Field  ;
                SourceExpr="Account No";
                OnValidate=BEGIN
                             vendorlist.GET("Account No");
                           END;
                            }

    { 1000000004;2;Field  ;
                SourceExpr="Account Name";
                Editable=false }

    { 1000000005;2;Field  ;
                SourceExpr=Telephone;
                Editable=false }

    { 1000000006;2;Field  ;
                SourceExpr="ID No";
                Editable=false }

    { 1000000007;2;Field  ;
                SourceExpr=Status;
                Editable=false }

    { 1000000008;2;Field  ;
                SourceExpr="Date Applied";
                Editable=false }

    { 1000000009;2;Field  ;
                SourceExpr="Time Applied";
                Editable=false }

    { 1000000010;2;Field  ;
                SourceExpr="Created By";
                Editable=false }

    { 1000000011;2;Field  ;
                SourceExpr=Sent }

    { 1120054004;2;Field  ;
                SourceExpr="Membership Registration Date";
                Editable=false }

    { 1120054000;2;Field  ;
                SourceExpr=Picture }

    { 1120054001;2;Field  ;
                SourceExpr=Signature }

    { 1120054002;2;Field  ;
                SourceExpr="ID Front" }

    { 1120054003;2;Field  ;
                SourceExpr="ID Back" }

    { 1000000012;2;Field  ;
                SourceExpr="No. Series" }

  }
  CODE
  {
    VAR
      vendorlist@1120054000 : Record 23;

    BEGIN
    END.
  }
}

