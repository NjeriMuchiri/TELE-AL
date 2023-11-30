OBJECT page 50002 Mpesa Changes List
{
  OBJECT-PROPERTIES
  {
    Date=05/30/16;
    Time=[ 9:43:25 AM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516335;
    PageType=List;
    CardPageID=Mpesa changes;
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
                SourceExpr="Transaction Date" }

    { 1000000004;2;Field  ;
                SourceExpr="MPESA Receipt No" }

    { 1000000005;2;Field  ;
                SourceExpr="Account No" }

    { 1000000006;2;Field  ;
                SourceExpr="New Account No" }

    { 1000000007;2;Field  ;
                SourceExpr="Approved By" }

    { 1000000008;2;Field  ;
                SourceExpr=Status }

  }
  CODE
  {

    BEGIN
    END.
  }
}

