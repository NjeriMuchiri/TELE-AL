OBJECT page 20419 Posted Funds Transfer List
{
  OBJECT-PROPERTIES
  {
    Date=09/22/15;
    Time=[ 4:26:40 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516004;
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
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr=Date }

    { 5   ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 6   ;2   ;Field     ;
                SourceExpr="Paying Bank Account" }

    { 7   ;2   ;Field     ;
                SourceExpr="Paying Bank Name" }

    { 8   ;2   ;Field     ;
                SourceExpr="Amount to Transfer" }

    { 9   ;2   ;Field     ;
                SourceExpr="Amount to Transfer(LCY)" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

