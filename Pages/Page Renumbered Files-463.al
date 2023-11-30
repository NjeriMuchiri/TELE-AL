OBJECT page 172058 MBanking Permissions
{
  OBJECT-PROPERTIES
  {
    Date=12/06/21;
    Time=[ 4:15:57 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516702;
    PageType=List;
    OnInit=BEGIN
             Permission.RESET;
             Permission.SETRANGE("User ID",USERID);
             Permission.SETRANGE("Sky Mobile Setups",TRUE);
             IF NOT Permission.FINDFIRST THEN
               ERROR('You do not have the following permission: "Sky Mobile Setups"');
           END;

    OnOpenPage=BEGIN
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

    { 5   ;2   ;Field     ;
                SourceExpr="User ID" }

    { 49  ;2   ;Field     ;
                SourceExpr="Reset Mpesa Pin" }

    { 50  ;2   ;Field     ;
                SourceExpr="Update Paybill Transaction" }

    { 51  ;2   ;Field     ;
                SourceExpr="Sky Mobile Setups" }

    { 52  ;2   ;Field     ;
                SourceExpr="Black-List Accounts" }

    { 61  ;2   ;Field     ;
                SourceExpr="View BlackListed Accounts" }

    { 3   ;2   ;Field     ;
                SourceExpr="Approve Mobile Banking" }

    { 1120054000;2;Field  ;
                SourceExpr="Create MBanking Applications" }

    { 4   ;2   ;Field     ;
                SourceExpr="Reverse Sky Transactions" }

    { 1120054001;2;Field  ;
                SourceExpr="Mpesa Reconciliation" }

    { 1120054002;2;Field  ;
                SourceExpr="Reverse M Bank Transfer" }

    { 1120054003;2;Field  ;
                SourceExpr="ATM Permisions" }

    { 1120054004;2;Field  ;
                SourceExpr="T-Kash Accounts" }

  }
  CODE
  {
    VAR
      SaccoPermissions@1000 : Record 51516702;
      Permission@1120054000 : Record 51516702;

    PROCEDURE RestrictAccess@2(UserNo@1000 : Code[100]);
    VAR
      StatusPermission@1001 : Record 91;
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

