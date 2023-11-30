OBJECT page 172067 Black-Listed Accounts
{
  OBJECT-PROPERTIES
  {
    Date=03/14/22;
    Time=[ 9:07:01 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516706;
    PageType=List;
    OnInit=BEGIN

             StatusPermission.RESET;
             StatusPermission.SETRANGE("User ID",USERID);
             StatusPermission.SETRANGE("View BlackListed Accounts",TRUE);
             IF NOT StatusPermission.FIND('-') THEN BEGIN
                 ERROR('You do not have the following permission: "Black-List Accounts"');
             END;
           END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      Name=Import;
                      RunObject=XMLport 50058;
                      Promoted=Yes;
                      PromotedIsBig=Yes }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Account No." }

    { 8   ;2   ;Field     ;
                SourceExpr=Reason }

    { 4   ;2   ;Field     ;
                SourceExpr="Black-Listed" }

    { 1120054002;2;Field  ;
                SourceExpr="BlackList on Loan" }

    { 1120054003;2;Field  ;
                SourceExpr="BlackList on Deposit" }

    { 1120054004;2;Field  ;
                SourceExpr="BlackList on Withdrawal" }

    { 5   ;2   ;Field     ;
                SourceExpr="Black-Listed By" }

    { 6   ;2   ;Field     ;
                SourceExpr="Date Black-Listed" }

  }
  CODE
  {
    VAR
      StatusPermission@1000 : Record 51516702;

    BEGIN
    END.
  }
}

