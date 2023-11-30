OBJECT page 172114 Change Request List
{
  OBJECT-PROPERTIES
  {
    Date=02/13/20;
    Time=[ 1:15:23 PM];
    Modified=Yes;
    Version List=Change RequestV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516350;
    SourceTableView=WHERE(Changed=CONST(No));
    PageType=List;
    CardPageID=CloudPesa Change Request;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr=No }

    { 1000000003;2;Field  ;
                SourceExpr=Type }

    { 1000000004;2;Field  ;
                SourceExpr="Account No" }

    { 1000000005;2;Field  ;
                SourceExpr="Mobile No" }

    { 1000000006;2;Field  ;
                SourceExpr=Name }

    { 1000000007;2;Field  ;
                SourceExpr="No. Series" }

    { 1000000008;2;Field  ;
                SourceExpr=Address }

    { 1000000009;2;Field  ;
                SourceExpr=Branch }

    { 1000000010;2;Field  ;
                SourceExpr=Picture }

    { 1000000011;2;Field  ;
                SourceExpr=signinature }

    { 1120054001;2;Field  ;
                SourceExpr="Front Side ID" }

    { 1120054002;2;Field  ;
                SourceExpr="Back Side ID" }

    { 1000000012;2;Field  ;
                SourceExpr=City }

    { 1000000013;2;Field  ;
                SourceExpr="E-mail" }

    { 1000000014;2;Field  ;
                SourceExpr="Personal No" }

    { 1000000015;2;Field  ;
                SourceExpr="ID No" }

    { 1000000016;2;Field  ;
                SourceExpr="Marital Status" }

    { 1000000017;2;Field  ;
                SourceExpr="Passport No." }

    { 1000000018;2;Field  ;
                SourceExpr=Status }

    { 1000000019;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000020;2;Field  ;
                SourceExpr="Account Category" }

    { 1000000021;2;Field  ;
                SourceExpr=Email }

    { 1000000022;2;Field  ;
                SourceExpr=Section }

    { 1000000023;2;Field  ;
                SourceExpr="Card No" }

    { 1000000024;2;Field  ;
                SourceExpr="Home Address" }

    { 1000000025;2;Field  ;
                SourceExpr=Loaction }

    { 1120054000;2;Field  ;
                SourceExpr="Application Date(old)" }

    { 1000000026;2;Field  ;
                SourceExpr="Sub-Location" }

    { 1000000027;2;Field  ;
                SourceExpr=District }

    { 1000000028;2;Field  ;
                SourceExpr="Reason for change" }

    { 1000000029;2;Field  ;
                SourceExpr="Signing Instructions" }

    { 1000000030;2;Field  ;
                SourceExpr="S-Mobile No" }

    { 1000000031;2;Field  ;
                SourceExpr="ATM Approve";
                OnValidate=BEGIN

                             IF usersetup.GET(USERID) THEN BEGIN
                               IF NOT usersetup."Edit Atm Changes" THEN
                                ERROR('you are not allowed to make this changes Contact Mr.Ominde');
                               END ELSE BEGIN
                                 ERROR(UserNotFound,USERID);
                                 END;
                           END;
                            }

    { 1000000032;2;Field  ;
                SourceExpr="Card Expiry Date" }

    { 1000000033;2;Field  ;
                SourceExpr="Card Valid From" }

    { 1000000034;2;Field  ;
                SourceExpr="Card Valid To" }

    { 1000000035;2;Field  ;
                SourceExpr="Date ATM Linked" }

    { 1000000036;2;Field  ;
                SourceExpr="ATM No." }

  }
  CODE
  {
    VAR
      usersetup@1120054000 : Record 91;
      UserNotFound@1120054001 : TextConst 'ENU=User Setup %1 not found.';

    BEGIN
    END.
  }
}

