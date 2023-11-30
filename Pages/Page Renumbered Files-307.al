OBJECT page 17498 SMS Messages
{
  OBJECT-PROPERTIES
  {
    Date=05/28/20;
    Time=10:16:23 AM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516329;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Entry No" }

    { 4   ;2   ;Field     ;
                SourceExpr=Source }

    { 5   ;2   ;Field     ;
                SourceExpr="Telephone No" }

    { 9   ;2   ;Field     ;
                SourceExpr="SMS Message" }

    { 6   ;2   ;Field     ;
                SourceExpr="Date Entered" }

    { 7   ;2   ;Field     ;
                SourceExpr="Time Entered" }

    { 8   ;2   ;Field     ;
                SourceExpr="Entered By" }

    { 10  ;2   ;Field     ;
                SourceExpr="Sent To Server" }

    { 19  ;2   ;Field     ;
                SourceExpr="Bulk SMS Balance" }

    { 1120054000;2;Field  ;
                SourceExpr=Rate }

    { 1120054001;2;Field  ;
                SourceExpr=Charged }

  }
  CODE
  {

    BEGIN
    END.
  }
}

