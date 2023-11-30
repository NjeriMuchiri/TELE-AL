OBJECT page 17430 Account App Next Of Kin Detail
{
  OBJECT-PROPERTIES
  {
    Date=10/15/18;
    Time=[ 8:42:22 AM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516291;
    PageType=Card;
    OnOpenPage=BEGIN
                 "Maximun Allocation %":=100;
                 //MODIFY;
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

    { 1102755011;2;Field  ;
                SourceExpr="ID No." }

    { 1102755012;2;Field  ;
                SourceExpr="%Allocation";
                OnValidate=BEGIN
                             RESET;
                             SETRANGE("Account No","Account No");
                              CALCFIELDS("Total Allocation");

                              IF "%Allocation">"Maximun Allocation %" THEN
                                ERROR(' Total allocation should be equal to 100 %');
                           END;
                            }

  }
  CODE
  {
    VAR
      App@1000000000 : Record 51516291;

    BEGIN
    END.
  }
}

