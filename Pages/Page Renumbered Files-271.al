OBJECT page 17462 Account Types List
{
  OBJECT-PROPERTIES
  {
    Date=02/15/22;
    Time=11:40:32 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516295;
    PageType=List;
    CardPageID=Account Types Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=Code }

    { 1120054000;2;Field  ;
                CaptionML=ENU=Account No. Format;
                SourceExpr="Account No Prefix";
                Editable=true }

    { 1102755003;2;Field  ;
                SourceExpr=Description }

    { 1102755004;2;Field  ;
                SourceExpr="Dormancy Period (M)" }

    { 1102755005;2;Field  ;
                SourceExpr="Entered By" }

    { 1102755006;2;Field  ;
                SourceExpr="Date Entered" }

    { 1102755007;2;Field  ;
                SourceExpr="Time Entered" }

    { 1102755008;2;Field  ;
                SourceExpr="Last Date Modified" }

    { 1102755009;2;Field  ;
                SourceExpr="Modified By" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

