OBJECT page 172066 Black-Listed Phone Nos
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:45:29 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516705;
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
      { 8       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      Name=Import;
                      RunObject=XMLport 50056;
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
                SourceExpr="Transactional Phone No." }

    { 7   ;2   ;Field     ;
                SourceExpr=Reason }

    { 4   ;2   ;Field     ;
                SourceExpr="Black-Listed" }

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
    {

      StatusPermission.RESET;
      StatusPermission.SETRANGE("User ID",USERID);
      StatusPermission.SETRANGE("Black-List Accounts",TRUE);
      IF NOT StatusPermission.FIND('-') THEN BEGIN
          ERROR('You do not have the following permission: "Black-List Accounts"');
      END;
    }
    END.
  }
}

