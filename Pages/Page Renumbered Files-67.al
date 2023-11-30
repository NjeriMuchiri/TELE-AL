OBJECT page 20431 Funds General Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/02/15;
    Time=12:45:44 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516030;
    PageType=Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;1   ;Group     ;
                Name=Numbering;
                GroupType=Group }

    { 4   ;2   ;Field     ;
                SourceExpr="Payment Voucher Nos" }

    { 5   ;2   ;Field     ;
                SourceExpr="Cash Voucher Nos" }

    { 6   ;2   ;Field     ;
                SourceExpr="PettyCash Nos" }

    { 7   ;2   ;Field     ;
                SourceExpr="Mobile Payment Nos" }

    { 8   ;2   ;Field     ;
                SourceExpr="Receipt Nos" }

    { 9   ;2   ;Field     ;
                SourceExpr="Funds Transfer Nos" }

    { 10  ;2   ;Field     ;
                SourceExpr="Imprest Nos" }

    { 11  ;2   ;Field     ;
                SourceExpr="Imprest Surrender Nos" }

    { 12  ;2   ;Field     ;
                SourceExpr="Claim Nos" }

    { 13  ;2   ;Field     ;
                SourceExpr="Travel Advance Nos" }

    { 14  ;2   ;Field     ;
                SourceExpr="Travel Surrender Nos" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

