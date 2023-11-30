OBJECT page 172179 KBA Bank Names
{
  OBJECT-PROPERTIES
  {
    Date=03/09/22;
    Time=[ 3:25:05 PM];
    Modified=Yes;
    Version List=PAYROLL;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516656;
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
                SourceExpr="Bank Code";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr="Bank Name";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr=Location;
                Editable=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

