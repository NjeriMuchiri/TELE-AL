OBJECT page 50085 Investor Receipt Lines
{
  OBJECT-PROPERTIES
  {
    Date=10/21/15;
    Time=[ 6:56:16 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516003;
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
                SourceExpr="Transaction Type";
                TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Receipt),
                                                                                  Transaction Category=CONST(Investor)) }

    { 4   ;2   ;Field     ;
                SourceExpr="Default Grouping" }

    { 5   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="Account Code" }

    { 7   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 8   ;2   ;Field     ;
                SourceExpr=Description }

    { 9   ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 10  ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

    { 11  ;2   ;Field     ;
                SourceExpr=Amount }

    { 12  ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 15  ;2   ;Field     ;
                SourceExpr="Net Amount" }

    { 13  ;2   ;Field     ;
                SourceExpr="Net Amount(LCY)" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

