OBJECT page 50095 ATM Cards Application List NEW
{
  OBJECT-PROPERTIES
  {
    Date=06/24/22;
    Time=11:20:04 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516321;
    SourceTableView=WHERE(Card Received=CONST(No));
    PageType=List;
    CardPageID=ATM Applications Card New;
    OnOpenPage=BEGIN

                 SkyPermissions.RESET;
                 SkyPermissions.SETRANGE(SkyPermissions."User ID",USERID);
                 SkyPermissions.SETRANGE(SkyPermissions."ATM Permisions",TRUE);
                 IF NOT SkyPermissions.FINDFIRST THEN ERROR('You do not have permisions to view this page');
               END;

  }
  CONTROLS
  {
    { 16  ;0   ;Container ;
                ContainerType=ContentArea }

    { 15  ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 14  ;2   ;Field     ;
                SourceExpr="No." }

    { 13  ;2   ;Field     ;
                SourceExpr="Request Type" }

    { 12  ;2   ;Field     ;
                SourceExpr="Account No" }

    { 9   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 1120054000;2;Field  ;
                SourceExpr="Application Date" }

    { 1120054015;2;Field  ;
                SourceExpr="Staff No" }

    { 1120054009;2;Field  ;
                SourceExpr="Card Status" }

    { 1120054008;2;Field  ;
                SourceExpr=Status }

    { 1120054010;2;Field  ;
                SourceExpr="ID No" }

    { 1120054004;2;Field  ;
                SourceExpr="Phone No." }

    { 1120054001;2;Field  ;
                SourceExpr="Card No" }

    { 1120054002;2;Field  ;
                SourceExpr="Date Issued" }

    { 1120054003;2;Field  ;
                SourceExpr=Limit }

    { 1120054006;2;Field  ;
                SourceExpr="Date Collected" }

    { 1120054007;2;Field  ;
                SourceExpr="Card Issued By" }

    { 1120054005;2;Field  ;
                SourceExpr="Replacement For Card No" }

    { 1120054011;2;Field  ;
                SourceExpr="ATM Card Linked" }

    { 1120054012;2;Field  ;
                SourceExpr="ATM Card Linked By" }

    { 1120054013;2;Field  ;
                SourceExpr="ATM Card Linked On" }

    { 1120054014;2;Field  ;
                SourceExpr="Branch Code" }

    { 1120054016;2;Field  ;
                SourceExpr=Branch }

    { 1120054017;2;Field  ;
                SourceExpr=Sacco_Name;
                OnValidate=BEGIN
                             //editable := yes;
                           END;
                            }

  }
  CODE
  {
    VAR
      ATMCardApplications@1120054000 : Record 51516321;
      SkyPermissions@1120054001 : Record 51516702;

    BEGIN
    END.
  }
}

