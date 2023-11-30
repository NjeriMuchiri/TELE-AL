OBJECT page 20418 Funds Transfer Lines
{
  OBJECT-PROPERTIES
  {
    Date=05/10/16;
    Time=[ 5:13:02 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516005;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Receiving Bank Account" }

    { 4   ;2   ;Field     ;
                SourceExpr="Bank Name" }

    { 5   ;2   ;Field     ;
                SourceExpr="Bank Balance";
                Editable=false }

    { 6   ;2   ;Field     ;
                SourceExpr="Bank Balance(LCY)";
                Editable=false }

    { 1000000000;2;Field  ;
                SourceExpr="Pay Mode" }

    { 7   ;2   ;Field     ;
                SourceExpr="Bank Account No." }

    { 8   ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 9   ;2   ;Field     ;
                SourceExpr="Currency Factor" }

    { 10  ;2   ;Field     ;
                SourceExpr="Amount to Receive" }

    { 11  ;2   ;Field     ;
                SourceExpr="Amount to Receive (LCY)" }

    { 12  ;2   ;Field     ;
                SourceExpr="External Doc No." }

  }
  CODE
  {

    BEGIN
    END.
  }
}

