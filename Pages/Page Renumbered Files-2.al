OBJECT page 20366 Job Exit Interview List-SS
{
  OBJECT-PROPERTIES
  {
    Date=07/15/22;
    Time=[ 3:01:21 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51525388;
    PageType=List;
    CardPageID=Page51525734;
    OnOpenPage=BEGIN
                 SETRANGE("User Id",USERID);
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
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                SourceExpr="Employee No." }

    { 5   ;2   ;Field     ;
                SourceExpr="Employee Name" }

    { 6   ;2   ;Field     ;
                SourceExpr=Position }

    { 7   ;2   ;Field     ;
                SourceExpr=Supervisor }

    { 8   ;2   ;Field     ;
                SourceExpr="Date of Join" }

    { 9   ;2   ;Field     ;
                SourceExpr="Termination Date" }

    { 10  ;2   ;Field     ;
                SourceExpr="Future Re-Employment" }

    { 11  ;2   ;Field     ;
                SourceExpr="Leaving could have prevented" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

