OBJECT page 17470 Fixed Deposit Types Card
{
  OBJECT-PROPERTIES
  {
    Date=07/23/20;
    Time=[ 4:45:34 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516305;
    PageType=Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr=Code }

    { 1102755003;2;Field  ;
                SourceExpr=Duration }

    { 1120054001;2;Field  ;
                SourceExpr="Int Duration" }

    { 1102755004;2;Field  ;
                SourceExpr=Description }

    { 1102755005;2;Field  ;
                SourceExpr="No. of Months" }

    { 1102755006;1;Part   ;
                CaptionML=ENU=Interest Computation;
                SubPageLink=Code=FIELD(Code);
                PagePartID=Page51516334;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

