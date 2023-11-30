OBJECT page 17435 Account Next of Kin Details
{
  OBJECT-PROPERTIES
  {
    Date=03/31/16;
    Time=[ 9:58:54 AM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516293;
    PageType=Card;
    OnOpenPage=BEGIN
                 "Maximun Allocation %":=100;
               END;

    OnAfterGetRecord=BEGIN
                        "Maximun Allocation %":=100;
                     END;

  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=Name }

    { 1102755003;2;Field  ;
                SourceExpr=Relationship }

    { 1102755004;2;Field  ;
                SourceExpr=Beneficiary }

    { 1102755005;2;Field  ;
                SourceExpr="Date of Birth" }

    { 1102755006;2;Field  ;
                SourceExpr=Address }

    { 1102755007;2;Field  ;
                SourceExpr=Telephone }

    { 1102755008;2;Field  ;
                SourceExpr=Fax }

    { 1102755009;2;Field  ;
                SourceExpr=Email }

    { 1102755010;2;Field  ;
                SourceExpr="ID No." }

    { 1102755011;2;Field  ;
                SourceExpr="%Allocation";
                OnValidate=BEGIN
                              CALCFIELDS("Total Allocation");
                              IF "%Allocation">"Maximun Allocation %" THEN
                                ERROR(' Total allocation should be equal to 100 %');
                           END;
                            }

  }
  CODE
  {
    VAR
      NextKin@1102755000 : Record 51516225;
      TOTALALLO@1102755001 : Decimal;

    BEGIN
    END.
  }
}

