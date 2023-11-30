OBJECT page 20432 Funds User Setup
{
  OBJECT-PROPERTIES
  {
    Date=11/18/16;
    Time=[ 9:17:41 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516031;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr=UserID }

    { 4   ;2   ;Field     ;
                SourceExpr="Receipt Journal Template" }

    { 5   ;2   ;Field     ;
                SourceExpr="Receipt Journal Batch" }

    { 6   ;2   ;Field     ;
                SourceExpr="Payment Journal Template" }

    { 7   ;2   ;Field     ;
                SourceExpr="Payment Journal Batch" }

    { 8   ;2   ;Field     ;
                SourceExpr="Petty Cash Template" }

    { 9   ;2   ;Field     ;
                SourceExpr="Petty Cash Batch" }

    { 10  ;2   ;Field     ;
                SourceExpr="FundsTransfer Template Name" }

    { 11  ;2   ;Field     ;
                SourceExpr="FundsTransfer Batch Name" }

    { 12  ;2   ;Field     ;
                SourceExpr="Default Receipts Bank" }

    { 13  ;2   ;Field     ;
                SourceExpr="Default Payment Bank" }

    { 14  ;2   ;Field     ;
                SourceExpr="Default Petty Cash Bank" }

    { 15  ;2   ;Field     ;
                SourceExpr="Max. Cash Collection" }

    { 16  ;2   ;Field     ;
                SourceExpr="Max. Cheque Collection" }

    { 17  ;2   ;Field     ;
                SourceExpr="Max. Deposit Slip Collection" }

    { 18  ;2   ;Field     ;
                SourceExpr="Supervisor ID" }

    { 19  ;2   ;Field     ;
                SourceExpr="Bank Pay In Journal Template" }

    { 20  ;2   ;Field     ;
                SourceExpr="Bank Pay In Journal Batch" }

    { 21  ;2   ;Field     ;
                SourceExpr="Imprest Template" }

    { 22  ;2   ;Field     ;
                SourceExpr="Imprest  Batch" }

    { 23  ;2   ;Field     ;
                SourceExpr="Claim Template" }

    { 24  ;2   ;Field     ;
                SourceExpr="Claim  Batch" }

    { 25  ;2   ;Field     ;
                SourceExpr="Advance Template" }

    { 26  ;2   ;Field     ;
                SourceExpr="Advance  Batch" }

    { 27  ;2   ;Field     ;
                SourceExpr="Advance Surr Template" }

    { 28  ;2   ;Field     ;
                SourceExpr="Advance Surr Batch" }

    { 29  ;2   ;Field     ;
                SourceExpr="Dim Change Journal Template" }

    { 30  ;2   ;Field     ;
                SourceExpr="Dim Change Journal Batch" }

    { 31  ;2   ;Field     ;
                SourceExpr="Journal Voucher Template" }

    { 32  ;2   ;Field     ;
                SourceExpr="Journal Voucher Batch" }

    { 1000000000;2;Field  ;
                SourceExpr="Payroll Template" }

    { 1000000001;2;Field  ;
                SourceExpr="Payroll Batch" }

    { 1000000002;2;Field  ;
                SourceExpr="Checkoff Template" }

    { 1000000003;2;Field  ;
                SourceExpr="Checkoff Batch" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

