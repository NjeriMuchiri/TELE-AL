OBJECT page 17450 EFT Details
{
  OBJECT-PROPERTIES
  {
    Date=08/18/16;
    Time=10:39:44 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516315;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       DCHAR:=0;
                       DCHAR:=STRLEN("Destination Account No");

                       NotAvailable:=TRUE;
                       AvailableBal:=0;


                       //Available Bal
                       IF Accounts.GET("Account No") THEN BEGIN
                       Accounts.CALCFIELDS(Accounts.Balance,Accounts."Uncleared Cheques",Accounts."ATM Transactions");
                       IF AccountTypes.GET(Accounts."Account Type") THEN BEGIN
                       AvailableBal:=Accounts.Balance-(Accounts."Uncleared Cheques"+Accounts."ATM Transactions"+Charges+AccountTypes."Minimum Balance");

                       IF Amount <= AvailableBal THEN
                       NotAvailable:=FALSE;

                       END;
                       END;
                     END;

  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                GroupType=Repeater }

    { 16  ;2   ;Field     ;
                SourceExpr="Account No" }

    { 15  ;2   ;Field     ;
                SourceExpr="Account Name";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                SourceExpr="Staff No";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                SourceExpr="Phone No.";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                SourceExpr=Charges;
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                SourceExpr="Account Type";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                CaptionML=ENU=Type;
                SourceExpr="Destination Account Type" }

    { 9   ;2   ;Field     ;
                SourceExpr=Amount }

    { 8   ;2   ;Field     ;
                CaptionML=ENU=Not Avail.;
                SourceExpr="Not Available";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="Destination Account No" }

    { 6   ;2   ;Field     ;
                CaptionML=ENU=CR;
                SourceExpr=DCHAR;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="Destination Account Name" }

    { 4   ;2   ;Field     ;
                SourceExpr="Bank No" }

    { 3   ;2   ;Field     ;
                SourceExpr="Payee Bank Name";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                SourceExpr="Standing Order No";
                Editable=FALSE }

    { 1   ;2   ;Field     ;
                SourceExpr=No;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      DCHAR@1102760000 : Integer;
      NotAvailable@1102760001 : Boolean;
      AvailableBal@1102760002 : Decimal;
      Charges@1102760003 : Decimal;
      Accounts@1102760004 : Record 23;
      AccountTypes@1102760005 : Record 51516295;

    BEGIN
    END.
  }
}

