OBJECT page 17368 Members Kin Details List
{
  OBJECT-PROPERTIES
  {
    Date=11/05/22;
    Time=[ 2:18:41 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516225;
    SourceTableView=WHERE(Type=CONST(Next of Kin));
    PageType=Card;
    OnOpenPage=BEGIN
                 {StatusPermissions.RESET;
                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Nominee);
                 IF StatusPermissions.FIND('-') = FALSE THEN
                 ERROR('You do not have permissions to View This information.');}
               END;

    OnQueryClosePage=BEGIN
                       IF Beneficiary=TRUE THEN BEGIN
                       TESTFIELD("%Allocation");
                       END;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=Type }

    { 1102760001;2;Field  ;
                SourceExpr=Name }

    { 1102760017;2;Field  ;
                SourceExpr="ID No." }

    { 1102760009;2;Field  ;
                SourceExpr=Address }

    { 1102760003;2;Field  ;
                SourceExpr=Relationship }

    { 1102760019;2;Field  ;
                SourceExpr="%Allocation" }

    { 1102760005;2;Field  ;
                SourceExpr=Beneficiary }

    { 1102760007;2;Field  ;
                SourceExpr="Date of Birth" }

    { 1102760011;2;Field  ;
                SourceExpr=Telephone }

    { 1102760015;2;Field  ;
                SourceExpr=Email }

    { 1102755000;2;Field  ;
                SourceExpr="Account No" }

  }
  CODE
  {
    VAR
      StatusPermissions@1000000000 : Record 51516310;

    BEGIN
    END.
  }
}

