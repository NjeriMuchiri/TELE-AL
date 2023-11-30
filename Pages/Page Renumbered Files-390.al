OBJECT page 50086 Investor Payment List
{
  OBJECT-PROPERTIES
  {
    Date=11/20/15;
    Time=[ 9:09:37 AM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516000;
    SourceTableView=WHERE(Investor Payment=CONST(Yes));
    PageType=List;
    CardPageID=Investor Payment Card;
    OnNewRecord=BEGIN
                    "Investor Payment":=TRUE;
                END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                SourceExpr="Document Type" }

    { 5   ;2   ;Field     ;
                SourceExpr="Document Date" }

    { 6   ;2   ;Field     ;
                SourceExpr=Payee }

    { 7   ;2   ;Field     ;
                SourceExpr=Amount }

    { 8   ;2   ;Field     ;
                SourceExpr="Amount(LCY)" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

