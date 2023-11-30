OBJECT page 20412 Receipt Line
{
  OBJECT-PROPERTIES
  {
    Date=04/05/18;
    Time=11:46:03 AM;
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

    { 3   ;2   ;Field     ;
                SourceExpr="Document No" }

    { 4   ;2   ;Field     ;
                SourceExpr="Document Type" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="Default Grouping" }

    { 7   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 8   ;2   ;Field     ;
                SourceExpr="Account Code" }

    { 9   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 1000000000;2;Field  ;
                SourceExpr="BOSATransaction Type" }

    { 1000000001;2;Field  ;
                SourceExpr="Loan No" }

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

    { 15  ;2   ;Field     ;
                SourceExpr="Currency Factor" }

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

