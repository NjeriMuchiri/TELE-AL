OBJECT page 20416 Funds Transfer List
{
  OBJECT-PROPERTIES
  {
    Date=05/20/16;
    Time=[ 2:58:08 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516004;
    PageType=List;
    CardPageID=Funds Transfer Card;
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

    { 1000000000;2;Field  ;
                SourceExpr=Posted;
                Editable=false }

    { 1000000001;2;Field  ;
                SourceExpr="Posted By";
                Editable=false }

    { 1000000002;2;Field  ;
                SourceExpr="Date Posted";
                Editable=false }

    { 1000000003;2;Field  ;
                SourceExpr="Time Posted";
                Editable=false }

    { 1000000004;2;Field  ;
                SourceExpr="Created By" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

