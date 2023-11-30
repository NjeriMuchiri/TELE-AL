OBJECT page 172131 Project User Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/20/15;
    Time=[ 6:12:41 PM];
    Modified=Yes;
    Version List=Project ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516868;
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
                SourceExpr="User ID" }

    { 4   ;2   ;Field     ;
                SourceExpr="Reclassification Template" }

    { 5   ;2   ;Field     ;
                SourceExpr="Reclassification Batch" }

    { 6   ;2   ;Field     ;
                SourceExpr="General Journal Template" }

    { 7   ;2   ;Field     ;
                SourceExpr="General Journal Batch" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

