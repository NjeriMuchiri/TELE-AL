OBJECT page 172070 Product Factory
{
  OBJECT-PROPERTIES
  {
    Date=04/20/23;
    Time=[ 2:25:40 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516717;
    PageType=List;
    CardPageID=Product Factory Card;
    OnInit=BEGIN
             RestrictAccess(USERID);
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
                SourceExpr="Product ID" }

    { 4   ;2   ;Field     ;
                SourceExpr="Product Description" }

    { 5   ;2   ;Field     ;
                SourceExpr="Product Class Type" }

    { 6   ;2   ;Field     ;
                SourceExpr="USSD Product Name" }

    { 7   ;2   ;Field     ;
                SourceExpr="Key Word" }

    { 1120054000;2;Field  ;
                SourceExpr="Account Type" }

  }
  CODE
  {

    PROCEDURE RestrictAccess@2(UserNo@1000 : Code[100]);
    VAR
      SaccoPermissions@1001 : Record 51516702;
      ErrorOnRestrictViewTxt@1002 : TextConst 'ENU=You do not have permissions to EDIT this Page. Contact your system administrator for further details';
    BEGIN
      SaccoPermissions.RESET;
      SaccoPermissions.SETRANGE("User ID",UserNo);
      SaccoPermissions.SETRANGE("Sky Mobile Setups",TRUE);
      IF NOT SaccoPermissions.FIND('-') THEN BEGIN
          ERROR('You do not have Setup Permissions');
      END;
    END;

    BEGIN
    END.
  }
}

