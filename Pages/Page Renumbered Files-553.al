OBJECT page 172148 HR Lookup Values Card
{
  OBJECT-PROPERTIES
  {
    Date=02/02/23;
    Time=11:35:19 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516163;
    PageType=Card;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755001;2;Field  ;
                SourceExpr=Type }

    { 1102755003;2;Field  ;
                SourceExpr=Code }

    { 1102755005;2;Field  ;
                SourceExpr=Description }

    { 1102755004;2;Field  ;
                SourceExpr="Supervisor Only" }

    { 1102755007;2;Field  ;
                SourceExpr=Remarks }

    { 1102755009;2;Field  ;
                SourceExpr="Notice Period" }

    { 1102755011;2;Field  ;
                SourceExpr=Closed }

    { 1102755013;2;Field  ;
                SourceExpr="Contract Length" }

    { 1102755023;2;Field  ;
                CaptionClass=Text19024457 }

    { 1120054000;2;Field  ;
                SourceExpr=Department }

    { 1102755034;2;Field  ;
                SourceExpr=Score }

    { 1102755015;2;Field  ;
                SourceExpr="Current Appraisal Period" }

    { 1102755017;2;Field  ;
                SourceExpr="Disciplinary Case Rating" }

    { 1102755019;2;Field  ;
                SourceExpr="Disciplinary Action" }

    { 1102755028;2;Field  ;
                SourceExpr=From }

    { 1102755030;2;Field  ;
                SourceExpr="To" }

    { 1102755026;2;Field  ;
                SourceExpr="Basic Salary" }

    { 1102755021;2;Field  ;
                SourceExpr="To be cleared by" }

    { 1102755002;2;Field  ;
                SourceExpr="Last Date Modified";
                Editable=false }

  }
  CODE
  {
    VAR
      Text19024457@19020751 : TextConst 'ENU=Months';

    BEGIN
    END.
  }
}

