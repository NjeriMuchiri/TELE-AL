OBJECT page 17499 Bulk SMS Header List
{
  OBJECT-PROPERTIES
  {
    Date=10/31/16;
    Time=12:58:12 PM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516337;
    PageType=List;
    CardPageID=Bulk SMS Header;
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
                SourceExpr=Message }

    { 1000000004;2;Field  ;
                SourceExpr="SMS Type" }

    { 1000000005;2;Field  ;
                SourceExpr="Date Entered" }

    { 1000000006;2;Field  ;
                SourceExpr="Time Entered" }

    { 1000000007;2;Field  ;
                SourceExpr="SMS Status" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

