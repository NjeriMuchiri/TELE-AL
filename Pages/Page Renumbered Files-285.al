OBJECT page 17476 Teller Till List
{
  OBJECT-PROPERTIES
  {
    Date=03/31/16;
    Time=11:27:09 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table270;
    SourceTableView=WHERE(Account Type=FILTER(Cashier));
    PageType=List;
    CardPageID=Teller Till Card;
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
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                SourceExpr=Contact }

    { 6   ;2   ;Field     ;
                SourceExpr="Phone No." }

    { 7   ;2   ;Field     ;
                SourceExpr="Bank Account No." }

    { 8   ;2   ;Field     ;
                SourceExpr="Bank Acc. Posting Group" }

    { 9   ;2   ;Field     ;
                SourceExpr=Amount }

  }
  CODE
  {

    BEGIN
    END.
  }
}

