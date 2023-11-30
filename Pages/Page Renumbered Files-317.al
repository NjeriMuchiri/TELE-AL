OBJECT page 50008 Data Sheet Periods
{
  OBJECT-PROPERTIES
  {
    Date=04/27/16;
    Time=[ 9:45:27 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516343;
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
                SourceExpr="Period Code" }

    { 1000000003;2;Field  ;
                SourceExpr="Begin Date" }

    { 1000000004;2;Field  ;
                SourceExpr="End Date" }

    { 1000000005;2;Field  ;
                SourceExpr=Month }

    { 1000000006;2;Field  ;
                SourceExpr="Payroll Month" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

