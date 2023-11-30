OBJECT page 172065 Sky SMS Messages
{
  OBJECT-PROPERTIES
  {
    Date=12/21/20;
    Time=12:18:55 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516711;
    SourceTableView=SORTING(date_created)
                    ORDER(Descending)
                    WHERE(msg=FILTER(<>*your PesaTele PIN is*));
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054004;1 ;Action    ;
                      Name=Show Available Balance;
                      OnAction=BEGIN
                                 MESSAGE('Available Balance: %1',SkyMbanking.GetAccountBalance("Account To Charge"));
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                SourceExpr=msg_id }

    { 1120054001;2;Field  ;
                SourceExpr=msg_category }

    { 5   ;2   ;Field     ;
                SourceExpr=msg_status_code }

    { 6   ;2   ;Field     ;
                SourceExpr=msg_status_description }

    { 7   ;2   ;Field     ;
                SourceExpr=sender }

    { 8   ;2   ;Field     ;
                SourceExpr=receiver }

    { 9   ;2   ;Field     ;
                SourceExpr=msg }

    { 10  ;2   ;Field     ;
                SourceExpr=msg_type }

    { 11  ;2   ;Field     ;
                SourceExpr=msg_priority }

    { 12  ;2   ;Field     ;
                SourceExpr="SMS Date" }

    { 13  ;2   ;Field     ;
                SourceExpr="Account To Charge" }

    { 1120054005;2;Field  ;
                SourceExpr="Insufficient Balance" }

    { 14  ;2   ;Field     ;
                SourceExpr=Posted }

    { 15  ;2   ;Field     ;
                SourceExpr=date_created }

    { 3   ;2   ;Field     ;
                SourceExpr=Finalized }

    { 1120054000;2;Field  ;
                SourceExpr="Charge Member" }

    { 1120054002;2;Field  ;
                SourceExpr=msg_request_correlation_id }

  }
  CODE
  {
    VAR
      SkyMbanking@1120054000 : Codeunit 51516701;

    BEGIN
    END.
  }
}

