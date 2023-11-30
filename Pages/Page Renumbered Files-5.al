OBJECT page 20369 Superivsor Experience Rating
{
  OBJECT-PROPERTIES
  {
    Date=07/15/22;
    Time=[ 3:37:21 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table50694;
    SourceTableView=WHERE(Supervisor Rating=CONST(Yes));
    PageType=List;
    OnNewRecord=BEGIN
                  "Supervisor Rating":=TRUE;
                END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr=Description }

    { 4   ;2   ;Field     ;
                SourceExpr="Supervisor Rating";
                Editable=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

