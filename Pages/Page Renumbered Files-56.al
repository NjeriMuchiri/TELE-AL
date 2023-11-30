OBJECT page 20420 Posted Funds Transfer Card
{
  OBJECT-PROPERTIES
  {
    Date=09/22/15;
    Time=[ 4:28:30 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516004;
    PageType=Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr="Pay Mode" }

    { 5   ;2   ;Field     ;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                SourceExpr="Posting Date" }

    { 7   ;2   ;Field     ;
                SourceExpr="Paying Bank Account" }

    { 8   ;2   ;Field     ;
                SourceExpr="Paying Bank Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Bank Balance" }

    { 10  ;2   ;Field     ;
                SourceExpr="Bank Balance(LCY)" }

    { 11  ;2   ;Field     ;
                SourceExpr="Bank Account No." }

    { 12  ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 13  ;2   ;Field     ;
                SourceExpr="Currency Factor" }

    { 14  ;2   ;Field     ;
                SourceExpr="Amount to Transfer" }

    { 15  ;2   ;Field     ;
                SourceExpr="Amount to Transfer(LCY)" }

    { 16  ;2   ;Field     ;
                SourceExpr="Total Line Amount" }

    { 17  ;2   ;Field     ;
                SourceExpr="Total Line Amount(LCY)" }

    { 18  ;2   ;Field     ;
                SourceExpr="Cheque/Doc. No" }

    { 19  ;2   ;Field     ;
                SourceExpr=Description }

    { 20  ;2   ;Field     ;
                SourceExpr="Created By" }

    { 21  ;2   ;Field     ;
                SourceExpr="Date Created" }

    { 22  ;2   ;Field     ;
                SourceExpr="Time Created" }

    { 23  ;2   ;Field     ;
                SourceExpr=Status }

    { 24  ;1   ;Part      ;
                SubPageLink=Document No=FIELD(No.);
                PagePartID=Page51516035;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

