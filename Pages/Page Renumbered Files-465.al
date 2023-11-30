OBJECT page 172060 Sky Corporate Charges
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:19:47 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516708;
    PageType=List;
    OnInit=BEGIN
             Permission.RESET;
             Permission.SETRANGE("User ID",USERID);
             Permission.SETRANGE("Sky Mobile Setups",TRUE);
             IF NOT Permission.FINDFIRST THEN
               ERROR('You do not have the following permission: "Sky Mobile Setups"');
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
                SourceExpr=Minimum }

    { 4   ;2   ;Field     ;
                SourceExpr=Maximum }

    { 5   ;2   ;Field     ;
                SourceExpr=Charge }

  }
  CODE
  {
    VAR
      Permission@1000 : Record 51516702;

    BEGIN
    END.
  }
}

