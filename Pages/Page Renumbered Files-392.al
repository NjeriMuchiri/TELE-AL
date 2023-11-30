OBJECT page 50088 Investor Payment Line
{
  OBJECT-PROPERTIES
  {
    Date=11/23/15;
    Time=11:50:50 AM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516001;
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
                SourceExpr="Payment Type";
                TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Payment)) }

    { 5   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="Account No." }

    { 7   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 8   ;2   ;Field     ;
                SourceExpr="Payment Description" }

    { 4   ;2   ;Field     ;
                SourceExpr="Investor Interest Code" }

    { 9   ;2   ;Field     ;
                SourceExpr="Investment Date" }

    { 11  ;2   ;Field     ;
                SourceExpr=Amount }

    { 12  ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

    { 22  ;2   ;Field     ;
                SourceExpr="Net Amount" }

    { 23  ;2   ;Field     ;
                SourceExpr="Net Amount(LCY)" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

