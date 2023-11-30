OBJECT page 172125 Property Receipt Line
{
  OBJECT-PROPERTIES
  {
    Date=10/21/15;
    Time=[ 7:01:42 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
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

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type";
                TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Receipt),
                                                                                  Transaction Category=CONST(Property)) }

    { 6   ;2   ;Field     ;
                SourceExpr="Default Grouping" }

    { 7   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 8   ;2   ;Field     ;
                SourceExpr="Account Code" }

    { 9   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 10  ;2   ;Field     ;
                SourceExpr=Description }

    { 11  ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 12  ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code" }

    { 13  ;2   ;Field     ;
                SourceExpr="Pay Mode" }

    { 14  ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 16  ;2   ;Field     ;
                SourceExpr=Amount }

    { 17  ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 18  ;2   ;Field     ;
                SourceExpr="Cheque No" }

    { 19  ;2   ;Field     ;
                SourceExpr="Applies-To Doc No." }

    { 20  ;2   ;Field     ;
                SourceExpr="Applies-To ID" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

