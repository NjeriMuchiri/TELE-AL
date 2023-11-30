OBJECT page 17466 Transaction Type Card
{
  OBJECT-PROPERTIES
  {
    Date=03/29/16;
    Time=11:05:21 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516298;
    PageType=Card;
  }
  CONTROLS
  {
    { 13  ;0   ;Container ;
                ContainerType=ContentArea }

    { 12  ;1   ;Group     ;
                CaptionML=ENU=General }

    { 11  ;2   ;Field     ;
                SourceExpr=Code }

    { 10  ;2   ;Field     ;
                SourceExpr=Description }

    { 9   ;2   ;Field     ;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 7   ;2   ;Field     ;
                SourceExpr="Has Schedule" }

    { 6   ;2   ;Field     ;
                SourceExpr="Transaction Category" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Span" }

    { 4   ;2   ;Field     ;
                SourceExpr="Default Mode" }

    { 3   ;2   ;Field     ;
                SourceExpr="Lower Limit" }

    { 1000000000;1;Part   ;
                SubPageLink=Transaction Type=FIELD(Code);
                PagePartID=Page51516326 }

  }
  CODE
  {

    BEGIN
    END.
  }
}

