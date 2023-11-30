OBJECT page 17483 User Branch Set Up
{
  OBJECT-PROPERTIES
  {
    Date=05/09/16;
    Time=11:55:25 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table2000000120;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                SourceExpr="User Name" }

    { 3   ;2   ;Field     ;
                SourceExpr="Full Name" }

    { 1000000001;2;Field  ;
                SourceExpr=Activity }

    { 1000000000;2;Field  ;
                SourceExpr=Branch }

  }
  CODE
  {

    BEGIN
    END.
  }
}

