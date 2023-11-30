OBJECT page 20434 Receipt Types Card
{
  OBJECT-PROPERTIES
  {
    Date=10/04/15;
    Time=[ 8:42:24 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516032;
    PageType=Card;
    OnNewRecord=BEGIN
                      "Transaction Type":="Transaction Type"::Receipt;
                END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="Transaction Code" }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Description" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 7   ;2   ;Field     ;
                SourceExpr="Account No" }

    { 8   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Default Grouping" }

    { 10  ;2   ;Field     ;
                SourceExpr="Withholding Tax Code" }

    { 11  ;2   ;Field     ;
                SourceExpr="Withholding Tax Chargeable" }

    { 12  ;2   ;Field     ;
                SourceExpr="VAT Code" }

    { 13  ;2   ;Field     ;
                SourceExpr="VAT Chargeable" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

