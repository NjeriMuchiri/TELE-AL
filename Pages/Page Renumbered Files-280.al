OBJECT page 17471 Transaction Type - List
{
  OBJECT-PROPERTIES
  {
    Date=10/31/18;
    Time=[ 9:32:11 AM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516298;
    PageType=List;
    CardPageID=Transaction Type Card;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr=Code }

    { 1102755000;2;Field  ;
                SourceExpr="Transaction Category" }

    { 1102760003;2;Field  ;
                SourceExpr=Description }

    { 1102760007;2;Field  ;
                SourceExpr="Account Type" }

    { 1102760005;2;Field  ;
                OptionCaptionML=ENU=<Cash Deposit,Withdrawal,Cheque Deposit,ATM Cash Deposit,ATM Cheque Deposit,ATM Withdrawal,BOSA Receipt,BOSA Withdrawal,Bankers Cheque,Encashment,M-pesa>;
                SourceExpr=Type }

  }
  CODE
  {

    BEGIN
    END.
  }
}

