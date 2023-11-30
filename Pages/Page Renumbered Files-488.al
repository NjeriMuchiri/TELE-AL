OBJECT page 172083 Paybill Reconciliation
{
  OBJECT-PROPERTIES
  {
    Date=12/17/20;
    Time=[ 7:30:16 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516724;
    PageType=List;
    CardPageID=Paybill Reconcilliation Card;
    OnInit=BEGIN
             RestrictAccess(USERID);
           END;

    ActionList=ACTIONS
    {
      { 1120054007;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054008;1 ;Action    ;
                      Name=Reconciliation Report;
                      RunObject=Report 51516701;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Entry No." }

    { 1120054003;2;Field  ;
                SourceExpr="Start Date";
                OnValidate=BEGIN
                             COMMIT;
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 1120054006;2;Field  ;
                SourceExpr="End Date" }

    { 1120054004;2;Field  ;
                SourceExpr=Reconciled }

    { 1120054005;2;Field  ;
                SourceExpr="Reconciled By" }

  }
  CODE
  {

    PROCEDURE RestrictAccess@2(UserNo@1000 : Code[100]);
    VAR
      StatusPermission@1001 : Record 51516702;
      ErrorOnRestrictViewTxt@1002 : TextConst 'ENU=You do not have permissions to EDIT this Page. Contact your system administrator for further details';
    BEGIN
      StatusPermission.RESET;
      StatusPermission.SETRANGE("User ID",UserNo);
      StatusPermission.SETRANGE(StatusPermission."Mpesa Reconciliation",TRUE);
      IF NOT StatusPermission.FIND('-') THEN BEGIN
          ERROR('You do not have the following permission: "Mpesa Reconciliation"');
      END;
    END;

    BEGIN
    END.
  }
}

