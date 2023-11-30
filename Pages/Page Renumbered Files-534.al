OBJECT page 172129 Interest Buffer
{
  OBJECT-PROPERTIES
  {
    Date=08/15/16;
    Time=12:36:49 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516324;
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
                SourceExpr=No }

    { 1000000003;2;Field  ;
                SourceExpr="Account No" }

    { 1000000004;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000013;2;Field  ;
                SourceExpr=Description }

    { 1000000005;2;Field  ;
                SourceExpr="Interest Date" }

    { 1000000006;2;Field  ;
                SourceExpr="Interest Amount" }

    { 1000000007;2;Field  ;
                SourceExpr="User ID" }

    { 1000000008;2;Field  ;
                SourceExpr="Account Matured" }

    { 1000000010;2;Field  ;
                SourceExpr="Late Interest" }

    { 1000000011;2;Field  ;
                SourceExpr=Transferred }

    { 1000000012;2;Field  ;
                SourceExpr="Mark For Deletion" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

