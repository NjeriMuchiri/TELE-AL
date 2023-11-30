OBJECT page 17444 Teller & Treasury Trans List
{
  OBJECT-PROPERTIES
  {
    Date=10/16/19;
    Time=[ 2:57:16 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516301;
    PageType=List;
    CardPageID=Teller & Treasury Trans Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=No }

    { 2   ;2   ;Field     ;
                CaptionML=ENU=Date Requested;
                SourceExpr="Requested Date";
                Editable=false }

    { 1102755003;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1102755004;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1102755005;2;Field  ;
                SourceExpr="From Account" }

    { 1102755006;2;Field  ;
                SourceExpr="To Account" }

    { 1   ;2   ;Field     ;
                CaptionML=ENU=Amount Requested;
                SourceExpr="Amount to request";
                Editable=false }

    { 1102755007;2;Field  ;
                CaptionML=ENU=Amount to issue;
                SourceExpr=Amount }

    { 1102755008;2;Field  ;
                SourceExpr=Posted }

    { 1102755009;2;Field  ;
                SourceExpr=Description }

    { 1120054000;2;Field  ;
                SourceExpr=Naration }

  }
  CODE
  {

    BEGIN
    END.
  }
}

