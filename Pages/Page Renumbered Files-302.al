OBJECT page 17493 Mpesa Changed
{
  OBJECT-PROPERTIES
  {
    Date=04/05/16;
    Time=[ 1:33:36 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516335;
    SourceTableView=WHERE(Status=CONST(Approved));
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
                SourceExpr=No }

    { 1102755003;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1102755004;2;Field  ;
                SourceExpr="Initiated By" }

    { 1102755005;2;Field  ;
                SourceExpr="MPESA Receipt No" }

    { 1102755006;2;Field  ;
                SourceExpr="Account No" }

    { 1102755007;2;Field  ;
                SourceExpr="New Account No" }

    { 1102755008;2;Field  ;
                SourceExpr=Comments }

    { 1102755009;2;Field  ;
                SourceExpr="Reasons for rejection" }

    { 1102755010;2;Field  ;
                CaptionML=ENU=Date Rejected;
                SourceExpr="Date Approved" }

    { 1102755011;2;Field  ;
                CaptionML=ENU=Rejected By;
                SourceExpr="Approved By" }

    { 1102755012;2;Field  ;
                CaptionML=ENU=Time Rejected;
                SourceExpr="Time Approved" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

